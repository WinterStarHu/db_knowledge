# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/06/05/
> 分类: migration/upgrade

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
	

  

    
数据库内核月报 － 2016 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 特性分析 · innodb 锁分裂继承与迁移
                      

                    

                    

                  
                      

                        MySQL · 特性分析 ·MySQL 5.7新特性系列二
                      

                    

                    

                  
                      

                        PgSQL · 实战经验 · 如何预测Freeze IO风暴
                      

                    

                    

                  
                      

                        GPDB · 特性分析· Filespace和Tablespace
                      

                    

                    

                  
                      

                        MariaDB · 新特性 · 窗口函数
                      

                    

                    

                  
                      

                        MySQL · TokuDB  · checkpoint过程
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 内部临时表
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 空间优化
                      

                    

                    

                  
                      

                        SQLServer · 最佳实践 · 数据库实现大容量插入的几种方式
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB COUNT(*) 优化(?)
                      

                    

 
        

    

  

    
 MariaDB · 新特性 · 窗口函数  

    
 Author: plinux  

  

  

  
简介

窗口函数（Window Function）是 SQL:2013 标准中提出的，在后续标准版本的更新中也多次扩展，最新的版本是 SQL:2011 中的标准。

从某些方面来说，窗口函数与聚合函数（Aggregate Function）有些类似，他们都是对一系列的行进行聚合计算，然而不同于聚合函数的是，窗口函数的输出并不是被聚集到单独的一行。像 SUM, AVG, COUNT 这些聚合函数最终输出都是一行记录。

窗口函数可以通过计算每行周围窗口上的集合值来分析数据，例如：计算一定记录范围内、一定值域内、或者一段时间内的累计和以及移动平均值等等。之所以使用窗口这个术语，是因为对结果的处理使用了一个滑动的查询结果集范围。

大部分数据库，尤其是商业数据库都支持SQL标准中定义的部分窗口函数，但是MySQL一直没有支持这个特性。窗口函数在MySQL社区一直呼声很高，却一直没有被实现，直到 MairaDB 10.2 响应了客户的需求，实现了部分窗口函数，并且在持续完善中，我们就来简单介绍一下 MairaDB 的窗口函数。

语法

MariaDB的窗口函数查询指定使用 OVER 关键字，默认情况下，用于计算的行集合（Window，窗口）是整个数据集，并且可以用 ORDER BY 子句排序。PARTITION BY 子句可以用于将窗口缩小到特定的集合内。

使用语法：

function (expression) OVER (
  [ PARTITION BY expression_list ]
  [ ORDER BY order_list [ frame_clause ] ] ) 

function:
  A valid window function

expression_list:
  expression | column_name [, expr_list ]

order_list:
  expression | column_name [ ASC | DESC ] 
  [, ... ]

frame_clause:

例如，给出下面的原始数据：

CREATE TABLE student (name CHAR(10), test CHAR(10), score TINYINT); 

INSERT INTO student VALUES 
  ('Chun', 'SQL', 75), ('Chun', 'Tuning', 73), 
  ('Esben', 'SQL', 43), ('Esben', 'Tuning', 31), 
  ('Kaolin', 'SQL', 56), ('Kaolin', 'Tuning', 88), 
  ('Tatiana', 'SQL', 87), ('Tatiana', 'Tuning', 83);

下面两个查询可以分别返回按 test 和 name 分区处理的平均数：

SELECT name, test, score, AVG(score) OVER (PARTITION BY test) 
  AS average_by_test FROM student;
+---------+--------+-------+-----------------+
| name    | test   | score | average_by_test |
+---------+--------+-------+-----------------+
| Chun    | SQL    |    75 |         65.2500 |
| Chun    | Tuning |    73 |         68.7500 |
| Esben   | SQL    |    43 |         65.2500 |
| Esben   | Tuning |    31 |         68.7500 |
| Kaolin  | SQL    |    56 |         65.2500 |
| Kaolin  | Tuning |    88 |         68.7500 |
| Tatiana | SQL    |    87 |         65.2500 |
| Tatiana | Tuning |    83 |         68.7500 |
+---------+--------+-------+-----------------+

SELECT name, test, score, AVG(score) OVER (PARTITION BY name) 
  AS average_by_name FROM student;
+---------+--------+-------+-----------------+
| name    | test   | score | average_by_name |
+---------+--------+-------+-----------------+
| Chun    | SQL    |    75 |         74.0000 |
| Chun    | Tuning |    73 |         74.0000 |
| Esben   | SQL    |    43 |         37.0000 |
| Esben   | Tuning |    31 |         37.0000 |
| Kaolin  | SQL    |    56 |         72.0000 |
| Kaolin  | Tuning |    88 |         72.0000 |
| Tatiana | SQL    |    87 |         85.0000 |
| Tatiana | Tuning |    83 |         85.0000 |
+---------+--------+-------+-----------------+

用例

RANK

描述：

RANK() 可以显示给定行的序号，从1开始，顺序以 ORDER BY 字段排序后的序列为准。

语法：

RANK() OVER (
  [ PARTITION BY partition_expression ]
  [ ORDER BY order_list ]
) 

例子

CREATE TABLE student(course VARCHAR(10), mark int, name varchar(10));

INSERT INTO student VALUES 
     ('Maths', 60, 'Thulile'),
     ('Maths', 60, 'Pritha'),
     ('Maths', 70, 'Voitto'),
     ('Biology', 60, 'Bilal'),
     ('Biology', 70, 'Roger');

SELECT RANK() OVER (PARTITION BY course ORDER BY mark) AS rank,
    DENSE_RANK() OVER (PARTITION BY course ORDER BY mark) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY course ORDER BY mark) AS row_num,
    course, mark, name from student;
+------+------------+---------+---------+------+---------+
| rank | dense_rank | row_num | course  | mark | name    |
+------+------------+---------+---------+------+---------+
|    1 |          1 |       1 | Maths   |   60 | Thulile |
|    1 |          1 |       2 | Maths   |   60 | Pritha  |
|    3 |          2 |       3 | Maths   |   70 | Voitto  |
|    1 |          1 |       1 | Biology |   60 | Bilal   |
|    2 |          2 |       2 | Biology |   70 | Roger   |
+------+------------+---------+---------+------+---------+

CUME_DIST

描述：

CUME_DIST() 可以返回一行数据的累积分布（cumulative distribution）。计算公式如下

(number of rows <= current row) / (total rows)

语法：

CUME_DIST() OVER ( 
  [ PARTITION BY partition_expression ] 
  [ ORDER BY order_list ]
)

例子：

create table t1 (
  pk int primary key,
  a int,
  b int
);

insert into t1 values
( 1 , 0, 10),
( 2 , 0, 10),
( 3 , 1, 10),
( 4 , 1, 10),
( 8 , 2, 10),
( 5 , 2, 20),
( 6 , 2, 20),
( 7 , 2, 20),
( 9 , 4, 20),
(10 , 4, 20);

select pk, a, b,
    rank() over (order by a),
    percent_rank() over (order by a),
    cume_dist() over (order by a)
from t1;
+----+------+------+--------------------------+----------------------------------+-------------------------------+
| pk | a    | b    | rank() over (order by a) | percent_rank() over (order by a) | cume_dist() over (order by a) |
+----+------+------+--------------------------+----------------------------------+-------------------------------+
|  1 |    0 |   10 |                        1 |                     0.0000000000 |                  0.2000000000 |
|  2 |    0 |   10 |                        1 |                     0.0000000000 |                  0.2000000000 |
|  3 |    1 |   10 |                        3 |                     0.2222222222 |                  0.4000000000 |
|  4 |    1 |   10 |                        3 |                     0.2222222222 |                  0.4000000000 |
|  5 |    2 |   20 |                        5 |                     0.4444444444 |                  0.8000000000 |
|  6 |    2 |   20 |                        5 |                     0.4444444444 |                  0.8000000000 |
|  7 |    2 |   20 |                        5 |                     0.4444444444 |                  0.8000000000 |
|  8 |    2 |   10 |                        5 |                     0.4444444444 |                  0.8000000000 |
|  9 |    4 |   20 |                        9 |                     0.8888888889 |                  1.0000000000 |
| 10 |    4 |   20 |                        9 |                     0.8888888889 |                  1.0000000000 |
+----+------+------+--------------------------+----------------------------------+-------------------------------+

select pk, a, b,
       percent_rank() over (order by pk),
       cume_dist() over (order by pk)
from t1 order by pk;
+----+------+------+-----------------------------------+--------------------------------+
| pk | a    | b    | percent_rank() over (order by pk) | cume_dist() over (order by pk) |
+----+------+------+-----------------------------------+--------------------------------+
|  1 |    0 |   10 |                      0.0000000000 |                   0.1000000000 |
|  2 |    0 |   10 |                      0.1111111111 |                   0.2000000000 |
|  3 |    1 |   10 |                      0.2222222222 |                   0.3000000000 |
|  4 |    1 |   10 |                      0.3333333333 |                   0.4000000000 |
|  5 |    2 |   20 |                      0.4444444444 |                   0.5000000000 |
|  6 |    2 |   20 |                      0.5555555556 |                   0.6000000000 |
|  7 |    2 |   20 |                      0.6666666667 |                   0.7000000000 |
|  8 |    2 |   10 |                      0.7777777778 |                   0.8000000000 |
|  9 |    4 |   20 |                      0.8888888889 |                   0.9000000000 |
| 10 |    4 |   20 |                      1.0000000000 |                   1.0000000000 |
+----+------+------+-----------------------------------+--------------------------------+

select pk, a, b,
        percent_rank() over (partition by a order by a),
        cume_dist() over (partition by a order by a)
from t1;
+----+------+------+-------------------------------------------------+----------------------------------------------+
| pk | a    | b    | percent_rank() over (partition by a order by a) | cume_dist() over (partition by a order by a) |
+----+------+------+-------------------------------------------------+----------------------------------------------+
|  1 |    0 |   10 |                                    0.0000000000 |                                 1.0000000000 |
|  2 |    0 |   10 |                                    0.0000000000 |                                 1.0000000000 |
|  3 |    1 |   10 |                                    0.0000000000 |                                 1.0000000000 |
|  4 |    1 |   10 |                                    0.0000000000 |                                 1.0000000000 |
|  5 |    2 |   20 |                                    0.0000000000 |                                 1.0000000000 |
|  6 |    2 |   20 |                                    0.0000000000 |                                 1.0000000000 |
|  7 |    2 |   20 |                                    0.0000000000 |                                 1.0000000000 |
|  8 |    2 |   10 |                                    0.0000000000 |                                 1.0000000000 |
|  9 |    4 |   20 |                                    0.0000000000 |                                 1.0000000000 |
| 10 |    4 |   20 |                                    0.0000000000 |                                 1.0000000000 |
+----+------+------+-------------------------------------------------+----------------------------------------------+

总结

  
支持 ROWS 和 RANGE类型的Frame
    

      
各种类型的Frame界定都支持，包括 RANGE PRECEDING | FOLLOWING n个Frame范围（不同于PostgreSQL 和 SQL Server）

      
RANGE类型的Frame 还不支持 DATE[TIME] 数据类型和四则运算，但MDEV-9727正在进行开发

    

  

  
还不支持 GROUPS类型的Frame（但好像还没有流行的数据库有支持这玩意的）

  
不支持禁用Frame（好像也没其他数据库支持）

  
不支持显式的 NULLS FIRST 和 NULLS LAST

  
不支持窗口函数嵌套处理（就是VALUE_OF(expr AT row_marker [, default_value) 这种语法）

  
下面这些窗口函数都支持：
    

      
“Streamable（流式）” 窗口函数：ROW_NUMBER, RANK, DENSE_RANK

      
一旦分区中的行数知道后，就可以流式处理的窗口函数：PERCENT_RANK, CUME_DIST, NTILE

    

  

  
目前支持窗口函数的聚合函数有： COUNT, SUM, AVG, BIT_OR, BIT_AND, BIT_XOR

  
包含 DISTINCT 子句的聚合函数不支持作为窗口函数

大家可以在
这里
查看具体支持哪些函数以及未来新增了哪些函数

  

    

		

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
