# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/06/01/
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
	

  

    
数据库内核月报 － 2024 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB优化器功能 - 连接消除
                      

                    

                    

                  
                      

                        MySQL 深潜 - Semijoin 丛林小道全览
                      

                    

 
        

    

  

    
 PolarDB优化器功能 - 连接消除  

    
 Author: 赵欣昊  

  

  

  
前言

在关系型数据库的查询处理中，数据库优化器是一项关键技术，它负责将用户写的SQL查询语句转化为高效的执行计划。连接操作（JOIN）是SQL语句中最常见也最为耗时的运算操作之一，但在某些情况下，连接可能由于表设计或查询逻辑而无需执行。PolarDB优化器的连接消除功能旨在通过分析表定义、查询条件和连接方式等情况，识别和移除查询计划中不必要的连接操作，从而提高查询执行速度。

考虑一个常见的业务场景，业务方定义了一个涉及订单明细表（lineitem）与配件表（part）的外连接（OUTER JOIN）的视图，其中partkey是配件表的主键。

CREATE
 
VIEW
 
v
 

AS
 

SELECT
 
*
 

FROM
 

...,

lineitem
 
LEFT
 
JOIN
 
part
 
ON
 
lineitem

.

partkey
 
=
 
part

.

partkey

;

如果在一次查询中，需求方只需要lineitem表中的信息，那么他的查询语句可能写成

SELECT
 
l_cols
 
FROM
 
v

;

这里l_cols表示lineitem表中的任意列。根据SQL的语义，由于lineitem与part表以左连接方式连接，因此lineitem表中的每一行都会在连接结果中出现；另一方面，由于partkey是part表的主键，因此lineitem表中的每一行只能与part表中最多一行满足连接条件。因此，连接结果中的每一行与lineitem表中的每一行一一对应。又因为需求方的查询语句中没有出现part表的相关信息，所以part表是冗余的，上述语句等价于

SELECT
 
l_cols

FROM
 
(

    
SELECT
 
*

    
FROM

    
...,

    
lineitem

)
 
as
 
v

;

除了外连接，内连接（INNER JOIN）、半连接（SEMI JOIN）等连接方式在一定条件下也可以被消除。接下来我们对不同连接方式的消除原理和场景做简要介绍。

外连接消除

前文所述的外连接消除满足两个条件：其一是
外连接的内表列未被外部引用
（1），其二是
外连接中外表列与内表的主键列相等
（2）。满足这两个条件的连接运算产生的结果集与直接使用外表进行查询的结果集一致，因此外连接可以消除。

仔细思考这两个条件，我们可以发现它们都不是必须的。

条件（1）的存在是因为查询要通过读取内表的数据来确定引用内表列的表达式结果。那么能否不读取内表就确定表达式结果呢？当外连接的连接条件恒为假时，根据SQL语义，内表列在经过连接之后一定为NULL，所以引用内表列的表达式无需读取内表即可求值。同时，外连接条件恒为假时，也能保证外表的每一行在连接结果中仍然恰好保留一行，查询结果不变，因此外连接可以消除。一个简单的例子如下所示。

SELECT
 
t1

.

a

,
 
t2

.

b
 
FROM
 
t1
 
LEFT
 
JOIN
 
t2
 
ON
 
FALSE

;

==>

SELECT
 
t1

.

a

,
 
NULL
 
FROM
 
t1

;

条件（2）同样可以放宽：内表的主键是为了保证外表的每一行在连接结果中具有唯一性，从而保证连接消除后查询结果不变。因此，如果
保证外表的每一行在连接结果中具有唯一性
（2.1），或者
连接结果重复不会导致最终查询结果发生变化
（2.2），那么都可以推出外连接可以消除。

不难想到，只要与外表列相等的内表列在内表上具有唯一性，就可以推出条件（2.1）。这种唯一性可以来自于表定义中的主键、唯一键，也可以来自于语句中的DISTINCT、GROUP BY等关系运算，并且唯一性还可以在表达式和关系模式间传递。在PolarDB MySQL查询优化器中，我们通过分析表定义和关系运算中蕴涵的函数依赖关系，构建函数依赖图，从而推导出各个表达式是否具有唯一性。例如，考虑如下变换

SELECT
 
t1

.

*
 
FROM
 
t1
 
LEFT
 
JOIN
 
(

SELECT
 
DISTINCT
 
a

,
 
a
 
*
 
a
 
as
 
b
 
FROM
 
t2

)
 
dt
 
ON
 
t1

.

a
 
=
 
dt

.

a

;

==>

SELECT
 
t1

.

*
 
FROM
 
t1

;

这一语句中，DISTINCT运算符蕴含了{a, b}两列集合具有唯一性，同时b是a的确定性函数，因此可以推导得到a具有唯一性，外连接可以消除。

对于条件（2.2），连接运算同层或外层的DISTINCT/GROUP BY等运算能够消除外连接产生的重复行，因此不会导致最终结果发生变化。例如

SELECT
 
t1

.

b

,
 
MAX

(

t1

.

c

)
 
FROM
 
t1
 
LEFT
 
JOIN
 
t2
 
ON
 
t1

.

a
 
=
 
t2

.

b
 
GROUP
 
BY
 
t1

.

b

;

==>

SELECT
 
t1

.

b

,
 
MAX

(

t1

.

c

)
 
FROM
 
t1
 
GROUP
 
BY
 
t1

.

b

;

MAX聚集运算的结果不会被输入列中是否有重复所影响，GROUP BY运算消除了外连接产生的重复行，因此语句中的外连接可以消除。此外，半连接（SEMI JOIN），子查询等结构也能够避免连接结果中的重复影响最终查询结果。

内连接/半连接消除

内连接消除

内连接与外连接SQL语义的区别是，外连接会返回外表中的所有行，而内连接只会返回符合连接条件的结果。因此，内连接消除需要额外条件来保证
要保留的表的每一行在连接结果中至少存在一行
（3）。

一个常见的满足这一条件的场景是外键表与主键表的连接运算。下面是一个主外键连接条件下内连接消除的例子。

CREATE
 
TABLE
 
t1
 
(

a
 
INT
 
PRIMARY
 
KEY

,
 
b
 
INT

);

CREATE
 
TABLE
 
t2
 
(

a
 
INT

,
 
b
 
INT

,
 
FOREIGN
 
KEY
 
(

a

)
 
REFERENCES
 
t1

(

a

));

SELECT
 
t1

.

a

,
 
t2

.

a
 
FROM
 
t1

,
 
t2
 
WHERE
 
t1

.

a
 
=
 
t2

.

a

;

==>

SELECT
 
t2

.

a

,
 
t2

.

a
 
FROM
 
t2
 
WHERE
 
t2

.

a
 
IS
 
NOT
 
NULL

;

表t2的a列是表t1的列a的外键，因此对t2中的任意一行，t1中一定存在至少一行满足t1.a = t2.a，条件（3）成立。t1的列a是t1的主键，因此t1中一定只有一行满足t1.a = t2.a，因此连接结果中表t2的行具有唯一性（对应于外连接消除的条件2）。除了在连接条件中被限制与t2.a值相等的t1.a以外，被消除的表t1没有其他列被引用，经过t1.a到t2.a的替换后，所有被消除表t1的列都不被外部引用（对应于外连接消除的条件1）。因此，上述语句中的内连接可以消除。需要注意的是，不同于外连接消除，内连接的连接条件不能直接删除，因为条件t1.a = t2.a隐含着t2.a不能为NULL的条件，在连接消除后仍然需要保留。

在某些场景下，外键引用列的唯一性无法保证，连接结果中可能存在重复行，此时直接消除内连接会导致连接结果中的重复行被消除。类似于外连接消除，如果连接结果重复不会导致最终查询结果发生变化，那么内连接仍然可以消除。考虑下列语句。

CREATE
 
TABLE
 
t1
 
(

a
 
INT

,
 
b
 
INT

,
 
UNIQUE
 
KEY

(

a

,
 
b

));

CREATE
 
TABLE
 
t2
 
(

a
 
INT

,
 
b
 
INT
 
NOT
 
NULL

,
 
FOREIGN
 
KEY
 
(

a

,
 
b

)
 
REFERENCES
 
t1

(

a

,
 
b

));

SELECT
 
DISTINCT
 
t1

.

a

,
 
t2

.

a
 
FROM
 
t1

,
 
t2
 
WHERE
 
t1

.

a
 
=
 
t2

.

a

;

==>

SELECT
 
DISTINCT
 
t2

.

a

,
 
t2

.

a
 
FROM
 
t2
 
WHERE
 
t2

.

a
 
IS
 
NOT
 
NULL

;

t1与t2的连接条件中只有t1.a=t2.a这一条件，但a列不具有唯一性，t2表的每一行在两表连接结果中可能出现多次。SELECT语句中的DISTINCT运算消除了重复，因此连接可以消除。

另一个常见的场景是，如果我们能确定连接运算的两表数据具有相等或包含关系，那么在适当的连接条件下，也可以满足条件（3）。例如

CREATE
 
TABLE
 
t1
 
(

a
 
INT
 
UNIQUE

,
 
b
 
INT

);

SELECT
 
t1

.

*

,
 
dt

.

*
 
FROM
 
t1

,
 
(

SELECT
 
*
 
FROM
 
t1
 
WHERE
 
b
 
>
 
1

)
 
dt
 
WHERE
 
t1

.

a
 
=
 
dt

.

a

;

==>

SELECT
 
dt

.

*

,
 
dt

.

*
 
FROM
 
(

SELECT
 
*
 
FROM
 
t1
 
WHERE
 
b
 
>
 
1

)
 
dt
 
WHERE
 
dt

.

a
 
IS
 
NOT
 
NULL

;

这里dt表的结果集是t1表的子集，连接条件保证了dt表数据在连接结果中的存在性和唯一性，因此内连接可以消除。

半连接消除

半连接与内连接的语义类似，都是只保留符合连接条件的结果，但半连接的语义进一步保证了所有内表不会被外部引用，并且外表行在连接结果中一定最多只有一行。这里仅给出一个半连接消除的例子，不再赘述。

CREATE
 
TABLE
 
t1
 
(

a
 
INT

,
 
b
 
INT

,
 
UNIQUE
 
KEY

(

a

,
 
b

));

CREATE
 
TABLE
 
t2
 
(

a
 
INT

,
 
b
 
INT
 
NOT
 
NULL

,
 
FOREIGN
 
KEY
 
(

a

,
 
b

)
 
REFERENCES
 
t1

(

a

,
 
b

));

SELECT
 
t2

.

*
 
FROM
 
t2
 
WHERE
 
EXISTS
 
(

SELECT
 
*
 
FROM
 
t1
 
WHERE
 
t1

.

a
 
=
 
t2

.

a

);

==>

SELECT
 
t2

.

*
 
FROM
 
t2
 
SEMI
 
JOIN
 
t1
 
WHERE
 
t1

.

a
 
=
 
t2

.

a

;

==>

SELECT
 
t2

.

*
 
FROM
 
t2
 
WHERE
 
t2

.

a
 
IS
 
NOT
 
NULL

;

总结

由于篇幅原因，本文仅简要介绍了连接消除的原理及其在不同连接方式下的部分消除场景。该功能预计将在PolarDB 8.0.2.2.25版本中上线，可通过设置如下参数开启。

SET
 
join_elimination_mode

=

ON

;
 
-- 对rw和ro节点都开启

SET
 
join_elimination_mode

=

REPLICA_ON

;
 
-- 只对ro节点开启

未来，PolarDB内核团队将继续深耕优化器领域，提升数据库查询性能，为用户带来更优质的体验。

  

    

		

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
