# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/11/04/
> 分类: 5.7特性

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
                      

                    

 
        

    

  

    
 MySQL · 5.7特性 · 高可用支持  

    
 Author:   

  

  

  

背景

MySQL的Master-Slave结构提供了实现High Availability的基础，在实现上面通常使用client-proxy-db的三层架构，proxy不单单完成错误检测、实例切换等高可用功能，还可以实现sharding，即scale out。

MySQL Fabric就是Oracle想大力发展的proxy，这里主要介绍为了完成高可用的功能，MySQL 5.7做了哪些事情，我们是否可以使用，实现自己的proxy？

高可用组件

proxy完成高可用的功能，除了需要MySQL提供的master-slave的基础结构外，还需要:

  
在错误检测、进行实例切换时候，需要DB的只读功能，防止m/s双写。

  
在切换完成后，如何实现client重连，或者实现session维持，对client透明。

那么问题来了

  
如何保证切换？

当前MySQL版本提供了一个read_only的功能，通过添加global read lock和commit锁来实现，可以满足实现单点写入。

  
client重连或者session维持？

client重连主要依赖client的API，检测connection的错误。而保持connection不断开，session维持怎么做？

MySQL 5.7增加的功能

  
offline mode

offline mode不光实现了read only的功能，并且会断掉所有的非super用户的connection，并禁止重连。虽然官方文档中介绍是为了支持upgrade，但完全可以使用在切换的过程中。
2.session回放功能支持

client-server protocol对于response packet增加了对session state状态改变的支持，对于以下的session state变化：

  
User-defined variables

  
session-specific values for server variables

  
Temporary tables that are created

  
Prepared statements

  
Current database
response packet中会添加一个tracker标示其变化。 有了这个功能就可以容易实现session的回放功能，特别在load balance或者cluster环境中，把一个用户的connection迁移到另外一台实例上，来保持connection不断开，实现切换对client透明。

使用MySQL 5.7新增的这两个功能，可以帮助proxy实现DB高可用。

  

    

		

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
