# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/06/03/
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
	

  

    
数据库内核月报 － 2023 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码解析 · 并发Replace into导致死锁
                      

                    

                    

                  
                      

                        MySQL · 源码解析 · mysql 子查询执行方式介绍
                      

                    

                    

                  
                      

                        极致性价比:自研数据库PolarDB on 自研芯片倚天
                      

                    

 
        

    

  

    
 极致性价比:自研数据库PolarDB on 自研芯片倚天  

    
 Author: 劲川  

  

  

  
1. 概述

PolarDB作为阿里云自研的云原生数据库，基于存算分离的架构，具备一写多读、多活容灾、全球部署、HTAP等特性。上线五周年多以来，PolarDB已经广泛应用到了各行各业，有多篇papers发表在SIGMOD、VLDB、FAST等顶级会议上。相对应的，倚天710处理器作为阿里云自研的国产化芯片，基于新一代CIPU架构，实现了计算、存储、网络性能的数量级提升，有效应用于云原生、视频编解码、高性能计算、基于CPU的机器学习和游戏服务等场景。那么当PolarDB遇上了倚天处理器，当自研数据库碰上了自研芯片又释放出什么样的火花呢？
在开始全文前，我们回顾一下倚天处理器的独特优势。一方面，随着传统 x86 CPU的持续迭代，服务器和数据中心的功耗和成本在持续攀升，每千瓦芯片功耗在生命周期内带来上万美金的成本。另一方面，在云这类面向多租户的场景下，超线程（HT）架构的问题逐渐暴露出来，面对一些高密计算任务时很难满足业务需求，共享缓存与物理核的机制导致租户之间处理任务可能需要相互排队，导致性能大幅下降；或者互相干扰的情况导致性能波动。基于ARM架构的倚天处理器很好地解决这两个问题，独享物理核独享L1/L2 Cache，无超线程概念，在实现高性能（减少干扰）的同时实现了低功耗/低成本。
PolarDB 针对自研倚天芯片，从芯片到数据库内核全链路优化，性能相比优化前提升超50%。在 sysbench OLTP 读写混合场景下，PolarDB 倚天性能大幅领先同规格自建 MySQL 实例。

2. 全路径性能优化

为了充分发挥出自研数据库PolarDB在自研芯片倚天上的性能，PolarDB团队从芯片侧到数据库内核做了全路径的优化。用户业务和应用从x86架构数据库向倚天ECS架构数据库迁移的过程中，
业务代码改造量是零，成功实现无缝迁移
：用户只需要把数据库的连接地址，从x86架构改成PolarDB On倚天ECS的地址即可。

2.1 全栈优化

针对倚天处理器这一全新的ARM体系，PolarDB从芯片到操作系统，进行了全栈的深度优化：

  
芯片：针对数据库应用场景，调整处理器预取策略。数据库的内存访问与很多负载不同，访问模式更加随机，不适合通用的数据预取策略。在数据库场景下，过于激进的数据预取可能无法提高缓存命中率，反而会增加内存带宽的使用，并且在缓存中填充无效的数据。调整预取策略，为缓存设置合理的指令预留，给 PolarDB 倚天带来显著的性能收益。

  
网络：网络收发产生频繁的中断，导致系统态和用户态的切换。数据库对网络吞吐要求低，适当减少网卡队列的数量可以起到聚合硬件中断的效果。进一步把中断绑定到固定的核心上，可以减少状态切换造成的影响，提高数据库整体的运行效率。

  
操作系统：推进操作系统版本，使用新OS内核，充分利用新版本操作系统对倚天处理器的支持和优化。采用代码大页优化，将数据库代码段通过透明大页映射，减少 iTLB 的使用，从而减少整个系统中 TLB 资源的争抢，显著降低 iTLB miss，提升性能。此外，对数据库场景调整了CFS调度器参数，使系统能在高压力场景下合理调度数据库的线程，保证处理器资源的充分利用。

  
编译器：启用 LSE 指令拓展，使用原生的 CAS 等指令实现数据库的原子操作，优化了加锁、解锁等操作的性能，极大提高了数据库高并发场景下的性能，在高并发写场景可提供数倍的性能提升。使用更新版本的 GCC 和 glibc，充分利用新版本编译器和标准库对 arm 架构的支持和优化。启用 PGO 优化技术，使用运行时的剖析信息指导编译优化过程，针对典型的数据库场景优化，使生成的二进制在大多数场景下拥有更好的性能。启用了链接时优化技术，扩展了编译器过程间分析的范围，全局优化数据库代码。

2.2 数据库内核优化

为了获取良好的性能，PolarDB在内核层面做了深度优化。其中，尤其PolarDB在多线程扩展性方面的优化，相较于传统MySQL，在倚天等多核处理器上发挥出了明显的优势：

  
针对计算存储分离架构的全路径优化：针对分布式存储和本地存储的差异性，实现了Partition Redo / Early Lock Release / Parallel Redo Apply / Lock-Less Flush / Multi-Queue AIO等全路径优化，显著降低了IO延迟对数据库性能的影响，提升了多核场景下的性能，感兴趣的读者可以查阅我们发表在VLDB’22的文章(
Cloudjump
)；

  
高性能索引 PolarIndex：实现了Btree在做SMO操作时不持有Index锁，从而支持多个SMO操作并发执行，明显提升了高并发更新/插入场景下的性能（
文档
）；

  
弹性并行查询 Elastic Parallel Query：针对云上用户实例CPU资源利用率较低、使用不均衡的特征，充分挖掘集群中多核CPU的并行处理能力，明显提升了单条大查询的处理效率（
用户文档
）；

  
并行DDL：针对大表DDL慢的问题，将DDL全过程拆分成多个子任务，利用多核能力并行加速DDL的执行，线性降低DDL的延迟（
用户文档
）；

  
事务系统优化：优化了高并发场景下活跃事务列表拷贝的瓶颈，明显提升了多核场景下的性能（
用户文档
）；

  
原子操作/内存屏障调优：相比于X86架构，ARM架构场景下是weak memory order，PolarDB内核团队优化了原子操作和相关屏障级别，降低并发场景下的系统性能损耗；

  
新指令支持：使用 arm 架构原生 CRC32 指令，硬件加速内核 CRC 计算，显著降低计算校验码的热点；
    

      
线程优先级/内核参数调优：针对倚天处理器的具体性能特征，调整了内核IO线程的优先级，细粒度调优了内核各类参数。

    

  

3. 测试结果

3.1 测试结果说明

通过对 sysbench OLTP 读写、只读和只写三种场景和 IO bound 、CPU bound 两种数据量下的压测，在每种场景和每个连接数下取压测结果QPS平均值统计，得到结果：

  
读写场景：CPU bound 测试中，Polar 倚天实例性能超过自建实例 90%；IO bound 测试中，Polar 倚天实例性能超过自建实例 80%

  
只读场景：CPU bound 测试中，Polar 倚天实例性能超过自建实例 110%；IO bound 测试中，Polar 倚天实例性能超过自建实例 100%

  
只写场景：CPU bound 测试中，Polar 倚天实例性能超过自建实例 100%；IO bound 测试中，Polar 倚天实例性能超过自建实例 50%

3.2 测试环境

  
实例规格

开箱测试，购买阿里云 PolarDB 标准版单节点倚天独享实例，并应用高性能参数模版（
文档
）。

  

    

      
架构

      
规格

      
存储

      
版本

      
CPU

    

  

  

    

      
阿里云 PolarDB 倚天

      
8c64g 独享实例

      
2T PL3 ESSD

      
8.0

      
倚天710

    

    

      
自建 MySQL 实例

      
8c64g

      
2T PL3 ESSD

      
8.0.28

      
倚天710

    

    

      
友商

      
8c64g

      
-

      
-

      
友商最新一代 CPU

    

  

  
测试参数
    

      
sysbench 1.0.20

      
CPU bound：10表 10000000行，约 24G 数据

      
IO bound：10表 40000000行，约 100G 数据

      
–rand-type=uniform

    

  

3.3 测试方法

# 准备数据
sysbench --db-driver=mysql --mysql-host=XXX --mysql-port=XXX --mysql-user=XXX --mysql-password=XXX --mysql-db=sbtest --table_size=40000000 --tables=10 --threads={1~512} oltp_read_write prepare

# 运行workload
# OLTP读写混合
sysbench --db-driver=mysql --mysql-host=XXX --mysql-port=XXX --mysql-user=XXX --mysql-password=XXX --mysql-db=sbtest --table_size=40000000 --rand-type=uniform --tables=10 --time=300 --threads={1~512} --report-interval=20 oltp_read_write run

# OLTP只读场景
sysbench --db-driver=mysql --mysql-host=XXX --mysql-port=XXX --mysql-user=XXX --mysql-password=XXX --mysql-db=sbtest --table_size=40000000 --rand-type=uniform --tables=10 --time=300 --threads={1~512} --report-interval=20 oltp_read_only run

# OLTP只写场景
sysbench --db-driver=mysql --mysql-host=XXX --mysql-port=XXX --mysql-user=XXX --mysql-password=XXX --mysql-db=sbtest --table_size=40000000 --rand-type=uniform --tables=10 --time=300 --threads={1~512} --report-interval=20 oltp_write_only run

# 清理数据
sysbench --db-driver=mysql --mysql-host=XXX --mysql-port=XXX --mysql-user=XXX --mysql-password=XXX --mysql-db=sbtest --table_size=40000000 --tables=10 --time=300 --threads={1~512} oltp_read_write/oltp_read_only/oltp_write_only cleanup

3.4 测试场景

CPU bound

读写场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
4426.39

      
4128.2

      
1,324.09

    

    

      
8

      
33223.57

      
28883.37

      
9,002.77

    

    

      
32

      
101381.29

      
59096.67

      
31,897.51

    

    

      
64

      
123323.59

      
61423.14

      
52,195.38

    

    

      
128

      
127590.64

      
67676.93

      
60,150.13

    

    

      
256

      
126259.29

      
65720.02

      
63,824.66

    

  

只读场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
2852.27

      
3135.17

      
1,492.69

    

    

      
8

      
28484.43

      
25144.96

      
11,605.65

    

    

      
32

      
98798.32

      
57178.22

      
43,683.58

    

    

      
64

      
114452.7

      
54767.44

      
80,841.04

    

    

      
128

      
115784.14

      
54730.61

      
96,171.27

    

    

      
256

      
124524.72

      
54019.85

      
97,759.58

    

  

只写场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
4741.59

      
4337.84

      
885.65

    

    

      
8

      
34759.83

      
31551.92

      
5,783.46

    

    

      
32

      
111183.7

      
79577.7

      
17,806.85

    

    

      
64

      
152742.18

      
85337.53

      
28,969.75

    

    

      
128

      
162261.84

      
83357.96

      
40,193.94

    

    

      
256

      
163423.91

      
81871.44

      
55,503.42

    

  

IO bound

读写场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
2325.18

      
2092.71

      
597.64

    

    

      
8

      
17848.08

      
16368.19

      
4,682.18

    

    

      
32

      
57849.13

      
37585.66

      
17,764.87

    

    

      
64

      
73375.52

      
40402.29

      
28,490.83

    

    

      
128

      
77419.21

      
44263.56

      
32,767.81

    

    

      
256

      
79618.95

      
41929.5

      
19,559.31

    

  

只读场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
2410.35

      
3113.29

      
667.55

    

    

      
8

      
18843.19

      
20459.12

      
5,399.64

    

    

      
32

      
64589.47

      
39944.8

      
21,008.63

    

    

      
64

      
84735.63

      
42712.68

      
35,479.36

    

    

      
128

      
90899.32

      
45699.65

      
41,595.30

    

    

      
256

      
91140.13

      
45245.97

      
42,600.34

    

  

只写场景

  

    

      
连接数

      
PolarDB 倚天

      
arm 自建

      
友商

    

  

  

    

      
1

      
3117.42

      
2284.61

      
540.05

    

    

      
8

      
22494.84

      
17690.3

      
3,491.79

    

    

      
32

      
65236.36

      
53808.61

      
14,829.89

    

    

      
64

      
82618.09

      
58923.72

      
21,072.20

    

    

      
128

      
84813.77

      
58975.09

      
33,459.10

    

    

      
256

      
87070.76

      
57020.43

      
25,615.59

    

  

4. 总结

PolarDB on 倚天充分发挥自研数据库和自研芯片的优势，性能大幅超越自建 MySQL arm 实例，相比同规格 PolarDB x86 实例降价最高可达 45%，零适配成本提升性价比，助力用户降本增效。

5. 参考文档

  
CloudJump: Optimizing Cloud Databases for Cloud Storages (VLDB’22)

https://www.vldb.org/pvldb/vol15/p3432-chen.pdf

  
PolarDB 倚天ARM版正式上线

https://cn.aliyun.com/activity/database/polardb_arm

  

    

		

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
