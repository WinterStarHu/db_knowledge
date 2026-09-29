# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/06/09/
> 分类: performance/tuning

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
	

  

    
数据库内核月报 － 2017 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 ·  Tokudb序列化和反序列化过程
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · HTAP视角,数据与计算的生态融合
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 从节点可更新机制
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 数据库崩溃恢复（下）
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · InnoDB crash
                      

                    

                    

                  
                      

                        MSSQL · 实现分析 · SQL Server实现审计日志的方案探索
                      

                    

                    

                  
                      

                        MySQL · 源码分析  · InnoDB Repeatable Read隔离级别之大不同
                      

                    

                    

                  
                      

                        MySQL · myrocks · MyRocks之memtable切换与刷盘
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · 云上的数据迁移
                      

                    

                    

                  
                      

                        MySQL · 社区新闻 · MariaDB 10.2 GA
                      

                    

 
        

    

  

    
 PgSQL · 最佳实践 · 云上的数据迁移  

    
 Author: 义从  

  

  

  
背景

大多数使用云产品作为 IT 解决方案的客户同时使用多款云产品是一个普遍现象。
用户在多款云产品之间转移数据成为一个基础的需求。

例如

  
1. 用户把线下机房中的 Oracle 数据库中的数据 迁移到云上 RDS PPAS 中。

  
2. 使用 RDS MYSQL 做为数据库支撑交易型业务场景，同时使用 HybridDB for PostgreSQL 作数据仓库解决方案。

  
3. 把 ODPS 中的大量离线数据导入到 HybridDB for PostgreSQL 进行实时分析。

上述场景都不可避免的需要进行云上的数据迁移。本文给大家聊聊这方面的一些解决方案，希望能帮助大家用好云产品。

一：关于硬件

在开始数据迁移之前，我们要对云相关的硬件有一些了解，这往往决定了我们能做到的最好情况，有助于我们选择最终解决方案。

1. 同一可用区

如果数据在云上，且在同一可用区间进行交换，那么恭喜你，这是最有效率的数据交换方式，也是我们最推荐的场景。用户的数据应该尽量在一个可用区。

现阶段的云产品所配置的网络最差都是千兆网络，万兆已经基本普及。数据的迁移在一个可用区间经过的交换机最小，因此延迟低，带宽较大，可以最大比较理想的吞吐量。

因此，后端数据库、前端的 ECS、存在大量数据的的 OSS 都应该在选择在同一个可用区。

2. 跨可用区、城市间可用区

部分有较高可用性要求的客户，会选择同城多可用区部署，甚至跨城市部署。进一步，阿里云有很多数据产品支持原生的多可用区部署方案。

阿里云在同城或跨城市的可用区间是通过网络专线连接。在这样的网络产品中交换数据效率虽然没有再同一可用区高，但依然能保证较高的网络质量。

从网络通讯效率角度，自然是：

同可用区 > 同城多可用区间 > 跨城多可用区间

例如：

(华东一 可用区B 内部) > (华东一 可用区B 和 华东一 可用区C 间) > (华东一 可用区B 和 华北一 可用区B 间)

3. 公网和 VPN 网络

这是效率最差的情况，也是背景章节中的数据上云场景的典型。因为该场景的物理通道是公共的且不可控。往往延迟较大，且质量有较大波动。

先天不足的情况，自然需要用软件做适当的弥补，通常建议用户选取具有下列特性的服务。

  
a: 支持重试机制，支持断点续传，大任务不能由于一个异常导致整个失败。

  
b: 支持并发机制，使用大并发增大吞吐量。

  
c: 使用增量数据迁移减少服务的停机时间。

接下来聊一聊数据交换中的数据格式问题

二：关于数据格式

在不同数据产品间转移数据通常有两种方式

1. 不落地的数据迁移

软件或服务同时连接到源数据端和目的端，把数据从源端拉出来，转换成目的端识别的格式后立即写入到目的端。

该和方法不需要数据中转空间，但要求的网络质量较高。如果数据量超大，如上 TB，那么迁移时间也比较长。

阿里云开源产品 
rds_dbsync
 CDP, 云服务 DTS 都属于这类。

2. 通过通用文件格式的数据迁移

如果您的数据量较大，则建议使用离线迁移转移数据，例如几十 TB 的数仓数据。
离线迁移是把全量数据导出成一种通用的数据组织格式，再导入到目的数据库。

相比不落地数据迁移，他有这些优势

  
1）离线导出的数据通常都会进行压缩，压缩一般都在 1：2 到 1：5 之间，能较大节省网络开销，从而提升整体效率。

  
2）离线方式很容易并行化，并行是提高效率的最有效手段。

基于通用文件的数据迁移，数据文件的格式是其中的关键。文件需要明确的交代清楚数据的组织方式。

目前常用的通用文件格式有 TXT/CSV TSV ORC Parquet protobuf 等。
这里部分数据格式已经自带数据压缩，例如 ORC Parquet。 对于未压缩的格式，如 CSV 可以自由选择数据压缩格式，例如 gzip bzip2 snappy 等。

2.1 通过 TEXT/CSV 文件中转数据

  
对于结构化数据，比较理想的数据格式是 CSV，CSV 是一种通用的数据格式标准，大家可以参考资料
1
。

  
PostgreSQL CSV 参数在资料
2
中。适用于社区和阿里云的 PostgreSQL 已经 Greenplum 和 HybridDB for PostgreSQL。

  
任何符合 CSV 标准的文件都可以导入 PostgreSQL 系列产品。
    

      
PostgreSQL 推送式导入数据 
COPY

      
HybridDB for PostgreSQL 推送式写数据 
COPY

    

  

CSV 相对简单的文本格式的优势是定义了清楚的语意，用于很容易处理一些复杂的场景

  
CSV 行分割符号是 ‘\n’ 也就是换行符

  
定义 DELIMITER 用于定义列的分割符
    

      
当用户数据中包括 DELIMITER 时，则需要配合 QUOTE 参数。

      
DELIMITER 需要是单字节字符，推荐是 ‘|’，‘,’ 或一些不常出现的字符。

    

  

  
QUOTE 以列为单位包裹有特殊字符的用户数据
    

      
用户包含有特殊字符的 text 类型字符串会被 QUOTE 包裹，用于区分用户数据和 CSV 控制数据。

      
如果不必要，例如整数，数据不会被 QUOTE 包裹（优化效率）。

      
QUOTE 不能和 DELIMITER 相同，默认 QUOTE 是双引号。

      
当用户数据中包含了 QUOTE 字符，则需要设置转义字符 escape。

    

  

  
ESCAPE 特殊字符转义
    

      
转义用户数据中的和 QUOTE 相同的字符。

      
ESCAPE 默认和 QUOTE 相同，也就是双引号。

      
也支持设置成 ‘\’(MySQL 默认的转义字符)。

    

  

2.2 用 OSS 中专数据

OSS 和 AWS 的 S3 一样，是云上廉价的存储服务，它打通了几乎所有的云产品。我们推荐用户使用它来中专大容量数据。

OSS 支持跨可用区数据转储数据（跨区域复制），用户可以很高效的把大量数据转移到另一个可用区。

目前，云裳的 PostgreSQL 和 HybridDB for PostgreSQL 都支持 OSS 数据源的读写。

  
PostgreSQL + OSS 读写外部数据源 
oss_fdw

  
HybridDB for PostgreSQL + OSS 并行的导入导出数据 
oss_ext

总结

本期分享了云上和数据转移相关的几个简单技巧，希望能帮到大家用好云。我们的产品在快速迭代，也请大家多反馈问题，帮助我们进步。

参考资料

  

CSV 格式标准

  

PostgreSQL COPY

  

PostgreSQL + OSS oss_fdw

  

HybridDB for PostgreSQL COPY

  

HybridDB for PostgreSQL + OSS oss_ext

  

rds_dbsync

  

    

		

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
