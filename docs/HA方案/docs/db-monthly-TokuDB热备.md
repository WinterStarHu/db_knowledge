# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/09/10/
> 分类: HA方案

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
                      

                    

 
        

    

  

    
 TokuDB · HA方案 · TokuDB热备  

    
 Author:   

  

  

  
TokuDB企业版提供热备功能(与社区版唯一的区别)。

该功能以plugin方式提供，当backup plugin加载后，它会拦截所有的文件操作(比如文件读写／目录操作等)，从而实现在备份的过程中增量同步，具体原理请看:

http://www.tokutek.com/2013/09/tokudb-hot-backup-part-1/

http://www.tokutek.com/2013/09/tokudb-hot-backup-part-2/

社区版如何实现热备呢？

官方推荐的方式是mylvmbackup，不过可能会有一些＂坑＂。

Percona的Vadim同学写过一篇
TokuDB tips
，介绍了Percona在使用mylvmbackup热备TokuDB中遇到的＂坑＂及解决方法：

不能只备份TokuDB自身的数据以及日志文件，还要备份最新的binlog，否则启动的时候可能就＂跪＂了！

还有一个比较geek的方式，直接基于TokuDB自身的机制，轻松的热备出一个备库。

上攻略：

1) SET TOKUDB_CHECKPOINT_LOCK=ON;
2) 开始拷贝TokuDB的数据文件(不包含日志文件)
3) FLUSH TABLES WITH READ LOCK;
4) 记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)
5) UNLOCK TABLES;
6) SET TOKUDB_CHECKPOINT_LOCK=OFF;

＂大杀器＂就是
TOKUDB_CHECKPOINT_LOCK
，它的作用是允许拿到checkpoint锁，此时TokuDB的checkpoint会一直block到该锁释放(执行前要把tokudb_checkpoint_on_flush_logs关掉)，目的是防止拷贝TokuDB数据文件的过程中做sharp checkpoint(注意：由于不做checkpoint，TokuDB的日志文件会逐渐增多)，从而导致数据文件内部不一致(已拷贝的文件被修改)。

整个热备过程中，只有步骤4是阻塞写的，但耗时较短。

  

    

		

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
