# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/07/01/
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
	

  

    
数据库内核月报 － 2024 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB MySQL 冷数据DDL优化
                      

                    

                    

                  
                      

                        PolarDB MySQL 冷数据查询性能优化
                      

                    

                    

                  
                      

                        PostgreSQL 子事务探秘
                      

                    

                    

                  
                      

                        使用PT_PERF排查线上慢SQL问题
                      

                    

 
        

    

  

    
 PolarDB MySQL 冷数据DDL优化  

    
 Author: yifei  

  

  

  
过去，
PolarDB
 在处理归档的冷数据时，遇到的主要挑战之一是对数据定义语言（
DDL
）操作的兼容性和效率问题，尤其是在执行诸如增加列、调整列宽等操作时。由于这些操作通常要求数据重写，通过 
COPY
 机制来实现，导致了极高的资源消耗和执行成本。这一局限性在持续归档至 
OSS
 外表的场景中尤为突出，给数据管理和运维工作带来了不便。
为应对这一挑战，我们引入了 
OSS META
 功能。该功能通过增强对冷数据的元数据管理能力，使得特定的DDL操作能够以即时（
INSTANT
）模式执行，从根本上优化了冷数据处理的灵活性和效率。这意味着，在 
OSS META
 功能启用状态下，系统能够智能识别并应用DDL变更，而无需经历传统意义上的全量数据重写流程。下面举一个例子详细介绍：

分区归档至外表

例如：客户有一张订单分区表，以订单创建时间作为分区键，每年一个分区。假设超过5年后，我们认为该订单被查询的几率不大，可以归档至 
OSS
 冷数据。其订单表结构如下：

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
                           
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2011 VALUES LESS THAN ('2012-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION p2012 VALUES LESS THAN ('2013-01-01') ENGINE = InnoDB,                            |
|        |  PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB) */
                         
|

+

--------+----------------------------------------------------------------------------------------------+

该表上有 
INTERVAL
 属性，可以随着表数据的增加，自动创建新的分区。（关于 
INTERVAL
 功能的介绍，请参考：
PolarDB MySQL INTERVAL RANGE分区
）。随着数据上升，假设客户插入的数据已经到了2016年，则该表的定义会变为：

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

4
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
          
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2011 VALUES LESS THAN ('2012-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION p2012 VALUES LESS THAN ('2013-01-01') ENGINE = InnoDB,                            |
|        |  PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB,                            |
|        |  PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB) */
     
|

+

--------+----------------------------------------------------------------------------------------------+

此时，由于分区 
p2011
 的数据距离最新的分区已经超过五年，出于降本的需求，我们将该分区的数据转到另一张冷存表上。首先，打开 
OSS META
 开关，通过

MySQL

>
 
set
 
use_oss_meta
 
=
 
ON

;

或者通过控制台设置参数 
loose_use_oss_meta = ON
 ,然后重新连接实例。

随后通过以下存储过程将分区归档至表：
> 该功能将会在 
8.0.2.2.25
 版本上线，具体请参考官网公告。

MySQL

>
 
call
 
dbms_dlm

.

archive_partition2table

(

'test'

,
 
'Orders'

,
 
'p2011'

,
 
'test'

,

'Orders_archive'

,
 
''

);

这个存储过程会把当前表 
test.Orders
 表的分区 
p2011
 归档到 
OSS
 外表 
test.Orders_archive
，如果没有表
test.Orders_archive
，则会自动创建一个。归档完成后，看下当前数据库中的所有表，如下：

MySQL

>
 
show
 
tables

;

+

-----------------------------+

|
 
Tables_in_test
              
|

+

-----------------------------+

|
 
Orders
                      
|

|
 
Orders_archive
              
|

+

-----------------------------+

2
 
rows
 
in
 
set

Time

:
 
0

.

020

s

这时已经自动创建好了表 
Orders_archive
 ，表结构和 
Orders
 基本一致，其建表语句为：

MySQL

>
 
show
 
create
 
table
 
Orders_archive

;

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Table
          
|
 
Create
 
Table
                                                                                                                                                                                                                             
|

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Orders_archive
 
|
 
CREATE
 
TABLE
 
`Orders_archive`
 
(
                                                                                                                                                                                                          
|

|
                
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
DEFAULT
 
'0'

,
                                                                                                                                                                                               
|

|
                
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                                    
|

|
                
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                                     
|

|
                
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                             
|

|
                
|
   
`create_time`
 
datetime
 
NOT
 
NULL
                                                                                                                                                                                                        
|

|
                
|
 
)
 
/*!99990 800020213 STORAGE OSS */
 
ENGINE

=

CSV
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
 
/*!99990 800020204 NULL_MARKER='NULL' */
 
/*!99990 800020223 OSS META=1 */
 
/*!99990 800020224 OSS_FILE_FILTER='order_id,create_time' */
 
|

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

006

s

可以看到表上带有 
OSS META=1
 的标记，说明当前表已经开启了 
OSS META
 功能。查询该表的数据，可以发现 
p2011
 分区的数据已经在表 
Orders_archive
 中了，并且 
Orders
 表中，分区 
p2011
 也被删除了。

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

9
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
          
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2012 VALUES LESS THAN ('2013-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB,                            |
|        |  PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB) */
     
|

+

--------+----------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

028

s

分区数据持续归档

随后，
Orders
 表随着数据持续的插入，可能会有更多的分区，例如：

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

10
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
         
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2012 VALUES LESS THAN ('2013-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB,                            |
|        |  PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20180101000000 VALUES LESS THAN ('2018-01-01 00:00:00') ENGINE = InnoDB) */
     
|

+

--------+----------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

006

s

此时按照保留5个分区的策略，可以继续把分区 
p2012
 的数据归档至刚刚的 
Orders_archive
 表，sql为：

MySQL

>
 
call
 
dbms_dlm

.

archive_partition2table

(

'test'

,
 
'Orders'

,
 
'p2012'

,
 
'test'

,

'Orders_archive'

,
 
''

);

Query
 
OK

,
 
0
 
rows
 
affected

Time

:
 
3

.

815

s

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

10
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
         
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20180101000000 VALUES LESS THAN ('2018-01-01 00:00:00') ENGINE = InnoDB) */
     
|

+

--------+----------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

027

s

归档后分区表 
Orders
 的数据进一步减少，可以显著降低存储成本。
但是，如果业务上有修改，例如，对分区表 
Orders
 需要加一列 
price
，表示当前订单的价格，加列后表定义为：

MySQL

>
 
alter
 
table
 
Orders
 
add
 
column
 
(

price
 
decimal
 
(

10

,

2

)
 
DEFAULT
 
NULL

),
 
algorithm
 
=
 
instant

;

Query
 
OK

,
 
0
 
rows
 
affected

Time

:
 
0

.

255

s

  

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+----------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                 
|

+

--------+----------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                      
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                         
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                 
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                           
|

|
        
|
   
`price`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                        
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                     
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

10
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
         
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
 
|

|
        
|
 
/*!50500 (PARTITION p2013 VALUES LESS THAN ('2014-01-01') ENGINE = InnoDB,                   |
|        |  PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB,        |
|        |  PARTITION _p20180101000000 VALUES LESS THAN ('2018-01-01 00:00:00') ENGINE = InnoDB) */
     
|

+

--------+----------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

006

s

此时，加完列后，如果我们想继续把分区 
p2013
 的数据归档至刚刚的 
OSS
 表 
Orders_archive
，会报错。这是因为 
Orders
 表和 
Orders_archive
 表的定义出现了不一致，报错如下：

MySQL

>
 
call
 
dbms_dlm

.

archive_partition2table

(

'test'

,
 
'Orders'

,
 
'p2013'

,
 
'test'

,

'Orders_archive'

,
 
''

);

(

8181

,
 
'[Data Lifecycle Management] errmsg: The metadata information of the original table is inconsistent with that of the target table.'

)

此时，我们需要给表 
Orders_archive
 也加上 
price
 列，就可以正常归档了，
sql
 为：

MySQL

>
 
alter
 
table
 
Orders_archive
 
add
 
column
 
(

price
 
decimal
 
(

10

,

2

)
 
DEFAULT
 
NULL

),
 
algorithm
 
=
 
instant

;

Query
 
OK

,
 
0
 
rows
 
affected

Time

:
 
0

.

348

s

注意，

  
只有 OSS 表上带有 
OSS META = 1
 标记时，才能执行 
instant DDL
 操作，否则会变成 
copy DDL
。

  
可以在 
DDL sql
 中强制指定算法为 
INSTANT
，避免出现预期外的 
COPY
 导致代价过大。

此时看下表 
Order_archive
 的表结构：

MySQL

>
 
show
 
create
 
table
 
Orders_archive

;

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Table
          
|
 
Create
 
Table
                                                                                                                                                                                                                             
|

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Orders_archive
 
|
 
CREATE
 
TABLE
 
`Orders_archive`
 
(
                                                                                                                                                                                                          
|

|
                
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
DEFAULT
 
'0'

,
                                                                                                                                                                                               
|

|
                
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                                    
|

|
                
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                                     
|

|
                
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                                                                                                                                                             
|

|
                
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                                                                                                                                                                       
|

|
                
|
   
`price`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL
                                                                                                                                                                                                     
|

|
                
|
 
)
 
/*!99990 800020213 STORAGE OSS */
 
ENGINE

=

CSV
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
 
/*!99990 800020204 NULL_MARKER='NULL' */
 
/*!99990 800020223 OSS META=1 */
 
/*!99990 800020224 OSS_FILE_FILTER='order_id,create_time' */
 
|

+

----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

250

s

已经和表 
Orders
 一致了，此时再归档分区 
p2013
，就不会报错了。

MySQL

>
 
call
 
dbms_dlm

.

archive_partition2table

(

'test'

,
 
'Orders'

,
 
'p2013'

,
 
'test'

,

'Orders_archive'

,
 
''

);

Query
 
OK

,
 
0
 
rows
 
affected

Time

:
 
4

.

969

s

MySQL

>
 
show
 
create
 
table
 
Orders

;

+

--------+------------------------------------------------------------------------------------------------+

|
 
Table
  
|
 
Create
 
Table
                                                                                   
|

+

--------+------------------------------------------------------------------------------------------------+

|
 
Orders
 
|
 
CREATE
 
TABLE
 
`Orders`
 
(
                                                                        
|

|
        
|
   
`order_id`
 
int

(

11

)
 
NOT
 
NULL
 
AUTO_INCREMENT

,
                                                  
|

|
        
|
   
`customer_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                          
|

|
        
|
   
`product_id`
 
int

(

11

)
 
DEFAULT
 
NULL

,
                                                           
|

|
        
|
   
`order_amount`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                   
|

|
        
|
   
`create_time`
 
datetime
 
NOT
 
NULL

,
                                                             
|

|
        
|
   
`price`
 
decimal

(

10

,

2

)
 
DEFAULT
 
NULL

,
                                                          
|

|
        
|
   
PRIMARY
 
KEY
 
(

`order_id`

,

`create_time`

)
                                                       
|

|
        
|
 
)
 
ENGINE

=

InnoDB
 
AUTO_INCREMENT

=

10
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
           
|

|
        
|
 
/*!50500 PARTITION BY RANGE  COLUMNS(create_time) */
 
/*!99990 800020200 INTERVAL(YEAR, 1) */
   
|

|
        
|
 
/*!50500 (PARTITION _p20150101000000 VALUES LESS THAN ('2015-01-01 00:00:00') ENGINE = InnoDB, |
|        |  PARTITION _p20160101000000 VALUES LESS THAN ('2016-01-01 00:00:00') ENGINE = InnoDB,          |
|        |  PARTITION _p20170101000000 VALUES LESS THAN ('2017-01-01 00:00:00') ENGINE = InnoDB,          |
|        |  PARTITION _p20180101000000 VALUES LESS THAN ('2018-01-01 00:00:00') ENGINE = InnoDB) */
       
|

+

--------+------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

024

s

可以看到分区数据已经归档至 
Orders_archive
 表里面了。

OSS META 功能的开启与关闭

通过以上可以看出，
OSS META
 开启后，对当前冷存表的 
DDL
 能力有极大的增强。更多的信息可以参考官网文档
OSS DDL 能力介绍
。
当然，如果您当前表已经归档成 
OSS
 表了，希望开启 
OSS META
 功能以支持更好的 
DDL
 操作，可以通过 
REPAIR TABLE
 语句实现，例如我们有一张归档表 
t
，

MySQL

>
 
show
 
create
 
table
 
t

;

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Table
 
|
 
Create
 
Table
                                                                                                                               
|

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

|
 
t
     
|
 
CREATE
 
TABLE
 
`t`
 
(
                                                                                                                         
|

|
       
|
   
`id`
 
int

(

11

)
 
DEFAULT
 
NULL
                                                                                                                
|

|
       
|
 
)
 
/*!99990 800020213 STORAGE OSS */
 
ENGINE

=

CSV
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
 
/*!99990 800020204 NULL_MARKER='NULL' */
 
|

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

008

s

此时表 
t
 上没有 
oss meta
 标记，可以通过 
repair table
 增加：

MySQL

>
 
repair
 
table
 
t

;

+

--------+--------+----------+----------+

|
 
Table
  
|
 
Op
     
|
 
Msg_type
 
|
 
Msg_text
 
|

+

--------+--------+----------+----------+

|
 
test

.

t
 
|
 
repair
 
|
 
status
   
|
 
OK
       
|

+

--------+--------+----------+----------+

1
 
row
 
in
 
set

Time

:
 
0

.

863

s

MySQL

>
 
show
 
create
 
table
 
t

;

+

-------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Table
 
|
 
Create
 
Table
                                                                                                                                                                
|

+

-------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|
 
t
     
|
 
CREATE
 
TABLE
 
`t`
 
(
                                                                                                                                                          
|

|
       
|
   
`id`
 
int

(

11

)
 
DEFAULT
 
NULL
                                                                                                                                                 
|

|
       
|
 
)
 
/*!99990 800020213 STORAGE OSS */
 
ENGINE

=

CSV
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
 
/*!99990 800020204 NULL_MARKER='NULL' */
 
/*!99990 800020223 OSS META=1 */
 
|

+

-------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

Time

:
 
0

.

014

s

注意，
repair table
 是一个 
inplace
 操作，对于 
OSS
 表来说，其整体时间与表的大小相关。
当然，也可以关闭当前表的 
OSS META
 功能，通过 
disable OSS META
 实现：

MySQL

>
 
ALTER
 
TABLE
 
t
 
DISABLE
 
OSS
 
META

;

Query
 
OK

,
 
0
 
rows
 
affected

Time

:
 
0

.

049

s

MySQL

>
 
show
 
create
 
table
 
t

;

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

|
 
Table
 
|
 
Create
 
Table
                                                                                                                               
|

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

|
 
t
     
|
 
CREATE
 
TABLE
 
`t`
 
(
                                                                                                                         
|

|
       
|
   
`id`
 
int

(

11

)
 
DEFAULT
 
NULL
                                                                                                                
|

|
       
|
 
)
 
/*!99990 800020213 STORAGE OSS */
 
ENGINE

=

CSV
 
DEFAULT
 
CHARSET

=

utf8mb4
 
COLLATE

=

utf8mb4_0900_ai_ci
 
/*!99990 800020204 NULL_MARKER='NULL' */
 
|

+

-------+--------------------------------------------------------------------------------------------------------------------------------------------+

1
 
row
 
in
 
set

关闭 
OSS META
 是一个 
instant
 操作，只修改表的元数据。

总结

PolarDB MySQL
 的 
8.0.2.2.24
 版本引入了冷数据 
OSS META
 功能，显著优化了冷数据的 
DDL
 操作。在过去，由于 
OSS
 冷数据的 
DDL
 能力有限，大部分 
DDL
 操作都需要使用 
COPY
 算法，导致修改表定义的成本很高。现在，通过增强对冷数据元数据的管理，某些
DDL
操作可以直接应用，无需全量数据重写，提高了效率和灵活性。当启用 
OSS META
功能后，例如在处理分区归档到OSS的场景中，可以更方便地进行表结构的修改。总的来说，
OSS META
 功能提升了
PolarDB MySQL
在处理冷数据
DDL
时的性能，降低了维护成本，使得冷数据管理更加便捷高效。

  

    

		

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
