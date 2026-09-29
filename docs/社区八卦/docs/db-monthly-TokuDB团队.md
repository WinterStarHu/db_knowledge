# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/08/10/
> 分类: 社区八卦

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
                      

                    

 
        

    

  

    
 TokuDB·社区八卦·TokuDB团队  

    
 Author:   

  

  

  
第一期先介绍下TokuDB团队吧。 
TokuDB自从开源后（更赞的是开源了所有的commits），逐渐被大家所熟悉，MariaDB 5.5系列和Percona Server 5.6的GA版本中，都以plugin的方式集成。

3位(Tokutek)创始人: 
Michael A. Bender
 , 
Martín Farach-Colton
 , 
Bradley C. Kuszmaul

2012年他们合发了一篇208页的pdf[
Data Structures and Algorithms for Big Databases
]，热爱存储引擎算法的朋友们一定要看 :D

TokuDB目前有５名研发:

@prohaska    --tokudb-engine研发，版本发布(一个人)
@Leif        --tokuFT研发(Bender学生)
@zkasheff    --tokuFT研发(Kuszmaul学生)
@esmet       --tokuFT研发(Farach学生)
@fizzfaldt   --算法优化(Bender学生)

可以说是个很＂精致＂团队，是研发也是测试，tokuFT的测试代码达~18w行(而tokuFT的核心代码才~9w行)，在代码把控上也很严格，要求所有代码在valgrind(helgrind和drd)下，没有memory、data race(资源竞争)和lock order(死锁)警告，质量很有保障。(BTW:我们也在借鉴和运用)

同时@Leif和@zkasheff也是tokuMX的研发，不久前，他俩就MongoDB Replication可能＂丢数据＂的问题，写了篇[
Ark: A Real-World Consensus Implementation
]，对Paxos和Raft感兴趣的同学可以去看下。

更有意思的是，当工程中遇到难题，研发们先讨论出方案，递给三位创始人，得到更权威的指导，如果问题不错，他们就深入研究，出paper，工程与学术相结合。

  

    

		

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
