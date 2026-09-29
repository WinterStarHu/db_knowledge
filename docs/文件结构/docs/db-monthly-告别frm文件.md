# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/07/
> 分类: 文件结构

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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 MySQL · 文件结构 · 告别frm文件  

    
 Author:   

  

  

  

提要

长久以来，server层和InnoDB层都保存了表的元数据，server使用frm文件保存了column，data_types等信息，而InnoDB使用data dictionary来保存meta data。

由于server层使用文件系统，而InnoDB使用事务引擎，所以经常会存在两者不一致的情况，比如：

create table的过程中实例crash
alter table过程中实例crash

具体可以参见：
http://dev.mysql.com/doc/refman/5.6/en/innodb-troubleshooting-datadict.html
 包括相关的解决方法。

改进

MySQL 后续的版本准备做相关的改进：

  
使用native InnoDB-based Data Dictionary保存meta data，不再需要frm文件

  
使用InnoDB引擎保存MySQL的系统表，比如privileges和timezones相关的表

使用new Data Dictionary，去掉frm文件，目前还在MySQL lab版本中。

而在MySQL 5.7的版本中，以下的系统表已不再使用MyISAM，而使用InnoDB引擎保存数据：

  
help_category

  
help_keyword

  
help_relation

  
help_topic

  
time_zone

  
time_zone_leap_second

  
time_zone_name

  
time_zone_transition,

  
time_zone_transition_type

变化

  
由于使用具有ACID特性的InnoDB引擎，由crash导致的元数据不一致情况将不再出现。

  
对于information_schema中元数据的查询，系统将暴露一个基表上的view出来，供查询。

  
由于使用InnoDB引擎来保存数据，–skip-innodb的参数将不再有意义，5.7版本中做删除处理。

问题

  
系统表切换到InnoDB引擎上，对于版本升级或者降级需要对脚本特殊处理。

  
去掉frm文件，系统如何平滑的进行升级？

  
第三方引擎怎么办？oracle后续的打算是如何？这是一个很大的问题。

由于去掉frm文件使用native InnoDB-based Data Dictionary的特性还在lab环境中酝酿，期待中。

无论如何，提升failure recovery的水平，对于使用者来说，终归是好事情！

  

    

		

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
