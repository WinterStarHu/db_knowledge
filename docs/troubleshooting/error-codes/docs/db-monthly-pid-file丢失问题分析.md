# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/03/03/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2015 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 答疑释惑· 并发Replace into导致的死锁分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 5.7.6 InnoDB page flush 优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· pid file丢失问题分析
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· using filesort VS using temporary
                      

                    

                    

                  
                      

                        MySQL · 优化限制· MySQL index_condition_pushdown
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· lower_case_table_names 使用问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Logical Decoding探索
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· jsonb类型解析
                      

                    

                    

                  
                      

                        TokuDB ·引擎机制· TokuDB线程池
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态· pid file丢失问题分析  

    
 Author:   

  

  

  

现象

mysql5.5,通过命令show variables like '%pid_file%'; 可以查到pid文件位置，例如/home/mysql/xx.pid。但发现在此目录下找不到此pid文件。

背景知识

mysql pid文件记录的是当前mysqld进程的pid。

通过mysqld_safe启动mysqld时，mysqld_safe会检查PID文件，未指定PID文件时，pid文件默认名为$DATADIR/
hostname
.pid

  
pid文件不存在，不做处理

  
文件存在，且pid已占用则报错"A mysqld process already exists"；文件存在，但pid未占用，则删除pid文件。

mysqld启动后会通过create_pid_file函数新建pid文件，通过getpid()获取当前进程pid并将pid写入pid文件。

因此，通过mysqld_safe启动时，pid文件的作用是为了防止同一个数据库被启动多次（数据文件是同一份，但端口不同的情况）。

另一个事实是mysqld在正常关闭时或通过SIGQUIT,SIGKILL,SIGTERM信号来kill mysqld时，会调用clean_up函数将pid文件删除。而mysqld异常crash时，pid文件是保留的。

另外mysqld_safe有一个功能是当mysqld异常crash时，后台会自动重启mysqld。mysqld关闭后，mysqld_safe会检查pid文件是否存在。如果存在则认为mysqld是异常crash, 需要自动重启；如果不存在则认为是正常关闭的，不需要自动重启,mysqld_safe程序也退出。

原因分析

查看error log发现数据库在相近的时间内启动了两次

141128 23:16:15 mysqld_safe Starting mysqld daemon with databases from 
….. 
141128 23:16:23 mysqld_safe Starting mysqld daemon with databases from 

前面说到mysqld_safe启动mysqld时,会根据pid文件来判断避免重复启动mysqld.然而，由于两次启动时间较近，导致第一次mysqld启动生成pid文件之前，第二个mysqld就已开始启动了，从而绕过了这个判断。第一次mysqld启动会成功，而第二次mysqld启动会因为文件锁而导致启动失败。

InnoDB: Unable to lock ./ibdata1, error: 11

第二次启动的mysqld关闭时会将第一次启动时产生的pid文件删除，从而导致pid文件丢失。

通过mysqld_safe启动mysqld来重现pid文件丢失有一定的概率性，必须是同时启动mysqld_safe。 如果是直接通过mysqld启动，同时指定相同的参数启动两次，那么就很容易重现了。

修复

参考5.6 官方的修复方法，在上述场景下删除pid文件时，需判断是否是自己新建的pid文件，同时文件中的pid是否和自身pid一致，否则不能删除。参考
补丁

  

    

		

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
