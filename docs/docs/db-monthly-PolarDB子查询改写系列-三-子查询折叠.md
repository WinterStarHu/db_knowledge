# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/01/01/
> 分类: 

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
	

  

    
数据库内核月报 － 2024 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB子查询改写系列（三）子查询折叠
                      

                    

                    

                  
                      

                        MySQL 权限管理
                      

                    

                    

                  
                      

                        MySQL 深潜 - 直方图采样优化
                      

                    

 
        

    

  

    
 PolarDB子查询改写系列（三）子查询折叠  

    
 Author: 陈江(恬泰）  

  

  

  
背景

一个逻辑运算符析取合取式(Item_cond)下如果有多个子查询，可以尝试对这多个子查询进行折叠，折叠成1个或者改写为true、false。 显而易见可以大大加速sql执行。

注：该功能在PolarDB 8.02.2.22 版本中， 默认在ro上开启，在rw上开启需设置如下参数

set subquery_coalesce_mode=on; // 开启折叠，默认只执行启发式折叠
set subquery_coalesce=on; // 开启基于代价折叠，折叠会增加新算子，大部分场景是个better plan，但并不总是
// 如果开启了cbqt，会忽略这个开关，基于代价进行枚举。

规则生效场景：

  
折叠的对象可以出现在where， having， join on条件的任何位置上。做到应消尽消。

  
子查询可以是Exists, IN子查询， ALL/ALL子查询

  
算子可以是正值， 负值运算，如in /not in， exists/not exists。

  
父亲逻辑算子可以是and， 可以是or

改写规则

同类型消除

SELECT * FROM t1 WHERE EXISTS (SELECT 1 FROM t2 WHERE c2 = 0)  --子查询1
	AND EXISTS (SELECT 1 FROM t2) 		              --子查询2
==》
SELECT * FROM t1 WHERE EXISTS (SELECT 1 FROM t2 WHERE c2 = 0)

*注：

子查询1是子查询2的子集，子查询2直接消除掉

or条件下：

SELECT * FROM t1 WHERE EXIST (SELECT 1 FROM t2 WHERE c2 = 0)  --子查询1
	or EXIST (SELECT 1 FROM t2) 		              --子查询2
==》
SELECT * FROM t1 WHERE EXISTs (SELECT 1 FROM t2)

*注： or条件下改写为 false or EXISTs (SELECT 1 FROM t2), 保留大集合

同类型子查询合并

select * from t1 where exists (select t1.a as f from t1 where a >10 and b < 10)
or exists (select a from t1 where a > 10  and c <3);
=>
select * from t1 where exists (select t1.a as f from t1 where a >10 and (b < 10 or c <3);

也可以是and_cond表达式

select * from t1 where not exists (select t1.a as f from t1 where a >10 and b < 10)
and not exists (select a from t1 where a > 10  and c <3);
=>
select * from t1 where not exists (select t1.a as f from t1 where a >10 and (b < 10 or c <3);

互斥类型子查询消除

exists冲突 //消除子查询，改写为false

场景：

  
exists VS not exists

  
in VS not in

SELECT * FROM t1 WHERE EXISTs (SELECT 1 FROM t2 WHERE c1 = 0)  --子查询1
      AND NOT EXISTs (SELECT 1 FROM t2) 		--子查询2
==>
SELECT * FROM t1 WHERE false

any/all 冲突 //SQL2

场景：

  

>any vs <all、<=all

  

<any vs >all, >=all

    

SELECT * FROM t1 WHERE t1.c1 > any (SELECT c1 FROM t2 where c1 > 100) and
t1.c1 < all (select c1 from t2 where  c1 > 10)
==>
SELECT * FROM t1 WHERE false; //any 是all 子集

    

    
Item_or下的消除

    

SELECT * FROM t1 WHERE EXISTs (SELECT 1 FROM t2 )  --子查询1
    or NOT EXISTs (SELECT 1 FROM t2 WHERE c1 = 0) 		--子查询2
==>
SELECT * FROM t1 WHERE true

    

    
互斥exists子查询合并 //SQL3

    

SELECT * FROM t1 WHERE EXIST (SELECT 1 FROM t2) 	    --子查询1
   AND NOT EXIST (SELECT 1 FROM t2 WHERE c2 = 0)      --子查询2
=>
SELECT * FROM t1 WHERE EXIST (SELECT 1 FROM t2 having sum (case when extra_cond 1 else 0) ==0) 

    

    
注：

  

  
增加 为having sum (case when extra_cond 1 else 0) ==0

  
并不总是最优的，基于代价选择是否进行折叠，如确认改写较优，开启subquery_coalesce参数。

  
tpch Q21 热数据测试对比如下

  

    

      
sql/耗时（64dop)

      
折叠（增加sum算子）

      
不折叠(semijoin执行）

    

  

  

    

      
Q21

      
3 min 50 sec

      
2 min 49.45 sec

    

  

any/all合并 //SQL4

场景：只支持in/not in子查询

  
in vs not in  并且 (not in集合更小，是左侧子集）

  
= any vs != all 并且 (all集合更小，是左侧子集）
    

SELECT * FROM t1 WHERE t1.c1 = any (SELECT c1 FROM t2 where c1 > 10) and
t1.c1 != all (select c1 from t2 where  c1 > 100)
==>
SELECT * FROM t1 WHERE t1.c1 = 
any (SELECT c1 FROM t2 where c1 > 10 and LNNVL(c1 >100));

    

    
注：
该plan也是基于代价进行改写的，通常都是改写更优。

  

or 条件下合并

SELECT * FROM t1 WHERE t1.c1 = any (SELECT c1 FROM t2 ) or
t1.c1 != all (select c1 from t2 where  c1 > 100)
==>
SELECT * FROM t1 WHERE 1;

结语

PolarDB子查询折叠基本上是能转尽转，可以折叠在where条件， join on条件， having条件内部的任何冗余子查询，
能大大加速SQL执行。

  

    

		

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
