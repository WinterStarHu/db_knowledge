# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/01/03/
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
	

  

    
数据库内核月报 － 2023 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB for MySQL 优化器查询变换系列 - IN-List 变换
                      

                    

                    

                  
                      

                        PolarDB IMCI 的 TopK 查询执行优化
                      

                    

                    

                  
                      

                        库表变更、加锁没审计？PolarDB MySQL 新功能 SQL Detail
                      

                    

                    

                  
                      

                        MySQL Binlog 源码入门
                      

                    

 
        

    

  

    
 库表变更、加锁没审计？PolarDB MySQL 新功能 SQL Detail  

    
 Author: 勉仁  

  

  

  
PolarDB MySQL最新引入了库表变更、加锁操作的详细审计功能SQL Detail。

背景

在数据库使用过程中，库表的变更，例如删除、创建、增加列和索引等都是非常敏感的。对库表的加锁也会影响整个业务的使用。对应操作的审计日志对于数据库的运维人员就非常重要，需要能够知道操作的用户账号、客户端IP、操作时间、完成时间等详细信息。
以往的审计日志基本都是全局开关，对所有SQL语句都做审计。这样记录的SQL全面，但成本也会很高。同时很多时候需要额外的组件存储信息，维护和信息安全控制的成本也高。而对业务会造成重大影响的很多由库表操作引发，这部分的审计很多时候又不可或缺。
因此PolarDB MySQL内核开发了能够对库表变更、加锁操作的详细审计功能SQL Detail。同时该功能的审计记录存储在用户数据库实例中，用户可以配置审计记录的保存时间，审计记录过期后会自动删除。该功能审计的成本极低，以每条审计记录存储1KB，每天库表变更1024次，审计保存30天算，仅需要30M的存储空间。该功能在相关语句开始执行时就会捕获到，记录到相关系统表中，并会在执行结束时进一步更新相关状态。
下面会对该功能的使用做详细的介绍。

功能介绍

功能开关与相关变量

  
功能开关

用户可以通过全局参数awr_sqldetail_enabled来开启SQL Detail功能（在阿里云PolarDB实例控制台上搜索参数loose_awr_sqldetail_enabled）。该参数的配置无需重启实例。

  
审计SQL类型子开关

通过全局参数awr_sqldetail_switch可以控制库表变更或者库表加锁释放锁是否记录。作为一个switch变量，当前有两个子开关，ddl（是否记录DDL变更）和lock_db_table（是否记录库表加锁释放锁）。ddl和lock_db_table默认都是开启的，即默认值为’ddl=on,lock_db_table=on’。
DDL包括的语句类型如下：
create_table、alter_table、drop_table、rename_table、create_index、drop_index、create_db、drop_db、alter_db、create_view、drop_view、create_trigger、drop_trigger、create_event、alter_event、create_function、create_procedure、drop_procedure、drop_function、alter_procedure、alter_function、truncate、alter_tablespace、repair、optimize、install_plugin、uninstall_plugin、install_component、uninstall_component、alter_instance、import、create_spatial_reference_system、drop_spatial_reference_system。
LOCK_DB_TABLE包括的语句类型如下：
lock_tables、unlock_tables。

  
审计保存时间定义

通过全局参数awr_sqldetail_retention可以配置SQL Detail审计记录的保存时间，其单位是秒。当审计记录保存超过该时候后，内核会通过后台线程自动淘汰该记录。该参数默认值是：2592000（30天）。

审计记录表

SQL Detail功能的记录存储在一张新的PolarDB系统表sys.hist_sqldetail中。该表的定义如下：

CREATE
 
TABLE
 
`hist_sqldetail`
 
(

  
`Id`
 
bigint

(

20

)
 
unsigned
 
NOT
 
NULL
 
AUTO_INCREMENT

,

  
`State`
 
varchar

(

16

)
 
COLLATE
 
utf8mb4_bin
 
DEFAULT
 
NULL

,

  
`Thread_id`
 
bigint

(

20

)
 
unsigned
 
DEFAULT
 
NULL

,

  
`Host`
 
varchar

(

60

)
 
COLLATE
 
utf8mb4_bin
 
NOT
 
NULL
 
DEFAULT
 
''

,

  
`User`
 
varchar

(

32

)
 
COLLATE
 
utf8mb4_bin
 
NOT
 
NULL
 
DEFAULT
 
''

,

  
`Client_ip`
 
varchar

(

60

)
 
COLLATE
 
utf8mb4_bin
 
DEFAULT
 
NULL

,

  
`Db`
 
varchar

(

64

)
 
COLLATE
 
utf8mb4_bin
 
DEFAULT
 
NULL

,

  
`Sql_text`
 
mediumtext
 
COLLATE
 
utf8mb4_bin
 
NOT
 
NULL

,

  
`Server_command`
 
varchar

(

32

)
 
COLLATE
 
utf8mb4_bin
 
DEFAULT
 
NULL

,

  
`Sql_command`
 
varchar

(

64

)
 
COLLATE
 
utf8mb4_bin
 
DEFAULT
 
NULL

,

  
`Start_time`
 
timestamp

(

6

)
 
NULL
 
DEFAULT
 
NULL

,

  
`Exec_time`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Wait_time`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Error_code`
 
int

(

11

)
 
DEFAULT
 
NULL

,

  
`Rows_sent`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Rows_examined`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Rows_affected`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Logical_read`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Phy_sync_read`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Phy_async_read`
 
bigint

(

20

)
 
DEFAULT
 
NULL

,

  
`Process_info`
 
text
 
COLLATE
 
utf8mb4_bin

,

  
`Extra`
 
text
 
COLLATE
 
utf8mb4_bin

,

  
`Create_time`
 
timestamp

(

6

)
 
NOT
 
NULL
 
DEFAULT
 
CURRENT_TIMESTAMP

(

6

),

  
`Update_time`
 
timestamp

(

6

)
 
NOT
 
NULL
 
DEFAULT
 
CURRENT_TIMESTAMP

(

6

)
 
ON
 
UPDATE
 
CURRENT_TIMESTAMP

(

6

),

  
PRIMARY
 
KEY
 
(

`Id`

),

  
KEY
 
`i_start_time`
 
(

`Start_time`

),

  
KEY
 
`i_update_time`
 
(

`Update_time`

)

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

utf8mb4_bin

;

该表各个字段表示的意义如下。可以看到该表会详细的记录库表变更、锁操作。

  

    

      
字段

      
描述

    

  

  

    

      
Id

      
sys.hist_sqldetail表的自增ID。

    

    

      
State

      
该操作被记录时所处的状态。

    

    

      
Thread_id

      
执行该SQL会话的线程ID

    

    

      
Host

      
执行该SQL会话的用户Host

    

    

      
User

      
执行该SQL会话的用户名

    

    

      
Client_ip

      
执行该SQL会话的客户端IP

    

    

      
Db

      
该SQL执行时所在的DB

    

    

      
Sql_text

      
具体SQL

    

    

      
Server_command

      
执行该SQL的server命令

    

    

      
Sql_command

      
命令类型

    

    

      
Start_time

      
开始执行的时间

    

    

      
Exec_time

      
执行时间，单位微秒

    

    

      
Wait_time

      
等待时间，单位微秒

    

    

      
Error_code

      
错误码

    

    

      
Rows_sent

      
返回的数据行

    

    

      
Rows_examined

      
扫描的数据行

    

    

      
Rows_affected

      
影响的行数

    

    

      
Logical_read

      
逻辑读次数

    

    

      
Phy_sync_read

      
物理同步读次数

    

    

      
Phy_async_read

      
物理异步读次数

    

    

      
Process_info

      
扩展字段，处理过程信息。

    

    

      
Extra

      
扩展字段，其他信息。

    

    

      
Create_time

      
记录写入时间

    

    

      
Update_time

      
记录更新时间

    

  

使用示例

配置awr_sqldetail_enabled为ON后，SQL Detail功能就会自动记录DDL，LOCK DB\TABLE操作，并自动管理这些记录。例如配置awr_sqldetail_enabled为ON后，我们在test库下做如下操作：

mysql

>
 
create
 
table
 
t

(

c1
 
int

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

02
 
sec

)

mysql

>
 
create
 
table
 
t

(

c1
 
int

);

ERROR
 
1050
 
(

42

S01

):
 
Table
 
't'
 
already
 
exists

mysql

>
  
alter
 
table
 
t
 
add
 
column
 
c2
 
int

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

02
 
sec

)

Records

:
 
0
  
Duplicates

:
 
0
  
Warnings

:
 
0

mysql

>
 
lock
 
tables
 
t
 
read

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
 
unlock
 
tables

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

,
 
2

);

Query
 
OK

,
 
1
 
row
 
affected
 
(

0

.

00
 
sec

)

执行完后，我们可以通过sys.hist_sqldetail查看上述操作中DDL和LOCK DB\TABLE的信息，而DML语句不会被记录。

mysql

>
 
select
 
*
 
from
 
sys

.

hist_sqldetail

\

G

***************************
 
1

.
 
row
 
***************************

            
Id

:
 
1

         
State

:
 
FINISH

     
Thread_id

:
 
18

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
create
 
table
 
t

(

c1
 
int

)

Server_command

:
 
Query

   
Sql_command

:
 
create_table

    
Start_time

:
 
2023

-

01

-

13
 
16

:

18

:

21

.

840435

     
Exec_time

:
 
17390

     
Wait_time

:
 
318

    
Error_code

:
 
0

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
420

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

13
 
16

:

18

:

22

.

391407

   
Update_time

:
 
2023

-

01

-

13
 
16

:

18

:

22

.

391407

***************************
 
2

.
 
row
 
***************************

            
Id

:
 
2

         
State

:
 
FINISH

     
Thread_id

:
 
18

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
create
 
table
 
t

(

c1
 
int

)

Server_command

:
 
Query

   
Sql_command

:
 
create_table

    
Start_time

:
 
2023

-

01

-

13
 
16

:

18

:

22

.

416321

     
Exec_time

:
 
822

     
Wait_time

:
 
229

    
Error_code

:
 
1050

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
55

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

13
 
16

:

18

:

23

.

393071

   
Update_time

:
 
2023

-

01

-

13
 
16

:

18

:

23

.

393071

***************************
 
3

.
 
row
 
***************************

            
Id

:
 
3

         
State

:
 
FINISH

     
Thread_id

:
 
18

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
alter
 
table
 
t
 
add
 
column
 
c2
 
int

Server_command

:
 
Query

   
Sql_command

:
 
alter_table

    
Start_time

:
 
2023

-

01

-

13
 
16

:

18

:

34

.

123947

     
Exec_time

:
 
16420

     
Wait_time

:
 
245

    
Error_code

:
 
0

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
778

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

13
 
16

:

18

:

34

.

394067

   
Update_time

:
 
2023

-

01

-

13
 
16

:

18

:

34

.

394067

***************************
 
4

.
 
row
 
***************************

            
Id

:
 
4

         
State

:
 
FINISH

     
Thread_id

:
 
18

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
lock
 
tables
 
t
 
read

Server_command

:
 
Query

   
Sql_command

:
 
lock_tables

    
Start_time

:
 
2023

-

01

-

13
 
16

:

19

:

49

.

891559

     
Exec_time

:
 
145

     
Wait_time

:
 
129

    
Error_code

:
 
0

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
0

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

13
 
16

:

19

:

50

.

399585

   
Update_time

:
 
2023

-

01

-

13
 
16

:

19

:

50

.

399585

***************************
 
5

.
 
row
 
***************************

            
Id

:
 
5

         
State

:
 
FINISH

     
Thread_id

:
 
18

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
unlock
 
tables

Server_command

:
 
Query

   
Sql_command

:
 
unlock_tables

    
Start_time

:
 
2023

-

01

-

13
 
16

:

19

:

56

.

924648

     
Exec_time

:
 
98

     
Wait_time

:
 
0

    
Error_code

:
 
0

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
0

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

13
 
16

:

19

:

57

.

400294

   
Update_time

:
 
2023

-

01

-

13
 
16

:

19

:

57

.

400294

SQL Detail在DDL开始执行时就会被捕获记录到系统表中。我们做如下操作

create
 
table
 
t1
 
as
 
select
 
c1

,
 
sleep

(

10

)
 
from
 
t

;

在上述DDL执行时，我们用另一个session查看sys.hist_sqldetail，可以看到处理PROCESS状态的审计记录。当该语句执行完，相关状态会被自动更新。

select
 
*
 
from
 
sys

.

hist_sqldetail
 
where
 
state

=

'PROCESS'

\

G

***************************
 
1

.
 
row
 
***************************

            
Id

:
 
xx

         
State

:
 
PROCESS

     
Thread_id

:
 
36

          
Host

:
 
localhost

          
User

:
 
root

     
Client_ip

:
 
127

.

0

.

0

.

1

            
Db

:
 
test

      
Sql_text

:
 
create
 
table
 
t1
 
as
 
select
 
c1

,
 
sleep

(

10

)
 
from
 
t

Server_command

:
 
Query

   
Sql_command

:
 
create_table

    
Start_time

:
 
2023

-

01

-

19
 
17

:

34

:

42

.

293752

     
Exec_time

:
 
0

     
Wait_time

:
 
0

    
Error_code

:
 
0

     
Rows_sent

:
 
0

 
Rows_examined

:
 
0

 
Rows_affected

:
 
0

  
Logical_read

:
 
0

 
Phy_sync_read

:
 
0

Phy_async_read

:
 
0

  
Process_info

:
 
NULL

         
Extra

:
 
NULL

   
Create_time

:
 
2023

-

01

-

19
 
17

:

34

:

42

.

641854

   
Update_time

:
 
2023

-

01

-

19
 
17

:

34

:

42

.

641854

总结

PolarDB MySQL新功能SQL Detail可以详细记录用户的各类库表变更操作，并且可以自动淘汰过期记录，帮助用户以极低的成本对库表操作做审计工作。

  

    

		

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
