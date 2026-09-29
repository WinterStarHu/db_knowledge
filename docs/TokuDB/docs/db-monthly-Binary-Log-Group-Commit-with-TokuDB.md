# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/12/10/
> 分类: TokuDB

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
	

  

    
数据库内核月报 － 2014 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 性能优化 · 5.7 Innodb事务系统
                      

                    

                    

                  
                      

                        MySQL · 踩过的坑 · 5.6 GTID 和存储引擎那会事
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · thread pool 原理分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · 并行复制外建约束问题
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · binlog event有序性
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · server_id为0的Rotate
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · Bulk Load for CREATE INDEX
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·Opened tables block read only
                      

                    

                    

                  
                      

                        MySQL·　优化改进· GTID启动优化
                      

                    

                    

                  
                      

                        TokuDB · TokuDB · Binary Log Group Commit with TokuDB
                      

                    

 
        

    

  

    
 TokuDB · TokuDB · Binary Log Group Commit with TokuDB  

    
 Author:   

  

  

  
MySQL在开启Binary Log的情况下，使用2PC(图1)来保证事务(XA)完整性的，每次提交事务需要做:

1) prepare phase:
记录prepare信息到引擎层的Redo Log，fsync到磁盘
2) commit phase:
A) 记录commit信息到MySQL Server层的Binary Log，fsync到磁盘
B) 记录commit信息到引擎层的Redo Log，fsync到磁盘
每个事务在提交的时候都要做3次fsync以确保日志真正的落盘，这样在log里，一个事务就会有3种状态:

状态1: Redo Log里存在，Binary Log里也存在      –正常情况，crash恢复时需要commit
状态2: Redo Log里存在，Binary Log里不存在      –prepare完毕后发生crash，恢复时需要rollback
状态3: Redo Log里不存在，Binary Log里也不存在   –提交失败，无需处理

这样，无论处于任何一个状态，事务的完整性都不会被破坏，但是每次提交会产生3次fsync，性能非常低。
为了提升性能，MySQL 5.6增加了group commit功能，当多个事务并发提交时，让多个都在等待fsync的事务合并做一次fsync，大大提升了吞吐量。
但是这个优化还需要引擎层的配合，引擎层需要＂一切行动听指挥＂，不要＂任性＂的做fsync，需要对当前THD做HA_IGNORE_DURABILITY判断，代码如下:

static bool tokudb_fsync_on_commit(THD *thd) {
#if MYSQL_VERSION_ID >= 50600
if (thd_get_durability_property(thd) == HA_IGNORE_DURABILITY)
return false;
else
#endif
return THDVAR(thd, commit_sync) != 0;
}

TokuDB 7.5.4版本即将包含这个特性，官方透露，600 tokudb commits/sec只产生120个tokudb fsyncs。

  

    

		

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
