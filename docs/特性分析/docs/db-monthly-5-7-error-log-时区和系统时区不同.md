# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/01/09/
> 分类: 特性分析

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
	

  

    
数据库内核月报 － 2017 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 同步机制
                      

                    

                    

                  
                      

                        MySQL · myrocks · myrocks index condition pushdown
                      

                    

                    

                  
                      

                        PgSQL · 案例分享 · PostgreSQL+HybridDB解决企业TP+AP混合需求
                      

                    

                    

                  
                      

                        MongoDB · 特性分析 · 网络性能优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · event_scheduler 慢日志记错
                      

                    

                    

                  
                      

                        PgSQL · 引擎介绍 · 向量化执行引擎简介
                      

                    

                    

                  
                      

                        SQL Server · 特性分析 ·  2012列存储索引技术
                      

                    

                    

                  
                      

                        PgSQL · 乱入拜年 · 小鸡吉吉和小象Pi吉(PostgreSQL)的鸡年传奇
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.7 error log 时区和系统时区不同
                      

                    

                    

                  
                      

                        TokuDB · 源码分析 · 一条query语句的执行过程
                      

                    

 
        

    

  

    
 MySQL · 特性分析 · 5.7 error log 时区和系统时区不同  

    
 Author: xijia.xj  

  

  

  
问题描述

现象

5.6 和 5.7 时区设置相同，select now()也显示当前时间

5.7 error log 中时间和当前时间差8小时

问题分析

5.6 写 error log 函数如下

取时间的函数是localtime_r(&skr, &tm_tmp)

日志中时间和系统时区相同

    static void print_buffer_to_file(enum loglevel level, const char *buffer,                                                                                                                                       
                                     size_t length)
    {   
      time_t skr; 
      struct tm tm_tmp;
      struct tm *start;
      DBUG_ENTER("print_buffer_to_file");
      DBUG_PRINT("enter",("buffer: %s", buffer));
    
      mysql_mutex_lock(&LOCK_error_log);
    
      skr= my_time(0);
      localtime_r(&skr, &tm_tmp);
      start=&tm_tmp;
    
      fprintf(stderr, "%d-%02d-%02d %02d:%02d:%02d %lu [%s] %.*s\n",
              start->tm_year + 1900,
              start->tm_mon + 1,  
              start->tm_mday,
              start->tm_hour,
              start->tm_min,
              start->tm_sec,
              current_pid,
              (level == ERROR_LEVEL ? "ERROR" : level == WARNING_LEVEL ?
               "Warning" : "Note"),
              (int) length, buffer);
    
      fflush(stderr);
    
      mysql_mutex_unlock(&LOCK_error_log);
      DBUG_VOID_RETURN;
    }

5.7 写 error log 函数如下

取时间的函数是 make_iso8601_timestamp(my_timestamp)

    static void print_buffer_to_file(enum loglevel level, const char *buffer,
                                     size_t length)
    {
      DBUG_ENTER("print_buffer_to_file");
      DBUG_PRINT("enter",("buffer: %s", buffer));
 
      char my_timestamp[iso8601_size];
 
      my_thread_id thread_id= 0;
 
      /*
        If the thread system is up and running and we're in a connection,
        add the connection ID to the log-line, otherwise 0.
      */
      if (THR_THD_initialized && (current_thd != NULL))
        thread_id= current_thd->thread_id();
 
      make_iso8601_timestamp(my_timestamp);
 
      /*
        This must work even if the mutex has not been initialized yet.
        At that point we should still be single threaded so that it is
        safe to write without mutex.
      */
      if (error_log_initialized)
        mysql_mutex_lock(&LOCK_error_log);
 
      if (error_log_buffering)
      {
        // Logfile not open yet, buffer messages for now.
        if (buffered_messages == NULL)
          buffered_messages= new (std::nothrow) std::string();
        std::ostringstream s;
        s << my_timestamp << " " << thread_id;
        if (level == ERROR_LEVEL)
          s << " [ERROR] ";
        else if (level == WARNING_LEVEL)
          s << " [Warning] ";
        else
          s << " [Note] ";
        s << buffer << std::endl;
        buffered_messages->append(s.str());
      }
      else
      {
        fprintf(stderr, "%s %u [%s] %.*s\n",
                my_timestamp,
                thread_id,
                (level == ERROR_LEVEL ? "ERROR" : level == WARNING_LEVEL ?
                 "Warning" : "Note"),
                (int) length, buffer);
 
        fflush(stderr);
      }
 
      if (error_log_initialized)
        mysql_mutex_unlock(&LOCK_error_log);
      DBUG_VOID_RETURN;
    }

make_iso8601_timestamp 中有代码段如下

参数 opt_log_timestamps 控制时间

 if (opt_log_timestamps == 0)
    gmtime_r(&seconds, &my_tm);
  else
  {   
    localtime_r(&seconds, &my_tm);

opt_log_timestamps 对应 sys_vars.cc 中的 log_timestamps

取值 const char *timestamp_type_names[]= {“UTC”, “SYSTEM”, NullS};

log_timestamps = 0 时，日志中是 UTC 时区

log_timestamps = 1 时，日志中是 SYSTEM 时区

5.7 默认 log_timestamps = 0

5.7 error log 使用系统时区

set global log_timestamps = 1;

  

    

		

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
