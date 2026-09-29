# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/10/07/
> 分类: 内核开发

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
	

  

    
数据库内核月报 － 2017 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PgSQL · 特性分析 · MVCC机制浅析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· CloudDBA SQL优化建议之统计信息获取
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB mini transation
                      

                    

                    

                  
                      

                        MySQL · 特性介绍 · 一些流行引擎存储格式简介
                      

                    

                    

                  
                      

                        MSSQL · 架构分析 · 从SQL Server 2017发布看SQL Server架构的演变
                      

                    

                    

                  
                      

                        MySQL · 引擎介绍 · Sphinx源码剖析(三)
                      

                    

                    

                  
                      

                        PgSQL · 内核开发 · 如何管理你的 PostgreSQL 插件
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 数据一样checksum不一样
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 经营、销售分析系统DB设计之共享充电宝
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 信号处理机制分析
                      

                    

 
        

    

  

    
 PgSQL · 内核开发 · 如何管理你的 PostgreSQL 插件  

    
 Author: 义从  

  

  

  
一.背景

我们都知道 PostgreSQL 提供了丰富数据库内核编程的接口，允许开发者以插件的形式把功能融入数据库内核。

PostgreSQL 提供了一个插件管理模块，用于管理用户创建的插件。

本文给大家介绍 PostgreSQL 插件管理模块，帮助大家管理自己的插件。

二.PostgreSQL的插件内容

通常一个 PostgreSQL 内核插件包括下面的部分

  
1. 包含功能的逻辑的动态库，即 so 文件。

  
2. 描述插件信息的的控制文件，即 control 文件。

  
3. 一组文件用于创建、更新和删除插件，这是一组按照版本命名的 SQL 文本文件。

如果缺少了上述部分，或版本号不正确，插件的管理功能会异常。

三.插件的管理

我们使用 create extension， drop extension alter extension 管理指定的插件。

1.插件的创建

例如 postgres_fdw 的创建

create extension postgres_fdw;
drop extension postgres_fdw;

我们可以选择把插件创建到指定的模式中。

2.插件的管理视图

这是最简单的部分，创建插件后，我们可以通过插件管理视图看到一些细节信息

select * from pg_extension ;
   extname    | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition 
--------------+----------+--------------+----------------+------------+-----------+-------------- 
 postgres_fdw |       10 |         2200 | t              | 1.0        |           | 

可以看到，postgres_fdw 的 owner, 存在的 schema 和插件的小版本。

3.插件的删除

插件的内容可以是任何的数据库对象，例如：函数、操作符等等。

这些对象可能被其他的对象引用，例如我们在 postgres_fdw 创建了基于 postgres_fdw 的外部表。

当我们要删除 postgres_fdw 时，需要加上 cascade 子句，把相关对象一并删除。

drop extension postgres_fdw cascade;

这么做带来的问题是，所有依赖这个插件的对象都会被删除。再次使用需要重建。

4.插件的更新

有时候，我们需要做插件的 BUGFIX ，或定制一些功能。这就用到了插件更新功能。

  
首先，我们需要升级插件的小版本

修改控制文件 .control, 增加一个小版本，如果当前版本是 1.1，则文件中版本号修改成 1.2

  
添加新版本的的 DDL SQL 文件

添加新版本的 DDL SQL 文件 *–1.2.sql, 用于从零创建该插件。

该 SQL 文件应该包括该插件的所有对象的 DDL。

  
添加用户老版本升级到新版本的 DDL SQL 文件

创建 *1.1–1.2.sql，用于从版本 1.1 升级到 1.2

该 SQL 文件只包含 1.2 版本中新创建的对象。用户的升级操作会调用该 SQL 文件，从而避免了完全重新创建。

  

    
修改源码添加新的功能，编译并安装到指定目录。

  

  

    
使用 SQL 升级小版本

  

alter extension postgres_fdw update;

如果成功更新，我们能从视图中看到对应的小版本号被更新了。

postgres=# select * from pg_extension ;
   extname    | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition 
--------------+----------+--------------+----------------+------------+-----------+--------------
postgres_fdw |       10 |         2200 | t              | 1.2        |           | 
(2 rows)

使用 PostgreSQL 的插件管理功能，用户很容开发和维护需要的插件。

其他

有几点需要特别提醒，这是在开发和管理插件时，经常碰到的问题，需要多加注意

  
插件是通过动态库形式引入到内核中。和内核在同一个进程中运行，且没有内存保护，影响内核的稳定性。开发中需要特别注意内存的使用。不要造成内存泄露或越界写。建议使用 PostgreSQL 的内存管理机制，插件中也能使用。

  
内核中被标记成 PGDLLIMPORT 的全局变量都能在插件中直接使用，这些通常是一些 GUC 参数。

  
内核中非 static 的函数也能在插件中使用，只需要先 extern 它们。

  
我们可以实现 _PG_init 用于实现一些初始化工作，该函数在连接建立后只会被执行一次。

  
我们可以在 _PG_init 中使用函数 DefineCustom*Variable 定义对应插件相关的 GUC 参数，他们可以用于开启和关闭该插件的一些功能。

  
插件的参数需要以插件名开头且加上点，例如 oss_fdw.enable_parallel_read。

参考

  

PostgreSQL 插件的创建

  

PostgreSQL 插件的删除

  

PostgreSQL 插件的修改/升级

  

    

		

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
