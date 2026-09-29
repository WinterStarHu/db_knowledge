# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/02/10/
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
                      

                    

 
        

    

  

    
 TokuDB · 特性分析· 日志详解  

    
 Author:   

  

  

  
TokuDB的日志跟InnoDB不一样，它有两类文件:

  
redo-log文件(以.tokulog[序号]为扩展名)

  
rollback日志文件(tokudb.rollback)

接下来就简单唠唠这两类文件的内部细节。

1) redo-log

记录的不是页而是对Fractal-Tree索引的操作日志。 log格式:

| length | command | lsn | content | crc|

content里记录的是具体的日志内容，比如insert操作，content就是:

| file-no | txnid | key | value|

TokuDB在做恢复的时候，会找到上次checkpoint时的LSN位置，然后读取log逐条恢复。

为了确保log的安全性，redo-log也支持从后往前解析。

当一个log的MAX_LSN小于已完成checkpoint的LSN时，就表明这个log文件可以安全删除了。

那么问题来了：

如果用户执行了一个“大事务”，比如delete一个大表，耗时很长，log文件岂不是非常多，一直等到事务提交再做清理？

不用的，这就是tokudb.rollback的作用了。

2) tokudb.rollback

用户的事务操作(insert/delete/update写操作)都会写一条日志到tokudb.rollback，存储的格式是:

|txnid | key|

记录日志伪码如下：

void ft_insert(txn,...)
{
if (txn) {
toku_logger_save_rollback_cmdinsert(...);
}

if (do_logging &amp;&amp; logger) {
toku_log_enq_insert(....);
}
}

如果是事务，每个操作会写2条日志(1条redo，1条rollback)。

如果用户执行了commit/rollback，TokuDB会根据txnid在tokudb.rollback里查到key(如果该entry不在cache里)，再根据key在索引文件里找到相应的事务信息并做相应的commit/rollback操作。

tokudb.rollback可以看做是一个事务的undo日志，记录的是的关系映射。

  

    

		

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
