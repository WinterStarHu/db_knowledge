# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/06/05/
> 分类: 引擎特性

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
	

  

    
数据库内核月报 － 2018 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 特性分析 · 8.0 对WAL的设计修改
                      

                    

                    

                  
                      

                        MariaDB · 特性分析 · 基于GTID的复制分析
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 难以置信，MySQL也可以无损自由切换
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 8.0 WriteSet 并行复制
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · writeConcern原理解析
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 ·  RDS SDK实现数据库迁移上阿里云RDS SQL Server
                      

                    

                    

                  
                      

                        PgSQL · 内核特性 · RDS PostgreSQL 高并发场景下提高系统吞吐量
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgresPro buildin pool原理分析与测试
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Column Family介绍
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL + PostGIS 时态分析
                      

                    

 
        

    

  

    
 MongoDB · 引擎特性 · writeConcern原理解析  

    
 Author: linqing  

  

  

  
MongoDB支持客户端灵活配置写入策略（
writeConcern
），以满足不同场景的需求。

db.collection.insert({x: 1}, {writeConcern: {w: 1}})

writeConcern选项

MongoDB支持的WriteConncern选项如下

  
w: <number>，数据写入到number个节点才向用客户端确认
    

      
{w: 0} 对客户端的写入不需要发送任何确认，适用于性能要求高，但不关注正确性的场景

      
{w: 1} 默认的writeConcern，数据写入到Primary就向客户端发送确认

      
{w: “majority”} 数据写入到副本集大多数成员后向客户端发送确认，适用于对数据安全性要求比较高的场景，该选项会降低写入性能

    

  

  
j: <boolean> ，写入操作的journal持久化后才向客户端确认
    

      
默认为”{j: false}，如果要求Primary写入持久化了才向客户端确认，则指定该选项为true

    

  

  
wtimeout: <millseconds>，写入超时时间，仅w的值大于1时有效。
    

      
当指定{w: 
}时，数据需要成功写入number个节点才算成功，如果写入过程中有节点故障，可能导致这个条件一直不能满足，从而一直不能向客户端发送确认结果，针对这种情况，客户端可设置wtimeout选项来指定超时时间，当写入过程持续超过该时间仍未结束，则认为写入失败。

    

  

{w: “majority”}解析

{w: 1}、{j: true}等writeConcern选项很好理解，Primary等待条件满足发送确认；但{w: “majority”}则相对复杂些，需要确认数据成功写入到大多数节点才算成功，而MongoDB的复制是通过Secondary不断拉取oplog并重放来实现的，并不是Primary主动将写入同步给Secondary，那么Primary是如何确认数据已成功写入到大多数节点的？

  
Client向Primary发起请求，指定writeConcern为{w: “majority”}，Primary收到请求，本地写入并记录写请求到oplog，然后等待大多数节点都同步了这条/批oplog（Secondary应用完oplog会向主报告最新进度)。

  
Secondary拉取到Primary上新写入的oplog，本地重放并记录oplog。为了让Secondary能在第一时间内拉取到主上的oplog，find命令支持一个
awaitData的选项
，当find没有任何符合条件的文档时，并不立即返回，而是等待最多maxTimeMS(默认为2s)时间看是否有新的符合条件的数据，如果有就返回；所以当新写入oplog时，备立马能获取到新的oplog。

  
Secondary上有单独的线程，当oplog的最新时间戳发生更新时，就会向Primary发送replSetUpdatePosition命令更新自己的oplog时间戳。

  
当Primary发现有足够多的节点oplog时间戳已经满足条件了，向客户端发送确认。

参考资料

  

MongoDB云数据库

  

find command

  

writeConcern

  

    

		

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
