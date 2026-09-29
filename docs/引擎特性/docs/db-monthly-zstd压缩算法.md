# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/05/09/
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
	

  

    
数据库内核月报 － 2015 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB redo log漫游
                      

                    

                    

                  
                      

                        MySQL · 专家投稿 · MySQL数据库SYS CPU高的可能性分析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 5.6 与 5.5 InnoDB 不兼容导致 crash
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · InnoDB 预读 VS Oracle 多块读
                      

                    

                    

                  
                      

                        PgSQL · 社区动态 · 9.5 新功能BRIN索引
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · MySQL DDL BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · set names 都做了什么
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 临时表操作导致主备不一致
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · zstd压缩算法
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · binlog 位点刷新策略
                      

                    

 
        

    

  

    
 TokuDB · 引擎特性 · zstd压缩算法  

    
 Author: 一工  

  

  

  
有4压缩很任性

TokuDB有着出色的压缩特性，这不是”盖”的：
RDS上有个InnoDB实例，1天的数据将近700GB空间，换成TokuDB后(默认zlib压缩)，同样的700GB可以保存５天的数据，业务读写性能也无任何影响，空间成本直线下降。

为什么TokuDB的压缩这么给力？
因为TokuDB一个“页”的大小为4MB，压缩起来，这酸爽…

zstd新压缩算法

TokuDB支持3种压缩算法:

tokudb_quicklz:
 
压缩效果差，

CPU

消耗低

tokudb_zlib

:
 
压缩效果偏中，

CPU

消耗偏中

(

默认

)

tokudb_lzma

:
 
压缩效果好，

CPU

消耗高

之所以提供多种压缩算法，主要是从CPU消耗和压缩效果上综合考虑的，大部分情况下 tokudb_zlib 都可以应付，而且压缩效果也不错，也是 TokuDB 默认压缩算法。
最近压缩界出了一枚小鲜肉:
zstd压缩算法
，由压缩专业户
Yann Collet
倾力打造。
zstd有着非常好的压缩效果，最重要的是它CPU消耗低和压缩(解压)速度非常快，我们内部TokuDB版本已集成此算法，下面就让我们看看同样数据集的情况下，它们的效果对比：

压缩效果对比图(越高越好):

zstd的压缩效果介于zlib和lzma之间，已经很理想了。

压缩时间对比图:

压缩时间非常少，几乎是quicklz的一半。

相信过不了多久，你的RDS数据已经悄悄的跑在zstd压缩算法之下。
如果你对我们所做的事情感兴趣，请抓起鼠标，敲起键盘，快快跟我们联系吧，最后悄悄说一句：

我们有妹子!!!

  

    

		

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
