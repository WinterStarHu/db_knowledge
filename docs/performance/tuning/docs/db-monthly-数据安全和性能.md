# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/09/09/
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
                      

                    

 
        

    

  

    
 TokuDB · 参数故事 · 数据安全和性能  

    
 Author:   

  

  

  
TokuDB里可调优的参数不多，今天把＂最重要＂的几个拉出来晒晒。

与性能相关的参数及说明:

tokudb_cache_size(bytes):
缓存大小，读写时候，数据会首先会缓存到这里。
默认大小为机器物理内存的一半。
tokudb_commit_sync(ON/OFF):
当事务提交的时候，是否要fsync log到磁盘。
默认开启(ON)，如果设置为OFF，性能会提升，但可能会丢失事务(commit记录到log buffer，但是未fsync到磁盘的事务)。
tokudb_directio(ON/OFF):
是否开启Direct I/O功能，TokuDB在写盘的时候，无论是否开启Direct I/O，都是按照512字节对齐的。
默认为OFF。
tokudb_fsync_log_period(ms):
多久fsync一下log buffer到磁盘，TokuDB的log buffer总大小为32MB且不可更改。
默认为0ms(此时做fsync的后台线程一直处于wait状态)，此时受tokudb_commit_sync开关控制是否要fsync log到磁盘(checkpoint也会fsync log buffer的，默认为1分钟)。

针对不同的使用场景：

1) 对数据要求较高(不允许丢失数据，事务ACID完整性)，只需根据内存调整tokudb_cache_size大小即可，建议开启tokudb_directio。

2) 对数据要求不太高(允许部分数据丢失，不要求事务ACID完整性)，可配置:

tokudb_commit_sync=OFF
tokudb_fsync_log_period=1000 #1s

在此配置下，每1秒对log buffer做下fsync，可充分利用log的group commit功能，如果TokuDB挂掉，则可能会丢失最多1秒的数据。

  

    

		

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
