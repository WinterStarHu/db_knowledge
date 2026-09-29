# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/07/06/
> 分类: 引擎特性

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
	

  

    
数据库内核月报 － 2019 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 最佳实践 · Statement Outline
                      

                    

                    

                  
                      

                        PgSQL · 新特性解读 · undo log 存储接口（上）
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Buffer Pool 漫谈
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · oplog 查询优化
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · pg_cron 内核分析及用法简介
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · CTE(Common Table Expressions)
                      

                    

                    

                  
                      

                        Database · 理论基础 · Mass Tree
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · `slow log` 与`CSV`引擎
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 使用SQL查询数据库日志
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL psql的元素周期表
                      

                    

 
        

    

  

    
 MySQL · 引擎特性 · CTE(Common Table Expressions)  

    
 Author: weixiang  

  

  

  
前言

CTE也就是common table expressions是sql标准里的语法，很多数据库都能够支持，MySQL也在8.0版本里加入了CTE功能，本文主要简单的介绍下该语法的用法，由于笔者对server层了解不深，本文不探讨代码层

CTE与derived table最大的不同之处是

  
可以自引用，递归使用（recursive cte

  
在语句级别生成独立的临时表. 多次调用只会执行一次

  
一个cte可以引用另外一个cte

  
一个CTE语句其实和CREATE [TEMPORARY] TABLE类似，但不需要显式的创建或删除，也不需要创建表的权限。更准确的说，CTE更像是一个临时的VIEW

示例

语法：

with_clause:
  WITH [RECURSIVE]
cte_name [(col_name [, col_name] ...)] AS (subquery)
  [, cte_name [(col_name [, col_name] ...)] AS (subquery)] ...

一条语句里可以创建多个cte，用逗号隔开:

WITH cta1 AS (SELECT sum(k) from sbtest1 where id < 100) ,  
     cta2 AS (SELECT SUM(k) from sbtest2 WHERE id < 100) 
  SELECT * FROM cta1 JOIN cta2 ;
  +----------+----------+
  | sum(k)   | SUM(k)   |
  +----------+----------+
  | 49529621 | 49840812 |
  +----------+----------+
  1 row in set (0.00 sec)

递归CTE示例：

  root@sb1 09:41:34>WITH RECURSIVE cte (n) AS
  -> (
      ->   SELECT 1
      ->   UNION ALL
      ->   SELECT n + 1 FROM cte WHERE n < 5
      -> )
  -> SELECT * FROM cte;
  +------+
  | n    |
  +------+
  |    1 |
  |    2 |
  |    3 |
  |    4 |
  |    5 |
  +------+
  5 rows in set (0.00 sec)

递归CTE需要加RECURSIVE关键字，使用Union all来产生结果

  SELECT ...定义初始化值，不引用自身, 同时初始化值的列也定义了cte上的列的个数和类型，可以用cast重定义
  UNION ALL
  SELECT ....返回更多的值，并定义退出循环条件，这里引用了cte自身

  其实现类似于：

  - non-recursive query block is evaluated, result goes into an internal tmp table
  - if no rows, exit
  - (A): recursive query block is evaluated over the tmp table's lastly inserted
         rows, and it produces new rows which are appended to the tmp table (if UNION
             ALL; only distinct not-already-there rows if UNION DISTINCT)
  - if the last step didn't produce new rows, exit
- goto (A)

递归的部分不可以包含:

Aggregate functions such as SUM()
Window functions
GROUP BY
ORDER BY
LIMIT
DISTINCT

再举个典型的斐波拉契数(Fibonacci Series Generation)

  WITH RECURSIVE fibonacci (n, fib_n, next_fib_n) AS
  (
   SELECT 1, 0, 1
   UNION ALL
   SELECT n + 1, next_fib_n, fib_n + next_fib_n
   FROM fibonacci WHERE n < 10
  )
  SELECT * FROM fibonacci;

  +------+-------+------------+
  | n    | fib_n | next_fib_n |
  +------+-------+------------+
  |    1 |     0 |          1 |
  |    2 |     1 |          1 |
  |    3 |     1 |          2 |
  |    4 |     2 |          3 |
  |    5 |     3 |          5 |
  |    6 |     5 |          8 |
  |    7 |     8 |         13 |
  |    8 |    13 |         21 |
  |    9 |    21 |         34 |
  |   10 |    34 |         55 |
  +------+-------+------------+
  10 rows in set (0.00 sec)

关于递归的深度，除了自定义推出条件外，为了避免无限递归，也定义了一个系统参数
cte_max_recursion_depth
来限制深度，默认值为1000:

  root@sb1 09:53:31>SELECT @@SESSION.cte_max_recursion_depth;
  +-----------------------------------+
  | @@SESSION.cte_max_recursion_depth |
  +-----------------------------------+
  |                              1000 |
  +-----------------------------------+
  1 row in set (0.01 sec)

  root@sb1 09:53:42>WITH RECURSIVE cte (n) AS (   SELECT 1   UNION ALL   SELECT n + 1 FROM cte WHERE n  < 1001) SELECT * FROM cte;
  ERROR 3636 (HY000): Recursive query aborted after 1001 iterations. Try increasing @@cte_max_recursion_depth to a larger value.

如何实现

前文已经说过，笔者对Server层代码了解不多，这里只做简单的记录

主要提交的代码

想看实现思路可以阅读如下两个worklog：

WL#883: Non-recursive WITH clause (Common Table Expression)

WL#3634: Recursive WITH (Common Table Expression)

参考文档

官方文档

A Definitive Guide To MySQL Recursive CTE

An Introduction to MySQL CTE

MySQL | Recursive CTE (Common Table Expressions)

之前的月报文章

  

    

		

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
