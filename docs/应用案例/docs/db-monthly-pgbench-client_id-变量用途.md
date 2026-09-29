# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/08/10/
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
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · pgbench client_id 变量用途  

    
 Author: digoal  

  

  

  
背景

pgbench是 PG内置的一款压测工具，效率非常高。内置tpcb测试模型，并且支持自定义压测模型（内置了非常丰富的变量生成函数，操作符，函数，变量。同时支持shell 调用结果作为变量传输。支持多个压测文件，文件权重设置等）。

详见

https://www.postgresql.org/docs/current/pgbench.html

由于pgbench支持客户端并行，可以开启多个链接进行测试。每个链接有一个唯一的标示：

client_id :

unique number identifying the client session (starts from zero)

采用client_id，可以模拟数据隔离的更新操作（防止多个链接相互更新到相同记录，导致锁问题，与真实场景不符，或影响更新测试性能）

或者将client_id作为动态identify的suffix组成，实现不同线程操作不同表的需求。（pgbench暂时还不支持这个功能, 可以参考这里说明 
《PostgreSQL 使用 pgbench 测试 sysbench 相关case - pg_oltp_bench》
   需要修改pgbench代码parseQuery）

vi test.sql  
\set id1 random(1, 10000000)  
SELECT pad FROM "sbtest:client_id" WHERE id = :id1;  
  
$ pgbench -M prepared -n -r -P 1 -f ./test.sql -h xxx.xxx.xxx.xxx -p 1924 -U postgres postgres -c 3 -j 3 -T 100   
  
目前会报错，只支持simple模式。  如果要让prepared模式支持，建议改pgbench代码来支持. 例如使用:::varname时，拼接identifid。     
ERROR:  relation "sbtest$1" does not exist  
LINE 1: SELECT pad FROM "sbtest$1" WHERE id = $2;  
                        ^  
client 0 aborted in state 1: ERROR:  prepared statement "P0_1" does not exist  
ERROR:  relation "sbtest$1" does not exist  
LINE 1: SELECT pad FROM "sbtest$1" WHERE id = $2;  
                        ^  
client 1 aborted in state 1: ERROR:  prepared statement "P0_1" does not exist  
ERROR:  relation "sbtest$1" does not exist  
LINE 1: SELECT pad FROM "sbtest$1" WHERE id = $2;  
                        ^  
client 2 aborted in state 1: ERROR:  prepared statement "P0_1" does not exist  

例子

upsert，确保不同的会话一定相互不会出现行级锁冲突干扰。

create table t(id int primary key, info text, crt_time timestamp);  

数据ID范围1亿，64个并发操作。确保不同并发操作的ID相互绝对不会重叠

vi test.sql  
  
\set id random(1,100000000)/64+:client_id  
insert into t values (:id, md5(random()::text), now()) on conflict (id) do update set info=excluded.info , crt_time=excluded.crt_time;  

说明：

\set id random(1,100000000)/64+:client_id  
  
random(1,100000000) 返回1到1亿之间的随机int  
/64除以64得到trunc int  
+:client_id ， 加每个线程的number，  
  
得到的值，赋予给id， 从而不同的线程绝对不会有重复的id出现  

postgres=# select * from t limit 10;  
   id    |               info               |          crt_time            
---------+----------------------------------+----------------------------  
  259017 | 1d55b352a6d0505bd9f5f7d4c445233b | 2019-08-28 22:27:38.123068  
 1472003 | 493446240b69fd241c135a238d70eab4 | 2019-08-28 22:27:35.934951  
 1001450 | 74d8334822be81483bffe7da3b5f0253 | 2019-08-28 22:27:26.06475  
  985969 | f9790129e9f4fe2da6f0d887abc5bb1c | 2019-08-28 22:27:37.722908  
 1140661 | d8214e5c1994549b612b7e4194c63bcb | 2019-08-28 22:27:37.205729  
 1252023 | 6d8fbeb3d039749e6594b8913955cde1 | 2019-08-28 22:27:29.841494  
  727159 | 68fa51af79d7c01502a79b8873aeb8fa | 2019-08-28 22:27:31.892077  
  687989 | 00b95072f38ffc73fb9e5b0ace009b5d | 2019-08-28 22:27:15.524358  
 1029162 | 113a44124e08be8105690a24b456863e | 2019-08-28 22:27:23.566686  
 1204224 | c6ea8e3c66790ccf3dd22b9feab2f4a6 | 2019-08-28 22:27:29.696627  
(10 rows)  

性能杠杠的

pgbench -M prepared -n -r -P 1 -f ./test.sql -c 64 -j 64 -T 120  
  
transaction type: ./test.sql  
scaling factor: 1  
query mode: prepared  
number of clients: 64  
number of threads: 64  
duration: 120 s  
number of transactions actually processed: 25803874  
latency average = 0.297 ms  
latency stddev = 0.251 ms  
tps = 215005.904762 (including connections establishing)  
tps = 215027.544261 (excluding connections establishing)  
statement latencies in milliseconds:  
         0.001  \set id random(1,100000000)/64+:client_id  
         0.296  insert into t ...........................  

即使id取值范围就是0-31，性能也是杠杠的。

vi test.sql  
insert into t values (:client_id, md5(random()::text), now()) on conflict (id) do update set info=excluded.info , crt_time=excluded.crt_time;  
  
pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
  
transaction type: ./test.sql  
scaling factor: 1  
query mode: prepared  
number of clients: 32  
number of threads: 32  
duration: 120 s  
number of transactions actually processed: 30045516  
latency average = 0.127 ms  
latency stddev = 0.073 ms  
tps = 250377.400798 (including connections establishing)  
tps = 250393.055448 (excluding connections establishing)  
statement latencies in milliseconds:  
         0.127  insert into t values (:client_id, ...........  

如果没有使用client_id，那锁冲突就会比较严重，造成等待影响性能。从25万qps下降到了18万qps。

vi test.sql  
\set id random(0,31)  
insert into t values (:id, md5(random()::text), now()) on conflict (id) do update set info=excluded.info , crt_time=excluded.crt_time;  
  
pgbench -M prepared -n -r -P 1 -f ./test.sql -c 32 -j 32 -T 120  
  
transaction type: ./test.sql  
scaling factor: 1  
query mode: prepared  
number of clients: 32  
number of threads: 32  
duration: 120 s  
number of transactions actually processed: 21619627  
latency average = 0.177 ms  
latency stddev = 0.138 ms  
tps = 180162.287114 (including connections establishing)  
tps = 180174.521514 (excluding connections establishing)  
statement latencies in milliseconds:  
         0.000  \set id random(0,31)  
         0.177  insert into t values (:id, ............  

小结

期待pgbench支持在identify字段中支持变量，而不仅仅是非identify内容中支持变量。

参考

《PostgreSQL 使用 pgbench 测试 sysbench 相关case - pg_oltp_bench》

《PostgreSQL 10.0 preview 性能增强 - 2PC事务恢复阶段性能提升》

《PostgreSQL native partition 分区表性能优化之 - 动态SQL+服务端绑定变量》

《PostgreSQL Oracle 兼容性之 - DBMS_SQL(存储过程动态SQL中使用绑定变量-DB端prepare statement)》

https://www.postgresql.org/docs/current/pgbench.html

  

    

		

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
