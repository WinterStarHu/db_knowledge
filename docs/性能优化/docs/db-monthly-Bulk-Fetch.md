# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/08/08/
> 分类: 性能优化

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
	

  

    
数据库内核月报 － 2014 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 参数故事 · timed_mutexes
                      

                    

                    

                  
                      

                        MySQL · 参数故事 · innodb_flush_log_at_trx_commit
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Count(Distinct) ERROR
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · mysqldump BUFFER OVERFLOW
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · long semaphore waits
                      

                    

                    

                  
                      

                        MariaDB · 分支特性 · 支持大于16K的InnoDB Page Size
                      

                    

                    

                  
                      

                        MariaDB · 分支特性 · FusionIO特性支持
                      

                    

                    

                  
                      

                        TokuDB · 性能优化 · Bulk Fetch
                      

                    

                    

                  
                      

                        TokuDB · 数据结构 · Fractal-Trees与LSM-Trees对比
                      

                    

                    

                  
                      

                        TokuDB·社区八卦·TokuDB团队
                      

                    

 
        

    

  

    
 TokuDB · 性能优化 · Bulk Fetch  

    
 Author:   

  

  

  
Bulk Fetch是为了提升区间操作性能的，聊它之前，先简单唠叨下读取机制，TokuDB由两部分组成: 
tokuFT
和 
tokudb-engine
 。 
tokuFT是个支持事务的key/value存储层，tokudb-engine是MySQL API对接层，调用关系为:tokudb-engine ->tokuFT。 
tokuFT里的一个value，在tokudb-engine里就是一条row数据，底层存储与上层调用解耦，是个很棒的设计。 
在tokuFT是个key里，索引的每个node都是大块头(4MB)，node又细分为多个＂小块＂(internal node的叫做partition，leaf node的叫做basement)。 
从磁盘读取数据到内存的方式有２种：

  

    
仅读一个＂小块＂的数据，反序列化到内存（提升point query性能，只读取需要的那部分数据即可)

  

  

    
读取整个node数据，反序列化到内存（提升区间性能，一次读取整个node磁盘数据）

  

对于tokudb-engine层的区间操作（比如get_next等），tokuFT这层是无状态的，必须告诉当前的key，然后给你查找next，流程大体是:

tokudb-engine::get_next(current_key) --&gt; tokuFT::search_next(current_key) --&gt; tokuFT::return next

这样，即使tokuFT缓存了整个node数据，tokudb-engine还是遍历着跟tokuFT要一遍：tokuFT每次都要根据当前key，多次调用compare操作最终查出next，路径太长了！ 
有什么办法优化呢？这就是Bulk Fetch的威力: tokudb-engine向tokuFT一次要回整个node的数据，自己解析出next row数据，tokuFT的调用就省了:

tokudb-engine::get_next(current_key) --&gt; tokudb-engine::parse_next

从Tokutek的测试看，在使用Bulk Fetch后，能有2x-5x的性能提升。 
但并不是所有的区间操作都可以Bulk Fetch的(比如涉及update/delete)，TokuDB目前实现了:SELECT、CREATE_TABLE、INSERT_SELECT和REPLACE_SELECT的Bulk Fetch功能，预计发布在7.1.8版，更多Bulk Fetch介绍： 

https://github.com/Tokutek/tokudb-engine/wiki/Bulk-Fetch

  

    

		

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
