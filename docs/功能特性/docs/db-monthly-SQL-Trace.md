# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/12/07/
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
                      

                    

 
        

    

  

    
 查询性能定位没现场？要统计各维度Top SQL？PolarDB MySQL新功能SQL Trace  

    
 Author: 勉仁  

  

  

  
PolarDB MySQL最新引入了查询的执行计划和性能的监控工具SQL Trace。

在数据库使用过程中，面对负载的持续高位，我们可能会需要查看消耗负载比较大的TopSQL。当一条查询语句的性能突然下降，我们可能需要排查语句的执行计划是否变化，语句执行时扫描行数、物理IO读是否明显变化。现在基于PolarDB MySQL SQL Trace我们可以便捷的获取这些信息，帮助我们分析查询性能问题、优化数据库负载。

本文会对PolarDB MySQL新特性SQL Trace做一个详细的使用说明，同时该功能可以参见
官网文档
。

功能介绍

当开启SQL Trace后，在查询优化阶段会记录当前查询选择的执行计划，包含了索引路径和访问方式的选择、JOIN ORDER、选择的查询变换等，还包含了是否选择并行执行、IMCI列存执行。

在执行阶段会收集执行时的统计信息，包含了等待时间、执行时间、返回行数、扫描行数、影响行数、逻辑读次数、物理同步读次数、物理异步读次数的总值、最小值、最大值，还有总的执行次数、第一次执行时间和最后一次执行时间等信息。同时会记录是普通执行方式还是Prepare/Execute方式。如果是命中query cache直接返回也会记录下来。

SQL Trace的信息存储在SQL Sharing的基础组件中，后台线程会根据SQL Trace的引用时间和过期时间判断是否可以回收。同时用户可以通过接口来控制SQL Trace的记录。

开关与变量

通过配置sql_trace_type可以打开SQL Trace功能。

  

    

      
参数名称

      
取值范围

      
描述

    

  

  

    

      
sql_trace_type

      
OFF|DEMAND|ALL

      
SQL Trace跟踪类型。- OFF（默认值）：不跟踪任何SQL语句。- DEMAND：跟踪指定的SQL语句。- ALL：跟踪所有的SQL语句。

    

  

可以通过sql_sharing_size来配置存储SQL Trace记录的SQL Sharing可用的内存大小。

  

    

      
参数名称

      
取值范围

      
描述

    

  

  

    

      
sql_sharing_size

      
[8388608-1073741824]

      
SQL Sharing组件的最大使用内存。单位：字节。默认值为134217728(128M)。

    

  

可以通过sql_trace_plan_expire_time控制SQL Trace记录过期时间。当SQL Trace记录超过该时间未被再次命中时会被后台回收。

  

    

      
参数名称

      
取值范围

      
描述

    

  

  

    

      
sql_trace_plan_expire_time

      
[0-18446744073709551615]

      
SQL Trace跟踪的执行计划失效时间。当执行计划超过该时间且未被命中后，该执行计划将会被判定为过期，可以将其淘汰。单位：秒。默认值为604800(7天)。

    

  

相关表

information_schema.sql_sharing

在SQL Trace功能中展示SQL Sharing中记录的表是information_schema.sql_sharing，该表可以展示SQL Trace跟踪的查询相关执行信息和查询各个执行计划的信息。

其定义如下：

sql
CREATE TEMPORARY TABLE `SQL_SHARING` (
  `TYPE` varchar(16) DEFAULT NULL,
  `SQL_ID` varchar(64) DEFAULT NULL,
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` varchar(2048) DEFAULT NULL,
  `PLAN_ID` varchar(64) DEFAULT NULL,
  `PLAN` varchar(1024) DEFAULT NULL,
  `PLAN_EXTRA` varchar(1024) DEFAULT NULL,
  `ERROR_CODE` bigint(21) DEFAULT NULL,
  `REF_BY` varchar(512) DEFAULT NULL,
  `FIRST_LOAD_TIME` datetime DEFAULT NULL,
  `LAST_HIT_TIME` datetime DEFAULT NULL,
  `EXECUTIONS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_WAIT_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_WAIT_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_WAIT_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_EXEC_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_EXEC_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_EXEC_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_ROWS_SENT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_ROWS_SENT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_ROWS_SENT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_ROWS_EXAMINED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_ROWS_EXAMINED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_ROWS_EXAMINED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_ROWS_AFFECTED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_ROWS_AFFECTED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_ROWS_AFFECTED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_LOGICAL_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_LOGICAL_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_LOGICAL_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_PHY_SYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_PHY_SYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_PHY_SYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SUM_PHY_ASYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MIN_PHY_ASYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_PHY_ASYNC_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `EXTRA` varchar(1024) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

其中各个字段意义如下：

  

    

      
字段名

      
字段意义

    

  

  

    

      
TYPE

      
当前记录的类型，其值为SQL或者PLAN

    

    

      
SQL_ID

      
当前记录的SQL_ID，为13位32进制字符串

    

    

      
SCHEMA_NAME

      
当前记录执行时的SCHEMA

    

    

      
DIGEST_TEXT

      
查询语句模板化后的字符串

    

    

      
PLAN_ID

      
查询语句执行计划的ID，为13位32进制字符串

    

    

      
PLAN

      
查询语句的执行计划，记录了访问路径、JOIN ORDER等执行计划信息

    

    

      
PLAN_EXTRA

      
查询语句执行的额外信息，记录了访问方式如全表扫描、索引范围、等值访问等信息。同时对于PREPARE/EXECUTE语句也会标记。

    

    

      
ERROR_CODE

      
查询执行的错误码

    

    

      
REF_BY

      
该查询或者执行计划被哪个功能引用，其值为SQL_TRACE或者SQL_TRACE(DEMAND）

    

    

      
FIRST_LOAD_TIME

      
该查询或者执行计划第一次记录到内存中的时间

    

    

      
LAST_HIT_TIME

      
该查询或者执行计划上一次被命中的时间

    

    

      
EXECUTIONS

      
执行的总次数

    

    

      
SUM_WAIT_TIME

      
总的等待时间，单位微秒

    

    

      
MIN_WAIT_TIME

      
最小的等待时间，单位微秒

    

    

      
MAX_WAIT_TIME

      
最大的等待时间，单位微秒

    

    

      
SUM_EXEC_TIME

      
总的执行时间，单位微秒

    

    

      
MIN_EXEC_TIME

      
最小的执行时间，单位微秒

    

    

      
MAX_EXEC_TIME

      
最大的执行时间，单位微秒

    

    

      
SUM_ROWS_SENT

      
总的返回行数

    

    

      
MIN_ROWS_SENT

      
最小的返回行数

    

    

      
MAX_ROWS_SENT

      
最大的返回行数

    

    

      
SUM_ROWS_EXAMINED

      
总的扫描行数

    

    

      
MIN_ROWS_EXAMINED

      
最小的扫描行数

    

    

      
MAX_ROWS_EXAMINED

      
最大的扫描行数

    

    

      
SUM_ROWS_AFFECTED

      
总的影响行数

    

    

      
MIN_ROWS_AFFECTED

      
最小的影响行数

    

    

      
MAX_ROWS_AFFECTED

      
最大的影响行数

    

    

      
SUM_LOGICAL_READ

      
总的逻辑读次数

    

    

      
MIN_LOGICAL_READ

      
最小的逻辑读次数

    

    

      
MAX_LOGICAL_READ

      
最大的逻辑读次数

    

    

      
SUM_PHY_SYNC_READ

      
总的物理同步读次数

    

    

      
MIN_PHY_SYNC_READ

      
最小的物理同步读次数

    

    

      
MAX_PHY_SYNC_READ

      
最大的物理同步读次数

    

    

      
SUM_PHY_ASYNC_READ

      
总的物理异步读次数

    

    

      
MIN_PHY_ASYNC_READ

      
最小的物理异步读次数

    

    

      
MAX_PHY_ASYNC_READ

      
最大的物理异步读次数

    

    

      
EXTRA

      
其他信息

    

  

mysql.sql_sharing

该表用于存储需要持续跟踪的SQL信息。当我们指定跟踪特定SQL时，如果我们在集群主节点上指定，该信息就会持久化到mysql.sql_sharing表上同时同步到集群其他节点。其表定义如下。

sql
CREATE TABLE `sql_sharing` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Sql_id` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `Schema_name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `Type` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `Digest_text` longtext COLLATE utf8_bin,
  `Plan_id` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `Plan` text COLLATE utf8_bin,
  `Version` int(11) unsigned DEFAULT NULL,
  `Create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `Update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `Extra_info` longtext COLLATE utf8_bin,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `sqlid_schema_type` (`Sql_id`,`Schema_name`,`Type`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

各个字段意义如下：

  

    

      
字段名

      
字段意义

    

  

  

    

      
Id

      
mysql.sql_sharing表中数据行的自增Id

    

    

      
Sql_id

      
查询的SQL ID

    

    

      
Schema_name

      
查询执行所在的schema

    

    

      
Type

      
使用该数据行的Polar功能

    

    

      
Digest_text

      
查询语句模板化后的文本

    

    

      
Plan_id

      
查询的执行计划ID（SQL Trace功能未使用）

    

    

      
Plan

      
查询的执行计划（SQL Trace功能未使用）

    

    

      
Version

      
该记录在系统内部的版本号

    

    

      
Create_time

      
该记录的插入时间

    

    

      
Update_time

      
该记录的更新时间

    

    

      
Extra_info

      
系统需要记录的其他信息

    

  

相关接口

dbms_sql.add_trace

添加需要跟踪的查询。当loose_sql_trace_type为DEMAND的时候，SQL Trace功能会仅跟踪通过该接口添加的查询。

其语法如下：

 dbms_sql.add_trace('<schema>', '<query>')

输入参数意义如下：

 <schema> 表示查询执行时所在的schema名。

 <query> 表示具体的查询语句。语句中的常量会被自动模板化，匹配该语句模板的查询会被跟踪。

dbms_sql.delete_trace

剔除对指定查询的跟踪。通过add_trace接口添加的查询，可以用该接口剔除跟踪。当loose_sql_trace_type为DEMAND时候，SQL Trace功能不会再跟踪该查询。

其语法如下：

 dbms_sql.delete_trace('<schema>', '<query>')

输入参数意义如下：

 <schema> 表示查询执行时所在的schema名。

 <query> 表示具体的查询语句。语句中的常量会被自动模板化，匹配该语句模板的查询会被从跟踪的查询中剔除。

dbms_sql.delete_trace_by_sqlid

剔除通过add_trace接口添加的查询。该接口和dbms_sql.delete_trace功能相同，仅是参数从具体查询变为了前面介绍polar_sql_id函数时候提到的SQL ID。

其语法如下：

  dbms_sql.delete_trace_by_sqlid('<schema>', '<sql_id>')

输入参数意义如下：

  <schema> 表示查询执行时所在的schema名。

  <query> 表示具体查询语句对应的SQL ID。

dbms_sql.reset_trace_stats

重置SQL Trace的执行统计信息。该接口重置内存中跟踪查询及计划的统计信息。

其语法如下，无输入参数：

dbms_sql.reset_trace_stats()

dbms_sql.flush_trace

清理SQL Trace在内存中的所有记录。

其语法如下，无输入参数：

dbms_sql.flush_trace()

dbms_sql.reload_trace

将mysql.sql_sharing中指定跟踪的查询记录载入到内存中。

其语法如下，无输入参数：

dbms_sql.reload_trace()

相关函数

polar_sql_id.该函数会计算查询语句在PolarDB中模板化后的SQL ID。该ID是一个由13位32进制字符组成的字符串。在SQL Trace功能中，我们会通过该SQL ID来标识模板化后的查询。

其语法如下：

  polar_sql_id('<query>')

输入参数意义如下：

  <query>表示具体的查询语句，该语句会被模板化后计算SQL ID值。

示例：

sql
mysql> select polar_sql_id("select * from  t where c1 > 1 and c1 < 10");
+-----------------------------------------------------------+
| polar_sql_id("select * from  t where c1 > 1 and c1 < 10") |
+-----------------------------------------------------------+
| 82t4dswtqjg02                                             |
+-----------------------------------------------------------+

性能影响

SQL Trace内部使用大量无锁设计，能够保证在高并发、多查询模板数量场景下数据库的性能。

在相同测试场景下，sql_trace_type为OFF和sql_trace_type为ALL（跟踪所有查询）的性能对比。sysbench测试数据量为2千张表，每张表1万行数据。我们分别测试4C8G规格实例和8C32G规格实例，在各个场景oltp_read_only、oltp_read_write下性能影响均不超过3%，详细数据见
官网文档性能测试
。

使用示例

跟踪指定SQL

当我们配置sql_trace_type为DEMAND的时候，我们可以只跟踪特定SQL。

示例数据

sql
mysql> create table t AS WITH RECURSIVE t(c1, c2, c3) AS (SELECT 1, 1, 1 UNION ALL SELECT c1+1, c2 + 1, c3 + 1 FROM t WHERE c1 < 100) SELECT c1, c2, c3 FROM t;
mysql> create index i_c1 on t(c1);

指定跟踪特定SQL。

sql
mysql> call dbms_sql.add_trace('test', 'select * from t where c1 > 1 and c1 < 10');

在PolarDB中通过上述语句添加跟踪的查询后，我们可以看到mysql.sql_sharing中存有如下记录：

我们在数据库中执行以下操作：

sql
mysql> select * from  t where c1 > 1 and c1 < 10;
mysql> select * from  t where c1 > 1 and c1 < 100;

然后访问information_schema.sql_sharing表可以看到对查询模板’SELECT * FROM 
t
 WHERE 
c1
 > ? AND 
c1
 < ?’的跟踪信息。两次执行有两个执行计划，分别是索引i_c1范围扫描和全表扫描。该查询每个执行计划的统计信息和查询总的统计信息都有展示。

sql
mysql> select * from information_schema.sql_sharing\G
*************************** 1. row ***************************
              TYPE: SQL
            SQL_ID: 82t4dswtqjg02
       SCHEMA_NAME: test
       DIGEST_TEXT: SELECT * FROM `t` WHERE `c1` > ? AND `c1` < ?
           PLAN_ID: NULL
              PLAN: NULL
        PLAN_EXTRA: NULL
        ERROR_CODE: NULL
            REF_BY: SQL_TRACE(DEMAND)
   FIRST_LOAD_TIME: 2022-11-07 19:05:28
     LAST_HIT_TIME: 2022-11-07 19:17:24
        EXECUTIONS: 2
     SUM_WAIT_TIME: 363
     MIN_WAIT_TIME: 179
     MAX_WAIT_TIME: 184
     SUM_EXEC_TIME: 925
     MIN_EXEC_TIME: 438
     MAX_EXEC_TIME: 487
     SUM_ROWS_SENT: 106
     MIN_ROWS_SENT: 8
     MAX_ROWS_SENT: 98
 SUM_ROWS_EXAMINED: 108
 MIN_ROWS_EXAMINED: 8
 MAX_ROWS_EXAMINED: 100
 SUM_ROWS_AFFECTED: 0
 MIN_ROWS_AFFECTED: 0
 MAX_ROWS_AFFECTED: 0
  SUM_LOGICAL_READ: 122
  MIN_LOGICAL_READ: 19
  MAX_LOGICAL_READ: 103
 SUM_PHY_SYNC_READ: 0
 MIN_PHY_SYNC_READ: 0
 MAX_PHY_SYNC_READ: 0
SUM_PHY_ASYNC_READ: 0
MIN_PHY_ASYNC_READ: 0
MAX_PHY_ASYNC_READ: 0
             EXTRA: {TRACE_ROW_ID:10}
*************************** 2. row ***************************
              TYPE: PLAN
            SQL_ID: 82t4dswtqjg02
       SCHEMA_NAME: test
       DIGEST_TEXT: NULL
           PLAN_ID: 5a4cvp4gjqgfj
              PLAN: /*+ NO_INDEX(`t`@`select#1`) */
        PLAN_EXTRA: {`t`@`select#1`:ALL}
        ERROR_CODE: 0
            REF_BY: SQL_TRACE(DEMAND)
   FIRST_LOAD_TIME: 2022-11-07 19:17:24
     LAST_HIT_TIME: 2022-11-07 19:17:24
        EXECUTIONS: 1
     SUM_WAIT_TIME: 184
     MIN_WAIT_TIME: 184
     MAX_WAIT_TIME: 184
     SUM_EXEC_TIME: 487
     MIN_EXEC_TIME: 487
     MAX_EXEC_TIME: 487
     SUM_ROWS_SENT: 98
     MIN_ROWS_SENT: 98
     MAX_ROWS_SENT: 98
 SUM_ROWS_EXAMINED: 100
 MIN_ROWS_EXAMINED: 100
 MAX_ROWS_EXAMINED: 100
 SUM_ROWS_AFFECTED: 0
 MIN_ROWS_AFFECTED: 0
 MAX_ROWS_AFFECTED: 0
  SUM_LOGICAL_READ: 103
  MIN_LOGICAL_READ: 103
  MAX_LOGICAL_READ: 103
 SUM_PHY_SYNC_READ: 0
 MIN_PHY_SYNC_READ: 0
 MAX_PHY_SYNC_READ: 0
SUM_PHY_ASYNC_READ: 0
MIN_PHY_ASYNC_READ: 0
MAX_PHY_ASYNC_READ: 0
             EXTRA: NULL
*************************** 3. row ***************************
              TYPE: PLAN
            SQL_ID: 82t4dswtqjg02
       SCHEMA_NAME: test
       DIGEST_TEXT: NULL
           PLAN_ID: 463zszw4mbv3w
              PLAN: /*+ INDEX(`t`@`select#1` `i_c1`) */
        PLAN_EXTRA: {`t`@`select#1`:range}
        ERROR_CODE: 0
            REF_BY: SQL_TRACE(DEMAND)
   FIRST_LOAD_TIME: 2022-11-07 19:17:21
     LAST_HIT_TIME: 2022-11-07 19:17:21
        EXECUTIONS: 1
     SUM_WAIT_TIME: 179
     MIN_WAIT_TIME: 179
     MAX_WAIT_TIME: 179
     SUM_EXEC_TIME: 438
     MIN_EXEC_TIME: 438
     MAX_EXEC_TIME: 438
     SUM_ROWS_SENT: 8
     MIN_ROWS_SENT: 8
     MAX_ROWS_SENT: 8
 SUM_ROWS_EXAMINED: 8
 MIN_ROWS_EXAMINED: 8
 MAX_ROWS_EXAMINED: 8
 SUM_ROWS_AFFECTED: 0
 MIN_ROWS_AFFECTED: 0
 MAX_ROWS_AFFECTED: 0
  SUM_LOGICAL_READ: 19
  MIN_LOGICAL_READ: 19
  MAX_LOGICAL_READ: 19
 SUM_PHY_SYNC_READ: 0
 MIN_PHY_SYNC_READ: 0
 MAX_PHY_SYNC_READ: 0
SUM_PHY_ASYNC_READ: 0
MIN_PHY_ASYNC_READ: 0
MAX_PHY_ASYNC_READ: 0
             EXTRA: NULL

查询分析

可以通过访问information_schema.sql_sharing表来分析指定SQL的执行信息和系统TopSQL等，示例如下：

通过下面语句可以获得指定SQL的执行信息和各个执行计划的执行信息。

sql
SELECT*
FROM information_schema.sql_sharing
WHERE sql_id = polar_sql_id('select * from t');

通过下面语句可以分别获得按照总执行时间、平均执行时间、总扫描行数三个维度Top10的SQL。

sql
SELECT*
FROM information_schema.sql_sharing
WHERE TYPE='sql'
ORDER BY SUM_EXEC_TIME DESC
LIMIT 10;

SELECT *
FROM information_schema.sql_sharing
WHERE TYPE='sql'
ORDER BY SUM_EXEC_TIME/EXECUTIONS DESC
LIMIT 10;

SELECT*
FROM information_schema.sql_sharing
WHERE TYPE='sql'
ORDER BY SUM_ROWS_EXAMINED DESC
LIMIT 10;

总结

PolarDB MySQL通过引入查询的执行计划和性能的监控工具SQL Trace来帮助用户更好的分析查询性能问题。该功能还会持续发展和提升，欢迎使用。

  

    

		

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
