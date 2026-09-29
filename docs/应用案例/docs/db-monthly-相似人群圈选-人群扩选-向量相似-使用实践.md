# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/10/10/
> 分类: 应用案例

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
	

  

    
数据库内核月报 － 2018 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 最佳实践 · POLARDB不得不知道的秘密
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Cost Model,直方图及优化器开销优化
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 使用混合密钥实现列加密
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · 复制集原理
                      

                    

                    

                  
                      

                        Redis · lazyfree · 大key删除的福音
                      

                    

                    

                  
                      

                        Database · 理论基础 · 数据库事务隔离发展历史
                      

                    

                    

                  
                      

                        Database · 理论基础 · 关于一致性协议和分布式锁
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Level Compact 分析
                      

                    

                    

                  
                      

                        MySQL · RocksDB · TransactionDB 介绍
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 相似人群圈选，人群扩选，向量相似 使用实践
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · 相似人群圈选，人群扩选，向量相似 使用实践  

    
 Author: digoal  

  

  

  
背景

PostgreSQL 相似插件非常多，插件的功能以及用法如下：

《PostgreSQL 相似搜索插件介绍大汇总 (cube,rum,pg_trgm,smlar,imgsmlr,pg_similarity) (rum,gin,gist)》

相似人群分析在精准营销，推荐系统中的需求很多。

人的属性可以使用向量来表达，每个值代表一个属性的权重值，通过向量相似，可以得到一群相似的人群。

例如

create table tt (  
  uid int8 primary key,  
  att1 float4,  -- 属性1 的权重值   
  att2 float4,  -- 属性2 的权重值  
  att3 float4,  -- 属性3 的权重值  
  ...  
  attn float4   -- 属性n 的权重值  
);  

使用cube表示属性

create table tt (  
  uid int8 primary key,  
  att cube  -- 属性  
);  

使用cube或imgsmlr可以达到类似的目的。

a <-> b float8  Euclidean distance between a and b.  
a <#> b float8  Taxicab (L-1 metric) distance between a and b.  
a <=> b float8  Chebyshev (L-inf metric) distance between a and b.  

但是如果向量很大(比如属性很多)，建议使用一些方法抽象出典型的特征值，压缩向量。  类似图层，图片压缩。实际上imgsmlr就是这么做的：

例如256
256的像素，压缩成4
4的像素，存储为特征值。

例子

1、创建插件

create extension cube;  

2、创建测试表

create table tt (id int , c1 cube);  

3、创建GIST索引

create index idx_tt_1 on tt using gist(c1);  

4、创建生成随机CUBE的函数

create or replace function gen_rand_cube(int,int) returns cube as $$  
  select ('('||string_agg((random()*$2)::text, ',')||')')::cube from generate_series(1,$1);  
$$ language sql strict;  

5、CUBE最多存100个维度

postgres=# \set VERBOSITY verbose  
  
postgres=# select gen_rand_cube(1000,10);  
  
ERROR:  22P02: invalid input syntax for cube  
DETAIL:  A cube cannot have more than 100 dimensions.  
CONTEXT:  SQL function "gen_rand_cube" statement 1  
LOCATION:  cube_yyparse, cubeparse.y:111  

6、写入测试数据

insert into tt select id, gen_rand_cube(16, 10) from generate_series(1,10000) t(id);  

7、通过单个特征值CUBE查询相似人群，以点搜群

select * from tt order by c1 <-> '(1,2,3,4,5,6,7)' limit x;  -- 个体搜群体  

8、通过多个特征值CUBE查询相似人群，以群搜群

select * from tt order by c1 <-> '[(1,2,3,4,5,6,7),(1,3,4,5,6,71,3), ...]' limit x; -- 群体搜群体  

postgres=# explain select * from tt order by c1 <-> '[(1,2,3),(2,3,4)]' limit 1;  
                                QUERY PLAN                                  
--------------------------------------------------------------------------  
 Limit  (cost=0.11..0.14 rows=1 width=44)  
   ->  Index Scan using idx_tt_1 on tt  (cost=0.11..0.16 rows=2 width=44)  
         Order By: (c1 <-> '(1, 2, 3),(2, 3, 4)'::cube)  
(3 rows)  

9、如果需要再计算压缩前的特征值的相似性，可以使用原始值再计算一遍。

《PostgreSQL 遗传学应用 - 矩阵相似距离计算 (欧式距离,…XX距离)》

select *,   
  c1 <-> ?1,   -- c1表示压缩后的特征值浮点数向量，比如（4*4）  
  distance_udf(detail_c1,?2)   -- deatil_c1 表示原始特征值浮点数向量(比如128*128)    
from tt order by c1 <-> ?1 limit xx;  

参考

https://www.postgresql.org/docs/devel/static/cube.html

https://github.com/postgrespro/imgsmlr

https://github.com/eulerto/pg_similarity

《PostgreSQL 相似搜索插件介绍大汇总 (cube,rum,pg_trgm,smlar,imgsmlr,pg_similarity) (rum,gin,gist)》

《PostgreSQL 11 相似图像搜索插件 imgsmlr 性能测试与优化 3 - citus 8机128shard (4亿图像)》

《PostgreSQL 11 相似图像搜索插件 imgsmlr 性能测试与优化 2 - 单机分区表 (dblink 异步调用并行) (4亿图像)》

《PostgreSQL 11 相似图像搜索插件 imgsmlr 性能测试与优化 1 - 单机单表 (4亿图像)》

  

    

		

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
