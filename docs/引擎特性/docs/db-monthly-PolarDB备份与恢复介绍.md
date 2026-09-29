# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/07/02/
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
	

  

    
数据库内核月报 － 2022 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 行业洞察 · 为什么游戏行业喜欢用PolarDB
                      

                    

                    

                  
                      

                        POLARDB · 引擎特性 · PolarDB备份与恢复介绍
                      

                    

                    

                  
                      

                        PolarDB Serverless之路 · 无感秒切
                      

                    

                    

                  
                      

                        PostgreSQL · 插件特性 · FDW 异步执行特性
                      

                    

 
        

    

  

    
 POLARDB · 引擎特性 · PolarDB备份与恢复介绍  

    
 Author:   

  

  

  
用户在使用数据库产品时可能会遇到一些情况，需要将数据还原到特定的时间点。PolarDB作为一款业界领先的企业级数据库产品，拥有强大的备份恢复能力，赋予用户通过指定时间点来查询历史数据状态或者还原历史状态的能力。主要包括以下几部分组成：实例级别的备份与恢复、库表备份与恢复、表回收站以及Flashback query等。 
下面我们首先介绍下用户在哪些情况下需要备份恢复及选择哪些备份恢复方法更为合适，然后介绍PolarDB几种备份恢复功能实现的原理。

场景及方案选择

问题场景不同，备份恢复方案的选择也不同，这主要是不同的备份恢复方案所消耗的时间RTO也会有很大不同，在进行数据紧急恢复的时候，RTO起着至关重要的作用，时间节省一分钟，意味着业务恢复的时间就提前一分钟，可以最大程序的减小业务损失。
备份恢复有实例级别备份与恢复，数据的备份恢复是整个实例级别；库表级别备份与恢复，备份同整实例相同，恢复时只恢复特定库表；表回收站是删除表时，不立即删除，将表及表中数据移动到一个回收站的地方，恢复时rename回来；闪回查询保存数据的delta历史版本，通过MVCC回查。几种方案的原理后面会详细介绍，此处先不展开。下面表格整理了下，不同场景选择的备份恢复方案，及对应时间开销：

实例级别备份与恢复

PolarDB支持数据备份和物理日志备份。数据备份即将某个时间点上集群的全量数据生成一个备份集（快照）；物理日志备份即记录生成备份集后的增量数据。通过一个完整的数据备份以及后续一段时间的Redo日志备份，就可以将整个PolarDB实例恢复到任意时间点。

实例备份

数据备份

数据备份按照存储位置可分为一级备份和二级备份。

一级备份

一级备份采用ROW（Redirect-on-Write）快照的方式，直接保存在PolarDB分布式存储系统上。每次保存时，一级备份并没有真正复制数据，当数据块有修改时系统会将其中一个历史版本的数据块保留给快照，同时生成新的数据块被原数据引用（Redirect）。因此无论数据库容量多少，都可以做到秒级备份。一级备份保留时长为3～14天。

二级备份

二级备份是指一级备份压缩后保存在其它离线存储介质上的备份数据。保存成本较低，但使用二级备份恢复数据的速度较慢。开启二级备份后，若一级备份超出您设置的保留时间，将会被自动转存为二级备份，转存速度约为150 MB/秒。二级备份支持同地域备份和跨地域备份。二级备份保留时长为30～7300天。

物理日志备份

日志备份通过实时并行上传Redo日志到OSS来达到备份的目的。日志备份方式包括同地域备份和跨地域备份，最短保留时间为3天，最长保留时间为7300天。

实例恢复

实例恢复是指将PolarDB全量历史数据恢复至一个新的实例集群，验证新集群数据后，可以再将恢复后的数据迁移至原集群。实例恢复支持从备份集恢复和恢复到过去时间点两种恢复方式。

备份集恢复

实例备份集恢复是选择其中一个全量数据的快照来恢复，相对于按时间点恢复，不需要拉取及应用增量的redo，恢复的速度更快，但只能恢复备份集对应时间点的数据。

按时间点恢复

按时间点恢复实例是指：通过一个完整的数据全量备份（快照）以及后续一段时间的日志备份，将PolarDB集群恢复到任意时间点（Point-In-Time Recovery，简称PITR），保证最近一段时间的数据安全性，避免误操作导致的数据丢失。恢复到任意时间点时，应用Redo日志的恢复速度大概是20~70秒/GB，整个恢复时间是备份集（快照）恢复时间以及应用Redo日志恢复时间之和。

库表备份与恢复

库表恢复是指仅恢复指定的部分库或部分表到原集群，而不是恢复整个实例。例如游戏业务中有时仅需恢复某个或某些玩家的数据，此时可使用库表恢复方式。PolarDB 5.6、5.8及8.0均支持表粒度的恢复数据。

库表备份

库表的备份和实例级别的备份是一样的，前面已经介绍过，这里不再展开介绍。

库表恢复

库表恢复和实例级别恢复的区别时，再选取数据集时只使用相应库表的数据，恢复redo数据时，只恢复相应库表及一些元信息的redo日志。相对整个实例的恢复，恢复选择更灵活，恢复时间更短。

表回收站

由于DDL语句无法回滚，如果误删除了表（例如DROP TABLE），可能会导致数据丢失。PolarDB提供了表回收站的功能，删除的表会被临时转移到表回收站，因此您可以从表回收站恢复误删的表。

表回收站使用

表回收站不仅保留被删除表的表结构，而且表中的数据也被保留。恢复时不仅可以恢复到原db原table，还可以指定新db和新table来做恢复。
在PolarDB MySQL引擎8.0版本，且内核小版本为8.0.1.1.2及以上时，支持表回收站功能。

参数及操作

参数介绍

recycle_bin : ON为打开回收站，OFF为关闭
recycle_bin_retention : 误删表的时间点在表回收站内数据的最长保留周期，取值1～365
24
3600单位秒，默认一周

打开关闭表回收站

set session recycle_bin=ON;
set session recycle_bin=OFF;

查看回收站临时保存表

CALL DBMS_RECYCLE.show_tables()
恢复表(如果后面两个参数省略，则恢复到原db和table)
CALL DBMS_RECYCLE.restore_table(‘RECYCLE_TABLE’,’DEST_DB’,’DEST_TABLE’);

举例参考

可参考PolarDB官方文档https://www.alibabacloud.com/help/zh/polardb-for-mysql/latest/restore-a-table-from-recycle-bin

表回收站原理

表回收站的实现本质上是使用表rename操作，将表移动到__recycle_bin__库下面进行管理（记录、恢复或者删除）。在打开表回收站功能时，创建了库“
recycle_bin
”，如果有drop table或者drop database的操作就不再是直接删除，将表移动到__recycle_bin__库下面，并为该表命名一个新的名字__innodb_XXX。被删除的表在移动到__recycle_bin__库时，会记录下ORIGIN_SCHEMA(原库名)、ORIGIN_TABLE(原表名)、RECYCLED_TIME (伪删除表时间)、PURGE_TIME(实际删除时间)等信息，用来做表恢复或者表数据的彻底删除。表恢复就是将表再做一次rename操作。

Flashback query

PolarDB的闪回查询（Flashback Query）功能，提供高效地，在当前实例，对历史某个时间点数据查询的能力。通过innodb_backquery_enable参数打开Flashback Query功能，并通过innodb_backquery_window设置需要回查的时间范围。之后，对数据库的查询操作都可以通过AS OF TIMESTAMP关键字来指定需要查看数据的历史时间点。通过闪回查询我们我们可以方便的查询之前几秒，几个小时甚至几天的数据。

闪回查询使用

PolarDB的闪回查询当前已在5.6、5.7及8.0发布上线。具体信息见文档https://www.alibabacloud.com/help/zh/polardb-for-mysql/latest/flashback-query

参数及操作

参数介绍

innodb_backquery_enable : ON为打开闪回查询，OFF为关闭
innodb_backquery_window	: 闪回查询时间窗口，1～30
24
3600单位秒，默认一天

操作

打开关闭闪回查询
set global innodb_backquery_enable=ON;
set global innodb_backquery_enable=OFF;
闪回查询语句
select * from table_name AS OF TIMESTAMP ‘2022-06-26 13:25:00’;

举例参考

闪回查询实现原理

PolarDB的闪回查询（Flashback Query）功能，实现是基于Innodb的多版本并发控制机制，即结合ReadView和Undo来查询当前事务可见的历史版本，Undo来构建历史版本，ReadView决定应该选择的具体版本。
由于PolarDB的闪回查询功能支持以及秒级粒度（即查询的数据时间差在1秒内）的数天甚至更久的回查，所以这里面要解决两个问题：1.如何做到秒级粒度的查询；2.如何支持数天甚至更久的历史数据回查。
针对秒级粒度回查这个问题，PolarDB内部会每隔1秒钟将当前的ReadView及对应的时间戳保存到一个系统表里面，在进行闪回查询时，我们根据语法解析出要查询的时间点，并从系统表中查到该时间点对应的ReadView，将该ReadView替换为trx的ReadView，并将trx旧的ReadView暂时保存，当该句闪回查询结束时，再将旧的ReadView替换回去。闪回查询从语法角度看是语句级别的，可以在一个事务内指定不同的时间进行闪回查询。
针对要支持数天甚至更久的历史数据回查，这就需要Undo保留足够久的数据，即数据不能更早的purge掉，我们在这里用闪回查询存ReadView的系统表中最老的ReadView来做Undo的purge view，这样Undo保留的时间就有闪回查询系统表最老的Readview来做限制，进而可以支持数天甚至更久的闪回查询。
整体上来说就是：开启闪回查询功能后，每隔1秒钟，会记录一个当前的ReadView及时间戳到闪回查询系统表，系统表中ReadView保留的时间有参数innodb_backquery_window来进行控制，超过的会自动清理掉，每隔一秒钟会用该系统表中最老的ReadView更新purge view。在backquery查询进来时，解析出对应时间戳后，从该系统表查到对应的ReadView，替换trx的ReadView，使用Innodb的MVCC机制查询历史数据，查询语句结束时将ReadView再替换回来。具体流程可参考下图：

后续演进

PolarDB当前已经有一套健全的备份恢复机制，来满足用户各种场景的需求，后面会沿着两个方向继续完善这套机制：1.现有方案继续完善，提供更快更准确的备份恢复能力；2.完善FlashBack体系，使得拥有更强大的在线回溯能力。

  

    

		

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
