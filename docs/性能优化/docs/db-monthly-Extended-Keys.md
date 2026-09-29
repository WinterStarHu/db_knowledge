# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/09/07/
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
                      

                    

 
        

    

  

    
 MariaDB · 性能优化 · Extended Keys  

    
 Author:   

  

  

  
MariaDB 10.0.8增加了一种新的执行计划——Extended Keys。

它充分利用了InnoDB的隐藏列来做执行计划，因为我们都知道InnoDB的索引组织表会把主键放在最末尾，所以实际上每个索引最后都包含了主键。

打开和关闭这个优化器选项的命令如下：

Enable:

set optimizer_switch=&#039;extended_keys=on&#039;;

Disable:

set optimizer_switch=&#039;extended_keys=off&#039;;

MariaDB 10.0.8中默认选项是 'extended_keys=off'. MariaDB 10.0.9开始默认选项是 'extended_keys=on'.

看一个例子：

有一个DBT-3/TPC-H 测试中用到的SQL如下

select o_orderkey
from part, lineitem, orders
where p_retailprice &gt; 2095 and o_orderdate=&#039;1992-07-01&#039;
and o_orderkey=l_orderkey and p_partkey=l_partkey;

这个查询是寻找发生在1992-07-01 并且零售价格高于2095的orderkeys.

通过 Extended Keys, 这个查询可以通过下面的计划执行:

扫描i_p_retailprice索引获得p_retailprice>2095的行，再从 extended keys中读取p_partkey（主键）的值。 对于每一个p_partkey的值，通过对lineitem表的i_l_partkey索引扫描，从 extended index中获取l_orderkey（主键）。 对于每一个被选中的l_orderkey值，再通过i_o_orderdate索引去查找o_orderkey（主键）的值。 这种访问方式所有的访问数据都没有回表，所以性能好的多。

下面是执行计划:

MariaDB [dbt3sf10]&gt; explain
-&gt; select o_orderkey
-&gt;   from part, lineitem, orders
-&gt;   where p_retailprice &gt; 2095 and o_orderdate=&#039;1992-07-01&#039;
-&gt;         and o_orderkey=l_orderkey and p_partkey=l_partkey\G
*************************** 1\. row ***************************
id: 1
select_type: SIMPLE
table: part
type: range
possible_keys: PRIMARY,i_p_retailprice
key: i_p_retailprice
key_len: 9
ref: NULL
rows: 100
Extra: Using where; Using index
*************************** 2\. row ***************************
id: 1
select_type: SIMPLE
table: lineitem
type: ref
possible_keys: PRIMARY,i_l_suppkey_partkey,i_l_partkey,i_l_orderkey,i_l_orderkey_quantity
key: i_l_partkey
key_len: 5
ref: dbt3sf10.part.p_partkey
rows: 15
Extra: Using index
*************************** 3\. row ***************************
id: 1
select_type: SIMPLE
table: orders
type: ref
possible_keys: PRIMARY,i_o_orderdate
key: i_o_orderdate
key_len: 8
ref: const,dbt3sf10.lineitem.l_orderkey
rows: 1
Extra: Using index
3 rows in set (0.00 sec)

  

    

		

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
