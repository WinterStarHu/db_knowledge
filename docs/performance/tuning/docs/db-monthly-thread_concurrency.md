# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/09/05/
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
	

  

    
数据库内核月报 － 2014 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 捉虫动态 · GTID 和 DELAYED
                      

                    

                    

                  
                      

                        MySQL · 限制改进 · GTID和升级
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID 和 binlog_checksum
                      

                    

                    

                  
                      

                        MySQL · 引擎差异·create_time in status
                      

                    

                    

                  
                      

                        MySQL · 参数故事 · thread_concurrency
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · auto_increment
                      

                    

                    

                  
                      

                        MariaDB · 性能优化 · Extended Keys
                      

                    

                    

                  
                      

                        MariaDB · 主备复制 · CREATE OR REPLACE
                      

                    

                    

                  
                      

                        TokuDB · 参数故事 · 数据安全和性能
                      

                    

                    

                  
                      

                        TokuDB · HA方案 · TokuDB热备
                      

                    

 
        

    

  

    
 MySQL · 参数故事 · thread_concurrency  

    
 Author:   

  

  

  

提要

　　thread_concurrency参数用于向操作系统建议期望的并发线程数，参数在mysqld启动的时候使用。但MySQL 5.6 从源码中删除了这个参数，不再使用。

参数背景

　　源码：

#ifndef HAVE_THR_SETCONCURRENCY
#define thr_setconcurrency(A) pthread_dummy(0)
#endif

mysqld_main
{
(void) thr_setconcurrency(concurrency);	// 10 by default
......
}

　　可以看到thread_concurrency的限制：

  
thread_concurrency不能用在GNU/Linux平台上，而只能在old Solaris versions < 9才能work。

  
OS层面只提供了hint建议，并不能提供足够的信息，控制和诊断都不够灵活。

  
OS无法获得MySQL层面提供的所有线程的状态，包括语句的执行，阻塞，当前事务状态等信息，所以OS终究不能根据事务型软件系统量身定制并发控制。
　　
     一句话，OS层面无法把并发控制做精细，所以放弃使用。

　　那么并发控制究竟在什么地方进行控制最好，控制为多少合适呢?

并发控制

　　并发控制点：

并发控制的目的是最大化提高系统的资源利用率，并减少管理和调度开销。在MySQL实例中，主要处理sql请求，所以期望系统资源最大化提供给sql的执行过程。
　　sql的执行牵涉到server层和引擎层：

  
server层：比如cost计算，生成sql执行计划的过程

  

    
Innodb层：比如根据执行计划，查找和更新数据page的过程
　　所以在MySQL实例中，有两个最佳的并发控制点：

  

  
server层：sql开始执行时。 MySQL在5.6后，在server层引入了thread pool进行并发控制

  
Innodb层：记录查找和记录更新时。 Innodb存储引擎，使用innodb_thread_concurrency参数进行并发控制

　　并发控制大小：

设置过大：造成系统调度消耗过大
设置过小：不能完全的使用系统资源，造成资源浪费
　　经验值：# Try number of CPU’s*2 for thread_concurrency

　　但还需要配合具体的平台和业务系统进行测试，才能找到最佳值。

Innodb并发控制

　　Innodb使用参数innodb_thread_concurrency控制并发线程的个数，源码中使用一对函数：

innodb_srv_conc_enter_innodb
innodb_srv_conc_exit_innodb
　　Innodb实现语句级的并发控制，在语句执行结束，stmt commit的时候，强制释放资源。

权衡和优化

  
一方面进行并发控制，提高资源利用率，

  
另一方还需要控制调度公平，防饿死等。
　　Innodb引入了n_tickets_to_enter_innodb参数，sql进入innodb执行时进行初始化，默认值500。

　　在执行过程中，依次进行递减，递减到0时，强制退出并发线程，重新抢占。

　　好处：

  
一方面单条sql可能写入或者更新多条记录，节省每次enter innodb的线程抢占代价。

  
另一方面防止单条sql过多的长时间占用并发线程，导致其它线程饿死的情况。

  

    

		

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
