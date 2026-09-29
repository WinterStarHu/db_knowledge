# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/03/10/
> 分类: 引擎机制

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
	

  

    
数据库内核月报 － 2015 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 答疑释惑· 并发Replace into导致的死锁分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 5.7.6 InnoDB page flush 优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· pid file丢失问题分析
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· using filesort VS using temporary
                      

                    

                    

                  
                      

                        MySQL · 优化限制· MySQL index_condition_pushdown
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· lower_case_table_names 使用问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Logical Decoding探索
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· jsonb类型解析
                      

                    

                    

                  
                      

                        TokuDB ·引擎机制· TokuDB线程池
                      

                    

 
        

    

  

    
 TokuDB ·引擎机制· TokuDB线程池  

    
 Author:   

  

  

  
这次还是以介绍TokuDB内部机制为主, 本篇来谈谈TokuDB内部的线程池模型。

TokuDB内部有一个线程池实现kibbutz， 代码: 
https://github.com/Tokutek/ft-index/blob/master/util/kibbutz.cc

其调度思想基于
work-stealing
， 代码也很简洁， 大体思路就是：维护一个任务队列， 空闲线程自己去这个队列领取任务。

kibbutz中文为“基布兹”,是以色列的一个集体社区，感兴趣的
戳这里
。

TokuDB内部线程池按功能可以分为以下3大块：

节点“饱和”apply线程池

当一个节点“饱和”的时候，TokuDB需要把节点message buffer中的数据apply到子节点(这个行为是由TokuDB的特殊索引结构决定)。

这个线程池的作用是实现并发apply“饱和”节点，线程数目为物理CPU的个数。

缓存专用线程池

这个线程池专门为缓存服务，包括两大块:

a) 节点预读线程，比如做区间查找的时候，在某些条件下会触发子节点预读，提前在后台线程把节点读取到缓存。

b) LRU剔除线程，当缓存大小到达高水位的时候，后台线程把LRU尾端的脏节点刷到磁盘，并从LRU中清除。

这个池子里的线程数目较多，干的活也比较重，线程数目为物理CPU数*2。

checkpoint克隆线程池

这个线程池比较特殊。

做checkpoint的时候，如果一个节点处于“pin”状态，并且它是可克隆的，就使用后台线程把它的数据克隆出来并刷到磁盘，这样checkpoint可以继续进行下去(如果此节点不可克隆，checkpoint线程会一直等到这个pin状态结束）。

这个线程数为物理CPU数/4（如果CPU > 4)。

好的线程池设计+好的任务调度算法，应该是一个引擎高效的最基本条件，让任务尽量并行起来。

  

    

		

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
