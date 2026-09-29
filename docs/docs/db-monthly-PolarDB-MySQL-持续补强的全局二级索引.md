# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/03/02/
> 分类: 

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
	

  

    
数据库内核月报 － 2023 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB auto_inc 场景性能优化之路
                      

                    

                    

                  
                      

                        PolarDB MySQL · 持续补强的全局二级索引
                      

                    

                    

                  
                      

                        PolarDB for MySQL 优化器查询变换系列 - 条件下推
                      

                    

                    

                  
                      

                        MySQL · 参数故事 · max_prepared_stmt_count
                      

                    

 
        

    

  

    
 PolarDB MySQL · 持续补强的全局二级索引  

    
 Author: zhiyi  

  

  

  
继我们去年年底发布内核原生的全局二级索引（
用户文档
）以来，陆续有客户过来咨询和使用。目前已经有客户在生产实例上大规模使用全局二级索引（Global Secondary Index，下文用GSI代替），大大优化了分区表场景下不含分区键的Query/DML性能以及支持不含分区键的Unique Key能力。阅读我们文章的读者，大部分都是数据库资深使用者和开发人员，应该能体会到这样一个从无到有的功能，在保持MySQL 100%兼容的情况下持续演进，存在大量的工程问题需要解决。因此，在全局二级索引上线之后的这段时间，我们不断补强它的各方面能力，本文将介绍PolarDB内核团队在全局二级索引方面的持续演进工作，并简单总结了目前用户的使用经验。

传统分布式数据库/中间件的平替方案

在需要使用GSI的客户里，我们发现除了本身MySQL分区表的客户以外，有多个客户是从传统的分布式数据库/分布式中间件迁移过来的。这部分客户选择迁移PolarDB MySQL的原因非常清晰：

  

    
分布式数据库的易用性/稳定性问题，MySQL的流行很大原因来自于它的简单易用。虽然很多分布式数据库都是宣称MySQL/PG兼容，但是很多情况下SQL的表现和性能，与MYSQL大相径庭。此外，使用者往往需要修改业务来完成数据库的适配兼容，甚至业务上频繁踩坑后才能有所感知。进一步的，业务往往需要感知数据库分库分表的方式，从而尽可能减少跨机多次交互的开销，这非常考验使用者的学习成本和学习能力；

  

  

    
分布式数据库昂贵的成本问题，为了提升scale-out能力，分布式数据库往往采用Share-Nothing的架构，有专门的计算节点/存储节点/元数据节点等等，存在大量的跨机交互。然而，这种设计并不是free lunch，在达到相同性能的前提下，分布式数据库往往需要消耗更多的硬件资源，导致更高的数据库成本。

  

  

    
PolarDB MySQL强大的计算/存储能力，已经能支撑远超传统MySQL数据处理规模的业务。

    
PolarDB MySQL演进到今天，支持一写多读（最多15个读节点）和多主（最多16个写节点）形态，每个节点最大高达88cores（最新的高性能处理器），存储支持高达100TB的规模（多副本自带修复能力）。在如此规模的计算/存储能力场景下，PolarDB MySQL 100%兼容MySQL，又通过Share-Storage的方式减少了大量的跨机交互成本，在成本、性能、易用性这“不可能三角”之间做到了极致。

    
很多传统分布式数据库的客户，往往对传统MySQL只能处理千万行规模的表、本地盘停留在TB级别（难以备份和还原）的印象非常深刻，但这也是PolarDB MySQL数年来一直在优化的问题。我们发现，很多从传统分布式数据库迁移过来的客户，在测试了PolarDB强大的处理（16*88cores的读写能力）和百TB规模的存储能力，在评估了效率、易用性、成本、满足业务负载等多个因素后，都选择迁移到了PolarDB MySQL。

  

用户迁移到了PolarDB MySQL后，根据业务的负载情况和表结构特征，可以选择单表或者分区表的方式。不管是单表还是分区表，我们都提供和MySQL单表/分区表完全一致的使用方式。PolarDB之前有一系列针对大表场景做优化的文章（
单表/大表优化
），读者可以自行查阅。本文主要侧重PolarDB MySQL在全局二级索引方面的情况，也就是分区表加强方面，读者在阅读之前可以阅读以下文章：
分区表增强
 和 
全局二级索引
，对PolarDB分区表&全局二级索引有更深入的理解。

针对全局二级索引的DDL增强

  

    
并行创建全局二级索引

    
PolarDB早在3年前就已经推出了并行DDL（
链接
）能力。不管是在稳定性还是性能上，PolarDB并行DDL早已经历了大量线上实例的考验和打磨。我们基于PolarDB的并行DDL能力，提供了并行创建GSI的能力。相比于单线程创建GSI，并行创建二级索引最高有15-20倍的性能提升。

  

  

    
Online创建全局二级索引
与局部索引的创建一样，在全局二级索引的创建过程中，我们支持Online的方式，不会阻塞住并发的DML操作。

  

  

    
支持带全局二级索引的表做秒级加字段

    
大量用户反馈加字段是刚性需求，老板本在有全局二级索引的情况下不支持instant add column，新版本将会支持instant add column，即加字段瞬间就能完成。

  

  

    
支持带全局二级索引的表做Interval Add Partition / Partition MDL

    
分区表往往需要根据时间等字段的递增增加分区。带全局二级索引的表，支持interval add partition，并且在增加分区时仅持有新分区的MDL锁，不堵塞其它分区的DML操作。

  

  

    
支持分区老化等场景下异步重构GSI（Work In Progress）

    
PolarDB分区表支持通过分区老化等操作，将一些不再高频访问的分区，存储到冷存储中来降低成本。在老版本中，带GSI的分区表在做分区老化等操作时，需要重建整个GSI，这导致分区老化操作的延迟大大增加。
  为了优化这一操作的体验，我们正在开发异步重构GSI的能力，当分区表做了分区老化等操作时，PolarDB会在后台清理掉这些老化分区的GSI数据，在保证分区老化等操作延迟不变的同时，让用户几乎感知不到GSI的重构操作，目前这一功能还在实现中（WIP）。

  

针对全局二级索引的其它方面增强

  

    
优化器方面增强

    
PolarDB全局二级索引的核心优势在于：用户使用和MySQL分区表完全一致的语义，就可以轻松创建全局二级索引，使用过程中无需感知GSI的存在，后台优化器&执行器&引擎就会自动完成GSI的更新和选择使用。传统MySQL优化器并不感知全局索引的存在，PolarDB内核团队在分区表优化器这块做了非常多工作，即优化器自动根据全局索引和局部索引的统计信息，根据SQL生成最优的执行计划。

  

  

    
支持带全局二级索引的表做库表恢复

    
在部分情况下，用户需要将特定的表恢复到具体的时间点，新版本将会支持带全局索引的表恢复到任意一个时间点。由于恢复出来的表的table id已经发生变化，而全局二级索引上存储了老表的table id作为回表的依据，所以恢复出来的表需要重建GSI。这一块可以通过并行创建全局二级索引来加速。

  

  

    

		

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
