# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/11/09/
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
                      

                    

 
        

    

  

    
 TokuDB · 引擎特性 · FAST UPDATES  

    
 Author:   

  

  

  
MySQL的update在执行时需要做read-modify-write：

  
从底层存储中读取row数据(read row)

  
对row数据做更改(modify row)

  
把更改后的数据写回底层存储(write row)

操作路径还是比较长的，TokuDB提供了fast update语法，让＂某些＂场景下update更快，无需做read和modify直接write。
用法:

 CREATE TABLE `t1` (
  `id` int(11) NOT NULL,
 `count` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)) ENGINE=TokuDB;

NOAR语句：

 INSERT NOAR INTO t1 VALUES (1,0) ON DUPLICATE KEY UPDATE count = count + 1;

语义是：插入一条记录，如果该记录存在(id为1)，就对count的值做加法操作，不存在则做插入。
注意： fast updates的条件是比较苛刻的，必须满足：

  
表必须有主键，且只能有一个索引(包含主键)

  
主键必须为： int, char或varchar类型，被更新的列也必须为三种类型之一

  
WHERE子句必须为单行操作

  
如果开启binlog，binlog_format必须为STATEMENT
看了这些苛刻的条件后，有种＂臣妾做不到＂的感觉了吧，可以看出TokuDB一直为细节而努力。

  

    

		

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
