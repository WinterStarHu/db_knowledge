# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/06/
> 分类: 功能改进

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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 MySQL · 功能改进 · InnoDB Warmup特性  

    
 Author:   

  

  

  

提要

相对于纳秒级的内存访问延时，普通的机械盘达到了毫秒级的随机访问延时，对于OLTP应用来说，物理IO绝对是目前数据库管理系统的最大性能杀手，所以增加内存的大小，提高IO的命中率无疑可以作为一种降低时延的常用优化手段。

针对使用InnoDB引擎的MySQL实例来说，增加buffer pool的大小，尽可能的提高buffer pool的命中率，减少物理IO的概率，能极大的提升系统的吞吐量。

但是，随着内存越来越大，面临着一个很严重的问题：当内存突然失效，或者实例异常crash后，面对相同的请求压力，或者突然的大压力，系统由于内存未命中会耗尽IO资源，并导致request响应变慢，形成雪崩效应。

Warmup特性

MySQL 5.6 Innodb提供了warmup的功能，并增加了三个控制参数：

innodb_buffer_pool_dump_at_shutdown
innodb_buffer_pool_filename
innodb_buffer_pool_load_at_startup

工作原理

InnoDB启动一个后台线程，等待一个条件变量：

  

    
当系统shutdown的时候，如果innodb_buffer_pool_dump_at_shutdown=on，系统会notify condition，从buffer pool的LRU链表中，读取spaceid+page_no到innodb_buffer_pool_file文件中，然后正常关闭。

  

  

    
当系统startup的时候，如果innodb_buffer_pool_load_at_startup=on，并且存在innodb_buffer_pool_file，会读取元信息，进行异步IO读取数据加载到buffer pool中。

  

  

    
为了防止系统运行过久，innodb_buffer_pool_file过时，无法反映当前热点数据的情况，InnoDB又提供了一个innodb_buffer_pool_dump_now参数，set后会即时进行一次dump，覆盖掉老的文件。

  

那么问题来了

  

    
Warmup是否影响startup的速度：

    
不影响.启动的时候，读取innodb_buffer_pool_file, 排序后，进行异步IO，不影响startup的速度。但现实的情况是：如果你是在业务高峰期出现crash，其实对于系统来说，先warmup后，再开放提供服务，更合适。

  

  

    
异常crash的时候，使用过时的元数据：

    
如果异常crash，那么就存在过时的innodb_buffer_pool_file，如果想避免这种情况，系统可以每隔一段时间，进行一次dump。

  

  

    
dump是否导致系统抖动

    
dump的过程，会持有mutex，扫描LRU链表，读取元数据，如果在系统业务高峰期，可能会产生抖动。
改进

  

MySQL 5.7 又增强了warmup功能的使用：

  

    
新增参数innodb_buffer_pool_dump_pct

    
当前InnoDB的buffer pool可能设置的比较大，可以通过设置dump的比例，控制dump的速度和load时的量。

  

  

    
innodb_io_capacity

    
控制load过程中，防止过量使用IO资源，如果单机多实例的情况下，同时启动实例，会使IO过载。

  

  

    

		

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
