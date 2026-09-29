# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/10/01/
> 分类: 功能特性

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
	

  

    
数据库内核月报 － 2022 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB · 功能特性 · 非阻塞DDL
                      

                    

                    

                  
                      

                        MySQL · UNDO LOG的演进与现状
                      

                    

                    

                  
                      

                        源码分析 · MySQL Event 源码分析
                      

                    

                    

                  
                      

                        B+树数据库故障恢复概述
                      

                    

                    

                  
                      

                        MySQL 深潜 - 统计信息采集
                      

                    

                    

                  
                      

                        PolarDB · 功能特性 · 嵌套子查询优化的性能分析
                      

                    

 
        

    

  

    
 PolarDB · 功能特性 · 非阻塞DDL  

    
 Author: saimu  

  

  

  
背景 / 外围工具

​		DDL语句作为数据库中最高危复杂的操作，其操作经常会涉及数据文件、MDL锁阻塞以及大表DDL执行时间过长等问题，常常困扰着企业DBA、业务开发以及众多数据库使用者。当前云数据库快速发展，众多客户将数据库从本地自建迁移到云上，从而简化数据库的管理难度，提高资源的弹性能力，但DDL依然是众多客户的梦魇操作，一不小心就会导致业务瘫痪乃至雪崩。因此，DDL是检测一个数据库是否是成熟商业数据库的重要标志。

​		为了避免这个问题，MySQL社区开发了很多外部工具，比如pt-osc和github的gh-ost，希望能绕过内核DDL能力不足的问题。pt-osc和gh-ost均采用拷表方式实现，即创建一个空的新表，然后通过select + insert的方式拷贝存量数据，然后通过触发器或者binlog的方式拷贝增量数据，最后通过rename操作切换新表和旧表。云厂商的各种工具，例如DMS的无锁变更也与这些外部工具原理类似。为了避免上文提到的问题，DBA和数据库使用者们不得不依赖这些外围工具，来避免DDL带来的潜在风险。但在这个数据爆炸的年代，外围工具存在着明显的劣势（下文会分析），但是pt-osc/gh-ost依然是众多DBA/数据库使用者们难以放弃的工具，通过大幅牺牲性能/易用性来追求稳定性。

​		PolarDB内核团队希望通过对DDL的持续更新，让使用者们在执行DDL时能同时满足性能/易用性/稳定性的要求。为了解决这个问题，我们首先研究了DBA们为什么依赖pt-osc/gh-ost的原因，并做了进一步的分析：

​	   1.MySQL在5.5及之前，DDL操作会直接锁表，在整个执行期间不支持更新操作，这显然在生产环境上是不可接受的。所以，pt-osc/gh-ost等外围工具先入为主，在5.5以及之前的版本帮助用户解决了这一难点问题。但是从MySQL5.6之后，MySQL开始支持Online DDL，即在DDL的主要执行过程中支持并发的DML操作，在很大程度上解决了这一痛点；

​       2. 传统基于Binlog的复制，在DDL复制方面有严重的延迟和堵塞问题。在MySQL多线程并行复制框架下，从库回放DDL操作时具有排他性，也就是说DDL操作独立为一个group，只有该DDL操作执行完才能回放后续的DML，如果DDL操作需花费2小时，那么复制延迟至少为2小时。但是针对这个问题，PolarDB基于物理复制，实时同步，在主库DDL完成的刹那，从库也完成了DDL操作；

​																		     图1 Slave节点执行DDL、DML流程

​         3. MySQL在5.6及之前，不管是copy DDL还是inplace DDL，并没有做过深入的性能优化，所以整体性能表现与外挂差别没有那么明显。但是MySQL5.7通过bulk load优化了建索引的效率，8.0通过instant DDL优化了加减列的效率。此外，PolarDB在DDL的critical path上做了大量预取/pipeline/并行的优化，整体性能远远优于外围工具。外围工具的性能，在大表问题上尤其明显，在PolarDB上线5年多以来，云上出现了众多数据量达到百GB甚至TB级别的单表，对其进行DDL操作甚至需要以天来计算。如果使用这些外围工具，因为外围工具拷贝存量/增量数据是在数据库内核外部执行的，操作非常重，性能将会进一步数倍地衰减（值得注意的是，当表过大或者增量更新过多时，我们在测试的过程中发现，外围工具常常无法完成增量数据的回放，失败回滚的代价很高）。为了说明这一点，我们使用传统的加列方式（INSTANT、INPLACE、COPY）与使用gh-ost工具分别对100万行数据的表进行加列操作的性能对比如下：

​              a. 在无负载的情况下，通过下图可以看出开启PolarDB 无阻塞DDL并使用传统的加列方式（INSTANT、INPLACE、COPY）比使用gh-ost工具耗时更少。

​																		图2 无负载，内核与gh-ost加列性能对比

​              b. 使用SysBench的oltp_read_write模拟业务负载，通过下图可以看出开启PolarDB无阻塞DDL并使用传统的加列方式（INSTANT、INPLACE、COPY）远比使用gh-ost工具耗时更少。

​																		图3 read_write负载，内核与gh-ost加列性能对比

​        4.虽然Online DDL在执行过程中允许并发的DML更新操作，但是在DDL的prepare/comment阶段依然需要短期持有锁（持有锁时间大部分情况下小于1秒）。MySQL申请MDL锁的策略，是一个写友好的策略。简单来说，如果DDL拿不到MDL锁，它会一直等待，堵塞后续访问这个表的DML操作。如果用户业务没有针对这个情况做足够的防御，非常容易导致连接数上涨，业务雪崩。PolarDB从上线以来，我们陆续发现多个客户因为这个问题，导致业务受到显著的影响。

​        综上所述，pt-osc/gh-ost等外围工具提供的1/2/3点优势，在PolarDB上并不存在，反而成为了劣势。因此，在很多场景，我们并不推荐用户使用外围工具。但是第4点依然是一个非常高危的风险，如果我们克服了第四点，用户就可以更加放心地不再使用外围工具，真正简单易用地克服DDL这个梦魇操作。为了解决这个问题，PolarDB推出了非阻塞DDL能力，保证在DDL拿不到锁的情况下，业务不受影响。

非阻塞DDL

​		用户在执行DDL操作的时候，若目标表存在未提交的长事务或大查询，DDL将持续等待获取MDL-X锁。PolarDB中由于MDL-X锁具有最高优先级，DDL在等待MDL-X锁的过程中，将阻塞目标表上所有的新事务，这将导致业务连接的堆积和阻塞，可能会造成整个业务系统崩溃的严重后果。PolarDB提供的Nonblock DDL功能，可以保证即使在无法获得MDL-X锁的情况下，依然允许新事务进入目标表，从而保证整个业务系统的稳定。下面对PolarDB 非阻塞DDL使用方面做一些介绍。

使用限制

  
支持
ALTER TABLE
语句的Nonblock DDL功能，应用于
ALTER TABLE
 

table_name

 
ADD INDEX
 

index_name

 
( `	column1
, 
column2
, 
column3` )
语句效果更佳。

  
支持
OPTIMIZE TABLE
 

table_name

 和 
TRUNCATE TABLE
 

table_name

 语句，对于在InnoDB引擎上创建的表，建议使用
ALTER TABLE
 

table_name

 
engine=innodb
命令来代替
OPTIMIZE TABLE
  

table_name

 命令进行碎片整理。

使用方法

您可以先通过
loose_polar_nonblock_ddl_mode
参数开启Nonblock DDL功能，并通过
loose_polar_nonblock_ddl_retry_times
参数设置获取MDL-X锁超时重试的次数、
loose_polar_nonblock_ddl_retry_interval
参数设置获取MDL-X锁超时重试的时间间隔、
loose_polar_nonblock_ddl_lock_wait_timeout
参数设置获取MDL-X锁超时的时间，参数说明如下：

  

    

      

参数

      

级别

      

说明

    

  

  

    

      

loose_polar_nonblock_ddl_mode

      
Session

      
Nonblock DDL功能开关。取值范围如下：
ON
：开启Nonblock DDL功能。
OFF
（默认）：关闭Nonblock DDL功能。

    

    

      

loose_polar_nonblock_ddl_retry_times

      
Session

      
设置获取MDL-X锁超时重试的次数。取值范围：0~31536000。默认值为0（由参数
lock_wait_timeout
计算得到的值）。
说明
 该参数值建议设置为4194304。

    

    

      

loose_polar_nonblock_ddl_retry_interval

      
Session

      
设置获取MDL-X锁超时重试的时间间隔。取值范围：1~31536000。单位为秒。默认值为6。

    

    

      

loose_polar_nonblock_ddl_lock_wait_timeout

      
Session

      
设置获取MDL-X锁超时的时间。取值范围：1~31536000。单位为秒。默认值为1。

    

  

性能对比

​		这里对开启和关闭Nonblock DDL功能对业务的影响情况进行对比。

测试环境

​		一个规格为8核64 GB的标准版PolarDB MySQL引擎8.0版本的集群。

测试方法

  
使用SysBench创建1个测试表
sbtest1
，并插入1000000行数据。

.

/

oltp_read_write

.

lua
 
--mysql-host="集群地址" --mysql-port=“端口号” --mysql-user=“用户名” --mysql-password=“用户密码” --mysql-db="sbtest" --tables=1 --table-size=1000000 --report-interval=1 --percentile=99 --threads=8 --time=6000 prepare

  
通过SysBench中的
oltp_read_write.lua
模拟用户业务。

.

/

oltp_read_write

.

lua
 
--mysql-host="集群地址" --mysql-port=“端口号” --mysql-user=“用户名” --mysql-password=“用户密码” --mysql-db="sbtest" --tables=1 --table-size=1000000 --report-interval=1 --percentile=99 --threads=8 --time=6000 run

  
在目标表
sbtest1
上开启一个事务但不提交，该事务将持有目标表
sbtest1
的MDL锁。

/* session 1 */
 

begin

;
 

select
 
*
 
from
 
sbtest1

;

  
在新会话中，开启和关闭Nonblock DDL功能的条件下，分别对表
sbtest1
进行加列操作，观察TPS的变化情况。

/* session 2 */
 

alter
 
table
 
sbtest1
 
add
 
column
 
d
 
int

;

  
使用gh-ost工具进行加列操作，观察TPS的变化情况，需开启binlog。

.

/

gh

-

ost
 
--assume-rbr --user="用户名" --password="用户密码" --host="集群地址" --port="端口号" --database="sbtest" --table="sbtest1"  --alter="ADD COLUMN d INT" --allow-on-master --aliyun-rds --initially-drop-old-table --initially-drop-ghost-table --execute;

测试结果

  
关闭Nonblock DDL，TPS持续跌零。默认超时时间为31536000，严重影响用户业务。

​																	图4 不开启内核Nonblock DDL功能，对业务影响

  
开启Nonblock DDL，TPS周期性下降，但未跌零。对用户业务影响较小，能保证业务系统的稳定。

​																图5 开启内核Nonblock DDL功能，对业务影响

  
使用gh-ost进行表结构无锁变更，TPS周期性跌零。对用户业务影响很大，这是cut-over阶段短暂锁表造成。

​																			图6 使用gh-ost变更，对业务影响

测试结论

​		Nonblock DDL功能在DDL执行期间能更好的规避新事务阻塞、TPS跌零等问题，从而尽可能的保证业务系统的稳定性。同时，能够提供更高效的DDL变更能力。

参考文档

PolarDB 非阻塞DDL官方文档

MySQL 8.0 Online DDL和pt-osc、gh-ost深度对比分析

  

    

		

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
