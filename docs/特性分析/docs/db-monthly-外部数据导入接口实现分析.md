# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/05/05/
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
	

  

    
数据库内核月报 － 2016 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 基于InnoDB的物理复制实现
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MySQL 5.7新特性系列一
                      

                    

                    

                  
                      

                        PostgreSQL · 特性分析 · 逻辑结构和权限体系
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · innodb buffer pool相关特性
                      

                    

                    

                  
                      

                        PG&GP · 特性分析 · 外部数据导入接口实现分析
                      

                    

                    

                  
                      

                        SQLServer · 最佳实践 · 透明数据加密在SQLServer的应用
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 日志子系统和崩溃恢复过程
                      

                    

                    

                  
                      

                        MongoDB · 特性分析 · Sharded cluster架构原理
                      

                    

                    

                  
                      

                        PostgreSQL · 特性分析 · 统计信息计算方法
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · left-join多表导致crash
                      

                    

 
        

    

  

    
 PG&GP · 特性分析 · 外部数据导入接口实现分析  

    
 Author: 义从  

  

  

  
背景

社区 PostgreSQL 和 GreenPlum 都提供了读写外部数据源的方法，它们都提供了一套编程接口，用户可以在这上面做二次开发，建立外部数据源和数据库间的数据通道。
本文介绍 PostgreSQL 和 GreenPlum 这部分编程接口的实现和编程方法。结合 RDS 开发的 oss_ext 接口。展示外部数据源接口的能力。

PostgreSQL FDW

FDW 的全称是 foreign-data wrapper，是一套读写外部数据源的编程接口。它提供了多个回调函数编程接口，开发者可以逐一实现这些接口，封装成动态库，然后加载到内核中使用。
下面逐一介绍下这套编程接口

1 扫描类接口

  

    
GetForeignRelSize_function GetForeignRelSize;

    
返回给数据库对应数据源的规模信息

  

  

    
GetForeignPaths_function GetForeignPaths;

    
优化器接口，提供对应数据源的查询路径。

  

  

    
GetForeignPlan_function GetForeignPlan;

    
优化器接口，提供对应数据源的查询计划。

  

  

    
BeginForeignScan_function BeginForeignScan;

    
执行器接口，外部表扫描开始的准备工作。

  

  

    
IterateForeignScan_function IterateForeignScan;

    
执行器接口，外部表扫描实现，一次返回一个 tuple slot。

  

  

    
ReScanForeignScan_function ReScanForeignScan;

    
执行器接口，外部表扫描节点重新开始，重置所有状态参数和内存结构。

  

  

    
EndForeignScan_function EndForeignScan;

    
执行器接口，外部表扫描节点结束，释放资源。

  

2 更新数据接口

  

    
AddForeignUpdateTargets_function AddForeignUpdateTargets;

    
构造要更新的外部数据源的目标列信息

  

  

    
PlanForeignModify_function PlanForeignModify;

    
构造外部数据源修改的（包括insert update delete的）的数据结构

  

  

    
BeginForeignModify_function BeginForeignModify;

    
执行器接口，数据更新节点的数据准备

  

  

    
ExecForeignInsert_function ExecForeignInsert;

    
执行器接口，insert 一行数据

  

  

    
ExecForeignUpdate_function ExecForeignUpdate;

    
执行器接口，update 一行数据

  

  

    
ExecForeignDelete_function ExecForeignDelete;

    
执行器接口，delete 一行数据

  

  

    
EndForeignModify_function EndForeignModify;

    
执行器接口，修改结束，释放相关资源

  

  

    
IsForeignRelUpdatable_function IsForeignRelUpdatable;

    
执行器接口，修改结束，释放相关资源

  

3 查询计划展示接口

  

    
ExplainForeignScan_function ExplainForeignScan;

    
展示扫描节点的相关信息

  

  

    
ExplainForeignModify_function ExplainForeignModify;

    
展示修改数据节点的相关信息

  

4 外部数据源统计信息接口

  

    
AnalyzeForeignTable_function AnalyzeForeignTable;

    
分析外部数据的数据分布状况接口

  

总结

  
用户可以根据需求实现他们，如只需要读取数据，则不用实现第二部分；

  
除了支持读取数据相关接口，还支持了对统计信息的接入。这样，PostgreSQL 真正的把外部数据源当作了“表”。考虑到了数据的规模，使得优化器合理的规划了外部表的执行路径。和执行阶段执行器深度结合。整套接口设计清晰分工明确；

  
这套接口的实现可以参考已经实现的 
PostgreSQL_FDW
。

GreenPlum external table

GreenPlum external table 和 PostgreSQL FDW 的区别

GreenPlum external table 在实现上和 PostgreSQL FDW 完全不同，有自己的特点：

  
GreenPlum 只提供了两个对外的接口 readfunc 和 writefunc；

  
GreenPlum external table 接口和内核交互的的内容是数据块，而 PostgreSQL FDW 是 tuple slot。
也就是说，通过 PostgreSQL FDW 需要把外部数据源做完整的行列解析，而 GreenPlum external table 则不同；

  
最大的不同 GreenPlum external table 执行过程中是驱动 segment 工作，可以通过这个接口让所有 segment 同时并行工作并行读写数据，大大提高了整个集群的性能；

  
GreenPlum external table 没有像 PostgreSQL FDW 那样的读取统计信息，并提供给优化器的接口，在复杂查询场景下使用 GreenPlum external table 可能查询计划不是最优的；

GreenPlum external table 接口

  

    
readfunc

    
按数据块读取数据

  

  

    
writefunc

    
按数据块写数据

  

从 oss 读取数据

基于上述编程接口，我们开发了一套用于从 oss 导入数据到 GreenPlum 和 PostgreSQL 的插件，性能杠杠的。帮助云上用户更好的使用 RDS 数据库产品。

从 oss 导入数据到 GreenPlum 

  

    

		

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
