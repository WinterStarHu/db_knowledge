# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/12/08/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2014 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 性能优化 · 5.7 Innodb事务系统
                      

                    

                    

                  
                      

                        MySQL · 踩过的坑 · 5.6 GTID 和存储引擎那会事
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · thread pool 原理分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · 并行复制外建约束问题
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · binlog event有序性
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · server_id为0的Rotate
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · Bulk Load for CREATE INDEX
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·Opened tables block read only
                      

                    

                    

                  
                      

                        MySQL·　优化改进· GTID启动优化
                      

                    

                    

                  
                      

                        TokuDB · TokuDB · Binary Log Group Commit with TokuDB
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态·Opened tables block read only  

    
 Author:   

  

  

  

背景

MySQL通过read_only参数来设置DB只读，这样MySQL实例就可以作为slave角色，只应用binlog，不接受用户修改数据。这样就可以保护master-slave结构中的数据一致性，防止双写风险。

global read_only的实现方式

MySQL5.5版本通过三个步骤来设置read_only：

步骤1：获取global read lock，阻塞所有的写入请求
步骤2：flush opened table cache，阻塞所有的显示读写锁
步骤3：获取commit lock，阻塞commit写入binlog
步骤4：设置read_only=1
步骤5：释放global read lock和commit lock。
MySQL 5.5的版本，通过这5步完成设置read only的功能。

Bug描述

比如如下场景：

 session1：
  lock table t read;
 
 session2：
  set global read_only=1;

先执行session1，然后session2会一直被session1阻塞。

原因是：session1的显示锁，虽然与步骤1中的global read lock相容， 但session2因为session1一直持有读锁并保持t表opened而被阻塞。

但是，实际上，显示的读写锁产生的opened table并不影响read_only的功能，这里的flush tables也并非是必须的。

这也是我们的实际应用环境中，因主备切换而要在master实例上设置read_only的时候，经常被大查询所阻塞的原因。

修复方法

修复方法非常简单，只需要把步骤2删除即可，不影响read only的语义。

官方在MySQL 5.6.5中进行了修复：

If tables were locked by LOCK TABLES ... READ in another session, SET GLOBAL read_only = 1 failed to complete. (Bug #57612, Bug #11764747)

RDS功能增强

设置read_only阻塞用户写入，但只能阻塞普通用户的更新，RDS为了最大可能的保护数据一致性，增强了read_only功能，通过设置super read only，阻塞除了slave线程以为的所有用户的写入，包括super用户。

  

    

		

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
