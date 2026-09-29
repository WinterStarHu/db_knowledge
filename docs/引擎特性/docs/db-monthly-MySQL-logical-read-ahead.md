# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/07/08/
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
	

  

    
数据库内核月报 － 2015 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb change buffer介绍
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB Checkpoint机制
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 时间线解析
                      

                    

                    

                  
                      

                        PgSQL · 功能分析 · PostGIS 在 O2O应用中的优势
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB index lock前世今生
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MySQL内存分配支持NUMA
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 外键删除bug分析
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · MySQL logical read-ahead
                      

                    

                    

                  
                      

                        MySQL · 功能介绍 · binlog拉取速度的控制
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 浮点型的显示问题
                      

                    

 
        

    

  

    
 MySQL · 引擎特性 · MySQL logical read-ahead  

    
 Author: 冷香  

  

  

  
背景

之前的月报中我们比较了InnoDB linear read-ahead和Oracle的multiblock read，两个的性能有所差别，具体可以参考
月报详情
。
这两种方式之所以带来了更高的吞吐量，都基于数据存储的连续性的假设，比如MySQL使用自增字段作为pk的InnoDB索引表，或者是Oracle使用默认的堆表，但当这样的假设条件不成立的时候，怎么办？

场景

考虑下面的一个场景，如下图所示：

这是一个B-Tree结构，典型的InnoDB的索引聚簇表，这样的结构很容易构造，比如使用一个非连续的字段作为索引字段，随机对记录进行插入，这样leaf page链表上的page_no就会产生非连续性，如果进行一次全表扫描，比如 
checksum table t
，按照正常的升序扫描，leaf page扫描的page_no顺序是3, 4, 5230等等，这样其实是无法使用到InnoDB 的Linear read-ahead，更没有办法合并IO请求。

对于存在时间比较长，变更又比较多的大表，除非我们对于这个表进行重建，否则leaf page的离散性会随着时间的推移，越来越严重。但对于在线应用来说，重建又会产生比较大的运维风险，这里就介绍一种平衡的方法，logical read-ahead。

logical read-ahead

逻辑预读的概念是指，根据branch节点来预读leaf节点。

逻辑预读使用两个扫描路径:

  
一个cursor定位到leaf page，然后根据leaf page之间的双链表，moves_up进行扫描数据；

  
另一个cursor定位到branch节点，因为InnoDB B-Tree结构的每一层都由双向链表进行连接，然后这个cursor就沿着branch节点进行扫描，保存扫描到的page_no，然后使用异步IO，发起这些leaf page的预读取。

代码实现

MySQL 5.6版本上的实现方式:

  
在
row_search_for_mysql
进行moves_up的过程中进行logical read-ahead；

  
branch节点扫描的cursor保存到trx结构中，生命周期到一个sql语句结束；

  
branch cursor扫描用户可配置的page count，临时保存到数组中，对page_no进行排序；

  
使用libaio发起异步IO读取，完成logical read-ahead。

logical read-ahead很好的提升了离散存储数据的吞吐能力，Facebook在他们的MySQL实例的逻辑备份过程中，对于大表的dump备份开启了此特性，备份速度有非常大的提升。

  

    

		

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
