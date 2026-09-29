# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/09/08/
> 分类: 主备复制

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
	

  

    
数据库内核月报 － 2014 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 捉虫动态 · GTID 和 DELAYED
                      

                    

                    

                  
                      

                        MySQL · 限制改进 · GTID和升级
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID 和 binlog_checksum
                      

                    

                    

                  
                      

                        MySQL · 引擎差异·create_time in status
                      

                    

                    

                  
                      

                        MySQL · 参数故事 · thread_concurrency
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · auto_increment
                      

                    

                    

                  
                      

                        MariaDB · 性能优化 · Extended Keys
                      

                    

                    

                  
                      

                        MariaDB · 主备复制 · CREATE OR REPLACE
                      

                    

                    

                  
                      

                        TokuDB · 参数故事 · 数据安全和性能
                      

                    

                    

                  
                      

                        TokuDB · HA方案 · TokuDB热备
                      

                    

 
        

    

  

    
 MariaDB · 主备复制 · CREATE OR REPLACE  

    
 Author:   

  

  

  
MariaDB 10.0.8 版本增加了一个CREATE OR REPLACE TABLE语法，这个语法的目的是让Replication更加可靠，为什么这个语句能让复制更可靠呢？

例如用户使用CREATE … SELECT语句，而这个语句回滚了又重新执行，备库有可能先收到一个CREATE语句，但是没收到INSERT的Events，主库重做一遍之后，备库收到CREATE语句时就会失败，而CREATE OR REPLACE则可以避免这个问题，存在的表会被替换掉。

最基本的使用例子：

CREATE OR REPLACE TABLE table_name (a int);

这个语句其实等价于：

DROP TABLE IF EXISTS table_name;
CREATE TABLE table_name (a int);

这两个语句的执行结果。

  
如果 table_name被LOCK TABLES锁住了，CREATE OR REPLACE TABLE会忽略锁定，然后在语句执行完成后把新建的表加上锁定。

  
临时表只有在指定了TEMPORARY关键字时才会被DROP掉。（用DROP TABLE的话，同名的临时表会比普通表先被删除）

使用CREATE OR REPLACE TABL必须意识到的问题：

  
表会首先被DROP掉（如果这张表存在的话），然后CREATE动作才会执行。正是因为如此，如果CREATE步骤失败了，那么执行这个语句后表可能会不存在了。如果表是被LOCK TABLES锁住的，那么表的锁会被释放掉先。

  
OR REPLACE和IF EXISTS语句不可同时使用

  
Slave在复制中当CREATE语句没有使用IF EXISTS标识时，会默认使用CREATE OR REPLACE语句来执行。这个行为可以通过slave-ddl-exec-mode变量来改变，设置为STRICT则不会做这个替换。

相关的新增参数：

　slave_ddl_exec_mode

　描述: Slave控制如何执行DDL的Event的模式。可选值有STRICT、IDEMPOTENT (默认值)。

　　在 IDEMPOTENT 模式下，Slave不会因为那些不会导致主备不一致的DDL执行失败而停止。

　　尤其是CREATE TABLE 会被当做 CREATE OR REPLACE TABLE，而 DROP TABLE 会被当做DROP TABLE IF EXIS TS.

　默认值: IDEMPOTENT

　可选值: IDEMPOTENT, STRICT

  

    

		

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
