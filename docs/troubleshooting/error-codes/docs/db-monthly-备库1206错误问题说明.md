# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/07/10/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2016 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 特性分析 ·MySQL 5.7新特性系列三
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.7 代价模型浅析
                      

                    

                    

                  
                      

                        PgSQL · 实战经验 · 分组TOP性能提升44倍
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 网络通信模块浅析
                      

                    

                    

                  
                      

                        MongoDB · 特性分析 · 索引原理
                      

                    

                    

                  
                      

                        SQLServer · 特性分析 · XML与JSON应用比较
                      

                    

                    

                  
                      

                        MySQL · 最佳实战 · 审计日志实用案例分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · 条件下推到物化表
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · Query Cache内部剖析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 备库1206错误问题说明
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态 · 备库1206错误问题说明  

    
 Author: dingqi.lxb  

  

  

  
问题背景

一个用户自建MySQL，出现备库复制中断的问题，报错为slave sql thread 错误，The total number of locks exceeds the lock table size。

报错代码

这个报错在代码中的抛错逻辑为：

if
 
UT_LIST_GET_LEN

(

buf_pool

->

free

)
 
+
 
UT_LIST_GET_LEN

(

buf_pool

->

LRU

)
 
<
 
buf_pool

->

curr_size
 
/
 
4

文字解释是：如果buffer pool中的空闲页面和LRU页面总和少于buffer pool 大小的1/4，则认为内存不够用，报错。

那么问题来了

  

    

buffer pool 哪里去了

  buffer pool是InnoDB内部管理内存的统一结构。默认每个page 16k。初始化后，每个page都是空闲状态，放在free中。
  当读取数据等需要用到页面数据的操作时，将数据从磁盘读取到内存中，用的就是buffer pool的page。为了支持淘汰机制，InnoDB内部维护了一个淘汰链表，就是LRU list。装了数据的page被从free list移到LRU list。
  但是，除了正常的读取数据，还有其他的逻辑需要从buffer pool中“抢”资源。比如本例中是因为undo page。
  事务越大，需要的undo page越多，在整个事务未提交前，undo page是必须强占内存的。这就可能导致一种情况：事务过大，导致buffer pool全部被用光，无法提供正常服务。
  因此InnoDB有了上面的保护机制。触发这个上限后报错后，事务会回滚，释放undo page。

  

  

为什么主库执行成功备库失败了

  从上面的分析和代码中可以看到，判断内存是否占用过多，设置的上限是buffer_pool size的1/4. 
  另外，5.6以后支持了设置多个 innodb_buffer_pool_instances，也就是分成多个pool， 在现在的逻辑中，认为只要“任意一个pool满足上述超过1/4的条件”，都判定为内存消耗过限。
  因此主要排查参数：
    

      
备库的 innodb_buffer_pool_size 是否小于主库值

      
若主备的innodb_buffer_pool_size值相同，备库的 innodb_buffer_pool_instances 值是否更大。

    

  

  

作为验证

  DBA在发现备库apply error的时候第一步往往是用 mysqlbinlog 工具去看导致错误的event是什么。这时候会发现其实是一个批量的load数据，或者update/delete大事务导致。

小结

  
buffer pool不仅用于缓存page，会有其他数据结构争抢；

  
主备的参数尽量保持一致；

  
尽量避免超大事务，即使不考虑备库apply error。这种超大事务在主库执行，由于undo page占用buffer pool，可能会导致buffer pool命中率突然下降，影响业务。

  

    

		

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
