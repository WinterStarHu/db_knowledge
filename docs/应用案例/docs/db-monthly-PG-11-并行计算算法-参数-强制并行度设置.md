# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/12/09/
> 分类: 应用案例

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
	

  

    
数据库内核月报 － 2018 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        Database · 原理介绍 · 数据库的事务与复制
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · PostgreSQL Hint Bits 简介
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 行级别安全解决方案
                      

                    

                    

                  
                      

                        MySQL · 原理介绍 · 再议MySQL的故障恢复
                      

                    

                    

                  
                      

                        POLARDB · 引擎特性 · 物理复制解读
                      

                    

                    

                  
                      

                        Redis · 原理介绍 · 利用管道优化aofrewrite
                      

                    

                    

                  
                      

                        PgSQL · 原理介绍 · PostgreSQL行锁实现
                      

                    

                    

                  
                      

                        MySQL · RocksDB · 数据的读取(二)
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 11 并行计算算法，参数，强制并行度设置
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL IoT，车联网 - 实时轨迹、行程实践
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · PG 11 并行计算算法，参数，强制并行度设置  

    
 Author: digoal  

  

  

  
背景

PostgreSQL 并行计算原理、应用参考:

《PostgreSQL 多场景 沙箱实验》

优化器并行计算的并行度计算方法

1、总worker进程数

postgres=# show  ;      
 max_worker_processes     
----------------------    
 128    
(1 row)    

2、所有会话，在同一时刻的QUERY，并行计算最大允许开启的WORKER数。

max_parallel_workers    

3、单条QUERY中，每个node最多允许开启的并行计算WORKER数

postgres=# show max_parallel_workers_per_gather ;    
 max_parallel_workers_per_gather     
---------------------------------    
 0    
(1 row)    

4、单个query, node的并行度

Min(parallel_workers（表级设置，没有设置则，根据表大小计算得到）, max_parallel_workers_per_gather)    

5、表级并行度参数，默认不设置，从表大小计算。

postgres=# alter table pa set (parallel_workers =32);    
ALTER TABLE    

6、真实并行度算法

min (max_worker_processes - 已运行workers ,     
     max_parallel_workers - 其他会话当前真实启用的并行度 ,      
     Min(parallel_workers（表级设置，没有设置则，根据表大小计算得到）, max_parallel_workers_per_gather)     
)    

优化器是否选择并行计算

优化器是否使用并行计算，取决于CBO，选择成本最低的方法，并行计算成本估算，成本因子参数如下：

postgres=# show parallel_tuple_cost ;    
 parallel_tuple_cost     
---------------------    
 0    
(1 row)    
             
postgres=# show parallel_setup_cost ;    
 parallel_setup_cost     
---------------------    
 0    
(1 row)    

如果非并行计算的执行计划成本低于并行计算的成本，则不使用并行计算。

优化器是否忽略并行计算

如果表扫描或索引扫描的表或索引低于设置的阈值，这个表扫描或索引扫描则不启用并行计算。

postgres=# show min_parallel_table_scan_size ;    
 min_parallel_table_scan_size     
------------------------------    
 0    
(1 row)    
    
postgres=# show min_parallel_index_scan_size ;    
 min_parallel_index_scan_size     
------------------------------    
 0    
(1 row)    

优化器强制选择并行计算参数

#force_parallel_mode = on    

并行计算相关参数

1、创建索引，CREATE TABLE AS，SELECT INTO 的并行度

postgres=# show max_parallel_maintenance_workers ;    
 max_parallel_maintenance_workers     
----------------------------------    
 24    
(1 row)    

2、并行分区表JOIN

#enable_partitionwise_join = on    

3、并行分区表分区聚合

#enable_partitionwise_aggregate = on    

4、并行HASH计算

#enable_parallel_hash = on    

5、LEADER主动获取并行WORKER的返回结果

parallel_leader_participation = on    

6、并行APPEND（分区表），UNION ALL查询

#enable_parallel_append = on    

强制并行

强制并行度24

1、总的可开启的WORKER足够大  
postgres=# show max_worker_processes ;  
 max_worker_processes   
----------------------  
 128  
(1 row)  
  
2、所有会话同时执行并行计算的并行度足够大  
postgres=# set max_parallel_workers=64;  
SET  
  
3、单个QUERY中并行计算NODE开启的WORKER=24  
postgres=# set max_parallel_workers_per_gather =24;  
SET  
  
4、所有表和索引扫描允许并行  
postgres=# set min_parallel_table_scan_size =0;  
SET  
postgres=# set min_parallel_index_scan_size =0;  
SET  
  
5、并行计算优化器成本设置为0  
postgres=# set parallel_tuple_cost =0;  
SET  
postgres=# set parallel_setup_cost =0;  
SET  
  
6、设置表级并行度为24  
postgres=# alter table pa set (parallel_workers =24);  
ALTER TABLE  
  
7、效果，强制24并行。  
postgres=# explain (analyze) select count(*) from pa;  
                                                             QUERY PLAN                                                                
-------------------------------------------------------------------------------------------------------------------------------------  
 Finalize Aggregate  (cost=1615.89..1615.89 rows=1 width=8) (actual time=81.711..81.711 rows=1 loops=1)  
   ->  Gather  (cost=1615.83..1615.83 rows=24 width=8) (actual time=81.572..90.278 rows=25 loops=1)  
         Workers Planned: 24  
         Workers Launched: 24  
         ->  Partial Aggregate  (cost=1615.83..1615.83 rows=1 width=8) (actual time=58.411..58.411 rows=1 loops=25)  
               ->  Parallel Seq Scan on pa  (cost=0.00..712.71 rows=416667 width=0) (actual time=0.012..35.428 rows=400000 loops=25)  
 Planning Time: 0.449 ms  
 Execution Time: 90.335 ms  
(8 rows)  

函数并行

1、并行函数

create or replace function ftest(int) returns boolean as $$    
  select $1<1000;    
$$ language sql strict    
parallel safe;    
    
-- parallel safe 语法    

2、并行聚合函数

combinefunc    

《PostgreSQL 11 preview - 多阶段并行聚合array_agg, string_agg》

《PostgreSQL Oracle 兼容性之 - 自定义并行聚合函数 PARALLEL_ENABLE AGGREGATE》

《PostgreSQL 10 自定义并行计算聚合函数的原理与实践 - (含array_agg合并多个数组为单个一元数组的例子)》

GPU并行

《PostgreSQL GPU 加速(HeteroDB pg_strom) (GPU计算, GPU-DIO-Nvme SSD, 列存, GPU内存缓存)》

  

    

		

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
