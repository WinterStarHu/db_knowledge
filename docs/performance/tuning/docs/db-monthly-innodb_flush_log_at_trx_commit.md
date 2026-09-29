# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/08/02/
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
                      

                    

 
        

    

  

    
 MySQL · 参数故事 · innodb_flush_log_at_trx_commit  

    
 Author:   

  

  

  

背景

　　innodb_flush_log_at_trx_commit 这个参数可以说是InnoDB里面最重要的参数之一，它控制了重做日志（redo log）的写盘和落盘策略。 具体的参数意义见手册

　　简单说来，可选值的安全性从0->2->1递增，分别对应于mysqld 进程crash可能丢失 -> OS crash可能丢失 -> 事务安全。

　　以上是路人皆知的故事，并且似乎板上钉钉，无可八卦。

innodb_use_global_flush_log_at_trx_commit

　　直到2010年的某一天，Percona的CTO Vadim同学觉得这种一刀切的风格不够灵活，最好把这个变量设置成session级别，每个session自己控制。

　　但同时为了保持Super权限对提交行为的控制，同时增加了innodb_use_global_flush_log_at_trx_commit参数。 这两个参数的配合逻辑为：

　　1、若innodb_use_global_flush_log_at_trx_commit为OFF，则使用session.innodb_flush_log_at_trx_commit;

　　2、若innodb_use_global_flush_log_at_trx_commit为ON,则使用global .innodb_flush_log_at_trx_commit（此时session中仍能设置，但无效）

　　3、每个session新建时，以当前的global.innodb_flush_log_at_trx_commit 为默认值。

业务应用

　　这个特性可以用在一些对表的重要性做等级定义的场景。比如同一个实例下，某些表数据有外部数据备份，或允许丢失部分事务的情况，对这些表的更新，可以设置 Session.innodb_flush_log_at_trx_commit为非1值。

　　在阿里云RDS服务中，我们对数据可靠性和可用性要求更高，将 innodb_use_global_flush_log_at_trx_commit设置为ON，因此修改session.innodb_flush_log_at_trx_commit也没有作用，统一使用 global.innodb_flush_log_at_trx_commit = 1。

  

    

		

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
