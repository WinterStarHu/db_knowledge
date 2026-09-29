

	

		

		
Cover Image

		

	

	

		

			

		

	

  

    

    

    
Test Book

  

  

    
数据库内核月报 － 2015/12> 原文出处：
http://mysql.taobao.org/monthly/

    

      
作者：
阿里云RDS-数据库内核组
 

    

    

      

        

          
数据库内核月报 － 2016/01

        

      

      

        

          
数据库内核月报 － 2015/12

        

      

      

        

          
数据库内核月报 － 2015/11

        

      

      

        

          
数据库内核月报 － 2015/10

        

      

      

        

          
数据库内核月报 － 2015/09

        

      

      

        

          
数据库内核月报 － 2015/08

        

      

      

        

          
数据库内核月报 － 2015/07

        

      

      

        

          
数据库内核月报 － 2015/06

        

      

      

        

          
数据库内核月报 － 2015/05

        

      

      

        

          
数据库内核月报 － 2015/04

        

      

      

        

          
数据库内核月报 － 2015/03

        

      

      

        

          
数据库内核月报 － 2015/02

        

      

      

        

          
数据库内核月报 － 2015/01

        

      

      

        

          
数据库内核月报 － 2014/12

        

      

      

        

          
数据库内核月报 － 2014/11

        

      

      

        

          
数据库内核月报 － 2014/10

        

      

      

        

          
数据库内核月报 － 2014/09

        

      

      

        

          
数据库内核月报 － 2014/08

        

      

    

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    
前言

    
本文的目的是对 InnoDB 的事务锁模块做个简单的介绍，使读者对这块有初步的认识。本文先介绍行级锁和表级锁的相关概念，再介绍其内部的一些实现；最后以两个有趣的案例结束本文。

    
本文所有的代码和示例都是基于当前最新的 MySQL5.7.10 版本。

    
行级锁

    
InnoDB 支持到行级别粒度的并发控制，本小节我们分析下几种常见的行级锁类型，以及在哪些情况下会使用到这些类型的锁。

    
LOCK_REC_NOT_GAP

    
锁带上这个 FLAG 时，表示这个锁对象只是单纯的锁在记录上，不会锁记录之前的 GAP。在 RC 隔离级别下一般加的都是该类型的记录锁（但唯一二级索引上的 duplicate key 检查除外，总是加 
LOCK_ORDINARY
 类型的锁）。

    
LOCK_GAP

    
表示只锁住一段范围，不锁记录本身，通常表示两个索引记录之间，或者索引上的第一条记录之前，或者最后一条记录之后的锁。可以理解为一种区间锁，一般在RR隔离级别下会使用到GAP锁。

    
你可以通过切换到RC隔离级别，或者开启选项
innodb_locks_unsafe_for_binlog
来避免GAP锁。这时候只有在检查外键约束或者duplicate key检查时才会使用到GAP LOCK。

    
LOCK_ORDINARY(Next-Key Lock)

    
也就是所谓的 NEXT-KEY 锁，包含记录本身及记录之前的GAP。当前 MySQL 默认情况下使用RR的隔离级别，而NEXT-KEY LOCK正是为了解决RR隔离级别下的幻读问题。所谓幻读就是一个事务内执行相同的查询，会看到不同的行记录。在RR隔离级别下这是不允许的。

    
假设索引上有记录1, 4, 5, 8，12 我们执行类似语句：SELECT… WHERE col > 10 FOR UPDATE。如果我们不在(8, 12)之间加上Gap锁，另外一个 Session 就可能向其中插入一条记录，例如9，再执行一次相同的SELECT FOR UPDATE，就会看到新插入的记录。

    
这也是为什么插入一条记录时，需要判断下一条记录上是否加锁了。

    
LOCK_S（共享锁）

    
共享锁的作用通常用于在事务中读取一条行记录后，不希望它被别的事务锁修改，但所有的读请求产生的LOCK_S锁是不冲突的。在InnoDB里有如下几种情况会请求S锁。

    

      

        
普通查询在隔离级别为 SERIALIZABLE 会给记录加 LOCK_S 锁。但这也取决于场景：非事务读（auto-commit）在 SERIALIZABLE 隔离级别下，无需加锁(不过在当前最新的5.7.10版本中，SHOW ENGINE INNODB STATUS 的输出中不会打印只读事务的信息，只能从
informationschema.innodb_trx
表中获取到该只读事务持有的锁个数等信息)。

      

      

        
类似 SQL SELECT … IN SHARE MODE，会给记录加S锁，其他线程可以并发查询，但不能修改。基于不同的隔离级别，行为有所不同:

        

          
RC隔离级别： 
LOCK_REC_NOT_GAP | LOCK_S
；

          
RR隔离级别：如果查询条件为唯一索引且是唯一等值查询时，加的是 
LOCK_REC_NOT_GAP | LOCK_S
；对于非唯一条件查询，或者查询会扫描到多条记录时，加的是
LOCK_ORDINARY | LOCK_S
锁，也就是记录本身+记录之前的GAP；

        

      

      

        
通常INSERT操作是不加锁的，但如果在插入或更新记录时，检查到 duplicate key（或者有一个被标记删除的duplicate key），对于普通的INSERT/UPDATE，会加LOCK_S锁，而对于类似REPLACE INTO或者INSERT … ON DUPLICATE这样的SQL加的是X锁。而针对不同的索引类型也有所不同：

        

          
对于聚集索引（参阅函数
row_ins_duplicate_error_in_clust
），隔离级别小于等于RC时，加的是
LOCK_REC_NOT_GAP
类似的S或者X记录锁。否则加
LOCK_ORDINARY
类型的记录锁（NEXT-KEY LOCK）；

          
对于二级唯一索引，若检查到重复键，当前版本总是加 LOCK_ORDINARY 类型的记录锁(函数 
row_ins_scan_sec_index_for_duplicate
)。实际上按照RC的设计理念，不应该加GAP锁（
bug#68021
），官方也事实上尝试修复过一次，即对于RC隔离级别加上
LOCK_REC_NOT_GAP
，但却引入了另外一个问题，导致二级索引的唯一约束失效(
bug#73170
)，感兴趣的可以参阅我写的
这篇博客
，由于这个严重bug，官方很快又把这个fix给revert掉了。

        

      

      

        
外键检查

        
当我们删除一条父表上的记录时，需要去检查是否有引用约束(
row_pd_check_references_constraints
)，这时候会扫描子表(
dict_table_t::referenced_list
)上对应的记录，并加上共享锁。按照实际情况又有所不同。我们举例说明

        
使用RC隔离级别，两张测试表：

        

          
 create table t1 (a int, b int, primary key(a));
 create table t2 (a int, b int, primary key (a), key(b), foreign key(b) references t1(a));
 insert into t1 values (1,2), (2,3), (3,4), (4,5), (5,6), (7,8), (10,11);
 insert into t2 values (1,2), (2,2), (4,4);

        

        
执行SQL：delete from t1 where a = 10;

        

          
在t1表记录10上加 
LOCKREC_NOT_GAP|LOCK_X

          
在t2表的supremum记录（表示最大记录）上加 
LOCK_ORDINARY|LOCK_S
，即锁住(4, ~)区间

        

        
执行SQL：delete from t1 where a = 2;

        

          
在t1表记录(2,3)上加 
LOCK_REC_NOT_GAP|LOCK_X

          
在t2表记录(1,2)上加 
LOCK_REC_NOT_GAP|LOCK_S
锁，这里检查到有引用约束，因此无需继续扫描(2,2)就可以退出检查，判定报错。

        

        
执行SQL：delete from t1 where a = 3;

        

          
在t1表记录(3,4)上加 
LOCK_REC_NOT_GAP|LOCK_X

          
在t2表记录(4,4)上加 
LOCK_GAP|LOCK_S
锁

        

        
另外从代码里还可以看到，如果扫描到的记录被标记删除时，也会加
LOCK_ORDINARY|LOCK_S
 锁。具体参阅函数
row_ins_check_foreign_constraint

      

      
INSERT … SELECT插入数据时，会对SELECT的表上扫描到的数据加LOCK_S锁

    

    
LOCK_X（排他锁）

    
排他锁的目的主要是避免对同一条记录的并发修改。通常对于UPDATE或者DELETE操作，或者类似SELECT … FOR UPDATE操作，都会对记录加排他锁。

    
我们以如下表为例：

    

      
create table t1 (a int, b int, c int, primary key(a), key(b));
insert into t1 values (1,2,3), (2,3,4),(3,4,5), (4,5,6),(5,6,7);

    

    
执行SQL（通过二级索引查询）：update t1 set c = c +1 where b = 3;

    

      
RC隔离级别：1. 锁住二级索引记录，为NOT GAP X锁；2.锁住对应的聚集索引记录，也是NOT GAP X锁。

      
RR隔离级别下：1.锁住二级索引记录，为
LOCK_ORDINARY|LOCK_X
锁；2.锁住聚集索引记录，为NOT GAP X锁

    

    
执行SQL（通过聚集索引检索，更新二级索引数据）：update t1 set b = b +1 where a = 2;

    

      
对聚集索引记录加 
LOCK_REC_NOT_GAP | LOCK_X
锁;

      
在标记删除二级索引时，检查二级索引记录上的锁（
lock_sec_rec_modify_check_and_lock
），如果存在和
LOCK_X | LOCK_REC_NOT_GAP
冲突的锁对象，则创建锁对象并返回等待错误码；否则无需创建锁对象；

      
当到达这里时，我们已经持有了聚集索引上的排他锁，因此能保证别的线程不会来修改这条记录。（修改记录总是先聚集索引，再二级索引的顺序），即使不对二级索引加锁也没有关系。但如果已经有别的线程已经持有了二级索引上的记录锁，则需要等待。

      
在标记删除后，需要插入更新后的二级索引记录时，依然要遵循插入意向锁的加锁原则。

    

    
我们考虑上述两种 SQL 的混合场景，一个是先锁住二级索引记录，再锁聚集索引；另一个是先锁聚集索引，再检查二级索引冲突，因此在这类并发更新场景下，可能会发生死锁。

    
不同场景，不同隔离级别下的加锁行为都有所不同，例如在RC隔离级别下，不符合WHERE条件的扫描到的记录，会被立刻释放掉，但RR级别则会持续到事务结束。你可以通过GDB，断点函数
lock_rec_lock
来查看某条SQL如何执行加锁操作。

    
LOCK_INSERT_INTENTION(插入意向锁)

    
INSERT INTENTION锁是GAP锁的一种，如果有多个session插入同一个GAP时，他们无需互相等待，例如当前索引上有记录4和8，两个并发session同时插入记录6，7。他们会分别为(4,8)加上GAP锁，但相互之间并不冲突（因为插入的记录不冲突）。

    
当向某个数据页中插入一条记录时，总是会调用函数
lock_rec_insert_check_and_lock
进行锁检查（构建索引时的数据插入除外），会去检查当前插入位置的下一条记录上是否存在锁对象，这里的下一条记录不是指的物理连续，而是按照逻辑顺序的下一条记录。

如果下一条记录上不存在锁对象：若记录是二级索引上的，先更新二级索引页上的最大事务ID为当前事务的ID；直接返回成功。

    
如果下一条记录上存在锁对象，就需要判断该锁对象是否锁住了GAP。如果GAP被锁住了，并判定和插入意向GAP锁冲突，当前操作就需要等待，加的锁类型为
LOCK_X | LOCK_GAP | LOCK_INSERT_INTENTION
，并进入等待状态。但是插入意向锁之间并不互斥。这意味着在同一个GAP里可能有多个申请插入意向锁的会话。

    
锁表更新

    
我们知道GAP锁是在一个记录上描述的，表示记录及其之前的记录之间的GAP。但如果记录之前发生了插入或者删除操作，之前描述的GAP就会发生变化，InnoDB需要对锁表进行更新。

    
对于数据插入，假设我们当前在记录[3,9]之间有会话持有锁(不管是否和插入意向锁冲突)，现在插入一条新的记录5，需要调用函数
lock_update_insert
。这里会遍历所有在记录9上的记录锁，如果这些锁不是插入意向锁并且是LOCK_GAP或者NEXT-KEY LOCK（没有设置
LOCK_REC_NOT_GAP
标记)(
lock_rec_inherit_to_gap_if_gap_lock
)，就会为这些会话的事务增加一个新的锁对象，锁的类型为
LOCK_REC | LOCK_GAP
，锁住的GAP范围在本例中为(3,5)。所有符合条件的会话都继承了这个新的GAP，避免之前的GAP锁失效。

    
对于数据删除操作，调用函数
lock_update_delete
，这里会遍历在被删除记录上的记录锁，当符合如下条件时，需要为这些锁对应的事务增加一个新的GAP锁，锁的Heap No为被删除记录的下一条记录：

    

      
lock_rec_inherit_to_gap
        for (lock = lock_rec_get_first(lock_sys->rec_hash, block, heap_no);
             lock != NULL;
             lock = lock_rec_get_next(heap_no, lock)) {

                if (!lock_rec_get_insert_intention(lock)
                    && !((srv_locks_unsafe_for_binlog
                          || lock->trx->isolation_level
                          <= TRX_ISO_READ_COMMITTED)
                         && lock_get_mode(lock) ==
                         (lock->trx->duplicates ? LOCK_S : LOCK_X))) {
                        lock_rec_add_to_queue(
                                LOCK_REC | LOCK_GAP | lock_get_mode(lock),
                                heir_block, heir_heap_no, lock->index,
                                lock->trx, FALSE);
                }
        }

    

    
从上述判断可以看出，即使在RC隔离级别下，也有可能继承LOCK GAP锁，这也是当前版本InnoDB唯一的意外：判断Duplicate key时目前容忍GAP锁。上面这段代码实际上在最近的版本中才做过更新，更早之前的版本可能存在二级索引损坏，感兴趣的可以阅读我的
这篇博客

    
完成GAP锁继承后，会将所有等待该记录的锁对象全部唤醒(
lock_rec_reset_and_release_wait
)。

    
LOCK_PREDICATE

    
从 MySQL5.7 开始MySQL整合了
boost.geometry
库以更好的支持空间数据类型，并支持在在Spatial数据类型的列上构建索引，在InnoDB内，这个索引和普通的索引有所不同，基于R-TREE的结构，目前支持对2D数据的描述，暂不支持3D.

    
R-TREE和BTREE不同，它能够描述多维空间，而多维数据并没有明确的数据顺序，因此无法在RR隔离级别下构建NEXT-KEY锁以避免幻读，因此InnoDB使用称为Predicate Lock的锁模式来加锁，会锁住一块查询用到的被称为MBR(minimum boundingrectangle/box)的数据区域。 因此这个锁不是锁到某个具体的记录之上的，可以理解为一种Page级别的锁。

    
Predicate Lock和普通的记录锁或者表锁（如上所述）存储在不同的lock hash中，其相互之间不会产生冲突。

    
Predicate Lock相关代码见
lock/lock0prdt.cc
文件

    
关于Predicate Lock的设计参阅官方
WL#6609
。

    
由于这块的代码量比较庞大，目前小编对InnoDB的spatial实现了解有限，本文暂不对此展开，将在后面单独专门介绍spatial index时，再细细阐述这块内容。

    
隐式锁

    
InnoDB 通常对插入操作无需加锁，而是通过一种“隐式锁”的方式来解决冲突。聚集索引记录中存储了事务id，如果另外有个session查询到了这条记录，会去判断该记录对应的事务id是否属于一个活跃的事务，并协助这个事务创建一个记录锁，然后将自己置于等待队列中。该设计的思路是基于大多数情况下新插入的记录不会立刻被别的线程并发修改，而创建锁的开销是比较昂贵的，涉及到全局资源的竞争。

    
关于隐式锁转换，上一期的月报
InnoDB 事务子系统介绍
我们已经介绍过了，这里不再赘述。

    
锁的冲突判定

    
锁模式的兼容性矩阵通过如下数组进行快速判定：

    

      
static const byte lock_compatibility_matrix[5][5] = {
/** IS IX S X AI /
/ IS / { TRUE, TRUE, TRUE, FALSE, TRUE},
/ IX / { TRUE, TRUE, FALSE, FALSE, TRUE},
/ S / { TRUE, FALSE, TRUE, FALSE, FALSE},
/ X / { FALSE, FALSE, FALSE, FALSE, FALSE},
/ AI / { TRUE, TRUE, FALSE, FALSE, FALSE}
};

    

    
对于记录锁而言，锁模式只有LOCK_S 和LOCK_X，其他的 FLAG 用于锁的描述，如前述 LOCK_GAP、LOCK_REC_NOT_GAP 以及 LOCK_ORDINARY、LOCK_INSERT_INTENTION 四种描述。在比较两个锁是否冲突时，即使不满足兼容性矩阵，在如下几种情况下，依然认为是相容的，无需等待（参考函数
lock_rec_has_to_wait
）

    

      
对于GAP类型（锁对象建立在supremum上或者申请的锁类型为LOCK_GAP）且申请的不是插入意向锁时，无需等待任何锁，这是因为不同Session对于相同GAP可能申请不同类型的锁，而GAP锁本身设计为不互相冲突；

      
LOCK_ORDINARY 或者LOCK_REC_NOT_GAP类型的锁对象，无需等待LOCK_GAP类型的锁；

      
LOCK_GAP类型的锁无需等待LOCK_REC_NOT_GAP类型的锁对象；

      
任何锁请求都无需等待插入意向锁。

    

    
表级锁

    
InnoDB的表级别锁包含五种锁模式：LOCK_IS、LOCK_IX、LOCK_X、LOCK_S以及LOCK_AUTO_INC锁，锁之间的相容性遵循数组
lock_compatibility_matrix
中的定义。

    
InnoDB表级锁的目的是为了防止DDL和DML的并发问题。但从5.5版本开始引入MDL锁后，InnoDB层的表级锁的意义就没那么大了，MDL锁本身已经覆盖了其大部分功能。以下我们介绍下几种InnoDB表锁类型。

    
LOCK_IS/LOCK_IX

    
也就是所谓的意向锁，这实际上可以理解为一种“暗示”未来需要什么样行级锁，IS表示未来可能需要在这个表的某些记录上加共享锁，IX表示未来可能需要在这个表的某些记录上加排他锁。意向锁是表级别的，IS和IX锁之间相互并不冲突，但与表级S/X锁冲突。

    
在对记录加S锁或者X锁时，必须保证其在相同的表上有对应的意向锁或者锁强度更高的表级锁。

    
LOCK_X

    
当加了LOCK_X表级锁时，所有其他的表级锁请求都需要等待。通常有这么几种情况需要加X锁：

    

      
DDL操作的最后一个阶段(
ha_innobase::commit_inlace_alter_table
)对表上加LOCK_X锁，以确保没有别的事务持有表级锁。通常情况下Server层MDL锁已经能保证这一点了，在DDL的commit 阶段是加了排他的MDL锁的。但诸如外键检查或者刚从崩溃恢复的事务正在进行某些操作，这些操作都是直接InnoDB自治的，不走server层，也就无法通过MDL所保护；

      
当设置会话的autocommit变量为OFF时，执行
LOCK TABLE tbname WRITE
这样的操作会加表级的LOCK_X锁(
ha_innobase::external_lock
)；

      
对某个表空间执行discard或者import操作时，需要加LOCK_X锁(
ha_innobase::discard_or_import_tablespace
)。

    

    
LOCK_S

    

      

        
在DDL的第一个阶段，如果当前DDL不能通过ONLINE的方式执行，则对表加LOCK_S锁(
prepare_inplace_alter_table_dict
)；

      

      
设置会话的autocommit为OFF，执行LOCK TABLE tbname READ时，会加LOCK_S锁(
ha_innobase::external_lock
)。

    

    
从上面的描述我们可以看到LOCK_X及LOCK_S锁在实际的大部分负载中都很少会遇到。主要还是互相不冲突的LOCK_IS及LOCK_IX锁。一个有趣的问题是，每次加表锁时，却总是要扫描表上所有的表级锁对象，检查是否有冲突的锁。很显然，如果我们在同一张表上的更新并发度很高，这个链表就会非常长。

    
基于大多数表锁不冲突的事实，我们在RDS MYSQL中对各种表锁对象进行计数，在检查是否有冲突时，例如当前申请的是意向锁，如果此时LOCK_S和LOCK_X的锁计数都是0，就可以认为没有冲突，直接忽略检查。由于检查是在持有全局大锁
lock_sys->mutex
下进行的。在单表大并发下，这个优化的效果还是非常明显的，可以减少持有全局大锁的时间。

    
LOCK_AUTO_INC

    
AUTO_INC锁加在表级别，和AUTO_INC、表级S锁以及X锁不相容。锁的范围为SQL级别，SQL结束后即释放。AUTO_INC的加锁逻辑和InnoDB的锁模式相关，这里在简单介绍一下。

    
通常对于自增列，我们既可以显式指定该值，也可以直接用NULL，系统将自动递增并填充该列。我们还可以在批量插入时混合使用者两种方式。不同的分配方式，其具体行为受到参数
innodb_autoinc_lock_mode
的影响。但在基于STATEMENT模式复制时，可能会影响到复制的数据一致性，
官方文档
 有详细描述，不再赘述，只说明下锁的影响。

    
自增锁模式通过参数
innodb_autoinc_lock_mode
来控制，加锁选择参阅函数
ha_innobase::innobase_lock_autoinc

    
具体的，有以下几个值：

    

AUTOINC_OLD_STYLE_LOCKING
（0）

    
也就是所谓的传统加锁模式（在5.1版本引入这个参数之前的策略），在该策略下，会在分配前加上AUTO_INC锁，并在SQL结束时释放掉。该模式保证了在STATEMENT复制模式下，备库执行类似INSERT … SELECT这样的语句时的一致性，因为这样的语句在执行时无法确定到底有多少条记录，只有在执行过程中不允许别的会话分配自增值，才能确保主备一致。

    
很显然这种锁模式非常影响并发插入的性能，但却保证了一条SQL内自增值分配的连续性。

    

AUTOINC_NEW_STYLE_LOCKING
（1）

    
这是InnoDB的默认值。在该锁模式下

    

      

        
普通的 INSERT 或 REPLACE 操作会先加一个
dict_table_t::autoinc_mutex
，然后去判断表上是否有别的线程加了LOCK_AUTO_INC锁，如果有的话，释放autoinc_mutex，并使用OLD STYLE的锁模式。否则，在预留本次插入需要的自增值之后，就快速的将autoinc_mutex释放掉。很显然，对于普通的并发INSERT操作，都是无需加LOCK_AUTO_INC锁的。因此大大提升了吞吐量；

      

      
但是对于一些批量插入操作，例如LOAD DATA，INSERT …SELECT 等还是使用OLD STYLE的锁模式，SQL执行期间加LOCK_AUTO_INC锁。

    

    
和传统模式相比，这种锁模式也能保证STATEMENT模式下的复制安全性，但却无法保证一条插入语句内的自增值的连续性，并且在执行一条混合了显式指定自增值和使用系统分配两种方式的插入语句时，可能存在一定的自增值浪费。

    
例如执行SQL：

    

      
INSERT INTO t1 (c1,c2) VALUES (1,'a'), (NULL,'b'), (5,'c'), (NULL,’d’）

    

    
假设当前AUTO_INCREMENT值为101，在传统模式下执行完后，下一个自增值为103，而在新模式下，下一个可用的自增值为105，因为在开始执行SQL时，会先预取了[101, 104] 4个自增值，这和插入行的个数相匹配，然后将AUTO_INCREMENT设为105，导致自增值103和104被浪费掉。

    

AUTOINC_NO_LOCKING
（2）

    
这种模式下只在分配时加个mutex即可，很快就释放，不会像NEW STYLE那样在某些场景下会退化到传统模式。因此设为2不能保证批量插入的复制安全性。

    
关于自增锁的小BUG

    
这是Mariadb的Jira上报的一个小bug，在row模式下，由于不走parse的逻辑，我们不知道行记录是通过什么批量导入还是普通INSERT产生的，因此command类型为SQLCOM_END，而在判断是否加自增锁时的逻辑时，是通过COMMAND类型是否为SQLCOM_INSERT或者SQLCOM_REPLACE来判断是否忽略加AUTO_INC锁。这个额外的锁开销，会导致在使用ROW模式时，InnoDB总是加AUTO_INC锁，加AUTO_INC锁又涉及到全局事务资源的开销，从而导致性能下降。

    
修复的方式也比较简单，将SQLCOM_END这个command类型也纳入考虑。

    
具体参阅
Jira链接
。

    
事务锁管理

    
InnoDB 所有的事务锁对象都是挂在全局对象lock_sys上，同时每个事务对象上也维持了其拥有的事务锁，每个表对象(
dict_table_t
)上维持了构建在其上的表级锁对象。

    
如下图所示：

    

      

    

    
innodb 锁

    
加表级锁

    

      
首先从当前事务的
trx_lock_t::table_locks
中查找是否已经加了等同或更高级别的表锁，如果已经加锁了，则直接返回成功（
lock_table_has
）；

      
检查当前是否有和正在申请的锁模式冲突的表级锁对象（
lock_table_other_has_incompatible
）；

直接遍历链表
dict_table_t::locks
链表

      
如果存在冲突的锁对象，则需要进入等待队列（
lock_table_enqueue_waiting
）

创建等待锁对象 （
lock_table_create
）

检查是否存在死锁（
DeadlockChecker::check_and_resolve
），当存在死锁时：如果当前会话被选作牺牲者，就移除锁请求(
lock_table_remove_low
)，重置当前事务的wait_lock为空，并返回错误码DB_DEADLOCK；若被选成胜利者，则锁等待解除，可以认为当前会话已经获得了锁，返回成功；

若没有发生死锁，设置事务对象的相关变量后，返回错误码DB_LOCK_WAIT，随后进入锁等待状态

      
如果不存在冲突的锁，则直接创建锁对象（
lock_table_create
），加入队列。

    

    

lock_table_create
: 创建锁对象

    

      
当前请求的是AUTO-INC锁时；

递增
dict_table_t::n_waiting_or_granted_auto_inc_locks
。前面我们已经提到过，当这个值非0时，对于自增列的插入操作就会退化到OLD-STYLE;

锁对象直接引用已经预先创建好的
dict_table_t::autoinc_lock
，并加入到
trx_t::autoinc_locks
集合中;

      
对于非AUTO-INC锁，则从一个pool中分配锁对象

在事务对象
trx_t::lock
中，维持了两个pool，一个是
trx_lock_t::rec_pool
，预分配了一组锁对象用于记录锁分配，另外一个是
trx_lock_t::table_pool
，用于表级锁的锁对象分配。通过预分配内存的方式，可以避免在持有全局大锁时(
lock_sys->mutex
)进行昂贵的内存分配操作。rec_pool和table_pool预分配的大小都为8个锁对象。（
lock_trx_alloc_locks
）;

如果table_pool已经用满，则走内存分配，创建一个锁对象；

      
构建好的锁对象分别加入到事务的
trx_t::lock.trx_locks
链表上以及表对象的
dict_table_t::locks
链表上；

      
构建好的锁对象加入到当前事务的
trx_t::lock.table_locks
集合中。

    

    
可以看到锁对象会加入到不同的集合或者链表中，通过挂载到事务对象上，可以快速检查当前事务是否已经持有表锁；通过挂到表对象的锁链表上，可以用于检查该表上的全局冲突情况。

    
加行级锁

    
行级锁加锁的入口函数为
lock_rec_lock
，其中第一个参数impl如果为TRUE，则当当前记录上已有的锁和
LOCK_X | LOCK_REC_NOT_GAP
不冲突时，就无需创建锁对象。（见上文关于记录锁LOCK_X相关描述部分），为了描述清晰，下文的流程描述，默认impl为FALSE。

    

lock_rec_lock
：

    

      
首先尝试fast lock的方式，对于冲突少的场景，这是比较普通的加锁方式(
lock_rec_lock_fast
), 符合如下情况时，可以走fast lock:

记录所在的page上没有任何记录锁时，直接创建锁对象，加入rec_hash，并返回成功;

记录所在的page上只存在一个记录锁，并且属于当前事务，且这个记录锁预分配的bitmap能够描述当前的heap no（预分配的bit数为创建锁对象时的page上记录数 + 64，参阅函数
RecLock::lock_size
），则直接设置对应的bit位并返回;

      
无法走fast lock时，再调用slow lock的逻辑(
lock_rec_lock_slow
)

判断当前事务是否已经持有了一个优先级更高的锁，如果是的话，直接返回成功（
lock_rec_has_expl
）;

检查是否存在和当前申请锁模式冲突的锁（
lock_rec_other_has_conflicting
），如果存在的话，就创建一个锁对象（
RecLock::RecLock
），并加入到等待队列中（
RecLock::add_to_waitq
），这里会进行死锁检测;

如果没有冲突的锁，则入队列（
lock_rec_add_to_queue
）：已经有在同一个Page上的锁对象且没有别的会话等待相同的heap no时，可以直接设置对应的bitmap（
lock_rec_find_similar_on_page
）；否则需要创建一个新的锁对象;

      
返回错误码，对于DB_LOCK_WAIT, DB_DEADLOCK等错误码，会在上层进行处理。

    

    
等待及死锁判断

    
当发现有冲突的锁时，调用函数
RecLock::add_to_waitq
进行判断

    

      
如果持有冲突锁的线程是内部的后台线程（例如后台dict_state线程），这个线程不会被一个高优先级的事务取消掉，因为总是优先保证内部线程正常执行；

      
比较当前会话和持有锁的会话的事务优先级，调用函数trx_arbitrate 返回被选作牺牲者的事务；

当前发起请求的会话是后台线程，但持有锁的会话设置了高优先级时，选择当前线程作为牺牲者；

持有锁的线程为后台线程时，在第一步已经判断了，不会选作牺牲者；

如果两个会话都设置了优先级，低优先级的被选做牺牲者，优先级相同时，请求者被选做牺牲者(
thd_tx_arbitrate
)；

PS: 目前最新版本的5.7还不支持用户端设置线程优先级（但增加一个配置session变量的接口非常容易)；

      
如果当前会话的优先级较低，或者另外一个持有锁的会话为后台线程，这时候若当前会话设置了优先级，直接报错，并返回错误码DB_DEADLOCK；

默认不设置优先级时，请求锁的会话也会被选作victim_trx，但只创建锁等待对象，不会直接返回错误；

      
当持有锁的会话被选作牺牲者时，说明当前会话肯定设置了高优先级，这时候会走
RecLock::enqueue_priority
的逻辑；

如果持有锁的会话在等待另外一个不同的锁时，或者持有锁的事务不是readonly的，当前会话会被回滚掉；

开始跳队列，直到当前会话满足加锁条件（
RecLock::jump_queue
）；

请求的锁对象跳过阻塞它的锁对象，直接操作hash链表，将锁对象往前挪；

从当前lock，向前遍历链表，逐个判断是否有别的会话持有了相同记录上的锁（
RecLock::is_on_row
），并将这些会话标记为回滚（
mark_trx_for_rollback
）,同时将这些事务对象搜集下来，以待后续处理（但直接阻塞当前会话的事务会被立刻回滚掉）；

高优先级的会话非常具有杀伤力，其他低优先级会话即使拿到了锁，也会被它所干掉。

    

    
不过实际场景中，我们并没有多少机会去设置事务的优先级，这里先抛开这个话题，只考虑默认的场景，即所有的事务优先级都未设置。

    
在创建了一个处于WAIT状态的锁对象后，我们需要进行死锁检测（
RecLock::deadlock_check
），死锁检测采用深度优先遍历的方式，通过事务对象上的
trx_t::lock.wait_lock
构造事务的wait-for graph进行判断，当最终发现一个锁请求等待闭环时，可以判定发生了死锁。另外一种情况是，如果检测深度过长（即锁等待的会话形成的检测链路非常长），也会认为发生死锁，最大深度默认为
LOCK_MAX_DEPTH_IN_DEADLOCK_CHECK
，值为200。

    
当发生死锁时，需要选择一个牺牲者（
DeadlockChecker::select_victim()
）来解决死锁，通常事务权重低的回滚（
trx_weight_ge
）。

    

      
修改了非事务表的会话具有更高的权重；

      
如果两个表都修改了、或者都没有修改事务表，那么就根据的事务的undo数量加上持有的事务锁个数来决定权值（TRX_WEIGHT）；

      
低权重的事务被回滚，高权重的获得锁对象。

    

    
Tips：对于一个经过精心设计的应用，我们可以从业务上避免死锁，而死锁检测本身是通过持有全局大锁来进行的，代价非常高昂，在阿里内部的应用中，由于有专业的团队来保证业务SQL的质量，我们可以选择性的禁止掉死锁检测来提升性能，尤其是在热点更新场景，带来的性能提升非常明显，极端高并发下，甚至能带来数倍的提升。

    
当无法立刻获得锁时，会将错误码传到上层进行处理（
row_mysql_handle_errors
）

    

      

DB_LOCK_WAIT
：

具有高优先级的事务已经搜集了会阻塞它的事务链表，这时候会统一将这些事务回滚掉（
trx_kill_blocking
）；

将当前的线程挂起（
lock_wait_suspend_thread
），等待超时时间取决于session级别配置（
innodb_lock_wait_timeout
），默认为50秒；

如果当前会话的状态设置为running，一种是被选做死锁检测的牺牲者，需要回滚当前事务，另外一种是在进入等待前已经获得了事务锁，也无需等待；

获得等待队列的一个空闲slot。（
lock_wait_table_reserve_slot
）

系统启动时，已经创建好了足够用的slot数组，类型为
srv_slot_t
，挂在
lock_sys->waiting_threads
上；

分配slot时，从slot数组的第一个元素开始遍历，直到找到一个空闲的slot。注意这里存在的一个性能问题是，如果挂起的线程非常多，每个新加入挂起等待的线程都需要遍历直到找到一个空闲的slot。 实际上如果每次遍历都从上次分配的位置往后找，到达数组末尾在循环到数组头，这样可以在高并发高锁冲突场景下获得一定的性能提升；

如果会话在innodb层（通常为true），则强制从InnoDB层退出，确保其不占用
innodb_thread_concurrency
的槽位。然后进入等待状态。被唤醒后，会再次强制进入InnoDB层；

被唤醒后，释放slot（
lock_wait_table_release_slot
）；

若被选作死锁的牺牲者了，返回上层回滚事务；若等待超时了，则根据参数
innodb_rollback_on_timeout
的配置，默认为OFF只回滚当前SQL，设置为ON表示回滚整个事务。

      

DB_DEADLOCK
: 直接回滚当前事务

    

    
释放锁及唤醒

    
大多数情况下事务锁都是在事务提交时释放，但有两种意外：

    

      
AUTO-INC锁在SQL结束时直接释放（
innobase_commit --> lock_unlock_table_autoinc
）；

      
在RC隔离级别下执行DML语句时，从引擎层返回到Server层的记录，如果不满足where条件，则需要立刻unlock掉（
ha_innobase::unlock_row
）。

    

    
除这两种情况外，其他的事务锁都是在事务提交时释放的(
lock_trx_release_locks --> lock_release
)。事务持有的所有锁都维护在链表
trx_t::lock.trx_locks
上，依次遍历释放即可。

    
对于行锁，从全局hash中删除后，还需要判断别的正在等待的会话是否可以被唤醒（
lock_rec_dequeue_from_page
）。例如如果当前释放的是某个记录的X锁，那么所有的S锁请求的会话都可以被唤醒。

    
这里的移除锁和检查的逻辑开销比较大，尤其是大量线程在等待少量几个锁时。当某个锁从hash链上移除时，InnoDB实际上通过遍历相同page上的所有等待的锁，并判断这些锁等待是否可以被唤醒。而判断唤醒的逻辑又一次遍历，这是因为当前的链表维护是基于的，并不是基于Heap no构建的。关于这个问题的讨论，可以参阅
bug#53825
。官方开发Sunny也提到虽然使用来构建链表，移除Bitmap会浪费更多的内存，但效率更高，而且现在的内存也没有以前那么昂贵。

    
对于表锁，如果表级锁的类型不为LOCK_IS，且当前事务修改了数据，就将表对象的
dict_table_t::query_cache_inv_id
设置为当前最大的事务id。在检查是否可以使用该表的Query Cache时会使用该值进行判断（
row_search_check_if_query_cache_permitted
），如果某个用户会话的事务对象的low_limit_id（即最大可见事务id）比这个值还小，说明它不应该使用当前table cache的内容，也不应该存储到query cache中。

    
表级锁对象的释放调用函数
lock_table_dequeue
。

    
注意在释放锁时，如果该事务持有的锁对象太多，每释放1000（
LOCK_RELEASE_INTERVAL
）个锁对象，会暂时释放下
lock_sys->mutex
再重新持有，防止InnoDB hang住。

    
两个有趣的案例

    
本小节我们来分析几个比较有趣的死锁案例。

    
普通的并发插入导致的死锁

    
create table t1 (a int primary key);

开启三个会话执行： insert into t1(a) values (2);

    

      

        

          
session 1

          
session 2

          
session 3

        

      

      

        

          
BEGIN; INSERT..

          
 

          
 

        

        

          
 

          
INSERT (block),为session1创建X锁，并等待S锁

          
 

        

        

          
 

          
 

          
INSERT (block， 同上等待S锁)

        

        

          
ROLLBACK，释放锁

          
 

          
 

        

        

          
 

          
获得S锁

          
获得S锁

        

        

          
 

          
申请插入意向X锁，等待session3

          
 

        

        

          
 

          
 

          
申请插入意向X锁，等待session2

        

      

    

    
上述描述了互相等待的场景，因为插入意向X锁和S锁是不相容的。这也是一种典型的锁升级导致的死锁。如果session1执行COMMIT的话，则另外两个线程都会因为duplicate key失败。

    
这里需要解释下为何要申请插入意向锁，因为ROLLBACK时原记录回滚时是被标记删除的。而我们尝试插入的记录和这个标记删除的记录是相邻的(键值相同)，根据插入意向锁的规则，插入位置的下一条记录上如果存在与插入意向X锁冲突的锁时，则需要获取插入意向X锁。

    
另外一种类似（但产生死锁的原因不同）的场景是在一张同时存在聚集索引和唯一索引的表上，通过replace into的方式插入冲突的唯一键，可能会产生死锁，在3月份的月报，我已经专门描述过这个问题，感兴趣的可以
延伸阅读下
。

    
又一个并发插入的死锁现象

    
两个会话参与。在RR隔离级别下

    
例表如下：

    

      
create table t1 (a int primary key ,b int);
insert into t1 values (1,2),(2,3),(3,4),(11,22);

    

    

      

        

          
session 1

          
session 2

        

      

      

        

          
begin;select * from t1 where a = 5 for update;(获取记录(11,22)上的GAP X锁)

          
 

        

        

          
 

          
begin;select * from t1 where a = 5 for update; (同上,GAP锁之间不冲突

        

        

          
insert into t1 values (4,5); (block，等待session1)

          
 

        

        

          
 

          
insert into t1 values (4,5);（需要等待session2，死锁）

        

      

    

    
引起这个死锁的原因是非插入意向的GAP X锁和插入意向X锁之间是冲突的。

  

  

    

    

    
Test Book

  

  

    
PostgreSQL 主备同步机制是通过流复制实现，其原理见之前的月报
PG主备流复制机制
。

    
Greenplum 是基于PostgreSQL开发的，它的主备也是通过流复制实现，但是Segment节点中的Primary和Mirror之间的数据同步是基于文件级别的同步实现的。为什么Primary和Mirror不能再使用流复制实现呢？主要有两个原因:

    

      
Append Only表不写WAL日志，所以Append Only表的数据就不能通过XLOG发送到Mirror再Apply；

      
pg_control等文件也是不写WAL日志，也只能通过文件方式同步到Mirror。

    

    
GP总体结构

    
Greenplum 的架构采用了MPP 无共享体系。在 MPP 系统中，每个数据节点有自己的CPU、磁盘和内存(Share nothing)，每个节点内的 CPU 不能访问另一个节点的内存。节点之间的信息交互是通过节点互联网络实现的，这个过程一般称为数据重分配(Data Redistribution)。GP master负责协调整个集群 ，一个数据节点可以配置多个节点实例(Segment Instances)，节点实例并行处理查询(SQL)。

    

      

    

    
Primary和Mirror同步机制

    
Primary和Mirror同步的内容主要有两部分，即文件和数据。之所以Primary和Mirror要同步文件，是Primary和Mirror之间可以自动failover，只有两者保持同步才能相互替代，如果只把数据同步过去，pg_control、pg_clog、pg_subtrans 没有同步，那么从Primary切换到Mirror会出现问题。GP master和GP slave却不用担心这些问题，Append Only 表的数据只会存在 Segment，所以WAL日志足够保持GP master和GP slave同步(只要是流复制，pg_control、pg_clog、pg_subtrans 这些文件Slave会自动更新，无需从Master同步)。

    
数据同步

    
当GP master向Primary下发执行计划后，Primary开始执行，如果是DML操作，那么Primary会产生XLOG及更新page。会在
SlruPhysicalWritePage
函数中(写数据页)产生FileRepOperationOpen、FileRepOperationWrite、FileRepOperationFlush、FileRepOperationClose等指令消息(消息中包含具体要更新的文件page及内容)，通过primary sender进程向Mirror发送Message，然后Mirror的mirror consumer等进程解析消息，执行变更。XLOG通过
XLogWrite
函数(写XLOG)执行同样的操作，把XLOG更新同步过去。

    
文件同步

    
Primary会有个recovery进程，这个进程会循环把Primary的 pg_control、pg_clog、pg_subtrans 等文件覆盖到Mirror。同时检查XLOG是否一致，如果不一致以Primary为主，对Mirror进行覆盖。除了把Primary部分文件同步到Mirror之外recovery进程还会将Mirror上面的临时文件删掉。

    

      

    

    
总结

    
Primary和Mirror同步数据的时候，Primary对于每一次写page都会通过消息发送到Mirror，如果Primary大量的更新page，那么Primary和Mirror同步将有可能成为瓶颈。

  

  

    

    

    
Test Book

  

  

    
介绍

    
本文将介绍 MySQL 5.7 中如何实现非结构化（JSON）数据的存储，在介绍 MySQL 5.7 的非结构化数据存储之前，首先介绍在之前的 MySQL 的版本中，用户如何通过 BLOB 实现 JSON 对象的存储，以及这样处理的缺点是什么，这些缺点也就是 MySQL 5.7 支持 JSON 的理由；然后我们介绍了 MySQL 5.7 如何支持 JSON 格式，本文将重点关注MySQL 5.7 JSON 的存储格式。

    
5.7 之前 BLOB 方式实现 JSON 对象的存储

    
MySQL 是一个关系型数据库，在 MySQL 5.7 之前，没有提供对非结构化数据的支持，但是如果用户有这样的需求，也可以通过 MySQL 的 BLOB 来存储非结构化的数据。如下所示：

    

      
mysql> create table t(json_data blob);
Query OK, 0 rows affected (0.13 sec)

mysql> insert into t values('{"key1":"data1", "key2":2, "key3":{"sub_key1":"sub_val1"}}');
Query OK, 1 row affected (0.01 sec)

mysql> select * from t;
+------------------------------------------------------------+
| json_data                                                  |
+------------------------------------------------------------+
| {"key1":"data1", "key2":2, "key3":{"sub_key1":"sub_val1"}} |
+------------------------------------------------------------+
1 row in set (0.00 sec)

    

    
在本例中，我们使用 BLOB 来存储 JSON 数据，使用这种方法，需要用户保证插入的数据是一个能够转换成 JSON 格式的字符串，MySQL 并不保证任何正确性。在MySQL看来，这就是一个普通的字符串，并不会进行任何有效性检查，此外提取 JSON 中的字段，也需要用户的代码中完成，如下所示：

    

      
#!/usr/bin/python

import pymysql
import json

try:
    conn = pymysql.connect(host="127.0.0.1", db="test", user="root", passwd="root", port=7799)
    sql = "select * from t"
    cur = conn.cursor()
    cur.execute(sql)
    rows =  cur.fetchall()
    print json.dumps(json.loads(rows[0][0]), indent=4)
except:
    conn.close()

    

    
执行python脚本的结果如下所示：

    

      
root@dev1:~# python test.py
{
    "key3": {
        "sub_key1": "sub_val1"
    },
    "key2": 2,
    "key1": "data1"
}

    

    
这种方式虽然也能够实现 JSON 的存储，但是有诸多缺点，最为显著的缺点有：

    

      
需要用户保证 JSON 的正确性，如果用户插入的数据并不是一个有效的 JSON 字符串，MySQL 并不会报错；

      
所有对 JSON 的操作，都需要在用户的代码里进行处理，不够友好；

      
即使只是提取 JSON 中某一个字段，也需要读出整个 BLOB，效率不高；

      
无法在 JSON 字段上建索引。

    

    
5.7中的JSON实现

    
MySQL本身已经是一个比较完备的数据库系统，对于底层存储并不适合有太大的改动，那么 MySQL 是如何支持 JSON 格式的呢？说来也巧，和我们前面的做法几乎一样——通过 BLOB 来存储。也就是说，MySQL 5.7支持 JSON 的做法是，在server层提供了一堆便于操作 JSON 的函数，至于存储，就是简单地将 JSON 编码成 BLOB，然后交由存储引擎层进行处理，也就是说，MySQL 5.7的JSON 支持与存储引擎没有关系，MyISAM 存储引擎也支持 JSON 格式，如下所示：

    

      
mysql> create table t_innodb(data json)engine=innodb;
Query OK, 0 rows affected (0.18 sec)

mysql> insert into t_innodb values('{"key":"val"}');
Query OK, 1 row affected (0.03 sec)

mysql> create table t_myisam(data json)engine=myisam;
Query OK, 0 rows affected (0.02 sec)

mysql> insert into t_myisam values('{"key":"val"}');
Query OK, 1 row affected (0.00 sec)

    

    
MySQL 5.7 提供了很多操作 JSON 的函数，都是为了提高易用性，可以参考
官方文档
。本文将主要关注实现。

    
关于MySQL 5.7的JSON存储，MySQL的源码里写得比较清楚，在sql/json_binary.h中有下面这段注释：

    

      
If the value is a JSON object, its binary representation will have a
header that contains:

- the member count
- the size of the binary value in bytes
- a list of pointers to each key
- a list of pointers to each value

The actual keys and values will come after the header, in the same
order as in the header.

Similarly, if the value is a JSON array, the binary representation
will have a header with

- the element count
- the size of the binary value in bytes
- a list of pointers to each value

    

    
从注释里面我们可以知道，对于JSON数组和JSON对象，MySQL如何编码成BLOB对象，数组比较简单，下面给出JSON对象的示意图（见json_binary.cc中的
serialize_json_object
函数），如下所示：

    

      

    

    
JSON 对象

    
说明如下：首先存放的是 JSON 的元素个数，然后存放的是转换成 BLOB 以后的字节数，接下来存放的是key pointers和value pointers。为了加快查找速度，MySQL 内部会对key进行排序，以便对key进行二分查找，以提高处理速度。

    
此外，对于key pointers，有如下注释：

    

      
/*
  The size of key entries for objects when using the small storage
  format or the large storage format. In the small format it is 4
  bytes (2 bytes for key length and 2 bytes for key offset). In the
  large format it is 6 (2 bytes for length, 4 bytes for offset).
*/
#define KEY_ENTRY_SIZE_SMALL      (2 + SMALL_OFFSET_SIZE)
#define KEY_ENTRY_SIZE_LARGE      (2 + LARGE_OFFSET_SIZE)

    

    
也就是说，在MySQL 5.7中，key的长度只用2个字节保存（65535），如果超过这个长度，MySQL将报错，如下所示：

    

      
mysql> insert into t1 values(JSON_OBJECT(repeat('a', 65535), 'val'));
Query OK, 1 row affected (0.37 sec)

mysql> insert into t1 values(JSON_OBJECT(repeat('a', 65536), 'val'));
ERROR 3151 (22032): The JSON object contains a key name that is too long.

    

    
如果查看MySQL的源码，可以看到，与JSON相关的文件有：

    

      
json_binary.cc
json_binary.h
json_dom.cc
json_dom.h
json_path.cc
json_path.h

    

    
其中，json_binary 处理JSON 的编码、解码，json_dom 是 JSON 的内存表示，json_path 用以将字符串解析成 JSON，具体说明见
WL#7909
。

    
对于 JSON 的编码，入口是json_binary.cc 文件中的
serialize
函数，对于 JSON 的解码，即将 BLOB 解析成 JSON 对象，入口是json_binary.cc文件中的
parse_binary
函数，只要搞清楚了 JSON 的存储格式，这两个函数是很好理解的。

    

      
作者介绍

赖明星 厦门大学硕士毕业，网易杭研服务器端开发工程师，MySQL 爱好者，网名“不知一不知二”。

    

  

  

    

    

    
Test Book

  

  

    
上一篇文章咱们对 ICP 进行了一次全面的分析，本篇文章小编继续为大家分析优化器的另外两个选项: MRR & batched_key_access(BKA) ，分析一下他们的作用、原理、相互关系、源码实现以及使用范围。

    
什么是 MRR

    
MRR 的全称是 Multi-Range Read Optimization，是优化器将随机 IO 转化为顺序 IO 以降低查询过程中 IO 开销的一种手段，咱们对比一下 mrr=on & mrr=off 时的执行计划：

    
其中表结构如下：

    

      
mysql> show create table t1\G
*************************** 1\. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `a` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL,
  `c` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mrrx` (`a`,`b`),
  KEY `xx` (`c`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1
1 row in set (0.00 sec)

    

    
操作如下：

    

      
mysql> set optimizer_switch='mrr=off';
Query OK, 0 rows affected (0.00 sec)

mysql>  explain select * from test.t1 where (a between 1 and 10) and (c between 9 and 10) ;
+----+-------------+-------+-------+---------------+------+---------+------+------+------------------------------------+
| id | select_type | table | type  | possible_keys | key  | key_len | ref  | rows | Extra                              |
+----+-------------+-------+-------+---------------+------+---------+------+------+------------------------------------+
|  1 | SIMPLE      | t1    | range | mrrx,xx       | xx   | 5       | NULL |    2 | Using index condition; Using where |
+----+-------------+-------+-------+---------------+------+---------+------+------+------------------------------------+
1 row in set (0.00 sec)

    

    
当把 MRR 关掉的情况下，执行计划使用的是索引 xx(c)，即从索引 xx 上读取一条数据后回表，取回该主键的完整数据，当数据较多且比较分散的情况下会有比较多的随机 IO, 导致性能低下，我们将 MRR 打开，执行以下操作：

    

      
mysql> set optimizer_switch='mrr=on';
Query OK, 0 rows affected (0.00 sec)

mysql>  explain select * from test.t1 where (a between 1 and 10) and (c between 9 and 10) ;
+----+-------------+-------+-------+---------------+------+---------+------+------+-----------------------------------------------+
| id | select_type | table | type  | possible_keys | key  | key_len | ref  | rows | Extra                                         |
+----+-------------+-------+-------+---------------+------+---------+------+------+-----------------------------------------------+
|  1 | SIMPLE      | t1    | range | mrrx,xx       | xx   | 5       | NULL |    2 | Using index condition; Using where; Using MRR |
+----+-------------+-------+-------+---------------+------+---------+------+------+-----------------------------------------------+
1 row in set (0.00 sec)

    

    
可以看到 extra 的输出中多了 “Using MRR” 信息，即使用了 MRR Optimization IO 层面进行了优化，减少 IO 方面的开销，更详细的说明可以参考
这里
。

    
MRR 原理

    
在不使用 MRR 时，优化器需要根据二级索引返回的记录来进行“回表”，这个过程一般会有较多的随机 IO, 使用 MRR 时，SQL 语句的执行过程是这样的：

    

      
优化器将二级索引查询到的记录放到一块缓冲区中；

      
如果二级索引扫描到文件的末尾或者缓冲区已满，则使用快速排序对缓冲区中的内容按照主键进行排序；

      
用户线程调用 MRR 接口取 cluster index，然后根据cluster index 取行数据；

      
当根据缓冲区中的 cluster index 取完数据，则继续调用过程 2) 3)，直至扫描结束；

    

    
通过上述过程，优化器将二级索引随机的 IO 进行排序，转化为主键的有序排列，从而实现了随机 IO 到顺序 IO 的转化，提升性能。

    
MRR 源码分析

    
首先，咱们来看一下 mrr 相对应的内存结构：

    

      
class DsMrr_impl
{
  ...
  handler *h;
  TABLE *table; /* Always equal to h->table */
private:
  /* Secondary handler object.  It is used for scanning the index */
  handler *h2;

  /* Buffer to store rowids, or (rowid, range_id) pairs */
  uchar *rowids_buf;
  uchar *rowids_buf_cur;   /* Current position when reading/writing */
  uchar *rowids_buf_last;  /* When reading: end of used buffer space */
  uchar *rowids_buf_end;   /* End of the buffer */

  bool dsmrr_eof; /* TRUE <=> We have reached EOF when reading index tuples */

  int dsmrr_init(handler *h, RANGE_SEQ_IF *seq_funcs, void *seq_init_param,
                 uint n_ranges, uint mode, HANDLER_BUFFER *buf);
  ….
  int dsmrr_fill_buffer();
  int dsmrr_next(char **range_info);
  bool get_disk_sweep_mrr_cost(uint keynr, ha_rows rows, uint flags, uint *buffer_size, Cost_estimate *cost);
  ….
}

    

    
简单说明：h2 指的是 MRR 使用的 second index 或主键索引, h 是指利用 h2 返回的主建来查询的句柄，rowids_buf 是 MRR 执行过程中存储有序主键的缓存区，大小由 MySQL 的变量 
read_rnd_buffer_size
 设置，下面我们结合程序的执行过程来看一下源码。

    

      

        
MRR 中有序主建的收集过程

优化器对查询语句的条件进行分析并选择合适的二级索引，并对二级索引的条件进行筛选拼装成 DYNAMIC_ARRAY ranges，在执行的时候将 ranges 传入初始化函数 
ha_myisam::multi_range_read_init
 ，继而会调用 
dsmrr_fill_buffer
 函数，在
dsmrr_fill_buffer
中会使用二级索引的句柄查找符合 ranges 的数据并添加至 rowids_buf 中，在扫描结束或缓冲区满的时候会对 rowids_buf 进行快速排序，详细过程可以参考函数：
dsmrr_fill_buffer
，其调用堆栈如下：

        

          
 #0  DsMrr_impl::dsmrr_fill_buffer (this=0x2aab0000cf00)
 #1  0x00000000006e49dd in DsMrr_impl::dsmrr_init(...)
 #2  0x00000000017d35e4 in ha_myisam::multi_range_read_init(...)
 #3  0x0000000000d134c6 in QUICK_RANGE_SELECT::reset (this=0x2aab00014070)
 #4  0x00000000009a266f in join_init_read_record (tab=0x2aab0000f5b8)
 #5  0x000000000099d6d4 in sub_select
 #6  0x000000000099c914 in do_select (join=0x2aab000064b0)
 #7  0x00000000009982f8 in JOIN::exec (this=0x2aab000064b0)
 #8  0x0000000000a5bd7c in mysql_execute_select
 ........

        

      

      

        
MRR 中主建缓冲区的使用过程

        
物理执行阶段，调用 
ha_myisam::multi_range_read_next
，在使用 MRR 的情况下会从过程1）中收集的有序主建的缓冲区取主建，然后再调用引擎层的 rnd_pos 直接找到数据，其中使用 mrr 的调用堆栈如下：

        

          
 #0  DsMrr_impl::dsmrr_next (this=0x2aab0000cf00, range_info=0x2aaafc03de70)
 #1  0x00000000017d3634 in ha_myisam::multi_range_read_next (this=0x2aab0000ca40, range_info=0x2aaafc03de70)
 #2  0x0000000000d138cc in QUICK_RANGE_SELECT::get_next (this=0x2aab00014070)
 #3  0x0000000000d46908 in rr_quick (info=0x2aab0000f648)
 #4  0x00000000009a2791 in join_init_read_record (tab=0x2aab0000f5b8)
 #5  0x000000000099d6d4 in sub_select (join=0x2aab000064b0, join_tab=0x2aab0000f5b8, end_of_records=false)
 #6  0x000000000099c914 in do_select (join=0x2aab000064b0)

        

        
二缓索引（h2）& 主建索引（h) 的协同是通过
rowids_buf_cur
来进行的。最初的初始化过程中，h2 会首先将数据填冲到 rowids_buf 中，如果发现缓冲区中的数据已经取完，则会继续调用 
dsmrr_fill_buffer
 往 rowids_buf 填主键并进行排序，如此反复，直至 h2 扫描至文件末尾，详情可以参考函数 
DsMrr_impl::dsmrr_next
。

      

    

    
通过上面的分析，是不是感觉 MRR 有点像二级索引与主键的 join 操作，那就是有点和 BKA 有些类似的概念了，咱们下面看一下 BKA 是如何实现的。

    
BKA 原理

    
BKA 是指在表连接的过程中为了提升 join 性能而使用的一种 join buffer，其作用是在读取被 join 表的记录的时候使用顺序 IO，BKA 被使用的标识是执行计划的 extra 信息中会有 “Batched Key Access” 信息， 我们首先看一个例子：

    

      
DROP TABLE t1, t2;
CREATE TABLE t1 (a int PRIMARY KEY, b int);
CREATE TABLE t2 (a int PRIMARY KEY, b int);
INSERT INTO t1 VALUES (1,2), (2,1), (3,2), (4,3), (5,6), (6,5), (7,8), (8,7), (9,10);
INSERT INTO t2 VALUES (3,0), (4,1), (6,4), (7,5);

mysql> set optimizer_switch="mrr=on,mrr_cost_based=off,batched_key_access=on";
mysql> explain SELECT * FROM t1 LEFT JOIN t2 ON t1.a = t2.a WHERE t2.b <= t1.a AND t1.a <= t1.b;
+----+-------------+-------+--------+---------------+---------+---------+-----------+------+-----------------------------------------------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref       | rows | Extra                                               |
+----+-------------+-------+--------+---------------+---------+---------+-----------+------+-----------------------------------------------------+
|  1 | SIMPLE      | t2    | ALL    | PRIMARY       | NULL    | NULL    | NULL      |    4 | Using where                                         |
|  1 | SIMPLE      | t1    | eq_ref | PRIMARY       | PRIMARY | 4       | test.t2.a |    1 | Using where; Using join buffer (Batched Key Access) |
+----+-------------+-------+--------+---------------+---------+---------+-----------+------+-----------------------------------------------------+
2 rows in set (0.00 sec)

    

    
从以上的例子中我们可以看到，在读取表 t1 的时候使用了带 BKA 功能的 join buffer, 其中 BKA & join buffer 的关系与实现我们放在后面详解。

    
BKA & MRR 之间的关系

    
使用 BKA 的表的 JOIN 过程如下：

    

      
连接表将满足条件的记录放入JOIN_CACHE，并将两表连接的字段放入一个 DYNAMIC_ARRAY ranges 中，此过程类似于 MRR 操作的过程，且在内存中使用的是同样的结构体 DsMrr_impl；

      
在进行表的过接过程中，会将 ranges 相关的信息传入 
DsMrr_impl::dsmrr_fill_buffer
，并进行被连接表主建的查找及排序等操作操作，这个过程比较复杂，包括需要判断使用的 key、key 是主建时的特殊操作等；

      

JOIN_CACHE_BKA::join_matching_records
 会调用过程2中产生的有序主建，然后顺序读取数据并进入下一步的操作（
evaluate_join_record
 等）；

      
当缓冲区的数据被读完后，会重复进行过程2，3, 直到记录被读取完。

    

    
由上面的分析可以看出，BKA将有序主建投递到存储引擎是通过 MRR 的接口的调用来实现的（
DsMrr_impl::dsmrr_next
），所以BKA 依赖 MRR，如果要使用BKA, MRR 是需要打开的，另外 
batched_key_access
 是默认关闭的，如果要使用，需要打开此选项。

BKA 的详细说明可参考
这里
。

    
BKA 源码实现

    
表之间的连接操作是通过 JOIN_CACHE 来做的，5.6 目前实现了 BNL, BKA (JOIN_CACHE_BKA & JOIN_CACHE_BKA_UNIQUE) 两种表连接的优化方式，其中 BKA 就是其中减少随机 IO 的一种方式，BKA内存中对应的结构是 JOIN_CACHE_BKA，咱们首先看一下多表 JOIN 之间的过程；

    

      
优化器生成的执行计划是由一个 JOIN_TAB 的左支树组成，每个 JOIN_TAB 包含了相关的表、使用的索引、语句中包含的条件等信息；

      

        
进入物理执行计划后，会对每一个表进行读数据，然后进入 
evaluate_join_record
, 当发现满足条件的记录时，则会将该记录添加到下一个JOIN_TAB 中的JOIN_CACHE 中，其堆栈如下：

        

          
 #0  JOIN_CACHE::put_record (this=0x2aab00019d20)
 #1  0x000000000099d29c in sub_select_op (join=0x2aab00016268, join_tab=0x2aab00018ed8, end_of_records=false)
 #2  0x000000000099ee1c in evaluate_join_record (join=0x2aab00016268, join_tab=0x2aab00018bd8)
 #3  0x000000000099d984 in sub_select (join=0x2aab00016268, join_tab=0x2aab00018bd8, end_of_records=false)
 #4  0x000000000099c914 in do_select (join=0x2aab00016268)
 #5  0x00000000009982f8 in JOIN::exec (this=0x2aab00016268)
 #6  0x0000000000a5bd7c in mysql_execute_select (thd=0x314d690, select_lex=0x31503a8, free_join=true)

        

      

      

        
当缓冲区满或者读到文件的末尾时，会调用下一个JOIN_TAB 中 
JOIN_CACHE::join_records
 方法（BKA 使用时 JOIN_CACHE 为 JOIN_CACHE_BKA），然后会进入 MRR 的相关逻辑，其完整的堆栈为：

        

          
 #0  DsMrr_impl::dsmrr_fill_buffer (this=0x2aab000128e0)
 #1  0x00000000006e49dd in DsMrr_impl::dsmrr_init
 #2  0x00000000017d35e4 in ha_myisam::multi_range_read_init
 #3  0x0000000000d838aa in JOIN_CACHE_BKA::init_join_matching_records (this=0x2aab00019d20, seq_funcs=0x2aaafc03dd80, ranges=4)
 #4  0x0000000000d8335c in JOIN_CACHE_BKA::join_matching_records (this=0x2aab00019d20, skip_last=false)
 #5  0x0000000000d812e8 in JOIN_CACHE::join_records (this=0x2aab00019d20, skip_last=false)
 #6  0x0000000000d86ed3 in JOIN_CACHE::end_send (this=0x2aab00019d20)
 #7  0x000000000099d0d1 in sub_select_op (join=0x2aab00016268, join_tab=0x2aab00018ed8, end_of_records=true)
 #8  0x000000000099d3c4 in sub_select (join=0x2aab00016268, join_tab=0x2aab00018bd8, end_of_records=true) at
 #9  0x000000000099c97d in do_select (join=0x2aab00016268)
 #10 0x00000000009982f8 in JOIN::exec (this=0x2aab00016268)
 #11 0x0000000000a5bd7c in mysql_execute_select

        

      

      

        

dsmrr_fill_buffer
 的过程相对复杂，需要首先取出两表相连接的字段的索引，如果没有索引，则会使用主建并直接读取，如果使用了索引，则需要从上一个JOIN_TAB中将索引的信息读出来并从 join_cache 的 buffer 中取出该索引的数据，然后再进行回表，查找主建、排序等操作，其堆栈如下：

        

          
 #0  JOIN_CACHE_BKA::get_next_key (this=0x2aab00019d20, key=0x2aab0001e178)
 #1  0x0000000000d82f83 in bka_range_seq_next (rseq=0x2aab00019d20, range=0x2aab0001e178)
 #2  0x00000000006e3cac in handler::multi_range_read_next (this=0x2aab0001e020, range_info=0x2aaafc03dc10)
 #3  0x00000000006e5466 in DsMrr_impl::dsmrr_fill_buffer (this=0x2aab000128e0)
 #4  0x00000000006e49dd in DsMrr_impl::dsmrr_init (…)
 #5  0x00000000017d35e4 in ha_myisam::multi_range_read_init (…)
 #6  0x0000000000d838aa in JOIN_CACHE_BKA::init_join_matching_records (this=0x2aab00019d20, seq_funcs=0x2aaafc03dd80, ranges=4)

        

      

    

    
此过程只是两个表的使用 BKA 时的过程，当是多表时，过程将更为复杂。

    
小结

    
本篇文章中我们详细的介绍了 MRR、BKA 以及 MRR & BKA 之间的关系等内容，测试用例都是在mrr_cost_based=OFF 的情况下进行的，因为SQL 语句是否使用 MRR 优化依赖于其代价的大小，优化器的代价计算是一个比较复杂的过程，无论是 MRR 还是 BKA 都只是优化器进行优化的方法，当其发现优化后的代价过高时就会不使用该项优化，因此在使用 MRR 相关的优化时，尽量设置 mrr_cost_based=ON，毕竟大多数情况下优化器是对的。

  

  

    

    

    
Test Book

  

  

    
背景

    
本文对 5.6 主备场景下，在备库做物理备份遇到死锁的case进行分析，希望对大家有所帮助。

    
这里用的的物理备份工具是 Percona-XtraBackup(PXB)，有的同学可能不清楚其备份流程，所以这里先简单说下，PXB的备份步骤是这样的：

    

      
拷贝 InnoDB redo log，这是一个单独的线程在拷，直到备份结束；

      
拷贝所有InnoDB ibd文件；

      
加全局读锁，执行 FLUSH TABLES WITH READ LOCK(FTWRL);

      
拷贝 frm、MYD、MYI 等文件；

      
获取位点信息，执行 show slave status 和 show master status；

      
解锁，UNLOCK TABLES;

      
做一些收尾处理，备份结束。

    

    
如果 MyISAM 表很多话，全局读锁的持有时间会比较长，所以一般都在备库做备份。

    
另外 FLUSH TABLE WITH READ LOCK 这条命令会获取2个MDL锁，全局读锁（
MDL_key::GLOBAL
）和全局COMMIT（
MDL_key::COMMIT
）锁，MDL锁详情可以参考之前的月报
MDL 实现分析
。

    
死锁分析

    
CASE 1

    
我们先看一下死锁时的现场是怎样的：

    

      
mysql> show processlist;
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+
| Id | User        | Host            | db   | Command | Time | State                                  | Info              |
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+
|  1 | root        | 127.0.0.1:53309 | NULL | Query   |  278 | init                                   | show slave status |
|  2 | system user |                 | NULL | Connect |  381 | Queueing master event to the relay log | NULL              |
|  3 | system user |                 | NULL | Connect |  311 | Waiting for commit lock                | NULL              |
|  4 | root        | 127.0.0.1:53312 | NULL | Query   |    0 | init                                   | show processlist  |
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+

    

    
可以看到 show slave status 被堵了很久，另外 SQL 线程在 Waiting for commit lock，说明在等待 COMMIT 锁。

    
这时候如果我们再连接进去执行 show slave status 也会被堵，并且即使 Ctrl-C kill 掉线程，线程依然还在。

    

      
mysql> show processlist;
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+
| Id | User        | Host            | db   | Command | Time | State                                  | Info              |
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+
|  1 | root        | 127.0.0.1:53309 | NULL | Query   |  753 | init                                   | show slave status |
|  2 | system user |                 | NULL | Connect |  856 | Queueing master event to the relay log | NULL              |
|  3 | system user |                 | NULL | Connect |  786 | Waiting for commit lock                | NULL              |
|  4 | root        | 127.0.0.1:53312 | NULL | Killed  |  188 | init                                   | show slave status |
|  5 | root        | 127.0.0.1:53314 | NULL | Query   |    0 | init                                   | show processlist  |
|  8 | root        | 127.0.0.1:53318 | NULL | Killed  |  125 | init                                   | show slave status |
| 11 | root        | 127.0.0.1:53321 | NULL | Killed  |  123 | init                                   | show slave status |
| 14 | root        | 127.0.0.1:53324 | NULL | Query   |  120 | init                                   | show slave status |
+----+-------------+-----------------+------+---------+------+----------------------------------------+-------------------+

    

    
pstack 看下相关线程的 backtrace，show slave status 线程的 backtrace 如下，非常明显是在等mutex，对应代码为 
mysql_mutex_lock(&mi->rli->data_lock)
:

    

      
#0  __lll_lock_wait
#1  _L_lock_974
#2  __GI___pthread_mutex_lock
#3  inline_mysql_mutex_lock
#4  show_slave_status
#5  mysql_execute_command
#6  mysql_parse
#7  dispatch_command
#8  do_command
#9  do_handle_one_connection
#10 handle_one_connection
...

    

    
SQL 线程的 backtrace 如下，在等 COMMIT 锁：

    

      
#0  pthread_cond_timedwait
#1  inline_mysql_cond_timedwait
#2  MDL_wait::timed_wait
#3  MDL_context::acquire_lock
#4  ha_commit_trans
#5  trans_commit
#6  Xid_log_event::do_commit
#7  Xid_log_event::do_apply_event
#8  Log_event::apply_event
#9  apply_event_and_update_pos
#10 exec_relay_log_event
#11 handle_slave_sql
...

    

    
如果我们gdb进去，去调试SQL线程，在 
MDL_context::acquire_lock
中：

    

      
(gdb) p (MDL_key::enum_mdl_namespace)lock->key->m_ptr[0]
$24 = MDL_key::COMMIT
(gdb) p ((THD*)lock->m_granted.m_list.m_first->m_ctx->m_owner)->thread_id
$25 = 1

    

    
可以看到 COMMIT 锁被线程 1 持有。

    
SQL线程在 
Xid_log_event::do_commit
 之前会持有 
rli_ptr->data_lock
。

    
所以现在就清楚了，是线程1（备份线程）和线程3（SQL线程）死锁了，还原下死锁过程：

    

      
备份线程执行 FTWRL，拿到 COMMIT 锁；

      
SQL线程执行到Xid event，准备提交事务，请求 COMMIT 锁，被备份线程阻塞；

      
备份线程为了获取 slave 执行位点，执行 show slave status，需要获取 
rli->data_lock
，被 SQL 线程阻塞。

    

    
就这样2个线程互相持有等待，形成死锁。

    
我们知道，MDL 是有死锁检测的，为什么这里没有检测到呢？因为
rli->data_lock
是一个mutex，不属于MDL系统的，在这个死锁场景中，MDL锁系统只能检测到对 COMMIT 锁的请求，是不存在死锁的。

    
之后的 show slave status 都被堵，是因为在执行 show slave status 前，会请求一个mutex:

    

      
mysql_mutex_lock(&LOCK_active_mi);
res= show_slave_status(thd, active_mi);
mysql_mutex_unlock(&LOCK_active_mi);

    

    
之前死锁的 show slave status 没有退出，后面的 show slave status 自然堵在这个 mutex 上，并且因为无法检测 
thd->killed
，所以一直无法退出。

    
死锁的原因是SQL线程在提交的时候，持有 
rli->data_lock
 锁，其实这个是不需要的，MySQL 官方在这个 
patch
 中修复。

    
CASE 2

    
在上面的bug修复后，又出现了死锁，但死锁的情况却不一样，show processlist 结果如下：

    

      
mysql> show processlist;
+----+-------------+-----------------+------+---------+------+----------------------------------+-------------------+
| Id | User        | Host            | db   | Command | Time | State                            | Info              |
+----+-------------+-----------------+------+---------+------+----------------------------------+-------------------+
|  2 | system user |                 | NULL | Connect |  436 | Waiting for master to send event | NULL              |
|  3 | system user |                 | NULL | Connect |  157 | Waiting for commit lock          | NULL              |
|  6 | root        | 127.0.0.1:42787 | NULL | Query   |   86 | init                             | show slave status |
|  7 | root        | 127.0.0.1:42788 | NULL | Query   |   96 | Killing slave                    | stop slave        |
|  8 | root        | 127.0.0.1:42789 | NULL | Query   |    0 | init                             | show processlist  |
+----+-------------+-----------------+------+---------+------+----------------------------------+-------------------+

    

    
依然是 SQL 线程在等待commit锁，然后 show slave status 被堵住没有返回，不同的是多了一个 stop slave; 我们来看下 stop slave 的backtrace:

    

      
#0  pthread_cond_timedwait
#1  inline_mysql_cond_timedwait
#2  terminate_slave_thread
#3  terminate_slave_threads
#4  stop_slave
#5  mysql_execute_command
#6  mysql_parse
#7  dispatch_command
#8  do_command
#9  do_handle_one_connection
#10 handle_one_connection
...

    

    
对应代码，可以发现 stop slave 正在等待 SQL 线程退出，而SQL线程此时正在等待备份线程（id=6）持有的 COMMIT 锁。整个死锁过程是这样的：

    

      
备份线程执行 FTWRL，拿到 COMMIT 锁；

      
SQL线程执行到Xid event，准备提交事务，请求 COMMIT 锁，被备份线程阻塞；

      
用户执行 stop slave，准备停掉备库复制线程，等待 SQL 线程退出；

      
备份线程为了获取 slave 执行位点，执行 show slave status，需要获取 
LOCK_active_mi
 锁，被用户线程（stop slave）阻塞。

    

    
这次是备份线程、SQL 线程、用户线程3个线程互相持有等待，形成死锁。

    
这次并不是代码bug，算是一个用法问题，因此我们在运维过程中，如果发现 SQL 线程在 Waiting for commit lock，就不要 stop slave。

    
死锁解决

    
如果不可避免出现了死锁，该怎么解决呢？

    
通过上面的分析可以看到，不管是在 case 1 还是 case 2，备份线程和用户线程都不再接受响应了，要解决死锁的话，只能 kill 掉 SQL 线程了，那么直接 kill 是否有风险呢？

    
SQL 线程能执行 Xid event，说明是在更新事务引擎表，kill 掉应该没问题（事务可以回滚，之后可以重做），但是5.6有这样的一个
bug
，会导致SQL线程在等待 COMMIT 锁的时候被kill，直接跳过事务，这样备库会比主库少一个事务，因此 kill 后需要对比主备数据，把少的事务补上。

    
如果你使用的 MySQL 版本已经修掉这个bug，也就是在 5.6.21 版本及之后，那么 kill SQL 线程是安全的。

    
死锁重现

    
如果为了测试或研究代码，要想复现死锁该怎么办呢？如果直接在备库执行一个 FTWRL，很可能是复现不了的，因为FTWRL是获取2个锁，全局读锁和全局 COMMIT 锁，SQL 线程非常可能被全局读锁堵到（Waiting for global read lock），而不是被 COMMIT 锁堵（Waiting for commit lock）。

    
一种方法是写 testcase，用 dubug sync 功能设置同步点，让线程停在指定的地方，但这要求 mysqld 跑在deubg模式下，并且要求有一定的MySQL 源码开发基础；

另一种方法是改代码，延长
do_commit
的时间，比如 sleep 一段时间，这样就给我们足够的时间让 FTWRL 在 SQL 线程请求 COMMIT 锁前执行完成，但是这需改代码，然后重新编译安装；

如果我们不会用debug sync，又不想改代码重新编译安装，就想在已有的环境测，改怎么办呢？
SYSTEMTAP
!

    
systemtap 起初只支持在内核空间进行探测，0.6 版本之后可以在用户空间进行探测，使用 systemtap 需要程序中包含 debug 信息（程序编译时加上 -g 选项）。

    
列出所有我们可以对 mysqld 进行探测的地方。

    

      
sudo stap -L 'process("/usr/sbin/mysqld").function("*")'

    

    
列出所有可以对 
Xid_log_event
 类进行探测的地方。

    

      
sudo stap -L 'process("/usr/sbin/mysqld").function("*Xid_log_event::*")'

    

    
如果我们想让 
Xid_log_event::do_commit
 执行有点延迟，可以这样做：

    

      
sudo stap -v -g -d /usr/bin/mysqld --ldd  -e 'probe process(16011).function("Xid_log_event::do_commit") { printf("got it\n")  mdelay(3000) }'

    

    
16011 是正在跑的备库进程PID，执行上面的 stap 命令后，每当备库执行到 
Xid_log_event::do_commit
 时，stap 就会打出个 “got it”，然后 SQL 线程暂停3s，这就给了我们充足的时间去执行 FTWRL，在SQL线程 commit 前拿到 COMMIT 锁。

  

  

    

    

    
Test Book

  

  

    
介绍

    
TokuDB也有类似InnoDB的buffer pool叫做cachetable，存储数据节点（包括叶节点和中间节点）和rollback段，本文中为了表达简单，叶节点，中间节点和rollback段统称数据节点。Cachetable是全局唯一的，它与MySQL实例存在一一对应的关系。TokuDB没有采用常见的BTREE(BTREE+，BTREE*)表示索引，而是采用Fractal Tree，简称FT。FT跟BTREE+类似，维护了一个树形的有序结构，中间节点存储pivot（TokuDB的中间节点还包含message buffer），叶节点存储数据。

    
数据库启动的时候会去初始化cachetable。Client线程（调用栈上下文所在的线程）要访问某个数据节点会首先在cachetable里面查找，找到就立即返回；否则会在cachetable申请一个cache项，然后从磁盘上加载数据到那个cache项。TokuDB里表示cache项的数据结构叫做pair，记录(节点块号/页号，数据节点）的对应关系。在MySQL的缺省引擎InnoDB中，数据和索引是存储在一个文件里的，而TokuDB中每个索引对应一个单独的磁盘文件。

    
Cachetable是一个hash表，每个bucket里面包含多个pair，共1024*1024个bucket。属于相同索引的pair由cachefile来管理。TokuDB有一个优化在后面会涉及到，这里先简单提一下。当server层显示关闭某个TokuDB表时FT层会调用
toku_cachefile_close
关闭表或者索引，并把缓存的数据节点从cachetable删除；但这些数据节点仍然保留在cachefile中（保留在内存中）。这种cachefile会被加到的stale列表里面，它包含的数据节点会在内存里呆一段时间。近期再次访问这个索引时，首先会在active列表里查找索引对应的cachefile。若没有找到会尝试在stale列表查找并把找到的cachefile的数据节点重新加到cachetable里去。近期再次访问相同的数据集就不必从磁盘上加载了。

    
Cachetable的工作线程(worker thead)

    
Cachetable创建了三个工作线程：

    

      
evictor线程：释放部分cachetable内存空间；

      
cleaner线程：flush中间节点的message buffer到叶节点；

      
checkpointer线程：写回dirty数据。

    

    
Cachetable的线程池

    
Cachetable创建了三个线程池：

    

      
client线程池：帮助cleaner线程flush中间节点的message buffer；

      
cachetable线程池：

帮助client线程fetch/partial fetch数据节点

帮助evictor线程evict/partial evict数据节点

从cachetable删除时，后台删除数据节点

      
checkpoint线程池：帮助client线程写回处于checkpoint_pending状态的数据节点。

    

    
Cachetable的几个主要队列

    

      
m_clock_head：新加载的数据节点除了加入hash方便快速定位，也会加入此队列。可以理解成cachetable的LRU队列；

      
m_cleaner_head：指向m_clock_head描述LRU队列，cleaner线程从这个位置开始扫描找到memory pressure最大的中间节点发起message buffer flush操作；

      
m_checkpoint_head：指向m_clock_head描述LRU队列，checkpointer线程在begin checkpoint阶段从这个位置开始扫描，把每个数据节点加到m_pending_head队列；

      
m_pending_head：checkpointer线程在end checkpoint阶段从这个位置开始扫描，把ditry数据节点写回到磁盘上。

    

    
Evictor线程

    
随着数据逐渐加载到cachetable，其消耗的内存空间越来越大，当达到一定程度时evictor工作线程会被唤醒尝试释放一些数据节点。Evitor线程定期运行(缺省1秒)。Evictor定义四个watermark来评价当前cachetable消耗内存的程度：

    

      
m_low_size_watermark: 达到此watermark以后，evictor线程停止释放内存空间。通俗的说，这就是cachetable消耗内存的上限；

      
m_low_size_hysteresis： 达到此watermark以后，client线程（也就是server层线程）唤醒evictor线程释放内存。一般是m_low_size_watermark的1.1倍；

      
m_high_size_hysteresis: 达到此watermark以后，阻塞的client线程会被唤醒。一般是m_low_size_watermark的1.2倍；

      
m_high_size_watermark：达到此watermark以后，client线程会被阻塞在m_flow_control_cond条件变量上等待evictor线程释放内存。一般是m_low_size_watermark的1.5倍。

    

    
Evictor线程被唤醒的时机

    

      
添加新pair；

      
Get pair时，需要fetch或者partial fetch数据节点；

      
Evictor destroy时，唤醒等待的client线程；

      
释放若干数据节点后，Evictor判断是否要继续运行。

    

    
铺垫了这么多，下面一起来看一下evictor线程的主体函数
run_eviction
。
run_eviction
是一个while循环调用
eviction_needed
判断是否要进行eviction。如下所示：m_size_current表示cachetable的当前size，m_size_evicting表示当前正在evicting的数据节点消耗的内存空间。两者的差就是这次eviction运行前，cachetable最终能到达的size。

伪码如下：

    

      
bool eviction_needed() {
    return (m_size_current - m_size_evicting) > m_low_size_watermark;
}
void run_eviction(){
    uint32_t num_pairs_examined_without_evicting = 0;
    while (eviction_needed()) {
        if (m_num_sleepers > 0 && should_sleeping_clients_wakeup()) {
            /* signal the waiting client threads */
        }
        bool some_eviction_ran = evict_some_stale_pair();
        if (!some_eviction_ran) {
            get m_pl->read_list_lock;
            if (!curr_in_clock) {
                /* nothing to evict */
               break;
            }
            if (num_pairs_examined_without_evicting > m_pl->m_n_in_table) {
                /* everything is in use */
                break;
            }
            bool eviction_run = run_eviction_on_pair(curr_in_clock);
            if (eviction_run) {
                // reset the count
                num_pairs_examined_without_evicting = 0;
            }
            else {
                num_pairs_examined_without_evicting++;
            }
            release m_pl->read_list_lock;
        }
    }
}

    

    
eviction_needed 返回true时evictor尝试释放内存。它首先看一下当前的cachetable是否降到m_high_size_hysteresis以下，若是就唤醒等待在m_flow_control_cond条件变量上的client线程。然后，cachetable会先尝试回收stale列表里面cachefile上的数据节点。若stale列表里面没有可回收的数据节点，就会从m_clock_head开始尝试回收内存。对于近期没有被访问过的数据节点，会调用
try_evict_pair
尝试回收；否则会使之逐渐退化并尝试partial evict。如果把整个m_clock_head队列扫描一遍都没发现可回收的数据节点，那么这次evictor线程的工作就完成了，等下次被唤醒时再次尝试回收内存。

    
Cleaner线程

    
Cleaner是另一个定期运行(缺省1秒)的工作线程，从m_cleaner_head开始最多扫8个数据节点，从中找到cache pressure最大的节点（这个过程会skip掉正在被其他线程访问的节点）。由于叶节点和rollback段的cache pressure为0，找到的节点一定是中间节点。如果这个节点设置了checkpoint_pending标记，那么需要先调用
write_locked_pair_for_checkpoint
把数据写回再调用
cleaner_callback
把中间节点的message buffer刷到叶节点上去。数据写回的过程，如果节点设置了
clone_callback
，写回是由checkpoint线程池来完成的；没有设置
clone_callback
的情况，写回是由cleaner线程完成的。中间节点flush message buffer是一个很复杂的过程，涉及到message apply和merge等操作，打算另写一篇文章介绍。

伪码如下：

    

      
run_cleaner(){
    uint32_t num_iterations = get_iterations(); // by default, iteration == 1
    for (uint32_t i = 0; i < num_iterations; ++i) {
        get pl->read_list_lock;
        PAIR best_pair = NULL;
        int n_seen = 0;
        long best_score = 0;
        const PAIR first_pair = m_cleaner_head;
        if (first_pair == NULL) {
            /* nothing to clean */
            break;
        }
        /* pick up best_pair */
        do {
            get m_cleaner_head pair lock;
            skip m_cleaner_head if which was being referenced by others
            n_seen++;
            long score = 0;
            bool need_unlock = false;
            score = m_cleaner_head cache pressure
            if (best_score < score) {
                best_score = score;
                if (best_pair) {
                    need_unlock = true;
                }
                best_pair = m_cleaner_head;
            } else {
                need_unlock = true;
            }
            if (need_unlock) {
                release m_cleaner_head pair lock;
            }
            m_cleaner_head = m_cleaner_head->clock_next;
        } while (m_cleaner_head != first_pair && n_seen < 8);
        release m_pl->read_list_lock;
        if (best_pair) {
            get best_pair->value_rwlock;
            if (best_pair->checkpoint_pending) {
                write_locked_pair_for_checkpoint(ct, best_pair, true);
            }
            bool cleaner_callback_called = false;
            if (best_pair cache pressure > 0) {
                r = best_pair->cleaner_callback(best_pair->value_data, best_pair->key, best_pair->fullhash, best_pair->write_extraargs);
                cleaner_callback_called = true;
            }
            if (!cleaner_callback_called) {
                release best_pair->value_rwlock;
            }
        }
    }
}

    

    
Checkpointer线程

    
Cachetable的脏数据是由checkpointer线程定期(缺省60秒)刷到磁盘上。

Checkpointer线程执行过程分为两个阶段：

    
begin checkpoint阶段

    

      
为每个active的cache file打for_checkpoint标记；

      
写日志；

      
为每个数据节点打checkpoint_pending标记，并加到m_pending_head队列；

      
clone checkpoint_header: FT的metadata在内存中的数据结构是FT_HEADER，这个header有两个版本:

h表示当前版本

checkpoint_header表示当前正在进行checkpoint的版本，是h在checkpoint开始时刻的副本

      
clone BTT（block translation table）: TokuDB采用BTT记录逻辑页号（blocknum）到文件offset的映射关系。每次刷新数据节点时申请一个未使用的offset，把脏页刷到新的offset位置上，不覆盖老的数据。

BTT表也采用类似的机制被映射到FT文件不同的offset上。BTT的起始地址记录在FT_HEADER中。checkpoint完成时FT_HEADER会被更新，使新数据生效。用户可以使用checkpoint机制生成backup加速重建数据库的过程。BTT表有三个版本

当前版本(_current)

正在checkpoint的版本(_inprogress)

上次checkpoint的版本(_checkpointed)

    

    
end checkpoint阶段

    

      

        
把m_pending_head队列里的数据节点挨个写回到磁盘。写的时候首先检查是否设置
clone_callback
方法，如有调用
clone_callback
生成clone节点，在
clone_callback
里可能会对叶节点做rebalance操作，clone完成后调用
cachetable_only_write_locked_data
把cloned pair写回。没有设置clone_callback的情况会直接调用
cachetable_write_locked_pair
把节点写回。

伪码如下：

        

          
 void write_pair_for_checkpoint_thread (evictor* ev, PAIR p) {
     get p->value_rwlock.write_lock;
     if (p->dirty && p->checkpoint_pending) {
         if (p->clone_callback) {
             get p->disk_nb_mutex;
             clone_pair(ev, p);
         } else {
             cachetable_write_locked_pair(ev, p, true /* for_checkpoint */);
         }
     }
     p->checkpoint_pending = false;
     put p->value_rwlock.write_lock;
     if (p->clone_callback) {
         cachetable_only_write_locked_data(ev, p, true /* for_checkpoint */,
 &attr, true /* is_clone */);
     }
 }

        

      

      
调用
checkpoint_userdata
：

写回BTT的_inprogress版本

写回FT_HEADER的checkpoint_header版本，后面会把checkpoint_header释放掉

      
调用
end_checkpoint_userdata
：

释放BTT _checkpointed版本占用的地址空间

把_inprogress版本切换成_checkpointed

    

  

  

    

    

    
Test Book

  

  

    
背景

    
系统为了加速对象的访问，通常都会增加一层缓存，以缓解下一层IO的瓶颈，OS的page cache和数据库的buffer pool都基于此。

    
但对象的删除，如果同步清理对象的缓存的话，不仅大大增加了延时，同时可能因为缓存过大导致IO blooding。所以针对缓存的清理，都会采用lazy drop的优化，下面我们就来对比下percona和官方针对drop table的lazy drop 优化。

    
假设使用
innodb_file_per_table
为表创建独立的tablespace，在业务处理过程中，有删除表的动作，会发现
drop table
操作不仅仅持续比较长，而且在删除过程中，实例的QPS也有所降低，主要是因为在清理buffer pool过程中，持有buffer pool的mutex导致，percona server在5.1版本开始引入 
lazy drop table
来消除drop table过程中带来的影响，但也并没有完全消除，MySQL 官方在5.5.23以后也引入了 
lazy drop table
 来优化drop 操作，下面我们就来对比一下这两种方式的差异。

    
值得一提的是：在日常的运维中，drop的操作并非核心需求，我们也都建议DBA在 off-peak 时间去做这样的操作。

    
同步模式

    
在讨论lazy模式之前，我们先看看MySQL在5.5.23版本之前的处理方式即同步模式:

当要drop table的时候，会在整个操作过程中持有buffer pool的mutex，然后扫描两次LRU链表，把属于这个table的page失效掉，buffer pool中page的个数越多，持有mutex时间就会越长，对在线业务的影响也就越明显。

    
简短看下核心处理代码:

    

      
fil_delete_tablespace
buf_LRU_invalidate_tablespace(
     ulint     id)     /*!< in: space id */
{
     ulint     i;()
     for (i = 0; i < srv_buf_pool_instances; i++) {
          buf_pool_t*     buf_pool;

          buf_pool = buf_pool_from_array(i);
          buf_LRU_drop_page_hash_for_tablespace(buf_pool, id);
          buf_LRU_invalidate_tablespace_buf_pool_instance(buf_pool, id);
     }
}

    

    

      

buf_LRU_drop_page_hash_for_tablespace
会扫描一次LRU list，需要从adaptive hash中删除对要删除的表的page的引用；

      

buf_LRU_invalidate_tablespace_buf_pool_instance
会扫描一次LRU list:

如果是dirty block，需要从flush list remove掉，然后从page hash中删除，最后从LRU list中删除。

    

    
可以看到，这种同步清理掉内存结构的操作，在业务高峰期，对系统的吞吐能力会产生不小的波动。

    
Percona lazy模式

    
percona实现了一个
lazy drop table
模式，使用参数控制：

    

      
mysql> show global variables like '%lazy%';
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| innodb_lazy_drop_table | 0     |
+------------------------+-------+

    

    
其处理drop table的过程如下:

    

      
持有buffer pool的lru list mutex锁；

      
开始扫描LRU list中的page；

如果这个page属于要删除的table的，就设置一个flag，表示这个page所在的表正在被删除

      
释放lru list mutex锁；

      
持有一个adaptive hash index的shared latch；

      
开始扫描buffer pool中的block；

      
如果这个page被AHI索引；

释放AHI 锁

持有page的exclusive lock

删除AHI中索引这个page的entries

释放page锁

持有AHI的shared lock进行下一个page的判断

    

    
相比较同步模式，Percona的lazy drop table在扫描lru list过程中，只set了一个flag，随后在lru正常的淘汰过程中或者flush dirty block的时候如果碰到这中block，直接就做删除处理了，这也就是lazy的核心。

    
其核心代码如下：

    

      
buf_LRU_mark_space_was_deleted(
     ulint     id)     /*!< in: space id */
{
     ulint     i;

/* 这一部分代码就是持有lru链表mutex，进行第一步，第二步操作。*/
     for (i = 0; i < srv_buf_pool_instances; i++) {
          mutex_enter(&buf_pool->LRU_list_mutex);
          while (bpage != NULL) {
               if (buf_page_get_space(bpage) == id)
                    bpage->space_was_being_deleted = TRUE;
          }
          mutex_exit(&buf_pool->LRU_list_mutex);

/* 这里扫描的是buf_pool中的chunk，也就是启动的时候，根据buffer pool的大小预分配好的blocks，不能更改，
   所以并不需要持有buffer pool mutex，或者lru list mutex。
*/
          btr_search_s_lock_all();
          chunk = buf_pool->chunks;
          for (j = buf_pool->n_chunks; j--; chunk++) {
               buf_block_t*     block     = chunk->blocks;
               for (k = chunk->size; k--; block++) {
                    if (buf_block_get_state(block)
                        != BUF_BLOCK_FILE_PAGE
                        || !block->index
                        || buf_page_get_space(&block->page) != id) {
                         continue;
                    }
/* 这里把AHI的锁释放掉了，但在btr_search_drop_page_hash_index中会持有AHI的lock对AHI结构进行变更。*/
                    btr_search_s_unlock_all();
                    rw_lock_x_lock(&block->lock);
                    btr_search_drop_page_hash_index(block, NULL);
                    rw_lock_x_unlock(&block->lock);

                    btr_search_s_lock_all();
               }
          }
          btr_search_s_unlock_all();
     }
}

    

    
MySQL lazy模式

    
在MySQL 5.5.23以后的版本，也实现了一个
lazy drop table
的方式，和percona的方式有所区别，下面来看一下具体的过程：

    

      
持有
buffer pool mutex
；

      
持有buffer pool中的
flush list mutex
；

      
开始扫描flush list；

如果dirty page属于drop table，那么就直接从flush list中remove掉；

如果删除的page个数超过了
#define BUF_LRU_DROP_SEARCH_SIZE 1024
 这个数目的话，释放
buffer pool mutex
，
flush list mutex
，释放cpu资源；

释放
flush list mutex
；

释放
buffer pool mutex
；

强制通过pthread_yield进行一次OS context switch，释放剩余的cpu时间片；

重新持有
buffer pool mutex
；

重新持有
flush list mutext
；

      
释放
flush list mutex
；

      
释放
buffer pool mutex
；

    

    
相比较percona的lazy方式，这里扫描的是dirty block，在LRU list中进行淘汰的时候，就不再判断当前fil_space是否存在的问题了，因为不牵涉到写入。

    
这里边有两个相关的bug，
bug#51325
、
bug#64284
，有兴趣可以参考一下。

    
其核心的代码如下：

    

      
buf_LRU_flush_or_remove_pages(id, BUF_REMOVE_FLUSH_NO_WRITE, 0);

buf_pool_mutex_enter(buf_pool);

err = buf_flush_or_remove_pages(buf_pool, id, flush, trx);
......
buf_pool_mutex_exit(buf_pool);

/* BUF_REMOVE_FLUSH_NO_WRITE：意思表示，只对dirty block进行remove操作，不做写入。

    

    
对比

    
从上面的percona和oracle的MySQL版本比较来看，percona是持有了
LRU list mutex
和
AHI lock
，而MySQL官方版本是持有了
buffer pool mutex
和
flush list mutex
，从锁的保护范围来看，
buffer pool mutex
直观上瓶颈会比较明显，但具体还要跟表的大小、dirty block的比例来看，如果dirty block比较少的话，官方版本并不扫描LRU list，所以可能持有的时间并不会太久。

    
Percona的开发人员还针对这两个不同版本进行了Benchmarks， 大家可以看下他们测试出来的结果:

    
这个图是 MySQL 官方版本测试在系统压力下，进行频繁drop table的系统抖动:

    

      

    

    
这个图是 Percona 版本测试在系统压力下，进行频繁drop table的系统抖动:

    

      

    

    
但对于这样的测试，小编想说，哪个DBA/开发人员这么变态，要这么频繁的drop table -_-||

  

  

    

    

    
Test Book

  

  

    
背景

    
server A,B 为双主结构，对于 server A 当gtid_next设置为AUTOMATIC时，A上执行的事务在binlog刷盘时递增获取事务的gtid，从而保证了在binlog中属于A的gtid是连续递增的。

    
A的binlog在B应用时，B会通过 Executed_Gtid_Set 来记录A的binlog在B的执行情况。而A的binlog中gtid是连续的，从而

    

      

        
B未开启并行复制，B依次应用binlog，Executed_Gtid_Set中B的gtid集合应该是连续的，如
A:1-100
；

      

      
B开启并行复制此时，B并发应用binlog，Executed_Gtid_Set中B的gtid集合末端可能会出现不连续的情况，如
A:1-92:94-96:98-100
，

但是如果在A停止写入，B和A完全同步的情况下，Executed_Gtid_Set中B的gtid集合应该是连续的。

    

    
以下分析均基于双主结构。

    
GTID不一致产生原因

    
并行复制

    
前面提到，并行复制时，Executed_Gtid_Set 尾部可能出现正常的空洞。这种不一致可以忽略，最终会一致的。

    
change master导致gtid丢失

    
change master重新指定binlog的拉取位置会导致主备gtid不一致。

    
考虑如下情况

    
主库：

    

      
create table t1(c1 int) engine=innodb;
create view v1 as select * from t1;

    

    
备库：

    

      
set sql_log_bin=0;
drop view v1;

    

    
主库：

    

      
create view v1 as select * from t1;

    

    
执行失败但仍然会生成binlog, binlog中error_code=1050，参考之前月报
binlog event 中的 error code
。

    

      
#160118 17:33:11 server id 2219317521  end_log_pos 172885 CRC32 0xb6f4693d  Query   thread_id=76714 exec_time=0 error_code=1050
SET TIMESTAMP=1453109591/*!*/;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `v1` AS select * from t1

    

    
备库：

    

      
show slave status\G
Last_SQL_Error: Query caused different errors on master and slave.     Error on master: message (format)='Table '%-.192s' already exists' error code=1050 ; Error on slave: actual message='no error', error code=0\. Default database: 'zy'. Query: 'CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `v1` AS select * from t1'

    

    
备库create view执行成功，而与预期应出现的binlog error_code不一致导致备库复制中断。

    
那么如何修复此类错误呢？首先想到这个binlog事件是可以跳过的，因此尝试使用跳过空事务的方式来尝试修复。实际上，这种修复方式是不起作用的。

    
构造空事务来忽略相同gtid，执行start slave；后SQL线程执行过程如下

    

      
首先预检查gtid是否执行，如果此gtid已执行，语句直接返回成功0;

      
然后检查预期error_code是否为1050，而实际error_code=0，还是不一致。

    

    
因此，此类错误通过构造空事务方式无法修复。

    
此时就需要change master 方式指向失败事件的下一个位点。然后按位点的方式(master_auto_position=0)来拉binlog。

    

      
stop slave;
change master to  master_log_file='xxxx', master_log_pos=xxx,master_auto_position=0;
start slave;

    

    
至此失败已经修复，但show slave status可以看到 Executed_Gtid_Set 存在空洞，gtid已经不一致了。

    
此时，我们可以通过skip空事务的方式来弥补这个空洞。

    
下一步，我们可以选择修改为通过gtid方式来拉binlog(此步必须在弥补空洞之后）。

    

      
stop slave;
change master to master_auto_position=1;
start slave;

    

    
主机crash

    
主库所在主机crash后，可能导致主库比备库少一些gtid。

    
binlog在写文件时先write，再sync。假设主库在write binlog之后，sync 之前，同时备库也拉取了这些未sync的binlog。此时主库宕机，主库一部分 binlog 未落盘，但这部分binlog已经传到了备库，那么备库会比主库多一些事务。因此主库重启后，重新构造 gtid_executed_set 时会比备库少一些gtid。

    
那些未sync的事务实际处于两阶段提交的prepare状态，重启后这些处于prepare的事务由于没有写binlog会回滚掉。

    
主机宕机HA切换后，新主库会比新备库多一些事务。

    
而实际上新主库会比新备库多一些事务应该没有影响，这些事务是用户发出了commit命令，但主机crash了，没有收到commit的回复，处于未知状态。这些未决事务可以提交也可以回滚！

    
对于以上情况，在binlog没有purge的情况下，结合应用我们可以根据gtid来修复主备不一致的情况，或回滚备库的修改，或者重做主库丢失的事务。

    
gtid不一致的 影响

    
假设备库比主库少一些gtid, 而主库多出来的这些gtid已经purge了。如果用备库做的备份集来恢复出一个实例时，备库会去主库拉取缺少的那些gtid，而那些gtid已经purge了。

这就会导致臭名昭著的1236问题

    

      
Last_IO_Errno: 1236
Last_IO_Error: Got fatal error 1236 from master when reading data from binary log: 'The slave is connecting using CHANGE MASTER TO MASTER_AUTO_POSITION = 1, but the master has purged binary logs containing GTIDs that the slave requires.'

    

    
根据前面的gtid不一致的分析，我们应该提前发现不一致，并及时修复，避免此类情况发生。

    
修复方法

    
这里总结些gtid不一致的修复方法：

    

      
对于可以忽略的gtid事务，可以通过跳过gtid的方式修复；

      
修改GTID_PURGED的方式

先reset master，再设置GTID_PURGED来修复不一致，此种方式需确保主备数据一致的情况下进行，风险较大，酌情考虑。

    

  

  

    

    

    
Test Book

  

  

    
背景

    
有一个功能，是社区官方版”永远”不考虑引入的(参见
PG TODO
，查找”Oracle-style”)，即类似Oracle的Plan Hint。社区开发者的理念是，引入Hint功能，会掩盖优化器本身的问题，导致缺陷不被暴露出来。但对于我们的使用者来讲，遇到某些SQL的查询计划不好，性能出了问题，使用了其他方法又不奏效的情况下，首先的目标还是想尽快解决问题，而Hint就可以在这种时候帮助到我们。可喜的是，通过集成“民间”的 pg_hint_plan 插件（
文档
），RDS for PG已经支持了Hint功能（RDS for PPAS也是支持的）。现在我们来研究一下这个插件如何使用，又是如何做到改变优化器优化过程，让优化器听我们“指挥”的。

    
使用

    
Plan Hint在RDS for PG里面缺省是没有打开的，可以LOAD命令启用：

    

      
postgres=# LOAD 'pg_hint_plan';
LOAD

    

    
但注意这只在会话级别有效，重新连接后将失效。如果想要每次连接都自动启用Hint，可以使用下面的命令（注意必须以RDS的根用户执行，否则会遇到权限错误）。这样下次连接时，Hint就默认启用了。

    

      
postgres=> alter role all set session_preload_libraries = 'pg_hint_plan';
ALTER ROLE

    

    
为了便于说明，我们使用下面的shell脚本来创建2张表：

    

      
for i in `seq 2` ; do

  psql -c "drop table t${i}"
  psql -c "create table t${i}(a int, b int);"
  psql -c "insert into t${i} select generate_series(1,1000), random() *1000+1"
  psql -c "create index t${i}_i_a on t${i}(a)"
  psql -c "create index t${i}_i_b on t${i}(b)"

done

    

    
然后在t1上进行查询，不使用和使用Hint的查询计划分别如下：

    

      
postgres=> explain select * from t1 where a = 1;
                           QUERY PLAN
-----------------------------------------------------------------
 Index Scan using t1_i_a on t1  (cost=0.28..8.29 rows=1 width=8)
   Index Cond: (a = 1)
(2 rows)

postgres=> /*+ SeqScan(t1) */ explain select * from t1 where a = 1;
                    QUERY PLAN
---------------------------------------------------
 Seq Scan on t1  (cost=0.00..17.50 rows=1 width=8)
   Filter: (a = 1)
(2 rows)

    

    
可以看出，利用Hint后，我们成功强制使用了表扫描。Hint一般以SQL注释的形式，出现在SQL的前面，并以/+开头，以/结尾。注意/*和+之间不能有空格。

    
Hint的种类

    
pg_hint_plan插件支持的Hint有很多种，分成如下几类(具体参见
pg_hint_plan文档
）：

    

      
扫描类（Scan Method），指定表的访问路径，举例如下：

--顺序扫描，参数为表名，也可以带模式名
SeqScan(t1)
--索引扫描，参数为表名和索引名，注意两者之间是空格，没有逗号
IndexScan(t1 t1_i_a)
--TID扫描
TidScan(t1)
--禁止顺序扫描
NoSeqScan(t1)
--禁止索引扫描
NoIndexScan(t1)

连接类（Join Method），指定表连接的方法，举例如下：

NestLoop(t1 t2)
MergeJoin(t1 t2)
HashJoin(t1 t2)

连接顺序类（Join Order），指定连接的顺序，举例如下：
--使t3和t1先连接，最后和t2连接
Leading(t2 (t3 t1))

SET类，即改变任意的GUC变量，举例如下：
--改变random_page_cost
Set(random_page_cost 3.0)

ROW类型，改变表的连接结果集的估计大小，举例如下:
--将t1和t2的连接结果的估计大小扩大10倍
Rows(t1 t2 *10)

    

    
内核实现

    
看完了形形色色的Hint，我们会想，这些Hint是怎么改变复杂的优化器逻辑，使其生成我们需要的查询计划的呢？我们从其源码看起（源码可以从
这里
下载）。

    
插件主要的代码集中在pg_hint_plan.c里面。从其中
PG_init
函数的代码可以看出，它利用了
planner_hook
（优化器的函数钩子，实际上是全局变量，存放函数地址，可以被插件更改，换成插件自定义函数的地址），用
pg_hint_plan_planner
取代了原来的优化器逻辑。这样PG在处理一个SQL时，将调用
pg_hint_plan_planner
来做优化。而
pg_hint_plan_planner
会调用
get_hints_from_comment
，来读取Hint，并调用
create_hintstate
进行语法分析。这里要说明的是，
create_hintstate
遇到一张表上的多个同类型Hint（包括重复的Hint），只保留最后一个，前面的会忽略。

    
另外，还有两个函数钩子被利用：
get_relation_info_hook
 和 
join_search_hook
。这两个钩子分别被修改指向了
pg_hint_plan_get_relation_info
和
pg_hint_plan_join_search
。前者是在优化器处理基本表（非视图、非函数的表）获取表信息时被调用，调用栈如下：

    

      
query_planner -> add_base_rels_to_query -> build_simple_rel -> get_relation_info -> get_relation_info_hook(即pg_hint_plan_get_relation_info)

    

    
这个
pg_hint_plan_get_relation_info
做了什么呢？仔细看会惊讶的发现，它是用来删除索引的！对，它在优化器获取表的基本信息后被调用，然后其从基本信息删除了那些在Hint中未使用的索引。例如，t1上有两个索引t1_i_a和t1_i_b，如果指定了IndexScan(t1 t_i_b)这个Hint，那么t1_i_a的索引信息在这里被删除，这样在后续的优化中，就永远不会考虑t1_i_a这个索引了！

    
再看
pg_hint_plan_join_search
，其被调用的位置如下：

    

      
query_planner -> make_one_rel -> make_rel_from_joinlist ->join_search_hook(即pg_hint_plan_join_search)

    

    
可见，它是在为一个SQL语句生成连接结果时被调用，其输入为待连接的表，输出为连接后生成的表及其最优的查询计划。它主要做了两件事：

    

      

        
调用
rebuild_scan_path
重新生成基本表的访问路径。为什么要重新生成呢？因为在基本表的访问计划生成阶段，扫描类的Hint并未实际起作用（只是对索引做过删除处理）。例如，即使指定了IndexScan(t1 t1_i_a)，但外部的GUC变量
enable_indexscan
被设置为了off，在这里也只会看到一个表扫描（SeqScan）的查询计划。因此这里需要重新设置好GUC变量（例如如果遇到IndexScan Hint，需要把GUC变量enable_indexscan重置为on），再做一遍访问计划。由于基本表一般数量较少，访问计划也只需再生成一次，所以此步开销是可接受的；

      

      
调用
pg_hint_plan_standard_join_search
生成连接的计划。这里是应用连接方法和连接顺序Hint的地方。要想改变连接方法或顺序，需要进一步修改优化器的整个逻辑，但优化器没那么多的预定义钩子可用了，采用函数钩子的方法不可行。于是，插件便“自备”了优化器的主流程代码（其实是从同版本的PG里面拷贝出来的），见插件代码中的core.c和make_join_rel.c两个文件。里面很多地方是被插件修改过的。其中核心的是修改对
add_paths_to_joinrel
的调用，使优化器实际调用
add_paths_to_joinrel_wrapper
。这个函数是用于为输入的两张表（可能是连接生成的中间表），生成一个连接计划。可以看到
add_paths_to_joinrel_wrapper
会先去查找有没有对应的Hint，如果有就直接利用，并舍弃掉不符合Hint的连接方法和顺序（这是连接顺序Hint其作用的地方）。

    

    
可以看到，此插件的实现并不复杂，它巧妙利用了优化器优化流程中的关键点，来应用Hint，达到固定查询计划的目的。

    
性能测试

    
从内核实现可以看出，指定Hint后会带来如下开销：基本表的访问路径要生成两次；每次连接两个中间表时，要检查是否有对应的Hint；很多地方需要反复更新GUC变量来影响计划生成。当然，由于直接指定了表的连接方法、顺序等，减少了生成的中间计划，这一点又节省了很多开销。所以，对使用Hint后的编译时间是否比原来长，不能一概而论。下面我们对Hint造成的编译开销做一下粗略测试。测试用例如下：

    

      
\timing

DO $$DECLARE count int;
BEGIN
    count := 1;
    LOOP
        count := count + 1;

        begin

            EXECUTE 'explain select * from t1,t2,t3,t4,t5,t6,t7,t8 where t1.a=t2.b and t2.a=t3.b and t3.a=t4.b and t4.a=t5.b and t5.a=t6.b and t6.a=t7.b and t7.a=t8.b';

            IF count > 10000 THEN
                EXIT;
            END IF;
        exception when others then

        end;
    END LOOP;

END$$;

DO $$DECLARE count int;
BEGIN
    count := 1;
    LOOP
        count := count + 1;

        begin

            EXECUTE '/*+  IndexScan(t1 t1_i_a) IndexScan(t2 t2_i_a) IndexScan(t3 t3_i_a) IndexScan(t4 t4_i_a) IndexScan(t5 t5_i_a) IndexScan(t6 t6_i_a) IndexScan(t7 t7_i_a) IndexScan(t8 t8_i_a)  Leading ( t1  t2  t3  t4  t5  t6  t7  t8 )  */ explain select * from t1,t2,t3,t4,t5,t6,t7,t8 where t1.a=t2.b and t2.a=t3.b and t3.a=t4.b and t4.a=t5.b and t5.a=t6.b and t6.a=t7.b and t7.a=t8.b' ;

            IF count > 10000 THEN
                EXIT;
            END IF;
        exception when others then

        end;
    END LOOP;

END$$;

    

    
这里我们使用了8张表，每张表都只有a、b两个int字段。用两个DO语句，每个都执行同一SQL语句10000次。一个DO语句是不带Hint的，另一个带了较复杂的Hint。测试结果，不带Hint的执行耗时17秒左右，带Hint的14秒左右。即带Hint的反而编译时间更短（注意这里只执行了explain，为真正执行SQL语句）。

  

  

    

    

    
Test Book

  

  

    
背景

    
上一期月报
MariaDB on Power8
我介绍了下 MariaDB 为 Power 处理器所做的一些优化，但是并没有给出实际测试的效果，这次月报我们借到了一台Power8的机器，有机会亲自试一把 MariaDB 在 Power 上的表现。

    
环境

    
一切不交代测试场景的Benchmark都是Benchmarketing。

    
因为Power和Intel之间对标的CPU型号我无法得知，因此这个测试仅仅用来观察MariaDB/MySQL在Power和Intel之间一些特质的差异，而非性能的直接对比。

    
Power 这边我们拿到的是 PowerVM 虚拟化的32核Power8机器，Intel这边用的是我们日常测试的E5-2630机型，虚拟机 vs 物理机，两者的价格我也没有数据，所以不要直接对比性能，不要直接对比性能，不要直接对比性能！

    
Power战队

    
处理器规格：

    

      
processor   : 0
cpu     : POWER8 (architected), altivec supported
clock       : 3425.000000MHz
revision    : 2.1 (pvr 004b 0201)

    

    
处理器核数：

    

      
[root@plx sysbench]# cat /proc/cpuinfo  | grep processor | wc -l
32

    

    
内存：

    

      
[root@plx sysbench]# free -g
              total        used        free      shared  buff/cache   available
Mem:             30           7           3           0          19          22
Swap:            15           0          15

    

    
Intel战队

    
处理器规格：

    

      
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 45
model name  : Intel(R) Xeon(R) CPU E5-2630 0 @ 2.30GHz
stepping    : 7
cpu MHz     : 2294.709
cache size  : 15360 KB
physical id : 0
siblings    : 12
core id     : 0
cpu cores   : 6
apicid      : 0
initial apicid  : 0
fpu     : yes
fpu_exception   : yes
cpuid level : 13
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 x2apic popcnt aes xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips    : 4589.41
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

    

    
处理器核数：

    

      
$cat /proc/cpuinfo  | grep processor | wc -l
24

    

    
内存：

    

      
$free -g
             total       used       free     shared    buffers     cached
Mem:           189         53        135          0          0          2
-/+ buffers/cache:         50        138
Swap:            1          0          1

    

    
CPU理论性能测试

    
首先我们用sysbench简单测试下CPU的计算能力。

    
测试命令：

    

      
sysbench --test=cpu --cpu-max-prime=20000 --num-threads=$num run

    

    
我在每个平台上至少执行了3次测试，只有连续三次测试结果差异极小的时候，才认为最后一次测试结果有效。因为Power8是一台虚拟机，并不能保证宿主机任何时候都只有我在用。

    
下面是原始测试数据的表格：

    
Power CPU理论测试

    

      

        

          
线程

          
总耗时(s)

          
平均延时(ms)

          
95%延时(ms)

        

      

      

        

          
1

          
201.67

          
20.17

          
20.19

        

        

          
4

          
66.61

          
26.64

          
33.18

        

        

          
8

          
59.90

          
47.90

          
106.78

        

        

          
16

          
49.18

          
78.62

          
119.75

        

        

          
32

          
37.37

          
119.36

          
119.86

        

        

          
64

          
37.37

          
237.32

          
349.90

        

        

          
128

          
37.38

          
469.16

          
619.61

        

        

          
512

          
37.38

          
1671.31

          
2179.63

        

      

    

    
Intel CPU理论测试

    

      

        

          
线程

          
总耗时(s)

          
平均延时(ms)

          
95%延时(ms)

        

      

      

        

          
1

          
827.08

          
82.71

          
83.02

        

        

          
4

          
206.97

          
82.77

          
83.24

        

        

          
8

          
103.45

          
82.72

          
83.14

        

        

          
16

          
60.02

          
95.96

          
114.39

        

        

          
32

          
47.52

          
151.89

          
230.74

        

        

          
64

          
47.53

          
303.26

          
350.64

        

        

          
128

          
47.53

          
604.46

          
695.92

        

        

          
512

          
47.53

          
2360.40

          
2759.46

        

      

    

    
CPU理论性能对比

    
（注：比值指的是相同线程数下，Intel耗时是Power的多少倍）

    

      

        

          
线程

          
Power总耗时(s)

          
Intel总耗时(s)

          
比值

        

      

      

        

          
1

          
201.67

          
827.08

          
4.10

        

        

          
4

          
66.61

          
206.97

          
3.11

        

        

          
8

          
59.90

          
103.45

          
1.73

        

        

          
16

          
49.18

          
60.02

          
1.22

        

        

          
32

          
37.37

          
47.52

          
1.27

        

        

          
64

          
37.37

          
47.53

          
1.27

        

        

          
128

          
37.38

          
47.53

          
1.27

        

        

          
512

          
37.38

          
47.53

          
1.27

        

      

    

    
从上面三个图我们可以总结一些硬件上的特性：

    

      
单核心效率Power要高于Intel。3.425GHz 的 Power8 耗时是 2.6GHZ 的 E5-2630 的 1/4，CPU频率只有1.3倍的差异；

      
并发足够高时，性能差异并没有那么大，耗时稳定在1.27倍左右。而核心数Power也是Intel的1.33倍。

    

    
场景

    
本次测试共有三种场景：

    

      
MariaDB 10.1.10 on Power

      
MariaDB 10.1.10 on Intel

      
RDS MySQL 5.6.16 on Intel

    

    
为何没有 MySQL on Power 呢，因为编译不过。。。

    
Buffer Pool全部为16G，数据文件大小为8G上下，保证数据可以全部载入内存。

    
测试命令：

    

      
./sysbench --db-dirver=mysql --mysql-host=127.0.0.1 --mysql-port=3001 --mysql-user=root --test=tests/db/select.lua  --mysql-table-engine=innodb --oltp-table-size=500000  --oltp-tables-count=64 --max-time=1800 --max-requests=2000000000 --num-threads=$num run

    

    
为什么只测读？因为Power主机和Intel主机上使用的硬盘不一样，HDD vs. SDD，测写就完全没有意义了，HDD会被SSD吊打。

    
因为做过PREPARE之后就直接开测，没有关过MySQL，因此测试时数据都是在内存中的，不会产生物理IO。

    
下面是测试结果原始数据的表格:

（注：TPS变动比例指当前线程数下的TPS相对于上一轮测试的TPS的比值）

    
MariaDB on Power

    

      

        

          
线程

          
TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
TPS变动比例

        

      

      

        

          
1

          
14279.19

          
0.07

          
0.08

          

        

        

          
4

          
41563.43

          
0.09

          
0.12

          
291.08%

        

        

          
8

          
63601.75

          
0.12

          
0.18

          
153.02%

        

        

          
16

          
94346.29

          
0.17

          
0.23

          
148.34%

        

        

          
32

          
119444.32

          
0.26

          
0.45

          
126.60%

        

        

          
64

          
129451.95

          
0.49

          
0.82

          
108.38%

        

        

          
128

          
123414.89

          
1.03

          
1.75

          
95.34%

        

        

          
256

          
112408.11

          
2.27

          
4.00

          
91.08%

        

        

          
512

          
113163.74

          
4.52

          
8.59

          
100.67%

        

        

          
768

          
105875.56

          
7.24

          
15.53

          
93.56%

        

      

    

    
RDS MySQL on Intel

    

      

        

          
线程

          
TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
TPS变动比例

        

      

      

        

          
1

          
10742.70

          
0.09

          
0.11

          

        

        

          
4

          
40061.40

          
0.10

          
0.12

          
372.92%

        

        

          
8

          
68544.88

          
0.12

          
0.14

          
171.10%

        

        

          
16

          
109659.96

          
0.14

          
0.16

          
159.98%

        

        

          
32

          
149450.12

          
0.21

          
0.39

          
136.29%

        

        

          
64

          
145596.26

          
0.44

          
0.75

          
97.42%

        

        

          
128

          
139679.85

          
0.91

          
4.96

          
95.94%

        

        

          
256

          
141907.18

          
1.80

          
11.73

          
101.59%

        

        

          
512

          
61794.87

          
8.28

          
25.79

          
43.55%

        

      

    

    
MariaDB on Intel

    

      

        

          
线程

          
TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
TPS变动比例

        

      

      

        

          
1

          
9673.51

          
0.10

          
0.12

          

        

        

          
4

          
37394.20

          
0.11

          
0.13

          
386.56%

        

        

          
8

          
47347.03

          
0.17

          
0.19

          
126.62%

        

        

          
16

          
107496.94

          
0.15

          
0.18

          
227.04%

        

        

          
32

          
140805.33

          
0.22

          
0.35

          
130.99%

        

        

          
64

          
137045.70

          
0.46

          
0.66

          
97.33%

        

        

          
128

          
138472.96

          
0.92

          
0.36

          
101.04%

        

        

          
256

          
134908.32

          
1.90

          
7.23

          
97.43%

        

        

          
512

          
131814.55

          
3.88

          
19.04

          
97.71%

        

      

    

    
下面是对比的表格：

    
MySQL vs MariaDB on Intel

    
(注：变化率是指MariaDB的数值相对于MySQL的数值的比值的百分比)

    

      

        

          
线程

          
MySQL TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
MariaDB TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
TPS变化率

          
平均延时变化率

          
95%延时变化率

        

      

      

        

          
1

          
10742.70

          
0.09

          
0.11

          
9673.51

          
0.10

          
0.12

          
90.05%

          
111.11%

          
109.09%

        

        

          
4

          
40061.40

          
0.10

          
0.12

          
37394.20

          
0.11

          
0.13

          
93.34%

          
110.00%

          
108.33%

        

        

          
8

          
68544.88

          
0.12

          
0.14

          
47347.03

          
0.17

          
0.19

          
69.07%

          
141.67%

          
135.71%

        

        

          
16

          
109659.96

          
0.14

          
0.16

          
107496.94

          
0.15

          
0.18

          
98.03%

          
107.14%

          
112.50%

        

        

          
32

          
149450.12

          
0.21

          
0.39

          
140805.33

          
0.22

          
0.35

          
94.22%

          
104.76%

          
89.74%

        

        

          
64

          
145596.26

          
0.44

          
0.75

          
137045.70

          
0.46

          
0.66

          
94.13%

          
104.55%

          
88.00%

        

        

          
128

          
139679.85

          
0.91

          
4.96

          
138472.96

          
0.92

          
0.36

          
99.14%

          
101.10%

          
7.26%

        

        

          
256

          
141907.18

          
1.80

          
11.73

          
134908.32

          
1.90

          
7.23

          
95.07%

          
105.56%

          
61.64%

        

        

          
512

          
61794.87

          
8.28

          
25.79

          
131814.55

          
3.88

          
19.04

          
213.31%

          
46.86%

          
73.83%

        

      

    

    
MariaDB on Intel vs Power

    
(注：变化率是指Power平台的数值相对于Intel平台的数值的比值的百分比)

    

      

        

          
线程

          
Intel TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
Power TPS

          
平均耗时(ms)

          
95%耗时(ms)

          
TPS变化率

          
平均延时变化率

          
95%延时变化率

        

      

      

        

          
1

          
9673.51

          
0.10

          
0.12

          
14279.19

          
0.07

          
0.08

          
147.61%

          
70.00%

          
66.67%

        

        

          
4

          
37394.20

          
0.11

          
0.13

          
41563.43

          
0.09

          
0.12

          
111.15%

          
81.82%

          
92.31%

        

        

          
8

          
47347.03

          
0.17

          
0.19

          
63601.75

          
0.12

          
0.18

          
134.33%

          
70.59%

          
94.74%

        

        

          
16

          
107496.94

          
0.15

          
0.18

          
94346.29

          
0.17

          
0.23

          
87.77%

          
113.33%

          
127.78%

        

        

          
32

          
140805.33

          
0.22

          
0.35

          
119444.32

          
0.26

          
0.45

          
84.83%

          
118.18%

          
128.57%

        

        

          
64

          
137045.70

          
0.46

          
0.66

          
129451.95

          
0.49

          
0.82

          
94.46%

          
106.52%

          
124.24%

        

        

          
128

          
138472.96

          
0.92

          
0.36

          
123414.89

          
1.03

          
1.75

          
89.13%

          
111.96%

          
486.11%

        

        

          
256

          
134908.32

          
1.90

          
7.23

          
112408.11

          
2.27

          
4.00

          
83.32%

          
119.47%

          
55.33%

        

        

          
512

          
131814.55

          
3.88

          
19.04

          
113163.74

          
4.52

          
8.59

          
85.85%

          
116.49%

          
45.12%

        

      

    

    
这个测试结果跟上一篇月报中IBM给出的官方测试对比有很大差异。

    
我们就来看看这些测试结果反映了些什么问题：

    

      
如果只看 MariaDB on Power 和 MySQL on Intel 的结果，我会以为 Power 在高并发时性能更稳定，但看了 MariaDB on Intel 的测试结果之后，意识到这是 MariaDB Thread Pool 的功劳，并不是Power平台的优势；

      
对比 MySQL on Intel 和 MariaDB on Intel 可以明显的看到，16并发和256并发是明显的分水岭，16并发之前MySQL优势明显，16并发到256并发之间两者差距不大，256并发之后，MariaDB完爆MySQL；

      
看 MariaDB 在 Power 和 Intel 平台下的表现，16并发之前 Power 优势会明显一点，16并发之后 Intel 就追上来了并且超越了 Power。这跟我们上面做的 CPU 理论测试结果差不多，大家可以上去翻表格，16线程之前 Power 效率要高于 Intel，但是之后基本就稳定了；

      
所以，官方的Benchmark永远不可靠，自己动手才是硬道理。

    

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    
前言

    
在前面几期关于 InnoDB Redo 和 Undo 实现的铺垫后，本节我们从上层的角度来阐述 InnoDB 的事务子系统是如何实现的，涉及的内容包括：InnoDB的事务相关模块、如何实现MVCC及ACID、如何进行事务的并发控制、事务系统如何进行管理等相关知识。本文的目的是让读者对事务系统有一个较全面的理解。

    
由于不同版本对事务系统都有改变，本文的所有分析基于当前GA的最新版本MySQL5.7.9，但也会在阐述的过程中，顺带描述之前版本的一些内容。本文也会介绍5.7版本对事务系统的一些优化点。

    
另外尽管 InnoDB 锁系统和事务有着非常密切的联系，但鉴于本文主要介绍事务模块，并且计划中的篇幅已经足够长。而锁系统又是一个非常复杂的模块，将在后面的月报中单独开一篇文章来讲述。

    
在阅读本文之前，强烈建议先阅读下之前两节的内容，因为事务系统和这些模块有着非常紧密的联系：

    

      
MySQL · 引擎特性 · InnoDB undo log 漫游

      

      
MySQL · 引擎特性 · InnoDB redo log漫游

      

      
MySQL · 引擎特性 · InnoDB 崩溃恢复过程

    

    
事务开启

    
InnoDB 提供了多种方式来开启一个事务，最简单的就是以一条 BEGIN 语句开始，也可以以 START TRANSACTION 开启事务，你还可以选择开启一个只读事务还是读写事务。所有显式开启事务的行为都会隐式的将上一条事务提交掉。

    
所有显示开启事务的入口函数均为
trans_begin
，如下列出了几种常用的事务开启方式。

    
BEGIN

    
当以BEGIN开启一个事务时，首先会去检查是否有活跃的事务还未提交，如果没有提交，则调用
ha_commit_trans
提交之前的事务，并释放之前事务持有的MDL锁。

执行BEGIN命令并不会真的去引擎层开启一个事务，仅仅是为当前线程设定标记，表示为显式开启的事务。

    
和BEGIN等效的命令还有“BEGIN WORK”及“START TRANSACTION”。

    
START TRANSACTION READ ONLY

    
使用该选项开启一个只读事务，当以这种形式开启事务时，会为当前线程的
thd->tx_read_only
设置为true。当Server层接受到任何数据更改的SQL时，都会直接拒绝请求，返回错误码
ER_CANT_EXECUTE_IN_READ_ONLY_TRANSACTION
，不会进入引擎层。

    
这个选项可以强约束一个事务为只读的，而只读事务在引擎层可以走优化过的逻辑，相比读写事务的开销更小，例如不用分配事务id、不用分配回滚段、不用维护到全局事务链表中。

    
该事务开启的方式从5.6版本开始引入。我们知道，在MySQL5.6版本中引入的一个对事务模块的重要优化：将全局事务链表拆成了两个链表：一个用于维护只读事务，一个用于维护读写事务。这样我们在构建一个一致性视图时，只需要遍历读写事务链表即可。但是在5.6版本中，InnoDB并不具备事务从只读模式自动转换成读写事务的能力，因此需要用户显式的使用以下两种方式来开启只读事务：

    

      
执行START TRANSACTION READ ONLY

      
或者将变量
tx_read_only
设置为true

    

    
5.7版本引入了模式自动转换的功能，但该语法依然保留了。

    
另外一个有趣的点是，在5.7版本中，你可以通过设置
session_track_transaction_info
变量来跟踪事务的状态，这货主要用于官方的分布式套件(例如fabric)，例如在一个负载均衡系统中，你需要知道哪些 statement 开启或处于一个事务中，哪些 statement 允许连接分配器调度到另外一个 connection。只读事务是一种特殊的事务状态，因此也需要记录到线程的
Transaction_state_tracker
中。

    
关于Session tracker，可以参阅官方
WL#6631
。

    
START TRANSACTION READ WRITE

    
和上述相反，该SQL用于开启读写事务，这也是默认的事务模式。但有一点不同的是，如果当前实例的 read_only 打开了且当前连接不是超级账户，则显示开启读写事务会报错。

    
同样的事务状态
TX_READ_WRITE
也要加入到Session Tracker中。另外包括上述几种显式开启的事务，其标记
TX_EXPLICIT
也加入到session tracker中。

    
读写事务并不意味着一定在引擎层就被认定为读写事务了，5.7版本InnoDB里总是默认一个事务开启时的状态为只读的。举个简单的例子，如果你事务的第一条SQL是只读查询，那么在InnoDB层，它的事务状态就是只读的，如果第二条SQL是更新操作，就将事务转换成读写模式。

    
START TRANSACTION WITH CONSISTENT SNAPSHOT

    
和上面几种方式不同的是，在开启事务时还会顺便创建一个视图（Read View），在InnoDB中，视图用于描述一个事务的可见性范围，也是多版本特性的重要组成部分。

    
这里会进入InnoDB层，调用函数
innobase_start_trx_and_assign_read_view
，注意只有你的隔离级别设置成REPEATABLE READ（可重复读）时，才会显式开启一个Read View，否则会抛出一个warning。

    
使用这种方式开启事务时，事务状态已经被设置成ACTIVE的。

    
状态变量
TX_WITH_SNAPSHOT
会加入到Session Tracker中。

    
AUTOCOMMIT = 0

    
当autocommit设置成0时，就无需显式开启事务，如果你执行多条SQL但不显式的调用COMMIT（或者执行会引起隐式提交的SQL）进行提交，事务将一直存在。通常我们不建议将该变量设置成0，因为很容易由于程序逻辑或使用习惯造成事务长时间不提交。而事务长时间不提交，在MySQL里简直就是噩梦，各种诡异的问题都会纷纷出现。一种典型的场景就是，你开启了一条查询，但由于未提交，导致后续对该表的DDL堵塞住，进而导致随后的所有SQL全部堵塞，简直就是灾难性的后果。

    
另外一种情况是，如果你长时间不提交一个已经构建Read View的事务，purge线程就无法清理一些已经提交的事务锁产生的undo日志，进而导致undo空间膨胀，具体的表现为ibdata文件疯狂膨胀。我们曾在线上观察到好几百G的Ibdata文件。

    
TIPS：所幸的是从5.7版本开始提供了可以在线truncate undo log的功能，前提是开启了独立的undo表空间，并保留了足够的 undo 回滚段配置（默认128个），至少需要35个回滚段。其truncate 原理也比较简单：当purge线程发现一个undo文件超过某个定义的阀值时，如果没有活跃事务引用这个undo文件，就将其设置成不可分配，并直接物理truncate文件。

    
事务提交

    
事务的提交分为两种方式，一种是隐式提交，一种是显式提交。

    
当你显式开启一个新的事务，或者执行一条非临时表的DDL语句时，就会隐式的将上一个事务提交掉。另外一种就是显式的执行“COMMIT” 语句来提交事务。

    
然而，在不同的场景下，MySQL在提交时进行的动作并不相同，这主要是因为 MySQL 是一种服务器层-引擎层的架构，并存在两套日志系统：Binary log及引擎事务日志。MySQL支持两种XA事务方式：隐式XA和显式XA；当然如果关闭binlog，并且仅使用一种事务引擎，就没有XA可言了。

    
关于隐式XA的控制对象，在实例启动时决定使用何种XA模式，如下代码段：

    

      
  if (total_ha_2pc > 1 || (1 == total_ha_2pc && opt_bin_log))
  {
    if (opt_bin_log)
      tc_log= &mysql_bin_log;
    else
      tc_log= &tc_log_mmap;
  }

    

    

      
若打开binlog，且使用了事务引擎，则XA控制对象为
mysql_bin_log
；

      
若关闭了binlog，且存在不止一种事务引擎时，则XA控制对象为
tc_log_mmap
；

      
其他情况，使用
tc_log_dummy
，这种场景下就没有什么XA可言了，无需任何协调者来进行XA。

    

    
这三者是
TC_LOG
的子类，关系如下图所示：

    

      

    

    
TC LOG

    
具体的，包含以下几种类型的XA（不对数据产生变更的只读事务无需走XA）

    
Binlog/Engine XA

    
当开启binlog时, MySQL默认使用该隐式XA模式。 在5.7版本中，事务的提交流程包括：

    
Binlog Prepare

设置
thd->durability_property= HA_IGNORE_DURABILITY
, 表示在innodb prepare时，不刷redo log。

    
InnoDB Prepare （入口函数
innobase_xa_prepare --> trx_prepare
）：

更新InnoDB的undo回滚段，将其设置为Prepare状态（
TRX_UNDO_PREPARED
）。

    
进入组提交 (
ordered_commit
)

    

      

        
Flush Stage：此时形成一组队列，由leader依次为别的线程写binlog文件

在准备写binlog前，会调用
ha_flush_logs
接口，将存储的日志写到最新的LSN，然后再写binlog到文件。这样做的目的是为了提升组提交的效率，具体参阅之前的
一篇月报
。

      

      

        
Sync Stage：如果
sync_binlog
计数超过配置值，则进行一次文件fsync，注意，参数
sync_binlog
的含义不是指的这么多个事务之后做一次fsync，而是这么多组事务队列后做一次fsync。

      

      

        
Semisync Stage (RDS MySQL only)：如果我们在事务commit之前等待备库ACK（设置成AFTER_SYNC模式），用户线程会释放上一个stage的锁，并等待ACk。这意味着在等待ACK的过程中，我们并不堵塞上一个stage的binlog写入，可以增加一定的吞吐量。

      

      
Commit Stage：队列中的事务依次进行innodb commit，将undo头的状态修改为
TRX_UNDO_CACHED
/
TRX_UNDO_TO_FREE
/
TRX_UNDO_TO_PURGE
任意一种 (undo相关知识参阅
之前的月报
)；并释放事务锁，清理读写事务链表、readview等一系列操作。每个事务在commit阶段也会去更新事务页的binlog位点。

    

    
TIPS：如果你关闭了
binlog_order_commits
选项，那么事务就各自进行提交，这种情况下不能保证innodb commit顺序和binlog写入顺序一致，这不会影响到数据一致性，在高并发场景下还能提升一定的吞吐量。但可能影响到物理备份的数据一致性，例如使用 xtrabackup（而不是基于其上的innobackup脚本）依赖于事务页上记录的binlog位点，如果位点发生乱序，就会导致备份的数据不一致。

    
Engine/Engine XA

    
当binlog关闭时，如果事务跨引擎了，就可以在事务引擎间进行XA了，典型的例如InnoDB和TokuDB（在RDS MySQL里已同时支持这两种事务引擎）。当支持超过1种事务引擎时，并且binlog关闭了，就走TC LOG MMAP逻辑。对应的XA控制对象为
tc_log_mmap
。

    
由于需要持久化事务信息以用于重启恢复，因此在该场景下，
tc_log_mmap
模块会创建一个文件，名为tc.log，文件初始化大小为24KB，使用mmap的方式映射到内存中。

    
tc.log 以PAGE来进行划分，每个PAGE大小为8K，至少需要3个PAGE，初始化的文件大小也为3个PAGE（
TC_LOG_MIN_SIZE
），每个Page对应的结构体对象为st_page，因此需要根据page数，完成文件对应的内存控制对象的初始化。初始化第一个page的header，写入magic number以及当前的2PC引擎数（也就是
total_ha_2pc
）

    
下图描述了tc.log的文件结构：

    

      

    

    
tc.log 文件结构

    
在事务执行的过程中，例如遇到第一条数据变更SQL时，会注册一个唯一标识的XID（实际上通过当前查询的query_id来唯一标识），之后直到事务提交，这个XID都不会改变。事务引擎本身在使用undo时，必须加上这个XID标识。

    
在进行事务Prepare阶段，若事务涉及到多个引擎，先在各自引擎里做事务Prepare。

    
然后进入commit阶段，这时候会将XID记录到tc.log中（如上图所示），这类涉及到相对复杂的page选择流程，这里不展开描述，具体的参阅函数
TC_LOG_MMAP::commit

    
在完成记录到tc.log后，就到引擎层各自提交事务。这样即使在引擎提交时失败，我们也可以在crash recovery时，通过读取tc.log记录的xid，指导引擎层将符合XID的事务进行提交。

    
Engine Commit

    
当关闭binlog时，且事务只使用了一个事务引擎时，就无需进行XA了，相应的事务commit的流程也有所不同。

    
首先事务无需进入Prepare状态，因为对单引擎事务做XA没有任何意义。

    
其次，因为没有Prepare状态的保护，事务在commit时需要对事务日志进行持久化。这样才能保证所有成功返回的事务变更， 能够在崩溃恢复时全部完成。

    
显式XA

    
MySQL支持显式的开启一个带命名的XA事务，例如：

    

      
XA BEGIN "xidname"
     do something.....
XA END 'xidname'
XA PREPARE 'xidname'   // 当完成这一步时，如果崩溃恢复，是可以在启动后通过XA RECOVER获得事务信息，并进行显式提交
XA COMMIT 'xidname'    // 完全提交事务

    

    
一个有趣的问题是，在5.7之前的版本中，如果执行XA的过程中，在完成XA PREPARE后，如果kill掉session，事务就丢失了，而不是像崩溃恢复那样，可以直接恢复出来。这主要是因为MySQL对Kill session的行为处理是直接回滚事务。

    
为了解决这个问题，MySQL5.7版本做了不小的改动，将XA的两阶段都记录到了binlog中。这样状态是持久化了的，一次干净的shutdown后，可以通过扫描binlog恢复出XA事务的状态，对于kill session导致的XA事务丢失，逻辑则比较简单：内存中使用一个transaction_cache维护了所有的XA事务，在断开连接调用THD::cleanup时不做回滚，仅设置事务标记即可。

    
具体的参阅我之前写的
这篇月报

    
事务回滚

    
当由于各种原因（例如死锁，或者显式ROLLBACK）需要将事务回滚时，会调用handler接口
ha_rollback_low
，进而调用InnoDB函数
trx_rollback_for_mysql
来回滚事务。回滚的方式是提取undo日志，做逆向操作。

    
由于InnoDB的undo是单独写在表空间中的，本质上和普通的数据页是一样的。如果在事务回滚时，undo页已经被从内存淘汰，回滚操作（特别是大事务变更回滚）就可能伴随大量的磁盘IO。因此InnoDB的回滚效率非常低。有的数据库管理系统，例如PostgreSQL，通过在数据页上冗余数据产生版本链的方式来实现多版本，因此回滚起来非常方便，只需要设置标记即可，但额外带来的问题就是无效数据清理开销。

    
SavePoint管理

    
在事务执行的过程中，你可以通过设置SAVEPOINT的方式来管理事务的执行过程。

    
在介绍Savepoint之前，需要先介绍下
trx_t::undo_no
。在事务每次成功写入一次undo后，这个计数都会递增一次（参阅函数
trx_undo_report_row_operation
）。事务的
undo_no
也会记录到undo page中进行持久化，因此在undo链表上的
undo_no
总是有序递增的。

    
总的来说，主要有以下几种操作类型。

    
设置SAVEPOINT

    
语法：SAVEPOINT sp_name

    
入口函数：
trans_savepoint

    
在事务中设置一个SAVEPOINT，你可以随意命名一个名字，在事务中设置的所有 savepoint 实际上维护了两份链表，一份挂在THD变量上（
thd->get_transaction()->m_savepoints
），包含了基本的savepoint信息及到引擎层的映射，另一份在引擎层的事务对象上（维持在链表
trx_t::trx_savepoints
中）。

    
如下图所示：

    

      

    

    
savepoint 链表

    
总共分为以下几步：

    

      
在增加新的SAVEPOINT时，总是先判断下是否同名的SAVEPOINT已经存在，如果存在，就用后者替换前者；

      
Server层维护的savepoint信息记录了命名信息及MDL锁的savepoint点。其中MDL锁的savepoint，可以实现回滚操作时释放该savepoint之后再获得的MDL锁；

      
在当前线程的Binlog cache中写入设置Savepoint的SQL, 并保存binlog cache中的位点 （
binlog_savepoint_set
）；

      
引擎层的savepoint中记录了最近一次的
trx_t::undo_no
及SAVEPOINT名字。通过这些信息可以准确的定位在设置SAVEPOINT点时Undo位点。（参阅引擎层入口函数：
trx_savepoint_for_mysql
）。

    

    
回滚SAVEPOINT

    
语法：ROLLBACK TO [ SAVEPOINT ] sp_name

入口函数：
trans_rollback_to_savepoint

    
检查点的回滚主要包括：

    

      
如果事务是一个XA事务，且已经处于XA PREPARE状态时是不允许回滚到某个SAVEPOINT的；

      
如果涉及非事务引擎，在binlog中写入回滚SQL，否则直接将binlog cache truncate到之前设置sp时保存的位点。（
binlog_savepoint_rollback
）

      
在引擎层进行回滚（
trx_rollback_to_savepoint_for_mysql
）

根据之前记录的undo_no，可以逆向操作当前事务占用的undo slot上的undo记录来进行回滚。

      
判断是否允许回滚MDL锁：

binlog关闭的情况下，总是允许回滚MDL锁

或者由引擎来确认（
ha_rollback_to_savepoint_can_release_mdl
），同时满足：

InnoDB：如果当前事务不持有任何事务锁（表级或者行级），则认为可以回滚MDL锁

Binlog：如果没有更改非事务引擎，则可以释放MDL锁

    

    
如果允许回滚MDL，则通过之前记录的
st_savepoint::mdl_savepoint
进行回滚

    
释放SAVEPOINT

    
语法为：RELEASE SAVEPOINT sp_name

入口函数：
trans_rollback_to_savepoint

    
顾名思义，就是删除一个SAVEPOINT，操作也很简单，直接根据命名从server层和innodb层的清理掉，并释放对应的内存。

    
隐式SAVEPOINT

    
在InnoDB中，还有一种隐式的savepoint，通过变量
trx_t::last_sql_stat_start
来维护。

    
初始状态下
trx_t::last_sql_stat_start
的值为0，当执行完一条SQL时，会调用函数
trx_mark_sql_stat_end
将当前的
trx_t::undo_no
保存到
trx_t::last_sql_stat_start
中。

    
如果SQL执行失败，就可以据此进行statement级别的回滚操作（
trx_rollback_last_sql_stat_for_mysql
）。

    
无论是显式SAVEPOINT还是隐式SAVEPOINT，都是通过undo_no来指示回滚到哪个事务状态。

    
两个有趣的bug

    

      
bug#79493

    

    
在一个只读事务中，如果设置了SAVEPOINT，任意执行一次
ROLLBACK TO SAVEPOINT
都会将事务从只读模式改变成读写模式。这主要是因为在活跃事务中执行ROLLBACK 操作会强制转换READ-WRITE模式。实际上这是没必要的，因为并没有造成任何的数据变更。

    

      
bug#79596

    

    
这个bug可以认为是一个相当严重的bug：在一个活跃的做过数据变更操作的事务中，任意执行一次ROLLBACK TO SAVEPOINT（即使SAVEPOINT不存在），然后kill掉客户端，会发现事务却提交了，并且没有写到binlog中。这会导致主备的数据不一致。

    
重现步骤如下：

    

      
mysql> create table test (value int) engine=innodb;
Query OK, 0 rows affected (3.88 sec)

mysql> begin;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into test set value = 1;
Query OK, 1 row affected (4.43 sec)

mysql> rollback to savepoint tx_0;
ERROR 1305 (42000): SAVEPOINT tx_0 does not exist
mysql> Killed

    

    
最后一步直接对session的进程kill -9时会导致事务commit。这主要是因为如果直接kill客户端，服务器端在清理线程资源，进行事务回滚时，相关的变量并没有被重设，thd的command类型还是
SQLCOM_ROLLBACK_TO_SAVEPOINT
，在函数
MYSQL_BIN_LOG::rollback
函数中将不会调用
ha_rollback_low
的引擎层回滚逻辑。原因是回滚到某个savepoint有特殊的处理流程，如果是通过ctrl+c的方式关闭client端，实际上会发送一个类型为
COM_QUIT
的command，它会将
thd->lex->sql_command
设置为
SQLCOM_END
，这时候会走正常的回滚逻辑。

    
事务执行管理

    
在事务执行的过程中，需要多个模块来辅助事务的正常执行：

    

      
Server层的MDL锁模块，维持了一个事务过程中所有涉及到的表级锁对象。通过MDL锁，可以堵塞DDL，避免DDL和DML记录binlog乱序；

      
InnoDB的trx_sys子系统，维持了所有的事务状态，包括活跃事务、非活跃事务对象、读写事务链表、负责分配事务id、回滚段、Readview等信息，是事务系统的总控模块；

      
InnoDB的lock_sys子系统，维护事务锁信息，用于对修改数据操作做并发控制，保证了在一个事务中被修改的记录，不可以被另外一个事务修改；

      
InnoDB的log_sys子系统，负责事务redo日志管理模块；

      
InnoDB的purge_sys子系统，则主要用于在事务提交后，进行垃圾回收，以及数据页的无效数据清理。

    

    
总的来说，事务管理模块的架构图，如下图所示：

    

      

    

    
InnoDB 事务管理

    
下面就几个事务模块的关键点展开描述。

    
事务ID

    
在InnoDB中一直维持了一个不断递增的整数，存储在
trx_sys->max_trx_id
中；每次开启一个新的读写事务时，都将该ID分配给事务，同时递增全局计数。事务ID可以看做一个事务的唯一标识。

    
在MySQL5.6及之前的版本中，总是为事务分配ID。但实际上这是没有必要的，毕竟只有做过数据更改的读写事务，我们才需要去根据事务ID判断可见性。因此在MySQL5.7版本中，只有读写事务才会分配事务ID，只读事务的ID默认为0。

    
那么问题来了，怎么去区分不同的只读事务呢？这里在需要输出事务ID时（例如执行
SHOW ENGINE INNODB STATUS
 或者查询INFORMATION_SCHEMA.INNODB_TRX表），使用只读事务对象的指针或上一个常量来标识其唯一性，具体的计算方式见函数
trx_get_id_for_print
。所以如果你show出来的事务ID看起来数字特别庞大，千万不要惊讶。

    
对于全局最大事务ID，每做256次赋值(
TRX_SYS_TRX_ID_WRITE_MARGIN
)就持久化一次到ibdata的事务页(
TRX_SYS_PAGE_NO
)中。

    
已分配的事务ID会加入到全局读写事务ID集合中（
trx_sys->rw_trx_ids
），事务ID和事务对象的map加入到
trx_sys->rw_trx_set
中，这是个有序的集合(
std::set
)，可以用于通过trx id快速定位到对应的事务对象。

    
事务分配得到的ID并不是立刻就被使用了，而是在做了数据修改时，需要创建或重用一个undo slot时，会将当前事务的ID写入到undo page头，状态为
TRX_UNDO_ACTIVE
。这也是崩溃恢复时，InnoDB判断是否有未完成事务的重要依据。

    
在执行数据更改的过程中，如果我们更新的是聚集索引记录，事务ID + 回滚段指针会被写到聚集索引记录中，其他会话可以据此来判断可见性以及是否要回溯undo链。

对于普通的二级索引页更新，则采用回溯聚集索引页的方式来判断可见性（如果需要的话）。关于MVCC，后文会有单独描述。

    
事务链表和集合

    
事务子系统维护了三个不同的链表，用来管理事务对象。

    
trx_sys->mysql_trx_list

包含了所有用户线程的事务对象，即使是未开启的事务对象，只要还没被回收到trx_pool中，都被放在该链表上。当session断开时，事务对象从链表上摘取，并被回收到trx_pool中，以待重用。

    
trx_sys->rw_trx_list

读写事务链表，当开启一个读写事务，或者事务模式转换成读写模式时，会将当前事务加入到读写事务链表中，链表上的事务是按照
trx_t::id
有序的；在事务提交阶段将其从读写事务链表上移除。

    
trx_sys->serialisation_list

序列化事务链表，在事务提交阶段，需要先将事务的undo状态设置为完成，在这之前，获得一个全局序列号
trx->no
，从
trx_sys->max_trx_id
中分配，并将当前事务加入到该链表中。随后更新undo等一系列操作后，因此进入提交阶段的事务并不是trx->id有序的，而是根据trx->no排序。当完成undo更新等操作后，再将事务对象同时从
serialisation_list
和
rw_trx_list
上移除。

    
这里需要说明下
trx_t::no
，这是个不太好理清的概念，从代码逻辑来看，在创建readview时，会用到序列化链表，链表的第一个元素具有最小的
trx_t::no
，会赋值给
ReadView::m_low_limit_no
。purge线程据此创建的readview，只有小于该值的undo，才可以被purge掉。

    
总的来说，
mysql_trx_list
包含了
rw_trx_list
上的事务对象，
rw_trx_list
包含了
serialisation_list
上的事务对象。

    
事务ID集合有两个：

    
trx_sys->rw_trx_ids

记录了当前活跃的读写事务ID集合，主要用于构建ReadView时快速拷贝一个快照

    
trx_sys->rw_trx_set

这是的映射集合，根据trx_id排序，用于通过trx_id快速获得对应的事务对象。一个主要的用途就是用于隐式锁转换，需要为记录中的事务id所对应的事务对象创建记录锁，通过该集合可以快速获得事务对象

    
事务回滚段

    
对于普通的读写事务，总是为其指定一个回滚段（默认128个回滚段）。而对于只读事务，如果使用到了InnoDB临时表，则为其分配(1~32)号回滚段。（回滚段指定参阅函数
trx_assign_rseg_low
）

    
当为事务指定了回滚段后，后续在事务需要写undo页时，就从该回滚段上分别分配两个slot，一个用于
update_undo
，一个用于
insert_undo
。分别处理的原因是事务提交后，update_undo需要purge线程来进行回收，而insert_undo则可以直接被重利用。

    
关于undo相关知识可以参阅之前的
月报

    
事务引用计数

    
在介绍事务引用计数之前，我们首先要了解下什么是隐式锁。所谓隐式锁，其实并不是一个真正的事务锁对象，可以理解为一个标记：对于聚集索引页的更新，记录本身天然带事务ID，对于二级索引页，则在page上记录最近一次更新的最大事务ID，通过回表的方式判断可见性。

    
由于事务锁涉及到全局资源，创建锁的开销高昂，InnoDB对于新插入的记录，在没有冲突的情况下是不创建记录锁的。举个例子，Session 1插入一条记录，并保持未提交状态。另外一个session想更新这条记录，从数据页上读取到这条记录后，发现对应的事务ID还处于活跃状态，根据当前的并发规则，这个更新需要被阻塞住。因此第二个session需要为session 1创建一条记录锁，然后将自己放入等待队列中。

    
在MySQL5.7版本之前，隐式锁转换的逻辑为（函数
lock_rec_convert_impl_to_expl
）

    

      

        
首先判断记录对应的事务ID是否还处于活跃状态

        
聚集索引： 
lock_clust_rec_some_has_impl

二级索引： 
lock_sec_rec_some_has_impl

如果不活跃，说明事务已提交，我们可以对这条记录做任何更改操作，直接返回；否则返回获取的trx_id

      

      
持有lock_sys->mutex；

      
持有trx_sys->mutex ，并获取当前记录中的事务ID对应的内存事务对象trx_t；

      
为该事务创建一个锁对象，并加入到锁队列中；

      
释放lock_sys->mutex。

    

    
上述流程中长时间持有
lock_sys->mutex
，目的是防止在为其转换隐式锁为显式锁时事务被提交掉。尤其是在第三步，同时持有两把大锁去查找事务对象。在5.6官方版本中，这种查找操作还需要遍历链表，开销巨大，推高了临界资源的竞争。

    
因此在5.7中引入事务计数
trx_t::n_ref
来辅助判断，在隐式锁转换时，通过读写事务集合(
rw_trx_set
)快速获得事务对象，同时对
trx_t::n_def
递增。这个过程无需加
lock_sys->mutex
锁。随后再持有Lock_sys->mutex去创建显式锁。在完成创建后，递减
trx_t::n_ref
。

    
为了防止为一个已提交的事务创建显式锁；在事务提交阶段也做了处理：在事务释放事务锁之前，如果引用计数非0，则表示有人正在做隐式锁转换，这里需要等待其完成。(参考函数
lock_trx_release_locks
)。

    
实际上上述修改是在官方优化读写事务链表之前完成的。由于在5.7里已经使用一个有序的集合保存了
trx_id
到
trx_t
的关联，可以非常快速的定位到事务对象，这个优化带来的性能提升已经没那么明显了。

    
关于隐式锁更详细的信息，我们将在之后专门讲述“事务锁”的月报中再单独描述。

    
事务并发控制

    
在MySQL5.7中，由于消除了大量临界资源的竞争，InnoDB只读查询的性能非常优化，几乎可以随着CPU线性扩展。但如果进入到读写混合的场景，就不可避免的使用到一些临界资源，例如事务、锁、日志等子系统。当竞争越激烈，就可能导致性能的下降。通常系统会有个吞吐量和响应时间最优的性能拐点。

    
InnoDB本身提供了并发控制机制，一种是语句级别的并发控制，另外一种是事务提交阶段的并发控制。

    
语句级别的并发通过参数
innodb_thread_concurrency
来控制，表示允许同时在InnoDB层活跃的并发SQL数。

    
每条SQL在进入InnoDB层进行操作之前都需要先递增全局计数，并为当前SQL分配
innodb_concurrency_tickets
个ticket。也就是说，如果当前SQL需要进出InnoDB层很多次（例如一个大查询需要扫描很多行数据时），
innodb_concurrency_tickets
次都可以自由进入InnoDB，无需判断
innodb_thread_concurrency
。当ticket用完时，就需要重新进入，当SQL执行完成后，会将ticket重置为0。

    
如果当前InnoDB层的并发度已满，用户线程就需要等待，目前的实现使用sleep一段时间的方式，sleep的时间是自适应的，但你可以通过参数
innodb_adaptive_max_sleep_delay
来设置一个最大sleep事件，具体的算法参阅函数
srv_conc_enter_innodb_with_atomics
。

    
提到并发控制，另外一个不得不提的问题就是热点更新问题。事务在进入InnoDB层，准备更新一条数据，但发现行记录被其他线程锁住，这时候该线程会强制退出InnoDB并发控制，同时将自己suspend住，进入睡眠等待。如果有大量并发的更新同一条记录，就意味着大量线程进入InnoDB层，访问热点竞争资源锁系统，然后再退出。最终会呈现出大量线程在InnoDB中suspend住，相当于并发控制并没有达到降低临界资源争用的效果。早期我们对该问题的优化就是将线程从堵在InnoDB层，转移到堵在进入InnoDB层时的外部排队中，这样就不涉及到InnoDB的资源争用了。具体的实现是将statement级别的并发控制提升为事务级别的并发控制，因此这个方案的缺陷是对长事务不友好。

    
另外还有一些并发控制方案，例如线程池、水位限流、按pk排队等策略，我们的RDS MySQL也很早就支持了。如果你存在热点争用（例如秒杀场景），并且正在使用RDS MySQL，你可以去咨询售后如何使用这些特性。

    
除了语句级别的并发外，InnoDB也提供了提交阶段的并发控制，主要通过参数
innodb_commit_concurrency
来控制。该参数的默认值为0，表示不控制commit阶段的并发。在进入函数
innobase_commit
时，如果该参数被设置，且当前并发度超过，就需要等待。然而由于当前在默认配置下所有事务都走组提交(
ordered_commit
)，InnoDB层的提交大多数情况下只会有一个活跃线程。你只有关闭binlog或者关闭参数
binlog_order_commits
，这个参数设置才有意义。

    
高优先级事务

    
MySQL5.7 实现了一种高优先级的事务调度方式。当事务处于高优先级模式时，它将永远不会被选作deadlock场景的牺牲者，拥有获得锁的最高优先级，并能kill掉阻塞它的的低优先级事务。这个特性主要是为了支持官方开发的Group Replication Plugin套件，以保证事务总是能在所有的节点上提交。

    
如何使用

目前GA版本还没有提供公共接口来使用该功能，但代码实现都是完备的，如果想使用该功能，直接写一个设置变量的接口即可，非常简单。在server层，每个THD上新增了两个变量来标识事务的优先级：

    

      

THD::tx_priority
 事务级别有效，当两个事务在InnoDB层冲突时，拥有更高值的事务将赢得锁；

      

THD::thd_tx_priority
 线程级别有效，当该变量被设置时，选择该值作为事务优先级，否则选择tx_priority。

    

    
死锁检测

在进行死锁检测时，需要对死锁的两个事务的优先级进行比较，低优先级的总是会被优先回滚掉，以保证高优先级的事务正常执行（
DeadlockChecker::check_and_resolve
）。

    
处理锁等待

在对记录尝试加锁时，如果发现有别的事务和当前事务冲突（
lock_re_other_has_conflicting
），需要判断是否要加入到等待队列中（
RecLock::add_to_wait
）：

    

      

        
如果两个事务都设置了高优先级、但当前事务优先级较低，或者冲突的事务是一个后台进程开启的事务（例如dict_stat线程进行统计信息更新），则立刻失败该事务，并返回DB_DEADLOCK错误码；

      

      
尝试将当前锁对象加入到等待队列中(
RecLock::enqueue_priority
)，高优先级的事务可以跳过锁等待队列(
RecLock::jump_queue
)，被跳过的事务需要被标记为异步回滚状态（
RecLock::mark_trx_for_rollback
），搜集到当前事务的
trx_t::hit_list
链表中。当阻塞当前事务的另外一个事务也处于等待状态、但等待另外一个不同的记录锁时，调用
rollback_blocking_trx
直接回滚掉，否则在进入锁等待之前再调用
trx_kill_blocking
依次回滚。

    

    
这里涉及到事务锁模块，本文不展开描述，下次专门在事务锁相关主题的月报讲述，你可以通过官方
WL#6835
 获取更过关于高优先级事务的信息。

    
trx_t::flush_observer

    
阅读代码时发现这个在5.7版本新加的变量，从它的命名可以看出，其应该和脏页flush相关。
flush_observer
可以认为是一个标记，当某种操作完成时，对于带这种标记的page(
buf_page_t::flush_observer
)，需要保证完全刷到磁盘上。

    
该变量主要解决早期5.7版本建索引耗时太久的
bug#74472
：为表增加索引的操作非常慢，即使表上没几条数据。原因是InnoDB在5.7版本修正了建索引的方式，采用自底向上的构建方式，并在创建索引的过程中关闭了redo，因此在做完加索引操作后，必须将其产生的脏页完全写到磁盘中，才能认为索引构建完毕，所以发起了一次完全的checkpoint，但如果buffer pool中存在大量脏页时，将会非常耗时。

    
为了解决这一问题，引入了
flush_observer
，在建索引之前创建一个
FlushObserver
并分配给事务对象(
trx_set_flush_observer
)，同时传递给
BtrBulk::m_flush_observer
。

    
在构建索引的过程中产生的脏页，通过
mtr_commit
将脏页转移到flush_list上时，顺便标记上flush_observer（
add_dirty_page_to_flush_list —> buf_flush_note_modification
）。

    
当做完索引构建操作后，由于bulk load操作不记redo，需要保证DDL产生的所有脏页都写到磁盘，因此调用
FlushObserver::flush
，将脏页写盘（
buf_LRU_flush_or_remove_pages
）。在做完这一步后，才开始apply online DDL过程中产生的row log(
row_log_apply
)。

    
如果DDL被中断（例如session被kill），也需要调用
FlushObserver::flush
，将这些产生的脏页从内存移除掉，无需写盘。

    
事务对象池

    
为了减少构建事务对象时的内存操作开销，尤其是短连接场景下的性能，InnoDB引入了一个池结构，可以很方便的分配和释放事务对象。实际上事务的事务锁对象也引用了池结构。

    
事务池对应的全局变量为
trx_pools
，初始化为：

    

      
     trx_pools = UT_NEW_NOKEY(trx_pools_t(MAX_TRX_BLOCK_SIZE));

    

    

trx_pools
是操作trx pool的接口，类型为
trx_pools_t
，其定义如下：

    

      
     typedef Pool<trx_t, TrxFactory, TrxPoolLock> trx_pool_t;
     typedef PoolManager<trx_pool_t, TrxPoolManagerLock > trx_pools_t;

    

    
其中，
trx_t
表示事务对象类型，TrxFactory封装了事务的初始化，TrxPoolLock封装了POOL锁的创建、销毁、加锁、解锁，PoolManager封装了池的管理方法。

    
这里涉及到多个类：

    

      
Pool 及 PoolManager 是公共用的类；

      
TrxFactory 和 TrxPoolLock, TrxPoolManagerLock是trx pool私有的类；

      
TrxFactory用于定义池中事务对象的初始化和销毁动作；

      
TrxPoolLock用于定义每个池中对象的互斥锁操作；

      
由于POOL的管理结构支持多个POOL对象，TrxPoolManagerLock用于互斥操作增加POOL对象。支持多个POOL对象的目的是分拆单个POOL对象的锁开销，避免引入热点。因为从POOL中获取和返还对象，都是需要排他锁的。

    

    
相关类的关系如下图所示：

    

      

    

    
事务池相关类

    
InnoDB MVCC实现

    
InnoDB有两个非常重要的模块来实现MVCC，一个是undo日志，用于记录数据的变化轨迹，另外一个是Readview，用于判断该session对哪些数据可见，哪些不可见。实际上我们已经在之前的月报中介绍过这部分内容，这里再简要介绍下。

    
事务视图ReadView

    
前面已经多次提到过ReadView，也就是事务视图，它用于控制数据的可见性。在InnoDB中，只有查询才需要通过Readview来控制可见性，对于DML等数据变更操作，如果操作了不可见的数据，则直接进入锁等待。

    
ReadView包含几个重要的变量：

    

      

ReadView::id
 创建该视图的事务ID；

      

ReadView::m_ids
 创建ReadView时，活跃的读写事务ID数组，有序存储；

      

ReadView::m_low_limit_id
 设置为当前最大事务ID；

      

ReadView::m_up_limit_id
 m_ids集合中的最小值，如果m_ids集合为空，表示当前没有活跃读写事务，则设置为当前最大事务ID。

    

    
很显然ReadView的创建需要在
trx_sys->mutex
的保护下进行，相当于拿到了当时的一个全局事务快照。基于上述变量，我们就可以判断数据页上的记录是否对当前事务可见了。

    
为了管理ReadView，MVCC子系统使用多个链表进行分配、维护、回收ReadView：

    

      

MVCC::m_free
 用于维护空闲的ReadView对象，初始化时创建1024个ReadView对象（
trx_sys_create
），当释放一个活跃的视图时，会将其加到该链表上，以便下次重用；

      

MVCC::m_views
 这里存储了两类视图，一类是当前活跃的视图，另一类是上次被关闭的只读事务视图。后者主要是为了减少视图分配开销。因为当系统的读占大多数时，如果在两次查询中间没有进行过任何读写操作，那我们就可以重用这个ReadView，而无需去持有
trx_sys->mutex
锁重新分配；

    

    
目前自动提交的只读事务或者RR级别下的只读都支持read view缓存，但目前版本还存在的问题是，在RC级别下不支持视图缓存，见
bug#79005
。

    
另外purge系统在开始purge任务时，需去克隆
MVCC::m_views
链表上未被close的最老视图，并在本地视图中将该最老事务的事务ID也加入到不可见的事务DI集合
ReadView::m_ids
中(
MVCC::clone_oldest_view
)。

    
回滚段指针

    
回滚段undo是实现InnoDB MVCC的根基。每次修改聚集索引页上的记录时，变更之前的记录都会写到undo日志中。回滚段指针包括undo log所在的回滚段ID、日志所在的page no、以及page内的偏移量，可以据此找到最近一次修改之前的undo记录，而每条Undo记录又能再次找到之前的变更。

    
当有可能undo被访问到时，purge_sys将不会去清理undo log，如上所述，purge_sys只会去清理最老ReadView不会看到的事务。这意味着，如果你运行了一个长时间的查询SQL，或者以大于RC的隔离级别开启了一个事务视图但没有提交事务，purge系统将一直无法前行，即使你的会话并不活跃。这时候undo日志将无法被及时回收，最直观的后果就是undo空间急剧膨胀。

    
关于undo这里不赘述，详细参阅
之前月报

    
可见性判断

    
如上所述，聚集索引的可见性判断和二级索引的可见性判断略有不同。因为二级索引记录并没有存储事务ID信息，相应的，只是在数据页头存储了最近更新该page的trx_id。

    
对于聚集索引记录，当我们从btree获得一条记录后，先判断（
lock_clust_rec_cons_read_sees
）当前的readview是否满足该记录的可见性：

    

      
如果记录的
trx_id
小于
ReadView::m_up_limit_id
，则说明该事务在创建ReadView时已经提交了，肯定可见；

      
如果记录的
trx_id
大于等于
ReadView::m_low_limit_id
，则说明该事务是创建readview之后开启的，肯定不可见；

      
当
trx_id
在
m_up_limit_id
和
m_low_limit_id
之间时，如果在
ReadView::m_ids
数组中，说明创建readview时该事务是活跃的，其做的变更对当前视图不可见，否则对该
trx_id
的变更可见。

    

    
如果基于上述判断，该数据变更不可见时，就尝试通过undo去构建老版本记录（
row_sel_build_prev_vers_for_mysql -->row_vers_build_for_consistent_read
），直到找到可见的记录，或者到达undo链表头都未找到。

    
注意当隔离级别设置为READ UNCOMMITTED时，不会去构建老版本。

    
如果我们查询得到的是一条二级索引记录：

    

      
首先将page头的
trx_id
和当前视图相比较：如果小于
ReadView::m_up_limit_id
，当前事务肯定可见；否则就需要去找到对应的聚集索引记录（
lock_sec_rec_cons_read_sees
）；

      
如果需要进一步判断，先根据ICP条件，检查是否该记录满足push down的条件，以减少回聚集索引的次数；

      
满足ICP条件，则需要查询聚集索引记录（
row_sel_get_clust_rec_for_mysql
），之后的判断就和上述聚集索引记录的判断一致了。

    

    
在InnoDB中，只有读查询才会去构建ReadView视图，对于类似DML这样的数据更改，无需判断可见性，而是单纯的发现事务锁冲突，直接堵塞操作。

    
隔离级别

    
然而在不同的隔离级别下，可见性的判断有很大的不同。

    

      

        
READ-UNCOMMITTED

在该隔离级别下会读到未提交事务所产生的数据更改，这意味着可以读到脏数据，实际上你可以从函数
row_search_mvcc中
发现，当从btree读到一条记录后，如果隔离级别设置成READ-UNCOMMITTED，根本不会去检查可见性或是查看老版本。这意味着，即使在同一条SQL中，也可能读到不一致的数据。

      

      

        
READ-COMMITTED

在该隔离级别下，可以在SQL级别做到一致性读，当事务中的SQL执行完成时，ReadView被立刻释放了，在执行下一条SQL时再重建ReadView。这意味着如果两次查询之间有别的事务提交了，是可以读到不一致的数据的。

      

      

        
REPEATABLE-READ

可重复读和READ-COMMITTED的不同之处在于，当第一次创建ReadView后（例如事务内执行的第一条SEELCT语句），这个视图就会一直维持到事务结束。也就是说，在事务执行期间的可见性判断不会发生变化，从而实现了事务内的可重复读。

      

      

        
SERIALIZABLE

序列化的隔离是最高等级的隔离级别，当一个事务在对某个表做记录变更操作时，另外一个查询操作就会被该操作堵塞住。同样的，如果某个只读事务开启并查询了某些记录，那么另外一个session对这些记录的更改操作是被堵塞的。内部的实现其实很简单：

        

          
对InnoDB表级别加
LOCK_IS
锁，防止表结构变更操作

          
对查询得到的记录加
LOCK_S
共享锁，这意味着在该隔离级别下，读操作不会互相阻塞。而数据变更操作通常会对记录加
LOCK_X
锁，和
LOCK_S
锁相冲突，InnoDB通过给查询加记录锁的方式来保证了序列化的隔离级别。

        

      

    

    
注意不同的隔离级别下，数据具有不同的隔离性，甚至事务锁的加锁策略也不尽相同，你需要根据自己实际的业务情况来进行选择。

    
一个有趣的可见性问题

    
在READ-COMMITTED隔离级别下，我们考虑如下执行序列：

    

      
Session 1：
mysql> CREATE TABLE t1 (c1 INT PRIMARY KEY, c2 INT, c3 INT, key(c2));
Query OK, 0 rows affected (0.00 sec)

mysql> BEGIN;
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO t1 VALUES (1,2,3);
Query OK, 1 row affected (0.00 sec)

Session 2:
mysql> BEGIN;
Query OK, 0 rows affected (0.00 sec)

mysql> UPDATE t1 SET c3=c3+1 WHERE c3 = 3;    // 扫描聚集索引进行查询，记录不可见，但未被记录锁堵塞
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0

mysql> UPDATE t1 SET c3=c3+1 WHERE c2 = 2;   // 根据二级索引进行查询，记录不可见，且被记录锁堵塞

    

    
查询条件不同，但指向的确是同一条已插入未提交的记录，为什么会有两种不同的表现呢？ 这主要是不同索引在数据检索时的策略不同造成的。

    
实际上session2的第一条update也为session1做了隐式锁转换，但是在返回到
row_search_mvcc
时，会走到如下判断：

    

      
Line 5312~5318,  row0sel.cc:
                        if (UNIV_LIKELY(prebuilt->row_read_type
                                        != ROW_READ_TRY_SEMI_CONSISTENT)
                            || unique_search
                            || index != clust_index) {

                                goto lock_wait_or_error;
                        }

    

    

      
对于第一条和第二条update，
prebuilt->row_read_type
值均为
ROW_READ_TRY_SEMI_CONSISTENT
，不满足第一个条件；

      
均不满足
unique_search
(通过pk，或uk作为where条件进行查询)；

      
第一个使用的聚集索引，三个条件都不满足；而第二个update使用的二级索引，因此走
lock_wait_or_error
的逻辑，进入锁等待。

    

    
第一条update继续往下走，根据undo去构建老版本记录（
row_sel_build_committed_vers_for_mysql
），一条新插入的记录老版本就是空了，所以认为这条更新没有查询到目标记录，从而忽略了锁阻塞的逻辑。

    
如果使用pk或者二级索引作为where条件查询的话，都会走到锁等待条件。

    
推而广之，如果表上没有索引的话，那么对于任意插入的记录，更新操作都见不到插入的记录（但是会为插入操作创建记录锁）。

    
InnoDB ACID

    
本小节针对ACID这四种数据库特性分别进行简单描述。

    
Atomicity （原子性）

    
所谓原子性，就是一个事务要么全部完成变更，要么全部失败。如果在执行过程中失败，回滚操作需要保证“好像”数据库从没执行过这个事务一样。

    
从用户的角度来看，用户发起一个COMMIT语句，要保证事务肯定成功完成了；若发起ROLLBACK语句，则干净的回滚掉事务所有的变更。

从内部实现的角度看，InnoDB对事务过程中的数据变更总是维持了undo log，若用户想要回滚事务，能够通过Undo追溯最老版本的方式，将数据全部回滚回来。若用户需要提交事务，则将提交日志刷到磁盘。

    
Consistency （一致性）

    
一致性指的是数据库需要总是保持一致的状态，即使实例崩溃了，也要能保证数据的一致性，包括内部数据存储的准确性，数据结构（例如btree）不被破坏。InnoDB通过doublewrite buffer 和crash recovery实现了这一点：前者保证数据页的准确性，后者保证恢复时能够将所有的变更apply到数据页上。如果崩溃恢复时存在还未提交的事务，那么根据XA规则提交或者回滚事务。最终实例总能处于一致的状态。

    
另外一种一致性指的是数据之间的约束不应该被事务所改变，例如外键约束。MySQL支持自动检查外键约束，或是做级联操作来保证数据完整性，但另外也提供了选项
foreign_key_checks
，如果您关闭了这个选项，数据间的约束和一致性就会失效。有些情况下，数据的一致性还需要用户的业务逻辑来保证。

    
Isolation （隔离性）

    
隔离性是指多个事务不可以对相同数据同时做修改，事务查看的数据要么就是修改之前的数据，要么就是修改之后的数据。InnoDB支持四种隔离级别，如上文所述，这里不再重复。

    
Durability（持久性）

    
当一个事务完成了，它所做的变更应该持久化到磁盘上，永不丢失。这个特性除了和数据库系统相关外，还和你的硬件条件相关。InnoDB给出了许多选项，你可以为了追求性能而弱化持久性，也可以为了完全的持久性而弱化性能。

    
和大多数DBMS一样，InnoDB 也遵循WAL（Write-Ahead Logging）的原则，在写数据文件前，总是保证日志已经写到了磁盘上。通过Redo日志可以恢复出所有的数据页变更。

    
为了保证数据的正确性，Redo log和数据页都做了checksum校验，防止使用损坏的数据。目前5.7版本默认支持使用CRC32的数据校验算法。

    
为了解决半写的问题，即写一半数据页时实例crash，这时候数据页是损坏的。InnoDB使用double write buffer来解决这个问题，在写数据页到用户表空间之前，总是先持久化到double write buffer，这样即使没有完整写页，我们也可以从double write buffer中将其恢复出来。你可以通过innodb_doublewrite选项来开启或者关闭该特性。

    
InnoDB通过这种机制保证了数据和日志的准确性的。你可以将实例配置成事务提交时将redo日志fsync到磁盘（
innodb_flush_log_at_trx_commit = 1
），数据文件的FLUSH策略（
innodb_flush_method
）修改为0_DIRECT，以此来保证强持久化。你也可以选择更弱化的配置来保证实例的性能。

  

  

    

    

    
Test Book

  

  

    
背景

    
在日常的数据处理中，我们经常会有这样的需求：从一个文本中寻找某个字符串（比如某个单词）。

    
对这个需求，我们可以用类似这样的SQL完成：SELECT * FROM tbl WHERE text LIKE ‘%rds PostgreSQL%’;（找到含有“rds PostgreSQL”的文本）。

    
现在我们考虑一些特殊的情形：

    

      

        
需要查找的文本特别多，特别大；

      

      

        
不做单纯的字符串匹配，而是考虑自然语言的一些特性，比如匹配某一类字符串（域名、人名）或者匹配单词的所有形式（不考虑它的词性及变化，比如have，has，had都匹配出来）；

      

      
对中文自然语言特性的支持。

    

    
那么此时再用以上的 “SELECT … LIKE …” 就不明智了，因为对数据库来说，这样的SQL必然走的是全表扫描，那么当文本特别多、特别大的时候，查找效率就会很低。

    
另外，这样的SQL也不会智能到可以处理自然语言的特性。

    
怎么办呢？PostgreSQL（以下简称PG）提供了强大的全文搜索功能可以满足这样的需求。

    
对文本的预处理

    
全文搜索首先需要对文本预处理，包括3步：

    

      

        
将文本分解成一个个token，这些token可以是数字、单词、域名、人名、email的格式等等。在PG中可以定义一个parser来做这个工作。

      

      

        
将第一步分解成的token标准化，所谓的标准化就是利用一些规则将token分好类（比如人名是一类、域名是一类等等）。标准化后的token我们称之为lexeme。在PG中是通过定义一个词典来做这个工作。PG里最简单的词典simple的标准化过程就是将大写字母转成小写字母。

      

      
对文本打分，优化查找过程，比如对于待查找的词，文本1匹配的数量大于文本2匹配的数量，那么在这个查找过程，文本1的优先级大于文本2的优先级。

    

    
在PG中，以上对文本的预处理可以通过一个函数
to_tsvector
来完成，函数的返回值是tsvector这个数据类型。

    
另外，对于待查找的单词，我们也要用
to_tsquery
这个函数包装起来，函数的返回值是tsquery这个数据类型。

    
一个简单的例子见下面，
to_tsquery
里的参数可以使用运算符(&:与、|:或、!:非)：

    

      
SELECT to_tsvector('fat cats ate fat rats') @@ to_tsquery('fat & rat');
 ?column?
----------
 t

    

    
Quick Start

    
在了解了这些概念之后，我们用实际的例子来玩一玩PG的全文搜索。

    
我们在client端输入以下命令，\dFp显示的是所有的parser，这里只有一个默认parser(default)。

    
\dFp+ default 显示默认parser(default)的详细信息：parse的过程（5个函数），parse的Token类型（asciihword, asciiword…）。

    

      
sbtest=# \dFp
        List of text search parsers
   Schema   |  Name   |     Description
------------+---------+---------------------
 pg_catalog | default | default word parser
(1 row)

sbtest=# \dFp+ default
    Text search parser "pg_catalog.default"
     Method      |    Function    | Description
-----------------+----------------+-------------
 Start parse     | prsd_start     | (internal)
 Get next token  | prsd_nexttoken | (internal)
 End parse       | prsd_end       | (internal)
 Get headline    | prsd_headline  | (internal)
 Get token types | prsd_lextype   | (internal)

        Token types for parser "pg_catalog.default"
   Token name    |               Description
-----------------+------------------------------------------
 asciihword      | Hyphenated word, all ASCII
 asciiword       | Word, all ASCII
 blank           | Space symbols
 email           | Email address
 entity          | XML entity
 file            | File or path name
 float           | Decimal notation
 host            | Host
 hword           | Hyphenated word, all letters
 hword_asciipart | Hyphenated word part, all ASCII
 hword_numpart   | Hyphenated word part, letters and digits
 hword_part      | Hyphenated word part, all letters
 int             | Signed integer
 numhword        | Hyphenated word, letters and digits
 numword         | Word, letters and digits
 protocol        | Protocol head
 sfloat          | Scientific notation
 tag             | XML tag
 uint            | Unsigned integer
 url             | URL
 url_path        | URL path
 version         | Version number
 word            | Word, all letters
(23 rows)

    

    
输入\dF+ english，给出标准化各类英语token时所用到的dictionary：

    

      
sbtest=# \dF+ english
Text search configuration "pg_catalog.english"
Parser: "pg_catalog.default"
      Token      | Dictionaries
-----------------+--------------
 asciihword      | english_stem
 asciiword       | english_stem
 email           | simple
 file            | simple
 float           | simple
 host            | simple
 hword           | english_stem
 hword_asciipart | english_stem
 hword_numpart   | simple
 hword_part      | english_stem
 int             | simple
 numhword        | simple
 numword         | simple
 sfloat          | simple
 uint            | simple
 url             | simple
 url_path        | simple
 version         | simple
 word            | english_stem

    

    
创建以default为parser的配置defcfg，并增加token映射，这里我们只关心email, url, host：

    

      
sbtest=# CREATE TEXT SEARCH CONFIGURATION defcfg (PARSER = default);
CREATE TEXT SEARCH CONFIGURATION
sbtest=# ALTER TEXT SEARCH CONFIGURATION defcfg ADD MAPPING FOR email,url,host WITH simple;
ALTER TEXT SEARCH CONFIGURATION

    

    
建好配置defcfg后，我们看看利用defcfg对文本进行处理的结果。这里使用
to_tsvector
函数，可以看到email，url，host都被识别出来了：

    

      
sbtest=# select to_tsvector('defcfg','xxx yyy xxx@taobao.com yyy@sina.com http://google.com/123 12345 ');
                              to_tsvector
-----------------------------------------------------------------------
 'google.com':4 'google.com/123':3 'xxx@taobao.com':1 'yyy@sina.com':2
(1 row)

    

    
在实际对表内的文本做全文搜索时，一般对目标列建立gin索引（也就是倒排索引，详情见
官方文档
），这样可以加快查询效率，具体操作如下：

    

      
sbtest=# CREATE TABLE t1(c1 text);
CREATE TABLE
sbtest=# CREATE INDEX c1_idx ON t1 USING gin(to_tsvector('defcfg', c1));
CREATE INDEX
sbtest=# \d t1
     Table "public.t1"
 Column | Type | Modifiers
--------+------+-----------
 c1     | text |
Indexes:
    "c1_idx" gin (to_tsvector('defcfg'::regconfig, c1))

    

    
这里我们插入2条文本，并做一些匹配：

    

      
sbtest=# INSERT INTO t1 VALUES('xxx yyy xxx@taobao.com yyy@sina.com http://google.com 12345');
INSERT 0 1
sbtest=# INSERT INTO t1 VALUES('xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345');
INSERT 0 1
sbtest=# select * from t1;
                             c1
-------------------------------------------------------------
 xxx yyy xxx@taobao.com yyy@sina.com http://google.com 12345
 xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345
(2 rows)

sbtest=# select * from t1 where to_tsvector('defcfg',c1) @@ 'google.com';
                             c1
-------------------------------------------------------------
 xxx yyy xxx@taobao.com yyy@sina.com http://google.com 12345
 xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345
(2 rows)

sbtest=# select * from t1 where to_tsvector('defcfg',c1) @@ to_tsquery('google.com & yyy@sina.com');
                             c1
-------------------------------------------------------------
 xxx yyy xxx@taobao.com yyy@sina.com http://google.com 12345
 xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345
(2 rows)

sbtest=# select * from t1 where to_tsvector('defcfg',c1) @@ to_tsquery('google.com & xxx@gmail.com');
                             c1
------------------------------------------------------------
 xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345
(1 row)

    

    
以上的操作都是针对英文，实际上对中文也是支持的，不过会稍微麻烦点，因为中文的token必须通过分词才能产生，所以需要先装分词的组件scws和zhparser，具体可以参考
这篇博文
。

    
结语

    
本文对PG的全文搜索做了一个入门级的介绍，方便用户快速上手，如果需要对全文搜索作更深入的研究，建议阅读
官方文档第12章
。

  

  

    

    

    
Test Book

  

  

    
AliCloudDB MongoDB在开发过程中遇到一个无法正常退出的BUG，由于是Release版本的编译（-O3），debuginfo已经不能很好的展现出堆栈的情况。这时又该如何确定问题所在呢？本篇文章完整的记录了整个排查过程。

    
场景

    
kill命令正常执行，但进程迟迟没有退出。非必现场景，在批量回收资源时比较容易出现，平时开发测试时没有遇到。从场景上看出现的概率并不高，可能是在某种极端条件下才能触发，由于第一次收到报告后没有保留现场，先到官方JIRA平台上去搜相关的BUG，无果，又盲目的尝试了几个场景后只能先Hold住，等待下次出现。

    
排查

    
确认BUG方向

    
很幸运，第二天BUG再次出现，僵尸进程？死循环？死锁？没有收到Kill信号？无数想法蹦出来，迅速登陆机器，查看现场，先从最简单的可能性开始开始排查。

    

ps
 
top
第一套组合拳，排除了僵尸进程可能性，并且TOP显示CPU使用率为0并不高；strace继续跟进查看，也没有发现有系统调用，最后在补一个pstack打印堆栈信息，全部线程都在wait。BUG的排查方向大致确定：线程间资源同步的问题（当然也不能排除是其他的可能性）。

    
确认代码范围

    
详细分析pstack内容，从堆栈信息中看一个长相特别的（其他大部分的线程堆栈都是雷同的）：

    

      
Thread 46 (Thread 0x2b5f079be700 (LWP 613)):
#0  0x000000301800b43c in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
#1  0x0000000000fec763 in boost::thread::join() ()
#2  0x0000000000c8eebc in mongo::repl::ReplicationCoordinatorExternalStateImpl::shutdown() ()
#3  0x0000000000c93fed in mongo::repl::ReplicationCoordinatorImpl::shutdown() ()
#4  0x0000000000ad2463 in mongo::exitCleanly(mongo::ExitCode) ()
#5  0x0000000000f9c176 in ?? ()
#6  0x0000000000feb384 in ?? ()
#7  0x0000003018007851 in start_thread () from /lib64/libpthread.so.0
#8  0x000000300a4e767d in clone () from /lib64/libc.so.6

    

    
从函数名上看起来是MongoDB退出的关键路径，就从这里入手，人肉翻下源码：

    

      
 97 void ReplicationCoordinatorExternalStateImpl::shutdown() {
 98     boost::lock_guard<boost::mutex> lk(_threadMutex);
 99     if (_startedThreads) {
100         log() << "Stopping replication applier threads";
101         _syncSourceFeedback.shutdown();
102         _syncSourceFeedbackThread->join();
103         _applierThread->join();
104         BackgroundSync* bgsync = BackgroundSync::get();
105         bgsync->shutdown();
106         _producerThread->join();
107     }
108 }

    

    
这么多的join，到底是哪个呢。上GDB，我们来看看Thread 46到底在等谁。先加载symbol-file，失败，加载后堆栈变得更乱了，换
disassemble
命令，显示汇编信息：

    

      
   0x0000000000c8ee6b <+75>:    mov    %rsp,%rdi
   0x0000000000c8ee6e <+78>:    callq  0xdc8670 <_ZN5mongo6logger16LogstreamBuilder10makeStreamEv>
   0x0000000000c8ee73 <+83>:    mov    0x20(%rsp),%rdi
   0x0000000000c8ee78 <+88>:    lea    0x86e299(%rip),%rsi        # 0x14fd118
   0x0000000000c8ee7f <+95>:    mov    $0x24,%edx
   0x0000000000c8ee84 <+100>:   callq  0x1456550 <_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l>
   0x0000000000c8ee89 <+105>:   mov    %rsp,%rdi
   0x0000000000c8ee8c <+108>:   callq  0xdc88d0 <_ZN5mongo6logger16LogstreamBuilderD2Ev>
   0x0000000000c8ee91 <+113>:   lea    0x38(%rbp),%rdi
   0x0000000000c8ee95 <+117>:   callq  0xcce810 <_ZN5mongo4repl18SyncSourceFeedback8shutdownEv>
   0x0000000000c8ee9a <+122>:   mov    0xe8(%rbp),%rdi
   0x0000000000c8eea1 <+129>:   test   %rdi,%rdi
   0x0000000000c8eea4 <+132>:   je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eea6 <+134>:   callq  0xfec600 <_ZN5boost6thread4joinEv>
   0x0000000000c8eeab <+139>:   mov    0xf0(%rbp),%rdi
   0x0000000000c8eeb2 <+146>:   test   %rdi,%rdi
   0x0000000000c8eeb5 <+149>:   je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eeb7 <+151>:   callq  0xfec600 <_ZN5boost6thread4joinEv>
=> 0x0000000000c8eebc <+156>:   callq  0xc284a0 <_ZN5mongo4repl14BackgroundSync3getEv>
   0x0000000000c8eec1 <+161>:   mov    %rax,%rdi
   0x0000000000c8eec4 <+164>:   callq  0xc27f60 <_ZN5mongo4repl14BackgroundSync8shutdownEv>
   0x0000000000c8eec9 <+169>:   mov    0xf8(%rbp),%rdi
   0x0000000000c8eed0 <+176>:   test   %rdi,%rdi
   0x0000000000c8eed3 <+179>:   je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eed5 <+181>:   callq  0xfec600 <_ZN5boost6thread4joinEv>
   0x0000000000c8eeda <+186>:   nopw   0x0(%rax,%rax,1)
   0x0000000000c8eee0 <+192>:   mov    %rbx,%rdi
   0x0000000000c8eee3 <+195>:   callq  0x804a38 <pthread_mutex_unlock@plt>
   0x0000000000c8eee8 <+200>:   cmp    $0x4,%eax
   0x0000000000c8eeeb <+203>:   je     0xc8eee0 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+192>
   0x0000000000c8eeed <+205>:   test   %eax,%eax
   0x0000000000c8eeef <+207>:   jne    0xc8ef0f <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+239>
   0x0000000000c8eef1 <+209>:   add    $0x38,%rsp
   0x0000000000c8eef5 <+213>:   pop    %rbx
   0x0000000000c8eef6 <+214>:   pop    %rbp
   0x0000000000c8eef7 <+215>:   pop    %r12
   0x0000000000c8eef9 <+217>:   pop    %r13
   0x0000000000c8eefb <+219>:   retq

    

    
查看
0x0000000000c8eeb7
地址的上下文，通过前后指令的函数符号名确定了目前代码是在
_applierThread->join()
，这里可以思考下是否还有的其他方法获得代码行。

    

_applierThread
 同样也是个线程，如果shutdown在等它，那它又在等谁呢，回头继续查pstack输出，找到相关的堆栈：

    

      
Thread 34 (Thread 0x2b5f0a6d8700 (LWP 1355)):
#0  0x000000301800b43c in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
#1  0x0000000000c2687b in mongo::repl::BackgroundSync::waitUntilPaused() ()
#2  0x0000000000cd192e in mongo::repl::SyncTail::tryPopAndWaitForMore(mongo::OperationContext*, mongo::repl::SyncTail::OpQueue*, mongo::repl::ReplicationCoordinator*) ()
#3  0x0000000000cd2823 in mongo::repl::SyncTail::oplogApplication() ()
#4  0x0000000000ccaaaf in mongo::repl::runSyncThread() ()
#5  0x0000000000feb384 in ?? ()
#6  0x0000003018007851 in start_thread () from /lib64/libpthread.so.0
#7  0x000000300a4e767d in clone () from /lib64/libc.so.6

    

    
注意这里与shutdown的等待是不同的，shutdown是在等待线程退出，而这里是在等待某个条件变量，再次上GDB，查看Thread 34 & backtrace 1, 
info locals
：

    

      
_lastOpTimeFetched = {i = 4, secs = 1448986976}, 
_lastAppliedHash = 3485900536827542548, 
_lastFetchedHash = 3485900536827542548, 
_pause = false, 
_pausedCondition = {internal_mutex = 
    {   __data = 
        {__lock = 0, __count = 0, __owner = 0, __nusers = 1, __kind = 0, __spins = 0, __list = 
            {__prev = 0x0, __next = 0x0}
        },
        __size = '\000' <repeats 12 times>, "\001", '\000' <repeats 26 times>, __align = 0
    }

    

    
找到代码BUG

    
看看代码怎么写的吧：

    

      
469 void BackgroundSync::waitUntilPaused() {
470     boost::unique_lock<boost::mutex> lock(_mutex);
471     while (!_pause) {
472         _pausedCondition.wait(lock);
473     }
474 }

    

    

_pause
变量一直都是0，所以会hang在这里。继续查看代码，跟踪
_pausedCondition
的调用，有两个函数会去唤醒，一个是stop，另一个是shutdown，但shutdown的调用应该在线程退后调用，以便释放资源。

    
同时，再次回过来在pstack中查看
BackgroundSync
的堆栈信息，想看看到底卡在了哪里。结果找不到
BackgroundSync
线程，问题更清晰了，所有
_pausedCondition
条件变量的唤醒，都是在该线程中完成的，如果
BackgroundSync
已经不存在了，一定会hang住。

    
再反复阅读代码，
BackgroundSync
在判断到
inShutdown()
时会自动结束生命周期，但结束后并没有更改
_pause
状态。

    
FIX BUG

    
解决办法是线程最后退出前执行stop函数，修改
_pause
状态，（shutdown会提前释放资源），查看官方最最新代码，确认有同样的修改，反向追踪提交，找到相关
JIRA
，抱怨JIRA的搜索弱爆了。

    
复现和验证

    
为何该BUG出现的频率会非常低呢，主要在判断是否等待的条件上：

    

      
if (replCoord->isWaitingForApplierToDrain()) {
506                 BackgroundSync::get()->waitUntilPaused();
507                 if (peek(&op)) {
508                     // The producer generated a last batch of ops before pausing so return
509                     // false so that we'll come back and apply them before signaling the drain
510                     // is complete.
511                     return false;
512                 }
513                 replCoord->signalDrainComplete(txn);
514             }

    

    

      
1908         case kActionWinElection: {
1909             boost::unique_lock<boost::mutex> lk(_mutex);
1910             _electionId = OID::gen();
1911             _topCoord->processWinElection(_electionId, getNextGlobalOptime());
1912             _isWaitingForDrainToComplete = true;
1913             const PostMemberStateUpdateAction nextAction =
1914                 _updateMemberStateFromTopologyCoordinator_inlock();
1915             invariant(nextAction != kActionWinElection);
1916             lk.unlock();
1917             _performPostMemberStateUpdateAction(nextAction);
1918             break;
1919         }

    

    
也就是说刚刚赢得了选举后会产生
_isWaitingForDrainToComplete == true
状态，恰巧这个时间窗口内进程接受到退出信号。复现的办法就是在
kActionWinElection
的后面加上sleep，以此来延长时间窗口，当然也可以通过GDB BLOCK的方式来复现。

  

  

    

    

    
Test Book

  

  

    
前言

    
很多时候，RDS用户经常会问如何调优RDS MySQL的参数，为了回答这个问题，写一篇blog来进行解释：

    

      
哪一些参数不能修改，那一些参数可以修改；

      
这些提供修改的参数是不是已经是最佳设置，如何才能利用好这些参数；

    

    
哪些参数可以改

    
细心的用户在购买RDS的时候都会看到，不同规格能够提供的最大连接数以及内存是不同的，所以这一些产品规格的限制参数：连接数、内存用户是不能够修改的，如果内存或者连接数出现了瓶颈：

    

      
内存瓶颈：实例会出现OOM，然后导致主备发生切换

      
连接数瓶颈：应用不能新建立连接到数据库

    

    
则需要进行应用优化、慢SQL优化或者进行弹性升级实例规格来解决。

    
还有一些涉及主备数据安全的参数比如
innodb_flush_log_at_trx_commit
、
sync_binlog
、
gtid_mode
、
semi_sync
、
binlog_format
等为了保证主备的数据安全，目前还暂不提供给用户进行修改。

    
除上述的这些参数外，绝大部分的参数都已经由DBA团队和源码团队优化过，用户不需要过多调整线上的参数就可以把数据库比较好的运行起来。但这些参数只是适合大多数的应用场景，个别特殊的场景还是需要个别对待，比如使用了tokudb引擎，这个时候就需要调整tokudb引擎能使用的内存比例(
tokudb_buffer_pool_ratio
)；又比如我的应用特点本身需要很大的一个锁超时时间，那么则需要调整
innodb_lock_wait_timeout
参数的大小以适应应用等等。

    
如何调参数

    
下面我将把控制台中能够修改的一些比较重要的参数给大家介绍一下，这些参数如果设置不当，则可能会出现性能问题或应用报错。

    
open_files_limit

    
作用：该参数用于控制MySQL实例能够同时打开使用的文件句柄数目。

原因：当数据库中的表（MyISAM 引擎表在被访问的时候需要消耗文件描述符，InnoDB引擎会自己管理已经打开的表—
table_open_cache
）打开越来越多后，会消耗分配给每个实例的文件句柄数目，RDS在起初初始化实例的时候设置的
open_files_limit
为8192，当打开的表数目超过该参数则会导致所有的数据库请求报错误。

现象：如果参数设置过小可导致应用报错

[ERROR] /mysqld: Can't open file: './mysql/user.frm' (errno: 24 -Too many open files);

建议：提高
open_files_limit
的值，RDS目前可以支撑最大为65535，，同时建议替换MyISAM存储引擎为InnoDB引擎。

    
back_log

    
作用：MySQL每处理一个连接请求的时候都会对应的创建一个新线程与之对应，那么在主线程创建新线程期间，如果前端应用有大量的短连接请求到达数据库，MySQL 会限制此刻新的连接进入请求队列，由参数
back_log
控制，如果等待的连接数量超过
back_log
，则将不会接受新的连接请求，所以如果需要MySQL能够处理大量的短连接，需要提高此参数的大小。

现象：如果参数过小可能会导致应用报错

SQLSTATE[HY000] [2002] Connection timed out;

建议：提高此参数值的大小，注意需要重启实例，RDS在起初初始化的值的默认值是50，现在初始化值已经调大了3000。

    
innodb_autoinc_lock_mode

    
作用：在MySQL5.1.22后，InnoDB为了解决自增主键锁表的问题，引入了参数
innodb_autoinc_lock_mode
，用于控制自增主键的锁机制，该参数可以设置的值为0/1/2，RDS 默认的参数值为1，表示InnoDB使用轻量级别的mutex锁来获取自增锁，替代最原始的表级锁，但是在load data（包括：INSERT … SELECT, REPLACE … SELECT）场景下会使用自增表锁，这样会则可能导致应用在并发导入数据出现死锁。

现象：如果应用并发使用load data(包括：INSERT … SELECT, REPLACE … SELECT)导入数据的时候出现死锁：

RECORD LOCKS space id xx page no xx n bits xx index PRIMARY of table xx.xx trx id xxx lock_mode X insert intention waiting. TABLE LOCK table xxx.xxx trx id xxxx lock mode AUTO-INC waiting；

建议：建议将参数设置改为2，则表示所有情况插入都使用轻量级别的mutex锁(只针对row模式)，这样就可以避免auto_inc的死锁，同时在INSERT … SELECT 的场景下会提升很大的性能（注意该参数设置为2，binlog的格式需要设置为row）。

    
query_cache_size

    
作用：该参数用于控制MySQL query cache的内存大小；如果MySQL开启query cache，再执行每一个query的时候会先锁住query cache，然后判断是否存在query cache中，如果存在直接返回结果，如果不存在，则再进行引擎查询等操作；同时insert、update和delete这样的操作都会将query cahce失效掉，这种失效还包括结构或者索引的任何变化，cache失效的维护代价较高，会给MySQL带来较大的压力，所以当我们的数据库不是那么频繁的更新的时候，query cache是个好东西，但是如果反过来，写入非常频繁，并集中在某几张表上的时候，那么query cache lock的锁机制会造成很频繁的锁冲突，对于这一张表的写和读会互相等待query cache lock解锁，导致select的查询效率下降。

现象：数据库中有大量的连接状态为checking query cache for query、Waiting for query cache lock、storing result in query cache；

建议：RDS默认是关闭query cache功能的，如果您的实例打开了query cache，当出现上述情况后可以关闭query cache；当然有些情况也可以打开query cache，比如：巧用query cache解决数据库性能问题。

    
net_write_timeout

    
作用：等待将一个block发送给客户端的超时时间。

现象：参数设置过小可能导致客户端报错the last packet successfully received from the server was milliseconds ago，the last packet sent successfully to the server was milliseconds ago。

建议：该参数在RDS中默认设置为60S，一般在网络条件比较差的时，或者客户端处理每个block耗时比较长时，由于
net_write_timeout
设置过小导致的连接中断很容易发生，建议增加该参数的大小；

    
tmp_table_size

    
作用：该参数用于决定内部内存临时表的最大值，每个线程都要分配（实际起限制作用的是
tmp_table_size
和
max_heap_table_size
的最小值），如果内存临时表超出了限制，MySQL就会自动地把它转化为基于磁盘的MyISAM表，优化查询语句的时候，要避免使用临时表，如果实在避免不了的话，要保证这些临时表是存在内存中的。

现象：如果复杂的SQL语句中包含了group by/distinct等不能通过索引进行优化而使用了临时表，则会导致SQL执行时间加长。

建议：如果应用中有很多group by/distinct等语句，同时数据库有足够的内存，可以增大
tmp_table_size
(
max_heap_table_size
)的值，以此来提升查询性能。

    
RDS MySQL 新增参数

    
下面介绍几个比较有用的 RDS MySQL 新增参数。

    
rds_max_tmp_disk_space

    
作用：用于控制MySQL能够使用的临时文件的大小，RDS初始默认值是10G，如果临时文件超出此大小，则会导致应用报错。

现象：The table ‘/home/mysql/dataxxx/tmp/#sql_2db3_1’ is full。

建议：需要先分析一下导致临时文件增加的SQL语句是否能够通过索引或者其他方式进行优化，其次如果确定实例的空间足够，则可以提升此参数的值，以保证SQL能够正常执行。注意此参数需要重启实例；

    
tokudb_buffer_pool_ratio

    
作用：用于控制TokuDB引擎能够使用的buffer内存大小，比如
innodb_buffer_pool_size
设置为1000M，
tokudb_buffer_pool_ratio
设置为50（代表50%），那么tokudb引擎的表能够使用的buffer 内存大小则为500M；

建议：该参数在RDS中默认设置为0，如果RDS中使用tokudb引擎，则建议调大该参数，以此来提升TokuDB引擎表的访问性能。该参数调整需要重启数据库实例。

    
max_statement_time

    
作用：用于控制查询在MySQL的最长执行时间，如果超过该参数设置时间，查询将会自动失败，默认是不限制。

建议：如果用户希望控制数据库中SQL的执行时间，则可以开启该参数，单位是毫秒。

现象：ERROR 3006 (HY000): Query execution was interrupted, max_statement_time exceeded

    
rds_threads_running_high_watermark

    
作用：用于控制MySQL并发的查询数目，比如将
rds_threads_running_high_watermark
该值设置为100，则允许MySQL同时进行的并发查询为100个，超过水位的查询将会被拒绝掉，该参数与
rds_threads_running_ctl_mode
配合使用（默认值为select）。

建议：该参数常常在秒杀或者大并发的场景下使用，对数据库具有较好的保护作用。

  

  

    

    

    
Test Book

  

  

    
前言

    
PostgreSQL standby 可以通过两种方法来激活成为主库：

    

      
trigger file，配置在recovery.conf中。

      
pg_ctl promote发送SIGUSR1信号给postmaster进程。

    

    
同时，PostgreSQL支持快速激活（fast promote）和非快速激活(fallback promote)：

    

      
fast promote 开启数据库读写前，不需要做检查点。而是推到开启读写之后执行一个CHECKPOINT_FORCE检查点。

      
fallback_promote 在开启数据库读写前，需要先做一个检查点，现在这个模式已经不对用户开放，需要修改代码，只是用作调试。

    

    
实现分析

    
激活数据库的代码分析如下：

    
激活过程，根据fast_promote变量判断是否需要先做检查点，再激活。

    

      
src/backend/access/transam/xlog.c
        if (InRecovery)
        {
                if (bgwriterLaunched)
                {
                        if (fast_promote)  // 如果是快速promote，在打开数据库读写前，不需要创建检查点。只需要创建一个recovery结束标记
                        {
                                checkPointLoc = ControlFile->prevCheckPoint;

                                record = ReadCheckpointRecord(xlogreader, checkPointLoc, 1, false);
                                if (record != NULL)
                                {
                                        fast_promoted = true;
                                        CreateEndOfRecoveryRecord();
                                }
                        }

                        if (!fast_promoted)  //  如果是fallback_promote模式，须先创建一个检查点，再开启读写模式。
                                RequestCheckpoint(CHECKPOINT_END_OF_RECOVERY |
                                                                  CHECKPOINT_IMMEDIATE |
                                                                  CHECKPOINT_WAIT);
                }
...

        InRecovery = false;    //  开启读写模式,允许接收用户写请求.

        LWLockAcquire(ControlFileLock, LW_EXCLUSIVE);
        ControlFile->state = DB_IN_PRODUCTION;   //  改写控制文件的数据库状态
        ControlFile->time = (pg_time_t) time(NULL);
        UpdateControlFile();   //  更新控制文件
        LWLockRelease(ControlFileLock);

...
        if (fast_promoted)   //  如果是快速promote，在允许用户写请求后，在这里执行一个检查点。所以提高了数据库的可用时间。
                RequestCheckpoint(CHECKPOINT_FORCE);
......

    

    
通过pg_ctl命令行工具，向postmaster发SIGUSR1信号，通知它激活数据库。

首先会写一个promote文件，告诉postmaster，是fast_promote。

    

      
src/bin/pg_ctl/pg_ctl.c
/*
 * promote
 */

static void
do_promote(void)
{
        FILE       *prmfile;
        pgpid_t         pid;
        struct stat statbuf;

        pid = get_pgpid(false);

......
        sig = SIGUSR1;
        if (kill((pid_t) pid, sig) != 0)  // 发送SIGUSR1信号，通知postmaster激活数据库。
        {
                write_stderr(_("%s: could not send promote signal (PID: %ld): %s\n"),
                                         progname, pid, strerror(errno));
                if (unlink(promote_file) != 0)
                        write_stderr(_("%s: could not remove promote signal file \"%s\": %s\n"),
                                                 progname, promote_file, strerror(errno));
                exit(1);
        }

        print_msg(_("server promoting\n"));
}

    

    
数据恢复时，检查standby是否收到promote请求或是否存在trigger文件。

如果是promote请求，则检查有没有promote文件，或者fallback_promote文件，如果有promote文件，则是fast_promote请求。如果有fallback_promote文件，则不是fast_promote请求（实际上根本不可能检测到fallback_promote文件，因为没有写这个文件的操作）。所以通过pg_ctl promote来激活，一定是fast promote的，即不需要先做检查点再激活。

如果检查到trigger文件，同样也是fast promote激活模式。

    

      
src/backend/access/transam/xlog.c
#define PROMOTE_SIGNAL_FILE             "promote"
#define FALLBACK_PROMOTE_SIGNAL_FILE "fallback_promote"

/*
 * Check to see whether the user-specified trigger file exists and whether a
 * promote request has arrived.  If either condition holds, return true.
 */
static bool
CheckForStandbyTrigger(void)
{
        struct stat stat_buf;
        static bool triggered = false;

        if (triggered)
                return true;

        if (IsPromoteTriggered())   // 检查是否收到pg_ctl promote信号
        {
......
                if (stat(PROMOTE_SIGNAL_FILE, &stat_buf) == 0)    // 先检查promote文件是否存在
                {
                        unlink(PROMOTE_SIGNAL_FILE);
                        unlink(FALLBACK_PROMOTE_SIGNAL_FILE);
                        fast_promote = true;    //  快速promote
                }
                else if (stat(FALLBACK_PROMOTE_SIGNAL_FILE, &stat_buf) == 0)  // 否则再检查fallback_promote文件是否存在
                {
                        unlink(FALLBACK_PROMOTE_SIGNAL_FILE);
                        fast_promote = false;    //  先执行checkpoint再promote
                }

                ereport(LOG, (errmsg("received promote request")));

                ResetPromoteTriggered();
                triggered = true;
                return true;
        }

        if (TriggerFile == NULL)   //  检查recovery.conf是否配置了trigger_file
                return false;

        if (stat(TriggerFile, &stat_buf) == 0)
        {
                ereport(LOG,
                                (errmsg("trigger file found: %s", TriggerFile)));
                unlink(TriggerFile);
                triggered = true;
                fast_promote = true;    //   快速promote
                return true;
        }
        else if (errno != ENOENT)
                ereport(ERROR,
                                (errcode_for_file_access(),
                                 errmsg("could not stat trigger file \"%s\": %m",
                                                TriggerFile)));

        return false;
}

src/backend/postmaster/startup.c
        pqsignal(SIGUSR2, StartupProcTriggerHandler);  // 注册SIGUSR2信号处理函数

/* SIGUSR2: set flag to finish recovery */
static void
StartupProcTriggerHandler(SIGNAL_ARGS)
{
        int                     save_errno = errno;

        promote_triggered = true;
        WakeupRecovery();

        errno = save_errno;
}

bool
IsPromoteTriggered(void)
{
        return promote_triggered;
}

    

    
postmaster收到SIGUSER1信号后，检查是否收到promote信号，判断当前的状态是否处于恢复中的任意状态，然后向startup进程发一个SIGUSR2的信号，触发promote。

    

      
src/backend/postmaster/postmaster.c

        pqsignal(SIGUSR1, sigusr1_handler); /* message from child process */  // 注册SIGUSR1信号处理函数

/*
 * sigusr1_handler - handle signal conditions from child processes
 */
static void
sigusr1_handler(SIGNAL_ARGS)
{
......
        if (CheckPromoteSignal() && StartupPID != 0 &&
                (pmState == PM_STARTUP || pmState == PM_RECOVERY ||
                 pmState == PM_HOT_STANDBY || pmState == PM_WAIT_READONLY))
        {
                /* Tell startup process to finish recovery */
                signal_child(StartupPID, SIGUSR2);  //  向startup进程发SIGUSR2信号，通知它处理promote
        }
......

src/backend/access/transam/xlog.c
/*
 * Check to see if a promote request has arrived. Should be
 * called by postmaster after receiving SIGUSR1.
 */
bool
CheckPromoteSignal(void)
{
        struct stat stat_buf;

        if (stat(PROMOTE_SIGNAL_FILE, &stat_buf) == 0 ||
                stat(FALLBACK_PROMOTE_SIGNAL_FILE, &stat_buf) == 0)
                return true;

        return false;
}

    

    
最后提一点， 9.3以前，曾经出现过pg_ctl promote -m 来指定是否需要fast promote或者fallback promote。

  

  

    

    

    
Test Book

  

  

    
前言

    
很久很久以前，内核君发表了一篇
HA方案·TokuDB热备
的文章，方法很简单：

    

      
SET TOKUDB_CHECKPOINT_LOCK=ON;

      
开始拷贝TokuDB的数据文件(不包含日志文件)；

      
FLUSH TABLES WITH READ LOCK;

      
记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)；

      
UNLOCK TABLES;

      
SET TOKUDB_CHECKPOINT_LOCK=OFF;

    

    
这些步骤可以很方便的嵌入到Percona XtraBackup中，与InnoDB一起工作，目前看是一个比较简单可行的方案。

    
大实例备份恢复问题

    
问题来了。

当某个实例的数据量达到TB级，你会发现备库(基于备份)重搭后，启动会灰常灰常慢，因为他们都在recover redo-log，为什么呢？

    

      
SET TOKUDB_CHECKPOINT_LOCK=ON;

      
开始拷贝TokuDB的数据文件(不包含日志文件)，由于拷贝TB级的数据非常耗时，redo log持续增加甚至上万个

    

    
当TokuDB启动后，扫描和recover这几万个redo log将是灾难性的。

    
解决这个问题比较简单，我们稍微调整下热备的顺序即可：

    

      
SET TOKUDB_CHECKPOINT_LOCK=ON;

      
FLUSH TABLES WITH READ LOCK;

      
记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)；

      
UNLOCK TABLES;

      
开始拷贝TokuDB的数据文件(不包含日志文件) –移动到这里

      
SET TOKUDB_CHECKPOINT_LOCK=OFF;

    

    
这样在拷贝TokuDB数据文件的时候，就跟redo-log没半毛钱关系了，而且拷贝的redo-log数也大大减少！

    
优化改进

    
本以为这样就可以早点下班回家，但问题还是来。

    
某实例有几十万个TokuDB文件(分区表文件)，使用热备的数据备库重搭后，复制过程中偶尔会出现”Duplicate entry … for key ‘PRIMARY’“错误。

    
引起这个错误的原因比较深，触发自TokuDB内部机制。

    
TokuDB每个分区表有数个文件组成（想了解TokuDB数据库文件的请
轻戳这里
），当分区表非常多的时候，打开的文件句柄数会非常多，受限于
open_files_limit
配置，TokuDB底层会触发句柄关闭机制，对当前文件进行checkpoint操作(新数据被刷到磁盘且生效)再做close，这样即使拿到checkpoint锁后，还是有数据被写入，就引发了以上问题。

    
为了解决这个问题，我们在热备的过程中引入一个状态：in_backup = true，防止文件关闭做checkpoint操作，具体的patch见
这里
。

    
这样TokuDB的热备就比较完美了，整个热备过程中，所有的数据文件均处于一个“一致性”状态，所有的操作都在redo-log里，不再污染数据文件。

  

  

    

    

    
Test Book

  

  

    
背景

    
最近处理了几起线上实例表膨胀的问题。表膨胀是指表的数据和索引所占文件系统的空间，在有效数据量并未发生大的变化的情况下，不断增大。PG使用过程中需要特别关注这方面，我们来给大家解析一下表膨胀的原因。

    
表膨胀的直接触发因素是表上的大量更新，如全表的update操作、大量的insert+delete操作等。而我们知道，PG在更新数据时，是不直接删除老数据的。一个update操作执行后，被更改的数据的旧版本也被保留下来，直到对表做vacuum操作的时候，才考虑回收旧版本。做数据更新时，这些旧版本不及时回收就会造成表膨胀。

    
线上实例都配置了autovacuum，有了autovacuum，PG会定期自动启动autovacuum worker进程，执行vacuum回收旧版本，防止表膨胀。但在我们看到的几起表膨胀问题里面，autovacuum几乎每分钟运行一次，仍然没有避免表膨胀，这是为什么呢？

    
表膨胀问题的重现

    
从问题实例的
pg_stat_activity
视图里面，可以发现它们有一个特点，就是有长时间未提交或终止的事务。

    
我们用下面的例子简单模拟一下。先创建一张表，插入一条数据。再建立两个连接，其中一个开启一个事务，执行插入和查询，但不提交；另一个不断执行update操作。

    
控制台A：

    

      
postgres=# begin;
BEGIN
postgres=# insert into test_bloat values(1);
INSERT 0 1
postgres=# select * from test_bloat;
 a
---
 1
 1
(2 rows)

postgres=#

    

    
控制台B：

    

      
postgres=# update test_bloat set a = 1;
UPDATE 1
postgres=# \watch 1
Watch every 1s  Wed Nov 11 17:04:31 2015
....

    

    
过不多久，查看表的大小就会发现它不断增大：

    

      
postgres=# \dt+ test_bloat
                           List of relations
 Schema |    Name    | Type  |     Owner     |    Size    | Description
--------+------------+-------+---------------+------------+-------------
 public | test_bloat | table | guangzhou.zgz | 8192 bytes |
(1 row)

....

postgres=# \dt+ test_bloat
                         List of relations
 Schema |    Name    | Type  |     Owner     | Size  | Description
--------+------------+-------+---------------+-------+-------------
 public | test_bloat | table | guangzhou.zgz | 40 kB |

    

    
查看第一个连接中的事务状态如下：

    

      
postgres=# select * from pg_stat_activity;
-[ RECORD 1 ]----+--------------------------------
datid            | 13003
datname          | postgres
pid              | 113306
usesysid         | 10
usename          | guangzhou.zgz
application_name | psql
client_addr      |
client_hostname  |
client_port      | -1
backend_start    | 2015-11-11 16:45:38.452728+08
xact_start       | 2015-11-11 16:47:00.998929+08
query_start      | 2015-11-11 16:47:43.657035+08
state_change     | 2015-11-11 16:47:43.658001+08
waiting          | f
state            | idle in transaction
backend_xid      | 2431157
backend_xmin     |
query            | select * from test_bloat;

    

    
可以发现，它有两个特点：

    

      
它的状态为“idle in transaction”，这是因为它未提交，又没有正在进行的查询；

      
它的backend_xid不为空，即它有事务号，这是因为它执行了更新操作，插入了一条数据。注意，PG只在发生更新的时候才分配事务ID，没有执行更新操作的事务（即只读事务）是没有backend_xid的。

    

    
测试发现，如果及时将此种事务提交，并不会造成表膨胀。可见正是这些事务导致了旧版本无法回收！

    
为什么旧版本没有被回收

    
我们从代码里面看看，为什么长事务阻止了版本回收？先看看vacuum回收旧版本的代码。vacuum操作由autovacuum worker执行，其调用顺序如下：

    

      
vacuum->vacuum_rel->lazy_vacuum_rel->lazy_scan_heap->heap_page_prune -> heap_prune_chain

    

    
vacuum每次处理一个表；每个表同时只有一个进程进行vacuuum。其中，
lazy_scan_heap
扫描一个表的所有页面，对每个页面调用
heap_page_prune
进行处理。
heap_page_prune
调用
heap_prune_chain
函数来判断，一个旧版本是否可以被回收（即删除）。这里要考虑的一个重要因素是，旧版本是否可能被当前系统里正在进行的事务（活跃事务，即已开始但未提交或终止的事务）需要。
heap_prune_chain
调用了HeapTupleSatisfiesVacuum来对一个数据记录的旧版本（tuple）做这个判断。HeapTupleSatisfiesVacuum里面最重要的一个判断如下：

    

      
if (!TransactionIdPrecedes(HeapTupleHeaderGetRawXmax(tuple), OldestXmin))
    return HEAPTUPLE_RECENTLY_DEAD;

    

    
这个判断实际上是计算当前tuple的xmax是否大于或等于OldestXmin。我们知道，xmax是删除这个tuple的事务ID，而OldestXmin由GetOldestXmin函数计算，是所有活跃事务的ID，以及所有事务的xmin 组成的集合中最小的事务ID。所有ID大于这个OldestXmin的事务，都是“新近”开启的事务，其他事务可能需要读取这个旧版本用于查询，所以不能物理删除，则返回
HEAPTUPLE_RECENTLY_DEAD
，保留此tuple（即不回收）。但如果系统中含有很久之前开启而未提交的事务，并且这个事务由于执行过更新，创建了事务ID（成为“长事务”），那么OldestXmin会非常小，vacuum做上述这个判断时，结果通常为true，即返回
HEAPTUPLE_RECENTLY_DEAD
，这样
heap_prune_chain
将会保留此tuple（旧版本），导致回收无法完成，表膨胀由此发生。

    
需要注意的是，并不是只有更新过数据的事务，长时间不提交会造成表膨胀，只读的事务也是同样的！看下面的case：

    
控制台A：

    

      
postgres=# begin;
BEGIN
postgres=# declare c1 cursor for select * from test_bloat for read only;
DECLARE CURSOR
postgres=#

    

    
控制台B:

    

      
postgres=# select * from pg_stat_activity;
-[ RECORD 1 ]----+--------------------------------------------------------------
datid            | 13003
datname          | postgres
pid              | 110811
usesysid         | 10
usename          | guangzhou.zgz
application_name | psql
client_addr      |
client_hostname  |
client_port      | -1
backend_start    | 2015-11-12 11:01:00.880549+08
xact_start       | 2015-11-12 11:01:32.843927x+08
query_start      | 2015-11-12 11:01:33.87293+08
state_change     | 2015-11-12 11:01:33.873547+08
waiting          | f
state            | idle in transaction
backend_xid      |
backend_xmin     | 2436509
query            | declare c1 cursor for select * from test_bloat for read only;

    

    
我们看到，这个只读事务的xmin是非空的，会被用来做OldestXmin，如果它长时间不完成操作（即cursore不close），就会造成整个数据库的表膨胀！因此，即便是只读事务，也要及时提交；另外，避免在存在大量更新操作的实例上，跑运行时间很长的查询语句。

    
回收膨胀的空间

    
如何回收膨胀的空间？长事务结束后，vacuum会回收一部分旧版本。但它回收数据页内的旧版本后，一般情况下并不能把空间还给操作系统。就是说，表所占的空间没有变化。只有一种情况下，即回收的页处于存储数据的文件（一张表对应一个或多个文件）尾部，并且页内没有事务可见的tuple（即整个页都可以删除）时，会做truncate操作，把尾部的这些页统一从文件中删除，文件大小和表所占空间随之减少。

    
另一种回收膨胀空间的方法是，执行vacuum full  操作。vacuum full命令实际上重建了整张表和上面的索引。它的缺点是，需要长时间锁住整张表，并耗费大量的IO，对应用影响很大。要减少vacuum full锁住表的时间，可以使用社区提供的pg_repack工具。它的原理是基于原表创建一张新表，同时利用触发器，将原表上当前的增量更新不断记录下来。新表建好后，将所记录的增量更新应用到新表，直到新旧表数据完全一致。最后将新旧表表名互换，删除旧表，即完成了表的空间整理操作，回收了空间。

    
避免表膨胀的方法

    
上面看到，表一旦膨胀，空间很难回收回来，所以要尽可能的避免表膨胀。要避免表膨胀，需要注意：

    

      
尽早的、及时的提交事务；

      
设计应用时，要使事务尽量短小；

      
注意配置与应用规模相适应的硬件资源（IO能力、CPU、内存等），并调教好数据库，使其性能最优，避免有些事务因为资源或性能问题长时间无法完成；

      
提交autovacuum，使其能按合理的周期运行。这方面的内容，我们今后专门介绍；

      

        
定期监控系统中是否有长事务，可以使用下面的SQL监控持续时间超过一定时间的事务：

        

          
 select * from pg_stat_activity where state<>'idle' and pg_backend_pid() != pid and (backend_xid is not null or backend_xmin is not null ) and extract(epoch from (now() - xact_start))  > <时间阈值，单位秒> ;

        

      

    

    
只要运用好上述方法，表膨胀是可以有效控制的。正常的表膨胀不会超过原来数据量的20%。

  

  

    

    

    
Test Book

  

  

    
前言

    

上一篇文章
 提过，我们在之后的文章中会从 optimizer 的选项出发，系统的介绍 optimizer 的各个变量，包括变量的原理、作用以及源码实现等，然后再进一步的介绍优化器的工作过程（SQL 语句扁平化处理、索引选择、代价计算、多表连接顺序选择以及物理执行等内容），本期我们先看一下众所周知的 ICP，官方文档请参考
这里
。

    
ICP 测试

    
首先，咱们来看一下打开 ICP 与关闭 ICP 之间的性能区别，以下是测试过程：

    
准备数据：

    

      
create table icp(id int, age int, name varchar(30), memo varchar(600)) engine=innodb;
alter table icp add index aind(age, name, memo);
--let $i= 100000
while ($i)
{
  --eval insert into icp values($i, 1, 'a$i', repeat('a$i', 100))
  --dec $i
}

    

    
PS: MySQL 有一个叫profile的东东，可以用来监视 SQL 语句在各个阶段的执行情况，咱们可以使用这个工具来观察 SQL 语句在各个阶段的运行情况，关于 profile 的详细说明可以参考
官方文档
。

    
打开 ICP 的性能测试：

    

      
set profiling=on;
set optimizer_switch="index_condition_pushdown=on”; （default enabled）
select * from icp where age = 1 and memo like '%9999%';
mysql> show profile cpu,block io for query 7;
+----------------------+-----------+-----------+------------+--------------+---------------+
| Status               | Duration  | CPU_user  | CPU_system | Block_ops_in | Block_ops_out |
+----------------------+-----------+-----------+------------+--------------+---------------+
| executing            |  0.000009 |  0.000000 |   0.000000 |            0 |             0 |
| Sending data         | 3.225383 | 3.507467 |   0.037994 |            0 |             0 |
+----------------------+-----------+-----------+------------+--------------+---------------+
mysql> show session status like '%handler%';show session status like '%handler%';
+----------------------------+--------+
| Handler_read_next          | 19    |
| Handler_read_rnd_next      | 30    |
+----------------------------+--------+
18 rows in set (0.00 sec)

    

    
关闭 ICP 的性能测试：

    

      
mysql> set optimizer_switch="index_condition_pushdown=off”;
mysql> select * from icp where age = 1 and memo like '%9999%';
mysql> show profile cpu, block io for query 20;
+----------------------+----------+----------+------------+--------------+---------------+
| Status               | Duration | CPU_user | CPU_system | Block_ops_in | Block_ops_out |
+----------------------+----------+----------+------------+--------------+---------------+
| Sending data         | 15.327345 | 17.443348 |   0.165975 |            0 |             0 |
+----------------------+----------+----------+------------+--------------+---------------+
15 rows in set, 1 warning (0.00 sec)
mysql> show session status like '%handler%';
+----------------------------+--------+
| Variable_name              | Value  |
+----------------------------+--------+
| Handler_read_next          | 100019 |
| Handler_read_rnd_next      | 47     |
+----------------------------+--------+
18 rows in set (0.01 sec)

    

    
测试结论：由以上测试情况可以看到，在二级索引是复合索引且前面的条件过滤性较低的情况下，打开 ICP 可以有效的降低 server 层和 engine 层之间交互的次数，从而有效的降低在运行时间。

    
ICP 原理

    
5.6 之前，在 SQL 语句的执行过程中，server 层通过 engine 的 api 获取数据，然后再进行 where_cond 的判断（具体判断逻辑在: 
evaluate_join_record
），每一条数据都需要从engine层返回server层做判断。我们回顾一下上面把 ICP 关掉的测试，可以看到 
Handler_read_next
 的值陡增，其原因是第 1 个字段区分度不高，且 memo 字段无法使用索引，造成了类似 index 扫描的的情况，性能较低。

    
5.6 之后，在利用索引扫描的过程中，如果发现 where_cond 中含有这个 index 相关的条件，则将此条件记录在 handler 接口中，在索引扫描的过程中，只有满足索引与handler接口的条件时，才会返回到 server 层做进一步的处理，在前缀索引区分度不够，其它字段区分度高的情况下可以有效的减少 server & engine之间的开销，提升查询性能。

    
ICP 源码实现

    
我们在上小节提到，index condition down 所用的条件是记在handler接口中的，咱们分析一下“记录”的过程是如何实现的。

    
首先，优化器计算代价后会生成一个 JOIN_TAB 的左支树，每一个 JOIN_TAB 包含相关表的指针、表的读取方式、访问表所包含的索引等信息，优化器会在
make_join_readinfo
 中对JOIN_TAB中表的访问方式进行相应的修正，并进一步将 where cond 中和索引相关的条件记录到 table 的句柄中，堆栈如下：

    

      
#0  make_cond_for_index (cond=0x2b69680179e8, table=0x2b6968012100, keyno=0, other_tbls_ok=true)
#1  in push_index_cond (tab=0x2b696802aa48, keyno=0, other_tbls_ok=true, trace_obj=0x2b696413ec30)
#2  in make_join_readinfo (join=0x2b6968017db0, options=0, no_jbuf_after=4294967295)
#3  in JOIN::optimize (this=0x2b6968017db0)
#4  in mysql_execute_select (thd=0x3176760, select_lex=0x3179470, free_join=true)

    

    
其次， 
make_cond_for_index
 是一个递归的过程，对 where_cond中的每一个条件进行判断，对满足条件的 cond 重新组合成一个新的cond，最后将新的 cond 挂在table->file 下面（table->file 指的是操作物理表的接口函数，此变量为thd下私有的，不共享，共享的是tab->table->s），详细参考
make_cond_for_index
 的详细实现，设置的堆栈如下：

    

      
#0  ha_innobase::idx_cond_push (this=0x2b696800e810, keyno=0, idx_cond=0x2b69680179e8)
#1  0x0000000000a60a55 in push_index_cond (tab=0x2b696802aa48, keyno=0, other_tbls_ok=true, trace_obj=0x2b696413ec30)
#2  0x0000000000a6362f in make_join_readinfo (join=0x2b6968017db0, options=0, no_jbuf_after=4294967295)
#3  0x0000000000d9b8bd in JOIN::optimize (this=0x2b6968017db0
#4  0x0000000000a5b9ae in mysql_execute_select (thd=0x3176760, select_lex=0x3179470, free_join=true)

    

    
再次，server 层根据生成的 JOIN_TAB 读取engine层的内容，在engine读取的时候，会进行
index_condition_pushdown
的调用，即 ICP 的调用，堆栈如下：

    

      
#0  Item_func_like::val_int (this=0x2b6978005a28)
#1  0x0000000001187b66 in innobase_index_cond (file=0x2b696800e810)
#2  0x0000000001393566 in row_search_idx_cond_check (mysql_rec=0x2b69680129f0  <incomplete sequence \361>, prebuilt=0x2b69680130f8, rec=0x2b692b56e4cf "\200", offsets=0x2b697008d450)
#3  0x0000000001397e2b in row_search_for_mysql (buf=0x2b69680129f0  <incomplete sequence \361>, mode=2, prebuilt=0x2b69680130f8, match_mode=1, direction=0)
#4  0x00000000011696b9 in ha_innobase::index_read (this=0x2b696800e810, buf=0x2b69680129f0  <incomplete sequence \361>, key_ptr=0x2b697800a660 "", key_len=5, find_flag=HA_READ_KEY_EXACT)
#5  0x00000000006ecc58 in handler::index_read_map (this=0x2b696800e810, buf=0x2b69680129f0  <incomplete sequence \361>, key=0x2b697800a660 "", keypart_map=1, find_flag=HA_READ_KEY_EXACT)
#6  0x00000000006d6bb4 in handler::ha_index_read_map (this=0x2b696800e810, buf=0x2b69680129f0  <incomplete sequence \361>, key=0x2b697800a660 "", keypart_map=1, find_flag=HA_READ_KEY_EXACT)
#7  0x00000000009a1870 in join_read_always_key (tab=0x2b697800a1b8)
#8  0x000000000099d480 in sub_select (join=0x2b6978005df0, join_tab=0x2b697800a1b8, end_of_records=false)
#9  0x000000000099c6c0 in do_select (join=0x2b6978005df0)
#10 0x00000000009980a4 in JOIN::exec (this=0x2b6978005df0)
#11 0x0000000000a5bac0 in mysql_execute_select (thd=0x32801a0, select_lex=0x3282eb0, free_join=true)

    

    
可见在 ICP 的判断是调用相关item的函数的，虽然同是调用 server 层的函数，但是没有 ICP 的调用需要根据主建找到记录，然后再匹配，而有了 ICP 可以省略一次主键查找数据的过程，进而提升效率。

    
ICP 使用限制及问题

    

      
只支持 select 语句；

      
5.6 中只支持 MyISAM 与 InnoDB 引擎;

      
ICP的优化策略可用于range、ref、eq_ref、ref_or_null 类型的访问数据方法；

      
不支持主建索引的 ICP；

      
当 SQL 使用覆盖索引时但只检索部分数据时，ICP 无法使用，详细的分析可以参考 
bug#68554
 中 Olav Sandstå的分析，代码实现部分可以参考 
make_join_readinfo
；

      

        
在查询的时候即使正确的使用索引的前Ｎ个字段（即遵循前缀索引的原则），还是会用到 ICP，无故的多了 ICP 相关的判断，这应该是一个退化的问题，例：

        

          
  mysql> explain select * from icp where age=1 and name = 'a1';
  +----+-------------+-------+------+---------------+------+---------+-------------+------+-----------------------+
  | id | select_type | table | type | possible_keys | key  | key_len | ref         | rows | Extra                 |
  +----+-------------+-------+------+---------------+------+---------+-------------+------+-----------------------+
  |  1 | SIMPLE      | icp   | ref  | aind          | aind | 38      | const,const |    1 | Using index condition |
  +----+-------------+-------+------+---------------+------+---------+-------------+------+-----------------------+
  1 row in set (3.26 sec)

        

      

    

    
PS: engine condition pushdown 是 NDB 使用的，其它引擎不支持。

  

  

    

    

    
Test Book

  

  

    
前言

    
Power平台作为IBM的企业级平台，其稳定性和高效能在业界尤其是大型金融企业有着良好的口碑，MariaDB作为MySQL的重要开源分支，也对IBM Power8平台进行了适配。

    
很幸运我拿到了一台Power8的机器，在Linux on Power上成功编译了MariaDB 10.1版本，不过还没有拿到同规格的PC服务器用于对比，所以本期我先介绍一下MariaDB on Power的一些信息，下期月报我会拿出实测对比数据，并且分析一下MariaDB在Power平台和x86平台上关键路径的效率。

    
关于Power平台

    
与我们常见的x86平台不同，Power平台是RISC架构，而Intel的x86是CISC架构，早期的Mac也是采用PowerPC。

    
RISC相对于CISC，把主要的设计放在最常用的指令上，尽量使这些执行执行更加简单高效，对于不常用的指令，通过组合指令来完成。所以在实现特殊任务时，RISC会比CISC更复杂，但是因为RISC指令简单，可以更轻松的实现更多核数更多流水线来弥补。而且RISC单元电路少，功耗低，整体能耗水平会比CISC好很多。

    
数据库业务属于简单业务，如果一台主机只运行数据库，那么在x86下其实有很多指令集是完全用不上的，所以理论上单位面积更低功耗，更多流水线，更高频率的Power平台运行数据库会更加高效。

    
同时IBM也提供了Linux on Power，并且同时提供了大端、小端两种模式，而不再要求必须是AIX，毕竟Linux大部分人会更熟悉。

    
MariaDB对Power的适配

    
MariaDB迁移到Power8平台不仅仅是简单的修改代码让编译可以通过，当然这也是很重要的。

    
从 git log 中可以看到，官方针对Power和Intel平台的不同，例如
CACHE_LINE_SIZE
的差异，Intel平台是64，Power平台是128。还有
MEMORY_BARRIER
上的差异，也会导致在锁操作和部分IO操作上两个平台会有差异，MariaDB在这部分也做了修改。

    
另外为了能使用IBM Advance Toolchain工具集编译 MariaDB 提升效率，也对代码上做了不少改动以便IBM Advance Toolchain能使用。

    
总之看起来一切都很好，针对很多细节都做了针对性修改。

    
编译中的问题

    
既然广告看起来这么好，那么就亲自动手试一下。

    
在Power on Linux上我下载了MariaDB 10.1.9的源码用GCC编译然而报错了：

    

      
[ 52%] Building CXX object storage/innobase/CMakeFiles/innobase.dir/api/api0api.cc.o
In file included from /root/mariadb-10.1.9/storage/innobase/include/ut0ut.h:36,
 from /root/mariadb-10.1.9/storage/innobase/include/univ.i:636,
 from /root/mariadb-10.1.9/storage/innobase/api/api0api.cc:27:
/root/mariadb-10.1.9/storage/innobase/include/os0sync.h:521:4: error: #error "Unsupported platform"
[ 52%] Building CXX object storage/archive/CMakeFiles/archive.dir/ha_archive.cc.o
In file included from /root/mariadb-10.1.9/storage/innobase/include/ sync0sync.h:837,
 from /root/mariadb-10.1.9/storage/innobase/include/mem0mem.h:34,
 from /root/mariadb-10.1.9/storage/innobase/include/data0data.h:33,
 from /root/mariadb-10.1.9/storage/innobase/include/que0que.h:30,
 from /root/mariadb-10.1.9/storage/innobase/include/api0misc.h:32,
 from /root/mariadb-10.1.9/storage/innobase/api/api0api.cc:38:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic: In function ‘lock_word_t ib_mutex_test_and_set(ib_mutex_t*)’:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic:85: error: ‘os_atomic_test_and_set’ was not declared in this scope
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic: In function ‘void mutex_reset_lock_word(ib_mutex_t*)’:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic:113: error: ‘os_atomic_clear’ was not declared in this scope
make[2]: *** [storage/innobase/CMakeFiles/innobase.dir/api/api0api.cc.o] Error 1
make[1]: *** [storage/innobase/CMakeFiles/innobase.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....

    

    
查看了下报错的代码行：

storage/innobase/include/sync0sync.ic

    

      
ib_mutex_test_and_set(
/*==================*/
        ib_mutex_t*     mutex)  /*!< in: mutex */
{
#if defined(HAVE_ATOMIC_BUILTINS)
        return(os_atomic_test_and_set(&mutex->lock_word));
#else

    

    
storage/innobase/include/os0sync.h

    

      
469 # if defined(HAVE_IB_GCC_ATOMIC_TEST_AND_SET)
470
471 /** Do an atomic test-and-set.
472 @param[in,out]  ptr   Memory location to set to non-zero
473 @return the previous value */
474 inline
475 lock_word_t
476 os_atomic_test_and_set(volatile lock_word_t* ptr)
477 {
478        return(__atomic_test_and_set(ptr, __ATOMIC_ACQUIRE));
479 }
480
481 /** Do an atomic clear.
482 @param[in,out]  ptr   Memory location to set to zero */
483 inline
484 void
485 os_atomic_clear(volatile lock_word_t* ptr)
486 {
487   __atomic_clear(ptr, __ATOMIC_RELEASE);
488 }
489
490 # elif defined(IB_STRONG_MEMORY_MODEL)
491
492 /** Do an atomic test and set.
493 @param[in,out]  ptr   Memory location to set to non-zero
494 @return the previous value */
495 inline
496 lock_word_t
497 os_atomic_test_and_set(volatile lock_word_t* ptr)
498 {
499   return(__sync_lock_test_and_set(ptr, 1));

    

    
可以看到，只有在
HAVE_IB_GCC_ATOMIC_TEST_AND_SET
或
IB_STRONG_MEMORY_MODEL
至少有一个标签打开的情况，
ib_mutex_test_and_set()
中调用的
os_atomic_test_and_set()
函数才会被开启。

    
然而因为RHEL6的原因，在Power8平台上GCC只有
HAVE_ATOMIC_BUILTINS
和
__powerpc__
两个宏（升级到RHEL7可以解决）。因此就出现了这一幕，
ib_mutex_test_and_set
中调用了
os_atomic_test_and_set()
而
os_atomic_test_and_set()
在头文件中没有被定义。修改很简单啦，改成用同一个宏判断就行了。

    
跟官方开发者沟通后这个fix可以解决这个问题

    

      
diff --git a/storage/innobase/include/os0sync.h b/storage/innobase/include/os0sync.h
index 8e4b4f4..e192a3a 100644
--- a/storage/innobase/include/os0sync.h
+++ b/storage/innobase/include/os0sync.h
@@ -487,7 +487,7 @@ os_atomic_clear(volatile lock_word_t* ptr)
    __atomic_clear(ptr, __ATOMIC_RELEASE);
 }

-# elif defined(IB_STRONG_MEMORY_MODEL)
+# elif defined(HAVE_ATOMIC_BUILTINS)

 /** Do an atomic test and set.
 @param[in,out] ptr     Memory location to set to non-zero

    

    
最后说两句

    
虽然官方也是有性能测试结果的，然而显然我们是不能相信官方测试的。因此我还会构造场景针对CPU本身的效能进行测试，下一期大家期待测试结果吧。

    
最后放两张官方的测试结果，看起来还是很牛X的！

    

      

      

      

    

  

  

    

    

    
Test Book

  

  

    
背景

    
MySQL 企业版由 Oracle 公司维护，当然也是收费的。其产品类别也基本和 Oracle 数据库一致，包括标准版、企业版、集群版等。标准版包括基本的特性，价格也会比企业版便宜很多。今天和小编一起来看下 MySQL Enterprise Edition 提供的一些功能，这些功能的源码当然是不开源的，也是企业版的卖点。

    
企业级备份恢复

    
备份

备份工具提供 InnoDB 的联机在线备份，同时 MyISAM 引擎的备份会阻塞写入。联机备份是否阻塞应用，还要根据引擎的特性来定。这点上，Percona 的备份工具 XtraBackup 提供的功能基本没有什么差别，对于 InnoDB 的增量备份，基本上都是根据 page header 的 lsn ，来确定自上次备份以来的变化。对于binlog的备份，基本是文件copy。

    
恢复

只要保留了备份以来的 binlog，就可以根据 binlog 里的时间戳或者xid，来恢复到任意时间点或者事务。

    
开源方案的比较

和 Percona XtraBackup 工具比较，MySQL 企业版提供的备份最大的不同就是：只备份实际的数据, 不会复制未使用的page, 对备份和恢复来说使用更少的读取和写入，相应的备份文件占用更少的空间。

    
对于 XtraBackup 工具，通过读取 ibd 文件，一个 page 一个 page 的备份来说，想要不复制未使用的块，会比较麻烦。对于类似 Oracle 这样的数据库，需要提前规划和分配表空间的方式来说，RMAN 只需要备份使用过的块即可，可能你的表空间100G大小，但只会备份已使用的1G空间。这点上要给企业版的备份工具点赞。

    
总结

从官方的描述来看，企业级的备份工具，在基本功能上和开源的备份工具基本一致，但提供的高级功能还是值得学习的。

    
企业级高可用

    
Oracle 提供的 MySQL 高可用方案，领先开源社区一个身位。

    
MySQL Fabric

    
Fabric高可用

1. mysqlfabric 在 MasterSlave 的基础上，通过故障检测，进行实例角色变化，完成主备切换;

2. MySQL Fabric-aware connector 根据 fabric 的路由信息，来完成应用的切换。

    
Fabric分片功能

connector根据应用提供的分片规则，来完成路由功能。

    
Fabric最大的特性

1. 需要客户端绑定 faric 提供的 connector，完成路由功能，如果你了解过或者使用淘宝开源的 TDDL，基本上就是这种方式，Application 需要引入 TDDL 的 jar 包来使用，只是 TDDL 并不负责主备的切换，通常由运维人员来完成主备故障切换，并漂移VIP；

2. 无代理运行。同三层的 proxy 架构相比，无疑 fabric 的效率肯定高于 proxy。

    
总结

rFabric 提供的两个组件，完成了应用的分片扩展和运维的故障应急功能，但弊端也很明显，对应用不透明。

    
Oracle VM Template

    
Oracle VM Template集成套件提供了以下组件:

    

      
Oracle Enterprise Linux

      
Oracle VM

      
Oracle VM Manager

      
Oracle Cluster File System

      
MySQL DATABASE

    

    
架构图如下所示：

    

      

    

    
Oracle VM Template

    
有没有觉得这个图和 Oracle RAC 非常相似，的确，这是一套基于 share disk 的 cluster 集群，VM Manager 负责实例、VM、物理主机的故障检测和异常恢复。SAN 和 iSCSI 存储系统复杂的分布式锁管理保证数据的完整性和快速切换挂载能力。

    
但从文档的解释来看，和 RAC 还是有一个最大的区别，目前它并没有真正的实现cluster，也就是这套系统只能做到failover，做不到load balance。

    
但这套系统最大的卖点应该是：

它集成了 MySQL 企业版的各种工具，比如 MySQL Enterprise Monitor & Query Analyzer, MySQL Enterprise Backup and MySQL Workbench，加上Oracle VM可以做到快速部署。如官方文档中提到的，比较适合云计算环境。

    
DRBD

    
这个是在存储级别进行数据复制的成熟商业方案，不多做介绍了。

    
总结

    
对于高可用来说，开源工具如 MHA 等一些 HA 工具，可以完成故障检测和角色切换。对于分片功能，各个大公司都会自己维护一套适合自己的中间件。

    
企业级扩展性

    
MySQL线程池

    
针对MySQL的单进程多线程的处理模型，使用线程池、减少连接过多导致的CPU调度开销，官方给出的测试结果：

    

      

    

    
OLTP RW

    

      

    

    
OLTP RO

    
目前开源的社区版本，如 Percona Server 和 MariaDB 都有可以参考和使用的线程池，Aliyun RDS MySQL 分支目前也支持线程池，对于数据库在大并发的情况下保持稳定性和持续的吞吐能力的确效果非常好。

    
企业级安全性

    
外部身份验证

    
使用 MySQL 的PAM plugin，利用PAM 对LDAP、Unix/Linux 和其他系统上的用户进行身份验证。这个就不多介绍了，主要是为了提高系统管理员/DBA的工作效率。

    
加密

    
企业版提供了非对称加密功能，对数据库持久化的数据进行加密:

    

      
数据文件加密，比如 InnoDB 数据文件等；

      
binlog 日志和 redo 日志文件加密。

    

    
网络传输使用数字证书来保证安全性。

    
对于商业的数据库 Oracle、SQLServer 而言，其提供了更为细粒度的加密方案，比如对某个表，对某个 column 进行指定不同的加密算法。

    
SQL 防火墙

    
企业版提供了 SQL Firewall 功能，其工作模式是这样的：

    

      
首先用户创建一个whitelist，whitelist由[ip + user + sql_digest]组成，表示通过这个认证登陆的用户只能执行这些SQL。sql_digest可以参考
上期的月报
回顾一下；

      
SQL在执行的过程中，根据whitelist进行匹配，会得到三种结果：

allow 即在白名单中，允许执行

deny 不再白名单中，拒绝执行

Detect 也就是在SQL Firewall在 detecting 模式的时候，并不直接拒绝非白名单SQL，只是记录可疑 SQL 日志，方便上线之前的试运行。

    

    
SQL Firewall提供了简单、暴力但也非常有效的保护，例如防止 SQL 注入等。

    
审计

    
审计是一项事后的安全防护策略，但也是问题追踪最有效的方式，企业版把 audit_log 作为一个独立的 plugin，用户只要 install audit_log plugin 就可以使用。

    
audit_log提供的参数：

    

      
audit_log_buffer_size 审计日志持久化之前的写入缓冲

      
audit_log_file 审计日志持久化文件

      
audit_log_rotate_on_size 审计日志文件滚动大小

    

    
用户可以看到的审计日志内容包括连接的相关信息、执行的sql、时间等。

    
好了，小编先学习到这，后续下回分解。

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    
前言 && 感想

    
本年度Oralce Open World会议从十月25号到29号，在美国旧金山举行。数万来自全球各地的从业人员涌入Moscone Center，见证一年一度的Oracle生态系统盛事。

    
本次OOW2015的主题都是围绕在Oracle Cloud，云服务应该是Oracle之后的发力点。几场Oracle CTO（前Oracle CEO）Larry的主题演讲也围绕cloud，详细阐述了Oracle Cloud的设计原则，及相关的云产品，其目标直指Amazon和Microsoft的云服务。

    
我在OOW的关注点主要是几场KeyNote以及MySQL相关的Topic。先总结下参会的感受吧：

    

      
Oracle的主场还是集中在Oracle database, Oracle Cloud以及Java。而“不太会赚钱”的MySQL主题则安排的比较少，会场也都是最小的；

      
关于MySQL，前几天MySQL5.7版本在前几天刚刚宣布GA，因此本次会议的官方主题都是关于新版本的特性介绍，新的版本带来了大量新特性（例如GIS、Build-in JSON、新的Fulltext Parser、Generated Column）以及性能优化（复制性能、InnDB读写性能），大量内部锁竞争的移除，使得新版本MySQL能够在多核环境下更好的Scale Up，发挥硬件的性能；

      
大部分内容都是已有的技术，并没有什么新的黑科技；

      
也有几家美国公司来介绍他们如何使用MySQL，但类似Facebook、Twitter这样的MySQL重度用户且对社区有很大贡献的公司却集体缺席，不得不说是个很大的遗憾；

      
从这几家公司使用MySQL的情况来看，我感觉阿里在MySQL领域的工作绝对是首屈一指的，没有多少公司像我们这样把MySQL玩的这么深入，这么深度的修改源码来适应我们的环境。明年如果有机会，不管谁去参加，我觉得都可以考虑去做几个主题演讲，宣传公司在MySQL社区的影响力；

      
从交流了解到，美国很多互联网公司都选择把服务器托管在AWS上。未来阿里云的国际化，需要把我们的技术影响力扩展到国外，才能争取到这样的用户。

    

    
以下是这五天期间我关注的几个Topic，主要从Oracle 、MySQL官方演讲、业界使用三个方面划分。

    
Oracle主题

    
Oracle OpenWorld Welcome Keynote [KEY10818]

    
Larry Ellison, Executive Chairman of the Board and Chief Technology Officer, Oracle

Brian Krzanich, CEO, Intel Corporation

    

      
视频链接

    

    
当天第一场重磅keynote，由intel的CEO主持，这次会议着重强调Intel和Oracle的深度合作带来的价值，顺便开刷了下IBM在云计算领域的落伍。最后压轴的是Larry的演讲，主题是Oracle Cloud服务，他明确指出了其在SAAS领域的对手是Salesforce，PaaS领域的对手是微软而不是IBM，IaaS领域的对手是Amazon（Aliyun在美国还是籍籍无名啊…）。相对于这些竞争对手，Oracle要做全平台的云服务提供商：在SaaS提供全部种类的商业应用，例如CX、HCM、ERP、EPM等；在PaaS领域提供完全符合工业标准的平台服务；在IaaS领域突出安全性、可靠性、低开销，标准化的基础设施服务。

    
为了达成上述目标，Larry从以下几个角度阐述了Oracle云服务的设计目标：

    
第一是低成本（cost），包括价格上具备竞争优势，通过自动化降低人力成本和人为误差，更轻易的创建和使用应用来减少成本。

    
第二是高可用性(reliability)，实现零宕机时间。两个方面：

    

      
fault tolerant，通过冗余设计，hot patching及备份，即时恢复来实现；

      
自动化(automation)，消除在部署、补丁、备份及恢复期间的人为错误。

    

    
第三是高性能，从三个方面阐述：

    

      
数据库，in-memory in-flush的列式数据库，部署在云中的Exadata；

      
中间件，In-memory speed-of-thought Analytics; 3.Sale-out架构，弹性能力，和按需获的性能。

    

    
第四是标准化，支持工业标准的SQL、Hadoop、NoSQL等等，让用户能够无锁定的自由迁移到其他云服务平台。

    
第五是兼容性，能够自动迁移负载和数据。例如从公有云和私有云之间自由迁移。

    
第六是安全性，能够持续的抵御黑客攻击。最新发布的SPARC M7处理器在硬件层支持实时的安全监测；另一方面也提供数据加密。

    
在阐述上述观点后，随后发布了一大堆的云产品，Oracle强势宣布了其正式进入了云计算领域。

    
Exploring Oracle Database 12c New Features Best Practices for DBAs and Developers [UGF7904]

    
Ami Aharonovich, CEO, DBAces-ilOUG

    

      
PPT链接

    

    
介绍了Oracle 12c的一些新特性，以及如何使用这些特性，作为一名MySQL开发，最让我感兴趣的是MySQL中没有的功能，以及是否能将Oracle的这些功能也实现到MySQL中去。以下是几个笔记的点。

    
隐藏列属性：定义为“column_name TYPE INVISIABLE”。当设置该属性后，这个列的内容对客户端而言就是不可见的，但如果显式的指定列名的话，则可以对该列进行操作，主要用于类似应用迁移之类的场景，例如增加新的列，不影响老的应用，同时新的应用也可以通过指定列的方式进行操作。MySQL可以考虑把这个特性Port过来。
这个文档
 有对该特性的描述。

    
默认的sequence值：可以默认获取一个新的sequence值（定义为column_name TYPE DEFAULT seq_name.nextval），另外一种方式是在列上定义一个
IDENTIFY
属性（id NUMBER GENERATED ALWAYS AS IDENTITY）仔细想想，这货不就是MySQL的Auto-Increment属性么。

    
Data Redaction：顾名思义，就是数据修订的意思，对返回给客户端的值进行修订，例如将敏感信息用”*“代替返回。有FULL Redaction、Partial Redaction、Regular expression、Random Redaction、No Redaction几种。如下图所示：

    

      

    

    
reduant

    
具体介绍参阅
这篇文章
。

下图描述了这个特性的一个典型应用。感觉是个比较有意思的特性，后面看看怎么做的，可以考虑实现到MySQL里

    

      

    

    
red use

    
更好的加列操作：如果列的值允许为NULL，加列操作不会产生表上所有记录更新，而是修改元数据。当查询到这个列时，如果尚未有数据，则从元数据中获得其default值，并返回给客户端。同样的思路可以应用于MySQL。

    
Adaptive Execution PLan：运行过程中自动调整执行计划，最终的计划取决于执行过程中看到的行数。

    
在该演讲slide的最后贴了大量关于Oracle 12c相关的链接，感兴趣的可以点开了解下。

    
General Session: Software in Silicon and SPARC Outlook—Secure, Smarter Database/Applications [GEN6421]

    
Masood Heydari, SVP, Hardware Development, Oracle

    

      
PPT链接

    

    
介绍新发布的SPARC M7 处理器，其性能强悍，号称有32个core，256线程，4.13GHZ，64MB的L3 Cache, 支持最大2TB的物理内存，支持4路DDR4 内存控制器； 并且相比前一代有3倍IO带宽提升；该处理器还支持Silicon Secured Memory， DB query Acceleration，Inline Decompression，将软件功能集合到硬件中，从而最大化发挥效率。其号称世界上最快的微处理器，其基于硬件的内存安全防护，能够防止黑客非法访问内存内容

    
MySQL官方演讲

    
How to Analyze and Tune SQL Queries for Better Performance [TUT3411]

    
Oystein Grovlen, Senior Principal Software Engineer, Oracle

    

      
PPT链接

    

    
演讲者为MySQL团队优化器模块的开发人员，重点介绍了优化器的相关知识，包括优化器的执行过程， MySQL 5.7引入的cost model ，5.6版本之后引入的物化统计信息。

其中比较有意思的点是cost model，介绍了用户如何通过设置cost model来影响优化器的行为。

通过实例介绍了索引选择的类型，介绍了join和子查询是如何进行优化器选择的，以及排序和聚合操作。 该演讲的slide干货满满，对优化器感兴趣的同学非常值得一看。

    
MySQL Replication Tips and Tricks [TUT5467]

    
Joao Gramacho, Software Developer, Oracle

    

      
PPT链接

    

    
详细介绍了MySQL的复制模块，以及大量的使用技巧及5.7的新特性，从浅显的知识到更深入的讨论都有涉及，适合对复制模块感兴趣的各个层次人群阅读。

    
InnoDB: What’s New in MySQL 5.7 [CON3716]

    
Sunny Brain, InnoDB Developer Manager

    
暂无PPT

    
InnoDB的开发主管Sunny Brain介绍了MySQL5.7对InnoDB模块的改进，总的来说，主要包括以下几点：

    
General tablespace： 一种用户定义的表空间，在磁盘上会生成一个ibd文件，可以指定表空间名来创建表，这些表的数据都存储到一个ibd文件中。

    
Virtual column：支持虚拟列，即用户通过预设的表达式定义的列，这样的列不存储数据，但支持基于其上建立索引。一种典型的应用是基于Json类型数据之上，使用json相关函数创建虚拟列。隔天Jimmy Yang有个演讲专门介绍这一块。

    
native partition：将分区表的引擎接口从Server层转移到InnoDB层，这意味着之前每个分区都需要一个存储引擎接口，现在则只需要一个引擎接口，对于包含大量分区的分区表而言，可以减少不少内存消耗。另外这种改变，也使得未来基于分区表做并行查询更加简单。

    
全文索引：改进了全文索引，可以更好的支持中文全文索引分词，这极大的弥补了5.6版本InnoDB全文索引的不足之处，从5.7版本开始，MySQL用户可以完全抛弃MyISAM引擎的全文索引

    
R-Tree Index(GIS Support)：开始支持GIS空间数据类型，弥补了MySQL和其他数据库（如PostgreSQL）相比的一大缺憾，GIS对当前基于地理空间的应用是非常重要的功能。

    
性能优化：在5.7版本对读写性能做了大量的优化，例如优化了读写事务链表的管理，Read View缓存(两个只读查询之间没有新的读写事务，则认为read view是可重用的)，消除了大量的事务锁瓶颈。基于这些改进，新版本的性能（尤其是读性能）能够在多核场景下获得更好的性能。 在讨论到Read view缓存时，我发现在RC隔离级别下，这一优化策略并没有生效，和Sunny讨论了下这个问题，他表示认同。

    
索引锁优化：引入SX Lock，在对btree做分裂或合并操作时，不再锁住整棵btree，从而降低对读负载的影响。

    
事务生命周期特性： （主要用于支持5.7另外一个新特性：Group Replication），包括高优先级事务，高优先级获取记录锁（可以从记录锁队列中往前跳），kill其他低优先级事务。目前这几个特性还对终端用户不直接可见。

    
DDL优化：对于索引创建，在之前的版本中使用先排序数据，再执行插入到新btree中的方式，而新版本则使用自低向上的索引构建方式，即先构建叶子节点，再从叶子节点开始构建非叶子节点，这样具有极高的索引创建效率。

    
Intrinsic table：主要被优化器使用，在之前版本中使用的是MyISAM引擎来作为查询过程中产生的临时表引擎；在5.7版本中，InnoDB对临时表(intrinsic table)做了大量优化，包括独立的临时表表空间，独立的undo回滚端，减少redo log的记录。下图是他们的性能比较图，可以看到InnoDB在高并发下能获得更好的性能。

    

      

    

    
intrinsic table

    
Memcached： 由于消除了大量的性能瓶颈，MySQL5.7的Memcached Plugin相比5.6有了数倍的提升，而在稳定性上，也修复了大量的bug，相信5.7版本能够改变5.6版本Memcached plugin无人问津的窘境。

    

      

    

    
memcached

    
其他还包括诸如大Page Size支持，CRC32的Redo log校验，多个Page cleaner线程及buffer pool刷脏逻辑优化。

    
总的来说，MySQL5.7是个非常值得期待的版本。

    
Building Scalable, High-Availability Systems Using MySQL Fabric [CON4975]

    
Mats Kindahl, Senior Principal Software Developer, Oracle

    
暂无PPT

    
介绍了MySQL新组件Fabric，主要用于构建高可用，可扩展的系统。Fabric本质上是一组脚本，算是官方出品的HA和Sharding工具。由于阿里在这一块已经非常的成熟，我对Fabric本身并不感兴趣，感兴趣的可以参阅
官方文档
。而对为了支持fabric对服务器端代码做的改动比较感兴趣。

    
总的来说，为了支持Fabric，MySQL本身做了几点改动：

实现一种新的方法来清理session的状态，可以reset 已有的会话，例如清理其内容并释放资源（WL#6797），这在我们RDS里也有类似的实现。

    
允许MySQL服务器进入一种离线状态，让已有的连接优雅的断开（SUPER账户除外），这主要用于升级或者维护服务器。该特性也用于fabric来辅助管理MySQL集群。(WL#3836)

    
增加一个服务器层的flag来判断是否有一个新的事务开启了，主要用于连接池的负载均衡，如果一个session未开启事务，就可以把它的请求调度给别的连接。 (WL#6631)

    
另外在29号也有另外一个关于Fabric的主题演讲，
参阅PPT
。

    
MySQL 5.7: What Is New in the Optimizer? [CON3379]

    
Manyi Lu, Senior engineering manager, Oracle

    

      
PPT链接

    

    
负责MySQL服务器层的开发主管介绍了MySQL5.7版本对Optimizer模块的优化，主要包括如下几个方面的改进。

    
Generated Column：用户可以在建表或ALTER时创建的一种新的列类型，列的数据可以通过一个预设的表达式来进行计算，如下建表语句：

    

      
CREATE TABLE order_lines
    (orderno integer,
    lineno integer,
    price decimal(10,2),
    qty integer,
   sum_price decimal(10,2) GENERATED ALWAYS AS (qty * price) STORED );

    

    
最后一个列的值为qty列和price列相乘得到。STORED属性表示在插入或更新时计算该列的值并存储到物理文件中。你也可以选择VIRTUAL属性，这样就只在查询时计算。这可以满足一些特殊的需求：例如实现基于方法的索引，物化缓存复杂的条件，简化查询SQL表达式。

    
JSON Support：支持内建的JSON类型的数据存储，并提供一组JSON函数。使用也比较简单，直接将列类型定义为JSON。

    
对于JSON类型的数据，在插入或更改时，会进行格式检查，通过新的语法和函数，也可以更方便的操作JSON数据。

    
和Generated Column相结合，我们还可以对json中的数据进行索引创建，从而索引json中的某个数据段。

    
PS：当天有另外一个演讲专门对JSON
做了介绍

    
Cost Model：用户可以根据自己的硬件场景来配置cost model，进而影响优化器的选择。基于5.7的cost model，解决了如下几个问题：

    

      
对于JOIN操作的记录数估计不准确；

      
hard-code的代价常量；

      
不准确的record-per-key，使用浮点数代替；

      
使用json输出explain的结果。Manyi Lu强调在下一个版本中，他们会着重解决优化的cost model自动调整功能，而不是依赖人来配置。

    

    
新的HINT表达式：在插叙中使用 /+ …/ 来开启一些优化器或者其他选项，例如BKA, BNL, MRR, ICP, SEMIJOIN, SUBQUERY，MAX_EXECUTION_TIME等等常用HINT。

    
Query Rewrite Plugin：一种新的插件类型，主要解决的问题是在不修改应用的情况下，更改其SQL的行为，例如如果优化器总是为这个SQL选择错误的执行计划，就可以为其加上hint做强制索引选择。

    
UNION ALL问题：在5.7版本终于解决了臭名昭著的UNION ALL总是创建临时表的问题，多个表做UNIALL ALL时，数据先存储到临时表，然后再发送，但UNION ALL并不需要结果集的顺序性和唯一性，没有必要构建临时表来作去重。

    
IN表达式优化：在之前的版本中，对于这样的表达式WHERE (a, b) IN ((0, 0), (1, 1))，即时(a,b)上存在索引，也无法使用IN表达式中的值去查询索引，在5.7解决了这个问题，可以使用索引做range scan。

    
EXPLAIN：可以去查看一个正在运行的SQL的执行计划，这个特性对我们诊断问题非常有用。

    
最后Manyi Lu罕见的给出了下一个版本优化器模块的RoadMap（Oracle的开发人员通常不会对下一阶段的开发发表评论），包括：

    

      
改进对存储过程的支持；

      
增加类似oracle的直方图；

      
支持并行查询；

      
公用表表达式(Common table expression) 。

    

    
在后面的讨论中，Manyi Lu也透露了“查询计划缓存”也在开发的计划中（尽管这里没有列出来）。

    
从优化器的进化可以看出来，MySQL的优化器模块开始变的越来越像Oracle了。希望新版本的MySQL5.7能够改变人们一向的“MySQL优化器很弱”的印象。

    
Update Everywhere with the MySQL Group Replication Plugin [CON5349]

    
Nuno Carvalho, Principal Software Engineer, Oracle

    
暂无PPT

    
介绍了MySQL的一种新的插件类型：Group Replication plugin，主要用于类似active-active复制拓扑结构的集群管理，支持多个节点更新，自动冲突检测，自动增删节点等功能，类似MariaDB的Galera。Group Replication目前已经到了0.6.0版本，但还没有正式GA。

    
使用Group Replication，需要保证使用的表都是InnoDB表，并且定义了主键。Binlog需要使用Row模式。

    
Group Replication的分布式一致性协议基于XCom，一种PaxOS协议的变种。

    
关于冲突检测，开发了一组
Group Communication 工具集
，提供了完全有序的广播，也就是说，消息在所有的节点都按照同样的顺序进行应用。当产生一个新的更新消息时（以类似binlog row格式存储）：

    

      
在当前实例上完成，但block在commit阶段；

      
group communcattion组件会负责将消息发送到所有依然活跃的节点。

      
最关键的是决定本地事务是该提交还是回滚。这就涉及到如何进行冲突检测，每个行记录都有一个版本信息，在行被更新时，版本也会递增。主要通过节点间行记录的版本信息来进行冲突检测；

      
如果不存在冲突，则全部提交；否则全部回滚。

    

    
版本信息是通过GTID维护的，所有实例的UUID是全局统一的，并保证了所有节点产生的GTID不会重复。有两个版本信息，一个是database version，也就是本地的version（dbv），另外一个是确认模块的version（cv），下图是一个典型的冲突解决场景：

    

      

    

    
group replication

    
关于一个事务在Group Replication集群中的生命周期，参阅
这篇博客

    
关于节点踢出和重新加入的逻辑，参阅
这篇文章

    
如何
使用Group Replication

    
在
官方博客
上还有不少文章介绍Group Replication，感兴趣的可以深入研究下。

    
What’s New in MySQL 5.7 Security [CON1559]

    
Georgi Kodinov, Senior Software Development Manager, Oracle

    

      
PPT链接

    

    
主要介绍了MySQL 5.7 包含的一些安全特性。包括：

    
企业版特性：

    

      
SQL防火墙用于包含实例免受预期外的SQL注入侵害;

      
企业版数据加密。

    

    
账户管理：

    

      
增加ALTER USER语法来修改用户权限。

      
临时权限禁止功能；

      
基于时间的权限失效策略；

      
服务器提供offline模式。

    

    
重构及新功能：

1. 新的权限表格式；

2. 提供基于AES的加解密函数；

3. mysql_secure_install/mysql_install_db使用c语言进行了重构；mysql_upgrade不再调用外部程序。

    
业界使用

    
MyRocks： MySQL on RockDB

    
Yoshinori Matsunobu, database developer at facebook

    
由于26号没有什么比较值得关注的主题，我们应facebook的邀请，26号下午去拜访了Facebook的MySQL开发团队，了解了下之前我们一直关注的MyRock开发情况，他们的开发Yosh专门为我们做了介绍。

    
说到MyRock，需要先介绍下RockDB。RockDB是facebook基于LevelDB的一个分支，他们在其上做了大量的优化，目前已经集成到Mogodb 作为一个plugin，Percona公司也开始针对RockDB提供技术支持。RockDB基于LSM存储结构，能够有效的减少磁盘擦写的次数，这对Facebook非常重要，因为在他们那里flash设备已被广泛使用，通过rockdb能够有效的控制磁盘成本。另外更大的SST 文件块大小相比InnoDB获得更好的压缩效果，减少磁盘的存储空间。

    
但是RockDB仅仅支持key-value，并没有SQL接口，如果想用rockdb取代已被广泛使用的InnoDB，应用修改的成本巨大，因此他们启动了MyRock项目，将RockDB包装成MySQL的一个存储引擎。Yosh透露预计明年会出一个GA版本，目前还处于开发状态，他们也在该项目上和MariaDB进行紧密合作。

为了进一步减少磁盘空间，他们实现了“prefix key encoding”，即对于具有相同前缀的行记录，这些相同的列值只存储一次。不过这样也带来了一些负面作用，即需要在建表时设定是正序存储还是逆序存储，因此需要和应用方商量好。

    
由于LSM具有分层结构，对查询并不友好，最差情况下每个level可能都需要查询一遍。一次带order by的range scan需要将多个level的结果进行merge，这不像基于Btree结构的InnoDB，直接做一次顺序扫描即可。为了优化该场景，他们在MyRock中引入了bloom filter来加速查询，快速确认某个level是否有需要的记录，减少不必要的IO。

    
目前MyRock还有一些限制，包括：不支持Online DDL、Foreign Key、Spatial Index、以及Fulltext；所有表必须有primary key；不支持next-key lock，并且必须使用row格式复制；不支持binlog和myrock的XA；ORDER BY DESC/ASC 由于prefix key encoding，总有一个会比较慢点；大量删除操作会影响到整体性能。

    
总的来说，他们并不期望myrock能完全取代InnoDB，只是期望在某些场景下能利用LSM的优点。目前该项目公布在github上，代码的开发进度、提交日志一目了然，不得不让人敬佩facebook的开源和社区合作精神。

    
A Global Transaction Identifier Rollout at Dropbox [CON4766]

    
Rene Cannao, MySQL DBA, Dropbox

David Turner, Database Administrator, Dropbox

    

      
PPT链接

    

    
Dropbox公司分享了他们如何使用GTID。没啥新东西，主要的问题还是GTID无法动态调整，导致整个MySQL集群无法升级到5.6及之后版本的问题，这个问题在社区（例如Facebook和booking）都做了些简单的patch来绕过这个问题，咱们的RDS MySQL也有相应的改动。 这个问题在5.7版本得到了彻底的解决。Gtid的开启和关闭被划分成了多个阶段，来保证整个复制拓扑的GTID一致性

    
Making MySQL More Efficient at Pinterest [CON3654]

    
Ernie Souhrada, Database Engineer, Pinterest

Robert Wultsch, Database Engineer, Pinterest

    
暂无PPT

    
Pinterest公司的两位数据库工程师（实际上他们整个team就两个人），一个是前Percona员工，一个是前Facebook员工。他们分享了Pinterest如何让MySQL更高效。

    
由于只有两名员工，他们选择更多的依靠已有的技术，例如备份使用MySQL Enterprice Backup。他们提到一个比较有意思的问题是，在数据库中他们存储了大量的JSON数据，这些数据列的大小平均为1.2kb。正好他们看到了我们以前分享的关于单列压缩的改进，在他们的场景下测试得出的结论是，列压缩在保证性能的基础上，依然能提供不错的压缩比。

    
他们在列压缩的基础上，对这个功能进行了扩展，方案交给Percona进行开发。也就是所谓的Predefined Compression dictionary。会后和他们交流了具体的方案，了解了这个改进的具体内容：

其本质是将需要压缩的数据预先定义好，然后在全局使用这个预先定义的数据词典进行压缩。定义两张系统表，一张系统表存储数据词典信息，另外一张表存储列与数据词典的映射。

    
由于预先定义好了压缩前缀词典，即时一个字符串在某个列中只出现了一次，也是可以被压缩的。

压缩前缀词典可以通过训练已有的数据集得到。这确实是一个非常有趣的思路，对他们的这种场景，减少了72%的磁盘占用。

    
Binlog Servers at Booking.com [CON4098]

    
Jean-François Gagné, Senior System Engineer, Booking.com

    

      
PPT链接

    

    
来自booking的开发人员介绍了他们的binlog server工具，根据其描述，其工作原理就是一个独立的server，从master上读取binlog，存储到本地；然后将自己当做一个“假”的master，将binlog分发到各个slave节点。

    
在阿里，我们早几年就有了类似的工具，例如DRC， Transfer，精卫等。不过booking结合binlog server实现了其生产环境的高可用，读扩展以及时间点恢复功能。

    
YouTube Vitess: Cloud-Native MySQL [CON11339]

    
Anthony Yeh, Software Engineer, Google

    

      
PPT链接

    

    
来自谷歌的工程师介绍了Youtube的开源项目Vitess。对分布式中间件不太了解。没啥感觉

    
Feed Your Streams: Zendesk’s Maxwell Generates Kafka Event Stream from MySQL Binlogs [CON3340]

    
Ben Osheroff, Principle Engineer, zendesk.com

    

      
PPT链接

    

    
zendisk的工程师分享了另外一款开源的工具，同样也是用于解析Binlog的，不同的是，把binlog的内容解析成了json的格式并复制到Kafka，算是玩出了新意。例如解析出来的数据如下图所示：

    

      

    

    
zendisk

    
Yahoo Case Study: MySQL GTIDs and Parallel or Multithreaded Replication [CON5409]

    
Yashada Jadhav, MySQL DBA, Yahoo

Stacy Yuan, Sr. MySQL DBA, Yahoo

    

      
PPT链接

    

    
主要讲了Yahoo关于GTID的使用，介绍了下复制的相关知识以及如何使用Percona版本的MySQL实现online GTID开启。没啥新意，看在难得是妹子的份上听了一会就闪了。但对这块不了解的同学可以看看。

    
Database Defense in Depth [CON3554]

    
Geoffrey Anderson, Senior Database Operations Engineer, Box

    

      
PPT链接

    

    
Box公司的DBA阐述了他们如何使用各种工具来解决MySQL遇到的问题，以保证MySQL的正常运行。没啥新东西。

  

  

    

    

    
Test Book

  

  

    
背景

    
在对数据库进行性能调优的时候，除了参数、配置的调整以外，SQL调优也是重要的手段，同时也是收益最大的一环。

当DBA对业务库进行sql调优的时候，如何做到有的放矢，投入产出受益最大？足够详细的SQL性能统计无疑是最重要的信息。

    
下面我们先来看下不同数据库提供的sql性能统计信息:

    
Oracle的sql性能统计

    
Oracle可以通过直接查询v$表得到，下面的columns列表是我们常用的一些统计:

    

      
select sql_id,
     sql_text,
     sql_fulltext,
     sharable_mem,
     persistent_mem,
     runtime_mem,
     sorts,
     fetches,
     executions,
     parse_calls,
     disk_reads,
     direct_writes,
     buffer_gets,
     application_wait_time,
     concurrency_wait_time,
     cluster_wait_time,
     user_io_wait_time,
     rows_processed,
     cpu_time,
     elapsed_time
from v$sql_area

    

    
这里边包括了几类统计，SQL内存使用的统计、parse的统计、物理/逻辑IO的统计、cpu时间、等待时间等时间统计。

    
DBA可以根据这些统计信息进行有针对性的调优:

    

      
CPU调优: 如果当前数据库性能CPU是瓶颈，可以通过order by cpu_time，查询出来top CPU的SQL进行调优；

      
IO调优: 可以根据buffer_gets, disk_reads，user_io_wait_time 查询top IO的SQL进行调优；

      
锁争用: 可以根据concurrency_wait_time，cluster_wait_time查询top lock的SQL进行调优。

    

    
MySQL的SQL性能统计

    
1. 通过show profiles来查询统计信息

在MySQL 5.6版本之前，还保留着show profiles的方式，后续版本逐步被performance_schema来替换了。

使用方法如下:

    

      
mysql> SET profiling=1;
mysql> select 1, sleep(1);
mysql> show profile cpu, block io for query 1;
+----------------------+----------+----------+------------+--------------+---------------+
| Status               | Duration | CPU_user | CPU_system | Block_ops_in | Block_ops_out |
+----------------------+----------+----------+------------+--------------+---------------+
| starting             | 0.000100 |     NULL |       NULL |         NULL |          NULL |
| checking permissions | 0.000014 |     NULL |       NULL |         NULL |          NULL |
| Opening tables       | 0.000024 |     NULL |       NULL |         NULL |          NULL |
| init                 | 0.000020 |     NULL |       NULL |         NULL |          NULL |
| optimizing           | 0.000008 |     NULL |       NULL |         NULL |          NULL |
| executing            | 0.000022 |     NULL |       NULL |         NULL |          NULL |
| User sleep           | 1.000090 |     NULL |       NULL |         NULL |          NULL |
| end                  | 0.000021 |     NULL |       NULL |         NULL |          NULL |
| query end            | 0.000009 |     NULL |       NULL |         NULL |          NULL |
| closing tables       | 0.000010 |     NULL |       NULL |         NULL |          NULL |
| freeing items        | 0.000055 |     NULL |       NULL |         NULL |          NULL |
| logging slow query   | 0.000008 |     NULL |       NULL |         NULL |          NULL |
| cleaning up          | 0.000012 |     NULL |       NULL |         NULL |          NULL |
+----------------------+----------+----------+------------+--------------+---------------+
13 rows in set (0.00 sec)

    

    
show profile的语法如下：

    

      
        SHOW PROFILE [type [, type] … ]  
            [FOR QUERY n]  
            [LIMIT row_count [OFFSET offset]]  

        type:  
            ALL  
          | BLOCK IO  
          | CONTEXT SWITCHES  
          | CPU  
      | IPC  
          | MEMORY  
          | PAGE FAULTS  
          | SOURCE  
          | SWAPS  

    

    
从结果集可以看到每一块操作的CPU时间，block IO情况。

但这种适合拿单个SQL进行分析，使用上的便捷性比较差。

    
2. 通过performance_schema的digest统计

MySQL之前的版本不支持绑定变量，导致SQL语句太多，相同业务的SQL汇总统计比较麻烦。

从MySQL 5.6开始，在performance_schema中支持了对SQL statement的digest进行统计。

performance_schema.events_statements_summary_by_digest表根据digest进行汇总统计，DBA可以直接访问这个内存表得到SQL的统计信息。

    
首先，需要打开performance_schema，然后系统就会自动为SQL statement生成digest，并记录统计信息。

例如:

    

      
mysql> select 1, sleep(1);
+---+----------+
| 1 | sleep(1) |
+---+----------+
| 1 |        0 |
+---+----------+
1 row in set (1.00 sec)
mysql> select * from events_statements_summary_by_digest\G;
*************************** 1\. row ***************************
                SCHEMA_NAME: performance_schema
                     DIGEST: bb80cc862a205b471ce0f0ff2605a9a0
                DIGEST_TEXT: SELECT ? , `sleep` (?)
                 COUNT_STAR: 1
             SUM_TIMER_WAIT: 1000577972000
             MIN_TIMER_WAIT: 1000577972000
             AVG_TIMER_WAIT: 1000577972000
             MAX_TIMER_WAIT: 1000577972000
              SUM_LOCK_TIME: 0
                 SUM_ERRORS: 0
               SUM_WARNINGS: 0
          SUM_ROWS_AFFECTED: 0
              SUM_ROWS_SENT: 1
          SUM_ROWS_EXAMINED: 0
SUM_CREATED_TMP_DISK_TABLES: 0
     SUM_CREATED_TMP_TABLES: 0
       SUM_SELECT_FULL_JOIN: 0
SUM_SELECT_FULL_RANGE_JOIN: 0
           SUM_SELECT_RANGE: 0
     SUM_SELECT_RANGE_CHECK: 0
            SUM_SELECT_SCAN: 0
      SUM_SORT_MERGE_PASSES: 0
             SUM_SORT_RANGE: 0
              SUM_SORT_ROWS: 0
              SUM_SORT_SCAN: 0
          SUM_NO_INDEX_USED: 0
     SUM_NO_GOOD_INDEX_USED: 0
                 FIRST_SEEN: 2015-11-06 11:15:52
                  LAST_SEEN: 2015-11-06 11:15:52
2 rows in set (0.00 sec)

    

    
DBA可用通过这个表的统计信息，来有的放矢的进行SQL调优。

    
然而performance_schema中digest的限制:

    

      
必须打开performance_schema的所有功能才行，但performance_schema全部打开会对性能产生一些影响；

      
events_statements_summary_by_digest 表默认有200个的最大限制，但从MySQL 5.5开始，可以通过调整performance_schema_digests_size来修改。但如果表满了的话，新来的digest的统计信息，会被全部汇总到一个digest=NULL的记录中；

      
对于每一个SQL statement，performance_schema会生成一个最大1024bytes的digest_text，超过的会被截断。

    

    
针对以上的一些限制，MySQL5.7最新GA的版本，进行了一些改进。

    
另外，针对限制2 Percona有一些工具pt-query-digest, 并建立一些digest历史表，进行分析，有兴趣的可以使用尝试一下。可以参考: 
mysql-query-digest-with-performance-schema

    
MySQL 5.7 performance_schema digest的改进

    

      
SQL statement digest生成功能不必和performance_schema绑定，digest的功能的源代码主要是这两个文件：PFS_digest.cc和PFS_digest.h。这两个文件从存储引擎目录storage/perfschema/ 移到了server目录sql/下；

      
从MySQL 5.7.6开始，digest的最大长度由固定的1024bytes，变成了可变大小，由参数performance_schema_max_sql_text_length在系统启动的时候初始化。

    

    
总结

    
用户可以针对performance_schema提供的digest的功能，根据需求进行一些开发和扩展，比如定期历史保存、建立SQL性能基线、或者更进一步如果能修改源码，可以为digest增加更多的merics等。

  

  

    

    

    
Test Book

  

  

    
背景

    
RDS上的PG没有开放超级用户，这给很多云上的客户使用PG带来了困难。因此有必要给大家讲讲PG的用户权限管理的一些小知识，它可以很好的帮助用户顺利的从之前的 DB 管理方式过度到云上。

    

      
PG 的 superuser 拥有几乎全部的数据库权限，甚至可以直接修改系统表，潜在风险相当大；

      
RDS PG 使用 superuser 运维 DB，例如管理用、管理流复制、备份等，这些操作用户是不需要关心的，换句话说它应该完全的交给云服务来处理；

      
对于用户而言，PG 的普通用户权限是完全够用的。使用普通用户，可以管理自己在云上的数据（对表进行DDL、DML、创建修改和管理其他数据库对象）。

    

    
之前的 PG 用户习惯使用 superuser 进行日常运维，一方面 superuser 完全不用做任何的授权，使用方便；另一方面这样的操作带来了潜在的风险，容易误操作。

    
最近碰到了较多的用户反馈，没有了超级用户，无法使用 RDS 的普通用户，管理其他普通用户创建的对象，经常出现操作对象无权限的问题，尤其存在多用户的情况下。通常情况下：

    

      
一个普通用户只能在自己 owner 的DB下创建 schema；

      
DB 下的对象有一个所属的 schema，普通用户可以在 public 下创建对象（如 table），在其他 schema 下创建对象需要 schema 的 owner 是当前用户或特别的授权；

      
管理一个数据库对象，需要是超级用户、或对象的 owner 是当前用户（在用户组权限之外）。

    

    
很多用户，使用了很多个 user 在 public 模式下创建了多张表，但是单个用户却没有权限同时管理他们， 更没有权限切换他们的 owner 到一个统一的用户下做统一处理，十分恼火。

    
解决方法

    
在这里，我们提供一种通用的方法，可以使用 PG 的用户组和继承特性，做到使用一个普通用户管理多个其他用户。

    

      

        
使用 RDS 的根账号创建一个用于管理数据库和用户的管理员账号，他具有创建用户和创建 DB 的权限

        

          
 postgres=# create user admin createdb createrole login password 'pgsql';
 CREATE ROLE
 postgres=# \du
                               List of roles
   Role name  |                   Attributes                   | Member of 
 -------------+------------------------------------------------+-----------
  admin       | Create role, Create DB                         | {}
  test        | Superuser                                      | {}

        

      

      

        
使用这个 admin 登陆 postgres，创建用于存放数据的DB

        

          
 postgres=> create database dbadmin;
 CREATE DATABASE

        

      

      

        
创建子账户subuser1 subuser2，并把他们的权限给admin

        

          
 dbadmin=> create user subuser1 ;
 CREATE ROLE
 dbadmin=> create user subuser2 ;
 CREATE ROLE
 dbadmin=> grant subuser1 to admin;
 GRANT ROLE
 dbadmin=> grant subuser2 to admin;
 GRANT ROLE

        

      

      

        
我们看到 admin 用户组管理了下列2个用户，也就是admin 拥有 subuser1，subuser2 的所有权限

        

          
 dbadmin=> \du
                                    List of roles
   Role name  |                   Attributes                   |      Member of
 -------------+------------------------------------------------+---------------------
  admin       | Create role, Create DB                         | {subuser1,subuser2}
  subuser1    |                                                | {}
  subuser2    |                                                | {}

        

      

      

        
使用 subuser1 或 subuser2 登陆数据库 dbadmin，public schema上创建 owner 是自己的表对象和其他对象。分别用3个用户创建3张表a b c用作测试，另外也可以使用 admin 用户创建分别属于 subuser1 和 subuser2 的 schema ，再创建 table

        

          
 dbadmin=> \d
            List of relations
  Schema |    Name    | Type  |  Owner
 --------+------------+-------+----------
  public | t_admin    | table | admin
  public | t_subuser1 | table | subuser1
  public | t_subuser2 | table | subuser2

        

      

      

        
使用 admin 用户，可以对这3张表做管理，例如:

        

          
 dbadmin=> select user;
  current_user
 --------------
  admin
 (1 row)
 dbadmin=> drop table t_admin,t_subuser1,t_subuser2;
 DROP TABLE

        

      

      

        
但是 subuser1 无法删除 t_admin 和 t_subuser2，同理 subuser2 也无法删除 t_admin 和 t_subuser1

        

          
 dbadmin=> select user;
  current_user
 --------------
  subuser1
 (1 row)
 dbadmin=> drop table t_admin;
 ERROR:  must be owner of relation t_admin
 dbadmin=> drop table t_subuser1;
 DROP TABLE
 dbadmin=> drop table t_subuser2;
 ERROR:  must be owner of relation t_subuser2

        

      

      

        
同理，可以使用 admin 用户，重置这3张表的 owner 到3个用户中的一个，而使用 subuser1 和 subuser2 则没有权限操作，例如:

        

          
 dbadmin=> select user;
  current_user
 --------------
  admin
 (1 row)
 dbadmin=> alter table t_admin owner to subuser1;
 ALTER TABLE
 dbadmin=> alter table t_subuser2 owner to subuser1;
 ALTER TABLE
 dbadmin=> alter table t_subuser1 owner to subuser2;
 ALTER TABLE

 dbadmin=> select user;
  current_user
 --------------
  subuser1
 (1 row)
 dbadmin=> \d
            List of relations
  Schema |    Name    | Type  |  Owner
 --------+------------+-------+----------
  public | t_admin    | table | subuser1
  public | t_subuser1 | table | subuser2
  public | t_subuser2 | table | subuser1
 (3 rows)
 dbadmin=> alter table t_admin owner to admin;
 ERROR:  must be member of role "admin"
 dbadmin=> alter table t_subuser1 owner to subuser1;
 ERROR:  must be owner of relation t_subuser1

        

      

      

        
最后，提一个完成上述功能的假设，admin 用户默认具有 INHERIT 权限，INHERIT 权限决定一个角色是否“继承”它所在组的角色的权限。一个带有 INHERIT 属性的角色可以自动使用已经赋与它直接或间接所在组的任何权限。没有 INHERIT，其它角色的成员关系只赋与该角色 SET ROLE 成其它角色的能力；其它角色的权限只是在这么做了之后才能获得。如果没有声明，缺省是 INHERIT。通过系统表， pg_roles 可以获得该用户的权限信息

        

          
 dbadmin=> select rolname,rolinherit from pg_roles ;
    rolname   | rolinherit
 -------------+------------
  subuser1    | t
  subuser2    | t
  admin       | t

        

      

    

    
总结

    
使用 PG 用户组可以做到使用一个 PG 用户组管理所在组内的所有其他普通用户和他们的对象。RDS 用户设置一个用户组，既可以管理多个用户的对象，又可以实现一定程度上的权限隔离，同时权限又不会过大，推荐在云上使用该方式管理自己的数据库。

    
如果要实现更加细粒度的权限控制，则需要使用 grant 和 revoke 语句，请参考官方
sql-createrole
 和 
sql-grant
。

  

  

    

    

    
Test Book

  

  

    
前言

    
在MySQL中，DDL是不属于事务范畴的，如果事务和DDL并行执行，操作相关联的表的话，会出现各种意想不到问题，如
事务特性被破坏
、
binlog顺序错乱
等，为了解决类似这些问题，MySQL在5.5.3引入了MDL锁(Metadata Locking)，关于其设计思路可以参考这两个worklog：
WL#3726
 和 
WL#4284
。本篇从代码实现角度对MDL进行分析。

    
重要数据结构

    
MDL 是在 MySQL server 层实现的一个模块，通过对外接口和server层其它模块进行交互，在sql/mdl.h和sql/mdl.cc中实现。

    

      

        

enum_mdl_type
，枚举类型，表示MDL锁的类型，目前一共9种

        

          
 * MDL_INTENTION_EXCLUSIVE           IX         // 意向X锁，只用于scope 锁
 * MDL_SHARED                        S          // 只能读metadata，当能读写数据，如检查表是否存在时用这个锁
 * MDL_SHARED_HIGH_PRIO              SH         // 高优先级S锁，可以抢占X锁，只能读metadata，不能读写数据，用于填充INFORMATION_SCHEMA，或者show create table时
 * MDL_SHARED_READ                   SR         // 可以读表数据，select语句，lock table xxx read 都用这个
 * MDL_SHARED_WRITE                  SW         // 可以更新表数据，insert，update，delete，lock table xxx write, select for update，
 * MDL_SHARED_UPGRADABLE             SU         // 可升级锁，可以升级为SNW或者X锁，ALTER TABLE第一阶段会用到
 * MDL_SHARED_NO_WRITE               SNW        // 可升级锁，其它线程能读metadata，数据可读不能读，持锁者可以读写，可以升级成X锁，ALTER TABLE的第一阶段
 * MDL_SHARED_NO_READ_WRITE          SNRW       // 可升级锁，其它线程能读metadata，数据不能读写，持锁者可以读写，可以升级成X锁，LOCK TABLES xxx WRITE
 * MDL_EXCLUSIVE                     X          // 排它锁，禁止其它线程的所有请求，CREATE/DROP/RENAME TABLE

        

      

      

        

enum_mdl_duration
，枚举类型，表示持有MDL锁的时间

        

          
 * MDL_STATEMENT         // 语句范围的，语句结束自动释放
 * MDL_TRANSACTION       // 事务范围的，事务结束时自动释放
 * MDL_EXPLICIT          // 显式锁，由lock tables xxx read 这种获取，需要通过unlock tables释放

        

      

      

        

MDL_key
, 对MDL锁的一个标识，是个三元组：namespace + db_name + table_name

        

          
 * m_ptr                  // 字符串数组，三元组就存在这里
 - enum_mdl_namespace     // 内部定义的一个枚举类型，表示加锁对象的类型
     * GLOBAL             // 全局读锁，FLUSH TABLES WITH READ LOCK
     * SCHEMA             // 数据库锁
     * TABLE              // 表锁
     * FUNCTION           // 函数锁
     * PROCEDURE          // 存储过程
     * TRIGGER            // 触发器
     * EVENT              // event事件
     * COMMIT             // 全局commit锁，FLUSH TABLES WITH READ LOCK

        

      

      

        

MDL_request
, 线程的锁请求，这个会发送给MDL子系统，包含加锁对象（MDL_key）、加什么类型锁（enum_mdl_type）、锁持有时间（enum_mdl_duration）等信息

        

          
 * type                    // 类型是enum_mdl_type，表示锁请求的类型
 * duration                // 类型是enum_mdl_duration，表示锁的持有时间
 * next_in_list            // 当前线程中下一个MDL_request指针，和prev_in_list一起所有MDL_request串起来，形成双向链表
 * prev_in_list            // 见上
 * ticket                  // 加锁成功后，MDL模块会返回一个ticket
 * key                     // MDL_key

        

      

      

        

MDL_ticket
, MDL子系统内部对加锁请求或已获得锁的表示，对MDL来说非常重要，同时是
MDL_wait_for_subgraph
的子类，线程的锁等待图就通过ticket构建出来。

        

          
 * next_in_context          // 和prev_in_context一起构造在当前context下所有的ticket双向链表
 * prev_in_context          // 见上
 * next_in_lock             // 和prev_in_lock一起构造当前MDL_lock的等待和持有ticket双向链表
 * prev_in_lock             // 见上
 - has_pending_conflicting_lock  // 当前ticket的锁类型是否和对应MDL锁的等待队列中的锁冲突
 - is_upgradable_or_exclusive    // 是否是可以升级或者互斥锁
 - has_stronger_or_equal_type    // 当前ticket对应的锁和指定的锁比较是否更强（如X比S强）
 - is_incompatible_when_granted  // 是否能加锁
 - is_incompatible_when_waiting  // 是否比等待队列中的tciket类型优先级更高
 - accept_visitor                // 死锁检测用到
 - get_deadlock_weight           // 拿一个死锁权重，死锁检测用
 * m_type                        // 锁类型
 * m_duration                    // 持有时间，debug 模式下有效
 * m_ctx                         // 指向所属context
 * m_lock                        // 指向请求的锁对象

        

      

      

        

MDL_wait
，锁等待实现，当拿不到锁时就要进入等待，等待的结果也存在这里面

        

          
 - enum_wait_status       // 锁等待退出时的状态
     * EMPTY              // 初始化值
     * GRANTED            // 加锁成功，拿到锁
     * VICTIM             // 等待的时候，死锁检测发现死锁，当前线程选为victim，加锁失败
     * TIMEOUT            // 加锁超时，加锁失败
     * KILLED             // 连接被kill，加锁失败
 - timed_wait             // 等待的实现，条件变量+超时

        

      

      

        

MDL_context
，在MDL子系统中，对应一个线程，thd和MDL系统交互就通过这个类实现

        

          
 - try_acquire_lock                       // 尝试加锁，加锁失败就返回，没有死锁检测
 - acquire_lock                           // 加一个锁，和上面的区别是多了死锁检测
 - acquire_locks                          // 一次性加多个排它锁，要么成功，要么全失败
 - upgrade_shared_lock                    // 升级共享锁
 - clone_ticket                           // clone 出一个 ticket
 - release_all_locks_for_name             // 把当前线程对某个对象加的所有MDL锁都释放掉
 - release_lock                           // 释放单个锁
 - is_lock_owner                          // 是否持有某个对象的锁
 - has_lock                               // 线程是否否在savepoint之前持有指定的锁
 - has_locks                              // 当前线程是否持有锁
 - set_explicit_duration_for_all_locks    // 锁的时间范围都置为显式
 - set_transaction_duration_for_all_locks // 锁的时间范围都置为事务
 - set_lock_duration                      // 设置锁的时间范围
 - release_statement_locks                // 释放所有语句时间范围的锁
 - release_transactional_locks            // 释放所有事务时间范围的锁
 - rollback_to_savepoint                  // MDL 锁回滚到某个savepoint
 - get_deadlock_weight                    // 死锁时拿一个权重值，以此来判断对应线程是否要做为victim
 * m_wait                                 // 锁等待
 * m_tickets                              // 指针数组，每个元素指向一个ticket链表，分别对应当前线程的语句范围锁、事务范围锁和显式锁
 * m_owner                                // 指向thd的指针
 * m_waiting_for                          // 当前线程正在等待的锁
 - find_ticket                            // 在当前线程ticket链表中查找一个ticket
 - release_locks_stored_before            // 释放ticket链表上在某个ticket之前所有ticket
 - find_deadlock                          // 检测是否有死锁
 - visit_subgraph                         // 和死锁检测相关

        

      

      

        

MDL_map
，MDL_key 到 MDL_lock 的一个映射，MDL模块内部用，MDL系统所有锁都放在这个Map里

        

          
 - init                       // 初始化
 - destroy
 - find_or_insert             // 查找对应的MDL_lock，没有的话新建并插入
 - remove                     // 移除MDL_lock
 * m_partitions               // MDL_map 分区
 * m_global_lock              // 预先分配的全局读锁
 * m_commit_lock              // 预先分配的全局commit锁

        

      

      

        

MDL_map_partition
，为了提升MDL模块的扩展性，把原本的一个MDL_map分成多个分区，每个分区就是一个 
MDL_map_partition

        

          
 - find_or_insert                   // 当前分区中查找对应的MDL_lock，没有的话新建并插入
 - remove                           // 在当前分区中移除MDL_lock
 - move_from_hash_to_lock_mutex     // 锁转换，释放对分区的加锁(MDL_map_partition::m_mutex)，获取lock对象的锁(MDL_lock::m_rwlock)
 * m_mutex                          // 对分区对象的一个保护锁，修改当前分区要拿到这个锁
 * m_unused_locks_cache             // 释放掉的锁对象的一个缓存，不用再新分配内存

        

      

      

        

MDL_lock
，MDL锁对象，对于一个key组合（三元组），整个系统只有一个锁对象，不管请求的key是什么类型，什么时间范围

        

          
- Ticket_list                      // 一个内部嵌套类，用于表示当前MDL锁相关的ticket列表，是个list
    - add_ticket                   // 增加 ticket
    - remove_ticket                // 移除 ticket
    - is_empty                     // list 是不是空的
    - clear_bit_if_not_in_list     // 如果当前list中没有某种类型的ticket，就把对应的位清掉
    * m_list                       // 存放ticket的list
    * m_bitmap                     // 标识当前list中所有ticket类型对应bit位的bitmap，实例是个short类型
* key                              // 当前锁对应的MDL_key
* m_rwlock                         // 对MDL_lock锁对象的保护锁
- has_pending_conflicting_lock     // 已经授权的ticket是否和等待队列中的ticket不兼容
- can_grant_lock                   // 能否加锁，先和等待队列进行优先级比较，然后看和已授权的锁是否兼容
- reschedule_waiters               // 当持有当前锁的ticket释放或者降级时，会调用下，看等待队列里是否有ticket此时可以获取锁
- remove_ticket                    // 从指定队列中移出ticket
- visit_subgraph                   // 死锁检测相关
- needs_notification               // 是否需要通知其它线程，当前ticket的锁情况
- notify_conflicting_locks         // 通知其它线程，有一个高级的锁请求
- hog_lock_types_bitmap            // 标识哪种锁是高级锁
* m_granted                        // 已经获得当前MDL锁的ticket队列
* m_waiting                        // 等待当前MDL锁的ticket队列
* m_hog_lock_count                 // 高级锁可以连接拿得锁的个数，超过这个数目就要给低级锁让路，防止低级锁饿死
* m_ref_usage                      // 和下面2个变量一起，为了提高锁的扩展性
* m_ref_release
* m_is_destroyed
* m_version                        // 用于判断锁对象是否被放入unsed队列
* m_map_part                       // 当前MDL锁所在的MDL_map 分区

        

      

      

        

MDL_scoped_lock
，MDL_lock的一个子类，主要用于对schema加MDL锁，全局读锁和全局commit锁也是这种类型。

      

      

MDL_object_lock
，MDL_lock的另一个子类，除了
MDL_scoped_lock
外，其它都用这个(table、fucntion等)，只有 
MDL_object_lock
 可以缓存。

    

    
总结下，上面这些类中，
MDL_key
 和 
MDL_request
 都是POD，用来保存信息的；
MDL_context
是MDL子系统和线程交互的接口，一个对象对应一个线程；
MDL_map
、
MDL_map_partition
 和 
MDL_lock
 都是MDL子系统内部实现细节，对server层其它部分不可见；
MDL_ticket
 表示线程对
MDL_lock
持有的某种锁。

    
MDL锁可以从不同角度进行分类：

    

      
namespace，如GLOBAL、SCHEMA、TABLE等；

      
锁的持续时间，如transaction、显式等；

      
锁的兼容性，如S、X、SH等；

      
锁的实现类，如scope，object等；

    

    
可以看作是MDL锁的不同属性，大家不要搞乱了 :-)

    
模块初始化

    
整个MDL模块的初始化是在mysqld启动时进行的，初始化逻辑在 
MDL_map::init()
 中，做的事情也比较简单：

    

      
初始化两个全局MDL锁，global lock 和 commit lock，两者都是类型都是
MDL_scoped_lock
；

      
分配
metadata_locks_hash_instances
个map分区，为了解决MDL模块
全局锁竞争问题
，在5.6.8对MDL锁做了分区(
commit
)，通过
metadata_locks_hash_instances
配置指定用多少个分区，默认是8个。

    

    
加锁

    
加锁就是server的线程（thd）向MDL模块获取对应锁的ticket过程，加锁成功标志是MDL模块返回一个对应的ticket，大致逻辑如下：

    

      
线程解析SQL语句，根据语义对每一个表对象设置
TABLE_LIST.mdl_request
，如对普通的select语句 
TABLE_lsit.mdl_request.type
 就是
MDL_SHARED_READ
，可以参考函数
st_select_lex::set_lock_for_tables()
；

      
线程在打开每个表之前，会请求和这个表对应的MDL锁，通过 
thd->mdl_context.acquire_lock()
 等接口将
mdl_request
请求发给MDL模块;

      
MDL模块根据请求类型和已有的锁来判断请求能否满足，如果可以就返回一个ticket；如果不可以就等待，等待结果可以是成功（别的线程释放了阻塞的MDL锁）或者失败（超时、连接被kill或者被死锁检测选为victim）；

      
线程根据MDL模块的返回结果，决定继续往下走还是报错退出。

    

    

      
需要注意的是，MDL锁并不是对表加锁，而是在加表锁前的一个预检查，如果能拿到MDL锁，下一步加相应的表锁。

    

    
下面对MDL模块中的主要加锁方法进行介绍。

    
MDL_context::find_ticket

这是一个shortcut方法，加锁的时候先检查当前线程是否已持有对应key的MDL锁，并且这个锁的类型不比请求的低，那么就不需要经过MDL系统再分配一个ticket出来（这个比较复杂，代价较高），直接使用已有的ticket，或者clone一个。

    
举个例子:

    

      
1\. begin;
2\. insert into t1 values (1);
3\. insert into t1 values (2);
   ...

    

    
在上面的语句序列中，执行语句3的时候就不需要再走一遍复杂的加锁逻辑，因为语句2已经成功拿到t1表的ticket，类型都是MDL_SHARED_WRITE，并且MDL锁时间范围也一样（transaction），这个时候直接用已有的ticket，甚至不用clone。

    
MDL_context::clone_ticket

经过检测发现可以直接使用已有的ticket，比如上面的
MDL_context::find_ticket
发现了可以复用的ticket，但是锁时间范围不一致，为了确保已经有锁释放时，不影响现在请求的，就clone一个ticket。

    

      
1\. begin;
2\. insert into t1 values (1);
3\. handler t1 open;
   ...

    

    
在上面的语句序列中，执行语句3的时候，发现有可以复用的ticket（语句2的ticket），但是handler需要的MDL锁是显式的，而语句2取得的ticket是事务时间范围的，事务完成后就会释放，为了避免handler的MDL锁被提前释放，因此单独clone一个出来用。

    
MDL_context::try_acquire_lock_impl

无等待的加锁，如果发现有冲突导致加锁失败，直接退出。会先调用
MDL_context::find_ticket
看是否有可以复用的ticket，有的话就返回成功，如果没有就看能否加锁，能加的话也返回成功，不能加也直接返回(同时返回一个ticket给调用者)。

    
MDL_context::acquire_lock

主加锁函数，调试MDL锁相关问题时，给这个函数加断点比较有效。先调用
MDL_context::try_acquire_lock_impl
，如果加锁失败就进入等待加锁逻辑：

    

      
将
MDL_context::try_acquire_lock_impl
返回的ticket放进MDL_lock的等待队列；

      
触发一次死锁检测（后面会详细介绍）；

      
进入等待，这个时候如果我们
show processlist
就会看到”Waiting for table metadata lock”之类state。等待又分为2种：

定时检查等待: 如果当前请求的锁是比较高级的（对于
MDL_object_lock
是比MDL_SHARED_NO_WRITE类型更高，对于
MDL_scoped_lock
是MDL_SHARED类型），就会每秒给其它持有当前锁的线程（并且这些连接持有的锁等级比较低）发信号，通知其释放锁，然后再检查是否锁已拿到；

一直等待，直到超时；

      
检查步骤3的等待结果，可以是GRANTED（拿到锁）、VICTIM（被死锁检测算法选为受害者）、TIMEOUT（加锁超时）、KILLED（连接被kill）。拿到锁返回成功，其它返回失败。

    

    

      
锁等待是靠
MDL_wait
这个类来实现的。

    

    
MDL_context::acquire_locks

一次性加多个排它MDL锁，如果其中一个加锁失败，前面已经拿到的锁也全部释放。主要用在DDL中，比如
drop table test.t1
这个DDL会一次加3个锁：

    

      
GLOBAL，MDL_INTENTION_EXCLUSIVE

      
test 库, MDL_INTENTION_EXCLUSIVE

      
test.t1 表，MDL_EXCLUSIVE

    

    
MDL_context::upgrade_shared_lock

锁升级，从共享锁升级到互斥锁，实现方式是重新申请一个目标锁，拿到新的ticket后替换老的ticket，用在alter table和create table场景中。

    
如
create table test.t1(id int) engine = innodb
，会先拿test.t1的MDL_SHARED共享锁，检查表是否存在，如果不存在就把锁升级到MDL_EXCLUSIVE锁，然后开始建表。

    
对于
alter table test.t1 add column name varchar(10), algorithm=copy;
，alter用copy到临时的方式来做。整个过程中MDL顺序是这样的：

    

      
刚开始打开表的时候，用的是 MDL_SHARED_UPGRADABLE 锁；

      
拷贝到临时表过程中，需要升级到 MDL_SHARED_NO_WRITE 锁，这个时候其它连接可以读，不能更新；

      
拷贝完在交换表的时候，需要升级到是MDL_EXCLUSIVE，这个时候是禁止读写的。

    

    
所以在用copy算法alter表过程中，会有2次锁升级。

    
MDL_ticket::downgrade_lock

和
MDL_context::upgrade_shared_lock
对应的锁降级，从互斥锁降级到共享锁，实现比较简单，直接把锁类型改为目标类型（不用重新申请）。

    
对于
alter table test.t1 add column name varchar(10), algorithm=inplace
，如果alter使用inplace算法的话，整个过程中MDL加锁顺序是这样的：

    

      
和copy算法一样，刚开始打开表的时候，用的是 MDL_SHARED_UPGRADABLE 锁；

      
在prepare前，升级到MDL_EXCLUSIVE锁；

      
在prepare后，降级到MDL_SHARED_UPGRADABLE（其它线程可以读写）或者MDL_SHARED_NO_WRITE（其它线程只能读不能写），降级到哪种由表的引擎决定；

      
在alter结束后，commit前，升级到MDL_EXCLUSIVE锁，然后commit。

    

    
可以看到inplace有2次锁升级，1次降级，不过在alter最耗时的阶段是有可能降级到MDL_SHARED_UPGRADABLE的，对其它线程的影响小。

    
MDL_context::release_locks_stored_before

释放线程指定ticket链表上某个ticket之前的所有ticket，每个context有3个ticket链表(statement、transaction和explicit)，分别对应当前线程持有的不同时间范围的MDL锁。而ticket在链表中的顺序和时间顺序是相反的，后插入的ticket放在链表开头，因此本函数的作用就是把某个时间点之后的ticket都释放掉，回滚MDL锁。有几个指释放MDL锁的函数都是基于此实现：

    

      

MDL_context::rollback_to_savepoint
，把存档点之后的所有MDL锁都释放掉；

      

MDL_context::release_transactional_locks
，释放所有transaction和statement时间范围的MDL锁；

      

MDL_context::release_statement_locks()
，释放所有statement时间范围的MDL锁。

    

    
死锁检测

    
MDL模块作为一个集中的资源，收到不同线程发来的锁请求，而有的锁是互斥的，不能同时满足，在这种情况下就会等待，如果线程在此之前已经拿到某些锁的话，就会形成持有-等待的状态；而又不可能要求所有线程按某一固定顺序请求锁，这样就会形成等待循环，也就是死锁，如下图所示：

    

      

    

    
图1. 死锁

    
线程T1持有M1，然后请求M2，但M2被线程T2持有，并且和T1的请求类型互斥，同时T2请求M1，和T1拿到的锁互斥，形成死锁。

    
在介绍MDL的死锁检测之前，先介绍下MDL锁的兼容矩阵。每种类型的锁各有2个兼容矩阵，granted matrix 和 waiting matrix，前者表示锁的兼容性，后者表示锁的优先级（优先级就是和等待队列的锁相比，当前锁是否能够进行加锁尝试，当前锁优先级高则可以，低则需进等待队列）。

    
矩阵中 ‘+’ 表示兼容，’-‘ 表示不兼容，’0’ 表示不可能存在的场景。

    

MDL_scoped_lock
，支持IX，S和X锁（关于锁的缩写可以看第一节）。

    

      

        
granted matrix

        

          
          | Type of active   |
  Request |   scoped lock    |
   type   | IS(*)  IX   S  X |
 ---------+------------------+
 IS       |  +      +   +  + |
 IX       |  +      +   -  - |
 S        |  +      -   +  - |
 X        |  +      -   -  - |

        

      

      

        
waiting matrix

        

          
          |    Pending      |
  Request |  scoped lock    |
   type   | IS(*)  IX  S  X |
 ---------+-----------------+
 IS       |  +      +  +  + |
 IX       |  +      +  -  - |
 S        |  +      +  +  - |
 X        |  +      +  +  + |

        

      

    

    
IS锁虽然列了出来，但是代码里并没有实现这个锁，因为IS和所有的锁类型都兼容（也可以理解为每次锁请求都默认会额外有一个IS锁）。

    

MDL_object_lock
，支持S、SH、SR、SW、SU、SNW、SNRW 和 X锁。

    

      

        
granted matrix

        

          
  Request  |  Granted requests for lock       |
   type    | S  SH  SR  SW  SU  SNW  SNRW  X  |
 ----------+----------------------------------+
 S         | +   +   +   +   +   +    +    -  |
 SH        | +   +   +   +   +   +    +    -  |
 SR        | +   +   +   +   +   +    -    -  |
 SW        | +   +   +   +   +   -    -    -  |
 SU        | +   +   +   +   -   -    -    -  |
 SNW       | +   +   +   -   -   -    -    -  |
 SNRW      | +   +   -   -   -   -    -    -  |
 X         | -   -   -   -   -   -    -    -  |
 SU -> X   | -   -   -   -   0   0    0    0  |
 SNW -> X  | -   -   -   0   0   0    0    0  |
 SNRW -> X | -   -   0   0   0   0    0    0  |

        

        
关于’0’的情况说明下，比如对于SU锁来说其和自身是不兼容的，不可能有2个线程对同一个对象都持有SU锁，所以就不存在当一个线程进行锁升级时，另一个线程持有SU。其它’0’的情况类似。

      

      

        
waiting matrix

        

          
  Request  |  Pending requests for lock      |
   type    | S  SH  SR  SW  SU  SNW  SNRW  X |
 ----------+---------------------------------+
 S         | +   +   +   +   +   +     +   - |
 SH        | +   +   +   +   +   +     +   + |
 SR        | +   +   +   +   +   +     -   - |
 SW        | +   +   +   +   +   -     -   - |
 SU        | +   +   +   +   +   +     +   - |
 SNW       | +   +   +   +   +   +     +   - |
 SNRW      | +   +   +   +   +   +     +   - |
 X         | +   +   +   +   +   +     +   + |
 SU -> X   | +   +   +   +   +   +     +   + |
 SNW -> X  | +   +   +   +   +   +     +   + |
 SNRW -> X | +   +   +   +   +   +     +   + |

        

        
注意 SH 比 X 锁的优先级还高，正是其高优先级(high priority)的体现。

      

    

    
在MDL系统中，资源关系是这样的：

    

      
线程和锁的关系通过ticket建立；

      
每个线程有3个ticket链表，分别对应当前持有的statement锁、transaction锁和显式锁，放在 
MDL_context::m_tickets
中；对于当前线程正在等待的锁只有一个，用
MDL_context::m_waiting_for
表示；

      
每个MDL锁有2个ticket链表，分别对应已经获得锁的线程（
MDL_lock::m_granted
）和等待锁的线程（
MDL_lock::m_waiting
）；

      
线程的ticket链表和MDL锁的ticket链表一起构成了MDL系统的等待关系图，死锁检测就是搜索这张图，看是否有环路。

    

    
为了描述的简洁，我们将线程和MDL锁的ticket链表都简化为1个，如下图2矩阵的，横线表示线程的链表，纵向表示MDL锁的链表，有色彩的交点表示一个ticket，橘黄色表示连接已经拿到锁，青色表示正在等待的锁，图中MDL上锁的类型不兼容，形成持有等待回路——死锁。

    

      

    

    
图2. MDL死锁

    
下面介绍下死锁检测中的函数。

    
MDL_context::find_deadlock

这个是死锁检测的入口，线程在
MDL_context::acquire_lock
尝试拿锁失败，进入等待之前，会调用这个函数进行一次死锁检测。

    
函数会行循环检测，直到发现没有死锁（每轮检测会去掉等待图中一条边，但不保证能解决死锁，所以需要循环），或者当前线程被选为victim才退出。

    
MDL_context::visit_subgraph

看当前线程是否有锁等待
MDL_context::m_waiting_for
，有的话就沿着ticket搜下去，没有就退出。

    
MDL_ticket::accept_visitor

这个方法看起来没有什么实际内容，只是简单调用
MDL_lock::visit_subgraph
，其实可以看作是搜索视角的转换，从 
MDL_context
 经过 
MDL_ticket
 进入到 
MDL_lock
，代码逻辑显得比较清晰。

    
MDL_lock::visit_subgraph

这个是死锁检测核心逻辑：

    

      
先给搜索深度加1，然后判断是否超过最大搜索深度（MAX_SEARCH_DEPTH= 32），超过就无条件认为有死锁，退出；

      
遍历当前锁的ticket链表，看ticket对应的线程是否和死锁检测的发起线程是同一个，如果是则说明有回路，退出（相当于做了一层的广度搜索）；

      
从头开始遍历当前锁的ticket链表，对每个ticket对应的线程，递归调用
MDL_context::visit_subgraph
（深度搜索）。

    

    
整个死锁检测逻辑是一个加了深度限制的深搜，中间同时多了一层广搜。

    
Deadlock_detection_visitor 是死锁检测中重要的辅助类，主要负责：

    

      
记录死锁检测的起始线程；

      
记录被选做victim的线程；

      
在检测到死锁，深搜一层层退出的时候，会依次检查回路上各线程的死锁权重，选择权重最小的做为最终的victim（权重由锁的类型决定）。

    

    
global read lock

    
相信FTWRL（FLUSH TABLES WITH READ LOCK）这个命令很多人都用过，比如备份时为了获取SQL线程执行位点或binlog位点，这个命令的目的是阻止新的更新进来和已有事务的提交。就这个命令主要靠MDL锁来实现，这里用到了2个MDL锁，namespace分别为
MDL_key::GLOBAL
和
MDL_key::COMMIT
，这2个锁在整个MDL系统中都是全局唯一的，都是
MDL_scoped_lock
类型。

    
执行 FTWRL 的线程会请求这2个锁的MDL_SHARED锁，并且是显式的。在所有更新数据的代码路径里，除了必须的锁外，还会额外请求
MDL_key::GLOBAL
锁的MDL_INTENTION_EXCLUSIVE锁；在事务提交前，会先请求
MDL_key::COMMIT
锁的MDL_INTENTION_EXCLUSIVE锁。对于scope锁来说，IX锁和S锁是不兼容的（参考granted matrix），所以更新和事务提交都被FTWRL挡到了。

    
Percona Server 实现的相对于 FTWRL 轻量级的backup锁也是基于MDL实现的，其对MDL_key的 namespace 额外扩展了2个，
MDL_key::BACKUP
和
MDL_key::BINLOG
，对应的2个锁也是全局唯一的，感兴趣的同学可以了解下
backup locks
。

  

  

    

    

    
Test Book

  

  

    
PG默认每个page的大小为8K，PG数据页写入是以page为单位，但是在断电等情况下，操作系统往往不能保证单个page原子地写入磁盘，这样就极有可能导致部分数据块只写到4K(操作系统是一般以4K为单位)，这些“部分写”的页面包含新旧数据的混合。在崩溃后的恢复期间，xlog 里面存储的记录变化信息不够完整，无法完全恢复该页。PG为了解决这类问题，full_page_write机制孕育而生。

    
什么是full_page_write？

    
PostgreSQL 在 checkpoint 之后在对数据页面的第一次写的时候会将整个数据页面写到 xlog 里面。当出现主机断电或者OS崩溃时，redo操作时通过checksum发现“部分写”的数据页，并将xlog中保存的这个完整数据页覆盖当前损坏的数据页，然后再继续redo就可以恢复整个数据库了。

除了能够解决断电等带来坏数据页问题外，full_page_write 还应用在在线备份功能上。PG进行全量备份数据库一般通过pg_basebackup工具实现，pg_basebackup类似于copy操作，在此期间，也会出现部分数据页写到一半时文件被copy走了，正是因为full_page_write存在，备份出来的数据库才可以成功恢复启动。所以即便full_page_write=off，在备份时也会被强制自动打开，保证备份成功。

    
实现原理

    
full_page_write主要在XLogInsert(插入一条xlog记录)时发挥作用，通过full_page_writer开关状态以及是否是checkpoint后对数据页面的第一次修改(lsn<RedoRecPtr)判断是否需要备份数据页。如果需要备份，那么则把数据页存放在这条记录的末尾，最终写入到xlog中。

    

      
doPageWrites = Insert->fullPageWrites || Insert->forcePageWrites;
/* Find info for buffer */
for (i = 0; i < XLR_MAX_BKP_BLOCKS; i++)
{
    if (dtbuf[i] == InvalidBuffer)
    {
        /* OK, put it in this slot */
        dtbuf[i] = rdt->buffer;
        if (doPageWrites && XLogCheckBuffer(rdt, true,&(dtbuf_lsn[i]), &(dtbuf_xlg[i])))
        {
            dtbuf_bkp[i] = true;
            rdt->data = NULL;
            rdt->len = 0;
        }
        break;
    }
    ......
}

    

    
在redo恢复的时候只要数据块有备份，那么就是用备份的数据。

    

      
/* If we have a full-page image, restore it and we're done */
if (record->xl_info & XLR_BKP_BLOCK(0))
{
    (void) RestoreBackupBlock(lsn, record, 0, false, false);
    return;
}

    

    

      

    

    
full_page_write不足之处

    
因为full_page_write需要在xlog中记录数据页，会写更多xlog文件，不仅有数据变化信息，还有数据页本身信息，这样会增加额外的IO和磁盘消耗，同时也会引起主备延迟变大。

为了优化full_page_write，社区提供了一个patch，它的主要设计是创建两个共享内存块队列，checkpoint专用buffer队列和非checkpoint专用buffer队列，同时关闭full_page_write。当用户DML产生的数据buffer需要刷盘时，并不是立即刷到磁盘，而是先进入double write的buffer队列，当buffer队列满时，则将buffer队列里面的数据首先刷到特别的double write文件，然后再将数据刷到数据库文件。通过这种设计就不需要在checkpoint 之后在对数据页面的第一次写的时候会将整个数据页面写到 xlog 里面。当数据库需要恢复的时候，遍历所有double write文件里面的记录块，找到每个记录块对应的数据库page，然后对这个page进行checksum，如果page损坏，那么直接把记录块里面的内容覆盖到buffer数据。最后把double write文件删除，重新初始化buffer队列。

    

      

    

    
总结

    
把full_page_write这个选项关闭会提高数据库执行速度以及减少xlog数量，但是可能导致系统崩溃或者掉电之后的数据库损坏。如果有减小部分页面写入风险的硬件支持（比如电池供电的磁盘控制器），或者文件系统支持(能够保证page写入原子性)，可以把风险降低到一个可以接受的范围，那么可以考虑关闭这个选项，其他情况下建议打开这个选择。

  

  

    

    

    
Test Book

  

  

    
外键约束异常现象

    
如下测例中，没有违反引用约束的插入失败。

    

      
create database `a-b`;
use `a-b`;
SET FOREIGN_KEY_CHECKS=0;
create table t1(c1 int primary key, c2 int) engine=innodb;
create table t2(c1 int primary key, c2 int) engine=innodb;
alter table t2 add  foreign key(c2)  references `a-b`.t1(c1);
SET FOREIGN_KEY_CHECKS=1;
insert into t1 values(1,1);
select * from t1;
c1      c2
1       1
select * from t2;
c1      c2
insert into t2 values(1,1);
ERROR 23000: Cannot add or update a child row: a foreign key constraint fails (`a-b`.`t2`, CONSTRAINT `t2_ibfk_1` FOREIGN KEY (`c2`) REFERENCES `a-b`.`t1` (`c1`))
insert into t2 values(1,1); //预期应该成功实际失败了。子表插入任何数据都会报违反引用约束。

    

    
异常分析

    
首先我们会检查表结构是否正常

    

      
show create table t2;
Table   Create Table
t2      CREATE TABLE `t2` (
  `c1` int(11) NOT NULL,
  `c2` int(11) DEFAULT NULL,
  PRIMARY KEY (`c1`),
  KEY `c2` (`c2`),
  CONSTRAINT `t2_ibfk_1` FOREIGN KEY (`c2`) REFERENCES `a-b`.`t1` (`c1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

    

    
查看 innodb_sys_foreign 表

    

      
select * from information_schema.innodb_sys_foreign where id='a@002db/t2_ibfk_1';
+-------------------+------------+----------+--------+------+
| ID                | FOR_NAME   | REF_NAME | N_COLS | TYPE |
+-------------------+------------+----------+--------+------+
| a@002db/t2_ibfk_1 | a@002db/t2 | a-b/t1   |      1 |    0 |
+-------------------+------------+----------+--------+------+

select * from information_schema.innodb_sys_tables where name='a@002db/t1';
+----------+------------+------+--------+-------+-------------+------------+---------------+
| TABLE_ID | NAME       | FLAG | N_COLS | SPACE | FILE_FORMAT | ROW_FORMAT | ZIP_PAGE_SIZE |
+----------+------------+------+--------+-------+-------------+------------+---------------+
|      530 | a@002db/t1 |    1 |      5 |   525 | Antelope    | Compact    |             0 |
+----------+------------+------+--------+-------+-------------+------------+---------------+

    

    
表结构正常，表面上看外键在系统表中元数据库信息正常。仔细比较发现 innodb_sys_foreign 的REF_NAME字段”a-b/t1”实际应为”a@002db/t2”。

    
MySQL内部表名和库名存储格式

    
MySQL 内部用 my_charset_filename 字符集来表名和库名。

    
以下数组定义了 my_charset_filename 字符集需要转换的字符。数组下标为 ascii 值，1代表不需要转换。可以看到字母数字和下划线等不需要转换，同时字符’-‘是需要转换的， 转换函数参见
my_wc_mb_filename
。

    

      
static char filename_safe_char[128]=
{
  1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, /* ................ */
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, /* ................ */
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, /*  !"#$%&'()*+,-./ */
  1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0, /* 0123456789:;<=>? */
  0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, /* @ABCDEFGHIJKLMNO */
  1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1, /* PQRSTUVWXYZ[\]^_ */
  0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, /* `abcdefghijklmno */
  1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0, /* pqrstuvwxyz{|}~. */
};

    

    
异常分析

    
由上节可知，字符’-‘作为库名或表名是需要转换的。innodb_sys_foreign 中 FOR_NAME 值是转换过的，只有 REF_NAME 未转换，而系统表 innodb_sys_tables 中存储的表名是转换后的。
dict_get_referenced_table
 根据未转换的表名 a-b/t1 去系统表 SYS_TABLES 查找会查找不到记录。于是会导致

    

      
 foreign->referenced_table==NULL

    

    
因此对子表的任何插入都会返回错误 DB_NO_REFERENCED_ROW，如下代码

    

      
row_ins_check_foreign_constraint:

 if (check_ref) {
         check_table = foreign->referenced_table;
         check_index = foreign->referenced_index;
 } else {
         check_table = foreign->foreign_table;
         check_index = foreign->foreign_index;
 }

if (check_table == NULL
    || check_table->ibd_file_missing
    || check_index == NULL) {

        if (!srv_read_only_mode && check_ref) {
                ……
                err = DB_NO_REFERENCED_ROW;
        }

        goto exit_func;

    

    
经过进一步调试分析发现，函数
innobase_get_foreign_key_info
中主表的库名和表名都没有经过转换，而是直接使用系统字符集。

    
回过头再看看bug的触发条件：

    

      
表名或库名包含特殊字符；

      
此表作为引用约束的主表；

      
增加引用约束是设置了SET FOREIGN_KEY_CHECKS=0；

    

    
这里强调下第3条, 如果上面的测例中去掉了SET FOREIGN_KEY_CHECKS=0，那么结果 REF_NAME会正常转换

    

      
SET FOREIGN_KEY_CHECKS=1;
create table t1(c1 int primary key, c2 int) engine=innodb;
create table t2(c1 int primary key, c2 int) engine=innodb;
alter table t2 add  foreign key(c2)  references `a-b`.t1(c1);
select * from information_schema.innodb_sys_foreign where id='a@002db/t2_ibfk_1';
+-------------------+------------+------------+--------+------+
| ID                | FOR_NAME   | REF_NAME   | N_COLS | TYPE |
+-------------------+------------+------------+--------+------+
| a@002db/t2_ibfk_1 | a@002db/t2 | a@002db/t1 |      1 |    0 |
+-------------------+------------+------------+--------+------+

    

    
online DDL 与 foreign key

    
MySQL 5.6 online DDL 是支持建索引的。而对于建外键索引同样也是支持的，条件是SET FOREIGN_KEY_CHECKS=0。

    

      
ha_innobase::check_if_supported_inplace_alter：
 if ((ha_alter_info->handler_flags
      & Alter_inplace_info::ADD_FOREIGN_KEY)
     && prebuilt->trx->check_foreigns) {
         ha_alter_info->unsupported_reason = innobase_get_err_msg(
                 ER_ALTER_OPERATION_NOT_SUPPORTED_REASON_FK_CHECK);
         DBUG_RETURN(HA_ALTER_INPLACE_NOT_SUPPORTED);
 }

    

    
SET FOREIGN_KEY_CHECKS=0时，
prebuilt->trx->check_foreigns
为false。

    
我们再来看出问题的函数
innobase_get_foreign_key_info
，只有online DDL的代码路径才会调用此函数：

    

      
#0  innobase_get_foreign_key_info
#1  ha_innobase::prepare_inplace_alter_table
#2  handler::ha_prepare_inplace_alter_table
#3  mysql_inplace_alter_table
#4  mysql_alter_table
......

    

    
而非online DDL的路径如下，函数 
dict_scan_id
 会对表名和库名进行转换：

    

      
#0  dict_scan_id
#1  dict_scan_table_name
#2  dict_create_foreign_constraints_low
#3  dict_create_foreign_constraints
#4  row_table_add_foreign_constraints
#5  ha_innobase::create
#6  handler::ha_create
#7  ha_create_table
#8  mysql_alter_table
......

    

    
修复

    
bug系统中虽然没有相关的bug信息，但从MySQL 5.6.26中我们看到官方Bug#21094069已经进行了修复，在
innobase_get_foreign_key_info
中对库名和表名进行转换。

    
参考commit:
1fae0d42c352908fed03e29db2b391a0d2969269

  

  

    

    

    
Test Book

  

  

    
本文我们从一个索引选择的问题出发，来研究一下 MySQL 中 range 代价的计算过程，进而分析这种计算过程中存在的问题。

    
问题现象

    
第一种情况：situation_unique_key_id

    

      
mysql> show create table cpa_order\G
*************************** 1\. row ***************************
       Table: cpa_order
Create Table: CREATE TABLE `cpa_order` (
  `cpa_order_id` bigint(20) unsigned NOT NULL,
  ...
  `settle_date` date DEFAULT NULL COMMENT,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`cpa_order_id`),
  UNIQUE KEY `id` (`id`),
  KEY `cpao_settle_date_id` (`settle_date`,`id`),
) ENGINE=InnoDB DEFAULT CHARSET=gbk
1 row in set (0.00 sec)

mysql> explain select * from cpa_order where settle_date='2015-11-05' and id > 15 \G
*************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: cpa_order
         type: ref
possible_keys: id,cpao_settle_date_id
          key: cpao_settle_date_id
      key_len: 4
          ref: const
         rows: 7
        Extra: Using index condition
1 row in set (0.00 sec)

    

    
SQL 语句执行过程可以看出，当 id 为 unique key 的时候，key_len= 4, 不难发现联合索引只使用了字段 cpao_settle_date_id ，而 id 并没有使用；

    
第二种情况：situation_without_key_id

    

      
mysql> alter table cpa_order drop index id;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> explain select * from cpa_order where settle_date='2015-11-05' and id > 15 \G （我们称之为 situation_without_key_id）
*************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: cpa_order
         type: range
possible_keys: cpao_settle_date_id
          key: cpao_settle_date_id
      key_len: 12
          ref: NULL
         rows: 3
        Extra: Using index condition
1 row in set (0.00 sec)

    

    
第三种情况: situation_plain_key_id

    

      
mysql> explain select * from cpa_order where settle_date='2015-11-05' and id > 15 \G （我们称之为 situation_plain_key_id）
*************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: cpa_order
         type: range
possible_keys: cpao_settle_date_id,id
          key: cpao_settle_date_id
      key_len: 12
          ref: NULL
         rows: 3
        Extra: Using index condition
1 row in set (0.01 sec)

    

    
以上的两个 SQL 语句在使用索引 cpao_settle_date_id 的时候两个字段都使用到了，因此过滤性应该更好，我们将上面的3种情况分别称之为 situation_unique_key_id，situation_without_key_id，situation_plain_key_id，以方便我们分析问题。

    
为什么在 id 为 unique 的时候联合索引只使用了其中的一个字段而没有字段 id ?

    
原因分析

    
MySQL 有一个很好的东东叫 optimizer trace，它提供了 MySQL 执行计划生成的各个阶段的详细信息，其中索引部分的分析更是详细，但是由于 optimizer trace 的东西比较多，我们在分析的时候只将本文相关的内容进行展开，optimizer trace 的
详细使用
。

    
打开并使用 optimizer_trace 功能，观察situation_unique_key_id 的代价生成过程的：

    

      
mysql> set optimizer_trace="enabled=on";
Query OK, 0 rows affected (0.00 sec)

mysql> select * from cpa_order where settle_date='2015-11-05' and id > 15 \G
3 rows in set (0.00 sec)

mysql> select * from information_schema.OPTIMIZER_TRACE\G

    

    
在 range 代价计算后，优化器会选择一个代价较小的 index 生成一个 read_plan 缓存起来，根据下面的代价计算过程可以看到，索引在代价计算过程中虽然是相等的，但先入为主，选择的其实是 id 这个索引。

    
range 部分的代价计算过程：

    

      
"range_scan_alternatives": [
                      {
                        "index": "id",
                        "ranges": [
                          "15 < id"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 3,
                        "cost": 4.61,
                        "chosen": true
                      },
                      {
                        "index": "cpao_settle_date_id",
                        "ranges": [
                          "2015-11-05 <= settle_date <= 2015-11-05 AND 15 < id"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 3,
                        "cost": 4.61,
                        "chosen": false,
                        "cause": "cost"
                      }

    

    
表的索引选择过程，主要是 ref & range 的索引方式的选择：

    

      
"considered_execution_plans": [
              {
                "plan_prefix": [
                ],
                "table": "`cpa_order`",
                "best_access_path": {
                  "considered_access_paths": [
                    {
                      "access_type": "ref",
                      "index": "cpao_settle_date_id",
                      "rows": 7,
                      "cost": 3.4,
                      "chosen": true
                    },
                    {
                      "access_type": "range",
                      "rows": 3,
                      "cost": 5.21,
                      "chosen": false
                    }
                  ]
                },
                "cost_for_plan": 3.4,
                "rows_for_plan": 7,
                "chosen": true
              }
            ]

    

    
可以看到优化器在比较 ref & range 的代价的时候，ref 的代价更小，所以选择的是ref，到这里我们觉得选择 ref 是“合理”的，但是当我们想到联合索引的作用时，我们应该觉得这是“不正常的”，至少这不应该是最终的索引选择方式。

    
观察 situation_without_key_id 的代价及生成过程，其 optimizer_trace 如下：

    
range 部分的代价计算过程：

    

      
                  "analyzing_range_alternatives": {
                    "range_scan_alternatives": [
                      {
                        "index": "cpao_settle_date_id",
                        "ranges": [
                          "2015-11-05 <= settle_date <= 2015-11-05 AND 15 < id"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 3,
                        "cost": 4.61,
                        "chosen": true
                      }
                    ],
                    "analyzing_roworder_intersect": {
                      "usable": false,
                      "cause": "too_few_roworder_scans"
                    }
                  },

    

    
表的索引选择过程：

    

      
            "considered_execution_plans": [
              {
                "plan_prefix": [
                ],
                "table": "`cpa_order`",
                "best_access_path": {
                  "considered_access_paths": [
                    {
                      "access_type": "ref",
                      "index": "cpao_settle_date_id",
                      "rows": 7,
                      "cost": 3.4,
                      "chosen": true
                    },
                    {
                      "access_type": "range",
                      "rows": 3,
                      "cost": 5.21,
                      "chosen": false
                    }
                  ]
                },
                "cost_for_plan": 3.4,
                "rows_for_plan": 7,
                "chosen": true
              }
            ]

    

    
可以看到，由于 where 条件中只有 cpao_settle_date_id & id 部分，索引选择的仍是ref, 其代价的计算结果与 situation_unique_key_id 中的代价是一致的，但是在 optimizer_trace 后面发现了如下的优化：

    

      
"attaching_conditions_to_tables": {
              "original_condition": "((`cpa_order`.`settle_date` = '2015-11-05') and (`cpa_order`.`id` > 15))",
              "attached_conditions_computation": [
                {
                  "access_type_changed": {
                    "table": "`cpa_order`",
                    "index": "cpao_settle_date_id",
                    "old_type": "ref",
                    "new_type": "range",
                    "cause": "uses_more_keyparts"
                  }
                }

    

    
这里我们不难看出，在计算的结尾处优化器做了个优化，就是把 id 字段也考虑了进来，我们根据 attached_conditions_computation 的提示找到了如下代码:

    

      
      if (tab->type == JT_REF &&                                  // 1)
          !tab->ref.depend_map &&                                 // 2)
          tab->quick &&                                           // 3)
          (uint) tab->ref.key == tab->quick->index &&             // 4)
          tab->ref.key_length < tab->quick->max_used_key_length)  // 5)
      {
        tab->type=JT_ALL;
        use_quick_range=1;
        tab->use_quick=QS_RANGE;
        tab->ref.key= -1;
        tab->ref.key_parts=0;
      }

    

    
结合注释，我们可以这样理解：

    

      
ref 与 range 使用的是相同的索引；

      
当前 table 选择的索引采用的是ref；

      
ref key 的使用的长度小于 range 的长度，则优先使用 range。

    

    
因此，在 situation_without_key_id 时，三个条件都满足，所以使用了 range 中的联合索引，那为什么 situation_unique_key_id 没有使用 id 呢，原因是在range 的代价计算过程中使用的是 id 这个索引，导致 unique id 这个索引与联合索引 cpao_settle_date_id 并不是同样的索引，不满足第一个条件，因此不进行优化。

    
有了上面的分析，我们观察 situation_plain_key_id 的代价及生成过程，situation_plain_key_id 在 range 的代价计算过程中选择的是 cpao_settle_date_id 索引，计算过程是将后者的计算结果与前者进行比较，因此即使相等，也是先入为主，其optimizer_trace如下：

    
range 部分的代价计算过程：

    

      
                    "range_scan_alternatives": [
                      {
                        "index": "cpao_settle_date_id",
                        "ranges": [
                          "2015-11-05 <= settle_date <= 2015-11-05 AND 15 < id"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 3,
                        "cost": 4.61,
                        "chosen": true
                      },
                      {
                        "index": "id",
                        "ranges": [
                          "15 < id"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 3,
                        "cost": 4.61,
                        "chosen": false,
                        "cause": "cost"
                      }
                    ]

    

    
表的索引选择过程：

    

      
            "considered_execution_plans": [
              {
                "plan_prefix": [
                ],
                "table": "`cpa_order`",
                "best_access_path": {
                  "considered_access_paths": [
                    {
                      "access_type": "ref",
                      "index": "cpao_settle_date_id",
                      "rows": 7,
                      "cost": 3.4,
                      "chosen": true
                    },
                    {
                      "access_type": "range",
                      "rows": 3,
                      "cost": 5.21,
                      "chosen": false
                    }
                  ]
                },
                "cost_for_plan": 3.4,
                "rows_for_plan": 7,
                "chosen": true
              }
            ]

    

    
结合上面的分析我们发现，ref & range 选择都是索引 cpao_settle_date_id，因此在最后的选择阶段也会进行索引的优化，与开头的问题表现相符。

    
range 代价计算过程

    
优化器在索引选择的过程中会将where 条件、join 条件等信息进行收集，对于非等值的索引会放到 possible keys 中，进行 range 部分的代价计算，对于等值相关字段的索引会进行 ref 部分的代价计算，如果是单表，其主要过程如下：

    

      

        
调用 
get_key_scans_params
 从已知的索引中选择一个代价最小的 read_plan，利用 read_plan 生成一个读表的计划，缓存至 tab->quick 中；

      

      

        
在 
best_access_path
 中计算:

        

          
全表的代价

          
如果有覆盖索引则计算覆盖索引的代价

          
如果有quick，则利用一些校验值计算上一步产生的 range 的代价

        

        
然后取其中最小的值用做当前表的代价；

      

      
在 
make_join_select
 中对已经生成的执行计划进行较正，如 situation_plain_key_id 的优化部分。

    

    
多表的计算过程更为复杂，不在此描述。

    
问题解答

    
为什么在 id 为 unique 的时候联合索引只使用了其中的一个字段而没有字段 id ?

    
由于 situation_unique_key_id 中在计算 range 的过程中使用的是索引 id 而不是 cpao_settle_date_id，因此不符合最后优化的条件，因此只使用了 cpao_settle_date_id 的前一部分而没有使用 id，这是优化器在实现过程中的问题。

    
range 代价计算过程可能引起的问题

    
我们已经了解了 range 代价计算的过程，可以发现可能会有以下问题：

    

      
当多个索引得到的代价是相同的，由于先入为主，只能缓存第一个，所以会有索引出错的问题；

      
每一次计算 range 的代价都会将缓存清空，如 order by limit 操作，这样有可能将之前的索引清空且走错索引，详情见 
bug#78993
。

    

    
小结

    
当执行计划出错的时候，我们可以有效的利用 optimizer_trace 来进行初步的分析，大部分还是有解的。另外由于执行计划的内容比较多，从本篇起，小编会尽量将优化器相关的东西给大家介绍一下，主要包括 optimizer_swith 的选项、含义、作用、以及在内核中是如何实现的，达到一起学习的目的。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
表结构如下所示:

    

      
show create table test\G
       Table: test
Create Table: CREATE TABLE `test` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id2` varchar(50) DEFAULT NULL
  `id3` varchar(100) DEFAULT NULL
  `some_text` varchar(200) DEFAULT NULL
  `name` varchar(20) DEFAULT NULL
  `another_text` varchar(500) DEFAULT NULL
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8

    

    
对 mysql 执行如下语句:

    

      
select count(distinct(id2))
from santo_test
where id3 = 'hahaha'
group by substr(ctime, 0, 10)

    

    
会导致mysql crash(signal 11)。

    
崩溃堆栈如下:

    

      
pthread_kill ()
handle_segfault (sig=11)
 <signal handler called>
ptr_compare ()
queue_insert ()
merge_buffers()
merge_many_buff()
filesort()
create_sort_index()
JOIN::exec()
mysql_select()
handle_select()
execute_sqlcom_select()
mysql_execute_command()
mysql_parse()
...

    

    

官方bug传送
。

    
Bug复现小贴士

一条select语句搞挂MySQL Server? 当然还是需要苛刻条件的：

    

      
需要保证 sort by/group by 的列本身是 CHAR(0) NOT NULL, 值也要多样化, 不然会直接在优化器被优化掉;

      
接着该列不能有索引, 确保逻辑走到filesort(在对索引列做GROUP BY/ORDER BY时直接走索引)；

      
之后要配备足够小的
sort_buffer_size
, 和足够量大的数据撑满 sort_buffer，如@@sort_buffer_size = 32768时，40行数据就可以触发；

      
然后默默的给 substr 函数投喂错误的参数。

    

    
BOOM!

    
搞完破坏, 我们来看问题怎么解。

    
成因解析

    
在看到触发 crash 语句的时候，一定有读者发现哪里不对了。这里使用的 substr(some_string, 0, some_length) 这样的写法，而官方文档中 substr 函数的 @param2 实际上是从1开始计算，当起始位置置为0的时候，这条语句返回值其实是空的。当然，最终导致压坏 mysql server 的一根稻草，正是这个长度为0的字符串。

    
现在我们沿着执行路线来探索 mysql 是如何一步步挂掉的，在 select 语句中使用 order by/group by 语句时，server 通常调用排序，主要通过索引或者 filesort 来实现排序，在 group by/order by 的列上不存在索引时，server 会选择使用 filesort，其主要逻辑见 filesort.cc:filesort()。这里还会涉及到一个变量，
sort_buffer_size
，当需要排序的数据量超过 
sort_buffer_size
 大小时，server 会将数据划分为 trunks，这时调用 
merge_many_buffers()
。随后一路调用到 mysys/ptr_cmp.c 文件中的比较函数，这里的比较函数是按字节进行的，每四个字节为一个比较单位，当传入的参数长度小于4时，会调用 
ptr_compare()
，而在上节的调用栈可以看到，最后 crash 就是在这个函数里。函数槽点如下:

    

      
static int ptr_compare(size_t *compare_length, uchar **a, uchar **b)
{
  reg3 int length= *compare_length;
  reg1 uchar *first,*last;

  first= *a; last= *b;
  while ( --length)
  {
    if (*first++ != *last++)
      return (int) first[-1] - (int) last[-1];
  }
  return (int) first[0] - (int) last[0];
}

    

    
在 lengh == 0 时，while 里就会根本停不下来，直到被比较的两位指针不停自加到一个不能访问的内存区域，逼迫系统用 signal 11 杀死 mysql server。

    
解决方案

    
比较长度为0的字符串本身是个意外, 所以解决方案就是添加一个辅助函数 
ptr_compare_length_zero
，在 length 为0时直接返回0，在做排序函数分派时，将长度为0的比较指派到
ptr_compare_length_zero
。

因此，想搞挂MySQL Server，这条路已经被堵上了，还是多修bug少搞破坏比较好 :-)

    

      
官方fix1
60c6920509516a1e05b855799479a59c27803191

      
官方fix2 
b62c5daa646434290c9b2d1c9b162487cb8edf04

      

        
MySQL · 社区动态 · MySQL5.6.26 ReleaseNote解读

      

    

  

  

    

    

    
Test Book

  

  

    
前言

    
4月份月报有篇文章《
行锁(row-lock)与区间锁(range-lock)
》，介绍了 TokuDB 的行锁/区间锁是如何使用的。这篇文章是其姐妹篇，介绍TokuDB行锁的实现，大家可以对照着看。

    
行锁申请

    
与 InnoDB 类似，TokuDB 也支持行级锁用来协调多个 txn 对数据库表某一段数据的并发访问。一个表中所有已经 grant 的行锁是用一个 binary search tree 来表示的，TokuDB 的术语称它为 lock tree。lock tree 与数据库表之间是一一对应的关系。当打开 cursor 读写 TokuDB 数据库的时候，需要首先尝试申请row lock，成功后再调用 
db_put
/
ha_tokudb::read_range_first
 方法来读写数据。TokuDB 的 row lock 是用 range lock 表示的，一个 range lock 代表按key值连续的一个行锁区间。rangelock是一个同步锁，如果获取成功立即返回；若失败则会同步等待若干时间，等待超时整个操作就会失败返回。range lock的申请分为三个阶段，下面将逐个说明。

    

      

        
创建range lock：在TokuDB中就是创建一个 lock_request 对象

创建的过程很简单，主要是初始化，创建成功后调用 lock_request 的 start 函数来申请锁；

      

      

        
申请range lock：大部分事情都在这个阶段完成的

申请锁的时候需要指定五元组（lt，txn，type，left_key，right_key），分别表示数据库表对应的lock tree，txn结构，锁类型（read/write)，键值区间（left_key, right_key)。申请的时候会根据锁 类型来调用 locktree 的 
acquire_write
/
read_lock
方法来获取锁。这里有个 tricky 的地方：在 locktree 实现中隐式地将 read lock 升级成 write lock。

在获取锁的函数里面，首先调用了 
check_current_lock_constraints
 来进行 throttle 控制当前锁占用的内存，这块不展开讨论了。

locktree 有一个为 single txn 做的优化，当系统猜测当前是工作在 single txn 的方式下（不存在锁竞争的问题），所有的锁都会被 grant 并记录在 sto_buffer 里面。如果不是 single txn 的模式，已经 grant 的锁则保存在 concurrent_tree 里面，这个就是我们在前面提到的那个 binary search tree。Single txn 模式的判断是用启发式的方法，由两个因素控制 sto_buffer 和 concurrent_tree 的切换: 积分 score 和 sto_buffer 长度，因篇幅有限这块也留给大家分析了。要提的一点是如果正处在 single txn 模式，遇到了一个新的 txn，那么 sto_buffer 的锁会被转移到 concurrent_tree 上。

我们重点讨论是 concurrent_tree 的情况。函数 
acquire_lock_consolidated
 会根据五元组里面的 left_key 和 right_key 构造一个 request_range，然后用这个 range 在 concurrent_tree 上定位到与它存在 overlap 关系的最小子树，并把子树里面与 request_range 存在 overlapped 关系的那些锁保存在一个变长数组里面。然后 iterate 这个数组看看是否存在锁冲突，冲突的条件是与五元组里的 txnid 不同但锁区间是 overlapped 的。如果不存在锁冲突，就可以立即 grant 这个锁申请了。

剩下的是些维护工作，就是依次把区间重叠的已经 grant 的锁和我们正在申请的锁进行区间 merge，保证 concurrent_tree 里面的所有锁的区间都是不相交的（不overlapped的）。如果不幸，申请的锁和concurrent_tree里面的锁有冲突，那么请求操作会失败。

      

      
等待range lock：申请失败会把这个 range lock 放到 locktree 的 pending list 里等待以后重试。

锁申请失败可能是发生了死锁，还需要调用 deadlock_exists 递归构造锁等待 DAG 图判断是否真的发生了死锁。

    

    
举例说明

    
上面描述比较枯燥，我们结合4月份月报里的例子一起看看吧。

    

      
mysql> show create table t\G
--------------------------- 1. row ---------------------------
       Table: t
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=TokuDB DEFAULT CHARSET=latin1

mysql> set autocommit=off;
mysql> insert into t values (1),(10),(100);
mysql> select * from information_schema.tokudb_locks\G
--------------------------- 1. row ---------------------------
               locks_trx_id: 238
      locks_mysql_thread_id: 3
              locks_dname: ./test/t-main
             locks_key_left: 0001000000
            locks_key_right: 0001000000
        locks_table_schema: test
          locks_table_name: t
locks_table_dictionary_name: main
--------------------------- 2. row ---------------------------
               locks_trx_id: 238
      locks_mysql_thread_id: 3
             locks_dname: ./test/t-main
             locks_key_left: 000a000000
            locks_key_right: 000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
--------------------------- 3. row ---------------------------
               locks_trx_id: 238
      locks_mysql_thread_id: 3
              locks_dname: ./test/t-main
             locks_key_left: 0064000000
            locks_key_right: 0064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main

    

    
再看一个例子。id 是 primary key，c1 上有 index 。Insert 三条记录产生6个行锁，3个在primary key上，3个在c1 index上。primary key上锁的key值主要由pk值构成，非 unique 的 index 锁的 key 值主要由 index 上的 key 值和 primary key 值组成。

    

      
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `c1` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `c1` (`c1`)
) ENGINE=TokuDB DEFAULT CHARSET=latin1
1 row in set (0.00 sec)

mysql> alter table t2 add index (c1);
mysql> set autocommit=off;
mysql> insert into t values(1,2),(10,11),(100,101);
mysql> select * from information_schema.tokudb_locks\G
--------------------------- 1. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-main
             locks_key_left: 0001000000
            locks_key_right: 0001000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
--------------------------- 2. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-main
             locks_key_left: 000a000000
            locks_key_right: 000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
--------------------------- 3. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-main
             locks_key_left: 0064000000
            locks_key_right: 0064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
--------------------------- 4. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-key-c1
             locks_key_left: 00010200000001000000
            locks_key_right: 00010200000001000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: key-c1
--------------------------- 5. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-key-c1
             locks_key_left: 00010b0000000a000000
            locks_key_right: 00010b0000000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: key-c1
--------------------------- 6. row ---------------------------
               locks_trx_id: 451
      locks_mysql_thread_id: 1
             locks_dname: ./test/t-key-c1
             locks_key_left: 00016500000064000000
            locks_key_right: 00016500000064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: key-c1

    

    
问题探讨

    
前面描述中提到 locktree 会自动升级读锁为写锁，这会不会带来性能问题呢？我看看下面的例子，假设场景是 isolation 级别是 read commit，关闭autocommit。

    
例1：

    

      
txn1: select 执行 index range scan ==> 在 
read_range_first
 之前会尝试获取读锁 ==> locktree 自动把读锁升级为写锁

      
txn2: select 执行 index range scan，与 txn1 相同的 index，数据有 overlapped ==> 在 
read_range_first
 之前会尝试获取读锁 ==> locktree 自动把读锁升级为写锁

    

    
例2:

    

      
txn3: select 执行 index range scan ==> 在 
read_range_first
 之前会尝试获取读锁 ==> locktree 自动把读锁升级为写锁

      
txn4: insert 插入的数据落在 txn3 操作的区间内 ==> 在 
db_put
 之前会尝试获取写锁 ==> locktree 获取写锁

    

    
这样看起来 txn1 与 txn2，txn3 与 txn4 申请的 rangelock 存在 overlapped 关系，可能引起等待。但事实上，在 read commit 的隔离级别上，txn1&txn2，tx3&txn4 是不需要等待的。

    
TokuDB 中读数据申请 row lock 是在 
c_set_bounds
 函数实现的。
c_set_bounds
 有个tricky的处理：对于 READ_UNCOMMITTED，READ_COMMITTED 和 REPEATABLE_READ 隔离级别下并且没有设置 DB_RMW 标志的话，读数据是不需要去拿 range lock 的。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
bug 触发条件如下：

    

      
优化器先选择了 where 条件中字段的索引，该索引过滤性较好；

      
SQL 中必须有 order by limit 从而引导优化器尝试使用 order by 字段上的索引进行优化，最终因代价问题没有成功。

    

    
复现case

    
表结构

    

      
create table t1(
    id int auto_increment primary key,
    a int, b int, c int,
    key iabc (a, b, c),
    key ic (c)
) engine = innodb;

    

    
构造数据

    

      
insert into t1 select null,null,null,null;
insert into t1 select null,null,null,null from t1;
insert into t1 select null,null,null,null from t1;
insert into t1 select null,null,null,null from t1;
insert into t1 select null,null,null,null from t1;
insert into t1 select null,null,null,null from t1;
update t1 set a = id / 2, b = id / 4, c = 6 - id / 8;

    

    
触发SQL

    

      
mysql> explain select id from t1 where a<3 and b in (1, 13) and c>=3 order by c limit 2\G
*************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: t1
         type: index
possible_keys: iabc,ic
          key: iabc
      key_len: 15
          ref: NULL
         rows: 32
         Extra: Using where; Using index; Using filesort

    

    
使用 force index 可以选择过滤性好的索引

    

      
mysql> explain select id from t1 force index(iabc) where a<3 and b in (1, 13) and c>=3 order by c limit 2\G
*************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: t1
         type: range
possible_keys: iabc
          key: iabc
      key_len: 5
          ref: NULL
         rows: 3
        Extra: Using where; Using index; Using filesort

    

    
问题分析

    
optimizer_trace 可以帮助分析这个问题。

    
SELECT * FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE\G

    

      
                "range_scan_alternatives": [
                  {
                    "index": "iabc",
                    "ranges": [
                      "NULL < a < 3"
                    ],
                    "index_dives_for_eq_ranges": true,
                    "rowid_ordered": false,
                    "using_mrr": false,
                    "index_only": true,
                    "rows": 3,
                    "cost": 1.6146,
                    "chosen": true
                  },
                  {
                    "index": "ic",
                    "ranges": [
                      "3 <= c"
                    ],
                    "index_dives_for_eq_ranges": true,
                    "rowid_ordered": false,
                    "using_mrr": false,
                    "index_only": false,
                    "rows": 17,
                    "cost": 21.41,
                    "chosen": false,
                    "cause": "cost"
                  }
                ],

    

    
range_scan_alternatives 计算 range_scan，各个索引的开销，从上面的结果可以看出，联合索引 iabc 开销较小，应该选择 iabc。

    

      
        "considered_execution_plans": [
          {
            "plan_prefix": [
            ],
            "table": "`t1`",
            "best_access_path": {
              "considered_access_paths": [
                {
                  "access_type": "range",
                  "rows": 3,
                  "cost": 2.2146,
                  "chosen": true
                }
              ]
            },
            "cost_for_plan": 2.2146,
            "rows_for_plan": 3,
            "chosen": true
          }
        ]

    

    
considered_execution_plans 表索引选择过程，access_type 是 range，rows_for_plan=3，到这里为止，执行计划还是符合预期的。

    

      
      {
        "clause_processing": {
          "clause": "ORDER BY",
          "original_clause": "`t1`.`c`",
          "items": [
            {
              "item": "`t1`.`c`"
            }
          ],
          "resulting_clause_is_simple": true,
          "resulting_clause": "`t1`.`c`"
        }
      },
      {
        "refine_plan": [
          {
            "table": "`t1`",
            "access_type": "index_scan"
          }
        ]
      },
      {
        "reconsidering_access_paths_for_index_ordering": {
          "clause": "ORDER BY",
          "index_order_summary": {
            "table": "`t1`",
            "index_provides_order": false,
            "order_direction": "undefined",
            "index": "unknown",
            "plan_changed": false
          }
        }
      }

    

    
clause_processing 用于简化 order by，经过 clause_processing access_type 变成 index_scan（全索引扫描，过滤性较range差），此时出现了和预期不符的结果。

    
因此可以推测优化器试图优化 order by 时出现了错误：

    

      
第一阶段，优化器选择了索引 iabc，采用 range 访问；

      
第二阶段，优化器试图进一步优化执行计划，使用 order by 的列访问，并清空了第一阶段的结果；

      
第三阶段，优化器发现使用 order by 的列访问，代价比第一阶段的结果更大，但是第一阶段结果已经被清空了，无法还原，于是选择了代价较大的访问方式（index_scan），触发了bug。

    

    
问题解决

    

      
我们在索引优化函数
SQL_SELECT::test_quick_select
 最开始的时候保存访问计划变量（quick）；

      
在索引没变的时候，还原这个变量；

      
在索引发生改变的时候，删除这个变量。

    

    
在不修改 mysql 源码的情况下，可以通过 force index 强制指定索引规避这个bug。

    

SQL_SELECT::test_quick_select
 调用栈如下

    

      
    #0  SQL_SELECT::test_quick_select
    #1  make_join_select
    #2  JOIN::optimize
    #3  mysql_execute_select
    #4  mysql_select
    #5  mysql_explain_unit
    #6  explain_query_expression
    #7  execute_sqlcom_select
    #8  mysql_execute_command
    #9  mysql_parse
    #10 dispatch_command
    #11 do_command

    

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · InnoDB 全文索引简介

        

      

      

        

          
MySQL · 特性分析 · 跟踪Metadata lock

        

      

      

        

          
MySQL · 答疑解惑 · 索引过滤性太差引起CPU飙高分析

        

      

      

        

          
PgSQL · 特性分析 · PG主备流复制机制

        

      

      

        

          
MySQL · 捉虫动态 · start slave crash 诊断分析

        

      

      

        

          
MySQL · 捉虫动态 · 删除索引导致表无法打开

        

      

      

        

          
PgSQL · 特性分析 · PostgreSQL Aurora方案与DEMO

        

      

      

        

          
TokuDB · 捉虫动态 · CREATE DATABASE 导致crash问题

        

      

      

        

          
PgSQL · 特性分析 · pg_receivexlog工具解析

        

      

      

        

          
MySQL · 特性分析 · MySQL权限存储与管理

        

      

    

  

  

    

    

    
Test Book

  

  

    
前言

    
从MySQL5.6版本开始支持InnoDB引擎的全文索引，语法层面上大多数兼容之前MyISAM的全文索引模式。所谓全文索引，是一种通过建立倒排索引，快速匹配文档的方式。MySQL支持三种模式的全文检索模式：

    

      
自然语言模式（
IN NATURAL LANGUAGE MODE
），即通过MATCH AGAINST 传递某个特定的字符串来进行检索。

      

        
布尔模式（
IN BOOLEAN MODE
），可以为检索的字符串增加操作符，例如“+”表示必须包含，“-”表示不包含，“*”表示通配符（这种情况， 即使传递的字符串较小或出现在停词中，也不会被过滤掉），其他还有很多特殊的布尔操作符，可以通过如下参数控制：

        

          
 mysql> show variables like '%ft_boolean_syntax%';
 +-------------------+----------------+
 | Variable_name     | Value          |
 +-------------------+----------------+
 | ft_boolean_syntax | + -><()~*:""&| |
 +-------------------+----------------+
 1 row in set (0.00 sec)

        

      

      
查询扩展模式（
WITH QUERY EXPANSION
）, 这种模式是自然语言模式下的一个变种，会执行两次检索，第一次使用给定的短语进行检索，第二次是结合第一次相关性比较高的行进行检索。

    

    
目前MySQL支持在CHAR、VARCHAR、TEXT类型的列上定义全文索引。

    
本文只是简单的分析了全文索引涉及到的代码模块以及5.7的一些新特性，源码部分基于MySQL5.7.8-rc版本，更细节的部分并未深入。

    
创建全文索引

    
如下例所示，一个简单的创建带全文索引表的SQL：

    

      
create table t1 (a int auto_increment primary key, b text, fulltext(b));

    

    
磁盘上会产生多个文件：

    

      
$ls -lh /u01/my57/data/test/
total 1.3M

 FTS_000000000000010b_0000000000000154_INDEX_1.ibd
 FTS_000000000000010b_0000000000000154_INDEX_2.ibd
 FTS_000000000000010b_0000000000000154_INDEX_3.ibd
 FTS_000000000000010b_0000000000000154_INDEX_4.ibd
 FTS_000000000000010b_0000000000000154_INDEX_5.ibd
 FTS_000000000000010b_0000000000000154_INDEX_6.ibd
 FTS_000000000000010b_BEING_DELETED_CACHE.ibd
 FTS_000000000000010b_BEING_DELETED.ibd
 FTS_000000000000010b_CONFIG.ibd
 FTS_000000000000010b_DELETED_CACHE.ibd
 FTS_000000000000010b_DELETED.ibd
 t1.frm
 t1.ibd

    

    
除了t1.frm和t1.ibd外，共分为以下几类表

    

      

        
FTS_000000000000010b_0000000000000154_INDEX
1~6.ibd这6个文件用于存储倒排索引，存储的是分词和位置以及document ID，根据分词的第一个字符值进行分区，映射到不同的文件中；

文件的命名规则为FTS
{TABLE
ID}
{INDEX_ID}
INDEX
{N}.ibd

      

      

        
FTS_000000000000010b_DELETED.ibd 包含已经被删除的DOC_ID，但还没从全文索引数据中删掉；

FTS_000000000000010b_DELETED_CACHE.ibd 是前者的内存缓存（但是搜索了下代码，只有当
fts_cache_t::deleted_doc_ids
被使用时，才会在sync时转储到该表中，但并没有发现任何地方使用这个对象）

      

      

        
FTS_000000000000010b_BEING_DELETED_CACHE.ibd 和 FTS_000000000000010b_BEING_DELETED.ibd，包含了已经被删除索引记录并且正在从全文索引中移除的DOC ID，前者是后者的内存版本，这两个表主要用于辅助进行OPTIMIZE TABLE时将DELETED/DELETED_CACHED表中的记录转储到其中。

      

      
FTS_000000000000010b_CONFIG.ibd，包含全文索引的内部信息，最重要的存储是FTS_SYNCED_DOC_ID，表示已经解析并刷到磁盘的doc id， 在崩溃恢复时，可以根据这个值判断哪些该重新解析并加入到索引cache中。

    

    
建全文索引辅助表函数参考：

    

      
ha_innobase::create
     |--> create_table_info_t::create_table
            |--> fts_create_common_tables

    

    
当对一个已经存在的表上创建全文索引时，InnoDB采用了fork多个线程进行并发构建全文索引项的方法，并发度由参数 
innodb_ft_sort_pll_degree
 控制。因此在restore一个全文索引表时，我们建议先建表、导入数据，再在表上创建全文索引。

    
参考函数：
row_merge_read_clustered_index --> row_fts_start_psort

线程回调函数为
fts_parallel_tokenization
。

    
当表上存在全文索引时，就会隐式的建立一个名为FTS_DOC_ID的列，并在其上创建一个唯一索引，用于标识分词出现的记录行。你也可以显式的创建一个名为FTS_DOC_ID的列，但需要和隐式创建的列类型保持一致。

    
为了维护表上的全文索引信息，全文索引模块定义了大量的类来进行管理，总的来说如下图所示：

    

      

    

    
图1. 全文索引模块

    
普通DML及查询操作

    
插入

    
我们可以通过INNODB_FT_INDEX_CACHE来检查插入记录的分词：

    

      
mysql> insert into  t1 values (NULL, 'hello, welcome to mysql world');
Query OK, 1 row affected (1.87 sec)

mysql> set global innodb_ft_aux_table = 'test/t1';
Query OK, 0 rows affected (0.00 sec)

mysql> select * from INNODB_FT_INDEX_CACHE;
+---------+--------------+-------------+-----------+--------+----------+
| WORD    | FIRST_DOC_ID | LAST_DOC_ID | DOC_COUNT | DOC_ID | POSITION |
+---------+--------------+-------------+-----------+--------+----------+
| hello   |            2 |           2 |         1 |      2 |        0 |
| mysql   |            2 |           2 |         1 |      2 |       18 |
| welcome |            2 |           2 |         1 |      2 |        7 |
| world   |            2 |           2 |         1 |      2 |       24 |
+---------+--------------+-------------+-----------+--------+----------+
4 rows in set (0.00 sec)

    

    
在插入一条记录时，对应的堆栈如下：

    

      
row_insert_for_mysql
     |--> row_insert_for_mysql_using_ins_graph
            |--> fts_trx_add_op  // state = FTS_INSERT

    

    
在向原表上插入完成记录后，会去判断表上是否有全文索引（DICT_TF2_FTS），如果有的话，则将插入记录对应的doc id提取出来(
fts_get_doc_id_from_row
)，并缓存到事务对象中。

    
删除

    
删除操作不会直接从全文索引里直接删除，因此依然可以从INNODB_FT_INDEX_CACHE中查到分词信息。

    
相关堆栈：

    

      
ha_innobase::delete_row
     |--> row_update_for_mysql
            |--> row_update_for_mysql_using_upd_graph
                   |--> row_fts_update_or_delete
                          |--> fts_trx_add_op // state = FTS_DELETE

    

    
更新

    
更新非全文索引列，不会修改FTS_DOC_ID列的值。如果更新了全文索引列，在InnoDB的实现是删除老的DOC，并插入新的DOC。

    
堆栈为：

    

      
ha_innobase::update_row
     |--> row_update_for_mysql
           |--> row_update_for_mysql_using_upd_graph
                  |--> row_fts_update_or_delete
                         |--> row_fts_do_update
                                |--> fts_trx_add_op // state = FTS_DELETE
                                |--> fts_trx_add_op // state = FTS_INSERT

    

    
可见所有DML的操作，都走接口函数
fts_trx_add_op
，划分为两种操作: FTS_INSERT及FTS_DELETE；当前事务涉及的doc id被存储到
trx->fts_trx
中，在执行SQL的过程中并没有更新全文索引，而是在事务提交时进行的。

    
在缓存操作时，维护了两个结构，一个是
trx->fts_trx->savepoints
，维护了事务全局的全文索引操作，另外一个是
trx->fts_trx->last_stmt
，维护的是当前SQL操作的doc id，前者在事务结束时处理，后者在SQL结束时清空。

    
查询

    
对于全文索引的查询，采用新的接口函数，分为两步:

    

      

        
根据检索词搜集符合条件的doc id。

        

          
 JOIN::optimize
     |--> init_ftfuncs
          |--> Item_func_match::init_search
                 |--> ha_innobase::ft_init_ext
                        |--> fts_query

        

        
在搜集满足查询条件的doc id时，首先读取DELETED表中记录的doc id，这些doc id随后被用做过滤。

      

      

        
根据搜集到的doc id，找到对应的记录，使用的索引是
dict_table_t::fts_doc_id_index
，也就是建立在隐藏列FTS_DOC_ID上的唯一索引。

        

          
 sub_select
      |--> join_ft_read_first
             |--> ha_innobase::ft_init
             |--> ha_innobase::ft_read
      |--> join_ft_read_next
             |--> ha_innobase::ft_read

        

      

    

    
通常查询返回的结果是根据rank排序的，InnoDB的全文检索排序规则和sphinx类似，基于 BM25 和 TF-IDF算法。

    
rank的计算算法如下：

    

      
${IDF} = log10( ${total_records} / ${matching_records} )  // total_records表示总的行记录数，matching_records表示匹配到检索字的行记录数
${TF} 表示单词在文档中出现的次数

${rank} = ${TF} * ${IDF} * ${IDF}

    

    
IDF的计算参阅函数：
fts_query_calculate_idf

ranking计算：
fts_query_calculate_ranking

    
如果使用多个单词匹配，则把各个单词各自的rank累加起来。官方博客有
一篇文章
专门对此进行了介绍。

    
事务操作

    
事务内回滚

正在事务内回滚某个语句，或者回滚到某个savepoint时，需要将对应的操作记录也要删除。维护了
trx->fts_trx->last_stmt
，在单条SQL结束时释放(
trx_mark_sql_stat_end
)。如果SQL回滚，就根据last_stmt中维护的doc id从全局savepoints中清理掉本条SQL的doc id。

    
相关堆栈：

    

      
innobase_rollback --> trx_rollback_last_sql_stat_for_mysql
                                        |--> fts_savepoint_rollback_last_stmt
                                                  |--> fts_undo_last_stmt
                                        |--> trx_mark_sql_stat_end
                                                  |--> fts_savepoint_laststmt_refresh

    

    
回滚到savepoint

    

      
innobase_rollback_to_savepoint
          |--> fts_savepoint_rollback

    

    
事务提交

    
相关堆栈：

    

      
trx_commit_low
      |--> fts_commit  // 处理trx->fts_trx->savepoints中缓存的全文索引操作
             |--> fts_commit_table
                    |--> fts_add
                           |--> fts_add_doc_by_id
                    |--> fts_delete
      |--> trx_commit_in_memory
             |--> trx_finalize_for_fts
                    |--> trx_finalize_for_fts_table

    

    
在调用fts_commit时，会根据不同的操作类型，调用fts_add增加全文索引项，调用fts_delete删除全文索引项。

    
由于在插入记录时，先分词、分解成多个词插入辅助表中，因此一条insert可能产生多个小的插入，这种写入放大可能是不可承受的。InnoDB采用了一种优化的方案：创建一个内存cache，临时缓存插入操作，当cache满时再批量刷到磁盘，这样做的好处是：

    

      
避免重复存储相同的单词；

      
cache size 通过参数
innodb_ft_cache_size
控制；

      
查询会将cache和磁盘数据进行merge。

    

    
在事务提交时，调用函数
fts_add_doc_by_id
：

    

      
首先根据doc id，使用doc_id所在的索引进行查询，找到刚刚插入的记录项对应的聚集索引记录；

      
遍历表上全部的聚集索引，根据全文索引对应的
fts_get_doc_t
(
fts_cache_t::get_docs
)构建
fts_doc_t
，对文档根据选择的parser进行分词(
fts_tokenize_document
函数或者
fts_tokenize_document_next
)，具体的文档存储到
fts_doc_t::text
中；

      
将上一步获得的分词加入到cache中（
fts_cache_add_doc
）；

      
如果当前cache的大小超过配置的
innodb_ft_cache_size
，或者全局cache的大小超过
innodb_ft_total_cache_size
(
fts_need_sync
被设置为true)，则进行一次sync，将该表缓存的数据刷到全文索引文件中(fts_sync)，并清空cache。

    

    
和插入相似，删除操作也可能产生大量小的删除操作，为了避免这种情况，维持一个表，来记录被删除的doc id，但记录依然存在于原文件中。删除操作的提交函数为
fts_delete
，将被删除的记录doc_id插入到DELETED辅助表中。

    
事务模块涉及的几个关键类包括：

    

      

    

    
图2. 全文索引事务模块

    
同步缓存

    
在满足一定条件时，全文索引需要进行一次sync操作，将数据同步到全文索引文件中，大概包含以下集中情况需要sync：

    

      
cache数据占用的内存超过限制；

      
后台线程
fts_optimize_thread
在shutdown调用，将所有表进行一次sync；

      

ha_innobase::optimize
调用（执行optimize table）；

      

row_merge_read_clustered_index
：创建一个新的临时表并读入数据后，进行一次sync调用。

    

    
同步操作的入口函数为fts_sync，大体流程为：

    

      
针对每个索引，调用函数
fts_sync_index
：通过函数
fts_select_index
计算写入的索引文件，再将分词节点信息写入到文件（函数
fts_write_node
）, 倒排索引的记录内容使用结构体
fts_node_t
进行描述，存储结构如下图所示：

    

    

      

    

    
图3. 倒排索引结点存储结构

    

      
调用
fts_sync_commit
提交sync操作：

更新CONFIG表记录的最大SYNC的DOC ID（
fts_cmp_set_sync_doc_id
）；

若
fts_cache_t::deleted_doc_ids
不为空，将其加入到DELETED_CACHE辅助表中（
fts_sync_add_deleted_cache
）；

清空cache 并重新初始化。

    

    
Optimize table

    
当你修改了某些配置（例如最小token size时），或者希望重组全文索引时，可以执行optimize table。由于原始optimize table操作会产生整个表的重建，耗时太久，因此InnoDB引入了一个参数
innodb_optimize_fulltext_only
来控制该行为。当开启该选项时，如果执行optimize table，就只优化全文索引，而不会去重建表，入口函数为ha_innobase::optimize：

    

      
ha_innobase::optimize
     |--> fts_sync_table
     |--> fts_optimize_table

    

    
首先调用函数
fts_sync_table
，将表上在内存中cache的数据刷到全文索引文件中；

然后调用函数
fts_optimize_table
，我们主要分析集中在第二步。

    

fts_optimize_table
函数流程如下：

    

      

        
如果BEGING_DELETED表中没有数据（例如第一次调用optimized table），则将DELETED表中的数据转储到BEING_DELETED表中，相当于拿到了一个快照，执行的SQL操作为：

        

          
  static  const char* fts_init_delete_sql =
          "BEGIN\n"
          "\n"
          "INSERT INTO $BEING_DELETED\n"
                  "SELECT doc_id FROM $DELETED;\n"
          "\n"
          "INSERT INTO $BEING_DELETED_CACHE\n"
                  "SELECT doc_id FROM $DELETED_CACHE;\n";

        

      

    

    
参考函数：
fts_optimize_create_deleted_doc_id_snapshot

    

      

        
从BEING_DELETED/BEING_DELETED_CACHE表中读取已经被删除的doc id，这些doc id在随后的索引优化中将被忽略掉。

参考函数：
fts_optimize_read_deleted_doc_id_snapshot

      

      

        
调用
fts_optimize_indexes
 对每个索引进行优化，相关堆栈如下：

        

          
  fts_optimize_indexes
       |--> fts_optimize_index
              |--> fts_optimize_index_read_words
                      // 读入需要进行优化的分词，一轮优化的个数不超过innodb_ft_num_word_optimize的配置值
                      // 缓存的分词数据采用zlib进行压缩
              |--> fts_optimize_words // 读取分词，将已经删除的doc id从其中清除，并回写到db
                      |--> fts_index_fetch_nodes // 逐个读取分词对应的全文索引项
                      |--> fts_optimize_compact
                           |--> fts_optimize_word // 判断是否包含被删除的doc id，并重组记录
                           |--> fts_optimize_write_word // 将记录写回索引，具体操作为先删除老的记录，再插入新的记录
                           |--> fts_config_set_index_value //更新CONFIG表的FTS_LAST_OPTIMIZED_WORD列，记录最近重组优化的分词
        |--> fts_optimize_index_completed // 若上述步骤将读取的分词全部处理完了，则本轮optimize操作完成

        

      

      

        
当在所有索引上完成optimize后，调用fts_optimize_purge_snapshot，主要操作包括：

        

          

            
从DELETE和DELETE_CACHE表中将doc id删除，参考函数fts_optimize_purge_deleted_doc_ids

            

              
  static const char* fts_delete_doc_ids_sql =
          "BEGIN\n"
          "\n"
          "DELETE FROM $DELETED WHERE doc_id = :doc_id1;\n"
          "DELETE FROM $DELETED_CACHE WHERE doc_id = :doc_id2;\n";

            

          

          

            
从BEING_DELETED及BEING_DELETED_CACHE中删除对应的doc id。

            

              
  static const char* fts_end_delete_sql =
          "BEGIN\n"
          "\n"
          "DELETE FROM $BEING_DELETED;\n"
          "DELETE FROM $BEING_DELETED_CACHE;\n";

            

            
参考函数： 
fts_optimize_purge_deleted_doc_id_snapshot

          

        

      

    

    
后台线程

    
InnoDB启动时，会创建一个后台线程，线程函数为
fts_optimize_thread
，工作队列为
fts_optimize_wq
，其主要目的是在满足一定条件时，对表自动进行optimize操作。

    
在如下两种情况，会向
fts_optimize_wq
中增加元组：

    

      

fts_optimize_add_table
: 创建或打开一个新的带全文索引的表时，创建一个类型为
FTS_MSG_ADD_TABLE
并包含表对象指针的MSG，加入到
fts_optimize_wq
中，这些表禁止被从数据词典中驱逐；

      

fts_optimize_remove_table
: 删除表、DDL、释放表对象(
dict_mem_table_free
)、删除全文索引(
fts_drop_index
)等操作时，会创建一个类型为
FTS_MSG_DEL_TABLE的MEG
，加入到
fts_optimize_wq
队列中。

    

    
fts optimize线程对于FTS_MSG_ADD_TABLE类型的会将相应的表加入到调度队列，对于FTS_MSG_DEL_TABLE，则从调度队列中删除。其调度队列的成员类型为
fts_slot_t
。

    
当表上删除的数据量超过一千万(FTS_OPTIMIZE_THRESHOLD)行时，就会触发一次自动optimize table，但两次optimize的间隔不应低于300秒（FTS_OPTIMIZE_INTERVAL_IN_SECS）。

    
监控

    
我们可以通过几个INFORMATION_SCHEMA下的全文索引表来监控全文索引状态。

    

      
mysql> show tables like '%ft%';
+-------------------------------------+
| Tables_in_information_schema (%ft%) |
+-------------------------------------+
| INNODB_FT_CONFIG                    |
| INNODB_FT_BEING_DELETED             |
| INNODB_FT_DELETED                   |
| INNODB_FT_DEFAULT_STOPWORD          |
| INNODB_FT_INDEX_TABLE               |
| INNODB_FT_INDEX_CACHE               |
+-------------------------------------+
6 rows in set (0.00 sec)

    

    
想要从information_schema表中查询信息，需要先设置变量
innodb_ft_aux_table
，值为你要查询表的”dbname/tablename”。

    
全文索引停词

    
停词(STOP WORD)用于在分词时忽略那些常见的不重要的单词，InnoDB目前内建的停词可以从information_schema.INNODB_FT_DEFAULT_STOPWORD读取，用户也可以自己定义停词列表，方法很简单：创建一个和nformation_schema.INNODB_FT_DEFAULT_STOPWORD一模一样的表，将你想要的停词加入到其中，然后设置
innodb_ft_server_stopword_table
值为你创建的表名：”dbname/tabname”。

    
你也可以使用会话级别的参数
innodb_ft_user_stopword_table
来指定你想要的停词表，和上述创建规则一致，具体的参阅
官方文档
。

    
另外配置项
innodb_ft_min_token_size
及
innodb_ft_max_token_size
 用于表示一个单词的字符长度范围，在这个范围的连续字符串才会被当作一个单词。然而如果使用ngram解析器的话，有效单词长度受参数
ngram_token_size
控制。

    
可以关闭参数
innodb_ft_enable_stopword
，这样在分词时也会把预设的停词考虑进去。

    
InnoDB全文索引插件

    
从MySQL 5.7.3开始InnoDB支持全文索引插件，用户可以以Plugin的模式来定义自己的分词规则，或是引入社区开发的全文索引解析器，例如某些专业领域的分词，可能具有不同的规则。

    
全文索引插件有两种角色：第一种是替换内建的parser，读取输入文档，进行解析后，将分词传送给server；另一种角色是作为内建parser的协作者，可以把输入文档处理过后，再传送给内建parser。

    
如果你已经有一个基于MYISAM的全文索引插件了，也可以根据
这篇官方文档
的介绍，将其修改成InnoDB全文索引插件。

    
InnoDB N-gram parser

    
从MySQL5.7.6版本开始提供了一种内建的全文索引ngram parser，可以很好的支持CJK字符集（中文、日文、韩文），CJK有个共同点就是单词不像英语习惯那样根据空格进行分解的，因此传统的内建分词方式无法准确的对类似中文进行分词。

    
ngram parser内建在代码中，该解析器默安装，你可以通过指定索引属性（
WITH PARSER ngram
）来利用该parser，例如：

    

      
mysql> create table ft_test(id int, content text, fulltext (content) with parser ngram);
Query OK, 0 rows affected (0.26 sec)

    

    
N-Gram使用一种特殊的方式来进行分词，举个简单的例子，假设要对单词’abcd’进行分词，那么其分词结果为：

    

      
N=1 : 'a', 'b', 'c', 'd';
N=2 : 'ab', 'bc', 'cd';
N=3 : 'abc', 'bcd';
N=4 : 'abcd';

    

    
N取决于
ngram_token_size
的设置，默认值为2。

    
对于停词的处理，N-Gram和默认的parser不同，即只要每个token包含了（而不是精确匹配）停词，就不对其进行索引；另外空格总是作为一个停词，因此在分词取token时，空格会被忽略掉。

    
在执行查询时，用户传递的搜索词也会基于N-Gram进行分解后进行检索。 具体的例子可以参阅
官方博客
的描述。

    
除了N-gram parser外，官方也支持了另外一种名为
MeCab Parser
的插件，主要用于日语分词，但需要手动安装。

  

  

    

    

    
Test Book

  

  

    
背景

    
MySQL 从5.5.3版本，对Metadata lock进行了调整，主要是MDL锁持有的周期从语句变成了事务， 其原因主要是解决两个问题：

    
问题1: 破坏事务隔离级别

在repeatable read的隔离级别下，多次的select语句执行过程中，会因为其它session的DDL语句，而导致select语句执行的结果不相同，破坏了RR的隔离级别。

    
问题2: 破坏binlog的顺序

在对表的DML过程中，会因为其它session的DDL语句，导致binlog里的event顺序在备库执行的结果和主库不一致。

    
从MySQL 5.5.3开始，MDL锁的持有周期变成了事务，解决了上面提到的两个问题，但在autocommit=off的情况下，也大大增加了阻塞的可能性。DBA对于阻塞的case，处理起来又比较麻烦，原因就是MDL锁的阻塞情况没有暴露明确的信息。

    
从MySQL 5.7.6开始，可以通过performance schema来查询MDL锁的持有情况。

    
在开始介绍5.7的跟踪Metadata lock之前， 小编还想讨论一下前面提到的这两个问题，在Oracle数据库中是如何处理的。

    
Oracle的处理方式

    
首先，Oracle只实现了两种隔离级别，即read committed和serializable，我们来看下serializable级别下，怎么来处理问题1:

    
先看如下的case:

    

      
session 1:                                                 session 2:
--                                                         create table t1(id number);
--                                                         insert into t1 values(1);
--                                                         commit;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;              --
TEST/TEST@ORCL>select * from t1;                           --
        ID
----------
         1
1 row selected.
--                                                         alter table t1 add col number;
TEST/TEST@ORCL>select * from t1;                           --

        ID        COL
---------- ----------
         1
--                                                         alter table t1 add col1 number default 10;
TEST/TEST@ORCL>select * from t1;                           --
        ID        COL       COL1
---------- ---------- ----------
         1

    

    
可以看到，虽然session是serializable隔离级别，但并没有产生阻塞的情况，Oracle保证了session1的多次select查询的返回结果是一样的，

但t1表数据字典的变化是马上可见的，这个也是符合serializable的要求的，因为隔离级别只定义了数据的可见性，而没有定义数据字典的可见性。

    
那MySQL能否不要MDL锁，来达到这样的效果？

    
答案是否定的，因为Oracle是堆表，alter的操作只更改了数据字典，数据记录没有发生变化，纵使加了default值，也是在原记录上进行的update，完全可以使用scn号来构建一致性读版本，这样就不会产生阻塞。

而MySQL是IOT表，alter的过程进行了表重建，无法完成read view的构建。

    
那我们再来看问题2，Oracle的处理方式:

    
对于redo日志，Oracle的处理方式和InnoDB的处理方式一致，也就是当使用redo的时候，日志的写入并不和事务的提交与否有必然的关系，也不用和提交的顺序保持一致。这一点就和binlog区别开来，也就是物理日志是可以避免使用逻辑日志(binlog)带来的问题。

    
MySQL如果要避免这两个问题，而不引入Metadata lock，可以有以下两个思路：

    

      
DDL只更改数据字典，行记录的变更在原记录上进行，这样能够实现多版本，也就是我们常说的在线加字段；

      
使用物理redo日志，避免使用binlog。

    

    
这两种都会对现有的MySQL架构带来调整，仅供参考。

    
下面我们回来看下对5.7 MDL的tracing。

    
MySQL 5.7

    
首先，打开metadata locks的tracing功能。

    

      
mysql> UPDATE performance_schema.setup_consumers SET ENABLED = 'YES' WHERE NAME = 'global_instrumentation';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1 Changed: 0 Warnings: 0
mysql> UPDATE performance_schema.setup_instruments SET ENABLED = 'YES' WHERE NAME = 'wait/lock/metadata/sql/mdl';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1 Changed: 0 Warnings: 0

    

    
打开两个session，一个select，一个truncate。因为MDL锁的情况，select会阻塞truncate的操作。

    
session 1: 操作如下：

    

      
mysql> set session autocommit=0;
Query OK, 0 rows affected (0.00 sec)
mysql> select @@autocommit, @@tx_isolation;
+--------------+----------------+
| @@autocommit | @@tx_isolation |
+--------------+----------------+
| 0 | READ-COMMITTED |
+--------------+----------------+
1 row in set (0.00 sec)
mysql> select * from t limit 1;
+----+------+
| id | val |
+----+------+
| 1 | 1 |
+----+------+
1 row in set (0.00 sec)

    

    
session 2: 操作如下：

    

      
mysql> truncate table t;

    

    
结果看到的就是session2被阻塞， 接下来check一下performance schema的信息：

    

      
mysql> select * from performance_schema.metadata_locks\G
*************************** 1\. row ***************************
OBJECT_TYPE: TABLE
OBJECT_SCHEMA: test
OBJECT_NAME: t
OBJECT_INSTANCE_BEGIN: 140450128308592
LOCK_TYPE: SHARED_READ
LOCK_DURATION: TRANSACTION
LOCK_STATUS: GRANTED
SOURCE: sql_parse.cc:5585
OWNER_THREAD_ID: 27
OWNER_EVENT_ID: 17
*************************** 2\. row ***************************
OBJECT_TYPE: GLOBAL
OBJECT_SCHEMA: NULL
OBJECT_NAME: NULL
OBJECT_INSTANCE_BEGIN: 140450195436144
LOCK_TYPE: INTENTION_EXCLUSIVE
LOCK_DURATION: STATEMENT
LOCK_STATUS: GRANTED
SOURCE: sql_base.cc:5224
OWNER_THREAD_ID: 30
OWNER_EVENT_ID: 8
*************************** 3\. row ***************************
OBJECT_TYPE: SCHEMA
OBJECT_SCHEMA: test
OBJECT_NAME: NULL
OBJECT_INSTANCE_BEGIN: 140450195434272
LOCK_TYPE: INTENTION_EXCLUSIVE
LOCK_DURATION: TRANSACTION
LOCK_STATUS: GRANTED
SOURCE: sql_base.cc:5209
OWNER_THREAD_ID: 30
OWNER_EVENT_ID: 8
*************************** 4\. row ***************************
OBJECT_TYPE: TABLE
OBJECT_SCHEMA: test
OBJECT_NAME: t
OBJECT_INSTANCE_BEGIN: 140450195434368
LOCK_TYPE: EXCLUSIVE
LOCK_DURATION: TRANSACTION
LOCK_STATUS: PENDING
SOURCE: sql_parse.cc:5585
OWNER_THREAD_ID: 30
OWNER_EVENT_ID: 8
*************************** 5\. row ***************************
OBJECT_TYPE: TABLE
OBJECT_SCHEMA: performance_schema
OBJECT_NAME: metadata_locks
OBJECT_INSTANCE_BEGIN: 140450128262384
LOCK_TYPE: SHARED_READ
LOCK_DURATION: TRANSACTION
LOCK_STATUS: GRANTED
SOURCE: sql_parse.cc:5585
OWNER_THREAD_ID: 27
OWNER_EVENT_ID: 18
5 rows in set (0.00 sec)

    

    
如上所示，在t表上，持有一个SHARE_READ lock，而且还有一个EXCULSIVE lock请求是pending状态，也就是我们被阻塞的session 2。

    
在5.7之前，我们可以通过show processlist，来查看MDL阻塞的情况，但无法获取session 1的信息:

    

      
mysql> SELECT OBJECT_TYPE, OBJECT_SCHEMA, OBJECT_NAME, LOCK_TYPE, LOCK_STATUS, THREAD_ID, PROCESSLIST_ID, PROCESSLIST_INFO FROM performance_schema.metadata_locks INNER JOIN performance_schema.threads ON THREAD_ID = OWNER_THREAD_ID WHERE PROCESSLIST_ID <> CONNECTION_ID();
+-------------+---------------+-------------+---------------------+-------------+-----------+----------------+------------------+
| OBJECT_TYPE | OBJECT_SCHEMA | OBJECT_NAME | LOCK_TYPE | LOCK_STATUS | THREAD_ID | PROCESSLIST_ID | PROCESSLIST_INFO |
+-------------+---------------+-------------+---------------------+-------------+-----------+----------------+------------------+
| GLOBAL | NULL | NULL | INTENTION_EXCLUSIVE | GRANTED | 30 | 8 | truncate table t |
| SCHEMA | test | NULL | INTENTION_EXCLUSIVE | GRANTED | 30 | 8 | truncate table t |
| TABLE | test | t | EXCLUSIVE | PENDING | 30 | 8 | truncate table t |
+-------------+---------------+-------------+---------------------+-------------+-----------+----------------+------------------+
3 rows in set (0.00 sec)
mysql> show processlist;
+----+------+-----------+------+---------+------+---------------------------------+------------------+
| Id | User | Host | db | Command | Time | State | Info |
+----+------+-----------+------+---------+------+---------------------------------+------------------+
| 5 | root | localhost | test | Query | 0 | starting | show processlist |
| 8 | root | localhost | test | Query | 50 | Waiting for table metadata lock | truncate table t |
+----+------+-----------+------+---------+------+---------------------------------+------------------+
2 rows in set (0.00 sec)

    

    
接下来当事务提交了后，释放MDL锁再查询，就看不到MDL锁的信息了。

    

      
mysql> commit;
Query OK, 0 rows affected (0.00 sec)
mysql> SELECT OBJECT_TYPE, OBJECT_SCHEMA, OBJECT_NAME, LOCK_TYPE, LOCK_STATUS, THREAD_ID, PROCESSLIST_ID, PROCESSLIST_INFO FROM performance_schema.metadata_locks INNER JOIN performance_schema.threads ON THREAD_ID = OWNER_THREAD_ID WHERE PROCESSLIST_ID <> CONNECTION_ID();
Empty set (0.01 sec)
mysql> select * from t;
Empty set (0.00 sec)

    

    
MySQL 5.7可以通过performance schema来检索MDL锁阻塞情况，方便DBA来诊断问题。

  

  

    

    

    
Test Book

  

  

    
前言

    
在操作数据库系统的时候，有个常识就是在建表的时候一定要建索引。为什么要建索引呢？

    
这里以MySQL的InnoDB存储引擎为例，因为InnoDB会以索引的排序为基准建立B+树，这样在检索数据的时候就可以通过B+树来查找，查找算法的时间复杂度是O(logn)级别的，避免全表扫描带来的性能下降和额外资源损耗。

    
理论上一个表所有的字段都可以建索引，那么给哪些字段建索引效果好呢？

    
一个想法是给频繁在SQL的where条件中出现的字段建立索引，这样可以保证通过索引来查找数据。

    
有一点是经常被忽略的，那就是索引的过滤性。比如我们给一个整型字段加索引，而这个字段在几乎所有的记录上的值都是1（过滤性很差），那么我们通过这个索引来查找数据就会遍历大部分无关记录，造成浪费。

    
我们知道update语句也是通过索引来查找待更新的数据的，而且update会给索引查找的记录加上X锁，因此索引过滤性不好不但造成性能下降，还有可能造成锁争夺和锁等待的损耗。

    
下面给出一个具体的因为索引过滤性太差引起CPU飙高的case，在RDS的线上实例曾出现过类似的case。

    
场景构造

    
在MySQL里我们建立这样一个表：

    

      
CREATE TABLE `sbtest1` (
  `id` int(10) unsigned NOT NULL,
  `k` int(10) unsigned NOT NULL DEFAULT '0',
  `n` int(10) unsigned NOT NULL DEFAULT '0',
  `c` char(120) NOT NULL DEFAULT '',
  `pad` char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `k_1` (`k`)
) ENGINE=InnoDB;

    

    
然后我们给sbtest1加点数据，并且让索引k_1(k)的过滤性不好，表内一共10000000条数据，索引k只有2个值50,51，如下所示：

    

      
mysql> select count(*) from sbtest1;
+----------+
| count(*) |
+----------+
| 10000000 |
+----------+
1 row in set (1.80 sec)

mysql> select distinct k from sbtest1;
+----+
| k  |
+----+
| 50 |
| 51 |
+----+
2 rows in set (2.22 sec)

    

    
然后我们用sysbench开32个并发的update，update语句如下：

    

      
UPDATE sbtest1 SET c='随机字符串' WHERE k=50或51 and n=随机值

    

    
执行show full processlist\G，可以看到这些update的状态大多处于”Searching rows for update”的状态。

    

      
mysql> show full processlist\G
*************************** 1\. row ***************************
                  Id: 2
                User: root
                Host:
                  db: test
             Command: Sleep
                Time: 6
               State:
                Info: NULL
         Memory_used: 1146520
Memory_used_by_query: 8208
        Logical_read: 53
  Physical_sync_read: 2
 Physical_async_read: 0
Temp_user_table_size: 0
Temp_sort_table_size: 0
 Temp_sort_file_size: 0
*************************** 2\. row ***************************
                  Id: 6
                User: root
                Host:
                  db: sbtest
             Command: Query
                Time: 21
               State: Searching rows for update
                Info: UPDATE sbtest1 SET c='96372750646-31206582030-89561475094-70112992370-09982266420-13264143120-70453817624-14068123856-50060327807-36562985632' WHERE k=50 and n=4951641
         Memory_used: 119840
Memory_used_by_query: 232
        Logical_read: 4935
  Physical_sync_read: 0
 Physical_async_read: 0
Temp_user_table_size: 0
Temp_sort_table_size: 0
 Temp_sort_file_size: 0
*************************** 3\. row ***************************
                  Id: 7
                User: root
                Host:
                  db: sbtest
             Command: Query
                Time: 21
               State: Searching rows for update
                Info: UPDATE sbtest1 SET c='28921237680-50951214786-47793625883-44090170070-31354117142-11520543175-97262835853-83486109785-32721666363-10671483869' WHERE k=51 and n=5033717
         Memory_used: 119840
Memory_used_by_query: 232
        Logical_read: 4949
  Physical_sync_read: 5
 Physical_async_read: 0
Temp_user_table_size: 0
Temp_sort_table_size: 0
 Temp_sort_file_size: 0

...

    

    
“Searching rows for update”即MySQL正在寻找待更新的记录的状态，正常情况这个状态是非常快就结束的，但是这里却长时间处于这个状态，为什么呢？

    
由于表的索引过滤性太差，每个线程在查找的时候会遇到很多冲突的记录。

    
InnoDB在通过索引拿到记录后，会给这些记录上X锁，同时也会请求全局的
lock_sys->mutex
和
trx_sys->mutex
，所以这里我们判断每个线程都堵在锁等待这里。（ps: 关于InnoDB加锁的逻辑，可以查看
这篇博文
）

    
这时候对系统用一下top命令，可以发现这个MySQL实例CPU飚的很高，我们再用perf工具看一下CPU飙高的MySQL调用堆栈是怎么样的，如下所示：

    

      
    83.77%   mysqld  mysqld              [.] _Z8ut_delaym
             |
             --- _Z8ut_delaym
                |
                |--99.99%-- _Z15mutex_spin_waitP10ib_mutex_tPKcm
                |          |
                |          |--88.88%-- _ZL20pfs_mutex_enter_funcP10ib_mutex_tPKcm.constprop.68
                |          |          |
                |          |          |--54.05%-- _ZL29lock_rec_convert_impl_to_explPK11buf_block_tPKhP12dict_index_tPKm
                |          |          |          _Z34lock_clust_rec_read_check_and_lockmPK11buf_block_tPKhP12dict_index_tPKm9lock_modemP9que_thr_t
                |          |          |          _ZL16sel_set_rec_lockPK11buf_block_tPKhP12dict_index_tPKmmmP9que_thr_t
                |          |          |          _Z20row_search_for_mysqlPhmP14row_prebuilt_tmm
                |          |          |          _ZN11ha_innobase10index_nextEPh
                |          |          |          _ZN7handler13ha_index_nextEPh
                |          |          |          _ZL8rr_indexP11READ_RECORD
                |          |          |          _Z12mysql_updateP3THDP10TABLE_LISTR4ListI4ItemES6_PS4_jP8st_ordery15enum_duplicatesbPySB_
                |          |          |          _Z21mysql_execute_commandP3THD
                |          |          |          _Z11mysql_parseP3THDPcjP12Parser_state
                |          |          |          _Z16dispatch_command19enum_server_commandP3THDPcj
                |          |          |          _Z26threadpool_process_requestP3THD
                |          |          |          _ZL11worker_mainPv
                |          |          |          start_thread
                |          |          |
                |          |           --45.95%-- _Z15lock_rec_unlockP5trx_tPK11buf_block_tPKh9lock_mode
                |          |                     _Z20row_unlock_for_mysqlP14row_prebuilt_tm
                |          |                     _Z12mysql_updateP3THDP10TABLE_LISTR4ListI4ItemES6_PS4_jP8st_ordery15enum_duplicatesbPySB_
                |          |                     _Z21mysql_execute_commandP3THD
                |          |                     _Z11mysql_parseP3THDPcjP12Parser_state
                |          |                     _Z16dispatch_command19enum_server_commandP3THDPcj
                |          |                     _Z26threadpool_process_requestP3THD
                |          |                     _ZL11worker_mainPv
                |          |                     start_thread

    

    
我们看到耗CPU最高的调用函数栈是…
mutex_spin_wait
->
ut_delay
，属于锁等待的逻辑。InnoDB在这里用的是自旋锁，锁等待是通过调用ut_delay做空循环实现的，会消耗CPU。这里证明了上面的判断是对的。

    
在这个case里涉及到的锁有记录锁、
lock_sys->mutex
和
trx_sys->mutex
，究竟是哪个锁等待时间最长呢？我们可以用下面的方法确认一下：

    

      
mysql> SELECT COUNT_STAR, SUM_TIMER_WAIT, AVG_TIMER_WAIT, EVENT_NAME FROM performance_schema.events_waits_summary_global_by_event_name where COUNT_STAR > 0 and EVENT_NAME like 'wait/synch/%' order by SUM_TIMER_WAIT desc limit 10;
+------------+------------------+----------------+--------------------------------------------+
| COUNT_STAR | SUM_TIMER_WAIT   | AVG_TIMER_WAIT | EVENT_NAME                                 |
+------------+------------------+----------------+--------------------------------------------+
|   36847781 | 1052968694795446 |       28575867 | wait/synch/mutex/innodb/lock_mutex         |
|       8096 |   81663413514785 |    10086883818 | wait/synch/cond/threadpool/timer_cond      |
|         19 |    3219754571347 |   169460766775 | wait/synch/cond/threadpool/worker_cond     |
|   12318491 |    1928008466219 |         156446 | wait/synch/mutex/innodb/trx_sys_mutex      |
|   36481800 |    1294486175099 |          35397 | wait/synch/mutex/innodb/trx_mutex          |
|   14792965 |     459532479943 |          31027 | wait/synch/mutex/innodb/os_mutex           |
|    2457971 |      62564589052 |          25346 | wait/synch/mutex/innodb/mutex_list_mutex   |
|    2457939 |      62188866940 |          24909 | wait/synch/mutex/innodb/rw_lock_list_mutex |
|     201370 |      32882813144 |         163001 | wait/synch/rwlock/innodb/hash_table_locks  |
|       1555 |      15321632528 |        9853039 | wait/synch/mutex/innodb/dict_sys_mutex     |
+------------+------------------+----------------+--------------------------------------------+
10 rows in set (0.01 sec)

    

    
从上面的表可以确认，lock_mutex（在MySQL源码里对应的是
lock_sys->mutex
）的锁等待累积时间最长（SUM_TIMER_WAIT）。lock_sys表示全局的InnoDB锁系统，在源码里看到InnoDB加/解某个记录锁的时候（这个case里是X锁），同时需要维护lock_sys，这时会请求lock_sys->mutex。

    
在这个case里，因为在Searching rows for update的阶段频繁地加/解X锁，就会频繁请求
lock_sys->mutex
，导致
lock_sys->mutex
锁总等待时间过长，同时在等待的时候消耗了大量CPU。

    
当我们将索引改成过滤性好的（比如字段n），再做上述实验，就看不到那么多线程堵在”Searching rows for update”的阶段，而且实例的CPU消耗也降了很多。

    
结语

    
通过以上实验，我们看到索引过滤性不好可能带来灾难性的结果：语句hang住以及主机CPU耗尽。因此我们在设计表的时候，应该对业务上的数据有充分的估计，选择过滤性好的字段作为索引。

  

  

    

    

    
Test Book

  

  

    
PostgreSQL在9.0之后引入了主备流复制机制，通过流复制，备库不断的从主库同步相应的数据，并在备库apply每个WAL record，这里的流复制每次传输单位是WAL日志的record。而PostgreSQL9.0之前提供的方法是主库写完一个WAL日志文件后，才把WAL日志文件传送到备库，这样的方式导致主备延迟特别大。同时PostgreSQL9.0之后提供了Hot Standby，备库在应用WAL record的同时也能够提供只读服务，大大提升了用户体验。

    
主备总体结构

    
PG主备流复制的核心部分由walsender，walreceiver和startup三个进程组成。

walsender进程是用来发送WAL日志记录的，执行顺序如下：

    

      
PostgresMain()->exec_replication_command()->StartReplication()->WalSndLoop()->XLogSendPhysical()

    

    
walreceiver进程是用来接收WAL日志记录的，执行顺序如下：

    

      
sigusr1_handler()->StartWalReceiver()->AuxiliaryProcessMain()->WalReceiverMain()->walrcv_receive()

    

    
startup进程是用来apply日志的，执行顺序如下：

    

      
PostmasterMain()->StartupDataBase()->AuxiliaryProcessMain()->StartupProcessMain()->StartupXLOG()

    

    
下图是PG主备总体框架图：

    

      

    

    
图1. PG主备总体框架图

    
walsender和walreceiver进程流复制过程

    
walsender和walreceiver交互主要分为以下几个步骤：

    

      
walreceiver启动后通过recovery.conf文件中的primary_conninfo参数信息连向主库，主库通过连接参数replication=true启动walsender进程；

      
walreceiver执行identify_system命令，获取主库systemid/timeline/xlogpos等信息，执行TIMELINE_HISTORY命令拉取history文件；

      
执行wal_startstreaming开始启动流复制，通过walrcv_receive获取WAL日志，期间也会回应主库发过来的心跳信息(接收位点、flush位点、apply位点)，向主库发送feedback信息(最老的事务id)，避免vacuum删掉备库正在使用的记录；

      
执行walrcv_endstreaming结束流复制，等待startup进程更新receiveStart和receiveStartTLI，一旦更新，进入步骤2。

    

    

      

    

    
图2. PG流复制过程

    
walreceiver和startup进程

    
startup进程进入standby模式和apply日志主要过程：

    

      
读取pg_control文件，找到redo位点;读取recovery.conf，如果配置standby_mode=on则进入standby模式。

      
如果是Hot Standby需要初始化clog、subtrans、事务环境等。初始化redo资源管理器，比如Heap、Heap2、Database、XLOG等。

      
读取WAL record，如果record不存在需要调用XLogPageRead->WaitForWALToBecomeAvailable->RequestXLogStreaming唤醒walreceiver从walsender获取WAL record。

      

        
对读取的WAL record进行redo，通过
record->xl_rmid
信息，调用相应的redo资源管理器进行redo操作。比如heap_redo的XLOG_HEAP_INSERT操作，就是通过record的信息在buffer page中增加一个record：

        

          
 MemSet((char *) htup, 0, sizeof(HeapTupleHeaderData));
 /* PG73FORMAT: get bitmap [+ padding] [+ oid] + data */
 memcpy((char *) htup + offsetof(HeapTupleHeaderData, t_bits),
       (char *) xlrec + SizeOfHeapInsert + SizeOfHeapHeader,
       newlen);
 newlen += offsetof(HeapTupleHeaderData, t_bits);
 htup->t_infomask2 = xlhdr.t_infomask2;
 htup->t_infomask = xlhdr.t_infomask;
 htup->t_hoff = xlhdr.t_hoff;
 HeapTupleHeaderSetXmin(htup, record->xl_xid);
 HeapTupleHeaderSetCmin(htup, FirstCommandId);
 htup->t_ctid = xlrec->target.tid;

 offnum = PageAddItem(page, (Item) htup, newlen, offnum, true, true);
 if (offnum == InvalidOffsetNumber)
    elog(PANIC, "heap_insert_redo: failed to add tuple");

 freespace = PageGetHeapFreeSpace(page);        /* needed to update FSM below */

 PageSetLSN(page, lsn);

 if (xlrec->flags & XLOG_HEAP_ALL_VISIBLE_CLEARED)
    PageClearAllVisible(page);

 MarkBufferDirty(buffer);

        

        
还有部分redo操作(vacuum产生的record)需要检查在Hot Standby模式下的查询冲突，比如某些tuples需要remove，而存在正在执行的query可能读到这些tuples，这样就会破坏事务隔离级别。通过函数ResolveRecoveryConflictWithSnapshot检测冲突，如果发生冲突，那么就把这个query所在的进程kill掉。

      

      
检查一致性，如果一致了，Hot Standby模式可以接受用户只读查询；更新共享内存中XLogCtlData的apply位点和时间线；如果恢复到时间点，时间线或者事务id需要检查是否恢复到当前目标；

      
回到步骤3，读取next WAL record。

    

    

      

    

    
图3. PG standby模式和apply日志过程

  

  

    

    

    
Test Book

  

  

    
问题现象

    
研发同学执行下列语句序列

    

      
stop slave; set global slave_parallel_workers=0; start slave;

    

    
后程序 hang 住，不一会返回了2013 错误，即服务器连接异常中断，检查 mysqld error log, 发现在mysqld在将并行复制转化为串行复制的过程中异常 crash，其中错误信息为：

    

      
[ERROR] Error reading slave worker configuration
[ERROR] Error creating relay log info: Failed to initialize the worker info structure.

    

    
crash 堆栈为：

    

      
#0  0x000000395fc0c69c in pthread_kill () from /lib64/libpthread.so.0
#1  0x00000000006b2425 in handle_fatal_signal (sig=11)
#2  <signal handler called>
#3  remove_info (this=0x2b19b775b000)
#4  Relay_log_info::mts_finalize_recovery
#5  0x0000000000920ec3 in slave_start_workers
#6  0x0000000000921c03 in handle_slave_sql
#7  0x000000395fc07851 in start_thread () from /lib64/libpthread.so.0
#8  0x000000395f4e767d in clone () from /lib64/libc.so.6

    

    
结合源码仔细分析上面的错误信息不难发现，在启动 SQL 线程初始化 worker 信息的过程中失败，从而引起了空指针异常。

    
问题复现

    
一个简单的 start slave 就能够导致 mysqld crash？应该不会那么简单，编写 testcase，试图在本地重现以上问题，测例如下：

    

      
--source include/master-slave.inc
--source include/not_embedded.inc
--source include/not_windows.inc
--connection slave
stop slave;
set global slave_parallel_workers= 1;
start slave;

stop slave;
set global slave_parallel_workers= 0;
start slave;

--source include/rpl_end.inc

    

    
运行后果然没有能够重现问题，根据研发的同学反映在中断之前有一段时间命令是 hang 住的，于是断定 hang 问题与 crash 应该存在着联系，以上测例并不能将问题重现，于是与求助研发同学进行联调，在 hang 住的时候采集到了以下关键 pt-pmp 信息：

    

      
pthread_cond_wait,os_cond_wait(os0sync.cc:214),os_event_wait_low(os0sync.cc:610),lock_wait_suspend_thread(lock0wait.cc:323),row_mysql_handle_errors(row0mysql.cc:1040),row_search_for_mysql(row0sel.cc:5064),ha_innobase::index_read(ha_innodb.cc:7668),ha_innobase::index_first(ha_innodb.cc:8041),ha_innobase::rnd_next(ha_innodb.cc:8138),handler::ha_rnd_next(handler.cc:2812),Rpl_info_table_access::scan_info(rpl_info_table_access.cc:287),Rpl_info_table::do_check_info(rpl_info_table.cc:444),Rpl_info_factory::decide_repository(rpl_info_factory.cc:567),Rpl_info_factory::create_worker(rpl_info_factory.cc:419),Relay_log_info::mts_finalize_recovery(rpl_rli.cc:328),slave_start_workers(rpl_slave.cc:6294),handle_slave_sql(rpl_slave.cc:6523),pfs_spawn_thread(pfs.cc:1858),start_thread(libpthread.so.0),clone(libc.so.6)

pthread_cond_wait,safe_cond_wait(thr_mutex.c:240),inline_mysql_cond_wait(mysql_thread.h:1151),start_slave_thread(rpl_slave.cc:1502),start_slave_threads(rpl_slave.cc:1587),start_slave(rpl_slave.cc:9485),start_slave(rpl_slave.cc:548),start_slave_cmd(rpl_slave.cc:690),mysql_execute_command(sql_parse.cc:3576),mysql_parse(sql_parse.cc:6958),dispatch_command(sql_parse.cc:1583),do_command(sql_parse.cc:1102),do_handle_one_connection(sql_connect.cc:1006),handle_one_connection(sql_connect.cc:922),pfs_spawn_thread(pfs.cc:1858),start_thread(libpthread.so.0),clone(libc.so.6)

    

    
可以看到在 start slave 后，sql thread 读取 slave_worker_info 初始化 worker 的过程中遇到了锁等待问题，于是断定 relay_log_info_repository=’table’，并且有其它的线程对 slave_worker_info中的记录上了Ｘ锁，但是是哪个线程确不是很清楚，因为只看到了一个线程在访问 slave_worker_info 表，然后再一次在hang的时候执行了下列操作：

    

      
mysql> SELECT r.trx_id waiting_trx_id, r.trx_mysql_thread_id waiting_thread, left(r.trx_query,20) waiting_query, concat(concat(lw.lock_type, ' '), lw.lock_mode) waiting_for_lock, b.trx_id blocking_trx_id, b.trx_mysql_thread_id blocking_thread, left(b.trx_query,20) blocking_query, concat(concat(lb.lock_type, ' '), lb.lock_mode) blocking_lock FROM information_schema.innodb_lock_waits w INNER JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id   INNER JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id INNER JOIN information_schema.innodb_locks lw ON lw.lock_trx_id = r.trx_id INNER JOIN information_schema.innodb_locks lb ON lb.lock_trx_id = b.trx_id\G
*************************** 1. row ***************************
  waiting_trx_id: 1313
  waiting_thread: 12
   waiting_query: NULL
waiting_for_lock: RECORD S
 blocking_trx_id: 1312
 blocking_thread: 6
  blocking_query: start slave
   blocking_lock: RECORD X
1 row in set (0.00 sec)

mysql> show processlist;
+----+-------------+-----------------+-------+---------+------+-----------------------------------------+------------------+
| Id | User        | Host            | db    | Command | Time | State                                   | Info             |
+----+-------------+-----------------+-------+---------+------+-----------------------------------------+------------------+
|  2 | root        | localhost:57292 | test  | Sleep   |   16 |                                         |             |
|  3 | root        | localhost:57293 | test  | Sleep   |   16 |                                         |             |
|  6 | root        | localhost:57299 | test  | Query   |   15 | Waiting for slave thread to start       | start slave      |
|  7 | root        | localhost:57300 | test  | Sleep   |   16 |                                         |             |
| 11 | system user |                 | NULL  | Connect |   15 | Connecting to master                    |             |
| 12 | system user |                 | mysql | Connect |   15 | Waiting for the next event in relay log |             |
| 13 | root        | localhost       | test  | Query   |    0 | init                                    | show processlist |
+----+-------------+-----------------+-------+---------+------+-----------------------------------------+------------------+
7 rows in set (0.00 sec)

    

    
其中 information_schema.innodb_lock_waits，information_schema.innodb_locks，information_schema.innodb_trx 的信息可参考
官方文档
。

    
从以上信息可以清楚地看到 start slave（blocking_thread: 6）获取了 slave_worker_info 中行记录的Ｘ锁，而 sql thread 线程 (waiting_thread: 12) 在获取 S 锁失败引起锁等待，进而获取信息失败返回NULL, 进而造成了空指针引用，mysqld crash，此时 start slave 与 sql thread 的资源竟争如下：

    

      
start slave thread 获取 slave_work_info 记录的 X 锁，等待 sql thread 已启动的信号量，然后继续运行；

      
sql thread 被启动后，需要根据 slave_worker_info 为进行初始化，因此等待获取相关行的Ｓ锁;

    

    
因此，start slave thread 与 sql thread 形成了死锁，分析到了现在还有两个疑问没有解释：

    

      
start slave 为什么会访问 slave_worker_info 且一直持有锁资源?

      
为什么本地在测试的时候加上 relay_log_info_repository 的设置还是不能重现呢？

    

    
继续研究，打开general log 后，发现有许多的 set autocommit=0 的语句，于是感觉可能是 autocommit 的问题，修改后测例如下：

    

      
--source include/master-slave.inc
--source include/not_embedded.inc
--source include/not_windows.inc
--connection slave
stop slave;
set global relay_log_info_repository='table';
set global master_info_repository='table';
set global slave_parallel_workers= 1;
start slave;
--sleep 1

stop slave;
set autocommit=0;
set global slave_parallel_workers= 0;
start slave;

--source include/rpl_end.inc

    

    
运行后问题终于重现。。。

    
问题原因

    
有了以上的分析过程，不难看出，在 1) autocommit=0 && 2) relay_log_info_repository=’table’ && 3) 并行复制切换到串行复制时，就会触发此 bug, 原因有以下两个：

    

      
start slave thread 在等待 sql thread 的过程中没有释放其占用的锁资源；

      
sql thread 在初始化 worker 信息时没有处理获取信息失败的情况。

    

    
回到上面的问题：

    

      

        
start slave 为什么会访问 slave_worker_info 且一直持有锁资源?

        
答：start slave 的过程中需要初始化 worker信息，执行 crash recovery 等一系列操作，对于已经执行的不再执行，对于没有执行的继续执行，详情见
global_init_info
，
mts_recovery_groups
 等函数，在autocommit=0 的情况下，start slave thread 没有commit 或者执行完之前是不会释放锁资源的。

      

      

        
为什么本地在测试的时候加上 relay_log_info_repository 的设置还是不能重现呢？

        
答：本地在测试的时候，autocommit 默认值为1，因此不会重现。

在上锁方面为什么会上写锁，可以参考：
Rpl_info_table::do_init_info
 函数；

      

      
影响范围

经官方验证，5.6, 5.6.26, 5.6.28, 5.7.10 均存在此 bug。

    

    
问题扩展

    
在排查问题的过程中发现 start slave 时会自动提交当前 session 之前已经操作的数据，然后开启一个新的事务，所以在使用 start slave 时要注意这个问题！

  

  

    

    

    
Test Book

  

  

    
问题背景

    
最近线上遇到一个问题，用户重启实例后发现有张表打不开了，经调研后发现是用户之前的霸蛮操作导致的，下面给出复现步骤：

    

      
create table t1 (id int not null primary key, name varchar(100) not null) engine=innodb;
create table t2 (id int not null primary key, fid int not null, name varchar(100) not null, CONSTRAINT `fk_fid` FOREIGN KEY (`fid`) REFERENCES `t1` (`id`)) engine=innodb;
insert into t1 values(1, 'test 1'),(2, 'test 2'),(3,'test 3');
insert into t2 values(1, 1, 'test 1'),(2, 1, 'test 2'),(3, 2, 'test 3');
show create table t2;
show create table t2\G
*************************** 1. row ***************************
Table: t2
Create Table: CREATE TABLE `t2` (
`id` int(11) NOT NULL,
`fid` int(11) NOT NULL,
`name` varchar(100) NOT NULL,
PRIMARY KEY (`id`),
KEY `fk_fid` (`fid`),
CONSTRAINT `fk_fid` FOREIGN KEY (`fid`) REFERENCES `t1` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

-- 霸蛮的删掉外键约束用的索引
set foreign_key_checks=off;
alter table t2 drop index `fk_fid`;

-- 重启mysqld前表t2正常
set foreign_key_checks=on;
show create table t2;
*************************** 1\. row ***************************
Table: t2
Create Table: CREATE TABLE `t2` (
`id` int(11) NOT NULL,
`fid` int(11) NOT NULL,
`name` varchar(100) NOT NULL,
PRIMARY KEY (`id`),
CONSTRAINT `fk_fid` FOREIGN KEY (`fid`) REFERENCES `t1` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

-- 重启mysqld
show tables;
+----------------+
| Tables_in_test |
+----------------+
| t1             |
| t2             |
+----------------+
show create table t2;
ERROR 1146 (42S02): Table 'test.t2' doesn't exist

    

    
重启后t2表打不开了。

    
问题分析

    
在MySQL中，为了能够快速的检查外键约束，需要子表和父表对应的列上都要有索引，如果对应字段上没有索引, 子表在建立外键约束的时候，会自动加上。

    

      
MySQL requires indexes on foreign keys and referenced keys so that foreign key checks can be fast and not require a table scan. In the referencing table, there must be an index where the foreign key columns are listed as the first columns in the same order. Such an index is created on the referencing table automatically if it does not exist.

    

    
子表上的外键索引正常情况是删不掉，如果试图去删除的话会报错：

    

      
ERROR 1553 (HY000): Cannot drop index 'fk_fid': needed in a foreign key constrain

    

    
删索引时的外键检查逻辑在 
innobase_check_foreign_key_index()
函数中，感兴趣的同学可以自己看下，调用栈如下：

    

      
#0  innobase_check_foreign_key_index
#1  ha_innobase::prepare_inplace_alter_table
#2  handler::ha_prepare_inplace_alter_table
#3  mysql_inplace_alter_table
#4  mysql_alter_table
#5  Sql_cmd_alter_table::execute
#6  mysql_execute_command
#7  mysql_parse
#8  dispatch_command
#9  do_command
#10 do_handle_one_connection
#11 handle_one_connection
#12 pfs_spawn_thread
#13 start_thread
#14 clone

    

    
但是如果用户设置了 
set foreign_key_checks=off
 后，删除索引时就不会进入 
innobase_check_foreign_key_index()
 ，所以索引能被删掉。

    
在上面的复现步骤中还可以看到，如果不重启的话，表是能正常打开的，即使是做了flush tables，表也能正常打开，这又是为什么呢？

    
我们知道MySQL有个table_open_cache，这是server层对打开表的缓存，flush tables会把这个cache清掉；InnoDB层的字典系统对打开的表也有一个缓存，基于这个缓存又构建了2个链表
dict_sys->table_LRU
 和 
dict_sys->table_non_LRU
，位于前者中的表缓存会被系统用LRU算法清理掉，后者不会，清理由InnoDB后台线程做，flush tables 不会触发清理。并且如果InnoDB表有外键的话，缓存是被放在
dict_sys->table_non_LRU
上的，所以不会被后台线程清理掉，因此成功打开一次后就不会出问题了。关于含外键表缓存被放在 
dict_sys->table_non_LRU
上，具体的调用栈如下：

    

      
#0  dict_table_move_from_lru_to_non_lru
#1  dict_foreign_add_to_cache
#2  dict_load_foreign
#3  dict_load_foreigns
#4  dict_load_table
#5  dict_table_open_on_name
#6  ha_innobase::open
#7  handler::ha_open
#8  open_table_from_share
#9  open_table
#10 open_and_process_table
#11 open_tables
#12 open_tables
#13 mysqld_show_create
#14 mysql_execute_command
#15 mysql_parse
#16 dispatch_command
#17 do_command
#18 do_handle_one_connection
#19 handle_one_connection
#20 pfs_spawn_thread
#21 start_thread
#22 clone

    

    
关于这点
官方文档
也有描述：

    

      
InnoDB system table instances and parent and child table instances with foreign key relationships are not placed on the LRU list and are not subject to eviction from memory.

    

    
问题解决

    
通过上面的分析可以看出之所以表打不开，是因为用户霸蛮的删除了外键依赖的索引，但是能让用户通过SQL就把表弄的不能访问，也算是数据库系统的bug，也早有人给官方提了bug，详见
bug#68148
、
bug#70260
、
bug#74659
。

    
MySQL 5.6.12 对此进行了修复，如果遇到这种情况表打不开的话，只需要先 
set foreign_key_checks=off
，然后表就可以打开了，这时把缺失的索引再加上就可以了，修复详情见
patch
。

    
上面的修复是在出问题后，其实最好是能从源头上杜绝，不让用户删除外键约束需要的索引，因为这本身就是错误的操作，因此MySQL 5.7.5又出了一个
patch
，让用户无法删除外键约束的索引，即使用 
set foreign_key_checks=off
 关闭掉外键约束检查。

  

  

    

    

    
Test Book

  

  

    
前言

    
亚马逊推出的Aurora数据库引擎，支持一份存储，一主多读的架构。这个架构和Oracle RAC类似，也是共享存储，但是只有一个实例可以执行写操作，其他实例只能执行读操作。相比传统的基于复制的一主多读，节约了存储和网络带宽的成本。

    
我们可以使用PostgreSQL的hot standby模式来模拟这种共享存储一主多读的架构，但是需要注意几点，hot standby也会对数据库有写的动作，例如recovery时，会修改控制文件，数据文件等等，这些操作是多余的。另外很多状态是存储在内存中的，所以内存状态也需要更新。

    
还有需要注意的是：

    

      
pg_xlog
pg_log
pg_clog
pg_multixact
postgresql.conf
recovery.conf
postmaster.pid

    

    
最终实现一主多备的架构，需要通过改PG内核来实现：

    

      
这些文件应该是每个实例对应一份。

postgresql.conf, recovery.conf, postmaster.pid, pg_control

      
hot standby不执行实际的恢复操作，但是需要更新自己的内存状态，如当前的OID，XID等等，以及更新自己的pg_control。

      
在多实例间，要实现主到备节点的OS脏页的同步，数据库shared buffer脏页的同步。

    

    
模拟过程

    
不改任何代码，在同一主机下启多实例测试，会遇到一些问题。(后面有问题描述，以及如何修改代码来修复这些问题)

    
主实例配置文件：

    

      
 # vi postgresql.conf
listen_addresses='0.0.0.0'
port=1921
max_connections=100
unix_socket_directories='.'
ssl=on
ssl_ciphers='EXPORT40'
shared_buffers=512MB
huge_pages=try
max_prepared_transactions=0
max_stack_depth=100kB
dynamic_shared_memory_type=posix
max_files_per_process=500
wal_level=logical
fsync=off
synchronous_commit=off
wal_sync_method=open_datasync
full_page_writes=off
wal_log_hints=off
wal_buffers=16MB
wal_writer_delay=10ms
checkpoint_segments=8
archive_mode=off
archive_command='/bin/date'
max_wal_senders=10
max_replication_slots=10
hot_standby=on
wal_receiver_status_interval=1s
hot_standby_feedback=on
enable_bitmapscan=on
enable_hashagg=on
enable_hashjoin=on
enable_indexscan=on
enable_material=on
enable_mergejoin=on
enable_nestloop=on
enable_seqscan=on
enable_sort=on
enable_tidscan=on
log_destination='csvlog'
logging_collector=on
log_directory='pg_log'
log_truncate_on_rotation=on
log_rotation_size=10MB
log_checkpoints=on
log_connections=on
log_disconnections=on
log_duration=off
log_error_verbosity=verbose
log_line_prefix='%i
log_statement='none'
log_timezone='PRC'
autovacuum=on
log_autovacuum_min_duration=0
autovacuum_vacuum_scale_factor=0.0002
autovacuum_analyze_scale_factor=0.0001
datestyle='iso,
timezone='PRC'
lc_messages='C'
lc_monetary='C'
lc_numeric='C'
lc_time='C'
default_text_search_config='pg_catalog.english'

 # vi recovery.done
recovery_target_timeline='latest'
standby_mode=on
primary_conninfo = 'host=127.0.0.1 port=1921 user=postgres keepalives_idle=60'

 # vi pg_hba.conf
local   replication     postgres                                trust
host    replication     postgres 127.0.0.1/32            trust

    

    
启动主实例。

    

      
postgres@digoal-> pg_ctl start

    

    
启动只读实例，必须先删除postmaster.pid，这点PostgreSQL新版本加了一个PATCH，如果这个文件被删除，会自动关闭数据库，所以我们需要注意，不要使用最新的PGSQL，或者把这个patch干掉先。

    

      
postgres@digoal-> cd $PGDATA
postgres@digoal-> mv recovery.done recovery.conf

postgres@digoal-> rm -f postmaster.pid
postgres@digoal-> pg_ctl start -o "-c log_directory=pg_log1922 -c port=1922"

    

    
查看当前控制文件状态，只读实例改了控制文件，和前面描述一致。

    

      
postgres@digoal-> pg_controldata |grep state
Database cluster state:               in archive recovery

    

    
连到主实例，创建表，插入测试数据。

    

      
psql -p 1921
postgres=# create table test1(id int);
CREATE TABLE
postgres=# insert into test1 select generate_series(1,10);
INSERT 0 10

    

    
在只读实例查看插入的数据。

    

      
postgres@digoal-> psql -h 127.0.0.1 -p 1922
postgres=# select * from test1;
 id
----
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
(10 rows)

    

    
主实例执行检查点后，控制文件状态会改回生产状态。

    

      
psql -p 1921
postgres=# checkpoint;
CHECKPOINT

postgres@digoal-> pg_controldata |grep state
Database cluster state:               in production

    

    
但是如果在只读实例执行完检查点，又会改回恢复状态。

    

      
postgres@digoal-> psql -h 127.0.0.1 -p 1922
psql (9.4.4)
postgres=# checkpoint;
CHECKPOINT

postgres@digoal-> pg_controldata |grep state
Database cluster state:               in archive recovery

    

    
注意到，上面的例子有1个问题，用流复制的话，会从主节点通过网络拷贝XLOG记录，并覆盖同一份已经写过的XLOG记录的对应的OFFSET，这是一个问题，因为可能会造成主节点看到的数据不一致（比如一个数据块改了多次，只读实例在恢复时将它覆盖到老的版本了，在主实例上看到的就会变成老版本的BLOCK，后面再来改这个问题，禁止只读实例恢复数据）。

    
另一方面，我们知道PostgreSQL standby会从三个地方（流、pg_xlog、restore_command）读取XLOG进行恢复，所以在共享存储的环境中，我们完全没有必要用流复制的方式，直接从pg_xlog目录读取即可。修改recovery.conf参数，将以下注释

    

      
 # primary_conninfo = 'host=127.0.0.1 port=1921 user=postgres keepalives_idle=60'

    

    
重启只读实例。

    

      
pg_ctl stop -m fast
postgres@digoal-> pg_ctl start -o "-c log_directory=pg_log1922 -c port=1922"

    

    
重新测试数据一致性。

主实例：

    

      
postgres=# insert into test1 select generate_series(1,10);
INSERT 0 10
postgres=# insert into test1 select generate_series(1,10);
INSERT 0 10
postgres=# insert into test1 select generate_series(1,10);
INSERT 0 10
postgres=# insert into test1 select generate_series(1,10);
INSERT 0 10

    

    
只读实例：

    

      
postgres=# select count(*) from test1;
 count
-------
    60
(1 row)

    

    
问题分析和解决

    
截至目前，有几个问题未解决：

    

      
standby还是要执行recovery的操作，recovery产生的write操作会随着只读实例数量的增加而增加。另外recovery有一个好处，解决了脏页的问题，主实例shared buffer中的脏页不需要额外的同步给只读实例了。recovery还会带来一个严重的BUG，回放可能和当前主节点操作同一个data page；或者回放时将块回放到老的状态，而实际上主节点又更新了这个块，造成数据块的不一致。如果此时只读实例关闭，然后立即关闭主实例，数据库再起来时，这个数据块是不一致的；

      
standby还是会改控制文件；

      
在同一个$PGDATA下启动实例，首先要删除postmaster.pid；

      

        
关闭实例时，已经被删除postmaster.pid的实例，只能通过找到postgres主进程的pid，然后发kill -s 15, 2或3的信号来关闭数据库；

        

          
 static void
 set_mode(char *modeopt)
 {
         if (strcmp(modeopt, "s") == 0 || strcmp(modeopt, "smart") == 0)
         {
                 shutdown_mode = SMART_MODE;
                 sig = SIGTERM;
         }
         else if (strcmp(modeopt, "f") == 0 || strcmp(modeopt, "fast") == 0)
         {
                 shutdown_mode = FAST_MODE;
                 sig = SIGINT;
         }
         else if (strcmp(modeopt, "i") == 0 || strcmp(modeopt, "immediate") == 0)
         {
                 shutdown_mode = IMMEDIATE_MODE;
                 sig = SIGQUIT;
         }
         else
         {
                 write_stderr(_("%s: unrecognized shutdown mode \"%s\"\n"), progname, modeopt);
                 do_advice();
                 exit(1);
         }
 }

        

      

      

        
当主节点删除rel page时，只读实例回放时，会报invalid xlog对应的rel page不存在的错误，这个也是只读实例需要回放日志带来的问题。非常容易重现这个问题，删除一个表即可。

        

          
 2015-10-09 13:30:50.776 CST,,,2082,,561750ab.822,20,,2015-10-09 13:29:15 CST,1/0,0,WARNING,01000,"page 8 of relation base/151898/185251 does not exist",,,,,"xlog redo clean: rel 1663/151898/185251; blk 8 remxid 640632117",,,"report_invalid_page, xlogutils.c:67",""
 2015-10-09 13:30:50.776 CST,,,2082,,561750ab.822,21,,2015-10-09 13:29:15 CST,1/0,0,PANIC,XX000,"WAL contains references to invalid pages",,,,,"xlog redo clean: rel 1663/151898/185251; blk 8 remxid 640632117",,,"log_invalid_page, xlogutils.c:91",""

        

        
这个报错可以先注释这一段来绕过，从而可以演示下去。

        

          
 src/backend/access/transam/xlogutils.c
 /* Log a reference to an invalid page */
 static void
 log_invalid_page(RelFileNode node, ForkNumber forkno, BlockNumber blkno,
                                  bool present)
 {
   //////
         /*
          * Once recovery has reached a consistent state, the invalid-page table
          * should be empty and remain so. If a reference to an invalid page is
          * found after consistency is reached, PANIC immediately. This might seem
          * aggressive, but it's better than letting the invalid reference linger
          * in the hash table until the end of recovery and PANIC there, which
          * might come only much later if this is a standby server.
          */
         //if (reachedConsistency)
         //{
         //      report_invalid_page(WARNING, node, forkno, blkno, present);
         //      elog(PANIC, "WAL contains references to invalid pages");
         //}

        

      

      
由于本例是在同一个操作系统中演示，所以没有遇到OS的dirty page cache的问题，如果是不同主机的环境，我们需要解决OS dirty page cache 的同步问题，或者消除dirty page cache，如使用direct IO。或者集群文件系统如gfs2。

    

    
如果要产品化，至少需要解决以上问题。

    
先解决Aurora实例写数据文件、控制文件、检查点的问题。

    

      

        
增加一个启动参数，表示这个实例是否为Aurora实例（即只读实例）

        

          
  # vi src/backend/utils/misc/guc.c
 /******** option records follow ********/

 static struct config_bool ConfigureNamesBool[] =
 {
         {
                 {"aurora", PGC_POSTMASTER, CONN_AUTH_SETTINGS,
                         gettext_noop("Enables advertising the server via Bonjour."),
                         NULL
                 },
                 &aurora,
                 false,
                 NULL, NULL, NULL
         },

        

      

      

        
新增变量

        

          
 # vi src/include/postmaster/postmaster.h
 extern bool aurora;

        

      

      

        
禁止Aurora实例更新控制文件

        

          
 # vi src/backend/access/transam/xlog.c
 #include "postmaster/postmaster.h"
 bool aurora;

 void
 UpdateControlFile(void)
 {
         if (aurora) return;

        

      

      

        
禁止Aurora实例启动bgwriter进程

        

          
 # vi src/backend/postmaster/bgwriter.c
 #include "postmaster/postmaster.h"
 bool  aurora;

 /*
  * Main entry point for bgwriter process
  *
  * This is invoked from AuxiliaryProcessMain, which has already created the
  * basic execution environment, but not enabled signals yet.
  */
 void
 BackgroundWriterMain(void)
 {
   //////
         pg_usleep(1000000L);

         /*
          * If an exception is encountered, processing resumes here.
          *
          * See notes in postgres.c about the design of this coding.
          */
         if (!aurora && sigsetjmp(local_sigjmp_buf, 1) != 0)
         {

   //////
                 /*
                  * Do one cycle of dirty-buffer writing.
                  */
                 if (!aurora) {
                 can_hibernate = BgBufferSync();
   //////
                 }
                 pg_usleep(1000000L);
         }
 }

        

      

      

        
禁止Aurora实例启动checkpointer进程

        

          
 # vi src/backend/postmaster/checkpointer.c
 #include "postmaster/postmaster.h"
 bool  aurora;
   //////
 /*
  * Main entry point for checkpointer process
  *
  * This is invoked from AuxiliaryProcessMain, which has already created the
  * basic execution environment, but not enabled signals yet.
  */
 void
 CheckpointerMain(void)
 {
   //////
         /*
          * Loop forever
          */
         for (;;)
         {
                 bool            do_checkpoint = false;
                 int                     flags = 0;
                 pg_time_t       now;
                 int                     elapsed_secs;
                 int                     cur_timeout;
                 int                     rc;

                 pg_usleep(100000L);

                 /* Clear any already-pending wakeups */
                 if (!aurora)  ResetLatch(&MyProc->procLatch);

                 /*
                  * Process any requests or signals received recently.
                  */
                 if (!aurora) AbsorbFsyncRequests();

                 if (!aurora && got_SIGHUP)
                 {
                         got_SIGHUP = false;
                         ProcessConfigFile(PGC_SIGHUP);

                         /*
                          * Checkpointer is the last process to shut down, so we ask it to
                          * hold the keys for a range of other tasks required most of which
                          * have nothing to do with checkpointing at all.
                          *
                          * For various reasons, some config values can change dynamically
                          * so the primary copy of them is held in shared memory to make
                          * sure all backends see the same value.  We make Checkpointer
                          * responsible for updating the shared memory copy if the
                          * parameter setting changes because of SIGHUP.
                          */
                         UpdateSharedMemoryConfig();
                 }
                 if (!aurora && checkpoint_requested)
                 {
                         checkpoint_requested = false;
                         do_checkpoint = true;
                         BgWriterStats.m_requested_checkpoints++;
                 }
                 if (!aurora && shutdown_requested)
                 {
                         /*
                          * From here on, elog(ERROR) should end with exit(1), not send
                          * control back to the sigsetjmp block above
                          */
                         ExitOnAnyError = true;
                         /* Close down the database */
                         ShutdownXLOG(0, 0);
                         /* Normal exit from the checkpointer is here */
                         proc_exit(0);           /* done */
                 }

                 /*
                  * Force a checkpoint if too much time has elapsed since the last one.
                  * Note that we count a timed checkpoint in stats only when this
                  * occurs without an external request, but we set the CAUSE_TIME flag
                  * bit even if there is also an external request.
                  */
                 now = (pg_time_t) time(NULL);
                 elapsed_secs = now - last_checkpoint_time;
                 if (!aurora && elapsed_secs >= CheckPointTimeout)
                 {
                         if (!do_checkpoint)
                                 BgWriterStats.m_timed_checkpoints++;
                         do_checkpoint = true;
                         flags |= CHECKPOINT_CAUSE_TIME;
                 }

                 /*
                  * Do a checkpoint if requested.
                  */
                 if (!aurora && do_checkpoint)
                 {
                         bool            ckpt_performed = false;
                         bool            do_restartpoint;

                         /* use volatile pointer to prevent code rearrangement */
                         volatile CheckpointerShmemStruct *cps = CheckpointerShmem;

                         /*
                          * Check if we should perform a checkpoint or a restartpoint. As a
                          * side-effect, RecoveryInProgress() initializes TimeLineID if
                          * it's not set yet.
                          */
                         do_restartpoint = RecoveryInProgress();

                         /*
                          * Atomically fetch the request flags to figure out what kind of a
                          * checkpoint we should perform, and increase the started-counter
                          * to acknowledge that we've started a new checkpoint.
                          */
                         SpinLockAcquire(&cps->ckpt_lck);
                         flags |= cps->ckpt_flags;
                         cps->ckpt_flags = 0;
                         cps->ckpt_started++;
                         SpinLockRelease(&cps->ckpt_lck);

                         /*
                          * The end-of-recovery checkpoint is a real checkpoint that's
                          * performed while we're still in recovery.
                          */
                         if (flags & CHECKPOINT_END_OF_RECOVERY)
                                 do_restartpoint = false;
   //////
                         ckpt_active = false;
                 }

                 /* Check for archive_timeout and switch xlog files if necessary. */
                 if (!aurora) CheckArchiveTimeout();
                 /*
                  * Send off activity statistics to the stats collector.  (The reason
                  * why we re-use bgwriter-related code for this is that the bgwriter
                  * and checkpointer used to be just one process.  It's probably not
                  * worth the trouble to split the stats support into two independent
                  * stats message types.)
                  */
                 if (!aurora) pgstat_send_bgwriter();

                 /*
                  * Sleep until we are signaled or it's time for another checkpoint or
                  * xlog file switch.
                  */
                 now = (pg_time_t) time(NULL);
                 elapsed_secs = now - last_checkpoint_time;
                 if (elapsed_secs >= CheckPointTimeout)
                         continue;                       /* no sleep for us ... */
                 cur_timeout = CheckPointTimeout - elapsed_secs;
                 if (!aurora && XLogArchiveTimeout > 0 && !RecoveryInProgress())
                 {
                         elapsed_secs = now - last_xlog_switch_time;
                         if (elapsed_secs >= XLogArchiveTimeout)
                                 continue;               /* no sleep for us ... */
                         cur_timeout = Min(cur_timeout, XLogArchiveTimeout - elapsed_secs);
                 }

                 if (!aurora) rc = WaitLatch(&MyProc->procLatch,
                                            WL_LATCH_SET | WL_TIMEOUT | WL_POSTMASTER_DEATH,
                                            cur_timeout * 1000L /* convert to ms */ );

                 /*
                  * Emergency bailout if postmaster has died.  This is to avoid the
                  * necessity for manual cleanup of all postmaster children.
                  */
                 if (rc & WL_POSTMASTER_DEATH)
                         exit(1);
         }
 }
   //////
 /* SIGINT: set flag to run a normal checkpoint right away */
 static void
 ReqCheckpointHandler(SIGNAL_ARGS)
 {
         if (aurora)
            return;
         int                     save_errno = errno;

         checkpoint_requested = true;
         if (MyProc)
                 SetLatch(&MyProc->procLatch);

         errno = save_errno;
 }
   //////
 /*
  * AbsorbFsyncRequests
  *              Retrieve queued fsync requests and pass them to local smgr.
  *
  * This is exported because it must be called during CreateCheckPoint;
  * we have to be sure we have accepted all pending requests just before
  * we start fsync'ing.  Since CreateCheckPoint sometimes runs in
  * non-checkpointer processes, do nothing if not checkpointer.
  */
 void
 AbsorbFsyncRequests(void)
 {
         CheckpointerRequest *requests = NULL;
         CheckpointerRequest *request;
         int                     n;

         if (!AmCheckpointerProcess() || aurora)
                 return;
   //////

        

      

      

        
禁止Aurora实例手工调用checkpoint命令

        

          
 # vi src/backend/tcop/utility.c
 #include "postmaster/postmaster.h"
 bool  aurora;

   //////
 void
 standard_ProcessUtility(Node *parsetree,
                                                 const char *queryString,
                                                 ProcessUtilityContext context,
                                                 ParamListInfo params,
                                                 DestReceiver *dest,
                                                 char *completionTag)
 {
   //////
                 case T_CheckPointStmt:
                    if (!superuser() || aurora)
                                 ereport(ERROR,
                                                 (errcode(ERRCODE_INSUFFICIENT_PRIVILEGE),
                                                  errmsg("must be superuser to do CHECKPOINT")));

        

      

    

    
改完上面的代码，重新编译一下，现在接近一个DEMO了。现在Aurora实例不会更新控制文件，不会写数据文件，不会执行checkpoint，是我们想要的结果。

启动只读实例时，加一个参数aurora=true，表示启动Aurora实例。

    

      
pg_ctl start -o "-c log_directory=pg_log1922 -c port=1922 -c aurora=true"

    

    
不过要产品化，还有很多细节需要考虑，这只是一个DEMO。阿里云RDS的小伙伴们加油！

    
还有一种更保险的玩法，共享存储多读架构，需要存储两份数据。其中一份是主实例的存储，它自己玩自己的，其他实例不对它做任何操作；另一份是standby的，这部作为共享存储，给多个只读实例来使用。

    
参考

    

      

        
https://aws.amazon.com/cn/rds/aurora/

      

      

        
src/backend/access/transam/xlog.c

        

          
 /*
  * Open the WAL segment containing WAL position 'RecPtr'.
  *
  * The segment can be fetched via restore_command, or via walreceiver having
  * streamed the record, or it can already be present in pg_xlog. Checking
  * pg_xlog is mainly for crash recovery, but it will be polled in standby mode
  * too, in case someone copies a new segment directly to pg_xlog. That is not
  * documented or recommended, though.
  *
  * If 'fetching_ckpt' is true, we're fetching a checkpoint record, and should
  * prepare to read WAL starting from RedoStartLSN after this.
  *
  * 'RecPtr' might not point to the beginning of the record we're interested
  * in, it might also point to the page or segment header. In that case,
  * 'tliRecPtr' is the position of the WAL record we're interested in. It is
  * used to decide which timeline to stream the requested WAL from.
  *
  * If the record is not immediately available, the function returns false
  * if we're not in standby mode. In standby mode, waits for it to become
  * available.
  *
  * When the requested record becomes available, the function opens the file
  * containing it (if not open already), and returns true. When end of standby
  * mode is triggered by the user, and there is no more WAL available, returns
  * false.
  */
 static bool
 WaitForWALToBecomeAvailable(XLogRecPtr RecPtr, bool randAccess,
                                                         bool fetching_ckpt, XLogRecPtr tliRecPtr)
 {
   //////
         static pg_time_t last_fail_time = 0;
         pg_time_t       now;

         /*-------
          * Standby mode is implemented by a state machine:
          *
          * 1. Read from either archive or pg_xlog (XLOG_FROM_ARCHIVE), or just
          *        pg_xlog (XLOG_FROM_XLOG)
          * 2. Check trigger file
          * 3. Read from primary server via walreceiver (XLOG_FROM_STREAM)
          * 4. Rescan timelines
          * 5. Sleep 5 seconds, and loop back to 1.
          *
          * Failure to read from the current source advances the state machine to
          * the next state.
          *
          * 'currentSource' indicates the current state. There are no currentSource
          * values for "check trigger", "rescan timelines", and "sleep" states,
          * those actions are taken when reading from the previous source fails, as
          * part of advancing to the next state.
          *-------
          */

        

      

    

  

  

    

    

    
Test Book

  

  

    
背景

    
TokuDB在启动的时候，会对datadir目录下的文件（和文件夹）进行遍历，根据规则找到所有的redo log文件，然后进行recover操作。

redo文件的命名规则是:log[index].toku[version]，比如log000000000002.tokulog27。

    
问题

    
这个bug说起来有点“谜之”，因为它还跟编译器的版本有关。

    
如果使用gcc 4.8.2编译出一个TokuDB（加-O3编译参数），进行如下操作：

    

      
CREATE DATABASE log0002;

    

    
然后重启，整个TokuDB就可能凌乱了，出现如下crash信息：

    

      
storage/tokudb/ft-index/ft/logger/logfilemgr.cc:159 toku_logfilemgr_init: Assertion 'r==2' failed (errno=2)
Backtrace: (Note: toku_do_assert=0x0xcd50d0)
mysqld(_Z20toku_logfilemgr_initP15toku_logfilemgrPKcPm+0x26c)[0xc40cdc]
mysqld(_Z30toku_logger_open_with_last_xidPKcP10tokuloggerm+0x51)[0xc10ba1]
mysqld(_Z14tokuft_recover)

    

    
原因

    
先来看下TokuDB判断一个文件是否为redo log的代码：

    

      
static bool is_a_logfile_any_version (const char *name, uint64_t *number_result, uint32_t *version_of_log) {
    bool rval = true;
    uint64_t result;
    int n;
    int r;
    uint32_t version;
    r = sscanf(name, "log%" SCNu64 ".tokulog%" SCNu32 "%n", &result, &version, &n);
    if (r!=2 || name[n]!='\0' || version <= TOKU_LOG_VERSION_1) {
        //Version 1 does NOT append 'version' to end of '.tokulog'
        version = TOKU_LOG_VERSION_1;
        r = sscanf(name, "log%" SCNu64 ".tokulog%n", &result, &n);
        if (r!=1 || name[n]!='\0') {
            rval = false;
        }
    }
    if (rval) {
        *number_result  = result;
        *version_of_log = version;
    }

    return rval;
}

    

    
这段代码的逻辑很简单，调用sscanf函数获取相关参数, 高能区域为：

    

      
r = sscanf(name, "log%" SCNu64 ".tokulog%" SCNu32 "%n", &result, &version, &n);

    

    
如果name为log0002，调用完sscanf函数后，n和version的值是不确定的（因为函数内变量未被初始化），就可能导致函数 
is_a_logfile_any_version
 把log0002文件夹误认为是一个redo log。

当
toku_logfilemgr_init
函数加载名称“log0002”时做二次校验，获取version值失败从而触发assert。

    
修复

    
大体思路是：

    

      
由于redo log不可能是文件夹，所以增加只对文件进行判断的逻辑，遇到文件夹直接跳过；

      
对
is_a_logfile_any_version
函数内变量进行初始化。

    

    
阿里云RDS TokuDB最新版本已经修复此问题，使用TokuDB的用户可以进行下小版本升级，以避免此问题影响业务。

  

  

    

    

    
Test Book

  

  

    
最近遇到这样一个需求：在做时间点恢复时，需要从主库获取最近生成的那些xlog文件（需要获取的xlog文件名是已知的）。怎么办？一个想法是，利用scp等工具，直接从主库下载，这要求我们处理整个下载过程，比较麻烦。其实PG已经为我们准备了一个xlog传输工具——pg_receivexlog。这个工具可能很多人都没注意到，而且官方文档中介绍的很少。在这里我们为大家解析一下这个工具。

    
能做什么

    
pg_receivexlog能为我们做什么呢？它能够从一个PG服务器，获取你想要的那些xlog日志文件。初步研究后，我们可以得到以下信息：

    

      
它以类似流式复制（streaming replication）的方式，获取主库的xlog文件。这意味着你要以超级用户或有replication权限的用户，连接PG进行日志传输，且要在pg_hba.conf里面，对其做权限配置。在连接建立后，PG服务器会有一个独立的WAL sender进程，负责xlog的传输，所以
max_wal_senders
要至少为1，使我们能获得一个WAL sender。

      
它不会等待一个xlog文件写完后才开始传输。也就是说，正在被写的xlog文件，也会进行传输，因此可以通过这个工具实时获取最新的xlog内容。

      
可以使用replication slot，通过同步replication slot的方式进行日志传输。这样做的好处是，主库在xlog传输完成前不会删除xlog文件。不过可能的风险是，如果日志没有利用slot成功传输，可能导致日志堆积在PG里面，最终把磁盘占满。

    

    
如何启动

    
PG安装后的bin目录里面，一般包含了pg_receivexlog这个工具。可以使用下面的方式启动它:

    

      
pg_receivexlog -h <host name> -p <port> -U <user> -W <password> -D <local dir to store xlog files>

    

    
其中，-h -p -U -W 选项指定要连接的PG的主机名、端口、用户、密码，-D 选项指定本地的一个目录，用于存储下载的xlog文件。另外缺省情况下，如果连接无法建立，或传输过程中连接意外断开，pg_receivexlog会进行重试，如果不想重试，可以指定-n选项。

    
有个问题是，如何指定要传输哪些xlog文件？先来看看pg_receivexlog如何确定从哪个xlog文件开始传输的。从src/bin/pg_basebackup/pg_receivexlog.c 的
FindStreamingStart
函数可以看出，pg_receivexlog会扫描整个-D选项指定的目录，将扫描到的每个文件名，去掉其timeline部分，转换为64为整数。选取其中对应整数最大的文件，按如下方式选择开始下载的文件：如果这个文件是以.partial为后缀的，则重新下载此文件和后续文件；如果该文件不带.partial后缀，是一个完整的日志文件，则从此文件的下一个文件（文件名加1）开始下载。如果我们需要从00000001000000000000001B到00000001000000000000001D的几个文件，则只需要在-D指定的目录里面执行：

    

      
touch 00000001000000000000001B.partial

    

    
保证此目录没有其他文件，然后按上面列出的方式启动pg_receivexlog即可，pg_receivexlog会重新下载00000001000000000000001B和后续文件。

    
如何停止

    
如何停止pg_receivexlog的执行呢？pg_receivexlog已经下载了我们需要的文件后，并不会自动停止，我们也没有办法指定它下载到哪个文件结束。唯一的办法是通过Ctl-C命令向它发送SIGINT信号来结束它。类似的，可以直接向它的进程发生kill命令：

    

      
kill -SIGINT <pg_receivexlog pid>

    

    
注意，pg_receivexlog只在成功传输完一个xlog文件后，才检查是否收到了SIGINT信号，因此你只可能在一个文件接收完成后正常结束pg_receivexlog运行。其实更暴力的办法是直接kill -9 也是可以的。

    
从上面的分析可以看出，pg_receivexlog这个工具还是比较简单易用的。除了传输xlog日志，可以利用它做一个日志服务器，用来存储归档的日志；还可以做为一主多备方案。由此可见，pg_receivexlog既是一个很实用的工具，也是一个可以用于更多场景的让人充满想象的利器。

  

  

    

    

    
Test Book

  

  

    
权限相关的表

    
系统表

    
MySQL用户权限信息都存储在以下系统表中，用户权限的创建、修改和回收都会同步更新到系统表中。

    

      
mysql.user            //用户信息
mysql.db              //库上的权限信息
mysql.tables_priv     //表级别权限信息
mysql.columns_priv    //列级别权限信息
mysql.procs_priv      //存储过程和存储函数的权限信息
mysql.proxies_priv    //MySQL proxy权限信息，这里不讨论

    

    

      
mysql.db存储是库的权限信息，不是存储实例有哪些库。MySQL查看实例有哪些数据库是通过在数据目录下查找有哪些目录文件得到的。

    

    
information_schema表

    
information_schema下有以下权限相关的表可供查询:

    

      
USER_PRIVILEGES
SCHEMA_PRIVILEGES
TABLE_PRIVILEGES
COLUMN_PRIVILEGES

    

    
权限缓存

    
用户在连接数据库的过程中，为了加快权限的验证过程，系统表中的权限会缓存到内存中。

例如：

mysql.user缓存在数组acl_users中,

mysql.db缓存在数组acl_dbs中,

mysql.tables_priv和mysql.columns_priv缓存在hash表column_priv_hash中,

mysql.procs_priv缓存在hash表proc_priv_hash和func_priv_hash中。

    
另外acl_cache缓存db级别的权限信息。例如执行use db时，会尝试从acl_cache中查找并更新当前数据库权限（
thd->security_ctx->db_access
）。

    
权限更新过程

    
以grant select on test.t1为例:

    

      
更新系统表mysql.user，mysql.db，mysql.tables_priv；

      
更新缓存acl_users，acl_dbs，column_priv_hash；

      
清空acl_cache。

    

    
FLUSH PRIVILEGES

    
FLUSH PRIVILEGES会重新从系统表中加载权限信息来构建缓存。

    
当我们通过SQL语句直接修改权限系统表来修改权限时，权限缓存是没有更新的，这样会导致权限缓存和系统表不一致。因此通过这种方式修改权限后，应执行FLUSH PRIVILEGES来刷新缓存，从而使更新的权限生效。

    
通过GRANT/REVOKE/CREATE USER/DROP USER来更新权限是不需要FLUSH PRIVILEGES的。

    

      
当前连接修改了权限信息时，现存的其他客户连接是不受影响的，权限在客户的下一次请求时生效。

    

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · InnoDB Adaptive hash index介绍

        

      

      

        

          
PgSQL · 特性分析 · clog异步提交一致性、原子操作与fsync

        

      

      

        

          
MySQL · 捉虫动态 · BUG 几例

        

      

      

        

          
PgSQL · 答疑解惑 · 诡异的函数返回值

        

      

      

        

          
MySQL · 捉虫动态 · 建表过程中crash造成重建表失败

        

      

      

        

          
PgSQL · 特性分析 · 谈谈checkpoint的调度

        

      

      

        

          
MySQL · 特性分析 · 5.6 并行复制恢复实现

        

      

      

        

          
MySQL · 备库优化 · relay fetch 备库优化

        

      

      

        

          
MySQL · 特性分析 · 5.6并行复制事件分发机制

        

      

      

        

MySQL · TokuDB · 文件目录谈
*

      

    

  

  

    

    

    
Test Book

  

  

    
前言

    
我们知道InnoDB的索引组织结构为Btree。通常情况下，我们需要根据查询条件，从根节点开始寻路到叶子节点，找到满足条件的记录。为了减少寻路开销，InnoDB本身做了几点优化。

    
首先，对于连续记录扫描，InnoDB在满足比较严格的条件时采用row cache的方式连续读取8条记录（并将记录格式转换成MySQL Format），存储在线程私有的
row_prebuilt_t::fetch_cache
中；这样一次寻路就可以获取多条记录，在server层处理完一条记录后，可以直接从cache中取数据而无需再次寻路，直到cache中数据取完，再进行下一轮。

    
另一种方式是，当一次进入InnoDB层获得数据后，在返回server层前，当前在btree上的cursor会被暂时存储到
row_prebuilt_t::pcur
中，当再次返回InnoDB层捞数据时，如果对应的Block没有发生任何修改，则可以继续沿用之前存储的cursor，无需重新定位。

    
上面这两种方式都是为了减少了重新寻路的次数，而对于一次寻路的开销，则使用Adaptive hash index来解决。AHI是一个内存结构，严格来说不是传统意义上的索引，可以把它理解为建立在Btree索引上的“索引”。

    
本文代码分析基于MySQL 5.7.7-rc，描述的逻辑适用于5.7.7之前及5.6版本。但在即将发布的MySQL-5.7.8版本中， InnoDB根据索引id对AHI进行了分区处理，以此来降低btr_search_latch读写锁竞争，由于尚未发布，本文暂不覆盖相关内容。

    
我们以一个干净启动的实例作为起点，分析下如何进行AHI构建的过程。

    
初始化

    
AHI在内存中表现就是一个普通的哈希表对象，存储在
btr_search_sys_t::hash_index
中，对AHI的查删改操作都是通过一个全局读写锁
btr_search_latch
来保护。

    
在实例启动，完成buffer pool初始化后，会初始化AHI子系统相关对象，并分配AHI内存，大小为buffer pool的1/64。

    
参考函数：
btr_search_sys_create

    
Tips：MySQL 5.7已经开始支持InnoDB buffer pool的动态调整，其策略是buffer pool的大小改变超过1倍，就重新分配AHI Hash内存（
btr_search_sys_resize
）。

    
触发AHI信息统计

    
在系统刚启动时，索引对象上没有足够的信息来启发是否适合进行AHI缓存，因此开始有个信息搜集的阶段，在索引对象上维护了
dict_index_t::search_info
，类型为
btr_search_t
，用于跟踪当前索引使用AHI的关键信息。

    
在第一次执行SQL时，需要从btree的root节点开始，当寻址到匹配的叶子节点时，会走如下逻辑：

    
btr_cur_search_to_nth_level：

    

      
if (btr_search_enabled && !index->disable_ahi) {
        btr_search_info_update(index, cursor);
}

    

    
这里会判断脏读AHI开关（btr_search_enabled）是否打开，以及
index->diable_ahi
是否为false。第二个条件是MySQL5.7对临时表的优化，避免临时表操作对全局对象的影响，针对临时表不做AHI构建。

    
我们看看函数btr_search_info_update的逻辑：

    

      
对
info->hash_analysis++
，当
info->hash_analysis
值超过
BTR_SEARCH_HASH_ANALYSIS
（17）时，也就是说对该索引寻路到叶子节点17次后，才会去做AHI分析（进入步骤2）

      
进入函数
btr_search_info_update_slow

    

    
在连续执行17次对相同索引的操作后，满足
info->hash_analysis
大于等于
BTR_SEARCH_HASH_ANALYSIS
的条件，就会调用函数
btr_search_info_update_slow
来更新search_info，这主要是为了避免频繁的索引查询分析产生的过多CPU开销。

    
InnoDB通过索引条件构建一个可用于查询的tuple，而AHI需要根据tuple定位到叶子节点上记录的位置，既然AHI是构建在Btree索引上的索引，它的键值就是通过索引的前N列的值计算的来，所有的信息搜集统计都是为了确定一个合适的”Ｎ” ，这个值也是个动态的值，会跟随应用的负载自适应调整并触发block上的AHI重构建。

    

btr_search_info_update_slow
包含三个部分：更新索引查询信息、block上的查询信息以及为当前block构建AHI，下面几小节分别介绍。

    
更新索引上的查询信息

    
参考函数：
btr_search_info_update_hash

    
这里涉及到的几个search_info变量包括：

btr_search_t::n_hash_potential
 表示如果使用AHI构建索引，潜在的可能成功的次数；

btr_search_t::hash_analysis
 若设置了新的建议前缀索引模式，则重置为0，随后的17次查询分析可以忽略更新search_info。

    
下面两个字段表示推荐的前缀索引模式：

btr_search_t::n_fields
 推荐构建AHI的索引列数；

btr_search_t::left_side
 表示是否在相同索引前缀的最左索引记录构建AHI；值为true时，则对于相同前缀索引的记录，只存储最右的那个记录。

通过n_fields和left_side可以指导选择哪些列作为索引前缀来构建（fold, rec）哈希记录。如果用户的SQL的索引前缀列的个数大于等于构建AHI时的前缀索引，就可以用上AHI。

    
Tip1：在５.7之前的版本中，还支持索引中的字符串前缀作为构建AHI的键值的一部分，但上游认为带来的好处并不明显，因此将
btr_search_t::n_bytes
 移除了(参见commit 
6f5f19b338543277a108a97710de8dd59b9dbb60
, 
42499d9394bf103a27d63cd38b0c3c6bd738a7c7
）。

Tip2：然而上游在测试中发现，如果把n_bytes移除，可能在诸如顺序插入这样的场景存在性能退化(参阅commit 
00ec81a9efc1108376813f15935b52c451a268cf
)，因此在新发布的MySQL5.7.8版本中又重新引入，本文分析代码时统一基于MySQL5.7.7版本。

    
两种情况需要构建建议的前缀索引列：

    

      
当前是第一次为该索引做AHI分析，
btr_search_t::n_hash_potential
值为0，需要构建建议的前缀索引列；

      
新的记录匹配模式发生了变化
(info->left_side == (info->n_fields <=cursor->low_match))
，需要重新设置前缀索引列。

    

    
相关代码段：

    

      
if (cursor->up_match == cursor->low_match) {
        info->n_hash_potential = 0; 

        /* For extra safety, we set some sensible values here */

        info->n_fields = 1; 
        info->left_side = TRUE;

} else if (cursor->up_match > cursor->low_match) {
        info->n_hash_potential = 1; 

        if (cursor->up_match >= n_unique) {
                info->n_fields = n_unique;
        } else if (cursor->low_match < cursor->up_match) {
                info->n_fields = cursor->low_match + 1; 
        } else {
                info->n_fields = cursor->low_match;
        }    

        info->left_side = TRUE;
} else {
        info->n_hash_potential = 1; 

        if (cursor->low_match >= n_unique) {

                info->n_fields = n_unique;
        } else if (cursor->low_match > cursor->up_match) {

                info->n_fields = cursor->up_match + 1; 
        } else {
                info->n_fields = cursor->up_match;
        }    

        info->left_side = FALSE;
}

    

    
从上述代码可以看到，在low_match和up_match之间，选择小一点match的索引列数的来进行设置，但不超过唯一确定索引记录值的列的个数：

    

      
当low_match小于up_match时，left_side设置为true，表示相同前缀索引的记录只缓存最左记录；

      
当low_match大于up_match时，left_side设置为false，表示相同前缀索引的记录只缓存最右记录。

    

    
如果不是第一次进入seach_info分析，有两种情况会递增
btr_search_t::n_hash_potential
：

    

      

        
本次查询的up_match和当前推荐的前缀索引都能唯一决定一条索引记录(例如唯一索引)，则根据search_info推荐的前缀索引列构建AHI肯定能命中，递增 
info->n_hash_potential
；

        

          
  if (info->n_fields >= n_unique && cursor->up_match >= n_unique) {
  increment_potential:
          info->n_hash_potential++;

          return;
  }

        

      

      

        
本次查询的tuple可以通过建议的前缀索引列构建的AHI定位到。

        

          
  if (info->left_side == (info->n_fields <= cursor->up_match)) {

          goto increment_potential;
  }

        

      

    

    
很显然，如果对同一个索引的查询交替使用不同的查询模式，可能上次更新的search_info很快就会被重新设置，具有固定模式的索引查询将会受益于AHI索引。

    
更新block上的查询信息

    
参考函数：
btr_search_update_block_hash_info

    
更新数据页block上的查询信息，涉及到修改的变量包括：

    

btr_search_info::last_hash_succ
 最近一次成功(或可能成功)使用AHI；

buf_block_t::n_hash_helps
 计数值，如果使用当前推荐的前缀索引列构建AHI可能命中的次数，用于启发构建／重新构建数据页上的AHI记录项；

buf_block_t::n_fields
 推荐在block上构建AHI的前缀索引列数；

buf_block_t::left_side
 和search_info上对应字段含义相同。

    
函数主要流程包括：

    

      

        
首先设置
btr_search_info::last_hash_succ
 为FALSE

这会导致在分析过程中无法使用AHI进行检索，感觉这里的设置不是很合理。这意味着每次分析一个新的block，都会导致AHI短暂不可用。

      

      

        
初始化或更新block上的查询信息

        

          
 if ((block->n_hash_helps > 0)
     && (info->n_hash_potential > 0)
     && (block->n_fields == info->n_fields)
     && (block->left_side == info->left_side)) {

         if ((block->index)
             && (block->curr_n_fields == info->n_fields)
             && (block->curr_left_side == info->left_side)) {

                 /* The search would presumably have succeeded using
                 the hash index */

                 info->last_hash_succ = TRUE;
         }

         block->n_hash_helps++;
 } else {
         block->n_hash_helps = 1;
         block->n_fields = info->n_fields;
         block->left_side = info->left_side;
 }

        

        
当block第一次被touch到并进入该函数时，设置block上的建议索引列值；以后再进入时，如果和索引上的全局search_info相匹配，则递增
block->n_hash_helps
，启发后续的创建或重构建AHI。

        
如果当前数据页block上已经构建了AHI记录项，且
buf_block_t::curr_n_fields
等字段和
btr_search_info
上对应字段值相同时，则认为当前SQL如果使用AHI索引能够命中，因此将
btr_search_info::last_hash_succ
设置为true，下次再使用相同索引检索btree时就会尝试使用AHI。

      

      

        
在初始化或更新block上的变量后，需要判断是否为整个page构建AHI索引：

        

          
 if ((block->n_hash_helps > page_get_n_recs(block->frame)
      / BTR_SEARCH_PAGE_BUILD_LIMIT)
     && (info->n_hash_potential >= BTR_SEARCH_BUILD_LIMIT)) {

         if ((!block->index)
             || (block->n_hash_helps
                 > 2 * page_get_n_recs(block->frame))
             || (block->n_fields != block->curr_n_fields)
             || (block->left_side != block->curr_left_side)) {

                 /* Build a new hash index on the page */

                 return(TRUE);
         }
 }

        

        
简单来说，当满足下面三个条件时，就会去为整个block上构建AHI记录项：

        

          
分析使用AHI可以成功查询的次数(
buf_block_t::n_hash_helps
)超过block上记录数的16(
BTR_SEARCH_PAGE_BUILD_LIMIT
)分之一；

          

btr_search_info::n_hash_potential
大于等于
BTR_SEARCH_BUILD_LIMIT
 (100)，表示连续100次潜在的成功使用AHI可能性；

          
尚未为当前block构造过索引、或者当前block上已经构建了AHI索引且
block->n_hash_helps
大于page上记录数的两倍、或者当前block上推荐的前缀索引列发生了变化 。

        

      

    

    
为数据页构建AHI索引

    
如果在上一阶段判断认为可以为当前page构建AHI索引（函数
btr_search_update_block_hash_info
返回值为TRUE），则根据当前推荐的索引前缀进行AHI构建。

    
参考函数：
btr_search_build_page_hash_index

    
分为三个阶段：

    

      

        
检查阶段：加btr_search_latch的S锁，判断AHI开关是否打开；如果block上已经构建了老的AHI但前缀索引列和当前推荐的不同，则清空Block对应的AHI记录项（
btr_search_drop_page_hash_index
）；检查n_fields和page上的记录数；然后释放btr_search_latch的S锁；

      

      

        
搜集阶段：根据推荐的索引列数计算记录fold值，将对应的数据页记录内存地址到数组里；

        
根据left_mode值，相同的前缀索引列值会有不同的行为，举个简单的例子，假设page上记录为 (2,1), (2,2), (5, 3), (5, 4), (7, 5), (8, 6)，n_fields＝１

        

          
若left_most为true，则hash存储的记录为(2,1) , (5, 3), (7, 5), (8,6)

          
若left_most为false，则hash存储的记录为(2, 2), (5, 4), (7,5), (8, 6)

        

      

      

        
插入阶段：加btr_search_latch的X锁，将第二阶段搜集的(fold, rec)插入到AHI中，并更新：

        

          
 if (!block->index) {
         index->search_info->ref_count++;
 }

 block->n_hash_helps = 0;

 block->curr_n_fields = n_fields;
 block->curr_left_side = left_side;
 block->index = index;

        

      

    

    
PS：由于第二阶段释放了btr_search
latch锁，这里还得判断block上的AHI信息是否发生了变化，如果block上已经构建了AHI且block->curr
*几个变量和当前尝试构建的检索模式不同，则放弃本次构建。

    
使用AHI

    
AHI的目的是根据用户提供的查询条件加速定位到叶子节点，一般如果有固定的查询pattern，都可以通过AHI受益，尤其是Btree高度比较大的时候。

    
入口函数：
btr_cur_search_to_nth_level

    
相关代码：

    

      
        /* Use of AHI is disabled for intrinsic table as these tables re-use
        the index-id and AHI validation is based on index-id. */
        if (rw_lock_get_writer(&btr_search_latch) == RW_LOCK_NOT_LOCKED
            && latch_mode <= BTR_MODIFY_LEAF
            && info->last_hash_succ
            && !index->disable_ahi
            && !estimate
# ifdef PAGE_CUR_LE_OR_EXTENDS
            && mode != PAGE_CUR_LE_OR_EXTENDS
# endif /* PAGE_CUR_LE_OR_EXTENDS */
            && !dict_index_is_spatial(index)
            /* If !has_search_latch, we do a dirty read of
            btr_search_enabled below, and btr_search_guess_on_hash()
            will have to check it again. */
            && UNIV_LIKELY(btr_search_enabled)
            && !modify_external
            && btr_search_guess_on_hash(index, info, tuple, mode,
                                        latch_mode, cursor,
                                        has_search_latch, mtr)) {

    

    
从代码段可以看出，需要满足如下条件才能够使用AHI：

    

      
没有加btr_search_latch写锁。如果加了写锁，可能操作时间比较耗时，走AHI检索记录就得不偿失了；

      
latch_mode <= BTR_MODIFY_LEAF，表明本次只是一次不变更BTREE结构的DML或查询（包括等值、RANGE等查询）操作；

      

btr_search_info::last_hash_succ
为true表示最近一次使用AHI成功（或可能成功）了；

      
打开AHI开关；

      
查询优化阶段的估值操作，例如计算range范围等，典型的堆栈包括：
handler::multi_range_read_info_const
　–> 
ha_innobase::records_in_range
 –> 
btr_estimate_n_rows_in_range
 –> 
btr_cur_search_to_nth_level
；

      
不是spatial索引；

      
调用者无需分配外部存储页(BTR_MODIFY_EXTERNAL，主要用于辅助写入大的blob数据，参考struct btr_blob_log_check_t)。

    

    
当满足上述条件时，进入函数
btr_search_guess_on_hash
，根据当前的查询tuple对象计算fold，并查询AHI；只有当前检索使用的tuple列的个数大于等于构建AHI的列的个数时，才能够使用AHI索引。

    

btr_search_guess_on_hash
：

    

      
首先用户提供的前缀索引查询条件必须大于等于构建AHI时的前缀索引列数，这里存在一种可能性：索引上的search_info的n_fields 和block上构建AHI时的cur_n_fields值已经不相同了，但是我们并不知道本次查询到底落在哪个block上，这里一致以search_info上的n_fields为准来计算fold，去查询AHI；

      
在检索AHI时需要加&btr_search_latch的S锁；

      
如果本次无法命中AHI，就会将
btr_search_info::last_hash_succ
设置为false，这意味着随后的查询都不会去使用AHI了，只能等待下一路查询信息分析后才可能再次启动（
btr_search_failure
）；

      
对于从ahi中获得的记录指针，还需要根据当前的查询模式检查是否是正确的记录位置（
btr_search_check_guess
）。

    

    
如果本次查询使用了AHI，但查询失败了（
cursor->flag == BTR_CUR_HASH_FAIL
），并且当前block构建AHI索引的curr_n_fields等字段和btr_search_info上的相符合，则根据当前cursor定位到的记录插入AHI。参考函数：
btr_search_update_hash_ref
。

    
从上述分析可见，AHI如其名，完全是自适应的，如果检索模式不固定，很容易就出现无法用上AHI或者AHI失效的情况。

    
维护AHI

    

      

        
关闭选项innodb_adaptive_hash_index；

        

          
持有
dict_sys->mutex
和
btr_search_latch
的X锁；

          
遍历
dict_sys->table_LRU
和
dict_sys->table_non_LRU
链表，将每个表上的所有索引的
index->search_info->ref_count
设置为0；

          
释放
dict_sys->mutex
；

          
遍历buffer pool，将block上的index标记(
buf_block_t::index
)清空为NULL；

          
清空AHI中的哈希项，并释放为记录项分配的Heap；

          
释放btr_search_latch。

        

        
参考函数：
btr_search_disable

      

      

        

index->search_info
的ref_count不为0时，无法从数据集词典cache中将对应的表驱逐，workaround的方式是临时关闭AHI开关；

        
参考函数：
dict_table_can_be_evicted
、
dict_index_remove_from_cache_low

      

      

        
删除索引页上的记录，或者更新的是二级索引、或者更新了主键且影响了排序键值，则需要从AHI上将对应的索引记录删除；

        
参考函数：
btr_search_update_hash_on_delete

      

      

        
插入新的记录时，如果本次插入未产生页面重组、操作的page为叶子节点，且本次插入操作使用过AHI定位成功，则先尝试更新再尝试插入，否则直接插入对应的AHI记录项；

        
参考函数：
btr_search_update_hash_node_on_insert
、
btr_search_update_hash_on_insert

      

      

        
涉及索引树分裂或者节点合并，或从LRU中驱逐page（buf_LRU_free_page）时，需要清空AHI对应的page。

        
参考函数：
btr_search_drop_page_hash_index

      

    

    
shortcut查询模式

    
在
row_search_mvcc
函数中，首先会去判断在满足一定条件时，使用shortcut模式，利用AHI索引来进行检索。

    
只有满足严苛的条件时（例如需要唯一键查询、使用聚集索引、长度不超过八分之一的page size、隔离级别在RC及RC之上、活跃的Read view等等条件，具体的参阅代码），才能使用shortcut：

    

      
加
btr_search_latch
的S锁；

      
然后通过
row_sel_try_search_shortcut_for_mysql
检索记录；如果找到满足条件的记录，本次查询可以不释放 btr_search_latch，这意味着InnoDB/server层交互期间可能持有AHI锁，但最多在10000次（BTR_SEA_TIMEOUT）交互后释放AHI latch。一旦发现有别的线程在等待AHI X 锁，也会主动释放其拥有的S锁。

    

    
然而， Percona的开发Alexey Kopytov认为这种长时间拥有的
btr_search_latch
的方式是没有必要的，这种设计方式出现在很久之前加锁、解锁非常昂贵的时代，然而现在的CPU已经很先进了，完全没有必要，在Percona的版本中，一次shortcut的查询操作后都直接释放掉
btr_search_latch
（参阅
bug#1218347
）。

    
AHI监控项

    
我们可以通过
information_schema.innodb_metrics
来监控AHI模块的运行状态

    
首先打开监控：

    

      
mysql>  set global innodb_monitor_enable = module_adaptive_hash;
Query OK, 0 rows affected (0.00 sec)

mysql> select status, name, subsystem from INNODB_METRICS where subsystem like '%adaptive_hash%';
+---------+------------------------------------------+---------------------+
| status  | name                                     | subsystem           |
+---------+------------------------------------------+---------------------+
| enabled | adaptive_hash_searches                   | adaptive_hash_index |
| enabled | adaptive_hash_searches_btree             | adaptive_hash_index |
| enabled | adaptive_hash_pages_added                | adaptive_hash_index |
| enabled | adaptive_hash_pages_removed              | adaptive_hash_index |
| enabled | adaptive_hash_rows_added                 | adaptive_hash_index |
| enabled | adaptive_hash_rows_removed               | adaptive_hash_index |
| enabled | adaptive_hash_rows_deleted_no_hash_entry | adaptive_hash_index |
| enabled | adaptive_hash_rows_updated               | adaptive_hash_index |
+---------+------------------------------------------+---------------------+
8 rows in set (0.00 sec)

    

    
重置所有的计数

    

      
mysql> set global innodb_monitor_reset_all = 'adaptive_hash%';
Query OK, 0 rows affected (0.00 sec)

    

    
该表搜集了AHI子系统诸如AHI查询次数，更新次数等信息，可以很好的监控其运行状态，在某些负载下，AHI并不适合打开，关闭AHI可以避免额外的维护开销。当然这取决于你针对具体负载的性能测试。

  

  

    

    

    
Test Book

  

  

    
本文分为三节，分别介绍clog的fsync频率，原子操作，与异步提交一致性。

    
PostgreSQL pg_clog fsync 频率分析

    
分析一下pg_clog是在什么时候需要调用fsync的？

    
首先引用wiki里的一段
pg_clog
的介绍

    

      
Some details here are in src/backend/access/transam/README:

1. “pg_clog records the commit status for each transaction that has been assigned an XID.”

2. “Transactions and subtransactions are assigned permanent XIDs only when/if they first do something that requires one — typically, insert/update/delete a tuple, though there are a few other places that need an XID assigned.”

      
pg_clog is updated only at sub or main transaction end. When the transactionid is assigned the page of the clog that contains that transactionid is checked to see if it already exists and if not, it is initialised.

pg_clog is allocated in pages of 8kB apiece(和BLOCKSZ一致，所以不一定是8K，见后面的分析). 

Each transaction needs 2 bits, so on an 8 kB page there is space for 4 transactions/byte * 8k bytes = 32k transactions.

On allocation, pages are zeroed, which is the bit pattern for “transaction in progress”. 

So when a transaction starts, it only needs to ensure that the pg_clog page that contains its status is allocated, but it need not write anything to it. 

In 8.3 and later, this happens not when the transaction starts, but when the Xid is assigned (i.e. when the transaction first calls a read-write command). 

In previous versions it happens when the first snapshot is taken, normally on the first command of any type with very few exceptions.

      
This means that one transaction in every 32K writing transactions does have to do extra work when it assigns itself an XID, namely create and zero out the next page of pg_clog. 

And that doesn’t just slow down the transaction in question, but the next few guys that would like an XID but arrive on the scene while the zeroing-out is still in progress. 

This probably contributes to reported behavior that the transaction execution time is subject to unpredictable spikes.

    

    
每隔32K个事务，要扩展一个CLOG PAGE，每次扩展需要填充0，同时需要调用PG_FSYNC，这个相比FSYNC XLOG应该是比较轻量级的。但是也可能出现不可预知的响应延迟，因为如果堵塞在扩展CLOG PAGE，所有等待clog PAGE的会话都会受到影响。

    
这里指当CLOG buffer没有空的SLOT时，会从所有的CLOG buffer SLOT选择一个脏页，将其刷出，这个时候才会产生pg_fsync。

CLOG pages don’t make their way out to disk until the internal CLOG buffers are filled, at which point the least recently used buffer there is evicted to permanent storage.

    
下面从代码中分析一下pg_clog是如何调用pg_fsync刷脏页的。

    
每次申请新的事务ID时，都需要调用ExtendCLOG，如果通过事务ID计算得到的CLOG PAGE页不存在，则需要扩展；但是并不是每次扩展都需要调用pg_fsync，因为checkpoint会将clog buffer刷到磁盘，除非在申请新的CLOG PAGE时所有的clog buffer都没有刷出脏页，才需要主动选择一个page并调用pg_fsync刷出对应的pg_clog/file。

src/backend/access/transam/varsup.c

    

      
/*
 * Allocate the next XID for a new transaction or subtransaction.
 *
 * The new XID is also stored into MyPgXact before returning.
 *
 * Note: when this is called, we are actually already inside a valid
 * transaction, since XIDs are now not allocated until the transaction
 * does something.  So it is safe to do a database lookup if we want to
 * issue a warning about XID wrap.
 */
TransactionId
GetNewTransactionId(bool isSubXact)
{
......
        /*
         * If we are allocating the first XID of a new page of the commit log,
         * zero out that commit-log page before returning. We must do this while
         * holding XidGenLock, else another xact could acquire and commit a later
         * XID before we zero the page.  Fortunately, a page of the commit log
         * holds 32K or more transactions, so we don't have to do this very often.
         *
         * Extend pg_subtrans too.
         */
        ExtendCLOG(xid);
        ExtendSUBTRANS(xid);
......

    

    

ExtendCLOG(xid)
扩展clog page，调用
TransactionIdToPgIndex
计算XID和CLOG_XACTS_PER_PAGE的余数，如果不为0，则不需要扩展。

src/backend/access/transam/clog.c

    

      
#define TransactionIdToPgIndex(xid) ((xid) % (TransactionId) CLOG_XACTS_PER_PAGE)

/*
 * Make sure that CLOG has room for a newly-allocated XID.
 *
 * NB: this is called while holding XidGenLock.  We want it to be very fast
 * most of the time; even when it's not so fast, no actual I/O need happen
 * unless we're forced to write out a dirty clog or xlog page to make room
 * in shared memory.
 */
void
ExtendCLOG(TransactionId newestXact)
{
        int                     pageno;

        /*
         * No work except at first XID of a page.  But beware: just after
         * wraparound, the first XID of page zero is FirstNormalTransactionId.
         */
        if (TransactionIdToPgIndex(newestXact) != 0 &&    // 余数不为0，说明不需要扩展。
                !TransactionIdEquals(newestXact, FirstNormalTransactionId))
                return;

        pageno = TransactionIdToPage(newestXact);

        LWLockAcquire(CLogControlLock, LW_EXCLUSIVE);

        /* Zero the page and make an XLOG entry about it */
        ZeroCLOGPage(pageno, true);

        LWLockRelease(CLogControlLock);
}

    

    

ZeroCLOGPage(pageno, true)
，调用
SimpleLruZeroPage
，扩展并初始化CLOG PAGE，写XLOG日志。

    

      
/*
 * Initialize (or reinitialize) a page of CLOG to zeroes.
 * If writeXlog is TRUE, also emit an XLOG record saying we did this.
 *
 * The page is not actually written, just set up in shared memory.
 * The slot number of the new page is returned.
 *
 * Control lock must be held at entry, and will be held at exit.
 */
static int
ZeroCLOGPage(int pageno, bool writeXlog)
{
        int                     slotno;

        slotno = SimpleLruZeroPage(ClogCtl, pageno);

        if (writeXlog)
                WriteZeroPageXlogRec(pageno);

        return slotno;
}

    

    

SimpleLruZeroPage(ClogCtl, pageno)
，调用
SlruSelectLRUPage(ctl, pageno)
，从clog shared buffer中选择SLOT。

src/backend/access/transam/slru.c

    

      
/*
 * Initialize (or reinitialize) a page to zeroes.
 *
 * The page is not actually written, just set up in shared memory.
 * The slot number of the new page is returned.
 *
 * Control lock must be held at entry, and will be held at exit.
 */
int
SimpleLruZeroPage(SlruCtl ctl, int pageno)
{
        SlruShared      shared = ctl->shared;
        int                     slotno;

        /* Find a suitable buffer slot for the page */
        slotno = SlruSelectLRUPage(ctl, pageno);
        Assert(shared->page_status[slotno] == SLRU_PAGE_EMPTY ||
                   (shared->page_status[slotno] == SLRU_PAGE_VALID &&
                        !shared->page_dirty[slotno]) ||
                   shared->page_number[slotno] == pageno);

        /* Mark the slot as containing this page */
        shared->page_number[slotno] = pageno;
        shared->page_status[slotno] = SLRU_PAGE_VALID;
        shared->page_dirty[slotno] = true;
        SlruRecentlyUsed(shared, slotno);

        /* Set the buffer to zeroes */
        MemSet(shared->page_buffer[slotno], 0, BLCKSZ);

        /* Set the LSNs for this new page to zero */
        SimpleLruZeroLSNs(ctl, slotno);

        /* Assume this page is now the latest active page */
        shared->latest_page_number = pageno;

        return slotno;
}

    

    

SlruSelectLRUPage(SlruCtl ctl, int pageno)
，从clog buffer选择一个空的SLOT，如果没有空的SLOT，则需要调用
SlruInternalWritePage(ctl, bestvalidslot, NULL)
，写shared buffer page。

    

      
/*
 * Select the slot to re-use when we need a free slot.
 *
 * The target page number is passed because we need to consider the
 * possibility that some other process reads in the target page while
 * we are doing I/O to free a slot.  Hence, check or recheck to see if
 * any slot already holds the target page, and return that slot if so.
 * Thus, the returned slot is *either* a slot already holding the pageno
 * (could be any state except EMPTY), *or* a freeable slot (state EMPTY
 * or CLEAN).
 *
 * Control lock must be held at entry, and will be held at exit.
 */
static int
SlruSelectLRUPage(SlruCtl ctl, int pageno)
{
......
        /* See if page already has a buffer assigned */  先查看clog buffer中是否有空SLOT，有则返回，不需要调pg_fsync
        for (slotno = 0; slotno < shared->num_slots; slotno++)
        {
            if (shared->page_number[slotno] == pageno &&
                shared->page_status[slotno] != SLRU_PAGE_EMPTY)
                return slotno;
        }
...... 
        /*  如果没有找到空SLOT，则需要从clog buffer中选择一个使用最少的PAGE，注意他不会选择最近临近的PAGE，优先选择IO不繁忙的PAGE
         * If we find any EMPTY slot, just select that one. Else choose a
         * victim page to replace.  We normally take the least recently used
         * valid page, but we will never take the slot containing
         * latest_page_number, even if it appears least recently used.  We
         * will select a slot that is already I/O busy only if there is no
         * other choice: a read-busy slot will not be least recently used once
         * the read finishes, and waiting for an I/O on a write-busy slot is
         * inferior to just picking some other slot.  Testing shows the slot
         * we pick instead will often be clean, allowing us to begin a read at
         * once.
         *  
         * Normally the page_lru_count values will all be different and so
         * there will be a well-defined LRU page.  But since we allow
         * concurrent execution of SlruRecentlyUsed() within
         * SimpleLruReadPage_ReadOnly(), it is possible that multiple pages
         * acquire the same lru_count values.  In that case we break ties by
         * choosing the furthest-back page.
         *
         * Notice that this next line forcibly advances cur_lru_count to a
         * value that is certainly beyond any value that will be in the
         * page_lru_count array after the loop finishes.  This ensures that
         * the next execution of SlruRecentlyUsed will mark the page newly
         * used, even if it's for a page that has the current counter value.
         * That gets us back on the path to having good data when there are
         * multiple pages with the same lru_count.
         */
        cur_count = (shared->cur_lru_count)++;
        for (slotno = 0; slotno < shared->num_slots; slotno++)
        {
            int         this_delta;
            int         this_page_number;

            if (shared->page_status[slotno] == SLRU_PAGE_EMPTY)  // 如果在此期间出现了空SLOT，返回这个slotno
                return slotno;
            this_delta = cur_count - shared->page_lru_count[slotno];
            if (this_delta < 0)
            {
                /*
                 * Clean up in case shared updates have caused cur_count
                 * increments to get "lost".  We back off the page counts,
                 * rather than trying to increase cur_count, to avoid any
                 * question of infinite loops or failure in the presence of
                 * wrapped-around counts.
                 */
                shared->page_lru_count[slotno] = cur_count;
                this_delta = 0;
            }
            this_page_number = shared->page_number[slotno];
            if (this_page_number == shared->latest_page_number)
                continue;
            if (shared->page_status[slotno] == SLRU_PAGE_VALID)  // IO不繁忙的脏页
            {
                if (this_delta > best_valid_delta ||
                    (this_delta == best_valid_delta &&
                     ctl->PagePrecedes(this_page_number,
                                       best_valid_page_number)))
                {
                    bestvalidslot = slotno;
                    best_valid_delta = this_delta;
                    best_valid_page_number = this_page_number;
                }
            }
            else
            {
                if (this_delta > best_invalid_delta ||
                    (this_delta == best_invalid_delta &&
                     ctl->PagePrecedes(this_page_number,
                                       best_invalid_page_number)))
                {
                    bestinvalidslot = slotno;  // 当所有页面IO都繁忙时，无奈只能从IO繁忙中选择一个.
                    best_invalid_delta = this_delta;
                    best_invalid_page_number = this_page_number;
                }
            }
        }

        /*  如果选择到的PAGE
         * If all pages (except possibly the latest one) are I/O busy, we'll
         * have to wait for an I/O to complete and then retry.  In that
         * unhappy case, we choose to wait for the I/O on the least recently
         * used slot, on the assumption that it was likely initiated first of
         * all the I/Os in progress and may therefore finish first.
         */
        if (best_valid_delta < 0)  // 说明没有找到SLRU_PAGE_VALID的PAGE，所有PAGE都处于IO繁忙的状态。
        {
            SimpleLruWaitIO(ctl, bestinvalidslot);
            continue;
        }

        /*
         * If the selected page is clean, we're set.
         */
        if (!shared->page_dirty[bestvalidslot])  // 如果这个页面已经不是脏页（例如被CHECKPOINT刷出了），那么直接返回
            return bestvalidslot;

......
仅仅当以上所有的步骤，都没有找到一个EMPTY SLOT时，才需要主动刷脏页（在SlruInternalWritePage调用pg_fsync)。
                /*
                 * Write the page.  注意第三个参数为NULL，即fdata
                 */
                SlruInternalWritePage(ctl, bestvalidslot, NULL);
......

    

    

SlruInternalWritePage(SlruCtl ctl, int slotno, SlruFlush fdata)
，调用
SlruPhysicalWritePage
，执行write。

    

      
/*
 * Write a page from a shared buffer, if necessary.
 * Does nothing if the specified slot is not dirty.
 *
 * NOTE: only one write attempt is made here.  Hence, it is possible that
 * the page is still dirty at exit (if someone else re-dirtied it during
 * the write).  However, we *do* attempt a fresh write even if the page
 * is already being written; this is for checkpoints.
 *
 * Control lock must be held at entry, and will be held at exit.
 */
static void
SlruInternalWritePage(SlruCtl ctl, int slotno, SlruFlush fdata)
{
......
        /* Do the write */
        ok = SlruPhysicalWritePage(ctl, pageno, slotno, fdata);
......

    

    
SLRU PAGE状态

    

      
/*
 * Page status codes.  Note that these do not include the "dirty" bit.
 * page_dirty can be TRUE only in the VALID or WRITE_IN_PROGRESS states;
 * in the latter case it implies that the page has been re-dirtied since
 * the write started.
 */
typedef enum
{
    SLRU_PAGE_EMPTY,            /* buffer is not in use */
    SLRU_PAGE_READ_IN_PROGRESS, /* page is being read in */
    SLRU_PAGE_VALID,            /* page is valid and not being written */
    SLRU_PAGE_WRITE_IN_PROGRESS /* page is being written out */
} SlruPageStatus;

    

    

SlruPhysicalWritePage(ctl, pageno, slotno, fdata)
，这里涉及pg_clog相关的
SlruCtlData
结构，do_fsync=true。

    

      
/*
 * Physical write of a page from a buffer slot
 *
 * On failure, we cannot just ereport(ERROR) since caller has put state in
 * shared memory that must be undone.  So, we return FALSE and save enough
 * info in static variables to let SlruReportIOError make the report.
 *
 * For now, assume it's not worth keeping a file pointer open across
 * independent read/write operations.  We do batch operations during
 * SimpleLruFlush, though.
 *
 * fdata is NULL for a standalone write, pointer to open-file info during
 * SimpleLruFlush.
 */
static bool
SlruPhysicalWritePage(SlruCtl ctl, int pageno, int slotno,
                                          SlruFlush fdata);
......
        int                     fd = -1;
......
//   如果文件不存在，自动创建  
        if (fd < 0)
        {
                /*
                 * If the file doesn't already exist, we should create it.  It is
                 * possible for this to need to happen when writing a page that's not
                 * first in its segment; we assume the OS can cope with that. (Note:
                 * it might seem that it'd be okay to create files only when
                 * SimpleLruZeroPage is called for the first page of a segment.
                 * However, if after a crash and restart the REDO logic elects to
                 * replay the log from a checkpoint before the latest one, then it's
                 * possible that we will get commands to set transaction status of
                 * transactions that have already been truncated from the commit log.
                 * Easiest way to deal with that is to accept references to
                 * nonexistent files here and in SlruPhysicalReadPage.)
                 *
                 * Note: it is possible for more than one backend to be executing this
                 * code simultaneously for different pages of the same file. Hence,
                 * don't use O_EXCL or O_TRUNC or anything like that.
                 */
                SlruFileName(ctl, path, segno);
                fd = OpenTransientFile(path, O_RDWR | O_CREAT | PG_BINARY,
                                                           S_IRUSR | S_IWUSR);
......
        /*
         * If not part of Flush, need to fsync now.  We assume this happens
         * infrequently enough that it's not a performance issue.
         */
        if (!fdata)  // 因为传入的fdata=NULL，并且ctl->do_fsync=true，所以以下pg_fsync被调用。
        {
                if (ctl->do_fsync && pg_fsync(fd))  // 对于pg_clog和multixact，do_fsync=true。
                {
                        slru_errcause = SLRU_FSYNC_FAILED;
                        slru_errno = errno;
                        CloseTransientFile(fd);
                        return false;
                }

                if (CloseTransientFile(fd))
                {
                        slru_errcause = SLRU_CLOSE_FAILED;
                        slru_errno = errno;
                        return false;
                }
        }

    

    

ctl->do_fsync
 && 
pg_fsync(fd)
涉及的代码：

src/include/access/slru.h

    

      
/*
 * SlruCtlData is an unshared structure that points to the active information
 * in shared memory.
 */
typedef struct SlruCtlData
{
        SlruShared      shared;

        /*
         * This flag tells whether to fsync writes (true for pg_clog and multixact
         * stuff, false for pg_subtrans and pg_notify).
         */
        bool            do_fsync;

        /*
         * Decide which of two page numbers is "older" for truncation purposes. We
         * need to use comparison of TransactionIds here in order to do the right
         * thing with wraparound XID arithmetic.
         */
        bool            (*PagePrecedes) (int, int);

        /*
         * Dir is set during SimpleLruInit and does not change thereafter. Since
         * it's always the same, it doesn't need to be in shared memory.
         */
        char            Dir[64];
} SlruCtlData;
typedef SlruCtlData *SlruCtl;

    

    
src/backend/access/transam/slru.c

    

      
......
void
SimpleLruInit(SlruCtl ctl, const char *name, int nslots, int nlsns,
                          LWLock *ctllock, const char *subdir)
......
        ctl->do_fsync = true;           /* default behavior */  // 初始化LRU时，do_fsync默认是true的。
......

    

    
以下是clog初始化LRU的调用，可以看到它没有修改do_fsync，所以是TURE。

src/backend/access/transam/clog.c

    

      
/*
 * Number of shared CLOG buffers.
 *
 * Testing during the PostgreSQL 9.2 development cycle revealed that on a
 * large multi-processor system, it was possible to have more CLOG page
 * requests in flight at one time than the number of CLOG buffers which existed
 * at that time, which was hardcoded to 8\.  Further testing revealed that
 * performance dropped off with more than 32 CLOG buffers, possibly because
 * the linear buffer search algorithm doesn't scale well.
 *
 * Unconditionally increasing the number of CLOG buffers to 32 did not seem
 * like a good idea, because it would increase the minimum amount of shared
 * memory required to start, which could be a problem for people running very
 * small configurations.  The following formula seems to represent a reasonable
 * compromise: people with very low values for shared_buffers will get fewer
 * CLOG buffers as well, and everyone else will get 32.
 *
 * It is likely that some further work will be needed here in future releases;
 * for example, on a 64-core server, the maximum number of CLOG requests that
 * can be simultaneously in flight will be even larger.  But that will
 * apparently require more than just changing the formula, so for now we take
 * the easy way out.
 */
Size
CLOGShmemBuffers(void)
{
        return Min(32, Max(4, NBuffers / 512));
}

void
CLOGShmemInit(void)
{
        ClogCtl->PagePrecedes = CLOGPagePrecedes;
        SimpleLruInit(ClogCtl, "CLOG Ctl", CLOGShmemBuffers(), CLOG_LSNS_PER_PAGE,
                                  CLogControlLock, "pg_clog");
}

    

    
以下是subtrans初始化LRU的调用，看到它修改了do_fsync=false。所以subtrans扩展PAGE时不需要调用pg_fsync。

src/backend/access/transam/subtrans.c

    

      
void
SUBTRANSShmemInit(void)
{
        SubTransCtl->PagePrecedes = SubTransPagePrecedes;
        SimpleLruInit(SubTransCtl, "SUBTRANS Ctl", NUM_SUBTRANS_BUFFERS, 0,
                                  SubtransControlLock, "pg_subtrans");
        /* Override default assumption that writes should be fsync'd */
        SubTransCtl->do_fsync = false;
}

    

    
multixact.c也没有修改do_fsync，所以也是需要fsync的。

MultiXactShmemInit(void)@src/backend/access/transam/multixact.c

    
pg_fsync代码：

src/backend/storage/file/fd.c

    

      
/*
 * pg_fsync --- do fsync with or without writethrough
 */
int
pg_fsync(int fd)
{
        /* #if is to skip the sync_method test if there's no need for it */
#if defined(HAVE_FSYNC_WRITETHROUGH) && !defined(FSYNC_WRITETHROUGH_IS_FSYNC)
        if (sync_method == SYNC_METHOD_FSYNC_WRITETHROUGH)
                return pg_fsync_writethrough(fd);
        else
#endif
                return pg_fsync_no_writethrough(fd);
}

/*
 * pg_fsync_no_writethrough --- same as fsync except does nothing if
 *      enableFsync is off
 */
int
pg_fsync_no_writethrough(int fd)
{
        if (enableFsync)
                return fsync(fd);
        else
                return 0;
}

/*
 * pg_fsync_writethrough
 */
int
pg_fsync_writethrough(int fd)
{
        if (enableFsync)
        {
#ifdef WIN32
                return _commit(fd);
#elif defined(F_FULLFSYNC)
                return (fcntl(fd, F_FULLFSYNC, 0) == -1) ? -1 : 0;
#else
                errno = ENOSYS;
                return -1;
#endif
        }
        else
                return 0;
}

    

    
从上面的代码分析，扩展clog page时，如果在CLOG BUFFER中没有EMPTY SLOT，则需要backend process主动刷CLOG PAGE，所以会有调用pg_fsync的动作。

    
clog page和数据库BLOCKSZ (database block size)一样大，默认是8K（如果编译数据库软件时没有修改的话，默认是8KB），最大可以设置为32KB。每个事务在pg_clog中需要2个比特位来存储事务信息(xmin commit/abort,xmax commit/abort)。所以8K的clog page可以存储32K个事务信息，换句话说，每32K个事务，需要扩展一次clog page。

    
下面的代码是clog的一些常用宏。

src/backend/access/transam/clog.c

    

      
/*
 * Defines for CLOG page sizes.  A page is the same BLCKSZ as is used
 * everywhere else in Postgres.
 *
 * Note: because TransactionIds are 32 bits and wrap around at 0xFFFFFFFF,
 * CLOG page numbering also wraps around at 0xFFFFFFFF/CLOG_XACTS_PER_PAGE,
 * and CLOG segment numbering at
 * 0xFFFFFFFF/CLOG_XACTS_PER_PAGE/SLRU_PAGES_PER_SEGMENT.  We need take no
 * explicit notice of that fact in this module, except when comparing segment
 * and page numbers in TruncateCLOG (see CLOGPagePrecedes).
 */

/* We need two bits per xact, so four xacts fit in a byte */
#define CLOG_BITS_PER_XACT      2
#define CLOG_XACTS_PER_BYTE 4
#define CLOG_XACTS_PER_PAGE (BLCKSZ * CLOG_XACTS_PER_BYTE)
#define CLOG_XACT_BITMASK       ((1 << CLOG_BITS_PER_XACT) - 1)

#define TransactionIdToPage(xid)         ((xid) / (TransactionId) CLOG_XACTS_PER_PAGE)
#define TransactionIdToPgIndex(xid)     ((xid) % (TransactionId) CLOG_XACTS_PER_PAGE)
#define TransactionIdToByte(xid)          (TransactionIdToPgIndex(xid) / CLOG_XACTS_PER_BYTE)
#define TransactionIdToBIndex(xid)       ((xid) % (TransactionId) CLOG_XACTS_PER_BYTE)

    

    
查看数据库的block size：

    

      
postgres@digoal-> pg_controldata |grep block  
Database block size:                  8192  
WAL block size:                       8192  

    

    
我们可以使用stap来跟踪是否调用pg_fsync，如果你要观察backend process主动刷clog 脏页，可以把checkpoint间隔开大，同时把clog shared buffer pages。

你就会观察到backend process主动刷clog 脏页。

    

      
Size
CLOGShmemBuffers(void)
{
    return Min(32, Max(4, NBuffers / 512));
}

    

    
跟踪

    

      
src/backend/access/transam/slru.c
SlruPhysicalWritePage
......
                SlruFileName(ctl, path, segno);
                fd = OpenTransientFile(path, O_RDWR | O_CREAT | PG_BINARY,
                                                           S_IRUSR | S_IWUSR);
......
src/backend/storage/file/fd.c
OpenTransientFile
pg_fsync(fd)

    

    
stap脚本

    

      
[root@digoal ~]# cat trc.stp
global f_start[999999]

probe process("/opt/pgsql/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c").call { 
   f_start[execname(), pid(), tid(), cpu()] = gettimeofday_ms()
   printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), gettimeofday_ms(), pp(), $$parms$$)
   # printf("%s -> time:%d, pp:%s\n", thread_indent(1), f_start[execname(), pid(), tid(), cpu()], pp() )
}

probe process("/opt/pgsql/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c").return {
  t=gettimeofday_ms()
  a=execname()
  b=cpu()
  c=pid()
  d=pp()
  e=tid()
  if (f_start[a,c,e,b]) {
  printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d, $return$$)
  # printf("%s <- time:%d, pp:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d)
  }
}

probe process("/opt/pgsql/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c").call {
   f_start[execname(), pid(), tid(), cpu()] = gettimeofday_ms()
   printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), gettimeofday_ms(), pp(), $$parms$$)
   # printf("%s -> time:%d, pp:%s\n", thread_indent(1), f_start[execname(), pid(), tid(), cpu()], pp() )
}

probe process("/opt/pgsql/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c").return {
  t=gettimeofday_ms()
  a=execname()
  b=cpu()
  c=pid()
  d=pp()
  e=tid()
  if (f_start[a,c,e,b]) {
  printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d, $return$$)
  # printf("%s <- time:%d, pp:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d)
  }
}

probe process("/opt/pgsql/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c").call {
   f_start[execname(), pid(), tid(), cpu()] = gettimeofday_ms()
   printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), gettimeofday_ms(), pp(), $$parms$$)
   # printf("%s -> time:%d, pp:%s\n", thread_indent(1), f_start[execname(), pid(), tid(), cpu()], pp() )
}

probe process("/opt/pgsql/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c").return {
  t=gettimeofday_ms()
  a=execname()
  b=cpu()
  c=pid()
  d=pp()
  e=tid()
  if (f_start[a,c,e,b]) {
  printf("%s <- time:%d, pp:%s, par:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d, $return$$)
  # printf("%s <- time:%d, pp:%s\n", thread_indent(-1), t - f_start[a,c,e,b], d)
  }
}

    

    
开启一个pgbench执行txid_current()函数申请新的事务号。

    

      
postgres@digoal-> cat 7.sql
select txid_current();

    

    
测试，约每秒产生32K左右的请求。

    

      
postgres@digoal-> pgbench -M prepared -n -r -P 1 -f ./7.sql -c 1 -j 1 -T 100000
progress: 240.0 s, 31164.4 tps, lat 0.031 ms stddev 0.183
progress: 241.0 s, 33243.3 tps, lat 0.029 ms stddev 0.127
progress: 242.0 s, 32567.3 tps, lat 0.030 ms stddev 0.179
progress: 243.0 s, 33656.6 tps, lat 0.029 ms stddev 0.038
progress: 244.0 s, 33948.1 tps, lat 0.029 ms stddev 0.021
progress: 245.0 s, 32996.8 tps, lat 0.030 ms stddev 0.046
progress: 246.0 s, 34156.7 tps, lat 0.029 ms stddev 0.015
progress: 247.0 s, 33259.5 tps, lat 0.029 ms stddev 0.074
progress: 248.0 s, 32979.6 tps, lat 0.030 ms stddev 0.043
progress: 249.0 s, 32892.6 tps, lat 0.030 ms stddev 0.039
progress: 250.0 s, 33090.7 tps, lat 0.029 ms stddev 0.020
progress: 251.0 s, 33238.3 tps, lat 0.029 ms stddev 0.017
progress: 252.0 s, 32341.3 tps, lat 0.030 ms stddev 0.045
progress: 253.0 s, 31999.0 tps, lat 0.030 ms stddev 0.167
progress: 254.0 s, 33332.6 tps, lat 0.029 ms stddev 0.056
progress: 255.0 s, 30394.6 tps, lat 0.032 ms stddev 0.027
progress: 256.0 s, 31862.7 tps, lat 0.031 ms stddev 0.023
progress: 257.0 s, 31574.0 tps, lat 0.031 ms stddev 0.112

    

    
跟踪backend process

    

      
postgres@digoal-> ps -ewf|grep postgres
postgres  2921  1883 29 09:37 pts/1    00:00:05 pgbench -M prepared -n -r -P 1 -f ./7.sql -c 1 -j 1 -T 100000
postgres  2924  1841 66 09:37 ?        00:00:13 postgres: postgres postgres [local] SELECT

    

    
从日志中抽取pg_clog相关的跟踪结果。

    

      
[root@digoal ~]# stap -vp 5 -DMAXSKIPPED=9999999 -DSTP_NO_OVERLOAD -DMAXTRYLOCK=100 ./trc.stp -x 2924 >./stap.log 2>&1

     0 postgres(2924): -> time:1441503927731, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").call, par:ctl={.shared=0x7f74a9fe39c0, .do_fsync='\001', .PagePrecedes=0x4b1960, .Dir="pg_clog"} pageno=12350 slotno=10 fdata=ERROR
    31 postgres(2924): -> time:1441503927731, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").call, par:fileName="pg_clog/0181" fileFlags=66 fileMode=384
    53 postgres(2924): <- time:0, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").return, par:14
   102 postgres(2924): -> time:1441503927731, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").call, par:fd=14
  1096 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").return, par:0
  1113 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").return, par:'\001'

1105302 postgres(2924): -> time:1441503928836, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").call, par:ctl={.shared=0x7f74a9fe39c0, .do_fsync='\001', .PagePrecedes=0x4b1960, .Dir="pg_clog"} pageno=12351 slotno=11 fdata=ERROR
1105329 postgres(2924): -> time:1441503928836, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").call, par:fileName="pg_clog/0181" fileFlags=66 fileMode=384
1105348 postgres(2924): <- time:0, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").return, par:14
1105405 postgres(2924): -> time:1441503928836, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").call, par:fd=14
1106440 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").return, par:0
1106452 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").return, par:'\001'

2087891 postgres(2924): -> time:1441503929819, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").call, par:ctl={.shared=0x7f74a9fe39c0, .do_fsync='\001', .PagePrecedes=0x4b1960, .Dir="pg_clog"} pageno=12352 slotno=12 fdata=ERROR
2087917 postgres(2924): -> time:1441503929819, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").call, par:fileName="pg_clog/0182" fileFlags=66 fileMode=384
2087958 postgres(2924): <- time:0, pp:process("/opt/pgsql9.4.4/bin/postgres").function("OpenTransientFile@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:1710").return, par:14
2088013 postgres(2924): -> time:1441503929819, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").call, par:fd=14
2089250 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("pg_fsync@/opt/soft_bak/postgresql-9.4.4/src/backend/storage/file/fd.c:315").return, par:0
2089265 postgres(2924): <- time:1, pp:process("/opt/pgsql9.4.4/bin/postgres").function("SlruPhysicalWritePage@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/slru.c:699").return, par:'\001'

    

    
计算估计，每隔1秒左右会产生一次fsync。

    

      
postgres=# select 1441503928836-1441503927731;
 ?column? 
----------
     1105
(1 row)

postgres=# select 1441503929819-1441503928836;
 ?column? 
----------
      983
(1 row)

    

    
前面pgbench的输出看到每秒产生约32000个事务，刚好等于一个clog页的事务数(本例数据块大小为8KB)。

每个事务需要2个比特位，每个字节存储4个事务信息，8192*4=32768。

    
如果你需要观察backend process不刷clog buffer脏页的情况。可以把checkpoint 间隔改小，或者手动执行checkpoint，同时还需要把clog buffer pages改大，例如：

    

      
Size
CLOGShmemBuffers(void)
{
    return Min(1024, Max(4, NBuffers / 2));
}

    

    
使用同样的stap脚本，你就观察不到backend process主动刷clog dirty page了。

    
通过以上分析，如果你发现backend process频繁的clog，可以采取一些优化手段。

    

      
因为每次扩展pg_clog文件后，文件大小都会发生变化，此时如果backend process调用pg_fdatasync也会写文件系统metadata journal（以EXT4为例，假设mount参数data不等于writeback），这个操作是整个文件系统串行的，容易产生堵塞；

所以backend process挑选clog page时，不选择最近的page number可以起到一定的效果，（最好是不选择最近的clog file中的pages）；

另一种方法是先调用
sync_file_range
, SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER，它不需要写metadata。将文件写入后再调用pg_fsync。减少等待data fsync的时间；

      
pg_clog文件预分配，目前pg_clog单个文件的大小是由CLOGShmemBuffers决定的，为BLOCKSZ的32倍。可以尝试预分配这个文件，而不是每次都扩展，改变它的大小；

      
延迟backend process 的 fsync请求到checkpoint处理。

    

    
[参考]

https://wiki.postgresql.org/wiki/Hint_Bits

http://blog.163.com/digoal@126/blog/static/1638770402015840480734/

src/backend/access/transam/varsup.c

src/backend/access/transam/clog.c

src/backend/access/transam/slru.c

src/include/access/slru.h

src/backend/access/transam/subtrans.c

src/backend/storage/file/fd.c

    
pg_clog的原子操作与pg_subtrans(子事务)

    
如果没有子事务，其实很容易保证pg_clog的原子操作，但是，如果加入了子事务并为子事务分配了XID，并且某些子事务XID和父事务的XID不在同一个CLOG PAGE时，保证事务一致性就涉及CLOG的原子写了。

    
PostgreSQL是通过2PC来实现CLOG的原子写的：

    

      
首先将主事务以外的CLOG PAGE中的子事务设置为sub-committed状态；

      
然后将主事务所在的CLOG PAGE中的子事务设置为sub-committed，同时设置主事务为committed状态，将同页的子事务设置为committed状态；

      
将其他CLOG PAGE中的子事务设置为committed状态；

    

    
src/backend/access/transam/clog.c

    

      
/*
 * TransactionIdSetTreeStatus
 *
 * Record the final state of transaction entries in the commit log for
 * a transaction and its subtransaction tree. Take care to ensure this is
 * efficient, and as atomic as possible.
 *
 * xid is a single xid to set status for. This will typically be
 * the top level transactionid for a top level commit or abort. It can
 * also be a subtransaction when we record transaction aborts.
 *
 * subxids is an array of xids of length nsubxids, representing subtransactions
 * in the tree of xid. In various cases nsubxids may be zero.
 *
 * lsn must be the WAL location of the commit record when recording an async
 * commit.  For a synchronous commit it can be InvalidXLogRecPtr, since the
 * caller guarantees the commit record is already flushed in that case.  It
 * should be InvalidXLogRecPtr for abort cases, too.
 *
 * In the commit case, atomicity is limited by whether all the subxids are in
 * the same CLOG page as xid.  If they all are, then the lock will be grabbed
 * only once, and the status will be set to committed directly.  Otherwise
 * we must
 *       1\. set sub-committed all subxids that are not on the same page as the
 *              main xid
 *       2\. atomically set committed the main xid and the subxids on the same page
 *       3\. go over the first bunch again and set them committed
 * Note that as far as concurrent checkers are concerned, main transaction
 * commit as a whole is still atomic.
 *
 * Example:
 *              TransactionId t commits and has subxids t1, t2, t3, t4
 *              t is on page p1, t1 is also on p1, t2 and t3 are on p2, t4 is on p3
 *              1\. update pages2-3:
 *                                      page2: set t2,t3 as sub-committed
 *                                      page3: set t4 as sub-committed
 *              2\. update page1:
 *                                      set t1 as sub-committed,
 *                                      then set t as committed,
                                        then set t1 as committed
 *              3\. update pages2-3:
 *                                      page2: set t2,t3 as committed
 *                                      page3: set t4 as committed
 *
 * NB: this is a low-level routine and is NOT the preferred entry point
 * for most uses; functions in transam.c are the intended callers.
 *
 * XXX Think about issuing FADVISE_WILLNEED on pages that we will need,
 * but aren't yet in cache, as well as hinting pages not to fall out of
 * cache yet.
 */

    

    
实际调用的入口代码在transam.c，subtrans.c中是一些低级接口。

    
那么什么是subtrans？

当我们使用savepoint时，会产生子事务。子事务和父事务一样，可能消耗XID。一旦为子事务分配了XID，那么就涉及CLOG的原子操作了，因为要保证父事务和所有的子事务的CLOG一致性。

当不消耗XID时，需要通过SubTransactionId来区分子事务。

    

      
src/backend/acp:process("/opt/pgsql9.4.4/bin/postgres").function("SubTransSetParent@/opt/soft_bak/postgresql-9.4.4/src/backend/access/transam/subtrans.c:75").return, par:pageno=? entryno=? slotno=607466858 ptr=0

    

    
重新开一个会话，你会发现，子事务也消耗了XID。因为重新分配的XID已经从607466859开始了。

    

      
postgres@digoal-> psql
psql (9.4.4)
Type "help" for help.
postgres=# select txid_current();
 txid_current 
--------------
    607466859
(1 row)

    

    
[参考]

src/backend/access/transam/clog.c

src/backend/access/transam/subtrans.c

src/backend/access/transam/transam.c

src/backend/access/transam/README

src/include/c.hr

    
CLOG一致性和异步提交

    
异步提交是指不需要等待事务对应的wal buffer fsync到磁盘，即返回，而且写CLOG时也不需要等待XLOG落盘。

而pg_clog和pg_xlog是两部分存储的，那么我们想一想，如果一个已提交事务的pg_clog已经落盘，而XLOG没有落盘，刚好此时数据库CRASH了。数据库恢复时，由于该事务对应的XLOG缺失，数据无法恢复到最终状态，但是PG_CLOG却显示该事务已提交，这就出问题了。

    
所以对于异步事务，CLOG在write前，务必等待该事务对应的XLOG已经FLUSH到磁盘。

    
PostgreSQL如何记录事务和它产生的XLOG的LSN的关系呢？

其实不是一一对应的关系，而是记录了多事务对一个LSN的关系。

src/backend/access/transam/clog.c

LSN组，每32个事务，记录它们对应的最大LSN。

也就是32个事务，只记录最大的LSN。节约空间？

    

      
/* We store the latest async LSN for each group of transactions */
#define CLOG_XACTS_PER_LSN_GROUP        32      /* keep this a power of 2 */

每个CLOG页需要分成多少个LSN组。
#define CLOG_LSNS_PER_PAGE      (CLOG_XACTS_PER_PAGE / CLOG_XACTS_PER_LSN_GROUP)

#define GetLSNIndex(slotno, xid)        ((slotno) * CLOG_LSNS_PER_PAGE + \
        ((xid) % (TransactionId) CLOG_XACTS_PER_PAGE) / CLOG_XACTS_PER_LSN_GROUP)

    

    
LSN被存储在这个数据结构中

src/include/access/slru.h

    

      
/*
 * Shared-memory state
 */
typedef struct SlruSharedData
{
......
    /*
         * Optional array of WAL flush LSNs associated with entries in the SLRU
         * pages.  If not zero/NULL, we must flush WAL before writing pages (true
         * for pg_clog, false for multixact, pg_subtrans, pg_notify).  group_lsn[]
         * has lsn_groups_per_page entries per buffer slot, each containing the
         * highest LSN known for a contiguous group of SLRU entries on that slot's
         * page.  仅仅pg_clog需要记录group_lsn
         */
        XLogRecPtr *group_lsn;  // 一个数组，存储32个事务组成的组中最大的LSN号。
        int                     lsn_groups_per_page;
......

    

    
src/backend/access/transam/clog.c

    

      
 * lsn must be the WAL location of the commit record when recording an async
 * commit.  For a synchronous commit it can be InvalidXLogRecPtr, since the
 * caller guarantees the commit record is already flushed in that case.  It
 * should be InvalidXLogRecPtr for abort cases, too.

void
TransactionIdSetTreeStatus(TransactionId xid, int nsubxids,
                                        TransactionId *subxids, XidStatus status, XLogRecPtr lsn)
{
......

    

    
更新事务状态时，同时更新对应LSN组的LSN为最大LSN值。(CLOG BUFFER中的操作)

    

      
/*
 * Sets the commit status of a single transaction.
 *
 * Must be called with CLogControlLock held
 */
static void
TransactionIdSetStatusBit(TransactionId xid, XidStatus status, XLogRecPtr lsn, int slotno)
{
......
        /*
         * Update the group LSN if the transaction completion LSN is higher.
         *
         * Note: lsn will be invalid when supplied during InRecovery processing,
         * so we don't need to do anything special to avoid LSN updates during
         * recovery. After recovery completes the next clog change will set the
         * LSN correctly.
         */
        if (!XLogR       int                     lsnindex = GetLSNIndex(slotno, xid);

                if (ClogCtl->shared->group_lsn[lsnindex] < lsn)  // 更新组LSN
                        ClogCtl->shared->group_lsn[lsnindex] = lsn;
        }
......

    

    
将事务标记为commit状态，对于异步事务，多一个LSN参数，用于修改事务组的最大LSN。

    

      
/*
 * TransactionIdCommitTree
 *              Marks the given transaction and children as committed
 *
 * "xid" is a toplevel transaction commit, and the xids array contains its
 * committed subtransactions.
 *
 * This commit operation is not guaranteed to be atomic, but if not, subxids
 * are correctly marked subcommit first.
 */
void
TransactionIdCommitTree(TransactionId xid, int nxids, TransactionId *xids)
{
        TransactionIdSetTreeStatus(xid, nxids, xids,
                                                           TRANSACTION_STATUS_COMMITTED,
                                                           InvalidXLogRecPtr);
}

/*
 * TransactionIdAsyncCommitTree
 *              Same as above, but for async commits.  The commit record LSN is needed.
 */
void
TransactionIdAsyncCommitTree(TransactionId xid, int nxids, TransactionId *xids,
                                                         XLogRecPtr lsn)
{
        TransactionIdSetTreeStatus(xid, nxids, xids,
                                                           TRANSACTION_STATUS_COMMITTED, lsn);
}

/*
 * TransactionIdAbortTree
 *              Marks the given transaction and children as aborted.
 *
 * "xid" is a toplevel transaction commit, and the xids array contains its
 * committed subtransactions.
 *
 * We don't need to worry about the non-atomic behavior, since any onlookers
 * will consider all the xacts as not-yet-committed anyway.
 */
void
TransactionIdAbortTree(TransactionId xid, int nxids, TransactionId *xids)
{
        TransactionIdSetTreeStatus(xid, nxids, xids,
                                                           TRANSACTION_STATUS_ABORTED, InvalidXLogRecPtr);
}

    

    
从XID号，获取它对应的LSN，需要注意的是，这个XID如果是一个FROZEN XID，则返回一个(XLogRecPtr) invalid lsn。

src/backend/access/transam/transam.c

    

      
/*
 * TransactionIdGetCommitLSN
 *
 * This function returns an LSN that is late enough to be able
 * to guarantee that if we flush up to the LSN returned then we
 * will have flushed the transaction's commit record to disk.
 *
 * The result is not necessarily the exact LSN of the transaction's
 * commit record!  For example, for long-past transactions (those whose
 * clog pages already migrated to disk), we'll return InvalidXLogRecPtr.
 * Also, because we group transactions on the same clog page to conserve
 * storage, we might return the LSN of a later transaction that falls into
 * the same group.
 */
XLogRecPtr
TransactionIdGetCommitLSN(TransactionId xid)
{
        XLogRecPtr      result;

        /*
         * Currently, all uses of this function are for xids that were just
         * reported to be committed by TransactionLogFetch, so we expect that
         * checking TransactionLogFetch's cache will usually succeed and avoid an
         * extra trip to shared memory.
         */
        if (TransactionIdEquals(xid, cachedFetchXid))
                return cachedCommitLSN;

        /* Special XIDs are always known committed */
        if (!TransactionIdIsNormal(xid))
                return InvalidXLogRecPtr;

        /*
         * Get the transaction status.
         */
        (void) TransactionIdGetStatus(xid, &result);

        return result;
}

/*
 * Interrogate the state of a transaction in the commit log.
 *
 * Aside from the actual commit status, this function returns (into *lsn)
 * an LSN that is late enough to be able to guarantee that if we flush up to
 * that LSN then we will have flushed the transaction's commit record to disk.
 * The result is not necessarily the exact LSN of the transaction's commit
 * record!      For example, for long-past transactions (those whose clog pages  // long-past事务，指非标准事务号。例), we'll return InvalidXLogRecPtr.  Also, because
 * we group transactions on the same clog page to conserve storage, we might
 * return the LSN of a later transaction that falls into the same group.
 *
 * NB: this is a low-level routine and is NOT the preferred entry point
 * for most uses; TransactionLogFetch() in transam.c is the intended caller.
 */
XidStatus
TransactionIdGetStatus(TransactionId xid, XLogRecPtr *lsn)
{
        int                     pageno = TransactionIdToPage(xid);
        int                     byteno = TransactionIdToByte(xid);
        int                     bshift = TransactionIdToBIndex(xid) * CLOG_BITS_PER_XACT;
        int                     slotno;
        int                     lsnindex;
        char       *byteptr;
        XidStatus       status;

        /* lock is acquired by SimpleLruReadPage_ReadOnly */

        slotno = SimpleLruReadPage_ReadOnly(ClogCtl, pageno, xid);
        byteptr = ClogCtl->shared->page_buffer[slotno] + byteno;

        status = (*byteptr >> bshift) & CLOG_XACT_BITMASK;

        lsnindex = GetLSNIndex(slotno, xid);
        *lsn = ClogCtl->shared->group_lsn[lsnindex];

        LWLockRelease(CLogControlLock);

        return status;
}

    

    
前面所涉及的都是CLOG BUFFER中的操作，如果要将buffer写到磁盘，则真正需要涉及到一致性的问题，即在将CLOG write到磁盘前，必须先确保对应的事务产生的XLOG已经flush到磁盘。那么这里就需要用到前面每个LSN组中记录的max LSN了。

代码如下：

src/backend/access/transam/slru.c

    

      
/*
 * Physical write of a page from a buffer slot
 *
 * On failure, we cannot just ereport(ERROR) since caller has put state in
 * shared memory that must be undone.  So, we return FALSE and save enough
 * info in static variables to let SlruReportIOError make the report.
 *
 * For now, assume it's not worth keeping a file pointer open across
 * independent read/write operations.  We do batch operations during
 * SimpleLruFlush, though.
 *
 * fdata is NULL for a standalone write, pointer to open-file info during
 * SimpleLruFlush.
 */
static bool
SlruPhysicalWritePage(SlruCtl ctl, int pageno, int slotno, SlruFlush fdata)
{
        SlruShared      shared = ctl->shared;
        int                     segno = pageno / SLRU_PAGES_PER_SEGMENT;
        int                     rpageno = pageno % SLRU_PAGES_PER_SEGMENT;
        int                     offset = rpageno * BLCKSZ;
        char            path[MAXPGPATH];
        int                     fd = -1;

        /*
         * Honor the write-WAL-before-data rule, if appropriate, so that we do not
         * write out data before associated WAL records.  This is the same action
         * performed during FlushBuffer() in the main buffer manager.
         */
        if (shared->group_lsn != NULL)
        {
                /*
                 * We must determine the largest async-commit LSN for the page. This
                 * is a bit tedious, but since this entire function is a slow path
                 * anyway, it seems better to do this here than to maintain a per-page
                 * LSN variable (which'd need an extra comparison in the
                 * transaction-commit path).
                 */
                XLogRecPtr      max_lsn;
                int                     lsnindex,
                                        lsnoff;

                lsnindex = slotno * shared->lsn_groups_per_page;
                max_lsn = shared->group_lsn[lsnindex++];
                for (lsnoff = 1; lsnoff < shared->lsn_groups_per_page; lsnoff++)
                {
                        XLogRecPtr      this_lsn = shared->group_lsn[lsnindex++];

                        if (max_lsn < this_lsn)
                                max_lsn = this_lsn;
                }

                if (!XLogRecPtrIsInvalid(max_lsn))  // 判断max_lsn是不是一个有效的LSN，如果是有效的LSN，说明需要先调用xlogflush将wal buffer中小于该LSN以及以前的buffer写入磁盘。
                                                    则。
                {
                        /*
                         * As noted above, elog(ERROR) is not acceptable here, so if
                         * XLogFlush were to fail, we must PANIC.  This isn't much of a
                         * restriction because XLogFlush is just about all critical
                         * section anyway, but let's make sure.
                         */
                        START_CRIT_SECTION();
                        XLogFlush(max_lsn);
                        END_CRIT_SECTION();
                }
        }
......

    

    
小结

对于异步事务，如何保证write-WAL-before-data规则？

pg_clog将32个事务分为一组，存储这些事务的最大LSN。存储在SlruSharedData结构中。

在将clog buffer write到磁盘前，需要确保该clog page对应事务的xlog LSN已经flush到磁盘。

    
[参考]

src/backend/access/transam/clog.c

src/include/access/slru.h

src/backend/access/transam/transam.c

src/backend/access/transam/slru.c

  

  

    

    

    
Test Book

  

  

    
随着RDS MySQL用户越来越多，隐藏很久很深的bug也逐渐被挖出来了，下面分享一下最近遇到的三例bug，都是官方版本存在的。

    
trigger/function中drop temporary table导致slave中断

    
只有5.6受到影响。

    
复现步骤

    

      
打开gtid_mode=ON

create function `test_func_1` () returns varchar(30) charset utf8
begin
    drop temporary table if exists test_func_1;
    drop temporary table if exists test_func_2;
    return "hello";
end;

select test_func_1();

    

    
原因分析

    
function/trigger和procedure不同，不能单独执行，必须依赖statement才能存在，这样就决定了 function/trigger 的事务边界必须由statement来定义，所以
create function/trigger
的时候，会进行检测body中是否有事务边界定义。比如，如果有commit/rollback，或者会引起隐式提交的DDL语句，那么就会报以下错误：

    

      
1422 - Explicit or implicit commit is not allowed in stored function or trigger.

    

    
MySQL 5.5为什么会成功？

因为
drop temporary table
是一个比较特殊的语句，虽然是DDL语句，但不会隐式提交，所以进行了特殊处理，可以使用。

    
MySQL 5.6 为什么主库会成功，备库会失败呢？

在打开gtid_mode的情况下，gtid有一个特殊的限制，不能在事务的过程中进行
drop temporary table
。如果要使用，必须为
drop temporary table
独立分配一个GTID。

    
复现方法中的function在主库执行的时候，产生的binlog event如下：

    

      
| master-bin.000001 |  580 | Gtid           |         1 |         628 | SET @@SESSION.GTID_NEXT= 'cfef3544-1327-11e5-8a6f-2c44fd7a5210:2'                                                                                                                                                                                                                                               |
| master-bin.000001 |  628 | Query          |         1 |         779 | DROP TEMPORARY TABLE IF EXISTS `test`.`test_func_1` /* generated by server */                                                                                                                                                                                                                                   |
| master-bin.000001 |  779 | Query          |         1 |         930 | DROP TEMPORARY TABLE IF EXISTS `test`.`test_func_2` /* generated by server */                                                                                                                                                                                                                                   |

    

    
而这样的event在备库slave线程执行的时候，不满足gtid对于
drop temproary table
的要求，所以报错。

    
修复方法

既然gtid_mode=on的时候，
drop temproary table
必须要分配一个gtid，那么也就意味着它虽然不会隐式提交，但还是定义了事务边界。修复方法就是就在
gtid_pre_statement_checks
的时候，对于这样的情况就拒绝执行。

    
drop带有中文表名的语句在备库执行失败

    
5.1、5.5、5.6都受影响。

    
复现步骤

    

      
use test;
set names gbk;
create table test.`t_测试_table`(id int);
drop table test.`t_测试_table`;

    

    
原因分析

首先环境设置:

    

      
set names gbk;
create table test.`t_测试_table`(id int);

    

    
牵涉到的字符集如下:

    

      
session环境:     gbk
query串:          gbk
表名和文件名:     system_charset
query_event:     gdk

drop table test.`t_测试_table`：
session环境:     gbk
query串:     gbk
表名和文件名:     system_charset
query_event:     system_charset

    

    
因为
drop table
的query event是/
 generated by server 
/，在主库生成的时候使用的字符集为system_charset，而在备库执行的时候，需要初始化session环境为主库带过来是gbk，而event本身是system_charset的，导致event和session环境的charset不一致，无法找到表而slave中断。

    
修复方法

对于/
 generated by server 
/的event，不沿用session的字符集，而是使用主库产生event时用的字符集。

    
带有auto_increment字段的表转成archive引擎报错

    
5.1、5.5、5.6都受影响。

    
复现步骤

    

      
create table test.t(id int primary key auto_increment, col1 int) engine=innodb;
insert into test.t values(1, 2);
insert into test.t values(2, 2);
commit;

alter table test.t engine= archive;

ERROR 1022 (23000): Can't write; duplicate key in table '#sql-db11_2bfaa

    

    
原因分析

archive是一个归档引擎，在写入的时候，必须按照递增顺序，也就是不能写入一个比当前pk小的记录，引擎层做了硬编码限制:

    

      
/*
We don't support decremening auto_increment. They make the performance
just cry.
*/
if (temp_auto <= share->archive_write.auto_increment &&
    mkey->flags & HA_NOSAME)
{
  rc= HA_ERR_FOUND_DUPP_KEY;
  goto error;
}

    

    
而alter的过程中，因为没有指定
auto_increment
的值，所以
auto_increment
会从原表中继承过来，也就是等于2，而在copy数据的时候，先插入pk=1的记录，发现比当前
auto_increment
值小，就报了上面的错误。

    
修复方法

    
语句
alter table t engine=archive
，在转换成archive引擎的时候，如果没有指定
auto_increment
的值的时候，系统默认指定成0， 而不是沿用原表的当前
auto_increment
值。

  

  

    

    

    
Test Book

  

  

    
背景

    
修改PG源码时，在elog.c文件中准备调用timestamp.c中的
TimestampTz GetCurrentTimestamp(void)
，以获取当前时间，
TimestampTz
是个int64类型，但是返回值类型不是期望的（是个int32值），但是在另外一个文件postgres.c调用返回的是正常的，如下：

    

      
elog.c: GetCurrentTimestamp() = 3891376011
postgres.c: GetCurrentTimestamp() = 495621643471576

    

    
也就是说，同一个函数在不同文件返回值不同！

    
原因调查

    
首先查看具体函数定义
GetCurrentTimestamp()
，怀疑是elog.c没有宏定义
HAVE_INT64_TIMESTAMP
，随后gdb调试查看，最终计算的结果result确实是int64的值，当这个函数返回之后得到的值却变成了int32的值。

    

      
TimestampTz
GetCurrentTimestamp(void)
{
    TimestampTz result;
    struct timeval tp;

    gettimeofday(&tp, NULL);

    result = (TimestampTz) tp.tv_sec -
        ((POSTGRES_EPOCH_JDATE - UNIX_EPOCH_JDATE) * SECS_PER_DAY);

#ifdef HAVE_INT64_TIMESTAMP
    result = (result * USECS_PER_SEC) + tp.tv_usec;
#else
    result = result + (tp.tv_usec / 1000000.0);
#endif

    return result;
}

    

    
难道elog.c调用的不是timestamp.c中这个函数？继续在源码中查找这个
GetCurrentTimestamp
函数定义，看是否有多个定义。但是查找的结果是除了这个文件有定义，其他文件都没有这个函数定义，并且在timestamp.c这个函数中添加debug信息也都打印出来了，现在可以确定是函数返回的时候将int64转成int32了。百思不得其解之际，最后在编译日志中发现一个warning：

    

      
elog.c:2245: warning: implicit declaration of function ‘GetCurrentTimestamp’

    

    
在网上搜了一下，这种警告是由于函数未声明引起的，但是
GetCurrentTimestamp()
在timestamp.h中声明了，通过对比postgres.c和elog.c include的头文件发现区别：postgres.c包含
#include "utils/timestamp.h"
，也就是在postgres.c 中含有
GetCurrentTimestamp
的函数声明，而在elog.c中却没有。在通过测试发现，C程序如果在函数调用前，没有对函数作声明，则编译系统会把第一次遇到的该函数形式（函数定义或函数调用）作为函数的声明，并将函数类型默认为函数返回值类型！

    
解决方法

    
在elog.c中添加
#include "utils/timestamp.h"
头文件，并查看编译日志看是否有其他这样的warning。重新配置编译选项，加上-Werror-implicit-function-declaration，将这种warning改成error，提前报错。

    
总结

    
对于这个warning需要重视，通过修改编译选项将其变成error，便于我们发现问题，错误发现的越早越好，避免在编译时忽略或者掩盖错误。如果不是这个函数返回值错误特别明显，它将有可能成为一个隐形的bug。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
主库的
create table
语句传到备库，备库SQL线程执行过程中报错：

    

      
Error 'Can't create table 'XXX.XX' (errno: -1)' on query. Default database: 'XXX'. Query: 'CREATE TABLE XX (  column_a char(32) NOT NULL,  column_b int(10) DEFAULT NULL,  column_c int(10) DEFAULT NULL,  PRIMARY KEY (column_a),  KEY expiry (column_b)) ENGINE=HEAP DEFAULT CHARSET=gbk'

    

    
备库 error log：

    

      
InnoDB: Error number 17 means 'File exists'.
InnoDB: Some operating system error numbers are described at
InnoDB: http://dev.mysql.com/doc/refman/5.5/en/operating-system-error-  codes.html
InnoDB: The file already exists though the corresponding table did not
InnoDB: exist in the InnoDB data dictionary. Have you moved InnoDB
InnoDB: .ibd files around without using the SQL commands
InnoDB: DISCARD TABLESPACE and IMPORT TABLESPACE, or did
InnoDB: mysqld crash in the middle of CREATE TABLE?You can
！！！InnoDB: resolve the problem by removing the file '...'
InnoDB: under the 'datadir' of MySQL.

    

    
从error log中可以看出，数据目录中已存在 .ibd 文件，推测是在建表过程中发生 crash。

    
数据目录下存在 .ibd，不存在 .frm，创建.ibd 文件的时间:

    

      
-rw-rw---- 1 mysql mysql    65536 Sep  5 14:41 XXX.ibd

    

    
.ibd 文件创建时间 150905 14:41，对应时间的 error log:

    

      
150905 14:41:58 mysqld_safe Number of processes running now: 0
150905 14:41:58 mysqld_safe mysqld restarted

    

    
之后也出现了和该创建失败的表相关的错误记录：

    

      
150905 14:59:45  InnoDB: Error: table `XXX`.`XX` does not exist in the InnoDB internal

    

    
问题分析

    
执行如下语句，模拟建表

    

      
create table test.t3 (id int);

    

    

create table
 时，由函数
mysql_create_frm
创建 .frm 文件，
mysql_create_frm
 调用栈如下：

    

      
#0  mysql_create_frm
#1  rea_create_table
#2  mysql_create_table_no_lock
#3  mysql_create_table
#4  mysql_execute_command
#5  mysql_parse

    

    
t3.frm 文件生成后，实例 crash（函数
mysql_create_frm
 执行完毕后
kill mysqld
），在数据库中
show tables
可以看到 test.t3，但是无法插入，数据目录下 t3.frm 文件依然存在。

    

drop table
报错

    

      
ERROR 1051 (42S02): Unknown table 'test.t3'

    

    
之后数据目录下的t3.frm不存在，show tables 无法看到t3表，可以重新创建t3表。

    
.ibd 文件由函数
fil_create_new_single_table_tablespace
创建，
fil_create_new_single_table_tablespace
调用栈如下：

    

      
#0  fil_create_new_single_table_tablespace
#1  dict_build_table_def_step
#2  dict_create_table_step
#3  que_thr_step
#4  que_run_threads_low
#5  que_run_threads
#6  row_create_table_for_mysql
#7  create_table_def
#8  ha_innobase::create
#9  handler::ha_create
#10 ha_create_table
#11 rea_create_table
#12 create_table_impl
#13 mysql_create_table_no_lock
#14 mysql_create_table
#15 mysql_execute_command
#16 mysql_parse

    

    
t3.ibd 文件生成后，实例 crash（函数
fil_create_new_single_table_tablespace
执行完毕后
kill mysqld
），在数据库中
show tables
可以看到 test.t3，无法插入数据，在数据目录下存在文件 t3.frm 和 t3.ibd。

    

drop table
依然可以移除 t3.frm 并使
show tables
无法看到 t3 表。但无法移除 t3.ibd，并在重建 t3 表时报错：

    

      
ERROR 1813 (HY000): Tablespace for table '`test`.`t3`' exists. Please DISCARD the tablespace before IMPORT.

    

    
在数据目录中删除 t3.ibd ，可以正常重建 t3 表。

    
这个 bug 的主要原因是 MySQL 的建表过程不是原子操作。如果建表过程正在进行的时候实例 crash，可能会造成一些在实例重启后无法自动恢复的问题。就像这个问题当中的文件残留，无法通过 MySQL 客户端中的操作解决，只能手动删除文件。如果用户是远程连接数据库，又没有登录服务器操作数据文件的权限，就会影响数据库的可用性。

    
MySQL 5.7 的实验室版本正在设计和实现新版本的数据字典来解决这一问题。这个版本主要由以下几个特性：

    

      
数据字典将实现事务存储，首先利用 InnoDB 存储，其他存储引擎可能会跟进开发；

      
把分布式系统中的字典信息统一成一个整体；

      
使用统一的规则存储字典信息，给字典对象定义统一的API；

      
避免文件系统特性带来的问题。

    

    
详细信息参见
MySQL Server Blog

    
问题解决

    
通过问题分析，判断备库无法建表是由于在执行
create table
语句时备库实例crash，且crash时.ibd 文件已存在。用户发现表创建失败，企图重建表依然失败，之后执行了
drop table
语句，移除了.frm文件，但.ibd文件依然存在，无法重建表。

将数据目录下的.ibd文件移到其他文件夹作为备份，在备库
start slave
后建表成功，主备复制正常。

  

  

    

    

    
Test Book

  

  

    
在PG的众多参数中，参数checkpoint相关的几个参数颇为神秘。这些参数与checkpoint的调度有关，对系统的稳定性还是比较重要的，下面我们为大家解析一下，这要先从PG的数据同步机制谈起。

    
PG的数据同步机制

    
众所周知，数据库的后台进程在执行用户事务时，发生的数据更改是先写入缓冲池中，对应PG就是shared buffers。PG的缓冲池一般设置为总内存的1/4左右，缓冲池里面的这些数据更改，在事务提交时，是无需同步写入到磁盘的。因为在事务提交时，会先写入WAL日志，有了WAL日志，就可以在异常情况下将数据恢复，保障数据安全，因此数据本身是否在提交时写入磁盘就没那么重要了。PG是只是在需要的时候，例如脏页较多时、或一定时间间隔后，才将数据写回磁盘。

    
脏页处理的过程分为几个步骤。首先是由background writer将shared buffers里面的被更改过的页面（即脏页），通过调用write写入操作系统page cache。在函数BgBufferSync可以看到，PG的background writer进程，会根据LRU链表，扫描shared buffers（实际上是每次扫描一部分），如果发现脏页，就调用系统调用write。可以通过设置bgwriter_delay参数，来控制background writer每次扫描之间的时间间隔。background writer在对一个页面调用write后，会将该页面对应的文件（实际上是表的segement，每个表可能有多个segment，对应多个物理文件）记录到共享内存的数组
CheckpointerShmem->requests
中，调用顺序如下：

    

      
BackgroundWriterMain -> BgBufferSync -> SyncOneBuffer -> FlushBuffer -> smgrwrite
                                                                           |
                                                                           |
                                                                           V
                       ForwardFsyncRequest <- register_dirty_segment <- mdwrite

    

    
最终checkpointer进程通过读取
CheckpointerShmem->requests
数组，获得这些request，并放入pendingOpsTable。而真正将脏页回写到磁盘的操作，是由checkpointer进程完成的。checkpointer每次也会调用smgrwrite，把所有的shared buffers脏页（即还没有被background writer清理过得脏页）写入操作系统的page cache，并存入pendingOpsTable，这样pendingOpsTable存放了所有write过的脏页，包括之前background writer>已经处理的脏页。随后PG的checkpointer进程会根据pedingOpsTable的记录，进行脏页回写操作（注意每次调用fysnc，都会sync数据表的一个文件，文件中所有脏页都会写入磁盘），调用顺序如下：

    

      
CheckPointGuts->CheckPointBuffers->->mdsync->pg_fsync->fsync

    

    
如果checkpointer做磁盘写入的频率过高，则每次可能只写入很少的数据。我们知道，磁盘对于顺序写入批量数据比随机写的效率要高的多，每次写入很少数据，就造成大量随机写；而如果我们放慢checkpoint的频率，多个随机页面就有可能组成一次顺序批量写入，效率大大提高。另外，checkpoint会进行fsync操作，大量的fsync可能造成系统IO阻塞，降低系统稳定性，因此checkpoint不能过于频繁。但checkpoint的间隔也不能无限制放大。因为如果出现系统宕机，在进行恢复时，需要从上一次checkpoint的时间点开始恢复，如果checkpoint间隔过长，会造成恢复时间缓慢，降低可用性。整个同步机制如下图所示：

    

      

    

    
图1. 数据同步机制

    
checkpoint的调度

    
那么如何调度checkpoint，即控制checkpoint的间隔呢？PG提供了几个参数：
checkpoint_segments
、
checkpoint_completion_target
和
checkpoint_timeout
。

    
决定是否做checkpoint有两个指标维度：

    

      

        
系统的数据修改量。

评估修改量，有两种方法：一种是记录shared buffer里面的脏页有多少，占所有buffer的多大比例；另外一种，记录用户事务的数据修改量是多少。如果用系统的脏页数量或所占比例，来评估修改量，会不太准确，用户有可能反复修改相同的页面，脏页不多，但实际修改量很大，这时候也是应该尽快进行checkpoint，减少恢复时间的。而通过记录WAL日志的产生量，可以很好的评估这个修改量，所以就有了
checkpoint_segments
这个参数，它用于指定产生多少WAL日志后，进行一次checkpoint。例如设置为16时，产生16个WAL日志文件后（如果每个日志文件的大小为16M，即产生16*16M字节的日志），进行一次checkpoint。判断是否触发checkpoint的调用如下：

        

          
 XLogInsert->XLogFlush->XLogWirte->XLogCheckpointNeeded

        

      

      
距离上一次checkpoint的时间。

也就是在上一次checkpoint后，多长时间必须做一次checkpoint。PG提供了
checkpoint_timeout
这个参数，缺省值为300秒，即如果上一次checkpoint后过了300秒没有做checkpoint了，就强制做一次checkpoint。

    

    
那么另外一个参数
checkpoint_completion_target
是做什么的呢？

    
checkpoint_completion_target 参数

    
这个看似不起眼的参数其实对checkpoint调度的影响很大。它是怎么使用的呢？checkpoint会调用BufferSync，将所有shared buffers的页面扫描一遍，如果发现脏页即调用write，写入page cache。每次write完一个脏页后，会调用
IsCheckpointOnSchedule()
这个函数。这个函数的主要逻辑是，判断新产生的日志文件数除以
checkpoint_segments
，结果是否小于
checkpoint_completion_target
。注意，这里的新产生日志文件数，是checkpoint开始后新产生的日志数，不是从上一次checkpoint结束后的新日志数。如果
IsCheckpointOnSchedule()
返回true，则checkpointer进程会进行sleep，sleep一定时间后，再读取下一个shared buffers页面进行write。这样做的效果是，当所有页面write完成时，新产生的日志页面数占
checkpoint_segements
的比例约为
checkpoint_completion_target
的设定值。例如，如果
checkpoint_segements
为16，
checkpoint_completion_target
为0.9，则当上一次checkpoint后，新的第16个日志文件产生后，写日志的那个进程会触发一次checkpoint。checkpoiter进程随即调用
CreateCheckPoint
，做一次checkpoint，checkpointer进程会调用
BufferSync
，扫描shared buffers写脏页。此时每次write一个脏页后，如果新产生的日志文件数小于16*0.9，即15个日志文件时，会进行sleep。最后当write脏页完成时，从上次checkpoint开始新产生的日志文件约为16+15=31个，即

    

      
checkpoint_segments + checkpoint_segments * checkpoint_completion_target

    

    
由此可见，
checkpoint_completion_target
直接控制了checkpoint中的write脏页的速度，使其完成时新产生日志文件数为上述期望值。

    
除了日志文件数，
IsCheckpointOnSchedule()
还会检查从checkpoint开始到现在的时间占
checkpoint_timeout
的比例，是否小于
checkpoint_completion_target
，以决定是否sleep。按
checkpoint_completion_target
为0.9，
checkpoint_timeout
为300秒计算，脏页write的完成时间距离checkpoint开始的时间，大约是270秒。实际上，这个时间上的约束和产生日志文件数的约束是同时起作用的。

    
当脏页全部被write完，就要进行真正的磁盘操作了，即fsync。此时每个文件的fsync之间没有sleep，是尽快完成的。一般做fsync总时间不会超过10秒，因此会赶在时间间隔到达
checkpoint_timeout
或新日志文件数到达
checkpoint_segments
前(都从checkpoint开始时间点开始算起)结束此次checkpoint。

    
总结起来，每次checkpoint所耗时间可以用下面的公式计算：

    

      
min（产生checkpoint_segments*checkpoint_completion_target个日志文件的时间，checkpoint_timeout*checkpoint_completion_target）+ 做fsync的时间

    

    
比如上面的例子，将会是：

    

      
min (产生15个日志文件的时间，270秒）+ fsync的时间

    

    
而这个时间一般小于产生
checkpoint_segments
个日志或
checkpoint_timeout
的时间。这样综合的效果是，每产生
checkpoint_segments
个日志或经历
checkpoint_timeout
的时间做一次checkpoint。在两次checkpoint的开始时间之间，会在
checkpoint_completion_target
比例的时间点完成脏页write，随后很快进行完fsync，如下图所示：

    

      

    

    
图2. checkpoint过程

    
以上便是checkpoint的调度机制。我们要注意调整上述几个参数时，不要让checkpoint产生过于频繁，否则频繁的fsync操作会是系统不稳定。比如，
checkpoint_segments
一般设置为16个以上，
checkpoint_completion_target
设为0.9，
checkpoint_timeout
为300秒，这样一般checkpoint的间隔能达到1分钟以上。

  

  

    

    

    
Test Book

  

  

    
在上一期的月报中，我们分析了 MySQL 5.6 并行复制是如何实现的，介绍了主要数据结构、Coordinator 线程的分发、Worker 线程的执行和checkpoint过程，读者朋友可以
回顾下
，本篇将对恢复逻辑进行介绍。

    
在并行复制之前，SQL线程的恢复很简单，从 relay-log.info 中取得上次执行到的位点，然后从这个位点开始执行即可。有了并行复制之后，情况就变得稍微复杂了些，worker 线程各自执行自己队列的事务，在
stop slave
或者 mysqld crash的时候，队列中的事务很可能没有执行完，比如crash时GAQ的状态如下图1所示，中间存在空隙(gap)，先分发给 worker a 的事务还未完成，而后分发给 worker b 的事务已经完成，对应就是 relay log 中间有一部分event没执行。我们知道，SQL执行或者分发是顺序读relay log的，如果恢复时从 2 开始执行，3 和 4就会重复执行，如果从4开始执行，2就会被跳过，都不行。并行复制恢复的逻辑就是把 2 找出来执行，把空隙给填上，然后SQL线程就可以 5 开始愉快地跑下去了。

    

      

    

    
图1. GAQ中的空隙

    
信息持久化

    
恢复离不开信息的持久化，每个worker线程对应一个worker.info，定期将执行位点信息刷入worker.info。类似于relay-log.info，worker.info 可以存在表中，也可以存在文件中，取决于配置
relay_log_info_repository
，刷写频率由 
sync_relay_log_info
 控制。

    
下面是relay-log.info中存的信息：

    

      
  Number_of_lines: 后面有多少行(文件)或字段(表)
   Relay_log_name: 执行到的relay log 的文件名
    Relay_log_pos: 执行到的relay log 的位置
  Master_log_name: 执行到的对应在主库 binlog 的文件名
   Master_log_pos: 执行到的对应在主库 binlog 的位置
        Sql_delay: SQL线程必须落后master的时间，通过 CHANGE MASTER TO MASTER_DELAY=X 指定
Number_of_workers: worker线程个数
               Id: 内部用的

    

    
下面是worker.info中存的信息：

    

      
                        Id: worker 的 id
            Relay_log_name: 执行到的relay log 的文件名
             Relay_log_pos: 执行到的relay log 的位置
           Master_log_name: 执行到的对应在主库 binlog 的文件名
            Master_log_pos: 执行到的对应在主库 binlog 的位置
 Checkpoint_relay_log_name: 上次 checkpoint 后，分发到的第一个 group 所在的 relay log 文件名
  Checkpoint_relay_log_pos: 同上，对应 relay log 中的位置
Checkpoint_master_log_name: 同上，对应在主库 binlog 的文件名
 Checkpoint_master_log_pos: 同上，对应在主库 binlog 中的位置
          Checkpoint_seqno: 当前执行到事务序列，从上次checkpoint后开始算
     Checkpoint_group_size: checkpoint_group_bitmap 的长度，多少个BYTE
   Checkpoint_group_bitmap: 从上次 checkpoitn 执行事务的标记

    

    
每个字段对应Slave_worer类的一个成员（Checkpoint_group_size除外），这其中比较重要的就是 Checkpoint_group_bitmap，记录哪些事务是执行过的，下面会介绍对bitmap的操作。

    
bitmap 记录执行事务

    
本节介绍对 
Slave_worker::group_executed
 这个bitmap的操作，在此之前需要介绍另一个变量 
Relay_log_info::checkpoint_seqno
，对 Coordinator 线程来说，表示从上次checkpoint调整后，下一个分发的事务编号，同时对应GAQ中事务(Slave_job_group)的个数，我们在上期介绍过，GAQ中存的是Coordinator 线程分发的、尚未被checkpoint出队的事务（可能已经被worker执行完了）；对woker线程来说，这个对应当前worker执行到的事务编号。

    
Coordinator 线程每分发一个事务，checkpoint_seqno 加 1；每次checkpoint后，会将 checkpoint_seqno 减去cnt（cnt为checkpoint时GAQ中出队的事务的个数）。worker 线程每执行完一个事务，会将 group_executed 的 checkpoint_seqno 位置1；如果遇到checkpoint，会将bitmap向左移位。

    
如下图所示，GAQ中第0、2、5个事务分发给了worker a，第0个已经执行完成，所以 worker a 的 bitmap 中，第0位置1；worker b 和 worker c 的 bitmap 同理，标识已经执行的事务。

    

      

    

    
图2. worker的bitmap

    
假设这个时候 Coordinator 线程做了一次 checkpoint，将队列头部2个已经完成的事务出队，然后将
rli->checkpoint_seqno
减2，同时将2累加到每个 
worker->bitmap_shifted
 中，当Coordinator 线程将新的事务分给worker的时候，会将 
worker->bitmap_shifted
 取出，存人当前
Slave_job_group.shifted
 中，当worker执行到这个group，就开始对 group_executed 进行偏移，偏移量就是
Slave_job_group.shitfed
 （再一次说明了GAQ中的Slave_job_group，充当了Coordinator 线程和worker线程通信的角色）。bitmap的变化就如下图所示，checkpoint后，原来的0和1出队，然后新的4、5、6加入进来，新分发给worker b 和 worker c 的 4 和 6 已经执行完成，所以bitamp和上图相比，已经向左路偏移了2位，而新分发worker a的5并示执行，所以worker a 的bitmap还未偏移。

    

      

    

    
图3. checkpoint后worker的bitmap

    
group_executed bitmap的长度和GAQ大小一样，由配置
slave_checkpoint_group
决定。

    
恢复逻辑

    
恢复的主要逻辑是
mts_recovery_groups()
 这个函数。

    
在启动slave的时候，如果relay-log.info中存的Number_of_workers不为0，就说明之前是并行复制，然后调用 
mts_recovery_groups()
，进入恢复逻辑。如前所述，
mts_recovery_groups()
 的目的就是根据 slave_worker_info 和 slave_info 中信息，把空隙事务找出来。

    
首先会创建 Number_of_workers 个 worker，依次把每个worker.info的信息读出来，然后把worker执行位点信息和relay-log.info中记录的位点信息（低水位）相比，如果比后者小，说明崩溃前已经被checkpoint出队，不可能造成空隙，直接跳过；如果比后者大，就把worker存入 
above_lwm_jobs
 数组。

above_lwm_jobs
收集完成后，初始化bitmap 
rli->recovery_groups
，用来汇总每个worker的bitmap。对 
above_lwm_jobs
 中的每个worker，设置一个计数器
recovery_group_cnt
，从低水位位点开始扫relay log，每扫完一个事务，
recovery_group_cnt
加1，直到扫到worker.info中记录的位点为止，之后把worker的bitmap汇总到
rli->recovery_groups
中，其间会统计一个最大的 
recovery_group_cnt
，记入
rli->mts_recovery_group_cnt
，这个对应高水位。 bitmap 汇总逻辑如下：

    

      
sql/rpl_slave.cc:8965
for (uint i= (w->checkpoint_seqno + 1) - recovery_group_cnt,
     j= 0; i <= w->checkpoint_seqno; i++, j++)
{
  if (bitmap_is_set(&w->group_executed, i))
  {
    DBUG_PRINT("mts", ("Setting bit %u.", j));
    bitmap_fast_test_and_set(groups, j);
  }
}

    

    
之后SQL线程就可以从低水位往高水位扫relay log，对于每个事务，如果 
rli->recovery_groups
 对应bit为1，说明崩溃前已经执行过，就跳过；反之，就对事务中的每个event调用 
do_apply_event()
执行。扫描到高水位后整个恢复逻辑结束，后面SQL线程就进入正常的执行逻辑，执行（串行）或者分发（并行）event。

  

  

    

    

    
Test Book

  

  

    
业务背景

    
MySQL 主备通过 binlog 实现数据同步的功能，主库将生成的 binlog 通过 binlog send 线程发送到备库，备库通过应用这些 binlog 来更新数据，实现主备数据一致，其应用 binlog 的读取操作与更新操作的堆栈分别如下。

    
读取操作：

    

      
#0  row_search_for_mysql
#1  0x0000000000c200c2 in ha_innobase::index_read
#2  0x0000000000c21c57 in ha_innobase::rnd_pos
#3  0x000000000090c5d3 in handler::rnd_pos_by_record
#4  0x0000000000a574c3 in Rows_log_event::find_row
#5  0x0000000000a589da in Delete_rows_log_event::do_exec_row
#6  0x0000000000a50dcc in Rows_log_event::do_apply_event
#7  0x00000000005d0bb8 in Log_event::apply_event
#8  0x00000000005b9782 in apply_event_and_update_pos
...

    

    
更新操作：

    

      
#0  row_update_for_mysql
#1  0x0000000000c1f466 in ha_innobase::delete_row
#2  0x000000000090b64a in handler::ha_delete_row
#3  0x0000000000a58a4b in Delete_rows_log_event::do_exec_row
#4  0x0000000000a50dcc in Rows_log_event::do_apply_event
#5  0x00000000005d0bb8 in Log_event::apply_event
#6  0x00000000005b9782 in apply_event_and_update_pos
...

    

    

      
由堆栈可以看出，sql 线程首先将数据从磁盘加载到内存，然后调用引擎层的接口执行相应的操作，当iops 及 buffer pool 较小时，读磁盘需要较多的时间，容易造成主备延迟问题；

      
当系统重启后，需要对系统进行预热，提高 buffer pool 的命中率，因此需要提供有效的方法来对系统进行预热；

    

    
综上，我们需要一种可以在 DML 操作之前将数据从磁盘加载到内存的功能，以实现数据库的快速操作。

    
解决方法

    
我们需要找到一种将数据加载到内存的方法，但又不对数据进行修改，需要满足以下的条件：

    

      
在库上更新的数据应该在备库操作之前被加载到内存中；

      
对于重启的mysqld实例，应该将启动之前所用的数据页加载到内存中；

      
加载操作对数据本身不进行修改，类似于select 语句。

    

    
因此，我们可以在mysqld启动时启动额外的线程对 relay log 进行特殊处理，以达到数据加载的目的。

    
设计思路 & 使用方法

    
RDS MySQL 利用 relay log 来解决上述两个问题，当系统启动后，可以在后台开启一个独立于SQL thread之外的线程将 relay log 相关的数据从磁盘加载到内存中，从而使备库在查找数据的时候直接利用buffer pool，而不需要从磁盘中进行加载，同理，使用这种方法也可以解决系统预热的问题。

    
当启动后，如果发现延迟且 buffer pool 命中率较低时，可以启用 relay fetch thread, 具体语法为：

    

      
启动 relay_fetch_thread: start slave relay_fetch_thread;
停止 relay_fetch_thread: stop slave relay_fetch_thread;

    

    
relay fetch thread 读取relay log, 并将要执行的数据从磁盘上加载到内存中，所以只能对包含数据部分的 log_event 进行操作，对 Query_log_event，Write_rows_log_event 是无法进行预读的，前者是因为Query_log_event 只是SQL语句，不包含具体的数据信息；后者则是event中没有的数据，所以不需要进行加载，另外为了防止 buffer pool 中读取的 page 被 evict 出去，我们需要对两种情况进行分别处理：

    

      
relay fetch thread 不能领先 sql thread 过多，如果领先过多的 relay log files，当 buffer pool 较小时，新加载进来的数据页会将老的数据页从内存中 evict 出去，对 sql thread 的命中率会有直接的影响；

      
当 sql thread 领先 relay fetch thread 时，此时 relay fetch thread 不需要将已执行完的 relay log 加载到内存，继续加载不仅会有命中率的问题，同时会造成 CPU 不必要的资源浪费。

    

    
因此，relay fetch thread 与 sql thread 应该相差的距离不太远，我们的策略是 relay fetch thread 与 sql thread 应该在同一个 relay log 上，具体策略如下：

    

      
如果 relay fetch thread 领先, 则当 relay fetch thread 读完一个文件后要等待 sql thread，直到 sql thread 应用完此relay log 再继续加载；

      
如果 sql thread 领先，则会通知 relay fetch thread 跳过当前执行的文件并用 sql thread 的位点来初始化自己将要执行的起点；

    

    
relay fetch thread 执行过程的伪码如下：

    

      
handle_slave_relay_fetch
{
   init_thd_and_rli();
   while (!relay_fetch_killed(eli))
   {
       ev= Log_event::read_log_event(&rli->relay_log_buf, 0, rli->relay_log.description_event_for_relay_fetch);
       if (ev == NULL) 
       { 
          deal with situations like hot_log, relay log purged, eof of relay log etc.
       }
       else
       {
             switch(ev->get_type_code())
             {
                case QUERY_EVENT:
                   deal with begin, commit 
                   break;

                case XID_EVENT:
                   deal with xid(commit)
                   break;

               case TABLE_MAP_EVENT:
                   init table info for rows log event
                   break;

               case UPDATE_ROWS_EVENT:
               case DELETE_ROWS_EVENT:
                  find_row();
                  break;

               case FORMAT_DESCRIPTION_EVENT:
                  init description_event_for_relay_fetch for reading binlog event;
               default:
                  break;
             }
             delete ev;
       }
   }
}

    

    
实现过程中注意的细节

    

      
由于 relay fetch thread 在加载数据的过程中会对记录进行加锁，所以在遇到begin, commit 的事件时，需要释放在读取过程中获取的所有锁资源，否则有可能会引起 sql 线程锁超时错误；

      
由于 relay fetch thread 的位点是使用 sql thread 的位点进行初始化的，所以需要处理 relay log 不是完整事务的情况；

      
释放 relay fetch thread 在执行过程中使用到的内存，否则会有内存问题；

      
在 relay fetch thread 执行的过程中需要特别注意 log_lock、run_lock 等锁问题，以避免备库的死锁；

      
需要对 relay log 的purge进行特殊处理；

      
如果是系统预热的功能，则需要对 relay fetch thread 与 sql thread 的领先策略进行调整。

    

  

  

    

    

    
Test Book

  

  

    
并行复制相关线程

    
在MySQL 5.6并行复制中，当设置
set global slave_parallel_workers=2
时，共有4个复制相关的线程，如下：

    

      
+----+-------------+------+-------+---------+------+------------------------------------------------------------------+------+
| ID | USER        | HOST | DB    | COMMAND | TIME | STATE                                                            | INFO |
+----+-------------+------+-------+---------+------+------------------------------------------------------------------+------+
| 23 | system user |      | NULL  | Connect |    3 | Waiting for master to send event                                 | NULL |
| 24 | system user |      | mysql | Connect |    3 | Slave has read all relay log; waiting for the slave I/O thread t | NULL |
| 25 | system user |      | NULL  | Connect |    3 | Waiting for an event from Coordinator                            | NULL |
| 26 | system user |      | NULL  | Connect |    3 | Waiting for an event from Coordinator                            | NULL |
+----+-------------+------+-------+---------+------+------------------------------------------------------------------+------+

    

    
其中第一个为IO线程，负责从主库拉取binlog到备库并存为relay log;

第二个为分发线程，负责解析relay log，并将解析后的事件分发给worker线程处理；

其余两个为worker线程负责处理分发后的事件，类型非并行复制时的sql线程。

    
并行复制并发策略

    
目前RDS MySQL并行复制是以表级别进行分发的，即同一时刻，同一个表相关的操作只能在同一个worker线程中进行。

    
考虑两个事务，分别对表进行insert

    

      
trx1:
begin;
insert into t1 values(1);
comit;

trx2:
begin;
insert into t2 values(1);
comit;

    

    
那么这两个事务可能分别在两个worker中并行执行。

    
有些特殊情会影响worker的并发执行:

    

      
并行退化为串行的情况

DDL语句串行处理(RDS MySQL正在优化DDL并行处理)

binlog切换事件需串行处理

有外键关系的表需串行处理

      
并行等待的情况

    

    
当一个事务中包含多个表时，如下:

    

      
trx3:
begin;
insert into t1 values(3);
insert into t2 values(3);
comit;

    

    
如果当前worker1正在执行t1相关的事务，worker2正在执行t2相关的事务，那么分发线程在分发trx3的t2的事件时必须等待worker2的t2相关的事务执行完成。

    
并行复制worker分配

    
假设，worker线程正在执行的情况如下:

    

      
worker 1: trx1: insert t1
worker 2: trx2: insert t2;  trx3: insert t3;

    

    
然后分发线程再来一个事务trx4:

    

      
trx4: insert t4;

    

    
分发线程该分配给哪个worker呢？

    
分配线程分配会分配给最空闲的worker(
get_least_occupied_worker
);

    
这里最空闲是指worker当前正在执行的事务涉及的表数越少越空闲。

    
worker1正在执行的事务涉及的表数为1，而worker2正在执行的事务涉及的表数为2，因此trx4会分配为worker1;

    
表和worker存在一一对应关系，为了快速找到表对应的worker，哈希表（
mapping_db_to_worker
）存储了这种映射关系。同时为了控制哈希表过大导致占用较多内存或哈希冲突，系统严格控制了哈希表的大小，不能超过16（硬编码
mts_partition_hash_soft_max
），当超过16时，会将当前没有执行的表从哈希表驱逐出去。

    
在表较多情况下，哈希表大小设为16显得过小，可能会频繁驱逐表，频繁新建哈希键值对的情况。

    
优化

    

      
表级并行复制下，哈希表的大小16（硬编码
mts_partition_hash_soft_max
）过小，应设为动态可调；

      
分配线程分配会分配给最空闲的
worker(get_least_occupied_worker)
。

    

    
考虑如下情况：

    

      
worker 1: t1 1000个事务
worker 2: t2 10个事务  t3 10 个事务

    

    
当前worker1比worker2要繁忙，而按照当前正在执行的事务涉及的表数越少越空闲的原则，新来的事务(比如insert t4)会分配给worker1，这是不合理的。

因此，空闲的标准应改为当前正在执行的事务数越少越空闲，这样新来的事务会分配给worker2。

  

  

    

    

    
Test Book

  

  

    
TokuDB的数据库文件组织方式比较随意，给我们一种“乱”的假象，今天就来漫谈下TokuDB数据库文件。

    
一个“新生”的TokuDB数据库，基础文件是这样的：

    

      
tokudb.directory --表/索引文件信息
tokudb.environment --TokuDB版本号信息
tokudb.rollback --undo记录
log000000000001.tokulog27 --redo记录
__tokudb_lock_dont_delete_me_* --文件锁，保证同一个datadir只能被一个TokuDB进程使用

    

    
在test数据库下面新建个表t1，并写几条数据：

    

      
CREATE TABLE `t1` (
`a` int(11) NOT NULL,
`b` int(11) DEFAULT NULL,
`c` int(11) DEFAULT NULL,
PRIMARY KEY (`a`),
KEY `bc` (`b`,`c`)
) ENGINE=TokuDB

    

    
就会发现目录下多出3个文件，表t1：

    

      
file1: _test_t1_key_bc_90_3_1b.tokudb --索引(bc)文件
file2: _test_t1_main_90_2_1b.tokudb --主文件
file3: _test_t1_status_90_1_1b.tokudb --表元数据文件

    

    
可以发现每个表最少2个文件，命名规则为：

    

      
_database_table_main*.tokudb
_database_table_status*.tokudb

    

    
索引是一个单独的.tokudb文件。

    
好了，下面是问题时间。

    
问题1: TokuDB如何知道哪些文件属于表t1

    
现在来dump下tokudb.directory：

    

      
{key={len=17 data="./test/t1-key-bc\000"} xid=0000000000000003 val={len=33 data="./_test_t1_key_bc_90_3_1b.tokudb\000"}}
{key={len=15 data="./test/t1-main\000"} xid=0000000000000002 val={len=31 data="./_test_t1_main_90_2_1b.tokudb\000"}}
{key={len=17 data="./test/t1-status\000"} xid=0000000000000001 val={len=33 data="./_test_t1_status_90_1_1b.tokudb\000"}}

    

    
TokuDB在启动的时候，会读取tokudb.directory，根据key信息组织出表t1的相关文件，并写到information_schema.tokudb_file_map表。

    
问题2: TokuDB如何知道表t1有哪些索引以及列信息

    
这些信息全部存在_test_t1_status_90_1_1b.tokudb文件里。

    
问题3: TokuDB的分区表文件是怎样的

    
实验走起来，首先创建一个按时间的分区表t2：

    

      
CREATE TABLE `t2` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `c1` int(11) DEFAULT NULL,
  `date` datetime NOT NULL,
  KEY `id` (`id`),
  KEY `c1` (`c1`)
) ENGINE=TokuDB DEFAULT CHARSET=latin1
/*!50100 PARTITION BY RANGE ( TO_DAYS(date))
(PARTITION p201508 VALUES LESS THAN (736176) ENGINE = TokuDB,
 PARTITION p201509 VALUES LESS THAN (736207) ENGINE = TokuDB,
 PARTITION rxMORES VALUES LESS THAN MAXVALUE ENGINE = TokuDB) */

    

    
现在分区表的文件是什么样的呢？

    

      
data/_test_t2_P_p201508_key_c1_ba_4_1b.tokudb
data/_test_t2_P_p201508_key_id_ba_3_1b.tokudb
data/_test_t2_P_p201508_main_ba_2_1b.tokudb
data/_test_t2_P_p201508_status_ba_1_1b.tokudb
data/_test_t2_P_p201509_key_c1_bb_4_1b.tokudb
data/_test_t2_P_p201509_key_id_bb_3_1b.tokudb
data/_test_t2_P_p201509_main_bb_2_1b.tokudb
data/_test_t2_P_p201509_status_bb_1_1b.tokudb
data/_test_t2_P_rxMORES_key_c1_bc_4_1b.tokudb
data/_test_t2_P_rxMORES_key_id_bc_3_1b.tokudb
data/_test_t2_P_rxMORES_main_bc_2_1b.tokudb
data/_test_t2_P_rxMORES_status_bc_1_1b.tokudb

    

    
可以看到每个分区表有4个文件：1个main文件，1个status文件，还有2个key索引文件。

对于分区表来说，总的文件数目基本是：分区数目 * (1 + 1 + 索引数目)。

    
所以如果您的分区非常多，open-files-limit 配置可要小心了，要尽可能的大点，否则可能会出现”Too many open files”，从而导致实例crash！

    
希望本文能帮助您了解到TokuDB的文件组织结构，祝玩得开心！

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 社区动态 · InnoDB Page Compression

        

      

      

        

          
PgSQL · 答疑解惑 · RDS中的PostgreSQL备库延迟原因分析

        

      

      

        

          
MySQL · 社区动态 · MySQL5.6.26 Release Note解读

        

      

      

        

          
PgSQL · 捉虫动态 · 执行大SQL语句提示无效的内存申请大小

        

      

      

        

          
MySQL · 社区动态 · MariaDB InnoDB表空间碎片整理

        

      

      

        

          
PgSQL · 答疑解惑 · 归档进程cp命令的core文件追查

        

      

      

        

          
MySQL · 答疑解惑 · open file limits

        

      

      

        

          
MySQL · TokuDB · 疯狂的 filenum++

        

      

      

        

          
MySQL · 功能分析 · 5.6 并行复制实现分析

        

      

      

        

          
MySQL · 功能分析 · MySQL表定义缓存

        

      

    

  

  

    

    

    
Test Book

  

  

    
背景：Punch hole和Sparse file

    
Punch hole是一个需要操作系统和文件系统支持的特性，顾名思义就是在文件中打洞。这个特性的目的是为了减少数据文件的磁盘开销。比如一个大文件中有一部分数据我们是不需要的，就可以通过punch hole特性将其删除，相当于在文件中打了个洞，这个洞是不占用磁盘的。

    
Punch hole特性通过fallocate调用来实现，在其第二个参数指定flag FALLOC_FL_PUNCH_HOLE时，第三个参数指定需要punch hole的偏移位置，第四个参数指定punch hole的长度。当成功打洞后，以后访问到这个范围的数据都返回0。

    
fallocate的描述见
文档
。根据文档的描述，
FALLOC_FL_PUNCH_HOLE
 需要和另外一个flag 
FALLOC_FL_KEEP_SIZE
一起使用，也就是说，即使在文件中打洞，通过stat获得的文件大小也不会发生变化，你需要通过du命令来获得准确的磁盘文件大小。

    
目前不是所有的内核都支持该特性，在阿里环境需要使用rh6 2.6.32-358及之后的版本，另外由于对应的flag 宏没有定义，我们需要显式的定义如下两个宏：(感谢 @伯瑜 大神的指点)

    

      
#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
#define FALLOC_FL_KEEP_SIZE     0x01 /* default is extend size */

    

    
通常情况下，偏移量和长度要求是文件系统的block size大小，否则fallocate调用可能失败并返回EINVAL。

    
除了上面这两个flag外，还有另外一个比较有意思的flag：
FALLOC_FL_COLLAPSE_RANGE
，名字和其功能比较形象，相当于在挖洞后，这个洞并没有留下，而是把后面的数据往前面移，因此被打洞的部分，在被随后访问到时，读取到的数据就不是0，而是后面的数据。

    
关于这个flag可以参考
这篇文章
了解其背景。

    
文件的管理使用sparse file（稀疏文件），一般支持punch hole特性的，都会支持sparse file，对于sparse file，可以参阅这篇
博客
，讲的非常详细。简单的重整了下博客中的配图，如下所示：

    

    
然而需要注意一种情况，由于文件中的空洞不占磁盘空间，当磁盘接近满时，如果向空洞写入数据，就可能触发写入失败的问题，导致不可预料的问题，因此空余的磁盘空间阀值需要多预留点。

    
InnoDB 新压缩实现

    
MySQL 5.7.8版本实现了一种新的压缩方式(
WL#7696
)，也就是所谓的Innodb Transaparent PageIO Compression，其原理很简单，就是利用punch hole + 数据压缩来实现的。其在内存中表现的是一个正常的page，只在读写到磁盘时，才进行文件压缩、解压处理。处理逻辑如下图所示：

    

    
首先，InnoDB增加了新的Page类型，这意味着如果使用该特性，则不能原地降级到老版本，需要对格式进行转换才能降级。

    
目前上游支持两种压缩算法：zllib及lz4，但我们也可以很方便的进行扩展新的算法。

    
被压缩的数据包含除FIL_PAGE_DATA之外的所有数据（包括tailer），但需要以block size对齐（线上环境的block size通常为4KB），这意味着即使我们把数据从16KB压缩到9KB，也需要存储12KB的数据。因此block size设小点，这样的场景将受益，可以减少空间浪费。

    
表定义

    
首先需要操作系统支持该特性，在阿里的环境里，需要装上新版内核（如上述）让系统支持punch hole。

    
可以通过CREATE TABLE 或ALTER TABLE 来定义压缩表：

    

      
mysql> create table sb1 (a int, b blob) compression='zlib';
Query OK, 0 rows affected (0.05 sec)

    

    
也可以选择compression=’lz4’来指定lz4压缩算法；注意对compression属性的ALTER是立刻生效的，因此在做完ALTER COMPRESSION属性操作后，需要做一次表的rebuild，例如optimize table操作，才能对已有的数据做punch hole。

    
compression属性存储在frm文件中，以两个字节存储字符串长度，随后存储compression属性定义字符串，这也是一个操作系统降级的风险点。

    
具体的使用参阅
官方文档
。

    
相关代码逻辑

    
压缩数据

    
压缩数据发生在对磁盘进行IO WRITE之前：

    

      
先在内存中压缩数据，并对齐Block size，确定做punch hole的范围，同时将即将写入文件的buf地址指向新分配的压缩页地址(这里存在优化的空间，需要避免重复分配内存块)。参考函数：

Native AIO: AIO::reserve_slot –> os_file_compress_page

同步写：os_file_pwrite –> os_file_io –> os_file_compress_page

      
将压缩处理过的page写入文件;

      
随后调用函数os_file_io_complete中，执行punch hole操作（os_file_punch_hole）。

    

    
解压数据

    
在从磁盘读取数据到磁盘后，首先要进行解压：参考函数：os_file_io_complete –> os_file_decompress_page

    
特殊处理

    

      
通过dblwr恢复的corruption的page写入时禁止压缩模式，因为此时innodb处于恢复模式，还没拿到server层存储的compression属性；

      
row_merge_read 和row_merge_write，一般是用于排序的临时文件，无需做压缩/解压；

      
truncate操作的文件日志禁止压缩模式。

    

    
代码整体的逻辑比较清晰，但改动点还比较多，后续我们将该特性Port到RDS版本，结合新内核来发挥数据空间节省的目的。

    
最后，Facebook的大神Domas写了一篇
博客
，认为InnoDB推出这样的压缩特性，使其正在丧失自身的优势，非常值得一读。简单的摘要下：

    

      
无法完美压缩：例如9KB的数据可能需要12kb来存储，取决于block size；

      
无法压缩Buffer pool, 这是和传统innodb压缩相比，以前的压缩方式可以在内存中只存放压缩页拷贝 （然而也有可能同时存在压缩和解压页），因此用户可能需要去购买iops更高的设备，而oracle正好也卖这些….

      
punch hole 可能产生的文件碎片化，底层的文件管理更加复杂；

      
对innodb文件做punch hole可能带来的后果是，使得每个文件的page变成一个独立的segment，文件系统需要单独的journal和metadata来管理。另外也有可能有性能问题：可能比non-sparse的写操作昂贵五倍 （这依赖于具体的内核）；

      
删除一个拥有几百万个段管理对象的数据文件带来的开销会非常昂贵。

    

  

  

    

    

    
Test Book

  

  

    
背景

    
在RDS环境中，多租户使用同一台主机是很常见的事情，为了隔离用户资源，有很多手段，例如使用虚拟机，或者CGROUP技术。以CGROUP为例，可以控制进程的CPU使用、内存使用、块设备的IOPS或者吞吐速率等资源使用。限制资源的好处是可以在共用的硬件层面为多个用户提供承诺的性能指标。当然这种方法也有一定的弊端，例如当用户需要运行消耗较多资源的SQL的时候，无法利用机器的空闲资源，因为它被限制住了。还有一些弊端可能导致RDS的不稳定，本文将展开讨论其中的弊端之一，资源限制是如何导致备库延迟的。

    
分析过程

    
创建一个实例，32G内存(确保测试时不被OOM)，1000GB存储空间，将块设备的读写IOPS都限制到200。

    
修改限制可以在控制台或者主机上操作，主机上操作举例：

    
获取postmaster进程号

    

      
$ps -ewf|grep pg468619
pg468619  24097      1  0 Jul29 ?        00:00:17 /path/to/postgres -D /path/to/data

    

    
查看这个进程所在的组

    

      
$cat /proc/24097/cgroup
3:memory:/rule3038
2:cpu:/rule3038
1:blkio:/rule3038

    

    
目前已限制在200

    

      
$cat /path/to/rule3038/blkio.throttle.read_iops_device
8:0     200
8:16    200
$cat /path/to/rds/rule3038/blkio.throttle.write_iops_device
8:0     200
8:16    200

    

    
如果没有限制，可以直接修改以上两个文件，或者使用cgset例如：

    

      
cgset -r blkio.throttle.write_iops_device='8:0 200' rule3038
cgset -r blkio.throttle.write_iops_device='8:16 200' rule3038

    

    
对应的块设备

    

      
$ll /dev/sda
brw-rw---- 1 root disk 8, 0 May 18 13:59 /dev/sda
$ll /dev/sdb
brw-rw---- 1 root disk 8, 16 Jul 31 07:45 /dev/sdb

    

    
接下来需要做的是创建测试用户，以及测试函数和测试表：

    
连接到数据库

    

      
$psql -p 3038 -U pg468619 postgres

    

    
创建测试用户

    

      
postgres=# create role digoal login encrypted password 'digoal';
postgres=# grant all on database postgres to digoal;

    

    
创建测试表，用于存储主节点插入XLOG的LSN以及备库接收、写、FLUSH、APPLY的XLOG LSN位置，以便计算主节点产生XLOG的速度和备库延迟的字节数。

    

      
postgres=# create table tbl_xlog_insert(id int,
sec numeric default EXTRACT(EPOCH from clock_timestamp()),
xlog_lsn text default pg_current_xlog_insert_location(),
sent_lsn pg_lsn,
write_lsn pg_lsn,
flush_lsn pg_lsn,
replay_lsn pg_lsn);

    

    
创建测试函数，目的是快速的产生大量XLOG，同时记录XLOG的位置到测试表。

    

      
postgres=# \c postgres postgres
postgres=# create or replace function f_test(int) returns void as $_$
declare
  v_tbl name := 'tbl_'||pg_backend_pid();
  ddl text := ' (id int8';
begin
  set synchronous_commit=off;
  execute 'DROP TABLE IF EXISTS '||v_tbl;
  -- 创建一个201个字段的测试表.
  for i in 1..200 loop
    ddl := ddl||',c'||i||' int8 default 0';
  end loop;
    ddl := ddl||') ';
  execute 'create table '||v_tbl||ddl||' with (autovacuum_enabled=off,   toast.autovacuum_enabled=off)';
  execute 'insert into '||v_tbl||' select generate_series(1,'||$1||')';
  execute 'DROP TABLE IF EXISTS '||v_tbl;
  -- 插入当前的XLOG位置, standby接收到的位置. 可能有一定的反馈延迟,延迟10毫秒
  perform pg_sleep(0.01);
  insert into tbl_xlog_insert(id, sent_lsn,write_lsn,flush_lsn,replay_lsn) select   pg_backend_pid(), sent_location,write_location,flush_location,replay_location from   pg_stat_replication limit 1;
end;
$_$ language plpgsql strict security definer;
postgres=# GRANT execute on function f_test(int) to digoal;

    

    
在测试机创建测试脚本

    

      
postgres@digoal-> cat test.sql
select f_test(5000);

    

    
测试时，使用1个连接就够了，太多了又会带来新的问题，心跳检测失败可能导致主备切换，这也是目前资源限制引起的一个问题，后面再来谈这个问题如何处理。

    

      
postgres@digoal-> pgbench -M prepared -n -r -f ./test.sql -c 1 -j 1 -t 100 -h  digoal0001.pg.rds.aliyuncs.com -p 3999 -U digoal postgres

    

    
在主节点查询主库产生XLOG的速度，以及备库延迟的情况：

    

      
postgres=# select round(0.001*pg_xlog_location_diff((lead(xlog_lsn,1) over(order by sec))::pg_lsn,xlog_lsn::pg_lsn)/(case lead(sec,1) over(order by sec)-sec when 0 then 1 else lead(sec,1) over(order by sec)-sec end), 2)as gen_xlog_KBpsec,
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,sent_lsn)/1024.0, 2) AS sent_xlog_delay_KB,
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,write_lsn)/1024.0, 2) AS   write_xlog_delay_KB,
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,flush_lsn)/1024.0, 2) AS flush_xlog_delay_KB,
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,replay_lsn)/1024.0, 2) AS replay_xlog_delay_KB
from tbl_xlog_insert where id=(select id from tbl_xlog_insert order by sec desc limit 1) order by sec;
 gen_xlog_kbpsec | sent_xlog_delay_kb | write_xlog_delay_kb | flush_xlog_delay_kb | replay_xlog_delay_kb
-----------------+--------------------+---------------------+---------------------+----------------------
          814.87 |            8616.37 |             8616.37 |             8616.37 |              8616.54
          809.63 |           10752.44 |            13952.44 |            16896.44 |             16898.04
          802.75 |           12747.91 |            14795.91 |            17227.91 |             17227.92
          821.96 |           12173.92 |            16269.92 |            19981.92 |             23022.60
          820.87 |           13167.77 |            17515.32 |            19799.77 |             23168.63
          581.98 |           15177.93 |            19553.93 |            23009.93 |             26213.85
         1320.19 |           12735.36 |            17087.36 |            20415.36 |             24112.03
          818.03 |           17281.54 |            21761.54 |            25729.54 |             28560.27
          808.66 |           17093.73 |            21445.73 |            25413.73 |             26377.87
          .                  .                     .                     .                     .
          .                  .                     .                     .                     .
          .                  .                     .                     .                     .
          .                  .                     .                     .                     .
          806.56 |           79064.04 |            83544.04 |            87128.04 |             90281.66
          804.10 |           82864.95 |            87472.95 |            87472.95 |             92209.77
          802.53 |           84598.83 |            88310.83 |            91766.83 |             95275.68
          598.90 |           82998.66 |            90038.66 |            90038.66 |             93495.39
         1304.52 |           84704.81 |            89184.81 |            92768.81 |             92768.95
          807.26 |           86847.66 |            91199.66 |            94527.66 |             97583.47
          823.86 |           89209.00 |            93561.00 |            97785.00 |             97785.32
          805.17 |           96967.23 |           101319.23 |           105287.23 |            108879.23
          829.41 |          101531.95 |           105883.95 |           109979.95 |            113468.85
          797.81 |          101999.23 |           106479.23 |           110447.23 |            110448.48
          609.47 |          102789.51 |           107269.51 |           111109.51 |            114741.74
                 |           99381.25 |           103861.25 |           107573.25 |            111083.62
(100 rows)

    

    
XLOG产生速度约800KB/s, 由于XLOG盘的IOPS限制，导致STANDBY延迟不断增大。为了排除并不是网络延迟导致的延迟，我们可以使用systemtap跟踪wal sender、wal writter进程的IOPS以及wal sender进程的网络吞吐。

    
需要先安装kernel debuginfo，跟踪指定postgres wal writter进程，获取读写IOPS：

    

      
\# vi io.stp
global reads, writes, total_io

probe vfs.read.return {
    reads[execname()] += 1
}

probe vfs.write.return {
    writes[execname()] += 1
}

\# print every 1 seconds  
probe timer.s(1) {  
    foreach (name in writes)  
        total_io[name] += writes[name]  
    foreach (name in reads)  
        total_io[name] += reads[name]  
    printf ("%16s\t%10s\t%10s\n", "Process", "SUM Read IO", "SUM Written IO")  
    foreach (name in total_io-)  
        printf("%16s\t%10d\t%10d\n", name,  
               reads[name], writes[name])  
    delete reads  
    delete writes  
    print("\n")  
}

\# print total_io when exit  
probe end {  
    foreach (name in total_io-)  
        printf("%16s\t%10d\t%10d\n", name,  
               reads[name], writes[name])  
    delete total_io  
    print("\n")  
}  

\# stap -vp 5 -DMAXSKIPPED=9999 -DSTP_NO_OVERLOAD -DMAXTRYLOCK=100 ./io.stp -x $pid

    

    
跟踪指定postgres wal sender进程，获取网络传输速率：

    

      
\# vi net.stp

global ifxmit, ifrecv  
global ifmerged  
// 定义3个全局变量, 分别用于存储传输,接收,以及合并数组;  
// 传输和接收数组中存储统计信息;  
// 合并数组存储网络接口上按照pid(), dev_name, execname(), uid()维度累加的传输和接收包个数.  

probe netdev.transmit  
{  
  ifxmit[pid(), dev_name, execname(), uid()] <<< length  
}  
// netdev.transmit 探针, 网络设备传输buffer时触发.  

probe netdev.receive  
{  
  ifrecv[pid(), dev_name, execname(), uid()] <<< length  
}  
// netdev.receive 探针, 从网络设备接收数据时触发.  

function print_activity()  
{  
  printf("%5s %5s %-7s %7s %7s %7s %7s %-15s\n",  
         "PID", "UID", "DEV", "XMIT_PK", "RECV_PK",    
         "XMIT_KB", "RECV_KB", "COMMAND")  

  foreach ([pid, dev, exec, uid] in ifrecv) {  
          ifmerged[pid, dev, exec, uid] += @count(ifrecv[pid,dev,exec,uid]);  
  }  
  foreach ([pid, dev, exec, uid] in ifxmit) {  
          ifmerged[pid, dev, exec, uid] += @count(ifxmit[pid,dev,exec,uid]);  
  }  
  // 按照倒序输出  
  foreach ([pid, dev, exec, uid] in ifmerged-) {  
    n_xmit = @count(ifxmit[pid, dev, exec, uid])  
    n_recv = @count(ifrecv[pid, dev, exec, uid])  
    printf("%5d %5d %-7s %7d %7d %7d %7d %-15s\n",  
           pid, uid, dev, n_xmit, n_recv,  
           n_xmit ? @sum(ifxmit[pid, dev, exec, uid])/1024 : 0,  
           n_recv ? @sum(ifrecv[pid, dev, exec, uid])/1024 : 0,  
           exec)  
  }   
// 输出: pid, uid, 网络接口, 传输包数, 接收包数, 传输KB, 接收KB, command.  

  print("\n")  

  delete ifxmit  
  delete ifrecv  
  delete ifmerged  
}  
// print_activity 函数, 按照pid,dev,exec,uid维度, 根据网络接收和传输包数倒序输出.  
//            n_xmit ? @sum(ifxmit[pid, dev, exec, uid])/1024 : 0,  
//            n_recv ? @sum(ifrecv[pid, dev, exec, uid])/1024 : 0,  
//  表示传输和接收的KB数.  
// print_activity 函数的末尾清除三个全局变量的值. 下次调用时重新输出上一次输出以来的统计信息.  

probe timer.s(1), end, error  
{  
  print_activity()  
}  
// 每1秒调用一次print_activity .  

\# stap -vp 5 -DMAXSKIPPED=9999 -DSTP_NO_OVERLOAD -DMAXTRYLOCK=100 ./io.stp -x $pid

    

    
因为生产上没有debuginfo的包，没有办法完成以上跟踪。不过为了验证不是网络原因导致的问题，还有其他手段。
sar -n DEV 1 100000
也可以查看网络传输。iotop则可以观察进程的IO，很遗憾生产上也没有iotop。

    
那么接下来，放开cgroup的限制，我们可以通过
sar -n DEV 1 100000
观察一下网络带宽：

主库和备库的postgres进程都从cgroup移除：

    

      
\#cat /proc/50511/cgroup   
3:memory:/rule3008  
2:cpu:/rule3008  
1:blkio:/rule3008  
\#cgdelete memory:/rule3008  
\#cgdelete cpu:/rule3008  
\#cgdelete blkio:/rule3008  

$cat /proc/119876/cgroup   
3:memory:/rule3090  
2:cpu:/rule3090  
1:blkio:/rule3090  

\#cgdelete memory:/rule3090  
\#cgdelete cpu:/rule3090  
\#cgdelete blkio:/rule3090  

    

    
目前的网络带宽是1GB：

    

      
\#ethtool eth0|grep Speed  
        Speed: 1000Mb/s

    

    
再次测试，我们可以观察到网络传输达到了1GB/8，约120MB/s：

    

      
01:54:24 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s  
01:54:25 PM        lo    132.29    132.29     29.42     29.42      0.00      0.00      0.00  
01:54:25 PM      eth0  85685.42   6495.83 125161.86    538.14      0.00      0.00      0.00  
01:54:25 PM      eth1    125.00     77.08     32.55     34.17      0.00      0.00      2.08  
01:54:25 PM     bond0  85808.33   6570.83 125192.78    572.14      0.00      0.00      2.08  

01:54:25 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s  
01:54:26 PM        lo    125.00    125.00     28.50     28.50      0.00      0.00      0.00  
01:54:26 PM      eth0  85412.50   6509.38 124869.50    519.73      0.00      0.00      0.00  
01:54:26 PM      eth1    129.17     97.92     11.04     57.40      0.00      0.00      0.00  
01:54:26 PM     bond0  85544.79   6611.46 124883.69    577.44      0.00      0.00      0.00  

    

    
当然，完全开放IOPS也有风险。如果网络带宽低于主节点产生WAL的速度，可能导致备库需要的WAL在主库WAL被快速回收，这种情况下，备库如果不能从任何地方获取到需要的XLOG，则备库会处于青黄不接的状态。我们需要考虑调整相应的wal keep segments，或者备库使用归档进行恢复，脱离青黄不接的状态。

    
以下是完全放开IOPS限制后带来的问题，由于写WAL速度超过了网络带宽120MB/S，达到了300MB/S，所以备库同样会延迟：

    

      
postgres=# select round(0.001*pg_xlog_location_diff((lead(xlog_lsn,1) over(order by sec))::pg_lsn,xlog_lsn::pg_lsn)/(case lead(sec,1) over(order by sec)-sec when 0 then 1 else lead(sec,1) over(order by sec)-sec end), 2)as gen_xlog_KBpsec,   
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,sent_lsn)/1024.0, 2) AS sent_xlog_delay_KB,  
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,write_lsn)/1024.0, 2) AS write_xlog_delay_KB,  
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,flush_lsn)/1024.0, 2) AS flush_xlog_delay_KB,  
round(pg_xlog_location_diff(xlog_lsn::pg_lsn,replay_lsn)/1024.0, 2) AS replay_xlog_delay_KB  
from tbl_xlog_insert where id=(select id from tbl_xlog_insert order by sec desc limit 1) order by sec;  
 gen_xlog_kbpsec | sent_xlog_delay_kb | write_xlog_delay_kb | flush_xlog_delay_kb | replay_xlog_delay_kb   
-----------------+--------------------+---------------------+---------------------+----------------------  
       306692.66 |         2763682.05 |          2769058.05 |          2769058.05 |           2773902.84  
       310323.46 |         2821964.55 |          2826060.55 |          2826060.55 |           2830312.84  
       286290.82 |         2878171.34 |          2882267.34 |          2882267.34 |           2888606.55  
       308019.02 |         2933665.58 |          2937761.58 |          2937761.58 |           2941141.12  
       347211.31 |         2992420.60 |          2996516.60 |          2996516.60 |           3000172.73  
       339915.61 |         3049958.89 |          3054054.89 |          3054054.89 |           3060592.84  
       345896.39 |         3110687.52 |          3115295.52 |          3115295.52 |           3123686.84  
       326032.85 |         3169349.81 |          3174213.81 |          3174341.81 |           3176994.25  
       309214.90 |         3223985.07 |          3231409.07 |          3231409.07 |           3234051.52  
       335529.65 |         3273305.11 |          3277529.11 |          3277529.11 |           3286191.45  
       329873.46 |         3330912.32 |          3335008.32 |          3335008.32 |           3343094.45  
       293908.19 |         3386875.67 |          3392251.67 |          3392251.67 |           3398439.91  
       329390.57 |         3439531.98 |          3443627.98 |          3443627.98 |           3448171.41    

    

    
当备库需要的XLOG在主库被覆盖后，备库无法获得对应的WAL，这种情况下，只能重新搭建备库，或者从归档获取需要的XLOG：

    

      
91812                           2015-07-31 05:55:40 UTC 00000                                           LOG:  started streaming WAL from primary at B/7A000000 on timeline 1  

91812                           2015-07-31 05:55:40 UTC XX000                                           FATAL:  could not receive data from WAL stream: ERROR:  requested WAL segment 000000010000000B0000007A has already been removed  

91833                           2015-07-31 05:55:45 UTC 00000                                           LOG:  started streaming WAL from primary at B/7A000000 on timeline 1  

91833                           2015-07-31 05:55:45 UTC XX000                                           FATAL:  could not receive data from WAL stream: ERROR:  requested WAL segment 000000010000000B0000007A has already been removed  

    

    
解决办法探讨

    
问题：

    

      
限制XLOG盘的IOPS，在用户长时间临近IOPS限制的操作下，可能导致备库延迟，同时可能带来心跳超时的问题。

      
如果不限制XLOG盘的IOPS，那么可能导致主节点产生WAL的速度过快，超出网卡的带宽（目前来看，换万兆网就可以解决这个问题），这样的话主库的XLOG可能会被覆盖掉，备库会无法获取需要的XLOG。

    

    
解决办法探讨：

    

      
不限制XLOG盘的IOPS，同时使用万兆网卡。

      
备库配置restore command，当主库的WAL被覆盖后，使用归档恢复。

    

    
参考

    

      
红帽cgroup文档

      

      
systemtap文档

    

  

  

    

    

    
Test Book

  

  

    
最近上游发布了MySQL 5.6.26版本，从Release Note来看，MySQL 5.6版本已经相当成熟，fix的bug数越来越少了。本文主要分析releae note上fix的相关bug，去除performance scheama、mac及windows平台、企业版、package相关内容。从本期开始，我们会在新版本发布时，在当月的月报上为大家做详细的版本Release Note分析。

    
InnoDB storage engine

    
问题描述

在类Unix平台上，当innodb_flush_method设置为O_DIRECT时，函数
os_file_create_simple_no_error_handling_func
没有使用O_DIRECT方式打开数据文件。例如在函数
fil_node_open_file
中，可能先以函数
os_file_create_simple_no_error_handling_func
打开文件，确定文件的大小，然后关闭文件；再以
os_file_create
打开数据文件，前者使用Buffered IO，后者使用DIRECT IO。这种混合使用可能引发性能问题。

    
根据man手册建议：

    

      
Applications should avoid mixing O_DIRECT and normal I/O to the same file, and especially to overlapping byte regions in handles the coherency issues in this situation, overall I/O the same file. Even when the filesystem correctly throughput is likely to be slower than using either mode of files with direct I/O to the same files.” alone. Likewise, applications should avoid mixing mmap(2)

    

    
(Bug #21113036, Bug #76627)

    
解决

在函数
os_file_create_simple_no_error_handling_func
 中禁止OS Cache（函数
os_file_set_nocache
）

    
补丁

b4daac21f52ced96c11632b83445111c0acede56

    
问题描述

在将一个脏页从非压缩page拷贝到压缩页后，在写page到文件时(
buf_flush_write_block_low
)，在设置压缩页的修改LSN之前先调用了函数
page_zip_verify_checksum
，由于此时压缩页上的LSN为0，而计算出来的checksum也可能为0，此时
page_zip_verify_checksum
认为要尝试写入一个空page，返回false，导致断言失败(Bug #21086723)。

    
解决

先设置LSN，再调用
page_zip_verify_checksum
。

    
补丁

5b6041b2c7cbee8a1d917631d3a051122b8c4f8d

    
问题描述

当以如下序列执行时，实例会crash:

    

      
create database `b`;
use b;
create table `#mysql50#q.q` select 1;
drop database `b`;

    

    
在创建表时，发现非法的表名，表名被reset成一个空字符串，传递到引擎层就是”dbname/”， 而引擎层的数据词典定义中，是通过“dbname/tablename”这样的字符串来定位的，这就违反了数据词典的约定。 随后如果执行drop database, 会去遍历以db名作为前缀的数据词典项，触发crash。PS：即使重启实例，drop database，也无法执行清理操作，用户线程会不停的在drop db的逻辑里loop(Bug #19929435)。

    
解决

在引擎层拒绝创建空的表名。

    
补丁

8fd710e06024a890e08e35009da541194ca0e5a4

    
问题描述

在函数
innobase_get_foreign_key_info
中，需要根据子表中存储的父表表名去打开父表，但子表上是根据系统字符集system_charset_info存储的，而innodb是使用my_charset_filename存储表名和库名，因此如果包含父表包含特殊字符，就会造成无法打开父表，导致报错。(Bug #21094069)

    
解决

将系统字符集的表名和库名转换成my_charset_filename格式（tablename_to_filename）。

    
补丁

1fae0d42c352908fed03e29db2b391a0d2969269

    
问题描述

    

      
当一个IO后台线程为了做ibuf merge，需要读入对应数据文件的bitmap page时(check 函数
buf_page_io_complete
 –> 
ibuf_merge_or_delete_for_page
),读取方式为同步读, 
space->n_pending_ops
递增；

      
另外一个用户线程准备删除对应的tablespace，因此将
space->stop_new_ops
设置为true，并等待直到
space->n_pending_ops
为0（
fil_check_pending_operations
）；

      
后台线程尝试读入ibuf bitmap page，但由于在
fil_io
函数中，如果发现
space->stop_new_ops
被设置，所有的读操作都被拒绝，直接返回DB_TABLESPACE_DELETED错误，但在函数
ibuf_merge_or_delete_for_page
中总是认为ibuf bitmap page被成功读入内存，后面直接引用这个page（实际上是空指针），可能会导致实例crash。

    

    
解决

在进行fil_io时，如果表空间正在被删除(
space->stop_new_ops
被设置为true），不允许异步读操作，但允许写操作和同步读操作。

    
补丁

3ba4563a757e07c3052c780b63e2626c78ca5c47

    
问题描述

当表上的索引存在前缀索引时(prefix index)，对表进行export，再import tablespace可能会失败，并报Schema mismatch错误，错误码为ER_TABLE_SCHEMA_MISMATCH。test case见bug#76877 (Bug #20977779, Bug #76877)。原因是cfg文件和表的索引定义相匹配时逻辑错误，例如如下表：

    

      
CREATE TABLE t1 (c1 VARCHAR(128), PRIMARY KEY (c1(16))) ENGINE=InnoDB;

    

    
在索引对象中定义了4个列：(c1, prefix_len=16), (DB_TRX_ID), (DB_ROLL_PTR)，(c1, prefix_len=0)。

cfg和表索引对象相比较时，其实两者是一样的，但cfg在取列时，如果存在相同列名的，总是取第一个，如上例，在比较第四个列的schema是否一致时，取的实际上是第一个，从而产生报错。

    
参考函数：
row_import::match_index_columns
 ((Bug #20977779, Bug #76877))。

    
解决

一个列一个列的依次校验。

    
补丁：

db23392bac27ad3e84319229ee3db9921b734abd

    
问题描述

考虑如下场景：

    

      
purge线程读取一个undo ，解析出对应的记录 (
row_purge
 —> 
row_purge_parse_undo_rec
)；

      
先 purge 二级索引(
row_purge_remove_sec_if_poss
)，再purge聚集索引(
row_purge_remove_clust_if_poss
)；

      
当 purge 二级索引页时，需要检查二级索引记录是否可以被物理purge掉(
row_purge_remove_sec_if_poss_leaf
)。

    

    
参考函数：
row_purge_poss_sec

    

      
can_delete = !row_purge_reposition_pcur(BTR_SEARCH_LEAF, node, &mtr)
             || !row_vers_old_has_index_entry(TRUE,
                                              btr_pcur_get_rec(&node->pcur),
                                              &mtr, index, entry,
                                              node->roll_ptr, node->trx_id);

    

    

row_purge_reposition_pcur
定位到聚集索引上，
node->found_clust
设置为true，定位到clust index上的cursor存储在node->pour上。

    

      
然后再检查二级索引记录是否被标记删除了，(
row_purge_remove_sec_if_poss_leaf
 —> 
red_get_deleted_flag
)，如果没有被标记删除，则报warning。

    

    
但是步骤3中，即时二级索引没有被标记删除，在函数
row_purge_poss_sec
也返回了true，这是因为重新定位cursor的逻辑错误。

    
函数
row_purge_reposition_pcur
:

    

      
if (node->found_clust) {
          ibool   found;
          found = btr_pcur_restore_position(mode, &node->pcur, mtr);
          return(found);
} else {
           node->found_clust = row_search_on_row_ref(
           &node->pcur, mode, node->table, node->ref, mtr);
           if (node->found_clust) {
               btr_pcur_store_position(&node->pcur, mtr);
           }
}

return(node->found_clust);

    

    
考虑如下序列：

    

      
purge Index1时，根据node->ref找到对应的聚集索引记录，node->found_clust设置为true，当前cursor存到node->pour中；

      
其他用户线程操作了聚集索引页，导致在purge index2时，restore position可能失败，因此返回false；

      
随后purge index2，发现node->found_clust为true，依旧用上次restore的position来作restore，依然失败；在函数
row_purge_reposition_pcur
返回false就认为对应的聚集索引不存在，然后就去尝试删除二级索引记录；但注意这次想purge的二级索引记录可能是一个新鲜插入的记录，并没有被delete mark，我们实际上需要根据node->ref重新定位。

    

    
解决

在函数
row_purge_reposition_pcur
中，若是restore cursor失败，需要重置node->found_clust为false (Bug #19138298, Bug #70214, Bug #21126772, Bug #21065746)

    
补丁

982a157c71667040838def7a00d951ffc55eccbc

4b8304a9a41c8382d18e084608c33e5c27bec311

e59914034ab695035c3fe48f046a96bb98d53044

92b4683d59c066f099be1d283c7d61b00caeedb2

    
InnoDB 全文索引

    
问题描述

尝试为表上rebuild 全文索引，但表上已经有损坏的索引时，会触发assert。(Bug #20637494)

    
解决

抛出错误，提示用户先删掉损坏的索引。返回错误码为ER_INNODB_INDEX_CORRUPT。

    
补丁

4395ad1755c3ed86c4210f76001a76eb0a69b553

3bdb4573e9b25357eea2421647263216c36367cb

    
问题描述

构建full-text的表上存在隐藏的FTS_DOC_ID和唯一索引FTS_DOC_ID_INDEX（FTS_DOC_ID），当删除全文索引时，对应的隐藏列并没有删除，但在当前的逻辑中，如果存在FTS_DOC_ID，则不允许ONLINE DDL(Bug #20590013, Bug #76012)。

    
解决

当表上只有FTS_DOC_ID_INDEX和FTS_DOC_ID 但没有定义全文索引时，允许ONLINE DDL。这些隐藏列直到全表rebuild时才被删除。

    
补丁

5610e5354a8be6609b2fc2a37902961be26af3cf

    
InnoDB API/Memcached

    
问题描述

ib_cursor_moveto
 函数没有判断构建的tuple的列个数是否小于索引列个数，而是直接用索引列的个数来做遍历，可能导致段错误(Bug #21121197, Bug #77083)。

    
解决

加上对应的判断。

    
补丁：

d511b503353c1588e90907f59b947e31796c1fc1

    
问题描述

ib_table_truncate
函数中，当truncate失败时，没有正确的释放事务对象，可能导致shutdown hang住。

    
解决:

总是释放事务对象。

    
补丁:

aeef8dc2c7af8be4f8ac91be6963e5252e8a9d3f

e0e1f02d97f54252c1e6ea386dc029560c9f7d08

    
问题描述

ib_open_table_by_id
函数中，已经加了
dict_sys->mutex
锁，但该函数中调用
dict_table_open_on_id
传递的第二个参数为FALSE，认为没有持有mutex，属于基本的逻辑错误(Bug #21121084, Bug #77100)。

    
解决

调整传参。

    
补丁

a2353c5d7ff6430e853de435d007ac64d91fd17d

    
上面几个bug看起来都是非常“低级”的代码缺陷，这也侧面证明了InnoDB API接口在推出后社区用的人实在太少了，这三个Bug都是facebook的工程师提出的，很好奇他们会利用InnoDB API做些什么。

    
问题描述

InnoDB memcached plugin在处理unsigned NOT NULL类型时没有正确处理，导致返回的数据错误。

    

      
对于unsigned类型，对应的IB_COL_UNSIGNED = 2

      
对于NOT NULL类型，对应的IB_COL_NOT_NULL = 1

    

    
但是代码里很多地方都使用类似
m_col->attr == IB_COL_UNSIGNED
，导致大量的逻辑错误(Bug #20535517, Bug #75864)。

    
解决

修改成
m_col->attr & IB_COL_UNSIGNED
。

    
补丁：

6ff8d5d2940b9c9079e07641b2beb12e8dd84b38

    
复制

    
问题描述

当使用多线程复制时，执行STOP SLAVE需要等待所有的worker线程完成其各自的工作队列中的事务。如果Pending的事务很多，可能要等待很长时间才能完成STOP SLAVE，另外在STOP SLAVE的过程中，是无法SHOW SLAVE STATUS的，一种比较常见的场景就是大量的监控程序SQL堵塞堆积(Bug #75525, Bug #20369401)。

    
解决

    
解决方案是先找到任意worker线程中最新的commit的事务，确定一个上限位点，所有的worker线程执行到这个位置停止，剩下的事务暂时不执行。具体的：

    

      
执行STOP SLAVE，coordinator线程首先将所有worker线程的状态设置成STOP（
slave_stop_workers(rli, &mts_inited)
），并更新
rli->max_updated_index
为最新的已经执行（或正在执行）的事务的group index(
set_max_updated_index_on_stop
)；

      
所有worker的工作队列中索引序号小于等于 
rli->max_updated_index
 的事务都需要被执行完，否则worker状态设置为STOP_ACCEPTED，表示已经完成了max_updated_index 之前的事务，可以退出(
set_max_updated_index_on_stop
)；

      
coordinator线程等待所有worker线程退出，并做一次checkpoint(
slave_stop_workers
 –> 
mts_checkpoint_routine
)。

    

    
但是上述方案并不能解决正在执行的大事务过慢的问题。

    
补丁

37f2e969bd36a7455e81ea2350685707bc859866

    
问题描述

MySQL使用InnoDB + binlog做XA的方式来进行crash recovery，但在之前的版本中如果写Binlog到磁盘发生了错误，group commit的逻辑并没有感知到这个错误，而是继续在引擎层提交事务，备库没有接收到对应的Binlog，导致主备数据不一致 (Bug #76795, Bug #20938915)。

    
解决

从MySQL 5.6.22版本开始，引入了一个新参数binlog_error_action (5.6.20及21版本叫做binlogging_impossible_mode)，若设置为ABORT_SERVER，则在发生binlog写入错误时直接让实例退出，避免引发更大的错误；若设置为IGNORE_ERROR，则忽略本次写入失败，同时禁止Binlog记录，需要重启才能让binlog再次开启。

为了主备数据的强一致性，通常应该将binlog_error_action设置为ABORT_SERVER，这样在打开文件、rotate新文件、从IO Cache写binlog到文件出现磁盘错误时，都会退出实例。

    
补丁

3b6b4bf8c5d1bfada58678acebafdf6f813c2dfe

    
问题描述

relay_log_recovery参数打开时，备库在重启时就可以根据SQL线程执行到的位置重新拉binlog，这可以有效处理备库发生机器宕机导致relay log文件损坏的情况，无需人工去change master，在之前版本中，如果使用了多线程复制，是无法开启该特性的，在启动实例时会报如下错误：

    

      
relay-log-recovery cannot be executed when the slave was stopped with an error or killed in MTS mode

    

    
实际上，如果开启了GTID，就无需关心各个worker线程之间的gap，通过备库的GTID集合充拉relay log即可(Bug #73397, Bug #19316063)。

    
解决

在重启recovery时检查是否开启了GTID。

    
补丁

fce558959bd0e5af1ae6aac3d8573db00c271dfd

    
问题描述

当两台备库错误的配置了相同的server_uuid，并指向同一个主库时，备库的IO线程会被频繁的断开并尝试重连。而在备库来看，并没有足够的信息提示产生重连的原因。

    
解决

这种场景下，主库会生产一个错误信息传递到备库，当备库接受到这样的错误信息时不再尝试重连。(Bug #72581, Bug #18731252)

    
补丁

751a3da76dfd66b92395f90f11fce6bd890c9db5

    
分区表

    
问题描述

bug被隐藏，无test case，对应release note:

    

      
Partitioning: In certain cases, ALTER TABLE … REBUILD PARTITION was not handled correctly when executed on a locked table. (Bug #75677, Bug #20437706)

    

    
解决

参考commit log.

    
补丁

6b0e6683416dc6f8274a460bd2512e7b037ec75f

    
优化器

    
小编对优化器模块代码理解不深，感兴趣的同学可以自行阅读对应的bug report及commit log，手动尝试复现bug。

    
问题描述

    

      
While calculating the cost for doing semjoin_dupsweedout strategy inner_fnout is calculated wrongly when max_outer_fanout becomes 0. This causes mysql server to exit later (Bug #21184091)

    

    
解决

    

      
Calculate the inner_fanout only when max_outer_fanout is > 0. Else there is no need to recalculate inner_fanout w.r.t max_outer_fanout.

    

    
补丁

bfba2338902a81927d116c30eaa1245eaea025c8

    
问题描述

    

      
GROUP BY or ORDER BY on a CHAR(0) NOT NULL column could lead to a server exit. (Bug #19660891)

ASSERTION `PARAM.SORT_LENGTH != 0’ FAILED IN SQL/FILESORT.CC:361

    

    
解决

参考commit log.

    
补丁：

60c6920509516a1e05b855799479a59c27803191

b62c5daa646434290c9b2d1c9b162487cb8edf04

    
问题描述

    

      
When choosing join order, the optimizer could incorrectly calculate the cost of a table scan and choose a table scan over a more efficient eq_ref join. (Bug #71584, Bug #18194196)

    

    
解决

参考commit log.

    
补丁：

7a36c155ea3f484799c213a5be5a3deb464251dc

    
其他

    
问题描述

MySQL String库下的字符串处理问题，在
cs_values
函数中，对字符串长度的处理存在缺陷，可能导致内存损坏(Bug #20359808)。

    
解决

调整长度判断。

    
补丁

1cdd3b832ae32d3c236869954f0c7a8a851ed94a

    
问题描述

当会话断开或者执行类似change user时，session status会merge到全局status中（
add_to_status(&global_status_var, &status_var)
），但没有立刻对thd的status_var做reset，这时候另外一个session去查询global status时，会重复把这些session的status值加到全局。

    
解决

在
THD::change_user
、
THD::release_resources
函数中累加到全局status后，重置session的status。

    
补丁

c8243dd36047debb76134344d761e48f0cedf78e

  

  

    

    

    
Test Book

  

  

    
背景

    
我们执行一个大SQL时（长度大于512M），会返回如下错误：

    

      
ERROR: invalid memory alloc request size 1073741824

    

    
复现

    
我们首先复现出来这个问题

    

      

        
创建表

        

          
 create table byteatable(id int, obj bytea);

        

      

      

        
插入512M大对象

        

          
 #!/bin/bash
 data='a'
 for ((i=1;i<=29;i++));
 do
 data=$data$data
 done
 echo 'build ok'
 psql -U postgres -d postgres << EOF
 insert into byteatable(id,obj) values (1,"$data");
 EOF
 echo 'OK'

        

      

    

    
执行脚本后就能复现出来了

    

      
ERROR: invalid memory alloc request size 1073741824

    

    
BUG分析

    
我们先找到出现这个错误的位置。

    
源码位置：

    

      
void *
MemoryContextAlloc(MemoryContext context, Size size)
{
    void *ret;
    AssertArg(MemoryContextIsValid(context));
    if (!AllocSizeIsValid(size))
      elog(ERROR, "invalid memory alloc request size %zu", size);
    context->isReset = false;
    ret = (*context->methods->alloc) (context, size);
    VALGRIND_MEMPOOL_ALLOC(context, ret, size);
    return ret;
}

#define AllocSizeIsValid(size) ((Size) (size) <= MaxAllocSize)

#define MaxAllocSize ((Size) 0x3fffffff) /* 1 gigabyte - 1 */

    

    
这里限制的内存是1G - 1，而我们插入的大SQL需要的内存没有1G，那么为什么还提示非法的申请内存大小呢？通过调试跟踪，我们发现是在词法分析的时刻出错的。主要问题是在词法分析的内存申请机制上，申请的内存肯定不能少于sql的长度，如果当前申请的内存不够用，那么将重新申请当前内存乘以2的内存大小。

    

      
int literallen; /* actual current string length */

int literalalloc; /* current allocated buffer size */
//当前申请内存初始化
yyext->literalalloc = 1024;

    

    

      
static void
addlit(char *ytext, int yleng, core_yyscan_t yyscanner)
{
    /* enlarge buffer if needed */
    if ((yyextra->literallen + yleng) >= yyextra->literalalloc)
    {
       do {
           yyextra->literalalloc *= 2;
       } while ((yyextra->literallen + yleng) >= yyextra->literalalloc);
       yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
                              yyextra->literalalloc);
     }
     /* append new data */
     memcpy(yyextra->literalbuf + yyextra->literallen, ytext, yleng);
     yyextra->literallen += yleng;
}
static void
addlitchar(unsigned char ychar, core_yyscan_t yyscanner)
{
     /* enlarge buffer if needed */
     if ((yyextra->literallen + 1) >= yyextra->literalalloc)
     {
          yyextra->literalalloc *= 2;
          yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
         yyextra->literalalloc);
     }
}

    

    
从源码中可以看出，每次申请原申请内存的2倍，即yyextra->literalalloc *= 2; 而最大申请内存限制是

    

      
#define MaxAllocSize ((Size) 0x3fffffff) /* 1 gigabyte - 1 */

    

    
所以我们在词法分析能申请的最大内存是2^29 = 536870912，如果词法分析SQL语句需要的内存大于536870912，那么申请的内存需要再乘2，就会得到2^30 = 1073741824，超过MaxAllocSize＝0x3fffffff= 1073741823。所以会提示错误：

    

      
ERROR: invalid memory alloc request size 1073741824

    

    
当然不仅仅是插入一个大对象才会引起这个问题，只要是SQL语句长度大于512M都是出现这个错误,我们可以使用select复现：

    

      
do language plpgsql $$
declare
  v_text text := 'a';
begin
  for i in 1..29 loop
    v_text:=v_text||v_text;
  end loop;
  execute $_$select '$_$||v_text||$_$'$_$;
  raise notice 'execute a sql large than 512MB success.';
exception when others then
  raise notice 'execute a sql large than 512MB failed.';
end;
$$;

    

    
BUG修复

    
其实申请MaxAllocSize是可行的，通过修改源码实现，每当申请的内存大于MaxAllocSize并且SQL需要的长度小于MaxAllocSize时，我们就申请MaxAllocSize大小的内存。

    

      
static void
addlit(char *ytext, int yleng, core_yyscan_t yyscanner)
{
    /* enlarge buffer if needed */
    if ((yyextra->literallen + yleng) >= yyextra->literalalloc)
    {
        do {
                yyextra->literalalloc *= 2;
        } while ((yyextra->literallen + yleng) >= yyextra->literalalloc);
        /* we can not alloc more than MaxAllocSize */
        if (yyextra->literalalloc > MaxAllocSize && (yyextra->literallen + yleng) < MaxAllocSize)
                yyextra->literalalloc = MaxAllocSize;
        yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
                                                                                        yyextra->literalalloc);
    }
    /* append new data */
    memcpy(yyextra->literalbuf + yyextra->literallen, ytext, yleng);
    yyextra->literallen += yleng;
}

    

    

      
static void
addlitchar(unsigned char ychar, core_yyscan_t yyscanner)
{
    /* enlarge buffer if needed */
    if ((yyextra->literallen + 1) >= yyextra->literalalloc)
    {
        yyextra->literalalloc *= 2;
        /* we can not alloc more than MaxAllocSize */
        if (yyextra->literalalloc > MaxAllocSize && (yyextra->literallen + 1) < MaxAllocSize)
                yyextra->literalalloc = MaxAllocSize;
        yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
                                                                                        yyextra->literalalloc);
    }
    /* append new data */
    yyextra->literalbuf[yyextra->literallen] = ychar;
    yyextra->literallen += 1;
}

    

    
修复之后可以正常插入了

    

      
$ sh pgtest.sh
build ok
INSERT 0 1
OK

    

  

  

    

    

    
Test Book

  

  

    
介绍

    
当你对InnoDB进行修改操作时，例如删除一些行，这些行只是被标记为“已删除”，而不是真的从索引中物理删除了，因而空间也没有真的被释放回收。InnoDB的Purge线程会异步的来清理这些没用的索引键和行，但是依然没有把这些释放出来的空间还给操作系统重新使用，因而会导致页面中存在很多空洞。如果表结构中包含动态长度字段，那么这些空洞甚至可能不能被InnoDB重新用来存新的行，因为空间空间长度不足。

有些用户可能会使用 OPTIMIZE TABLE 或者 ALTER TABLE  ENGINE=InnoDB 来重建这些表，但是这样会导致表的拷贝，如果临时空间不足甚至不足以进行一次 OPTIMIZE TABLE 操作。并且如果你用的是共享表空间方式，OPTIMIZE TABLE 会导致你的共享表空间文件持续增大，因为整理的索引和数据都追加在数据文件的末尾。

    
新的碎片整理算法

    
从MariaDB 10.1开始，MariaDB把Facebook的碎片整理代码合并进来了，并且把所有代码都调整到InnoDB/XtraDB层去实现，因而只需要使用现成的 OPTIMIZE TABLE 命令就行。开启新的整理算法需要把下面的配置加到 my.cnf 配置文件中：

    

      
[mysqld]
innodb-defragment=1

    

    
这样配置以后新的碎片整理功能就会替代原有的 OPTIMIZE TABLE 算法，不会有新的表生成，也不需要把旧表的数据拷贝到新表。新的算法会载入 n 个页面尝试把上面的记录紧凑的合并到一起，从而让页面存满记录，然后释放掉完全空了的页面。

    
新的配置项

    

      
innodb_defragment: 打开或关闭InnoDB碎片整理算法。当设置为FALSE时，所有正在做的整理操作会暂停。暂停的整理操作会在变量设置为TRUE时重新开始。默认值是FALSE。

      
innodb_defragment_n_pages: 一次性读取多少个页面进行合并整理操作。取值范围是2~32，默认值是7。

      
innodb_defragment_stats_accuracy: 统计信息写到持久化存储前可以有多少个整理统计信息的变更。设置为0表示不禁用整理统计追踪，默认值是0.

      
innodb_defragment_fill_factor_n_recs: 在进行空间整理时在一个页面上留多少条记录的空间。这个变量和 innodb_defragment_fill_factor 一起可以让页面不至于被塞得太满，从而减少后面插入记录导致的页面分裂。取值范围是 1~100，默认值是20。

      
innodb_defragment_fill_factor: 可以设置为[0.7~1]之间的值，让整理算法知道应该把一个页面填的多满。默认值是0.9. 设置为0.7以下没有什么意义。这个变量和 innodb_defragment_fill_factor_n_recs 一起可以让页面不至于被塞得太满，从而减少后面插入记录导致的页面分裂。上面这量个变量也是告诉我们，持续的整理操作可以让InnoDB更高效。

      
innodb_defragment_frequency: 对单个索引每秒的整理操作不要超过这个数量。这个变量控制了整理线程在一段时间内请求索引的 X_LOCK 的次数。整理线程会检查是当前操作的索引离上次操作的时间否超过了1/defragment_frequency (s) ，如果还没过足够长的时间，则把索引重新放回队列中。实际的操作频率只会比这个值低。

    

    
新的状态变量

    

      
Innodb_defragment_compression_failures: 整理碎片时重新压缩页面失败的次数。

      
Innodb_defragment_failures: 整理操作失败的次数（例如没有可压缩的页面）。

      
Innodb_defragment_count: 整理操作的次数。

    

    
举例

    

      
set @@global.innodb_file_per_table = 1;
set @@global.innodb_defragment_n_pages = 32;
set @@global.innodb_defragment_fill_factor = 0.95;
CREATE TABLE tb_defragment (
pk1 bigint(20) NOT NULL,
pk2 bigint(20) NOT NULL,
fd4 text,
fd5 varchar(50) DEFAULT NULL,
PRIMARY KEY (pk1),
KEY ix1 (pk2)
) ENGINE=InnoDB;

delimiter //;
create procedure innodb_insert_proc (repeat_count int)
begin
  declare current_num int;
  set current_num = 0;
  while current_num &lt; repeat_count do
    INSERT INTO tb_defragment VALUES (current_num, 1, REPEAT('Abcdefg', 20), REPEAT('12345',5));
    INSERT INTO tb_defragment VALUES (current_num+1, 2, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    INSERT INTO tb_defragment VALUES (current_num+2, 3, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    INSERT INTO tb_defragment VALUES (current_num+3, 4, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    set current_num = current_num + 4;
  end while;
end//
delimiter ;//
commit;

set autocommit=0;
call innodb_insert_proc(50000);
commit;
set autocommit=1;

    

    
在建表和插入操作之后，我们可以在 INFORMATION_SCHEMA 中看到如下信息：

    

      
select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'PRIMARY';
Value
313

select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'ix1';
Value
72

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_pages_freed');
count(stat_value)
0

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_page_split');
count(stat_value)
0

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_leaf_pages_defrag');
count(stat_value)
0

SELECT table_name, data_free/1024/1024 AS data_free_MB, table_rows FROM information_schema.tables WHERE engine LIKE 'InnoDB' and table_name like '%tb_defragment%';
table_name data_free_MB table_rows
tb_defragment 4.00000000 50051

SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'PRIMARY';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` PRIMARY 25873 4739939

SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'ix1';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` ix1 50071 1051775

    

    
现在如果我们删掉 3/4 的记录就会在页面中留下很多空洞，然后我们通过 OTPTIMIZE TABLE 执行整理操作：

    

      
delete from tb_defragment where pk2 between 2 and 4;

optimize table tb_defragment;
Table   Op  Msg_type    Msg_text
test.tb_defragment  optimize    status  OK
show status like '%innodb_def%';
Variable_name   Value
Innodb_defragment_compression_failures  0
Innodb_defragment_failures  1
Innodb_defragment_count 4

    

    
执行完之后我们可以看到有些页面被释放掉了，有些页面被合并了：

    

      
select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'PRIMARY';
Value
0

select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'ix1';
Value
0

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_pages_freed');
count(stat_value)
2

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_page_split');
count(stat_value)
2

select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_leaf_pages_defrag');
count(stat_value)
2

SELECT table_name, data_free/1024/1024 AS data_free_MB, table_rows FROM information_schema.tables WHERE engine LIKE 'InnoDB';
table_name data_free_MB table_rows
innodb_index_stats 0.00000000 8
innodb_table_stats 0.00000000 0
tb_defragment 4.00000000 12431

SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'PRIMARY';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` PRIMARY 690 102145

SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'ix1';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` ix1 5295 111263

    

  

  

    

    

    
Test Book

  

  

    
问题现象

    
最近我们的几个非生产实例中，均出现了由archiver进程产生的core dump文件，让人如临大敌：是不是遇到了PG的大BUG导致了crash？

    
先来看看这些core文件。由于我们在/proc/sys/kernel/core_pattern指定了存放core文件的目录，所以可以在这个目录里面找到这些core文件。幸运的是，这些core文件都不大，一般几百KB，没有对文件系统的存储空间造成压力：

    

      
$du -sh *
248K    core.170254
248K    core.242719
248K    core.31624

    

    
使用file命令，看一下core文件的基本信息：

    

      
#file core.170254
core.170254: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style, from 'cp pg_xlog/00000001000000410000006E /xxxx/yyy/zzz/00000001000'

    

    
可以看到，这些core文件由执行cp命令的进程产生，而且这个cp命令是在拷贝PG的xlog。因为我们设置了PG的archieve_command参数为’cp %f /xxx/yyy/zzz/%p’，所以判断这个执行cp命令的进程，应该是由归档进程调用，用于归档日志的。

    
根据我们以前的经验，crash一般是由于代码的Bug引起。难道系统的cp命令有Bug导致了core？

    
初步分析

    
我们用gdb看一下发生core dump时的调用栈：

    

      
$gdb postgres core.31624

Core was generated by `cp pg_xlog/000000010000004200000091 /xxx/yyy/zzz/00000001000'.
Program terminated with signal 3, Quit.
#0  0x0000003ed44da360 in ?? ()
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.80.2.alios6.x86_64
(gdb) bt
#0  0x0000003ed44da360 in ?? ()
#1  0x0000000000407df9 in ?? ()
#2  0x007da781c2f60000 in ?? ()
......

    

    
Oops，由于没有安装glibc的调试信息（debug info），看不到调用栈的函数名。但从上面的信息里面，我们得到了一个重要线索：

    

      
Program terminated with signal 3, Quit.

    

    
就是说cp命令在执行的过程中，收到一个编号为3的信号。查看文档，这个信号就是SIGQUIT。这儿有两个疑问：

    

      
为什么收到SIGQUIT后，会产生core文件？

      
为什么归档进程在调用cp命令进行日志归档时，会收到SIGQUIT信号？

    

    
下面我们以这两个问题为线索进行分析。

    
问题分析

    
问题1

    
先看第1个问题，我们使用简单的脚本模拟一下。用一个脚本，不断的拷贝文件，我们使用较大的文件，以使cp命令运行的时间足够长：

    

      
$cat cp.sh
while true ; do

cp -fr bigfile bigfile_copy

sleep 1

done

    

    
在上述脚本运行过程中，再用另一个脚本不断的向其发送SIGQUIT信号：

    

      
$cat kill.sh
while true ;
do

kill -3 `ps -ef |grep "cp -fr" |head -n 1 |awk -F' ' '{print $2}'`

done

    

    
注意，我们发送信号的目标进程必须是cp.sh进程的执行
cp -fr
命令的子进程，而不是cp.sh本身。这时，我们发现cp.sh的脚本收到了SIGQUIT信号：

    

      
cp.sh: line 7:  3683 Quit                    cp -fr /tmp/* /tmp2
cp.sh: line 7:  3879 Quit                    cp -fr /tmp/* /tmp2

    

    
但奇怪的是，系统的core目录并没用core文件产生。原来，Linux系统缺省的环境下，每个用户进程的core文件的size limit是0，需要显式增大size limit，才能打印出core文件。我们使用下面的命令，放开core文件的size limit：

    

      
ulimit -c unlimited

    

    
再次运行cp.sh和kill.sh，发现core file 产生了！

    

      
$sh cp.sh
cp.sh: line 7:  7222 Quit                    (core dumped) cp -fr bigfile bigfile_copy
cp.sh: line 7:  7416 Quit                    (core dumped) cp -fr bigfile bigfile_copy
cp.sh: line 7:  7605 Quit                    (core dumped) cp -fr bigfile bigfile_copy
cp.sh: line 7:  7798 Quit                    (core dumped) cp -fr bigfile bigfile_copy

    

    
看来，cp命令在收到SIGQUIT时，产生core文件是正常的。查阅文档和cp命令的源代码发现，原来，Linux下如果进程不对SIGQUIT信号做捕获（即不设置信号处理函数），进程在收到SIGQUIT的行为就是打印core文件并退出。

    
问题2

    
现在再看第2个问题，为什么cp命令的进程会收到SIGQUIT信号？是不是Postmaster发出的呢？

    
仔细查看系统日志记录（位于/var/log/messages），发现系统出现过OOM（Out of Memory) Kill事件。就是说，PG实例使用了过多的内存，把系统内存耗光后，Linux系统发出了kill -9信号给某些占用内存较多的子进程。子进程收到Kill -9信号后，就会无条件退出。而Linux内核在子进程退出时，会向其父进程，即PG的Postmaster主进程发送SIGCHILD信号。从PG代码可以看到，Postmaster在处理这些SIGCHILD信号时，如果发现子进程是被Kill -9杀掉的，则要用发信号的方式通知所有子进程退出（除了像sysloger这种非关键进程外）。这时Postmaster向子进程发生的退出信号就是SIGQUIT！所以我们高度怀疑cp命令收到的SIGQUIT正是Postmaster发出的。

    
但有个疑问是，产生core文件的cp命令进程，是归档进程利用syscmd函数新启动一个独立的子进程，所以其实它是Postmaster进程的“孙子”进程；而Postmaster只是像它直接的子进程发送了信号，信号是如何到达这个孙子进程的呢？

    
仔细查看代码发现，原来，PG代码里面fork一个子进程后，会建立一个子进程组(Process Group)，这个子进程fork出的进程，都会在这个进程组里面。向这个子进程发信号，组中所有进程都会收到。

    
结论与解决方案

    
自此，谜底揭开，core文件的产生原因可以总结为，发生OOM Kill时，PG主进程会向所有子进程和子进程所拥有的Process Group发送Kill -3信号；另一方面，归档进程会fork子进程来执行归档命令（即cp命令），此子进程在归档进程的Process Group里面，故也收到了Kill -3信号。而且该进程会对信号执行缺省动作即产生core文件。所产生的core文件为cp命令的core文件（一般300k左右，对系统影响不大）。

    
我们知道，如果我们设置core file的size limit为0，就会阻止core文件产生。而对于出问题的PG实例，我们是在pg_ctl启动进程时加入了-c选项，将core file 的size limit去除；而所有Postmaster的子进程和孙子进程，又继承了父进程的size limit，导致core file产生。所以，此问题的一个规避方法为，对archive_command做如下设置：

    

      
archive_command='ulimit -c 0 && cp %p /u01/tmp/%f'

    

    
这样在cp命令被归档进程调用时，其core file的size limit为0，即便收到SIGQUIT信号，也不会打印core dump file。

  

  

    

    

    
Test Book

  

  

    
背景

    
最近在Aliyun RDS的环境上，有些用户碰到了打开文件句柄数过多的错误，查看用户实例的打开句柄个数，确实超过了系统设置的值，一旦出现了这种错误，将会带来连锁的各种错误(取决于当时正在操作什么类型的文件，以及什么操作)。下面，我们就一起来看一下MySQL在操作过程中，牵涉到文件打开和关闭的关键点，以及你一直以来可能存在的认识误区。

    
参数和名词

    
关联参数

    
我们先列一下几个关键的参数，不了解的可以先参考官方文档，我们假设在MySQL 5.6版本上，主要针对InnoDB表。

    

      
open_file_limits
table_open_cache
table_definition_cache
innodb_file_per_table
innodb_open_files

    

    
open_file_limits的设置的值，mysqld会通过setrlimit系统调用来初始化本进程可以使用的最大文件句柄数。

    
而另外的四个参数的设置，对打开的文件数产生什么影响？我们稍后分析。

    
关联名词

    
下面列出的名称，是在MySQL源代码中出现的，能帮助我们更好的理解参数的设置：

    

      
table：MySQL操作一张表时建的对象，table_open_cache参数控制缓存的对象就是table；

      
table_share：MySQL对一张表的定义建的对象， table_definition_cache参数控制缓存的对象就是table_share；

      
handler：引擎句柄，和table是一对一的关系，每一种引擎都实现自己的handler，这也是MySQL支持多引擎的关键；

      
innobase_share：InnoDB引擎层对应的表定义对象；

      
dict_table：InnoDB引擎对应的表结构定义；

      
fil_tablespace：InnoDB引擎层对应的表空间，当设置innodb_file_per_table=ON的时候，每一个InnoDB表对应一个表空间；

      
fil_node：表空间对应的节点，如果一个表空间对应多个文件，比如logfile，那么就tablespace和node就是一对多的关系。

    

    
对照着上面提到的参数和名称，下面来看几个场景。

    
3. 场景

    
我们把一个简单的select语句在MySQL中的操作分为三个过程，open/read/close。

    
open过程

    
当操作某张表的时候，比如select * from test;

    

      
首先初始化一个table_share对象:

如果对象在table_definition_cache中存在，就直接引用；

如果不存在，就打开test.frm，读取表结构的定义，创建table_share对象，然后就关闭了test.frm。所以，这一步只在table_definition_cache未命中的时候，才open/close frm文件，并不占用太久的句柄。

      
然后创建table对象:

如果在table_open_cache中存在unused_table， 就直接使用；

如果不存在，就会创建table对象，这里并不牵涉到文件操作。

    

    
server层所需要的对象已经创建完毕，下面是InnoDB层:

    

      

        
首先创建InnoDB handler 和Innobase_share 对象，这一步仅仅是内存对象，不牵涉文件操作。

      

      
然后load dict_table对象:

如果在dictionary cache中存在dict_table，就直接引用；

如果不存在，InnoDB会读取系统表空间(ibdata)的SYS_TABLES表，读取InnoDB记录的表结构定义，同时还会读取SYS_INDEXES, SYS_COLUMN, SYS_FOREIGN 等和表关联的定义。

注：这里会牵涉到数据字典的读取操作，但因为ibdata文件从系统启动的时候，就一直处在打开状态，并且不能关闭，所以这里也没有打开新的文件操作。

      
最后load test表空间，在fil_system的缓存中查找: 如果存在，就直接使用，如果不存在，会读取SYS_DATAFILES系统字典表，并打开第一个文件，这里只有一个文件test.ibd，读取segment header验证space id，验证成功，就创建了file_tablespace和fil_node对象。

注：这里会打开test.ibd文件，验证完tablespace id就会关闭。

    

    
结论

    
这里我们发现，在读取一张表的之前的open过程，虽然有open file的动作，但都是用于初始化定义、结构等信息。所以table_open_cache， table_definition_cache并不会对open_file_limits有什么影响。而innodb_file_per_table的设置，只是增加了open file超过limit的几率，并不会有直接的影响。

    
read 过程

    
open完成后，当select需要扫描BTree结构上的某一个leaf page，而buffer pool未命中的时候，会发起IO操作:

    
InnoDB会通过fil_node对象里的file handler进行IO操作，但这里每次open file的时候，会进行innodb_open_files判断。如果当前InnoDB打开的文件数超过了innodb_open_files，就会强制关闭一些文件，在fil_system全局结构中有一个LRU链表，这里保存了所有打开的用户表空间文件句柄，并且当前没有任何IO操作。系统可以安全的关闭一些文件句柄，以满足innodb_open_files的需要。

    
结论

对于InnoDB来说，innodb_open_files设置了一个安全的file limit，除非InnoDB发起的并发IO请求数过多，并且分散在不同的表空间上。

    
close过程

    
当语句完成后，会进行close动作：

    

      
如果当前table cache大小没有超过table_open_cache，就把table缓存到cache中；

      
如果table_share的ref_count，就是table引用次数减到0，说明没有table引用，并且超过了table_definition_cache，就从cache中删除；

      
同样，innobase_share也根据ref_count来判断是否要缓存。InnoDB层的dict_table也缓存在dictionary cache中。

    

    
结论

close的过程，并没有文件的关闭动作，而仅仅是内存对象的缓存或者销毁的动作。

    
总体来看这三个过程：InnoDB所有和文件相关的对象、fil_tablespace、fil_node和语句、事务等一些生命周期并没有什么关系。所以语句的并发，事务的大小等等因素都不会引起文件打开数过多。

    
recovery过程

    
recovery的过程中，因为无法判断要应用的redo，所以会load fil_space一遍，会打开所有的ibd文件一遍，进行一次读取。但同样受限innodb_open_files的控制，同时打开文件数不能超过这个值。

    
不过5.7已经添加了一种新的redo类型MLOG_FILE_NAME ，来
优化recovery的过程
。

    
系统启动

在系统启动的过程中，会初始化ibdata和logfile文件，这两类文件，是永久打开的，不受innodb_open_files限制，但数量有限。

    
从上面来看，InnoDB并不会引起这么明显的open files过多的问题，那问题究竟出现在哪里？

    
问题

    
在MySQL实例中还存在其他文件，比如用户连接创建的socket、binlog 文件、relay log文件、slow log等log文件。socket由max_connections来控制，log文件的打开数量有限。所以问题回到了MyISAM表上面，对于用户创建的MyISAM分区表，open的过程中，会把MYD文件全部打开，当分区过多的时候，open files数量就急剧上升，导致超过limit值。

    
flush table会关闭打开的文件吗？

    
flush table操作，会把table cache中未使用的table close掉，前面我们看到close的操作，并不会产生文件关闭操作。不过MyISAM实现的handler的close函数，会把打开的文件句柄给关闭掉，所以flush table能够缓解open files过多的问题，但仅限于MyISAM，而InnoDB的文件打开/关闭逻辑并不受影响。

    
总结

    
所以，对于用户实例的open file limit的设置问题，需要计算好连接数、系统文件、表文件等文件，另外建议使用InnoDB表来避免open files 暴涨的问题。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
收到一枚RDS TokuDB实例crash导致HA切换的报警，上去一看错误如下：

    

      
tokudb/ft-index/ft/cachetable/cachetable.cc toku_cachetable_openfd_with_filenum: Assertion `filenum.fileid != FILENUM_NONE.fileid' failed
/bin/mysqld(_Z19db_env_do_backtraceP8_IO_FILE+0x1b)[0xc57ddb]
/bin/mysqld(_Z35toku_cachetable_openfd_with_filenumPP9cachefileP10cachetableiPKc7FILENUMPb+0x223)[0xbb49b3]
/bin/mysqld(_Z19toku_ft_handle_openP9ft_handlePKciiP10cachetableP7tokutxn+0x135)[0xbf3c05]
/bin/mysqld(_Z20toku_ft_handle_clonePP9ft_handleS0_P7tokutxn+0xb5)[0xbf42f5]
/bin/mysqld(_Z29toku_db_lt_on_create_callbackPN4toku8locktreeEPv+0x2a)[0xb801ba]
/bin/mysqld(_Z18toku_db_open_inameP9__toku_dbP13__toku_db_txnPKcji+0x276)[0xb805b6]
/bin/mysqld(_ZN9ha_tokudb20open_main_dictionaryEPKcbP13__toku_db_txn+0x1ab)[0xb50a0b]
/bin/mysqld(_ZN9ha_tokudb16initialize_shareEPKci+0x2c8)[0xb70848]
/bin/mysqld(_ZN9ha_tokudb4openEPKcij+0x5e9)[0xb71349]
/bin/mysqld(_ZN7handler7ha_openEP5TABLEPKcii+0x33)[0x5e74b3]

    

    
这个错误信息在RDS上第一次碰到，隐隐感到这是一个“可遇不可求”的bug导致，开始捉虫。

    
问题分析

    
每个表(索引)文件被打开后，TokuDB都会为这个文件赋予一个唯一id，即filenum。

    
filenum有什么作用？

TokuDB在写redo log的时候，每个事务里会带一个filenum属性，用来标示该事务属于哪个表文件，在崩溃恢复的时候，会根据这个filenum回放到相应的表里。

    
filenum在什么时候被分配？

表(索引)文件被打开的时候会被分配。

    
filenum如何分配？

为了保证唯一性，TokuDB维护了一个filenum数据结构(类似binary tree) : m_active_filenum，分配算法：

    

      
uint32_t m_next_filenum_to_use;  //全局变量，用来标识已分配的最大filenum
lock();
retry:
int ret = m_active_filenum.find(m_next_filenum_to_use);
if (ret == 0) {
  //m_next_filenum_to_use被占用
  m_next_filenum_to_use++;
  goto retry;
}
filenum = m_next_filenum_to_use; //得到我们想要的filenum
m_next_filenum_to_use++;
unlock();

    

    
这样问题就来了，如果用户有非常多的表(索引)文件，不停的被打开和关闭，m_next_filenum_to_use会一直递增下去，由于是uint32_t类型，小宇宙终于爆发了，filenum 递增到4294967295(UINT_MAX)，从而导致assert失败。

    
问题修复

    
当一些表(索引)文件被close后，这些filenum可以被回收再利用，所以当filenum递增到UINT_MAX后，重置到0即可:

    

      
uint32_t m_next_filenum_to_use;  //全局变量，用来标识已分配的最大filenum
lock();
retry:
int ret = m_active_filenum.find(m_next_filenum_to_use);
if (ret == 0) {
  //m_next_filenum_to_use被占用
  m_next_filenum_to_use++;
  goto retry;
}
// 从0开始重新获取未被使用的filenum
if (m_next_filenum_to_use == UINT_MAX) {
  m_next_filenum_to_use = 0;
  goto retry;
}
filenum = m_next_filenum_to_use; //得到我们想要的filenum
m_next_filenum_to_use++;
unlock();

    

    
RDS版本已修复此问题，官方patch戳
这里
。

  

  

    

    

    
Test Book

  

  

    
背景

    
我们知道MySQL的主备同步是通过binlog在备库重放进行的，IO线程把主库binlog拉过去存入relaylog，然后SQL线程重放 relaylog 中的event，然而这种模式有一个问题就是SQL线程只有一个，在主库压力大的时候，备库单个SQL线程是跑不过主库的多个用户线程的，这样备库延迟是不可避免的。为了解决这种n对1造成的备库延迟问题，5.6 引入了并行复制机制，即SQL线程在执行的时候可以并发跑。

    
关于其背后的设计思想，可以参考这几个worklog 
WL#4648
，
WL#5563
，
WL#5569
，
WL#5754
，
WL#5599
，之前的月报也对并行复制原理进程了阐述，读者朋友可以
回顾下
。

    
本篇将从代码实现角度讲述并行复制是如何做的，分析基于MySQL 5.6.26。

    
准备知识

    
binlog

    
binlog 是对数据库更改操作的记录，里面是一个个的event，如类似下面的event序列：

    

      
Query_log
Table_map
Write/Delete/Update_row_event
Xid

    

    
关于每个event的含义可以参考
官方文档
。

    
配置

    
并行复制提供了几个参数配置，可以通过修改参数值对其进行调节。

    

      
slave_parallel_workers           // worker 线程个数
slave-checkpoint-group           // 隔多少个事务做一次 checkpoint
slave-checkpoint-period          // 隔多长时间做一次 checkpoint
slave-pending-jobs-size-max      // 分发给worker的、处于等待状态的event的大小上限

    

    
概念术语

    
下面是并行复制中用到几个概念：

    

      
MTS            // Multi-Threaded Slave，并行复制
group          // 一个事务在binlog中对应的一组event序列
worker         // 简称W，event 执行线程，MTS新引入的
Coordinator    // 简称C，分发协作线程，就是之前的 SQL线程
checkpoint     // 简称CP，检查点，C线程在满足一定条件下去做，目的是收集W线程执行完信息，向前推动执行位点
B-event        // 标志事务开始的event，BEGIN 这种Query或者GTID
G-event        // 包含分发信息的event，如Table_map、Query
T-event        // 标志事务结束的event，COMMIT/ROLLBACK 这种Query 或者XID

    

    
相关代码文件

    
sql/rpl_rli_pdb.h // pdb的是 parallelized by db name简写
WL#5563

sql/rpl_rli_pdb.cc

sql/rpl_slave.cc

sql/log_event.cc

sql/rpl_rli.h

    
并行执行原则

    

      
并行执行的基本模型是生产者-消费者，C线程将event按db插入各W线程的任务队列，W线程从队列里取出event执行；

      
同一个group(事务)内的event都发给同一个worker，保证事务的一致性；

      
分发关系由包含db信息的event(G-evnet)决定，其它event按决定好的关系进行分发；

    

    
重要数据结构

    

      

        

db_worker_hash_entry
，db->worker 映射关系，也即分发关系，所有的分发关系缓存在C的一个HASH表中(APH)

        

          
 - db               // db 名
 - worker           // 指向worker的指针，表示被分发到的W线程
 - usage            // 有多少正在分发的group用到这个关系
 - temporary_tables // 用于在C和W之前传递临时表

        

      

      

        

slave_job_item
，worker的jobs队列的成员

        

          
 - data          // 就是一个binlog event

        

      

      

        

circular_buffer_queue
，用DYNAMIC_ARRAY arrary实现的一个首尾相连的环形队列，是其他重要数据结构的基类

        

          
 - Q              // 底层用到的 DYNAMIC_ARRAY
 - size           // Queue 的容量
 - avail          // 队列尾
 - entry          // 队列头
 - len            // 队列实际大小
 - de_queue()     // 出队操作
 - de_tail()      // 尾部出队
 - en_queue()     // 入队
 - head_queue()   // 取队列头，但是不出队

        

      

      

        

Slave_job_group
，维护一个正在执行的事务的信息，如对应的位点信息、事务分发到的worker、有没有执行完等。

        

          
 - group_master_log_name      // 对应主库的 binlog 文件名
 - group_master_log_pos       // 对应在主库 binlog 中的位置
 - group_relay_log_name       // 对应备库 relaylog 文件名
 - group_relay_log_pos        // 对应在备库 relaylog 中的位置
 - worker_id                  // 对应的worker的id
 - worker                     // worker 指针
 - total_seqno                // 当前group是启动以来执行的第几个group
 - master_log_pos             // group中B-event的位置
 - checkpoint_seqno           // 当前group是从上次做完CP后的第几个group
 - checkpoint_log_pos         // worker收到checkpoint信号后更新
 - checkpoint_log_name        // 同上
 - checkpoint_relay_log_pos   // 同上
 - checkpoint_relay_log_name  // 同上
 - done                       // 这个group是否已经被worker commit掉
 - shifted                    // checkpoint 的时候shift值
 - ts                         // 时间，更新SBM
 - reset()                    // 重置上面的成员变量

        

      

      

        

Slave_committed_queue
，维护分发执行的group信息，是
circular_buffer_queue
的子类，队列里存的时 
Slave_job_group

        

          
 - lwm                        // 类型是Slave_job_group，低水位(Low-Water-Mark)，表示上次CP执行到的位置
 - last_done                  // 类型是一个DYNAMIC_ARRAY，里面存的是Slave_job_group:total_seqno，表示每个worker执行到第几个group
 - assigned_group_index       // 正在分发的group在GAQ中的位置
 - move_queue_head()          // 做checkpoint时，把已经commit的group移出队列
 - get_job_group()            // 返回队列指定位置的Slave_job_group
 - en_queue()                 // 入队一个 Slave_job_group

        

      

      

        

Slave_jobs_queue
，任务队列，也是
circular_buffer_queue
的子类，队列里存的是
slave_job_item
，每个worker有一个这样的任务队列

        

          
 - overfill                  // 队列满标志
 - waited_overfill           // 队列满的次数

        

      

      

        

Slave_worker
，对应一个worker，
Relay_log_info
 的子类

        

          
 - jobs                           // 类型是 Slave_jobs_queue，C分发过来的event都放在这里面
 - c_rli                          // 指向C的指针
 - curr_group_exec_parts          // 类型是 DYNAMIC_ARRAY，里面存的是当前group用到的分发关系，是指向APH成员的指针，简写CGEP
 - curr_group_seen_begin          // 当前所在 group 有没有解析到 B-event
 - id                             // worker 的id标识
 - last_group_done_index          // worker上一次执行的group在GAQ中的位置
 - gaq_index                      // worker 当前执行的的事务在GAQ中的位置
 - usage_partition                // worker用到的分发关系个数
 - end_group_sets_max_dbs         // 和串行执行相关的
 - bitmap_shifted                 // CP后bitmap需要偏移的距离，用于调整 group_executed
 - wq_overrun_cnt                 // 超载多少
 - overrun_level                  // 超载指标
 - underrun_level                 // 饥饿指标
 - excess_cnt                     // 用于往mts_wq_excess_cnt累计
 - group_executed                 // 类型是 MY_BITMAP，标示CP后执行的group
 - group_shifted                  // 类型是 MY_BITMAP，计算group_executed，临时用作中间变量
 - running_status                 // 标识 worker 线程的状态，可以有 NOT_RUNNING、RUNNING、ERROR_LEAVING、KILLED
 - slave_worker_ends_group ()     // 当一个group执行完或者异常终止时会调用
 - commit_positions()             // group执行完是调用，用于更新位点和bitmap
 - rollback_positions()           // 回滚bitmap

        

      

      

        

Relay_log_info
，对应C线程，在MTS之前对应SQL线程，为了支持并行复制，在原来的基础上又加了一些成员

        

          
 - mapping_db_to_worker           // 非常重要的成员，类型是HASH，用于缓存所有的分发关系，APH（Assigned Partition Hash），目的能通过db快速找到映射关系，但HASH长度大于mts_partition_hash_soft_max（固定16）时，会对没有使用的映射关系进行回收。
 - workers                        // 类型是 DYNAMIC_ARRAY，成员是一个个Slave_worker
 - pending_jobs                   // 一个统计信息，表示待执行job个数
 - mts_slave_worker_queue_len_max // 每个worker最多能容纳jobs的个数，目前hard code是16384
 - mts_pending_jobs_size          // 所有worker的job占的内存
 - mts_pending_jobs_size_max      // 所有worker的job占的内存，对应配置 slave_pending_jobs_size_max
 - mts_wq_oversize                // 标示job占用内存已达上限
 - gaq                            // 非常重要的成员，代码注释里经常提到的GAQ，类型是Slave_committed_queue，存的成员是Slave_job_group，大小对应配置 slave-checkpoint-group，用于W和C交互
 - curr_group_assigned_parts      // 类型是 DYNAMIC_ARRAY，当前group中已经分配的event的映射关系，可以和Slave_worker的curr_group_exec_parts对应，简写CGAP
 - curr_group_da                  // 类型是DYNAMIC_ARRAY，对于还无法决定分发worker的event，先存在这里
 - mts_wq_underrun_w_id           // 标识比较空闲的worker的id
 - mts_wq_excess_cnt              // 标示worker的超载情况
 - mts_worker_underrun_level      // 当W的任务队列大小低于这个值的认为处于饥饿状态
 - mts_coordinator_basic_nap      // 当work负载较大时，C线程sleep，会用到这个值
 - opt_slave_parallel_workers     // 对应配置 slave_parallel_workers
 - slave_parallel_workers         // 当前实际的worker数
 - exit_counter                   // 退出时用
 - max_updated_index              // 退出时用
 - checkpoint_seqno               // 上次CP后分发的group个数
 - checkpoint_group               // 对应配置 mts_checkpoint_group
 - recovery_groups                // 类型是 MY_BITMAP，恢复时用到
 - mts_group_status               // 分发线程所处的状态，取值为 MTS_NOT_IN_GROUP、MTS_IN_GROUP、MTS_END_GROUP、MTS_KILLED_GROUP
 - mts_events_assigned            // 分发的event计数
 - mts_groups_assigned            // 分发的group计数
 - least_occupied_workers         // 类型是 DYNAMIC_ARRAY，从注释将worker按从空闲到繁忙排序的一个数组，用于先worker用，但是实际并未用到。 
 - last_clock                     // 上次做checkpoint的时间

        

      

      

        
其它方法

        

          
 map_db_to_worker()             // 把db映射给worker
 get_least_occupied_worker()    // 获取负载最小的worker
 wait_for_workers_to_finish()   // 等待worker完成，并发临时转成串行是用到
 append_item_to_jobs()          // 把任务分发给 worker
 mts_move_temp_table_to_entry() // 用于传递临时表
 mts_move_temp_tables_to_thd()  // 同上

        

      

    

    
初始化

    
和单线程SQL相比，MTS需要初始化新加的MTS变量和启动worker线程。

    
主要是
slave_start_workers()
这个函数。会初始化C线程的MTS变量，如workers、curr_group_assigned_parts、curr_group_da、gaq等，接着调用
init_hash_workers()
 初始化HASH表mapping_db_to_worker，在这些做完后依次调用 
slave_start_single_worker()
 初始化每个worker并启动W线程。worker 的的初始化包括jobs任务队列、curr_group_exec_parts 等相关变量，其中jobs长度目前是固定的16384，目前还不可配置；worker线程的主函数是
handle_slave_worker()
，不停的调用
slave_worker_exec_job()
来执行C分配的event。

    
Coordinator 分发协作

    
分发线程主体和之前的SQL线程基本是一样的，不停的调用 
exec_relay_log_event()
 函数。
exec_relay_log_event()
主要分2部分，一是调用
next_event()
读取relay log，一是
apply_event_and_update_pos()
 做分发。

    

next_event()
 比较简单，就是不停的用 
Log_event::read_log_event()
 从relay log 读取event，除此之外还会调用
mts_checkpoint_routine()
 做checkpoint，后面会详细讲checkpiont过程。

    

apply_event_and_update_pos()
进行分发的入口是
Log_event::apply_event()
，如果没有开MTS，就是原来的逻辑，SQL线程直接执行event，如果开了MTS的话，调用
get_slave_worker()
，这个是分发的主逻辑。

    
在介绍分发逻辑前，先将所有的binlog event 可以分下类（代码里是这么分的）:

    

      
B-event   // BEGIN(Query) 或者 GTID
G-event   // 包含db信息的event，Table_map 或者 Query
P-event   // 一般放在G-event前的，如int_var、rand、user_var等
R-event   // 一般放在G-event后的，如各种Rows event
T-event   // COMMIT/ROLLBACK(Query) 或者XID

    

    
分发逻辑是这样的:

    

      
如果是B-event，表明是事务的开始，mts_groups_assigned 计数加1，同时GAQ中入队一个新的group，表示一个新的事务开始，然后把event放入curr_group_da，因为B-event没有db信息，还不知道分发给哪个worker;

      
如果是G-event，event里包含db信息，就需要按这个db找到一个分发到的worker，worker选择机制是
map_db_to_worker()
实现。调用
map_db_to_worker()
时，有2个参数比较重要，一个是dbname，这个就是分发关系的key，一个是last_worker，表示当前group中event上一次分发到的worker(last_assigned_worker)；

在当前group已经用到的映射关系(curr_group_assigned_parts CGAP)中找，如果有同db的映射关系，就直接返回last_worker；如果找不到，就去APH中按db名搜索；

如果APH中搜到的话，分3种情况，a) 这个映射关系没有group用到，就直接把db映射为last_worker，如果last_worker为空的主话，就找一个最空闲的worker，
get_least_occupied_worker()
 b) 这个映射关系有group用，并且对应的worker和last_worker一样，就用last_worker，映射关系引用计数加1 c) 如果映射关系对应的worker和last_worker不一样，这表示有冲突，就需要等到引用这个映射关系的group全部执行完，然后把db映射为last_worker；

如果没搜到的话，就新生成一个映射关系，key用db，value用last_worker，如果last_worker为空的话，选最空闲的worker，
get_least_occupied_worker()
，并把新生成的映射插入到APH中，如果HASP表长度大于 mts_partition_hash_soft_max 的话，在插入前会对APH做一次收缩，从中去除掉没有被group引用的映射关系；

把选择的映射关系插入到 curr_group_assigned_parts 中。

      
如果是其它event，worker直接用last_assigned_worker。

    

    
什么时候切换为串行？

如果G-event包含的db个数大于MAX_DBS_IN_EVENT_MTS(16个)，或者更新的表被外键依赖，那么就需要串行执行当前group。串行固定选用第0个worker来执行，在分发前会等待其它worker全部执行完，在分发后会等待所有worker执行完。gropu执行完后自动切换为并行执行。

    
worker 确定好了，下一步就是分发event了，入口函数 
append_item_to_jobs()
。这个函数的作用非常明确，就是把event插入到worker的jobs队列中，在插入前会有对event大小有检查：

    

      
如果event大小已经超过了等待任务大小的上限（配置slave-pending-jobs-size-max )，就报event太大的错，然后返回；

      
如果event大小+已经在等待的任务大小超过了slave-pending-jobs-size-max，就等待，至到等待队列变小；

      
如果当前的worker的队列满的话，也等待。

    

    
Worker 执行

    
W线程执行的主逻辑是 
slave_worker_exec_job()
:

    

      
从自己的job队列里取出event；

      
根据event的信息，来更新worker中的变量，如curr_group_exec_parts(CGEP)、future_event_relay_log_pos、gaq_index等；

      
执行event，
do_apply_event_worker()
，最终调用每个event的
do_apply_event()
方法，和单线程下一样；

      
如果是T event，调用 
slave_worker_ends_group()
，表示一个事务已经执行完了，a) 更新位点，通过
commit_positions()
，更新事务在GAQ中对应的
Slave_job_group
，这样C就知道W执行到哪了，另外还会更新W的bitmap信息(如果是xid event，在apply_event中就会调用commit_positions) b) 清空 curr_group_exec_parts，将映射关系中的引用数减1;

      
更新C的队列统计信息，如等待执行任务数pending_jobs，等待执行任务大小mts_pending_jobs_size等；

      
更新 overrun 和 underrun 状态。

    

    
分发和执行逻辑可以用下图简单表示：

C线程在GAQ中插入group，标示一个要执行的事务，接着确定分发关系（从CGAP或者APH中，或者生成新的），然后按映射关系把event分发给对应worker的job队列；worker在执行event过程中更新自己的CGEP，在执行完整个group后，根据CGEP中的记录去更新APH中引用关系的计数，同时把GAQ中的对应group标示为done。

    
checkpoint 过程

    
如前所述，C线程会在从relaylog读取event后，会尝试做checkpoint，入口函数是
mts_checkpoint_routine()
。checkpoint的作用是把worker执行完的事务从GAQ中去除，向前推进事务完成点。

    
有2个条件会触发checkpoint：

    

      
当前时间距上次checkpoint已经超过配置 mts-checkpoint-period，这时会尝试做一次checkpoint，不管有没有向前推进事务；

      
上一次checkpoint后分发的事务数已经到达checkpoint设置上限(slave-checkpoint-group)，这时会强制做checkpoint，如果一次checkpoint没成功，会一直重试，直至成功。

    

    
GAQ中的事务推进通过 
Slave_committed_queue::move_queue_head()
 实现，从前向后扫描GAQ中的group：

    

      
如果当前group已经完成(通过标志
Slave_job_group.done
标志确认)，就把这个group出队，同时把这个出队的group信息赋给低水位lwm，向前推进；

      
如果遇到没有完成的group，就是遇到一个gap，表示对应worker还没执行完当前group，checkpoint不能再向前推进了，到此结束，返回值就是退出前已经推进的group个数。

    

    

    
slave 停止

    
类似单线程复制，stop slave 命令会终止C线程和W线程的运行。

    
C线程收到退出信号后，会先调用
slave_stop_workers()
终止W线程，过程如下：

    

      
依次把每个运行中的 worker 的 runnig_status 设置
Slave_worker::STOP
，同时设置worker执行终止位置
rli->max_updated_index
；

      
C线程等待所有W线程终止(
w->running_status == Slave_worker::NOT_RUNNING
)；

      
调用
mts_checkpoint_routine()
，做一次checkpoint；

      
释放资源，如APH、GAQ、CGDA(curr_group_da)、CGAP(curr_group_assigned_parts)等。

    

    
W线程在
pop_jobs_item()
中会调用
set_max_updated_index_on_stop()
，会检查2个条件 1) job队列是空的，2) 当前worker执行的事务在GAQ中的位置，是否已经超过
rli->max_updated_index
；任一条件满足就设置状态 running_status 为 
Slave_worker::STOP_ACCEPTED
，表示开始退出。

    
从上面的逻辑可以看出，在收到stop信号后，worker线程会等正在执行的group完成后，才会退出。

    
异常退出

    
W被kill或者执行出错

    

      

slave_worker_exec_job()
 进入错误处理逻辑，调用
Slave_worker::slave_worker_ends_group()
，给C线程发KILL_QUERY信号，然后做相关变量的清理，把job队列的任务全部清理掉，最终把running_status置为
Slave_worker::NOT_RUNNING
，表示结束；

      
C线程收到kill信号后，停止分发，然后进入
slave_stop_workers()
逻辑，给活跃的W线程发送STOP信号；

      
其它W线程收到STOP信号后，会处理job队列中所有的event；

      
和stop slave不同的是，C线程最后不会做checkpoint。

    

    
C被kill

    
C被kill的处理逻辑和stop slave差不多，不同之处在于等worker全部终止后，不会做checkpoint。

    
恢复

    
Slave线程重启（正常关闭或者异常kill）后，需要根据Coordinator和每个Worker的记录信息来进行恢复，推进到一个一致状态后再开始并行，详细过程我们下期月报再分析。

    
存在的问题

    
5.6 的MTS是按db来进行分发的，分发粒度太大，如果只有一个db的时候，就没有并发性了，所有group都分给一个worker，就变成单线程执行了。一个简单的优化改进是改成按table来分发，只需要把分发的key从dbname改成dbname + tablename，整体分发逻辑不需要变动。再进一步，如果遇到热点表更新呢，这时候binlog里记录的event都是针对一个表的更新，又会变成串行执行。这个时候就需要变化一下分发测略喽，如按事务维度进行分发，这个策略对源码的改动就会比较大些，有需要的同学可以试试:-)

  

  

    

    

    
Test Book

  

  

    
表定义

    
MySQL的表包含表名，表空间、索引、列、约束等信息，这些表的元数据我们暂且称为表定义信息。

对于InnoDB来说，MySQL在server层和engine层都有表定义信息。server层的表定义记录在frm文件中，而InnoDB层的表定义信息存储在InnoDB系统表中。例如:

    

      
 InnoDB_SYS_DATAFILES   
 InnoDB_SYS_TABLESTATS  
 InnoDB_SYS_INDEXES     
 InnoDB_SYS_FIELDS      
 InnoDB_SYS_TABLESPACES 
 InnoDB_SYS_FOREIGN_COLS
 InnoDB_SYS_FOREIGN     
 InnoDB_SYS_TABLES      
 InnoDB_SYS_COLUMNS     

    

    
注：以上都是memory表，它们内容是从实际系统表中获取的。实际上InnoDB系统表engine也是InnoDB类型的，数据也是以B树组织的。

    
在数据库每次执行sql都会访问表定义信息，如果每次都从frm文件或系统表中获取，效率会较低。因此MySQL在server层和InnoDB层都有表定义的缓存。以MySQL 5.6为例，参数table_definition_cache控制了表定义缓存中表的个数，server层和InnoDB层的表定义缓存共用此参数。

    
server层表定义缓存

    
server层表定义为TABLE_SHARE对象，TABLE_SHARE对象有引用计数和版本信息，每次使用flush操作会递增版本信息。

server层表定义缓存由hash表和old_unused_share链表组成，通过hash表table_def_cache以表名为key缓存TABLE_SHARE对象，同时未使用的TABLE_SHARE对象通过old_unused_share链表链接。

    

      

        
获取TABLE_SHARE(
get_table_share
)

先从HASH查找，找不到再读取frm文件加载表定义信息。同时递增引用计数。

      

      
释放TABLE_SHARE(
release_table_share
)

递减引用计数。当引用计数为0时，如果版本发生变化，直接删除此TABLE_SHARE。

    

    
old_unused_share链表调整:

    

      

        
获取TABLE_SHARE时(
get_table_share
)

未使用的TABLE_SHARE对象被启用，须从LRU链表取出；

如果缓存总数超出table_definition_cache大小，须依次从old_unused_share链表尾部去除。

      

      
释放TABLE_SHARE时(
release_table_share
)

当引用计数为0时，如果版本没有发生变化，将TABLE_SHARE对象加入old_unused_share链表尾部。如果缓存总数超出table_definition_cache大小，须依次从old_unused_share链表尾部去除。

真正free TABLE_SHARE对象时，如果此对象还在old_unused_share链表中，须从其中去除。

    

    
InnoDB层表定义缓存

    
InnoDB表定义为
dict_table_t
， 缓存为
dict_sys_t
，结构如下

    

      
struct dict_sys_t{
    ...
    hash_table_t*    table_hash;    /*!< hash table of the tables， based
                    on name */
    hash_table_t*    table_id_hash;    /*!< hash table of the tables， based
                    on id */
    ulint        size;        /*!< varying space in bytes occupied
                    by the data dictionary table and
                    index objects */
    dict_table_t*    sys_tables;    /*!< SYS_TABLES table */
    dict_table_t*    sys_columns;    /*!< SYS_COLUMNS table */
    dict_table_t*    sys_indexes;    /*!< SYS_INDEXES table */
    dict_table_t*    sys_fields;    /*!< SYS_FIELDS table */

    UT_LIST_BASE_NODE_T(dict_table_t)
            table_LRU;    /*!< List of tables that can be evicted
                    from the cache */
    UT_LIST_BASE_NODE_T(dict_table_t)
            table_non_LRU;    /*!< List of tables that can't be
                    evicted from the cache */
};

    

    
主要由hash表和LRU链表组成。

    

      

        
两个hash表，分别按name和id，便于按name和id进行查找。

      

      
table_non_LRU：

存放不放入到LRU链表的表，这些表不会从缓存中淘汰出去。那么哪些表会放入table_non_LRU链表呢？

系统表，如sys_tables sys_columns sys_fields SYS_INDEXES等；

有引用关系的表都加入table_non_LRU(dict_foreign_add_to_cache)；

有全文索引的表都加入table_non_LRU(fts_optimize_add_table)；

便于删表，删表前对将表加入table_non_LRU，删表时加载表时保证表仍然在缓存中，例如表corrupted时。

      

        
table_LRU

不在table_non_LRU链表中的表都加入table_LRU链表中。

      

      

        
dict_table_t* sys_tables 等

常用系统表单独标识出来，每次使用时直接取出，不需要从hash表查找。

      

      

        
LRU的维护

既然存在table_LRU链表，我们就需要考虑LRU的调整：

        

          

            
将最近使用的表放入LRU头部（
dict_move_to_mru
）

每次按name和id查找时都会调整，参考
dict_table_open_on_name
和
dict_table_open_on_id
。

          

          

            
LRU的淘汰

            

              
淘汰哪些表

LRU中表才可以淘汰，table_non_LRU中的表不参入淘汰。

表引用计数必须为0(
table->n_ref_count == 0
)。

表的索引被自适应哈希引用计数必须为0(
btr_search_t->ref_count=0
)。

              
何时淘汰

主线程控制每47（SRV_MASTER_DICT_LRU_INTERVAL）秒检查一次，只遍历一半LRU链表。

主线程空闲时检查一次，但扫所有LRU链表，清理控制缓存表个数不能超过table_definition_cache。

              
如何淘汰

从LRU尾部开始，淘汰满足条件表(
dict_make_room_in_cache
)。

            

          

        

      

    

    
注：

1. table_non_LRU没有实际作用，主要用于debug；

2. 如果有较多引用约束的表，它们不受LRU管理，参数table_definition_cache的作用会弱化。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · Innodb change buffer介绍

        

      

      

        

          
MySQL · TokuDB · TokuDB Checkpoint机制

        

      

      

        

          
PgSQL · 特性分析 · 时间线解析

        

      

      

        

          
PgSQL · 功能分析 · PostGIS 在 O2O应用中的优势

        

      

      

        

          
MySQL · 引擎特性 · InnoDB index lock前世今生

        

      

      

        

          
MySQL · 社区动态 · MySQL内存分配支持NUMA

        

      

      

        

          
MySQL · 答疑解惑 · 外键删除bug分析

        

      

      

        

          
MySQL · 引擎特性 · MySQL logical read-ahead

        

      

      

        

          
MySQL · 功能介绍 · binlog拉取速度的控制

        

      

      

        

          
MySQL · 答疑解惑 · 浮点型的显示问题

        

      

    

  

  

    

    

    
Test Book

  

  

    
前言

    
在前面几期月报我们介绍了undo log、redo log以及InnoDB如何崩溃恢复来实现数据ACID的相关知识。本期我们介绍另外一种重要的数据变更日志，也就是InnoDB change buffer。 Change buffer的主要目的是将对二级索引的数据操作缓存下来，以此减少二级索引的随机IO，并达到操作合并的效果。

    
在MySQL5.5之前的版本中，由于只支持缓存insert操作，所以最初叫做insert buffer，只是后来的版本中支持了更多的操作类型缓存，才改叫change buffer，这也是为什么代码中有大量的ibuf前缀开头的函数或变量。为了表达方面，本文也将change buffer缩写为ibuf。

    
由于历史上ibuf的数据格式曾发生过多次变化，本文讨论的相关内容基于如下设定：

版本为5.5及之后的版本，不涉及旧版本的逻辑，innodb_change_buffering 设置为ALL，表示缓存所有操作。

    
ibuf btree

    
change buffer的物理上是一颗普通的btree，存储在ibdata系统表空间中，根页为ibdata的第4个page(FSP_IBUF_TREE_ROOT_PAGE_NO)。

    
一条ibuf 记录大概包含如下列：

    
ibuf btree通过三列(space id, page no , counter)作为主键来唯一决定一条记录，其中counter是一个递增值，目的是为了维持不同操作的有序性，例如可以通过counter来保证在merge时执行如下序列时的循序和用户操作顺序是一致的：INSERT x, DELETE-MARK x, INSERT x。

    
在插入ibuf记录前我们是不知道counter的值的，因此总是先将对应tuple的counter设置为0xFFFF，然后将cursor以模式PAGE_CUR_LE定位到小于等于(space id, page no, 0xFFFF)的位置，新记录的counter为当前位置记录counter值加1。

    
ibuf btree最大默认为buffer pool size的25%，当超过25%时，可能触发用户线程同步缩减ibuf btree。为何要将ibuf btree的大小和buffer pool大小相关联呢 ？ 一个比较重要的原因是防止ibuf本身占用过多的buffer pool资源。

    
ibuf bitmap

    
由于ibuf 缓存的操作都是针对某个具体page的，因此在缓存操作时必须保证该操作不会导致空page 或索引分裂。

    
针对第一种情况，即避免空page，主要是对purge线程而言，因为只有purge线程才会去真正的删除二级索引上的物理记录。在准备插入类型为IBUF_OP_DELETE的操作缓存时，会预估在apply完该page上所有的ibuf entry后还剩下多少记录（
ibuf_get_volume_buffered
），如果只剩下一条记录，则拒绝本次purge操作缓存，改走正常的读入物理页逻辑。

    
针对第二种情况，InnoDB通过一种特殊的page来维护每个数据页的空闲空间大小，也就是ibuf bitmap page，该page存在于每个ibd文件中，具有固定的page no，其文件结构如下图所示：

    

    
ibuf bitmap使用4个bit来描述一个page：

    

      

        
IBUF_BITMAP_FREE：使用2个bit来描述空闲空间大小，以16KB的page size为例，能表示的空闲空间范围为0（0 bytes）、1（512 bytes）、2（1024 bytes）、3（2048 bytes）。很显然，能够缓存的二级索引记录最大不可能超过2048字节。

由于只有INSERT操作才可能导致page记录满，因此只需要对IBUF_OP_INSERT类型的操作进行判断：

        
ibuf_insert_low:

        

          
 if (op == IBUF_OP_INSERT) {
         ulint   bits = ibuf_bitmap_page_get_bits(
                 bitmap_page, page_no, zip_size, IBUF_BITMAP_FREE,
                 &bitmap_mtr);

         if (buffered + entry_size + page_dir_calc_reserved_space(1)
             > ibuf_index_page_calc_free_from_bits(zip_size, bits)) {
                 /* Release the bitmap page latch early. */
                 ibuf_mtr_commit(&bitmap_mtr);

                 /* It may not fit */
                 do_merge = TRUE;

                 ibuf_get_merge_page_nos(FALSE,
                                         btr_pcur_get_rec(&pcur), &mtr,
                                         space_ids, space_versions,
                                         page_nos, &n_stored);

                 goto fail_exit;
         }
 }

        

        
其中
ibuf_bitmap_page_get_bits
函数根据space id 和page no 获取对应的bitmap page，找到空闲空间描述信息；如果本次插入操作可能超出限制，则从当前cursor位置附近开始，触发一次异步的ibuf merge，目的是尽量将当前page的缓存操作做一次合并。

在正常的对物理页的DML过程中，如果page内空间发生了变化，总是需要去更新对应的IBUF_BITMAP_FREE值。参考函数：
btr_compress
、
btr_cur_optimistic_insert
。

      

      
IBUF_BITMAP_BUFFERED：用于表示该page是否有操作缓存，在
ibuf_insert_low
函数中，准备插入ibuf btree前设置成true。二级索引物理页读入内存时会根据该标记位判断是否需要进行ibuf merge操作。

      
IBUF_BITMAP_IBUF：表示该数据页是否是ibuf btree的一部分，该标记位主要用于异步AIO读操作。InnoDB专门为change buffer模块分配了一个后台AIO线程，如果page属于change buffer的b树，则使用该线程做异步读，参考函数：
ibuf_page_low

    

    
操作类型

    
InnoDB change buffer可以对三种类型的操作进行缓存：INSERT、DELETE-MARK 、DELETE操作，前两种对应用户线程操作，第三种则由purge操作触发。

    
用户可以通过参数innodb_change_buffering来控制缓存何种操作：

    

      
/** Allowed values of innodb_change_buffering */
static const char* innobase_change_buffering_values[IBUF_USE_COUNT] = {
        "none",         /* IBUF_USE_NONE */
        "inserts",      /* IBUF_USE_INSERT */
        "deletes",      /* IBUF_USE_DELETE_MARK */
        "changes",      /* IBUF_USE_INSERT_DELETE_MARK */
        "purges",       /* IBUF_USE_DELETE */
        "all"           /* IBUF_USE_ALL */
};

    

    
innodb_change_buffering默认值为all，表示缓存所有操作。注意由于在二级索引上的更新操作总是先delete-mark，再insert新记录，因此update会产生两条ibuf entry。

    
缓存条件

    
只有满足一定条件时，操作才会被缓存，所有对ibuf操作的判断，都从
btr_cur_search_to_nth_level
入口，该函数用于定位到btree上满足条件的记录，大概的判断条件如下：

    

      
用户设置了选项innodb_change_buffering；

      
只有叶子节点才会去考虑是否使用ibuf；

      
对于聚集索引，不可以缓存操作；

      
对于唯一二级索引(unique key)，由于索引记录具有唯一性，因此无法缓存插入操作，但可以缓存删除操作；

      
表上没有flush 操作，例如执行flush table for export时，不允许对表进行 ibuf 缓存 （通过
dict_table_t::quiesce
 进行标识）

    

    
参考函数：
ibuf_should_try
:

当满足ibuf缓存条件时，会使用两种模式去尝试获取数据页：

    

      
BUF_GET_IF_IN_POOL： 如果数据页在内存中，则获取page并返回，否则返回NULL；
BUF_GET_IF_IN_POOL_OR_WATCH：如果数据页在内存中，则获取page并返回，否则为请求的page设置一个`sentinel`(buf_pool_watch_set)，相当于标记这个page，表示这个page上的记录正在被purge。(下一小节介绍)

    

    
前者是前台用户线程触发，后者为purge线程在物理清除无效数据时触发，如果数据已经在内存中了，则不进行缓存。随后进入函数ibuf_insert，经过一系列的检查后（不可产生空page 和索引分裂、未超出最大ibuf size限制）执行操作缓存。

    
purge操作缓存

    
对于purge操作，当page不存在于内存时设置的sentinel是什么鬼？它是如何设置的，什么时候会被清理掉，这几个问题涉及到purge操作的缓存流程：

    

      

        
如何设置sentinel

当purge线程尝试读入page时，若数据页不在buffer pool中，则调用函数
buf_pool_watch_set
，分为两步：

        

          
Step1: 首先检查page hash，如果存在于page hash中：1）若未被设置成sentinel （别的线程将数据页读入内存时会清理掉对应标记），返回数据页；2）否则返回NULL；

          
Step2: 若page hash中不存在，则从
buf_pool_t::watch
数组中找到一个空闲的（状态为BUF_BLOCK_POOL_WATCH）page控制结构体对象buf_page_t，将其状态设置为BUF_BLOCK_ZIP_PAGE，初始化相关变量，并插入到page hash中。
buf_pool_t::watch
数组的大小为purge线程的个数，这意味着即使所有purge线程同时访问同一个buffer pool instance，总会拥有一个空闲的watch数组对象。

        

      

      

        
判断是否可以缓存purge操作

当设置sentinel并返回后，在决定缓存purge之前，需要去判断是否有别的线程对同一条记录缓存了新的操作，举个简单的例子：

        

          
Step 1: delete-mark X (sec index) //session 1

          
Step 2: insert X (clust index) //session 1

          
Step 3: delete X(sec index) //purge thread

          
Step 4: insert X (sec index) //session 1

        

        
如果二级索引页在内存中，那么Step 3 和Step4必然是有序的，因为需要获取block锁才能进行数据变更操作。但数据页不在内存时，就需要确保Step 4在Step 3之后执行。因此在缓存purge操作之前，需要根据当前要清理的记录，找到对应的聚集索引记录，并检查相比当前purge线程的readview是否有新版本的聚集索引记录（即有新的插入操作发生）。

        
如果检查到有新的插入，则本次purge操作直接放弃。因为当符合一定条件时，Step 4的操作可以直接把Step1产生的记录删除标记清除掉，重用物理空间。

        
参考函数：
row_purge_poss_sec
：

但是注意上述检查流程结束时，会在函数
row_purge_poss_sec
中将mtr提交掉，对应的聚集索引页的Latch会被释放掉，这意味着可能出现如下序列：

        

          
Step 1: delete-mark X；

          
Step 2: delete X，purge线程为其设置watch，并完成在函数
row_purge_poss_sec
中的检查，准备插入ibuf

          
Step 3: insert X，索引页不在内存，准备插入ibuf

        

        
在函数
ibuf_insert
中，针对IBUF_OP_INSERT和IBUF_OP_DELETE_MARK操作，会去检查是否对应的二级索引页被设置成sentinel（
buf_page_get_also_watch
），如果是的话，表明当前有一个pending的purge操作，目前的处理逻辑是放弃insert和delete-mark的缓存操作，转而读取物理页。

        
综上，如果purge操作先进入
ibuf_insert
，则对应二级索引页的watch必然被设置，insert操作将放弃缓存，转而尝试读入索引页；如果insert先进入
ibuf_insert
，则purge操作的缓存放弃。

        
即使Purge线程完成一系列检查，进入缓存阶段，这时候用户线程依旧可能会去读入物理页；有没有可能导致purge操作丢失呢 ？答案是否定的！因为purge线程在缓存操作时先将cursor定位到ibuf btree上，对应的ibuf page已将加上latch；而用户线程如果读入物理页，为了merge ibuf entry，也需要请求page latch；当purge线程在拿到latch后，会再检查一次看看物理页是否已读入内存（
buf_pool_watch_occurred
），如果是的话，则放弃本次缓存。

      

      

        
何时清理sentinel

有两种情况会清理sentinel：

        

          
第一种情况是purge操作完成缓存后（或者判断无法进行purge缓存）进行清理；

          
第二种情况是从磁盘读入文件块的时候，会调用
buf_page_init_for_read->buf_page_init
初始化一个page对象。这时候会做一个判断，如果将被读入的page被设置为sentinel(在watch数组中被设置)，则调用
buf_pool_watch_remove
将其从page hash中移除，对应
bp->watch
的数据元素被重置成空闲状态。

        

      

    

    
ibuf merge

    
有以下几种场景会触发ibuf merge操作：

    

      
用户线程选择二级索引进行数据查询，这时候必须要读入二级索引页，相应的ibuf entry需要merge到Page中。

      
当尝试缓存插入操作时，如果预估page的空间不足，可能导致索引分裂，则定位到尝试缓存的page no在ibuf btree中的位置，最多merge 8个(IBUF_MERGE_AREA) page，merge方式为异步，即发起异步读索引页请求。

参考函数：
ibuf_insert_low —> ibuf_get_merge_page_nos_func

      

        
若当前ibuf tree size 超过ibuf->max_size + 10（
IBUF_CONTRACT_DO_NOT_INSERT
）时，执行一次同步的ibuf merge（
ibuf_contract
），merge的page no为随机定位的cursor，最多一次merge 8个page，同时放弃本次缓存。

其中
ibuf->max_size
默认为25% * buffer pool size，百分比由参数
innodb_change_buffer_max_size
控制，可动态调整。

参考函数：
ibuf_insert_low —> ibuf_contract

      

      
若本次插入ibuf操作可能产生ibuf btree索引分裂（BTR_MODIFY_TREE）时:

当前ibuf->size max_size， 不做处理;

当前ibuf->size >= ibuf->max_size + 5 (IBUF_CONTRACT_ON_INSERT_SYNC)时，执行一次同步ibuf merge，位置随机;

当前Ibuf->size介于ibuf->max_size 和ibuf->max_size +5 之间时。执行一次异步ibuf merge，位置随机。

参考函数：
ibuf_insert_low —> ibuf_contract_after_insert

      

        
后台master线程发起merge

master线程有三种工作状态：

IDLE：实例处于空闲状态，以100%的io capacity来作merge操作：

        

          
 n_pages = PCT_IO(100);

        

        
相当于一次merge的page数等于innodb_io_capacity

参考函数：
srv_master_do_idle_tasks

        
ACTIVE：实例处于活跃状态，这时候会以如下算法计算需要merge的page数：

        

          
    /* By default we do a batch of 5% of the io_capacity */
    n_pages = PCT_IO(5);

    mutex_enter(&ibuf_mutex);

    /* If the ibuf->size is more than half the max_size
    then we make more agreesive contraction.
    +1 is to avoid division by zero. */
    if (ibuf->size > ibuf->max_size / 2) {
            ulint diff = ibuf->size - ibuf->max_size / 2;
            n_pages += PCT_IO((diff * 100)
                               / (ibuf->max_size + 1));
    }

    mutex_exit(&ibuf_mutex);

        

        
可见在系统active时，会以比较温和的方式去做merge，如果当前ibuf btree size超过最大值的一半，则尝试多做一些merge操作。

参考函数： 
srv_master_do_active_tasks

        
SHUTDOWN：当执行slow shutdown时，会强制做一次全部的ibuf merge

参考函数：
srv_master_do_shutdown_tasks

      

      

        
对某个表执行flush table 操作时，会触发对该表的强制ibuf merge，例如执行：

        

          
 flush table tbname for export;
 flush table tbname with read lock;

        

        
实际上强制ibuf merge主要是为flush for export准备的，当执行该命令后，为了保证能安全的将ibd拷贝到其他实例上， 需要对该表应用全部的ibuf 缓存。

参考函数：
row_quiesce_table_start

      

    

    
“著名” bug

    
在change buffer的应用史上，最著名的bug要属 
bug#61104
，其现象为当实例意外crash后，无法从崩溃中恢复，错误日志中报如下断言：

    

      
InnoDB: Failing assertion: page_get_n_recs(page) > 1

    

    
最初官方花了很长的时间都没有找到这个问题的root cause，只能加了一些代码逻辑避免不断crash重启，让用户有机会登录实例，重建二级索引。

    
后来Percona的开发人员Alexey Kopytov在
bug#66819
 提出了该问题的根本原因，指出ibuf entry的删除和merge 并不是一个原子的操作（即处于两个mtr事务中），当merge ibuf的mtr提交后crash，就可能在重启时重复做ibuf merge。如果上次执行DELETE操作导致对应索引页上记录数只剩下一条，第二次apply时认为本次操作会产生空页，从而导致断言错误。

    
官方很快根据Alexey的意见做了修复，修复方式也比较简单：

    

      
在第一个mtr里，merge ibuf entry 到二级索引页，并标记删除ibuf entry，提交mtr;

      
在第二个mtr里，执行真正的悲观删除ibuf entry;

      
在执行merge操作前，对于被delete mark的ibuf entry，不做merge操作。

    

    
具体的参考函数：
ibuf_merge_or_delete_for_page
 和 
ibuf_delete_rec
。

    
比较乌龙的是，我们发现第一次修复并没有处理purge线程产生的delete缓存；我们将该发现公布到社区，很快得到了响应，并由上游快速fix掉了，因此完整的补丁分布在两个版本中：

    

      
官方第一次fix(MySQL5.5.29)

      

      
官方第二次fix(MySQL5.5.31)

    

  

  

    

    

    
Test Book

  

  

    
导读：TokuDB在“云端”的优势

    
为了降低用户数据存储成本，2015年４月份，云数据库(Aliyun RDS)增加了TokuDB引擎支持(MySQL5.6版本)，也是第一家支持TokuDB的RDS。

    
我们知道，当一个实例的数据空间超过TB级别时，空间存储和运维成本都是非常高的，尤其是做实例迁移和备份，整个过程耗时会非常长。

    
我们对线上一些大的InnoDB实例(TB级)平滑迁移到TokuDB后，数据空间从 2TB+ 直接降到 400GB ，空间成本仅为原来的五分之一，而且读写性能没有任何降低(写性能反而提升不少)。通过线上几个大实例(TB级)的使用，TokuDB的压缩比均在５倍以上，同样的空间大小，使用TokuDB后可以存５倍的容量！

    
TokuDB的另外一个特点就是低IO消耗，相同数据量下，IO花销基本是InnoDB的1/8，IO成本也降低了不少，同样的IOPS限制下，TokuDB写性能会更高。因为IOPS消耗较少，RDS已经在线上部署TokuDB+廉价SATA盘集群，配合“方寸山”(分库分表proxy)来提供低成本高性能的PB级日志存储能力。

    
这个集群使用廉价的SATA盘(IOPS能力~120)，单台物理机基本可提供30,000 TPS的写能力(tokudb_fsync_log_period=0和sync_binlog=1，针对类如日志型应用，对数据安全性要求不是很高的话，调整tokudb_fsync_log_period=1000，sync_binlog=1000，性能会更高)，利用TokuDB的大页(page size 4MB)压缩优势，尤其是对日志内容，压缩比基本在1/8以上，单机可提供160TB+的的存储能力，整个集群可轻松支持PB级。

    
使用TokuDB，让你随便任性！

    
本篇来探讨下TokuDB内部的一个重要机制: checkpoint。

    
TokuDB的checkpoint只有一种方式：sharp checkpoint，即做checkpoint的时候，需要把内存中所有的”脏页”都刷回磁盘。本篇就来介绍下TokuDB的sharp checkpoint的一些具体细节，使看官们对TokuDB的checkpoint有个大概了解。

    
为什么要checkpoint

    
TokuDB引擎里，数据存在于3个地方：

    

      
Redo Log (disk)

      
Buffer Pool (memory)

      
Data File (disk)

    

    
为了性能，对“页”级的操作会先被Cache到Buffer Pool里，当触发某些条件后，才会把这些“脏页”刷到磁盘进行持久化，这样就带来一个问题：

对于TokuDB来说，整个Fractal-Tree元素有两部分的“页”组成：(Buffer Pool里的“页” ) + （Data File里已持久化的”页”），如果TokuDB crash后，Buffer Pool里的“页”丢失，只剩Data File的“页”，此时的Fractal-Tree处于“混沌“状态(不一致状态)。

    
为了避免出现这种“混沌“状态，TokuDB需要定期(默认60s)做Checkpoint操作，把Buffer Pool里的“脏页”刷到磁盘的Data File里。

    
当TokuDB Crash后，只需从上次的一致性状态点开始“回放” Redo Log里的日志即可，恢复的数据量大概就是60s内的数据，快吧？嗯。

    
TokuDB Checkpoint机制

    
TokuDB checkpoint分2个阶段：begin_checkpoint 和 end_checkpoint

    
大体逻辑如下：

    
begin_checkpoint：

    

      
C1, 拿到checkpoint锁
C2, 对buffer pool的page_list加read-lock
C3, 遍历page_list，对每个page设置checkpoint_pending flag
C4, 释放buffer pool page_list的读锁

    

    
end_checkpoint:

    

      
C5, 遍历page_list，对checkpoint_pending为true且为“脏”的page尝试获取write-lock
C6, 如果拿到write-lock，clone出来一份，释放write-lock，然后把clone的page刷回磁盘

    

    
以上就是整个checkpoint大概的逻辑，整个过程中，只有C6的任务最“繁重”，在这里面有几个“大活”：

    

      
clone的时候如果是leaf“页”，会对原“页”重做数据均分(leaf里包含多个大小均匀的子分区) –CPU消耗

      
刷盘前做大量压缩 –CPU消耗

      
多线程并发的把page刷到磁盘 –IO操作

    

    
以上3点会导致checkpoint的时候出现一点点的性能抖动，下面看组数据：

    

      
[ 250s] threads: 32, tps: 5095.80, reads/s: 71330.94, writes/s: 20380.38, response time: 8.14ms (95%)
[ 255s] threads: 32, tps: 4461.80, reads/s: 62470.82, writes/s: 17848.80, response time: 10.03ms (95%)
[ 260s] threads: 32, tps: 4968.79, reads/s: 69562.25, writes/s: 19873.96, response time: 8.49ms (95%)
[ 265s] threads: 32, tps: 5123.61, reads/s: 71738.31, writes/s: 20494.03, response time: 8.06ms (95%)
[ 270s] threads: 32, tps: 5119.00, reads/s: 71666.02, writes/s: 20475.61, response time: 8.11ms (95%)
[ 275s] threads: 32, tps: 5117.00, reads/s: 71624.40, writes/s: 20469.00, response time: 8.07ms (95%)
[ 280s] threads: 32, tps: 5117.39, reads/s: 71640.26, writes/s: 20471.56, response time: 8.08ms (95%)
[ 285s] threads: 32, tps: 5103.21, reads/s: 71457.54, writes/s: 20414.24, response time: 8.11ms (95%)
[ 290s] threads: 32, tps: 5115.80, reads/s: 71608.46, writes/s: 20461.42, response time: 8.11ms (95%)
[ 295s] threads: 32, tps: 5121.98, reads/s: 71708.73, writes/s: 20484.72, response time: 8.09ms (95%)
[ 300s] threads: 32, tps: 5115.01, reads/s: 71617.00, writes/s: 20462.46, response time: 8.08ms (95%)
[ 305s] threads: 32, tps: 5115.00, reads/s: 71611.76, writes/s: 20461.79, response time: 8.11ms (95%)
[ 310s] threads: 32, tps: 5100.01, reads/s: 71396.90, writes/s: 20398.03, response time: 8.13ms (95%)
[ 315s] threads: 32, tps: 4479.20, reads/s: 62723.81, writes/s: 17913.40, response time: 10.02ms (95%)
[ 320s] threads: 32, tps: 4964.80, reads/s: 69496.00, writes/s: 19863.60, response time: 8.63ms (95%)
[ 325s] threads: 32, tps: 5112.19, reads/s: 71567.45, writes/s: 20447.56, response time: 8.12ms (95%)

    

    
以上为sysbench测试数据(读写混合)，仅供参考，可以看到在[255s]和[315s]checkpoint的时候，性能有个抖动。

    
喵，另外一个问题来了：如果TokuDB在end_checkpoint C6的时候crash了呢，只有部分“脏页”被写到磁盘？此时的数据库(Fractal-Tree)状态岂不是不一致了？

    
TokuDB在这里使用了copy-on-write模型，本次checkpoint的“脏页”在刷到磁盘的时候，不会覆写上次checkpoint的文件区间，保证在整个checkpoint过程中出现crash，不会影响整个数据库的状态。

    
本篇只是大概介绍了TokuDB的checkpoint机制，还有非常多的细节，感兴趣的同学可阅读
ft/cachetable
代码。

  

  

    

    

    
Test Book

  

  

    
“时间线”（Timeline）是PG一个很有特色的概念，在备份恢复方面的文档里面时有出现。但针对这个概念的详细解释却很少，也让人不太好理解，我们在此仔细解析一下。

    
时间线的引入

    
为了理解引入时间线的背景，我们来分析一下，如果没有时间线，会有什么问题？先举个将数据库恢复到以前时间点的例子。假设在一个数据库的运行过程中，DBA在周三12:00AM删掉了一个关键的表，但是直到周五中午才发现这个问题。这个时候DBA拿出最初的数据库备份，加上存在归档目录的日志文件，将数据库恢复到周三11:00AM的时间点，这样就能正常启动和运行。但是，DBA后来意识到这样恢复是不对的，想恢复到周四8:00AM的数据，这时会发现无法做到：因为在数据库不断运行中，会产生与旧的WAL文件重名的文件，这些文件进入归档目录时，会覆盖原来的旧日志，导致恢复数据库需要的WAL文件丢失。为了避免这种情况，需要区分原始数据库历史生成的WAL文件和完成恢复之后继续运行产生的（重名的）新WAL文件。整个过程如图1所示：

    

    
为了解决这个问题，PostgreSQL引入了时间线的概念。每当归档文件恢复完成后，创建一个新的时间线用来区别新生成的WAL记录。WAL文件名由时间线和日志序号组成，源码实现如下：

    

      
#define XLogFileName(fname, tli, log, seg)  \
    snprintf(fname, XLOG_DATA_FNAME_LEN + 1, "%08X%08X%08X", tli, log, seg)

    

    
例如：

    

      
$ ls -1
00000002.history
00000003.history
00000003000000000000001A
00000003000000000000001B

    

    
时间线ID号是WAL文件名组成之一，因此一个新的时间线不会覆盖由以前的时间线生成的WAL。如图2所示，每个时间线类似一个分支，在当前时间线的操作不会对其他时间线WAL造成影响，有了时间线，我们就可以恢复到之前的任何时间点。

    

    
新时间线的出现场景

    
新的时间线会在什么情况下出现呢？

    

      

        
即时恢复(PITR)

配置recovery.conf文件：

        

          
 restore_command = 'cp /mnt/server/archivedir/%f %p' //从归档目录恢复日志
 recovery_target_time = '2015-7-16 12:00:00 ' //指定归档时间点，如没指定恢复到故障前的最后一完成的事务
 recovery_target_timeline = 'latest' //指定归档时间线，’latest’代表最新的时间线分支，如没指定恢复到故障前的pg_control里面的时间线
 standby_mode = ‘off’ //打开后将会以备库身份启动，而不是即时恢复

        

        
设置好recovery.conf文件后，启动数据库，将会产生新的timeline，而且会生成一个新的history文件。恢复的默认行为是沿着与当前基本备份相同的时间线恢复。如果你想恢复到某些时间线，你需要指定的recovery.conf目标时间线
recovery_target_timeline
，不能恢复到早于基本备份分支的时间点。

      

      

        
standby promote

搭建一个PG主备，然后停止主库，在备库机器执行：

        

          
 $ pg_ctl promote –D $PGDATA

        

        
这时候备库将会升为主备，同时产生一个新的timeline，同样生成一个新的history文件。

      

    

    
history文件

    
每次创建一个新的时间线，PostgreSQL都会创建一个“时间线历史”文件，文件名类似.history，它里面的内容是由原时间线history文件的内容再追加一条当前时间线切换记录。假设数据库恢复启动后，切换到新的时间线ID＝5，那么文件名就是00000005.history ，该文件记录了自己从什么时间哪个时间线什么原因分出来的，该文件可能含有多行记录，每个记录的内容格式如下：

    

      
 * <parentTLI> <switchpoint> <reason>
 *
 *      parentTLI       ID of the parent timeline
 *      switchpoint     XLogRecPtr of the WAL position where the switch happened
 *      reason          human-readable explanation of why the timeline was changed

    

    
例如：

    

      
$ cat 00000004.history
1   0/140000C8  no recovery target specified
2   0/19000060  no recovery target specified
3   0/1F000090  no recovery target specified

    

    
当数据库在从包含多个时间线的归档中恢复时，这些history文件允许系统选取正确的WAL文件，当然，它也能像WAL文件一样被归档到WAL归档目录里。历史文件只是很小的文本文件，所以保存它们的代价很小。

    
当我们在recovery.conf指定目标时间线tli进行恢复时，程序首先寻找.history文件，根据.history文件里面记录的时间线分支关系，找到从pg_control里面的startTLI到tli之间的所有时间线对应的日志文件，再进行恢复。

    
总结

    
PG中通过timeline机制能够方便地实现数据库恢复到任意时间点，这对我们数据库备份有重要的作用。我们可以在数据库的使用中合理地备份和归档我们的数据，一旦数据出现丢失或损坏，我们都能有条不紊的使用timeline机制恢复出来我们需要的数据。

  

  

    

    

    
Test Book

  

  

    
最近上线了一个O2O相关的应用，用到了PostgreSQL和非常著名的插件PostGIS，该应用把PostgreSQL和PostGIS的优势在O2O领域成功的发挥了出来。O2O业务分为线上和线下两部分，线下部分业务和位置距离等密切相关，不可避免的需要保存商户位置信息，进行距离的计算，范围覆盖计算等，这部分业务简称LBS（Location Based Service），即基于地理位置信息服务。使用PostgreSQL和PostGIS实现这些业务，具有天然的优势。

    
空间数据库扩展

    
由于空间数据具有空间位置、非结构化、空间关系、分类编码、海量数据等特征，一般的商用数据库管理系统本身难以满足要求，因此很多厂商都在其产品基础上，加入了空间方面的扩展。例如，支持空间扩展的产品有Oracle的Oracle Spatial，IBM的DB2 Spatial Extender，Informix 的Spatial DataBlade等。其优点是空间数据的管理与通用数据库系统融为一体，空间数据按对象存取，可在数据库内核中实现空间操作和处理，扩展SQL比较方便，较易实现数据共享与互操作；其缺点主要表现为，实现难度大，压缩数据比较困难，目前的功能和性能与第一类系统尚存在差距。

    
开源数据库方面，目前性能最优秀的数据库软件当属PostgreSQL数据库，而构建在其上的空间对象扩展模块PostGIS则使得其成为一个真正的大型空间数据库。

    
PostgreSQL和PostGIS

    
1986年，加州大学伯克利分校的 Michael Stonebraker 教授领导了Postgres的项目，它是PostgreSQL的前身。这个项目的成果非常显著，在现代数据库的许多方面都作出了大量的贡献，如在面向对象的数据库、部分索引技术、规则、过程和数据库扩展方面都取得了显著的成果。同时，Stonebraker将PostgreSQL纳入到BSD版权体系中，使得PostgreSQL在各种科研机构和一些公共服务组织得到了广泛的应用。

    
在PostgreSQL中已经定义了一些基本的集合实体类型，这些类型包括：点（POINT）、线（LINE）、线段（LSEG）、方形（BOX）、多边形（POLYGON）和圆（CIRCLE）等，另外PostgreSQL定义了一系列的函数和操作符来实现几何类型的操作和运算。同时PostgreSQL引入空间数据索引R-tree。

    
尽管在PostgreSQL提供了上述几项支持空间数据的特性，但其提供的空间特性很难达到GIS的要求，主要表现在：缺乏复杂的空间类型、没有提供空间分析、没有提供投影变换功能。为了使得PostgreSQL更好的提供空间信息服务，PostGIS应运而生。

    
PostGIS是PostgreSQL的一个扩展，PostGIS提供如下空间信息服务功能：空间对象、空间索引、空间操作函数和空间操作符，同时PostGIS遵循OpenGIS的规范。

    
O2O应用中空间计算需求

    
外卖应用短距离配送系统解决的是物流配送过程中最后一公里的问题。国家邮政局市场监管司预计，今年“双十一”期间快递总量将超过数亿件，最高日处理量可能突破7000万件。如此多的包裹堆积在城市物流的“最后一公里”上，让物流公司喘不过气来。商务部商业流通司司长王选庆说：“我国物流业在城际间的干线运输效率已经大大提高。现在真正的难题集中在城市配送的‘最后一公里’，配送难、配送贵的问题越来越突出。” 数据显示，末端配送成本已经占到物流行业总成本的30%以上。大量的社会资源消耗在“最后一公里”上，加重了城市的交通和环境压力，却未能带来配送效率的提高。短距离配送系统定位同城短距离配送业务，物流公司通过该平台获取同城内的物流配送订单，批量配送到距离该地约5公里内的目的地。典型业务模型如下：

1. 业务员查询自己负责范围内的订单信息，需求不规则多边形(自己负责的业务范围)的范围查询；

2. 业务员获取订单配送距离和推荐路线，需求点到点的距离计算、路径计算；

3. 相似路径的多个订单的批量配送，需求位置和大量传统数据符合运算；

4. 实时配送，位置跟踪。大量位置相关信息的存取，需要有较好的性能。

    
PostgreSQL+PostGIS解决方案

    
上述需求对应PostgreSQL 和PostGIS涉及到的数据类型和SQL用法有:

    

      

        
数据类型。几何对象的数据类型如下：

        

          
 POINT(0 0) ——点
 LINESTRING(0 0,1 1,1 2) ——线
 POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1, 2 1, 2 2, 1 2,1 1)) ——面
 MULTIPOINT(0 0,1 2) ——多点
 MULTILINESTRING((0 0,1 1,1 2),(2 3,3 2,5 4)) ——多线
 MULTIPOLYGON(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1))) ——多面
 GEOMETRYCOLLECTION(POINT(2 3),LINESTRING((2 3,3 4))) ——几何集合

        

      

      
距离计算函数：
ST_distance_sphere(point, point)

      
范围判定函数。判断A是否被B包含：
ST_Within(geometry A, geometry B)

      

        
更多几何运算：

        

          
  面积量测 ST_Area(geometry)
  获取两个几何对象相交的部分 ST_Intersection(geometry, geometry)
  判断两个几何对象的边缘是否接触 ST_Touches(geometry, geometry)
  判断两个几何对象是否互相穿过 ST_Crosses(geometry, geometry)
  判断两个几何对象是否是重叠 ST_Overlaps(geometry, geometry)
  判断A是否包含B ST_Contains(geometry A, geometry B)
  判断A是否覆盖 B ST_Covers(geometry A, geometry B)
  判断A是否被B所覆盖 ST_CoveredBy(geometry A, geometry B)

        

      

      

        
如果需要精确的计算结果，则要做坐标系转换，称为空间投影。例如，以两个空间点的位置，计算两点间的距离。计算结果的单位与你的空间数据的参考系有关。如果使用4326(wgs84)这个坐标系，则是以度为单位的，要想转成米为单位的话还得做一下转换。例如，GEOCS 代表的是地理坐标系，也就是以经纬度表示的坐标系统，例如编号为4326的坐标系统，PROJCS 代表的投影坐标系，它是通过一种算法把球面坐标系转成平面坐标系，以便计算，一般是以米为单位表示，例如编号为26986的坐标系统。在求两点之间的距离时，由于存的数据都是经纬度，因此它参考的是GEOCS，要想得到以米为单位的结果，首先要把它转成PROJCS，可以通过ST_Transform来实现。查看PostGIS手册，这个函数的原型如下：

        

          
 geometry ST_Transform(geometry g1, integer srid);

        

        
第一个参数是原来的几何对象，第二个参数为要把它转换到这个投影所代表的坐标系下。这时我们只要找一个单位是米的投影坐标系，用下面的方法转换过去就好了：

        

          
 SELECT ST_Distance(
        ST_Transform(ST_GeomFromText('POINT(-87.734087560562 43.770129071141)',4326),26986),
        ST_Transform(ST_GeomFromText('POINT(-87.747382933006 43.759234252055)', 4326),26986));

        

        
这个查出来的结果即是以米为单位的两点间的距离了。

      

      

        
空间索引。空间相关的数据支持创建GIST索引，这大大提高了这类数据查询的效率，使用下面的方法可以创建空间索引：

        

          
 CREATE INDEX shape_index_area
    ON sp_delivery_area.area
    USING gist(shape);

        

      

    

    
无论是数据类型还是各种几何运算，都和关系数据库PostgreSQL紧密结合，你可以在进行数据库事务操作的同时，进行空间运算，这让业务的开发异常的简单并且效率极高。

    
与其他方案的对比

    
这是典型的业务场景和 MongoDB 的性能对比:

    

    
基本上PostgreSQL的性能可以秒杀MongoDB。

    
在功能上，和MYSQL对比，PostGIS具有下列优势：

    

    
O2O业务场景中的LBS业务使用PostgreSQL + PostGIS有无法比拟的优势。

  

  

    

    

    
Test Book

  

  

    
前言

    
InnoDB并发过程中使用两类锁进行同步。

    
1. 事务锁

维护在不同的Isolation level下数据库的Atomicity和Consistency两大基本特性。

    
InnoDB定义了如下的lock mode:

    

      
/* Basic lock modes */
enum lock_mode {
LOCK_IS = 0,     /* intention shared */
LOCK_IX,     /* intention exclusive */
LOCK_S,          /* shared */
LOCK_X,          /* exclusive */
LOCK_AUTO_INC,     /* locks the auto-inc counter of a table
in an exclusive mode */
LOCK_NONE,     /* this is used elsewhere to note consistent read */
LOCK_NUM = LOCK_NONE, /* number of lock modes */
LOCK_NONE_UNSET = 255
};

    

    
2. 内存锁

为了维护内存结构的一致性，比如Dictionary cache、sync array、trx system等结构。

InnoDB并没有直接使用glibc提供的库，而是自己封装了两类：

1. 一类是mutex，实现内存结构的串行化访问

2. 一类是rw lock，实现读写阻塞，读读并发的访问的读写锁

    
读者如果有兴趣，可以直接翻阅InnoDB的代码，这里我们主要介绍index lock所使用的rw lock。

    
InnoDB index lock

    
InnoDB默认使用B-Tree结构来保存数据，如下图所示的B-Tree结构：

    
这个B-Tree一共有两类节点，一类是node(branch) block，一类是leaf block，对于内存中的每一个block，都有一个rw lock与之相对应，用于保护block内部结构的一致性，阻塞并发修改。每一个index在内存中保持着一个index字典对象，即
dict_index_t
，并对应着一个index lock，同样属于rw lock类型，用于保护B-Tree的平衡树结构。

    
所以，InnoDB为每一个index，维护两种rw lock:

1. index级别的，用于保护B-Tree结构不被破坏

2. block级别的，用于保护block内部结构不被破坏

    
很明显，rw lock 锁保护的对象的级别越高，冲突的可能性就越大，并发的瓶颈也就越容易出现。

    
InnoDB index lock的处理场景分析

    

      
我们先来看rw lock的模型，rw lock一共使用两类lock mode，即S锁和X锁，其相容性矩阵是：

    

    

      
  | S| X|
--+--+--+
S | o| x|
--+--+--+
X | x| x|
--+--+--+

    

    
按照lock mode，数据库对B-Tree操作区分几种类型:

    

      
btr_search_leaf
btr_modify_leaf
btr_modify_tree
btr_search_prev
btr_modify_prev

    

    
根据这些不同的操作类型，我们下面来分析一下加锁的过程。

    
场景分析

    
场景1. 索引扫描查询

    
如果sql通过索引进行扫描，其latch mode为
btr_search_leaf
:

    
首先是hold住index lock的RW_S_LATCH，然后通过
btr_cur_search_to_nth_level
进行B-Tree查询leaf节点的过程。当cursor定位到leaf节点上之后，在leaf page节点上，添加RW_S_LATCH锁，即S锁，然后通过save_point的mtr释放index lock的S锁。在扫描的过程中，因为持有index的RW_S_LATCH，所以节点的扫描比如root、branch这样的node block，并不持有任何mode的rw lock。直到latch住leaf节点后，就释放掉 index 的锁，这样尽可能的减少阻塞，剩下就是leaf节点的扫描过程，只持有leaf page的锁。 扫描完数据，就释放leaf page的S锁。

    
场景2. 升序和降序查询

    
场景2和场景1在持有index lock的过程中，是相同的，都是在search的过程中，持有RW_S_LATCH，一旦定位到leaf page，就释放掉index 的S锁，升序和降序的扫描过程中，会沿着leaf page之间的双链表进行扫描，因为是双向链表，所以可以完成asc和desc的扫描。但这里要注意的是，InnoDB先持有下一个page的lock，然后再释放当前持有page的lock，这样就有可能造成死锁，所以InnoDB不管当前是asc还是desc的扫描，都会先持有左leaf page的lock，然后再持有下一个leaf page的锁，最后释放prev page的lock，这样做到加锁的顺序一致，避免死锁。

    
场景3. 乐观插入记录

    
InnoDB在插入记录的过程中，分了两个步骤，乐观插入和悲观插入：

1. 乐观，就是当前leaf page的剩余空间满足记录的插入需要；

2. 悲观，就是需要split B-Tree，增加leaf page来完成新记录的插入。

    
先看乐观插入:

场景1和场景2都持有leaf page的RW_S_LATCH，但在插入的过程中，操作类型是btr_modify_leaf，需要持有leaf page的RW_X_LATCH， 在search的过程中，和场景1、2相同，都是持有index的RW_S_LATCH lock，一旦定位结束，释放index lock。

    
场景4. 悲观插入记录

    
悲观插入，需要split B-Tree，所以首先会持有index lock，mode为RW_X_LATCH，并X lock三个leaf page，即prev，current，next三个leaf page，然后修改branch节点的记录，指向leaf节点，修改完成后，才能释放index lock。

在split的过程中，无法进行search操作(因为正在修改branch节点)，但如果其他线程已经在读取leaf page，并不会受影响。

    
场景5. online DDL

    
在online DDL的过程中，比如add index，因为是新添加的index，并不会产生并发访问的问题。

    
场景6. DDL

    
比如加字段的过程，其并发问题，由server层的MDL锁和InnoDB层的事务锁来完成其同步。

    
问题：

    
我们来看上面提到的6个场景，对我们日常使用InnoDB的过程中，影响最大的就是场景4，即split的过程中，会严重的影响并发，因为index 的X lock，导致任何的B-Tree扫描都产生了阻塞。有解吗？

    
通常我们碰到lock导致的并发问题的时候，第一个想到的就是降低锁对象的粒度，粒度越小，共享区域也就越小，冲突的几率也就越小，并发就能够提高。

    
根据这个原则，我们回过头来看这个问题，因为index lock 保护了整个B-Tree的结构，但我们对某一个branch节点进行split的时候，我们仅仅修改了这个branch节点，所以我们可以把锁的粒度降低到某些要修改的branch节点上，这样就可以不影响其他branch节点的扫描和访问。

    
MySQL 5.7的改进

    
MySQL官方对index lock进行了优化，在split的过程中，尽可能的减少冲突，减少并发的瓶颈。

    
对于InnoDB的rw lock增加第三种lock mode，即SX锁，其相容性矩阵如下：

    

      
  | S|SX| X|
--+--+--+--+
S | o| o| x|
--+--+--+--+
SX| o| x| x|
--+--+--+--+
X | x| x| x|
--+--+--+--+

    

    
这里仍然保留了index lock，考虑一下两个存在冲突的场景，还是否阻塞：

    
1. BTR_SEARCH_LEAF和BTR_MODIFY_LEAF

    
对于扫描leaf节点和修改leaf节点的场景：

    

      
index->lock 持有S锁不变
branch->latch 从无--> S latch
   latch order:
       latch root block (S)
       latch root-1 block (S)
       ....
       latch leaf+1 block (S)
leaf->latch 持有S或者X锁不变
release index lock 不变
release branch latch 从无到释放

    

    
和之前的差别是在search的过程中，对使用到的branch节点，加上S锁，用于同步branch节点的修改。同样，当定位到leaf节点后，就可以把index lock和branch lock全部释放掉了，后面leaf节点之间的移动，同样不需要index lock和branch lock。

    
2. BTR_MODIFY_TREE

    
对于修改index B-Tree结构的场景：

    

      
index->lock 从X锁-->SX 锁
branch->latch 从无--> X latch

    

    
注意：因为有index SX锁，所以不允许并发的修改B-Tree操作，所以，只需要X latch要修改的branch即可。

    
和之前的差别就是index lock从X锁变成了SX锁，这样并不影响search的过程，增加了更改过程中branch节点的X锁。

    
总结：

    
这样修改后，index lock在并发的过程中，修改B-Tree和search B-Tree没有了并发冲突问题，在split的过程中，只有search和modify到同一个branch节点，才会产生阻塞，对于我们正常的使用数据库过程中（大部分都是通过index进行读写），可以显著的提升并发能力。

  

  

    

    

    
Test Book

  

  

    
NUMA 问题曾经一直是困扰DBA的一个大问题，早在 2010 年, 就有人给MySQL报了Bug#
57241
, 指出了MySQL在x86系统下存在严重的 “swap insanity” 问题。在NUMA架构越来越普遍的今天，这个问题越来越严重。

    
MySQL的 swap insanity 问题

    
有同学专门翻译了Jeremy Cole关于 “swap insanity” 问题的
文章
，原文看
这里
，

    
如果你没空看的话，这里简单描述一下，就是当你把主机大部分内存分配给InnoDB时，你会发现明明操作系统还有很多内存，但是却有很多内存被交换到了SWAP分区。

    
从
这里
可以下载到一个测试的C代码，如果你有NUMA架构的服务器，可以测试下不同分配方式的性能差异：

    

      
sudo -s
echo 2048 > /proc/sys/vm/nr_hugepages
echo 1000000000000 > /proc/sys/kernel/shmmax

# Node local allocation
for i in `seq 0 4 127`
do
./latency2001 -a $i -c $i -l 128M
done

# Allocate on memory on CPU 0
for i in `seq 0 4 127`
do
./latency2001 -a 0 -c $i -l 128M
done

    

    
有两个方式可以解决这个问题：

1. 在Linux Kernel启动参数中加上numa=off（这样也会影响到其他进程使用NUMA）；

2. 在mysqld_safe脚本中加上“numactl –interleave all”来启动mysqld。

    
当然如果跑多实例，我也用过直接绑定mysqld进程到某个numa节点的方式，不过这要求每个实例分配的内存不超过每个NUMA节点管理的内存。脚本可以看
这里
。

    
5年过去了，官方依然没有解决这个Bug。但好消息是，官方终于着手解决这个问题了，Stewart Smith 同学提交的Bug#
72811
，其Patch即将出现在MySQL 5.6.27, 5.7.9 版本之中。

    
代码层面解决NUMA问题

    
如果在代码层面彻底解决NUMA问题，那么我们需要解决两个问题：

1. 全局内存应该采用interleave的分配方式分散在不同的numa node上；

2. 线程内存应该采用local的分配方式分配在线程运行的numa node上。

    
Linux 提供了 
set_mempolicy()
 函数可以用来设置进程的内存分配策略，其中默认的MPOL_DEFAULT策略就是在当前运行的节点上分配内存，而MPOL_INTERLEAVE策略则是跨所有节点来分配内存。这个函数的说明可以看
这里
。

    
因此对于MySQL Server和InnoDB引擎都需要做修改：

1. 在
mysqld_main()
入口设置 
set_mempolicy(MPOL_INTERLEAVE, NULL, 0)
 启用全局分配方式；

2. 在MySQL启动完成之后设置
set_mempolicy(MPOL_DEFAULT, NULL, 0)
 启用本地分配方式；

3. 在InnoDB入口时设置 
set_mempolicy(MPOL_INTERLEAVE, NULL, 0)
 启用全局分配方式；

4. 在Buffer Pool分配完成时设置 
set_mempolicy(MPOL_DEFAULT, NULL, 0)
 启用本地分配方式。

    
MySQL 5.6.27, 5.7.9 发布之后，将会增加一个 
innodb_numa_interleave
 参数来控制这个策略。
innodb_numa_interleave
 如果打开，那么将会按上面的策略来设置内存分配方式，如果关闭或者主机不支持NUMA，那么还是按原来的方式分配。

    
我们一起期待新版本的发布吧，妈妈再也不用担心我的NUMA了！

  

  

    

    

    
Test Book

  

  

    
背景

    
你是否曾为
Error on rename of './test/#sql-78fd_780371' to './test/t2' (errno: 150)
这样的错误而不解，如stackoverflow上的这个
问题
？

    
下面我们来复现下：

    

      
drop table t2;
drop table t1;

create table t1(c1 int primary key, c2 int);
create table t2(c1 int primary key, c2 int , constraint fk foreign key (c2) references t1(c1)) engine=innodb;

//删外键所引用的列
alter table t2 drop c2;
//删不存在的外键
alter table t2 drop foreign key idx1;

    

    
5.5的表现

    

      
mysql>  alter table t2 drop c2;
ERROR 1025 (HY000): Error on rename of './test/#sql-78fd_780371' to './test/t2' (errno: 150)
mysql> alter table t2 drop foreign key  idx1;
ERROR 1025 (HY000): Error on rename of './test/t2' to './test/#sql2-78fd-780371' (errno: 152)

    

    
5.6的表现

    

      
mysql>  alter table t2 drop c2;
ERROR 1553 (HY000): Cannot drop index 'fk': needed in a foreign key constraint
mysql> alter table t2 drop foreign key  idx1;
ERROR 1091 (42000): Can't DROP 'idx1'; check that column/key exists

    

    
很明显5.6的报错信息更精确些，5.5的报错太不人性化了，容易造成误解。

    
它们差别在于5.6的报错处理在语义分析阶段，精准的定位了错误信息。

    

      
 mysql_alter_table
    |=>mysql_inplace_alter_table
    |==>ha_innobase::prepare_inplace_alter_table
    |===>innobase_check_foreign_key_index

    

    
而5.5的报错处理在执行阶段。

    
我们先来看看5.5的执行流程：

    

      
 mysql_alter_table
    |=>mysql_create_table_no_lock //创建临时表tmp_table1,其结构和原表类似,但不包括外键信息
    |==>rea_create_table
    |=>copy_data_between_tables //将原表数据copy到tmp_table1
    |=>mysql_rename_table //将原表重命名tmp_table2,但不重命名外键涉及的表信息
    |==> row_rename_table_for_mysql //修改字典表
    |=>mysql_rename_table //将临时表tmp_table1重命名回原表
    |==>row_rename_table_for_mysql //修改字典表
    |===>dict_load_foreigns //这里通过从数据字段加载外键信息来检查外键索引是否存在,外键索引列是否一致.

    

    

dict_load_foreigns
：这个函数由于承担的责任太多，只要发现错误，就笼统的抛出
Error on rename of 'xxxx' to 'xxxx' (errno: xxx)
的错误.

    
外键bug

    
我们来看一个外键相关的
bug77467
。

    

      
Alter table reply
    change blogId topicId int(11) NOT NULL,
    drop index userId,
    drop foreign key reply_ibfk_2;

    

    
bug中这个DDL虽然执行失败了，但实际上foreign key reply_ibfk_2被删除了。这个bug在单机环境下影响不大，但在主备环境下由于DDL执行失败并没有记binlog，从而导致主备表结构不一致。这个bug只出现在5.6以前的版本中，5.6是OK的

    
bug分析

    
我们来看看5.5的流程：

    

      
mysql_alter_table
    |=>mysql_create_table_no_lock //创建临时表tmp_table1,其结构和原表类似,但不包括外键信息
    |==>rea_create_table
    |=>copy_data_between_tables //将原表数据copy到tmp_table1
    |=>mysql_rename_table //将原表重命名tmp_table2,但不重命名外键涉及的表信息,同时删除原表的外键reply_ibfk_2
    |==> row_rename_table_for_mysql //修改字典表
    |=>mysql_rename_table //将临时表tmp_table1重命名回原表
    |==>row_rename_table_for_mysql //修改字典表
    |===>dict_load_foreigns //这里通过从数据字段加载外键信息来检查外键索引是否存在,外键索引列是否一致.检查发现index userId不存在,出现错误
    |===>trx_rollback_to_savepoint //出现错误回滚之前的修改

    

    
出错回滚之前的修改，预期是回滚删除外键reply_ibfk_2，但是删除外键reply_ibfk_2操作在第一次
mysql_rename_table
中，属于一个事务，而回滚操作在第二次
mysql_rename_table
中，属于另一个事务，因此回滚没有成功。

    
那么5.6为什么没有出现这种错误呢？5.6在语义分析的时候就发现错误，还没来得及删外键就已经报错返回了。

    
bug修复

    
5.5修复方法，将删外键的操作放到第二次
mysql_rename_table
中进行，如果出现错误就可以顺利的回滚了。当然，还是5.6的做法比较好。

  

  

    

    

    
Test Book

  

  

    
背景

    
之前的月报中我们比较了InnoDB linear read-ahead和Oracle的multiblock read，两个的性能有所差别，具体可以参考
月报详情
。

这两种方式之所以带来了更高的吞吐量，都基于数据存储的连续性的假设，比如MySQL使用自增字段作为pk的InnoDB索引表，或者是Oracle使用默认的堆表，但当这样的假设条件不成立的时候，怎么办？

    
场景

    
考虑下面的一个场景，如下图所示：

    

    
这是一个B-Tree结构，典型的InnoDB的索引聚簇表，这样的结构很容易构造，比如使用一个非连续的字段作为索引字段，随机对记录进行插入，这样leaf page链表上的page_no就会产生非连续性，如果进行一次全表扫描，比如 
checksum table t
，按照正常的升序扫描，leaf page扫描的page_no顺序是3, 4, 5230等等，这样其实是无法使用到InnoDB 的Linear read-ahead，更没有办法合并IO请求。

    
对于存在时间比较长，变更又比较多的大表，除非我们对于这个表进行重建，否则leaf page的离散性会随着时间的推移，越来越严重。但对于在线应用来说，重建又会产生比较大的运维风险，这里就介绍一种平衡的方法，logical read-ahead。

    
logical read-ahead

    
逻辑预读的概念是指，根据branch节点来预读leaf节点。

    
逻辑预读使用两个扫描路径:

1. 一个cursor定位到leaf page，然后根据leaf page之间的双链表，moves_up进行扫描数据；

2. 另一个cursor定位到branch节点，因为InnoDB B-Tree结构的每一层都由双向链表进行连接，然后这个cursor就沿着branch节点进行扫描，保存扫描到的page_no，然后使用异步IO，发起这些leaf page的预读取。

    
代码实现

    
MySQL 5.6版本上的实现方式:

1. 在
row_search_for_mysql
进行moves_up的过程中进行logical read-ahead；

2. branch节点扫描的cursor保存到trx结构中，生命周期到一个sql语句结束；

3. branch cursor扫描用户可配置的page count，临时保存到数组中，对page_no进行排序；

4. 使用libaio发起异步IO读取，完成logical read-ahead。

    
logical read-ahead很好的提升了离散存储数据的吞吐能力，Facebook在他们的MySQL实例的逻辑备份过程中，对于大表的dump备份开启了此特性，备份速度有非常大的提升。

  

  

    

    

    
Test Book

  

  

    
binlog拉取存在的问题

    
MySQL 主备之间数据同步是通过binlog进行的，当主库更新产生binlog时，备库需要同步主库的数据，通过binlog协议从主库拉取binlog进行数据同步，以达到主备数据一致性的目的。但当主库tps较高时会产生大量的binlog，以致备库拉取主库产生的binlog时占用较多的网络带宽，引起以下问题：

    

      
在MySQL中，写入与读取binlog使用的是同一把锁(Lock_log)，频繁的读取binlog，会加剧Lock_log冲突，影响主库执行，进而造成TPS降低或抖动；

      
当备库数量较多时，备库拉取binlog会占用过多的带宽，影响应用的响应时间。

    

    
为了解决上面提到的问题，需要对binlog的拉取速度进行限制。

    
问题存在的原因

    
备库或应用通过binlog协议向主库发送消息，告诉主库要拉取binlog，主库经过权限认证后，以binlog_event为单位读取在本地的binlog，然后将这些binlog_event发送给应用，其过程简单描述如下：

    

      
从mysql-bin.index中找到用户消息中的指定文件，如果没有指定要拉取的binlog文件名称，则用第一个；

      
上Lock_log锁，从1)或4) 中的binlog file中读取一个binlog_event，释放Lock_log锁，判断binlog_event的类型；

      
如果是普通binlog_event，则将binlog_event发送到net 缓冲区；

      
如果是Rotate_log_event，则取出要Rotate到的文件，执行2)；

      
如果当前读的文件是最后一个文件且已经读到了文件的结尾，则会释放Lock_log锁，并等待新的Log_event信号。

    

    
从以上过程可以看出，binlog的发送速度和IO、网络有很大的关系，只要这三者不受限制，程序会就尽力发送binlog而没有限制。

    
解决问题的方法

    
由3、4可以看出，程序在读取和发送之间是没有其它工作的，如果IO很强，读取的速度很快，那么binlog的发送速度就会很快且不受限制，进而造成本文开始所描述的问题；针对binlog发送速度的问题，rds_mysql 通过设置binlog发送线程的发送频率、休眠时间来调整binlog的发送速度，因此 rds_mysql 引入了两个新的参数：

1. binlog_send_idle_period binlog发送线程的每次休眠时间，单位微秒，默认值100；

2. binlog_send_limit_users binlog发送线程的速度配置，默认值”“。

    
举例如下：

set global binlog_send_limit_users=”rep1:3,rep2:10” 的作用是设置rep1拉取binlog的上限速度是3M/s, rep2拉取binlog的上限速度是10M/s，其中rep2、rep2指的是应用连接的用户名，对于binlog的拉取速度控制主要分为两个方面：

    
binlog 发送速度监控线程

    
速度监控线程随着mysqld的启动而启动，用于定时扫描限速列表，计算列表中的每一个binlog dump线程的binlog发送速度，并根据计算的速度调整binlog的发送频率，其工作过程描述如下：

    

      
速度监控线程随着mysqld的启动而启动，并初始化限速列表；

      
对限速列表进行依次扫描，如果取到的线程不为空，转2);

      
计算当前线程的发送速度，与用户设定的速度进行比较，大于设定的发送速度，转3)，如果小于用户设定的发送速度，则转4)

      
通过调整当前线程的net_thread_frequency 成员，降低发送频率；

      
通过调整当前线程的net_thread_frequency 成员，增加发送频率；

      
遍历完限速列表后让出CPU 1毫秒，转1)

    

    
由以上描述可以看出，监控线程每毫秒执行一次，根据发送的字节数来计算binlog发送线程的发送速度是否超过设定的速度，并通过调整发送频率来调整binlog的发送速度，监控线程的限速列表是这样构造的：

    

      
binlog dump 线程在拉取binlog前会先根据连接的用户名判断是否应该对该用户限速，如果需要限速，则需要将当前dump线程加入限速列表；

      
当binlog dump结束或断开连接时，从限速列表移除；

      
当设置参数binlog_send_limit_users时，会对当前所有线程进行遍历，将被限制的用户加入限速列表，对不受限制的用户移出限制列表，所有受影响的线程不需要重新连接，可以实时生效。

    

    
binlog dump 线程

    
dump 线程用于发送binlog，在发送过程中会根据监控线程设置的发送频率来调整binlog发送的速度，可以分为以下几步：

1. binlog dump 线程在拉取binlog前会先根据连接的用户名判断是否将本用户的线程加入限速列表；

2. 读取binlog，并查看是否需要休眠，需要休眠转3)，否则转4)；

3. 休眠binlog_send_idle_period；

4. 发送读取到的binlog event，转2。

    
因此可以通过设置binlog的发送频率及休眠时间精确调整binlog的发送速度

  

  

    

    

    
Test Book

  

  

    
背景

    
我们打开MySQL客户端，执行下面的SQL语句：

    

      
drop table if exists t;
create table t(id double)engine=innodb;
insert into t values(1e-15),(1e-16);
select * from t;

    

    

select * from t
出来的内容如下，我们看到浮点数1e-15用正常的数值来表示，1e-16用科学技术法来表示。

    

      
+-------------------+
| id                |
+-------------------+
| 0.000000000000001 |
|             1e-16 |
+-------------------+

    

    
我们知道在计算机中浮点数用来近似表示某个实数。浮点数有2种显示风格，一种是正常的表示（0.18, 2.345等），一种是科学技术法的表示（1.23e+12，2.45e-16等）。那么MySQL的浮点型在什么情况下表示成正常的实数（如0.18，2.345），什么情况下表示成科学计数法（如1.23e+12，2.45e-16）呢？下面我们进行更精确的实验以及从源码角度来解释MySQL对于浮点数的显示问题。

    
实验

    
我们用下面的SQL语句直接显示多个浮点数:

    

      
select (1e+14),(1e+15),(2.3e+14),(2.3e+15),(1e-15),(1e-16),(3.4e-15),(3.4e-16);

    

    
select出来的内容是：

    

      
+-----------------+-------+-----------------+---------+-------------------+-------+--------------------+---------+
| 1e+14           | 1e+15 | 2.3e+14         | 2.3e+15 | 1e-15             | 1e-16 | 3.4e-15            | 3.4e-16 |
+-----------------+-------+-----------------+---------+-------------------+-------+--------------------+---------+
| 100000000000000 |  1e15 | 230000000000000 |  2.3e15 | 0.000000000000001 | 1e-16 | 0.0000000000000034 | 3.4e-16 |
+-----------------+-------+-----------------+---------+-------------------+-------+--------------------+---------+

    

    
通过以上的例子再结合更多的实验我们可以看出这么一个规律：

    

      
在数值大于0时，科学计数法表示的指数小于或等于14时，select出来的是正常非科学计数法的数值；

      
在数值大于0时，科学计数法表示的指数大于14时，select出来的是科学计数法的数值；

      
当数值小于0时，科学计数法表示的指数大于或等于-15时，select出来的是正常非科学计数法的数值；

      
当数值小于0时，科学计数法表示的指数小于-15时，select出来的是科学计数法的数值。

    

    
另外由于上面的select并没有来自某个具体表，所以浮点数展示的规则是和存储引擎没有关系的，MySQL对于浮点数展示包装的逻辑是在server层完成的。

    
我们去代码里验证一下这个规律是否正确。

    
验证

    
我们可以用gdb跟到代码里面寻找这块逻辑，但是MySQL单单server层的代码也有好几万行，盲目的跟代码并不能很快的找到我们要找的位置。所以，跟代码前我们很有必要先分析一下这块逻辑会出现在什么位置。

    
我们知道MySQL对select的处理的大体过程是，客户端向服务端发送select，服务端解析select并把结果返回到客户端，那么这块逻辑就很有可能出现在服务端把结果送到客户端这个过程中。

    
最后通过跟踪代码我们发现了在MySQL将结果返回客户端的过程中，在下面这个位置的
buffer->set_real
对要显示的内容进行了包装，并把包装的结果放到buffer这个变量里。

    

      
sql/protocol.cc:
bool Protocol_text::store(double from, uint32 decimals, String *buffer)
{
#ifndef DBUG_OFF
  DBUG_ASSERT(field_types == 0 ||
          field_types[field_pos] == MYSQL_TYPE_DOUBLE);
  field_pos++;
#endif
  buffer->set_real(from, decimals, thd->charset());
  return net_store_data((uchar*) buffer->ptr(), buffer->length());
}

    

    
在对set_real往更深的调用层次跟踪，我们找到了对浮点数的展示进行包装的位置：

    

      
strings/dtoa.c:
...
size_t my_gcvt(double x, my_gcvt_arg_type type, int width, char *to,
               my_bool *error)
...

    

    
通过分析
my_gcvt
这个函数，我们可以得出MySQL对于浮点数展示的规则。

    
首先我们必须知道以下这个事实（下面’f’format表示正常格式，’e’format表示科学计数法的格式）：

MySQL对select出来的每一列占用的宽度是有要求的，如果浮点数在’f’format下的有效数字太多，就有可能超过最大宽度，这时若还想要用’f’format，就不得不丢失一些有效数字了。如果同样数值的’e’format不会丢失有效数字，MySQL就会把该浮点数从’f’format转为’e’format。

    
下面的这个if语句确定了用’f’format表示浮点数的条件。

    

      
strings/dtoa.c -> function my_gcvt

if ((have_space ||
    /*
      Not enough space, let's see if the 'f' format provides the most number
      of significant digits.
    */
     ((decpt <= width && (decpt >= -1 || (decpt == -2 &&
                                            (len > 1 || !force_e_format)))) &&
       !force_e_format)) &&

     /*
       Use the 'e' format in some cases even if we have enough space for the
       'f' one. See comment for MAX_DECPT_FOR_F_FORMAT.
     */
    (!have_space || (decpt >= -MAX_DECPT_FOR_F_FORMAT + 1 &&
                     (decpt <= MAX_DECPT_FOR_F_FORMAT || len > decpt))))

    

    
代码有点乱，但是通过看注释以及上下文，我们可以分析出用’f’format表示浮点数必须同时满足2个条件：

1. 用’f’format表示浮点数不会因为宽度限制造成精度丢失；

2. 浮点数用若用’e’format表示时的指数在一个临界值范围（-15,14）内，那么就用’f’format表示。

    
在前面的实验中，我们给出的几个浮点数若用’f’format并不会超过列的最大宽度，即满足条件1。那么这几个浮点数用’f’format还是’e’format表示就由条件2决定了，条件2和我们在实验中看到的规律相符。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · InnoDB 崩溃恢复过程

        

      

      

        

          
MySQL · 捉虫动态 · 唯一键约束失效

        

      

      

        

          
MySQL · 捉虫动态 · ALTER IGNORE TABLE导致主备不一致

        

      

      

        

          
MySQL · 答疑解惑 · MySQL Sort 分页

        

      

      

        

          
MySQL · 答疑解惑 · binlog event 中的 error code

        

      

      

        

          
PgSQL · 功能分析 · Listen/Notify 功能

        

      

      

        

          
MySQL · 捉虫动态 · 任性的 normal shutdown

        

      

      

        

          
PgSQL · 追根究底 · WAL日志空间的意外增长

        

      

      

        

          
MySQL · 社区动态 · MariaDB Role 体系

        

      

      

        

          
MySQL · TokuDB · TokuDB数据文件大小计算

        

      

    

  

  

    

    

    
Test Book

  

  

    
在前面两期月报中，我们详细介绍了 InnoDB redo log 和 undo log 的相关知识，本文将介绍 InnoDB 在崩溃恢复时的主要流程。

    
本文代码分析基于 MySQL 5.7.7-RC 版本，函数入口为 
innobase_start_or_create_for_mysql
，这是一个非常冗长的函数，本文只涉及和崩溃恢复相关的代码。

    
在阅读本文前，强烈建议翻阅我们之前的两期月报：

1. 
MySQL · 引擎特性 · InnoDB undo log 漫游

2. 
MySQL · 引擎特性 · InnoDB redo log漫游

    
初始化崩溃恢复

    
首先初始化崩溃恢复所需要的内存对象：

    

      
        recv_sys_create();
        recv_sys_init(buf_pool_get_curr_size());

    

    
当InnoDB正常shutdown，在flush redo log 和脏页后，会做一次完全同步的checkpoint，并将checkpoint的LSN写到ibdata的第一个page中（
fil_write_flushed_lsn
）。

    
在重启实例时，会打开系统表空间ibdata，并读取存储在其中的LSN：

    

      
        err = srv_sys_space.open_or_create(
        false, &sum_of_new_sizes, &flushed_lsn);

    

    
上述调用将从ibdata中读取的LSN存储到变量flushed_lsn中，表示上次shutdown时的checkpoint点，在后面做崩溃恢复时会用到。另外这里也会将double write buffer内存储的page载入到内存中(
buf_dblwr_init_or_load_pages
)，如果ibdata的第一个page损坏了，就从dblwr中恢复出来。

    

      
Tips：注意在MySQL 5.6.16之前的版本中，如果InnoDB的表空间第一个page损坏了，就认为无法确定这个表空间的space id，也就无法决定使用dblwr中的哪个page来进行恢复，InnoDB将崩溃恢复失败(bug#70087)，

由于每个数据页上都存储着表空间id，因此后面将这里的逻辑修改成往后多读几个page，并尝试不同的page size，直到找到一个完好的数据页， (参考函数
Datafile::find_space_id()
)。因此为了能安全的使用double write buffer保护数据，建议使用5.6.16及之后的MySQL版本。

    

    
恢复truncate操作

    
为了保证对 undo log 独立表空间和用户独立表空间进行 truncate 操作的原子性，InnoDB 采用文件日志的方式为每个 truncate 操作创建一个独特的文件，如果在重启时这个文件存在，说明上次 truncate 操作还没完成实例就崩溃了，在重启时，我们需要继续完成truncate操作。

    
这一块的崩溃恢复是独立于redo log系统之外的。

    
对于 undo log 表空间恢复，在初始化 undo 子系统时完成：

    

      
err = srv_undo_tablespaces_init(
        create_new_db,
        srv_undo_tablespaces,
        &srv_undo_tablespaces_open);

    

    
对于用户表空间，扫描数据目录，找到 truncate 日志文件：如果文件中没有任何数据，表示truncate还没开始；如果文件中已经写了一个MAGIC NUM，表示truncate操作已经完成了；这两种情况都不需要处理。

    

      
err = TruncateLogParser::scan_and_parse(srv_log_group_home_dir);

    

    
但对用户表空间truncate操作的恢复是redo log apply完成后才进行的，这主要是因为恢复truncate可能涉及到系统表的更新操作（例如重建索引），需要在redo apply完成后才能进行。

    
进入redo崩溃恢复开始逻辑

    
入口函数：

c err = recv_recovery_from_checkpoint_start(flushed_lsn);

    
传递的参数flushed_lsn即为从ibdata第一个page读取的LSN，主要包含以下几步：

    
Step 1: 为每个buffer pool instance创建一棵红黑树，指向
buffer_pool_t::flush_rbt
，主要用于加速插入flush list (
buf_flush_init_flush_rbt
)；

Step 2: 读取存储在第一个redo log文件头的CHECKPOINT LSN，并根据该LSN定位到redo日志文件中对应的位置，从该checkpoint点开始扫描。

    
在这里会调用三次
recv_group_scan_log_recs
扫描redo log文件：

    
1. 第一次的目的是找到MLOG_CHECKPOINT日志

    
MLOG_CHECKPOINT 日志中记录了CHECKPOINT LSN，当该日志中记录的LSN和日志头中记录的CHECKPOINT LSN相同时，表示找到了符合的MLOG_CHECKPOINT LSN，将扫描到的LSN号记录到 
recv_sys->mlog_checkpoint_lsn
 中。(在5.6版本里没有这一次扫描)

    
MLOG_CHECKPOINT在
WL#7142
中被引入，其目的是为了简化 InnoDB 崩溃恢复的逻辑，根据WL#7142的描述，包含几点改进：

    

      
避免崩溃恢复时读取每个ibd的第一个page来确认其space id;

      
无需检查$datadir/*.isl，新的日志类型记录了文件全路径，并消除了isl文件和实际ibd目录的不一致可能带来的问题;

      
自动忽略那些还没有导入到InnoDB的ibd文件（例如在执行IMPORT TABLESPACE时crash）;

      
引入了新的日志类型MLOG_FILE_DELETE来跟踪ibd文件的删除操作。

    

    
这里可能会产生的问题是，如果MLOG_CHECKPOINT日志和文件头记录的CHECKPOINT LSN差距太远的话，在第一次扫描时可能花费大量的时间做无谓的解析，感觉这里还有优化的空间。

    
在我的测试实例中，由于崩溃时施加的负载比较大，MLOG_CHECKPOINT和CHECKPOINT点的LSN相差约1G的redo log。

    
2. 第二次扫描，再次从checkpoint点开始重复扫描，存储日志对象

    
日志解析后的对象类型为
recv_t
，包含日志类型、长度、数据、开始和结束LSN。日志对象的存储使用hash结构，根据 space id 和 page no 计算hash值，相同页上的变更作为链表节点链在一起，大概结构可以表示为：

    

      

    

    
扫描的过程中，会基于MLOG_FILE_NAME 和MLOG_FILE_DELETE 这样的redo日志记录来构建
recv_spaces
，存储space id到文件信息的映射（
fil_name_parse
 –> 
fil_name_process
），这些文件可能需要进行崩溃恢复。（实际上第一次扫描时，也会向
recv_spaces
中插入数据，但只到MLOG_CHECKPOINT日志记录为止）

    

      
Tips：在一次checkpoint后第一次修改某个表的数据时，总是先写一条MLOG_FILE_NAME 日志记录；通过该类型的日志可以跟踪一次CHECKPOINT后修改过的表空间，避免打开全部表。

在第二次扫描时，总会判断将要修改的表空间是否在
recv_spaces
中，如果不存在，则认为产生列严重的错误，拒绝启动（
recv_parse_or_apply_log_rec_body
）

    

    
默认情况下，Redo log以一批64KB（RECV_SCAN_SIZE）为单位读入到
log_sys->buf
中，然后调用函数
recv_scan_log_recs
处理日志块。这里会判断到日志块的有效性：是否是完整写入的、日志块checksum是否正确， 另外也会根据一些标记位来做判断：

    

      
在每次写入redo log时，总会将写入的起始block头的flush bit设置为true，表示一次写入的起始位置，因此在重启扫描日志时，也会根据flush bit来推进扫描的LSN点；

      
每次写redo时，还会在每个block上记录下一个checkpoint no（每次做checkpoint都会递增），由于日志文件是循环使用的，因此需要根据checkpoint no判断是否读到了老旧的redo日志。

    

    
对于合法的日志，会拷贝到缓冲区
recv_sys->buf
中，调用函数
recv_parse_log_recs
解析日志记录。 这里会根据不同的日志类型分别进行处理，并尝试进行apply，堆栈为：

    

      
recv_parse_log_recs
    --> recv_parse_log_rec
        --> recv_parse_or_apply_log_rec_body

    

    
如果想理解InnoDB如何基于不同的日志类型进行崩溃恢复的，非常有必要细读函数
recv_parse_or_apply_log_rec_body
，这里是redo日志apply的入口。

    
例如如果解析到的日志类型为MLOG_UNDO_HDR_CREATE，就会从日志中解析出事务ID，为其重建undo log头（
trx_undo_parse_page_header
）；如果是一条插入操作标识（MLOG_REC_INSERT 或者 MLOG_COMP_REC_INSERT），就需要从中解析出索引信息（
mlog_parse_index
）和记录信息（
page_cur_parse_insert_rec
）；或者解析一条IN-PLACE UPDATE (MLOG_REC_UPDATE_IN_PLACE)日志，则调用函数
btr_cur_parse_update_in_place
。

    
第二次扫描只会应用MLOG
FILE
*类型的日志，记录到
recv_spaces
中，对于其他类型的日志在解析后存储到哈希对象里。然后调用函数
recv_init_crash_recovery_spaces
对涉及的表空间进行初始化处理：

    

      

        
首先会打印两条我们非常熟悉的日志信息：

        

          
  [Note] InnoDB: Database was not shutdown normally!
  [Note] InnoDB: Starting crash recovery.

        

      

      

        
如果
recv_spaces
中的表空间未被删除，且ibd文件存在时，则表明这是个普通的文件操作，将该table space加入到
fil_system->named_spaces
链表上（
fil_names_dirty
），后续可能会对这些表做redo apply操作；

      

      

        
对于已经被删除的表空间，我们可以忽略日志apply，将对应表的space id在
recv_sys->addr_hash
上的记录项设置为RECV_DISCARDED;

      

      

        
调用函数
buf_dblwr_process()
，该函数会检查所有记录在double write buffer中的page，其对应的数据文件页是否完好，如果损坏了，则直接从dblwr中恢复;

      

      
最后创建一个临时的后台线程，线程函数为
recv_writer_thread
，这个线程和page cleaner线程配合使用，它会去通知page cleaner线程去flush崩溃恢复产生的脏页，直到
recv_sys
中存储的redo记录都被应用完成并彻底释放掉(
recv_sys->heap == NULL
)

    

    
3. 如果第二次扫描hash表空间不足，无法全部存储到hash表中，则发起第三次扫描，清空hash，重新从checkpoint点开始扫描。

    
hash对象的空间最大一般为buffer pool size - 512个page大小。

    
第三次扫描不会尝试一起全部存储到hash里，而是一旦发现hash不够了，就立刻apply redo日志。但是…如果总的日志需要存储的hash空间略大于可用的最大空间，那么一次额外的扫描开销还是非常明显的。

    
简而言之，第一次扫描找到正确的MLOG_CHECKPOINT位置；第二次扫描解析 redo 日志并存储到hash中；如果hash空间不够用，则再来一轮重新开始，解析一批，应用一批。

    
三次扫描后，hash中通常还有redo日志没有被应用掉。这个留在后面来做，随后将
recv_sys->apply_log_recs
 设置为true，并从函数
recv_recovery_from_checkpoint_start
返回。

    
对于正常shutdown的场景，一次checkpoint完成后是不记录MLOG_CHECKPOINT日志的，如果扫描过程中没有找到对应的日志，那就认为上次是正常shutdown的，不用考虑崩溃恢复了。

    

      
Tips：偶尔我们会看到日志中报类似这样的信息：

“The log sequence number xxx in the system tablespace does not match the log sequence number xxxx in the ib_logfiles!”

从内部逻辑来看是因为ibdata中记录的lsn和iblogfile中记录的checkpoint lsn不一致，但系统又判定无需崩溃恢复时会报这样的错。单纯从InnoDB实例来看是可能的，因为做checkpint 和更新ibdata不是原子的操作，这样的日志信息一般我们也是可以忽略的。

    

    
初始化事务子系统（trx_sys_init_at_db_start）

    
这里会涉及到读入undo相关的系统页数据，在崩溃恢复状态下，所有的page都要先进行日志apply后，才能被调用者使用，例如如下堆栈：

    

      
trx_sys_init_at_db_start
    --> trx_sysf_get -->
        ....->buf_page_io_complete --> recv_recover_page

    

    
因此在初始化回滚段的时候，我们通过读入回滚段页并进行redo log apply，就可以将回滚段信息恢复到一致的状态，从而能够 “复活”在系统崩溃时活跃的事务，维护到读写事务链表中。对于处于prepare状态的事务，我们后续需要做额外处理。

    
关于事务如何从崩溃恢复中复活，参阅4月份的月报 “
MySQL · 引擎特性 · InnoDB undo log 漫游
“最后一节。

    
应用redo日志(
recv_apply_hashed_log_recs
)

    
根据之前搜集到
recv_sys->addr_hash
中的日志记录，依次将page读入内存，并对每个page进行崩溃恢复操作（
recv_recover_page_func
）：

    

      

        
已经被删除的表空间，直接跳过其对应的日志记录；

      

      

        
在读入需要恢复的文件页时，会主动尝试采用预读的方式多读点page (
recv_read_in_area
)，搜集最多连续32个（RECV_READ_AHEAD_AREA）需要做恢复的page no，然后发送异步读请求。 page 读入buffer pool时，会主动做崩溃恢复逻辑；

      

      

        
只有LSN大于数据页上LSN的日志才会被apply; 忽略被truncate的表的redo日志；

      

      

        
在恢复数据页的过程中不产生新的redo 日志；

      

      
在完成修复page后，需要将脏页加入到buffer pool的flush list上；由于innodb需要保证flush list的有序性，而崩溃恢复过程中修改page的LSN是基于redo 的LSN而不是全局的LSN，无法保证有序性；InnoDB另外维护了一颗红黑树来维持有序性，每次插入到flush list前，查找红黑树找到合适的插入位置，然后加入到flush list上。（
buf_flush_recv_note_modification
）

    

    
完成崩溃恢复(
recv_recovery_from_checkpoint_finish
)

    
在完成所有redo日志apply后，基本的崩溃恢复也完成了，此时可以释放资源，等待recv writer线程退出 (崩溃恢复产生的脏页已经被清理掉)，释放红黑树，回滚所有数据词典操作产生的非prepare状态的事务 (
trx_rollback_or_clean_recovered
)

    
无效数据清理及事务回滚：

    
调用函数
recv_recovery_rollback_active
完成下述工作：

    

      
删除临时创建的索引，例如在DDL创建索引时crash时的残留临时索引(
row_merge_drop_temp_indexes()
)；

      
清理InnoDB临时表 (
row_mysql_drop_temp_tables
)；

      
清理全文索引的无效的辅助表(
fts_drop_orphaned_tables()
)；

      
创建后台线程，线程函数为
trx_rollback_or_clean_all_recovered
，和在
recv_recovery_from_checkpoint_finish
中的调用不同，该后台线程会回滚所有不处于prepare状态的事务。

    

    
至此InnoDB层的崩溃恢复算是告一段落，只剩下处于prepare状态的事务还有待处理，而这一部分需要和Server层的binlog联合来进行崩溃恢复。

    
Binlog/InnoDB XA Recover

    
回到Server层，在初始化完了各个存储引擎后，如果binlog打开了，我们就可以通过binlog来进行XA恢复:

    

      
首先扫描最后一个binlog文件，找到其中所有的XID事件，并将其中的XID记录到一个hash结构中（
MYSQL_BIN_LOG::recover
）；

      
然后对每个引擎调用接口函数
xarecover_handlerton
, 拿到每个事务引擎中处于prepare状态的事务xid，如果这个xid存在于binlog中，则提交；否则回滚事务。

    

    
很显然，如果我们弱化配置的持久性(
innodb_flush_log_at_trx_commit != 1
 或者 
sync_binlog != 1
)， 宕机可能导致两种丢数据的场景：

    

      
引擎层提交了，但binlog没写入，备库丢事务；

      
引擎层没有prepare，但binlog写入了，主库丢事务。

    

    
即使我们将参数设置成
innodb_flush_log_at_trx_commit =1
 和 
sync_binlog = 1
，也还会面临这样一种情况：主库crash时还有binlog没传递到备库，如果我们直接提升备库为主库，同样会导致主备不一致，老主库必须根据新主库重做，才能恢复到一致的状态。针对这种场景，我们可以通过开启semisync的方式来解决，一种可行的方案描述如下：

    

      
设置双1强持久化配置;

      
我们将semisync的超时时间设到极大值，同时使用semisync AFTER_SYNC模式，即用户线程在写入binlog后，引擎层提交前等待备库ACK；

      
基于步骤1的配置，我们可以保证在主库crash时，所有老主库比备库多出来的事务都处于prepare状态；

      
备库完全apply日志后，记下其执行到的relay log对应的位点，然后将备库提升为新主库；

      
将老主库的最后一个binlog进行截断，截断的位点即为步骤3记录的位点;

      
启动老主库，那些已经传递到备库的事务都会提交掉，未传递到备库的binlog都会回滚掉。

    

  

  

    

    

    
Test Book

  

  

    
唯一键是数据库设计中常用的索引类型，主要用于约束数据，不允许出现重复的键值记录。可以想象，如果唯一键约束失效了，将可能产生可怕的逻辑错误。本文主要讨论下最近MySQL爆出来的两个唯一键约束失效导致二级索引corruption的问题。

    
问题一： 检查重复键加锁逻辑不当

    
影响版本：MySQL 5.6.21之前，5.6.12之后的版本

    
介绍分析

    
在5.6.12之前的版本中，当插入一条带唯一约束的记录时，如果表上已经存在了这条记录，或者有一条标记删除的相同键值记录时，就需要对这条记录加S GAP （类型为LOCK_ORDINARY）锁，即使你使用的是READ-COMMIT的隔离级别。因此有人report了
bug#68021
 ，认为在RC级别下，检查duplicate key时无需加GAP锁，在MySQL 5.6.12版本里针对RR级别依然加LOCK_ORDINARY类型的S锁，而针对RC级别加LOCK_REC_NOT_GAP类型的S锁。

    
上述修复带来了严重的退化，在RC隔离级别下，使用DELETE + 并发INSERT冲突键值的场景，将可能触发唯一键失效，我们简单描述下冲突产生的过程：

    

      
开启一个session，执行flush tables tbname for export，这会使purge操作停下来；

      
删除某条记录，其二级索引为uk1, 执行的是标记删除，由于purge被我们人为的停止，因此这条记录不会立刻被清理掉；

      
插入记录，包含唯一索引记录uk1，由于step 2的记录还在（没被purge）,因此需要检查唯一性，在函数
row_ins_scan_sec_index_for_duplicate
中，根据隔离级别在记录上加S NOT GAP 锁，唯一性检查后提交mtr释放block锁；

      
和step 3 类似，另外一个session也插入uk1， 同样加上S NOT GAP锁，因为S锁是相容的，因此可以成功加上锁，提交mtr释放block锁；

      
| 两个session现在可以进行插入，因为受block x锁限制，插入过程是顺序的。但两次插入都能成功，原因是在做插入锁检查时，会检查相邻记录是否存在与(LOCK_X | LOCK_GAP | LOCK_INSERT_INTENTION)相冲突的锁，而GAP 锁和NOT GAP的S锁是不冲突的(参考函数
lock_rec_has_to_wait
)， 因此两次插入都能顺利进行下去。 |

    

    
修复

    
直接把针对 bug#68021 的补丁给revert了。也就是说，在检查duplicate key时总是加GAP类型的S锁（LOCK_ORDINARY），这样上述过程的加锁类型可以归纳为：

    

      
SESSION1 持有 LOCK_ORDINARY S LOCK
SESSION2 持有 LOCK_ORDINARY S LOCK
SESSION1 INSERT RECORD ... CONFLICT, ENQUEUE （LOCK_X | LOCK_GAP | LOCK_INSERT_INTENTION) ——> WAIT
SESSION2 INSERT RECORD ... CONFLICT, ENQUEUE LOCK_X | LOCK_GAP | LOCK_INSERT_INTENTION ——> DEAD LOCK HAPPEN

    

    
如上描述，这里会有一定的几率发生死锁，并且死锁信息通常让人无法捉摸，如果你发现两条插入相同唯一键的SQL出现在死锁信息里，那有很大的可能是这个问题导致的。

    
问题二：锁继承逻辑缺陷导致约束失效(bug#76927)

    
影响版本：MySQL 5.1 ~ MySQL 5.7全系列版本，上游已确认，尚未fix。

    
介绍分析

    
这个问题是最近Percona的开发人员Alexey发现的，触发条件是一次DELETE + 并发REPLACE INTO操作，DELETE和REPLACE操作相同的唯一键值。

    
和INSERT操作不同，通过REPLACE INTO、LOAD DATAFILE REPLACE、INSERT…ON DUPLICATE执行的SQL，在检查唯一建约束时，总是给冲突的记录加LOCK_ORDINARY类型的X锁 (而非上例的S锁)。

    
问题产生的场景如下：

    

      
和上例一样，先让purge线程暂时停止下来；

      
删除包含uk1的记录，由于purge已经停止了，记录会留在物理文件中不会被及时清理掉；

      
执行REPLACE INTO，插入一条包含uk1的记录，由于存在标记删除但尚未清理的冲突键值，且当前操作为replace into，因此给记录加LOCK_ORDINARY类型的X锁；完成冲突检测后，提交mtr释放block锁；

      

        
开启另外一个session执行REPLACE INTO，同样插入冲突键值UK1，由于Step 3 已经加了X锁，因此这里再加X锁产生锁等待，进入等待队列。这时候我们查看innodb_locks表，会发现已经存在两个锁对象了

        

          
 mysql> select * from information_schema.innodb_locks;
 +------------+-------------+-----------+-----------+-------------+------------+------------+-----------+----------+-----------+
 | lock_id | lock_trx_id | lock_mode | lock_type | lock_table | lock_index | lock_space | lock_page | lock_rec | lock_data |
 +------------+-------------+-----------+-----------+-------------+------------+------------+-----------+----------+-----------+
 | 1300:6:4:2 | 1300 | X | RECORD | `test`.`t1` | a | 6 | 4 | 2 | 1 |
 | 1299:6:4:2 | 1299 | X | RECORD | `test`.`t1` | a | 6 | 4 | 2 | 1 |
 +------------+-------------+-----------+-----------+-------------+------------+------------+-----------+----------+-----------+
 2 rows in set (0.00 sec)

        

      

      

        
开启purge线程，purge操作会清理掉之前标记删除的物理记录，然而在step3 和step4上已经在这条记录上加了记录锁，记录被清掉了，对应的锁记录也需要做处理，InnoDB会尝试将锁继承给下一条记录，我们来看看锁继承的逻辑，调用函数
lock_rec_inherit_to_gap
：

        

          
 for (lock = lock_rec_get_first(lock_sys->rec_hash, block, heap_no);
      lock != NULL;
      lock = lock_rec_get_next(heap_no, lock)) {

         if (!lock_rec_get_insert_intention(lock)
             && !((srv_locks_unsafe_for_binlog
                   || lock->trx->isolation_level
                   <= TRX_ISO_READ_COMMITTED)
                  && lock_get_mode(lock) == LOCK_X)) {

                 lock_rec_add_to_queue(
                         LOCK_REC | LOCK_GAP | lock_get_mode(lock),
                         heir_block, heir_heap_no, lock->index,
                         lock->trx, FALSE);
         }
 }

        

        
当满足如下条件时，不会做锁继承：

        

          
锁类型为插入意向锁

          

srv_locks_unsafe_for_binlog
打开且锁类型为X锁

          
锁对应事务的隔离级别小于等于RC且锁类型为X锁

        

        
由于当前的隔离级别为RC，并且REPLACE INTO操作加的是X锁，因此锁没有被相邻记录继承，我们从INNODB_LOCKS系统表中也可以发现这一点：

        

          
 mysql> select * from information_schema.innodb_locks;
 Empty set (0.00 sec)

        

      

      
唤醒第二个replace 操作（正在等待X锁），执行插入操作成功；

      
唤醒第一个replace 操作，由于已经完成duplicate key检测，插入成功。

    

    
修复

    
从上述逻辑可以看出，当purge线程被激活后，记录和记录锁对象都被移除了，purge操作悄悄的破坏了InnoDB的加锁协议。

    
修复的方法也比较简单，InnoDB认为只可能加S锁来维持一致性约束，因此当记录被物理删除时，只有S类型的锁才被继承。但对于REPLACE这样的操作，加的是X类型的锁，这种锁类型必须也要考虑进去，将其继承给下一条记录。Alexey已经将patch push到percona server，改动也就一行，可以参考Percona的 
补丁
。

    
问题三：事务可见性导致的唯一键“失效”

    
我们来看看另外一个在REPEATABLE READ 隔离级别下，唯一键“失效”的问题，考虑如下执行序列。

    

      
创建测试表：create table t1 (a int primary key, b int unique key) engine = innodb;

session 1:
mysql> insert into t1 values (1,2);
Query OK, 1 row affected (0.00 sec)

mysql> begin;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from t1;
+---+------+
| a | b |
+---+------+
| 1 | 2 |
+---+------+
1 row in set (0.00 sec)

session 2:
mysql> delete from t1;
Query OK, 1 row affected (0.00 sec)

session 1:

mysql> insert into t1 values (2,2);
Query OK, 1 row affected (0.00 sec)

mysql> select * from t1;
+---+------+
| a | b |
+---+------+
| 1 | 2 |
| 2 | 2 |
+---+------+
2 rows in set (0.00 sec)

    

    
b列是唯一键，session1成功插入一条刚被删除的相同键值，并且能查询出来两条相同键值的记录。看起来似乎是唯一键约束被破坏了，这实际上和InnoDB的内部实现有关。

    
在上述序列中，session 2执行删除操作，将唯一键进行标记删除，由于session1 已经开启了一个活跃的视图，根据REPEATABLE-READ的可见性原则，session 2所做的数据变更对session 1而言是不可见的，purge线程也无法去物理清理该记录。只要session 1不提交事务，总应该能看到被标记删除的记录(1,2)。

    
当session 1插入相同唯一键值记录(2,2)时，会检查到文件中存在冲突的唯一建，但修改该唯一键的事务已经提交，因此session 1认为插入记录(2,2)是合法的，完成插入后，唯一索引页上就存在两条物理记录，并且对session 1都是可见的。

    
这个问题是不是bug很难界定，毕竟他没有违反RR级别下可见性原则，唯一索引数据本身也是完好的，据我所知，PostgreSQL也遵循相同的逻辑。

  

  

    

    

    
Test Book

  

  

    
背景

    
我们知道当一张表的某个字段存在重复值时，这个字段没办法直接加UNIQUE KEY，但是MySQL提供了一个 ALTER IGNORE TABLE的方式，可以忽略修改表结构过程中出现的错误，但是要忽略UNIQUE重复值，就需要打开old_alter_table，也就是拷贝表的方式来ALTER TABLE。

    
例如这样：

    

      
CREATE TABLE t1(c1 int) ENGINE = InnoDB;
INSERT INTO t1 VALUES (1), (1);
SET old_alter_table=1;
ALTER IGNORE TABLE t1 ADD UNIQUE (c1);

    

    
但是如果你是 MySQL 5.5 主备环境，你会发现备库收到这个DDL后，SQL THREAD 会给你一个无情的报错：

    

      
'Error 'Duplicate entry '1' for key 'c1'' on query.
Default database: 'test'. Query: 'ALTER IGNORE TABLE t1 ADD UNIQUE (c1)''

    

    
原因

    
这是为什么呢？

    
其实关键问题就是这个SQL要执行成功，必须保证 old_alter_table 打开，但是 MySQL 的 SET 语句并不参与复制，因此备库只收到了一个 ALTER IGNORE TABLE，而没有先打开 old_alter_table，因此备库用的不是整表拷贝的方法来重建表，因而无法执行成功。

    
解决

    
那我们怎么解决这个问题呢，也很简单，只要备库Slave线程也用 old_alter_table=1 来执行 ALTER IGNORE TABLE就好了。

    
本质上就是 
mysql_alter_table()
 中需要让
need_copy_table= ALTER_TABLE_DATA_CHANGED
（old_alter_table=1），而不是
need_copy_table= ALTER_TABLE_INDEX_CHANGED
（old_alter_table=0）。

    
因此我们只要在
mysql_alter_table()
函数中判断该用哪种算法的时候，给出一个可以干预的变量，让Slave线程在需要的时候可以按
need_copy_table= ALTER_TABLE_DATA_CHANGED
执行。

    
原来的代码：

    

      
   if ((thd->variables.old_alter_table
       || (table->s->db_type() != create_info->db_type)
 #ifdef WITH_PARTITION_STORAGE_ENGINE
       || partition_changed
 #endif
      )
     need_copy_table= ALTER_TABLE_DATA_CHANGED;

    

    
我们加上判断 (‘是否启用Slave自动用 ALTER_TABLE_DATA_CHANGED 方式做ALTER IGNORE TABLE’ && 
thd->slave_thread
 && ignore)，就可以在我们打开控制变量的时候，强制让Slave线程用 old_alter_table=1 的方式来执行 ALTER IGNORE TABLE。

    

      
   if ((thd->variables.old_alter_table ||
        ('是否启用Slave自动用 ALTER_TABLE_DATA_CHANGED 方式做ALTER IGNORE TABLE' &&
         thd->slave_thread && ignore))
       || (table->s->db_type() != create_info->db_type)
 #ifdef WITH_PARTITION_STORAGE_ENGINE
       || partition_changed
 #endif
      )
     need_copy_table= ALTER_TABLE_DATA_CHANGED;

    

  

  

    

    

    
Test Book

  

  

    
背景

    
6.5号，小编在 Aliyun 的论坛中发现一位开发者提的一个问题，说 RDS 发现了一个超级大BUG，吓的小编一身冷汗 = =!!

赶紧来看看，背景是一个RDS用户创建了一张表，在一个都是NULL值的非索引字段上进行了排序并分页，用户发现第二页和第一页的数据有重复，然后以为是NULL值的问题，把这个字段都更新成相同的值，发现问题照旧。详细的信息可以登录阿里云的
官方论坛查看
。

    
小编进行了尝试，确实如此，并且5.5的版本和5.6的版本行为不一致，所以，必须要查明原因。

    
原因调查

    
在MySQL 5.6的版本上，优化器在遇到order by limit语句的时候，做了一个优化，即使用了priority queue。参考伪代码：

    

      
while (get_next_sortkey())
     {
       if (using priority queue)
         push sort key into queue
       else
       {
         if (no free space in sort_keys buffers)
         {
           sort sort_keys buffer;
           dump sorted sequence to 'tempfile';
           dump BUFFPEK describing sequence location into 'buffpek_pointers';
         }
         put sort key into 'sort_keys';
       }
     }
     if (sort_keys has some elements && dumped at least once)
       sort-dump-dump as above;
     else
       don't sort, leave sort_keys array to be sorted by caller.

    

    
使用 priority queue 的目的，就是在不能使用索引有序性的时候，如果要排序，并且使用了limit n，那么只需要在排序的过程中，保留n条记录即可，这样虽然不能解决所有记录都需要排序的开销，但是只需要 sort buffer 少量的内存就可以完成排序。

    
之所以5.6出现了第二页数据重复的问题，是因为 priority queue 使用了堆排序的排序方法，而堆排序是一个不稳定的排序方法，也就是相同的值可能排序出来的结果和读出来的数据顺序不一致。

    
5.5 没有这个优化，所以也就不会出现这个问题。

    
解决方法

    
1. 索引排序字段

之前的月报中，我们讨论过三星索引的设计，其中第二条就是利用索引的有序性，如果用户在字段添加上索引，就直接按照索引的有序性进行读取并分页，从而可以规避遇到的这个问题。

    
2. 正确理解分页

还是要正确理解分页，分页是建立在排序的基础上，进行了数量范围分割。排序是数据库提供的功能，而分页却是衍生的出来的应用需求。在MySQL和Oracle的官方文档中提供了limit n和rownum < n的方法，但却没有明确的定义分页这个概念。还有重要的一点，虽然上面的解决方法可以缓解用户的这个问题，但按照用户的理解，依然还有问题：比如，这个表插入比较频繁，用户查询的时候，在read-committed的隔离级别下，第一页和第二页仍然会有重合。

    
分页一直都有这个问题，我们看分页常用的场景：1)早期的论坛 2)个人交易记录。这些场景都对数据分页都没有非常高的准确性要求。

    
究竟是不是BUG

    
究竟归于bug问题还是用户使用理解上的问题？

    
小编觉得应该分开看待这个问题，如果是排序的问题，那就算是BUG，如果是分页的这个问题，那它确实完成了order by的功能，也完成了limit n功能，那就不能说它是BUG，分页就纯粹变成了用户理解的问题了。

    
用户在使用数据库的时候常见的一些问题：

    
1. 不加order by的时候的排序问题

用户在使用Oracle或MySQL的时候，发现MySQL总是有序的，Oracle却很混乱，这个主要是因为Oracle是堆表，MySQL是索引聚簇表的原因。所以没有order by的时候，数据库并不保证记录返回的顺序性，并且不保证每次返回都一致的。

    
2. 分页问题

分页重复的问题，就如前面所描述的，分页是在数据库提供的排序功能的基础上，衍生出来的应用需求，数据库并不保证分页的重复问题。

    
3. NULL值和空串问题

不同的数据库对于NULL值和空串的理解和处理是不一样的，比如Oracle NULL和NULL值是无法比较的，既不是相等也不是不相等，是未知的。而对于空串，在插入的时候，MySQL是一个字符串长度为0的空串，而Oracle则直接进行NULL值处理。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
RDS 有个任务叫做恢复到任意时间点，相当于一个数据时光机，可以将数据恢复到过去任意一个时间点，在用户出现误操作需要将数据找回时非常有用。这个功能主要是通过备份集恢复 + binlog回放实现，在用备份集恢复出的实例上应用 binlog 到指定时间点。

    
然而最近线上重放binlog时遇到了这样一个错误：

    

      
Table xxxx already exists

    

    
查看对应 binlog 的，发现这是一个 CREATE VIEW 语句，而备份集恢复出来的实例上确实已经有了这个view，再往前翻看binlog，并没有发现 DROP 这个 view 的记录，倒是找到了CREATE 这个 view 的记录，仔细比较2处 CREATE VIEW 的binlog event，会发现后者多了个 error_code=1050，这个是什么错呢：

    

      
$perror 1050
MySQL error code 1050 (ER_TABLE_EXISTS_ERROR): Table '%-.192s' already exists

    

    
1050 对应的错就是 Table already exists

    
就是说 CREATE VIEW 失败了，仍然记入 binlog 了，但是当时备库并没有这个错误中断掉。

    
复现步骤

    
复现非常简单，连着执行同一个create view语句即可。

    

      
mysql> create table t1(id int, name varchar(30)) engine=innodb;
Query OK, 0 rows affected (0.02 sec)

mysql> create view t1_v as select id from t1;
Query OK, 0 rows affected (0.01 sec)

mysql> create view t1_v as select id from t1;
ERROR 1050 (42S01): Table 't1_v' already exists

    

    
查看binlog event

    

      
#150614 23:15:02 server id 36302  end_log_pos 2651 CRC32 0x8f8b6c61     GTID [commit=yes]
SET @@SESSION.GTID_NEXT= '94cdda9b-a2d0-11e4-ade1-a0d3c1f20ae4:68157343'/*!*/;
# at 2651
#150614 23:15:02 server id 36302  end_log_pos 2856 CRC32 0x703fbe6d     Query   thread_id=21475 exec_time=0     error_code=0
SET TIMESTAMP=1434294902/*!*/;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `t1_v` AS select id from t1
/*!*/;
# at 2856
#150614 23:15:02 server id 36302  end_log_pos 2904 CRC32 0xfc2ef7cb     GTID [commit=yes]
SET @@SESSION.GTID_NEXT= '94cdda9b-a2d0-11e4-ade1-a0d3c1f20ae4:68157344'/*!*/;
# at 2904
#150614 23:15:02 server id 36302  end_log_pos 3109 CRC32 0x0e807965     Query   thread_id=21475 exec_time=0     error_code=1050
SET TIMESTAMP=1434294902/*!*/;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `t1_v` AS select id from t1
/*!*/;

    

    
可以清楚的看到，第二次 CREATE VIEW 时error_code 为 1050。

    
分析

    
查看 binlog 对应的代码，发现 error_code 这个字段是 
Query_log_event
 的专属，其它的如 row_event、gtid event等都没有这个字段。而备库在执行
Query_log_event
 时会检查event 的 error_code(存入expected_error），如果非0的话，就和当前SQL线程执行出错（存入actual_error）比较，看是否一致，如果一致的话就算执行成功，如果不一致的话，就再检查这个错是否能够忽略，如配置了 slave_skip_errors，代码片段如下（在
Query_log_event::do_apply_event
中）:

    

      
/*
If we expected a non-zero error code, and we don't get the same error
code, and it should be ignored or is related to a concurrency issue.
*/
actual_error= thd->is_error() ? thd->get_stmt_da()->sql_errno() : 0;
DBUG_PRINT("info",("expected_error: %d  sql_errno: %d",
expected_error, actual_error));

if ((expected_error && expected_error != actual_error &&
!concurrency_error_code(expected_error)) &&
!ignored_error_code(actual_error) &&
!ignored_error_code(expected_error))
{
rli->report(ERROR_LEVEL, 0,
"\
Query caused different errors on master and slave.     \
Error on master: message (format)='%s' error code=%d ; \
Error on slave: actual message='%s', error code=%d. \
Default database: '%s'. Query: '%s'",
ER_SAFE(expected_error),
expected_error,
actual_error ? thd->get_stmt_da()->message() : "no error",
actual_error,
print_slave_db_safe(db), query_arg);
thd->is_slave_error= 1;
}

    

    
正常的想法应该是执行出错，就不应该记binlog，为什么会有这样的设计呢，主库错，记binlog，然后备库要求同样的错。

因为DDL是不能回滚的，如果DDL执行到一半报错，主库又不能回滚，那么应该如何通知备库它做了一半呢？就是把错记下去，期待备库也报同样的错。

    
挖一下黑历史，
Query_log_event
 中的 
error_code
 字段最早是在这个
commit
中加入的，目的是将主库上执行出错的信息传给备库，备库执行的时候会检测实际的出错信息和主库传过来的binlog中记录的是否是一样的，不一样就报错。

    
在此之前，备库对于 
Query_log_event
 执行出错是这样处理的，先检查SQL线程执行出错是不是因为表不存在，如果是的话，就单独再开个连接，从主库把不存在的表导过来(
fetch_nx_table
)，然后再重试执行失败的event，如果还有不存在的表，就再拉，再重复执行；对于其它的错就直接报错。

现在看起来是不是很奇葩，2000年的时候，MySQL还是很年青的哇 =_=

    
总结

    
我们在回放binlog的时候用的是mysql client，不是SQL线程，mysql client中并没有对error_cocd的处理逻辑，因此遇到执行出错就直接报错了。

    
所以如果脚本或者代码里有这种重放binlog逻辑的，需要注意处理这种场景。

  

  

    

    

    
Test Book

  

  

    
Listen 和 Notify 是PG很有意思的一个功能，可以用来进行多应用间的通信。它们可以在SQL中使用，也可以用C、JDBC里面的API调用。下面介绍一下其使用方法和内核实现。

    
使用方法

    
用一个简单的例子，来看一下Listen/Notify如何使用。假设我们有两个应用A和B，部署在不同的机器上：A机器处理前端用户请求，同时需要将一些可以异步执行的任务，分配给后台服务器B。B接收到任务并处理完成后反馈给A结果。

    

      
--分别在A和B两台机器上初始化PG连接，它们互相监听对方消息，A负责派发任务给B

--机器A初始化与PG的连接
session A:
listen workA;
commit;

--机器B初始化与PG的连接
session B:
listen workerB;
commit;

--A派发任务给B
session A:
begin;
notify workerB, 'do job 1001';
commit;

--B接受消息
session B:
begin;
Asynchronous notification "worker1" with payload "1001" received from server process with PID 29826.
commit;

--B解析消息(可用脚本或应用实现），然后完成任务，发送反馈给A
session B:
....
begin;
notify workA 'job 1001 done';
commit;

    

    
利用上面的步骤，A和B两个机器通过PG完成了通信。在上面的过程中，需要注意的是：

    

      
B要想接受到消息，必须在A Notify之前运行了Listen命令；

      
A需要使用事务commit操作来触发消息发送；

      
消息是异步发送到B的，即无论B的状态如何，消息都会先到达PG的消息队列（每个PG实例只有一个唯一的存放所有消息的队列）；B要查看消息，如果使用的是psql客户端，则需要先发送带有事务操作的命令（如begin、commit或rollback）给PG；

      
A 如果连续发送多个消息，B会一次性收到这些消息；

      
在C代码里面，你可以使用如下的调用来获取所有已到达的消息，如果没有消息到达，则进入睡眠状态。

    

    

      
    while (1)
    {
        sock = PQsocket(conn);

        /* Monitor socket. Sleep if there is no message */
        select(sock + 1, &input_mask, NULL, NULL, NULL) 

        /* Now check for input */
        PQconsumeInput(conn);

        /* Loop until all notifications currently received have been handled */
        while ((notify = PQnotifies(conn)) != NULL)
        {
            /* Received some message, print it out */
            fprintf(stderr,
                    "ASYNC NOTIFY of '%s' received from backend PID %d\n",
                    notify->relname, notify->be_pid);
            PQfreemem(notify);
         }
    }

    

    
内核实现

    
Listen/Notify的实现其实比较简单。主要的数据结构是一个消息队列（
asyncQueueControl->tail
和
asyncQueueControl->head
分别指向队列尾和队列头）和一个进程状态数组（
asyncQueueControl->backend
），如下图所示：

    

    
消息队列里面存放了所有进程的所有通知消息，而状态数组存放了所有执行了Listen命令、准备接收异步消息的进程的状态信息。状态数组中含有每个进程已经读取到的消息在队列里面的位置指针。如果有了新消息，进程就从此指针往后取，直到读取全部消息。

    
当一个连接的后台进程接收到Listen命令时，先将Listen的信息记录下来，然后在事务提交时，执行Listen操作，即把本进程放入状态数组（参见
Exec_ListenPreCommit
函数）。

    
执行Notify命令时，Async_Notify函数负责把通知放入pendingNotifies链表。在事务Commit操作前后，执行下面的逻辑：

    

      
调用PreCommit_Notify函数，将pendingNotifies链表中的消息，放入全局消息队列;

      
执行Commit操作;

      
利用调用链
ProcessCompletedNotifies->SignalBackends->SendProcSignal->kill
，向其他所有状态数组中的进程，发出通知信号。

    

    
另一方面，每个进程在接收到信号后，利用函数
HandleNotifyInterrupt
处理信号。如果当前进程处于事务中，则不立即处理消息，等到事务提交完毕，调用
prepare_for_client_read
读取下一个用户命令时，利用
ProcessIncomingNotify
处理消息；否则，立即调用
ProcessIncomingNotify
处理消息。
ProcessIncomingNotify
最终调用
NotifyMyFrontEnd
发送消息到客户端：

    

      
ProcessIncomingNotify --> asyncQueueReadAllNotifications() --> NotifyMyFrontEnd

    

    
注意，客户端收到消息后，并不立即显示出来，而是需要用API进行获取。例如，psql就是在执行下一个命令时（如begin、commit），会顺便把收到的消息显示出来的。

    
总结

    
Listen/Notify是一个轻量级的应用间通信机制，有了它，具有访问数据库能力的应用可以轻易的利用PG实现互操作。当然，由于消息队列是存放在内存里面的，在发生实例宕机等问题时，消息将丢失，对可靠性要求高的应用，需要自己进行消息持久化（如利用PG存储消息，进行持久化）。

  

  

    

    

    
Test Book

  

  

    
问题描述

    
在RDS生产环境中，一个MySQL实例莫名地被shutdown了, 日志中有如下信息：

    

      
150525 15:30:52 [Note] User 'userxx' issued shutdown command
150525 15:30:52 [Note] /path/to/mysqld: Normal shutdown
150525 15:30:52 [Note] Stop asynchronous binlog_dump to slave (server_id: xxxxx)
150525 15:30:52 [Note] Event Scheduler: Killing the scheduler thread, thread id xxx
150525 15:30:52 [Note] Event Scheduler: Waiting for the scheduler thread to reply
150525 15:30:52 [Note] Event Scheduler: Stopped
150525 15:30:52 [Note] Event Scheduler: Purging the queue. 0 events
150525 15:30:53 [Note] User 'userxx' issued shutdown command
150525 15:31:07 [Note] Slave I/O thread exiting, read up to log 'log.xxxxx', position xxxxxx
150525 15:31:07 [Note] Error reading relay log event: slave SQL thread was killed
150525 15:31:09 [Note] User 'userxx' issued shutdown command

    

    
以下日志是 RDS 实例特有的日志，RDS实例会将用户的重要操作记录在错误日志中。

    

      
150525 15:30:52 [Note] User 'userxx' issued shutdown command

    

    
从日志可以看出：

    

      
实例是正常关闭的

      
用户在极短的时间内执行了多次shutdown命令

    

    
问题分析

    
首先我们来查看用户userxx信息，比较奇怪的是，用户userxx为普通用户，并没有执行shutdown的权限。

第一感觉很可能是MySQL权限模块出现了bug, 导致普通用户也可以执行shutdown命令。于是在一个测试实例上，建立相同权限的同名用户，验证发现userxx确实没有权限执行shutdown命令。

    
进一步从源码中来分析，查找源码中所有可能执行shutdown的路径。从源码中扫描COM_SHUTDOWN 出现的地方,于是在
dispatch_command
函数中发现一处比较可疑的地方，代码如下：

    

      
    thd->set_time();
    if (!thd->is_valid_time())
    {
      /*
       If the time has got past 2038 we need to shut this server down
       We do this by making sure every command is a shutdown and we
       have enough privileges to shut the server down

       TODO: remove this when we have full 64 bit my_time_t support
      */
      thd->security_ctx->master_access|= SHUTDOWN_ACL;
      command= COM_SHUTDOWN;
    }

    

    
MySQL 每次执行一条命令前，会获取一个系统当前时间(
thd->set_time()
)，如果获取的时间不合法(超过2038年或小于0），那么此条命令会自动转为shutdown命令。

    
如果用户多个连接并发执行命令，并且获取的时间不合法，那么每个连接都会执行shutdown命令，这和我们前面看到的日志中的现象很吻合。

    
看来问题集中在为什么获取时间会不合法？

    
最可能的原因是当前主机系统时间设置超过了2038, 于是查看系统时间，然而并没有如我们所愿，系统时间是正常的。

    
最后我们从系统日志中发现了端倪，

    

      
May 25 15:29:49 xxx kernel: : [4768743.131263]  [<ffffffff8109bff3>] ? ktime_get+0x63/0xe0
May 25 15:29:49 xxx kernel: : [4768743.131267]  [<ffffffff810726f7>] ? __do_softirq+0xb7/0x1e0
May 25 15:29:49 xxx kernel: : [4768743.131271]  [<ffffffff8100c24c>] ? call_softirq+0x1c/0x30
May 25 15:29:49 xxx kernel: : [4768743.131274]  [<ffffffff8100de85>] ? do_softirq+0x65/0xa0
May 25 15:29:49 xxx kernel: : [4768743.131276]  [<ffffffff810724e5>] ? irq_exit+0x85/0x90

    

    
差不多在同一时刻系统出现较多的软中断，导致获取系统时间出现错误，即超过2038年或小于0。

    
改进

    
从错误日志中我们表面上看到普通用户执行了shutdown命令，这个带来了疑惑和误导。因此我们做了如下改进：

    

      
此种情况下，在错误日志中打印详细的日志信息，说明shutdown是由于时间获取错误导致；

      
增加重试机制，在第一次获取时间不合法情况下，不直接执行shutdown，而是增加重试重新获取时间，如果还是不合法，再执行shutdown。

    

  

  

    

    

    
Test Book

  

  

    
问题出现

    
我们在线上巡检中发现，一个实例的pg_xlog目录，增长到4G，很是疑惑。刚开始怀疑是日志归档过慢，日志堆积在pg_xlog目录下面，未被清除导致。于是检查归档目录下的文件，内容如下。但发现新近完成写入的日志文件都被归档成功了（即在pg_xlog/archive_status里面，有对应的xxx.done文件）。

    

      
ls -lrt pg_xlog
...
-rw------- 1 xxxx xxxx 16777216 Jun 14 18:39 0000000100000035000000DE
-rw------- 1 xxxx xxxx 16777216 Jun 14 18:39 0000000100000035000000DF
drwx------ 2 xxxx xxxx    73728 Jun 14 18:39 archive_status
-rw------- 1 xxxx xxxx 16777216 Jun 14 18:39 0000000100000035000000E0

ls -lrt pg_xlog/archive_status
...
-rw------- 1 xxxx xxxx 0 Jun 14 18:39 0000000100000035000000DE.done
-rw------- 1 xxxx xxxx 0 Jun 14 18:39 0000000100000035000000DF.done
-rw------- 1 xxxx xxxx 0 Jun 14 18:39 0000000100000035000000E0.done

    

    
仔细观察，奇怪的是，pg_xlog里面还有一些日志文件，其文件名对应了还没产生的日志号！如下所示，当前正在被写入的日志号为100000035000000E0左右，却出现了名为1000000360000000C的日志文件名，更蹊跷的是，其修改时间还在很早以前，就是说不是新近创建或修改过的，如下面的文件修改或创建时间是在当前时间的一个小时之前：

    

      
ls -lrt pg_xlog
....
-rw------- 1 xxxx xxxx 16777216 Jun 14 17:37 00000001000000360000000C
-rw------- 1 xxxx xxxx 16777216 Jun 14 17:37 000000010000003600000014
....

    

    
这是怎么回事呢？难道是“幽灵日志”？下面我们要搞清楚两个问题：1）为什么会出现”幽灵日志“？2）PG正常情况下日志空间大小是多少？

    
PG日志创建清理机制

    
要回答上述问题，需要先摸清PG的日志创建、保持和清理机制。与此直接相关的模块有：日志写入（WAL writer）进程和日志归档（archiver）进程。其实检查点（checkpointer）进程和日志发送进程（WAL sender）也与此有关。

    
WAL writer负责异步把WAL日志刷入磁盘；与此同时，其他普通后台进程，也可能会同步的将WAL日志刷入磁盘，我们先从分析它们入手。从代码里面不难看出，它们将日志写入新的日志文件时，有如下函数调用：

    

      
XLogWrite -> XLogFileInit ->BasicOpenFile

    

    
BasicOpenFile负责打开一个新的日志文件，如果文件不存在，则新建文件。而其代码注释里面提到“Try to use existent file (checkpoint maker may have created it already)”，即打开的文件可能已经被checkpointer进程创建。

    
于是我们将目光转向checkpointer。其主要函数CheckpointerMain的逻辑如下：

    

      
检查是否有checkpoint request信号；

      
检查是否checkpoint timeout时间已到；

      
调用CreateCheckPoint做检查点操作；

      
调用WaitLatch等待checkpoint timeout或checkpoint request信号。

    

    
重点内容都在
CreateCheckPoint
函数中，其逻辑如下：

    

      
检查上次检查点后是否有WAL日志写入，如果没有直接返回；

      
调用CheckPointGuts将WAL日志fsync到磁盘；注意其中的CheckPointBuffers函数，会根据checkpoint_completion_target的值做一定的delay，使fsync操作的完成时间占两个检查点之间时间间隔的比例，约为checkpoint_completion_target；

      
在WAL中插入检查点日志信息；

      
取系统前一次检查点的日志位置指针，即此指针之前的日志文件，都可以删除了；

      
由KeepLogSeg根据wal_keep_segments和replication slot的情况计算要额外保留的日志；

      
由RemoveOldXlogFiles做真正的日志删除，而神奇的是RemoveOldXlogFiles并未实际删除文件，而是将其回收，即将老文件rename成新文件，做了日志文件预分配；

      
完成检查点返回。

    

    
可以看到，在这里出现日志删除、预分配等逻辑。也就是说PG的日志文件可能是在做检查点操作时预分配的！预分配的文件名使用了“未来”的目前还不存在的日志号，这就解释了我们之前遇到的“幽灵日志”情况，也回答了我们的第一个问题。

    
当然，需要说明的是，日志的保留和删除还和是否被archiver进程归档成功有关。

    
日志空间大小

    
继续看第二个问题。前面提到的日志空间暴增让我们如临大敌，那么PG日志到底最多会占用多少空间？我们遇到的涨到3G情况正常吗？

    
从日志清理逻辑（重点是
KeepLogSeg
和
RemoveOldXlogFiles
函数）的分析，我们得到下面的结论：

    

      
日志的删除和预分配只在检查点刚完成时进行；

      
删除时，保证上一次检查点之后到现在的日志不会被删除；

      
保证从目前日志位置往前wal_keep_segments个日志文件不会删除；

      
预分配的过程是，对所有不再需要的旧文件重命名为一个未来的日志号，直到预分配的文件数量达到XLOGfileslop，即
2*checkpoint\_segments + 1
。checkpoint_segments为一个可配置的参数，控制了两个检查点间产生的日志文件数量。

    

    
另外，为讨论方便，下面我们先做如下假设：

    

      
有足够多（即大于2*checkpoint_segments + 1）的不再需要的旧日志文件，可以用于预分配；

      
每次检查点操作完成的时间，正好占两个检查点之间时间间隔的checkpoint_completion_target（线上目前我们设为0.9）。

    

    
设某次检查点操作完成时的时间点为A，则此时做日志预分配的情形如下图所示：

    

    
候选被回收的文件是在时间点C之前的、并且大于wal_keep_segments个文件间隔的文件；这些文件将重命名为预分配文件，文件号为从A对应的日志开始递增，直到达到
2*checkpoint_segments + 1
个文件为止。

    
做检查点操作过程中，是不断产生新日志文件的，而且两次检查点之间的日志文件数为一个稳定的值，即checkpoint_segments。因此，在时间点B到A之间产生的日志数约为
checkpoint_segments * checkpoint_completion_target
。

    
待A时间点预分配完日志文件，并删除其他不需要的日志后，新产生的日志将使用预分配空间，日志空间不会增大，日志空间大小达到一个稳定状态。而此时日志的空间至少为：保留的日志空间 + 预分配空间 + 正在被写入的那个文件，即为：

    

      
max(wal_keep_segments, checkpoint_segments + checkpoint_segments*checkpoint_completion_target) + 2 * checkpoint_segments + 1 + 1

    

    
这就是在日志大小达到稳定状态时，所能达到的最大值。所谓“稳定状态”是指，一旦达到这个状态，优先使用预分配空间，一般不会增大；即使日志文件继续增加，也会被删除（如果archiver和wal sender都正常工作的话）。而日志大小也不会明显减少，因为处于预分配状态的日志数量、前一次检查点到当前时间点的日志量都没有大的变化。

    
回到我们的问题，PG的日志空间占用的正常值，可以用上面的公式计算出来。如果wal_keep_segments为80，checkpoint_segments为64，checkpoint_completion_target为0.9，那么根据公式计算结果为4.02G。即日志空间增加到4G也是正常的。并且可以通过减小checkpoint_segements的值，减少日志空间占用。

    
几个问题

    
通过上面分析得出的公式，我们在处理日志时遇到的一些问题就迎刃而解了，例如：

    
Q: 增加wal_keep_segments会增大日志空间吗？

A: 如果增加wal_keep_segments后，其值仍小于（checkpoint_segments + checkpoint_segments * checkpoint_completion_target），则增加wal_keep_segments并不会增大日志占用空间。

    
Q: checkpoint_segments与日志空间大小有什么关系？

A: 在wal_keep_segments较小时，checkpoint_segments对日志空间占用有至关重要的影响。日志空间大小基本上可以用4倍checkpoint_segments来估算出来。但当wal_keep_segments较大时，比如是checkpoint_segments的10倍，则checkpoint_segments对日志空间大小的影响相对就小很多了。

    
思考题

    
上面的分析中，我们做了两点假设。一个是系统中有足够多的旧日志可供回收，这种情况会出现吗（提示：archiver进程或replication slot对日志删除的影响）？另一个是，检查点操作会及时完成，那么如果检查点操作未及时完成，会出现什么情况？会导致日志空间占用比我们的公式更大吗？

  

  

    

    

    
Test Book

  

  

    
背景

    
从 MairaDB 10.0.5 开始，MariaDB 开始提供 Role（角色）的功能，补全了大家一直吐槽的 MySQL 不能像 Oracle 一样支持角色定义的功能。

    
一个角色就是把一堆的权限捆绑在一起授权，这个功能对于有很多用户拥有相同权限的情况可以显著提高管理效率。在有角色之前，这种情况只能为每个用户都做一大堆的授权操作，或者是给很多个需要相同权限的用户提供同一个账号去使用，这又会导致你要分析用户行为的时候不知道哪个操作是哪个具体用户发起的。

    
有了角色，这样的管理就太容易了。例如，可以把权限需求相同的用户赋予同一个角色，只要定义好这个角色的权限就行，要更改这类用户的权限，只需要更改这个角色的权限就可以了，变化会影响到所有这个角色的用户。

    
用法

    
创建角色需要使用 CREATE ROLE 语句，删除角色使用 DROP ROLE 语句。然后再通过 GRANT 语句给角色增加授权，也可以把角色授权给用户，然后这个角色的权限就会分配给这个用户。同样，REVOKE 语句也可以用来移除角色的授权，或者把一个用户移除某个角色。

    
一旦用户连接上来，他可以执行 SET ROLE 语句来把自己切换到某个被授权的角色下，从而使用这个角色的权限。通过 CURRENT_ROLE 函数可以显示当前用户执行在哪个角色下，没有就是 NULL。

    
只有直接被授予用户的角色才可以使用 SET ROLE 语句，间接授予的角色并不能被 SET ROLE 设置。例如角色B被授予角色A，而角色A被授予用户A，那么用户A只能 SET ROLE 角色A，而不能设置角色B。

    
从 MariaDB 10.1.1 开始，可以利用 SET DEFAULT ROLE 语句来给某个用户设置默认的角色。当用户链接的时候，会默认使用这个角色，其实就是连接后自动做了一个 SET ROLE 语句。

    
使用举例

    
创建一个角色并给他赋权:

    

      
CREATE ROLE journalist;
GRANT SHOW DATABASES ON *.* TO journalist;
GRANT journalist to hulda;

    

    
这里 hulda 并不马上拥有 SHOW DATABASES 权限，他还需要先执行一个 SET ROLE 语句启用这个角色：

    

      
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
+--------------------+
SELECT CURRENT_ROLE;
+--------------+
| CURRENT_ROLE |
+--------------+
| NULL         |
+--------------+
SET ROLE journalist;
SELECT CURRENT_ROLE;
+--------------+
| CURRENT_ROLE |
+--------------+
| journalist   |
+--------------+
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| ...                |
| information_schema |
| mysql              |
| performance_schema |
| test               |
| ...                |
+--------------------+
SET ROLE NONE;

    

    
角色也可以授权给另一个角色：

    

      
CREATE ROLE writer;
GRANT SELECT ON data.* TO writer;
GRANT writer TO journalist;

    

    
但是只能 SET ROLE 直接给用户的角色。像这里 hulda 只能 SET ROLE journalist，而不能 SET ROLE writer，并且只要启用了 journalist 角色，hulda 也自动获得了 writer 角色的权限：

    

      
SELECT CURRENT_ROLE;
+--------------+
| CURRENT_ROLE |
+--------------+
| NULL         |
+--------------+
SHOW TABLES FROM data;
Empty set (0.01 sec)

SET ROLE journalist;
SELECT CURRENT_ROLE;
+--------------+
| CURRENT_ROLE |
+--------------+
| journalist   |
+--------------+
SHOW TABLES FROM data;
+------------------------------+
| Tables_in_data               |
+------------------------------+
| set1                         |
| ...                          |
+------------------------------+

    

    
角色和视图、存储过程。

    
当用户设置启用了一个角色，从某种意义上说他有两个身份的权限集合（用户本身和他的角色）但是一个视图或者存储过程只能有一个定义者。所以，当一个视图或者存储过程通过 SQL SECURITY DEFINER 创建时，只能指定 CURRENT_USER 或者 CURRENT_ROLE 中的一个。所以有些情况下，你创建了一个视图，但是你却可能没法使用它。

    

      
CREATE ROLE r1;
GRANT ALL ON db1.* TO r1;
GRANT r1 TO foo@localhost;
GRANT ALL ON db.* TO foo@localhost;
SELECT CURRENT_USER
+---------------+
| current_user  |
+---------------+
| foo@localhost |
+---------------+
SET ROLE r1;
CREATE TABLE db1.t1 (i int);
CREATE VIEW db.v1 AS SELECT * FROM db1.t1;
SHOW CREATE VIEW db.v1;
+------+------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View | Create View                                                                                                                              | character_set_client | collation_connection |
+------+------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| v1   | CREATE ALGORITHM=UNDEFINED DEFINER=`foo`@`localhost` SQL SECURITY DEFINER VIEW `db`.`v1` AS SELECT `db1`.`t1`.`i` AS `i` from `db1`.`t1` | utf8                 | utf8_general_ci      |
+------+------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
CREATE DEFINER=CURRENT_ROLE VIEW db.v2 AS SELECT * FROM db1.t1;
SHOW CREATE VIEW db.b2;
+------+-----------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View | Create View                                                                                                                 | character_set_client | collation_connection |
+------+-----------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| v2   | CREATE ALGORITHM=UNDEFINED DEFINER=`r1` SQL SECURITY DEFINER VIEW `db`.`v2` AS select `db1`.`t1`.`a` AS `a` from `db1`.`t1` | utf8                 | utf8_general_ci      |
+------+-------------------------------------------------------------------------------------

    

  

  

    

    

    
Test Book

  

  

    
想要查看TokuDB某个表占了多少磁盘空间，目前还没有太好的方法。

如果你使用’show table status’命令，得到的结果只会让你更迷茫:

    

      
           Name: toku
         Engine: TokuDB
        Version: 10
     Row_format: tokudb_zlib
           Rows: 28874059
 Avg_row_length: 30
    Data_length: 868159449
Max_data_length: 9223372036854775807
   Index_length: 2099497463
      Data_free: 0

    

    
我们来看看test_toku表磁盘文件大小：

    

      
$du -b _test_toku*
124427776       _test_toku_A_B.tokudb  --KEY(A,B)索引数据文件
215959552       _test_toku_B_C.tokudb  --KEY(B,C)索引数据文件
149504000       _test_toku_main.tokudb --主数据文件

    

    
Data_length和Index_length都对不上，而且差的还不是一点，真头疼，总不能每次都要去服务器上du吧？其实，我们可以通过
information_schema.TokuDB_fractal_tree_info
得到：

    

      
mysql> select * from TokuDB_fractal_tree_info where table_name='test_toku'\G;
*************************** 1\. row ***************************
        dictionary_name: ./test/test_toku_A_B
     internal_file_name: _test_toku_A_B.tokudb
bt_num_blocks_allocated: 449
   bt_num_blocks_in_use: 449
      bt_size_allocated: 124416093
         bt_size_in_use: 123563101
           table_schema: test
             table_name: toku
  table_dictionary_name: key-test_toku_A_B
*************************** 2\. row ***************************
        dictionary_name: ./test/test_toku_B_C
     internal_file_name: ./_test_toku_B_C.tokudb
bt_num_blocks_allocated: 612
   bt_num_blocks_in_use: 612
      bt_size_allocated: 215945353
         bt_size_in_use: 214784137
           table_schema: test
             table_name: toku
  table_dictionary_name: key-test_toku_B_C
*************************** 3\. row ***************************
        dictionary_name: ./test/test_toku-main
     internal_file_name: ./_test_toku_main.tokudb
bt_num_blocks_allocated: 486
   bt_num_blocks_in_use: 486
      bt_size_allocated: 149491745
         bt_size_in_use: 148580897
           table_schema: test
             table_name: toku
  table_dictionary_name: main

    

    

bt_size_allocated
字段是TokuDB内部维护当前数据文件最后分配的offset，跟数据文件磁盘大小基本一致。

    
再回到刚才的问题：
show table status
里Data_length和Index_length为什么跟实际大小出入这么大呢？

    
在
ha_tokudb::info()
里:

    

      
stats.data_file_length = dict_stats.bt_dsize;

    

    
bt_dsize的值来自toku_ft_stat64:

    

      
bt_dsize = ft->in_memory_stats.numbytes;

    

    

in_memory_stats.numbytes
是TokuDB在内存中维护的一个变量，用于记录变更数据的增量大小，每次checkpoint的时候持久化到数据文件(包括索引文件)的header里，所以是个出入比较大的参考变量(无压缩)，已不能通过此变量来反应表文件的真实大小。

    
这么不爽的地方，我们(RDS MySQL)已准备好patch把它修掉，让
show table status
可以拿到TokuDB表文件的真实大小。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · InnoDB redo log漫游

        

      

      

        

          
MySQL · 专家投稿 · MySQL数据库SYS CPU高的可能性分析

        

      

      

        

          
MySQL · 捉虫动态 · 5.6 与 5.5 InnoDB 不兼容导致 crash

        

      

      

        

          
MySQL · 答疑解惑 · InnoDB 预读 VS Oracle 多块读

        

      

      

        

          
PgSQL · 社区动态 · 9.5 新功能BRIN索引

        

      

      

        

          
MySQL · 捉虫动态 · MySQL DDL BUG

        

      

      

        

          
MySQL · 答疑解惑 · set names 都做了什么

        

      

      

        

          
MySQL · 捉虫动态 · 临时表操作导致主备不一致

        

      

      

        

          
TokuDB · 引擎特性 · zstd压缩算法

        

      

      

        

          
MySQL · 答疑解惑 · binlog 位点刷新策略

        

      

    

  

  

    

    

    
Test Book

  

  

    
前言

    
InnoDB 有两块非常重要的日志，一个是undo log，另外一个是redo log，前者用来保证事务的原子性以及InnoDB的MVCC，后者用来保证事务的持久性。

    
和大多数关系型数据库一样，InnoDB记录了对数据文件的物理更改，并保证总是日志先行，也就是所谓的WAL，即在持久化数据文件前，保证之前的redo日志已经写到磁盘。

    
LSN(log sequence number) 用于记录日志序号，它是一个不断递增的 unsigned long long 类型整数。在 InnoDB 的日志系统中，LSN 无处不在，它既用于表示修改脏页时的日志序号，也用于记录checkpoint，通过LSN，可以具体的定位到其在redo log文件中的位置。

    
为了管理脏页，在 Buffer Pool 的每个instance上都维持了一个flush list，flush list 上的 page 按照修改这些 page 的LSN号进行排序。因此定期做redo checkpoint点时，选择的 LSN 总是所有 bp instance 的 flush list 上最老的那个page（拥有最小的LSN）。由于采用WAL的策略，每次事务提交时需要持久化 redo log 才能保证事务不丢。而延迟刷脏页则起到了合并多次修改的效果，避免频繁写数据文件造成的性能问题。

    
由于 InnoDB 日志组的特性已经被废弃（redo日志写多份），归档日志(InnoDB archive log)特性也在5.7被彻底移除，本文在描述相关逻辑时会忽略这些逻辑。另外限于篇幅，InnoDB崩溃恢复的逻辑将在下期讲述，本文重点阐述redo log 产生的生命周期以及MySQL 5.7的一些改进点。

    
本文的分析基于最新的MySQL 5.7.7-RC版本。

    
InnoDB 日志文件

    
InnoDB的redo log可以通过参数
innodb_log_files_in_group
配置成多个文件，另外一个参数
innodb_log_file_size
表示每个文件的大小。因此总的redo log大小为
innodb_log_files_in_group * innodb_log_file_size
。

    
Redo log文件以
ib_logfile[number]
命名，日志目录可以通过参数
innodb_log_group_home_dir
控制。Redo log 以顺序的方式写入文件文件，写满时则回溯到第一个文件，进行覆盖写。（但在做redo checkpoint时，也会更新第一个日志文件的头部checkpoint标记，所以严格来讲也不算顺序写）。

    

    
在InnoDB内部，逻辑上
ib_logfile
被当成了一个文件，对应同一个space id。由于是使用512字节block对齐写入文件，可以很方便的根据全局维护的LSN号计算出要写入到哪一个文件以及对应的偏移量。

    
Redo log文件是循环写入的，在覆盖写之前，总是要保证对应的脏页已经刷到了磁盘。在非常大的负载下，Redo log可能产生的速度非常快，导致频繁的刷脏操作，进而导致性能下降，通常在未做checkpoint的日志超过文件总大小的76%之后，InnoDB 认为这可能是个不安全的点，会强制的preflush脏页，导致大量用户线程stall住。如果可预期会有这样的场景，我们建议调大redo log文件的大小。可以做一次干净的shutdown，然后修改Redo log配置，重启实例。

    
除了redo log文件外，InnoDB还有其他的日志文件，例如为了保证truncate操作而产生的中间日志文件，包括 truncate innodb 表以及truncate undo log tablespace，都会产生一个中间文件，来标识这些操作是成功还是失败，如果truncate没有完成，则需要在 crash recovery 时进行重做。有意思的是，根据官方worklog的描述，最初实现truncate操作的原子化时是通过增加新的redo log类型来实现的，但后来不知道为什么又改成了采用日志文件的方式，也许是考虑到低版本兼容的问题吧。

    
关键结构体

    
log_sys对象

    

log_sys
是InnoDB日志系统的中枢及核心对象，控制着日志的拷贝、写入、checkpoint等核心功能。它同时也是大写入负载场景下的热点模块，是连接InnoDB日志文件及log buffer的枢纽，对应结构体为
log_t
。

    
其中与 redo log 文件相关的成员变量包括：

    

      

        

          
变量名

          
描述

        

      

      

        

          
log_groups

          
日志组，当前版本仅支持一组日志，对应类型为 
log_group_t
 ，包含了当前日志组的文件个数、每个文件的大小、space id等信息

        

        

          
lsn_t log_group_capacity

          
表示当前日志文件的总容量，值为:(Redo log文件总大小 - redo 文件个数 
 LOG_FILE_HDR_SIZE) 
 0.9，LOG_FILE_HDR_SIZE 为 4*512 字节

        

        

          
lsn_t max_modified_age_async

          
异步 preflush dirty page 点

        

        

          
lsn_t max_modified_age_sync

          
同步 preflush dirty page 点

        

        

          
lsn_t max_checkpoint_age_async

          
异步 checkpoint 点

        

        

          
lsn_t max_checkpoint_age

          
同步 checkpoint 点

        

      

    

    
上述几个sync/async点的计算方式可以参阅函数
log_calc_max_ages
，以如下实例配置为例：

    

      
innodb_log_files_in_group=4
innodb_log_file_size=4G
总文件大小: 17179869184

    

    
各个成员变量值及占总文件大小的比例：

    

      
log_sys->log_group_capacity = 15461874893 (90%)

log_sys->max_modified_age_async = 12175607164 (71%)

log_sys->max_modified_age_sync = 13045293390 (76%)

log_sys->max_checkpoint_age_async = 13480136503 (78%)

log_sys->max_checkpoint_age = 13914979615 (81%)

    

    
通常的：

    
当当前未刷脏的最老lsn和当前lsn的距离超过
max_modified_age_async
（71%）时，且开启了选项
innodb_adaptive_flushing
时，page cleaner线程会去尝试做更多的dirty page flush工作，避免脏页堆积。

当当前未刷脏的最老lsn和当前Lsn的距离超过
max_modified_age_sync
(76%)时，用户线程需要去做同步刷脏，这是一个性能下降的临界点，会极大的影响整体吞吐量和响应时间。

当上次checkpoint的lsn和当前lsn超过
max_checkpoint_age
(81%)，用户线程需要同步地做一次checkpoint，需要等待checkpoint写入完成。

当上次checkpoint的lsn和当前lsn的距离超过
max_checkpoint_age_async
（78%）但小于
max_checkpoint_age
（81%）时，用户线程做一次异步checkpoint（后台异步线程执行CHECKPOINT信息写入操作），无需等待checkpoint完成。

    

log_group_t
结构体主要成员如下表所示：

    

      

        

          
变量名

          
描述

        

      

      

        

          
ulint n_files

          
Ib_logfile的文件个数

        

        

          
lsn_t file_size

          
文件大小

        

        

          
ulint space_id

          
Redo log 的space id, 固定大小，值为SRV_LOG_SPACE_FIRST_ID

        

        

          
ulint state

          
LOG_GROUP_OK 或者 LOG_GROUP_CORRUPTED

        

        

          
lsn_t lsn

          
该group内写到的lsn

        

        

          
lsn_t lsn_offset

          
上述lsn对应的文件偏移量

        

        

          
byte** file_header_bufs

          
Buffer区域，用于设定日志文件头信息，并写入ib logfile。当切换到新的ib_logfile时，更新该文件的起始lsn，写入头部。 头部信息还包含： LOG_GROUP_ID, LOG_FILE_START_LSN（当前文件起始lsn）、LOG_FILE_WAS_CREATED_BY_HOT_BACKUP(函数log_group_file_header_flush)

        

        

          
lsn_t scanned_lsn

          
用于崩溃恢复时辅助记录扫描到的lsn号

        

        

          
byte* checkpoint_buf

          
Checkpoint缓冲区，用于向日志文件写入checkpoint信息（下文详细描述）

        

      

    

    
与redo log 内存缓冲区相关的成员变量包括：

    

      

        

          
变量名

          
描述

        

      

      

        

          
ulint buf_free

          
Log buffer中当前空闲可写的位置

        

        

          
byte* buf

          
Log buffer起始位置指针

        

        

          
ulint buf_size

          
Log buffer 大小，受参数innodb_log_buffer_size控制，但可能会自动extend

        

        

          
ulint max_buf_free

          
值为log_sys->buf_size / LOG_BUF_FLUSH_RATIO - LOG_BUF_FLUSH_MARGIN, 其中： LOG_BUF_FLUSH_RATIO=2, LOG_BUF_FLUSH_MARGIN=(4 
 512 + 4
 page_size) ,page_size默认为16k,当buf_free超过该值时，可能触发用户线程去写redo；在事务拷redo 到buffer后，也会判断该值，如果超过buf_free，设置log_sys->check_flush_or_checkpoint为true

        

        

          
ulint buf_next_to_write

          
Log buffer偏移量，下次写入redo文件的起始位置，即本次写入的结束位置

        

        

          
volatile bool is_extending

          
Log buffer是否正在进行扩展 （防止过大的redo log entry无法写入buffer）, 实际上，当写入的redo log长度超过buf_size/2时，就会去调用函数log_buffer_extend,一旦扩展Buffer，就不会在缩减回去了！

        

        

          
ulint write_end_offset

          
本次写入的结束位置偏移量(从逻辑来看有点多余，直接用log_sys->buf_free就行了)

        

      

    

    
和Checkpoint检查点相关的成员变量：

    

      

        

          
变量名

          
描述

        

      

      

        

          
ib_uint64_t next_checkpoint_no

          
每完成一次checkpoint递增该值

        

        

          
lsn_t last_checkpoint_lsn

          
最近一次checkpoint时的lsn，每完成一次checkpoint，将next_checkpoint_lsn的值赋给last_checkpoint_lsn

        

        

          
lsn_t next_checkpoint_lsn

          
下次checkpoint的lsn（本次发起的checkpoint的lsn）

        

        

          
mtr_buf_t* append_on_checkpoint

          
5.7新增，在做DDL时（例如增删列），会先将包含MLOG_FILE_RENAME2日志记录的buf挂到这个变量上。 在DDL完成后，再清理掉。(log_append_on_checkpoint),主要是防止DDL期间crash产生的数据词典不一致。 该变量在如下commit加上： a5ecc38f44abb66aa2024c70e37d1f4aa4c8ace9

        

        

          
ulint n_pending_checkpoint_writes

          
大于0时，表示有一个checkpoint写入操作正在进行。用户发起checkpoint时，递增该值。后台线程完成checkpoint写入后，递减该值(log_io_complete)

        

        

          
rw_lock_t checkpoint_lock

          
checkpoint锁，每次写checkpoint信息时需要加x锁。由异步io线程释放该x锁

        

        

          
byte* checkpoint_buf

          
Checkpoint信息缓冲区，每次checkpoint前，先写该buf，再将buf刷到磁盘

        

      

    

    
其他状态变量

    

      

        

          
变量名

          
描述

        

      

      

        

          
bool check_flush_or_checkpoint

          
当该变量被设置时，用户线程可能需要去检查释放要刷log buffer、或是做preflush、checkpoint等以防止Redo 空间不足

        

        

          
lsn_t write_lsn

          
最近一次完成写入到文件的LSN

        

        

          
lsn_t current_flush_lsn

          
当前正在fsync到的LSN

        

        

          
lsn_t flushed_to_disk_lsn

          
最近一次完成fsync到文件的LSN

        

        

          
ulint n_pending_flushes

          
表示pending的redo fsync，这个值最大为1

        

        

          
os_event_t flush_event

          
若当前有正在进行的fsync，并且本次请求也是fsync操作，则需要等待上次fsync操作完成

        

      

    

    
log_sys与日志文件和日志缓冲区的关系可用下图来表示：

    

    
Mini transaction

    
Mini transaction(简称mtr)是InnoDB对物理数据文件操作的最小事务单元，用于管理对Page加锁、修改、释放、以及日志提交到公共buffer等工作。一个mtr操作必须是原子的，一个事务可以包含多个mtr。每个mtr完成后需要将本地产生的日志拷贝到公共缓冲区，将修改的脏页放到flush list上。

    
mtr事务对应的类为
mtr_t
, 
mtr_t::Impl
中保存了当前mtr的相关信息，包括:

    

      

        

          
变量名

          
描述

        

      

      

        

          
mtr_buf_t m_memo

          
用于存储该mtr持有的锁类型

        

        

          
mtr_buf_t m_log

          
存储redo log记录

        

        

          
bool m_made_dirty

          
是否产生了至少一个脏页

        

        

          
bool m_inside_ibuf

          
是否在操作change buffer

        

        

          
bool m_modifications

          
是否修改了buffer pool page

        

        

          
ib_uint32_t m_n_log_recs

          
该mtr log记录个数

        

        

          
mtr_log_t m_log_mode

          
Mtr的工作模式，包括四种： MTR_LOG_ALL：默认模式，记录所有会修改磁盘数据的操作；MTR_LOG_NONE：不记录redo，脏页也不放到flush list上；MTR_LOG_NO_REDO：不记录redo，但脏页放到flush list上；MTR_LOG_SHORT_INSERTS：插入记录操作REDO，在将记录从一个page拷贝到另外一个新建的page时用到，此时忽略写索引信息到redo log中。（参阅函数page_cur_insert_rec_write_log）

        

        

          
fil_space_t* m_user_space

          
当前mtr修改的用户表空间

        

        

          
fil_space_t* m_undo_space

          
当前mtr修改的undo表空间

        

        

          
fil_space_t* m_sys_space

          
当前mtr修改的系统表空间

        

        

          
mtr_state_t m_state

          
包含四种状态: MTR_STATE_INIT、MTR_STATE_COMMITTING、 MTR_STATE_COMMITTED

        

      

    

    
在修改或读一个数据文件中的数据时，一般是通过mtr来控制对对应page或者索引树的加锁，在5.7中，有以下几种锁类型（
mtr_memo_type_t
）：

    

      

        

          
变量名

          
描述

        

      

      

        

          
MTR_MEMO_PAGE_S_FIX

          
用于PAGE上的S锁

        

        

          
MTR_MEMO_PAGE_X_FIX

          
用于PAGE上的X锁

        

        

          
MTR_MEMO_PAGE_SX_FIX

          
用于PAGE上的SX锁，以上锁通过mtr_memo_push 保存到mtr中

        

        

          
MTR_MEMO_BUF_FIX

          
PAGE上未加读写锁，仅做buf fix

        

        

          
MTR_MEMO_S_LOCK

          
S锁，通常用于索引锁

        

        

          
MTR_MEMO_X_LOCK

          
X锁，通常用于索引锁

        

        

          
MTR_MEMO_SX_LOCK

          
SX锁，通常用于索引锁，以上3个锁，通过mtr_s/x/sx_lock加锁，通过mtr_memo_release释放锁

        

      

    

    
mtr log生成

    
InnoDB的redo log都是通过mtr产生的，先写到mtr的cache中，然后再提交到公共buffer中，本小节以INSERT一条记录对page产生的修改为例，阐述一个mtr的典型生命周期。

    
入口函数：
row_ins_clust_index_entry_low

    
开启mtr

    
执行如下代码块

    

      
mtr_start(&mtr);
mtr.set_named_space(index->space);

    

    
mtr_start主要包括：

    

      

        
初始化mtr的各个状态变量

      

      

        
默认模式为MTR_LOG_ALL，表示记录所有的数据变更

      

      

        
mtr状态设置为ACTIVE状态（MTR_STATE_ACTIVE）

      

      
为锁管理对象和日志管理对象初始化内存（mtr_buf_t）,初始化对象链表

    

    

mtr.set_named_space
 是5.7新增的逻辑，将当前修改的表空间对象
fil_space_t
保存下来：如果是系统表空间，则赋值给
m_impl.m_sys_space
, 否则赋值给
m_impl.m_user_space
。

    

      
Tips： 在5.7里针对临时表做了优化，直接关闭redo记录：

mtr.set_log_mode(MTR_LOG_NO_REDO)

    

    
定位记录插入的位置

    
主要入口函数： 
btr_cur_search_to_nth_level

    
不管插入还是更新操作，都是先以乐观方式进行，因此先加索引S锁

mtr_s_lock(dict_index_get_lock(index),&mtr)
，对应
mtr_t::s_lock
函数

如果以悲观方式插入记录，意味着可能产生索引分裂，在5.7之前会加索引X锁，而5.7版本则会加SX锁（但某些情况下也会退化成X锁）

加X锁： 
mtr_x_lock(dict_index_get_lock(index), mtr)
,对应
mtr_t::x_lock
函数

加SX锁：
mtr_sx_lock(dict_index_get_lock(index),mtr)
，对应
mtr_t::sx_lock
函数

    
对应到内部实现，实际上就是加上对应的锁对象，然后将该锁的指针和类型构建的
mtr_memo_slot_t
对象插入到
mtr.m_impl.m_memo
中。

    
当找到预插入page对应的block，还需要加block锁，并把对应的锁类型加入到mtr：
mtr_memo_push(mtr, block, fix_type)

    
如果对page加的是MTR_MEMO_PAGE_X_FIX或者MTR_MEMO_PAGE_SX_FIX锁，并且当前block是clean的，则将
m_impl.m_made_dirty
设置成true，表示即将修改一个干净的page。

    
如果加锁类型为MTR_MEMO_BUF_FIX，实际上是不加锁对象的，但需要判断临时表的场景，临时表page的修改不加latch，但需要将
m_impl.m_made_dirty
设置为true（根据block的成员
m_impl.m_made_dirty
来判断），这也是5.7对InnoDB临时表场景的一种优化。

    
同样的，根据锁类型和锁对象构建
mtr_memo_slot_t
加入到
m_impl.m_memo
中。

    
插入数据

    
在插入数据过程中，包含大量的redo写cache逻辑，例如更新二级索引页的max trx id、写undo log产生的redo(嵌套另外一个mtr)、修改数据页产生的日志。这里我们只讨论修改数据页产生的日志，进入函数
page_cur_insert_rec_write_log
:

    
Step 1: 调用函数
mlog_open_and_write_index
记录索引相关信息

    

      
调用
mlog_open
，分配足够日志写入的内存地址，并返回内存指针

      
初始化日志记录：
mlog_write_initial_log_record_fast

写入 
|类型=MLOG\_COMP\_REC\_INSERT，1字节|space id | page no|
 space id 和page no采用一种压缩写入的方式（
mach_write_compressed
），根据数字的具体大小，选择从1到4个字节记录整数，节约redo空间，对应的解压函数为
mach_read_compressed

      
写入当前索引列个数，占两个字节

      
写入行记录上决定唯一性的列的个数，占两个字节(
dict_index_get_n_unique_in_tree
)

对于聚集索引，就是PK上的列数；对于二级索引，就是二级索引列+PK列个数

      
写入每个列的长度信息，每个列占两个字节

如果这是 varchar 列且最大长度超过255字节, len = 0x7fff；如果该列非空，len |= 0x8000；其他情况直接写入列长度。

    

    
Step 2: 写入记录在page上的偏移量，占两个字节

    

      
mach_write_to_2(log_ptr, page_offset(cursor_rec));

    

    
Step 3: 写入记录其它相关信息 （rec size, extra size, info bit，关于InnoDB的数据文件物理描述，我们以后再介绍，本文不展开）

    
Step 4: 将插入的记录拷贝到redo文件，同时关闭mlog

    

      
memcpy(log_ptr, ins_ptr, rec_size);
mlog_close(mtr, log_ptr + rec_size);

    

    
通过上述流程，我们写入了一个类型为MLOG_COMP_REC_INSERT的日志记录。由于特定类型的记录都基于约定的格式，在崩溃恢复时也可以基于这样的约定解析出日志。

    
这里只举了一个非常简单的例子，该mtr中只包含一条redo记录。实际上mtr遍布整个InnoDB的逻辑，但只要遵循相同的写入和读取约定，并对写入的单元（page）加上互斥锁，就能从崩溃恢复。

    
更多的redo log记录类型参见
enum mlog_id_t
。

    
在这个过程中产生的redo log都记录在
mtr.m_impl.m_log
中，只有显式提交mtr时，才会写到公共buffer中。

    
提交mtr log

    
当提交一个mini transaction时，需要将对数据的更改记录提交到公共buffer中，并将对应的脏页加到flush list上。

    
入口函数为
mtr_t::commit()
，当修改产生脏页或者日志记录时，调用
mtr_t::Command::execute
，执行过程如下：

    
Step 1: 
mtr_t::Command::prepare_write()

    

      
若当前mtr的模式为MTR_LOG_NO_REDO 或者MTR_LOG_NONE，则获取
log_sys->mutex
，从函数返回

      
若当前要写入的redo log记录的大小超过log buffer的二分之一，则去扩大log buffer，大小约为原来的两倍。

      
持有
log_sys->mutex

      
调用函数
log_margin_checkpoint_age
检查本次写入：

如果本次产生的redo log size的两倍超过redo log文件capacity，则打印一条错误信息；若本次写入可能覆盖检查点，还需要去强制做一次同步chekpoint

      

        
检查本次修改的表空间是否是上次checkpoint后第一次修改，调用函数（
fil_names_write_if_was_clean
）

如果space->max_lsn = 0，表示自上次checkpoint后第一次修改该表空间：

a. 修改
space->max_lsn
为当前
log_sys->lsn
；

b. 调用
fil_names_dirty_and_write
将该tablespace加入到
fil_system->named_spaces
链表上；

c. 调用
fil_names_write
写入一条类型为MLOG_FILE_NAME的日志，写入类型、spaceid, page no(0)、文件路径长度、以及文件路径名。

        
在mtr日志末尾追加一个字节的MLOG_MULTI_REC_END类型的标记，表示这是多个日志类型的mtr。

        

          
Tips：在5.6及之前的版本中，每次crash recovery时都需要打开所有的ibd文件，如果表的数量非常多时，会非常影响崩溃恢复性能，因此从5.7版本开始，每次checkpoint后，第一次修改的文件名被记录到redo log中，这样在重启从检查点恢复时，就只打开那些需要打开的文件即可（
WL#7142
）

        

      

      
如果不是从上一次checkpoint后第一次修改该表，则根据mtr中log的个数，或标识日志头最高位为MLOG_SINGLE_REC_FLAG，或附加一个1字节的MLOG_MULTI_REC_END日志。

    

    
注意从
prepare_write
函数返回时是持有
log_sys->mutex
锁的。

    
至此一条插入操作产生的mtr日志格式有可能如下图所示：

    

    
Step 2: mtr_t::Command::finish_write

    
将日志从mtr中拷贝到公共log buffer。这里有两种方式

    

      
如果mtr中的日志较小，则调用函数
log_reserve_and_write_fast
，尝试将日志拷贝到log buffer最近的一个block。如果空间不足，走逻辑b)，否则直接拷贝

      

        
检查是否有足够的空闲空间后，返回当前的lsn赋值给
m_start_lsn
（
log_reserve_and_open(len)
），随后将日志记录写入到log buffer中。

        

          
  m_start_lsn = log_reserve_and_open(len);
  mtr_write_log_t write_log;
  m_impl->m_log.for_each_block(write_log);

        

      

      

        
在完成将redo 拷贝到log buffer后，需要调用
log_close
, 如果最后一个block未写满，则设置该block头部的LOG_BLOCK_FIRST_REC_GROUP信息；

满足如下情况时，设置
log_sys->check_flush_or_checkpoint
为true：

        

          
当前写入buffer的位置超过log buffer的一半

          
bp中最老lsn和当前lsn的距离超过log_sys->max_modified_age_sync

          
当前未checkpoint的lsn age超过log_sys->max_checkpoint_age_async

          
当前bp中最老lsn为0 （没有脏页）

        

        
当
check_flush_or_checkpoint
被设置时，用户线程在每次修改数据前调用
log_free_check
时，会根据该标记决定是否刷redo日志或者脏页。

      

    

    
注意log buffer遵循一定的格式，它以512字节对齐，和redo log文件的block size必须完全匹配。由于以固定block size组织结构，因此一个block中可能包含多个mtr提交的记录，也可能一个mtr的日志占用多个block。如下图所示：

    

    
Step 3：如果本次修改产生了脏页，获取
log_sys->log_flush_order_mutex
，随后释放
log_sys->mutex
。

    
Step 4. 将当前Mtr修改的脏页加入到flush list上，脏页上记录的lsn为当前mtr写入的结束点lsn。基于上述加锁逻辑，能够保证flush list上的脏页总是以LSN排序。

    
Step 5. 释放
log_sys->log_flush_order_mutex
锁

    
Step 6. 释放当前mtr持有的锁（主要是page latch）及分配的内存，mtr完成提交。

    
Redo 写盘操作

    
有几种场景可能会触发redo log写文件：

    

      
Redo log buffer空间不足时

      
事务提交

      
后台线程

      
做checkpoint

      
实例shutdown时

      
binlog切换时

    

    
我们所熟悉的参数
innodb_flush_log_at_trx_commit
 作用于事务提交时，这也是最常见的场景：

    

      
当设置该值为1时，每次事务提交都要做一次fsync，这是最安全的配置，即使宕机也不会丢失事务；

      
当设置为2时，则在事务提交时只做write操作，只保证写到系统的page cache，因此实例crash不会丢失事务，但宕机则可能丢失事务；

      
当设置为0时，事务提交不会触发redo写操作，而是留给后台线程每秒一次的刷盘操作，因此实例crash将最多丢失1秒钟内的事务。

    

    
下图表示了不同配置值的持久化程度：

    

    
显然对性能的影响是随着持久化程度的增加而增加的。通常我们建议在日常场景将该值设置为1，但在系统高峰期临时修改成2以应对大负载。

    
由于各个事务可以交叉的将事务日志拷贝到log buffer中，因而一次事务提交触发的写redo到文件，可能隐式的帮别的线程“顺便”也写了redo log，从而达到group commit的效果。

    
写redo log的入口函数为
log_write_up_to
，该函数的逻辑比较简单，这里不详细描述，但有几点说明下。

    
log_write_up_to逻辑重构

    
首先是在该代码逻辑上，相比5.6及之前的版本，5.7在没有更改日志写主要架构的基础上重写了
log_write_up_to
，让其代码更加可读，同时消除一次多余的获取
log_sys->mutex
，具体的(
WL#7050
)：

    

      
早期版本的innodb支持将redo写到多个group中，但现在只支持一个group，因此移除相关的变量，消除
log_write_up_to
的第二个传参；

      
write redo操作一直持有
log_sys->mutex
, 所有随后的write请求，不再进入condition wait, 而是通过log_sys->mutex序列化；

      
之前的逻辑中，在write一次redo后，需要释放
log_sys->mutex
，再重新获取，更新相关变量，新的逻辑消除了第二次获取 
log_sys->mutex
；

      
write请求的写redo无需等待fsync，这意味着写redo log文件和fsync文件可以同时进行。

    

    
理论上该改动可以帮助优化
innodb_flush_log_at_trx_commit=2
时的性能。

    
log write ahead

    
上面已经介绍过，InnoDB以512字节一个block的方式对齐写入ib_logfile文件，但现代文件系统一般以4096字节为一个block单位。如果即将写入的日志文件块不在OS Cache时，就需要将对应的4096字节的block读入内存，修改其中的512字节，然后再把该block写回磁盘。

    
为了解决这个问题，MySQL 5.7引入了一个新参数：
innodb_log_write_ahead_size
。当当前写入文件的偏移量不能整除该值时，则补0，多写一部分数据。这样当写入的数据是以磁盘block size对齐时，就可以直接write磁盘，而无需read-modify-write这三步了。

    
注意
innodb_log_write_ahead_size
的默认值为8196，你可能需要根据你的系统配置来修改该值，以获得更好的效果。

    
Innodb redo log checksum

    
在写入redo log到文件之前，redo log的每一个block都需要加上checksum校验位，以防止apply了损坏的redo log。

    
然而在5.7.7版本之前版本，都是使用的InnoDB的默认checksum算法（称为InnoDB checksum），这种算法的效率较低。因此在MySQL5.7.8以及Percona Server 5.6版本都支持使用CRC32的checksum算法，该算法可以引用硬件特性，因而具有非常高的效率。

    
在我的sysbench测试中，使用
update_non_index
，128个并发下TPS可以从55000上升到60000（非双1），效果还是非常明显的。

    
Redo checkpoint

    
InnoDB的redo log采用覆盖循环写的方式，而不是拥有无限的redo空间；即使拥有理论上极大的redo log空间，为了从崩溃中快速恢复，及时做checkpoint也是非常有必要的。

    
InnoDB的master线程大约每隔10秒会做一次redo checkpoint，但不会去preflush脏页来推进checkpoint点。

    
通常普通的低压力负载下，page cleaner线程的刷脏速度足以保证可作为检查点的lsn被及时的推进。但如果系统负载很高时，redo log推进速度过快，而page cleaner来不及刷脏，这时候就会出现用户线程陷入同步刷脏并做同checkpoint的境地，这种策略的目的是为了保证redo log能够安全的写入文件而不会覆盖最近的检查点。

    
redo checkpoint的入口函数为
log_checkpoint
，其执行流程如下：

    
Step1. 持有log_sys->mutex锁，并获取buffer pool的flush list链表尾的block上的lsn，这个lsn是buffer pool中未写入数据文件的最老lsn，在该lsn之前的数据都保证已经写入了磁盘。

    
Step 2. 调用函数fil_names_clear

    

      

        
如果
log_sys->append_on_checkpoint
被设置，表示当前有会话正处于DDL的commit阶段，但还没有完成，向redo log buffer中追加一个新的redo log记录

该逻辑由commita5ecc38f44abb66aa2024c70e37d1f4aa4c8ace9引入，用于解决DDL过程中crash的问题

      

      

        
扫描
fil_system->named_spaces
上的
fil_space_t
对象，如果表空间
fil_space_t->max_lsn
小于当前准备做checkpoint的Lsn，则从链表上移除并将max_lsn重置为0。同时为每个被修改的表空间构建MLOG_FILE_NAME类型的redo记录。（这一步未来可能会移除，只要跟踪第一次修改该表空间的min_lsn，并且min_lsn大于当前checkpoint的lsn，就可以忽略调用
fil_names_write
）

      

      
写入一个MLOG_CHECKPOINT类型的CHECKPOINT REDO记录，并记入当前的checkpoint LSN

    

    
Step3 . fsync redo log到当前的lsn

    
Step4. 写入checkpoint信息

    
函数：
log_write_checkpoint_info --> log_group_checkpoint

    
checkpoint信息被写入到了第一个iblogfile的头部，但写入的文件偏移位置比较有意思，当
log_sys->next_checkpoint_no
为奇数时，写入到LOG_CHECKPOINT_2（3 *512字节）位置，为偶数时，写入到LOG_CHECKPOINT_1（512字节）位置。

    
大致结构如下图所示：

    

      

    

    
在crash recover重启时，会读取记录在checkpoint中的lsn信息，然后从该lsn开始扫描redo日志。

    
Checkpoint操作由异步IO线程执行写入操作，当完成写入后，会调用函数
log_io_complete
执行如下操作：

    

      
fsync 被修改的redo log文件

      

        
更新相关变量：

        

          
 log_sys->next_checkpoint_no++
 log_sys->last_checkpoint_lsn = log_sys->next_checkpoint_lsn

        

      

      
释放log_sys->checkpoint_lock锁

    

    
然而在5.7之前的版本中，我们并没有根据即将写入的数据大小来预测当前是否需要做checkpoint，而是在写之前检测，保证redo log文件中有”足够安全”的空间（而非绝对安全）。假定我们的ib_logfile文件很小，如果我们更新一个非常大的blob字段，就有可能覆盖掉未checkpoint的redo log， 大神Jeremy cole 在buglist上提了一个
Bug#69477
。

    
为了解决该问题，在MySQL 5.6.22版本开始，对blob列做了限制: 当redo log的大小超过 (
innodb_log_file_size *innodb_log_files_in_group
)的十分之一时，就会给应用报错，然而这可能会带来不兼容问题，用户会发现，早期版本用的好好的SQL，在最新版本的5.6里居然跑不动了。

    
在5.7.5及之后版本，则没有5.6的限制，其核心思路是每操作4个外部存储页，就检查一次redo log是否足够用，如果不够，就会推进checkpoint的lsn。当然具体的实现比较复杂，感兴趣的参考如下comit：f88a5151b18d24303746138a199db910fbb3d071

    
文件日志

    
除了普通的redo log日志外，InnoDB还增加了一种文件日志类型，即通过创建特定文件，赋予特定的文件名来标示某种操作。目前有两种类型：undo table space truncate操作及用户表空间truncate操作。通过文件日志可以保证这些操作的原子性。

    
Undo tablespace truncate

    
我们知道undo log是MVCC多版本控制的核心模块，一直以来undo log都存储在ibdata系统表空间中，而从5.6开始，用户可以把undo log存储到独立的tablespace中，并拆分成多个Undo log文件，但无法缩小文件的大小。而长时间未提交事务导致大量undo空间的浪费的例子，在我们的生产场景也不是一次两次了。

    
5.7版本的undo log的truncate操作是基于独立undo 表空间来实现的。在purge线程选定需要清理的undo tablespace后，开始做truncate操作之前，会先创建一个命名为
undo_space_id_trunc.log
的文件，然后将undo tablespace truncate 到10M大小，在完成truncate后删除日志文件。

    
如果在truncate过程中实例崩溃重启，若发现该文件存在，则认为truncate操作没有完成，需要重做一遍。注意这种文件操作是无法回滚的。

    
User tablespace truncate

    
类似的，在5.7版本里，也是通过日志文件来保证用户表空间truncate操作的原子性。在做实际的文件操作前，创建一个命名为
ib_space-id_table-id_trunc.log
的文件。在完成操作后删除。

    
同样的，在崩溃重启时，如果检查到该文件存在，需要确认是否重做。

    
InnoDB shutdown

    
实例关闭分为两种，一种是正常shutdown（非fast shutdown），实例重启时无需apply日志，另外一种是异常shutdown，包括实例crash以及fast shutdown。

    
当正常shutdown实例时，会将所有的脏页都刷到磁盘，并做一次完全同步的checkpoint；同时将最后的lsn写到系统表ibdata的第一个page中（函数
fil_write_flushed_lsn
）。在重启时，可以根据该lsn来判断这是不是一次正常的shutdown，如果不是就需要去做崩溃恢复逻辑。

    
参阅函数
logs_empty_and_mark_files_at_shutdown
。

    
关于异常重启的逻辑，由于崩溃恢复涉及到的模块众多，逻辑复杂，我们将在下期月报单独进行描述。

  

  

    

    

    
Test Book

  

  

    
问题背景

    
我们在管理繁忙的 MySQL 数据库时，可能都有碰到 SYS CPU 高的经历：系统突然 SYS CPU 高起来，甚至比 USER CPU 高很多，这时系统 QPS、TPS 急剧下降。

    
SYS CPU高是什么造成的呢？主要有2种可能：

1. context switch 不高，但在内核态 spin，导致 SYS CPU 高

2. context switch 高，每秒超过 200K，有时超过1M，过多 context switch 导致 SYS CPU 高

    
下面我们对这两种情况逐一分析。

    
context switch 不高，但在内核态 spin

    
MySQL 在内核态 spin，说明需要系统资源，当这个资源紧张不足时，就会在内核态 spin。

    
有些资源，用户进程（或线程）通过执行系统调或因中断进入内核，一般来说申请这些资源的执行时间很短，当出现资源争用时，如果采用 sleep 再唤醒机制，代价较大，因此多采用在内核态spin的策略。

    
例如申请内存或发生缺页中断，没有 free 内存可用时，进程或线程就可能在内核态先执行内存回收再执行内存分配，但系统内存是共享资源，分配回收时需要锁保护，当多个进程（或线程）同时回收分配内存时。就会在内核态 spin。

    
当 free 内存不足时，可能出现这种情况。典型症状：

    

      
MySQL running 高，但系统 qps、tps 下降

      
系统 free 内存不足；或系统 free 内存充足时，但启用了 numa 内存分配策略，有的节点 free 内存很少

      
系统 context switch 不高

      
MySQL InnoDB 的 mutex、RWlock 查不到等待信息

      
sar -B 显示有 pgscand 产生

    

    
分析

    
当系统内存不足时，MySQL 突然有大量访问，紧急需要大量内存，kswapd 在短时间内回收不了足够多的 free 内存，或 kswapd 还没有触发执行，这时 MySQL 用户线程就会在内核态执行内存回收操作，从而出现以上症状。

    
sar -B 输出中，pgscank 是表示内核线程 kswapd 回收内存，k意思是 kernel；pgscand是表示用户进程或线程直接回收内存，d意思是direct。

    
解决办法：保证系统有充足 free 内存可用，NUMA 环境要求每个节点都有足够free内存可用。

    
由于 Linux 系统会尽量使用 free 内存，一个运行很久的 Linux 系统，free内存通常很少，存在大量 filecache 内存，但 Linux 没有直接提供控制 filecache 占用多少的参数，那怎么能够保留足够可用的 free 内存，以应对突然内存需求呢？

    
对此，Linux 2.3.32+ 内核中增加一个新的参数
vm.extra_free_kbytes
，就是控制free内存的。

    
关于系统free内存，有2个重要参数：
vm.min_free_kbytes
 和 
vm.extra_free_kbytes
(2.6.32+)

    

vm.min_free_kbytes
：系统保留给内核用的内存。

    
这个值决定 
/proc/zoneinfo
 中 zone 的min值。当系统 free 内存小于这个值时，kswapd 会回收内存，直到free内存达到
/proc/zoneinfo
中 high 值才停止回收；

    
当用户进程或线程分配内存或发生缺页中断时，free 内存少于 
vm.min_free_kbytes
，会在用户线程上下文中直接进行回收内存（pgscand）和分配内存。

    

vm.extra_free_kbytes
：系统保留给应用的free内存。

    
这个值决定了
/proc/zoneinfo
中Normal zone的low值。当系统free内存小于
vm.min_free_kbytes + vm.extra_free_kbytes
 时，kswapd会开始回收内存，直到free内存达到 
/proc/zoneinfo
 中high值才停止回收。

    
这个额外的
vm.extra_free_kbytes
就是给应用突发内存需求时使用的，避免急需内存时发生pgscand或kswapd回收内存不及时。

    

vm.extra_free_kbytes
 分配多大合适呢？一般能应对流量高峰时1-2秒内存需求就可以了。free内存减少后，kswapd进程会在后台回收内存的，一般512M-2G可以满足要求。

    
context switch 高

    
有很多种情况都会导致 context switch。MySQL 中的 mutex 和 RWlock 在获取不成功后，短暂spin，还不成功，就会发生 context switch，sleep，等待唤醒。

    
在 MySQL中，mutex 和 RWlock导致的 context switch，一般在
show global status
,
show engine innodb mutex
,
show engine innodb status
,
performance_schema
等中会体现出来，针对不同的mutex和RWlock等待，可以采取不同的优化措施。

    
除了MySQL的mutex和RWlock，还发现一种情况，是MySQL外的mutex竞争导致context switch高。

    
典型症状：

    

      
MySQL running 高，但系统 qps、tps 低

      
系统context switch很高，每秒超过200K

      
在 MySQL 内存查不到mutex和RWlock竞争信息

      
SYS CPU 高，USER CPU 低

      
并发执行的SQL中出现timestamp字段，MySQL的time_zone设置为system

    

    
分析

    
对于使用 timestamp 的场景，MySQL 在访问 timestamp 字段时会做时区转换，当 time_zone 设置为 system 时，MySQL 访问每一行的 timestamp 字段时，都会通过 libc 的时区函数，获取 Linux 设置的时区，在这个函数中会持有mutex，当大量并发SQL需要访问 timestamp 字段时，会出现 mutex 竞争。

    
MySQL 访问每一行都会做这个时区转换，转换完后释放mutex，所有等待这个 mutex 的线程全部唤醒，结果又会只有一个线程会成功持有 mutex，其余又会再次sleep，这样就会导致 context switch 非常高但 qps 很低，系统吞吐量急剧下降。

    
解决办法：设置time_zone=’+8:00’，这样就不会访问 Linux 系统时区，直接转换，避免了mutex问题。

    
另外，对于spin消耗，MySQL配置变量中的
innodb_spin_wait_delay
 和 
innodb_sync_spin_loops
 可以用于微调。

    

      
作者介绍

高亚芳 北京理工大学计算机系毕业，IT行业老兵，目前负责数据存储基础架构工作，开源爱好者。

    

  

  

    

    

    
Test Book

  

  

    
bug 背景

    
RDS的备份工具用的是 Percona-XtraBackup（后面简称PXB），这个工具包里有2个重要的工具，innobackupex和xtrabackup，后者是C编译出的二进制文件，负责备份 InnoDB 数据，前者是一个Perl 脚本，对后者进行封装，同时负责备份非 InnoDB 数据。xtrabackup 二进制里内嵌了InnoDB引擎，所以能很好的处理InnoDB数据。在2.2版本之前，PXB 分别针对不同版本的 MySQL 源码（5.1/5.5/5.6）编译了不同版本的xtrabackup，以便备份不同版本的MySQL数据，然而在2.2之后，PXB官方觉得5.6已经可以很好的兼容5.1和5.5，所以就只针对 5.6.22 版本的代码编译了一个 xtrabackup 二进制文件，关于这个改动可以看官方的BP 
#single binary
。故事就由此发生。。。

    
bug 描述

    
当我们对5.5版本的备份集进行还原的时候，xtrabackup crash 了，报错信息如下：

    

      
2015-05-12 19:03:08 7fd9d8258720  InnoDB: Assertion failure in thread 140573610968864 in file pars0pars.cc line 865
InnoDB: Failing assertion: sym_node->table != NULL
InnoDB: We intentionally generate a memory trap.
InnoDB: Submit a detailed bug report to http://bugs.mysql.com.
InnoDB: If you get repeated assertion failures or crashes, even
InnoDB: immediately after the mysqld startup, there may be
InnoDB: corruption in the InnoDB tablespace. Please refer to
InnoDB: http://dev.mysql.com/doc/refman/5.6/en/forcing-innodb-recovery.html
InnoDB: about forcing recovery.
11:03:08 UTC - xtrabackup got signal 6 ;
This could be because you hit a bug or data is corrupted.
This error can also be caused by malfunctioning hardware.
We will try our best to scrape up some info that will hopefully help
diagnose the problem, but since we have already crashed,
something is definitely wrong and this may fail.

Thread pointer: 0x176aeb0
Attempting backtrace. You can use the following information to find out
where mysqld died. If you see no messages after this, something went
terribly wrong...
stack_bottom = 0 thread_stack 0x10000
xtrabackup(my_print_stacktrace+0x35) [0x9f5331]
xtrabackup(handle_fatal_signal+0x2bb) [0x7f801b]
/lib64/libpthread.so.0() [0x3530c0f500]
/lib64/libc.so.6(gsignal+0x35) [0x35f40328a5]
/lib64/libc.so.6(abort+0x175) [0x35f4034085]
xtrabackup() [0x76bfb0]
xtrabackup(pars_update_statement(upd_node_t*, sym_node_t*, void*)+0x30) [0x76c8d8]
xtrabackup(yyparse()+0xcb1) [0xa5ef27]
xtrabackup(pars_sql(pars_info_t*, char const*)+0xaf) [0x76e06d]
xtrabackup(que_eval_sql(pars_info_t*, char const*, unsigned long, trx_t*)+0x85) [0x78eeb2]
xtrabackup(row_drop_table_for_mysql(char const*, trx_t*, bool, bool)+0xa98) [0x720a0c]
xtrabackup(row_mysql_drop_temp_tables()+0x24c) [0x721503]
xtrabackup(recv_recovery_rollback_active()+0x2c) [0x753ebe]
xtrabackup(innobase_start_or_create_for_mysql()+0x17aa) [0x7293c4]
xtrabackup() [0x607a00]
xtrabackup() [0x610204]
xtrabackup(main+0x8b8) [0x611674]
/lib64/libc.so.6(__libc_start_main+0xfd) [0x35f401ecdd]
xtrabackup() [0x604369]

    

    
bug 分析

    
从crash的信息
InnoDB: Assertion failure in thread 140573610968864 in file pars0pars.cc line 865
，可以定位的crash的代码点

    

      
862|                sym_node->table = dict_table_open_on_name(
863|                        sym_node->name, TRUE, FALSE, DICT_ERR_IGNORE_NONE);
864|
865|                ut_a(sym_node->table != NULL);

    

    
可以看到，是 InnoDB 在试图打开一张表的时候，打开失败，直接 assert 了。

    
分析调用堆栈，是xtrabackup在恢复数据的时候，启动了内嵌的 InnoDB 引擎，在活跃事务回滚的时候，会将备份时候存在的临时表全部 drop 掉。在删除表的时候，除了要删除表本身，还需要删除在 InnoDB 系统表中的记录，删除记录是通过内部执行sql的方式做的
que_eval_sql
，其中有这么一段sql

    

      
4195|                           "DELETE FROM SYS_TABLESPACES\n"
4196|                           "WHERE SPACE = space_id;\n"
4197|                           "DELETE FROM SYS_DATAFILES\n"
4198|                           "WHERE SPACE = space_id;\n"

    

    
SYS_TABLESPACES 和 SYS_DATAFILES 这2个系统表是在5.6中才有的，5.5是没有的，所以在调用 
dict_table_open_on_name
 的时候就打不开 SYS_TABLESPACES 表，导致CRASH。

    
bug修复

    
这里给一个简单的修复方法，就是在调用 
que_eval_sql
 删除记录前判断下当前数据是否是5.6的，如果是就传原来的sql，如果不是，就传去掉 SYS_TABLESPACES 和 SYS_DATAFILES 的sql。PXB官方已经确认这个bug 
#1399471
，目前尚未修复，应该会在下个版本修掉。

如果等不及的话，可以有2种选择：

1. 代码修复，用这里提供的方法；

2. 版本回退，在恢复的时候，临时用PXB 2.1版本中的 xtrabackup_55 替换 xtrabckup。

    
bug 影响

    
从上面的分析可以得到，要触发这个bug，需要这些条件：

1. PXB版本是2.2以上

2. MySQL版本是5.5/5.1

3. 备份的时候有持有临时表的回话。

    
当满足上面这些条件，恢复数据就会crash。

    
PXB备份出来的idb数据时间点是不一致的，恢复数据时需要应用redo将数据追到一个一致的点，效果上就相当于 MySQL 异常关闭，buffer pool 有数据没有落盘，然后重启应用redo做崩溃恢复。所以这个场景只有在用PXB才容易出现，对正常使用的mysqld来说一般是不会的，因为我们在升级的时候都是正常关闭 mysqld，这是临时表都被清理干净了，后再用新版mysqld启动，所以新版mysqld启动时就不需要做drop临时表的操作，自然不会crash了。

  

  

    

    

    
Test Book

  

  

    
背景

    
目前，IO 仍然是数据库的性能杀手，为了提高 IO 利用率和吞吐量，不同的数据库都设计了不同的方法，本文就介绍下 InnoDB 提供的预读(read-ahead)功能，以及 Oracle 提供的多块读(multiblock-read)功能，并进行一些对比。

    
InnoDB read-ahead

    
InnoDB 提供了两种预读的方式，一种是 Linear read ahead，由参数
innodb_read_ahead_threshold
控制，当你连续读取一个 extent 的 threshold 个 page 的时候，会触发下一个 extent 64个page的预读。另外一种是Random read-ahead，由参数
innodb_random_read_ahead
控制，当你连续读取设定的数量的page后，会触发读取这个extent的剩余page。

    
InnoDB 的预读功能是使用后台线程异步完成的。InnoDB启动了
innodb_read_io_threads
个后台线程，来完成IO request，并且可以使用Native AIO，在你的环境中如果安装了libaio，在MySQL实例启动的时候，查看系统日志：
InnoDB: Using Linux native AIO
 表明 InnoDB 已经使用Native AIO了。在Linear read ahead触发的时候，InnoDB通过
io_submit()
提交了下一个extent的64个pages的IO request，并由一个read IO thread完成。

    
Oracle multiblock-read

    
当你要对堆表进行全表扫描，并需要大量IO的时候，通常在 session 级别设置
db_file_multiblock_read_count
，这样 Oracle 会在读取堆表结构的数据块的时候，一次IO读取多个数据块，大大减少了IO的次数。但这里一次合并IO请求的数据块，必须不能在buffer pool中，否则会分割IO请求。不过，在针对大表的汇总分析查找中，设置
db_file_multiblock_read_count
的效果是非常明显的。不过也要注意，不要在系统级别上设置过大的
db_file_multiblock_read_count
， 会造成buffer cache flooding。

    
场景分析

    
下面我们看两个非常典型的场景:

    
1. 高并发，小IO的情况

在高并发的场景下，sql响应时间主要取决于同步IO请求的时间，而InnoDB的预读通常不会触发，就算触发，更多的是预热(warmup)的效果，并不会对系统带来非常大的收益，对rt的影响也非常小。

而Oracle如果设置了
db_file_multiblock_read_count
，在这样的场景下，有可能会适得其反，因为一次同步IO请求的时间增加了。

    
所以在这样的场景下，InnoDB的read-ahead和Oracle的multiblock-read并不会带来太多的收益。我们看另外一个场景。

    
2. 低并发，高IO吞吐

通常，我们可能想在业务低峰期，对线上数据进行汇总查询。这时，希望能够完全使用主机的资源来完成sql的查询，在使用全表扫描的时候，InnoDB会触发read-ahead，每次提前异步读取下一个extent的page，加快读取的速度。

Oracle使用
db_file_multiblock_read_count
，一次IO读取多个block，提高读取的吞吐量。

    
问题

    
为什么在聚集查询的时候，Oracle的效果会比InnoDB要好？

    
这个问题，在针对机械盘的情况，又回到了 IOPS 和 throughput 的讨论上去了。InnoDB的read-ahead，在触发的时候，针对下一个extent，对每一个page提交了异步IO请求，也就是增加了IO request次数，虽然Native AIO和disk会有针对性合并IO，但仍然非常有限，而Oracle每次提交合并多个连续数据块的IO请求，能够更好利用disk的吞吐能力。

    
所以，InnoDB在针对aggregation类型的查询的时候，想要完全使用IO的吞吐能力，相比较Oracle的multiblock-read，会偏弱一点。

    
优化方法

    
针对InnoDB的机制，我们可以尝试几种优化方法:

    

      
在session级别，提供可设置预读的触发条件，并使用多个后台线程来完成异步IO请求。因为没有减少小IO请求，作者尝试了这种方法，收益甚小；

      
独立一个buffer pool，专门进行多块读，针对next extent，一次读取到buffer pool中，这种方式就和Oracle的multiblock-read比较类似了；

      
终极优化方法，就是使用并行查询，Oracle在全表扫描的时候，使用
/* parallel */
 hint方法启动多个进程完成查询，InnoDB的聚簇索引结构，需要逻辑分片，针对每一个分片启动一个线程完成查询。

    

    
读者如果有兴趣，可以进行一些尝试。

  

  

    

    

    
Test Book

  

  

    
虽然PG 9.4发布不过半年时间，下一个大版本9.5却已经进入人们的视野。按目前的情况，2015年上半年可能发布beta版本，下半年正式发布PG 9.5。9.5里面最令人瞩目的一个新功能恐怕是BRIN索引了。下面这个commit加入了对BRIN索引的支持：

    

      
commit: 7516f5259411c02ae89e49084452dc342aadb2ae

author: Alvaro Herrera 
alvherre@alvh.no-ip.org

date: Fri, 7 Nov 2014 16:38:14 -0300

BRIN: Block Range Indexes

      
BRIN is a new index access method intended to accelerate scans of very

large tables, without the maintenance overhead of btrees or other

traditional indexes. They work by maintaining “summary” data about

block ranges. Bitmap index scans work by reading each summary tuple and

comparing them with the query quals; all pages in the range are returned

in a lossy TID bitmap if the quals are consistent with the values in the

summary tuple, otherwise not. Normal index scans are not supported

because these indexes do not store TIDs.

    

    
BRIN即Block Range Indexes，顾名思义，就是对数据块区段所做的索引。其实它的设计思路很简单，就是通过扫描整个表，记录下每个固定区段（例如第1到128号数据块）所含数据被索引字段的最大值和最小值，依次存入索引空间。当处理某个查询，需要找到符合查询条件的记录时，可以使用BRIN索引，跳过与查询条件不符合的区段，加速查找。下面我们分析一下这种新型索引的使用方法和内核实现。

    
使用

    
下面我们创建一个有一百万记录的表，然后为其建立BRIN索引，再在表上做查询：

    

      
postgres=# create table t AS SELECT generate_series(1,100000000) AS id;
SELECT 100000000
postgres=# \timing
Timing is on.
postgres=# create index idx_brin on t using brin(id);
CREATE INDEX
Time: 72766.822 ms

postgres=# explain analyze select * from t where id = 507654;
                                                     QUERY PLAN
-----------------------------------------------------------------------------------------
 Bitmap Heap Scan on t  (cost=52.01..56.02 rows=1 width=4) (actual time=26.046..41.431 rows=1 loops=1)
   Recheck Cond: (id = 507654)
   Rows Removed by Index Recheck: 28927
   Heap Blocks: lossy=128
   ->  Bitmap Index Scan on idx_brin  (cost=0.00..52.01 rows=1 width=0) (actual time=6.408..6.408 rows=1280 loops=1)
         Index Cond: (id = 507654)
 Planning time: 8.265 ms
 Execution time: 42.575 ms
(8 rows)

Time: 67.897 ms

    

    
可见，使用BRIN避免了全表扫描，执行时间为67ms左右。下面我们对比一下，如果不使用BRIN，耗时多少（注意，我们做下面操作之前，清空了操作系统pagecache，并重启了PG）：

    

      
postgres=# drop index idx_brin;
DROP INDEX

postgres=# explain analyze select * from t where id = 507654;
                                              QUERY PLAN
----------------------------------------------------------------------------------------
 Seq Scan on t  (cost=0.00..1692478.00 rows=1 width=4) (actual time=194.665..35124.454 rows=1 loops=1)
   Filter: (id = 507654)
   Rows Removed by Filter: 99999999
 Planning time: 6.345 ms
 Execution time: 35125.633 ms
(5 rows)

    

    
执行时间35s左右！原因在于，使用BRIN索引时，实际只读取了一个区段里的数据块，而全表扫描时，则读取所有数据块。

    
实现

    
存储结构

    
BRIN索引的存储结构如下图所示：

    

    
BRIN索引由一组相同结构的索引块组成，每个索引块含有固定数目的索引记录，每条记录里面含有一个指向最值块的指针。最值块里面的每条记录存放了区段最大和最小值，及其对应的数据区段起始块的块号。要想定位某个数据块对应的BRIN索引记录，可以按下面的公式，计算索引块号和索引记录的位置：

    

      
索引块号 =（数据块号 / 每个区段包含的块数） / 每个索引块含有的索引记录数
索引记录的位置 = （数据块号 / 每个区段包含的块数）% 每个索引块含有的索引记录数

    

    
例如，如果一条数据记录所在数据块块号为1000，而在缺省情况下BRIN索引每个区段包含的块数为128（可以在创建索引时，通过
WITH (pages_per_range = xxx)
子句来修改），而每个索引块的索引记录数固定（约为8K/6)，这样可以很容易按照公式找到对应索引记录。而由索引记录里面存放的指针，可以读取到对应最值块和最值记录。

    
索引构建

    
BRIN索引的构建过程比较简单，需要对原表做一次全表扫描，每扫描完一个区段，相应的索引块和最值块也构建完成。值得注意的是，对于最后一个区段，如果所含的块数不足，则不会为其构建最值记录；而是等到数据块数达到一个完整区块时，才为其计算最值。这样的设计，有利于提高从表尾部大规模插入数据时的性能。

    
查询操作

    
使用BRIN索引处理查询时，PG会从头开始，检查所有的索引记录，并用索引记录指向的最值记录与查询条件相比较，从而判断对应区段是否可能包含符合查询条件的数据；最后得到所有相关区段列表，再顺序读取这些区段中的数据块进行比较，返回实际符合查询条件的数据记录。

    
插入操作

    
BRIN索引插入操作的接口函数为
brininsert
，在一个数据记录被插入到数据块后被调用。其过程主要是利用数据块号，按照上面提到的定位过程，找到对应的最值记录，然后比较最值和插入的数据记录值。如果最大值小于该数据记录值，或最小值大于数据记录值，则更新最大或最小值。值得注意的是，插入操作如果要更新索引或最值记录，是要锁定整个块的，这样多个并行插入对索引的修改是很容易冲突的，就是说BRIN索引会一定程度上降低并行插入的性能。

    
删除和更新操作

    
BRIN索引的所有接口函数可以在
pg_am.h
中找到。但令人疑惑的是，只有插入（insert）的接口函数，没有针对删除（delete）或更新（update）的函数。其实，和PG其他类型的索引类似，BRIN索引也是不需要执行删除操作的。删除一条数据记录时，BRIN索引不做修改。即使在对一个表做VACUUM操作时，也同样不需修改BRIN索引（注意，对于其他索引如B树索引，在VACUUM操作时会修改索引删除无效索引记录）。另一方面，对于更新操作，相当于一次删除加一次插入操作，由于不需要对索引做删除操作，实际只做了一次索引插入。

    
小结

    
通过上面分析，不难看出，这种BRIN索引适用于下面的场景：

    

      
非常大的表，如果创建B树索引，会占用较大空间；采用BRIN，不失为一种时间换空间的方法（BRIN比B树索引处理查询时会慢一些）；

      
经常大批量尾部插入的表，这些表如果创建了B树索引，会引起索引尾部更新的互斥；而使用BRIN索引，尾部数据块的索引记录只在满了一个区段时才进行一次插入，减少了互斥的情况。

    

    
BRIN是PG 9.5一个令人期待的新功能，对于BRIN将给PG带来的性能、易用性方面的变化，我们拭目以待。

  

  

    

    

    
Test Book

  

  

    
背景

    
MySQL保存了两份元数据，一份在server层，保存在FRM文件中，另外一份在引擎层，比如InnoDB的数据字典中，这样也就造成了DDL语句经常导致元数据不一致的情况，下面介绍两个近期出现的因为DDL产生的bug。

    
rename 外键引用的column

    
BUG复现过程

    

      
CREATE TABLE t1 (a INT NOT NULL,
                 b INT NOT NULL,
                 INDEX idx(a)) ENGINE=InnoDB;

CREATE TABLE t2 (a INT KEY,  b INT, INDEX ind(b),
                 FOREIGN KEY (b) REFERENCES t1(a)
                 ON DELETE CASCADE
                 ON UPDATE CASCADE) ENGINE=InnoDB;

ALTER TABLE t1 CHANGE a id INT;

    

    
在DEBUG版本下，MySQL实例是crash的，crash在 
handler0alter.cc
 line 5643。

    
BUG原因分析

    
在做alter语句的时候，因为rename的column关联有foreign key，所以需要在数据字典中更改这个foreign key，但在数据字典缓存中还保留了一份foreign对象，代码只做了持久化的更改，在重新
dict_load_foreigns()
的时候，和缓存中的foreign key冲突，导致函数报错。

    
BUG修复方法

    
BUG修复也比较简单，在rename的过程中，先更改数据字典，然后调用
dict_foreign_remove_from_cache
函数清理内存中的对象，这样在重新
dict_load_foreigns
的时候，就一切正常了。

    
MySQL官方版本在5.6.23修复了这个问题。

    
alter 添加和删除索引导致不一致

    
BUG复现过程

    

      
CREATE TABLE t1(id INT, col1 INT, col2 INT, KEY(col1))ENGINE=InnoDB;
alter table t1 add key(col2), drop key col1;

    

    
复现此BUG的时候需要使用DEBUG_SYNC，在alter table的过程中，add key(col2)步骤成功，而在drop key的时候InnoDB报失败。

然后导致MySQL server层对表t1的定义和InnoDB层的定义不一致。

    
BUG原因分析

在drop key报引擎失败的时候，MySQL server层开始回滚整个DDL语句，server层这时回滚了FRM的定义，而InnoDB成功添加的key(col2)却没有回滚。

    
BUG修复方法

在alter的过程中，记录每一个阶段成功的调用，在语句结束的时候，如果遇到需要回滚的statement，需要同时回滚引擎层和server层。

    
因为MySQL保存了两份元数据，也造成在DDL变更的过程中，无法保证数据的一致性。

  

  

    

    

    
Test Book

  

  

    
背景

    
最近有同事问，set names 时会同时设置了3个session变量

    

      
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET character_set_connection = charset_name;

    

    
就从变量名字来看，character_set_client 是设置客户端相关的字符集，character_set_results 是设置返回结果相关的字符集，character_set_connection 这个就有点不太明白了，这个有啥用呢？

    
概念说明

    
通过
官方文档
来看:

    

      
character_set_client 是指客户端发送过来的语句的编码;

      
character_set_connection 是指mysqld收到客户端的语句后，要转换到的编码；

      
而 character_set_results 是指server执行语句后，返回给客户端的数据的编码。

    

    
对人来说，能够理解的是各种各样的符号，而对计算机来说，只能理解二进制，二进制和符号之间的对应关系就是编码。不同地域国家都有自己的一套符号集合，每个都各自用一组二进制数字表示，从而形成了不同的编码，字符集就可以看作是编码和符号的对应关系集合。同一个二进制数在不同的字符集下可能对应完全不一样的字符，如在GBK字符集中，
C4E3
 对应的是
你
，而在big5字符集中对应的是
斕
，而 
你
在unicode中的编码是
4F60
，在
Collation-Charts
这个网站有字符集和编码对应关系图，可以非常直观地看到不同编码下二进制数和符号的对应关系。

    
set names 设置的3个变量就是设置mysqld和客户端通信时，mysqld应该如何解读client发来的字符，以及返回给客户端什么样的编码。

    
实验测试

    
环境如下：

    

      
mysql> show variables like 'character%';
+--------------------------+-------------------------------------+
| Variable_name            | Value                               |
+--------------------------+-------------------------------------+
| character_set_client     | utf8                                |
| character_set_connection | utf8                                |
| character_set_database   | utf8                                |
| character_set_filesystem | binary                              |
| character_set_results    | utf8                                |
| character_set_server     | utf8                                |
| character_set_system     | utf8                                |

    

    
server端的3个编码设置都是utf8。

另外，客户端是标准 mysql client，使用的编码是utf8，和sever端编码是一致的。

    
建一张表作为测试

    

      
CREATE TABLE t1(id INT, name VARCHAR(200) CHARSET utf8) engine=InnoDB;

INSERT INTO t1 VALUES(0, '你好');
mysql> SELECT id, name, hex(name) FROM t1;
+------+--------+--------------+
| id   | name   | hex(name)    |
+------+--------+--------------+
|    0 | 你好   | E4BDA0E5A5BD |
+------+--------+--------------+

    

    
下面我们分别改变这3个值，来看下结果会有什么变化

    
Case 1 只改变 character_set_client

    

      
SET character_set_client=gbk;
INSERT INTO t1 VALUES(1, '你好');
mysql>  SELECT id, name, hex(name) FROM t1;
+------+-----------+--------------------+
| id   | name      | hex(name)          |
+------+-----------+--------------------+
|    0 | 你好      | E4BDA0E5A5BD       |
|    1 | 浣犲ソ    | E6B5A3E78AB2E382BD |
+------+-----------+--------------------+
2 rows in set (0.00 sec)

    

    
可以看到返回的数据已经乱码了，并且数据库里存的确实和第一条记录不一样。

    
case 2 只改变 character_set_connection

    

      
SET names utf8;
SET character_set_connection = gbk;
INSERT INTO t1 VALUES(2, '你好');

mysql>  SELECT id, name, hex(name) FROM t1;
+------+-----------+--------------------+
| id   | name      | hex(name)          |
+------+-----------+--------------------+
|    0 | 你好      | E4BDA0E5A5BD       |
|    1 | 浣犲ソ    | E6B5A3E78AB2E382BD |
|    2 | 你好      | E4BDA0E5A5BD       |
+------+-----------+--------------------+
3 rows in set (0.00 sec)

    

    
case 3 只改变 character_set_results

    

      
SET names utf8;
SET character_set_results = gbk;
INSERT INTO t1 VALUES(3, '你好');

mysql> select id, name, hex(name) from t1;
+------+--------+--------------------+
| id   | name   | hex(name)          |
+------+--------+--------------------+
|    0 |        | E4BDA0E5A5BD       |
|    1 | 你好   | E6B5A3E78AB2E382BD |
|    2 |        | E4BDA0E5A5BD       |
|    3 |        | E4BDA0E5A5BD       |
+------+--------+--------------------+
4 rows in set (0.00 sec)

    

    
再改回原样，看下结果

    

      
SET names utf8;
mysql>  SELECT id, name, hex(name) FROM t1;
+------+-----------+--------------------+
| id   | name      | hex(name)          |
+------+-----------+--------------------+
|    0 | 你好      | E4BDA0E5A5BD       |
|    1 | 浣犲ソ    | E6B5A3E78AB2E382BD |
|    2 | 你好      | E4BDA0E5A5BD       |
|    3 | 你好      | E4BDA0E5A5BD       |
+------+-----------+--------------------+
4 rows in set (0.00 sec)

    

    
分析

    
我们先理下字符集在整个过程中是怎样变化的，然后再分析上面的case

    
客户发送请求时：

    

      
A1 客户端发送出语句(总是以utf8)------> A2 sever收到语句解析(按character_set_client指定编码)
                                                                    |
                                                                    v
A4 数据进入mysqld内部存储<--------- A3 sever判断是否需要转换编码(以character_set_connection 目标编码)

    

    
server返回结果时：

    

      
B1 server返回结果(按character_set_results 指定编码) ----->B2客户端解析编码显示(总是以utf8)

    

    
A3步是否需要转换编码，代码中的逻辑是这样的，在sql_yacc.yy文件中：

    

      
  LEX_STRING tmp;
  THD *thd= YYTHD;
  const CHARSET_INFO *cs_con= thd->variables.collation_connection;
  const CHARSET_INFO *cs_cli= thd->variables.character_set_client;
  uint repertoire= thd->lex->text_string_is_7bit &&
                   my_charset_is_ascii_based(cs_cli) ?
                   MY_REPERTOIRE_ASCII : MY_REPERTOIRE_UNICODE30;
  if (thd->charset_is_collation_connection ||
      (repertoire == MY_REPERTOIRE_ASCII &&
       my_charset_is_ascii_based(cs_con)))
     tmp= $1;
  else
  {
    if (thd->convert_string(&tmp, cs_con, $1.str, $1.length, cs_cli))
        MYSQL_YYABORT;
  }
  $$= new (thd->mem_root) Item_string(tmp.str, tmp.length, cs_con,
                                      DERIVATION_COERCIBLE,
                                      repertoire);
  if ($$ == NULL)
     MYSQL_YYABORT;

    

    
如果 
character_set_client
 和 
character_set_connection
 一样，或者当前的字符编码是和ASCII兼容，并且都是ASCII范围内的，就不转换，其它情况就转。

    
对于case1

实际上客户端发过来是UTF8的，但A2步骤server认为客户端的编码是GBK的，就按GBK来解析，同时满足A3步骤的转换条件，所以就误将UTF8编码认为是GBK，然后又给转成了UTF8。

你好
的UTF8编码是 
E4BDA0E5A5BD
 6个字节，每个字符3个字节，按GBK来解析的话，因为GBK是固定2个字节，就认为有3个字符，然后转成UTF8，虽然UTF8是变长的，但是这里的3个GBK字符按值都是要占3个字节的，转出来一共9个字节。所以case1看到的实际存储的值一共9个字节，比原来的大。

在返回时，是按UTF8返回的，因为存了3个UTF8字符，所以客户端看到的就是3个。

    
对于case2

A2步骤没问题，问题是出在A3，按照转换逻辑，此时需要把UTF8转成GBK，这里因为
character_set_client
是正确的，所以转换的源不会识别错，转换成GBK自然也不会错，后面存储成UTF8时，再从GBK转成UTF8，也没错，因为UTF8和GBK字符集里都包含 ‘你’和’好’，所以相互转换也不会出错，只是多了2次转换。

    
对于case3

错在返回字符集设置的和客户端不匹配，在返回时，server将所有字符转成GBK的，结果客户端一根筋的认为是UTF8，就解析错了。

比较有意思的是第二条记录，即case1错误插进去的，显示出来是对的。

为什么呢，因为在case1中存的时候，是按 
UTF8->强制解析为GBK->然后转为UTF8
 这个逻辑存下去的，而返回的时候，因为server会将存的UTF8又给转回GBK，然后客户端又拿着这个GBK误以为是UTF8解析，实际上是case1的逆向过程，虽然2个方向都是错的，最终显示是好的，所谓的负负得正吧，哈哈。

    
对于case2 ，数据从客户端进入server的时候，多做了2次转换，最终显示还是对的，但不是所有场景都是这样，如下面这种

    

      
set names utf8;
set character_set_connection  = latin1;
INSERT INTO t1 VALUES(4, '你好');
set names utf8;
mysql>  SELECT id, name, hex(name) FROM t1;
+------+-----------+--------------------+
| id   | name      | hex(name)          |
+------+-----------+--------------------+
|    0 | 你好      | E4BDA0E5A5BD       |
|    1 | 浣犲ソ    | E6B5A3E78AB2E382BD |
|    2 | 你好      | E4BDA0E5A5BD       |
|    3 | 你好      | E4BDA0E5A5BD       |
|    4 | ??        | 3F3F               |
+------+-----------+--------------------+
5 rows in set (0.00 sec)

    

    
为什么呢，因为在 UTF8转latin1时，信息丢失了，latin1字符编码所能表达的字符集是远小于utf8的，
你
 和 
好
就不在其中，这2个字符在转换中被转成了 
?
 和 
?
，之后存储转换成UTF8时，
?
只有一个字节
3F
，还原回去还是 
3F
。

    
总结

    

character_set_client
 和 
character_set_results
 是一定要和客户端一致，不要依赖于负负得正，
character_set_connection
 设置和
character_set_client
 不一致，有丢失数据的风险，所以尽量也一致，总之这3个值就是要一样，还要和客户端一致，所以才有了 set names 这个快捷命令。关于为啥要有 
character_set_connection
 这一步转换，笔者目前还没看出来，以后理解了再更新，如果读者朋友知道的话，请不吝赐教。

  

  

    

    

    
Test Book

  

  

    
bug描述

    
在binlog_format=row模式下，事务中create或drop临时表后，后面再执行DML（影响多行的DML)如果失败，那么失败的DML会回滚，但DML仍然记录了binlog。这个 binlog 应用到备库后会导致主备不一致。

此bug已提给官方
bug#76940
。 以下是重现的测例：

    
主库执行

    

      
create table t1(c1 int primary key)  engine=innodb;
insert into t1 values(1),(2),(3),(4),(5);
create table t2 (c1 int, c2 int, foreign key(c2) references t1(c1)) engine=innodb;
insert into t2 values(1,1),(2,2),(5,5);

create temporary table tmp as select * from t1;

begin;
drop temporary table if exists tmp;
delete from t1 where c1 > 2;
--delete 失败： ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`zy`.`t2`, CONSTRAINT `t2_ibfk_1` FOREIGN KEY (`c2`) REFERENCES `t1` (`c1`))
commit;

mysql> select * from t1;
+----+
| c1 |
+----+
|  1 |
|  2 |
|  3 |
|  4 |
|  5 |
+----+

    

    
备库结果

    

      
mysql> select * from t1;
+----+
| c1 |
+----+
|  1 |
|  2 |
|  5 |
+----+

    

    
查看主库生成的binlog，
delete from t1 where c1 > 2
 失败了也记入了binlog。

    

      
BEGIN
/*!*/;
# at 1226
#150515 17:27:07 server id 1979399682  end_log_pos 1349     Query   thread_id=6263054   exec_time=0 error_code=0
SET TIMESTAMP=1431682027/*!*/;
SET @@session.pseudo_thread_id=6263054/*!*/;
DROP TEMPORARY TABLE IF EXISTS `tmp` /* generated by server */
/*!*/;
# at 1349
# at 1388
#150515 17:27:07 server id 1979399682  end_log_pos 1388     Table_map: `zy`.`t1` mapped to number 42174
#150515 17:27:07 server id 1979399682  end_log_pos 1427     Delete_rows: table id 42174 flags: STMT_END_F

BINLOG '
67tVVRMCPvt1JwAAAGwFAAAAAL6kAAAAAAEAAnp5AAJ0MQABAwAA
67tVVRkCPvt1JwAAAJMFAAAAAL6kAAAAAAEAAf/+AwAAAP4EAAAA
'/*!*/;
### DELETE FROM zy.t1
### WHERE
###   @1=3 /* INT meta=0 nullable=0 is_null=0 */
### DELETE FROM zy.t1
### WHERE
###   @1=4 /* INT meta=0 nullable=0 is_null=0 */
# at 1427
#150515 17:27:09 server id 1979399682  end_log_pos 1494     Query   thread_id=6263054   exec_time=0 error_code=0
SET TIMESTAMP=1431682029/*!*/;
COMMIT

    

    
bug分析

    
binlog有两个cache用来缓存事务的binlog。

    

      
  binlog_cache_data stmt_cache; //存放非事务表和临时表binlog
  binlog_cache_data trx_cache;  //存放事务表binlog

    

    
事务和语句回滚时应清理相应的cache, 事务提交时cache会刷入binlog文件中。

    
临时表在 drop 或 create 时不管成功还是失败都会记binlog。

    
当 drop 或 create 临时表操作和其他DML在一个事务中时，drop 或 create 临时表不管成功还是失败都会记binlog。查看源码中逻辑是只要事务中出现过 drop 或 create 临时表操作，那么事务后来的语句不管成功还是失败binlog cache都不会清理(参考函数
binlog_rollback
和
binlog_truncate_trx_cache
)。

    
对于前面的例子，当事务执行到以下语句时，由于违反引用约束失败语句回滚时trx_cache应该清理。

delete from t1 where c1 > 2;

因此 delete 3,4 两条记录的binlog是应该不记入binlog的。

    
bug修复方法

    
当 drop 或 create 临时表操作和其他DML在一个事务中时，如果当前执行的语句不是 drop 或 create 临时表并且失败，则 binlog cache 应该清理。如果当前执行的语句是drop或create临时表，不管成功还是失败，cache都不用清理，都应记入binlog。

  

  

    

    

    
Test Book

  

  

    
有4压缩很任性

    
TokuDB有着出色的压缩特性，这不是”盖”的：

RDS上有个InnoDB实例，1天的数据将近700GB空间，换成TokuDB后(默认zlib压缩)，同样的700GB可以保存５天的数据，业务读写性能也无任何影响，空间成本直线下降。

    
为什么TokuDB的压缩这么给力？

因为TokuDB一个“页”的大小为4MB，压缩起来，这酸爽…

    
zstd新压缩算法

    
TokuDB支持3种压缩算法:

    

      
tokudb_quicklz: 压缩效果差，CPU消耗低
tokudb_zlib: 压缩效果偏中，CPU消耗偏中(默认)
tokudb_lzma: 压缩效果好，CPU消耗高

    

    
之所以提供多种压缩算法，主要是从CPU消耗和压缩效果上综合考虑的，大部分情况下 tokudb_zlib 都可以应付，而且压缩效果也不错，也是 TokuDB 默认压缩算法。

最近压缩界出了一枚小鲜肉:
zstd压缩算法
，由压缩专业户
Yann Collet
倾力打造。

zstd有着非常好的压缩效果，最重要的是它CPU消耗低和压缩(解压)速度非常快，我们内部TokuDB版本已集成此算法，下面就让我们看看同样数据集的情况下，它们的效果对比：

    
压缩效果对比图(越高越好):

zstd的压缩效果介于zlib和lzma之间，已经很理想了。

    
压缩时间对比图:

压缩时间非常少，几乎是quicklz的一半。

    
相信过不了多久，你的RDS数据已经悄悄的跑在zstd压缩算法之下。

如果你对我们所做的事情感兴趣，请抓起鼠标，敲起键盘，快快跟我们联系吧，最后悄悄说一句：

    
我们有妹子!!!

  

  

    

    

    
Test Book

  

  

    
背景

    
MySQL 非 GTID 协议主备同步原理：

主库在执行 SQL 语句时产生binlog，在事务 commit 时将产生的binlog event写入binlog文件，备库IO线程通过 
com_binlog_dump
 用文件位置协议从主库拉取 binlog，将拉取的binlog存储到relaylog, SQL线程读取 relaylog 然后进行 apply，实现主备同步，在这个过程中有以下几个问题：

    

      
主库什么时间将产生的 binlog 真正刷到文件中？

      
备库IO线程从哪个位置读取主库的 binlog event 的？

      
备库SQL线程如何记录执行到的 relaylog 的位点？

      
备库IO线程何时将cache中的event 刷到relay log 文件中的?

    

    
问题分析

    
下面对这几个问题挨个解答。

    
问题 1: 主库什么时间将产生的binlog 真正刷到文件中

    
事务
ordered_commit
 中，会将 
thd->cache_mngr
 中的 binlog cache 写入到 binlog 文件中，但并没有执行fsync()操作，即只将文件内容写入到 OS 缓存中，详细 bt 为：

    

      
#0  my_write
#1  0x0000000000a92f50 in inline_mysql_file_write
#2  0x0000000000a9612e in my_b_flush_io_cache
#3  0x0000000000a43466 in MYSQL_BIN_LOG::flush_cache_to_file
#4  0x0000000000a43a4d in MYSQL_BIN_LOG::ordered_commit
#5  0x0000000000a429f2 in MYSQL_BIN_LOG::commit
#6  0x000000000063d3e2 in ha_commit_trans
#7  0x00000000008adb7a in trans_commit_stmt
#8  0x00000000007e511f in mysql_execute_command
#9  0x00000000007e7e0e in mysql_parse
#10 0x00000000007dae0e in dispatch_command
#11 0x00000000007d9634 in do_command
#12 0x00000000007a046d in do_handle_one_connection
#13 0x000000000079ff75 in handle_one_connection
#14 0x0000003a00a07851 in start_thread ()
#15 0x0000003a006e767d in clone ()

    

    
commit 时，会判断是否将产生的 binlog flush 到文件中，即执行 fsync操作，详细bt 为：

    

      
#0  MYSQL_BIN_LOG::sync_binlog_file
#1  0x0000000000a43c62 in MYSQL_BIN_LOG::ordered_commit
#2  0x0000000000a429f2 in MYSQL_BIN_LOG::commit
#3  0x000000000063d3e2 in ha_commit_trans
#4  0x00000000008adb7a in trans_commit_stmt
#5  0x00000000007e511f in mysql_execute_command
#6  0x00000000007e7e0e in mysql_parse
#7  0x00000000007dae0e in dispatch_command
#8  0x00000000007d9634 in do_command (thd=0x37a40160)
#9  0x00000000007a046d in do_handle_one_connection
#10 0x000000000079ff75 in handle_one_connection
#11 0x0000003a00a07851 in start_thread ()
#12 0x0000003a006e767d in clone ()

    

    
由 
MYSQL_BIN_LOG::sync_binlog_file
 可以看出，每提交一个事务，会 fsync 一次binlog file。 当 sync_binlog != 1 的时候，每次事务提交的时候，不一定会执行 fsync 操作，binlog 的内容只是缓存在了 OS（是否会执行fsync操作，取决于OS缓存的大小），此时备库可以读到主库产生的 binlog, 在这种情况下，当主库机器挂掉时，有以下两种情况：

    

      
主备同步无延迟，此时主库机器恢复后，备库接着之前的位点重新拉binlog, 但是主库由于没有fsync最后的binlog，所以会返回1236 的错误：

MySQL error code 1236 (ER_MASTER_FATAL_ERROR_READING_BINLOG): Got fatal error %d from master when reading data from binary log: '%-.256s'

      
备库没有读到主库失去的binlog，此时备库无法同步主库最后的更新，备库不可用。

    

    
问题 2: 备库IO线程从哪个位置读取主库的binlog event 的

    
更新位点信息的 bt 如下：

    

      
#0  Rpl_info_table::do_flush_info (this=0x379cbf90, force=false)
#1  0x0000000000a78270 in Rpl_info_handler::flush_info
#2  0x0000000000a773b9 in Master_info::flush_info
#3  0x0000000000a5da4b in flush_master_info
#4  0x0000000000a697eb in handle_slave_io
#5  0x0000003a00a07851 in start_thread () from /lib64/libpthread.so.0
#6  0x0000003a006e767d in clone () from /lib64/libc.so.6

    

    
备库通过 
master_log_info
 来记录主库的相关信息，通过参数 
sync_master_info
 来设置备库经过多少个 binlog event 来更新已经读取到的位点信息。当stop slave时，会把正常的位点更新到
master_log_info
中，此时，如果最后的位点不是commit，则在start slave后，会继续上一位点拉取 binlog，从而造成同一个事务的binlog event分布在不同的binlog file中，此时如果执行顺利则不会有问题；如果在拉这个事务的过程中，sql 线程出错中断，在并行复制下会引起分发线程停在事务中间，再次启动的时候，会从上一次分发的事务继续分发，会造成在并行复制中不可分发的情况，因此需要注意。

    
当 sync_master_info > 1000时，可能在第1000个binlog 拉取的时候机器出问题，此时重启后会从主库多拉999个 binlog event，造成事务在备库多次执行问题，对于没有 primary key, unique key 可能会有问题，造成主备数据不一致，最常遇到的是1062问题。

    
问题3: 备库SQL线程如何记录执行到的relaylog 的位点

    
同问题2一样，相关的 bt 也类似，
relay_log_info
 记录的是备库已经执行了的最后的位点，这个位点不会处于事务中间，即是每 
sync_relay_log_info
 个事务更新一下这个位点。

    
相关
bugs

bug 原因: 备库异常 crash 后，可能造成事务在拉取过程中被重新拉取，binlog序列如下：

    

      
begin;
table_map;
begin;
table_map;
rows_log_event;
commit;

    

    
在并行复制条件下，由于出现了不完整的事务，所以会造成绑定事务信息无法恢复，造成hang的情况，详情见 
bug 分析
。

    
问题 4: 备库IO线程何时将cache中的event 刷到relay log 文件中的

    
这个问题的解答和问题1类似，也是以binlog event为单位的，当然也存在着和问题1中同样的问题，在此不在赘述。

    
结语

    
MySQL 通过 
sync_binlog
，
sync_master_info
，
sync_relay_log_info
，
sync_relay_log
 来记录相关的位点信息，出于性能考虑以及程序本身的健壮性，引入了各式要样的bug，类似的bug在此不在列举，那么有没有更好的方法来记录这些信息呢，当然有，即GTID 协议，会在下期月报分析。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 引擎特性 · InnoDB undo log 漫游

        

      

      

        

          
TokuDB · 产品新闻 · RDS TokuDB小手册

        

      

      

        

          
TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)

        

      

      

        

          
PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁

        

      

      

        

          
MySQL · 捉虫动态 · 连接断开导致XA事务丢失

        

      

      

        

          
MySQL · 捉虫动态 · GTID下slave_net_timeout值太小问题

        

      

      

        

          
MySQL · 捉虫动态 · Relay log 中 GTID group 完整性检测

        

      

      

        

          
MySQL · 答疑释惑 · UPDATE交换列单表和多表的区别

        

      

      

        

          
MySQL · 捉虫动态 · 删被引用索引导致crash

        

      

      

        

          
MySQL · 答疑释惑 · GTID下auto_position=0时数据不一致

        

      

    

  

  

    

    

    
Test Book

  

  

    
本文是对整个Undo生命周期过程的阐述，代码分析基于当前最新的MySQL5.7版本。本文也可以作为了解整个Undo模块的代码导读。由于涉及到的模块众多，因此部分细节并未深入。

    
前言

    
Undo log是InnoDB MVCC事务特性的重要组成部分。当我们对记录做了变更操作时就会产生undo记录，Undo记录默认被记录到系统表空间(ibdata)中，但从5.6开始，也可以使用独立的Undo 表空间。

    
Undo记录中存储的是老版本数据，当一个旧的事务需要读取数据时，为了能读取到老版本的数据，需要顺着undo链找到满足其可见性的记录。当版本链很长时，通常可以认为这是个比较耗时的操作（例如
bug#69812
）。

    
大多数对数据的变更操作包括INSERT/DELETE/UPDATE，其中INSERT操作在事务提交前只对当前事务可见，因此产生的Undo日志可以在事务提交后直接删除（谁会对刚插入的数据有可见性需求呢！！），而对于UPDATE/DELETE则需要维护多版本信息，在InnoDB里，UPDATE和DELETE操作产生的Undo日志被归成一类，即update_undo。

    
基本文件结构

    
为了保证事务并发操作时，在写各自的undo log时不产生冲突，InnoDB采用回滚段的方式来维护undo log的并发写入和持久化。回滚段实际上是一种 Undo 文件组织方式，每个回滚段又有多个undo log slot。具体的文件组织方式如下图所示：

    

      

    

    
上图展示了基本的Undo回滚段布局结构，其中:

    

      
rseg0预留在系统表空间ibdata中;

      
rseg 1~rseg 32这32个回滚段存放于临时表的系统表空间中;

      
rseg33~ 则根据配置存放到独立undo表空间中（如果没有打开独立Undo表空间，则存放于ibdata中）

    

    
如果我们使用独立Undo tablespace，则总是从第一个Undo space开始轮询分配undo 回滚段。大多数情况下这是OK的，但假设我们将回滚段的个数从33开始依次递增配置到128，就可能导致所有的回滚段都存放在同一个undo space中。(参考函数trx_sys_create_rsegs 以及 
bug#74471
)

    
每个回滚段维护了一个段头页，在该page中又划分了1024个slot(TRX_RSEG_N_SLOTS)，每个slot又对应到一个undo log对象，因此理论上InnoDB最多支持 96 * 1024个普通事务。

    
关键结构体

    
为了便于管理和使用undo记录，在内存中维持了如下关键结构体对象：

    

      
所有回滚段都记录在
trx_sys->rseg_array
，数组大小为128，分别对应不同的回滚段；

      
rseg_array数组类型为trx_rseg_t，用于维护回滚段相关信息；

      
每个回滚段对象trx_rseg_t还要管理undo log信息，对应结构体为trx_undo_t，使用多个链表来维护trx_undo_t信息;

      
事务开启时，会专门给他指定一个回滚段，以后该事务用到的undo log页，就从该回滚段上分配;

      
事务提交后，需要purge的回滚段会被放到purge队列上(
purge_sys->purge_queue
)。

    

    
各个结构体之间的联系如下：

    

      

    

    
分配回滚段

    
当开启一个读写事务时（或者从只读事务转换为读写事务），我们需要预先为事务分配一个回滚段：

    
对于只读事务，如果产生对临时表的写入，则需要为其分配回滚段，使用临时表回滚段（第1~32号回滚段），函数入口：
trx_assign_rseg -->trx_assign_rseg_low-->get_next_noredo_rseg
。

    
在MySQL5.7中事务默认以只读事务开启，当随后判定为读写事务时，则转换成读写模式，并为其分配事务ID和回滚段，调用函数：
trx_set_rw_mode -->trx_assign_rseg_low --> get_next_redo_rseg
。

    
普通回滚段的分配方式如下：

    

      
采用round-robin的轮询方式来赋予回滚段给事务，如果回滚段被标记为skip_allocation（这个undo tablespace太大了，purge线程需要对其进行truncate操作），则跳到下一个；

      
选择一个回滚段给事务后，会将该回滚段的
rseg->trx_ref_count
递增，这样该回滚段所在的undo tablespace文件就不可以被truncate掉；

      
临时表回滚段被赋予
trx->rsegs->m_noredo
，普通读写操作的回滚段被赋予
trx->rsegs->m_redo
；如果事务在只读阶段使用到临时表，随后转换成读写事务，那么会为该事务分配两个回滚段。

    

    
使用回滚段

    
当产生数据变更时，我们需要使用Undo log记录下变更前的数据以维护多版本信息。insert 和 delete/update 分开记录undo，因此需要从回滚段单独分配Undo slot。

    
入口函数：
trx_undo_report_row_operation

    
流程如下：

    

      
判断当前变更的是否是临时表，如果是临时表，则采用临时表回滚段来分配，否则采用普通的回滚段；

      
临时表操作记录undo时不写redo log；

      
操作类型为TRX_UNDO_INSERT_OP，且未分配insert undo slot时，调用函数
trx_undo_assign_undo
进行分配；

      
操作类型为TRX_UNDO_MODIFY_OP，且未分配Update undo slot时，调用函数
trx_undo_assign_undo
进行分配。

    

    
我们来看看函数trx_undo_assign_undo的流程：

    

      
首先总是从cahced list上分配trx_undo_t （函数
trx_undo_reuse_cached
，当满足某些条件时，事务提交时会将其拥有的trx_undo_t放到cached list上，这样新的事务可以重用这些undo 对象，而无需去扫描回滚段，寻找可用的slot，在后面的事务提交一节会介绍到）；

对于INSERT，从
trx_rseg_t::insert_undo_cached
上获取，并修改头部重用信息（trx_undo_insert_header_reuse）及预留XID空间（trx_undo_header_add_space_for_xid）

对于DELETE/UPDATE，从
trx_rseg_t::update_undo_cached
上获取， 并在undo log hdr page上创建新的Undo log header(trx_undo_header_create)，及预留XID存储空间（trx_undo_header_add_space_for_xid）

获取到trx_undo_t对象后，会从cached list上移除掉。并初始化trx_undo_t相关信息（trx_undo_mem_init_for_reuse），将
trx_undo_t::state
设置为TRX_UNDO_ACTIVE

      

        
如果没有cache的trx_undo_t，则需要从回滚段上分配一个空闲的undo slot（trx_undo_create），并创建对应的undo页，进行初始化；

        
一个回滚段可以支持1024个事务并发，如果不幸回滚段都用完了（通常这几乎不会发生），会返回错误DB_TOO_MANY_CONCURRENT_TRXS

        
每一个Undo log segment实际上对应一个独立的段，段头的起始位置在UNDO 头page的TRX_UNDO_SEG_HDR+TRX_UNDO_FSEG_HEADER偏移位置（见下图）

      

      

        
已分配给事务的trx_undo_t会加入到链表
trx_rseg_t::insert_undo_list
或者
trx_rseg_t::update_undo_list上
；

      

      
如果是数据词典操作（DDL）产生的undo，主要是表级别操作，例如创建或删除表，还需要记录操作的table id到undo log header中(TRX_UNDO_TABLE_ID)，同时将TRX_UNDO_DICT_TRANS设置为TRUE。(trx_undo_mark_as_dict_operation)。

    

    
总的来说，undo header page主要包括如下信息：

    
如何写入undo日志

    
入口函数：
trx_undo_report_row_operation

    
当分配了一个undo slot，同时初始化完可用的空闲区域后，就可以向其中写入undo记录了。写入的page no取自
undo->last_page_no
，初始情况下和hdr_page_no相同。

    
对于INSERT_UNDO，调用函数trx_undo_page_report_insert进行插入，记录格式大致如下图所示：

    
对于UPDATE_UNDO，调用函数
trx_undo_page_report_modify
进行插入，UPDATE UNDO的记录格式大概如下图所示：

    
在写入的过程中，可能出现单页面空间不足的情况，导致写入失败，我们需要将刚刚写入的区域清空重置(trx_undo_erase_page_end)，同时申请一个新的page(trx_undo_add_page) 加入到undo log段上，同时将
undo->last_page_no
指向新分配的page，然后重试。

    
完成Undo log写入后，构建新的回滚段指针并返回（trx_undo_build_roll_ptr），回滚段指针包括undo log所在的回滚段id、日志所在的page no、以及page内的偏移量，需要记录到聚集索引记录中。

    
事务Prepare阶段

    
入口函数：trx_prepare_low

    
当事务完成需要提交时，为了和BINLOG做XA，InnoDB的commit被划分成了两个阶段：prepare阶段和commit阶段，本小节主要讨论下prepare阶段undo相关的逻辑。

    
为了在崩溃重启时知道事务状态，需要将事务设置为Prepare，MySQL 5.7对临时表undo和普通表undo分别做了处理，前者在写undo日志时总是不需要记录redo，后者则需要记录。

    
分别设置insert undo 和 update undo的状态为prepare，调用函数trx_undo_set_state_at_prepare，过程也比较简单，找到undo log slot对应的头页面(trx_undo_t::hdr_page_no)，将页面段头的TRX_UNDO_STATE设置为TRX_UNDO_PREPARED，同时修改其他对应字段，如下图所示（对于外部显式XA所产生的XID，这里不做讨论）：

    
Tips：InnoDB层的XID是如何获取的呢？ 当Innodb的参数innodb_support_xa打开时，在执行事务的第一条SQL时，就会去注册XA，根据第一条SQL的query id拼凑XID数据，然后存储在事务对象中。参考函数
trans_register_ha
。

    
事务Commit

    
当事务commit时，需要将事务状态设置为COMMIT状态，这里同样通过Undo来实现的。

    
入口函数：
trx_commit_low-->trx_write_serialisation_history

    
在该函数中，需要将该事务包含的Undo都设置为完成状态，先设置insert undo，再设置update undo（trx_undo_set_state_at_finish），完成状态包含三种：

    

      
如果当前的undo log只占一个page，且占用的header page大小使用不足其3/4时(TRX_UNDO_PAGE_REUSE_LIMIT)，则状态设置为TRX_UNDO_CACHED，该undo对象会随后加入到undo cache list上；

      
如果是Insert_undo（undo类型为TRX_UNDO_INSERT），则状态设置为TRX_UNDO_TO_FREE；

      
如果不满足a和b，则表明该undo可能需要Purge线程去执行清理操作，状态设置为TRX_UNDO_TO_PURGE。

    

    
在确认状态信息后，写入undo header page的TRX_UNDO_STATE中。

    
如果当前事务包含update undo，并且undo所在回滚段不在purge队列时，还需要将当前undo所在的回滚段（及当前最大的事务号）加入Purge线程的Purge队列（purge_sys->purge_queue）中（参考函数
trx_serialisation_number_get
）。

    
对于undate undo需要调用
trx_undo_update_cleanup
进行清理操作，清理的过程包括：

    

      

        
将undo log加入到history list上，调用
trx_purge_add_update_undo_to_history
：

        

          

            
如果该undo log不满足cache的条件（状态为TRX_UNDO_CACHED，如上述），则将其占用的slot设置为FIL_NULL，意为slot空闲，同时更新回滚段头的TRX_RSEG_HISTORY_SIZE值，将当前undo占用的page数累加上去；

          

          

            
将当前undo加入到回滚段的TRX_RSEG_HISTORY链表上，作为链表头节点，节点指针为UNDO头的TRX_UNDO_HISTORY_NODE；

          

          

            
更新
trx_sys->rseg_history_len
（也就是show engine innodb status看到的history list），如果只有普通的update_undo，则加1，如果还有临时表的update_undo，则加2，然后唤醒purge线程；

          

          

            
将当前事务的
trx_t::no
写入undo头的TRX_UNDO_TRX_NO段；

          

          

            
如果不是delete-mark操作，将undo头的TRX_UNDO_DEL_MARKS更新为false;

          

          

            
如果undo所在回滚段的
rseg->last_page_no
为FIL_NULL，表示该回滚段的旧的清理已经完成，进行如下赋值，记录这个回滚段上第一个需要purge的undo记录信息：

            

              
  rseg->last_page_no = undo->hdr_page_no;
  rseg->last_offset = undo->hdr_offset;
  rseg->last_trx_no = trx->no;
  rseg->last_del_marks = undo->del_marks;

            

          

        

      

      
如果undo需要cache，将undo对象放到回滚段的update_undo_cached链表上；否则释放undo对象（trx_undo_mem_free）。

    

    
注意上面只清理了update_undo，insert_undo直到事务释放记录锁、从读写事务链表清除、以及关闭read view后才进行，调用函数trx_undo_insert_cleanup：

    

      

        
如果Undo状态为TRX_UNDO_CACHED，则加入到回滚段的insert_undo_cached链表上；

      

      
否则，将该undo所占的segment及其所占用的回滚段的slot全部释放掉（trx_undo_seg_free），修改当前回滚段的大小(rseg->curr_size)，并释放undo对象所占的内存（trx_undo_mem_free），和Update_undo不同，insert_undo并未放到History list上。

    

    
事务完成提交后，需要将其使用的回滚段引用计数rseg->trx_ref_count减1；

    
事务回滚

    
如果事务因为异常或者被显式的回滚了，那么所有数据变更都要改回去。这里就要借助回滚日志中的数据来进行恢复了。

    
入口函数为：
row_undo_step --> row_undo

    
操作也比较简单，析取老版本记录，做逆向操作即可：对于标记删除的记录清理标记删除标记；对于in-place更新，将数据回滚到最老版本；对于插入操作，直接删除聚集索引和二级索引记录（row_undo_ins）。

    
具体的操作中，先回滚二级索引记录（row_undo_mod_del_mark_sec、row_undo_mod_upd_exist_sec、row_undo_mod_upd_del_sec），再回滚聚集索引记录（row_undo_mod_clust）。这里不展开描述，可以参阅对应的函数。

    
多版本控制

    
InnoDB的多版本使用undo来构建，这很好理解，undo记录中包含了记录更改前的镜像，如果更改数据的事务未提交，对于隔离级别大于等于read commit的事务而言，它不应该看到已修改的数据，而是应该给它返回老版本的数据。

    
入口函数： 
row_vers_build_for_consistent_read

    
由于在修改聚集索引记录时，总是存储了回滚段指针和事务id，可以通过该指针找到对应的undo 记录，通过事务Id来判断记录的可见性。当旧版本记录中的事务id对当前事务而言是不可见时，则继续向前构建，直到找到一个可见的记录或者到达版本链尾部。（关于事务可见性及read view，可以参阅我们
之前的月报
）

    
Tips 1：构建老版本记录（
trx_undo_prev_version_build
）需要持有page latch，因此如果Undo链太长的话，其他请求该page的线程可能等待时间过长导致crash，最典型的就是备库备份场景：

    
当备库使用innodb表存储复制位点信息时（relay_log_info_repository=TABLE），逻辑备份显式开启一个read view并且执行了长时间的备份时，这中间都无法对slave_relay_log_info表做purge操作，导致版本链极其长；当开始备份slave_relay_log_info表时，就需要去花很长的时间构建老版本；复制线程由于需要更新slave_relay_log_info表，因此会陷入等待Page latch的场景，最终有可能导致信号量等待超时，实例自杀。 （
bug#74003
）

    
Tips 2：在构建老版本的过程中，总是需要创建heap来存储旧版本记录，实际上这个heap是可以重用的，无需总是重复构建（
bug#69812
）

    
Tips 3：如果回滚段类型是INSERT，就完全没有必要去看Undo日志了，因为一个未提交事务的新插入记录，对其他事务而言总是不可见的。

    
Tips 4: 对于聚集索引我们知道其记录中存有修改该记录的事务id，我们可以直接判断是否需要构建老版本(
lock_clust_rec_cons_read_sees
)，但对于二级索引记录，并未存储事务id，而是每次更新记录时，同时更新记录所在的page上的事务id（PAGE_MAX_TRX_ID），如果该事务id对当前事务是可见的，那么就无需去构建老版本了，否则就需要去回表查询对应的聚集索引记录，然后判断可见性（
lock_sec_rec_cons_read_sees
）。

    
Purge清理操作

    
从上面的分析我们可以知道：update_undo产生的日志会放到history list中，当这些旧版本无人访问时，需要进行清理操作；另外页内标记删除的操作也需要从物理上清理掉。后台Purge线程负责这些工作。

    
入口函数：
srv_do_purge --> trx_purge

    

      

        
确认可见性

        
在开始尝试purge前，purge线程会先克隆一个最老的活跃视图（
trx_sys->mvcc->clone_oldest_view
），所有在readview开启之前提交的事务所做的事务变更都是可以清理的。

      

      

        
获取需要purge的undo记录（
trx_purge_attach_undo_recs
）

        
从history list上读取多个Undo记录，并分配到多个purge线程的工作队列上（
(purge_node_t*) thr->child->undo_recs
），默认一次最多取300个undo记录，可通过参数innodb_purge_batch_size参数调整。

      

      

        
Purge工作线程

        
当完成任务的分发后，各个工作线程（包括协调线程）开始进行purge操作

入口函数： row_purge_step -> row_purge -> row_purge_record_func

        
主要包括两种：一种是记录直接被标记删除了，这时候需要物理清理所有的聚集索引和二级索引记录（
row_purge_record_func
）；另一种是聚集索引in-place更新了，但二级索引上的记录顺序可能发生变化，而二级索引的更新总是标记删除 + 插入，因此需要根据回滚段记录去检查二级索引记录序是否发生变化，并执行清理操作（
row_purge_upd_exist_or_extern
）。

      

      

        
清理history list

        
从前面的分析我们知道，insert undo在事务提交后，Undo segment 就释放了。而update undo则加入了history list，为了将这些文件空间回收重用，需要对其进行truncate操作；默认每处理128轮Purge循环后，Purge协调线程需要执行一次purge history List操作。

        
入口函数：
trx_purge_truncate --> trx_purge_truncate_history

        
从回滚段的HISTORY 文件链表上开始遍历释放Undo log segment，由于history 链表是按照trx no有序的，因此遍历truncate直到完全清除，或者遇到一个还未purge的undo log（trx no比当前purge到的位置更大）时才停止。

      

    

    
关于Purge操作的逻辑实际上还算是比较复杂的代码模块，这里只是简单的介绍了下，以后有时间再展开描述。

    
崩溃恢复

    
当实例从崩溃中恢复时，需要将活跃的事务从undo中提取出来，对于ACTIVE状态的事务直接回滚，对于Prepare状态的事务，如果该事务对应的binlog已经记录，则提交，否则回滚事务。

    
实现的流程也比较简单，首先先做redo (recv_recovery_from_checkpoint_start)，undo是受redo 保护的，因此可以从redo中恢复（临时表undo除外，临时表undo是不记录redo的）。

    
在redo日志应用完成后，初始化完成数据词典子系统（dict_boot），随后开始初始化事务子系统（trx_sys_init_at_db_start），undo 段的初始化即在这一步完成。

    
在初始化undo段时(
trx_sys_init_at_db_start -> trx_rseg_array_init -> ... -> trx_undo_lists_init
)，会根据每个回滚段page中的slot是否被使用来恢复对应的undo log，读取其状态信息和类型等信息，创建内存结构，并存放到每个回滚段的undo list上。

    
当初始化完成undo内存对象后，就要据此来恢复崩溃前的事务链表了(trx_lists_init_at_db_start)，根据每个回滚段的insert_undo_list来恢复插入操作的事务(trx_resurrect_insert)，根据update_undo_list来恢复更新事务(tex_resurrect_update)，如果既存在插入又存在更新，则只恢复一个事务对象。另外除了恢复事务对象外，还要恢复表锁及读写事务链表，从而恢复到崩溃之前的事务场景。

    
当从Undo恢复崩溃前活跃的事务对象后，会去开启一个后台线程来做事务回滚和清理操作（recv_recovery_rollback_active -> trx_rollback_or_clean_all_recovered），对于处于ACTIVE状态的事务直接回滚，对于既不ACTIVE也非PREPARE状态的事务，直接则认为其是提交的，直接释放事务对象。但完成这一步后，理论上事务链表上只存在PREPARE状态的事务。

    
随后很快我们进入XA Recover阶段，MySQL使用内部XA，即通过Binlog和InnoDB做XA恢复。在初始化完成引擎后，Server层会开始扫描最后一个Binlog文件，搜集其中记录的XID（MYSQL_BIN_LOG::recover），然后和InnoDB层的事务XID做对比。如果XID已经存在于binlog中了，对应的事务需要提交；否则需要回滚事务。

    
Tips：为何只需要扫描最后一个binlog文件就可以了？ 因为在每次rotate到一个新的binlog文件之前，总是要保证前一个binlog文件中对应的事务都提交并且sync redo到磁盘了，也就是说，前一个binlog文件中的事务在崩溃恢复时肯定是出于提交状态的。

  

  

    

    

    
Test Book

  

  

    
TokuDB简介

    
TokuDB是一个支持事务的“新”引擎，有着出色的数据压缩功能，由美国TokuTek公司(
http://www.tokutek.com/
) 研发，该公司于2015年4月份被Percona收购。

为了降低用户数据存储成本，云数据库(Aliyun RDS)增加了TokuDB引擎支持(MySQL5.6版本)。

    
TokuDB引擎有什么优点

    
出色的数据压缩功能，较低的IOPS消耗，如果您的数据量比较大，强烈建议您使用TokuDB，以节省空间成本，而且有着与InnoDB相当的性能。

    
使用TokuDB引擎有什么注意点

    
不支持外键(foreign key)功能，如果您的表有外键，切换到TokuDB引擎后，此约束将被忽略!!!

    
阿里云RDS中TokuDB的buffer pool size如何分配

    
我们提供了tokudb_buffer_pool_ratio参数(下图)，作用是调整TokuDB的buffer pool（与InnoDB共享）分配比例，这个参数的意思是TokuDB占用buffer pool的百分比。

    
小提醒: 

如果您是TokuDB用户，建议把这个参数设置成100，表示TokuDB将使用全部buffer pool;

如果您是InnoDB用户，请忽略此参数，默认为InnoDB使用全部buffer pool。

    
阿里云RDS中如何使用TokuDB引擎

    

      

        
第一种方法是在DDL语句中指定表的引擎:

        
建新表:

        

          
 CREATE TABLE ... ENGINE=TokuDB;

        

        
更改引擎:

        

          
  ALTER TABLE ... ENGINE=TokuDB;  
  ANALYZE TABLE ...;

        

      

      

        
第二种方法是通过IDB工具指定表引擎为TokuDB：

      

      
第三种方法(推荐)：

设置default_storage_engine为TokuDB后，表引擎默认为TokuDB。(注意：此设置需要重启)

    

    
阿里云RDS中TokuDB表的热备

    
RDS备份功能已完全支持TokuDB引擎，当您在做备份的时候，会自动备份TokuDB表。

    
阿里云RDS中如何修改TokuDB引擎的压缩算法

    

      

        
第一种方法是在client中指定row_format:

        

          
 CREATE/ALTER TABLE ... ENGINE=TokuDB ROW_FORMAT=[压缩算法];

        

      

      
第二种方法是通过IDB工具指定：

    

    
TokuDB的压缩算法如何选择

    

      
tokudb_zlib:表启用zlib压缩，压缩效果偏中，CPU消耗偏中，建议使用(默认)；

      
tokudb_quicklz:表启用quicklz压缩，压缩效果差，CPU消耗低；

      
tokudb_lzma:表启用lzma压缩，压缩效果好，CPU消耗高。

    

    
TokuDB默认压缩算法为zlib，建议您不要做修改，因为zlib压缩的性价比非常高。

  

  

    

    

    
Test Book

  

  

    
简介

    
TokuDB使用LockTree(ft-index/locktree)来维护事务的锁状态(row-lock和range-lock)，LockTree的数据结构是一个Binary Tree。 

本篇将通过几个“栗子”来谈谈TokuDB的row-lock和range-lock。 

表t:

    

      
mysql> show create table t\G
*************************** 1. row ***************************
       Table: t
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=TokuDB DEFAULT CHARSET=latin1

    

    
row-lock

    

      
mysql> set autocommit=off;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into t values (1),(10),(100);
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from information_schema.tokudb_locks\G
*************************** 1. row ***************************
               locks_trx_id: 238
      locks_mysql_thread_id: 3
                locks_dname: ./test/t-main
             locks_key_left: 0001000000
            locks_key_right: 0001000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 2. row ***************************
               locks_trx_id: 238
      locks_mysql_thread_id: 3
                locks_dname: ./test/t-main
             locks_key_left: 000a000000
            locks_key_right: 000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 3. row ***************************
               locks_trx_id: 238
      locks_mysql_thread_id: 3
                locks_dname: ./test/t-main
             locks_key_left: 0064000000
            locks_key_right: 0064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
3 rows in set (0.00 sec)

    

    
从tokudb_locks表可以查询到，生成了3条row-lock(locks_key_left和locks_key_right相等)。 

为了存储和显示方便，locks_key_left/locks_key_right取key的hash值。

    
range-lock

    

      
mysql> set autocommit=off;
Query OK, 0 rows affected (0.00 sec)

mysql> delete from t where id<100;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from information_schema.tokudb_locks\G
*************************** 1. row ***************************
               locks_trx_id: 280
      locks_mysql_thread_id: 12
                locks_dname: ./test/t-main
             locks_key_left: -infinity
            locks_key_right: ff64000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
1 row in set (0.00 sec)

    

    
从tokudb_locks表可以查询到，where条件的rang-lock区间为[-infinity, ff64000000]，只要其他事务的锁区间跟这个有任何重叠，则需要等待。

    
锁冲突

    
client1执行如下操作:

    

      
mysql1> set autocommit=off;
Query OK, 0 rows affected (0.00 sec)

mysql1> insert into t values (1),(10),(100);
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql1> select * from information_schema.tokudb_locks\G
*************************** 1. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 0001000000
            locks_key_right: 0001000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 2. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 000a000000
            locks_key_right: 000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 3. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 0064000000
            locks_key_right: 0064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
3 rows in set (0.00 sec)

    

    
client2执行如下操作:

    

      
mysql2> set autocommit=off;
Query OK, 0 rows affected (0.00 sec)

mysql2> insert into t values (2),(100);
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
mysql2> select * from information_schema.tokudb_locks\G
*************************** 1. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 0001000000
            locks_key_right: 0001000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 2. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 000a000000
            locks_key_right: 000a000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 3. row ***************************
               locks_trx_id: 283
      locks_mysql_thread_id: 14
                locks_dname: ./test/t-main
             locks_key_left: 0064000000
            locks_key_right: 0064000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
*************************** 4. row ***************************
               locks_trx_id: 289
      locks_mysql_thread_id: 16
                locks_dname: ./test/t-main
             locks_key_left: 0002000000
            locks_key_right: 0002000000
         locks_table_schema: test
           locks_table_name: t
locks_table_dictionary_name: main
4 rows in set (0.00 sec)

mysql2> select @@tokudb_last_lock_timeout;
+--------------------------------------------------------------------------------------------------------------------+
| @@tokudb_last_lock_timeout                                                                                         |
+--------------------------------------------------------------------------------------------------------------------+
| {"mysql_thread_id":16, "dbname":"./test/t-main", "requesting_txnid":289, "blocking_txnid":283, "key":"0064000000"} |
+--------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

    

    
锁等待超时了，通过参数tokudb_last_lock_timeout得知，hash为0064000000的row-lock已经被txnid为283（client1)抢占。

    
总结

    
在使用TokuDB过程中，如果
show processlist
里有锁等待语句，可以通过tokudb_locks表获取到当前所有事务的锁信息，以快速定位到问题。 

TokuDB提供tokudb_lock_timeout_debug参数，可以设置不同值(默认值为1)来记录锁冲突信息，说明如下：

    

      
tokudb_lock_timeout_debug = 0: No lock timeouts or lock deadlocks are reported.
tokudb_lock_timeout_debug = 1: A JSON document that describes the lock conflict is stored in the tokudb_last_lock_timeout session variable
tokudb_lock_timeout_debug = 2: A JSON document that describes the lock conflict is printed to the MySQL error log.
tokudb_lock_timeout_debug = 3: A JSON document that describes the lock conflict is stored in the 

    

  

  

    

    

    
Test Book

  

  

    
PgSQL 9.4.1在2015年2月5日发布，主打的是安全方面的更新，修补了如下的安全漏洞：

    

      
CVE-2015-0241 Buffer overruns in “to_char” functions.

      
CVE-2015-0242 Buffer overrun in replacement printf family of functions.

      
CVE-2015-0243 Memory errors in functions in the pgcrypto extension.

      
CVE-2015-0244 An error in extended protocol message reading.

      
CVE-2014-8161 Constraint violation errors can cause display of values in columns which the user would not normally have rights to see.

    

    
也就是说，在9.4 GA版本中，是存在这些安全漏洞的，9.4.1把它们修复了。好消息是，阿里云的RDS PG将直接采用更安全的9.4.1版本。下面我们不妨分析一下这些漏洞的具体情况，看看如果使用9.4 GA，有哪些安全隐患。

    
CVE-2015-0244

    
比较起来，CVE-2015-0244这个漏洞较严重些，我们做重点分析。从修复这个问题的代码改动（
patch
）可以看出，问题主要出在前后端通信过程中。最简单的触发方式，是利用Query Cancellation机制。这里有必要先介绍一下前后端的通信过程和Query Cancellation的实现逻辑。

    
客户端连接PG时，后端建立一个backend（即后台进程）为其服务，服务逻辑主要在PostgresMain()中。PostgresMain()有一个无条件for循环，不断从客户端读取新的SQL命令，并进行处理。PG每次从客户端读取8K大小的消息；如果一个SQL比较大，大小超过8K，则需要多次读取。

    
读取一次客户端消息的调用序列如下：

    

      
PostgresMain -> ReadCommand -> SocketBackend -> pq_getmessage
                                                        |
                                                        V
             recv <- secure_read  <- pq_recvbuf <- pq_getbytes

    

    
其中pq_recvbuf调用secure_read每次读取8K的数据。如果一个SQL很大，比如

    

      
INSERT INTO tablename VALUES (1), (2),.....,(10000000)

    

    
则需要反复调用secure_read。此时如果用户端发起了一个Query Cancellation，比如在psql控制台按下了Ctl+c，则PG后台进程最终会收到一个SIGINT信号，触发它中断当前的处理，跳转到信号处理函数StatementCancelHandler。其后的函数调用过程如下：

    

      
StatementCancelHandler -> ProcessInterrupts -> elog( ERROR，......) 
                                                         |
                                                         V
                     siglongjmp  <-  PG_RE_THROW <- errfinish

    

    
可见，最后PG利用siglongjmp，实现了调转。跳转到哪里了呢？我们知道，siglongjmp一般和sigsetjmp成对使用；查看PostgresMain函数，可以发现下面这一行：

    

      
if (sigsetjmp(local_sigjmp_buf, 1) != 0)

    

    
实际上，siglongjmp就是跳转到这一行，继续执行。接下来执行的逻辑正好是对事务执行回滚和对session（即当前连接）环境做初始化，接着就又开始调用ReadCommand，继续从客户端读取消息了。

    
仔细分析上述过程，可以发现一个问题：如果PG在读取一个客户端消息的中间，收到了一个Query Cancellation信号，则PG会回滚事务，并将状态改为等待读取新消息，然后再次调用ReadCommand读消息。但是，此时还是从原来的网络连接中，调用recv读取，所以读取到消息，有可能是上一个消息的一部分。就是说，PG可能把上一个消息的一部分，当做一个新的消息的开始来处理！攻击者可以利用这一点，将一个完整的消息，注入到原SQL中，绕过前端的检查，执行原来不被允许的SQL。例如，如果一个网站前端有一个这样的SQL语句：

    

      
INSERT INTO table VALUES ( ? )

    

    
问号部分，由用户输入并由前端代码填充。正常情况下，如果用户的注入一个
'DELETE FROM table'
，企图删除整个表，是不符合语法的，PG会返回错误。但利用这个漏洞，用户可以在PG接收这个SQL的时候，撤销这次SQL操作，如果用户发起一个Query Cancellation，最终向后台进程发SIGINT信号，则可能会导致后台进程跳转到新消息读取阶段，继续读取消息。此时如果恰好读取到DELETE语句的开头，那么就可以把注入的SQL作为一个新的完整SQL成功执行。

    
此漏洞直接的修复方法是，在读取一个消息过程中，设置一个状态标识，表明目前正在读取消息的阶段。当发生Query Cancellation中断或者其他会造成中断处理的错误，后台进程跳转到中断处理代码，回滚当前事务后，检测状态标识。如果状态标识被设置，说明是从消息读取阶段被中断的，则直接使用elog( FATAL,…)退出后台进程，并断开连接，

    
CVE-2015-0241

    
这个漏洞涉及两个小问题：

    
一个是to_char代码里面在处理localized month（在具体某个locale下的月份名，例如，”January”在中文locale里面是”一月”）和 localized week day（具体某个locale下得星期的名称，例如，”Monday”在中文里面是”星期一”）时，使用的数组过小，在某些locale下面可能指针越界。

    
另一个小问题是，to_char在将输入的float类型转换为字符串时，如果指定格式的字符串过长，可能造成存放结果的数组不够大而内存越界。

    
为修复此漏洞，在下面的文件里面增大了处理数组长度，并加入了对长度的判断。

    

      
src/backend/utils/adt/formatting.c

    

    
CVE-2015-0242

    
这个漏洞是PG自带的snprintf函数，在较大的精度要求时可能导致存放结果的数组过小而造成内存越界。这个问题只影响没有snprintf支持的平台。

    
CVE-2015-0243

    
只影响插件pgcrypto。主要由于此插件所使用的imath的版本有了变化，造成原来代码里面假设的所调用函数的返回值长度有变化，可能造成数组溢出。

    
CVE-2014-8161

    
由于疏忽，
BuildIndexValueDescription
, 
ExecBuildSlotValueDescription
以及 
ri_ReportViolation
等函数在打印出错信息时，会把用户无权知道的信息打印出来。例如，在插入数据到一个有非空约束的表中时，用户会看到如下的出错信息：

    

      
INSERT INTO t1 (c1) VALUES (5); 
ERROR:  null value in column "c2" violates not-null constraint
DETAIL:  Failing row contains (c1) = (5).

    

    
用户实际上没有查看c2这个字段的权限，所以不应该让其感知到c2字段的存在。而这个错误信息暴露了这一点。

    
再如，假设用户没有查看c1字段值的权限，只有查看c3字段的权限并且c3上有值域约束，则在对c3赋值时，如果使用一个不符合值域约束的值，会提示错误，并且错误信息会把c1的值打印出来：

    

      
UPDATE t1 SET c3 = 10; 
ERROR:  new row for relation "t1" violates check constraint "t1_c3_check"
DETAIL:  Failing row contains (c1, c3) = (1, 10).

    

    
这样用户很容易通过执行类似
update set c3 = "any value"
 的语句，把c1的值打出来，造成信息泄露。

  

  

    

    

    
Test Book

  

  

    
我们看到在MySQL 5.7版本里大量遗留很多年的bug都被fix掉了，bug#12161就是其中一个，该bug在2005年第一次report到Bug list上，十年之后终于在MySQL 5.7.7 第一个RC版本被fix了。

    
Bug描述

    
当我们显式开启一个XA事务，执行操作，并完成XA PREPARE后，如果Kill session或者主动断开再重连执行XA RECOVER，之前的这个XA事务就会直接丢失掉了。

    
例如：

    

      
mysql> XA BEGIN 'abc';
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO t1 VALUES (1,2,3);
Query OK, 1 row affected (0.00 sec)

mysql> XA END 'abc';
Query OK, 0 rows affected (0.00 sec)

mysql> XA PREPARE 'abc';
Query OK, 0 rows affected (0.00 sec)

mysql> Ctrl-C -- exit!
Aborted

mysql> XA RECOVER;
Empty set (0.00 sec)

    

    
有趣的是，如果在XA PREPARE后把实例KILL掉，是可以通过XA RECOVER恢复的：

    

      
mysql> XA RECOVER;
+----------+--------------+--------------+------+
| formatID | gtrid_length | bqual_length | data |
+----------+--------------+--------------+------+
| 1 | 3 | 0 | abc |
+----------+--------------+--------------+------+
1 row in set (0.00 sec)

mysql> XA COMMIT 'abc';
Query OK, 0 rows affected (0.00 sec)

    

    
虽然实例异常重启可以恢复事务，但引入的另外一个问题是：事务变更的binlog丢失，导致主备数据不一致。

    
bug产生的原因也很简单：在退出session时，线程总是会去无条件的回滚掉自己尚未提交的事务。

    
官方修复

    
持久化

    
为了解决这个问题，将XA的两阶段记录到了Binlog中；

    
对于上文描述的序列，当执行到XA PREPARE时，记录第一阶段的binlog，如下：

    

      
Query event : XA START X'616263',X'’,1  // 这里的'616262'即是'abc'的十六进制编码
Table_map event
Write_rows event
Query event：XA END X'616263',X'',1
XA_prepare event： XA PREPARE X'616263',X'’,1

    

    
这时候该XA事务同时在InnoDB层（事务处于Prepare状态，Redo持久化到磁盘）和Server层都有持久化信息。

    
其中XA_PREPARE事件是新引入的事件类型（内部类为XA_prepare_event），以后版本升级需要注意到这个低版本不兼容事件。

    
然后再执行XA COMMIT ‘abc’，产生新的事件：

    

      
Query event：XA COMMIT X'616263',X'',1

    

    
如果执行XA ROLLBACK，则记录：

    

      
Query event：XA ROLLBACK X'616263',X'',1

    

    
由于XA PREPARE和XA COMMIT是分开执行的，因此在这两个事件中间可能存在别的事务，备库复制线程需要处理这种情况。

    
为了实现XA PREPARE写binlog，对binlog_prepare进行了扩展，这里会调用mysql_bin_log.commit， 将cache中的binlog刷到文件中。

    
Tips：XID可以包含三个部分：gtrid, [, bqual [, format ID]]，其中gtrid是必选的，表示全局标识，bqual是分支标识，默认为空’‘，format ID是一个unsigned整型，默认值为1，在上例中，我们只指定了gtrid为’abc’，因此bqual段和format ID均为默认值。更具体的描述参考
官方文档
。

    
如何恢复

    
当会话断开时（例如kill session或者一次干净的shutdown/restart操作），我们必须要能恢复该事务，之前的逻辑是在cleanup时，直接回滚所有的活跃事务。在新版本中，对XA PREPARE的事务做了特殊处理（THD::cleanup），如果处于Prepare状态，就将事务的in_recovery设置为TRUE，并更新到hash表transaction_cache中（transaction_cache_detach），该hash表用于维护所有XA事务。

    
对于非XA的活跃事务，在会话断开时，依然采用回滚策略。

    
当重连客户端后，我们可以直接执行 XA COMMIT ‘abc’，这时候会通过XID关键字去搜索transaction_cache并将对应的事务提交掉。

    
同时BINLOG的状态要保持一致，如果会话断开前的XA PREPARE没有记录Binlog， 重连后执行XA COMMIT也不应该记录。

    
备库复制

    
由于XA PREPARE和XA COMMIT是分开记录的，当碰到XA COMMIT时，备库采用等待之前的事务全部完成，然后再执行的方式（相当于退化到串行）。

    
另外，我们知道在一个正常的会话过程中，总是为其cache一个事务对象，新的事务会重用这个事务对象，避免多次分配；而XA事务的COMMIT和PREPARE是分离的，需要为XA事务单独分配事务对象。因此复制线程执行XA START时，将其拥有的事务对象临时保存起来（detach_native_trx），当执行到XA_prepare_log_event事件时，再将其恢复给复制线程，同时XA事务对象关闭read view，将is_recovered设置为TRUE（函数innodb_replace_trx_in_thd）。

    
随后复制线程在执行到XA COMMIT时直接根据XID找到对应的XA事务进行提交。

    
参考：

    

WL#6860
 Binlogging XA-prepared transaction

Github：git show f4c37f7aea732763947980600c6882ec908a54a0

MySQL 5.7.7-RC

  

  

    

    

    
Test Book

  

  

    
背景

    
官方 5.6 最新版本 5.6.24 有这样一个bugfix，当使用 GTID 协议进行复制，并且备库的 slave_net_timeout 值设置太小的话，备库的 slave io 线程会卡住，同时主库上的 binlog dump 线程数一直在涨，
官方的bug地址
 。

    
bug分析

    
首先说明下几个概念：

1. slave_net_timeout，这个变量控制备库 IO 线程的连接超时，如果IO线程在指定时间内没有从主库收到数据的话，就断开重连，默认值是3600秒；

2. heartbeat 事件，主库在dump线程空闲的时候（dump线程已经把所有binlog都发给备库了，主库还没有更新操作），就隔断时间发一个 heartbeat 给备库，以免备库超时断开，这个时间间隔是备库在 change master 时传过来的，在 rpl_slave.cc 中可以看到，默认取 
min<float>(SLAVE_MAX_HEARTBEAT_PERIOD, (slave_net_timeout/2.0))
；

3. GTID 的 auto_position 协议，正是因为有了 GTID，才可以在 chang master 时不指定binlog坐标（filename, pos），但是主库dump线程在发给备库event的时候，还是需要从某个坐标开始的，只是这个过程通过 GTID 能自动搜出来罢了，关于如何找到要发送的第一个 binlog 可以看下
之前的月报
，找到后就需要从这个 binlog 开头开始扫描，找到第一个备库没有 GTID，然后开始发送。

    
问题的源头就出在 binlog 文件扫描上，官方 bug 的复现步骤中有这样一个条件，use 1GB binlog file size. stop slave at high binlog position (>800MB)，就是说主库的 binlog 要比较大，并且备库 IO 线程要停在这个 binlog 比较靠后的位置。这样备库 start slave 连上的时候，主库的 dump 线程就要从这个 binlog 开头往后扫，找到开始发送 binlog 的位置，如果文件比较大的话，这个扫描时间就会比较长。heartbeat 事件是在主库空闲的时候才会发送的，在扫描过种中是不会检查要不要发 heartbeat 的，如果备库的 slave_net_timeout 设置比较小的话，超过时间还没收到一个事件，这时备库 IO 就会停下，然后重连。

    
IO 线程重连会导致另外一个问题，我们知道一个主库是可以拖多个备库的，但是对每个备库只能有一个连接，如果已经连上来的备库再发一个 dump 请求的话，主库就会把当前备库老的 IO 连接置为 killed，具体函数是 sql/rpl_master.cc 中的 
kill_zombie_dump_threads
，但这个 kill 只是置了标志位，还需要老的 dump 线程自己判断，然后退出。dump 线程 killed 状态检测只在切换 binlog 和空闲的时候，如果这个时候老的 dump 线程还在扫 binlog，即使已经是killed了也不会退出。而同时新的 dump 线程依然要从头扫 binlog，重复上面的过程，导致备库 IO 又超时重连，因此在主库上show processlist的话，会看到 dump 线程慢慢堆积起来。

    
下面的结果就是备库 slave_net_timeout 设置为10s的测试结果，可以看到相邻 dump 线程差不多间隔10s。

    

      
|  9 | root | localhost:46882 | NULL | Binlog Dump GTID |  159 | init  | NULL             |
| 10 | root | localhost:46929 | NULL | Binlog Dump GTID |  149 | init  | NULL             |
| 11 | root | localhost:46975 | NULL | Binlog Dump GTID |  138 | init  | NULL             |
| 12 | root | localhost:47023 | NULL | Binlog Dump GTID |  127 | init  | NULL             |
| 13 | root | localhost:47074 | NULL | Binlog Dump GTID |  115 | init  | NULL             |
| 14 | root | localhost:47143 | NULL | Binlog Dump GTID |  104 | init  | NULL             |
| 15 | root | localhost:47206 | NULL | Binlog Dump GTID |   93 | init  | NULL             |
| 16 | root | localhost:47255 | NULL | Binlog Dump GTID |   82 | init  | NULL             |
| 17 | root | localhost:47311 | NULL | Binlog Dump GTID |   71 | init  | NULL             |
| 18 | root | localhost:47362 | NULL | Binlog Dump GTID |   60 | init  | NULL             |
| 19 | root | localhost:47427 | NULL | Binlog Dump GTID |   49 | init  | NULL             |

    

    
如果在备库上 show slave status 的的话，会看到 IO 线程接收的 binlog 位点一直不更新，就像 hang 住了一样。

    
bug修复

    
出现这个问题是因为主库 dump 线程检测 heartbeat_period 和 thd->killed 的粒度太大，都是 binlog 文件级别的，因此官方的改法就是把两者的检测粒度降为event级别，dump 线程每 read 一个 event，都会检测是否该发送 heartbeat 了，同时 thd 的 killed 标志是否被置上，是的话就退出。

具体的patch可以看
官方github
。

    
有了这个 patch 后，主库 dump 线程还是需要时间扫描binlog，备库的 IO 线程看起来依然像 hang 住一样，但是已经不会超时重连，主库的dump 线程也不会堆积。

  

  

    

    

    
Test Book

  

  

    
bug背景

    
官方 5.7.6 版本对 gtid 有非常多的改进和bugfix，其中有一个 bugfix 是针对 relay log 中没有接收完整的 gtid 事务的。正常的relay log 中的 gtid 事务应该是像下面这样：

1. gtid event

2. query event (begin)

3. row event (write/update/delete)

4. query event (commit)

    
上面这 4 个 event 序列构成一个 group。因为 IO 线程从主库接收 binlog 时，是以 event 为单位的，如果在 group 中间，比如3之后，stop slave 停掉IO线程的话，relay log 中就会记录一个不完整的事务。我们知道，GTID 的 auto_position 协议是通过计算主备库之间 GTID 集合的差集，然后来确定哪些 binlog 是要从主发给备的，备库用的集合就是 Retrieved_Gtid_Set 和 gtid_executed 的并集。IO 线程收到一个 gtid event 就会把它加入到 Retrieved_Gtid_Set 中，所以如果这个时候 start slave的话，最后这个不完整的事务是不会重新发送的，因为根据协议，主库认为备库已经有了这个事务，不需要再发送了。

    
修复分析

    
之所以会出现这种问题，是因为 IO 线程在处理的时候，没有将 gtid_event 和后面的事件序列当作一个整体来看待，只要收到开头的 gtid event，就认为整个 group 都已经收到。

    
所以官方的修复就是加一个事务边界检查器（Transaction_boundary_parser），只有当 IO 线程收到完整的 group，才将 gtid 加入到 Retrieved_Gtid_Set；同样在 mysqld 重启从 relay log 中初始化 Retrieved_Gtid_Set 时，也利用边界检查器判断 realy log 中的 gtid 事务是否完整。

    
下面就看下这个边界检查器是如何做判断的：

    
将 relay log 中的 event 序列分为2种，DDL 和 DML。

    

      
DDL 序列如下：
  DDL-1: GTID event
  DDL-2: User_var/Intvar/Rand event
  DDL-3: Query event

DML 序列如下:
  DML-1: GTID event
  DML-2: Query event(BEGIN)
  DML-3: Query event(除了 BEGIN/COMMIT/ROLLBACK) / Rows event / load event)
  DML-4: (Query event (COMMIT) | Query event(ROLLBACK) | Xid)

    

    
然后定义了5种状态，标识目前读到的 event 事件是在事务内还是事务外。

1. EVENT_PARSER_NONE // 在事务外，这个时候应该是读完 DDL-3 或者 DML-4

2. EVENT_PARSER_GTID // 读到了GTID event，处于事务中，这个时候应该是读到 DDL-1 或者 DDL-3

3. EVENT_PARSER_DDL // 处于事务中，读到 DDL-2

4. EVENT_PARSER_DML // 处于事务中，读到 DML-2 或者 DML-3

5. EVENT_PARSER_ERROR // 错误状态

    
边界检查器的实现是一个状态机，根据目前所处的状态和读到的event，确定下一步应该转移到什么状态。

    
比如对于下面这样的 event 序列：

1. gtid

2. begin

3. update rows

4. commit

    
状态是这样转移的，刚开始是 EVENT_PARSER_NONE，读到事件1，转为 EVENT_PARSER_GTID 状态，读到事件2，转为 EVENT_PARSER_DML 状态，读到事件3，转为EVENT_PARSER_DML状态，读到事件4，转为 EVENT_PARSER_NONE 状态。从EVENT_PARSER_NONE（事务外）最终又到 EVENT_PARSER_NONE，中间读了一个完整的事务。

详细的状态转移规则可以看
官方patch
。

    
有了这个边界检测器后，IO 线程就能准确判断当前是处于事务外还是事务内，从而决定要不要把GTID添加到 Retrieved_Gtid_Set 中。

    
相关bug

    
对于 relay log 部分事务的问题，官方
之前有个patch
，其逻辑是对 relay log 中最后一个 gtid 做特殊处理。在 request dump 的时候，如果这个 gtid 不在备库的 gtid_executed 集合中的话，就把这个 gtid 从发送给主库的 gtid 集合里去掉，这样主库就会把这个最后的 gtid 事务重新发过来；如果这个 gtid 已经在备库的 gtid_executed 集合中的话，就不从发送给主库的 gtid 集合里去掉，这样主库库就不会重发。

    
但是这种修复方式依赖于 gtid_executed，并不是根据事务是否完整来决定要不要重拉事务，所以有的场景下会有问题，如 
bug#72392
 这种场景。

    
官方目前这种用边界检测的修复方式是比较好的，但是可能会有性能上的问题，因为每个的 event 都要用边界检查器判断下，像 query event 需要要进行字符串比较。

  

  

    

    

    
Test Book

  

  

    
背景描述

    
之前我们遇到一个咨询，客户说：

1. 同一个表，col1=a，col2=b，做 update，set col1=col2，col2=col1，这时候两个都是b

2. 不同表，A表 col1=a，B表 col2=b，做 update，就能进行交换

为什么不同表就能交换呢？

    
问题实验

    
一张表的测试

    

      
root@localhost : test 12:36:09> select * from upt;
+------+------+  
| c1   | c2   |  
+------+------+  
| a    | b    |  
+------+------+  
1 row in set (0.03 sec)  
root@localhost : test 12:36:20> update upt set c1=c2,c2=c1;
Query OK, 1 row affected (2 hours 47 min 59.80 sec)
Rows matched: 1  Changed: 1  Warnings: 0
root@localhost : test 03:24:32> select * from upt;
+------+------+  
| c1   | c2   |  
+------+------+  
| b    | b    |  
+------+------+  
1 row in set (0.00 sec)  

    

    
两张表的测试

    

      
root@localhost : test 02:45:13> select * from upt1;
+------+------+------+  
| c1   | c2   | id   |  
+------+------+------+  
| a    | b    |    1 |  
| c    | d    |    2 |  
+------+------+------+  
2 rows in set (0.00 sec)  
root@localhost : test 02:45:18> select * from upt2;
+------+------+------+  
| c1   | c2   | id   |  
+------+------+------+  
| e    | f    |    1 |  
| g    | h    |    2 |  
+------+------+------+  
2 rows in set (0.00 sec)  
root@localhost : test 02:47:50> update upt1, upt2 set upt1.c1=upt2.c1, upt2.c1=upt1.c1 where upt1.id=upt2.id;
Query OK, 4 rows affected (0.04 sec)  
Rows matched: 4  Changed: 4  Warnings: 0  
root@localhost : test 02:48:25> select * from upt1;
+------+------+------+  
| c1   | c2   | id   |  
+------+------+------+  
| e    | b    |    1 |  
| g    | d    |    2 |  
+------+------+------+  
2 rows in set (0.00 sec)  
root@localhost : test 02:48:35> select * from upt2;
+------+------+------+  
| c1   | c2   | id   |  
+------+------+------+  
| a    | f    |    1 |  
| c    | h    |    2 |  
+------+------+------+  
2 rows in set (0.01 sec)  

    

    
问题分析

    
一张表的情况

    
UPDATE并没有把c1和c2列的值做交换，而是用c2列的值覆盖了c1列的值。而如果c1和c2来自不同的表，则会交换值，原因何在呢？

    
单张表的UPDATE函数入口为 
mysql_uptate()
，函数有两个参数 
List<Item> &fields，List<Item> &values
分别表示要修改的列，和它们的目标值。

    
在上面例子中SET子句等号的左边，依次出现的是c1和c2，所以在fields数组中，顺序是field(c1)->field(c2)，在SET子句等号的右边，依次出现的是c2和c1，所以在values数组中，顺序是value(c2)->value(c1)。

    
对于单表UPDATE，MySQL调用了read_record()来读取values，所以会得到 value(c2).str_value=’b’->value(c1).str_value=’a’。然后在fill_record()中，根据fields的顺序依次调用value->save_in_field()来把values填入fields。

    
因此value(c2)会被首先赋值给field(c1)，因此field(c1).str_value=’b’，然后value(c1).str_value此时已经成为了’b’，因此value(c1)复制给filed(c2)依然还是’b’。

    
我们用三个列来验证我们的分析

    

      
root@localhost : test 03:54:55> select * from upt;
+------+------+------+  
| c1   | c2   | c3   |  
+------+------+------+  
| a    | b    | c    |  
+------+------+------+  
1 row in set (0.01 sec)  
root@localhost : test 03:55:05> update upt set c1=c2, c2=c3, c3=c1;
Query OK, 1 row affected (0.00 sec)  
Rows matched: 1  Changed: 1  Warnings: 0  
root@localhost : test 03:55:45> select * from upt;
+------+------+------+  
| c1   | c2   | c3   |  
+------+------+------+  
| b    | c    | b    |  
+------+------+------+  
1 row in set (0.00 sec)  

    

    
可见，c1被赋值为c2的时候，c2还是’b’，c2被赋值为c3的时候，c3还是’c’。但是当c3被赋值为c1的时候，c1之前已经被赋值为’b’，所以c3也就成了’b’。

    
两张表的分析

    
对于不同表的UPDATE，MySQL调用的是mysql_multi_update()，定义一个multi_update类来处理，最终在 
multi_update::do_updates()
 中进行修改。

    
这里有什么不同的呢？

    
通过调研 
multi_update::do_updates()
 函数发现，multi_update类中的copy_field数组暂存了要更新的列值

    

      
for ( ; *field ; field++)  
{  
Item_field *item= (Item_field* ) field_it++;  
(copy_field_ptr++)->set(item->field, *field, 0);  
}  

    

    
然后从原表中读取一行记录，并存到table->record[1]，

    

      
tbl->file->ha_rnd_pos(tbl->record[0], (uchar *) tmp_table->field[field_num]->ptr)))  
...  
store_record(table,record[1]);  

    

    
接着再把暂存的列值拷贝回table->record[0]，

    

      
for (copy_field_ptr=copy_field;  
     copy_field_ptr != copy_field_end;  
     copy_field_ptr++)  
  (*copy_field_ptr->do_copy)(copy_field_ptr);    

    

    
最后调用ha_update_row这个API更新这行数据,

    

      
local_error= table->file->ha_update_row(table->record[1], table->record[0]);

    

    
这样就不会因为列值被修改，而导致后续利用列值更新其他列的时候值变化了，这就是UPDATE多表和单表逻辑中区别的关键。

  

  

    

    

    
Test Book

  

  

    
bug描述

    
设置 foreign_key_checks=0 删除被引用的索引后，再设置foreign_key_checks=1，对引用表进行DML操作会导致 mysqld crash，以下是重现的测例：

    

      
drop table if exists t2;
drop table if exists t1;

create table t1 (a int, b int, key idx1(a)) engine=innodb;
insert into t1 values(1,1);
insert into t1 values(2,2);
create table t2 (a int, b int, foreign key (b) references t1(a)) engine=innodb;
set session foreign_key_checks = 0;
alter table t1 drop key idx1;
set session foreign_key_checks = 1;
insert into t2 values (1,1); //此语句执行时mysqld会crash

    

    
分析

    
对于引用约束，在mysql实现中引用表和被引用表都会记录表的引用关系。

    
以下链表记录该表引用了哪些表，链表中每个元素为 dict_foreign_t

    

      
table->foreign_list      

    

    
以下链表记录该表被哪些表引用，链表中每个元素为 dict_foreign_t

    

      
table->referenced_list

    

    
dict_foreign_t 结构如下

    

      
dict_foreign_t
{
  foreign_table       // t2
  foreign_index       
  referenced_table    // t1
  referenced_index    // idx1
  ......
}

    

    
对于上面的测例，t1为被引用表，t2为引用表。

    

      

        
对于t1

table->foreign_list 为null

table->referenced_list 则记录了引用关系

      

      
对于t2

table->foreign_list 记录了引用关系

table->referenced_list 则为null

    

    
对于删除索引操作，如果索引涉及到引用关系，那么对应引用关系中的索引也应该做相应调整。对于测例中的删索引操作 
alter table t1 drop key idx1;
 应该做如下调整

    

      

        
修改t1表的引用关系

table->referenced_list中dict_foreign_t->referenced_index 置为null

      

      
修改t2表的引用关系

table->foreign_list中dict_foreign_t->referenced_index 置为null

    

    
而此bug修复之前, 并没有修改t2表的引用关系, 从而导致后面对t2表进行DML操作时，如果访问了无效的dict_foreign_t->referenced_index就会导致crash。

    
修复方法

    
删除被引用的索引后,应修改引用表的引用关系，即应修改table->referenced_list。

详见
官方修复

    
附加说明

    
如果删除引用表对应的外键时，mysql如何处理的呢？同删除被引用表的索引一样，都需要调整引用表和被引用表的关系。

    
实际上，当删除引用表对应的外键时，如果存在和此外键相似（这里的相似是指索引列数和列顺序相同）的索引时，会用相似的索引代替删除的外键，从而保持原有的引用约束关系。

    
例如，在下面的例子中，原来t2存在有两个索引idx1和idx2，都可以作为外键，函数
dict_foreign_find_index
选择了idx1作为外键。当删除idx1后，同样通过dict_foreign_find_index选择了idx2做为了外键。

    

      
drop table if exists t2;
drop table if exists t1;

create table t1 (a int, b int, key(a)) engine=innodb;
create table t2 (a int, b int, foreign key (b) references t1(a),
                 key idx1(b), key idx2(b)) engine=innodb;
alter table t2 drop key idx1;

    

    
同样，此bug修复后，删除被引用表的索引时，如果存在相似的索引会用相似的索引代替。

例如，在下面的例子中，原来t1存在有两个索引idx1和idx2，都可以作为被引用索引，函数dict_foreign_find_index选择了idx1作为被引用索引。当删除idx1后，同样通过dict_foreign_find_index选择了idx2做为了新的被引用索引。

    

      
drop table if exists  t2;
drop table if exists  t1;
create table t1 (a int, b int, key idx1(a), key
                 idx2(a)) engine=innodb;
create table t2 (a int, b int,
                 foreign key (b) references t1(a)) engine=innodb;

    

    
其实，相似索引的存在是完全没有必要的。如果禁止创建相似的索引，那么引用约束这块的处理也不会这么复杂了。

  

  

    

    

    
Test Book

  

  

    
问题重现

    
搭建一主一备，主备配置分别如下 ，同时设置备库的auto_position=0

    

      
$cat crash_recovery-slave.opt

gtid_mode=on 

enforce_gtid_consistency=on 

log_slave_updates=on

relay_log_purge=OFF

sync_relay_log_info=1000

sync_relay_log=1

sync_relay_log_info=100

$cat crash_recovery-master.opt

gtid_mode=on 

enforce_gtid_consistency=on 

log_slave_updates=on

    

    
用 sysbench 不断对主库进行压测，由于主库压力比较大，可以发现备库延迟不断增加，在有延迟的情况下，重启备库 OS 并启动备库 mysql server，关闭主库压力，待主备延迟为零的时候，做主备校验（这样的过程我们称之为一轮，在每一轮的结尾处做主备校验），这时可以发现会有一个表的 checksum 不一致，即产生了主备不一致的问题。

    
问题分析

    

      

        
分别在主备库比较 
show global variables like '%gtid_executed%'
 可以发现主备的 gtid_executed 的值是相等的;

      

      

        
将 checksum 不一致的表中的数据分别取出，然后vimdiff 一下，找到不一致表的具体数据的主建;

      

      

        
在主库的binlog中找到对这条数据最近一次操作的gtid;

      

      

        
解析备库的relaylog，并查找步骤 3) 中的gtid，可以发现，该gtid是一个relay log的结尾，且文件结尾处没有rotate log event.

      

      

        
继续解析relaylog文件，可以发现在format event之后是一个table_map_event, update_rows, xid_log_event, gtid_log_event, 只是gtid_log_event 的 id 小于3)中出现问题的gtid;

      

      
从 5）解析的relay log 来看，备库crash后，并不是接着crash之前的 binlog 来进行拉的，而是 crash 之前的一个位点，假设我们在crash之前拉取了 gtid 为30的binlog event，并sync 了relay log,此时，master_log_info记录的是之前的主库事务位点，假设为事务 10 的一个位点，那么当 OS 重启后，由于备库 auto_position=0, 会从master_log_info中的位点10来拉取binlog，从而形成了这样的binlog序列：

    

    
gtid_log_event(30), table_map_event(10), update_rows_log_event(10), xid_log_event(10), gtid_log_event(11)…..

    
这样的后果是将事务10的数据再次执行并误认为是事务30的数据，而直正拉取到事务30的binlog event时不执行，从而造成主备不一致的问题。

    
解决方案

    

      

        
打开gtid时，必须指定auto_position= 1;

      

      
备库在记录master_log_info时，以事务为单位记录位点信息，而不是以event为单位记录位点信息，这个需要在handle_slave_io中修改源码。

    

    
参数说明

    
sync_relay_log_info：Synchronously flush relay log info to disk after every #th transaction，每隔多少个事务 sync 一次 relay log 信息；

    
sync_master_info： Synchronously flush master info to disk after every #th event，每隔多少个log_event sync 一次 master log 信息；

    
sync_relay_log： Synchronously flush relay log to disk after every #th event，每隔多少个 log_event sync 一次 relay log 信息；

    
mysql 在读取binlog event时，会首先将位点信息写入操作系统的文件，但是没有 sync 操作，所以当OS crash时，会造成之前写但没有 sync 的位点信息丢失。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 答疑释惑· 并发Replace into导致的死锁分析

        

      

      

        

          
MySQL · 性能优化· 5.7.6 InnoDB page flush 优化

        

      

      

        

          
MySQL · 捉虫动态· pid file丢失问题分析

        

      

      

        

          
MySQL · 答疑释惑· using filesort VS using temporary

        

      

      

        

          
MySQL · 优化限制· MySQL index_condition_pushdown

        

      

      

        

          
MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG

        

      

      

        

          
MySQL · 答疑释惑· lower_case_table_names 使用问题

        

      

      

        

          
PgSQL · 特性分析· Logical Decoding探索

        

      

      

        

          
PgSQL · 特性分析· jsonb类型解析

        

      

      

        

          
TokuDB ·引擎机制· TokuDB线程池

        

      

    

  

  

    

    

    
Test Book

  

  

    

测试版本：
MySQL5.6.23

    

      
测试表：

    

    

      
create table t1 (a int auto_increment primary key, b int, c int, unique key (b));并发执行SQL：
replace into t1(b,c) values (2,3)  //使用脚本，超过3个会话

    

    

      
背景

    

    
Replace into操作可以算是比较常用的操作类型之一，当我们不确定即将插入的记录是否存在唯一性冲突时，可以通过Replace into的方式让MySQL自动处理：当存在冲突时，会把旧记录替换成新的记录。

    
我们先来理一下一条简单的replace into操作（如上例所示）的主要流程包括哪些。

    

      
Step 1. 正常的插入逻辑

    

    
首先插入聚集索引记录，在上例中a列为自增列，由于未显式指定自增值，每次Insert前都会生成一个不冲突的新值。

    
随后插入二级索引b，由于其是唯一索引，在检查duplicate key时，为其加上类型为LOCK_X的记录锁。

    
Tips：对于普通的INSERT操作，当需要检查duplicate key时，加LOCK_S锁，而对于Replace into 或者 INSERT..ON DUPLICATE操作，则加LOCK_X记录锁。

    
当UK记录已经存在时，返回错误DB_DUPLICATE_KEY。

    

      
Step 2. 处理错误

    

    
由于检测到duplicate key，因此第一步插入的聚集索引记录需要被回滚掉（row_undo_ins）。

    

      
Step 3. 转换操作

    

    
从InnoDB层失败返回到Server层后，收到duplicate key错误，首先检索唯一键冲突的索引，并对冲突的索引记录（及聚集索引记录）加锁。

    
随后确认转换模式以解决冲突：

    

      
如果发生uk冲突的索引是最后一个唯一索引、没有外键引用、且不存在delete trigger时，使用UPDATE ROW的方式来解决冲突；

      
否则，使用DELETE ROW + INSERT ROW的方式解决冲突。

    

    

      
Step 4. 更新记录

    

    
对于聚集索引，由于PK列发生变化，采用delete + insert 聚集索引记录的方式更新。

    
对于二级uk索引，同样采用标记删除 + 插入的方式。

    
我们知道，在尝试插入一条记录时，如果插入位置的下一条记录上存在记录锁，那么在插入时，当前session需要对其加插入意向锁，具体类型为LOCK_X | LOCK_GAP | LOCK_INSERT_INTENTION。这也是导致死锁的关键点之一。

    

      
是否能保证自增列的有序性?

    

    
默认情况下，参数innodb_autoinc_lock_mode的值为1，因此只在分配自增列时互斥（如果我们将其设为0的话，就会产生AUTO_INC类型的表级锁）。当分配完自增列值后，我们并不知道并发的replace into的顺序。

    

      
死锁分析

    

    
回到死锁线程分析，从死锁日志我们大致可以推断出如下序列（本例中死锁的heap no为5）：

    

      
Session 1 执行到Step4, 准备更新二级Uk索引，因此持有uk上heap no 为5的X 行锁和PK上的X行锁；

      
Session 2 检查到uk冲突，需要加X行锁；

      
Session 1 在标记删除记录后，尝试插入新的uk记录，发现预插入点的下一条记录(heap no =5) 上有锁请求，因此尝试加插入意向X锁，产生锁升级， 死锁路径：Session1 => Session 2 => Session1。

    

    
到这里其实问题已经很明显了，我们考虑如下场景：假设当前表内数据为：

    

      
root@sb1 08:57:41>select * from t1;
+---------+------+------+
| a | b | c |
+---------+------+------+
| 2100612 | 2 | 3 |
+---------+------+------+
1 row in set (0.00 sec)

    

    
由于不能保证自增列被更新的有序性，我们假定有三个并发的会话，并假定表上只有一条记录。

    
session 1获得自增列值为2100619， session 2 获得的自增列值为2100614， session 3获得的自增列值为2100616。

    
Session 1: replace into t1 values (2100619, 2, 3); // uk索引上记录(2, 2100612)被标记删除，同时插入新记录(2, 2100619)

    

      
Purge线程启动，(2, 2100612)被物理删除，Page上只剩下唯一的物理记录(2, 2100619)。

    

    
Session 2: replace into t1 values (2100614, 2, 3);

    
这里我们使用gdb的non-stop模式，使其断在row_update_for_mysql函数(insert尝试失败后，会转换成update)，此时session2持有(2, 2100619) 的X锁。

    

      
Tips：我们可以通过如下命令使用gdb的non-stop模式：
1\. 以gdb启动mysqld
2\. 设置： 
    set target-async 1 
    set pagination off 
    set non-stop on
3\. 设置函数断点，然后run

    

    
Session 3: replace into t1 values (2100616, 2, 3); // 检测到uk有冲突键，需要获取记录(2, 2100619) 的X锁，等待session 2。

    
Session 2:

    

      
a)标记删除记录(2, 2100619)，同时插入新记录(2, 2100614)；

      
b) (2, 2100614) 比(2, 2100619) 要小，因此定位到该记录之前，也就是系统记录infimum；

      
c)infimum记录的下一条记录(2, 2100619)上有锁等待，需要升级成插入意向X锁，导致死锁发生。

    

    

      
如果Purge线程一直停止，会发生什么呢 ？

    

    
我们随便建一个表，然后执行FLUSH TABLE tbname FOR EXPORT来让purge线程停止。

    
假设当前表上数据为：

    

      
root@sb1 10:26:05>select * from t1;
+---------+------+------+
| a | b | c |
+---------+------+------+
| 2100710 | 2 | 3 |
+---------+------+------+
1 row in set (0.00 sec)

    

    
Session 1：replace into t1 values (2100720, 2, 3);

    
此时Page上存在记录(infimum), (2, 2100710), (2, 2100720), (supremum)。

    
Session 2：replace into t1 values (2100715, 2, 3);

    
同上例，使用gdb断到函数row_update_for_mysql。由于没有启动purge线程，因此老的被标记删除的记录还存在于page内，在扫描二级索引重复键时，也会依次给这些老记录加锁，因此session 2会持有 (2, 2100710)和 (2, 2100720)的X锁。

    
Session 3：replace into t1 values (2100718, 2, 3); // 被session2阻塞，等待(2,2100710)的X锁

    
Session 2：在标记删除二级索引记录，并进行插入时，选择的插入位置为 (2, 2100710), (2,2100720)之间，插入点的下一条记录(2,2100720)上没有其他线程锁等待，当前session锁升级成功；

    
完成插入后，page上的记录分布为(infimum), (2, 2100710), (2, 2100715), (2, 2100720), (supremum)。

    
Session 3：完成插入，最终page内的记录为(infimum), (2, 2100710), (2, 2100715), (2, 2100718), (2, 2100720), (supremum)。其中只有用户记录(2, 2100718)未被标记删除。

  

  

    

    

    
Test Book

  

  

    
在上期的
月报
中，我们已经详细介绍了Oracle MySQL以及社区分支最新的对InnoDB page flush的优化。在最近release的5.7.6版本中又有了进一步的改进。主要包括以下几点修改

    

      
修改一、更精确的loop时间

    

    
Page cleaner每做srv_flushing_avg_loops次flush后，会去计算刷脏和Redo LSN增长的速度。由于每次Page cleaner的工作量是自适应的，一次flush操作的时间可能超过1秒。

    
在新版本中，统一采用当前时间和上次更新速率的时间差来确认是否需要重新计算速率。因此参数innodb_flushing_avg_loops的行为实际上等同于每这么多秒后重计算速率。

    

      
修改二、根据buffer pool实例的脏页分布来决定刷脏

    

    
从5.7版本开始支持配置多个page cleaner线程以实现并行刷脏。在5.7.6之前的版本，Page cleaner协调线程根据当前的负载情况，会计算出预计需要flush的总page数和目标LSN，然后在多个bp instance间做个均分。

    
但是考虑一种场景：如果bp实例间的负载不平衡，某个实例在目标LSN之前的脏页很多，而有些实例很少，那么本应该多做刷脏动作的bp就可能产生堆积。 我们之前在
webscalesql google公开讨论组
 有过类似的讨论，感兴趣的可以看看。

    
回到正题上来，在5.7.6版本中，计算目标page数的方法大概如下：

    

      

        
根据当前脏页占比和Redo LSN增长状态，计算利用IO Capacity的百分比（pct_total）

      

      
计算目标LSN:

    

    

      
 target_lsn = oldest_lsn + lsn_avg_rate * buf_flush_lsn_scan_factor

    

    
其中oldest_lsn表示当前buffer pool中最老page的LSN，lsn_avg_rate表示每秒LSN推进的平均速率，buf_flush_lsn_scan_factor目前是hardcode的，值为3。

    

      
统计每个buffer pool 小于target_lsn的page数pages_for_lsn

    

    
初步估定每个bp instance 的n_pages_requested= pages_for_lsn /buf_flush_lsn_scan_factor。每个bp的pages_for_lsn被累加到sum_pages_for_lsn

    

      
同时根据io capacity估算总的需要flush的Page数量：

    

    

      
sum_pages_for_lsn /= buf_flush_lsn_scan_factor;
n_pages = (PCT_IO(pct_total) + avg_page_rate + sum_pages_for_lsn) / 3;

    

    
n_pages若超过innodb_io_capacity_max，则设置为innodb_io_capacity_max

    

      
轮询每个Buffer pool 实例：

    

    

      
如果当前有足够的Redo 空间：n_pages_requested  = n_pages / srv_buf_pool_instances
否则：n_pages_requested = n_pages_requested  * n_pages / sum_pages_for_lsn

    

    
也就是说，在Redo 空间足够时，依然采用均衡的刷脏逻辑。

    
在早期版本中，会根据两个条件来判断每个bp刷脏的进度：目标LSN及page数。而到了5.7.6版本里，大多数情况下只根据更加准确的请求刷page数来进行判定 （系统空闲时进行100% io capactiy的page flush、崩溃恢复时、以及实例shutdown时的刷脏除外）

    
虽然计算公式比较清晰，但有些factor的定值依然让人很困惑，也许是官方测试的比较理想的配置。不过最好还是设置成可配置的，由有经验的用户根据自己具体的负载情况来进行定制。

    

      
修改三、用户线程在检查Redo 空间时不参与刷脏

    

    
在之前版本中，当未做checkpoint的日志量过多时，用户线程会进行batch flush操作，将每个buffer pool instance的LSN推进到某个指定值。如果某个bp instance已经有别的线程在flush，则跳过尝试下一个instance，同时认为这次的flush操作是失败的，会返回重试。

    
当用户线程参与到刷脏时，通常会认为这是个性能拐点，TPS会出现急剧下降，大量线程陷入condtion wait 和并发flush。因此在5.7.6里，当用户线程需要推进LSN时，不再主动发起刷脏，这些工作会留给page cleaner线程来作。 用户线程只去轮询每个bp instance，直到所有的bp instance 的LSN超过其目标LSN，每次轮询默认sleep重试时间为10000微妙

    
事实上, Percona Server早在5.6版本里已经使用相同的策略了。

    

      
修改四、为page cleaner线程设置更高的优先级

    

    
在Linux平台下，对于page cleaner的协调线程和worker线程，其CPU优先级被设置为-20，即最高优先级，通过函数set_priority设置。目前还不支持参数配置。

    

      
修改五、防止checkpoint LSN被覆盖

    

    
在之前的版本中，尽管每次在写Redo时都会去检查日志文件是否容留了足够百分比的可用空间，但实际上并没有考虑即将写入的Redo log长度。如果我们操作一些极大的记录并产生很长的Redo log记录，这可能导致检查点LSN被覆盖掉，如果这时候crash就会无法安全的做崩溃恢复。

    
在新的逻辑里，在检测到当前写入的Redo 可能造成覆盖上次的checkpoint点时，就会进入sleep，等待page cleaner线程刷脏，然后再做一次Redo log checkpoint。如此循环直到checkpoint的LSN推进到安全的位置。

    

参考
： 
worklog：wl#7868
，及
补丁

  

  

    

    

    
Test Book

  

  

    

      
现象

    

    
mysql5.5,通过命令show variables like '%pid_file%'; 可以查到pid文件位置，例如/home/mysql/xx.pid。但发现在此目录下找不到此pid文件。

    

      
背景知识

    

    
mysql pid文件记录的是当前mysqld进程的pid。

    
通过mysqld_safe启动mysqld时，mysqld_safe会检查PID文件，未指定PID文件时，pid文件默认名为$DATADIR/
hostname
.pid

    

      
pid文件不存在，不做处理

      
文件存在，且pid已占用则报错"A mysqld process already exists"；文件存在，但pid未占用，则删除pid文件。

    

    
mysqld启动后会通过create_pid_file函数新建pid文件，通过getpid()获取当前进程pid并将pid写入pid文件。

    
因此，通过mysqld_safe启动时，pid文件的作用是为了防止同一个数据库被启动多次（数据文件是同一份，但端口不同的情况）。

    
另一个事实是mysqld在正常关闭时或通过SIGQUIT,SIGKILL,SIGTERM信号来kill mysqld时，会调用clean_up函数将pid文件删除。而mysqld异常crash时，pid文件是保留的。

    
另外mysqld_safe有一个功能是当mysqld异常crash时，后台会自动重启mysqld。mysqld关闭后，mysqld_safe会检查pid文件是否存在。如果存在则认为mysqld是异常crash, 需要自动重启；如果不存在则认为是正常关闭的，不需要自动重启,mysqld_safe程序也退出。

    

      
原因分析

    

    
查看error log发现数据库在相近的时间内启动了两次

    

      
141128 23:16:15 mysqld_safe Starting mysqld daemon with databases from 
….. 
141128 23:16:23 mysqld_safe Starting mysqld daemon with databases from 

    

    
前面说到mysqld_safe启动mysqld时,会根据pid文件来判断避免重复启动mysqld.然而，由于两次启动时间较近，导致第一次mysqld启动生成pid文件之前，第二个mysqld就已开始启动了，从而绕过了这个判断。第一次mysqld启动会成功，而第二次mysqld启动会因为文件锁而导致启动失败。

    

      
InnoDB: Unable to lock ./ibdata1, error: 11

    

    
第二次启动的mysqld关闭时会将第一次启动时产生的pid文件删除，从而导致pid文件丢失。

    
通过mysqld_safe启动mysqld来重现pid文件丢失有一定的概率性，必须是同时启动mysqld_safe。 如果是直接通过mysqld启动，同时指定相同的参数启动两次，那么就很容易重现了。

    

      
修复

    

    
参考5.6 官方的修复方法，在上述场景下删除pid文件时，需判断是否是自己新建的pid文件，同时文件中的pid是否和自身pid一致，否则不能删除。参考
补丁

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL 执行查询语句， 对于order by谓词，可能会使用filesort或者temporary。比如explain一条语句的时候，会看到Extra字段中可能会出现，using filesort和using temporary。下面我们就来探讨下两个的区别和适用场景。

    

      
解释

    

    
1. using filesort

    
filesort主要用于查询数据结果集的排序操作，首先MySQL会使用sort_buffer_size大小的内存进行排序，如果结果集超过了sort_buffer_size大小，会把这一个排序后的chunk转移到file上，最后使用多路归并排序完成所有数据的排序操作。

    
MySQL filesort有两种使用模式:

    
模式1: sort的item保存了所需要的所有字段，排序完成后，没有必要再回表扫描。

    
模式2: sort的item仅包括，待排序完成后，根据rowid查询所需要的columns。

    
很明显，模式1能够极大的减少回表的随机IO。

    
2. using temporary

    
MySQL使用临时表保存临时的结构，以用于后续的处理，MySQL首先创建heap引擎的临时表，如果临时的数据过多，超过max_heap_table_size的大小，会自动把临时表转换成MyISAM引擎的表来使用。

    
从上面的解释上来看，filesort和temporary的使用场景的区别并不是很明显，不过，有以下的原则:

    
filesort只能应用在单个表上，如果有多个表的数据需要排序，那么MySQL会先使用using temporary保存临时数据，然后再在临时表上使用filesort进行排序，最后输出结果。

    

      
适用场景

    

    
我们看一下下面的三个case:

    

      
 create table t1(    
    id int, col1 int, col2 varchar(10),
    key(id, col1));

    

    

      
 create table t2(
    id int, col1 int, col2 varchar(10),
    key(col1));

    

    
case 1:

    

      
 mysql> explain select * from t1 force index(id), t2 where t1.id=1 and t1.col1 = t2.col2 order by t1.col1 ;
 +----+-------------+-------+------+---------------+------+---------+-------+------+-------------+
 | id | select_type | table | type | possible_keys | key  | key_len | ref   | rows | Extra       |
 +----+-------------+-------+------+---------------+------+---------+-------+------+-------------+
 |  1 | SIMPLE      | t1    | ref  | id            | id   | 5       | const |    1 | Using where |
 |  1 | SIMPLE      | t2    | ALL  | NULL          | NULL | NULL    | NULL  |    1 | Using where |
 +----+-------------+-------+------+---------------+------+---------+-------+------+-------------+

    

    
case1: order by字段能够使用index的有序性，所以没有使用filesort，也没有使用temporary。

    
case 2:

    

      
 mysql> explain select * from t1 force index(id), t2 where t1.id=1 and t1.col1 = t2.col2 order by t1.col2;
 +----+-------------+-------+------+---------------+------+---------+-------+------+-----------------------------+
 | id | select_type | table | type | possible_keys | key  | key_len | ref   | rows | Extra                       |
 +----+-------------+-------+------+---------------+------+---------+-------+------+-----------------------------+
 |  1 | SIMPLE      | t1    | ref  | id            | id   | 5       | const |    1 | Using where; Using filesort |
 |  1 | SIMPLE      | t2    | ALL  | NULL          | NULL | NULL    | NULL  |    1 | Using where                 |
 +----+-------------+-------+------+---------------+------+---------+-------+------+-----------------------------+

    

    
case2: order by谓词，是在第一个表t1上完成，所以只需要在t1表上使用filesort，然后排序后的结果集join t2表。

    
case 3:

    

      
 mysql> explain select * from t1 force index(id), t2 where t1.id=1 and t1.col1 = t2.col2 order by t2.col1 ;
 +----+-------------+-------+------+---------------+------+---------+-------+------+----------------------------------------------+
 | id | select_type | table | type | possible_keys | key  | key_len | ref   | rows | Extra                                        |
 +----+-------------+-------+------+---------------+------+---------+-------+------+----------------------------------------------+
 |  1 | SIMPLE      | t1    | ref  | id            | id   | 5       | const |    1 | Using where; Using temporary; Using filesort |
 |  1 | SIMPLE      | t2    | ALL  | NULL          | NULL | NULL    | NULL  |    1 | Using where; Using join buffer               |
 +----+-------------+-------+------+---------------+------+---------+-------+------+----------------------------------------------+

    

    
case 3: order by的字段在t2表上，所以需要把t1，t2表join的结果保存到temporary表上，然后对临时表进行filesort，最后输出结果。

    

      
特别优化

    

    
MySQL对order by + limit的filesort做了特别优化，使用Priority queue来保存结果，即一个堆的结构，只保留top n的数据满足limit条件。

    

      
另外

    

    
filesort和temporary都会在tmp目录下创建文件，temporary创建的是MYI，MYD文件。但filesort的文件, 因为MySQL使用了create->open->unlink->使用->close的方式，隐藏了文件，以便进程异常结束的时候，临时文件能够自动回收掉，所以在评估tmp目录空间的时候，需要特别注意。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL 5.6 开始支持index_condition_pushdown特性，即server层把可以在index进行filter的谓词传递给引擎层完成过滤，然后结果返回到server。

    

      
工作方式

    

    
下面看一下InnoDB的处理方式:

    
通过设置set global optimizer_switch= "index_condition_pushdown=ON"来启用这个特性。

    
例如:

    

      
 CREATE TABLE `t1` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `col1` int(11) DEFAULT NULL,
   `col2` int(11) DEFAULT NULL,
   PRIMARY KEY (`id`),
   KEY `t1_cc` (`col1`,`col2`)
 )  ENGINE=InnoDB;

    

    

      
 mysql> explain select * from t1 where col1>= 1 and col1 <= 4 and col2=11;
 +----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+
 | id | select_type | table | type  | possible_keys | key   | key_len | ref  | rows | Extra                 |
 +----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+
 |  1 | SIMPLE      | t1    | range | t1_cc         | t1_cc | 10      | NULL |    2 | Using index condition |
 +----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+

    

    
1. 评估

    
在执行计划评估阶段，通过push_index_cond函数把index filter谓词传递给引擎handler。

    
2. 执行

    
InnoDB通过row_search_for_mysql获取每行记录的时候，使用innobase_index_cond函数来check index filter谓词条件是否成立。通过这种方式来完成index上的filter，整个过程并不复杂。

    

      
收益和限制

    

    
下面来看一下index_condition_pushdown的收益和限制:

    
收益: index_condition_pushdown所带来的收益可以从三个方面来看:

    
1. 数据copy

    
减少了InnoDB层返回给server层的数据量，减少了数据copy。

    
2. 随机读取

    
对于二级索引的扫描和过滤，减少了回primary key上进行随机读取的次数

    
3. 记录锁

    
记录锁是在InnoDB层完成的，比如如果是select for update语句，就会发现index_condition_pushdown会大大减少记录锁的个数。

    
限制: 目前index_condition_pushdown还有诸多的限制:

    
1. 索引类型

    
如果索引类型是primary key，就不会采用，因为index_condition_pushdown最大的好处是减少回表的随机IO，所以如果使用的index是PK，那么收益就大大减少，不过MySQL官方也在从新评估是否采用，见WL#6061。

    
2. 性能衰减

    
如果在primary key上面使用， 或者index filter谓词并不能有效过滤记录的时候，会发现sysbench的测试性能相比较关闭ICP的方式略低。可以参考

http://s.petrunia.net/blog/?p=101的讨论
。

    
3. SQL类型

    
1. 不支持多表update和delete语句，因为select和update会共用handler，而一个是一致性读，一个是当前读，同样的filter都apply的话，update会找不到记录。

    
2. 如果JOIN是CONST 或者 SYSTEM，不能使用。 因为CONST和SYSTEM做了特别优化，只执行一次，做了缓存，而应用filter的话，会产生数据一致性问题。

    

      
索引设计的原则

    

    
除了MySQL提供的这些新特性以外，DBA或者开发在设计index的时候，应该遵循的一些原则:

    
1. 查询谓词都能够通过index进行扫描

    
2. 排序谓词都能够利用index的有序性

    
3. index包含了查询所需要的所有字段

    
这就是传说中的Three-star index。

    
可以参考《Wiley,.Relational.Database.Index.Design.and.the.Optimizers》

    
MySQL的index_condition_pushdown，前进了一大步，不过相比较Oracle的index扫描方式，还有空间。比如oracle的index扫描支持的index skip scan方式。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL的DDL没有被设计成事务操作，因此DDL操作是无法回滚的（像PgSQL把DDL也设计成事务操作，DDL就可以在执行成功后被回滚操作取消）。这就会导致如果某个DDL语句内部被拆分为多个原子的DDL调用，那么这个DDL语句就不具备中途执行失败后回滚整个DDL语句的能力，也就是说，即使语句逻辑内的某个原子DDL调用失败了，也无法回滚已经完成的那些原子DDL调用。

    

      
问题描述

    

    
DROP DATABASE 就是一个例子，对于MySQL而言，DROP DATABASE 并非是一个原子DDL操作，因为它是一个个删除DB下的每张表，而 DROP TABLE 操作本身是会做预检查的，无法删除就会取消删表操作返回失败，所以 DROP TABLE 才能认为是原子的DDL调用。 这就会引起一个问题，如果一个DB中的某张表DROP失败了，实际上 DROP DATABASE 作为一个整体是执行失败的，但是DB中已经有一些表被删除了，因此Binlog中会记录成多个 DROP TABLE 操作，而不是一个 DROP DATABASE 语句。 如果被删除的表的表名都不长，还是会记录成一个删除多张表的 DROP TABLE 语句（DROP TABLE tbl1, tbl2, ...），但是如果表名总长度太长，MySQL会拆分为多个 DROP TABLE 语句来记录。 没有GTID的时候这似乎也不是什么大问题，但是引入GTID之后就有一个问题：每个语句只分配一个GTID。如果一个 DROP DATABASE 语句被拆分为多个 DROP TABLE 语句，Binlog中就会出现多个 DROP TABLE 事件共用一个GTID的情况！

    
举个例子：

    

      
 CREATE DATABASE db1;
 USE db1;
 CREATE TABLE t1 (id INT, name VARCHAR(20), PRIMARY KEY (`id`)) ENGINE=InnoDB;
 CREATE TABLE t2 (id INT) ENGINE=InnoDB;
 CREATE TABLE t3 (id INT) ENGINE=InnoDB;
 CREATE TABLE t4 (id INT) ENGINE=InnoDB;
 INSERT INTO t1 VALUES(1, "test"), (2, "try");
 INSERT INTO t2 VALUES(1);

 # 创建很多表名很长的表
 let $count = 50;
 while ($count) {
   eval create table a_very_long_long_long_long_long_table_name_$count(id int) engine = InnoDB;
   dec $count;
 }

 CREATE DATABASE db2;
 USE db2;
 CREATE TABLE t3 (id INT, num INT, ext_id INT,
 CONSTRAINT t3_fk_1 FOREIGN KEY (ext_id) REFERENCES db1.t1(id)) ENGINE=InnoDB;
 INSERT INTO t3 VALUES (1, 2, 2);

 DROP DATABASE IF EXISTS db1;

    

    
这里因为 db2.t3 表引用了 db1.t1 的字段作为外键约束，所以当 db1 做 DROP DATABASE 删除到 t1 表时就报错了，但此时很多表已经被删除了。我们看Binlog中记录的内容：

    

      
 SET @@SESSION.GTID_NEXT= '340d95b8-a699-11e4-868d-a0d3c1f20ae4:61'/*!*/;
 # at 12209
 #150128 10:56:10 server id 1  end_log_pos 13259 CRC32 0xcf952733        Query   thread_id=6     exec_time=1     error_code=0
 use `db1`/*!*/;
 SET TIMESTAMP=1422413770/*!*/;
 DROP TABLE IF EXISTS `a_very_long_long_long_long_long_table_name_33`,`a_very_long_long_long_long_long_table_name_15`,`a_very_long_long_long_long_long_table_name_43`,`a_very_long_long_long_long_long_table_name_13`,`a_very_long_long_long_long_long_table_name_10`,`a_very_long_long_long_long_long_table_name_28`,`a_very_long_long_long_long_long_table_name_23`,`a_very_long_long_long_long_long_table_name_32`,`a_very_long_long_long_long_long_table_name_50`,`a_very_long_long_long_long_long_table_name_17`,`a_very_long_long_long_long_long_table_name_19`,`a_very_long_long_long_long_long_table_name_30`,`a_very_long_long_long_long_long_table_name_48`,`a_very_long_long_long_long_long_table_name_49`,`a_very_long_long_long_long_long_table_name_3`,`a_very_long_long_long_long_long_table_name_29`,`a_very_long_long_long_long_long_table_name_9`,`a_very_long_long_long_long_long_table_name_47`,`a_very_long_long_long_long_long_table_name_12`,`a_very_long_long_long_long_long_table_name_42`
 /*!*/;
 # at 13259
 #150128 10:56:10 server id 1  end_log_pos 14315 CRC32 0xd91d1210        Query   thread_id=6     exec_time=1     error_code=0
 SET TIMESTAMP=1422413770/*!*/;
 DROP TABLE IF EXISTS `a_very_long_long_long_long_long_table_name_36`,`a_very_long_long_long_long_long_table_name_1`,`a_very_long_long_long_long_long_table_name_38`,`a_very_long_long_long_long_long_table_name_24`,`a_very_long_long_long_long_long_table_name_16`,`a_very_long_long_long_long_long_table_name_34`,`a_very_long_long_long_long_long_table_name_37`,`a_very_long_long_long_long_long_table_name_6`,`a_very_long_long_long_long_long_table_name_5`,`a_very_long_long_long_long_long_table_name_40`,`t2`,`a_very_long_long_long_long_long_table_name_4`,`a_very_long_long_long_long_long_table_name_20`,`a_very_long_long_long_long_long_table_name_45`,`a_very_long_long_long_long_long_table_name_2`,`a_very_long_long_long_long_long_table_name_27`,`a_very_long_long_long_long_long_table_name_46`,`a_very_long_long_long_long_long_table_name_35`,`t3`,`a_very_long_long_long_long_long_table_name_26`,`a_very_long_long_long_long_long_table_name_8`,`a_very_long_long_long_long_long_table_name_22`
 /*!*/;
 # at 14315
 #150128 10:56:10 server id 1  end_log_pos 14891 CRC32 0x06158e42        Query   thread_id=6     exec_time=1     error_code=0
 SET TIMESTAMP=1422413770/*!*/;
 DROP TABLE IF EXISTS `a_very_long_long_long_long_long_table_name_44`,`a_very_long_long_long_long_long_table_name_11`,`a_very_long_long_long_long_long_table_name_25`,`a_very_long_long_long_long_long_table_name_18`,`a_very_long_long_long_long_long_table_name_7`,`a_very_long_long_long_long_long_table_name_31`,`a_very_long_long_long_long_long_table_name_21`,`a_very_long_long_long_long_long_table_name_14`,`t4`,`a_very_long_long_long_long_long_table_name_39`,`a_very_long_long_long_long_long_table_name_41`

    

    
3个 DROP TABLE 语句都是同一个GTID：340d95b8-a699-11e4-868d-a0d3c1f20ae4:61

    
这就导致备库复制报错：

    

      
  Last_SQL_Errno: 1837
              Last_SQL_Error: Error 'When @@SESSION.GTID_NEXT is set to a GTID, you must explicitly set it to a different value after a COMMIT or ROLLBACK. Please check GTID_NEXT variable manual page for detailed explanation. Current @@SESSION.GTID_NEXT is '340d95b8-a699-11e4-868d-a0d3c1f20ae4:61'.' on query. Default database: 'db1'. Query: 'DROP TABLE IF EXISTS `a_very_long_long_long_long_long_table_name_36`,`a_very_long_long_long_long_long_table_name_1`,`a_very_long_long_long_long_long_table_name_38`,`a_very_long_long_long_long_long_table_name_24`,`a_very_long_long_long_long_long_table_name_16`,`a_very_long_long_long_long_long_table_name_34`,`a_very_long_long_long_long_long_table_name_37`,`a_very_long_long_long_long_long_table_name_6`,`a_very_long_long_long_long_long_table_name_5`,`a_very_long_long_long_long_long_table_name_40`,`t2`,`a_very_long_long_long_long_long_table_name_4`,`a_very_long_long_long_long_long_table_name_20`,`a_very_long_long_long_long_long_table_name_45`,`a_very_long_long_long_long_long_table_name_2`,`a_very_long_lon

    

    

      
解决方案

    

    
怎么解决这个问题呢？

    
1. 让MySQL支持DDL事务

    
2. 对DROP DATABASE操作进行预检查

    
第一种方案对MySQL改动太大了，完全不现实。因此我们采用了第二种方案，也间接实现了 DROP DATABASE 这个操作的原子性。 DROP DATABASE 之所以出现上面的状况，就是因为没有先检查表是否可以删除，而是走一步看一步，一个个删的时候才看能不能删除。我们对MySQL做了修正，对于DB中的每张表，在 DROP DATABASE 执行之前，都先预检查所有可能导致删除表失败的条件，如果一旦发现某张表会无法删除，就放弃整个 DROP DATABASE 操作，提示用户删除错误，让用户先自行解决问题后，再重新执行 DROP DATABASE。

    
例如上面例子中的情况，本来 DROP DATABASE 执行到有外键约束的表时会报错:

    

      
 ERROR 23000: Cannot delete or update a parent row: a foreign key constraint fails

    

    
但此时其他表已经删除了，而我们修正以后，同样的操作会报一个Error和一个Warning，并且没有真的删任何表：

    

      
 SHOW WARNINGS;
 Level    Code    Message
 Error    1217    Cannot delete or update a parent row: a foreign key constraint fails
 Note    3000    There are at least one table referenced by foreign key, the first table is 't1'. Please drop table(s) that referenced by foreign key first!

    

    
这里提示了用户有表存在问题无法删除，让用户先处理掉之后，再来执行 DROP DATABASE。此时库下面所有的表都还在，一定要预检查通过才会真的删除。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
在MySQL中，表是和操作系统中的文件对应的，而文件名在有的操作系统下是区分大小写的（比如linux），有的是不区分大小写（比如Windows），表名与文件名的大小写对应关系，MySQL 是通过
lower_case_table_names
 这个变量来控制的。

    
这个变量的有效取值是0，1，2，按照
官方文档
 的解释：

    
0表示，表在文件系统存储的时候，对应的文件名是按建表时指定的大小写存的，MySQL 内部对表名的比较也是区分大小写的； 

1表示，表在文件系统存储的时候，对应的文件名都小写的，MySQL 内部对表名的比较是转成小写的，即不区分大小写； 

2表示，表在文件系统存储的时候，对应的文件名是按建表时指定的大小写存的，但是 MySQL 内部对表名的比较是转成小写的，即不区分大小写。

    
0适用于区分大小写的系统，1都适用，2适用于不区分大小写的系统。

    
如果在开始使用MySQL选定了一个合适的值后，就不要改变，不然的话在之后使用中就会出现问题。

    

      
问题描述

    

    
这里给出一个在使用过程中改变 lower_case_table_names 导致 drop database 失败的案例。因为lower_case_table_names是个只读变量，只能在启动时指定参数设置值，或者 gdb 挂上去直接改内存。

    
首先在启动 mysqld 的时候，指定 lower_case_table_names = 0，我们执行这样的语句：

    

      
create database db1;
use db1;
create table t1(a int) engine = InnoDB; 
create table t2(a int) engine = MyISAM; 
create table T3(a int) engine = InnoDB; 
create table T4(a int) engine = MyISAM;

    

    
查看对应数据库目录下的表文件：

    

      
$ls db1
db.opt  t1.frm  t1.ibd  t2.frm  t2.MYD  t2.MYI  T3.frm  T3.ibd  T4.frm  T4.MYD  T4.MYI

    

    
然后重启mysqld，指定 lower_case_table_names =1，执行删除db1

    

      
mysql> drop database db1;
ERROR 1010 (HY000): Error dropping database (can't rmdir './db1', errno: 39)

    

    
可以看到删库语句执行失败，我们再看下数据库目录下的表文件

    

      
$ls a
T3.frm  T4.frm  T4.MYD  T4.MYI

    

    
可以看到，大写的 T3 和 T4 表没有被删掉，为什么呢？

    

      
问题分析

    

    
mysqld 在执行 drop database 操作的时候，是调用 mysql_rm_db 这个函数，在删除时先把db下的所有表都删掉，然后再把db删掉。为了找出对应db下的所有表，mysqld 是通过遍历数据库目录下的文件来做的，具体是用 find_db_tables_and_rm_known_files 这个函数，遍历数据库目录下的所有文件，然后构造出要 drop 的table列表，然而在构造删除列表过程中，会有这样一个判断:

    

      
if (lower_case_table_names)
  table_list->table_name_length= my_casedn_str(files_charset_info,
                                              table_list->table_name);

    

    
意思就是如果lower_case_table_names非0的话，就把 table_name 转成小写的，T3 和 T4 就被转成 t3 和 t4，这样生成的 table_list 中的对应的表是 t1,t2,t3,t4。之后拿着这样的 table_list 通过 mysql_rm_table_no_locks 一个个删表，这样就只把t1,t2 给删了，t3和t4不存在，并且删表时的逻辑是带有 if exists 的，所以也不会报错。

    
在list表都删除完后，调用rm_dir_w_symlink来删除db目录，此时db1目录下还有 T3 T4 对应的文件，这个函数会调用系统的 rmdir 函数，而当目录非空的时候，rmdir是执行失败的。

    
所以我们看到最终的错误提示 Error dropping database (can't rmdir './db1', errno: 39)

    

      
建议

    

    
上面的问题是改变 lower_case_table_names 导致 drop database 失败，其实还有许多其它的因为lower_case_table_names值改变导致的问题，比如主备库本来这个值本来是一致的，如果只改主库的值的话，就会导致备库复制中断，报找不到表的问题，或者本来是不区分大小写的，应用里的写的SQL语句有大写表名，也有小写表名，之后改成区分大小写，就会导致应用出错。

    
所以建议是:

    

      
不要轻易的改变lower_case_table_names的值，如果真要改的话，要先检查下已有的表是否有大小写的问题，保证目前的表名和要改的模式是一致的，比如从区分大小写改为不区分大小写，那就不应该有大写表存在，如果有的话，要先把大写表rename成小写的，如果本来有共存同名的大写表和小写表，就要想办法去掉一个。

      
应用不要依赖于 mysql 的表名转换机制，应用里的sql语句应该和表名一致，在不区分大小写的时候，应用里对同一个表的使用，不要既有大写表名，也有小写表名。

    

  

  

    

    

    
Test Book

  

  

    
Logical Decoding是9.4里面的一个主要功能，是向最终实现逻辑复制迈出的一大步。简言之，它的功能是从PG的WAL日志中，读取数据库更新信息，然后“翻译”（Decode）成逻辑的形式，可发送到远程从库做数据同步。这个功能还可以用于，DBA在数据库宕机，并发生主从切换后，检查原主库有哪些更新宕机前未同步到从库，并手动同步来弥补丢失的（已提交）的更新。这里我们探索一下它的使用和实现原理。

    

      
使用

    

    
1）首先需要将 wal_level这个配置参数设置为logical，并保证max_replication_slots至少为1。

    
2）创建Logical Replication Slot。Logical Decoding利用了Logical Replication Slot来获取和Decode日志。关于Physical Replication Slot我们在上期中有详细介绍，而Logical Replication Slot与Physical Replication Slot的数据结构类似。创建一个Logical Replication Slot的命令如下：

    

      
SELECT * FROM pg_create_logical_replication_slot('my_rep_slot', 'test_decoding');
 slot_name  | xlog_position
-------------+---------------
my_rep_slot | 0/7FE68E8

    

    

      
select * from pg_replication_slots;
  slot_name   |    plugin     | slot_type | datoid | database | active | xmin | catalog_xmin | restart_lsn
---------------+---------------+-----------+--------+----------+--------+------+--------------+-------------
my_rep_slot   | test_decoding | logical   |  13003 | postgres | f      |      |         9735 | 0/7FE6828

    

    
注意，创建Logical Replication Slot，需要指定一个输出插件（Output Plugin）。这个插件要提供一些回调函数，用于格式化输出日志。就是说，内核中的Logical Decoding先读取WAL日志，将其Decode成一种半成品式的格式（已包含所有有效信息，比如被更新的表名，更新类型，更新前后的数据记录即Tuple），然后交由输出插件最终呈现给用户。这里我们使用了系统自带的一个插件，即test_decoding。上面的输出中，创建命令返回的xlog_position的值是当前系统中，最后被写入磁盘的日志记录的LSN。此LSN之后的日志，都可以通过Logical Decoding进行解析了。

    
3）解析日志。

    

      
--先做一个执行插入操作的事务：
begin;
insert into test values(2);
commit;
--使用pg_logical_slot_peek_changes，Decode对应的WAL日志。
SELECT * FROM pg_logical_slot_peek_changes('my_rep_slot', NULL, NULL, 'include-timestamp', 'on', 'include-xids', 'on');
location  | xid  |                      data
-----------+------+------------------------------------------------
 0/7FE6C80 | 9736 | BEGIN 9736
 0/7FE6C80 | 9736 | table public.test: INSERT: col[integer]:2
 0/7FE6DE0 | 9736 | COMMIT 9736 (at 2015-03-13 15:03:49.803582+08)

    

    
pg_logical_slot_peek_changes返回数据中的第二行记录了我们所做的INSERT操作（只有在事务提交后，才能看到这些修改）。而我们通过pg_xlogdump可以看到原来的WAL日志记录为：

    

      
<PG installdir>/bin/pg_xlogdump -s  0/7FE6C80 -n 1
rmgr: Heap        len (rec/tot):     31/   219, tx:       9736, lsn: 0/07FE6C80, prev 0/07FE6C48, bkp: 1000, desc: insert: rel 1663/13003/16507; tid 0/3

    

    
也就是说，Logical Decoding把这条日志，反解析成一个“table public.test: INSERT: col[integer]:2”字符串。其实如果对输出插件稍作修改，可以直接解析成可执行的SQL语句：“INSERT INTO public.test (col) VALUES(2)“

    
那么这是如何做到的呢？下面我们看看其中原理。

    

      
原理

    

    
追踪一下pg_logical_slot_peek_changes的调用链，不难看到Decoding的整个过程。在pg_logical_slot_get_changes_guts中，从restart_lsn（即上次的最后读取后，剩下的事务中最先开始的事务对应的LSN）开始，先用XLogReadRecord函数（注意，会先从cache里面读取日志，如果cache里面没有，则会到磁盘中的日志段里面读取）获取一个日志记录，存入结构体XLogRecord，紧接着用LogicalDecodingProcessRecord做Decode。如此循环，直到读完日志或到达指定点。

    
LogicalDecodingProcessRecord是解析日志的关键。它在内存中维护一个哈希表（LogicalDecodingContext->reorder->by_txn），存放正在处理的事务信息。在处理每个日志记录时，如果遇到一个BEGIN操作，就在哈希表中插入相应事务。而只有在遇到COMMIT操作的时候，才会把整个事务的所有语句解析出来（调用ReorderBufferCommit）。这个过程中，它要为每个事务维护一个快照（Snapshot）。每次有事务做COMMIT都要更新一下这个快照。这样，等到事务COMMIT时，它的快照是最新的，可以用来访问系统表，得到如relation node id与relation名字之间的对应关系等信息，从而完成Decode。需要说明的是，LogicalDecodingProcessRecord在维护快照时做了优化：因为Decode过程只需要访问系统表，所以快照中只保留了那些更新了系统表的事务。

    
另外，Replication Slot的xmin信息会影响系统的Vacuum，使其保留仍然需要的数据版本。而SnapBuildProcessRunningXacts会不断更新Replication Slot中的xmin信息，避免使Vacuum停滞。

    
输出Decode后日志的过程，都在DecodeCommit调用的ReorderBufferCommit函数中。在ReorderBufferCommit中，调用了输出插件的apply_change等回调函数，会将日志信息打印成我们最终看到的字符串，这样就完成了Decode。

  

  

    

    

    
Test Book

  

  

    
PG 9.4版本里面，增强了对json数据的支持，受到了很大关注。9.4之前，PG已经原生支持json数据类型了，但只是用字符串的形式存储和处理。这样做天然有性能上的缺点：每次对json字符串里面的数据进行查询，一般需要全表扫描加字符串匹配，效率很低。当然也可以在存储json的字符串字段上创建GIN索引，但需要对查询中用到的json的key或value创建单独索引，造成要被动维护很多索引。所以，这种json类型，只适用于把PG单纯作为数据存储，只读入读出数据，不对数据进行限定key或value查询的场景。

    
PG 9.4中引入了jsonb类型。其特点是，将json数据中的key和value进行解析，转换为PG的基本数据类型，包括数字，字符串和布尔类型等；同时，增加了对应的GIN处理函数，可以将json中的所有key和value转换为GIN索引的key。这样，只用一个GIN索引，即可实现对所有key或value的条件查询。下面我们分析一下jsonb的使用方法和内核实现。

    

      
使用

    

    
创建含jsonb类型的表方法如下所示：

    

      
=> create table test_jsonb(col_jsonb jsonb);
CREATE TABLE
=> insert into test_jsonb values('{"product": "PostgreSQL", "version": 9.4, "platform":["win", "linux", "unix"]}'::jsonb);
INSERT 0 1

    

    
创建GIN索引的方法如下：

    

      
--创建jsonb_ops索引：
=> create index idx_jsonb on test_jsonb using gin (col_jsonb);
CREATE INDEX
--创建jsonb_ops_path索引：
=> create index idx_jsonb_path on test_jsonb using gin (col_jsonb jsonb_path_ops);
CREATE INDEX

    

    
可以使用下面的查询得到含有键值对的行：

    

      
=>select * from test_jsonb where col_jsonb @> '{"product" : "PostgreSQL"}';
                                    col_jsonb
---------------------------------------------------------------------------------
{"product": "PostgreSQL", "version": 9.4, "platform": ["win", "linux", "unix"]}

    

    

      
内核实现

    

    
先分析一下jsonb是如何从字符串，变成特殊的二进制形式存入磁盘的。追踪一下jsonb插入的过程，可以看到PG所调用的函数流程如下。

    

      
jsonb_in->jsonb_from_cstring->pg_parse_json->JsonbValueToJsonb

    

    
其中，pg_parse_json先把用户输入的字符串，通过编译器转换为一个树形结构（每个节点的类型为JsonbValue）。然后JsonbValueToJsonb在这个结构基础上，转换为存入磁盘的格式。从convertJsonbObject函数可以看出，转换为磁盘格式的策略为：从树形结构的根部开始遍历，递归进行广度优先遍历。对于同一父亲下面的子键值，将所有键名（字符串）长度写入buffer中预留的头部，随后将键名依次写入buffer中。最后再以相似的方式写入键所对应的所有值（值如果是json对象，则递归调用）。这样，读入buffer的头部，就可以遍历出所有键名的位置，得到键名。再从读第一个键值开始，读入对应的值或子键，最终得到整个树（见JsonbIteratorNext）。

    
采用这种存储方式，jsonb所占用的存储空间比原来支持的json类型要多一些。其实，jsonb的核心优势在于快速和灵活的索引。从前面创建index的语句可以看到，jsonb支持两种特有的GIN索引jsonb_ops和jsonb_path_ops。我们知道，GIN索引建立时，会先通过内建函数从表中每行数据的索引字段的值中，抽取键（key），一个字段值一般可抽取多个key。然后，将每个key与含有此key的所有行的ID组成键值对，再将它们插入b树索引供查询。那么这两种GIN索引有什么区别呢？

    
它们的区别在于，生成GIN key的方式不同。jsonb_ops调用gin_extract_jsonb函数生成key，这样每个字段的json数据中的所有键和值都被转成GIN的key；而jsonb_path_ops使用函数gin_extract_jsonb_path抽取：如果将一个jsonb类型的字段值看做一颗树，叶子节点为具体的值，中间节点为键，则抽取的每个键值实际上时每个从根节点到叶子节点的路径对应的hash值。

    
不难推测，jsonb_path_ops索引的key的数目和jsonb的叶子节点数有关，用叶子节点的路径做查询条件时会比较快（这也是这种索引唯一支持的查询方式）；而jsonb_ops索引的key的数目与jsonb包含的键和值（即树形结构的所有节点）的总数有关，可以用于路径查询之外的其他查询。

  

  

    

    

    
Test Book

  

  

    
这次还是以介绍TokuDB内部机制为主, 本篇来谈谈TokuDB内部的线程池模型。

    
TokuDB内部有一个线程池实现kibbutz， 代码: 

https://github.com/Tokutek/ft-index/blob/master/util/kibbutz.cc

    
其调度思想基于
work-stealing
， 代码也很简洁， 大体思路就是：维护一个任务队列， 空闲线程自己去这个队列领取任务。

    
kibbutz中文为“基布兹”,是以色列的一个集体社区，感兴趣的
戳这里
。

    
TokuDB内部线程池按功能可以分为以下3大块：

    

      
节点“饱和”apply线程池

    

    
当一个节点“饱和”的时候，TokuDB需要把节点message buffer中的数据apply到子节点(这个行为是由TokuDB的特殊索引结构决定)。

    
这个线程池的作用是实现并发apply“饱和”节点，线程数目为物理CPU的个数。

    

      
缓存专用线程池

    

    
这个线程池专门为缓存服务，包括两大块:

    
a) 节点预读线程，比如做区间查找的时候，在某些条件下会触发子节点预读，提前在后台线程把节点读取到缓存。

    
b) LRU剔除线程，当缓存大小到达高水位的时候，后台线程把LRU尾端的脏节点刷到磁盘，并从LRU中清除。

    
这个池子里的线程数目较多，干的活也比较重，线程数目为物理CPU数*2。

    

      
checkpoint克隆线程池

    

    
这个线程池比较特殊。

    
做checkpoint的时候，如果一个节点处于“pin”状态，并且它是可克隆的，就使用后台线程把它的数据克隆出来并刷到磁盘，这样checkpoint可以继续进行下去(如果此节点不可克隆，checkpoint线程会一直等到这个pin状态结束）。

    
这个线程数为物理CPU数/4（如果CPU > 4)。

    
好的线程池设计+好的任务调度算法，应该是一个引擎高效的最基本条件，让任务尽量并行起来。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 性能优化· InnoDB buffer pool flush策略漫谈

        

      

      

        

          
MySQL · 社区动态· 5.6.23 InnoDB相关Bugfix

        

      

      

        

          
PgSQL · 特性分析· Replication Slot

        

      

      

        

          
PgSQL · 特性分析· pg_prewarm

        

      

      

        

          
MySQL · 答疑释惑· InnoDB丢失自增值

        

      

      

        

          
MySQL · 答疑释惑· 5.5 和 5.6 时间类型兼容问题

        

      

      

        

          
MySQL · 捉虫动态· 变量修改导致binlog错误

        

      

      

        

          
MariaDB · 特性分析· 表/表空间加密

        

      

      

        

          
MariaDB · 特性分析· Per-query variables

        

      

      

        

          
TokuDB · 特性分析· 日志详解

        

      

    

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
我们知道InnoDB使用buffer pool来缓存从磁盘读取到内存的数据页。buffer pool通常由数个内存块加上一组控制结构体对象组成。内存块的个数取决于buffer pool instance的个数，不过在5.7版本中开始默认以128M（可配置）的chunk单位分配内存块，这样做的目的是为了支持buffer pool的在线动态调整大小。

    
Buffer pool的每个内存块通过mmap的方式分配内存，因此你会发现，在实例启动时虚存很高，而物理内存很低。这些大片的内存块又按照16KB划分为多个frame，用于存储数据页。

    
虽然大多数情况下buffer pool是以16KB来存储数据页，但有一种例外：使用压缩表时，需要在内存中同时存储压缩页和解压页，对于压缩页，使用Binary buddy allocator算法来分配内存空间。例如我们读入一个8KB的压缩页，就从buffer pool中取一个16KB的block，取其中8KB，剩下的8KB放到空闲链表上；如果紧跟着另外一个4KB的压缩页读入内存，就可以从这8KB中分裂4KB，同时将剩下的4KB放到空闲链表上。

    
为了管理buffer pool，每个buffer pool instance 使用如下几个链表来管理：

    

      
LRU链表包含所有读入内存的数据页；

      
Flush_list包含被修改过的脏页；

      
unzip_LRU包含所有解压页；

      
Free list上存放当前空闲的block。

    

    
另外为了避免查询数据页时扫描LRU，还为每个buffer pool instance维护了一个page hash，通过space id 和page no可以直接找到对应的page。

    
一般情况下，当我们需要读入一个Page时，首先根据space id 和page no找到对应的buffer pool instance。然后查询page hash，如果page hash中没有，则表示需要从磁盘读取。在读盘前首先我们需要为即将读入内存的数据页分配一个空闲的block。当free list上存在空闲的block时，可以直接从free list上摘取；如果没有，就需要从unzip_lru 或者 lru上驱逐page。

    
这里需要遵循一定的原则（参考函数buf_LRU_scan_and_free_block , 5.7.5）：

    

      
首先尝试从unzip_lru上驱逐解压页；

      
如果没有，再尝试从Lru链表上驱逐Page；

      
如果还是无法从Lru上获取到空闲block，用户线程就会参与刷脏，尝试做一次SINGLE PAGE FLUSH，单独从Lru上刷掉一个脏页，然后再重试。

    

    
Buffer pool中的page被修改后，不是立刻写入磁盘，而是由后台线程定时写入，和大多数数据库系统一样，脏页的写盘遵循日志先行WAL原则，因此在每个block上都记录了一个最近被修改时的Lsn，写数据页时需要确保当前写入日志文件的redo不低于这个Lsn。

    
然而基于WAL原则的刷脏策略可能带来一个问题：当数据库的写入负载过高时，产生redo log的速度极快，redo log可能很快到达同步checkpoint点。这时候需要进行刷脏来推进Lsn。由于这种行为是由用户线程在检查到redo log空间不够时触发，大量用户线程将可能陷入到这段低效的逻辑中，产生一个明显的性能拐点。

    

      
Page Cleaner线程

    

    
在MySQL5.6中，开启了一个独立的page cleaner线程来进行刷lru list 和flush list。默认每隔一秒运行一次，5.6版本里提供了一大堆的参数来控制page cleaner的flush行为，包括：

    

      
innodb_adaptive_flushing_lwm， 
innodb_max_dirty_pages_pct_lwm
innodb_flushing_avg_loops
innodb_io_capacity_max
innodb_lru_scan_depth

    

    
这里我们不一一介绍，总的来说，如果你发现redo log推进的非常快，为了避免用户线程陷入刷脏，可以通过调大innodb_io_capacity_max来解决，该参数限制了每秒刷新的脏页上限，调大该值可以增加Page cleaner线程每秒的工作量。如果你发现你的系统中free list不足，总是需要驱逐脏页来获取空闲的block时，可以适当调大innodb_lru_scan_depth 。该参数表示从每个buffer pool instance的lru上扫描的深度，调大该值有助于多释放些空闲页，避免用户线程去做single page flush。

    
为了提升扩展性和刷脏效率，在5.7.4版本里引入了多个page cleaner线程，从而达到并行刷脏的效果。目前Page cleaner并未和buffer pool绑定，其模型为一个协调线程 + 多个工作线程，协调线程本身也是工作线程。因此如果innodb_page_cleaners设置为4，那么就是一个协调线程，加3个工作线程，工作方式为生产者-消费者。工作队列长度为buffer pool instance的个数，使用一个全局slot数组表示。

    
协调线程在决定了需要flush的page数和lsn_limit后，会设置slot数组，将其中每个slot的状态设置为PAGE_CLEANER_STATE_REQUESTED, 并设置目标page数及lsn_limit，然后唤醒工作线程 (pc_request)

    
工作线程被唤醒后，从slot数组中取一个未被占用的slot，修改其状态，表示已被调度，然后对该slot所对应的buffer pool instance进行操作。直到所有的slot都被消费完后，才进入下一轮。通过这种方式，多个page cleaner线程实现了并发flush buffer pool，从而提升flush dirty page/lru的效率。

    

      
MySQL5.7的InnoDB flush策略优化

    

    
在之前版本中，因为可能同时有多个线程操作buffer pool刷page （在刷脏时会释放buffer pool mutex），每次刷完一个page后需要回溯到链表尾部，使得扫描bp链表的时间复杂度最差为O（N*N）。

    
在5.6版本中针对Flush list的扫描做了一定的修复，使用一个指针来记录当前正在flush的page，待flush操作完成后，再看一下这个指针有没有被别的线程修改掉，如果被修改了，就回溯到链表尾部，否则无需回溯。但这个修复并不完整，在最差的情况下，时间复杂度依旧不理想。

    
因此在5.7版本中对这个问题进行了彻底的修复，使用多个名为hazard pointer的指针，在需要扫描LIST时，存储下一个即将扫描的目标page，根据不同的目的分为几类：

    

      
flush_hp: 用作批量刷FLUSH LIST

      
lru_hp: 用作批量刷LRU LIST

      
lru_scan_itr: 用于从LRU链表上驱逐一个可替换的page，总是从上一次扫描结束的位置开始，而不是LRU尾部

      
single_scan_itr: 当buffer pool中没有空闲block时，用户线程会从FLUSH LIST上单独驱逐一个可替换的page 或者 flush一个脏页，总是从上一次扫描结束的位置开始，而不是LRU尾部。

    

    
后两类的hp都是由用户线程在尝试获取空闲block时调用，只有在推进到某个buf_page_t::old被设置成true的page (大约从Lru链表尾部起至总长度的八分之三位置的page)时， 再将指针重置到Lru尾部。

    
这些指针在初始化buffer pool时分配，每个buffer pool instance都拥有自己的hp指针。当某个线程对buffer pool中的page进行操作时，例如需要从LRU中移除Page时，如果当前的page被设置为hp，就要将hp更新为当前Page的前一个page。当完成当前page的flush操作后，直接使用hp中存储的page指针进行下一轮flush。

    

      
社区优化

    

    
一如既往的，Percona Server在5.6版本中针对buffer pool flush做了不少的优化，主要的修改包括如下几点：

    

      

        
优化刷LRU流程buf_flush_LRU_tail 

该函数由page cleaner线程调用。

        

          
原生的逻辑：依次flush 每个buffer pool instance，每次扫描的深度通过参数innodb_lru_scan_depth来配置。而在每个instance内，又分成多个chunk来调用；

          
修改后的逻辑为：每次flush一个buffer pool的LRU时，只刷一个chunk，然后再下一个instance，刷完所有instnace后，再回到前面再刷一个chunk。简而言之，把集中的flush操作进行了分散，其目的是分散压力，避免对某个instance的集中操作，给予其他线程更多访问buffer pool的机会。

        

      

      

        
允许设定刷LRU/FLUSH LIST的超时时间，防止flush操作时间过长导致别的线程（例如尝试做single page flush的用户线程）stall住；当到达超时时间时,page cleaner线程退出flush。

      

      

        
避免用户线程参与刷buffer pool 

当用户线程参与刷buffer pool时，由于线程数的不可控，将产生严重的竞争开销，例如free list不足时做single page flush，以及在redo空间不足时，做dirty page flush，都会严重影响性能。Percona Server允许选择让page cleaner线程来做这些工作，用户线程只需要等待即可。出于效率考虑，用户还可以设置page cleaner线程的cpu调度优先级。 

另外在Page cleaner线程经过优化后，可以知道系统当前处于同步刷新状态，可以去做更激烈的刷脏(furious flush)，用户线程参与到其中，可能只会起到反作用。

      

      

        
允许设置page cleaner线程，purge线程，io线程，master线程的CPU调度优先级，并优先获得InnoDB的mutex。

      

      
使用新的独立后台线程来刷buffer pool的LRU链表，将这部分工作负担从page cleaner线程剥离。 

实际上就是直接转移刷LRU的代码到独立线程了。从之前Percona的版本来看，都是在不断的强化后台线程，让用户线程少参与到刷脏/checkpoint这类耗时操作中。

    

  

  

    

    

    
Test Book

  

  

    
本节摘取了MySQL5.6.23的几个和InnoDB相关的主要bugfix，简单阐述下问题及解决方案。

    

      
问题一

    

    
当执行FLUSH TABLE..FOR EXPORT命令时，会暂停purge线程的操作。这一步通过设置一个标记purge_sys->state的值为PURGE_STATE_STOP来告诉purge线程该停下来歇歇了。

    
然而如果Purge线程当前正在函数srv_do_purge中工作，该函数会执行一个while循环，退出条件是当前server shutdown，或者上次purge的page数为0，并没有检查purge线程的状态是否被设置为PURGE_STATE_STOP; 很显然，如果当前的history list非常长，那么可能需要等待purge完成后，才能退出循环，而在用户看来，就好像hang了很久一样。推长history list 很容易：开启一个打开read view的事务（例如RR级别下执行一个SELECT）不做提交，同时有并发的DML，跑一段时间history list就上去了。

    

      
解决

    

    
在函数srv_do_purge函数的while退出条件中加上purge线程状态判断，如果被设置为PURGE_STATE_STOP，就退出循环。

    

      
补丁

    

    

      
问题二

    

    
在执行InnoDB crash recovery阶段，如果发现不合法的大字段，就会去调用函数ib_warn_row_too_big 去打印一条warning，函数为push_warning_printf。然而这个函数的目的是给客户端返回一条warning，而这时候系统还在崩溃恢复阶段，并没有合法的thd对象，因此造成系统崩溃。

    
Tips：这个bug是在升级到新版本5.6出现的，最根本的原因是5.6新版本对大字段长度做的约束。早期版本5.6及之前的版本，我们可以定义非常大的blob字段，但如果字段太长，对这些字段的修改，可能导致redo log的checkpoint点被覆盖，因为计算redo log 空间是否足够，并没有依赖即将插入的redo 记录长度，而仅仅是保留一定的比例。因此在5.6.22版本中做了限制：如果blob的长度超过innodb_log_file_size * innodb_log_files_in_group的十分之一时，就会更新失败，给用户返回DB_TOO_BIG_RECORD的错误码。这个问题在5.7版本里被彻底解决：每写4个blob外部存储页，检查一次redo log空间是否足够，如果不够用，就推进checkpoint点。

    

      
解决

    

    
在函数ib_warn_row_too_big中判断当前线程thd是否被初始化，如果为NULL，直接返回，不调用push_warning_printf。

    

      
补丁

    

    

      
问题三

    

    
当我们通过alter语句修改一个被外键约束的列名时，由于没有从数据词典cache中将包含老列名的cache项驱逐掉，导致重载外键约束时失败。

    
举个简单的例子：

    

      
root@sb1 12:37:13>CREATE TABLE t1 (a INT NOT NULL,  b INT NOT NULL,  INDEX idx(a)) ENGINE=InnoDB;
Query OK, 0 rows affected (0.00 sec)

    

    

      
root@sb1 12:37:26>CREATE TABLE t2 (a INT KEY,  b INT,  INDEX ind(b),  FOREIGN KEY (b) REFERENCES t1(a) ON DELETE CASCADE ON UPDATE CASCADE)  ENGINE=InnoDB;
Query OK, 0 rows affected (0.00 sec)

    

    

      
root@sb1 12:37:41>ALTER TABLE t1 CHANGE a id INT;
Query OK, 0 rows affected, 1 warning (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 1

    

    

      
root@sb1 12:37:48>show warnings;
+-------+------+-----------------------------------+
| Level | Code | Message                           |
+-------+------+-----------------------------------+
| Error | 1215 | Cannot add foreign key constraint |
+-------+------+-----------------------------------+
1 row in set (0.00 sec)

    

    

      
root@sb1 12:47:39>show create table t1\G
*************************** 1\. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `id` int(11) DEFAULT NULL,
  `b` int(11) NOT NULL,
  KEY `idx` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

    

    

      
root@sb1 12:52:08>INSERT INTO t2 VALUES (56, 6);
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`sb1`.`t2`, CONSTRAINT `t2_ibfk_1` FOREIGN KEY (`b`) REFERENCES `t1` (`a`) ON DELETE CASCADE ON UPDATE CASCADE)

    

    
可以看到，尽管t1表的a列已经被rename成 id，但打印出来的信息也并没有更正。

    

      
解决

    

    
当被外键约束的列名被修改时，将对应的外键项从数据词典cache中驱逐，当其被随后重新加载时就会使用新的对象。

    

      
补丁

    

    

      
问题四

    

    
如上文所提到的，在新版本InnoDB中，对blob字段的数据操作需要保证其不超过总的redo log file大小的十分之一，但是返回的错误码DB_TOO_BIG_RECORD及打印的信息太容易让人误解，大概如下：

    

      
ERROR 42000: Row size too large (> ####). Changing some columns to TEXT or BLOB or using ROW_FORMAT=DYNAMIC or ROW_FORMAT=COMPRESSED may help. In current row format, BLOB prefix of 768 bytes is stored inline

    

    

      
解决

    

    
输出更合适、更直观的错误信息，如下：

    

      
ERROR 42000: The size of BLOB/TEXT data inserted in one transaction is greater than 10% of redo log size. Increase the redo log size using innodb_log_file_size.

    

    

      
补丁

    

    

      
问题五

    

    
FLUSH TABLE操作在某些情况下可能导致实例crash。 例如如下执行序列：

    

      
mysql> CREATE TABLE t1(C TEXT CHARACTER SET UJIS) ENGINE=INNODB;
Query OK, 0 rows affected (0.00 sec)

mysql> LOCK TABLES t1 WRITE,t1 AS t0 READ,t1 AS t2 READ;
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH TABLE t1;   ---- 实例CRASH

    

    
当执行FLUSH TABLE时，在重载表cache时，InnoDB层会针对每个表设置其状态（ha_innobase::store_lock）。如果执行FLUSH 操作，并且加的是读锁时，就会调用函数row_quiesce_set_state将table->quiesce设置为QUIESCE_START。在上例中，表t1的两个表名表均加读锁，造成重复设置状态为QUIESCE_START，导致断言失败。

    
Tips：在5.6版本中，虽然有明确的FLUSH TABLE..FOR EXPORT命令来协助转储ibd文件。但实际上，简单的FLUSH TABLE操作默认就会产生一个tbname.cfg的配置文件，拷贝该文件和ibd，可以将数据转移到其他实例上。table->quiesce用于标识操作状态，例如，如果标识为QUIESCE_START，就会在函数ha_innobase::external_lock中调用row_quiesce_table_start来启动配置文件的生成。

    

      
解决

    

    
移除断言

    

      
补丁

    

    

      
问题六

    

    
线上实例错误日志中偶尔出现 “UNABLE TO PURGE A RECORD”，从官方bug系统来看，很多用户都遇到了类似的问题。

    
当change buffer模块以如下序列来缓存索引操作时可能产生上述错误信息：

    

      
记录被标记删除（IBUF_OP_DELETE_MARK）

      
随后插入相同记录--IBUF_OP_INSERT

      
Purge线程需要物理删除二级索引记录，操作被buffer--IBUF_OP_DELETE

    

    
当读入物理页时，总是需要进行ibuf merge。如果执行到IBUF_OP_DELETE这种类型的change buffer时，发现记录并没有被标记删除，就会导致错误日志报错。

    
显然上述的操作序列是不合理的，正确的序列应该是IBUF_OP_DELETE_MARK，IBUF_OP_DELETE，IBUF_OP_INSERT。

    
为了搞清楚逻辑，我们简单的理一下相关代码。

    
注意IBUF_OP_DELETE是由第一步的标记删除操作触发，Purge线程发起；在每个buffer pool的控制结构体中，有一个成员buf_pool->watch[BUF_POOL_WATCH_SIZE]，BUF_POOL_WATCH_SIZE的值为purge线程个数，用于辅助Purge操作。

    
假定内存中没有对应的Page，Purge线程会做如下几件事儿：

    

      

        
首先查询buffer pool，看看page是否已经读入内存；如果不在内存中，则将page no等信息存储到watch数组中，并插入page hash（buf_pool_watch_set）。（如果随后page被读入内存，也会删除watch标记）

      

      

        
判断该二级索引记录是否可以被Purge（row_purge_poss_sec，当该二级索引记录对应的聚集索引记录没有delete mark并且其trx id比当前的purge view还旧时，不可以做Purge操作）

      

      

        
随后在插入IBUF_OP_DELETE类型的ibuf记录时，还会double check下该page是否被设为sentinel （ibuf_insert_low，buf_pool_watch_occurred），如果未被设置，表明已经page已经读入内存，就可以直接去做purge，而无需缓存了。

      

      
对于普通的操作类型，例如IBUF_OP_INSERT和IBUF_OP_DELETE_MARK，同样也会double check page 是否读入了内存。在函数ibuf_insert中会调用buf_page_hash_get进行检查，如果page被读入内存，则不缓存操作，如果请求的Page被设为sentinel，则从buf_page_hash_get返回NULL，因此随后判定需要缓存该类型的操作。这也正是问题的所在：

    

    

      
标记删除记录，写入IBUF_OP_DELETE_MARK

      
Purge线程设置page对应的sentinel，完成合法性检查，准备调用ibuf_insert

      
插入相同记录，写入IBUF_OP_INSERT

      
Purge线程写入IBUF_OP_DELETE

    

    

      
解决

    

    
如果记录所在的page被设置了一个sentinel，那么对该page的并发插入操作就不应该缓存到change buffer中，而是直接去尝试读取物理页。

    

      
补丁

    

    

      
问题七

    

    
对于非windows系统的平台上，函数os_file_pwrite和os_file_pread在碰到io错误时返回-1，并错误的作为写入/读取的字节数写在错误日志中。

    

      
解决

    

    
单独记录失败的系统调用日志，打印更可读的日志信息。

    

      
补丁

    

    

      
问题八

    

    
在崩溃恢复后立刻执行一次slow shutdown （innodb_fast_shutdown = 0） 可能产生断言失败crash。原因是当完成crash recovery后，对于需要回滚的事务，会起单独的线程来执行，这时候如果shutdown实例，会触发触发purge线程内部断言失败：ut_a(n_pages_purged == 0 || srv_fast_shutdown != 0);

    

      
解决

    

    
等待trx_rollback_or_clean_all_recovered完成后，再进行slow shutdown

    

      
补丁

    

  

  

    

    

    
Test Book

  

  

    
PostgreSQL 9.4 已于2014年底正式发布了（阿里云的RDS将支持PG 9.4）。在这个版本，我们看到了像Jsonb, Logical Decoding, Replication Slot等新功能。对于Replication Slot，文档上介绍的不多，乍一看让人比较难理解是做什么的。其实，Replication Slot的出现，主要是为最终在PG内核实现逻辑复制和双向复制铺路的（目前，逻辑和双向复制在内核中还缺少很多核心功能点，需要借助BDR插件，见
PG官方wiki
 ，引入Replication Slot的背后原因见
这里
）。不过，作为9.4版本的一个主要功能，它不但可以用于逻辑复制，还可用于物理复制（或者叫Streaming Replication）。针对物理复制的Replication Slot称为Physical Replication Slot。

    
由于大家目前主要用的还只是PG自带的物理复制方式，我们就重点分析一下Physical Replication Slot。

    
使用Physical Replication Slot，可以达到两个效果：

    
A）可以确保从库（standby）需要的日志不被过早备份出去而导致从库失败，出现下面的error：

    

      
ERROR:  requested WAL segment 00000001000000010000002D has already been removed

    

    
通过Replication Slot记录的从库状态，PG会保证从库还没有apply的日志，不会从主库的日志目录里面清除或archive掉。而且，replication slot的状态信息是持久化保存的，即便从库断掉或主库重启，这些信息仍然不会丢掉或失效。

    
B）当允许应用连接从库做只读查询时，Replication Slot可以与运行时参数hot_standby_feedback配合使用，使主库的vacuum操作不会过早的清掉从库查询需要的记录，而出现如下错误（错误的原因下面会详细解释）：

    

      
ERROR:  canceling statement due to conflict with recovery

    

    
下面看看Physical Replication Slot的用法和内核实现。

    

      
用法

    

    
下面是启用Replication Slot的步骤，很简单：

    
1）首先需要配置好Steaming Replication的主库从库。涉及的参数有，listen_addresses（='*'），hot_standby（=on）， wal_level（=hot_standby），max_wal_senders（=1），尤其注意配置max_replication_slots大于等于1。这些参数主从库应一致。

    
2）在主库创建replication slot：

    

      
postgres=# SELECT * FROM pg_create_physical_replication_slot('my_rep_slot_1');
  slot_name   | xlog_position
---------------+---------------
my_rep_slot_1 |

    

    
此时replication slot还不处于active状态。

    
3) 在从库配置recovery.conf如下，然后重启从库：

    

      
standby_mode = 'on'
primary_slot_name = 'my_rep_slot_1'
primary_conninfo = 'user=pg001 host=10.x.x.x port=5432 sslmode=prefer sslcompression=1 krbsrvname=postgres'

    

    
4）观察主库replication slot的状态变化：

    

      
postgres=# SELECT * FROM pg_replication_slots ;
  slot_name   | plugin | slot_type | datoid | database | active | xmin | catalog_xmin | restart_lsn
---------------+--------+-----------+--------+----------+--------+------+--------------+-------------
my_rep_slot_1 |        | physical  |        |          | t      | 1812 |              | 0/3011A70

    

    
5）与hot_standby_feedback配合使用。在将从库的postgresql.conf文件中的hot_standby_feedback选项设为on，重启从库即可。

    

      
内核实现

    

    
replication slot是由下面的
patch
加入内核中的：

    

      
author    Robert Haas <rhaas@postgresql.org>  
Sat, 1 Feb 2014 03:45:17 +0000 (22:45 -0500)
committer    Robert Haas <rhaas@postgresql.org>  
Sat, 1 Feb 2014 03:45:36 +0000 (22:45 -0500)
Replication slots are a crash-safe data structure which can be created
on either a master or a standby to prevent premature removal of
write-ahead log segments needed by a standby, as well as (with
hot_standby_feedback=on) pruning of tuples whose removal would cause
replication conflicts.  Slots have some advantages over existing
techniques, as explained in the documentation.

    

    
这个patch改的文件不少，分析这些代码，我们重点关注下面的问题：

    
A）Replication Slot是如何在内核中创建的？

    
通过分析创建Replication Slot时调用的函数ReplicationSlotCreate，可以看出，
Replication Slot实质上是内存中的一些数据结构，加上持久化保存到pg_replslot/目录中的二进制状态文件。
在PG启动的时候，预先在共享内存中分配好这些数据结构所用内存（即一个大小为max_replication_slots的数组）。这些数据结构在用户创建Replication Slot时开始被使用。一个Replication Slot被创建并使用后，其数据结构和状态文件会被WAL（Write-Ahead-Log）的发送者（wal_sender)进程更新。

    
另外，如果单纯从Replication Slot的名字，我们很容易觉得Replication Slot会创建新的与从库的连接，进行日志发送。实际上，创建过程中并没有创建新的与从库的连接，Replication Slot还是使用了wal_sender原有连接（由于一个从库一个wal_sender连接，所以一个从库和主库之间也只有一个active的Replication Slot）。

    
B) Replication Slot的状态是如何被更新的？

    
很容易发现，Replication Slot的状态的更新有两种情况。

    
第一种是在ProcessStandbyHSFeedbackMessage这个函数被更新。这个函数是在处理wal_sender所收到的从库发回的feedback reply message时调用的。通过这个函数，我们可以看出，每个wal_sender进程的Replication Slot（就是用户创建的Replication Slot）保存在MyReplicationSlot这个全局变量中。在处理从库发回的reply时，reply中的xmin信息会被提取出来，存入slot的data.xmin和effective_xmin域中，并通过函数ProcArraySetReplicationSlotXmin，最终更新到系统全局的procArray->replication_slot_xmin结构中（以使其对所有进程可见），完成slot的更新。

    
这里要注意，如果我们有多个Replication Slot（分别对应各自从库），则在更新全局结构procArray->replication_slot_xmin时，会选取所有slot中最小的xmin值。

    
第二种是在ProcessStandbyReplyMessage中。这个函数处理从库发送的restart lsn信息（即从库apply的日志的编号），会直接将其更新到replication slot的restart lsn域中，并保存到磁盘，用于主库判断是否要保留日志不被archive。

    
C) Replication Slot如何和hot_standby_feedback配合，来避免从库的查询冲突的？

    
这里，从库的查询冲突指的是下面的情况：从库上有正在运行的查询，而且运行时间很长；这时主库上在做正常的vaccum，清除掉无用的记录版本。但主库的vaccum是不知道从库的查询存在的，所以在清除时，不考虑从库的正在运行的查询，只考虑主库里面的事务状态。其结果，vacuum可能会清除掉从库查询中涉及的，仍然在使用的记录版本。当这些vaccum操作，通过日志同步到从库，而恰好从库的查询仍然没有运行完，vaccum就要等待或cancel这个查询，以保证同步正常继续和查询不出现错误的结果。这样，每当用户在从库运行长查询，就容易出现我们上面提到到query conflict error。

    
如何避免这种冲突呢？目前最好的解决方案是使用hot_standby_feedback + Replication Slot。其原理简单说就是，从库将它的查询所依赖的记录版本的信息，以一个事务id来表示，并放在从库发回给主库wal_sender的reply中发给主库（见函数XLogWalRcvSendHSFeedback），并最终传导给主库vaccum，让其刀下留人，暂时不清除相关记录。

    
具体过程是，在从库，函数XLogWalRcvSendHSFeedback调用GetOldestXmin获得xmin，放入给主库的reply中。主库的wal_sender收到后，如果使用了Replication Slot，就把这个xmin放入slot的状态信息中，并更新此时系统所有slot的最小xmin。这个系统所有slot的最小xmin怎么在主库传导给vacuum的呢？以自动触发的vacuum操作为例，其中的逻辑的顺序如下：

    
GetSnapshotData（vacuum事务开始时，获取slot xmin，存入全局变量） ->vacuum_set_xid_limits（调用 GetOldestXmin，通过全局变量，获取系统xmin和slot xmin，取较小值）-> vacuum_lazy （使用xmin，判断哪些记录版本可以清除）

    
这样，利用Replication Slot这个渠道，就解决了从库查询冲突。

    

      
注意事项

    

    
最后，介绍一下使用Replication Slot的注意事项：

    
1）如果收不到从库的reply，Replication Slot的状态restart lsn会保持不变，造成主库会一直保留本地日志，可能导致日志磁盘满。所以应该实时监控日志磁盘使用情况，并设置较小的wal_sender_timeout，及早发现从库断掉的情况。

    
2）将hot_standby_feedback设为on时，注意如果从库长时间有慢查询发生，可能导致发回到主库的xmin变化较慢，主库的vaccum操作停滞，造成主库被频繁更新的表大小暴增。

    
除了物理复制，Replication Slot对逻辑复制的意义更大，我们期待在可能出现逻辑复制功能的9.5版本中看到它大显身手。

  

  

    

    

    
Test Book

  

  

    
PostgreSQL内核中引入了一个很有意思的插件，pg_prewarm。它可以用于在系统重启时，手动加载经常访问的表到操作系统的cache或PG的shared buffer，从而减少检查系统重启对应用的影响。这个插件是这个通过这个
patch
加入PG内核的。 pg_prewarm的开发者在设计pg_prewarm时，把它设计成一个执行单一任务的工具，尽求简单，所以我们看到的pg_prearm功能和实现都非常简单。下面我们对它进行性能实测并分析一下它的实现。

    

      
基本信息

    

    
利用下面的语句可以创建此插件：

    

      
create EXTENSION pg_prewarm;

    

    
实际上，创建插件的过程只是用下面的语句创建了pg_prewarm函数。这个函数是此插件提供的唯一函数：

    

      
CREATE FUNCTION pg_prewarm(regclass,
        mode text default 'buffer',
        fork text default 'main',
        first_block int8 default null,
        last_block int8 default null)
RETURNS int8
AS 'MODULE_PATHNAME', 'pg_prewarm'
LANGUAGE C

    

    
函数的第一个参数是要做prewarm的表名，第二个参数是prewarm的模式（prefetch模式表示异步预取到操作系统cache；read表示同步预取；buffer则表示同步读入到PG的shared buffer），第三个参数是relation fork的类型（一般用main，其他类型有visibilitymap和fsm，参见
[1]

[2]
），最后两个参数是开始和结束的block number（一个表的block number从0开始，block总数可以通过pg_class系统表的relpages字段获得）。

    

      
性能实测

    

    
再来看看，这个prewarm性能上能达到多大效果。我们先将PG的shared buffer设为2G，OS总的memory有7G。然后创建下面的大小近1G的表test：

    

      
pgbench=# \d test
       Table "public.test"
Column |     Type      | Modifiers
--------+---------------+-----------
 name   | character(20) |

    

    

      
pgbench=#  SELECT pg_size_pretty(pg_total_relation_size('test'));
 pg_size_pretty
----------------
 995 MB

    

    
在每次都清掉操作系统cache和PG的shared buffer的情况下，分别测试下面几种场景：

    
1）不进行pg_prewarm的情况：

    

      
pgbench=# explain analyze select count(*) from test;
                                                       QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------
Aggregate  (cost=377389.91..377389.92 rows=1 width=0) (actual time=22270.304..22270.304 rows=1 loops=1)
  ->  Seq Scan on test  (cost=0.00..327389.73 rows=20000073 width=0) (actual time=0.699..18287.199 rows=20000002 loops=1)
Planning time: 0.134 ms
Execution time: 22270.383 ms

    

    
可以看到，近1G的表，全表扫描一遍，耗时22秒多。

    
2）下面我们先做read这种模式的prewarm，test表的数据被同步读入操作系统cache（pg_prewarm返回的是处理的block数目，此处我们没指定block number，也就是读入test的所有block），然后再做全表扫：

    

      
pgbench=# select pg_prewarm('test', 'read', 'main');
pg_prewarm
------------
    127389

    

    

      
pgbench=# explain analyze select count(*) from test;
                                                       QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
Aggregate  (cost=377389.90..377389.91 rows=1 width=0) (actual time=8577.767..8577.767 rows=1 loops=1)
  ->  Seq Scan on test  (cost=0.00..327389.72 rows=20000072 width=0) (actual time=0.086..4716.444 rows=20000002 loops=1)
Planning time: 0.049 ms
Execution time: 8577.831 ms

    

    
时间降至8秒多！这时反复执行全表扫描，时间稳定在8秒多。

    
3）再尝试buffer模式：

    

      
pgbench=# select pg_prewarm('test', 'buffer', 'main');
pg_prewarm
------------
    127389

    

    

      
pgbench=# explain analyze select count(*) from test;
                                                       QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
Aggregate  (cost=377389.90..377389.91 rows=1 width=0) (actual time=8214.277..8214.277 rows=1 loops=1)
  ->  Seq Scan on test  (cost=0.00..327389.72 rows=20000072 width=0) (actual time=0.015..4250.300 rows=20000002 loops=1)
Planning time: 0.049 ms
Execution time: 8214.340 ms

    

    
比read模式时间略少，但相差不大。可见，如果操作系统的cache够大，数据取到OS cache还是shared buffer对执行时间影响不大（在不考虑其他应用影响PG的情况下）。

    
4）最后尝试prefetch模式，即异步预取。这里，我们有意在pg_prewarm返回后，立即执行全表查询。这样在执行全表查询时，可能之前的预取还没完成，从而使全表查询和预取并发进行，缩短了总的响应时间：

    

      
explain analyze select pg_prewarm('test', 'prefetch', 'main');
                                       QUERY PLAN
------------------------------------------------------------------------------------------
Result  (cost=0.00..0.01 rows=1 width=0) (actual time=1011.338..1011.339 rows=1 loops=1)
Planning time: 0.124 ms
Execution time: 1011.402 ms

    

    

      
explain analyze select count(*) from test;
                                                       QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
Aggregate  (cost=377389.90..377389.91 rows=1 width=0) (actual time=8420.652..8420.652 rows=1 loops=1)
  ->  Seq Scan on test  (cost=0.00..327389.72 rows=20000072 width=0) (actual time=0.065..4583.200 rows=20000002 loops=1)
Planning time: 0.344 ms
Execution time: 8420.723 ms

    

    
可以看到，总的完成时间是9秒多，使用pg_prewarm做预取大大缩短了总时间。因此在进行全表扫描前，做一次异步的prewarm，不失为一种优化全表查询的方法。

    

      
实现

    

    
pg_prewarm的代码只有一个pg_prewarm.c文件。可以看出，prefetch模式下，对于表的每个block，调用一次PrefetchBuffer，后面的调用为：

    

      
PrefetchBuffer -> smgrprefetch  -> mdprefetch -> FilePrefetch -> posix_fadvise（POSIX_FADV_WILLNEED）

    

    
可见，它是最终调用posix_fadvise，把读请求交给操作系统，然后返回，实现的异步读取。

    
而在read和buffer模式（调用逻辑分别如下）中，最终都调用了系统调用read，来实现同步读入OS cache和shared buffer的（注意buffer模式实际上是先读入OS cache，再拷贝到shared buffer）：

    

      
read模式：smgrread -> mdread -> FileRead  -> read

    

    

      
buffer模式：ReadBufferExtended -> ReadBuffer_common -> smgrread -> mdread -> FileRead -> read

    

    

      
问题

    

    
可能有人比较疑惑：执行1次select * from 不就可以将表的数据读入shared buffer和OS cache而实现预热了吗？岂不是比做这样一个插件更简单？实际上，对于较大的表（大小超过shared buff的1/4），进行全表扫描时，PG认为没必要为这种操作使用所有shared buffer，只会让其使用很少的一部分buffer，一般只有几百K，详细描述可以参见
关于BAS_BULKREAD策略的代码
和
README
）。所以，预热大表是不能用一个查询直接实现的，而pg_prewarm正是在这方面大大方便了用户。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
在上一期的月报中，我们在
InnoDB自增列重复值问题
 中提到，InnoDB 自增列在重启后会丢失，因为MySQL没有持久化自增值，平时是存在内存表对象中的。如果实例重启的话，内存值丢失，其初始化过程是做了一个类似 select max(id) + 1 操作。实际上存在另外一种场景，实例即使不重启，也会导致自增值丢失。

    

      
问题说明

    

    
实例运行过种中，InnoDB表自增值是存储在表对象中的，表对象又是放在缓存中的，如果表太多而不能全部放在缓存中的话，老的表就会被置换出来，这种被置换出来的表下次再使用的时候，就要重新打开一遍，对自增列来说，这个过程就和实例重启类似，需要 select max(id) + 1 算一下自增值。

    
对InnoDB来说，其数据字典中表对象缓存大小由 
table_definition_cache
 系统变量控制，在5.6.8之后，其最小值是400。和表缓存相关的另一个系统变量是
table_open_cache
，这个控制的是所有线程打开表的缓存大小，这个缓存放在server层。

    
下面我们用testcase的方式来给出InnoDB表对象对置换出的场景：

    

      
 ##把 table_definition_cache 和 table_open_cache 都设为400
 SET GLOBAL table_definition_cache = 400;
 SET GLOBAL table_open_cache = 400;

 ## 创建500个InnoDB自增表，各插入一条数据，然后把自增改为100
 let $i=0;
 while($i < 500)
 {
   --eval CREATE TABLE t$i(id INT NOT NULL AUTO_INCREMENT, name VARCHAR(30), PRIMARY KEY(id)) ENGINE=InnoDB;
   --eval INSERT INTO t$i(name) VALUES("InnoDB");
   --eval ALTER TABLE t$i AUTO_INCREMENT = 100;
   --inc $i
 }

 ## 最后400张表扫一遍
 let $i=100;
 while($i < 500)
 {
   --eval SELECT * FROM t$i;
   --inc $i
 }

 ## 稍微sleep下，等mysqld把不用的表（t0..t99）换出
 sleep 5;

 ## 查看t1表自增
 SHOW CREATE TABLE t1;

 Table   Create Table
 t1      CREATE TABLE `t1` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `name` varchar(30) DEFAULT NULL,
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1
 ...

    

    
可以看到自增值确实和重启场景一样，本应是100，却变成了 2（select max(id) + 1）了。

    

      
问题分析

    

    
原因就是缓存不够，导致表对象被换出，下次再用就要重新打开，这里给出调用栈，对代码感兴趣的同学可以看下。

    
将老的table置换出：

    

      
 #0  dict_table_remove_from_cache_low (table=0x2b81d054e278, lru_evict=1)
     at /path/to/mysql/storage/innobase/dict/dict0dict.cc:1804
 #1  0x00000000011cf246 in dict_make_room_in_cache (max_tables=400, pct_check=100)
     at /path/to/mysql/storage/innobase/dict/dict0dict.cc:1261
 #2  0x0000000001083564 in srv_master_evict_from_table_cache (pct_check=100)
     at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2017
 #3  0x0000000001084022 in srv_master_do_idle_tasks () at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2212
 #4  0x000000000108484a in srv_master_thread (arg=0x0) at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2360
 #5  0x00000030cc007851 in start_thread () from /lib64/libpthread.so.0
 #6  0x00000030cbce767d in clone () from /lib64/libc.so.6

    

    
尝试从缓存加载表对象：

    

      
 #0  dict_table_check_if_in_cache_low (table_name=0x2adef847db20 "test/t1")
     at /path/to/mysql/storage/innobase/include/dict0priv.ic:114
 #1  0x00000000011cd51a in dict_table_open_on_name (table_name=0x2adef847db20 "test/t1", dict_locked=0, try_drop=1,
     ignore_err=DICT_ERR_IGNORE_NONE) at /path/to/mysql/storage/innobase/dict/dict0dict.cc:947
 #2  0x0000000000e58d8a in ha_innobase::open (this=0x2adef9747010, name=0x2adef7460780 "./test/t1", mode=2, test_if_locked=2)
     at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:4776
 #3  0x000000000068668b in handler::ha_open (this=0x2adef9747010, table_arg=0x2adef742bc00, name=0x2adef7460780 "./test/t1", mode=2,
     test_if_locked=2) at /path/to/mysql/sql/handler.cc:2525
 ...
 #9  0x00000000009c2a84 in mysqld_show_create (thd=0x2adef47aa000, table_list=0x2adef74200f0)
     at /path/to/mysql/sql/sql_show.cc:867
 #10 0x00000000009553b1 in mysql_execute_command (thd=0x2adef47aa000) at /path/to/mysql/sql/sql_parse.cc:3507
 #11 0x0000000000963bbe in mysql_parse (thd=0x2adef47aa000, rawbuf=0x2adef7420010 "show create table t1", length=20,
     parser_state=0x2adef8480630) at /path/to/mysql/sql/sql_parse.cc:6623
 ...

    

    
缓存加载不到表对象，用select maxt 逻辑初始化自增：

    

      
 #0  row_search_max_autoinc (index=0x2b241d8f50f8, col_name=0x2b241d855519 "id", value=0x2b241e87d8a8)
     at /path/to/mysql/storage/innobase/row/row0sel.cc:5361
 #1  0x0000000000e58998 in ha_innobase::innobase_initialize_autoinc (this=0x2b241fbd9010)
     at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:4663
 #2  0x0000000000e59bd9 in ha_innobase::open (this=0x2b241fbd9010, name=0x2b241d853780 "./test/t1", mode=2, test_if_locked=2)
     at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:5089
 #3  0x000000000068668b in handler::ha_open (this=0x2b241fbd9010, table_arg=0x2b241e422000, name=0x2b241d853780 "./test/t1", mode=2,
     test_if_locked=2) at /path/to/mysql/sql/handler.cc:2525
 ...
 #9  0x00000000009c2a84 in mysqld_show_create (thd=0x2b241abaa000, table_list=0x2b241d8200f0)
     at /path/to/mysql/sql/sql_show.cc:867
 #10 0x00000000009553b1 in mysql_execute_command (thd=0x2b241abaa000) at /path/to/mysql/sql/sql_parse.cc:3507
 #11 0x0000000000963bbe in mysql_parse (thd=0x2b241abaa000, rawbuf=0x2b241d820010 "show create table t1", length=20,
     parser_state=0x2b241e880630) at /path/to/mysql/sql/sql_parse.cc:6623
 ...

    

    

      
处理建议

    

    
对于这个问题，一种解决方法是从源码改进，将自增值持久化，可以参考
上期的月报
给出的思路；如果不想改代码的话，可以这样绕过：在设定auto_increment值后，主动插入一行记录，这样不论在重启还是缓存淘汰的情况下，重新打开表仍能得到预期的值。

  

  

    

    

    
Test Book

  

  

    

      
问题描述

    

    
5.6.4及以上版本，datetime,time,timestamp的Binlog在5.6.4以下的备库无法执行，如：

    
5.6.16（主库）: create table t1(t datetime default now()); insert into t1 values(now());

    
5.5.18（备库）: show slave stauts\G ;

    
此时备库中断，报错：Last_Errno: 1677，

    
描述信息：Last_Error: Column 1 of table t1.t' cannot be converted from type '' to type 'datetime'

    
详情见
Bug#70085

    

      
问题原因

    

    
1) 5.5版本存储的是datetime,time,timestamp这三种数据类型的长整型的数据，insert时的BT为：

    

      
#0 TIME_to_ulonglong_datetime (my_time=0x2ad2c82e84c0) at /u01/workplace/Percona-Server-5.5.18/sql-common/my_time.c:1187
#1 0x0000000000680b6d in Field_datetime::store (this=0x2ad2d000fb10, from=0x2ad2d0014fe0 "2014-02-25 11:20:42", len=19, cs=<value optimized out>) 
#2 0x00000000005488a4 in fill_record (thd=0xa602190, ptr=<value optimized out>, values=<value optimized out>, ignore_errors=<value optimized out>, triggers=0x0, event) 
#3 fill_record_n_invoke_before_triggers (thd=0xa602190, ptr=<value optimized out>, values=<value optimized out>, ignore_errors=<value optimized out>, triggers=0x0, event)

    

    
2) 5.6.16的相应堆栈为：

    

      
#0 my_datetime_packed_to_binary (nr=1842590951223066624, ptr=0x7fa88005dea1 "\231\222\062\265*", dec=0)
#1 0x00000000009155d4 in Field_datetimef::store_packed (this=0x7fa88005dec0, nr=1842590951223066624)
#2 0x000000000091553a in Field_datetimef::store_internal (this=0x7fa88005dec0, ltime=0x7fa8d42018f0, warnings=0x7fa8d4201920)
#3 0x000000000091191a in Field_temporal_with_date::store_internal_with_round (this=0x7fa88005dec0, ltime=0x7fa8d42018f0,warnings=0x7fa8d4201920) 
#4 0x00000000009109e9 in Field_temporal::store (this=0x7fa88005dec0, str=0x7fa8800052f8 "2014-02-25 11:20:42", len=19, cs=0x168e400)
#5 0x000000000065360b in Item::save_str_value_in_field (this=0x7fa880005310, field=0x7fa88005dec0, result=0x7fa880005320)
#6 0x0000000000663ef6 in Item_string::save_in_field (this=0x7fa880005310, field=0x7fa88005dec0, no_conversions=false)
#7 0x000000000077bbc6 in fill_record (thd=0x6f24020, ptr=0x7fa88005deb8, values=..., ignore_errors=false, bitmap=0x0)
#8 0x000000000077bcf7 in fill_record_n_invoke_before_triggers (thd=0x6f24020, ptr=0x7fa88005deb0, values=..., ignore_errors=false,triggers=0x0, event)

    

    
从面的两个堆栈可以看出，在构造插入数据的时候，调用的是Field的具体函数，根据不同类型调用的方法不同；5.5与5.6之间，datetime的数据类型不一致，当5.5升级到5.6时，其堆栈不变，原因是在表的FRM中，记录了表中列的数据类型，其中5.5中的数据类型为MYSQL_TYPE_DATETIME，5.6的数据类型为MYSQL_TYPE_DATETIME2，所以对于原表升级，不影响复制，但是对于新表中如果含有这三种数据类型的表，复制到备库就会出现问题，因为5.5中，没有MYSQL_TYPE_DATETIME2这种数据类型。

    

      
解决方法

    

    
对表的DML操作或DDL操作，都是依赖于表结构而言的，这也是为什么物理5.5升级到5.6后，对于原本含有datetime,time,timestamp这三种类型的表没有影响，但是对于新建的表就会有影响，原因就是对于产生Binlog的操作或存储引擎的操作的Field来源于FRM文件，所以，当在创建表的时候，如果5.5要使用5.6的Binlog，那我们对于DDL含有这三种数据类型的操作，使用5.5可以识别的数据类型：MYSQL_TYPE_DATETIME，而不是MYSQL_TYPE_DATETIME2，这样在MySQL内部的操作过程中就不会有问题，因此我们可以为MySQL添加一个参数，当参数打开时，创建datetime,time,timestamp的数据类型为兼容5.5的数据类型，否则为新的数据类型。

    

      
TimeStamp 与 Datetime 的区别

    

    
1. 值域不同

    
TIMESTAMP has a range of '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC. DATETIME The supported range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59' TimeStamp带有时区信息，其中TimeStamp在存储时，将当前时间转化为UTC格式的时间，如北京时间，现在是2014-03-15 23:21:00,那么存储的会是2014-03-15 23:21:00 - 3600S；取数据的时候会加上当前时区时间。

    
2. 底层的存储结构不同

    
5.5 是以longlong类型存储的，而5.6 的格式如下：

    
timestamp：4+max(3); (变长，4-7个字节)，没有Sign

    
datetime： 底层存储(变长，5-8个字节)

    

      
1 bit  sign            (used when on disk)
  17 bits year*13+month   (year 0-9999, month 0-12)
   5 bits day             (0-31)
   5 bits hour            (0-23)
   6 bits minute          (0-59)
   6 bits second          (0-59)
  24 bits microseconds    (0-999999)
  Total: 64 bits = 8 bytes

    

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL 5.6.6 版本新加了这样一个参数——log_bin_use_v1_row_events，这个参数用来控制binlog中Rows_log_event的格式，如果这个值为1的话，就用v1版的Rows_log_event格式（即5.6.6之前的），默认是0，用新的v2版本的格式，更详细看
官方文档
。这个参数一般保持默认即可，但是当我们需要搭 5.6->5.5 这要的主备的时候，就需要把主库的这个值改为1，不然5.5的备库不能正确解析Rows_log_event。最近在使用这个参数的时候发现了一个bug，导致主库binlog写坏，备库复制中断，报错如下：

    
Last_SQL_Errno: 1594 Last_SQL_Error: Relay log read failure: Could not parse relay log event entry. The possible reasons are: the master's binary log is corrupted (you can check this by running 'mysqlbinlog' on the binary log), the slave's relay log is corrupted (you can check this by running 'mysqlbinlog' on the relay log), a network problem, or a bug in the master's or slave's MySQL code. If you want to check the master's binary log or slave's relay log, you will be able to know their names by issuing 'SHOW SLAVE STATUS' on this slave.

    

      
bug 分析

    

    
binlog event 结构

    

      
event header
event body
  -fixed part(postheader)
  -variable part (payload)

    

    
如上所示，每种binlog event 都可以分为header 和 body 2部分，body 又可以分为 fixed part 和 variable part，其中event header的长度相同并且固定，5.0开始用的v4格式的binlog，其event header固定长度为19字节，包含多个字段，具体每个字段的含义可以看
这里
。 event body 中post header 长度也是固定的，所以叫 fixed part，但是不同类型event这一部分的长度不一样，最后的 variable part 就是event的主体了，这个就长度不一了。 log_bin_use_v1_row_events 这个值的不同，影响的部分就是 postheader 这里的长度，如果值为1的话，用v1格式，postheader 长度是8个字节，如果是0，用v2格式，其长度为10。每个Rows_log_event的event header的type字节会标明当前event是v1还是v2，试想一下，如果event header部分标明是v2，postheader却实际上只有8个字节，或者反过来，event header部分标明是v1，postheader有10个字节，备库拿到这样的binlog，去尝试解析的时候，就完全凌乱了。

    
为啥会出现这种一个event前后不一致的情况呢，代码编写不严谨！

    
在写 Rows_log_event(Write/Update/Delete) 过程中，有2次用到 log_bin_use_v1_row_events 这个全局变量，一次是在构造函数处，一次是在写postheader时 Rows_log_event::write_data_header()，2次都是直接使用，如果正好在这2次中间，我们执行 set global log_bin_use_v1_row_events = 0|1，改变原来的值，就会导致前后逻辑判断结果不一致。如果主库有频繁的更新操作，每次更新又比较大，只要修改这个值，就很容易触发这个bug。

    
另外官方还有点不严谨的是，
文档上
说这个值是 readonly的，实际代码是dynamic 的，如果是 readonly 的话，也就不会触发上面的bug了。

    

      
bug修复

    

    
修复很简单，把2次引用全局变量改成一次就好了，在Rows_log_event::write_data_header函数里直接使用已经保存的m_type，改法如下

    

      
-  if (likely(!log_bin_use_v1_row_events))
+
+
+  if (likely(!(m_type == WRITE_ROWS_EVENT_V1 ||
+               m_type == UPDATE_ROWS_EVENT_V1 ||
+               m_type == DELETE_ROWS_EVENT_V1 )))

    

    
这样改之后，就只会在构造函数中才用到全局变量。

  

  

    

    

    
Test Book

  

  

    
Google向MariaDB 10.1.13（暂未Release）贡献了这个补丁，可以对表/表空间进行加密。

    
加密过的表可以防止某些非授权用户访问或偷取磁盘然后通过访问原始数据文件来偷取数据。当然，假设你已经把密钥文件存储在另一个系统上。但是，使用加密可能会降低差不多10%的性能。目前，只有XtraDB/InnoDB引擎能完全支持加密。

    
MariaDB在InnoDB/XtraDB中支持两种方式的加密:

    
Table encryption（表级加密）: 只有在创建时指定 PAGE_ENCRYPTION=1 的表才被加密。

    
Tablespace encryption（表空间加密）: 当前实例下的任何文件都被加密（包括日志文件）。

    
MariaDB中所有的加密算法都是基于AES的。但是你可以在启动的时候使用 --encryption-algorithm=name 来指定具体哪种基于AES的加密算法，有这些可选:

    
| 选项 | 描述 | 

| none | 默认值。不进行任何加密。 | 

| aes_cbc | 建议值。这是大部分欧洲政府接受的算法。 | 

| aes_ctr | 一种新的块加密模式，Google自己开发的，并且在他们的MariaDB实例中使用的算法。 | 

| aes_ecb | 这种加密模式用于内部计数器计算。你可以用它来加密，但它不能提供强保密性。 |

    

      
密钥的管理

    

    
为了保护加密过的数据，密钥必须另外保存，不要跟数据文件放在一个地方。默认情况下，MariaDB支持两种密钥管理方式，都是以Plugin的方式实现的。

    
1） file_key_management_plugin

    
file_key_management_plugin 是一个密钥管理插件，可以从文件中读取密钥。这个插件有如下配置选项：

    
file_key_management_plugin_filename=path-to-key-file: 密钥文件存放的位置

    
file_key_management_plugin_filekey: 一个可选的Key，用来解密密钥文件

    
一个my.cnf配置的例子:

    

      
[mysqld]
encryption-algorithm = aes_cbc
file_key_management_plugin_filename = /home/mdb/keys.enc
file_key_management_plugin_filekey = secret

    

    
这个密钥文件（/home/mdb/keys.enc）包含了AES密钥。128, 192 或 256位密钥都可以支持。ID有16个字节。 一个密钥文件内容的例子如下：

    

      
1;F5502320F8429037B8DAEF761B189D12;770A8A65DA156D24EE2A093277530142

    

    
1是密钥的标识，在建表的时候可以指定使用哪个密钥; 接着是16字节的ID，最后是一个16字节的AES密钥。密钥标识可以从0~255，但是0号密钥是保留给InnoDB日志文件使用的，不要在建表的时候用。

    
密钥文件本身同样可以加密，file_key_management_plugin_filekey定义的密钥可以用来解密密钥文件。OpenSSL命令行工具可以用来创建密钥文件。例如：

    

      
openssl enc –aes-256-cbc –md sha1 –k secret –in keys.txt –out keys.enc
openssl enc –aes-256-cbc –md sha1 –k <initialPwd> –in secret –out secret.enc

    

    
如果密钥文件在启动的时候读取不到（例如没提供解密密钥文件的Key），那么加密功能不再被支持，也无法访问被加密过的表。

    
2） example_key_management_plugin

    
为了获得真正高强度的加密，密钥必须周期性的变更。

    
example_key_management_plugin 是一个实现的例子。用你自己的密钥管理系统替换这个插件，可以创建一个非常安全的系统，例如从远程服务器来获取密钥。Google内部就是这么做的。

    
当然，example_key_management_plugin 仅仅是一个例子，你要根据它来编写你自己的Plugin！

    

      
加密数据

    

    
1）表级加密

    
表级加密意味着你可以选择哪些表需要加密。这可以让你在速度和安全性之间获得平衡。

    
要使用表级加密，你要这样做:

    

      
设置 encryption-algorithm 选择你需要的加密算法；

      
载入 file-key-management-plugin 插件或者其他相似的插件，添加 enable-file-key-management-plugin 到你的my.cnf文件。

    

    
要加密一个表，你需要在CREATE/ALTER TABLE 语句中使用新的参数：

    
| 选项 | 可选值 | 描述 | 

| PAGE_ENCRYPTION | 0 或 1 | 1是启用这个功能，0是关闭 | 

| PAGE_ENCRYPTION_KEY | 0-255 | 密钥表示。这个值表示用那个密钥。 |

    
例如：

    

      
CREATE TABLE T (id int, value varchar(255)) PAGE_ENCRYPTION=1 PAGE_ENCRYPTION_KEY=17;

    

    
这个建表语句会创建一个表T，使用标识为17的密钥加密。

    

      
ALTER TABLE T PAGE_ENCRYPTION=1 PAGE_ENCRYPTION_KEY=18;

    

    
更改表T使用标识为18的密钥来加密。如果你之前加密过这张表，那会首先解密这张表再重新加密。

    

      
ALTER TABLE T page_encryption=0;

    

    
关闭表T的加密功能。如果之前是加密的，那这个操作会做解密。

    
2） 表空间加密

    
要使用加密表空间，需要这样做:

    

      
设置 encryption-algorithm 来选择加密算法；

      
设置 innodb-encrypt-tables 为 1；

      
载入 file-key-management-plugin 插件或者其他相似的插件，添加 enable-file-key-management-plugin 到你的 my.cnf 文件；

      
启用 innodb-tablespaces-encryption 插件；

      
启用 innodb-tablespaces-scrubbing 插件。

    

    
有下列变量可以配置加密项：

    
| 变量 | 可选值 | 描述 | 

| innodb-encrypt-tables | Boolean (0 or 1) | 是否在存储引擎加密所有表 | 

| innodb-encryption-rotate-key-age | 秒数 | 如果获取到了新密钥多久更新一次页面加密 | 

| innodb-encryption-rotation-iop | IOPS数 | 后台使用多少IOPS来做页面加密更新 | 

| innodb-encryption-threads | 线程数 | 用多少个后台线程来做页面加密更新和清理 | 

| innodb-background-scrub-data-check-interval | 秒数 | 隔多久检查空间是否需要清理 | 

| innodb-background-scrub-data-compressed | Boolean (0 or 1) | 打开通过后台线程来清理压缩数据 | 

| innodb-background-scrub-data-interval | 秒数 | 隔多久调用一次清理 | 

| innodb-background-scrub-data-uncompressed | Boolean (0 or 1) | 打开通过后台线程来清理未压缩数据 |

    
清理（Scrubbing）意味着有一个后台线程定期的扫描所有的表并且对所有页面升级压缩密钥。

    
配置表空间加密的示例 my.cnf:

    

      
[mysqld]
encryption-algorithm=aes_ctr
innodb-tablespaces-encryption
innodb-tablespaces-scrubbing
innodb-encrypt-tables
innodb-encryption-threads=4

    

    

      
加密和压缩

    

    
加密和压缩（配合FusionIO使用的功能，
之前的月报介绍过
）可以同时使用。这可以让MariaDB先压缩数据然后再做加密，这种情况下可以很大的节省存储空间，并且数据更难被解密。

  

  

    

    

    
Test Book

  

  

    
自MariaDB 10.1.2起，MariaDB提供了一种"Per-query variables的方式来为Query设置语句级变量，通过 SET STATEMENT 语句可以为接下来要执行的语句设置一些系统变量值。

    

      
语法

    

    
SET STATEMENT var1=value1 [, var2=value2, ...] FOR

    
varN是一个系统变量，valueN是一个常量值。但是有部分变量是不支持的，在这个章节的末尾列出了所有不支持的变量。

    
一条 "SET STATEMENT var1=value1 FOR stmt" 语句等价与如下一系列操作：

    
SET @save_value=@@var1;

    
SET SESSION var1=value1;

    
stmt;

    
SET SESSION var1=@save_value;

    
MySQL服务器在执行整条语句前会先做解析，所以所有影响解析器的变量都无法达到预期的效果，因为解析完之后才能获得这些变量的值。例如字符集变量sql_mode=ansi_quotes。

    

      
一些使用特性的例子

    

    
可以限制语句的执行时间 max_statement_time: SET STATEMENT max_statement_time=1000 FOR SELECT ... ;

    
为一个语句临时改变优化器的规则: SET STATEMENT optimizer_switch='materialization=off' FOR SELECT ....;

    
为一个语句单独打开MRR/BKA特性: SET STATEMENT join_cache_level=6, optimizer_switch='mrr=on' FOR SELECT ...

    

      
下面这些变量无法使用Per-query variables特性来设置

    

    
autocommit

    
character_set_client

    
character_set_connection

    
character_set_filesystem

    
collation_connection

    
default_master_connection

    
debug_sync

    
interactive_timeout

    
gtid_domain_id

    
last_insert_id

    
log_slow_filter

    
log_slow_rate_limit

    
log_slow_verbosity

    
long_query_time

    
min_examined_row_limit

    
profiling

    
profiling_history_size

    
query_cache_type

    
rand_seed1

    
rand_seed2

    
skip_replication

    
slow_query_log

    
sql_log_off

    
tx_isolation

    
wait_timeout

  

  

    

    

    
Test Book

  

  

    
TokuDB的日志跟InnoDB不一样，它有两类文件:

    

      
redo-log文件(以.tokulog[序号]为扩展名)

      
rollback日志文件(tokudb.rollback)

    

    
接下来就简单唠唠这两类文件的内部细节。

    

      
1) redo-log

    

    
记录的不是页而是对Fractal-Tree索引的操作日志。 log格式:

    

      
| length | command | lsn | content | crc|

    

    
content里记录的是具体的日志内容，比如insert操作，content就是:

    

      
| file-no | txnid | key | value|

    

    
TokuDB在做恢复的时候，会找到上次checkpoint时的LSN位置，然后读取log逐条恢复。

    
为了确保log的安全性，redo-log也支持从后往前解析。

    
当一个log的MAX_LSN小于已完成checkpoint的LSN时，就表明这个log文件可以安全删除了。

    
那么问题来了：

    
如果用户执行了一个“大事务”，比如delete一个大表，耗时很长，log文件岂不是非常多，一直等到事务提交再做清理？

    
不用的，这就是tokudb.rollback的作用了。

    

      
2) tokudb.rollback

    

    
用户的事务操作(insert/delete/update写操作)都会写一条日志到tokudb.rollback，存储的格式是:

    

      
|txnid | key|

    

    
记录日志伪码如下：

    

      
void ft_insert(txn,...)
{
   if (txn) {
       toku_logger_save_rollback_cmdinsert(...);
   }

   if (do_logging && logger) {
       toku_log_enq_insert(....);
   }
}

    

    
如果是事务，每个操作会写2条日志(1条redo，1条rollback)。

    
如果用户执行了commit/rollback，TokuDB会根据txnid在tokudb.rollback里查到key(如果该entry不在cache里)，再根据key在索引文件里找到相应的事务信息并做相应的commit/rollback操作。

    
tokudb.rollback可以看做是一个事务的undo日志，记录的是的关系映射。

  

  

    

    

    
Test Book

  

  

    

      

        

          
MySQL · 性能优化· Group Commit优化

        

      

      

        

          
MySQL · 新增特性· DDL fast fail

        

      

      

        

          
MySQL · 性能优化· 启用GTID场景的性能问题及优化

        

      

      

        

          
MySQL · 捉虫动态· InnoDB自增列重复值问题

        

      

      

        

          
MySQL · 优化改进· 复制性能改进过程

        

      

      

        

          
MySQL · 谈古论今· key分区算法演变分析

        

      

      

        

          
MySQL · 捉虫动态· mysql client crash一例

        

      

      

        

          
MySQL · 捉虫动态· 设置 gtid_purged 破坏AUTO_POSITION复制协议

        

      

      

        

          
MySQL · 捉虫动态· replicate filter 和 GTID 一起使用的问题

        

      

      

        

          
TokuDB·特性分析· Optimize Table

        

      

    

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
关于Group Commit网上的资料其实已经足够多了，我这里只简单的介绍一下。

    
众所周知，在MySQL5.6之前的版本，由于引入了Binlog/InnoDB的XA，Binlog的写入和InnoDB commit完全串行化执行，大概的执行序列如下：

    

      
 InnoDB prepare  （持有prepare_commit_mutex）；
 write/sync Binlog；
 InnoDB commit (写入COMMIT标记后释放prepare_commit_mutex)。

    

    
当sync_binlog=1时，很明显上述的第二步会成为瓶颈，而且还是持有全局大锁，这也是为什么性能会急剧下降。

    
很快Mariadb就提出了一个Binlog Group Commit方案，即在准备写入Binlog时，维持一个队列，最早进入队列的是leader，后来的是follower，leader为搜集到的队列中的线程依次写Binlog文件, 并commit事务。Percona 的Group Commit实现也是Port自Mariadb。不过仍在使用Percona Server5.5的朋友需要注意，该Group Commit实现可能破坏掉Semisync的行为，感兴趣的点击 
bug#1254571

    
Oracle MySQL 在5.6版本开始也支持Binlog Group Commit，使用了和Mariadb类似的思路，但将Group Commit的过程拆分成了三个阶段：flush stage 将各个线程的binlog从cache写到文件中; sync stage 对binlog做fsync操作（如果需要的话）；commit stage 为各个线程做引擎层的事务commit。每个stage同时只有一个线程在操作。

    
Tips：当引入Group Commit后，sync_binlog的含义就变了，假定设为1000，表示的不是1000个事务后做一次fsync，而是1000个事务组。

    
Oracle MySQL的实现的优势在于三个阶段可以并发执行，从而提升效率。更进一步的理解，可以参考
这篇博客

    

      
XA Recover

    

    
在Binlog打开的情况下，MySQL默认使用MYSQL_BIN_LOG来做XA协调者，大致流程为：

    

      
1.扫描最后一个Binlog文件，提取其中的xid；
2.InnoDB维持了状态为Prepare的事务链表，将这些事务的xid和Binlog中记录的xid做比较，如果在Binlog中存在，则提交，否则回滚事务。

    

    
通过这种方式，可以让InnoDB和Binlog中的事务状态保持一致。显然只要事务在InnoDB层完成了Prepare，并且写入了Binlog，就可以从崩溃中恢复事务，这意味着我们无需在InnoDB commit时显式的write/fsync redo log。

    
Tips：MySQL为何只需要扫描最后一个Binlog文件呢 ？ 原因是每次在rotate到新的Binlog文件时，总是保证没有正在提交的事务，然后fsync一次InnoDB的redo log。这样就可以保证老的Binlog文件中的事务在InnoDB总是提交的。

    

      
问题

    

    
其实问题很简单：每个事务都要保证其Prepare的事务被write/fsync到redo log文件。尽管某个事务可能会帮助其他事务完成redo 写入，但这种行为是随机的，并且依然会产生明显的log_sys->mutex开销。

    

      
优化

    

    
从XA恢复的逻辑我们可以知道，只要保证InnoDB Prepare的redo日志在写Binlog前完成write/sync即可。因此我们对Group Commit的第一个stage的逻辑做了些许修改，大概描述如下：

    

      
 Step1\. InnoDB Prepare，记录当前的LSN到thd中；
 Step2\. 进入Group Commit的flush stage；Leader搜集队列，同时算出队列中最大的LSN。
 Step3\. 将InnoDB的redo log write/fsync到指定的LSN
 Step4\. 写Binlog并进行随后的工作(sync Binlog, InnoDB commit , etc)

    

    
通过延迟写redo log的方式，显式的为redo log做了一次组写入，并减少了log_sys->mutex的竞争。

    
目前官方MySQL已经根据我们report的bug#73202锁提供的思路，对5.7.6的代码进行了优化，对应的Release Note如下：

    

      
  When using InnoDB with binary logging enabled, concurrent transactions written in the InnoDB redo log are now grouped together before synchronizing 
  to disk when innodb_flush_log_at_trx_commit is set to 1, which reduces the amount of synchronization operations. This can lead to improved performance.

    

    

      
性能数据

    

    
简单测试了下，使用sysbench, update_non_index.lua, 100张表，每张10w行记录，innodb_flush_log_at_trx_commit=2, sync_binlog=1000，关闭Gtid

    

      
 并发线程        原生                  修改后
 32             25600                27000
 64             30000                35000
 128            33000                39000
 256            29800                38000

    

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
项目的快速迭代开发和在线业务需要保持持续可用的要求，导致MySQL的ddl变成了DBA很头疼的事情，而且经常导致故障发生。本篇介绍RDS分支上做的一个功能改进，DDL fast fail。主要解决：DDL操作因为无法获取MDL排它锁，进入等待队列的时候，阻塞了应用所有的读写请求问题。

    

      
MDL锁机制介绍

    

    
首先介绍一下MDL(METADATA LOCK)锁机制，MySQL为了保证表结构的完整性和一致性，对表的所有访问都需要获得相应级别的MDL锁，比如以下场景：

    

      
 session 1: start transaction; select * from test.t1;
 session 2: alter table test.t1 add extra int;
 session 3: select * from test.t1;

    

    
session 1对t1表做查询，首先需要获取t1表的MDL_SHARED_READ级别MDL锁。锁一直持续到commit结束，然后释放。

    
session 2对t1表做DDL，需要获取t1表的MDL_EXCLUSIVE级别MDL锁，因为MDL_SHARED_READ与MDL_EXCLUSIVE不相容，所以session 2被session 1阻塞，然后进入等待队列。

    
session 3对t1表做查询，因为等待队列中有MDL_EXCLUSIVE级别MDL锁请求，所以session3也被阻塞，进入等待队列。

    
这种场景就是目前因为MDL锁导致的很经典的阻塞问题，如果session1长时间未提交，或者查询持续过长时间，那么后续对t1表的所有读写操作，都被阻塞。 对于在线的业务来说，很容易导致业务中断。

    

      
aliyun RDS分支改进

    

    
DDL fast fail并没有解决真正DDL过程中的阻塞问题，但避免了因为DDL操作没有获取锁，进而导致业务其他查询/更新语句阻塞的问题。

    
其实现方式如下:

    
alter table test.t1 no_wait/wait 1 add extra int;

    
在ddl语句中，增加了no_wait/wait 1语法支持。

    
其处理逻辑如下:

    
首先尝试获取t1表的MDL_EXCLUSIVE级别的MDL锁:

    
当语句指定的是no_wait，如果获取失败，客户端将得到报错信息：ERROR : Lock wait timeout exceeded; try restarting transaction。

    
当语句指定的是wait 1，如果获取失败，最多等待1s，然后得到报错信息：ERROR : Lock wait timeout exceeded; try restarting transaction。

    
另外，除了alter语句以外，还支持rename，truncate，drop，optimize，create index等ddl操作。

    

      
与Oracle的比较

    

    
在Oracle 10g的时候，DDL操作经常会遇到这样的错误信息：

    
ora-00054:resource busy and acquire with nowait specified

    
即DDL操作无法获取表上面的排它锁，而fast fail。

    
其实DDL获取排他锁的设计，需要考虑的就是两个问题：

    
1. 雪崩

    
如果你采用排队阻塞的机制，那么DDL如果长时间无法获取锁，就会导致应用的雪崩效应，对于高并发的业务，也是灾难。

    
2. 饿死

    
如果你采用强制式的机制，那么要防止DDL一直无法获取锁的情况，在业务高峰期，可能DDL永远无法成功。

    
在Oracle 11g的时候，引入了DDL_LOCK_TIMEOUT参数，如果你设置了这个参数，那么DDL操作将使用排队阻塞模式，可以在session和global级别设置， 给了用户更多选择。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL从5.6版本开始支持GTID特性，也就是所谓全局事务ID，在整个复制拓扑结构内，每个事务拥有自己全局唯一标识。GTID包含两个部分，一部分是实例的UUID，另一部分是实例内递增的整数。

    
GTID的分配包含两种方式，一种是自动分配，另外一种是显式设置session.gtid_next，下面简单介绍下这两种方式：

    

      
自动分配

    

    
如果没有设置session级别的变量gtid_next，所有事务都走自动分配逻辑。分配GTID发生在GROUP COMMIT的第一个阶段，也就是flush stage，大概可以描述为：

    

      
 Step 1：事务过程中，碰到第一条DML语句需要记录Binlog时，分配一段Gtid事件的cache，但不分配实际的GTID
 Step 2：事务完成后，进入commit阶段，分配一个GTID并写入Step1预留的Gtid事件中，该GTID必须保证不在gtid_owned集合和gtid_executed集合中。 分配的GTID随后被加入到gtid_owned集合中。
 Step 3：将Binlog 从线程cache中刷到Binlog文件中。
 Step 4：将GTID加入到gtid_executed集合中。
 Step 5：在完成sync stage 和commit stage后，各个会话将其使用的GTID从gtid_owned中移除。

    

    

      
显式设置

    

    
用户通过设置session级别变量gtid_next可以显式指定一个GTID，流程如下：

    

      
 Step 1：设置变量gtid_next，指定的GTID被加入到gtid_owned集合中。
 Step 2：执行任意事务SQL，在将binlog从线程cache刷到binlog文件后，将GTID加入到gtid_executed集合中。
 Step 3：在完成事务COMMIT后，从gtid_owned中移除。

    

    
备库SQL线程使用的就是第二种方式，因为备库在apply主库的日志时，要保证GTID是一致的，SQL线程读取到GTID事件后，就根据其中记录的GTID来设置其gtid_next变量。

    

      
问题

    

    
由于在实例内，GTID需要保证唯一性，因此不管是操作gtid_executed集合和gtid_owned集合，还是分配GTID，都需要加上一个大锁。我们的优化主要集中在第一种GTID分配方式。

    
对于GTID的分配，由于处于Group Commit的第一个阶段，由该阶段的leader线程为其follower线程分配GTID及刷Binlog，因此不会产生竞争。

    
而在Step 5，各个线程在完成事务提交后，各自去从gtid_owned集合中删除其使用的gtid。这时候每个线程都需要获取互斥锁，很显然，并发越高，这种竞争就越明显，我们很容易从pt-pmp输出中看到如下类似的trace：

    

      
 ha_commit_trans—>MYSQL_BIN_LOG::commit—>MYSQL_BIN_LOG::ordered_commit—>MYSQL_BIN_LOG::finish_commit—>Gtid_state::update_owned_gtids_impl—>lock_sidno

    

    
这同时也会影响到GTID的分配阶段，导致TPS在高并发场景下的急剧下降。

    

      
解决

    

    
实际上对于自动分配GTID的场景，并没有必要维护gtid_owned集合。我们的修改也非常简单，在自动分配一个GTID后，直接加入到gtid_executed集合中，避免维护gtid_owned，这样事务提交时就无需去清理gtid_owned集合了，从而可以完全避免锁竞争。

    
当然为了保证一致性，如果分配GTID后，写入Binlog文件失败，也需要从gtid_executed集合中删除。不过这种场景非常罕见。

    

      
性能数据

    

    
使用sysbench，100张表，每张10w行记录，update_non_index.lua，纯内存操作，innodb_flush_log_at_trx_commit = 2，sync_binlog = 1000

    

      
 并发线程       原生               修改后
 32           24500              25000
 64           27900              29000
 128          30800              31500
 256          29700              32000
 512          29300              31700
 1024         27000              31000

    

    
从测试结果可以看到，优化前随着并发上升，性能出现下降，而优化后则能保持TPS稳定。

  

  

    

    

    
Test Book

  

  

    

      
问题重现

    

    
先从问题入手，重现下这个
bug

    

      
use test;
drop table if exists t1;
create table t1(id int auto_increment, a int, primary key (id)) engine=innodb;
insert into t1 values (1,2);
insert into t1 values (null,2);
insert into t1 values (null,2);
select * from t1;
+----+------+
| id | a |
+----+------+
| 1 | 2 |
| 2 | 2 |
| 3 | 2 |
+----+------+
delete from t1 where id=2;
delete from t1 where id=3;
select * from t1;
+----+------+
| id | a |
+----+------+
| 1 | 2 |
+----+------+

    

    
这里我们关闭mysql，再启动mysql,然后再插入一条数据

    

      
insert into t1 values (null,2);
select * FROM T1;
+----+------+
| id | a |
+----+------+
| 1 | 2 |
+----+------+
| 2 | 2 |
+----+------+

    

    
我们看到插入了（2,2），而如果我没有重启，插入同样数据我们得到的应该是（4,2)。 上面的测试反映了mysqld重启后，InnoDB存储引擎的表自增id可能出现重复利用的情况。

    
自增id重复利用在某些场景下会出现问题。依然用上面的例子，假设t1有个历史表t1_history用来存t1表的历史数据，那么mysqld重启前,ti_history中可能已经有了（2,2）这条数据，而重启后我们又插入了（2，2），当新插入的(2,2)迁移到历史表时，会违反主键约束。

    

      
原因分析

    

    
InnoDB 自增列出现重复值的原因

    

      
mysql> show create table t1\G;
*************************** 1\. row ***************************
Table: t1
Create Table: CREATE TABLE `t1` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`a` int(11) DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=innodb AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

    

    
建表时可以指定 AUTO_INCREMENT值，不指定时默认为1，这个值表示当前自增列的起始值大小，如果新插入的数据没有指定自增列的值，那么自增列的值即为这个起始值。对于InnoDB表，这个值没有持久到文件中。而是存在内存中（dict_table_struct.autoinc）。那么又问，既然这个值没有持久下来，为什么我们每次插入新的值后， show create table t1看到AUTO_INCREMENT值是跟随变化的。其实show create table t1是直接从dict_table_struct.autoinc取得的（ha_innobase::update_create_info）。

    
知道了AUTO_INCREMENT是实时存储内存中的。那么，mysqld 重启后，从哪里得到AUTO_INCREMENT呢? 内存值肯定是丢失了。实际上mysql采用执行类似select max(id)+1 from t1;方法来得到AUTO_INCREMENT。而这种方法就是造成自增id重复的原因。

    

      
MyISAM自增值

    

    
MyISAM也有这个问题吗？MyISAM是没有这个问题的。myisam会将这个值实时存储在.MYI文件中（mi_state_info_write）。mysqld重起后会从.MYI中读取AUTO_INCREMENT值（mi_state_info_read)。因此，MyISAM表重启是不会出现自增id重复的问题。

    

      
问题修复

    

    
MyISAM选择将AUTO_INCREMENT实时存储在.MYI文件头部中。实际上.MYI头部还会实时存其他信息，也就是说写AUTO_INCREMENT只是个顺带的操作，其性能损耗可以忽略。InnoDB 表如果要解决这个问题，有两种方法。1）将AUTO_INCREMENT最大值持久到frm文件中。2）将 AUTO_INCREMENT最大值持久到聚集索引根页trx_id所在的位置。第一种方法直接写文件性能消耗较大，这是一额外的操作，而不是一个顺带的操作。我们采用第二种方案。为什么选择存储在聚集索引根页页头trx_id，页头中存储trx_id,只对二级索引页和insert buf 页头有效（MVCC)。而聚集索引根页页头trx_id这个值是没有使用的，始终保持初始值0。正好这个位置8个字节可存放自增值的值。我们每次更新AUTO_INCREMENT值时，同时将这个值修改到聚集索引根页页头trx_id的位置。 这个写操作跟真正的数据写操作一样，遵守write-ahead log原则，只不过这里只需要redo log ,而不需要undo log。因为我们不需要回滚AUTO_INCREMENT的变化（即回滚后自增列值会保留，即使insert 回滚了，AUTO_INCREMENT值不会回滚）。

    
因此，AUTO_INCREMENT值存储在聚集索引根页trx_id所在的位置，实际上是对内存根页的修改和多了一条redo log（量很小）,而这个redo log 的写入也是异步的，可以说是原有事务log的一个顺带操作。因此AUTO_INCREMENT值存储在聚集索引根页这个性能损耗是极小的。

    
修复后的性能对比，我们新增了全局参数innodb_autoinc_persistent 取值on/off； on 表示将AUTO_INCREMENT值实时存储在聚集索引根页。off则采用原有方式只存储在内存。

    

      
./bin/sysbench --test=sysbench/tests/db/insert.lua --mysql-port=4001 --mysql-user=root \--mysql-table-engine=innodb --mysql-db=sbtest --oltp-table-size=0 --oltp-tables-count=1 \--num-threads=100 --mysql-socket=/u01/zy/sysbench/build5/run/mysql.sock  --max-time=7200 --max-requests run
set global innodb_autoinc_persistent=off;
tps: 22199 rt:2.25ms
set global innodb_autoinc_persistent=on;
tps: 22003 rt:2.27ms

    

    
可以看出性能损耗在%1以下。

    

      
改进

    

    
新增参数innodb_autoinc_persistent_interval 用于控制持久化AUTO_INCREMENT值的频率。例如：innodb_autoinc_persistent_interval=100，auto_incrememt_increment=1时，即每100次insert会控制持久化一次AUTO_INCREMENT值。每次持久的值为：当前值+innodb_autoinc_persistent_interval。

    
测试结论

    

      
 innodb_autoinc_persistent=ON, innodb_autoinc_persistent_interval=1时性能损耗在%1以下。
 innodb_autoinc_persistent=ON, innodb_autoinc_persistent_interval=100时性能损耗可以忽略。

    

    

      
限制

    

    
1 innodb_autoinc_persistent=on， innodb_autoinc_persistent_interval=N>1时，自增N次后持久化到聚集索引根页,每次持久的值为当前AUTO_INCREMENT+(N-1)*innodb_autoextend_increment。重启后读取持久化的AUTO_INCREMENT值会偏大，造成一些浪费但不会重复。innodb_autoinc_persistent_interval=1 每次都持久化没有这个问题。

    
2 如果innodb_autoinc_persistent=on，频繁设置auto_increment_increment的可能会导致持久化到聚集索引根页的值不准确。因为innodb_autoinc_persistent_interval计算没有考虑auto_increment_increment变化的情况，参看dict_table_autoinc_update_if_greater。而设置auto_increment_increment的情况极少，可以忽略。

    
注意：如果我们使用需要开启innodb_autoinc_persistent，应该在参数文件中指定

    

      
innodb_autoinc_persistent= on

    

    
如果这样指定set global innodb_autoinc_persistent=on;重启后将不会从聚集索引根页读取AUTO_INCREMENT最大值。

    
疑问：对于InnoDB表，重启通过select max(id)+1 from t1得到AUTO_INCREMENT值，如果id上有索引那么这个语句使用索引查找就很快。那么，这个可以解释mysql 为什么要求自增列必须包含在索引中的原因。 如果没有指定索引，则报如下错误，

    
ERROR 1075 (42000): Incorrect table definition; there can be only one auto column and it must be defined as a key 而myisam表竟然也有这个要求，感觉是多余的。

  

  

    

    

    
Test Book

  

  

    

      
前言

    

    
与oracle 不同，mysql 的主库与备库的同步是通过 binlog 实现的，而redo日志只做为mysql 实例的crash recovery使用。mysql在4.x 的时候放弃redo 的同步策略而引入 binlog的同步，一个重要原因是为了兼容其它非事务存储引擎，否则主备同步是没有办法进行的。

    
redo 日志同步属于物理同步方法，简单直接，将修改的物理部分传送到备库执行，主备共用一致的 LSN，只要保证 LSN 相同即可，同一时刻，只能主库或备库一方接受写请求； binlog的同步方法属于逻辑复制，分为statement 或 row 模式，其中statement记录的是SQL语句，Row 模式记录的是修改之前的记录与修改之后的记录，即前镜像与后镜像；备库通过binlog dump 协议拉取binlog,然后在备库执行。如果拉取的binlog是SQL语句，备库会走和主库相同的逻辑，如果是row 格式，则会调用存储引擎来执行相应的修改。

    
本文简单说明5.5到5.7的主备复制性能改进过程。

    
replication improvement (from 5.5 to 5.7)

    

      
(1) 5.5 中，binlog的同步是由两个线程执行的

    

    
io_thread: 根据binlog dump协议从主库拉取binlog, 并将binlog转存到本地的relaylog；

    
sql_thread: 读取relaylog，根据位点的先后顺序执行binlog event，进而将主库的修改同步到备库，达到主备一致的效果； 由于在主库的更新是由多个客户端执行的，所以当压力达到一定的程度时，备库单线程执行主库的binlog跟不上主库执行的速度，进而会产生延迟造成备库不可用，这也是分库的原因之一，其SQL线程的执行堆栈如下：

    

      
sql_thread:
exec_relay_log_event
    apply_event_and_update_pos
         apply_event
             rows_log_event::apply_event
                 storage_engine operation
         update_pos

    

    
(2) 
5.6 中，引入了多线程模式，在多线程模式下，其线程结构如下

    
io_thread: 同5.5

    
Coordinator_thread: 负责读取 relay log，将读取的binlog event以事务为单位分发到各个 worker thread 进行执行，并在必要时执行binlog event（Description_format_log_event， Rotate_log_event 等）。

    
worker_thread: 执行分配到的binlog event，各个线程之间互不影响；

    

      
多线程原理

    

    
sql_thread 的分发原理是依据当前事务所操作的数据库名称来进行分发，如果事务是跨数据库行为的，则需要等待已分配的该数据库的事务全部执行完毕，才会继续分发，其分配行为的伪码可以简单的描述如下：

    

      
get_slave_worker
  if (contains_partition_info(log_event))
     db_name= get_db_name(log_event);
     entry {db_name, worker_thread, usage} = map_db_to_worker(db_name);
     while (entry->usage > 0)
        wait();
    return worker;
  else if (last_assigned_worker)
    return last_assigned_worker;
  else
    push into buffer_array and deliver them until come across a event that have partition info

    

    

      
需要注意的细节

    

    

      

        

          
内存的分配与释放。relay thread 每读取一个log_event, 则需要 malloc 一定的内存，在work线程执行完后，则需要free掉；

          
数据库名 与 worker 线程的绑定信息在一个hash表中进行维护，hash表以entry为单位，entry中记录当前entry所代表的数据库名，有多少个事务相关的已被分发，执行这些事务的worker thread等信息；

          
维护一个绑定信息的array , 在分发事务的时候，更新绑定信息，增加相应 entry->usage, 在执行完一个事务的时候，则需要减少相应的entry->usage；

          
slave worker 信息的维护，即每个 worker thread执行了哪些事务，执行到的位点是在哪，延迟是如何计算的，如果执行出错，mts_recovery_group 又是如何恢复的；

          
分配线程是以数据库名进行分发的，当一个实例中只有一个数据库的时候，不会对性能有提高，相反，由于增加额外的操作，性能还会有一点回退；

          
临时表的处理，临时表是和entry绑定在一起的，在执行的时候将entry的临时表挂在执行线程thd下面，但没有固化，如果在临时表操作期间，备库crash，则重启后备库会有错误；

        

      

    

    

      
总体上说，5.6 的并行复制打破了5.5 单线程的复制的行为，只是在单库下用处不大，并且5.6的并行复制的改动引入了一些重量级的bug

    

    

      

        

          
mysql slave sql thread memory leak (

http://bugs.mysql.com/bug.php?id=71197
)

          
Relay log without xid_log_event may case parallel replication hang (

http://bugs.mysql.com/bug.php?id=72794
)

          
Transaction lost when relay_log_info_repository=FILE and crashed (

http://bugs.mysql.com/bug.php?id=73482
)

        

      

    

    
(3) 5.7中，并行复制的实现添加了另外一种并行的方式，即主库在 ordered_commit中的第二阶段的时候，将同一批commit的 binlog 打上一个相同的seqno标签，同一时间戳的事务在备库是可以同时执行的，因此大大简化了并行复制的逻辑，并打破了相同 DB 不能并行执行的限制。备库在执行时，具有同一seqno的事务在备库可以并行的执行，互不干扰，也不需要绑定信息，后一批seqno的事务需要等待前一批相同seqno的事务执行完后才可以执行。

    
详细实现可参考：

http://bazaar.launchpad.net/~mysql/mysql-server/5.7/revision/6256
 。

    
reference：

http://geek.rohitkalhans.com/2013/09/enhancedMTS-deepdive.html

  

  

    

    

    
Test Book

  

  

    
本文说明一个物理升级导致的 "数据丢失"。

    

      
现象

    

    
在mysql 5.1下新建key分表，可以正确查询数据。

    

      
drop table t1;

create table t1 (c1 int , c2 int) 
PARTITION BY KEY (c2) partitions 5; 
insert into t1  values(1,1785089517),(2,null); 
mysql> select * from t1 where c2=1785089517;
+------+------------+
| c1   | c2         |
+------+------------+
|    1 | 1785089517 |
+------+------------+
1 row in set (0.00 sec)
mysql> select * from t1 where c2 is null;
+------+------+
| c1   | c2   |
+------+------+
|    2 | NULL |
+------+------+
1 row in set (0.00 sec)

    

    
而直接用mysql5.5或mysql5.6启动上面的5.1实例，发现(1,1785089517)这行数据不能正确查询出来。

    

      
alter table t1 PARTITION BY KEY ALGORITHM = 1 (c2)  partitions 5;
mysql> select * from t1 where c2 is null;
+------+------+
| c1   | c2   |
+------+------+
|    2 | NULL |
+------+------+
1 row in set (0.00 sec)
mysql> select * from t1 where c2=1785089517;
Empty set (0.00 sec)

    

    

      
原因分析

    

    
跟踪代码发现，5.1 与5.5,5.6 key hash算法是有区别的。

    
5.1 对于非空值的处理算法如下

    

      
void my_hash_sort_bin(const CHARSET_INFO *cs __attribute__((unused)),
                     const uchar *key, size_t len,ulong *nr1, ulong *nr2)
{
  const uchar *pos = key; 

  key+= len;

  for (; pos < (uchar*) key ; pos++)
  {
    nr1[0]^=(ulong) ((((uint) nr1[0] & 63)+nr2[0]) * 
             ((uint)*pos)) + (nr1[0] << 8);
    nr2[0]+=3;
  }
}

    

    
通过此算法算出数据(1,1785089517)在第3个分区

    
5.5和5.6非空值的处理算法如下

    

      
void my_hash_sort_simple(const CHARSET_INFO *cs,
                         const uchar *key, size_t len,
                         ulong *nr1, ulong *nr2)
{
  register uchar *sort_order=cs->sort_order;
  const uchar *end;

  /* 
    Remove end space. We have to do this to be able to compare
    'A ' and 'A' as identical
  */        
  end= skip_trailing_space(key, len);

  for (; key < (uchar*) end ; key++)
  {
    nr1[0]^=(ulong) ((((uint) nr1[0] & 63)+nr2[0]) * 
            ((uint) sort_order[(uint) *key])) + (nr1[0] << 8);
    nr2[0]+=3;
  }
}

    

    
通过此算法算出数据(1,1785089517)在第5个分区，因此，5.5,5.6查询不能查询出此行数据。

    
5.1,5.5,5.6对于空值的算法还是一致的,如下

    

      
if (field->is_null())
{
  nr1^= (nr1 << 1) | 1;
  continue;
}

    

    
都能正确算出数据(2, null)在第3个分区。因此，空值可以正确查询出来。

    
那么是什么导致非空值的hash算法走了不同路径呢？在5.1下，计算字段key hash固定字符集就是my_charset_bin，对应的hash 函数就是前面的my_hash_sort_simple。而在5.5，5.6下，计算字段key hash的字符集是随字段变化的，字段c2类型为int对应my_charset_numeric，与之对应的hash函数为my_hash_sort_simple。具体可以参考函数Field::hash

    
那么问题又来了，5.5后为什么算法会变化呢？原因在于官方关于字符集策略的调整，详见
WL#2649
 。

    

      
兼容处理

    

    
前面讲到，由于hash 算法变化，用5.5，5.6启动5.1的实例，导致不能正确查询数据。那么5.1升级5.5,5.6就必须兼容这个问题.mysql 5.5.31以后，提供了专门的语法 ALTER TABLE ... PARTITION BY ALGORITHM=1 [LINEAR] KEY ...  用于兼容此问题。对于上面的例子，用5.5或5.6启动5.1的实例后执行

    

      
mysql> alter table t1 PARTITION BY KEY ALGORITHM = 1 (c2) partitions 5;
Query OK, 2 rows affected (0.02 sec)
Records: 2  Duplicates: 0  Warnings: 0

    

    

      
mysql> select * from t1 where c2=1785089517;
+------+------------+
| c1   | c2         |
+------+------------+
|    1 | 1785089517 |
+------+------------+
1 row in set (0.00 sec)

    

    
数据可以正确查询出来了。

    
而实际上5.5,5.6的mysql_upgrade升级程序已经提供了兼容方法。mysql_upgrade 执行check table xxx for upgrade 会检查key分区表是否用了老的算法。如果使用了老的算法，会返回

    

      
mysql> CHECK TABLE t1  FOR UPGRADE\G
*************************** 1\. row ***************************
   Table: test.t1
      Op: check
Msg_type: error
Msg_text: KEY () partitioning changed, please run:
ALTER TABLE `test`.`t1` PARTITION BY KEY /*!50611 ALGORITHM = 1 */ (c2)
PARTITIONS 5
*************************** 2\. row ***************************
   Table: test.t1
      Op: check
Msg_type: status
Msg_text: Operation failed
2 rows in set (0.00 sec)

    

    
检查到错误信息后会自动执行以下语句进行兼容。

    

      
ALTER TABLE `test`.`t1` PARTITION BY KEY /*!50611 ALGORITHM = 1 */ (c2) PARTITIONS 5。

    

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
客户使用mysqldump导出一张表，然后使用mysql -e 'source test.dmp'的过程中client进程crash，爆出内存的segment fault错误，导致无法导入数据。

    

      
问题定位

    

    
test.dmp文件大概50G左右，查看了一下文件的前几行内容，发现：

    

      
 A partial dump from a server that has GTIDs will by default include the GTIDs of all transactions, even those that changed suppressed parts of the database If you don't want to restore GTIDs pass set-gtid-purged=OFF. To make a complete dump, pass...
 -- MySQL dump 10.13  Distrib 5.6.16, for Linux (x86_64)
 --
 -- Host: 127.0.0.1    Database: carpath
 -- ------------------------------------------------------
 -- Server version       5.6.16-log
 /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
 /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

    

    
问题定位到第一行出现了不正常warning的信息，是由于客户使用mysqldump命令的时候，重定向了stderr。即:

    
mysqldump ...>/test.dmp 2>&1

    
导致error或者warning信息都重定向到了test.dmp, 最终导致失败。

    

      
问题引申

    

    
问题虽然定位到了，但却有几个问题没有弄清楚：

    
问题1. 不正常的sql，执行失败，报错出来就可以了，为什么会导致crash？

    
mysql.cc::add_line函数中，在读第一行的时候，读取到了don't,发现有一个单引号，所以程序死命的去找匹配的另外一个单引号，导致不断的读取文件，分配内存，直到crash。

    
假设没有这个单引号，mysql读到第六行，发现;号，就会执行sql，并正常的报错退出。

    
问题2. 那代码中对于大小的边界到底是多少？比如insert语句支持batch insert时，语句的长度多少，又比如遇到clob字段呢？

    
1. 首先clob字段的长度限制

    
clob家族类型的column长度受限于max_allowed_packet的大小，MySQL 5.5中，对于max_allowd_packet的大小限制在(1024, 1024
1024
1024)之间。

    
2. mysqldump导出insert语句的时候，如何分割insert语句？

    
mysqldump时候支持insert t1 value(),(),();这样的batch insert语句。

    
mysqldump其实是根据opt_net_buffer_length来进行分割，当一个insert语句超过这个大小，就强制分割到下一个insert语句中，这样更多的是在做网络层的优化。

    
又如果遇到大的clob字段怎么办？ 如果一行就超过了opt_net_buffer_length，那就强制每一行都分割。

    
3. mysql client端读取dump文件的时候, 到底能分配多大的内存？

    
mysql.cc中定义了:

    

      
#define MAX_BATCH_BUFFER_SIZE (1024L * 1024L * 1024L)

    

    
也就是mysql在执行语句的时候，最多只能分配1G大小的缓存。

    
所以，正常情况下，max_allowed_packet现在的最大字段长度和MAX_BATCH_BUFFER_SIZE限制的最大insert语句，是匹配的。

    

      
RDS问题修复原则

    

    
从问题的定位上来看，这一例crash属于客户错误使用mysqldump导致的问题，Aliyun RDS分支对内存导致的crash问题，都会定位并反馈给用户。 但此例不做修复，而是引导用户正确的使用mysqldump工具。

  

  

    

    

    
Test Book

  

  

    

      
bug描述

    

    
Oracle 最新发布的版本 5.6.22 中有这样一个关于GTID的bugfix，在主备场景下，如果我们在主库上 SET GLOBAL GTID_PURGED = "some_gtid_set"，并且 some_gtid_set 中包含了备库还没复制的事务，这个时候如果备库接上主库的话，预期结果是主库返回错误，IO线程挂掉的，但是实际上，在这种场景下主库并不报错，只是默默的把自己 binlog 中包含的gtid事务发给备库。这个bug的造成的结果是看起来复制正常，没有错误，但实际上备库已经丢事务了，主备很可能就不一致了。

    

      
背景知识

    

    
一） binlog GTID事件

    
binlog 中记录的和GTID相关的事件主要有2种，Previous_gtids_log_event 和 Gtid_log_event，前者表示之前的binlog中包含的gtid的集合，后者就是一个gtid，对应一个事务。一个 binlog 文件中只有一个 Previous_gtids_log_event，放在开头，有多个 Gtid_log_event，如下面所示

    

      
Previous_gtids_log_event   // 此 binlog 之前的所有binlog文件包含的gtid集合

Gtid_log_event // 单个gtid event
Transaction
Gtid_log_event
Transaction
.
.
.
Gtid_log_event
Transaction

    

    
二） 备库发送GTID集合给主库

    
我们知道备库的复制线程是分IO线程和SQL线程2种的，IO线程通过GTID协议或者文件位置协议拉取主库的binlog，然后记录在自己的relay log中；SQL线程通过执行realy log中的事件，把其中的操作都自己做一遍，记入本地binlog。在GTID协议下，备库向主库发送拉取请求的时候，会告知主库自己已经有的所有的GTID的集合，Retrieved_Gtid_Set + Executed_Gtid_Set，前者对应 realy log 中所有的gtid集合，表示已经拉取过的，后者对应binlog中记录有的，表示已经执行过的；主库在收到这2个总集合后，会扫描自己的binlog，找到合适的binlog然后开始发送。

    
三）主库如何找到要发送给备库的第一个binlog

    
主库将备库发送过来的总合集记为 slave_gtid_executed，然后调用 find_first_log_not_in_gtid_set(slave_gtid_executed)，这个函数的目的是从最新到最老扫描binlog文件，找到第一个含有不存在 slave_gtid_executed 这个集合的gtid的binlog。在这个扫描过程中并不需要从头到尾读binlog中所有的gtid，只需要读出 Previous_gtids_log_event ，如果Previous_gtids_log_event 不是 slave_gtid_executed的子集，就继续向前找binlog，直到找到为止。

    
这个查找过程总会停止的，停止条件如下：

    

      
找到了这样的binlog，其Previous_gtids_log_event 是slave_gtid_executed子集

      
在往前读binlog的时候，发现没有binlog文件了（如被purge了），但是还没找到满足条件的Previous_gtids_log_event，这个时候主库报错

      
一直往前找，发现Previous_gtids_log_event 是空集

    

    
在条件2下，报错信息是这样的

    
Got fatal error 1236 from master when reading data from binary log: 'The slave is connecting using CHANGE MASTER TO MASTER_AUTO_POSITION = 1, but the master has purged binary logs containing GTIDs that the slave requires.

    
其实上面的条件3是条件1的特殊情况，这个bugfix针对的场景就是条件3这种，但并不是所有的符合条件3的场景都会触发这个bug，下面就分析下什么情况下才会触发bug。

    

      
bug 分析

    

    
假设有这样的场景，我们要用已经有MySQL实例的备份重新做一对主备实例，不管是用 xtrabackup 这种物理备份工具或者mysqldump这种逻辑备份工具，都会有2步操作，

    

      
导入数据

      
SET GLOBAL GTID_PURGED ="xxxx"

    

    
步骤2是为了保证GTID的完备性，因为新实例已经导入了数据，就需要把生成这些数据的事务对应的GTID集合也设置进来。

    
正常的操作是主备都要做这2步的，如果我们只在主库上做了这2步，备库什么也不做，然后就直接用 GTID 协议把备库连上来，按照我们的预期这个时候是应该出错的，主备不一致，并且主库的binlog中没东西，应该报之前停止条件2报的错。但是令人大跌眼镜的是主库不报错，复制看起来是完全正常的。

    
为啥会这样呢，SET GLOBAL GTID_PURGED 操作会调用 mysql_bin_log.rotate_and_purge切换到一个新的binlog，并把这个GTID_PURGED 集合记入新生成的binlog的Previous_gtids_log_event，假设原有的binlog为A，新生成的为B，主库刚启动，所以A就是主库的第一个binlog，它之前啥也没有，A的Previous_gtids_log_event就是空集，并且A中也不包含任何GTID事件，否则SET GLOBAL GTID_PURGED是做不了的。按照之前的扫描逻辑，扫到A是肯定会停下来的，并且不报错。

    

      
bug 修复

    

    
官方的修复就是在主库扫描查找binlog之前，判断一下 gtid_purged 集合不是不比slave_gtid_executed大，如果是就报错，错误信息和条件2一样 Got fatal error 1236 from master when reading data from binary log: 'The slave is connecting using CHANGE MASTER TO MASTER_AUTO_POSITION = 1, but the master has purged binary logs containing GTIDs that the slave requires.

    
详细的bugfix请看revno: 
6211

  

  

    

    

    
Test Book

  

  

    

      
问题描述

    

    
当单个 MySQL 实例的数据增长到很多的时候，就会考虑通过库或者表级别的拆分，把当前实例的数据分散到多个实例上去，假设原实例为A，想把其中的5个库（db1/db2/db3/db4/db5）拆分到5个实例（B1/B2/B3/B4/B5）上去。

    
拆分过程一般会这样做，先把A的相应库的数据导出，然后导入到对应的B实例上，但是在这个导出导入过程中，A库的数据还是在持续更新的，所以还需在导入完后，在所有的B实例和A实例间建立复制关系，拉取缺失的数据，在业务不繁忙的时候将业务切换到各个B实例。

    
在复制搭建时，每个B实例只需要复制A实例上的一个库，所以只需要重放对应库的binlog即可，这个通过 replicate-do-db 来设置过滤条件。如果我们用备库上执行 show slave status\G 会看到Executed_Gtid_Set是断断续续的，间断非常多，导致这一列很长很长，看到的直接效果就是被刷屏了。

    
为啥会这样呢，因为设了replicate-do-db，就只会执行对应db对应的event，其它db的都不执行。主库的执行是不分db的，对各个db的操作互相间隔，记录在binlog中，所以备库做了过滤后，就出现这种断断的现象。

    
除了这个看着不舒服外，还会导致其它问题么？

    
假设我们拿B1实例的备份做了一个新实例，然后接到A上，如果主库A又定期purge了老的binlog，那么新实例的IO线程就会出错，因为需要的binlog在主库上找不到了；即使主库没有purge 老的binlog，新实例还要把主库的binlog都从头重新拉过来，然后执行的时候又都过滤掉，不如不拉取。

    
有没有好的办法解决这个问题呢？SQL线程在执行的时候，发现是该被过滤掉的event，在不执行的同时，记一个空事务就好了，把原事务对应的GTID位置占住，记入binlog，这样备库的Executed_Gtid_Set就是连续的了。

    

      
bug 修复

    

    
对这个问题，官方有一个相应的bugfix，参见 revno: 
5860
 ，有了这个patch后，备库B1的 SQL 线程在遇到和 db2-db5 相关的SQL语句时，在binlog中把对应的GTID记下，同时对应记一个空事务。

    
这个 patch 只是针对Query_log_event，即 statement 格式的 binlog event，那么row格式的呢？ row格式原来就已经是这种行为，通过check_table_map 函数来过滤库或者表，然后生成一个空事务。

    
另外这个patch还专门处理了下 CREATE/DROP TEMPORARY TABLE 这2种语句，我们知道row格式下，对临时表的操作是不会记入binlog的。如果主库的binlog格式是 statement，备库用的是 row，CREATE/DROP TEMPORARY TABLE 对应的事务传到备库后，就会消失掉，Executed_Gtid_Set集合看起来是不连续的，但是主库的binlog记的gtid是连续的，这个 patch 让这种情况下的CREATE/DROP TEMPORARY TABLE在备库同样记为一个空事务。

  

  

    

    

    
Test Book

  

  

    
来自一个TokuDB用户的“投诉”:

    

      

      
https://mariadb.atlassian.net/browse/MDEV-6207

    

    
现象大概是:

    
用户有一个MyISAM的表test_table:

    

      
 CREATE TABLE IF NOT EXISTS `test_table` (
   `id` int(10) unsigned NOT NULL,
   `pub_key` varchar(80) NOT NULL,
   PRIMARY KEY (`id`),
   KEY `pub_key` (`pub_key`)
 ) ENGINE=MyISAM DEFAULT CHARSET=latin1;

    

    
转成TokuDB引擎后表大小为92M左右:

    

      
 47M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
 45M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

    

    
执行"OPTIMIZE TABLE test_table":

    

      
 63M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
 61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

    

    
再次执行"OPTIMIZE TABLE test_table":

    

      
 79M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
 61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

    

    
继续执行:

    

      
 79M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
 61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

    

    
基本稳定在这个大小。

    
主索引从47M-->63M-->79M，执行"OPTIMIZE TABLE"后为什么会越来越大？

    
这得从TokuDB的索引文件分配方式说起，当内存中的脏页需要写到磁盘时，TokuDB优先在文件末尾分配空间并写入，而不是“覆写”原块，原来的块暂时成了“碎片”。

    
这样问题就来了，索引文件岂不是越来越大？No, TokuDB会把这些“碎片”在checkpoint时加入到回收列表，以供后面的写操作使用，看似79M的文件其实还可以装不少数据呢！

    
嗯，这个现象解释通了，但还有2个问题:

    
1) 在执行这个语句的时候，TokuDB到底在做什么呢？

    
在做toku_ft_flush_some_child，把内节点的缓冲区(message buffer)数据刷到最底层的叶节点。

    
2) 在TokuDB里，OPTIMIZE TABLE有用吗？

    
作用非常小，不建议使用，TokuDB是一个"No Fragmentation"的引擎。

    
官方WIKI: 
Optimize Table

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    

      
背景知识

    

    
为了便于理解下文，我们先简单梳理下Innodb中的事务、视图、多版本的相关背景知识。

    
在Innodb中，每次开启一个事务时，都会为该session分配一个事务对象。而为了对全局所有的事务进行控制和协调，有一个全局对象trx_sys，对trx_sys相关成员的操作需要trx_sys->mutex锁。

    
Innodb使用一种称做ReadView(视图)的对象来判断事务的可见性（也就是ACID中的隔离性）。根据可见性原则，某个新开启的事务不应该看到其他未提交的事务。 Innodb在执行一个SELECT或者显式开启START TRANSACTION WITH CONSISTENT SNAPSHOT (后者只应用于REPEATABLE-READ隔离级别) 会创建一个视图对象。对于RR隔离级别，视图的生命周期到事务提交结束，对于RC隔离级别，则每条查询开始时重分配事务。

    
通常一个视图中包含创建视图的事务ID，以及在创建视图时活跃的事务ID数组。例如，当开启一个视图时，当前事务的事务ID为5， 事务链表上活跃事务ID为{2,5,6,9,12}，那么就会把{2,6,9,12}存储到当前的视图中（5是当前事务的ID，不记录到视图中），{2,6,9,12}对应的事务所做的修改对当前事务而言都是不可见的，小于2的事务ID对当前事务都是可见的，大于12的事务ID对当前事务是不可见的。

    
那么如何判断可见性呢？ 对于聚集索引，每次修改记录时，都会在记录中保存当前的事务ID，同时旧版本记录存储在UNDO中；对于二级索引，则在二级索引页中存储了更新当前页的最大事务ID，如果该事务ID大于readview->up_limit_id（对于上例，up_limit_id值为2），那么就需要回聚集索引判断记录可见性；如果小于2， 那么总是可见的，可以直接读取。

    
Innodb的多版本数据使用UNDO来维护的，例如聚集索引记录(1) =>(2)=>(3)，从1更新成2，再更新成3，就会产生两条undo记录。当然这不是本文讨论的重点。后续在单独针对临时表的优化时会谈及undo相关的知识。

    

      
Innodb事务系统优化

    

    
在MySQL 5.7版本里，针对性的对事务系统做了比较深入的优化，主要解决了下面几个问题。

    
问题一：视图对象的创建需要trx_sys->mutex锁保护

    
trx_sys->mutex是事务系统最核心的全局锁对象，持有该锁进行的操作都不应该耗时过长。对于read view对象，完全可以将其缓存下来重复使用。这样就避免了持有锁分配视图内存。

    
因此在MySQL 5.7版本中，实例启动时就分配1024个视图对象；同时维护两个链表，一个是已使用的视图链表，一个是空闲的视图链表；当需要分配新的视图时，总是从空闲视图链表中分配，如果没有，再新分配一个。

    
在Percona Server中也做了类似的优化，但与5.7不同的是，其不集中管理所有的视图，而是每个事务对象(trx_t)上都挂载一个预分配的视图对象，在事务对象销毁时释放(事务对象本身对session而言也是重用的)。

    
问题二：视图对象中保存全局事务ID时，需要扫描事务链表

    
正如上面描述的，为了判断事务视图的可见性，在打开一个视图时需要拷贝当时活跃的事务ID。在5.5及之前版本需要遍历所有的活跃事务，而在5.6中，将事务链表拆分成了只读事务链表，和读写事务链表，这样我们只需要遍历读写事务链表，拷贝事务ID即可。

    
在5.7中，事务系统维持了一个全局事务ID数组，每个活跃读写事务的ID都被加入到其中，在事务提交时从其中删除，这样打开视图时只需要使用memcpy 拷贝该数组即可，无需遍历链表。在读写链表较长(高并发下)的场景，该优化可以显著的提升性能。不过就该优化点而言，Percona Serve同样走在了前面，相同的思路实现在Percona Server 5.6中。

    
问题三: 用户需要显式开启只读事务，才会放入只读事务链表

    
尽量在5.6中已经将事务链表拆分成了只读事务链表和读写事务链表（AUTOCOMMIT的SELECT不加入任何链表），但用户需要显式的指定事务以只读模式打开（START TRANSACTION READ ONLY）或者设置SESSION变量tx_read_only。

    
显然这种方式对用户而言是极不友好的，因此在5.7中做了比较彻底的改变，将只读事务链表从其中彻底移除了，取而代之的是，所有事务都以只读模式打开。

    
例如如下事务序列：

    
BEGIN;

    
SELECT; //事务开始，不分配事务ID，不分配回滚段；

    
UPDATE; //分配事务ID并插入全局事务数组和事务对象集合中，分配回滚段；

    
COMMIT;

    
而对于BEGIN;SELECT;SELECT;COMMIT这样的序列，整个事务周期既不分配事务ID，也不分配回滚段。

    
那么问题来了，既然只读的事务不分配事务ID，那么如何标示事务呢，在5.7中，使用事务对象的地址来进行计算得到一个唯一的事务ID。执行’SHOW ENGINE INNODB STATUS’不再显示活跃的只读事务，只能通过INNODB_TRX表来查询。这是一个需要注意的点，因为很多人都是通过前者来找到长时间未提交的事务。

    
另外一个比较有意思的小优化是，对于AUTOCOMMIT的只读查询，关闭视图时，并不是立刻从视图链表中移除，而是设置一个简单的close标记；该session下次需要打开该read view时，如果这期间没有任何读写事务，就可以直接重用上次的read view，清楚close标记，这样打开、关闭视图都无需获取trx_sys->mutex。

    
问题四：隐式锁转换为显式锁的开销

    
Innodb对于类似INSERT操作，采用的是隐式锁的方式，隐式锁不是锁，只是一种称呼而已，只有在需要的时候，才会转换为显式锁。例如如下：

    
Session 1: BEING; INSERT INTO t1(pk, val) VALUES (1,2); //不创建锁对象

    
Session 2: UPDATE t1 SET val=val+1 WHERE pk=1; //创建两个锁对象，一个是为session1创建一个记录锁对象，另外一个是给自己创建一个等待类型的记录锁对象，然后session2加入锁等待队列。

    
在Session 2中为Session1创建锁对象的过程即是所谓的隐式锁向显式锁转换。 当session2扫描到session 1插入的记录时，发现session 1的事务依然活跃，就会进入转换逻辑。

    
在5.6版本中，其转换过程如下：

    
1.持有lock_sys->mutex

    
2. 持有trx_sys->mutex；

    
根据事务ID，扫描读写事务链表，找到对应的事务对象；

    
释放trx_sys->mutex；

    
3.创建显式锁对象

    
4.释放lock_sys->mutex

    
可以看到，在该操作的过程中，全程持有lock_sys->mutex，持有锁的原因是防止事务提交掉。当读写事务链表非常长时（例如高并发写入时），这种开销将是不可接受的。

    
在5.7版本中，上述逻辑则优化成:

    
1. 持有trx_sys->mutex

    
根据事务ID找到对应的事务对象（直接查找trx_sys->rw_trx_set，其保存了trx_id和事务对象的映射关系，因此无需扫描读写事务链表）

    
增加事务对象引用计数（++trx->n_ref）

    
释放trx_sys->mutex

    
2. 持有lock_sys->mutex；

    
创建显式锁对象；

    
释放lock_sys->mutex；

    
3.递减事务对象引用计数

    
在事务commit，释放记录锁前，会先判断引用记录数是否为0，如果不为0，表示正有其他事务为其转换显式锁，这时候需要等待，直到计数为0，才能进入释放事务记录锁阶段。

    
总的来说，该优化减少了隐式锁转换时持有LOCK_sys->mutex的时间，从而提升性能。

    
除了上述提到的几点事务优化外，在5.7版本中还对事务系统部分的代码做了重构，完全用C++重写；引入了一个POOL结构，事务对象和锁对象都可以缓存复用。大家可以阅读几个相关的worklog，以更好的理解上述优化：

    

      

      
http://dev.mysql.com/worklog/task/?id=6047

    

    

      

      
http://dev.mysql.com/worklog/task/?id=6578

    

    

      

      
http://dev.mysql.com/worklog/task/?id=6899

    

    

      

      
http://dev.mysql.com/worklog/task/?id=6906

    

  

  

    

    

    
Test Book

  

  

    

      
混用引擎的问题

    

    
在MySQL中，存储引擎是通过插件方式使用的，事务是由存储引擎自己实现，MySQL服务层是不管理事务的，所以在同一个事务中混用不同的存储引擎是不可靠的。 如果混用事务引擎和非事务引擎的话，事务如果正常提交的话，5.5不会有问题，但是5.6版本如果开了 GTID 的话就会报错，因为GTID模式下不允许事务中同时更新事务引擎和非事务引擎（
Restrictions on Replication with GTIDs
）； 如果事务回滚的话，不管是 5.5 还是 5.6 都会有问题的，因为对非事务引擎表的操作是无法回滚的，这样就会造成数据不一致，因为只有部分操作成功，并且结果不可预知，事务的原子性和一致性被破坏。

    
我们下面举例子来说明，t1_i 是事务引擎表（InnoDB），ti_m 是非事务引擎（MyISAM）。

    
在事务执行前2张表里的数据如下：

    

      
mysql> SELECT * FROM t1_i;
+------+------+
| id   | name |
+------+------+
|    1 | test |
|    2 | test |
+------+------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM t1_m;
+------+------+
| id   | name |
+------+------+
|    1 | test |
|    2 | test |
+------+------+
2 rows in set (0.00 sec)

    

    
事务如下，对2张表分别插一条数据，然后 rollback 模拟出错回滚，

    

      
BEGIN;
INSERT INTO t1_m VALUES (3, "test");
INSERT INTO t1_i VALUES (3, "test");
ROLLBACK;

    

    
执行回滚后，我们会看到 MySQL 返回信息中有 warnings; 

Query OK, 0 rows affected, 1 warning

    
查看 warning，可以清楚地看到提示，非事务引擎无法回滚：

    

      
SHOW WARNINGS;
+---------+------+---------------------------------------------------------------+
| Level   | Code | Message                                                       |
+---------+------+---------------------------------------------------------------+
| Warning | 1196 | Some non-transactional changed tables couldn't be rolled back |
+---------+------+---------------------------------------------------------------+

    

    
我们来看下现在2张表中的数据，可以看到 t1_m 的插入确实没有回滚，这与事务逻辑的预期是不一样的。

    

      
mysql> SELECT * FROM t1_m;
+------+------+
| id   | name |
+------+------+
|    1 | test |
|    2 | test |
|    3 | test |
+------+------+

mysql> SELECT * FROM t1_I;
+------+------+
| id   | name |
+------+------+
|    1 | test |
|    2 | test |
+------+------+

    

    
当我们在非事务引擎上执行事务相关的操作的时候，MySQL 一般是不会报错的，比如在非事务引擎的操作前后用 BEGIN 和 COMMIT, 这是完全可以的，并且让我们误以为操作是有事务性的，我们在使用的时候要注意这一点。

    
总的来说，要遵循这样的一条原则，不要在事务中混用不同的存储引擎。

    

      
5.5 到 5.6 升级问题

    

    
5.5 升级到 5.6 的时候，我们会先建立一个5.6版本的实例，然后把数据从5.5迁移到5.6，最后把连接切到 5.6 完成升级。有时候升级会失败，这是因为5.6 GTID 的一些限制导致的。

    
其中有一条是关于临时表的限制，官方描述如下：

    

      
Temporary tables. CREATE TEMPORARY TABLE and DROP TEMPORARY TABLE statements are not supported inside transactions when using GTIDs (that is, when the server was started with the --enforce-gtid-consistency option). It is possible to use these statements with GTIDs enabled, but only outside of any transaction, and only with autocommit=1.

    

    
限制表明不能在事务中创建临时表，可以在事务外创建，但要求 autocommit = 1。

    
我们新建5.6的实例的时候，会重用 5.5 的配置，autocommit 就是其中之一，并且这个是允许用户配置的，如果用户在5.5实例上把这个值改为0，然后升级到5.6，就会出错。我们知道，创建新实例的时候，会先通过 mysql_install_db 脚本初始化数据库，这包括系统表的创建、基本数据的添加等 ，其中会用到 mysql_system_tables_data.sql 这个sql脚本，里面有：

    

      
CREATE TEMPORARY TABLE tmp_db LIKE db;  

CREATE TEMPORARY TABLE tmp_user LIKE user;  

CREATE TEMPORARY TABLE tmp_proxies_priv LIKE proxies_priv; 

    

    
这样的语句，脚本执行失败，所以mysql.db 、mysql.user 和 mysql.proxies_priv表里的初始数据就没有添加进去。

    
error log 中会看到这样的信息

    

      
2014-12-08 20:48:15 9264 [Warning] Bootstrap mode disables GTIDs. Bootstrap mode should only be used by mysql_install_db which initializes the MySQL data directory and creates system tables. ERROR: 1787 When @@GLOBAL.ENFORCE_GTID_CONSISTENCY = 1, the statements CREATE TEMPORARY TABLE and DROP TEMPORARY TABLE can be executed in a non-transactional context only, and require that AUTOCOMMIT = 1. 2014-12-08 20:48:16 9264 [ERROR] Aborting

    

    
我们这时如果正常启动mysqld的话，会发现默认root用户是登录不进去的，因为user表是空的，根本没有root用户，而匿名用户 
@localhost 又什么也做不了。

    
我们用 --skip-grant-tables 启动数据库后，匿名用户登录进去，查看user表，会发现是空的。

    

      
mysql> SELECT * FROM mysql.user;
Empty set (0.00 sec)

    

    
因为新建的数据库不可用，所以最终导致迁移失败。

    
这个问题的根本原因是5.5的配置文件中 autocommit = 0 导致的，所以好的解决方法是我们在升级5.6前，把这个值设置为1，然后再升级。

  

  

    

    

    
Test Book

  

  

    

      
大连接问题

    

    
现有mysql 处理客户端连接的方式会触发mysql 新建一个线程来处理新的连接，新建的线程会处理该连接所发送的所有 SQL 请求，即 one-thread-per-connection 的方式，其创建连接的堆栈为：

    

      
 mysqld_main
   handle_connections_sockets
     create_new_thread
       create_thread_to_handle_connection
         handle_one_connection

    

    
线程建立后，处理请求的堆栈如下：

    

      
0 mysql_execute_command

      
1 0x0000000000936f40 in mysql_parse

      
2 0x0000000000920664 in dispatch_command

      
3 0x000000000091e951 in do_command

      
4 0x00000000008c2cd4 in do_handle_one_connection

      
5 0x00000000008c2442 in handle_one_connection

      
6 0x0000003562e07851 in start_thread () from /lib64/libpthread.so.0

      
7 0x0000003562ae767d in clone () from /lib64/libc.so.6

    

    

      
优点及存在的问题

    

    
在连接数较小的情况下可以很快的响应客户端的请求，但当连接数非常大时会创建很多线程，这样会引起以下问题：

    
1. 过多线程之间的切换会加重系统的负载，造成系统资源紧张且响应不及时；

    
2. 频繁的进行线程的创建及销毁以及线程间同时无序的竟争系统资源加重了系统的负载。

    
thread_pool正是为了解决以上问题而产生的；

    

      
什么是thread_pool

    

    
thread_pool(线程池)，是指mysql 创建若干工作线程来共同处理所有连接的用户请求，用户的请求的方式不再是 ‘one thread per connection’，而是多个线程共同接收并处理多个连接的请求，在数据库的底层处理方面(mysql_execute_command)，单线程的处理方式和线程池的处理方式是一致的。

    

      
thread_pool 的工作原理

    

    
启动 thread_pool 的mysql 会创建thread_pool_size 个thread group , 一个timer thread, 每个thread group 最多拥有thread_pool_oversubscribe个活动线程，一个listener线程，listener线程负责监听分配到thread group中的连接，并将监听到的事件放入到一个queue中，worker线程从queue中取出连接的事件并执行具体的操作，执行的过程和one thread per connection 相同。timer threaad 则是为了监听各个threadgroup的运行情况，并根据是否阴塞来创建新的worker线程。

    
thread_pool 建立连接的堆栈如下：

    

      
 mysqld_main
   handle_connections_sockets
     create_new_thread
       tp_add_connection
         queue_put

    

    
thread group中的 worker 处理请求的堆栈如下：

    

      
0 mysql_execute_command

      
1 0x0000000000936f40 in mysql_parse

      
2 0x0000000000920664 in dispatch_command

      
3 0x000000000091e951 in do_command

      
4 0x0000000000a78533 in threadpool_process_request

      
5 0x000000000066a10b in handle_event

      
6 0x000000000066a436 in worker_main

      
7 0x0000003562e07851 in start_thread ()

      
8 0x0000003562ae767d in clone ()

    

    
其中worker_main函数是woker线程的主函数，调用mysql本身的do_command 进行消息解析及处理，和one_thread_per_connection 是一样的逻辑； thread_pool 自行控制工作的线程个数，进而实现线程的管理。

    
thread_pool中线程的创建：

    
1. listener线程将监听事件放入mysql放入queue中时，如果发现当前thread group中的活跃线程数active_thread_count为零，则创建新的worker 线程；

    
2. 正在执行的线程阻塞时，如果发现当前thread group中的活跃线程数active_thread_count为零，则创建新的worker 线程；

    
3. timer线程在检测时发现没有listener线程且自上次检测以来没有新的请求时会创建新的worker线程，其中检测的时间受参数threadpool_stall_limit控制；

    
4. timer线程在检测时发现没有执行过新的请求且执行队列queue 不为空时会创建新的worker线程；

    
worker线程的伪码如下：

    

      
 worker_main
 {
   while(connection)
   {
        connection= get_event();
        /* get_event函数用于从该线程所属thread_Group中取得事件，然后交给Handle_event函数处理，在同一Group内部，只有thread_pool_oversubscribe个线程能同时工作，多余的线程会进入sleep状态  */
        if(connection)
          handle_event(connection);
        /* 如果是没有登录过的请求，则进行授权检查，并将其Socket绑定到thread_group中的pollfd中，并设置Connection到event中的指针上；对于登录过的，直接处理请求 */
   }
   // 线程销毁
 }

    

    
thread_pool中线程的销毁：

    
当从队列queue中取出的connection为空时，则此线程销毁，取connection所等待的时间受参数thread_pool_idle_timeout的控制； 综上，thread_pool通过线程的创建及销毁来自动处理worker的线程个数，在负载较高时，创建的线程数目较高，负载较低时，会销毁多余的worker线程，从而降低连接个数带来的影响的同时，提升稳定性及性能。同时，threadpool中引入了Timer 线程，主要做两个事情。

    
1. 定期检查每个thread_group是否阻塞，如果阻塞，则进行唤醒或创建线程的工作；

    
2. 检查每个thread_group中的连接是否超时，如果超时则关掉连接并释放相应的资源；

    
threadpool在使用中存在的问题：

    
1. 由于threadpool严格控制活跃线程数的限制，如果同时有多个大查询同时分配到了同一个thread group，则会造成此group中的请求过慢，rt 升高，最典型的就是多个binlog dump 线程同时分配到了同一个group内；

    
2. 开启了事务模式时，非事务模式的请求会放入低优先级队列，因此可能在较长时间内得不到有效处理，极端情况下，会导致实例hang 住，例如某个连接执行了 flush tables with read lock ,并且此连接的后续请求都会放入低优先级，那么有可能会造成实列hang住；

    
3. 较小并发下，threadpool 性能退化的问题；

  

  

    

    

    
Test Book

  

  

    

      
背景：

    

    
mysql 主备同步是通过binlog来进行的，备库的 IO 线程从主库拉取binlog，SQL线程将拉取的binlog应用到备库，在5.6之前，备库只有一个线程应用binlog，主库的更新量大，且备库的执行效率低时，就会造成了大量从主库拉取的binlog来不及执行，因此造成了主备延迟问题。为了解决主备延迟，需要提高备库的执行效率，阿里MySQL 设计并开发了并行复制功能，所谓并行复制，指的是应用binlog的线程数量是多个的，而不是原生的单个线程，经过测试可以极大的提高复制性能（有3X的性能提升），在并行复制中，一个 IO 线程，一个分发线程，多个sql_thread，分发线程读取relay log，并将读取的relay log 分发给多个sql_thread, 从而实现并行化的效果。

    

      
原理：

    

    
分发线程的分发原理是依据当前事务所操作的表的名称来进行分发的，如果事务是跨表的（一个事务更新多张表），则需要等待已分配的该表相关的事务全部执行完毕，才会继续分发，其分配行为的伪码可以简单的描述如下：

    

      
get_slave_worker
 if (contains_partition_info(log_event))
    table_name= get_db_name(log_event);
    entry {table_name, worker_thread, usage} = map_table_to_worker(table_name);
    while (entry->usage > 0)
       wait();
   return worker;
 else if (last_assigned_worker)
   return last_assigned_worker;
 else
   push into buffer_array and deliver them until come across a event that have partition info

    

    

      
问题描述（testcase）：

    

    

      
drop table t2 if exists t2; 

drop table t1 if exists t1; 

create table t1(c1 int primary key, c2 int); 

create table t2(c1 int primary key, c2 int , foreign key (c2) references t1(c1)); 

insert into t1 values(1,1); 

insert into t1 values(2,2); 

insert into t2 values(1,1); 

insert into t2 values(2,2);

    

    
以下两个语句在备库的执行顺序不同，结果会不同

    
delete from t2 where c2=1; （语句1）

    
update t1 set c1=3 where c1=1;（语句2）

    
如果语句2先于语句1在备库执行，则会报外建约束错误，因为在上述的分发原理中没有考虑到外建约束问题，这种情况下，只有串行化处理了，当然，你可以执行：set global foreign_key_checks=off;然后start slave；在类似语句执行完后，再恢复foreign check，但是这样做真正安全吗？答案是不一定的……

    
情况1:

    
create table t1(c1 int primary key, c2 int);

    
create table t2(c1 int primary key, c2 int , foreign key (c2) references t1(c1));

    
在这种定义下，如果不检测foreign key，则不会有问题，因为对t1, t2的操作都会记录binlog；

    
情况2:

    
create table t1(c1 int primary key, c2 int);

    
create table t2(c1 int primary key, c2 int , foreign key (c2) references t1(c1) on delete cascade);

    
在这种定义下，如果不检测foreign key，则会有问题，因为对表t1的操作会影响t2表，在检测foreign key的时候，会进行相应的cascade操作，如果不检测foreign key,则不进行级联操作，这种问题一旦发生，则会引起主备不一致问题。

    

      
解决方法

    

    
5.6 并行复制没有此问题，5.6中在检测到foreign key的事件时，会等待已经分发的所有binlog都已执行完再执行，因此解决了此问题。

    

改进方案 
这个方案虽然能解决问题，但是若系统中只要出现一个外键关系，并且持续有更新，会导致持续性的回退到单线程方案，那么多线程复制的效果就会大打折扣。实际上这个做法比较极端，改进的方案是，遇到有foreign key 的表，应该将其分发到依赖他的表的同一个sql thread 中。这样执行这些事务时，其他表的并行复制仍能继续。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
　　对于解析MySQL的binlog用来更新其他数据存储的应用来说，binlog的顺序标识是很重要的。比如根据时间戳得到binlog位点作为解析起点。

    
　　但是binlog里面的事件，是否有稳定的有序性？

    
　　binlog中有三个看上去可能有序的信息：xid、timestamp、gno。本文分析这三个信息在binlog中的有序性。

    

      
Xid

    

    
　　当binlog格式为row，且事务中更新的是事务引擎时，每个事务的结束位置都有Xid，Xid的类型为整型。

    
　　MySQL中每个语句都会被分配一个全局递增的query_id(重启会被重置)，每个事务的Xid来源于事务第一个语句的query_id。

    
　　考虑一个简单的操作顺序：

    
　　session 1: begin; select; update;

    
　　session 2: begin; select; update; insert; commit;

    
　　session 1: insert; commit;

    
　　显然Xid2 > Xid1，但因为事务2会先于事务1记录写binlog，因此在这个binlog中，会出现Xid不是有序的情况。

    

      
TIMESTAMP

    

    
　　时间戳的有序性可能是被误用最多的。在mysqlbinlog这个工具的输出结果中，每个事务起始有会输出一个SET TIMESTAMP=n。这个值取自第一个更新事件的时间。上一节的例子中,timestamp2>timestamp1,但因为事务2会先于事务1记录写binlog，因此在这个binlog中，会出现TIMESTAMP不是有序的情况。

    

      
GNO

    

    
　　对于打开了gtid_mode的实例，每个事务起始位置都会有一个gtid event，其内容输出格式为UUID:gn，gno是一个整型数。

    
　　由于NEXT_GTID是可以直接指定的，因此若故意构造，可以很容易得到不是递增的情况，这里只讨论automatic模式下的有序性。

    
　　与上述两种情况不同，gno生成于事务提交时写binlog的时候。注意这里不是生成binlog，而是将binlog写入磁盘的时候。因此实现上确保了同一个UUID下gno的有序性。

    

      
小结

    

    
　　一个binlog文件中的Xid和TIMESTAMP无法保证有序性。在无特殊操作的情况下，相同的UUID可以保证gno的有序性。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
　　在MySQL的M-S结构里面，event是binlog日志的基本单位。每个event来源于主库，每个Event都包含了serverid，用于表示该event是哪个实例生成的。

    
　　在5.6里面，细心的同学会发现，备库的relaylog中出现了server_id为0的event，其类型为Rotate Event。

    
　　这里说说server_id=0的Rotate Event。

    

      
心跳event

    

    
　　MySQL Cluster中从NDB 6.3开始就出现的HEADBEAT event(hb event), 在社区版直到5.6.2才提供。

    
　　hb event的目的是为了保持M-S之间的心跳。用法上是slave在change master的时候可以指定MASTER_HEARTBEAT_PERIOD。当此值为0时，主库发送完所有事件后这个主备通道就一直idle直到发送新的event；当此值为非0的n时，主库通道在idle超过n秒之后，发一个hb event。

    
　　心跳event的另外一个作用是主库将当前的最新位点通知给备库。hb event中包含主库当前binlog最新位置的文件名和位点。备库收到hb event后判断主库位点是否大于本地保存的位点，若是，则在relay log中记录一个server_id为0的Rotate事件， 这意味着主库上新增了不需要发送给自己的event。

    

      
出现条件

    

    
　　在传统的主备环境中，正常情况下心跳事件是不会被触发写入到备库的relaylog的。这是因为所有的主库binlog中的事件都会发给备库，所以备库收到的hb event中的位点总是不大于备库已经接收到的binlog event最大值（注意到hb event只在通道idle时才发）。

    
　　但是在5.6启用了GTID以后，就出现了这样的case。最常见的是每个binlog文件开头用于表示之前所有binlog执行过的事件合集的Previous-GTIDs，这个事件需要记录在binlog中，但是不需要发给slave。这就会让备库在接收到hb之后记录一个server_id=0的Rotate event。

    

      
主库relaylog

    

    
　　与此相关的，一个可能出现的现象是双M单写场景下，备库没有更新，但是主库会一直写relay log。

    
　　步骤如下：

    
　　1、主备之间完成MM关系(GTID_MODE=on)

    
　　2、主库和备库各自stop slave

    
　　3、主库执行大量更新

    
　　4、主库start slave

    
　　5、备库start slave

    
　　在备库同步日志过程中生成了本地的binlog，这些binlog需要再发回给主库。5.6的一个机制是，如果发现通道对面的接收方的executed_set已经包含了这个事件，则不发送。

    
　　由于这些事件本身就是主库发送过来的，因此备库都不需要发回。但是备库必须通知主库本地的binlog的最新位点，因此构造了一个hb event。

    
　　主库收到hb event后记录在relaylog中，形式就是server_id=0的Rotate事件。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL5.6以后的版本提供了多种优化手段用于create index，比如online方式，Bulk Load方式。

    
Online提供了非阻塞写入的方式创建索引，为运维提供了很大的便利。

    
Bulk Load提升了索引创建的效率,减少了阻塞的时间。

    
这篇介绍下MySQL 5.7.5 Bulk Load的细节，并从查找，排序，redo，undo，page split等维度比较一下传统方式和Bulk Load方式。

    

      
传统方式

    

    
MySQL 5.7.5版本之前，create index使用的是和insert一条记录相同的api接口，即自上而下的插入方式。

    
步骤1: 扫描clustered index，得到行记录。

    
步骤2: 根据record，按照B-Tree的结构，从root->branch->leaf page查找到属于record的位置。:

    
步骤3: 调用write index record接口，维护索引。

    
1. 查找: 对每一条记录在插入前从B-Tree上查找到自己的位置。

    
2. 排序: 因为是按照B-Tree的结构，所以每一条记录插入都是有序的。

    
3. redo: 每条记录的插入都会记录innodb的redo做保护。

    
4. undo: 记录每个插入记录位置的undo

    
5. page split: 插入采用optimistic的方式，如果失败而发现page full，那么就split page，并向上更新branch page。

    
从上面的步骤和几个维度的说明上，传统的create index比较简单，但一方面会阻塞写入，另一方面效率会比较低，延长了不可用时间。

    

      
Bulk Load方式

    

    
MySQL 5.7.5 版本，提供了Bulk Load方式创建索引，使用多路归并排序和批量写入的方法，是一种自下而上的方式。

    
步骤1: 扫描clustered index，写入sort buffer，等sort buffer写满了后，写入到临时文件中。

    
步骤2: 对临时文件中的有序记录进行归并排序。

    
步骤3: 批量写入到索引结构中。

    
批量写入: 因为记录都是有序的，所以写入的过程就是，不断的分配leaf page，然后批量写入记录，并保留innodb_fill_factor设置的空闲空间大小，所以，就是不断在最右边leaf page写入，并不断进行平衡B-Tree结构的过程。

    
1. 查找: Bulk Load方式并没有单条record查找的过程。

    
2. 排序: 使用多路归并排序，对待写入的records进行排序。

    
3. redo: Innodb并没有记录redo log，而是做checkpoint直接持久化数据。

    
4. undo: 记录了新分配的page。

    
5. page split: 因为每次都是初始化一个最右端的page，create index的时候不存在split。

    
从上面的步骤和几个维度的说明上，Bulk Load方式能显著的利用机器的吞吐量，加快创建index的过程。

    

      
问题及与Oracle的比较

    

    
1. 临时空间使用

    
MySQL使用临时目录来保存临时文件，对于文件的大小受限于目录空间大小，需要注意。RDS通过增加一个参数来控制临时空间的使用。

    
Oracle使用临时表空间，如果排序空间不足，则会遇到常见的错误：ORA-01652: unable to extend temp segment by 128 in tablespace TEMP

    
2. redo保护

    
MySQL 的Bulk Load方式，没有使用redo保护，数据库从write-ahead logging方式退化成direct persist data，并且未来如果MySQL希望使用Innodb redo的方式进行复制，也变的困难。

    
Oracle如果不指定no logging参数，索引创建过程中记录完整的redo信息。

    
3. direct write

    
MySQL Bulk Load方式，对于新的leaf page，在创建的过程中，唤醒page cleaner线程对这些page做checkpoint进行持久化。

    
Oracle提供一种用户的服务器进程直接direct write物理文件的方式，写入数据，而不依赖DBWR进程。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL通过read_only参数来设置DB只读，这样MySQL实例就可以作为slave角色，只应用binlog，不接受用户修改数据。这样就可以保护master-slave结构中的数据一致性，防止双写风险。

    

      
global read_only的实现方式

    

    
MySQL5.5版本通过三个步骤来设置read_only：

    
步骤1：获取global read lock，阻塞所有的写入请求

    
步骤2：flush opened table cache，阻塞所有的显示读写锁

    
步骤3：获取commit lock，阻塞commit写入binlog

    
步骤4：设置read_only=1

    
步骤5：释放global read lock和commit lock。

    
MySQL 5.5的版本，通过这5步完成设置read only的功能。

    

      
Bug描述

    

    
比如如下场景：

    

      
 session1：
 lock table t read;

 session2：
 set global read_only=1;

    

    
先执行session1，然后session2会一直被session1阻塞。

    
原因是：session1的显示锁，虽然与步骤1中的global read lock相容， 但session2因为session1一直持有读锁并保持t表opened而被阻塞。

    
但是，实际上，显示的读写锁产生的opened table并不影响read_only的功能，这里的flush tables也并非是必须的。

    
这也是我们的实际应用环境中，因主备切换而要在master实例上设置read_only的时候，经常被大查询所阻塞的原因。

    

      
修复方法

    

    
修复方法非常简单，只需要把步骤2删除即可，不影响read only的语义。

    
官方在MySQL 5.6.5中进行了修复：

    
If tables were locked by LOCK TABLES ... READ in another session, SET GLOBAL read_only = 1 failed to complete. (Bug #57612, Bug #11764747)

    

      
RDS功能增强

    

    
设置read_only阻塞用户写入，但只能阻塞普通用户的更新，RDS为了最大可能的保护数据一致性，增强了read_only功能，通过设置super read only，阻塞除了slave线程以为的所有用户的写入，包括super用户。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
GTID 可以说是 MySQL 5.6 版本的一个杀手级特性，它给主备复制带来了极大的便利，RDS只读实例就是强依赖于这个特性。然而GTID在给我们带来便利的同时，也埋下了许多坑，最近几期内核月报中GTID的频繁出现也说明了这一点，对其我们可以说是既爱又恨。

    
GTID 并不是免费午餐，要使用它是要有代价的，为了保证GTID这个体系能够运转起来，需要做许多相关的工作，比如binlog里每个事务要多记 gtid_event 这种事件、写binlog的时候要生成 gtid、要维护几个GTID集合(logged, purged, owned)、THD类要多加GTID的成员变量等等，这些对性能和资源开销方面都有影响。

    
官方的最新代码中加入了一个关于GTID的优化，是在mysqld启动的时候，加快 gtid_set 初始化的速度，详见revno: 
6110
。关于GITD集合，最重要的有2个，一个是 gtid_executed， 另一个是gtid_purged，很多数据库运维相关的操作都要和这2个集合打交道，前者对应当前实例已经执行过的事务集合，后者对应已经执行过，但是已经不在binlog中的事务集合。mysqld 正常运行时，这2个集合是在内存中持续更新的，可是重启的时候，需要初始化这2个集合，因为并没有专门的地方记录这2个集合，初始化是通过读取binlog进行的。

    

      
优化分析

    

    
mysqld 是通过对 binlog.index 中记录的 binlog 文件做2次遍历来实现初始化的，第一次是从后向前，即从最新的binlog开始，到最老的binlog，对每个binlog从头到尾读一遍，初始化 gtid_executed 集合；第二次是从前往后，同样对每个binlog从头到尾读一遍，用来初始化gtid_purged 集合。每一遍的最好情况都是只读一个binlog文件，对gtid_executed 集合来说，只需要最新的binlog就行了，因为每个binlog开始会记录 previous_gitd_set，这个集合加上当前binlog内部记录的 gtid_event，就是所有已经执行的，也即 gtid_executed； 对gitd_purged来说，理想情况更简单，只需要读最老binlog文件的头部的previous_gtid event即可，文件里面的 gtid_event 根本不需要。

    
最坏情况是什么呢，就是一堆binlog文件里，只有其中一个文件里有gtid，其它都没有，这样的话，对于2遍扫描，都需要扫到这个binlog，才能确定这2个集合。

    
比如 a b c D e f 这几个，每个对应一个binlog文件，其中只有D含有gtid，其它的都没有，这样的话，每一遍的扫描都要读到文件D才能确定。

    
官方的优化是，不管什么情况下，每一遍的扫描，最多只读一个文件，不会再多读，如果最新和最老的文件都没有gtid，就把gtid_executed和gtid_purged设为空。

    

      
优化场景

    

    
下面我们来看下，这个优化有没有用 。 

我们还是用 a b c d e f 这几个表示binlog文件，小写表示文件没有包含gtid，大写表示有。

    

      
开始没有开gtid，后来开了：a, b, c, d, e, F 这样的模式，gtid_executed 只读 F，gtid_purged 只读a, 前者是F全集，后者是空的，如果没有这个优化的话，gtid_executed 也是读一个文件，gtid_purged 要从a读到F，最终还是空的，优化是有效果的

      
开始有，后来没有：A, b, c, d, e, f，这种情况下 gtid_executed 集合被初始化成空集，gtid_purged 也是空集，初始化结果是错的

      
开始没有，中间有最后也没有：a, b, c, D, e, f 这种情况，2个集合都被初始化成空的，结果也是错的

      
一直有：A，B，C，D，E，F，这种本来就是最好情况，本来每次遍历就只读一个文件的，加不加这个优化都一样

    

    
其它情况可以自己推算下

    
总的来说这个优化是比较鸡肋的，有的情况下还会算错，官方的优化 patch 带了个开关控制，默认是关的，这个只是对个别场景比较适合，比如上面的场景1。

  

  

    

    

    
Test Book

  

  

    
MySQL在开启Binary Log的情况下，使用2PC(图1)来保证事务(XA)完整性的，每次提交事务需要做:

    

      
 1) prepare phase:
     记录prepare信息到引擎层的Redo Log，fsync到磁盘
 2) commit phase:
     A) 记录commit信息到MySQL Server层的Binary Log，fsync到磁盘
     B) 记录commit信息到引擎层的Redo Log，fsync到磁盘

    

    
每个事务在提交的时候都要做3次fsync以确保日志真正的落盘，这样在log里，一个事务就会有3种状态:

    

      
 状态1: Redo Log里存在，Binary Log里也存在      --正常情况，crash恢复时需要commit
 状态2: Redo Log里存在，Binary Log里不存在      --prepare完毕后发生crash，恢复时需要rollback
 状态3: Redo Log里不存在，Binary Log里也不存在   --提交失败，无需处理

    

    

      

        

      

    

    
这样，无论处于任何一个状态，事务的完整性都不会被破坏，但是每次提交会产生3次fsync，性能非常低。 

为了提升性能，MySQL 5.6增加了group commit功能，当多个事务并发提交时，让多个都在等待fsync的事务合并做一次fsync，大大提升了吞吐量。 

但是这个优化还需要引擎层的配合，引擎层需要＂一切行动听指挥＂，不要＂任性＂的做fsync，需要对当前THD做HA_IGNORE_DURABILITY判断，代码如下:

    

      
 static bool tokudb_fsync_on_commit(THD *thd) {
 #if MYSQL_VERSION_ID >= 50600
     if (thd_get_durability_property(thd) == HA_IGNORE_DURABILITY)
         return false;
     else
 #endif
         return THDVAR(thd, commit_sync) != 0;
 }

    

    
TokuDB 7.5.4版本即将包含这个特性，官方透露，600 tokudb commits/sec只产生120个tokudb fsyncs。

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    

      
bug 描述

    

    
这是一个和 GTID 相关的Bug，也就是说5.6才会有，并且出现这个 bug 需要满足条件：

    

      
做修改性质的表管理操作，如 OPTIMIZE/ANALYZE/REPAIR 可以，CHECK 就不可以

      
操作对应的表不存在

      
gtid_next 被设置为一个固定的值，并且 binlog 开启

    

    
在同时满足这3种条件下，会发现记录binlog时，对应的 Gtid_log_event 中的UUID会记为 00000000-0000-0000-0000-000000000000，并且这个对应的 gtid 不会记入 Executed_Gtid_Set。

    

      
bug影响

    

    
从 bug 描述可以看出，这个 bug 的表现特征就是 gtid_event 记错了，因此单实例的话基本不受影响的，因为主备复制时才会用到 gtid，所以主备场景会受到这个bug的影响。下面我们看下主备场景下这个bug是如何影响的：

    
MS : M 和 S 互为主备，都是5.6，以 gtid 协议进行复制，M是主库。

    
假设我们在主库上执行了 OPTIMIZE TABLE non_exist_table，这时候 gtid_next = 'AUTOMATIC'，不是一个固定值，所以主库的 gtid 记录还是正常的，假设这时生成的 gtid_log_event 为 f3c1dd3e-395d-11e4-be45-4cb16c8f4abc:5，binlog 传到备库后，SQL 线程在 apply 的时候，会先将 f3c1dd3e-395d-11e4-be45-4cb16c8f4abc:5 设置为 gtid_next，然后同样做 OPTIMIZE TABLE non_exist_table，这个时候就触发了bug，备库的 gtid_log_event 记为00000000-0000-0000-0000-000000000000:5，并且不记入 Executed_Gtid_Set。主库继续接收用户的更新，同时会将备库的 binlog 拉过去应用，当做到 00000000-0000-0000-0000-000000000000:5 时，发现这个不在 Executed_Gtid_Set 中，就会执行，同样触发 bug， gtid_log_event 记为00000000-0000-0000-0000-000000000000:5，并且同样不记入 Executed_Gtid_Set。如此这样循环往复，会发现 OPTIMIZE TABLE non_exist_table 对应的binlog 在主备之前循环，充斥在 binlog 和 relay log 中。

    

      
bug 分析

    

    
之所以出现这个bug，是因为表管理操作的特殊性，OPTIMIZE/ANALYZE/REPAIR/CHECK TABLE 这些都统一调用 mysql_admin_table 函数进行管理操作，mysql_admin_table 执行失败的时候，执行线程并不报错，而是在 mysql_admin_table 函数结束前，清空线程中的error，将错误信息封装在结果集(result set)中发送给客户端，所以 OPTIMIZE/ANALYZE/REPAIR 虽然执行失败了，但仍然会记 binlog 。 按照这个逻辑来看，出错了仍然记binlog也是没问题，只要记对就行了，但是这里有一个问题，就是 mysql_admin_table 会调用 open_and_lock_tables，因为表不存在，所以 open_and_lock_tables 打开表的时候就出错，然后调用 trans_rollback_stmt ，之后会调到 gtid_rollback，最终调到 thd->variables.gtid_next.set_undefined()。

    

      
void set_undefined()
{
   if (type == GTID_GROUP)
     type= UNDEFINED_GROUP;
 }

    

    
可以看到，如果是 type == GTID_GROUP，就将 type 设置为 UNDEFINED_GROUP。那么什么情况下gtid_next 的 type 会是 GTID_GROUP，答案是为一个固定值的时候，即类似这种 f3c1dd3e-395d-11e4-be45-4cb16c8f4abc:5。

    
而在 Gtid_log_event::Gtid_log_event 有这段逻辑，

    

      
 if (spec.type == GTID_GROUP)
 {
   global_sid_lock->rdlock();
   sid= global_sid_map->sidno_to_sid(spec.gtid.sidno);
   global_sid_lock->unlock();
 }
 else
   sid.clear();

    

    
我们会发现，这个时候sid会被清掉，clear 操作就是置全0，所以最终写入 binlog 的就是全0。

    
细心的同学会发现，当 gtid_next = automatic 的时候，也是会被 clear 的（automatic 对应的 group 是 AUTOMATIC_GROUP），其实如果 gtid_next = automatic 的话，只有在 binlog commit 的时候才调用 gtid_before_write_cache 生成 gtid，所以前面的 gtid_rollback 是不会影响 automatic 的。

    
关于不记 Executed_Gtid_Set 的问题，gtid_rollback 的时候，一方面通过 thd->variables.gtid_next.set_undefined() 把 gtid_next 的type设成UNDEFINED_GROUP，另一方面用 thd->clear_owned_gtids()，把 thd->owned_gtid 的 sidno 设为0，导致最终不会添加到 Executed_Gtid_Set 中。

    

      
bug修复

    

    
官方已经修复了这个bug，具体可以参见这2个 revno

    

      
revno: 
5749

      
revno: 
5751

    

    
主要是第一个，第二个是post-fix。修复方法是在 THD 中加一个标志 skip_gtid_rollback，在进入 mysql_admin_table 时先根据上下文设置thd->skip_gtid_rollback ，在退出mysql_admin_table 前重置标志，gtid_rollback 在执行clear前会判断下thd->skip_gtid_rollback。

  

  

    

    

    
Test Book

  

  

    

      
bug描述

    

    
这是5.6中和gtid相关的一个bug，当 mysqld 收到 sighup 信号 （比如 kill -1） 的时候，会 flush binlog，但是新生成binlog开头没写 Previous_gtids_log_event，这会导致下面 2 个问题：

    

      

        
这个时候 mysqld 重启的话，会发现再也起不来了，error log 里有这样的错

        
The binary log file 'mysql/mysql-bin.000020' is logically corrupted: The first global transaction identifier was read, but no other information regarding identifiers existing on the previous log files was found.

      

      

        
这个时候主库继续更新，然后从库来拉取 binlog 的时候，io 线程会停下来

        
Last_IO_Error: Got fatal error 1236 from master when reading data from binary log: 'Error reading header of binary log while looking for the oldest binary log that contains any GTID that is not in the given gtid set'

      

    

    

      
bug 分析

    

    
mysqld 在收到 sighup 信号后，signal_hand 线程会调用 reload_acl_and_cache 函数 (sql_reload.cc)，最终会调用 MYSQL_BIN_LOG::open_binlog，open_binlog 有这段逻辑:

    

      
if (current_thd && gtid_mode > 0)
 {
   if (need_sid_lock)
     global_sid_lock->wrlock();
   else
     global_sid_lock->assert_some_wrlock();
   Previous_gtids_log_event prev_gtids_ev(previous_gtid_set);
   if (need_sid_lock)
     global_sid_lock->unlock();
   prev_gtids_ev.checksum_alg= s.checksum_alg;
   if (prev_gtids_ev.write(&log_file))
     goto err;
   bytes_written+= prev_gtids_ev.data_written;
 }

    

    
signal_hand 没有调用 store_globals 设置 THR_THD 这个key，所以这个时候 current_thd 得到的值是空的，因此prev_gtids_event 也就不会写进新binlog中的。

    

      
2个问题的分析

    

    

      

        
mysqld 重启不起来的原因：

        
mysqld 在启动的时候会通过 mysql_bin_log.init_gtid_sets 来初始化 gtid_executed 和 gtid_purged 2个set，初使化 gtid_executed 时，会读最新的binlog，将文件开头 Previous_gtids_log_event 的 gtid set 和文件里所有的 gtid_event 加起来，放进 gtid_executed，在读文件过程中，如果发现没有 Previous_gtids_log_event ，就报错，程序退出。

      

      

        
备库的错误信息解释：

        
在gtid协议下，主库向备库发 binlog 是用 com_binlog_dump_gtid 函数，这个函数会调到 MYSQL_BIN_LOG::find_first_log_not_in_gtid_set()，这个函数的作用是找到备库需要的第一个 binlog 文件，逻辑是这样的，从编号最大的binlog 往前找，对每个binlog，读取 Previous_gtids_log_event，如果发现这个集合是备库的发来的 gtid_set 的子集，就停止，当前这个binlog文件就是备库需要的第一个binlog文件。找的过程中，如果发现没有 Previous_gtids_log_event，就把错误信息 ER_MASTER_FATAL_ERROR_READING_BINLOG 发给备库。

      

    

    

      
问题的解决方法

    

    

      
对server 起不来的，只能手动删所有 binlog 文件了，同时还要清空 binlog.index 文件，有备库的话要重搭备库。

      
对于主备场景下，备库停掉的，purge 主库的binlog，如果主备不致的话，比如主库sighup后又有新的更新，这时候需要重做备库，因为binlog已经没了，只能拿主库的数据来重新做一个。

    

    

      
bug 修复

    

    
这个bug官方已经修复，具体可以参考 revno: 
5908
。

    
修复方法类似reload_acl_and_cache 中 REFRESH_GRANT 的逻辑，生成一个临时的 THD 作为 current_thd，在flush logs 完后释放掉。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
InnoDB作为事务性引擎，使用write-ahead logging(WAL)机制保证ACID中的Atomicity和Durability，使用undo机制保证ACID中的Consistency和Isolation。

    
按照WAL和undo的机制，形成以下两个原则：

    
1. 数据块的更改需要先记录redo日志。

    
2. 数据块的更改需要先写入undo。

    
根据这两个原则，InnoDB更新数据的基本流程可以简单的总结为：

    
1. 记录需要更改undo record的redo log

    
2. 记录需要更改data record的redo log

    
3. 写入redo log

    
4. 写入undo record

    
5. 更新data record

    
这5个步骤。

    

      
InnoDB Recovery

    

    
如果MySQL实例异常crash，那么重启过程中首先会进行InnoDB recovery。 即：根据last checkpoint点，顺序读取后面的redo log，按照先前滚，再回滚的原则， 应用所有的redo log。

    
因为redo record中记录着数据块的地址(space_id+page_no)，所以recovery的过程首先会执行合并相同数据块的操作，以加快recovery的过程。

    

      
那么问题来了

    

    
根据space_id怎么找到对应IDB数据文件？

    
因为在恢复的过程中，InnoDB只load了redo文件和系统表空间文件，如何查找InnoDB的数据文件呢？

    
1. InnoDB的数据字典dict_table_t结构中也保存了对应关系，但数据字典受redo保护，recovery的过程中不可用。

    
2. 扫描datadir的所有数据文件，读取page中保存的space_id，建立space_id和数据文件的对应关系。

    
MySQL目前采用第二种方式，但带来了一个问题，当设置了innodb_file_per_table后，每一个表对应一个表空间，那么需要读取所有的目录下的所有Innodb数据文件，这样就会严重的影响了recovery的时间。

    

      
MySQL 5.7改进策略：

    

    
MySQL 5.7中，在redo log中增加了一种新的record类型，即MLOG_FILE_NAME，记录了自last checkpoint以来更改的数据文件的file name。 这样在应用的时候，直接根据文件名就可以找到数据文件。

    

      
Oracle的设计机制：

    

    
Oracle数据库recovery的过程中，有没有这个问题呢？ 答案是没有。

    
我们来看下Oracle的设计机制:

    
oracle同样在系统表空间中记录了数据字典，受redo保护，可以通过DBA_开头的表来查询。但Oracle还维护了一个control file，控制文件中记录了database name，redo file，datafile，backup等信息，通过v$开头的表查询。

    
当Oracle在recovery的过程中，需要数据库在mount状态下，即打开了控制文件，这时数据字典还不可用(DB没有open)，在应用redo log的时候，根据控制文件中的v$datafile，检索file_id和file_name的对应关系。

    
MySQL是根据datadir，innodb_data_home_dir，innodb_log_group_home_dir等几个目录配置，通过文件系统的查找，找到相应文件的，而Oracle维护了一个集中式的control file管理这些初始加载的文件地址。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
MySQL的Master-Slave结构提供了实现High Availability的基础，在实现上面通常使用client-proxy-db的三层架构，proxy不单单完成错误检测、实例切换等高可用功能，还可以实现sharding，即scale out。

    
MySQL Fabric就是Oracle想大力发展的proxy，这里主要介绍为了完成高可用的功能，MySQL 5.7做了哪些事情，我们是否可以使用，实现自己的proxy？

    

      
高可用组件

    

    
proxy完成高可用的功能，除了需要MySQL提供的master-slave的基础结构外，还需要:

    
1. 在错误检测、进行实例切换时候，需要DB的只读功能，防止m/s双写。

    
2. 在切换完成后，如何实现client重连，或者实现session维持，对client透明。

    

      
那么问题来了

    

    
1. 如何保证切换？

    
当前MySQL版本提供了一个read_only的功能，通过添加global read lock和commit锁来实现，可以满足实现单点写入。

    
2. client重连或者session维持？

    
client重连主要依赖client的API，检测connection的错误。而保持connection不断开，session维持怎么做？

    

      
MySQL 5.7增加的功能

    

    
1. offline mode

    
offline mode不光实现了read only的功能，并且会断掉所有的非super用户的connection，并禁止重连。虽然官方文档中介绍是为了支持upgrade，但完全可以使用在切换的过程中。

    
2.session回放功能支持

    
client-server protocol对于response packet增加了对session state状态改变的支持，对于以下的session state变化：

    
1. User-defined variables

    
2. session-specific values for server variables

    
3. Temporary tables that are created

    
4. Prepared statements

    
5. Current database

    
response packet中会添加一个tracker标示其变化。 有了这个功能就可以容易实现session的回放功能，特别在load balance或者cluster环境中，把一个用户的connection迁移到另外一台实例上，来保持connection不断开，实现切换对client透明。

    
使用MySQL 5.7新增的这两个功能，可以帮助proxy实现DB高可用。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
引入MDL锁的目的，最初是为了解决著名的bug#989，在MySQL 5.1及之前的版本，事务执行过程中并不维护涉及到的所有表的Metatdata 锁，极易出现复制中断，例如如下执行序列：

    
Session 1: BEGIN;

    
Session 1: INSERT INTO t1 VALUES (1);

    
Session 2: Drop table t1; --------SQL写入BINLOG

    
Session 1: COMMIT; -----事务写入BINLOG

    
在备库重放 binlog时，会先执行DROP TABLE，再INSERT数据，从而导致复制中断。

    
在MySQL 5.5版本里，引入了MDL, 在事务过程中涉及到的所有表的MDL锁，直到事务结束才释放。这意味着上述序列的DROP TABLE 操作将被Session 1阻塞住直到其提交。

    
不过用过5.5的人都知道，MDL实在是个让人讨厌的东西，相信不少人肯定遇到过在使用mysqldump做逻辑备份时，由于需要执行FLUSH TABLES WITH READ LOCK (以下用FTWRL缩写代替)来获取全局GLOBAL的MDL锁，因此经常可以看到“wait for global read lock”之类的信息。如果备库存在大查询，或者复制线程正在执行比较漫长的DDL，并且FTWRL被block住，那么随后的QUERY都会被block住，导致业务不可用引发故障。

    
为了解决这个问题，Facebook为MySQL增加新的接口替换掉FTWRL 只创建一个read view ，并返回与read view一致的binlog位点；另外Percona Server也实现了一种类似的办法来绕过FTWRL，具体点击
文档连接
以及
percona的博客
，不展开阐述。

    
MDL解决了
bug#989
，却引入了一个新的热点，所有的MDL锁对象被维护在一个hash对象中；对于热点，最正常的想法当然是对其进行分区来分散热点，不过这也是Facebook的大神Mark Callaghan在report了
bug#66473
后才加入的，当时Mark观察到MDL_map::mutex的锁竞争非常高，进而推动官方改变。因此在MySQL 5.6.8及之后的版本中，引入了新参数metadata_locks_hash_instances来控制对mdl hash的分区数(
Rev:4350
)；

    
不过故事还没结束，后面的测试又发现哈希函数有问题，类似somedb.someprefix1….somedb.someprefix8的hash key值相同，都被hash到同一个桶下面了，相当于hash分区没生效。这属于hash算法的问题，喜欢考古的同学可以阅读下
bug#66473
后面Dmitry Lenev的分析。

    
Mark进一步的测试发现Innodb的hash计算算法比my_hash_sort_bin要更高效， Oracle的开发人员重开了个
bug#68487
来跟踪该问题，并在MySQL5.6.15对hash key计算函数进行优化，包括fix 上面说的hash计算问题(
Rev:5459
)，使用MurmurHash3算法来计算mdl key的hash值。

    

      
MySQL 5.7 对MDL锁的优化

    

    
在MySQL 5.7里对MDL子系统做了更为彻底的优化。主要从以下几点出发：

    
第一，尽管对MDL HASH进行了分区，但由于是以表名+库名的方式作为key值进行分区，如果查询或者DML都集中在同一张表上，就会hash到相同的分区，引起明显的MDL HASH上的锁竞争

    
针对这一点，引入了LOCK-FREE的HASH来存储MDL_lock，LF_HASH无锁算法基于论文"Split-Ordered Lists: Lock-Free Extensible Hash Tables"，实现还比较复杂。 注：实际上LF_HASH很早就被应用于Performance Schema，算是比较成熟的代码模块。

    
由于引入了LF_HASH，MDL HASH分区特性自然直接被废除了 。

    
对应
WL#7305
， PATCH(
Rev:7249
)

    
第二，从广泛使用的实际场景来看，DML/SELECT相比DDL等高级别MDL锁类型，是更为普遍的，因此可以针对性的降低DML和SELECT操作的MDL开销。

    
为了实现对DML/SELECT的快速加锁，使用了类似LOCK-WORD的加锁方式，称之为FAST-PATH，如果FAST-PATH加锁失败，则走SLOW-PATH来进行加锁。

    
每个MDL锁对象（MDL_lock）都维持了一个long long类型的状态值来标示当前的加锁状态，变量名为MDL_lock::m_fast_path_state 举个简单的例子：（初始在sbtest1表上对应MDL_lock::m_fast_path_state值为0）

    
Session 1: BEGIN;

    
Session 1: SELECT * FROM sbtest1 WHERE id =1; //m_fast_path_state = 1048576, MDL ticket 不加MDL_lock::m_granted队列

    
Session 2: BEGIN;

    
Session 2: SELECT * FROM sbtest1 WHERE id =2; //m_fast_path_state=1048576+1048576=2097152，同上，走FAST PATH

    
Session 3: ALTER TABLE sbtest1 ENGINE = INNODB; //DDL请求加的MDL_SHARED_UPGRADABLE类型锁被视为unobtrusive lock，可以认为这个是比上述SQL的MDL锁级别更高的锁，并且不相容，因此被强制走slow path。而slow path是需要加MDL_lock::m_rwlock的写锁。m_fast_path_state = m_fast_path_state | MDL_lock::HAS_SLOW_PATH | MDL_lock::HAS_OBTRUSIVE

    
注:DDL还会获得库级别的意向排他MDL锁或者表级别的共享可升级锁，但为了表述方便，这里直接忽略了，只考虑涉及的同一个MDL_lock锁对象。

    
Session 4: SELECT * FROM sbtest1 WHERE id =3; // 检查m_fast_path_state &HAS_OBTRUSIVE，如果DDL还没跑完，就会走slow path。

    
从上面的描述可以看出，MDL子系统显式的对锁类型进行了区分（OBTRUSIVE or UNOBTRUSIVE），存储在数组矩阵m_unobtrusive_lock_increment。 因此对于相容类型的MDL锁类型，例如DML/SELECT，加锁操作几乎没有任何读写锁或MUTEX开销。

    
对应
WL#7304
, 
WL#7306
 ， PATCH（
Rev:7067
,
Rev:7129
）(
Rev:7586
)

    
第三，由于引入了MDL锁，实际上早期版本用于控制Server和引擎层表级并发的THR_LOCK 对于Innodb而言已经有些冗余了，因此Innodb表完全可以忽略这部分的开销。

    
不过在已有的逻辑中，Innodb依然依赖THR_LOCK来实现LOCK TABLE tbname READ，因此增加了新的MDL锁类型来代替这种实现。

    
实际上代码的大部分修改都是为了处理新的MDL类型，Innodb的改动只有几行代码。

    
对应
WL#6671
，PATCH(
Rev:8232
)

    
第四，Server层的用户锁（通过GET_LOCK函数获取）使用MDL来重新实现。

    
用户可以通过GET_LOCK()来同时获取多个用户锁，同时由于使用MDL来实现，可以借助MDL子系统实现死锁的检测。

    
注意由于该变化，导致用户锁的命名必须小于64字节，这是受MDL子系统的限制导致。

    
对应
WL#1159
, PATCH(
Rev:8356
)

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
Innodb使用undo log来实现MVCC，这意味着如果一个很老的事务长时间不提交，那么新产生的undo log都无法被及时清理掉。在MySQL 5.5及之前版本中，undo log是存储在ibdata中。从5.6开始可以使用独立的undo log表空间来存储undo。但是直到5.6，一旦undo log膨胀，依然没有任何办法为其 “减肥”。因此我们经常看到ibdata被膨胀到几十上百G。

    

      
改进

    

    
在MySQL5.7.5版本中终于增加了这个众望所归的功能，实现了在线truncate undo log的功能。对应的changeling entry如下：

    
InnoDB: You can now truncate undo logs that reside in undo tablespaces. This feature is enabled using the innodb_undo_log_truncate configuration option. For more information, see Truncating Undo Logs That Reside in Undo Tablespaces.

    
在能够使用该特性之前，需要先打开独立undo表空间，注意现在只能在install db的时候才能开启，因为在初始化阶段是写死占用了最小的几个space id的。这种实现方式。。。只能无限吐槽了。

    
有几个参数控制undo tablespace：

    
innodb_undo_directory：undo文件的存储目录。

    
innodb_undo_tablespaces：undo tablespace的个数，实现在线truncate undo，需要大于等于2，因为在truncate一个undo log文件时，要保证另外一个是可用的，这样就无需停止业务了。

    
innodb_undo_logs：undo回滚段的数量需要大于34。原因是1~32个回滚段会被临时表占用（5.7针对临时表做了大量优化），第33、34分配给undospace1 和undospace2。

    
这里有个比较有意思的问题，由于undo 回滚段总是从第一个undospace分配，如果每次从1开始，每次重启递增innodb_undo_logs，所有的回滚段都会被分配到第一个undo space，在truncate第一个undo space时，将无可用的undo回滚分配给正常的用户事务。

    
innodb_purge_rseg_truncate_frequency：用于控制purge回滚段的频度。 Innodb Purge操作的协调线程每隔这么多次purge事务分发后，就会触发一次History purge，并检查当前的undo log 表空间状态是否会触发truncate。

    
innodb_max_undo_log_size：控制最大undo tablespace文件的大小，超过这个阀值时才会去尝试truncate。truncate后的大小默认为10M。

    
innodb_undo_log_truncate：用于打开/关闭undo log 在线truncate特性，可动态调整。

    
undo log 的truncate操作由purge 协调线程发起，在truncate 某个undo log 表空间的过程中，保证有一个可用的undo log tablespace能提供给用户使用，从而实现所谓的在线truncate。

    
当选定一个需要truncate的undo log space时，需要检查其是否是可释放的，也就是说是否还有活跃的事务可能访问其中的回滚段。如果没有，就将该tablespace中的回滚段设置为不可分配，然后对undo log space文件进行truncate，并重新初始化到10M，初始化文件头等一系列操作。

    
这里引入了比较有意思的方法来保证truncate的原子性，即在开始truncate时，创建一个独立的文件，命名为undo__trunc.log，在做完truncate操作后，删除文件。如果在中间发生crash，崩溃恢复时发现该文件，会继续完成truncate操作。

    
更具体的参考
WL#6965
 及对应补丁
Rev:8615

  

  

    

    

    
Test Book

  

  

    

      
问题描述

    

    
首先，我们执行下面的TestCase：

    

      
 --source include/master-slave.inc
 --source include/have_binlog_format_row.inc
 connection slave;
 set global slave_rows_search_algorithms='TABLE_SCAN';
 connection master;
 create table t1(id int, name varchar(20);
 insert into t1 values(1,'a');
 insert into t2 values(2, 'b');
 ......
 insert into t3 values(1000, 'xxx');
 delete from t1;
 ---source include/rpl_end.inc

    

    
随着 t1 数据量的增大，rpl_hash_scan.test 的执行时间会随着 t1 数据量的增大而快速的增长，因为在执行 'delete from t1;' 对于t1的每一行删除操作，备库都要扫描t1,即全表扫描，如果 select count(*) from t1 = N, 则需要扫描Ｎ次 t1 表， 则读取记录数为： O(N + (N-1) + (N-2) + .... + 1) = O(N^2)，在 replication 没有引入 hash_scan，binlog_format=row时，对于无索引表，是通过 table_scan 实现的，如果一个update_rows_log_event/delete_rows_log_event 包含多行修改时，每个修改都要进行全表扫描来实现，其 stack 如下：

    

      
#0 Rows_log_event::do_table_scan_and_update
#1 0x0000000000a3d7f7 in Rows_log_event::do_apply_event 
#2 0x0000000000a28e3a in Log_event::apply_event
#3 0x0000000000a8365f in apply_event_and_update_pos
#4 0x0000000000a84764 in exec_relay_log_event 
#5 0x0000000000a89e97 in handle_slave_sql (arg=0x1b3e030) 
#6 0x0000000000e341c3 in pfs_spawn_thread (arg=0x2b7f48004b20) 
#7 0x0000003a00a07851 in start_thread () from /lib64/libpthread.so.0
#8 0x0000003a006e767d in clone () from /lib64/libc.so.6

    

    
这种情况下，往往会造成备库延迟，这也是无索引表所带来的复制延迟问题。

    

      
如何解决问题：

    

    

      
RDS 为了解这个问题，会在每个表创建的时候检查一下表是否包含主建或者唯一建，如果没有包含，则创建一个隐式主建，此主建对用户透明，用户无感，相应的show create, select * 等操作会屏蔽隐式主建，从而可以减少无索引表带来的影响;

      
官方为了解决这个问题，在5.6.6 及以后版本引入参数 slave_rows_search_algorithms ，用于指示备库在 apply_binlog_event时使用的算法，有三种算法TABLE_SCAN,INDEX_SCAN,HASH_SCAN，其中table_scan与index_scan是已经存在的，本文主要研究HASH_SCAN的实现方式，关于参数slave_rows_search_algorithms的设置，详情请参考：

http://dev.mysql.com/doc/refman/5.6/en/replication-options-slave.html#option_mysqld_slave-rows-search-algorithms

    

    

      
hash_scan 的实现方法：

    

    
简单的讲，在 apply rows_log_event时，会将 log_event 中对行的更新缓存在两个结构中，分别是：m_hash, m_distinct_key_list。 m_hash：主要用来缓存更新的行记录的起始位置，是一个hash表； m_distinct_key_list：如果有索引，则将索引的值push 到m_distinct_key_list，如果表没有索引，则不使用这个List结构； 其中预扫描整个调用过程如下： Log_event::apply_event

    

      
 Rows_log_event::do_apply_event
    Rows_log_event::do_hash_scan_and_update 
      Rows_log_event::do_hash_row  (add entry info of changed records)
        if (m_key_index < MAX_KEY) (index used instead of table scan)
          Rows_log_event::add_key_to_distinct_keyset ()

    

    
当一个event 中包含多个行的更改时，会首先扫描所有的更改，将结果缓存到m_hash中，如果该表有索引，则将索引的值缓存至m_distinct_key_list List 中，如果没有，则不使用这个缓存结构，而直接进行全表扫描；

    

      
执行 stack 如下：

    

    

      
#0 handler::ha_delete_row 
#1 0x0000000000a4192b in Delete_rows_log_event::do_exec_row 
#2 0x0000000000a3a9c8 in Rows_log_event::do_apply_row
#3 0x0000000000a3c1f4 in Rows_log_event::do_scan_and_update 
#4 0x0000000000a3c5ef in Rows_log_event::do_hash_scan_and_update 
#5 0x0000000000a3d7f7 in Rows_log_event::do_apply_event 
#6 0x0000000000a28e3a in Log_event::apply_event
#7 0x0000000000a8365f in apply_event_and_update_pos
#8 0x0000000000a84764 in exec_relay_log_event 
#9 0x0000000000a89e97 in handle_slave_sql
#10 0x0000000000e341c3 in pfs_spawn_thread
#11 0x0000003a00a07851 in start_thread () 
#12 0x0000003a006e767d in clone () 

    

    

      
执行过程说明：

    

    
Rows_log_event::do_scan_and_update

    

      
    open_record_scan()
    do
      next_record_scan()
        if (m_key_index > MAX_KEY)
           ha_rnd_next();
        else
           ha_index_read_map(m_key from m_distinct_key_list)       
        entry= m_hash->get()
        m_hash->del(entry);
        do_apply_row()
     while (m_hash->size > 0);

    

    
从执行过程上可以看出，当使用hash_scan时，只会全表扫描一次，虽然会多次遍历m_hash这个hash表，但是这个扫描是O(1),所以，代价很小，因此可以降低扫描次数，提高执行效率。

    

      
hash_scan 的一个 bug

    

    
bug详情：

http://bugs.mysql.com/bug.php?id=72788

    
bug原因：m_distinct_key_list 中的index key 不是唯一的，所以存在着对已经删除了的记录重复删除的问题。

    
bug修复：

http://bazaar.launchpad.net/~mysql/mysql-server/5.7/revision/8494

    

      
问题扩展：

    

    

      

        
在没有索引的情况下，是不是把 hash_scan 打开就能提高效率，降低延迟呢？

        
不一定，如果每次更新操作只一条记录，此时仍然需要全表扫描，并且由于entry 的开销，应该会有后退的情况；

      

      

        
一个event中能包含多少条记录的更新呢？

        
这个和表结构以及记录的数据大小有关，一个event 的大小不会超过9000 bytes, 没有参数可以控制这个size；

      

      

        
hash_scan 有没有限制呢？

        
hash_scan 只会对更新、删除操作有效，对于binlog_format=statement 产生的 Query_log_event 或者binlog_format=row 时产生的 Write_rows_log_event 不起作用；

      

    

  

  

    

    

    
Test Book

  

  

    
TokuDB　7.5.0大版本已发布，是一个里程碑的版本，这里谈几点优化，以飨存储引擎爱好者们。

    

      
a) shutdown加速

    

    
有用户
反馈
TokuDB在shutdown的时候，半个小时还没完事，非常不可接受。 

在shutdown的时候，TokuDB在干什么呢？在做checkpoint，把内存中的节点数据序列化并压缩到磁盘。 

那为什么如此耗时呢？如果tokudb_cache_size开的比较大，内存中的节点会非常多，在shutdown的时候，大家都排队等着被压缩到磁盘（串行的）。 

在7.5.0版本，TokuDB官方针对此问题进行了优化，使多个节点并行压缩来缩短时间。

    
详细commit见: 

https://github.com/Tokutek/ft-index/commit/bd85b8ce7d152412755860976a871fdfc977115c
  

BTW: TokuDB在早期设计的时候已保留并行接口，只是一直未开启。

    

      
b) 内节点读取加速

    

    
在内存中，TokuDB内节点(internal node)的每个message buffer都有２个重要数据结构：

    

      
 1) FIFO结构，保存{key, value}
 2) OMT结构，保存{key, FIFO-offset}

    

    
由于FIFO不具备快速查找特性，就利用OMT来做快速查找(根据key查到value)。

    
这样，当内节点发生cache miss的时候，索引层需要做：

    

      
 1) 从磁盘读取节点内容到内存
 2) 构造FIFO结构
 3) 根据FIFO构造OMT结构(做排序)

    

    
由于TokuDB内部有不少性能探(ji)针(shu)，他们发现步骤3)是个不小的性能消耗点，因为每次都要把message buffer做下排序构造出OMT，于是在7.5.0版本，把OMT的FIFO-offset(已排序)也持久化到磁盘，这样排序的损耗就没了。

    

      
c) 顺序写加速

    

    
当写发生的时候，会根据当前的key在pivots里查找(二分)当前写要落入哪个mesage buffer，如果写是顺序(或局部顺序，数据走向为最右边路径)的，就可以避免由＂查找＂带来的额外开销。 

如何判断是顺序写呢？TokuDB使用了一种简单的启发式方法(heurstic)：seqinsert_score积分式。 

如果：

    

      
 1) 当前写入落入最右节点，对seqinsert_score加一分(原子)
 2) 当前写入落入非最右节点，对seqinsert_score清零(原子)

    

    
当seqinsert_score大于100的时候，就可以认为是顺序写，当下次写操作发生时，首先与最右的节点pivot进行对比判断，如果确实为顺序写，则会被写到该节点，省去不少compare开销。 

方法简单而有效。

  

  

    

    

    
Test Book

  

  

    
MySQL的update在执行时需要做read-modify-write：

    

      
1) 从底层存储中读取row数据(read row)
2) 对row数据做更改(modify row)
3) 把更改后的数据写回底层存储(write row)

    

    
操作路径还是比较长的，TokuDB提供了fast update语法，让＂某些＂场景下update更快，无需做read和modify直接write。 

用法:

    

      
 CREATE TABLE `t1` (
 `id` int(11) NOT NULL,
 `count` bigint(20) NOT NULL,
 PRIMARY KEY (`id`)) ENGINE=TokuDB;

    

    
NOAR语句：

    

      
 INSERT NOAR INTO t1 VALUES (1,0) ON DUPLICATE KEY UPDATE count = count + 1;

    

    
语义是：插入一条记录，如果该记录存在(id为1)，就对count的值做加法操作，不存在则做插入。 

注意： fast updates的条件是比较苛刻的，必须满足：

    

      
1) 表必须有主键，且只能有一个索引(包含主键)
2) 主键必须为： int, char或varchar类型，被更新的列也必须为三种类型之一
3) WHERE子句必须为单行操作
4) 如果开启binlog，binlog_format必须为STATEMENT

    

    
看了这些苛刻的条件后，有种＂臣妾做不到＂的感觉了吧，可以看出TokuDB一直为细节而努力。

  

  

    

    

    
Test Book

  

  

    
从MySQL 5.6.2/MariaDB 10.0.0版本开始，MySQL/MariaDB针对"ORDER BY ...LIMIT n"语句实现了一种新的优化策略。当n足够小的时候，优化器会采用一个容积为n的优先队列来进行排序，而不是排序所有数据然后取出前n条。 这个新算法可以这么描述：（假设是ASC排序）

    

      
建立一个只有n个元素的优先队列（堆），根节点为堆中最大元素

      
根据其他条件，依次从表中取出一行数据

      
如果当前行的排序关键字小于堆头，则把当前元素替换堆头，重新Shift保持堆的特性

      
再取一条数据重复2步骤，如果没有下一条数据则执行5

      
依次取出堆中的元素（从大到小排序），逆序输出（从小到大排序），即可得ASC的排序结果

    

    
这样的算法，时间复杂度为m
log(n)，m为索引过滤后的行数，n为LIMIT的行数。而原始的全排序算法，时间复杂度为m
log(m)。只要n远小于m，这个算法就会很有效。

    
不过在MySQL 5.6中，除了optimizer_trace，没有好的方法来看到这个新的执行计划到底起了多少作用。MariaDB 10.013开始，提供一个系统状态，可以查看新执行计划调用的次数：

    

      
 Sort_priority_queue_sorts
 描述: 通过优先队列实现排序的次数。(总排序次数=Sort_range+Sort_scan)
 范围: Global, Session
 数据类型: numeric
 引入版本: MariaDB 10.0.13

    

    
此外，MariaDB还将此信息打入了Slow Log中。只要指定 log_slow_verbosity=query_plan，就可以在Slow Log中看到这样的记录：

    

      
 # Time: 140714 18:30:39
 # User@Host: root[root] @ localhost []
 # Thread_id: 3  Schema: test  QC_hit: No
 # Query_time: 0.053857  Lock_time: 0.000188  Rows_sent: 11  Rows_examined: 100011
 # Full_scan: Yes  Full_join: No  Tmp_table: No  Tmp_table_on_disk: No
 # Filesort: Yes  Filesort_on_disk: No  Merge_passes: 0  Priority_queue: Yes
 SET timestamp=1405348239;SET timestamp=1405348239;
 select * from t1 where col1 between 10 and 20 order by col2 limit 100;

    

    
"Priority_queue: Yes" 就表示这个Query利用了优先队列的执行计划(pt-query-digest 目前已经可以解析 Priority_queue 这个列)。

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    
为了生成执行计划，优化器会使用一个基于估算查询执行过程中各种操作开销的成本模型。MySQL优化器有一组在编译时默认指定的“成本常量”（例如CPU算几个因子、IO算几个因子），用于决策执行计划的生成。

    
从5.7.5开始，优化器在执行计划的生成过程中有了额外的成本估算项可用。这些估算项存在在mysql系统库的server_cost和engine_cost表中，并且任何时候都可以通过修改表中的值来配置这些估算项。这些表存在的目的是，可以通过简单的调整这些表中的成本估算项来影响执行计划的生成，来达到调整执行计划的目的。

    
两张表的结构和内容如下：

    

      
root@localhost : test 12:38:41> select * from mysql.server_cost; 
+------------------------------+------------+---------------------+---------+
| cost_name                    | cost_value | last_update         | comment |
+------------------------------+------------+---------------------+---------+
| disk_temptable_create_cost   |       NULL | 2014-10-15 11:34:11 | NULL    |
| disk_temptable_row_cost      |       NULL | 2014-10-15 11:34:11 | NULL    |
| key_compare_cost             |       NULL | 2014-10-15 11:34:11 | NULL    |
| memory_temptable_create_cost |       NULL | 2014-10-15 11:34:11 | NULL    |
| memory_temptable_row_cost    |       NULL | 2014-10-15 11:34:11 | NULL    |
| row_evaluate_cost            |       NULL | 2014-10-15 11:34:11 | NULL    | 
+------------------------------+------------+---------------------+---------+

    

    

      
root@localhost : test 12:38:51> select * from mysql.engine_cost;
+-------------+-------------+--------------------+------------+---------------------+---------+
| engine_name | device_type | cost_name          | cost_value | last_update         | comment |
+-------------+-------------+--------------------+------------+---------------------+---------+
| default     |           0 | io_block_read_cost |       NULL | 2014-10-15 11:34:11 | NULL    |
+-------------+-------------+--------------------+------------+---------------------+---------+

    

    

      
成本模型的工作方式

    

    
可配置的优化器成本模型按如下方式工作：

    
MySQL Server在启动时读取成本模型表，并且在运行时使用内存中存贮的值。表中任何非NULL的成本估算项的值都会覆盖在代码中写死的默认成本常数，优先参与优化器成本计算。任何NULL值的成本估算项优化器都会认为用户没有指定特定的值，而使用代码中默认的成本常数。

    
在MySQL运行时，Server可能会重新读取成本表，可以通过动态载入存储引擎或者执行FLUSH OPTIMIZER_COSTS语句来触发。

    
成本估算表可以让管理员通过简单的方式去调整成本估算项，也可以通过把估算项设置为NULL来恢复原来的内置默认值。优化器使用的是内存中缓存的开销值，所以修改了表中的值后记得用FLUSH OPTIMIZER_COSTS命令让修改生效。

    
内存中缓存的成本项对当前正在执行的Session是不起效果的，一个Session内执行的Query其成本项的值是不会变动的。即使Server触发了重新读取成本表，任何估算项的变更也只影响后来链接上来的Session。

    
成本开销表是不参与复制的，只影响修改的本地实例，不会通过复制把开销表的变更复制到备库。

    

      
成本模型数据库

    

    
优化器成本模型库由mysql系统库下的两张表组成，包含了Query执行过程中一些操作项的成本估算值：

    
server_cost: Server层一些操作的成本估算项的值

    
engine_cost: 特定引擎的一些操作的成本估算项的值

    
server_cost表包含这些字段:

    
cost_name

    
成本模型中的成本估算项的名称（不区分大小写）。如果Server无法识别名称，在读取的时候会打一个报错在error log中。

    
cost_value

    
成本估算项的值。如果值是非NULL的，那么Server就使用这个值作为成本，否则就用编译时内置的值，DBA可以通过UPDATE这个列来修改响应的成本项。如果Server读到无效的值（例如负数），会在errorlog中打一条Warning。

    
要覆盖内置的默认值就需要设置一个非NULL值，如果要恢复默认值，就把值重新改为NULL，然后执行FLUSH OPTIMIZER_COSTS 告诉Server重新读取成本表。

    
last_update

    
这一行的最后修改时间。

    
comment

    
成本项的描述注释。DBA可以利用这个这个列来记录为什么修改了这个成本项的值，用于备查。

    
server_cost表的主键是server_cost，所以不能创建名称相同的成本项。

    
Server可以识别server_cost表中如下的cost_name:

    
disk_temptable_create_cost, disk_temptable_row_cost

    
内部创建磁盘临时表的成本开销。增加这些成本项的值可以让优化器更偏向于生成不使用磁盘临时表的执行计划。

    
key_compare_cost

    
比较记录键值的成本开销。增加这个值可以让执行计划中比较键值的操作成本变的更加昂贵。例如，一个执行计划执行了filesort，那么它的代价会比利用索引避免排序的代价要大得多。

    
memory_temptable_create_cost, memory_temptable_row_cost

    
内部创建内存临时表的成本开销。增加这些值可以使得建立内部临时表成本增加，因而优化器会偏向于不使用临时表。

    
row_evaluate_cost

    
扫描记录行的成本开销。增加这个会导致执行计划中扫描很多行数据的操作变得更加昂贵，因而执行计划会偏向扫描更少的函数。例如，一个全表扫描会比范围扫描要昂贵的多。

    
engine_cost 表包含这些列:

    
engine_name

    
要应用这个成本项的存储引擎的名称（不区分大小写）。如果这些值是default，那么对所有没在表里指定的存储引擎都会生效。如果Server无法认出引擎名称，会在errorlog输出一条Warning。

    
device_type

    
这个成本项适用的设备类型。这个列可以为不同的存储设备指定不同的成本开销，例如SAS盘和SSD盘是不一样的。不过目前，这个信息还没启用，只有0可以设置。

    
cost_value，last_update，comment

    
这三列的含义跟server_cost表中的字段含义一样.

    
engine_cost表的主键是 (cost_name, engine_name, device_type)，所以不允许为一个引擎的同一类存储设备创建相同的成本项。

    
目前Server只识别engine_cost表中的一个cost_name：

    
io_block_read_cost

    
这个成本项表示从磁盘读取一个数据的成本。增加这个值会导致执行计划中读取磁盘块会有更高的成本，因此优化器会偏向于读取更少的磁盘块。例如，一个全表扫描会比一个范围扫描读取更少的磁盘块，因此优化器会偏向范围扫描。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
　　当用户从oracle迁移到MySQL时，可能由于原表字段太多建表不成功，这里讨论一个问题：一个InnoDB表最多能建多少个text字段。

    
　　我们后续的讨论基于创建表的语句形如：create table t(f1 text, f2 text, ..., fN text)engine=innodb;

    

      
默认配置

    

    
　　在默认配置下，上面的建表语句，N取值范围为[1, 1017]。 为什么是1017这个“奇怪”的数字。实际上单表的最大列数目是1024-1，但是由于InnoDB会增加三个系统内部字段（主键ID、事务ID、回滚指针），因此需要减3。而用于记录系统字典表也受1023的限制，又需要再增加三个该表的系统字段，因此每个表的最大字段数是1023-3*2。

    

      
插入异常

    

    
　　上述描述说明的是表能够创建成功的最大字段数。但是这样的表是“插入不安全”的。我们知道text的长度上限是64k。而往上表中插入一行，每个字段长度为7，就会报错：Row size too large (> 8126).

    
　　一个page是16k，空page扣掉页信息占用空间是16252，需要除以2，原因是每个page至少要包含两个记录。

    
　　也就是说，虽然可以创建一个包含1017个text字段的表，但是很容易碰到插入失败。

    

      
如何保证插入安全

    

    
　　上面的表结构，在保证插入安全的情况下，N的最大值是多少？text在存储的时候，当超过768字节的时候，剩余部分会保存在另外的页面（off-page），因此每个字段占用的最大空间为768+20+2=788. 20字节存储最短剩余部分的位置（SPACEID+PAGEID+OFFSET）。2字节存储本地实际长度。

    
　　因此N最大值为lower(8126/790)=10。

    
　　如果我们想在创建的表的时候，保证创建的表中的text字段都能安全的达到64k上限（而不是等插入的时候才发现），那么需要将默认为OFF的innodb_strict_mode设置为ON，这样在建表时会先做判断。

    
　　但是，在设置为严格模式后，上述建表语句的最大N却并非10.

    

      
ROW_FORMAT

    

    
　　在off-page存储时，本地占用790个字节，是基于默认的ROW_FORMAT，即为COMPACT，此时插入安全的N上限为10。

    
　　而在InnoDB新格式Barracuda支持下，Dynamic格式的off-page存储时，在local保存的上限不再是768，而是20个字节。这样每个字段在数据页里面占用的最大值是40byte，再需要一个额外的字节存储实际的本地长度，因此每个text最大占用41字节。

    
　　实际上很容易测试在严格模式下，建表的最大N为196. 以下为N=197时计算过程：

    
　　每行记录预留header 5个字节。

    
　　每个bit保存是否允许null，需要 upper(197/8)=25个字节。

    
　　三个系统保留字段 6+6+7=19.

    
　　因此总占用空间 5+25+19+41*197=8126！

    
　　也就是说，当N=197时，刚好长度为8126，而代码中实现是 if(rec_max_size >= page_rec_max) reutrn(error).

    
　　就这么不巧！

    

      
作为补充

    

    
　　有经验的读者可以联想到，如果我们的表中自己定义一个int型主键呢？此时系统不需要额外增加主键，因此整个表结构比之前少2字节。

    
　　也就是说，建表语句修改为: create table t(id int primary key, f1 text, f2 text, ..., fN text)engine=innodb;

    
　　则此时的N上限能达到197。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
在 MySQL 日常维护中，要回滚或者恢复数据，我们经常会用 binlog 来在数据库上重放，执行类似下面的语句：

    
mysqlbinlog mysql-bin.000001 | mysql -hxxxx -Pxx -u

    
最近遇到了这样一个问题，在重放 binlog 时，mysqld 报这样的错

    
ERROR 1064 (42000) at line 25: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'DELIMITER ;

    

      
分析

    

    
上面的错是说语法不对，难道是 binlog 写错了，为了方便查看，先把 mysqlbinlog 解析结果保存到一个文件

    
mysqlbinlog mysql-bin.000001 > abc.sql

    
然后打开 abc.sql 文件，会看到这样的语句

    
"CREATE TABLE t_binlog_sbr(a int)^@"

    
最后面的奇怪的 "^@" 这是啥呢，我们用二进制方式打开文件后，发现这个其实是1个字节，值是 00，被显示成 "^@"了。

    
为啥后面会多 1 个 0 呢，后来发现是用户在用 MySQL C API 时用错了，具体是这个函数 mysql_real_query，基原型是

    
int mysql_real_query(MYSQL 
mysql, const char 
stmt_str, unsigned long length)

    
详细说明参考
这里
，length 参数表示 stmt_str 的长度，所以正常的调用应该是这样的：

    
mysq_real_query(mysql, sql, strlen(sql))

    
可是用户在使用时多加了个1，变成这样

    
mysq_real_query(mysql, sql, strlen(sql) + 1)

    
最终导致记录的 binlog 后面多了个 '\0'。 这个问题只在 statement 格式有，row 格式没有。

    

      
解决方法

    

    
有同学会问，+1 可以，+2、 +3 呢，这个是不可以的，>=2 的都是不行的，语句发过来后，mysqld 在 parse_sql 阶段直接报错返回了，后面就不会执行了。

    
1) 修改代码

    
mysq_real_query(mysql, sql, strlen(sql) + 1) 这种用法是不对的，但是 MySQL 却允许，虽然这么用是不对的，但是为了兼容性，最好还是允许这种使用方式，但是在写binlog的时候做个判断，长度是不是写错了，错了的话纠正过来，在 THD::binlog_query 里面改。

    
2) 5.6 版本加参数

    
如果是用 5.6 版本的 mysql client 的话，在重放时出错提示信息不一样，是类似下面这样的，更加友好，这个错误是 mysql client 报的，不是mysqld报的：

    
ERROR at line 24: ASCII '\0' appeared in the statement, but this is not allowed unless option --binary-mode is enabled and mysql is run in non-interactive mode. Set --binary-mode to 1 if ASCII '\0' is expected....

    
5.6 版本的 mysql client 多了一个参数 --binary-mode，允许语句里有 '\0'，所以如果是用5.6的话，就可以不用修改代码，重放binlog时这样做就可以了：

    
mysqlbinlog mysql-bin.000001 | mysql --binary-mode -hxxxx -Pxx -u

  

  

    

    

    
Test Book

  

  

    

      
bug背景

    

    
官方最近发布的版本(5.7.5)修复了这样一个bug，主备复制场景下，如果主库和备库对应的表结构中有数据类型不一致，并且主库的 binlog 是 row 格式的，这时候如果主库对不一致的表做了一个大事务更新，备库在应用 relay-log 的时候报OOM(Out of Memory)。bug地址在
这里
，主备数据类型不一致主要发生在这2种情况下：

    

      
主备库版本不一致，不同版本之间的数据类型可能存在不一致。用户在报这个bug时，就是在5.5到5.6的复制场景下，用到了时间类型，时间类型在5.6.4版本时
发生了变化

      
人为直接的连上从库 alter 表

    

    

      
bug分析

    

    
为啥数据类型不一致会导致 OOM 呢？OOM 表示程序在持续申请内存，把内存给用爆了。从库的slave thread在应用Rows_log_event时，如果发现主库的表和从库的表不兼容，就会创建一个临时中间表，做数据转化：

    

      
Rows_log_event::do_apply_event()
    table_def::compatible_with()
         table_def::create_conversion_table()
              create_conversion_table()

    

    
在此过程中用的临时表结构和field字段都是从thd的mem_root分配的，而每个Rows_log_event应用时分配内存空间再do_apply_event后就不会再用了，但是 Rows_log_event::do_apply_event() 结束后并没有free_root释放，而是在事务所有event做完后释放的。类似下面这种包含大量更新语句的事务，每一个更新对应一个Rows_log_event，备库在应用时，在事务执行中间所有申请的内存都会保持，如果语句非常多的话，就导致OOM了。

    

      
begin;
insert into t1 values (xxx); /* 1 */
insert into t1 values (xxx); /* 2 */
insert into t1 values (xxx); /* 3 */
....
insert into t1 values (xxx); /* 1000000 */
end;

    

    

      
bug 修复

    

    
像 Query_log_event::do_apply_event() 在结束会调用free_root，来释放thd->mem_root空间，而Rows_log_event::do_apply_event()却不能这样干，因为在下面的场景下，用户的线程会调用 Rows_log_event::do_apply_event()

    
mysqlbinlog mysql-bin.00000x | mysql -hxxxx -Pxx -u

    
如果在中间释放用户线程的thd->mem_root的话，会有问题。

    
因此官方的修复方法是在Log_event类构造函数初始化一个属于log_event的 mem_root

    

      
Log_event::Log_event()
    init_sql_alloc(PSI_INSTRUMENT_ME, &m_event_mem_root, 4096, 0);

    

    
在析构函数里释放

    

      
virtual ~Log_event()
    free_root(&m_event_mem_root, MYF(MY_KEEP_PREALLOC));

    

    
然后把Rows_log_event::do_apply_event()本来从thd->mem_root申请的内存改为从自身的 m_event_mem_root 申请，这样每个event应用完，被delete时其转化过程中申请的内存也一并被释放，避免了OOM的产生。

  

  

    

    

    
Test Book

  

  

    

      
现象

    

    
　　5.6版本，在创建InnoDB表过程中，若发生crash，会导致服务无法启动。

    

      
背景

    

    
　　每个InnoDB表A创建成功后有两个文件A.frm和A.ibd。建表流程如下：

    
　　1、创建A.frm

    
　　2、创建A.ibd

    
　　3、初始化A.ibd

    
　　4、将表A加入InnoDB字典

    
　　若crash发生在步骤2之后，则只保留一个完整的A.frm和一个空文件A.idb。

    

      
崩溃恢复

    

    
　　在上述的crash发生后，下一次启动则需要做崩溃恢复。崩溃恢复的一个逻辑是需要遍历数据目录下的所有.ibd文件，验证文件与字典的一致性。

    
　　对于长度为0的.ibd 文件，报错并跳过，继续检测下一个表。

    
　　以上是5.5和5.6共有的逻辑。但5.6的一个新特性破坏了这个规则。

    

      
远程目录

    

    
　　5.6支持create table的时候指定其他目录。语法是create table 里新增参数DATA DIRECTORY.这样一个表就可能存在多个表空间。每个表空间对应一个数据结构(fsp_open_info).

    
　　这意味着在崩溃恢复过程中，需要验证哪一个表空间是可用的(fil_validate_single_table_tablespace)，

    
　　验证的方法是尝试读取该表空间的第一个page，若可用则将对应的fsp_open_info::success设置为TRUE。

    
　　而在读取本地默认表空间的第一个页时，若碰到读取失败，直接exit(1)，导致程序直接退出。“若文件小于4个page就报错”的逻辑，是在这个exit之后。

    

      
分析改进

    

    
　　其实在这个场景下，多出来的A.frm和A.ibd并不会导致系统严重问题。由于表A还没有记录入系统字典，实际上只需要将这两个文件直接删掉即可。

    
　　因此5.6的这个新增要求过于苛刻。改进方法是将文件大小的判断提前，若发现小于4个page，则直接报错跳过这个表。

  

  

    

    

    
Test Book

  

  

    

      
提要

    

    
相对于纳秒级的内存访问延时，普通的机械盘达到了毫秒级的随机访问延时，对于OLTP应用来说，物理IO绝对是目前数据库管理系统的最大性能杀手，所以增加内存的大小，提高IO的命中率无疑可以作为一种降低时延的常用优化手段。

    
针对使用InnoDB引擎的MySQL实例来说，增加buffer pool的大小，尽可能的提高buffer pool的命中率，减少物理IO的概率，能极大的提升系统的吞吐量。

    
但是，随着内存越来越大，面临着一个很严重的问题：当内存突然失效，或者实例异常crash后，面对相同的请求压力，或者突然的大压力，系统由于内存未命中会耗尽IO资源，并导致request响应变慢，形成雪崩效应。

    

      
Warmup特性

    

    
MySQL 5.6 Innodb提供了warmup的功能，并增加了三个控制参数：

    
innodb_buffer_pool_dump_at_shutdown

    
innodb_buffer_pool_filename

    
innodb_buffer_pool_load_at_startup

    

      
工作原理

    

    
InnoDB启动一个后台线程，等待一个条件变量：

    
1. 当系统shutdown的时候，如果innodb_buffer_pool_dump_at_shutdown=on，系统会notify condition，从buffer pool的LRU链表中，读取spaceid+page_no到innodb_buffer_pool_file文件中，然后正常关闭。

    
2. 当系统startup的时候，如果innodb_buffer_pool_load_at_startup=on，并且存在innodb_buffer_pool_file，会读取元信息，进行异步IO读取数据加载到buffer pool中。

    
3. 为了防止系统运行过久，innodb_buffer_pool_file过时，无法反映当前热点数据的情况，InnoDB又提供了一个innodb_buffer_pool_dump_now参数，set后会即时进行一次dump，覆盖掉老的文件。

    

      
那么问题来了

    

    
1. Warmup是否影响startup的速度：

    
不影响.启动的时候，读取innodb_buffer_pool_file, 排序后，进行异步IO，不影响startup的速度。但现实的情况是：如果你是在业务高峰期出现crash，其实对于系统来说，先warmup后，再开放提供服务，更合适。

    
2. 异常crash的时候，使用过时的元数据：

    
如果异常crash，那么就存在过时的innodb_buffer_pool_file，如果想避免这种情况，系统可以每隔一段时间，进行一次dump。

    
3. dump是否导致系统抖动

    
dump的过程，会持有mutex，扫描LRU链表，读取元数据，如果在系统业务高峰期，可能会产生抖动。

    

      
改进

    

    
MySQL 5.7 又增强了warmup功能的使用：

    
1. 新增参数innodb_buffer_pool_dump_pct

    
当前InnoDB的buffer pool可能设置的比较大，可以通过设置dump的比例，控制dump的速度和load时的量。

    
2. innodb_io_capacity

    
控制load过程中，防止过量使用IO资源，如果单机多实例的情况下，同时启动实例，会使IO过载。

  

  

    

    

    
Test Book

  

  

    

      
提要

    

    
长久以来，server层和InnoDB层都保存了表的元数据，server使用frm文件保存了column，data_types等信息，而InnoDB使用data dictionary来保存meta data。

    
由于server层使用文件系统，而InnoDB使用事务引擎，所以经常会存在两者不一致的情况，比如：

    
create table的过程中实例crash

    
alter table过程中实例crash

    
具体可以参见： 

http://dev.mysql.com/doc/refman/5.6/en/innodb-troubleshooting-datadict.html
 包括相关的解决方法。

    

      
改进

    

    
MySQL 后续的版本准备做相关的改进：

    
1. 使用native InnoDB-based Data Dictionary保存meta data，不再需要frm文件

    
2. 使用InnoDB引擎保存MySQL的系统表，比如privileges和timezones相关的表

    
使用new Data Dictionary，去掉frm文件，目前还在MySQL lab版本中。

    
而在MySQL 5.7的版本中，以下的系统表已不再使用MyISAM，而使用InnoDB引擎保存数据：

    

      
 - help_category
 - help_keyword
 - help_relation
 - help_topic
 - time_zone
 - time_zone_leap_second
 - time_zone_name
 - time_zone_transition,
 - time_zone_transition_type

    

    

      
变化

    

    
1. 由于使用具有ACID特性的InnoDB引擎，由crash导致的元数据不一致情况将不再出现。

    
2. 对于information_schema中元数据的查询，系统将暴露一个基表上的view出来，供查询。

    
3. 由于使用InnoDB引擎来保存数据，--skip-innodb的参数将不再有意义，5.7版本中做删除处理。

    

      
问题

    

    
1. 系统表切换到InnoDB引擎上，对于版本升级或者降级需要对脚本特殊处理。

    
2. 去掉frm文件，系统如何平滑的进行升级？

    
3. 第三方引擎怎么办？oracle后续的打算是如何？这是一个很大的问题。

    
由于去掉frm文件使用native InnoDB-based Data Dictionary的特性还在lab环境中酝酿，期待中。

    
无论如何，提升failure recovery的水平，对于使用者来说，终归是好事情！

  

  

    

    

    
Test Book

  

  

    
MariaDB 10.1版本中新增加了一个 ANALYZE statement 命令。这个命令跟 EXPLAIN statement 命令类似，但不同的是， ANALYZE statement 命令调用优化器生成执行计划并且会真实的去执行语句，再用 EXPLAIN 的输出来替代结果集，并且 EXPLAIN 结果是实际语句执行中统计出来的。

    
这个语句可以让你检查优化器估算的执行计划代价和实际执行差多少。

    

      
命令的输出

    

    

      
MariaDB> analyze select * from tbl1 where key1 between 10 and 200 and col1 like 'foo%'\G
*************************** 1\. row ***************************
          id: 1
 select_type: SIMPLE
       table: tbl1
        type: range
possible_keys: key1
         key: key1
     key_len: 5
         ref: NULL
        rows: 181
      r_rows: 181
    filtered: 100.00
  r_filtered: 10.50
       Extra: Using index condition; Using where

    

    
我们可以看到 ANALYZE 命令多了r_rows和r_filterd两行，我们来比较一下 EXPLAIN 计算的 rows/filtered 和 ANALYZE 计算的 r_rows/r_filtered 两列的区别。

    
r_rows 是基于实际观察的 rows 列，它表示实际从表中读取了多少行数据。

    
r_filtered 是基于实际观察的 filtered 列，它表示经过应用WHERE条件之后还有百分之多少的数据剩余。

    

      
输出结果解析

    

    
让我们来看一个更复杂的SQL。

    

      
analyze select * 
from orders, customer 
where 
  customer.c_custkey=orders.o_custkey and 
  customer.c_acctbal < 0 and 
  orders.o_totalprice > 200*1000

    

    

      
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
| id | select_type | table    | type | possible_keys | key         | key_len | ref                | rows   | r_rows | filtered | r_filtered | Extra       |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
|  1 | SIMPLE      | customer | ALL  | PRIMARY,...   | NULL        | NULL    | NULL               | 149095 | 150000 |    18.08 |       9.13 | Using where |
|  1 | SIMPLE      | orders   | ref  | i_o_custkey   | i_o_custkey | 5       | customer.c_custkey |      7 |     10 |   100.00 |      30.03 | Using where |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+

    

    
从上面的结果，我们可以获得如下信息：

    
对于 customer 表，customer.rows=149095, customer.r_rows=150000. 从这两个值来看，优化器对 customer 表的访问估算还是很准确的。

    
customer.filtered=18.08, customer.r_filtered=9.13. 优化器有点高估了
customer
 表所匹配的记录的条数。（一般来说，当你有个全表扫描，并且 r_filtered 少于15%的时候，你得考虑为表增加相应的索引了）

    
orders.filtered=100, orders.r_filtered=30.03. 优化器无法预估经过条件（orders.o_totalprice > 200*1000）检查后还剩多少比例的记录。因此，优化器显示了100%。事实上，这个值是30%，通常来说30%的过滤性并不值得去建一个索引。但是对于多表Join，采集和使用列统计信息也许对查询有帮助，也可能帮助优化器选择更好的执行计划。（因为在关联中，关联条件和普通过滤条件组合以后，可能过滤性会非常好，并且有助于优化器判断哪张表做驱动表比较好）

    
然后我们再把前面的例子稍微修改一下

    

      
analyze select * 
from orders, customer 
where 
  customer.c_custkey=orders.o_custkey and 
  customer.c_acctbal < -0 and customer.c_comment like '%foo%'
  orders.o_totalprice > 200*1000
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
| id | select_type | table    | type | possible_keys | key         | key_len | ref                | rows   | r_rows | filtered | r_filtered | Extra       |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
|  1 | SIMPLE      | customer | ALL  | PRIMARY,...   | NULL        | NULL    | NULL               | 149095 | 150000 |    18.08 |       0.00 | Using where |
|  1 | SIMPLE      | orders   | ref  | i_o_custkey   | i_o_custkey | 5       | customer.c_custkey |      7 |   NULL |   100.00 |       NULL | Using where |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+

    

    
这里我们可以看到 orders.r_rows=NULL，以及 orders.r_filtered=NULL。这意味着 orders 表连一次都没有被扫描到。

  

  

    

    

    
Test Book

  

  

    
尽管MySQL 5.6和MariaDB 10.x在replication上已经做了不少优化，TokuDB 7.5也做了一个＂进一步＂的优化：Read Free Replication(RFR)，目的是提高备库(slave)重放速度，减少主备延迟。

    
RFR的原理比较简单：就是避免一些＂不必要＂的读来减少read IO。

    

      
Read IO

    

    
当在slave上执行：UPDATE/DELETE操作的时候，MySQL进行read-modify-write操作，可能会产生read IO操作，而INSERT的时候如果需要做＂唯一性＂检查，也可能会产生read IO。

    
什么条件下，TokuDB才可以read free呢？

    

      
主库配置必须BINLOG_FORMAT=ROW

      
主库上的操作不能违反唯一性约束（比如设置了＂unique_checks=OFF＂，否则主备同步会停止），这样到TokuDB备库的所有log event都默认不需要再做＂unique check＂

      
备库只读

    

    
同时满足以上3个条件，TokuDB的备库认为从主库过来的INSERT/UPDATE/DELETE log event均是安全的，可以不做read，直接做write操作。

    
从
TokuDB官方测试
看效果还是不错的，主库~140TPS，备库~70TPS，当开启RFR的时候，备库可以飚到1400TPS，随后与主库基本持平。

    
进一步的优化还在继续，希望＂妈妈＂(DBA)再也不用担心我(read only slave)的性能了。

    

      

        

      

    

  

  

    

    

    
Test Book

  

  

    
TokuDB除了有着较好的写性能外，还有一个重要的特性：压缩，而且大部分情况下压缩效果很不错。

    
目前TokuDB有４种压缩算法：

    

      
tokudb_lzma:    压缩比高，CPU消耗也高
tokudb_zlib:    压缩比和CPU消耗持中(默认压缩算法)
tokudb_quicklz:    压缩比低，CPU消耗低
tokudb_uncompressed:无压缩

    

    
使用上也比较简单：

    

      
MariaDB:
CREATE TABLE `t_quicklz` (
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL
) ENGINE=TokuDB `compression`='tokudb_quicklz'

    

    

      
MySQL(Percona Server):
CREATE TABLE `t_quicklz` (
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1 ROW_FORMAT=TOKUDB_QUICKLZ

    

    
可能大家会有一个疑问：如果一个表创建的时候压缩算法是tokudb_quicklz，我可以通过ALERT TABLE改成其他算法吗？答案是：可以的！

    
TokuDB在底层实现上，用1byte来标记当前block的压缩算法，并持久化到磁盘，当压缩算法改变后，从磁盘读取数据然后解压缩的代码类似：

    

      
 switch (block_buffer[0] & 0xF) {
    case TOKU_NO_COMPRESSION:
        ...
        break;

    case TOKU_ZLIB_METHOD:
        ...
        break;

    case TOKU_QUICKLZ_METHOD:
        ...
        break;
    case TOKU_LZMA_METHOD:
        ...
        break;
｝

    

    
是不是很机智？

    
在使用TokuDB的过程中，一般不会改变压缩算法，除非默认的tokudb_zlib不给力，TokuDB是大block(4MB)，压缩效果较好，enjoy~

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    

      
描述

    

    
　　这是一个MySQL 5.6才有的bug，影响包含最新版本。涉及到的概念有GTID、DELAYED。

    

      
现象

    

    
　　在5.6主备都开启GTID-MODE的时候，备库同步线程停止，且Last_SQL_Error显示“When @@SESSION.GTID_NEXT is set to a GTID, you must explicitly set it to a different value after a COMMIT or ROLLBACK. Please check GTID_NEXT variable manual page for detailed explanation. Current @@SESSION.GTID_NEXT is ... ” 　　

    
　　查到这个位置正在执行的日志是一个INSERT语句，并且主库上使用的语法是 INSERT DELAYED INTO。 　　

    

      
GTID限制

    

    
　　众所周知，在打开gtid-mode的时候，MySQL不允许执行create table xx as select ... 这个语句。其原因是每个GTID编号(gno)需要唯一对应一个事务，而在ROW格式binlog模式下，上述语句会被写成一个create语句和一个insert事务。这样违背唯一对应约束。

    

      
关于DELAYED

    

    
　　往数据库里插入数据的标准命令是INSERT，而DELAYED的意思，则是异步插入。也就是说，MySQL接受这个命令后，保存命令就直接返回给客户端，因此用户会发现在某些场景下INSERT DELAYED性能优于”INSERT，实际上只是更快的返回，而非更快的完成。

    
　　既然执行线程已经返回给用户，那么这个INSERT任务就是由一个后台线程执行的。这里有一个优化：执行线程每次循环获取现有的任务列表，多个一起执行。

    
　　这样就可能连续执行N个INSER操作，生成多个INSERT事件。而在生成GTID时，就只对应一个gno。

    
　　这就违反了上一节提到的GTID限制。

    
　　这个binlog传到备库后，备库在执行完这个gno对应的第一个事件后，操作表是一个MyISAM表（DELAYED语法只MyISAM引擎支持），自动提交事务，在执行下一个事务时，发现“少了”新的gno，因此报错。

    

      
分析修复

    

    
　　上述bug的根本原因是DELAYED语法生成了违反GTID限制的binlog。实际上这个语法应该也设定为：在GTID模式下禁止。

    
　　若从减少应用的报错考虑，另一种修复策略是在GTID模式下，自动将INSERT DELAYED转为INSERT。

    

      
DELAYED相关

    

    
　　a) InnoDB不支持DELAYED语法，因为这破坏了事务的原子性和可见性。

    
　　b) 即使对于MyISAM，官方已经将DELAYED语法在5.6列为deprecated, 在5.7取消。

    
　　c) 目前能够使用DELAYED的语法有 INSERT DELAYED 和 REPLACE DELAYED。

    
　　d) DELAYED 命令统一使用ROW格式binlog。

  

  

    

    

    
Test Book

  

  

    

      
GTID 资料

    

    
MySQL 5.6 引入了global transaction identifiers (GTIDs，全局事务ID)的特性，这一特性是用来解决主从复制(replication)场景下的一些问题，GTID 只存在于 binlog 中，数据库中是没有的。

    
要了解 GTID 的话，
官方文档
是一定要看的，另外再推荐推荐三篇 Oracle 同学写的文章(需爬墙)：

    

      

        
Failover and Flexible Replication Topologies in MySQL 5.6

      

      

        
Advanced use of Global Transaction Identifiers

      

      

        
Flexible Fail-over Policies Using MySQL and Global Transaction Identifiers

      

      
有兴趣的话也可以看下 GTID 的 worklog 
WL#3548

    

    

      
升级遇到的问题

    

    
GTID 能很好的解决 failover 问题，做到主库切换自动化，减轻 DBA 同学的负担，但是这个前提是所有的 MySQL 实例都是 5.6，如果线上实例是 5.5 的，必须全部升到 5.6 才行，而目前官方并没有提供平滑的 5.5 升级到 5.6 GTID 的方式，中间必须要有一个实例重启过程，这是由 GTID 目前的实现方式决定的：

    

      
限制1. GTID 模式实例和非GTID模式实例是不能进行复制的，要求非常严格，一刀切，要么都是GTID，要么都不是

      
限制2. gtid_mode 是只读的，要改变状态必须1)关闭实例、2)修改配置文件、3) 重启实例

    

    
在这种条件要求下，我们来看下线上实例从 5.5 升级到 5.6 会有什么问题，为了保证业务不中断，升级过程一直要有实例对外提供服务，因此升级方式是创建一个新的 5.6 实例，从5.5同步数据，然后业务切换到 5.6。

    
为了描述方便，做如下假设：

    
实例A

    
5.5 版本的，目前业务用的数据库

    
实例B

    
5.6 版本的，数据迁移的目标

    
迁移步骤如下：

    

      
用热备份工具如 Percona XtraBackup 将 A 数据备份然后导入到B

      
B 用非 GTID 模式和 5.5 同步数据，这时用的是传统的基于文件位置的复制

      
B和A同步的差不多的时候，在 A 上设 read_only，等 B 同步完成，假设同步完后时间点为 t1

      
关闭 B，修改参数开启GTID，重启B

      
将业务的数据操作指向B，假设这个时间点为 t2

      
B 开始提供服务，迁移完毕

    

    
在上面的步骤中，t1 到 t2 的时间段内相当于数据库服务不可用，整个数据库停掉重启，这对线上业务来说是不可接受的，上面是用单个实例A和实例B说明问题，同样可以扩展到集群A和集群B。

    
gtid_mode 的取值范围除了 OFF 和 ON 这两个值外，还有 UPGRADE_STEP_1和UPGRADE_STEP_2，目前后2者并不支持，不过从名字上看应该是为了升级预留的，但是目前并没有好的升级方式。

    

      
解决方案

    

    
如果要想做到不重启升级，必须打破之前提到限制条件，booking.com 提供了一种方案，就是打破限制1，创造出一种特殊的模式，使实例处于GTID模式下仍然可以和非GTID的实例进行复制。 详细的方案介绍在这里
MySQL 5.6 GTIDs: Evaluation and Online Migration
，代码的改动很小，就是让 sql/rpl_slave.cc 中的下面这段检查代码无效：

    

      
if (mi->master_gtid_mode > gtid_mode + 1 ||
    gtid_mode > mi->master_gtid_mode + 1)
{
  mi->report(ERROR_LEVEL, ER_SLAVE_FATAL_ERROR,
             "The slave IO thread stops because the master has "
             "@@GLOBAL.GTID_MODE %s and this server has "
             "@@GLOBAL.GTID_MODE %s",
             gtid_mode_names[mi->master_gtid_mode],
             gtid_mode_names[gtid_mode]);
  DBUG_RETURN(1);
}

    

    
之前的升级方式是 A->B 这种拓扑，现在变为 A->C->B

    
实例A

    
5.5 版本的，目前业务用的数据库

    
实例C

    
5.6 版本的，一种中间状态实例，既可以和非GTID通信，又可以和GTID通信

    
实例B

    
5.6 版本的，数据迁移的目标

    
迁移步骤如下：

    

      
用热备份工具如 Percona XtraBackup 将 A 数据备份然后导入到B

      
建立 A->C->B 这种复制关系，其中 A->C 之间是文件位置协议，C->B 之间是 GTID 协议

      
B、C和A同步的差不多的时候，在 A 上设 read_only，等B同步完成

      
将业务的数据操作指向B

      
B 开始提供服务，迁移完毕

    

    
这里为了和之前迁移目标一致，多用了一个实例C，其实这时候可以把B给去掉，还是2个实例。可以看到，引入了C后，升级过程中并没有实例重启过程，只有一个短暂的只读时间段，这个是无法避免的，即使不用GTID，也会有这个过程。

    
目前RDS实例升级到5.6也是用这种方式。如果是集群到集群的话，要注意一点，处于中间状态的实例C最好只有一个，因为这种实例相当于一个GTID转换器，将A中没有 GTID 的 binlog 转成包含 GTID 的 binlog，然后传给B，如果有多个实例C的话，A中同一个binlog 中的事务会转换出不同的GTID，这与 GTID 和事务一一对应的根本原则相矛盾，复制会出问题。当然，如果能保证经过不同的C的binlog事务不会重复的话就可以有多个C。

  

  

    

    

    
Test Book

  

  

    

      
现象描述

    

    
　　在5.6主备环境下，主备都开启GTID-MODE，备库开启crc校验，主库不开。重启备库sql线程后，备库sql线程停止Last_Error显示：Relay log read failure: Could not parse relay log event entry. 

The possible reasons are: the master's binary log is corrupted

(you can check this by running 'mysqlbinlog' on the binary log), 

the slave's relay log is corrupted

 (you can check this by running 'mysqlbinlog' on the relay log), a network problem, or a bug in the master's or slave's MySQL code. If you want to check the master's binary log or slave's relay log, you will be able to know their names by issuing 'SHOW SLAVE STATUS' on this slave.

    
　　从错误信息可以看出，可能是主库的binlog或备库的relaylog出错。

    

      
关于GTIDs

    

    
　　详见上一章节：MySQL·　限制改进·GTID和升级

    

      
binlog头部信息

    

    
　　FORMAT_DESCRIPTION：binlog格式信息，备库解析binlog的标准。

    
　　PREVIOUS_GTIDS_LOG：已产生的GTID集合，防止重复记录binlog。

    
　　ROTATE：备库binlog切换到主库binlog的转换标志。

    

      
PREVIOUS_GTIDS_LOG

    

    
　　开启GTID_MODE时，每个binlog文件的头部会有一个PREVIOUS_GTIDS_LOG，用于保存已产生的GTID。MySQL源码中的Gtid_set类用于实现这个功能，内部由链表实现，链表的每个节点保存了一个区间，用于指代一段连续的GNO。

    

      
分析和修复

    

    
　　在上述环境下，备库relay log的前几条应该是：

    

      
   FORMAT_DESCRIPTION_EVENT (of slave)
   PREVIOUS_GTIDS_LOG_EVENT (of slave)
   ROTATE_EVENT             (of master)
   FORMAT_DESCRIPTION_EVENT (of master)

    

    
　　之前备库选取FORMAT 的策略是：先根据文件头备库的FORMAT_DESCRIPTION_EVENT确定FORMAT，然后继续向下读；

    
　　如果读到FORMAT_DESCRIPTION_EVENT，则更新FORMAT；如果读到ROTATE_EVENT，则继续向下读；

    
　　如果读到一条非FORMAT_DESCRIPTION_EVENT或ROTATE_EVENT的log，则停止更新FORMAT，选取当前FORMAT解析后面的log。

    
　　由备库前几条relay log可知，读到第二条PREVIOUS_GTIDS_LOG_EVENT时，已由备库的FORMAT_DESCRIPTION_EVENT确定FORMAT(binlog_checksum=on)，而略过主库的FORMAT_DESCRIPTION_EVENT。

    
　　到下面解析log时，会认为每条log尾部有crc校验信息。但校验信息实际是不存在的，所以会报crc校验的错误。

    
　　当读到PREVIOUS_GTIDS_LOG_EVENT时继续向下读，即可读到主库的FORMAT_DESCRIPTION_EVENT，解决这个bug。

    

      
其他复现场景

    

    
　　5.5/5.1会作为5.6的主库，此时备库开启GTID-MODE和crc校验。若中间出现主键冲突等错误，sql thread暂停后， 执行start slave，会报错 "Event crc check failed"。原因是5.5/5.1不支持crc校验，和5.6不开启crc校验相似。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
　　在MySQL数据库中，我们利用show table status命令可以得到表的状态信息，其中一列信息为create_time，表示表的创建时间。对于不同的存储引擎（如InnoDB/MyISAM/MEMORY）我们都能得到create_time的数值。我们知道不同的存储引擎表的文件结构是不同的，因此实现表的创建时间create_time的机制也是不同的。下面着重探讨InnoDB和MyISAM在create_time上的区别。

    

      
实验

    

    
　　我们先做一些实验来看看create_time的特点。在InnoDB引擎下创建一个表：

    

      
    CREATE TABLE `tb` (
       `seq_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
       `a` varchar(32) DEFAULT NULL,
       `b` varchar(32) DEFAULT NULL,
       `c` varchar(32) DEFAULT NULL,
       `d` char(255) DEFAULT NULL,
       Primary key (seq_id),
       KEY a (a),
       KEY bc (b,c),
       KEY cb (c,b)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    

    
　　在MyISAM引擎下也创建结构相同的一个表，如何可以更新create_time呢？我们在表上做以下3种操作，观察create_time的变化。

    
　　1. 对表进行增删改查操作，InnoDB、MyISAM的create_time不变。

    
　　2. 对表进行alter table add column e varchar(32)，InnoDB、MyISAM的create_time都更新到当前时间。

    
　　3. 对表进行truncate table tb，InnoDB的create_time不变、MyISAM的create_time更新到当前时间。

    
　　通过这些操作我们发现虽然2种引擎的内部实现不同，但前2种操作的现象是一样的。对表进行增删改查并不重建表，因此create_time没有更新。而alter table会更新create_time的原因是新建了一个原表的副本，在副本上实现alter table的功能（增加新列等等），最后删除原表，用副本替代原表。因此alter table下create_time是原表副本的创建时间。

    
　　第3种操作，两者的现象不同，这是为什么呢？我们从代码实现上分析原因。

    

      
show table status的create_time的实现

    

    
1.InnoDB

    
　　在InnoDB下执行show table status获得create_time来自于代码：

    

      
    ./storage/innobase/handler/ha_innodb.cc：
    ...
    if (os_file_get_status(path,&stat_info)) {
        stats.create_time = (ulong) stat_info.ctime;
    }
    ...

    

    
　　stats.create_time最终来自于以下代码的statinfo变量：

    

      
    ./storage/innobase/os/os0file.c：
    ...
    ret = stat(path, &statinfo);
    ...

    

    
　　stat为C语言的库函数，含义是将文件路径path定位的文件（TABLENAME.frm）的状态信息（包括了创建时间create_time）存入statinfo。

    
　　通过对源码的分析，我们知道在InnoDB引擎，create_time来源于.frm文件的创建日期。在truncate table之后，InnoDB并没有重建.frm文件，因此show table status的create_time不变。

    
2. MyISAM下

    
　　在MyISAM下执行show table status获得create_time来自于代码：

    

      
    ./storage/myisam/ha_myisam.cc:
    ...
    stats.create_time= (ulong) misam_info.create_time;
    ...

    

    
　　对应的misam_info.create_time来源于:

    

      
    ./storage/myisam/mi_open.c:
    ...
    mi_state_info_read(disk_cache, &share->state);
    ...

    

    
　　即MyISAM通过读.MYI文件来获得state信息（包含了create_time)，也就是说MyISAM下show table status的create_time最终来源于MYI文件中的state信息。

    
　　在MyISAM下，创建表(create table..)的create_time来源于以下代码：

    

      
    ./storage/myisam/mi_create.c：
    ...
    if (! (flags & HA_DONT_TOUCH_DATA))
       share.state.create_time= (long) time((time_t*) 0);
    ...

    

    
　　MyISAM下的create_time来源于share变量，每次执行这部分代码都会更新share.state.create_time。share是MyISAM引擎下的全局信息，share.state区间信息包含了键和数据文件长度、时间戳（即create_time）和打开表的次数等等参数。share.state会记入MYI文件，代码如下：

    

      
    ./storage/myisam/mi_create.c：
    ...
    DBUG_PRINT("info", ("write state info and base info"));
    if (mi_state_info_write(file, &share.state, 2) ||
       mi_base_info_write(file, &share.base))
      goto err;
    ...

    

    
　　执行truncate table也会经过以上2处的代码，更新.MYI文件的state区间的信息，然后show table status时读入.MYI文件最新的state信息（包含了create_time），因此create_time会被更新。

  

  

    

    

    
Test Book

  

  

    

      
提要

    

    
　　thread_concurrency参数用于向操作系统建议期望的并发线程数，参数在mysqld启动的时候使用。但MySQL 5.6 从源码中删除了这个参数，不再使用。

    

      
参数背景

    

    
　　源码：

    

      
 #ifndef HAVE_THR_SETCONCURRENCY
 #define thr_setconcurrency(A) pthread_dummy(0)
 #endif

 mysqld_main
 {
   (void) thr_setconcurrency(concurrency);    // 10 by default
   ......
 }

    

    
　　可以看到thread_concurrency的限制：

    
1. thread_concurrency不能用在GNU/Linux平台上，而只能在old Solaris versions

    
2. OS层面只提供了hint建议，并不能提供足够的信息，控制和诊断都不够灵活。

    
3. OS无法获得MySQL层面提供的所有线程的状态，包括语句的执行，阻塞，当前事务状态等信息，所以OS终究不能根据事务型软件系统量身定制并发控制。

    
　　一句话，OS层面无法把并发控制做精细，所以放弃使用。

    
　　那么并发控制究竟在什么地方进行控制最好，控制为多少合适呢?

    

      
并发控制

    

    
　　
并发控制点：

    
并发控制的目的是最大化提高系统的资源利用率，并减少管理和调度开销。在MySQL实例中，主要处理sql请求，所以期望系统资源最大化提供给sql的执行过程。

    
　　sql的执行牵涉到server层和引擎层：

    
1. server层：比如cost计算，生成sql执行计划的过程

    
2. Innodb层：比如根据执行计划，查找和更新数据page的过程

    
　　所以在MySQL实例中，有两个最佳的并发控制点：

    
1. server层：sql开始执行时。 MySQL在5.6后，在server层引入了thread pool进行并发控制

    
2. Innodb层：记录查找和记录更新时。 Innodb存储引擎，使用innodb_thread_concurrency参数进行并发控制

    
　　
并发控制大小：

    
设置过大：造成系统调度消耗过大

    
设置过小：不能完全的使用系统资源，造成资源浪费

    
　　经验值：# Try number of CPU's*2 for thread_concurrency

    
　　但还需要配合具体的平台和业务系统进行测试，才能找到最佳值。

    

      
Innodb并发控制

    

    
　　Innodb使用参数innodb_thread_concurrency控制并发线程的个数，源码中使用一对函数：

    
innodb_srv_conc_enter_innodb

    
innodb_srv_conc_exit_innodb

    
　　Innodb实现语句级的并发控制，在语句执行结束，stmt commit的时候，强制释放资源。

    

      
权衡和优化

    

    
1. 一方面进行并发控制，提高资源利用率，

    
2. 另一方还需要控制调度公平，防饿死等。

    
　　Innodb引入了n_tickets_to_enter_innodb参数，sql进入innodb执行时进行初始化，默认值500。

    
　　在执行过程中，依次进行递减，递减到0时，强制退出并发线程，重新抢占。

    
　　好处：

    
1. 一方面单条sql可能写入或者更新多条记录，节省每次enter innodb的线程抢占代价。

    
2. 另一方面防止单条sql过多的长时间占用并发线程，导致其它线程饿死的情况。

  

  

    

    

    
Test Book

  

  

    

      
背景：

    

    
　　Innodb引擎使用B_tree结构保存表数据，这样就需要一个唯一键表示每一行记录(比如二级索引记录引用)。

    
　　Innodb表定义中处理主键的逻辑是：

    
　　1.如果表定义了主键，就使用主键唯一定位一条记录

    
　　2.如果没有定义主键，Innodb就生成一个全局唯一的rowid来定位一条记录

    

      
auto_increment的由来:

    

    
　　1.Innodb强烈推荐在设计表中自定义一个主键，因为rowid是全局唯一的，所以如果有很多表没有定义主键，就会在生成rowid上产生争用。

    

      
      /* Dictionary system struct */
      struct dict_sys_struct{
      mutex_t    mutex;
      row_id_t    row_id;
      ......
      }

    

    
　　row_id由mutex保护，并在每次checkpoint的时候，写入到数据字典的文件头。

    
　　2.当用户自定义了主键后，由于大部分实际应用部署的分布式，所以主键值的生成上，采用集中式的方式，更容易实现唯一性，所以auto_increment非常合适。

    
　　auto_increment也带来两个好处：

    
　　1. auto_increment的值是表级别的，不会在db级别上产生争用

    
　　2. 由于auto_increment的顺序性，减少了随机读的可能，保证了写入的page的缓冲命中。（不可否认，写入的并发足够大时，会产生热点块的争用）

    

      
auto_increment引起的bug：

    

    
　　环境：MySQL 5.6.16版本, binlog_format=row

    
　　case复现：

    

      
     create table test.kkk ( c int(11) default null, id int(11) not null auto_increment, d int(11) default null, primary key (id), unique key d (d) )
     engine=innodb default charset=latin1;
     insert into test.kkk values(5, 27,4);
     replace into test.kkk(c, id, d) values(6, 35, 4);
     commit;    

    

    

      
     show create table时：
     主库：auto_increment=36
     备库：auto_increment=28

    

    
　　当进行主备切换后，导致主键冲突，slave恢复异常。

    
　　同样insert on duplication update 语句同样存在这样的问题。

    

      
aliyun rds分支bug修复

    

    
　　
问题的原因：
Innodb对于auto_increment的处理，当语句是insert时，会进行递增，而update，delete语句则不更新。

    
　　当replace语句在主库的执行时：

    
　　1. 先按照insert语句执行，发现uk冲突。

    
　　2. 演变成update语句进行更新。

    
　　这样在主库，虽然insert失败，但auto_increment也递增上去了。但到备库，row格式下，只产生了一个update row event，

    
　　备库无法知道主库是一个replace语句，而且insert还失败了， 所以auto_increment在备库没有递增。

    
　　
修复方式：
在备库，对于update进行auto_increment递增，可能会产生副作用，即auto_increment的浪费，但不会产生主键冲突。

    

      
那些年经历的auto_increment坑：

    

    
　　1. 实例重启，主键冲突：

    
　　内存中的autoinc值，在系统重启后，使用select max(id) from table来初始化。所以，如果你设计的业务表，存在delete操作，那么一旦你的实例crash过，重启后，可能会复用以前使用过的id值。如果你需要持续对这个表进行逻辑备份，那么就可能会碰到主键冲突的问题。

    
　　2. load file阻塞：

    
　　在设置innodb_autoinc_lock_mode=1的时候，MySQL为了维护单个statement语句的id连续性，当不确定插入条数的时候，会在语句整个执行过程中

    
　　持有LOCK_AUTO_INC, /
 locks the auto-inc counter of a table in an exclusive mode 
/

    
　　这个锁是表级别的，使用互斥模式。

    
　　所以，在繁忙的表上，如果要导入数据，小心可能阻塞正常的业务写入，并发写入在这个时候也会阻塞的。

  

  

    

    

    
Test Book

  

  

    
MariaDB 10.0.8增加了一种新的执行计划——Extended Keys。

    
它充分利用了InnoDB的隐藏列来做执行计划，因为我们都知道InnoDB的索引组织表会把主键放在最末尾，所以实际上每个索引最后都包含了主键。

    
打开和关闭这个优化器选项的命令如下：

    
Enable:

    

      
  set optimizer_switch='extended_keys=on';

    

    
Disable:

    

      
 set optimizer_switch='extended_keys=off';

    

    
MariaDB 10.0.8中默认选项是 'extended_keys=off'. MariaDB 10.0.9开始默认选项是 'extended_keys=on'.

    
看一个例子：

    
有一个DBT-3/TPC-H 测试中用到的SQL如下

    

      
 select o_orderkey
 from part, lineitem, orders
 where p_retailprice > 2095 and o_orderdate='1992-07-01'
       and o_orderkey=l_orderkey and p_partkey=l_partkey;

    

    
这个查询是寻找发生在1992-07-01 并且零售价格高于2095的orderkeys.

    
通过 Extended Keys, 这个查询可以通过下面的计划执行:

    
扫描i_p_retailprice索引获得p_retailprice>2095的行，再从 extended keys中读取p_partkey（主键）的值。 对于每一个p_partkey的值，通过对lineitem表的i_l_partkey索引扫描，从 extended index中获取l_orderkey（主键）。 对于每一个被选中的l_orderkey值，再通过i_o_orderdate索引去查找o_orderkey（主键）的值。 这种访问方式所有的访问数据都没有回表，所以性能好的多。

    
下面是执行计划:

    

      
 MariaDB [dbt3sf10]> explain
    -> select o_orderkey
    ->   from part, lineitem, orders
    ->   where p_retailprice > 2095 and o_orderdate='1992-07-01'
    ->         and o_orderkey=l_orderkey and p_partkey=l_partkey\G
 *************************** 1\. row ***************************
           id: 1
  select_type: SIMPLE
        table: part
         type: range
 possible_keys: PRIMARY,i_p_retailprice
          key: i_p_retailprice
      key_len: 9
          ref: NULL
         rows: 100
        Extra: Using where; Using index
 *************************** 2\. row ***************************
           id: 1
  select_type: SIMPLE
        table: lineitem
         type: ref
 possible_keys: PRIMARY,i_l_suppkey_partkey,i_l_partkey,i_l_orderkey,i_l_orderkey_quantity
          key: i_l_partkey
      key_len: 5
          ref: dbt3sf10.part.p_partkey
         rows: 15
        Extra: Using index
 *************************** 3\. row ***************************
           id: 1
  select_type: SIMPLE
        table: orders
         type: ref
 possible_keys: PRIMARY,i_o_orderdate
          key: i_o_orderdate
      key_len: 8
          ref: const,dbt3sf10.lineitem.l_orderkey
         rows: 1
        Extra: Using index
 3 rows in set (0.00 sec)

    

  

  

    

    

    
Test Book

  

  

    
MariaDB 10.0.8 版本增加了一个CREATE OR REPLACE TABLE语法，这个语法的目的是让Replication更加可靠，为什么这个语句能让复制更可靠呢？

    
例如用户使用CREATE ... SELECT语句，而这个语句回滚了又重新执行，备库有可能先收到一个CREATE语句，但是没收到INSERT的Events，主库重做一遍之后，备库收到CREATE语句时就会失败，而CREATE OR REPLACE则可以避免这个问题，存在的表会被替换掉。

    
最基本的使用例子：

    

      
 CREATE OR REPLACE TABLE table_name (a int);

    

    
这个语句其实等价于：

    

      
 DROP TABLE IF EXISTS table_name;
 CREATE TABLE table_name (a int);

    

    
这两个语句的执行结果。

    

      
如果 table_name被LOCK TABLES锁住了，CREATE OR REPLACE TABLE会忽略锁定，然后在语句执行完成后把新建的表加上锁定。

      
临时表只有在指定了TEMPORARY关键字时才会被DROP掉。（用DROP TABLE的话，同名的临时表会比普通表先被删除）

    

    
使用CREATE OR REPLACE TABL必须意识到的问题：

    

      
表会首先被DROP掉（如果这张表存在的话），然后CREATE动作才会执行。正是因为如此，如果CREATE步骤失败了，那么执行这个语句后表可能会不存在了。如果表是被LOCK TABLES锁住的，那么表的锁会被释放掉先。

      
OR REPLACE和IF EXISTS语句不可同时使用

      
Slave在复制中当CREATE语句没有使用IF EXISTS标识时，会默认使用CREATE OR REPLACE语句来执行。这个行为可以通过slave-ddl-exec-mode变量来改变，设置为STRICT则不会做这个替换。

    

    
相关的新增参数：

    
　slave_ddl_exec_mode

    
　描述: Slave控制如何执行DDL的Event的模式。可选值有STRICT、IDEMPOTENT (默认值)。

    
　　在 IDEMPOTENT 模式下，Slave不会因为那些不会导致主备不一致的DDL执行失败而停止。

    
　　尤其是CREATE TABLE 会被当做 CREATE OR REPLACE TABLE，而 DROP TABLE 会被当做DROP TABLE IF EXISTS.

    
　默认值: IDEMPOTENT

    
　可选值: IDEMPOTENT, STRICT

  

  

    

    

    
Test Book

  

  

    
TokuDB里可调优的参数不多，今天把＂最重要＂的几个拉出来晒晒。

    
与性能相关的参数及说明:

    

      
 tokudb_cache_size(bytes):
 缓存大小，读写时候，数据会首先会缓存到这里。
 默认大小为机器物理内存的一半。
 tokudb_commit_sync(ON/OFF):
 当事务提交的时候，是否要fsync log到磁盘。
 默认开启(ON)，如果设置为OFF，性能会提升，但可能会丢失事务(commit记录到log buffer，但是未fsync到磁盘的事务)。
 tokudb_directio(ON/OFF):
 是否开启Direct I/O功能，TokuDB在写盘的时候，无论是否开启Direct I/O，都是按照512字节对齐的。
 默认为OFF。
 tokudb_fsync_log_period(ms):
 多久fsync一下log buffer到磁盘，TokuDB的log buffer总大小为32MB且不可更改。
 默认为0ms(此时做fsync的后台线程一直处于wait状态)，此时受tokudb_commit_sync开关控制是否要fsync log到磁盘(checkpoint也会fsync log buffer的，默认为1分钟)。

    

    
针对不同的使用场景：

    
1) 对数据要求较高(不允许丢失数据，事务ACID完整性)，只需根据内存调整tokudb_cache_size大小即可，建议开启tokudb_directio。

    
2) 对数据要求不太高(允许部分数据丢失，不要求事务ACID完整性)，可配置:

    

      
 tokudb_commit_sync=OFF
 tokudb_fsync_log_period=1000 #1s

    

    
在此配置下，每1秒对log buffer做下fsync，可充分利用log的group commit功能，如果TokuDB挂掉，则可能会丢失最多1秒的数据。

  

  

    

    

    
Test Book

  

  

    
TokuDB企业版提供热备功能(与社区版唯一的区别)。

    
该功能以plugin方式提供，当backup plugin加载后，它会拦截所有的文件操作(比如文件读写／目录操作等)，从而实现在备份的过程中增量同步，具体原理请看:

    

http://www.tokutek.com/2013/09/tokudb-hot-backup-part-1/
  

http://www.tokutek.com/2013/09/tokudb-hot-backup-part-2/
 

    
社区版如何实现热备呢？

    
官方推荐的方式是mylvmbackup，不过可能会有一些＂坑＂。

    
Percona的Vadim同学写过一篇
TokuDB tips
，介绍了Percona在使用mylvmbackup热备TokuDB中遇到的＂坑＂及解决方法：

    
不能只备份TokuDB自身的数据以及日志文件，还要备份最新的binlog，否则启动的时候可能就＂跪＂了！

    
还有一个比较geek的方式，直接基于TokuDB自身的机制，轻松的热备出一个备库。

    
上攻略：

    

      
 1) SET TOKUDB_CHECKPOINT_LOCK=ON;
 2) 开始拷贝TokuDB的数据文件(不包含日志文件)
 3) FLUSH TABLES WITH READ LOCK;
 4) 记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)
 5) UNLOCK TABLES;
 6) SET TOKUDB_CHECKPOINT_LOCK=OFF;

    

    
＂大杀器＂就是
TOKUDB_CHECKPOINT_LOCK
，它的作用是允许拿到checkpoint锁，此时TokuDB的checkpoint会一直block到该锁释放(执行前要把tokudb_checkpoint_on_flush_logs关掉)，目的是防止拷贝TokuDB数据文件的过程中做sharp checkpoint(注意：由于不做checkpoint，TokuDB的日志文件会逐渐增多)，从而导致数据文件内部不一致(已拷贝的文件被修改)。

    
整个热备过程中，只有步骤4是阻塞写的，但耗时较短。

  

  

    

    

    
Test Book

  

  

  

    

    

    
Test Book

  

  

    
提要

    
MySQL 5.5.39 Release版本正式从源码里删除了全局参数
timed_mutexes
。
timed_mutexes
原本用来控制是否对Innodb引擎的
mutex wait
进行计时统计，以方便进行性能诊断。为什么要删除这个参数呢？

    
下面介绍下相关背景：

    
Innodb的同步锁机制

    
Innodb封装了mutex和rw_lock结构来保护内存的变量和结构,进行多线程同步，考虑可移植性， mutex使用lock_word或者OS mutex来保证原子操作，并使用event条件变量进行阻塞和唤醒操作。

    

      
 os_event_t    event;
 volatile lock_word_t    lock_word;
 os_fast_mutex_t os_fast_mutex;

    

    
Innodb同步锁引入的数据结构和开销

    
1. 全局mutex链表

    
Innodb引入了一个全局的链表ut_list_base_node_t mutex_list，并使用一个单独的mutex来保护链表。 所有的mutex在create或者free的时候来修改链表，有了全局链表，也使统计汇总有了可能性，参考命令“show engine innodb mutex”. 虽然需要维护一个全局的链表，但这并不会影响太多的性能，因为大部分的mutex的生命周期都是从Innodb启动一直到shutdown。

    
2. 统计信息

    
mutex的结构中，有几个统计信息：

    

      
 count_os_wait：请求mutex进入等待的次数
 count_using: 请求mutex的次数
 count_spin_loop: 请求mutex时spin的轮数
 count_spin_rounds: 请求mutex的spin次数
 count_os_yield:请求mutex spin失败后os等待次数
 lspent_time: 统计等待mutex的时间

    

    
lock mutex的主要步骤：

    

      
 1\. 首先trylock mutex，如果没有获取到mutex，并不马上进行wait，而是进行spin。
 2\. 尝试spin，如果在SYNC_SPIN_ROUNDS次后，仍然没有lock，那么就进入等待队列，等待唤醒。

    

    
在MySQL5.5的版本里，非UNIV_DEBUG模式下，Innodb仅仅保留了count_os_wait的次数，这也是为了性能的考虑。所以5.5的版本后， timed_mutexes在Release下，其实已经不再起作用，所以5.5.39，以及5.6以后，源码里都不再保留timed_mutexes。 要么在debug模式下，启用这些统计，但上线版本又不可能使用DEBUG模式，所以对于mutex的统计，MySQL在后面的版本中使用了performance_schema的等待事件来代替，即:

    

      
 mysql> SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
 -> WHERE TABLE_SCHEMA = 'performance_schema'
 -> AND TABLE_NAME LIKE '%instances';
 +------------------+
 | TABLE_NAME       |
 +------------------+
 | cond_instances   |
 | file_instances   |
 | mutex_instances  |
 | rwlock_instances |
 +------------------+

    

    
3. 全局等待队列

    
Innodb为所有的等待状态的线程准备了一个队列，如果获取mutex失败，那么就申请一个cell，进入阻塞状态，等待signal。 sync_primary_wait_array，有了这个全局的队列，Innodb就可以对这些wait的线程进行统计，比如long semaphore waits就是根据这个队列进行的查询。

    
4. signal丢失

    
这里再讨论下signal丢失的情况，我们重新再看下lock mutex的步骤：

    

      
 线程1：
 1\. try lock mutex
 2\. fail，然后spin
 3\. fail，然后进入队列，然后wait event
 线程2：
 1.own mutex
 2.free mutex
 3.signal event

    

    
如果按照这个时序，在线程2 signal event后，线程1才进入队列，那么线程1就永远处在阻塞状态，无法唤醒。为了解决signal丢失的情况， Innodb启动了一个后台线程：sync_arr_wake_threads_if_sema_free，每隔1s就轮询wait数组，如果可以lock，就signal这个event来唤醒线程。

    
从上面来看，Innodb为了mutex和rwlock的移植性，以及为了监控和诊断，添加了多个全局的数据结构，这样实时的统计才有可能，但也带来了维护数据结构的开销。 而timed_mutexes控制的mutex wait时间统计，因为只在debug模式下进行编译，而且5.6以后使用performance schema的等待事件进行替代，所以参数做了删除处理。

  

  

    

    

    
Test Book

  

  

    
背景

    
　　
innodb_flush_log_at_trx_commit
 这个参数可以说是InnoDB里面最重要的参数之一，它控制了重做日志（redo log）的写盘和落盘策略。 具体的参数意义见
手册

    
　　简单说来，可选值的安全性从0->2->1递增，分别对应于mysqld 进程crash可能丢失 -> OS crash可能丢失 -> 事务安全。

    
　　以上是路人皆知的故事，并且似乎板上钉钉，无可八卦。

    

      

        
innodb_use_global_flush_log_at_trx_commit

      

    

    
　　直到2010年的某一天，Percona的CTO Vadim同学觉得这种一刀切的风格不够灵活，最好把这个变量设置成session级别，每个session自己控制。

    
　　但同时为了保持Super权限对提交行为的控制，同时增加了innodb_use_global_flush_log_at_trx_commit参数。 这两个参数的配合逻辑为：

    
　　1、若innodb_use_global_flush_log_at_trx_commit为OFF，则使用session.innodb_flush_log_at_trx_commit;

    
　　2、若innodb_use_global_flush_log_at_trx_commit为ON,则使用global .innodb_flush_log_at_trx_commit（此时session中仍能设置，但无效）

    
　　3、每个session新建时，以当前的global.innodb_flush_log_at_trx_commit 为默认值。

    
业务应用

    
　　这个特性可以用在一些对表的重要性做等级定义的场景。比如同一个实例下，某些表数据有外部数据备份，或允许丢失部分事务的情况，对这些表的更新，可以设置 Session.innodb_flush_log_at_trx_commit为非1值。

    
　　在阿里云RDS服务中，我们对数据可靠性和可用性要求更高，将 innodb_use_global_flush_log_at_trx_commit设置为ON，因此修改session.innodb_flush_log_at_trx_commit也没有作用，统一使用 global.innodb_flush_log_at_trx_commit = 1。

  

  

    

    

    
Test Book

  

  

    
背景

    
　　MySQL现行版本中存在一个count(distinct)语句返回结果错误的bug，表现为，实际结果存在值，但是用count(distinct)统计后返回的是0。

    

      
drop table if exists tb;
set tmp_table_size=1024;
create table tb(id int auto_increment primary key, v varchar(32)) charset=gbk;
insert into tb(v) values("aaa");
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
insert into tb(v) (select v from tb);
update tb set v=concat(v, id);
select count(distinct v) from tb;
返回0

    

    
上述中update语句的目的是将所有的v值设为各不相同。

    
原因分析

    
　　Count(distinct f)的语义就是计算字段f的去重总数，计算流程大致如下：

    
　　流程一:

    
1、 构造一个unique集合A1（用tree实现） 2、 对每个值都试图插入集合A1中 3、 若和A1中现有item重复则直接跳过，不重复则插入并+1 4、 完成后计算集合中元素个数。

    
　　细心的同学会看到上面的语句中有一个set tmp_table_size的过程，集合A1并不能无限扩大，大小上限为tmp_table_size。若超过则上述流程变为

    
　　流程二：

    
1、 构造一个unique 集合A1 2、 插入item过程中若大小超过tmp_table_size，则将A1暂时写到文件中，再构造集合A2 3、 重复步骤2直到所有的item插入完成 因此若item很多则可能重复生成多个集合A1～An。 4、 对A1～An作合并操作。由于只是每个集合A保证unique，因此需要做类似归并排序的操作（实际上不需要排序，只是扫一遍） 5、 因此合并操作需要一个临时内存，长度为n，单元大小为key_length （key大小）。这个临时内存，用的也是tmp_table_size定义的大小。实际上在合并过程中还需要长为key_length的预留空间作临时内存保存。因此需要的空间为 (n+1)
key_length。 6、 在进行合并前会判断tmp_table_size >=(n+1)
key_length， 不满足则直接放弃合并。其结果就是返回为0。

    
案例分析

    
　　以上面这个case为例。字段v的单key大小为65 (65 = 32
2+1) 加上tree节点字占空间24字节共89字节。单个集合只能放11个item （1024/89）， 因此n为 24 （24>=256/11）, 在合并时需要 (24+1)
65= 1625字节的临时空间，大于1024，放弃合并。

    

      
Sql_big_tables

    

    
　　实际上在最初处理这个问题时，DBA同学发现社区也有人讨论这个bug，并且指出在set sql_big_tables=on的时候，执行count(distinct)就能正确返回结果。原因就是在sql_big_tables=on的情况下，构造集合的方式是直接生成一个临时表，全部插入后直接计算临时表的大小作为结果，整个过程与tmp_table_size无关。

    
解决方法

    
　　运维上，set sql_big_tables是一个方法，不过会影响性能。调高tmp_table_size算是正招。当然本质上这是一个bug。 　　代码上，对于已经走到合并操作的这个逻辑，如果tmp_table_size不够，应该直接申请新的临时空间用于合并，完成后释放。虽然会造成临时征用内存，不过以现有的逻辑来看，临时征用的内存已经不少了.

    
　　另外一种时间换空间的方法，就是作多次合并。

    
　　相比之下第一种改造比较简单安全。该bug在RDS MySQL 5.5 中已经修复。

  

  

    

    

    
Test Book

  

  

    
bug背景

    
　　在上个月发布的新版本中，官方修复了一个mysqldump输入库名或表明长度越界的bug。

    
　　在MySQL的当前约束中，库名和表名字符串最大长度为NAME_LEN=192字节。在myqldump实现中，需要对输入的表名做处理，比如增加``防止表名中的特殊字符。这些临时处理的内存，声明为类似name_buff[NAME_LEN+3],这样在用户输入的库名或表名长度过长时，会造成数组越界读写，导致不可预期的错误。

    
　　这个修复的逻辑也比较简单，就是在开始dump前作参数检查，若发现长度超过NAME_LEN的库/表名，直接抛错返回“argument too long”。

    
细节说明

    
　　需要注意的是，该修复改变了mysqldump的行为。由于名字长度超过NAME_LEN的库/表肯定不存在，因此修复之前的逻辑，是报告该表不存在。“table not exists”这个逻辑是可以通过--force 跳过的。而“argument too long”则无视force参数，直接抛错返回。

  

  

    

    

    
Test Book

  

  

    

      
现象描述：

    

    
Innodb引擎，父表和子表通过foreign constraint进行关联，因为在更新数据时需要check外键constraint，当父表被大量的子表referenced时候，那么在open Innodb数据字典的时候，需要open所有的child table和所有的foreign constraint，导致持有dict_sys->mutex时间过长，产生long semaphore wait, 然后innodb crash了。

    

      
case复现

    

    

      
 CREATE TABLE `t1` (
 `f1` int(11) NOT NULL,
 PRIMARY KEY (`f1`)
 ) ENGINE=InnoDB

    

    

      
 CREATE TABLE `fk_1` (
   `f1` int(11) NOT NULL,
   PRIMARY KEY (`f1`),
   CONSTRAINT `pc1` FOREIGN KEY (`f1`) REFERENCES `t1` (`f1`) ON DELETE CASCADE ON UPDATE CASCADE
 ) ENGINE=InnoDB
 ......
 这里建了fk_[0-10000]张表。

    

    

      
分析过程

    

    

      
1. 数据字典

    

    
innodb使用系统表空间保存表相关的数据字典，系统的数据字典包括：

    

      
 SYS_TABLES
 SYS_INDEXES
 SYS_COLUMNS
 SYS_FIELDS
 SYS_FOREIGN
 SYS_FOREIGN_COLS
 SYS_STATS

    

    
在load某个表的时候，分别从这些表中把表相关的index,column, index_field, foreign, foreign_col数据保存到dictionary cache中。 对应的内存对象分别是：dict_col_struct，dict_field_struct，dict_index_struct，dict_table_struct，dict_foreign_struct。

    

      
2. open过程

    

    
dict_load_table：

    

      
 1\. 通过sys_tables系统表，load table相关的定义
 2\. 通过sys_indexes系统表，根据table_id load 所有相关index
 3\. 通过sys_columns系统表，根据table_id load 所有的columns
 4\. 通过sys_fields系统表，根据index_id load 所有index的field
 5\. 通过sys_foreign系统表，load所有关联的表和foreign key

    

    

      
3. load foreign的详细过程

    

    
3.1 根据表名t1 查找sys_foreign.

    
而sys_foreign表上一共有三个索引： 　　　　

    

      
 index_1(id): cluster_index
 index_2(for_name): secondary_index
 index_3(ref_name): secondary_index

    

    
所以，根据for_name='t1', ref_name='t1'检索出来所有相关的foreign_id.

    
3.2 加入cache

    
因为没有专门的cache，foreign分别加入到for_name->foreign_list, ref_name->referenced_list。 问题的关键：因为foreign是全局唯一的，但foreign又与两个表关联，所以，有可能在open 其它表的时候已经打开过，所以，create foreign对象后，需要判断以下四个list，是否已经存在，如果存在就直接使用。

    
dict_foreign_find：分别查询这四个list，如果已经存在，则free新建的foreign对象，引用已经存在的。

    

      
 for_name->foreign_list
 for_name->referenced_list
 ref_name->foreign_list
 ref_name->referenced_list

    

    
如果不存在，把新建的foreign加入到for_name->foreign_list，ref_name->referenced_list链表中。

    

      
4. 问题的原因：

    

    
因为第一次load，所以find都没有找到，但这四个都是list，随着open的越来越多，检索的代价越来越大。 而整个过程中，都一直持有trx_sys->mutex，最终导致了long semaphore wait。

    

      
5. 问题改进方法：

    

    
在MySQL 5.5.39版本中，进行了修复，修复的方法就是，除了foreign_list，referenced_list。 另外又增加了两个red_black tree，如下源码所示：

    

      
 struct dict_table_struct{
   table_id_t    id;    　　/*!< id of the table */
   mem_heap_t*    heap;    /*!< memory heap */
   char*    name;    　　　　/*!< table name */
   UT_LIST_BASE_NODE_T(dict_foreign_t)
   foreign_list;　　　　　　　　　　/*!< list of foreign key constraints in the table; these refer to columns in other tables */
   UT_LIST_BASE_NODE_T(dict_foreign_t)
   referenced_list;/*!< list of foreign key constraints which refer to this table */
   ib_rbt_t*    foreign_rbt;    /*!< a rb-tree of all foreign keys listed in foreign_list, sorted by foreign->id */
   ib_rbt_t*    referenced_rbt;    /*!< a rb-tree of all foreign keys listed in referenced_list, sorted by foreign->id */
 }

    

    
这样dict_foreign_find的过程中，通过red_black tree进行检索，时间复杂度降到O(log n).

  

  

    

    

    
Test Book

  

  

    
背景

    
最近发布的MariaDB 10.1 Alpha版本，提交了一个改动，放宽了InnoDB Page<=16K的限制，将上限提高到64K。 从MDEV-6075需求文档中可以看出，目前只支持COMPACT的结构，DYNAMIC结构能否支持还在研究，COMPRESSED结构则确定无法支持。

    

      
 revno: 3987
 committer: Jan Lindström <jplindst@mariadb.org>
 branch nick: 10.1
 timestamp: Tue 2014-05-13 13:28:57 +0300
 message:
 MDEV-6075: Allow > 16K pages on InnoDB
 This patch allows up to 64K pages for tables with DYNAMIC, COMPACT and REDUNDANT row types. Tables with COMPRESSED row type allows still only <= 16K page size. Note that single row size must be still <= 16K and max key length is not affected.

    

    
业务应用

    
什么情况下需要64K这么大的页面呢？ 我们知道一个Page，不是所有的page_size都可以用来存数据，还有一些管理信息要存，例如页头和页尾（
InnoDB Page
）。 此外，InnoDB Buffer Pool管理页面本身也有代价，Page数越多，那么相同大小下，管理链表就越长。

    
因此当我们的数据行本身就比较长，尤其是做大块插入的时候，更大的页面更有利于提升如速度，因为一个页面可以放入更多的行，每个IO写下去的大小更大，就可以以更少的IOPS写更多的数据。 而且，当行长超过8K的时候，如果是16K的页面，就会强制转换一些字符串类型为TEXT，把字符串主体转移到扩展页中，会导致读取列需要多一个IO，更大的页面也就支持了更大的行长，64K页面可以支持近似32K的行长而不用使用扩展页。 但是，如果是短小行长的随机读取和写入，则不适合使用这么大的页面，这会导致IO效率下降，大IO只能读取到小部分有效数据，得不偿失。

  

  

    

    

    
Test Book

  

  

    

      
背景

    

    
随着存储设备越来越快，InnoDB许多原有的设计不再适合新的高速硬件，因此MariaDB 10.1 Alpha版本针对FusionIO PCI-E SSD做出了专门的优化，充分利用了Fio的硬件特性。 MDEV-6246这个需求改造了MariaDB，以利用fio的Atomic writes和文件系统压缩特性。

    

      
 revno: 3988 [merge]
 committer: Jan Lindström <jplindst@mariadb.org>
 branch nick: 10.1
 timestamp: Thu 2014-05-22 14:24:00 +0300
 message:
 MDEV-6246: Merge 10.0.10-FusionIO to 10.1.

    

    
为何Fio会更快呢，因为传统的存储设备读取，是左图的方式，要经过RAID控制器，来回的路径就长了。而Fio才有右图的方式，设备通过PCI槽直接与CPU交互，大大缩短了路径。

    

      

    

    

      
Atomic writes

    

    
InnoDB一直存在一个叫做Double Write Buffer的东西，目的就是为了防止页面写到一半系统崩溃，导致页面损坏，因为InnoDB的Page是16K，而一般的机械硬盘扇区是512字节，SSD大都是4K的块大小，都不能保证16K的写入是完整的。 而Fio的NVMFS文件系统则提供了原子写的保证，只要对文件句柄增加DFS_IOCTL_ATOMIC_WRITE_SET的ioctl标记位，就可以启用这个文件的原子写支持。

    

      
 ioctl(file, DFS_IOCTL_ATOMIC_WRITE_SET, &atomic_option)

    

    
MariaDB新增了一个参数来启用这个特性，一旦开启，所有文件会用DFS_IOCTL_ATOMIC_WRITE_SET标记打开。

    

      
 innodb_use_atomic_writes = 1

    

    
这样一来Double Write Buffer就没有存在的价值了，因为不会出现部分写，每个write下去都可以保证所写内容全部完成，这可以相当程度上提升InnoDB的性能。

    

      
Page compression

    

    
InnoDB标准的页面大小是16K，InnoDB也提供1K、2K、4K、8K的压缩页面大小，通过KEY_BLOCK_SIZE来设置压缩大小，使用zlib标准库来进行压缩。 但是Page是频繁被更新的，如果每次修改都重新压缩页面，代价很高，InnoDB就采用了modification log来暂存部分修改信息，而避免了频繁解压缩，待modification log存满时，再重新对整个Page做一次重构压缩。 但是Compressed Page载入InnoDB Buffer Pool时，InnoDB只能处理未压缩的页面，因此还要在内存中存一份解压页面，回写到磁盘时再次压缩。

    
总而言之，InnoDB的Compressed Page有这些缺点：

    

      
 内存开销
 空间: 压缩和解压缩页面都要存在InnoDB Buffer Pool
 访问: 修改需要同时写入到压缩页面和未压缩页面
 CPU开销
 软件压缩库zlib (从磁盘读取时需要解压缩放入内存, 页面分裂时需要重新压缩)
 Split & Recompress & Rebalance when mlog overflows
 空间收益
 固定的页面压缩大小 – 给压缩的效果设置了一个固定的边界
 Modification log和Page预留空间弱化了压缩带来的空间缩减
 糟糕的实现
 代码过于复杂而导致压缩和未压缩的表性能差距非常明显

    

    
MariaDB与FusionIO合作利用NVMFS文件系统的特性，修改InnoDB的Page结构来支持文件系统级的压缩。 Page compression要求InnoDB做了如下配置：

    

      
 innodb_file_per_table = 1
 innodb_file_format = Barracuda.

    

    
它的实现方法是，只在Page即将写入到文件系统时，才进行压缩，因此最终只有压缩后的容量被写入到磁盘，如果压缩失败，那么就把没有压缩的容量写入磁盘。另外还会对Page内的512字节的倍数的未使用空间清理掉，不占用实际存储：

    

      
 fallocate(file, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, off, trim_len);

    

    
当页面被读取时，会在放入Buffer Pool之前进行解压缩，将原始页面载入内存。因此需要在文件头中加入一个新的Page type：FIL_PAGE_PAGE_COMPRESSED 

    
综合起来可以这样定义一张表：

    

      
 CREATE TABLE t3 (a int KEY, b int)  DATA DIRECTORY=’/dev/fioa’ PAGE_COMPRESSED=1 PAGE_COMPRESSION_LEVEL=4 ATOMIC_WRITES=’ON’;

    

    
意思是将t3表存到/dev/fioa盘，开启Page compression，采用4级压缩，开启原子写。

    
经过测试，可以看出，LZ4的压缩比例最好，而且，对性能影响非常小。

    

      

    

    

      

    

  

  

    

    

    
Test Book

  

  

    
Bulk Fetch是为了提升区间操作性能的，聊它之前，先简单唠叨下读取机制，TokuDB由两部分组成: 
tokuFT
和 
tokudb-engine
 。 

tokuFT是个支持事务的key/value存储层，tokudb-engine是MySQL API对接层，调用关系为:tokudb-engine ->tokuFT。 

tokuFT里的一个value，在tokudb-engine里就是一条row数据，底层存储与上层调用解耦，是个很棒的设计。 

在tokuFT是个key里，索引的每个node都是大块头(4MB)，node又细分为多个＂小块＂(internal node的叫做partition，leaf node的叫做basement)。 

从磁盘读取数据到内存的方式有２种：

    

      

        
仅读一个＂小块＂的数据，反序列化到内存（提升point query性能，只读取需要的那部分数据即可)

      

      
读取整个node数据，反序列化到内存（提升区间性能，一次读取整个node磁盘数据）

    

    
对于tokudb-engine层的区间操作（比如get_next等），tokuFT这层是无状态的，必须告诉当前的key，然后给你查找next，流程大体是:

    

      
 tokudb-engine::get_next(current_key) --> tokuFT::search_next(current_key) --> tokuFT::return next

    

    
这样，即使tokuFT缓存了整个node数据，tokudb-engine还是遍历着跟tokuFT要一遍：tokuFT每次都要根据当前key，多次调用compare操作最终查出next，路径太长了！ 

有什么办法优化呢？这就是Bulk Fetch的威力: tokudb-engine向tokuFT一次要回整个node的数据，自己解析出next row数据，tokuFT的调用就省了:

    

      
 tokudb-engine::get_next(current_key) --> tokudb-engine::parse_next

    

    
从Tokutek的测试看，在使用Bulk Fetch后，能有2x-5x的性能提升。 

但并不是所有的区间操作都可以Bulk Fetch的(比如涉及update/delete)，TokuDB目前实现了:SELECT、CREATE_TABLE、INSERT_SELECT和REPLACE_SELECT的Bulk Fetch功能，预计发布在7.1.8版，更多Bulk Fetch介绍： 

https://github.com/Tokutek/tokudb-engine/wiki/Bulk-Fetch

  

  

    

    

    
Test Book

  

  

    
最近，TokuDB的创始人Dr. Bradley Kuzmaul发表了一篇文章: 
A Comparison of Log-Structured Merge (LSM) and Fractal Tree Indexing
，从write amplification(WAMP), read amplification(RAMP), and space amplification三个方面对B-Trees，LSM-Trees(LSM)以及Fractal-Trees(FT)进行了详细的分析和对比。

    
Dr. Bradley Kuzmaul的结果是(页13): 

    
从结果来看：

    

      
在WAMP上，FT跟LSM(leveled)是相同的
在RAMP(range)上，LSM(leveled)的复杂度明显要高不少(FT的O(logN/B)倍)

    

    
不过，RAMP这块的分析有个小问题： 

LSM(leveled)在实现上(比如LevelDB)，可以通过meta-info打＂锚点＂的方式，把RAMP(range)降低甚至做到跟FT一样，如果是point queries的RAMP，则可以通过Bloom filter来降低。

    
具体的推导过程请阅读原作，下面简单分析下FT的RAMP为啥比LSM的要低。 

FT的读方式比较＂特殊＂，由于每个节点都有个message buffer，当有读请求时，需要把inner node的message buffer数据（部分）推(apply)到leaf node，最后只在leaf node上做二分查找，所以RAMP基本就是树的高度。

    
另外，在数据流向上(compaction过程中数据走向)，LSM强调"level"(横向)，从level-L根据规则选取部分数据merge到level-(L+1)，如果选取数据的策略不好，会抢占磁盘带宽，容易引起性能抖动，而FT强调"root-to-leaf"(纵向)，数据从root有序的逐层merge到leaf节点，每条数据的merge路径是很明确的。

  

  

    

    

    
Test Book

  

  

    
第一期先介绍下TokuDB团队吧。 

TokuDB自从开源后（更赞的是开源了所有的commits），逐渐被大家所熟悉，MariaDB 5.5系列和Percona Server 5.6的GA版本中，都以plugin的方式集成。

    
3位(Tokutek)创始人: 
Michael A. Bender
 , 
Martín Farach-Colton
 , 
Bradley C. Kuszmaul
  

2012年他们合发了一篇208页的pdf[
Data Structures and Algorithms for Big Databases
]，热爱存储引擎算法的朋友们一定要看 :D

    
TokuDB目前有５名研发:

    

      
 @prohaska    --tokudb-engine研发，版本发布(一个人)
 @Leif        --tokuFT研发(Bender学生)
 @zkasheff    --tokuFT研发(Kuszmaul学生)
 @esmet       --tokuFT研发(Farach学生)
 @fizzfaldt   --算法优化(Bender学生)

    

    
可以说是个很＂精致＂团队，是研发也是测试，tokuFT的测试代码达~18w行(而tokuFT的核心代码才~9w行)，在代码把控上也很严格，要求所有代码在valgrind(helgrind和drd)下，没有memory、data race(资源竞争)和lock order(死锁)警告，质量很有保障。(BTW:我们也在借鉴和运用)  

同时@Leif和@zkasheff也是tokuMX的研发，不久前，他俩就MongoDB Replication可能＂丢数据＂的问题，写了篇[
Ark: A Real-World Consensus Implementation
]，对Paxos和Raft感兴趣的同学可以去看下。

    
更有意思的是，当工程中遇到难题，研发们先讨论出方案，递给三位创始人，得到更权威的指导，如果问题不错，他们就深入研究，出paper，工程与学术相结合。

  

