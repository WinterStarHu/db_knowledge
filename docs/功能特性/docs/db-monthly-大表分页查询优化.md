# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/12/06/
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
	

  

    
数据库内核月报 － 2022 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB MySQL 新特性 - Partial Result Cache
                      

                    

                    

                  
                      

                        MySQL Temporal Data Types
                      

                    

                    

                  
                      

                        Innodb 中的 Btree 实现 (一) · 引言 & insert 篇
                      

                    

                    

                  
                      

                        MySQL · 业务场景 · 业务并发扣款，金额未扣
                      

                    

                    

                  
                      

                        PolarDB MySQL · 功能特性 · Fast Query Cache技术详解与最佳实践
                      

                    

                    

                  
                      

                        PolarDB MySQL · 功能特性 · 大表分页查询优化
                      

                    

                    

                  
                      

                        查询性能定位没现场？要统计各维度Top SQL？PolarDB MySQL新功能SQL Trace
                      

                    

 
        

    

  

    
 PolarDB MySQL · 功能特性 · 大表分页查询优化  

    
 Author: 勉仁  

  

  

  
在社区MySQL中，业务如果对大表做深度分页查询往往性能很差，查询的响应时间很难满足业务的需求。PolarDB MySQL对深度分页场景优化，可以极大提升分页查询性能。

社区MySQL深度分页

我们基于TPCH(Scale 10)的表举例，比如业务对订单明细表（lineitem表）按照特定发货日期(l_shipDATE列)范围查询订单明细信息。
如果100行每页，我们查询1万页以后的查询如下：

SELECT
 
*

FROM
   
lineitem

WHERE
  
l_shipdate
 
>
 
'1997-01-01'

       
AND
 
l_shipdate
 
<
 
'1997-08-01'

ORDER
  
BY
 
l_shipdate

LIMIT
  
1000000

,
 
100

;

在社区MySQL中，我们可以看到如下执行计划，选择了列l_shipDATE的索引，利用索引序不需要做额外的sort操作。

mysql

>
 
explain
 
select
 
*
 
from
 
lineitem
 
where
 
l_shipDATE
 
>

'1997-01-01'
 
and
 
l_shipDATE
 
<
 
'1997-05-01'
 
order
 
by
 
l_shipDATE
 
limit
 
1000000

,
 
100

\

G

***************************
 
1

.
 
row
 
***************************

           
id

:
 
1

  
select_type

:
 
SIMPLE

        
table

:
 
lineitem

   
partitions

:
 
NULL

         
type

:
 
range

possible_keys

:
 
i_l_shipdate

          
key

:
 
i_l_shipdate

      
key_len

:
 
4

          
ref

:
 
NULL

         
rows

:
 
5820160

     
filtered

:
 
100

.

00

        
Extra

:
 
Using
 
index
 
condition

在

PolarDB

中对

optimizer_switch

做如下设置，可以得到社区

MySQL

的执行计划。

mysql

>
 
set
 
@@

optimizer_switch

=

'limit_offset_pushdown=off,detach_range_condition=off'

;

上述深度分页查询，当完全是冷数据的时候需要48.77s，全在内存中时候耗时也需要4.99s。这对于使用该业务的客户，等待时间就很难接受。

mysql

>
 
select
 
*
 
from
 
lineitem
 
where
 
l_shipDATE
 
>

'1997-01-01'
 
and
 
l_shipDATE
 
<
 
'1997-05-01'
 
order
 
by
 
l_shipDATE
 
limit
 
1000000

,
 
100

;

而且该时间会随着数据量的增加而大幅增加，当200万行数据的时候冷数据要63.17s，热数据要10.04s。这里冷数据没有线性增加是因为物理IO因为已经读取的page在后面被使用而没有线性增加。如果是InnoDB buffer pool相比读取数据小，比如这里200万行的读取，设置Buffer pool size为128M，那么执行时间就需要225s。

mysql

>
 
select
 
*
 
from
 
lineitem
 
where
 
l_shipDATE
 
>

'1997-01-01'
 
and
 
l_shipDATE
 
<
 
'1997-05-01'
 
order
 
by
 
l_shipDATE
 
limit
 
2000000

,
 
100

;

MySQL中所有的分页操作都会从存储引擎中将数据行逐行取出，上面的查询还要回表取非索引列数据，然后交给SQL层，SQL层检查条件，然后将不需要返回给客户端的offset数据过滤掉。

PolarDB深度分页

在PolarDB中，优化器会分析深度分页查询的谓词条件，如果谓词条件能够在引擎的扫描范围中体现，那么就会把谓词条件的检查完全下推到引擎层，从SQL层移除。上面场景中移除谓词条件后，PolarDB会把分页数据中offset的扫描也下推到引擎层，做快速的扫描过滤。同时如果需要回表访问，PolarDB会仅对最后需要返回客户端数据做回表，极大的减少开销。

上面的查询在PolarDB中默认计划如下：

mysql

>
 
explain
 
select
 
*
 
from
 
lineitem
 
where
 
l_shipDATE
 
>

'1997-01-01'
 
and
 
l_shipDATE
 
<
 
'1997-05-01'
 
order
 
by
 
l_shipDATE
 
limit
 
1000000

,
 
100

\

G

***************************
 
1

.
 
row
 
***************************

           
id

:
 
1

  
select_type

:
 
SIMPLE

        
table

:
 
lineitem

   
partitions

:
 
NULL

         
type

:
 
range

possible_keys

:
 
i_l_shipdate

          
key

:
 
i_l_shipdate

      
key_len

:
 
4

          
ref

:
 
NULL

         
rows

:
 
5820160

     
filtered

:
 
100

.

00

        
Extra

:
 
Using
 
limit

-

offset
 
pushdown

在PolarDB中冷数据100w行深度分页执行时间0.21s，热数据执行主要0.07s。
对于200w行的深度分页，冷数据执行时间0.41s，热数据执行时间0.15s。当设置Buffer pool size为128M的时候，执行时间依然为0.15s，因为PolarDB 分页的200w行数据是不需要查询主键的，能够避免大量的随机IO，BP能够缓存大量二级索引数据。

性能对比总结

  

    

      
 

      
100w行深度分页冷数据

      
100w行深度分页热数据

      
200w行深度分页冷数据

      
200w行深度分页热数据

      
200w行深度分页低BP size

    

  

  

    

      
社区MySQL

      
48.77s

      
4.99s

      
63.17s

      
10.04s

      
225s

    

    

      
PolarDB MySQL

      
0.21s

      
0.07

      
0.41s

      
0.15s

      
0.15s

    

    

      
PolarDB MySQL提升

      
232倍

      
71倍

      
154倍

      
67倍

      
1500倍

    

  

上面可以看到在通过索引深度分页查询表上各个列信息情况下，PolarDB MySQL可以有67到200倍以上的性能提升，对于Buffer pool size小于数据大小的场景可以有更大的提升。在不需要回表，仅查询二级索引列的场景，热数据情况下PolarDB也可以有6倍性能提升。可参加PolarDB MySQL深度分页优化的官网
功能介绍文档
。

  

    

		

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
