# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/06/08/
> 分类: myrocks

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
	

  

    
数据库内核月报 － 2017 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 ·  Tokudb序列化和反序列化过程
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · HTAP视角,数据与计算的生态融合
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 从节点可更新机制
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 数据库崩溃恢复（下）
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · InnoDB crash
                      

                    

                    

                  
                      

                        MSSQL · 实现分析 · SQL Server实现审计日志的方案探索
                      

                    

                    

                  
                      

                        MySQL · 源码分析  · InnoDB Repeatable Read隔离级别之大不同
                      

                    

                    

                  
                      

                        MySQL · myrocks · MyRocks之memtable切换与刷盘
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · 云上的数据迁移
                      

                    

                    

                  
                      

                        MySQL · 社区新闻 · MariaDB 10.2 GA
                      

                    

 
        

    

  

    
 MySQL · myrocks · MyRocks之memtable切换与刷盘  

    
 Author: 张远  

  

  

  
概述

MyRocks的memtable默认是skiplist，其大小和个数分别由参数write_buffer_size和max_write_buffer_number控制。数据写入时先写入active memtable, 当active memtable写满时，active memtable会转化为immutable memtable. immutable memtable数据是不会变化的，最终会刷入level0的sst文件中。

memtable 内存分配

RocksDB有自己的内存分配机制，称为Arena. Arena由固定的inline_block_和动态的blocks_组成。
inline_block_固定为2048bytes, blocks_由一系列的block组成，这些block大小一般为KBlockSize, 但从arena申请较大内存时(> KBlockSize/4)单独分配一个所申请大小的block. KBlockSize由参数arena_block_size指定，arena_block_size 不指定时默认为write_buffer_size的1/8.

这里有两个重要的概念

  

    
blocks_memory_

Arena当前已分配的内存

  

  

    
alloc_bytes_remaining_

Arena当前block已分配但未使用的内存，注意不是整个Arena已分配而未使用的内存

  

RocksDB在实际使用内存中用的是ConcurrentArena， 它是在Arena的基础上封装，是线程安全的。
同时ConcurrentArena为了提高并发对内存进行了分片，分片数由cpu个数决定，例如cpu核数为24， 则分片数为32，以下是分片的算法

// find a power of two >= num_cpus and >= 8
  auto num_cpus = std::thread::hardware_concurrency();
  index_mask_ = 7;
  while (index_mask_ + 1 < num_cpus) {
    index_mask_ = index_mask_ * 2 + 1;
  }

  shards_.reset(new Shard[index_mask_ + 1]);

  
每个分片都有已分配但未使用的内存， 分片越多浪费的内存越多。

一个有趣的例子

测试环境：CPU核数64，write_buffer_size=1G,  arena_block_size=0
根据前面的算法，CPU核数64, 内存分片数为64， arena_block_size 默认为write_buffer_size的1/8，对齐后是131072000

我们用1200个连接进行并发插入，这样能够充分使用内存分片数
这是测试某个瞬间取得的内存数据

allocated_memory:1179650048
AllocatedAndUnused:1172297392
write_buffer_size:1048576000
BlockSize:131072000

注意AllocatedAndUnused和allocated_memory是如此的接近，也就是说存在
巨大的内存浪费
。然而这不是最严重的，更严重的是这种情况导致memtable的切换，后面会进行分析。

memtable 切换

memtable 发生切换的条件有

  
memtable内存超过write_buffer_size会切换

  
WAL日志满，WAL日志超过rocksdb_max_total_wal_size，会从所有的colomn family中找出含有最老日志(the earliest log containing a prepared section)的memtable进行切换，详见HandleWALFull

  
Buffer满，全局的write buffer超过rocksdb_db_write_buffer_size时，会从所有的colomn family中找出最先创建的memtable进行切换，详见HandleWriteBufferFull

  
flush memtable前会切换memtable, 下节会介绍

下面详细介绍memtable满切换

  
memtable 满切换

memtable内存超过write_buffer_size会切换，由于arena的内存使用，memtable控制内存使用的算法更加精细，切换条件从源码中很容易理解

bool MemTable::ShouldFlushNow() const {
  // This constant variable can be interpreted as: if we still have more than
  // "kAllowOverAllocationRatio * kArenaBlockSize" space left, we'd try to over
  // allocate one more block.
  const double kAllowOverAllocationRatio = 0.6;

  // If arena still have room for new block allocation, we can safely say it
  // shouldn't flush.
  auto allocated_memory = table_->ApproximateMemoryUsage() +
                          range_del_table_->ApproximateMemoryUsage() +
                          arena_.MemoryAllocatedBytes();

  // if we can still allocate one more block without exceeding the
  // over-allocation ratio, then we should not flush.
  if (allocated_memory + kArenaBlockSize <
      moptions_.write_buffer_size +
      kArenaBlockSize * kAllowOverAllocationRatio) {
    return false;
  }

  // if user keeps adding entries that exceeds moptions.write_buffer_size,
  // we need to flush earlier even though we still have much available
  // memory left.
  if (allocated_memory > moptions_.write_buffer_size +
      kArenaBlockSize * kAllowOverAllocationRatio) {
    return true;
  }

 return arena_.AllocatedAndUnused() < kArenaBlockSize / 4;
}

而上一节举出的例子正好符合切换的条件，正如前面所说的，内存都分配好了，还没来得及使用就发生切换了，白忙活了一场。

  
这里的现象是虽然write_buffer_size是1G，但最后刷到level0的sst都远远小于1G。

那么如何避免这种情况呢

  
减少内存分片数，不建议

  
调小arena_block_size, 亲测可用

  
这里有一个原则是arena_block_size*内存分片数应该小于write_buffer_size

  
memtable 切换实现

  
NewWritableFile //创建日志文件

  
ConstructNewMemtable //创建memtable

  
cfd->imm()->Add(cfd->mem(), &context->memtables_to_free_); //设置immutable

  
cfd->SetMemtable(new_mem); //设置新的memtable

flush memtable

immutable memtable会不断flush到level0的SST文件中

触发flush的条件有

  
WAL日志满，WAL日志超过rocksdb_max_total_wal_size，会从所有的colomn family中找出含有最老日志(the earliest log containing a prepared section)的column family进行flush，详见HandleWALFull

  
Buffer满，全局的write buffer超过rocksdb_db_write_buffer_size时，会从所有的colomn family中找出最先创建的memtable的column family进行flush，详见HandleWriteBufferFull

  
手动设置参数force_flush_memtable_now/rocksdb_force_flush_memtable_and_lzero_now时

  
CompactRange时

  
创建checkpoint时

  
shutdown时avoid_flush_during_shutdown=0会flush所有memtable

other

rocksdb中设置max_background_flushes=-1可以禁止flush，而MyRocks中rocksdb_max_background_flushes最小值限制为0. 因此，MyRocks若要禁止flush需放开此限制。

  

    

		

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
