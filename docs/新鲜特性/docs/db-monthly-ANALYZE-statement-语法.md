# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/08/
> 分类: 新鲜特性

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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 MariaDB · 新鲜特性 · ANALYZE statement 语法  

    
 Author:   

  

  

  

命令的输出

MariaDB&gt; analyze select * from tbl1 where key1 between 10 and 200 and col1 like &#039;foo%&#039;\G
*************************** 1\. row ***************************
id: 1
select_type: SIMPLE
table: tbl1
type: range
possible_keys: key1
key: key1
key_len: 5
ref: NULL
rows: 181
r_rows: 181
filtered: 100.00
r_filtered: 10.50
Extra: Using index condition; Using where

我们可以看到 ANALYZE 命令多了r_rows和r_filterd两行，我们来比较一下 EXPLAIN 计算的 rows/filtered 和 ANALYZE 计算的 r_rows/r_filtered 两列的区别。

r_rows 是基于实际观察的 rows 列，它表示实际从表中读取了多少行数据。

r_filtered 是基于实际观察的 filtered 列，它表示经过应用WHERE条件之后还有百分之多少的数据剩余。

输出结果解析

让我们来看一个更复杂的SQL。

analyze select * 
from orders, customer 
where 
customer.c_custkey=orders.o_custkey and 
customer.c_acctbal &lt; 0 and 
orders.o_totalprice &gt; 200*1000

+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
| id | select_type | table    | type | possible_keys | key         | key_len | ref                | rows   | r_rows | filtered | r_filtered | Extra       |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
|  1 | SIMPLE      | customer | ALL  | PRIMARY,...   | NULL        | NULL    | NULL               | 149095 | 150000 |    18.08 |       9.13 | Using where |
|  1 | SIMPLE      | orders   | ref  | i_o_custkey   | i_o_custkey | 5       | customer.c_custkey |      7 |     10 |   100.00 |      30.03 | Using where |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+

从上面的结果，我们可以获得如下信息：

对于 customer 表，customer.rows=149095, customer.r_rows=150000. 从这两个值来看，优化器对 customer 表的访问估算还是很准确的。

customer.filtered=18.08, customer.r_filtered=9.13. 优化器有点高估了
customer
 表所匹配的记录的条数。（一般来说，当你有个全表扫描，并且 r_filtered 少于15%的时候，你得考虑为表增加相应的索引了）

orders.filtered=100, orders.r_filtered=30.03. 优化器无法预估经过条件（orders.o_totalprice > 200*1000）检查后还剩多少比例的记录。因此，优化器显示了100%。事实上，这个值是30%，通常来说30%的过滤性并不值得去建一个索引。但是对于多表Join，采集和使用列统计信息也许对查询有帮助，也可能帮助优化器选择更好的执行计划。（因为在关联中，关联条件和普通过滤条件组合以后，可能过滤性会非常好，并且有助于优化器判断哪张表做驱动表比较好）

然后我们再把前面的例子稍微修改一下

analyze select * 
from orders, customer 
where 
customer.c_custkey=orders.o_custkey and 
customer.c_acctbal &lt; -0 and customer.c_comment like &#039;%foo%&#039;
orders.o_totalprice &gt; 200*1000
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
| id | select_type | table    | type | possible_keys | key         | key_len | ref                | rows   | r_rows | filtered | r_filtered | Extra       |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+
|  1 | SIMPLE      | customer | ALL  | PRIMARY,...   | NULL        | NULL    | NULL               | 149095 | 150000 |    18.08 |       0.00 | Using where |
|  1 | SIMPLE      | orders   | ref  | i_o_custkey   | i_o_custkey | 5       | customer.c_custkey |      7 |   NULL |   100.00 |       NULL | Using where |
+----+-------------+----------+------+---------------+-------------+---------+--------------------+--------+--------+----------+------------+-------------+

这里我们可以看到 orders.r_rows=NULL，以及 orders.r_filtered=NULL。这意味着 orders 表连一次都没有被扫描到。

  

    

		

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
