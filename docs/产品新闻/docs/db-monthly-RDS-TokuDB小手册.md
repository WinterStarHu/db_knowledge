# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/04/02/
> 分类: 产品新闻

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
	

  

    
数据库内核月报 － 2015 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB undo log 漫游
                      

                    

                    

                  
                      

                        TokuDB · 产品新闻 · RDS TokuDB小手册
                      

                    

                    

                  
                      

                        TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)
                      

                    

                    

                  
                      

                        PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 连接断开导致XA事务丢失
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID下slave_net_timeout值太小问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Relay log 中 GTID group 完整性检测
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · UPDATE交换列单表和多表的区别
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 删被引用索引导致crash
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · GTID下auto_position=0时数据不一致
                      

                    

 
        

    

  

    
 TokuDB · 产品新闻 · RDS TokuDB小手册  

    
 Author: 一工  

  

  

  
TokuDB简介

TokuDB是一个支持事务的“新”引擎，有着出色的数据压缩功能，由美国TokuTek公司(http://www.tokutek.com/) 研发，该公司于2015年4月份被Percona收购。
为了降低用户数据存储成本，云数据库(Aliyun RDS)增加了TokuDB引擎支持(MySQL5.6版本)。

TokuDB引擎有什么优点

出色的数据压缩功能，较低的IOPS消耗，如果您的数据量比较大，强烈建议您使用TokuDB，以节省空间成本，而且有着与InnoDB相当的性能。

使用TokuDB引擎有什么注意点

不支持外键(foreign key)功能，如果您的表有外键，切换到TokuDB引擎后，此约束将被忽略!!!

阿里云RDS中TokuDB的buffer pool size如何分配

我们提供了tokudb_buffer_pool_ratio参数(下图)，作用是调整TokuDB的buffer pool（与InnoDB共享）分配比例，这个参数的意思是TokuDB占用buffer pool的百分比。

小提醒:  

如果您是TokuDB用户，建议把这个参数设置成100，表示TokuDB将使用全部buffer pool;
如果您是InnoDB用户，请忽略此参数，默认为InnoDB使用全部buffer pool。

阿里云RDS中如何使用TokuDB引擎

  

    
第一种方法是在DDL语句中指定表的引擎:

    
建新表:

    

 CREATE TABLE ... ENGINE=TokuDB;

    

    
更改引擎:

    

  ALTER TABLE ... ENGINE=TokuDB;  
  ANALYZE TABLE ...;

    

  

  

    
第二种方法是通过IDB工具指定表引擎为TokuDB：

  

  

    
第三种方法(推荐)：
设置default_storage_engine为TokuDB后，表引擎默认为TokuDB。
(注意：此设置需要重启)

  

阿里云RDS中TokuDB表的热备

RDS备份功能已完全支持TokuDB引擎，当您在做备份的时候，会自动备份TokuDB表。

阿里云RDS中如何修改TokuDB引擎的压缩算法

  

    
第一种方法是在client中指定row_format:

    

 CREATE/ALTER TABLE ... ENGINE=TokuDB ROW_FORMAT=[压缩算法];

    

  

  

    
第二种方法是通过IDB工具指定：

  

TokuDB的压缩算法如何选择

  
tokudb_zlib:表启用zlib压缩，压缩效果偏中，CPU消耗偏中，建议使用(默认)；

  
tokudb_quicklz:表启用quicklz压缩，压缩效果差，CPU消耗低；

  
tokudb_lzma:表启用lzma压缩，压缩效果好，CPU消耗高。

TokuDB默认压缩算法为zlib，建议您不要做修改，因为zlib压缩的性价比非常高。

  

    

		

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
