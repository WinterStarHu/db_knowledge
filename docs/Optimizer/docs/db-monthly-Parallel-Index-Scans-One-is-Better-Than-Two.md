# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/10/03/
> 分类: Optimizer

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
	

  

    
数据库内核月报 － 2019 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb 表空间
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · POLARDB 并行查询加速全程详解
                      

                    

                    

                  
                      

                        MySQL · Optimizer · Parallel Index Scans, One is Better Than Two
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · X-Engine MySQL RDS 用户的新选择
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Sequence Engine
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 分组提交的使用与注意
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · Spark Connector 实战指南
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 12 tpcc - use sysbench-tpcc by Percona-Lab
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  阿里云RDS PG 11开放dblink, postgres_fdw权限
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · Oracle 20c 新特性 - 翻出了PG十年前的特性
                      

                    

 
        

    

  

    
 MySQL · Optimizer · Parallel Index Scans, One is Better Than Two  

    
 Author: Øystein  

  

  

  
As presented at the 
Percona Live Conference in Austin
 in May, at Alibaba we are working on adding support for 
parallel query execution to POLARDB for MySQL
. As discussed in the presentation, we observe that parallel range scans on secondary indexes does not scale very well in MySQL. This is old news. 
Mark Callaghan reported this
 several years ago, and this does not seem to have changed. In this blog post, I will investigate what effects using a multi-processor machine have on the scalability of parallel index range scans.

I will run a variant of Query 6 of the 
TPC-H
/
DBT-3
 benchmark.  While the original Query 6 sums up the revenue for a whole year, my version will only compute it over a single month:

SELECT
 
SUM

(

l_extendedprice
 
*
 
l_discount

)
 
AS
 
revenue

FROM
 
lineitem

WHERE
 
l_shipdate
 
>=
 
'1997-01-01'

  
AND
 
l_shipdate
 
<
 
DATE_ADD

(

'1997-01-01'

,
 
INTERVAL
 
'1'
 
MONTH

)

  
AND
 
l_discount
 
BETWEEN
 
0

.

05
 
-
 
0

.

01
 
AND
 
0

.

05
 
+
 
0

.

01

  
AND
 
l_quantity
 
<
 
25

;

This query was run by multiple parallel threads using sysbench on MySQL 8.0.17.  For each query execution, a random month was picked. The machine used have 2 processors with 16 physical cores each, so with hyper-threading there are in total 64 virtual CPUs. I used a DBT-3 scale factor 1 database, and with a 4 GB InnoDB buffer pool, all data was cached in memory.  MySQL will use the secondary index on 
l_shipdate
 when executing this query.  For comparison, I also ran the same query when forcing MySQL to use table scan instead of index range scan.  The results are presented in this graph:

The throughput when using the secondary index is of course higher than for table scan, since we only need to read data for 1 month instead of for all 84 months when using a full table scan.  However, we see that while the table scan scales almost linearly up to 32 threads, this is not the case for the index range scan.  For 32 threads, the throughput with table scans is more than 30 times higher than with 1 thread.  For index range scan, the increase is only about 7.8x and 9.5x for 32 and 64 threads, respectively.

We can see that for table scan, there is no benefit from hyper-threading; the maximum throughput is reached when having one thread per physical core. In other words, each thread doing table scan is able to execute without any significant interrupts.  For index range scans, on the other hand, we see that we get higher throughput with 64 threads than with 32 threads.  This is an indication that the threads are regularly stalled, and there is a benefit from having other threads that can be scheduled when this happens.

So why are the threads stalled? I think the most likely reason is that there is a synchronization bottleneck related to non-covering secondary index scans. Further investigations are needed to understand where, but my current guess is that it is related to accessing the root page of the B-tree when looking up the row corresponding to the index entry.  (I have turned off the adaptive hash index (AHI) when running these tests, so all primary key look-ups will have to go through the root page.  When using the AHI, the scaling seem to be even worse, but that is different story …)

When there is a lot of thread synchronization, running on multiple processors may increase our problems since the state of the mutex, or whatever is used for synchronization, will have to be synchronized between the caches of the CPUs. To investigate what effects this have for our case, I will use 
Resource Groups
 to make MySQL use only one processor for this query.  First, I will create a resource group, 
cpu1
, that contains the virtual CPUs of processor 1:

CREATE
 
RESOURCE
 
GROUP
 
cpu1
 
TYPE

=

user
 
VCPU

=

16

-

31

,

48

-

63

;

To make our query use this resource group, we add a hint to the query:

SELECT
 
/*+ RESOURCE_GROUP(cpu1) */
 
       
SUM

(

l_extendedprice
 
*
 
l_discount

)
 
AS
 
revenue

FROM
 
lineitem

WHERE
 
l_shipdate
 
>=
 
'1997-01-01'

  
AND
 
l_shipdate
 
<
 
DATE_ADD

(

'1997-01-01'

,
 
INTERVAL
 
'1'
 
MONTH

)

  
AND
 
l_discount
 
BETWEEN
 
0

.

05
 
-
 
0

.

01
 
AND
 
0

.

05
 
+
 
0

.

01

  
AND
 
l_quantity
 
<
 
25

;

We repeat the sysbench runs with this query, and compare the results for index range scans:

We see that using only the cores of one processor, increases the performance.  The maximum throughput is increased by almost 30% by using one processor instead of two! The “scale factors” are now 10.3x and 12.6x for 16 and 32 threads, respectively. Much better, but still a bit away from perfect scaling.  Hence, there is still a need for further investigations. Stay tuned!

This blog post first appeared at 
oysteing.blogspot.com

  

    

		

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
