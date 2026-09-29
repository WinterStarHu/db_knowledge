# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/11/08/
> 分类: 版本优化

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
	

  

    
数据库内核月报 － 2014 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 捉虫动态 · OPTIMIZE 不存在的表
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · SIGHUP 导致 binlog 写错
                      

                    

                    

                  
                      

                        MySQL · 5.7改进 · Recovery改进
                      

                    

                    

                  
                      

                        MySQL · 5.7特性 · 高可用支持
                      

                    

                    

                  
                      

                        MySQL · 5.7优化 · Metadata Lock子系统的优化
                      

                    

                    

                  
                      

                        MySQL · 5.7特性 · 在线Truncate undo log 表空间
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · hash_scan 算法的实现解析
                      

                    

                    

                  
                      

                        TokuDB · 版本优化 · 7.5.0
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · FAST UPDATES
                      

                    

                    

                  
                      

                        MariaDB · 性能优化 · filesort with small LIMIT optimization
                      

                    

 
        

    

  

    
 TokuDB · 版本优化 · 7.5.0  

    
 Author:   

  

  

  
TokuDB　7.5.0大版本已发布，是一个里程碑的版本，这里谈几点优化，以飨存储引擎爱好者们。

a) shutdown加速

有用户反馈TokuDB在shutdown的时候，半个小时还没完事，非常不可接受。
在shutdown的时候，TokuDB在干什么呢？在做checkpoint，把内存中的节点数据序列化并压缩到磁盘。
那为什么如此耗时呢？如果tokudb_cache_size开的比较大，内存中的节点会非常多，在shutdown的时候，大家都排队等着被压缩到磁盘（串行的）。
在7.5.0版本，TokuDB官方针对此问题进行了优化，使多个节点并行压缩来缩短时间。

详细commit见: 
https://github.com/Tokutek/ft-index/commit/bd85b8ce7d152412755860976a871fdfc977115c
 
BTW: TokuDB在早期设计的时候已保留并行接口，只是一直未开启。

b) 内节点读取加速

在内存中，TokuDB内节点(internal node)的每个message buffer都有２个重要数据结构：

1) FIFO结构，保存{key, value}
2) OMT结构，保存{key, FIFO-offset}
由于FIFO不具备快速查找特性，就利用OMT来做快速查找(根据key查到value)。

这样，当内节点发生cache miss的时候，索引层需要做：

1) 从磁盘读取节点内容到内存
2) 构造FIFO结构
3) 根据FIFO构造OMT结构(做排序)
由于TokuDB内部有不少性能探(ji)针(shu)，他们发现步骤3)是个不小的性能消耗点，因为每次都要把message buffer做下排序构造出OMT，于是在7.5.0版本，把OMT的FIFO-offset(已排序)也持久化到磁盘，这样排序的损耗就没了。

c) 顺序写加速

当写发生的时候，会根据当前的key在pivots里查找(二分)当前写要落入哪个mesage buffer，如果写是顺序(或局部顺序，数据走向为最右边路径)的，就可以避免由＂查找＂带来的额外开销。
Fractal tree.png
如何判断是顺序写呢？TokuDB使用了一种简单的启发式方法(heurstic)：seqinsert_score积分式。
如果：

1) 当前写入落入最右节点，对seqinsert_score加一分(原子)
2) 当前写入落入非最右节点，对seqinsert_score清零(原子)
当seqinsert_score大于100的时候，就可以认为是顺序写，当下次写操作发生时，首先与最右的节点pivot进行对比判断，如果确实为顺序写，则会被写到该节点，省去不少compare开销。
方法简单而有效。

  

    

		

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
