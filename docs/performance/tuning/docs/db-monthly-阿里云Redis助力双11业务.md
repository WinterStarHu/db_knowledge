# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/12/09/
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
	

  

    
数据库内核月报 － 2016 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Infobright 列存数据库
                      

                    

                    

                  
                      

                        MySQL · myrocks · myrocks统计信息
                      

                    

                    

                  
                      

                        SQL Server · 特性介绍 · 统计信息
                      

                    

                    

                  
                      

                        PgSQL · 案例分享 · 从春运抢火车票思考数据库设计
                      

                    

                    

                  
                      

                        HybridDB · 最佳实践 · OLAP和OLTP一体化打造
                      

                    

                    

                  
                      

                        TokuDB · 特性分析 · 导入数据大杀器：Loader
                      

                    

                    

                  
                      

                        PgSQL · 案例分享 · PostgreSQL 性能诊断指南
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 5.6中ORDER BY + LIMIT 错选执行计划
                      

                    

                    

                  
                      

                        Redis · 最佳实践 · 阿里云Redis助力双11业务
                      

                    

                    

                  
                      

                        PgSQL · 案例分享 · 递归收敛优化
                      

                    

 
        

    

  

    
 Redis · 最佳实践 · 阿里云Redis助力双11业务  

    
 Author: minghang.zmh  

  

  

  
双11如火如荼的结束了，阿里云Redis(ApsaraDB for Redis原KVStore)也圆满完成了双11Redis的保障工作。目前阿里云Redis提供了单机版本和集群版本的Redis。

  
单机版本Redis具有很高的兼容性，并且支持Lua脚本及地理位置计算。

  
集群版本具有大容量、高性能的特性，能够突破Redis单线程的单机性能极限。

阿里云Redis默认双机热备并提供了备份恢复支持，同时阿里云Redis源码团队持续对Redis进行优化升级，提供了强大的安全防护能力。本文将选取双11的一些业务场景简化之后进行介绍，实际业务场景会比本文复杂。

微淘社区之亿级关系链存储

微淘社区承载了亿级淘宝用户的社交关系链，对于每个用户都有自己的关注列表，每个商家有自己的粉丝信息，整个微淘社区承载的关系链如下图所示。

如果选用传统的关系型数据库模型表达如上的关系信息，会使业务设计繁杂，并且不能获得良好的性能体验。微淘社区使用Redis集群缓存了存储社区的关注链，简化了关注信息的存储，并保证了双11业务丝滑一般的体验。微淘社区使用了Hashes存储用户之间的关注信息，存储结构如下，并提供了以下两种的查询接口：

  
用户A 是否和 用户B产生过关注关系；

  
用户A的主动关系列表；

天猫直播之评论商品游标分页

双11用户在观看无线端直播的时候，需要对直播对应的评论进行刷新动作，主要有以下三种模式:

  
增量下拉。 也即是从指定位置向上获取指定个数（增量）的评论。

  
下拉刷新。 也即是获取最新的指定个数的评论。

  
增量上拉。 也即是从指定位置向下获取指定个数（增量）的评论。

无线直播系统使用Redis优化该场景的业务，保证了直播评论接口的成功率，并能够保证5w+以上的tps和毫秒级的rt请求。直播系统对于每个直播会写入两份数据，分别为索引和评论数据，索引数据为SortedSet的数据结构用于对评论的排序，而评论数据使用Hashes进行存储，在获取评论的时候通过索引拿到需要的索引id之后通过Hashes的读取来获得评论的列表。评论的写入过程如下：

用户在刷新列表之后后台需要获取对应的评论信息，获取的流程如下：

  
获取当前索引位置

  
获取索引列表

  
获取评论数据

菜鸟单据履行中心之订单排序

双11用户在产生一个交易订单之后会随之产生一个物流订单。经过菜鸟仓配系统处理的订单，为了让仓配各个阶段能够更加智能的协同作业，决策系统会根据订单信息指定出对应的订单履行计划，包括什么时候下发仓、什么时候出库、什么时候配送揽收、什么 时候送达等信息，单据履行中心根据履行计划，对每个阶段按照对应的时间去履行物流服务。由于仓、配的运力有限，对于有限的运力下，期望最早作业的单据是业务认为优先级最高的单据，所以订单在真正下发给仓或者配之前，需要按照优先级进行排序。

订单履行中心通过使用Redis来对所有的物流订单进行排序决定哪个订单是最高优先级的。

结束

Redis是一个优秀的开源数据库，提供了开发者更便利的数据模型，阿里云Redis致力于提供稳定、高性能的Redis服务，欢迎广大开发者使用
阿里云Redis
服务。

  

    

		

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
