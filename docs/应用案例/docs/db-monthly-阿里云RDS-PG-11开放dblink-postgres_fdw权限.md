# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/10/09/
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
	

  

    
数据库内核月报 － 2019 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb 表空间
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · POLARDB 并行查询加速全程详解
                      

                    

                    

                  
                      

                        MySQL · Optimizer · Parallel Index Scans, One is Better Than Two
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · X-Engine MySQL RDS 用户的新选择
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Sequence Engine
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 分组提交的使用与注意
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · Spark Connector 实战指南
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 12 tpcc - use sysbench-tpcc by Percona-Lab
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  阿里云RDS PG 11开放dblink, postgres_fdw权限
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · Oracle 20c 新特性 - 翻出了PG十年前的特性
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 ·  阿里云RDS PG 11开放dblink, postgres_fdw权限  

    
 Author: digoal  

  

  

  
背景

阿里云RDS PG 11 云盘版开放相同vpc的实例间的dblink, postgres_fdw功能。相同vpc内如果有自建的pg实例，也可以被访问，如果要访问vpc外部的其他实例，通过相同vpc内ecs的端口跳转也能实现。

阿里云RDS PG 11 云盘版购买入口：

https://rds-buy.aliyun.com/rdsBuy?spm=5176.7920951.1393245.1.41c64ce1pOvLll&aly_as=JoVfjAtF#/create/rds?initData=%7B%22data%22:%7B%22rds_dbtype%22:%22PostgreSQL%22%7D%7D

支持距离

rds pg 11 (postgres_fdw , dblink) 可以访问如下：

1、same vpc ecs/rds pg

2、same vpc ecs（端口转发） -> other vpc/network pg

3、same vpc ecs(自建pg+oracle_fdw,mysql_fdw) -> other vpc\/network oracle|mysql

rds pg 11 (将支持oracle_fdw, mysql_fdw) 可以访问如下：

1、same vpc ecs(oracle， mysql)\/rds mysql

2、same vpc ecs(端口转发) -> other vpc\/network mysql|oracle

通过同vpc内ecs的端口转发功能，可以访问ecs可以访问的任意目标。(只要ecs能访问的，rds pg就可以通过这个端口代理去访问)

端口转发见本文参考部分。

例子

dblink例子

postgres=> select dblink_connect('a', 'host=同一vpc下的另一rds的内网域名 port=同一vpc下的另一rds的内网监听端口 user=远程数据库用户名 password=密码 dbname=库名');  
 dblink_connect   
----------------  
 OK  
(1 row)  
  
postgres=> select version();  
     version       
-----------------  
 PostgreSQL 11.5  
(1 row)  
  
postgres=> SELECT * FROM dblink('a', 'SELECT version()') as t(ver text);  
       ver          
------------------  
 PostgreSQL 10.10  
(1 row)  

postgres_fdw例子

新建一个数据库

postgres=> create database db1;  
CREATE DATABASE  
  
postgres=> \c db1  

新建postgres_fdw插件

db1=> create extension postgres_fdw;  
CREATE EXTENSION  

新建远程数据库server

db1=> CREATE SERVER foreign_server                                                              
        FOREIGN DATA WRAPPER postgres_fdw  
        OPTIONS (host '同一vpc下的另一rds的内网域名 port=同一vpc下的另一rds的内网监听端口', port '同一vpc下的另一rds的内网监听端口', dbname '库名');  
CREATE SERVER  
  
db1=> CREATE USER MAPPING FOR digoal      
        SERVER foreign_server  
        OPTIONS (user '远程数据库用户', password '密码');  
CREATE USER MAPPING  

导入外部表

db1=> import foreign schema public from server foreign_server into ft;  
IMPORT FOREIGN SCHEMA  
  
db1=> \det ft.*  
            List of foreign tables  
 Schema |       Table        |     Server       
--------+--------------------+----------------  
 ft     | customer1          | foreign_server  
 ft     | district1          | foreign_server  
 ft     | ha_health_check    | foreign_server  
 ft     | history1           | foreign_server  
 ft     | item1              | foreign_server  
 ft     | new_orders1        | foreign_server  
 ft     | order_line1        | foreign_server  
 ft     | orders1            | foreign_server  
 ft     | pg_stat_statements | foreign_server  
 ft     | stock1             | foreign_server  
 ft     | warehouse1         | foreign_server  
(11 rows)  

参考

https://www.postgresql.org/docs/12/postgres-fdw.html

https://www.postgresql.org/docs/12/dblink.html

《使用 ssh -R 建立反向/远程TCP端口转发代理》

《使用 ssh -R 建立反向/远程TCP端口转发代理》

《一个端口代理软件 - inlab balance》

  

    

		

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
