# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/11/10/
> 分类: 性能优化

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
                      

                    

 
        

    

  

    
 MariaDB · 性能优化 · filesort with small LIMIT optimization  

    
 Author:   

  

  

  
从MySQL 5.6.2/MariaDB 10.0.0版本开始，MySQL/MariaDB针对”ORDER BY …LIMIT n”语句实现了一种新的优化策略。当n足够小的时候，优化器会采用一个容积为n的优先队列来进行排序，而不是排序所有数据然后取出前n条。 这个新算法可以这么描述：（假设是ASC排序）

  
建立一个只有n个元素的优先队列（堆），根节点为堆中最大元素

  
根据其他条件，依次从表中取出一行数据

  
如果当前行的排序关键字小于堆头，则把当前元素替换堆头，重新Shift保持堆的特性

  
再取一条数据重复2步骤，如果没有下一条数据则执行5

  
依次取出堆中的元素（从大到小排序），逆序输出（从小到大排序），即可得ASC的排序结果

这样的算法，时间复杂度为m
log(n)，m为索引过滤后的行数，n为LIMIT的行数。而原始的全排序算法，时间复杂度为m
log(m)。只要n远小于m，这个算法就会很有效。

不过在MySQL 5.6中，除了optimizer_trace，没有好的方法来看到这个新的执行计划到底起了多少作用。MariaDB 10.013开始，提供一个系统状态，可以查看新执行计划调用的次数：

Sort_priority_queue_sorts
描述: 通过优先队列实现排序的次数。(总排序次数=Sort_range+Sort_scan)
范围: Global, Session
数据类型: numeric
引入版本: MariaDB 10.0.13

此外，MariaDB还将此信息打入了Slow Log中。只要指定 log_slow_verbosity=query_plan，就可以在Slow Log中看到这样的记录：

# Time: 140714 18:30:39
# User@Host: root[root] @ localhost []
# Thread_id: 3  Schema: test  QC_hit: No
# Query_time: 0.053857  Lock_time: 0.000188  Rows_sent: 11  Rows_examined: 100011
# Full_scan: Yes  Full_join: No  Tmp_table: No  Tmp_table_on_disk: No
# Filesort: Yes  Filesort_on_disk: No  Merge_passes: 0  Priority_queue: Yes
SET timestamp=1405348239;SET timestamp=1405348239;
select * from t1 where col1 between 10 and 20 order by col2 limit 100;

“Priority_queue: Yes” 就表示这个Query利用了优先队列的执行计划(pt-query-digest 目前已经可以解析 Priority_queue 这个列)。

  

    

		

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
