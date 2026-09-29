# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/08/05/
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
	

  

    
数据库内核月报 － 2024 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PostgreSQL 插入常量的合法性检查
                      

                    

                    

                  
                      

                        PostgreSQL MemoryContext 标准实现解读
                      

                    

                    

                  
                      

                        pg_repack 插件原理解读
                      

                    

                    

                  
                      

                        PostgreSQL blink-tree implement notes
                      

                    

                    

                  
                      

                        PolarStore弹性内存池（EMP）
                      

                    

 
        

    

  

    
 PolarStore弹性内存池（EMP）  

    
 Author: zhiyi  

  

  

  
本文介绍了PolarStore的弹性内存池（Elastic Memory Pool，简称 EMP）技术，结合高速网络和智能缓存，大幅降低数据读取延迟，提升PolarDB在I/O密集型负载下的性能表现。

背景介绍

PolarStore为PolarDB提供低延迟、高吞吐量的高性能数据存储服务。作为数据库的核心组成部分，PolarStore负责将数据从存储层高效地读取到数据库内存，这在I/O密集型负载场景下至关重要。为了进一步提升性能，PolarStore基于PolarDB三层解耦架构的优势，推出了弹性内存池（Elastic Memory Pool，简称 EMP）功能。EMP利用分布式高速RDMA网络和高速介质，智能缓存热点数据，无需您感知或适配。在EMP的加持下，PolarStore数据读取延迟最高可降低5倍，显著提升PolarDB整体性能，在 I/O密集型负载下吞吐量提升可达90%。

EMP功能介绍

功能简介

数据库的缓存池（Buffer Pool）是内存中用于缓存磁盘数据的区域。当需要访问数据时，先从Buffer Pool中读取，若数据在Buffer Pool未命中，则需要从底层存储中获取数据，相比内存访问，IO操作会增加网络和读盘延迟，这将直接影响数据库的性能。因为单台主机的内存限制，单个数据库集群Buffer Pool的大小非常有限。

为了解决这个问题，PolarStore的EMP功能应运而生。EMP利用RDMA高速网络，将存储集群中的内存和持久性内存等高速介质高效整合，组成一个可扩展的内存池。EMP能够智能识别数据库的热点数据，并将其缓存在内存池中，实现数据的高速访问。在EMP加持下，PolarStore 16KB粒度随机读IO延迟可低至25us，最多降低至原有延迟的1/5，并且远低于业界典型本地盘NVME SSD的80~90us的延迟，显著提升了PolarDB的性能。

PolarDB集群支持动态启用和关闭EMP，且操作过程不会影响数据库集群运行，无需中断或阻塞数据库集群运行。

核心优势

  

    

无损提升读IO性能，读延迟降低5倍

    
EMP由分布式存储集群中大量存储节点中的内存或持久性内存等高速介质组成，每个节点会识别热点数据并缓存在本地EMP中。EMP无需PolarDB实例消耗用户宝贵的计算或内存资源，无论IO是否直接在EMP缓存命中，PolarDB都不会产生多余的IO请求。当读访问命中EMP缓存时，数据直接从EMP返回，实现极低的访问延迟；未命中时，不会增加额外开销，数据访问性能不受影响。因此，EMP可以无损提升读IO性能。

  

  

    

一写多读共享内存池

    
PolarDB是基于共享存储的一写多读架构，EMP基于此架构实现，支持一写多读。RW和RO同样共享EMP缓存，所有RO的访问都能够加速，加速效果不受RO个数的限制，并且PolarDB集群没有缓存一致性的开销成本。在节点故障切换、集群扩展等场景下，新的主节点或新扩展只读节点能够无缝衔接使用EMP中共享的热数据，从而更快地完成冷节点到热节点的切换，缩小业务侧的响应时间（RT）上升时间窗口，保障业务运行稳定性。

  

  

    

弹性扩展EMP空间，智能识别并均衡分布热点数据

    
PolarStore是由多个存储节点构成的分布式存储资源池，每个存储节点上都包含EMP可用的内存或持久性内存等资源，因此EMP资源池支持随存储节点扩展而弹性扩展。EMP是存储集群级别的内存池，可以给单个PolarDB集群提供多达数十TB的缓存空间。得益于和PolarDB紧密结合的IO请求全链路标记能力，EMP能够根据数据库的不同IO类型等特征，智能识别集群的读热点，针对性地优化提升集群的读IO缓存命中率，最大化地利用资源提升集群性能。 比如：针对Binlog或Redo log等文件的类流式顺序访问、IBD数据文件的随机读写访问等分别针对性的进行优化。同时EMP会自动识别存储节点流量热点并进行负载均衡调度，充分利用分布式能力，弹性扩展EMP。

  

性能测试

  

    
测试方式：同一个规格的集群，对比开启EMP功能前后的QPS性能。

  

  

    
测试工具：Sysbench和TPC-H。

  

  

    
测试场景：

    

      

        
OLTP基本场景read_only、write_only、read_write。

      

      

        
TPC-H基准测试。

      

      

        
数据库典型场景：

        

          

            
game_blob：selete, update。

            
场景特点：大blob的读写，频繁访问和更新大型字段更容易导致读写IO瓶颈。

          

          

            
数据库大查询性能测试。

            
场景特点：对时延敏感的主键顺序Scan和二级索引回表等场景。

          

          

            
数据库重启测试。

            
场景特点：数据库升级、升配、重启场景都会产生大量的读IO用来恢复数据库，读延迟直接影响数据库的恢复速度。

          

        

      

    

  

  

    
测试集群规格：测试8C 64 GB的集群，对比EMP打开前后的性能。

  

  

    

      

系列

      

存储类型

      

规格代码

      

CPU和内存

    

  

  

    

      

集群版独享规格

      

PSL5

      

polar.mysql.x8.xlarge

      

8C 64 GB

    

  

OLTP测试

测试配置

  

    
数据量：32张数据表，每张表7000万行数据，约540 GB数据。

  

  

    
工具：Sysbench基准测试程序oltp_read_only、oltp_write_only、oltp_read_write。

  

  

    
测试方法：

    

      

        
oltp_read_only负载（只读）：

        

sysbench oltp_read_only 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 prepare
sysbench oltp_read_only 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 run

        

      

      

        
oltp_write_only负载（只写）：

        

sysbench oltp_write_only 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 prepare
sysbench oltp_write_only 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 run

        

      

      

        
oltp_read_write负载（读写混合）：

        

sysbench oltp_read_write 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 prepare
sysbench oltp_read_write 
--tables

=
32 
--table_size

=
70000000 
--threads

=
32 
--rand-type

=
uniform 
--time

=
120 run

        

      

    

  

测试结果

三种不同负载的测试结果如下：

  
oltp_read_only性能：开启EMP后，QPS提升可达50%。

  
oltp_write_only性能：开启EMP后，QPS提升可达30%。

  
oltp_read_write性能：开启EMP后，QPS提升可达46%，随着压力的增加，瓶颈在CPU的限制。

TPC-H测试

TPC-H是业界常用的一套基准，由TPC委员会制定发布，用于评测数据库的分析型查询能力。TPC-H查询包含8张数据表、22条复杂的SQL查询，大多数查询包含若干表Join、子查询和Group by等聚合。

说明

本文的TPC-H的实现基于TPC-H的基准测试，并不能与已发布的TPC-H基准测试结果相比较，本文中的测试并不符合TPC-H基准测试的所有要求。

测试配置

  
测试方法：对比EMP开启前后TPC-H负载中每个query执行时间。

  
数据大小：100 GB。

测试结果

选取其中几个典型的query进行对比，EMP功能开启后，耗时降低35%~55%。

数据库典型场景测试

游戏blob

说明

在数据库中，我们常常使用BLOB（Binary Large Object）来存储大块的二进制数据，例如图片、视频等。当这些BLOB数据非常庞大，例如每行数据达到512 KB甚至更大时，我们就称之为“大BLOB场景”。

在大BLOB场景下，频繁地访问和更新这些大字段会对数据库造成巨大的读写压力，容易导致I/O瓶颈，进而影响数据库整体性能。

测试配置

  

    
测试数据量：64张数据表，每张表15000行数据，blob长度为512 KB，约520 GB数据。

  

  

    
测试场景：大blob select、update。

  

  

    
测试工具：Sysbench基准测试程序game_blob_update。

  

  

    
测试集群规格：测试8C 64 GB的集群，对比EMP打开前后的性能。

  

  

    
测试方式：

    

      

        
game_blob_update selects（只读）。

        

sysbench game_blob_update 
--tables

=
64 
--table_size

=
15000 
--threads

=
32 
--rand-type

=
uniform 
--blob_length

=
524288 
--time

=
120 
--selects

=
1 run

        

      

      

        
game_blob_update updates（读写混合）。

        

sysbench game_blob_update 
--tables

=
64 
--table_size

=
15000 
--threads

=
32 
--rand-type

=
uniform 
--blob_length

=
524288 
--time

=
120 
--selects

=
1 run

        

      

    

  

测试结果

  

    
测试结果如下：

    

      

        
game_blob select性能：开启EMP后，QPS提升高达90%。

      

      

        
game_blob update性能：开启EMP后，QPS提升可达52%。

        

      

    

  

大数据量查询

测试配置

  

    
测试数据量：表大小为1 GB、10 GB、100 GB。

  

  

    
测试方法：测试对时延敏感的主键顺序Scan和二级索引回表。

    

      

        
Scan主键。

        

SELECT
 
COUNT

(

*

)
 
FROM
 
sbtest1
 
FORCE
 
INDEX

(

PRIMARY

);

        

      

      

        
Scan二级索引回表。

        

SELECT
 
MAX

(

pad

)
 
FROM
 
sbtest1
 
FORCE
 
INDEX

(

k_1

);

        

      

    

  

测试结果

  
测试结果如下：
    

      
冷数据场景下Scan主键获得100%左右的速度提升。

      
Scan二级索引回表获得95%以上的速度提升。

    

  

数据库重启

测试配置

  
测试方法：Sysbench准备数据后，调整刷脏参数使刷脏变慢，插入数据过程中重启数据库进程，统计重启恢复时间。对比开启EMP前后的恢复时间。

  
数据量：240 GB，重启时Redo数据量6 GB。

测试结果

  

    
测试结果如下：

    

      

        
重启总耗时获得25%的速度提升。

      

      

        
重启总耗时包括Scan Redo和Apply Page两个阶段，Apply阶段速度提升78%。

        

      

    

  

相关链接

  
产品文档：https://help.aliyun.com/zh/polardb/polardb-for-mysql/user-guide/polarstore-elastic-memory-pool-emp?spm=a2c4g.11186623.0.i4

  
邀测文档：https://help.aliyun.com/zh/polardb/polardb-for-mysql/invited-test-polarstore-elastic-memory-pool?spm=a2c4g.11186623.0.i21

  

    

		

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
