# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/08/09/
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
	

  

    
数据库内核月报 － 2018 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 主库 binlog 概览
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Write Prepared Policy
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 使用对称秘钥实现列加密
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · InnoDB对binlog_format的限制
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · sharding chunk 分裂与迁移详解
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PostgreSQL物理备份内部原理
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 连接与认证过程
                      

                    

                    

                  
                      

                        MySQL · RocksDB ·  MemTable的写入逻辑
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · Greenplum RoaringBitmap多阶段聚合
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 高并发空间位置更新、多属性KNN搜索并测
                      

                    

 
        

    

  

    
 PgSQL · 最佳实践 · Greenplum RoaringBitmap多阶段聚合  

    
 Author: 步真  

  

  

  
背景

为了让阿里云RDS PG以更低的成本、更高的性能支持用户海量数据画像的实时计算，在Greenplum分布式数据库内核中，我们引入了RoaringBitmap功能的插件。
Greenplum roaring bitmap与业务场景 (类阿里云RDS PG varbitx, 应用于海量用户 实时画像和圈选、透视)

位图索引在数据库领域应用很广泛。传统位图索引通过判断一个整数对应位图bit位是否置1，来进行快速索引。32位操作系统下，整数范围最大为2^32-1，为构建该整数的位图结构，需要占用2^32/8/1024/1024=512M大小的内存空间，而在大多数情况下，一个整数集合构建好的bitmap，bitmap中元素稀疏程度较大，用512M内存来存储当前数据结构，显然是不可接受的。
RoaringBitmap被描述为压缩位图，其实现方式是将一个32位长度的整数分为高16位和低16位两部分。对于高16位，作为key被存储在keys[]中，而对于低16位，作为value被存储在containers[]中。key和value通过数组下标进行对应。keys被维护为一个有序数组，每次通过二分查找在O(logn)内完成高16位的索引。
对于低16位，可以分为两种实现。元素个数小于4096，直接存储16位数，即采用2字节大小的short结构进行存储。元素个数超过4096，采用1024个long来对65536个bit进行存储。

原生功能

原生的Greenplum内核不带有RoaringBitmap插件，开源社区实现了该功能，从而使得Greenplum可以支持RoaringBitmap类型。但该版本对于多阶段的聚合，并没有将聚合做到计算节点，而是实现为在主节点gathermotion再聚合，从而导致聚合性能不佳。

postgres=# explain select rb_cardinality(rb_and_agg(bitmap)) from t1;  
                                       QUERY PLAN                                         
----------------------------------------------------------------------------------------  
 Aggregate  (cost=1.05..1.07 rows=1 width=4)  
   ->  Gather Motion 3:1  (slice1; segments: 3)  (cost=0.00..1.05 rows=1 width=1254608)  
         ->  Seq Scan on t1  (cost=0.00..1.01 rows=1 width=1254608)  
(3 rows)  
  
Time: 0.727 ms

从SQL执行计划也可以看出，原生方式下的RoaringBitmap实现，采用的是主节点上的单阶段聚合，这也成为了我们可以进行性能优化的一个方面。

优化改进

我们针对聚合操作进行了优化并改进，使得聚合操作采用多阶段聚合的方式实现，进一步提升RoaringBitmap在阿里云RDS实际业务中的性能。改进后的具体实现逻辑如下：

我们通过在从节点完成一阶段聚合操作，再由主节点完成二阶段聚合，从而充分利用从节点自身计算性能，采用多阶段方式，提高聚合操作性能。
改进后的执行计划为多阶段方式执行。

postgres=# explain select RB_AND_AGG(bitmap) from t1;
                                    QUERY PLAN
-----------------------------------------------------------------------------------
 Aggregate  (cost=1.08..1.09 rows=1 width=32)
   ->  Gather Motion 3:1  (slice1; segments: 3)  (cost=1.01..1.06 rows=1 width=32)
         ->  Aggregate  (cost=1.01..1.02 rows=1 width=32)
               ->  Seq Scan on t1  (cost=0.00..1.01 rows=1 width=40)
(4 rows)

性能测试1

  
表结构

 CREATE TABLE t1 (id integer, bitmap roaringbitmap);
 INSERT INTO t1 SELECT GENERATE_SERIES(1,1000000),RB_BUILD(ARRAY[1,2,3,4,5,6,7,8,9,200]);

  
测试结果

  
结果分析

主节点个数为1，从节点个数为3，相较于不采用多阶段聚合方式，性能提升基本在2-3倍，其中rb_and_agg原生环境下在主节点聚合所有数据，优化后效果明显。

性能测试2

为进一步说明ARRAY长度的大小不会使得改进后的方案性能降低，进行了第二轮性能测试。

  
表结构

 CREATE TABLE t1 (id integer, bitmap roaringbitmap);
 INSERT INTO t1 SELECT GENERATE_SERIES(1,1000000),RB_BUILD(ARRAY(SELECT *FROM GENERATE_SERIES(1,10000)));

  
测试结果

  
结果分析

主节点个数为1，从节点个数为3，相较于不采用多阶段聚合方式，性能提升基本在2-3倍。其中rb_and_agg与rb_and_cardinality_agg执行时间超过10分钟，为方便构建测试结果图，取10w毫秒。

部署方法

创建插件

postgres=# create extension roaringbitmap;
CREATE EXTENSION

创建测试表

postgres=# create table t1 (id integer, bitmap roaringbitmap);
NOTICE:  Table doesn't have 'DISTRIBUTED BY' clause -- Using column named 'id' as the Greenplum Database data distribution key for this table.
HINT:  The 'DISTRIBUTED BY' clause determines the distribution of data. Make sure column(s) chosen are the optimal data distribution key to minimize skew.
CREATE TABLE

插入测试数据

postgres=# insert into t1 (select 1, rb_build(array[1,2,3,4,5,6,7,8,9,200]));
INSERT 0 1

聚合函数使用测试

postgres=# select rb_or_agg(bitmap) from t1;
                                                                 rb_or_agg
--------------------------------------------------------------------------------------------------------------------------------------------
 :0\000\000\001\000\000\000\000\000\011\000\020\000\000\000\001\000\002\000\003\000\004\000\005\000\006\000\007\000\010\000\011\000\310\000
(1 row)

postgres=# select rb_or_agg(bitmap) from t1;
                                                                 rb_or_agg
--------------------------------------------------------------------------------------------------------------------------------------------
 :0\000\000\001\000\000\000\000\000\011\000\020\000\000\000\001\000\002\000\003\000\004\000\005\000\006\000\007\000\010\000\011\000\310\000
(1 row)

postgres=# select rb_and_agg(bitmap) from t1;
                                                                 rb_and_agg
--------------------------------------------------------------------------------------------------------------------------------------------
 :0\000\000\001\000\000\000\000\000\011\000\020\000\000\000\001\000\002\000\003\000\004\000\005\000\006\000\007\000\010\000\011\000\310\000
(1 row)

postgres=# select rb_xor_agg(bitmap) from t1;
                                                                 rb_xor_agg
--------------------------------------------------------------------------------------------------------------------------------------------
 :0\000\000\001\000\000\000\000\000\011\000\020\000\000\000\001\000\002\000\003\000\004\000\005\000\006\000\007\000\010\000\011\000\310\000
(1 row)

postgres=# select rb_build_agg(id) from t1;
                            rb_build_agg
--------------------------------------------------------------------
 :0\000\000\001\000\000\000\000\000\000\000\020\000\000\000\001\000
(1 row)

postgres=# select rb_or_cardinality_agg(bitmap) from t1;
 rb_or_cardinality_agg
-----------------------
                    10
(1 row)

postgres=# select rb_and_cardinality_agg(bitmap) from t1;
 rb_and_cardinality_agg
------------------------
                     10
(1 row)

postgres=# select rb_xor_cardinality_agg(bitmap) from t1;
 rb_xor_cardinality_agg
------------------------
                     10
(1 row)

总结

我们将Greenplum原生RoaringBitmap插件进行了优化，增加了对聚合操作的多阶段执行处理，提升了RoaringBitmap多阶段聚合操作的执行性能。

  

    

		

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
