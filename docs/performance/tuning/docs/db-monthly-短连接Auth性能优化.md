# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/04/07/
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
	

  

    
数据库内核月报 － 2016 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 参数故事 · innodb_additional_mem_pool_size
                      

                    

                    

                  
                      

                        GPDB · 特性分析 · Segment事务一致性与异常处理
                      

                    

                    

                  
                      

                        GPDB · 特性分析 · Segment 修复指南
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 并行复制外键约束问题二
                      

                    

                    

                  
                      

                        PgSQL · 性能优化 · 如何潇洒的处理每天上百TB的数据增量
                      

                    

                    

                  
                      

                        Memcached · 最佳实践 · 热点 Key 问题解决方案
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · 短连接Auth性能优化
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · RDS 只读实例延迟分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB索引结构--Fractal Tree
                      

                    

                    

                  
                      

                        MySQL · TokuDB · Savepoint漫谈
                      

                    

 
        

    

  

    
 MongoDB · 最佳实践 · 短连接Auth性能优化  

    
 Author: mingyan.zc  

  

  

  
问题

通常我们使用MongoDB的时候，客户端（driver）和MongoDB之间都是使用长连接，但是在某些场景下、某些driver仍然只能使用短连接进行连接，比如PHP。就在我们
阿里云数据库MongoDB版
商业化后没多久，我们就遇到了一个用户短连接过多导致的性能问题。

这个问题的症状是MongoD的CPU使用率居高不下，16个核都跑满了，影响到了用户的正常使用。

排查

首先想到的当然是看看有没有很多慢查询，针对存在的慢查询都建议用户建了索引后，情况还是没有好转。这时我们观察到用户的driver不断有短连接上来，基本上身份认证完执行个操作后很快就断开。会不会是短连接的问题导致呢？因为
阿里云数据库MongoDB版
出于安全考虑，强制打开了身份认证，我们知道 MongoDB3.0 后使用的身份认证机制是
SCRAM-SHA1
，这是需要进行一些 CPU 密集型操作比如哈希计算等的。通过profile工具进行诊断后，我们发现 CPU 热点非常集中，主要消耗在读取 
/dev/urandom
 来生成随机数，这需要通过系统调用进入内核态。再结合监控，确实 CPU 都消耗在sys而不是user。以下为profile工具诊断图：

对照一下源码就知道了，这是因为在认证过程中需要生成一串叫做server-nonce的随机字符串（具体的认证过程及这个随机字符串的作用可参照
MongoDB中使用的SCRAM-SHA1认证机制
。在Linux平台下，是通过这个
/dev/urandom
（Linux上提供了两个随机数生成的特殊设备文件，还有一个是
/dev/random
，这两个的区别是从
/dev/urandom
 中读取是非阻塞的，具体可再自行google或看man手册。）来生成随机数的。其原理是利用当前系统的熵池来计算出一定数量的随机比特，然后将这些比特作为字节流返回。熵池就是当前系统的环境噪音，因此其随机效果还是比较好的。不过有利必有弊，这个
/dev/urandom
的性能就不怎么好了。要使用这个来生成随机数，首先要进行系统调用，这涉及用户态到内核态的切换。其次，为了避免两个并发读返回同样的结果，在内核中使用了spinlock，因此在多线程并发从
/dev/urandom
中读时，性能会急剧下降。这个东东设计之初是为了安全，而不是性能。因此建议的做法是使用
/dev/urandom
来初始化用户态的随机数，而不是每个请求都从这里取。

解决

既然知道了问题，那么解决也就好办了，当然是想办法使用一个性能较好，随机性又不差的方案来替换这个
/dev/urandom
。我们使用了一个用户态的随机数生成器，效果非常明显，CPU使用率从100%降到10%。

以下为优化前后CPU使用率对比图：

其中红色、蓝色、绿色分别为关闭Auth、打开Auth（优化前）和打开Auth（优化后）。

目前
阿里云数据库MongoDB版
已经全面使用了性能优化版，所以各位使用短连接（如PHP driver）的客官们可以放心使用了。

  

    

		

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
