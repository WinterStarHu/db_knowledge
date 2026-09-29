# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/01/10/
> 分类: 特性分析

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
	

  

    
数据库内核月报 － 2015 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 性能优化· Group Commit优化
                      

                    

                    

                  
                      

                        MySQL · 新增特性· DDL fast fail
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 启用GTID场景的性能问题及优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· InnoDB自增列重复值问题
                      

                    

                    

                  
                      

                        MySQL · 优化改进· 复制性能改进过程
                      

                    

                    

                  
                      

                        MySQL · 谈古论今· key分区算法演变分析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· mysql client crash一例
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· 设置 gtid_purged 破坏AUTO_POSITION复制协议
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· replicate filter 和 GTID 一起使用的问题
                      

                    

                    

                  
                      

                        TokuDB·特性分析· Optimize Table
                      

                    

 
        

    

  

    
 TokuDB·特性分析· Optimize Table  

    
 Author:   

  

  

  
来自一个TokuDB用户的“投诉”:

https://mariadb.atlassian.net/browse/MDEV-6207

现象大概是:

用户有一个MyISAM的表test_table:

CREATE TABLE IF NOT EXISTS `test_table` (
`id` int(10) unsigned NOT NULL,
`pub_key` varchar(80) NOT NULL,
PRIMARY KEY (`id`),
KEY `pub_key` (`pub_key`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

转成TokuDB引擎后表大小为92M左右:

47M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
45M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

执行"OPTIMIZE TABLE test_table":

63M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

再次执行"OPTIMIZE TABLE test_table":

79M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

继续执行:

79M     _tester_testdb_sql_61e7_1812_main_ad88a6b_1_19_B_0.tokudb
61M     _tester_testdb_sql_61e7_1812_key_pub_key_ad88a6b_1_19_B_1.tokudb

基本稳定在这个大小。

主索引从47M–>63M–>79M，执行"OPTIMIZE TABLE"后为什么会越来越大？

这得从TokuDB的索引文件分配方式说起，当内存中的脏页需要写到磁盘时，TokuDB优先在文件末尾分配空间并写入，而不是“覆写”原块，原来的块暂时成了“碎片”。

这样问题就来了，索引文件岂不是越来越大？No, TokuDB会把这些“碎片”在checkpoint时加入到回收列表，以供后面的写操作使用，看似79M的文件其实还可以装不少数据呢！

嗯，这个现象解释通了，但还有2个问题:

1) 在执行这个语句的时候，TokuDB到底在做什么呢？

在做toku_ft_flush_some_child，把内节点的缓冲区(message buffer)数据刷到最底层的叶节点。

2) 在TokuDB里，OPTIMIZE TABLE有用吗？

作用非常小，不建议使用，TokuDB是一个"No Fragmentation"的引擎。

官方WIKI: 
Optimize Table

  

    

		

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
