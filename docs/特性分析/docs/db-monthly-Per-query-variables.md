# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/02/09/
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
	

  

    
数据库内核月报 － 2015 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 性能优化· InnoDB buffer pool flush策略漫谈
                      

                    

                    

                  
                      

                        MySQL · 社区动态· 5.6.23 InnoDB相关Bugfix
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Replication Slot
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· pg_prewarm
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· InnoDB丢失自增值
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· 5.5 和 5.6 时间类型兼容问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· 变量修改导致binlog错误
                      

                    

                    

                  
                      

                        MariaDB · 特性分析· 表/表空间加密
                      

                    

                    

                  
                      

                        MariaDB · 特性分析· Per-query variables
                      

                    

                    

                  
                      

                        TokuDB · 特性分析· 日志详解
                      

                    

 
        

    

  

    
 MariaDB · 特性分析· Per-query variables  

    
 Author:   

  

  

  
自MariaDB 10.1.2起，MariaDB提供了一种"Per-query variables的方式来为Query设置语句级变量，通过 SET STATEMENT 语句可以为接下来要执行的语句设置一些系统变量值。

语法

SET STATEMENT var1=value1 [, var2=value2, …] FOR

varN是一个系统变量，valueN是一个常量值。但是有部分变量是不支持的，在这个章节的末尾列出了所有不支持的变量。

一条 "SET STATEMENT var1=value1 FOR stmt" 语句等价与如下一系列操作：

SET @save_value=@@var1;

SET SESSION var1=value1;

stmt;

SET SESSION var1=@save_value;

MySQL服务器在执行整条语句前会先做解析，所以所有影响解析器的变量都无法达到预期的效果，因为解析完之后才能获得这些变量的值。例如字符集变量sql_mode=ansi_quotes。

一些使用特性的例子

可以限制语句的执行时间 max_statement_time: SET STATEMENT max_statement_time=1000 FOR SELECT … ;

为一个语句临时改变优化器的规则: SET STATEMENT optimizer_switch='materialization=off' FOR SELECT ….;

为一个语句单独打开MRR/BKA特性: SET STATEMENT join_cache_level=6, optimizer_switch='mrr=on' FOR SELECT …

下面这些变量无法使用Per-query variables特性来设置

autocommit

character_set_client

character_set_connection

character_set_filesystem

collation_connection

default_master_connection

debug_sync

interactive_timeout

gtid_domain_id

last_insert_id

log_slow_filter

log_slow_rate_limit

log_slow_verbosity

long_query_time

min_examined_row_limit

profiling

profiling_history_size

query_cache_type

rand_seed1

rand_seed2

skip_replication

slow_query_log

sql_log_off

tx_isolation

wait_timeout

  

    

		

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
