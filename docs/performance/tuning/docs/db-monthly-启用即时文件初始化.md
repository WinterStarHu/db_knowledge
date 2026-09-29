# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/08/06/
> 分类: performance/tuning

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
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 启用即时文件初始化  

    
 Author: 风移  

  

  

  
问题引入

某天，假设您所在公司的生产订单库大库（假设超过1TB）Crash掉了，此时，做为DBA的您，不得不从备份文件中快速将数据库还原出来。但是您发现，这个数据库还原操作初期长达小时时间始化在做数据文件零填充初始操作。于是，您想能否跳过这个数据库文件的初始化操作，快速的还原数据库呢？答案是肯定的，就是我们今天要分享的SQL Server即时文件初始化技术。

什么是即时文件初始化

在即时文件初始化技术面世之前（或者未开启即时文件初始化）的场景中，SQL Server数据库数据文件和日志文件的初始化操作目的是覆盖之前删除的文件遗留在磁盘上的现有数据，操作的方法是通过零填充（用零填充）数据和日志文件来达到目的的，如果数据库较大（几十上百GB）的话，会导致这个初始化动作耗时很长。

因此，从Windows XP（Windows Server 2003）开始，NTFS文件系统加入了新特性，允许跳过用零填充文件的初始化步骤，叫即时文件初始化。SQL Server 2005引入了即时文件初始化的新特性，可以在瞬间对数据文件进行初始化，以避免零填充操作。即时文件初始化可以快速执行文件创建操作，无论数据库文件的大小有多大。

为什么需要即时文件初始化

一般情况下，操作系统中文件创建的请求都是小文件创建操作，比如：新建一个Word文档或者Excel表格。对于这种小文件创建初始化操作来说，性能提升几乎无感知。但是，对于像数据库这种大文件的频繁操作来说，即时文件初始化在以下场景就显得尤为重要了：

	创建数据库。

	现有数据库添加数据或日志文件。

	增大数据库现有文件的大小。

	数据库文件自动增长操作。

	还原数据库或文件组。

这些数据库（或者说数据库文件）的操作，无论数据库文件大小多大，都可以即时完成，而无需等待零填充操作。

假设，某一天您的生产环境的订单库Crash掉了，而不幸的是这个库恰好是一个超大库（假设超过1TB）。这时候，您做为DBA，不得不选择从备份文件中争分夺秒的将数据库还原出来，如果在没有开启即时文件初始化的情况下，要将1TB的文件以零填充，这个初始化操作耗时可能长达小时级别。而在即时文件初始化开启的情况下，这个动作瞬间完成，大大提速了您数据库还原的动作，最大限度减少损失。由此可见，即时文件初始化可以大大提高数据库文件操作的效率，好处是显而易见的。

注意：

只有数据库数据文件才支持即时文件初始化功能。而创建或修改数据库日志文件大小时，不支持即时文件初始化功能，还是将始终零填充该文件。

如何开启即时文件初始化

即时文件初始化功能仅在向SQL Server 服务启动帐户授予了SE_MANAGE_VOLUME_NAME 权限之后才可用 。因此，我们只需要授予SQL Server启动账号相应的权限即可。方法如下：

	找到SQL Server启动账号

	授予SE_MANAGE_VOLUME_NAME

	重启SQL Server

找到SQL Server启动账号

打开SQL Server管理配置工具 -> SQL Server Services -> 右侧找到 SQL Server (MSSQLSERVER) -> 在Log On As列中的用户名就是SQL Server的启动账号。

授予SE_MANAGE_VOLUME_NAME

secpol.msc -> Security Settings -> Local Policies -> User Rights Assignment -> 双击“Perform volume maintenance tasks” -> Add User or Group -> NETWORK SERVICES -> OK

重启SQL Server

开启即时文件初始化的最后一步是重启SQL Server Service。

测试即时文件初始化

即时文件初始化是操作系统层面对数据库文件的行为，确实不太好观察和验证，好在SQL Server中有未公开的Trace Flag 3004，我们只需要打开3004和3006，将其输出到SQL Server错误日志文件中即可验证。

DBCC TRACEON (3004 ,3605 ,-1)
GO

CREATE DATABASE TestInstallInit
GO

EXEC sys.sp_readerrorlog
GO

DBCC TRACEOFF (3004 ,3605 ,-1)
GO

如下截图所示：

从SQL Server错误日志中，我们已经观察到Zeroing动作只在事务日志文件上发生，数据文件未见Zeroing。因此，即时文件初始化已经生效。

最后总结

即时文件初始化可以大大加速SQL Server数据库数据文件操作，包括创建数、修改和还原数据库等操作，是SQL Server数据库管理与运维需要重点考虑的优化点。

  

    

		

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
