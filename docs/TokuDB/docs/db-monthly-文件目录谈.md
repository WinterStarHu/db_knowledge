# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/09/10/
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
	

  

    
数据库内核月报 － 2015 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 ·  InnoDB Adaptive hash index介绍
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 ·  clog异步提交一致性、原子操作与fsync
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · BUG 几例
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 诡异的函数返回值
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 建表过程中crash造成重建表失败
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 谈谈checkpoint的调度
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.6 并行复制恢复实现
                      

                    

                    

                  
                      

                        MySQL · 备库优化 ·  relay fetch 备库优化
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.6并行复制事件分发机制
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 文件目录谈
                      

                    

 
        

    

  

    
 MySQL · TokuDB · 文件目录谈  

    
 Author: 一工  

  

  

  
TokuDB的数据库文件组织方式比较随意，给我们一种“乱”的假象，今天就来漫谈下TokuDB数据库文件。

一个“新生”的TokuDB数据库，基础文件是这样的：

tokudb.directory --表/索引文件信息
tokudb.environment --TokuDB版本号信息
tokudb.rollback --undo记录
log000000000001.tokulog27 --redo记录
__tokudb_lock_dont_delete_me_* --文件锁，保证同一个datadir只能被一个TokuDB进程使用

在test数据库下面新建个表t1，并写几条数据：

CREATE TABLE `t1` (
`a` int(11) NOT NULL,
`b` int(11) DEFAULT NULL,
`c` int(11) DEFAULT NULL,
PRIMARY KEY (`a`),
KEY `bc` (`b`,`c`)
) ENGINE=TokuDB

就会发现目录下多出3个文件，表t1：

file1: _test_t1_key_bc_90_3_1b.tokudb --索引(bc)文件
file2: _test_t1_main_90_2_1b.tokudb --主文件
file3: _test_t1_status_90_1_1b.tokudb --表元数据文件

可以发现每个表最少2个文件，命名规则为：

_database_table_main*.tokudb
_database_table_status*.tokudb

索引是一个单独的.tokudb文件。

好了，下面是问题时间。

问题1: TokuDB如何知道哪些文件属于表t1

现在来dump下tokudb.directory：

{key={len=17 data="./test/t1-key-bc\000"} xid=0000000000000003 val={len=33 data="./_test_t1_key_bc_90_3_1b.tokudb\000"}}
{key={len=15 data="./test/t1-main\000"} xid=0000000000000002 val={len=31 data="./_test_t1_main_90_2_1b.tokudb\000"}}
{key={len=17 data="./test/t1-status\000"} xid=0000000000000001 val={len=33 data="./_test_t1_status_90_1_1b.tokudb\000"}}

TokuDB在启动的时候，会读取tokudb.directory，根据key信息组织出表t1的相关文件，并写到information_schema.tokudb_file_map表。

问题2: TokuDB如何知道表t1有哪些索引以及列信息

这些信息全部存在_test_t1_status_90_1_1b.tokudb文件里。

问题3: TokuDB的分区表文件是怎样的

实验走起来，首先创建一个按时间的分区表t2：

CREATE TABLE `t2` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `c1` int(11) DEFAULT NULL,
  `date` datetime NOT NULL,
  KEY `id` (`id`),
  KEY `c1` (`c1`)
) ENGINE=TokuDB DEFAULT CHARSET=latin1
/*!50100 PARTITION BY RANGE ( TO_DAYS(date))
(PARTITION p201508 VALUES LESS THAN (736176) ENGINE = TokuDB,
 PARTITION p201509 VALUES LESS THAN (736207) ENGINE = TokuDB,
 PARTITION rxMORES VALUES LESS THAN MAXVALUE ENGINE = TokuDB) */

现在分区表的文件是什么样的呢？

data/_test_t2_P_p201508_key_c1_ba_4_1b.tokudb
data/_test_t2_P_p201508_key_id_ba_3_1b.tokudb
data/_test_t2_P_p201508_main_ba_2_1b.tokudb
data/_test_t2_P_p201508_status_ba_1_1b.tokudb
data/_test_t2_P_p201509_key_c1_bb_4_1b.tokudb
data/_test_t2_P_p201509_key_id_bb_3_1b.tokudb
data/_test_t2_P_p201509_main_bb_2_1b.tokudb
data/_test_t2_P_p201509_status_bb_1_1b.tokudb
data/_test_t2_P_rxMORES_key_c1_bc_4_1b.tokudb
data/_test_t2_P_rxMORES_key_id_bc_3_1b.tokudb
data/_test_t2_P_rxMORES_main_bc_2_1b.tokudb
data/_test_t2_P_rxMORES_status_bc_1_1b.tokudb

可以看到每个分区表有4个文件：1个main文件，1个status文件，还有2个key索引文件。
对于分区表来说，总的文件数目基本是：分区数目 * (1 + 1 + 索引数目)。

所以如果您的分区非常多，open-files-limit 配置可要小心了，要尽可能的大点，否则可能会出现”Too many open files”，从而导致实例crash！

希望本文能帮助您了解到TokuDB的文件组织结构，祝玩得开心！

  

    

		

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
