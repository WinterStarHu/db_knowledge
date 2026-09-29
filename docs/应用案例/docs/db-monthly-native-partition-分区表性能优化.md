# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/01/10/
> 分类: 应用案例

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
	

  

    
数据库内核月报 － 2019 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 理论基础 · 数据库故障恢复机制的前世今生
                      

                    

                    

                  
                      

                        POLARDB · 最佳实践 · POLARDB不得不知道的秘密(二)
                      

                    

                    

                  
                      

                        MongoDB · 原理介绍 · MongoDB从事务到复制
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · PostgreSQL 并行查询概述
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 如何打码隐私数据列
                      

                    

                    

                  
                      

                        Redis · 引擎特性 · Lua脚本新姿势
                      

                    

                    

                  
                      

                        Mariadb · 源码分析 · proxy protocol
                      

                    

                    

                  
                      

                        MySQL · InnoDB · tablespace源码分析
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · MySQL中的IO共享操作
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · native partition 分区表性能优化
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · native partition 分区表性能优化  

    
 Author: digoal  

  

  

  
背景

目前PG的native partition分区性能还有优化空间，一种解决方法是使用pg_pathman插件，另一种方法是业务上直接插分区，还有一种方法是使用UDF函数接口（函数内部使用prepared statement来降低PARSE  CPU开销）。

本文提供的是UDF的例子，以及性能比对。

例子

1、创建分区表

create table p (id int , info text, crt_time timestamp) partition by list (abs(mod(id,128)));    

2、创建128个分区

do language plpgsql $$  
declare  
begin  
  for i in 0..127 loop  
    execute format('create table p%s partition of p for values in (%s)', i, i);  
  end loop;  
end;  
$$;  

直接插分区主表

vi test.sql  
\set id random(1,2000000000)  
insert into p values (:id, 'test', now());  

性能

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 64 -j 64 -T 120  
  
  
  
pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
progress: 1.0 s, 26287.2 tps, lat 1.178 ms stddev 0.418  
progress: 2.0 s, 27441.8 tps, lat 1.166 ms stddev 0.393  
progress: 3.0 s, 27526.0 tps, lat 1.163 ms stddev 0.398  

批量插性能

vi test.sql  
  
insert into p values (1,'test',now()),(2,'test',now()),(3,'test',now()),(4,'test',now()),(5,'test',now()),(6,'test',now()),(7,'test',now()),(8,'test',now()),(9,'test',now()),(10,'test',now());  

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
progress: 1.0 s, 26240.5 tps, lat 1.179 ms stddev 0.462  
progress: 2.0 s, 28285.8 tps, lat 1.131 ms stddev 0.393  
progress: 3.0 s, 28185.1 tps, lat 1.135 ms stddev 0.423  
progress: 4.0 s, 28266.1 tps, lat 1.132 ms stddev 0.395  
progress: 5.0 s, 28248.9 tps, lat 1.133 ms stddev 0.438  
progress: 6.0 s, 26739.0 tps, lat 1.197 ms stddev 1.154  
progress: 7.0 s, 28075.1 tps, lat 1.140 ms stddev 0.426  
progress: 8.0 s, 28297.8 tps, lat 1.131 ms stddev 0.384  

使用UDF+绑定变量插分区

1、绑定变量的语法

postgres=# \h prepare  
Command:     PREPARE  
Description: prepare a statement for execution  
Syntax:  
PREPARE name [ ( data_type [, ...] ) ] AS statement  
  
postgres=# \h execute  
Command:     EXECUTE  
Description: execute a prepared statement  
Syntax:  
EXECUTE name [ ( parameter [, ...] ) ]  

2、写一个UDF，使用绑定变量插入

create or replace function ins_p(int, text, timestamp) returns void as $$  
declare  
  suffix text := abs(mod($1,128));  
begin  
  execute format('execute ps%s(%s, %L, %L)', suffix, $1, $2, $3);  
  exception when others then  
    execute format('prepare ps%s(int,text,timestamp) as insert into p%s (id,info,crt_time) values ($1,$2,$3)', suffix, suffix);  
    execute format('execute ps%s(%s, %L, %L)', suffix, $1, $2, $3);  
end;  
$$ language plpgsql strict;  

3、性能

vi test.sql  
  
\set id random(1,2000000000)  
select ins_p(:id, 'test', now()::timestamp);  

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
progress: 1.0 s, 192814.1 tps, lat 0.161 ms stddev 0.092  
progress: 2.0 s, 205480.6 tps, lat 0.156 ms stddev 0.061  
progress: 3.0 s, 209206.4 tps, lat 0.153 ms stddev 0.058  
progress: 4.0 s, 206333.8 tps, lat 0.155 ms stddev 0.061  

如果是BATCH写入，可以改一下这个UDF如下

create or replace function ins_p(int, text, timestamp) returns void as $$  
declare  
  suffix text := abs(mod($1,128));  
begin  
  execute format('execute ps%s(%s, %L, %L)', suffix, $1, $2, $3);  
  exception when others then  
    execute format('prepare ps%s(int,text,timestamp) as insert into p%s (id,info,crt_time) values ($1,$2,$3)', suffix, suffix);  
    execute format('execute ps%s(%s, %L, %L)', suffix, $1, $2, $3);  
end;  
$$ language plpgsql strict;  

create or replace function ins_p_batch(p[]) returns void as $$  
declare  
  i p;  
begin  
  foreach i in array $1 loop  
    perform ins_p(i.id, i.info, i.crt_time);  
  end loop;  
end;  
$$ language plpgsql strict;  

batch使用举例

postgres=# select count(*) from p;  
  count     
----------  
 28741670  
(1 row)  
  
Time: 390.775 ms  
postgres=# select ins_p_batch((select array_agg(p) from (select p from p limit 10000) t));  
 ins_p_batch   
-------------  
   
(1 row)  
  
Time: 247.861 ms  
postgres=# select count(*) from p;  
  count     
----------  
 28751670  
(1 row)  
  
Time: 383.485 ms  

postgres=# select array_agg(p) from (select p from p limit 10) t;  
-[ RECORD 1 ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
array_agg | {"(1269675648,test,\"2019-01-09 17:08:35.432933\")","(1515917568,test,\"2019-01-09 17:08:35.435001\")","(137413760,test,\"2019-01-09 17:08:35.438484\")","(1750920192,test,\"2019-01-09 17:08:35.443544\")","(849316096,test,\"2019-01-09 17:08:35.448552\")","(891638016,test,\"2019-01-09 17:08:35.449074\")","(320902144,test,\"2019-01-09 17:08:35.449142\")","(95829120,test,\"2019-01-09 17:08:35.453658\")","(358048256,test,\"2019-01-09 17:08:35.454924\")","(1009512320,test,\"2019-01-09 17:08:35.457164\")"}  
  
Time: 1.771 ms  
  
postgres=# select ins_p_batch('{"(1269675648,test,\"2019-01-09 17:08:35.432933\")","(1515917568,test,\"2019-01-09 17:08:35.435001\")","(137413760,test,\"2019-01-09 17:08:35.438484\")","(1750920192,test,\"2019-01-09 17:08:35.443544\")","(849316096,test,\"2019-01-09 17:08:35.448552\")","(891638016,test,\"2019-01-09 17:08:35.449074\")","(320902144,test,\"2019-01-09 17:08:35.449142\")","(95829120,test,\"2019-01-09 17:08:35.453658\")","(358048256,test,\"2019-01-09 17:08:35.454924\")","(1009512320,test,\"2019-01-09 17:08:35.457164\")"}');  
 ins_p_batch   
-------------  
   
(1 row)  
  
Time: 0.841 ms  

性能

vi test.sql  
select ins_p_batch('{"(1269675648,test,\"2019-01-09\")","(1515917568,test,\"2019-01-09\")","(137413760,test,\"2019-01-09\")","(1750920192,test,\"2019-01-09\")","(849316096,test,\"2019-01-09\")","(891638016,test,\"2019-01-09\")","(320902144,test,\"2019-01-09\")","(95829120,test,\"2019-01-09\")","(358048256,test,\"2019-01-09\")","(1009512320,test,\"2019-01-09\")"}');  

一次插10行

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
progress: 1.0 s, 41637.4 tps, lat 0.745 ms stddev 0.742  
progress: 2.0 s, 42862.5 tps, lat 0.746 ms stddev 0.614  
progress: 3.0 s, 42417.1 tps, lat 0.754 ms stddev 0.689  
progress: 4.0 s, 42389.5 tps, lat 0.755 ms stddev 0.691  

应用程序直接写分区

性能

vi test.sql  
\set id random(1,2000000000)  
insert into p2 values (2,'test',now());  

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
progress: 1.0 s, 364350.5 tps, lat 0.085 ms stddev 0.208  
progress: 2.0 s, 379071.4 tps, lat 0.084 ms stddev 0.215  
progress: 3.0 s, 384452.1 tps, lat 0.083 ms stddev 0.188  

性能对比

方法 | 每秒插入多少行

—|—

插分区主表(单条) | 2.7万

插分区主表(10条) | 28万

应用直接插分区(单条) | 38万

使用UDF+动态绑定变量插分区(单条) | 20万

使用UDF+动态绑定变量批量查(10条) | 42万

另外需要注意，并发越高，直接插主表的性能越差，例如使用64个并发插入时，只有2.1万行/s。

参考

《PostgreSQL 9.x, 10, 11 hash分区表 用法举例》

《分区表锁粒度差异 - pg_pathman VS native partition table》

《PostgreSQL 商用版本EPAS(阿里云ppas(Oracle 兼容版)) - 分区表性能优化 (堪比pg_pathman)》

《PostgreSQL 10 内置分区 vs pg_pathman perf profiling》

《PostgreSQL 9.6 sharding based on FDW & pg_pathman》

《PostgreSQL 9.5+ 高效分区表实现 - pg_pathman》

《PostgreSQL 查询涉及分区表过多导致的性能问题 - 性能诊断与优化(大量BIND, spin lock, SLEEP进程)》

digoal’s 大量PostgreSQL文章入口

免费领取阿里云RDS PostgreSQL实例、ECS虚拟机

  

    

		

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
