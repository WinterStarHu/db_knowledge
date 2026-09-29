# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/08/02/
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
	

  

    
数据库内核月报 － 2019 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PgSQL· 引擎特性 · 多版本并发控制介绍及实例分析
                      

                    

                    

                  
                      

                        AliSQL · 引擎特性 · Recycle Bin
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 8.0 Innodb redo log record 源码分析
                      

                    

                    

                  
                      

                        Database · 内存管理 · JeMalloc-5.1.0 实现分析
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · clone_plugin
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 启用即时文件初始化
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 浅析PostgreSQL 的JIT
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 ·  ROLLUP 功能用法和实现
                      

                    

                    

                  
                      

                        Redis · 最佳实践 · 混合存储实践指南
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · pgbench client_id 变量用途
                      

                    

 
        

    

  

    
 AliSQL · 引擎特性 · Recycle Bin  

    
 Author: lengxiang  

  

  

  
背景

MySQL 在生产环境使用过程中，会伴随着开发和运维人员的误操作，比如 DROP TABLE / DATABASE，这类 DDL 语句不具有可操作的回滚特性，而导致数据丢失，AliSQL 8.0 新特性支持回收站功能（Recycle Bin），临时把删除清理的表转移到回收站，并保留可设置的时间，方便用户找回数据。为了方便，提供了 DBMS_RECYCLE package 作为管理接口

Recycle Bin 管理接口

Recycle Bin 提供了两个管理接口，分别是:

1.DBMS_RECYCLE.show_tables()

展示回收站中所有临时保存的表：

  
mysql

>
 
call
 
dbms_recycle

.

show_tables

();

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
|
 
SCHEMA
          
|
 
TABLE
         
|
 
ORIGIN_SCHEMA
 
|
 
ORIGIN_TABLE
 
|
 
RECYCLED_TIME
       
|
 
PURGE_TIME
          
|

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
|
 
__recycle_bin__
 
|
 
__innodb_1063
 
|
 
product_db
    
|
 
t1
           
|
 
2019

-

08

-

08
 
11

:

01

:

46
 
|
 
2019

-

08

-

15
 
11

:

01

:

46
 
|

  
|
 
__recycle_bin__
 
|
 
__innodb_1064
 
|
 
product_db
    
|
 
t2
           
|
 
2019

-

08

-

08
 
11

:

01

:

46
 
|
 
2019

-

08

-

15
 
11

:

01

:

46
 
|

  
|
 
__recycle_bin__
 
|
 
__innodb_1065
 
|
 
product_db
    
|
 
parent
       
|
 
2019

-

08

-

08
 
11

:

01

:

46
 
|
 
2019

-

08

-

15
 
11

:

01

:

46
 
|

  
|
 
__recycle_bin__
 
|
 
__innodb_1066
 
|
 
product_db
    
|
 
child
        
|
 
2019

-

08

-

08
 
11

:

01

:

46
 
|
 
2019

-

08

-

15
 
11

:

01

:

46
 
|

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
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

– Columns 解释:

SCHEMA
 
回收站的 schema

TABLE
 
进入回收站后的表名

ORIGIN_SCHEMA
 
原始表的 schema

ORIGIN_TABLE
 
原始表的表名

RECYCLED_TIME
 
回收时间

PURGE_TIME
 
未来被清理掉的时间

2.DBMS_RECYCLE.purge_table(table_name=>)

手动清理回收站中的某张表

mysql

>
 
call
 
dbms_recycle

.

purge_table

(

"__innodb_1063"

);

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

01
 
sec

)

清理掉回收站中的

"__innodb_1063"
 
表

Recycle Bin 参数

Recycle Bin 一共设计了 5 个参数，分别是：

  
recycle_bin
    

  
recycle_bin

  
-- 是否打开回收功能， session + global 级别。

    

  

  
recycle_bin_retention
    

  recycle_bin_retention
  -- 回收站保留最长时间是多少，单位是seconds，默认是一周。

    

  

  
recycle_scheduler
    

  recycle_scheduler
  -- 是否打开回收站的异步清理任务线程

    

  

  
recycle_scheduler_interval
    

  recycle_scheduler_interval
  -- 回收站异步清理线程的轮询间隔，单位是seconds, 默认是30s。

    

  

  
recycle_scheduler_purge_table_print
    

  recycle_scheduler_purge_table_print
  -- 是否打印异步清理现场工作的详细日志

    

  

Recycle Bin 设计

Recycle Bin 总览

1. 回收机制

当操作 DROP TABLE / DATABASE 语句的时候， 只保留相关的表对象，并移动到专门的 recycle bin 目录中，
其它对象的删除策略是：

  
与表无关的对象，比如 procedure，根据操作语句决定是否保留，不做回收。

  
表的附属对象，比如 trigger，Foreign key，column statistics等，只要存在可能修改表数据的，做删除，

比如 trigger，Foreign key。 但columns statistics不做清理，随表进入回收站。

2. 清理机制

回收站会启动一个background 线程，来异步清理超过 recycle_bin_retention 时间的表对象, 在清理回收站表的时候，如果遇到是大表的清理，会再启动一个background 来做异步大文件删除。

Recycle schema 和权限控制

1. recycle schema
 
MySQL 系统启动的时候，会初始化一个 recycle bin 的schema， 命名为 “
recycle_bin
“， 作为回收站使用的专有 database。

  mysql> show databases;
  +--------------------+
  | Database           |
  +--------------------+
  | __recycle_bin__    |
  | information_schema |
  | mysql              |
  | performance_schema |
  | sys                |
  +--------------------+
  6 rows in set (0.00 sec)

2. 权限控制
 

1.Database 权限：

recycle_bin
  作为回收站的 schema，是系统级 database，没有权限做修改和删除。
用户无法使用drop table / database 来操作回收站。
比如：

  
mysql

>
 
drop
 
table
 
__recycle_bin__

.

__innodb_1064

;

  
ERROR
 
1044
 
(

42000

):
 
Access
 
denied
 
for
 
user
 
'b1'

@

'%'
 
to
 
database
 
'__recycle_bin__'

2.recycled table 权限：

– recycle scheduler 后台线程具有所有权限，可以做清理工作；
– 用户虽然无法直接 drop table，可以使用 dbms_recycle.purge_table()，

但仍然需要原表和回收站表都具有 DROP_ACL 权限：
 

比如：

mysql

>
 
call
 
dbms_recycle

.

purge_table

(

"__innodb_1064"

);

ERROR
 
1142
 
(

42000

):
 
DROP
 
command
 
denied
 
to
 
user
 
'b1'

@

'localhost'
 
for
 
table
 
'__innodb_1064'

-- Grant 回收站权限

mysql

>
 
grant
 
drop
 
on
 
__recycle_bin__

.

__innodb_1064
 
to
 
b1

@

'%'

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

-- Grant 原表权限

mysql

>
 
grant
 
drop
 
on
 
product_db

.

t2
 
to
 
b1

@

'%'

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
 
call
 
dbms_recycle

.

purge_table

(

"__innodb_1064"

);

Query
 
OK

,
 
0
 
rows
 
affected
 
(

0

.

01
 
sec

)

Recycled table 命名规则

Recycled table 会从不同的 schema，回收到统一的 recycle bin 回收站中，所以需要保证目标表表名唯一，所以
这里定义了一个命名格式：

  
"__"
 
+
 
Storge
 
Engine
 
+
 
SE
 
private
 
id

Storge Engine：代表存储引擎名称，比如 innodb。
SE private id：是存储引擎为每一个表生成的唯一值，比如 InnoDB 中，就是 table id，
以此来唯一表示一个表名称。
 

Recycled table 关联对象

在回收表的过程中，需要处理表的相关对象，其处理的原则是：

  
如果是表附属对象，可能会存在修改表数据的可能性，就做删除，比如 trigger 和 FK。

  
如果是表相关对象，不会修改数据，就不做清理，比如相关的 view，统计信息等。

下面通过一个例子来看下：

 
原始结构
 

  
CREATE
 
TABLE
 
parent
 
(

      
id
 
INT
 
NOT
 
NULL

,

      
PRIMARY
 
KEY
 
(

id

)

      
)
 
ENGINE

=

INNODB

;

  
CREATE
 
TABLE
 
child
 
(

      
id
 
INT

,

      
parent_id
 
INT

,

      
self_id
 
INT

,

      
INDEX
 
id_ind
 
(

id

),

      
INDEX
 
par_ind
 
(

parent_id

),

      
INDEX
 
sel_ind
 
(

self_id

),

      
FOREIGN
 
KEY
 
(

self_id

)
 
REFERENCES
 
child

(

id

),

      
FOREIGN
 
KEY
 
(

parent_id

)
 
REFERENCES
 
parent

(

id

)
 
ON
 
DELETE
 
CASCADE

      
)
 
ENGINE

=

INNODB

;

  
CREATE
 
TABLE
 
log

(

id
 
INT

);

  
delimiter
 
//

  
CREATE
 
TRIGGER
 
trigger_child

  
before
 
INSERT
 
ON
 
child
 
FOR
 
EACH
 
ROW

  
BEGIN

  
INSERT
 
INTO
 
log
 
value

(

1

);

  
END

//

  
delimiter
 
;

  
CREATE
 
VIEW
 
view_child
 
AS
 
SELECT
 
*
 
FROM
 
child

;

Drop 并回收（相关关联对象删除或失效）

  
1

.
 
删除表
 
child

；

  
mysql

>
 
drop
 
table
 
child

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

01
 
sec

)

  
2

.
 
查看回收站，及
 
child
 
表在回收站的结构

  
mysql

>
 
call
 
dbms_recycle

.

show_tables

();

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
|
 
SCHEMA
          
|
 
TABLE
         
|
 
ORIGIN_SCHEMA
 
|
 
ORIGIN_TABLE
 
|
 
RECYCLED_TIME
       
|
 
PURGE_TIME
          
|

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
|
 
__recycle_bin__
 
|
 
__innodb_1068
 
|
 
test
          
|
 
child
        
|
 
2019

-

08

-

08
 
12

:

32

:

48
 
|
 
2019

-

08

-

15
 
12

:

32

:

48
 
|

  
+

-----------------+---------------+---------------+--------------+---------------------+---------------------+

  
mysql

>
 
show
 
create
 
table
 
__recycle_bin__

.

__innodb_1068

\

G

  
***************************
 
1

.
 
row
 
***************************

  
Table

:
 
__innodb_1068

  
Create
 
Table

:
 
CREATE
 
TABLE
 
`__innodb_1068`
 
(

      
`id`
 
int

(

11

)
 
DEFAULT
 
NULL

,

      
`parent_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,

      
`self_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,

      
KEY
 
`id_ind`
 
(

`id`

),

      
KEY
 
`par_ind`
 
(

`parent_id`

),

      
KEY
 
`sel_ind`
 
(

`self_id`

)

      
)
 
ENGINE

=

InnoDB
 
DEFAULT
 
CHARSET

=

utf8

  
-- 相关的 Foreign key 已经全部删除。

  
3

.
 
查看相关

trigger

。

  
mysql

>
 
show
 
create
 
trigger
 
trigger_child

;

  
ERROR
 
1360
 
(

HY000

):
 
Trigger
 
does
 
not
 
exist

  
-- 相关的trigger已经全部删除。

  
4

.
 
查看相关

view

。

  
mysql

>
 
show
 
create
 
view
 
view_child

\

G

  
***************************
 
1

.
 
row
 
***************************

  
View

:
 
view_child

  
Create
 
View

:
 
CREATE
 
ALGORITHM

=

UNDEFINED
 
DEFINER

=

`root`

@

`localhost`
 
SQL
 
SECURITY
 
DEFINER
 
VIEW
 
`view_child`
 
AS
 
select
 
`child`

.

`id`
 
AS
 
`id`

,

`child`

.

`parent_id`
 
AS
 
`parent_id`

,

`child`

.

`self_id`
 
AS
 
`self_id`
 
from
 
`child`

  
character_set_client

:
 
utf8mb4

  
collation_connection

:
 
utf8mb4_0900_ai_ci

  
1
 
row
 
in
 
set

,
 
1
 
warning
 
(

0

.

01
 
sec

)

  
mysql

>
 
show
 
warnings

;

  
+

---------+------+-----------------------------------------------------------------------------------------------------------------------------------+

  
|
 
Level
   
|
 
Code
 
|
 
Message
                                                                                                                           
|

  
+

---------+------+-----------------------------------------------------------------------------------------------------------------------------------+

  
|
 
Warning
 
|
 
1356
 
|
 
View
 
'test.view_child'
 
references
 
invalid
 
table

(

s

)
 
or
 
column

(

s

)
 
or
 
function

(

s

)
 
or
 
definer

/

invoker
 
of
 
view
 
lack
 
rights
 
to
 
use
 
them
 
|

  
+

---------+------+-----------------------------------------------------------------------------------------------------------------------------------+

  
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

  
-- 相关的view 已经失效。

Master-slave 独立回收

在 master - slave 结构中， 是否回收，或回收站保留的周期，都是实例本身的设置，不会影响到 binlog 复制到的节点上，所以，我们可以在 master 节点上设置回收，保留 7 天周期，在slave 节点上，设置回收，保留14天周期。
比如

master：
 

  
--recycle_bin = on

  
--recycle_bin_retention = 7 * 24 * 60 * 60

  
master

节点上，回收站保留
 
7
 
天

slave：
 

  
--recycle_bin = on

  
--recycle_bin_retention = 14 * 24 * 60 * 60

  
slave
 
节点上，回收站保留
 
14
 
天

要注意的点就是，回收站保留周期不同，将导致 master - slave 节点之间的空间占用差别比较大。

异步表清理和大文件删除

当 recycle scheduler 异步线程 purge  回收站的表时候，如果遇到大表，那么将会启动大表异步删除逻辑，相关参数如下：

  
INNODB_DATA_FILE_PURGE

:
 
Whether
 
enable
 
the
 
async
 
purge
 
strategy

  
INNODB_DATA_FILE_PURGE_IMMEDIATE

:
 
Unlink
 
data
 
file
 
rather
 
than
 
truncate

  
INNODB_DATA_FILE_PURGE_ALL_AT_SHUTDOWN

:
 
Cleanup
 
all
 
when
 
normal
 
shutdown

  
INNODB_DATA_FILE_PURGE_DIR

:
 
Temporary
 
file
 
directory

  
INNODB_DATA_FILE_PURGE_INTERVAL

:
 
Purge
 
time
 
interval
 
(

by
 
milliseconds

)

INNODB_DATA_FILE_PURGE_MAX_SIZE

:
 
Purge
 
max
 
size
 
every
 
time
 
(

by
 
MB

)

  
INNODB_PRINT_DATA_FILE_PURGE_PROCESS

:
 
Print
 
the
 
process
 
of
 
file
 
purge
 
worker

比如设置：

  
set
 
global
 
INNODB_DATA_FILE_PURGE
 
=
 
on

;

  
set
 
global
 
INNODB_DATA_FILE_PURGE_INTERVAL
 
=
 
100

;

  
set
 
global
 
INNODB_DATA_FILE_PURGE_MAX_SIZE
 
=
 
128

;

  
每
 
100

ms

，删除
 
128

MB
 
大小。

可以通过如下视图，查看大表异步删除的进展情况：

  
mysql

>
 
select
 
*
 
from
 
information_schema

.

innodb_purge_files

;

  
+

--------+---------------------+--------------------------------------+---------------+------------------------+--------------+

  
|
 
log_id
 
|
 
start_time
          
|
          
original_path
               
|
 
original_size
 
|
 
temporary_path
         
|
 
current_size
 
|

  
+

--------+---------------------+--------------------------------------+---------------+------------------------+--------------+

  
|
     
36
 
|
 
2019

-

08

-

08
 
12

:

06

:

38
 
|
 
.

/

__recycle_bin__

/

__innodb_1064

.

ibd
  
|
      
37748736
 
|
 
purge

/#

FP_1557846107_1
 
|
     
20971520
 
|

  
+

--------+---------------------+--------------------------------------+---------------+------------------------+--------------+

注意事项

1. 回收站跨文件系统

如果你的回收站目录 “
_recycle__bin
“_  和回收的表跨了文件系统，那么drop table，将会搬迁表空间文件，耗时较长。

2. General tablespace
 
general tablespace 会存在多个表共享同一个表空间的情况， 当回收其中一张表的时候，不会搬迁相关的表空间文件，如果master 和 slave 设置的回收保留时间不同，那么就会存在在某一个时间点，主备间的这个general tablespace中的表数量不相等的情况。

  

    

		

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
