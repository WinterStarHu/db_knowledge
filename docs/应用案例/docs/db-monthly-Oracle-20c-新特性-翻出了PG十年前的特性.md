# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/10/10/
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
	

  

    
数据库内核月报 － 2019 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb 表空间
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · POLARDB 并行查询加速全程详解
                      

                    

                    

                  
                      

                        MySQL · Optimizer · Parallel Index Scans, One is Better Than Two
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · X-Engine MySQL RDS 用户的新选择
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Sequence Engine
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 分组提交的使用与注意
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · Spark Connector 实战指南
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 12 tpcc - use sysbench-tpcc by Percona-Lab
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  阿里云RDS PG 11开放dblink, postgres_fdw权限
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · Oracle 20c 新特性 - 翻出了PG十年前的特性
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · Oracle 20c 新特性 - 翻出了PG十年前的特性  

    
 Author: digoal  

  

  

  
背景

熟悉PG的小伙伴一定知道，PG每年都会发布一个大版本，已经坚持了24年，每个大版本都有非常大的进步，这在软件行业都是非常罕见的，所以PG蝉联了2017，2018两届dbengine年度数据库，同时在2019年继linux后荣获OSCON 终身成就奖。

PG大版本特征矩阵：

https://www.postgresql.org/about/featurematrix/

近些年，Oracle也开始和PG一样每年都在发版本。今年oow发布了20c，我们看一下20c支持了那些特性：可以参考盖老师发布的如下文档

https://www.modb.pro/db/7242?from=timeline&isappinstalled=0

实际上在Oracle发布的新特性里面，有大多数特性在PG内核或扩展模块已经支持(主要原因是PG的架构非常灵活，可以很方便的开发扩展功能，同时允许被商业或非商业的形式使用)：

《PostgreSQL Oracle 兼容性 - Oracle 19c 新特性在PostgreSQL中的使用》

《PostgreSQL 覆盖 Oracle 18c 重大新特性》

来看一下20C里面PG有哪些是已经覆盖的功能呢？

1. 原生的区块链支持 - Native Blockchain Tables

这个特性在PG 中的支持方法

https://github.com/postgrespro/pg_credereum

2. 持久化内存存储支持 - Persistent Memory Store

3. SQL的宏支持 - SQL Macro

这个特性在PG 中的支持方法

https://github.com/postgrespro/pg_variables

4. SQL新特性和函数扩展 - Extensions

在分析计算中，20c 提供了两种新的分布聚类算法，偏态 - SKEWNESS、峰度 - KURTOSIS，通过这两个算法，可以对给定数据进行更丰富的分布计算，新特性支持物化视图，遵循和方差（VARIANCE）相同的语义。

新的位运算符也被引入，20c 中支持的新的位运算包括：BIT_AND_AGG、BIT_OR_AGG、BIT_XOR_AGG 。

这个特性在PG 中的支持方法

https://pgxn.org/dist/aggs_for_arrays/

https://www.postgresql.org/docs/12/functions-aggregate.html

5. 自动化的In-Memory 管理 - Self-Managing In-Memory

In-Memory 技术引入之后，为Oracle数据库带来了基于内存的列式存储能力，支持 OLTP 和 OLAP 混合的计算。

6. 广泛的机器学习算法和AutoML支持

在Oracle 20c中，更多的机器学习算法被加入进来，实现了更广泛的机器学习算法支持。

极限梯度助推树  - eXtreme Gradient Boosting  Trees(XGBoost) 的数据库实现，以及各种算法，如分类（Classification）、回归(regression)、排行(ranking)、生存分析(survial  analysitic)等；

MSET-SPRT 支持传感器、物联网数据源的异常检测等，非线性、非参数异常检测ML技术；

这个特性在PG 中的支持方法

https://pivotal.io/cn/madlib

7. 多租户细粒度资源模型 - New Resource Modeling Scheme

在20c之前,多租户的数据库管理是服务驱动的，通过服务来决定PDB的资源放置，PDB的开启也是通过服务来进行隐式驱动的。

在集群环境中，这就存在一个问题，PDB 可能被放置在某个资源紧张的服务器上，服务驱动的模型并不完善。

在 20c 中，Oracle 引入了细粒度的资源模型，将负载和 PDB 的重要性等引入管理视角。例如，用户可以通过Cardinality 和 Rank 定义，改变 PDB 的优先级，在数据库启动时，优先打开优先级别高的PDB。

这个特性在PG 中的支持方法

《PostgreSQL 多租户》

《PostgreSQL 用户、会话、业务级 资源隔离(cgroup, 进程组, pg_cgroups) - resource manage》

《PostgreSQL 商用版本EPAS(阿里云ppas(Oracle 兼容版)) HTAP功能之资源隔离管理 - CPU与刷脏资源组管理》

8. 零影响的计划停机维护 - Zero Downtime for Planned Outages

在 Oracle 不同版本的不断演进中，一直在加强数据库的可用性能力。在 20c 中，对于计划停机维护或者滚动升级等，Oracle 通过 Smart DRM 等特性以实现对应用的零影响。

对于维护操作，数据库可以在实例关闭前进行动态的资源重分配，这一特性被称为 Smart DRM，通过GRD的动态资源重组织，重新选出的Master节点不需要进行任何的恢复和维护，对于应用做到了完全无感知、无影响。

9. In-Memory 的 Spatial 和 Text 支持

针对 Oracle 数据库内置的多模特性，地理信息 -Spatial 和 全文检索 - Text 组件，在 20c 中，通过 In-Memory 的内存特性，获得了进一步的支持。

对于空间数据，Oracle 在内存中为空间列增加空间摘要信息（仅限于内存中，无需外部存储），通过 SIMD 矢量快速过滤、替换 R-Tree 索引等手段，以加速空间数据查询检索，可以将查询速度提升10倍。

这个特性在PG 中的支持方法

暂时不支持内存特性，但是空间计算、文本搜索都是很早很早以前就支持的。

http://postgis.org/

https://github.com/postgrespro/rum

https://www.postgresql.org/docs/12/textsearch.html

https://www.postgresql.org/docs/12/indexes-types.html

10. 备库的 Result Cache 支持 - Standby Result Cache

在 Oracle 12.2 和 18c 中，已经实现了 ADG 的 会话连接保持 和 Buffer Cache保持，在 20c 中，Result Cache 在备库上进一步得以保留，以确保这个细节特性的主备性能通过。

Result Cache 特性是指，对于特定查询（例如结果集不变化的），将查询结果保留在内存中，对于反复查询（尤其是大规模聚合）的语句，其成本几乎降低为 0 。

参考

https://www.modb.pro/db/7242?from=timeline&isappinstalled=0

《PostgreSQL Oracle 兼容性 - Oracle 19c 新特性在PostgreSQL中的使用》

《PostgreSQL 覆盖 Oracle 18c 重大新特性》

  

    

		

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
