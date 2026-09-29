# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/05/07/
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
	

  

    
数据库内核月报 － 2018 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · Community · Congratulations on MySQL 8.0 GA
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · Online DDL 工具 gh-ost 支持阿里云 RDS
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MySQL 8.0 资源组 (Resource Groups)
                      

                    

                    

                  
                      

                        MySQL · 引擎分析 · InnoDB行锁分析
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 神奇的pg_rewind
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 ·  阿里云RDS SQL自动化迁移上云的一种解决方案
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · journal 与 oplog，究竟谁先写入？
                      

                    

                    

                  
                      

                        MySQL · RocksDB · MANIFEST文件介绍
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · change master to
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 阿里云 RDS PostgreSQL 高并发特性 vs 社区版本
                      

                    

 
        

    

  

    
 MongoDB · 引擎特性 · journal 与 oplog，究竟谁先写入？  

    
 Author:   

  

  

  
MongoDB journal 与 oplog，谁先写入？最近经常被人问到，本文主要科普一下 MongoDB 里 oplog 以及 journal 这两个概念。

journal

journal 是 MongoDB 存储引擎层的概念，目前 MongoDB主要支持 mmapv1、wiredtiger、mongorocks 等存储引擎，都支持配置journal。

MongoDB 所有的数据写入、读取最终都是调存储引擎层的接口来存储、读取数据，journal 是存储引擎存储数据时的一种辅助机制。

以wiredtiger 为例，如果不配置 journal，写入 wiredtiger 的数据，并不会立即持久化存储；而是每分钟会做一次全量的checkpoint（
storage.syncPeriodSecs
配置项，默认为1分钟），将所有的数据持久化。如果中间出现宕机，那么数据只能恢复到最近的一次checkpoint，这样最多可能丢掉1分钟的数据。

所以建议「一定要开启journal」，开启 journal 后，每次写入会记录一条操作日志（通过journal可以重新构造出写入的数据）。这样即使出现宕机，启动时 Wiredtiger 会先将数据恢复到最近的一次checkpoint的点，然后重放后续的 journal 操作日志来恢复数据。

MongoDB 里的 journal 行为 主要由2个参数控制，
storage.journal.enabled
 决定是否开启journal，
storage.journal.commitInternalMs
 决定 journal 刷盘的间隔，默认为100ms，用户也可以通过写入时指定 writeConcern 为 {j: ture} 来每次写入时都确保 journal 刷盘。

oplog

oplog 是 MongoDB 主从复制层面的一个概念，通过 oplog 来实现复制集节点间数据同步，客户端将数据写入到 Primary，Primary 写入数据后会记录一条 oplog，Secondary 从 Primary（或其他 Secondary ）拉取 oplog 并重放，来确保复制集里每个节点存储相同的数据。

oplog 在 MongoDB 里是一个普通的 capped collection，对于存储引擎来说，oplog只是一部分普通的数据而已。

MongoDB 的一次写入

MongoDB 复制集里写入一个文档时，需要修改如下数据

  
将文档数据写入对应的集合

  
更新集合的所有索引信息

  
写入一条oplog用于同步

上面3个修改操作，需要确保要么都成功，要么都失败，不能出现部分成功的情况，否则

  
如果数据写入成功，但索引写入失败，那么会出现某个数据，通过全表扫描能读取到，但通过索引就无法读取

  
如果数据、索引都写入成功，但 oplog 写入不成功，那么写入操作就不能正常的同步到备节点，出现主备数据不一致的情况

MongoDB 在写入数据时，会将上述3个操作放到一个 wiredtiger 的事务里，确保「原子性」。

beginTransaction();
writeDataToColleciton();
writeCollectionIndex();
writeOplog();
commitTransaction();

wiredtiger 提交事务时，会将所有修改操作应用，并将上述3个操作写入到一条 journal 操作日志里；后台会周期性的checkpoint，将修改持久化，并移除无用的journal。

从数据布局看，oplog 与 journal 的关系

谁先写入？？

  
oplog 与 journal 是 MongoDB 里不同层次的概念，放在一起比先后本身是不合理的。

  
oplog 在 MongoDB 里是一个普通的集合，所以 oplog 的写入与普通集合的写入并无区别。

  
一次写入，会对应数据、索引，oplog的修改，而这3个修改，会对应一条journal操作日志。

  

    

		

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
