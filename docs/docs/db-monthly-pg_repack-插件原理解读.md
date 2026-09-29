# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/08/03/
> 分类: 

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
	

  

    
数据库内核月报 － 2024 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PostgreSQL 插入常量的合法性检查
                      

                    

                    

                  
                      

                        PostgreSQL MemoryContext 标准实现解读
                      

                    

                    

                  
                      

                        pg_repack 插件原理解读
                      

                    

                    

                  
                      

                        PostgreSQL blink-tree implement notes
                      

                    

                    

                  
                      

                        PolarStore弹性内存池（EMP）
                      

                    

 
        

    

  

    
 pg_repack 插件原理解读  

    
 Author: xinkang  

  

  

  
pg_repack 是 PostgreSQL 数据库生态的一款第三方插件，本文将结合 pg_repack 的 
源代码
 来介绍其原理，而不会介绍如何使用它。如果想了解 pg_repack 的具体用法，可以参考 pg_repack 的 
官方文档
 或 PolarDB PostgreSQL 版的 
pg_repack 文档
。

简介

pg_repack 的字面意思是“重新包装”，可以 
回收碎片化的存储空间，解决表和索引的存储空间膨胀问题
。

PostgreSQL 内核自带的 

VACUUM FULL

 和 

CLUSTER

 功能同样可以重写表并解决存储空间膨胀问题，为何还要开发一个 pg_repack 插件来做同样的事？这是因为 
VACUUM FULL
 和 
CLUSTER
 需要锁表，可能导致业务长时间无法进行数据读写，而 pg_repack 
对读写请求的阻塞时间很短，对业务影响更小
，这就是它相比 
VACUUM FULL
 和 
CLUSTER
 最大的优势。

pg_repack 以安装在 PostgreSQL 数据库侧的 pg_repack 插件作为服务端，并提供 pg_repack 客户端给用户，两者需要搭配使用，用户执行一条形如 
pg_repack --table=my_table
 的 shell 命令，客户端会连接到服务端去执行表重写的操作。

为什么需要一个单独的客户端，而不能让用户直接连接到数据库去执行类似 
SELECT repack_table('my_table')
 之类的函数调用来完成表重写？这是因为 pg_repack 的操作涉及到全量数据同步、增量数据同步等多个阶段，其中还有锁级别的切换，包含多个事务，无法封装在一个函数中。为了让用户能够一键完成表重写，因此 pg_repack 选择将以上步骤封装到客户端中。

代码结构

pg_repack 代码主要分为两个目录，一个是服务端代码目录 
pg_repack/lib/
，一个是客户端代码目录 
pg_repack/bin/
：

  

pg_repack/lib/
 目录下的文件最终会编译生成 pg_repack.so，在数据库服务端通过 
CREATE EXTENSION
 创建插件的方式操作来进行加载。

  

pg_repack/bin/
 目录下的文件最终会编译生成 pg_repack 客户端工具。

repack 普通表

首先介绍 repack 普通表，这是最常见、最重要的 pg_repack 操作。该操作会重写表，并重建表上的索引，作用类似于 
VACUUM FULL
 或 
CLUSTER
，适用于表空间膨胀的场景。大致用法如下：

  
使用 
--table/-t
 参数指定表名。

  
如果表上有多个索引，则可以使用 
--jobs/-j
 参数设置重建索引的并发度，这样重建速度更快。

  
默认为 
CLUSTER
 模式，重写过程中对该表上之前执行过 
CLUSTER
 的列进行排序，还可以使用 
--order-by/-o
 选项对指定的列排序。可以使用 
--no-order/-n
 选项来执行 
VACUUM FULL
 模式。

VACUUM FULL
 操作会对表加排它锁，阻塞一切读写操作，将表中数据读出并写到一份新的存储，新的存储中的数据排列很紧密，用于代替之前的碎片化的旧存储。
VACUUM FULL
 的逻辑之所以相对简单，是因为它阻塞了读写操作，不需要考虑并发读写场景。

然而 pg_repack 允许操作过程中有并发读写，因此需要考虑并发 DML 产生的增量数据，总体上分为 
全量数据同步 + 增量数据同步
 两个阶段。其中增量数据用触发器捕获，保存到单独的日志表中，最后将日志表的数据应用的新表。

相关的函数调用链为 
main->repack_one_database->repack_one_table
，其中 
repack_one_table
 是关键函数，它的主要流程如下：

  
初始化
    

      
对表加意向锁，防止该表上有多个 pg_repack 任务并发执行；

      
对表加排它锁，阻塞读写；

      
创建日志表，用于保存 repack 过程中的增量数据；

      
在原表上创建触发器，用于将原表上的增量数据插入日志表；

      
从排它锁降级到共享锁，不再阻塞读写，后续的 repack 过程多数时间内都持有共享锁，在允许业务读写请求访问表的同时，又可以防止 DDL 操作修改表结构。

    

  

  
全量数据同步
    

      
创建一个空的新表：
CREATE TABLE new_table AS SELECT * FROM old_table WITH NO DATA
；

      
将原表数据全量同步到新表：
INSERT INTO new_table SELECT * FROM old_table
；

    

  

  
索引重建：调用 
rebuild_indexes
 函数在新表上创建索引，可以开启多个并发，并发数量取决于 
--jobs
 参数。

  
增量数据同步：反复调用 
apply_log
 函数将日志表中的增量数据应用到新表，直到日志表中没有数据为止。如果原表一直在产生增量数据，则同步过程可能要持续很久。

  
元数据交换
    

      
从共享锁升级为排它锁，阻塞读写，不允许继续产生增量数据；

      
由于加排它锁之前的短暂空当可能有并发 DML 产生增量数据，所以再次调用 
apply_log
 函数同步增量数据；

      
调用 
repack_swap
 函数交换新表和旧表的元数据，主要是把 
pg_catalog.pg_class
 系统表中保存的 relfilenode、reltablespace、reltoastrelid 等元数据对调，让原表的元数据指向新表的存储，它更为紧凑，而新表的元数据则指向原表之前的那份空间膨胀率较高的存储；

      
释放排它锁，此时 repack 已经基本完成，不再需要锁来进行保护。

    

  

  
删除旧表
    

      
对表加排它锁；

      
调用 
repack_drop
 函数删除旧表以释放膨胀的存储空间，此外还需要删除日志表、触发器等；

      
释放排它锁。

    

  

repack 继承表&分区表

如果通过 
--parent-table/-I
 参数指定一个父表，pg_repack 会对该父表以及它的所有继承表或分区都执行 repack 操作。

repack 分区表相关的函数调用为：
main->repack_one_database->repack_one_table
。其中 
repack_one_database
 函数会获取父表的所有继承表/分区，然后对所有的表依次调用 
repack_one_table
 函数。这样做的原因是每个继承表/分区都有自己独立的存储，因此可以独立执行 repack。假如其中某个继承表/分区的 repack 发生错误，通常可以忽略该分区，继续执行下一个分区。

获取所有继承表的原理是调用 
repack.get_table_and_inheritors->find_all_inheritors
 函数，其作用等价于从 
pg_catalog.pg_inherits
 系统表查出所有的继承表。

至于 
repack_one_table
 操作单个表的原理，在前面 repack 普通表的部分已经介绍过了。

repack 索引

对表上的索引进行 repack，而不操作表中的数据，可以理解为索引重建，适用于索引空间膨胀的场景。

可以用 
--index/-i
 参数指定具体的索引名，也可以用 
--table/-t
 参数指定表名，再用 
--only-indexes/-x
 参数说明操作该表的索引。

repack 索引相关的函数调用：
main->repack_all_indexes->repack_table_indexes
，其中 
repack_table_indexes
 函数执行单个表上的操作，关键逻辑就在该函数中，如果有多个表需要操作，
repack_all_indexes
 会多次调用它。
repack_table_indexes
 函数大概分为三步：

  
使用 

CREATE INDEX CONCURRENTLY

 并发创建一个新的临时索引，不阻塞读写，新索引名为 
index\_<oid>
，其中 
oid
 为它对应的原索引的 oid。

  
调用 pg_repack 插件实现的 
repack.repack_index_swap
 函数交换新旧索引的元数据，操作过程需要对表持有排它锁，短暂阻塞读写。其中 
repack.repack_index_swap
 函数的原理是把新旧索引在 
pg_catalog.pg_class
 系统表中保存的 relfilenode、reltablespace、reltoastrelid 等元数据对调，这样原索引的元数据就指向了新索引的存储，它更为紧凑，而新索引的元数据则指向了原索引之前的那份存储，它往往空间膨胀率比较高。

  
使用 

DROP INDEX CONCURRENTLY

 并发删除新索引，丢弃那份空间膨胀率较高的存储，
不阻塞读写
。

以上三步操作的作用实际上等同于执行一次 

REINDEX CONCURRENTLY

，因此：

  
对于 PostgreSQL 11 及更早的版本，由于数据库内核不支持 
REINDEX CONCURRENTLY
，则可以借助 pg_repack 来实现在线索引重建；

  
对于 PostgreSQL 12 及之后的版本没有必要使用 pg_repack 插件来重建索引，直接使用 PostgreSQL 内核自带的 
REINDEX CONCURRENTLY
 来重建索引即可。

repack 多个对象

除了前面介绍的对单个表和索引进行操作之外，pg_repack 还支持操作整个数据库或者模式。这些操作都比较激进，一次操作大量的表和索引，对业务的影响相对较大，因此 
不建议
 对整个模式和数据库执行 pg_repack，而更推荐对单个表或索引执行 pg_repack。

repack 整个模式

通过 
--schema/-c
 参数指定模式，pg_repack 就会对该模式中的所有表和索引执行操作。

repack 整个模式相关的函数调用：
main->repack_one_database->repack_one_table
，其中 
repack_one_database
 会找出该模式下所有的表，对每个表都执行 
repack_one_table
 函数。
repack_one_table
 的原理已经在之前 repack 单表的部分介绍过了。

repack 整个数据库

通过 
--dbname/-d
 参数指定数据库，但是不指定具体的表和索引名，pg_repack 就会对该数据库中的所有用户表和索引执行操作。

repack 单个数据库相关的函数调用：
main->repack_one_database->repack_one_table
，其中 
repack_one_database
 会查出该数据库下的所有表，并对每个表的调用 
repack_one_table
 函数去执行操作。至于 
repack_one_table
 的原理，在前面 repack 普通表的部分已经介绍过了。

repack 所有数据库

通过 
--all/-a
 参数表示对该实例的所有数据库中的所有表和索引都执行 repack 操作。

repack 所有数据库相关的函数调用：
main->repack_all_databases->repack_one_database
，其中 
repack_all_databases
 会获取实例中的所有数据库，并对每个数据库都调用 
repack_one_database
 去执行单个数据库的 repack 操作。
repack_one_database
 的原理在上一步已经介绍过了。

repack 修改表空间

通过 
--tablespace/-s
 指定一个新的表空间，即可将 repack 之后的新表移动到一个新的表空间，如果使用 
--moveidx
 参数，还可以将 repack 之后的新索引也移动到新的表空间。

它的实现原理很简单，就是在 
repack_one_table
 函数创建新表或 
repack_table_indexes
 函数创建新索引的过程中指定表空间，

CREATE TABLE

 和 

CREATE INDEX

 天然支持该能力。

与 pg_squeeze 插件对比

在 PostgreSQL 生态中，有另一款 pg_squeeze 插件的作用同样是清理膨胀的存储空间，与 pg_repack 的作用基本相同，但是实现方式不同，两者对比如下：

  
增量数据同步方式
    

      
pg_repack 使用触发器 + 日志表的方式来同步，缺点是触发器会降低表的 DML 性能；

      
pg_squeeze 使用逻辑复制解析 WAL 日志的方式来同步，缺点是要求 
wal_level
 参数值为 
logical
，如果参数值不满足要求，则需要修改 
wal_level
 参数，修改后需要重启数据库才能生效，而重启操作对于生产环境的影响较大。

    

  

  
封装方式
    

      
pg_repack 将所有操作封装到客户端，缺点是：客户端与服务端的连接可能因为网络不稳定而断开，导致 repack 失败，并在数据库中残留触发器、日志表等对象；

      
pg_squeeze 将所有操作封装后台进程 background worker，不依赖客户端，在服务端执行 SQL 即可启动后台进程。缺点是后台进程在异步在后台运行的，其执行过程的报错信息对用户不可见。

    

  

  
其他
    

      
pg_squeeze 支持配置时间表达式，在后台定时自动化执行，无需每次手动操作。

    

  

  

    

		

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
