# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/12/05/
> 分类: 答疑释惑

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
                      

                    

 
        

    

  

    
 MySQL · 答疑释惑 · binlog event有序性  

    
 Author:   

  

  

  

背景

对于解析MySQL的binlog用来更新其他数据存储的应用来说，binlog的顺序标识是很重要的。比如根据时间戳得到binlog位点作为解析起点。

但是binlog里面的事件，是否有稳定的有序性？

binlog中有三个看上去可能有序的信息：xid、timestamp、gno。本文分析这三个信息在binlog中的有序性。

Xid

当binlog格式为row，且事务中更新的是事务引擎时，每个事务的结束位置都有Xid，Xid的类型为整型。

MySQL中每个语句都会被分配一个全局递增的query_id(重启会被重置)，每个事务的Xid来源于事务第一个语句的query_id。

考虑一个简单的操作顺序：

session 1: begin; select; update;

session 2: begin; select; update; insert; commit;

session 1: insert; commit;

显然Xid2 > Xid1，但因为事务2会先于事务1记录写binlog，因此在这个binlog中，会出现Xid不是有序的情况。

TIMESTAMP

时间戳的有序性可能是被误用最多的。在mysqlbinlog这个工具的输出结果中，每个事务起始有会输出一个SET TIMESTAMP=n。这个值取自第一个更新事件的时间。上一节的例子中,timestamp2>timestamp1,但因为事务2会先于事务1记录写binlog，因此在这个binlog中，会出现TIMESTAMP不是有序的情况。

GNO

对于打开了gtid_mode的实例，每个事务起始位置都会有一个gtid event，其内容输出格式为UUID:gn，gno是一个整型数。

由于NEXT_GTID是可以直接指定的，因此若故意构造，可以很容易得到不是递增的情况，这里只讨论automatic模式下的有序性。

与上述两种情况不同，gno生成于事务提交时写binlog的时候。注意这里不是生成binlog，而是将binlog写入磁盘的时候。因此实现上确保了同一个UUID下gno的有序性。

小结

一个binlog文件中的Xid和TIMESTAMP无法保证有序性。在无特殊操作的情况下，相同的UUID可以保证gno的有序性。

  

    

		

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
