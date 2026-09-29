# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/04/03/
> 分类: 特性分析

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
	

  

    
数据库内核月报 － 2015 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB undo log 漫游
                      

                    

                    

                  
                      

                        TokuDB · 产品新闻 · RDS TokuDB小手册
                      

                    

                    

                  
                      

                        TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)
                      

                    

                    

                  
                      

                        PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 连接断开导致XA事务丢失
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID下slave_net_timeout值太小问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Relay log 中 GTID group 完整性检测
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · UPDATE交换列单表和多表的区别
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 删被引用索引导致crash
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · GTID下auto_position=0时数据不一致
                      

                    

 
        

    

  

    
 TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)  

    
 Author: 一工  

  

  

  
简介

TokuDB使用LockTree(ft-index/locktree)来维护事务的锁状态(row-lock和range-lock)，LockTree的数据结构是一个Binary Tree。

本篇将通过几个“栗子”来谈谈TokuDB的row-lock和range-lock。 

表t:

mysql

>
 
show
 
create
 
table
 
t

\

G

***************************
 
1

.
 
row
 
***************************

       
Table

:
 
t

Create
 
Table

:
 
CREATE
 
TABLE
 
`t`
 
(

  
`id`
 
int

(

11

)
 
NOT
 
NULL

,

  
PRIMARY
 
KEY
 
(

`id`

)

)
 
ENGINE

=

TokuDB
 
DEFAULT
 
CHARSET

=

latin1

row-lock

mysql

>
 
set
 
autocommit

=

off

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

00
 
sec

)

mysql

>
 
insert
 
into
 
t
 
values
 
(

1

),(

10

),(

100

);

Query
 
OK

,
 
3
 
rows
 
affected
 
(

0

.

00
 
sec

)

Records

:
 
3
  
Duplicates

:
 
0
  
Warnings

:
 
0

mysql

>
 
select
 
*
 
from
 
information_schema

.

tokudb_locks

\

G

***************************
 
1

.
 
row
 
***************************

               
locks_trx_id

:
 
238

      
locks_mysql_thread_id

:
 
3

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0001000000

            
locks_key_right

:
 
0001000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
2

.
 
row
 
***************************

               
locks_trx_id

:
 
238

      
locks_mysql_thread_id

:
 
3

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
000

a000000

            
locks_key_right

:
 
000

a000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
3

.
 
row
 
***************************

               
locks_trx_id

:
 
238

      
locks_mysql_thread_id

:
 
3

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0064000000

            
locks_key_right

:
 
0064000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

3
 
rows
 
in
 
set
 
(

0

.

00
 
sec

)

从tokudb_locks表可以查询到，生成了3条row-lock(locks_key_left和locks_key_right相等)。 

为了存储和显示方便，locks_key_left/locks_key_right取key的hash值。

range-lock

mysql

>
 
set
 
autocommit

=

off

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

00
 
sec

)

mysql

>
 
delete
 
from
 
t
 
where
 
id

<

100

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

00
 
sec

)

mysql

>
 
select
 
*
 
from
 
information_schema

.

tokudb_locks

\

G

***************************
 
1

.
 
row
 
***************************

               
locks_trx_id

:
 
280

      
locks_mysql_thread_id

:
 
12

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
-

infinity

            
locks_key_right

:
 
ff64000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

1
 
row
 
in
 
set
 
(

0

.

00
 
sec

)

从tokudb_locks表可以查询到，where条件的rang-lock区间为[-infinity, ff64000000]，只要其他事务的锁区间跟这个有任何重叠，则需要等待。

锁冲突

client1执行如下操作:

mysql1

>
 
set
 
autocommit

=

off

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

00
 
sec

)

mysql1

>
 
insert
 
into
 
t
 
values
 
(

1

),(

10

),(

100

);

Query
 
OK

,
 
3
 
rows
 
affected
 
(

0

.

00
 
sec

)

Records

:
 
3
  
Duplicates

:
 
0
  
Warnings

:
 
0

mysql1

>
 
select
 
*
 
from
 
information_schema

.

tokudb_locks

\

G

***************************
 
1

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0001000000

            
locks_key_right

:
 
0001000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
2

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
000

a000000

            
locks_key_right

:
 
000

a000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
3

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0064000000

            
locks_key_right

:
 
0064000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

3
 
rows
 
in
 
set
 
(

0

.

00
 
sec

)

client2执行如下操作:

mysql2

>
 
set
 
autocommit

=

off

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

00
 
sec

)

mysql2

>
 
insert
 
into
 
t
 
values
 
(

2

),(

100

);

ERROR
 
1205
 
(

HY000

):
 
Lock
 
wait
 
timeout
 
exceeded

;
 
try
 
restarting
 
transaction

mysql2

>
 
select
 
*
 
from
 
information_schema

.

tokudb_locks

\

G

***************************
 
1

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0001000000

            
locks_key_right

:
 
0001000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
2

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
000

a000000

            
locks_key_right

:
 
000

a000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
3

.
 
row
 
***************************

               
locks_trx_id

:
 
283

      
locks_mysql_thread_id

:
 
14

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0064000000

            
locks_key_right

:
 
0064000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

***************************
 
4

.
 
row
 
***************************

               
locks_trx_id

:
 
289

      
locks_mysql_thread_id

:
 
16

                
locks_dname

:
 
.

/

test

/

t

-

main

             
locks_key_left

:
 
0002000000

            
locks_key_right

:
 
0002000000

         
locks_table_schema

:
 
test

           
locks_table_name

:
 
t

locks_table_dictionary_name

:
 
main

4
 
rows
 
in
 
set
 
(

0

.

00
 
sec

)

mysql2

>
 
select
 
@@

tokudb_last_lock_timeout

;

+

--------------------------------------------------------------------------------------------------------------------+

|
 
@@

tokudb_last_lock_timeout
                                                                                         
|

+

--------------------------------------------------------------------------------------------------------------------+

|
 
{

"mysql_thread_id"

:

16

,
 
"dbname"

:

"./test/t-main"

,
 
"requesting_txnid"

:

289

,
 
"blocking_txnid"

:

283

,
 
"key"

:

"0064000000"

}
 
|

+

--------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set
 
(

0

.

00
 
sec

)

锁等待超时了，通过参数tokudb_last_lock_timeout得知，hash为
0064000000
的row-lock已经被txnid为283（client1)抢占。

总结

在使用TokuDB过程中，如果
show processlist
里有锁等待语句，可以通过tokudb_locks表获取到当前所有事务的锁信息，以快速定位到问题。 

TokuDB提供tokudb_lock_timeout_debug参数，可以设置不同值(默认值为1)来记录锁冲突信息，说明如下：

tokudb_lock_timeout_debug
 
=
 
0

:
 
No
 
lock
 
timeouts
 
or
 
lock
 
deadlocks
 
are
 
reported

.

tokudb_lock_timeout_debug
 
=
 
1

:
 
A
 
JSON
 
document
 
that
 
describes
 
the
 
lock
 
conflict
 
is
 
stored
 
in
 
the
 
tokudb_last_lock_timeout
 
session
 
variable

tokudb_lock_timeout_debug
 
=
 
2

:
 
A
 
JSON
 
document
 
that
 
describes
 
the
 
lock
 
conflict
 
is
 
printed
 
to
 
the
 
MySQL
 
error
 
log

.

tokudb_lock_timeout_debug
 
=
 
3

:
 
A
 
JSON
 
document
 
that
 
describes
 
the
 
lock
 
conflict
 
is
 
stored
 
in
 
the
 
tokudb_last_lock_timeout
 
session
 
variable
 
and
 
is
 
printed
 
to
 
the
 
MySQL
 
error
 
log

.
 

  

    

		

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
