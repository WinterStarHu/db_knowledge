# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2020/10/01/
> 分类: 源码分析

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
	

  

    
数据库内核月报 － 2020 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 · 子查询优化源码分析
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · undo tablespace 的发展
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · How to read the lock information from debugger
                      

                    

 
        

    

  

    
 MySQL · 源码分析 · 子查询优化源码分析  

    
 Author: 李博  

  

  

  
子查询定义

在一个完整的查询语句中包含的子查询块被称为子查询。通常情况下，我们可以将出现在SELECT、WHERE和HAVING语法中的子查询块称为嵌套子查询，出现在FROM语法后的子查询块称为内联视图或派生表。

本篇文章将会结合源码介绍在MySQL中针对子查询的几种优化策略。

子查询在执行计划中的表示

Semijoin/Antijoin

对于表示是否存在语义的查询语句，在语法上表示为IN/=ANY/EXISTS，优化器会尝试转换为semijoin/antijoin进行优化。与普通join会将左表和右表的记录连接在一起不同，semijoin/antijoin仅关心右表中是否存在可以与左表记录连接的记录，而返回左表记录。

在prepare阶段，优化器会首先检查当前查询是否可以转换为semijoin/antijoin的条件（由于antijoin是semijoin的相反，在代码层面也是一块处理的，所以之后的论述以semijoin为主），这部分代码在
SELECT_LEX::resolve_subquery
中，具体的条件总结如下：

  
子查询必须是谓词IN/=ANY/EXISTS的一部分，并且出现在WHERE或ON语法的最高层，可以被包含在AND表达式中。

  
必须是单个查询块，不带有UNION。

  
不包含HAVING语法。

  
不包含任何聚合函数。

  
不包含LIMIT语法。

  
外查询语句没有使用STRAIGHT_JOIN语法。

如果满足条件，将会把当前谓词加入到外查询的
SELECT_LEX::sj_candidates
中作为semijon的备选。

由于优化器对查询块的处理是一种递归的方式，在完成对子查询的判断之后，在外层查询的prepare阶段，会调用
SELECT_LEX::flatten_subqueries
函数完成子查询到semijoin的最终转换，这个过程在整个查询的生命周期只会发生一次，且不可逆。在SQL语法上等价为：

从一个带有备选

semijoin

子查询判断条件的查询块：

    
SELECT
 
...

    
FROM
 
ot

,
 
...

    
WHERE
 
oe
 
IN
 
(

SELECT
 
ie
 
FROM
 
it1
 
...
 
itN
 
WHERE
 
subq_where

)
 
AND
 
outer_where

转换为：

    
SELECT
 
...

    
FROM
 
ot
 
SEMI
 
JOIN
 
(

it1
 
...
 
itN

),
 
...

    
WHERE
 
outer_where
 
AND
 
subq_where
 
AND
 
oe

=

ie

为了实现上述过程，需要进行以下步骤：

  
创建
SEMI JOIN (it1 ... itN)
语以部分，并加入到外层查询块的执行计划中。

  
将子查询的WHERE条件以及JOIN条件，加入到父查询的WHERE条件中。

  
将子查询谓词从父查询的判断谓词中消除。

具体的伪代码如下：

SELECT_LEX

::

flatten_subqueries

()

     
/* Semijoin flattening is bottom-up. Indeed, we have this execution flow,
        for SELECT#1 WHERE X IN (SELECT #2 WHERE Y IN (SELECT#3)) :

        SELECT_LEX::prepare() (select#1)
           -> fix_fields() on IN condition
               -> SELECT_LEX::prepare() on subquery (select#2)
                   -> fix_fields() on IN condition
                        -> SELECT_LEX::prepare() on subquery (select#3)
                        <- SELECT_LEX::prepare()
                   <- fix_fields()
                   -> flatten_subqueries: merge #3 in #2
                   <- flatten_subqueries
               <- SELECT_LEX::prepare()
           <- fix_fields()
           -> flatten_subqueries: merge #2 in #1

        Note that flattening of #(N) is done by its parent JOIN#(N-1), because
        there are cases where flattening is not possible and only the parent can
        know.*/

   
|--

子查询层层嵌套中采用

bottom

-

up

的方式去展开。在

fix_fields

()

的过程中依次从里往外。仅支持

IN

和

EXISTS

的子查询，且内层的

sj_candidates

为空。

   
|--

由于在

WHERE

条件同一层可能存在多个可以展开的子查询判断，首先会计算优先级来决定

semijoin

展开顺序：

      
1.
 
依赖外层查询的子查询优先于不相关子查询。

      
2.
 
有着更多表的子查询优先于更少表的子查询。

      
3.
 
顺序上先计算的子查询优先于后计算的。

   
|--

semijoin

子查询不能和

antijoin

子查询相互嵌套。

   
|--

判断子查询的

WHERE

条件是否为常量。

      
如果判断条件永远为

FALSE

，那么子查询结果永远为空。该情况下，可以将子查询直接清除，不用转换成

semijoin

。

   
|--

替换外层查询的

WHERE

条件中子查询判断的条件

      
1.
 
子查询内条件并不永远为

FALSE

，或者永远为

FALSE

的情况下，需要改写为

antijoin

（

antijoin

情况下，子查询结果永远为空，外层查询条件永远通过）。

         
此时将条件改为永远为

True

。

      
2.
 
子查询永远为

FALSE

，且不是

antijoin

。那么将外层查询中的条件改成永远为

False

。

      
/* 子查询判断条件可能为IN/=ANY/EXISTS，或者对应的否定。参数为Item_exists_subselect *。
         The following transformations are performed:

         1. IN/=ANY predicates on the form:

         SELECT ...
         FROM ot1 ... otN
         WHERE (oe1, ... oeM) IN (SELECT ie1, ..., ieM
                                  FROM it1 ... itK
                                 [WHERE inner-cond])
          [AND outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         are transformed into:

         SELECT ...
         FROM (ot1 ... otN) SJ (it1 ... itK)
                           ON (oe1, ... oeM) = (ie1, ..., ieM)
                              [AND inner-cond]
         [WHERE outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         Notice that the inner-cond may contain correlated and non-correlated
         expressions. Further transformations will analyze and break up such
         expressions.

         2. EXISTS predicates on the form:

         SELECT ...
         FROM ot1 ... otN
         WHERE EXISTS (SELECT expressions
                       FROM it1 ... itK
                       [WHERE inner-cond])
          [AND outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         are transformed into:

         SELECT ...
         FROM (ot1 ... otN) SJ (it1 ... itK)
                            [ON inner-cond]
         [WHERE outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         3. Negated EXISTS predicates on the form:

         SELECT ...
         FROM ot1 ... otN
         WHERE NOT EXISTS (SELECT expressions
                       FROM it1 ... itK
                       [WHERE inner-cond])
          [AND outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         are transformed into:

         SELECT ...
         FROM (ot1 ... otN) AJ (it1 ... itK)
                            [ON inner-cond]
         [WHERE outer-cond AND is-null-cond(it1)]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         where AJ means "antijoin" and is like a LEFT JOIN; and is-null-cond is
         false if the row of it1 is "found" and "not_null_compl" (i.e. matches
         inner-cond).

         4. Negated IN predicates on the form:

         SELECT ...
         FROM ot1 ... otN
         WHERE (oe1, ... oeM) NOT IN (SELECT ie1, ..., ieM
                                  FROM it1 ... itK
                                  [WHERE inner-cond])
         [AND outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         are transformed into:

         SELECT ...
         FROM (ot1 ... otN) AJ (it1 ... itK)
                            ON (oe1, ... oeM) = (ie1, ..., ieM)
                            [AND inner-cond]
         [WHERE outer-cond]
         [GROUP BY ...] [HAVING ...] [ORDER BY ...]

         5. The cases 1/2 (respectively 3/4) above also apply when the predicate is
         decorated with IS TRUE or IS NOT FALSE (respectively IS NOT TRUE or IS FALSE).*/

   
|--

SELECT_LEX

::

convert_subquery_to_semijoin

()
 
// 将当前查询块中包含的子查询判断转换成TABLE_LIST中的semijoin嵌套，antijoin也在里面完成。

     
|--

生成一个新的

semijoin

嵌套的

TABLE_LIST

表

     
|--

TABLE_LIST

::

merge_underlying_tables

()
 
// 将子查询中潜在的表合并到上述join表中

     
|--

将子查询的叶子表插入到当前查询块的叶子表后面，重新设置子查询的叶子表的序号和依赖的外表。将子查询的叶子表重置。

     
|--

如果是

outer
 
join

的话，在

join

链表中传递可空性。

     
|--

SELECT_LEX

::

decorrelate_condition

()

       
|--

将内层子查询中的关联条件去关联化，这些条件被加入到

semijoin

的列表里。这些条件必须是确定的，仅支持简单判断条件或者由简单判断条件组成的

AND

条件。

       
|--

decorrelate_equality

()

         
|--

判断左右条件是否仅依赖于内外层表，将其表达式分别加入到

semijoin

内外表的表达式列表中。

     
|--

decorrelate_join_conds

()
 
// 解关联内层查询的join条件

     
|--

Item_cond_and

::

fix_after_pullout

()
 
// 将子查询的WHERE条件上拉，更新使用表的信息

     
|--

SELECT_LEX

::

build_sj_cond

()
 
// 根据semijoin的条件列表创建AND条件，如果有条件为常量True，则去除该条件；如果常量为False，则整个条件都去除。

     
|--

将创建出来的

semijoin

条件加入到外层查询的

WHERE

条件中

物化执行 or 迭代式循环执行

对于不能采用semijoin/antijoin执行的存在式语义的子查询，在MySQL源码的表示含义下，会做IN->EXISTS的转换，其实本质是在物化执行和迭代式循环执行中做选择。IN语法代表非相关子查询仅执行一次，将查询结果物化成临时表，之后需要结果时候就去物化表中查找；EXISTS代表对于外表的每一条记录，子查询都会执行一次，是迭代式循环执行。

MySQL会在prepare阶段尝试做IN->EXISTS的转换，然后在optimize阶段，比较IN or EXISTS执行的代价，最后根据代价决定采用哪种执行策略完成最终转换。

在prepare阶段IN->EXISTS的转换主要是将IN语法的左表达式与右表达式中子查询的输出列对应组合，加入到子查询的WHERE或者HAVING条件中，在SQL语义上表示为：

outer_expr
 
IN
 
(

SELECT
 
inner_expr
 
FROM
 
...
 
WHERE
 
subquery_where

)

转换为：

EXISTS
 
(

SELECT
 
1
 
FROM
 
...
 
WHERE
 
subquery_where
 
AND
 
outer_expr

=

inner_expr

)

这一过程主要发生在
Item_in_subselect::single_value_in_to_exists_transformer
中，详细过程为：

/* 通过判断条件注入将IN语法转换为EXISTS语法
   向子查询中注入额外的判断条件，并将子查询标记为关联子查询。*/

|--

Item_in_subselect

::

single_value_in_to_exists_transformer

()

  
|--

如果子查询包含聚合函数、窗口函数、

GROUP

语法、

HAVING

语法，将判断条件加入到

HAVING

语法中。

  
|--

如果我们想区分

NULL

和

False

的结果的话，将这个条件封装到触发器中。

     
SELECT
 
ie
 
FROM
 
...
 
HAVING
 
subq_having
 
AND

               
trigcond

(

oe
 
$

cmp

$
 
ref_or_null_helper

<

ie

>

)

  
|--

创建指向子查询唯一列的

Item_ref_null_helper

对象，与之前注入的左表达式

Item_ref

共同创建比较表达式

  
|--

如果子查询的第一个列为包含聚合列的表达式，那么

WHERE

和

HAVING

语法中可能通过不同的

Item_ref

引用到这个

Item

，存入到

Item_sum

::

ref_by

数组中

  
|--

and_items

()
 
// 加入到HAVING条件中

|--

如果不包含聚合函数、窗口函数、

GROUP

语法、

HAVING

语法，将判断条件加入

WHERE

语句中

  
|--

如果不需要区分

NULL

与

False

的结果：

     
SELECT
 
1
 
FROM
 
...
 
WHERE
 
(

oe
 
$

cmp

$
 
ie

)
 
AND
 
subq_where

  
|--

如果需要区分上述结果的差别，使用触发器

     
SELECT
 
1
 
FROM
 
...

     
WHERE
 
subq_where
 
AND
 
trigcond

((

oe
 
$

cmp

$
 
ie

)
 
OR
 
(

ie
 
IS
 
NULL

))

           
HAVING
 
trigcond

(

@

<

is_not_null_test

@

>

(

ie

))

  
|--

其他，单个查询块，没有表及上述语法，直接用条件表达式在外查询中替代

总结

以上就是MySQL中针对子查询所做的大部分优化和转换的工作，代码分析基于MySQL 8.0.19版本。

参考：
https://dev.mysql.com/doc/refman/8.0/en/subquery-optimization.html

  

    

		

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
