# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/12/06/
> 分类: TokuDB

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
	

  

    
数据库内核月报 － 2015 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 事务子系统介绍
                      

                    

                    

                  
                      

                        PgSQL · 特性介绍 · 全文搜索介绍
                      

                    

                    

                  
                      

                        MongoDB · 捉虫动态 · Kill Hang问题排查记录
                      

                    

                    

                  
                      

                        MySQL · 参数优化 ·RDS MySQL参数调优最佳实践
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 备库激活过程分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 让Hot Backup更完美
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 表膨胀
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · Index Condition Pushdown (ICP)
                      

                    

                    

                  
                      

                        MariaDB · 社区动态 · MariaDB on Power8
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 企业版特性一览
                      

                    

 
        

    

  

    
 MySQL · TokuDB · 让Hot Backup更完美  

    
 Author: yigong  

  

  

  
前言

很久很久以前，内核君发表了一篇
HA方案·TokuDB热备
的文章，方法很简单：

  
SET TOKUDB_CHECKPOINT_LOCK=ON;

  
开始拷贝TokuDB的数据文件(不包含日志文件)；

  
FLUSH TABLES WITH READ LOCK;

  
记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)；

  
UNLOCK TABLES;

  
SET TOKUDB_CHECKPOINT_LOCK=OFF;

这些步骤可以很方便的嵌入到Percona XtraBackup中，与InnoDB一起工作，目前看是一个比较简单可行的方案。

大实例备份恢复问题

问题来了。
当某个实例的数据量达到TB级，你会发现备库(基于备份)重搭后，启动会灰常灰常慢，因为他们都在recover redo-log，为什么呢？

  
SET TOKUDB_CHECKPOINT_LOCK=ON;

  
开始拷贝TokuDB的数据文件(不包含日志文件)，由于拷贝TB级的数据非常耗时，redo log持续增加甚至上万个

当TokuDB启动后，扫描和recover这几万个redo log将是灾难性的。

解决这个问题比较简单，我们稍微调整下热备的顺序即可：

  
SET TOKUDB_CHECKPOINT_LOCK=ON;

  
FLUSH TABLES WITH READ LOCK;

  
记录binlog位置，拷贝最新的binlog和TokuDB的日志文件(*.tokulog)；

  
UNLOCK TABLES;

  
开始拷贝TokuDB的数据文件(不包含日志文件)  –移动到这里

  
SET TOKUDB_CHECKPOINT_LOCK=OFF;

这样在拷贝TokuDB数据文件的时候，就跟redo-log没半毛钱关系了，而且拷贝的redo-log数也大大减少！

优化改进

本以为这样就可以早点下班回家，但问题还是来。

某实例有几十万个TokuDB文件(分区表文件)，使用热备的数据备库重搭后，复制过程中偶尔会出现”Duplicate entry … for key ‘PRIMARY’“错误。

引起这个错误的原因比较深，触发自TokuDB内部机制。

TokuDB每个分区表有数个文件组成（想了解TokuDB数据库文件的请
轻戳这里
），当分区表非常多的时候，打开的文件句柄数会非常多，受限于
open_files_limit
配置，TokuDB底层会触发句柄关闭机制，对当前文件进行checkpoint操作(新数据被刷到磁盘且生效)再做close，这样即使拿到checkpoint锁后，还是有数据被写入，就引发了以上问题。

为了解决这个问题，我们在热备的过程中引入一个状态：in_backup = true，防止文件关闭做checkpoint操作，具体的patch见
这里
。

这样TokuDB的热备就比较完美了，整个热备过程中，所有的数据文件均处于一个“一致性”状态，所有的操作都在redo-log里，不再污染数据文件。

  

    

		

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
