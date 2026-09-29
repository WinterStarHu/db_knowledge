# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/04/02/
> 分类: performance/tuning

数据库内核月报
 -->
  

  

  

  

  

  

  

  

  

  
 -->
  
hljs.initHighlightingOnLoad();

  

  

  

  

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-62056244-1', 'auto');
  ga('send', 'pageview');

 -->

  

  

  数据库内核月报
	

  

    
数据库内核月报 － 2023 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB MySQL 联邦查询优化特征（条件下推、按需返回列、LIMIT OFFSET下推）
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · PolarDB Innodb刷脏优化
                      

                    

                    

                  
                      

                        PolarDB MySQL · 功能特性 · Auto Plan Cache
                      

                    

 
        

    

  

    
 MySQL · 引擎特性 · PolarDB Innodb刷脏优化  

    
 Author: 慕星  

  

  

  
PolarDB现有架构采用了物理复制+共享存储的架构方案，在这个架构下，原有的Innodb的刷脏策略需要进一步的调整和优化，才能满足当前PolarDB的需求。原生Innodb的刷脏策略概括为一句话来说，就是batch化积攒更多的修改，减少频繁IO，而PolarDB本身因为RO和RW之间的约束问题，需要更加优雅和顺滑的刷脏以持续推进RW节点上的Flush_lsn，本篇文章总结一下PolarDB在Innodb刷脏之路上的一些列优化和策略调整，以达到在不同的业务场景下平衡释放Free Page和推进Checkpoint lsn的需求。

本文所讨论代码实现均依据Mysql 8.0.13版本。

原生Innodb刷脏:

首先介绍一下Innodb原生的刷脏逻辑，当用户的写入（写入包括插入，更新，删除操作，后续所有写入统指代以上三种操作的总和）请求在执行时，会对在Buffer Pool中的Page进行修改，这些被修改过后的Page被称之为Dirty Page，这些Dirty Page统一管理在Buffer Pool中的Flush list链表上，同时也被挂载到LRU list上，Dirty Page一定在Flush list和LRU List中，但普通Page只在LRU List上。同时有一组Page Cleaner线程会周期性的对Flush list上的Dirty Page进行刷盘，也称之为刷脏操作，完成对数据页的持久化，只有Dirty Page落盘后，才能推进整个BP的Flush lsn，从而推进Checkpoint lsn，以保证在Checkpoint之前的Redo log尽快得到回收。Checkpoint lsn的及时推进能帮助数据库出现意外Crash时，在Recovery阶段减少需要回放的Redo，加快节点的重启速率，减少意外宕机带来的影响。

Page Cleaner线程组：

Page Cleaner线程是Innodb中持久化Page的一组线程，除了Redo以外的数据持久化工作全部由Page Cleaner线程完成，包括用户表，系统表，Undo，DD等所有表的Page。Page Cleaner线程使用了Innodb中经典的一个Coordinator和多个Worker的线程组设计，其中Coordinator负责对任务的切分和调度，Worker负责实际的工作内容，当然在分配完任务后Coordinator也会作为其中的一个Worker完成自己的那部分工作。在Page Cleaner Coordinator中，会判断是否要执行刷脏，以及自适应计算每次刷脏需要刷的Page数量等操作，而Worker线程只需要将自己获取到的BP instance按照所设定的n_pages进行刷盘，默认Woker线程的数量和Buffer Pool Instances数量相当。

在Page Cleaner Coordinator线程默认每间隔1秒触发一次刷脏操作，刷完就会Sleep，除非有其他Checkpoint等操作触发Sync Flush，也就是同步刷脏，Sync Flush会将BP的Flush lsn推进到指定的buf_flush_sync_lsn。

同步刷脏：

除了默认的Coordinator按照固定频率刷脏外，Innodb还存在强制触发刷脏的机制，这些操作统一被称为同步刷脏，即必须要把当前Buffer Pool的flush lsn推进至某一个固定位点。同步刷脏通常会设置一个buf_flush_sync_lsn，当Coordinator线程在运行过程中发现buf_flush_sync_lsn不为0，则会触发同步刷脏（即全量刷脏），把所有Oldest modification lsn小于buf_flush_sync_lsn位点的Dirty Page全部进行刷脏落盘，同步刷脏时，要刷的Page数量是不受innodb_io_capacity限制，同步刷脏会抢占大量的IO资源，同时在每个Page刷脏落盘的IO过程中也会持有该Page的SX锁，这些操作会影响用户的写入请求，可能会出现性能抖动。

自适应刷脏：

Page Cleaner每次刷脏的Page数量是通过一个自适应算法来实现的，代码逻辑主要集中在page_cleaner_flush_pages_recommendation()函数中，这个自适应刷脏算法是按照一个固定频率srv_flushing_avg_loops（默认30秒）来调整的，每次调整的数值主要依赖以下几个条件：

  
Redo平均产生速率及其产生的平均脏页数量

  
平均每秒的刷脏数量

  
IO Capacity参数以及实际脏页率

Redo平均产生速率及其产生的平均脏页数量的计算规则比较简单，即计算每个间隔之间的平均Redo lsn 产生速率，计算出一个Tagert lsn，然后依据Tagert lsn去查找在BP的Flush list上所有oldest_modification_lsn小于Tagert lsn的Page数量，以此来估算出Redo所产生的平均脏页数量。具体的计算规则如下：

/* 通过当前获取到的lsn和上次获取到的lsn，以及时间间隔计算出此间隔内的Redo产生速率 */
lsn_rate = static_cast<lsn_t>(static_cast<double>(cur_lsn - prev_lsn) / time_elapsed);

/* 计算Redo Log产生速度的平均值 */
lsn_avg_rate = (lsn_avg_rate + lsn_rate) / 2;

/* 根据Redo速率估算出一个target lsn，主要用于计算有多少脏页 */
lsn_t target_lsn = oldest_lsn + lsn_avg_rate * buf_flush_lsn_scan_factor;

sum_pages_for_lsn = 通过target_lsn遍历BP 的Flush list，统计出所有oldest_modification_lsn小于Tagert lsn的Page数量

/* 估算出Redo所产生的平均脏页数量 */
ulint pages_for_lsn = std::min<ulint>(sum_pages_for_lsn, srv_max_io_capacity * 2);

平均每秒的刷脏数量主要是为了平衡根据Redo 产生速率计算出脏页量的差值过大的场景，因为Redo的产生速率和业务场景相关，当数据库写入压力比较大时，产生的Redo也就会越多，每秒刷脏量能够起到削峰填谷的作用，避免刷脏引发的IO波动从而影响写入性能。计算如下：

/* 通过sum_pages和时间间隔计算刷脏的平均 Page 数量 */
avg_page_rate = static_cast<ulint>(((static_cast<double>(sum_pages) / time_elapsed) + avg_page_rate) / 2);

IO Capacity参数以及实际脏页率是最后一个限制刷脏量的硬性条件，其中srv_max_io_capacity限制了每次刷脏的最大Page数量，这个参数是可动态修改的，同时会根据实际的脏页率和Redo产生速率来计算是否触发激烈刷脏，具体规则如下：

/* 通过实际脏页率计算所占io_capacity的比例，超过srv_max_buf_pool_modified_pct, 会设置为100%触发激烈刷脏. */
pct_for_dirty = af_get_pct_for_dirty();

/* 通过Redo lsn平均产生速率计算占io_capacity的比例. 超过srv_max_buf_pool_modified_pct, 会设置为100%触发激烈刷脏. */
pct_for_lsn = af_get_pct_for_lsn(age);
  
/* 两者取最大值. */
pct_total = ut_max(pct_for_dirty, pct_for_lsn);

/* 根据pct_total，avg_page_rate，pages_for_lsn 三者计算出一个平均值，即为此次自适应建议调整的刷脏数量 */
n_pages = (PCT_IO(pct_total) + avg_page_rate + pages_for_lsn) / 3;

/* 限定n_pages不能超过srv_max_io_capacity参数所设定的值. */
if (n_pages > srv_max_io_capacity) {
  n_pages = srv_max_io_capacity;
}

总的来说，自适应刷脏在原生的Innodb逻辑中起着比较重要的作用，默认Mysql部署在本地盘，在本地盘容量有限的情况下，对Redo log的空间占用也会有限制，在写入压力比较大时，会产生大量Redo导致Redo log空间吃紧，就需要依赖pages_for_lsn计算出合理的刷脏建议值来尽快调整刷脏量，以及pct_for_lsn来计算出是否要触发激烈刷脏来释放Redo log空间，同时avg_page_rate起到了削峰填谷避免了IO剧烈抖动，srv_max_io_capacity限制了最大刷脏数量来保证写入性能的稳定性，innodb_io_capacity的建议值最好是和数据库运行环境的IOPS绑定，一般不会设置的特别小，以保证每次刷脏能够释放足够的资源。

刷脏的具体流程：

前面部分主要讨论了刷脏线程的调度实现，接下来主要介绍一下具体的刷脏流程。

默认的Page刷脏都是由Page Cleaner Worker线程来触发的，在Worker线程执行时，会先从Buffer Pool Flush状态数组中获取到需要刷脏的Buffer Pool Instance，接下来会先执行LRU List的刷脏，LRU的刷脏包括两部分，从LRU释放Free Page，以及从LRU List上扫描脏页进行刷脏落盘。在执行完LRU刷脏之后，才会执行Flush list的刷脏。除了Worker的刷脏之外，也有一种特殊情况可能会由用户线程触发刷脏操作，当用户线程触发刷脏时，说明数据库本身的脏页率已经到了一个非常高的情况，并且单靠Page Cleaner线程已经无法及时释放Free Page，需要用户线程主动介入进行刷脏。Innodb对上面这三种Dirty Page落盘的情况分别定义为：

/** Flags for flush types */
enum buf_flush_t : uint8_t {
  /** Flush via the LRU list */
  BUF_FLUSH_LRU = 0,

  /** Flush via the flush list of dirty blocks */
  BUF_FLUSH_LIST,

  /** Flush via the LRU list but only a single page */
  BUF_FLUSH_SINGLE_PAGE,

  /** Index of last element + 1  */
  BUF_FLUSH_N_TYPES
};

在数据库系统正常运行过程中，刷脏操作默认都是以BUF_FLUSH_LIST的模式，也就是说Page Cleaner worker线程从Flush List上对脏页进行刷盘，在BUF_FLUSH_LIST刷脏完成后，并不会主动Free 当前的Dirty Page，只是从Flush List上将其移除，想要真正释放这个Page，需要后续的LRU刷脏过程中将其Free掉才可以。

在Worker线程执行时，首先会对LRU List进行刷脏，这一步的最主要目的是为了释放出Free Page，以避免用户的读写请求无法获取到Free Page而被阻塞，影响数据库访问。在LRU List刷脏过程中，会检查当前Free page的数量，当Free Page少于innodb_LRU_scan_depth时，就会触发LRU刷脏，LRU刷脏最多只扫描innodb_LRU_scan_depth个Page，也就是说如果在刷脏过程中Free page的数量已经达到innodb_LRU_scan_depth，此次LRU List的刷脏就可以中止了。刷脏过程中会从LRU List的尾部从后往前扫描，如果满足Free条件，就直接将其Free，如果满足刷脏条件即从LRU List上扫描到的Page是Dirty Page，则会触发刷脏操作，也就是BUF_FLUSH_LRU类型的刷脏。

在对LRU List刷脏完成之后，才会去执行Flush List的刷脏操作，Flush List上的Page全部都是脏页，并且按照Oldest modification lsn从大到小的模式排列，链表末尾的Page的Oldest modification lsn最老，而最后一个Page的Oldest modification lsn也就限制了该BP instance的Flush lsn，所有BP Instances的最小Flush lsn又限制了Innodb的Checkpoint lsn。

在执行刷脏的过程中，都是调用buf_flush_page_and_try_neighbors来执行，从函数名就能看出，在刷脏时不但要把当前的Page进行落盘，同时还要去尝试将同一Space上的相邻Page No的Page一起落盘，这种设计主要是为了能够将随机IO转变为顺序IO，保证在刷脏时能有更好的写入效率。

在Page执行落盘的IO操作期间，是必须要持有该Page的SX锁的，SX锁的特性保证了读请求还能访问这个Page，但写请求就必须要等待这个Page的IO完全结束后才能再执行。

Free Page完全依赖LRU List的刷脏，当用户线程在发起读写请求时，会尝试获取一个Free Page，如果此时数据库读写压力非常大整个BP又非常的满，可能会导致在等待多轮之后还没有拿到Free Page，此时用户线程将会尝试从LRU List上获取一个Page并尝试刷脏（Free 或者落盘），我们称这种类型的刷脏为Single Flush，即BUF_FLUSH_SINGLE_PAGE，如果Innodb种出现大量的Single Flush，则说明当前刷脏已经有瓶颈产生，需要进一步的调优排查。

Page在List中的转移流程：

Innodb默认开启了Native AIO用于更加方便和高效的执行IO请求，Page Cleaner线程在执行真正的刷脏也就是IO请求时，实际上并不会真正触发IO操作，而是构造一个IO请求，并将其丢到AIO队列中，由后台的AIO线程完成真正的IO操作，在将所有的IO请求下发之后，会等待IO结束，然后再由Coordinator调度下一轮的刷脏，注意这里Page Cleaner线程并没有直接将刷脏完成后的Page从Flush list移除，那么Page从Flush Lits，LRU List以及Free List中又是如何转移的呢？

默认在Buffer Pool初始化时，所以的Page都被挂载在Free Page上，每当有读写请求进来时，会从Free List上获取（即从Free List上移除）一个Block并将其加入到LRU List上，后续如果这个Page发生内容变更，就会将这个Page同时也加到Flush List上，即Flush List上的Page全是脏页，并且这些脏页是按照每个Page的OldestModification LSN进行排列的，List尾部的Page的OldestModification LSN最老。

在AIO线程将Page的IO操作执行完成后，会触发一个回调函数，也就是IO_complete，在这个函数中会识别出下发Page的IO请求的类型是什么，如果是BUF_FLUSH_LIST，则需要将这个Page 从Flush List移除，如果是BUF_FLUSH_LRU，除了从Flush List移除外，还需要将其从LRU List上进行淘汰，添加至Free List中。正常的LRU刷脏过程中，如果从LRU List的尾部扫出的Page是非脏的，也会直接将其从LRU List移除并添加到Free List中。

另外，用户线程触发的BUF_FLUSH_SINGLE_PAGE，默认走的是AIO:Sync，也就是同步IO，会直接调用回调函数IO_complete完成将Page从LRU List中摘除并加入到Free List中去的工作。

如果Buffer Pool中的Free Pgae总是能满足在本轮刷脏过程中所有用户请求，则用户线程几乎不会频繁的触发Single Flush，Single Flush回对LRU List加锁，多个用户线程线程并行进行Single Flush时会引发LRU List的Mutex锁争用问题，以及出现IO操作对用户请求的影响也会更大。

小结：

总的来说Innodb的刷脏机制设计的还是较为巧妙的，但也存在一些问题，比如Page Cleaner线程在刷脏时先刷LRU List，后刷Flush lsit，如果此时用户的读写压力压力非常大LRU List每次最多又只能释放innodb_LRU_scan_depth个Free Page，此时就会导致用户线程出现频繁的等待，甚至触发Single Flush，从而导致用户线程执行SQL时间被大大拉长，影响用户访问。另外，在Page真正落盘期间一直持有的SX锁对写入请求也会有影响，这些问题在PolarDB中都有一些相应的优化策略来解决。

PolarDB InnoDB刷脏优化：

PolarDB现有架构采用了物理复制+共享存储的架构方案，RW和RO节点共享同一份数据，因此对Page的Flush提出了更高的要求，在讨论刷脏优化之前，我们先简单回顾一下PolarDB的RW和RO节点间的两大约束（关于约束的更详细请参考这篇文章：
PolarDB · 引擎特性 · 物理复制热点页优化
）：

  

RW侧：RW在刷脏时必须保证Page的最新修改LSN（
Newest_modification_lsn
） <  所有RO节点的最小Apply LSN（
Safe_lsn
）

  

RO侧：RO节点必须在内存中缓存从RW的Flush LSN（受限于Flush List上最老Page的
Oldest_modification_lsn
）到当前Apply LSN的所有Redo

相比于原生Mysql Innodb的刷脏可以积攒更多的修改再批量刷脏落盘，因为Page的落盘是几乎没有什么特殊限制的，只要扫描到满足条件就可以立马进行刷脏落盘，但PolarDB存在约束1的限制，有些Page无法及时被落盘，从而导致RW的Flush lsn不能及时推进。从约束2可见，RW的Flush LSN如果不能够及时的推进，RO节点上在内存缓存的Redo就会越多，如果超出上限，可能会导致RO节点频繁自杀，因此我们需要对RW的Flush LSN进行更加迫切的推进策略 ，而这类问题也是采用共享存储架构的必然存在的问题之一，一定不能让RW 的Flush lsn落后过多。

我们针对Flush LSN尽快推进指定了一些列的策略，具体包括以下内容：

  
支持自适应调整刷脏IO Capacity等相关参数，调配每次刷脏的量更加适应当前的数据库请求

  
LRU List独立刷脏，Page Cleaner线程只负责Flush List的刷脏，同时规避Single Flush

  
Shadown Flush减少刷脏时持有SX锁的时间，提升写入性能

IO Capacity等参数调整：

原生Innodb的IO Capacity默认是和数据库运行环境的IOPS绑定的，并且Innodb本身默认的刷脏策略也更倾向于累积足够的修改后再对脏页进行刷盘，这样能够使得每个脏页上的修改数据积攒的更多以避免频繁的IO操作带来额外的开销。但在PolarDB的架构下，原生的刷脏策略又需要尽可能的多积攒修改，所以无法满足尽快推进Flush lsn需求，因此我们对innodb_io_capacity进行了调整，将默认的单次刷脏的数量调整到了一个相对较为缓和的值，同时这个刷脏量会统一权衡LRU List上的刷脏和Flush List上的刷脏，而不是像原生的逻辑只限制Flush List的每次刷脏的最大量，在业务写入压力大时，可以让LRU List多释放一些Free Page，而当出现Uncheckpoint Redo堆积时，让Flush List下发更多的IO请求，以避免Uncheckpoint Redo持续堆积。其次在大规格实例上，默认触发脏页自适应刷脏的门槛也需要和实际的内存规格进行对齐，而不能所有规格通用一个比例的触发值，我们针对实例规格对innodb_max_dirty_pages_pct进行了调整，内存规格越大，则比值也需要相应的降低，以尽可能早的满足触发自适应刷脏的条件。

LRU Manager Thread线程组：

在原生的Innodb刷脏逻辑中，因为Page Cleaner 线程对LRU List和Flush List刷脏顺序固定且运行周期固定，存在以下问题会影响Free page的释放具体如下：

  
刷脏时要先对LRU List进行刷脏，在完成之后才能刷Flush list，而在Flush list刷脏的时候，LRU list就不会有机会再去刷脏了，要想继续从LRU List释放Free Page，就必须等到下一轮的刷脏才行，同时每轮的刷脏要先刷LRU也会影响Flush List的刷脏效率，导致其无法得到及时刷脏而不能推进Flush LSN。

  
Page Cleaner Coodinator默认1秒调度一次刷脏，也就是说LRU和Flush list的刷脏无法用单独的sleep时间去调整频率，不够灵活。

  
Flush List的刷脏并不能保证每次刷脏时最老的Page一定落盘，如果这个Page有IO访问，就会跳过刷脏刷后面的Page，这虽然提升了Page的访问性能，但会导致Uncheckpoint Redo堆积，结合2可能会出现某一个时刻既没有Free page，同时Uncheckpoint又很大的情况。

基于以上个问题，PolarDB引入了一组新的刷脏线程，LRU Manager Threads，由这组线程专门负责对LRU List进行刷脏，因此Page Cleaner线程也就只用关心Flush List的刷脏，使得LRU List和Flush List的刷脏流程相互独立，互不干涉，提高了各自的刷脏效率。同时，由于LRU List的刷脏变得更加灵活和及时，原有的由用户线程所触发的Single Flush也可以被取消了，用户线程只需要等待LRU Manager Thread释放出Free Page即可，不再需要自己触发刷脏，减少了LRU List的锁争用。而Page Cleaner线程只负责刷Flush List之后，也能更及时的推进Flush LSN，以避免RO因约束缓存过多的Redo导致种种问题。

LRU Manager Thread的数量默认也是和BP Instance绑定，每个线程单独负责一个BP Instance的LRU List，依然是通过检查Free Page是否小于innodb_LRU_scan_depth来选择是否触发LRU刷脏，满足条件则会尝试Free或者Flu shinnodb_LRU_scan_depth个Page，同时将其重新添加到Free List中，以便于后续的读写请求来获取。

Shadow Flush：

之前提到在Page 刷脏时，在整个IO过程中需要持有该Page的SX锁，SX锁只允许读请求访问正在刷脏的Page，不允许写入请求访问，以避免在刷脏过程中又有新的写入请求对该Page发生修改，导致数据出现问题。IO操作又是一个重操作，如果此时数据库写入压力较大，Page Cleaner线程就会和用户线程产生Page的X锁争用，从而导致刷脏被拖慢，且用户的写入请求也会受阻，从而影响用户。

为了解决这个问题，我们将PolarDB的Copy Page策略（详情参见之前的这篇文章
PolarDB · 引擎特性 · 物理复制热点页优化
）进行了一番改造，在刷脏时，如果Copy Page还有多余的空间，我们直接给该Page制作一个Copy，这个Copy实际上就是一个内存的memcpy，在过程中是持有Page的SX锁的，在Copy完成后，就会将Page的SX锁释放并移除出Flush List，然后再将这个Copy的Page进行刷盘，这样就能尽可能短的持有Page的SX锁，我们将这一策略称之为Shadow Flush。Shadow Flush能明显降低在写入压力较大的场景下脏页落盘所带来的性能抖动，使得用户的写入请求更加平滑。

总结：

PolarDB本身采用了物理复制+共享存储的架构，在两大约束下无法再适配原生Innodb的刷脏策略，需要用更激进的刷脏策略来实现Flush LSN的及时推进，所以通过参数调优，LRU Manager Thread方案来提升Page Cleaner的刷脏效率和频率，但随之带来的写入放大和Page SX锁争用问题就需要有Shadow Flush来进行缓解，从而能够实现更优雅更顺滑的刷脏策略，也更加契合PolarDB本身的架构。

参考文章：

  

InnoDB的刷脏机制

  

PolarDB · 引擎特性 · 物理复制热点页优化

  

    

		

 -->
  

  
阿里云PolarDB-数据库内核组
 -->
  
 -->
  
社招/校招 欢迎投递简历 直达招聘信息
 -->
  
 -->
  
直连月报小编
 -->
  
 -->
  
欢迎在github上star AliSQL
 -->
  

  阅读：
 - 

  

本作品采用
知识共享署名-非商业性使用-相同方式共享 3.0 未本地化版本许可协议
进行许可。

  jQuery(document).ready(function($){
    // browser window scroll (in pixels) after which the "back to top" link is shown
    var offset = 300,
      //browser window scroll (in pixels) after which the "back to top" link opacity is reduced
      offset_opacity = 1200,
      //duration of the top scrolling animation (in ms)
      scroll_top_duration = 700,
      //grab the "back to top" link
      $back_to_top = $('.cd-top');

    //hide or show the "back to top" link
    $(window).scroll(function(){
      ( $(this).scrollTop() > offset ) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible cd-fade-out');
      if( $(this).scrollTop() > offset_opacity ) {
        $back_to_top.addClass('cd-fade-out');
      }
    });

    //smooth scroll to top
    $back_to_top.on('click', function(event){
      event.preventDefault();
      $('body,html').animate({
        scrollTop: 0 ,
        }, scroll_top_duration
      );
    });

  });
