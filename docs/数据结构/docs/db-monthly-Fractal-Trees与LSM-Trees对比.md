# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/08/09/
> 分类: 数据结构

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
                      

                    

 
        

    

  

    
 TokuDB · 数据结构 · Fractal-Trees与LSM-Trees对比  

    
 Author:   

  

  

  
最近，TokuDB的创始人Dr. Bradley Kuzmaul发表了一篇文章: 
A Comparison of Log-Structured Merge (LSM) and Fractal Tree Indexing
，从write amplification(WAMP), read amplification(RAMP), and space amplification三个方面对B-Trees，LSM-Trees(LSM)以及Fractal-Trees(FT)进行了详细的分析和对比。

Dr. Bradley Kuzmaul的结果是(页13): 

从结果来看：

在WAMP上，FT跟LSM(leveled)是相同的
在RAMP(range)上，LSM(leveled)的复杂度明显要高不少(FT的O(logN/B)倍)

不过，RAMP这块的分析有个小问题： 
LSM(leveled)在实现上(比如LevelDB)，可以通过meta-info打＂锚点＂的方式，把RAMP(range)降低甚至做到跟FT一样，如果是point queries的RAMP，则可以通过Bloom filter来降低。

具体的推导过程请阅读原作，下面简单分析下FT的RAMP为啥比LSM的要低。 
FT的读方式比较＂特殊＂，由于每个节点都有个message buffer，当有读请求时，需要把inner node的message buffer数据（部分）推(apply)到leaf node，最后只在leaf node上做二分查找，所以RAMP基本就是树的高度。

另外，在数据流向上(compaction过程中数据走向)，LSM强调"level"(横向)，从level-L根据规则选取部分数据merge到level-(L+1)，如果选取数据的策略不好，会抢占磁盘带宽，容易引起性能抖动，而FT强调"root-to-leaf"(纵向)，数据从root有序的逐层merge到leaf节点，每条数据的merge路径是很明确的。

  

    

		

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
