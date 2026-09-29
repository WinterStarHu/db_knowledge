# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/10/05/
> 分类: 架构分析

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
	

  

    
数据库内核月报 － 2017 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PgSQL · 特性分析 · MVCC机制浅析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· CloudDBA SQL优化建议之统计信息获取
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB mini transation
                      

                    

                    

                  
                      

                        MySQL · 特性介绍 · 一些流行引擎存储格式简介
                      

                    

                    

                  
                      

                        MSSQL · 架构分析 · 从SQL Server 2017发布看SQL Server架构的演变
                      

                    

                    

                  
                      

                        MySQL · 引擎介绍 · Sphinx源码剖析(三)
                      

                    

                    

                  
                      

                        PgSQL · 内核开发 · 如何管理你的 PostgreSQL 插件
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 数据一样checksum不一样
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 经营、销售分析系统DB设计之共享充电宝
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 信号处理机制分析
                      

                    

 
        

    

  

    
 MSSQL · 架构分析 · 从SQL Server 2017发布看SQL Server架构的演变  

    
 Author: 风移  

  

  

  
摘要

美国时间2017年10月2日，微软正式发布了最新一代可以运行在Linux平台的数据库SQL Server 2017。SQL Server 2017给用户带来了一系列的新功能特性的同时，也体现了微软关于自家关系型数据库平台建设方面的最新设计与思考。这篇文章旨在介绍SQL Server 2017新特性，以及微软是如何从架构层面的演进来快速实现Linux平台的SQL Server 2017产品。

SQL Server 2017发布

早在2016年，当微软宣布SQL Server将很快在Linux上运行时，这一消息对用户、权威人士以及SQL Server从业者来说都是一个巨大的惊喜。果然，微软不负众望，在美国时间2017年10月2日，正式发布了最新一代可以运行在Linux平台的数据库SQL Server 2017。近年来随着各类NoSQL数据库产品和Hadoop生态的出现与流行，给了传统关系型数据库（RDBMS）带来了巨大的挑战。从微软提供Linux版SQL Server这件事情，我们可以诡探出微软大的战略转型：变得更加开放、包容和拥抱变化，而不是像以前一样与自家的微软系列生态系统紧密的捆绑在一起。微软的这种良性转变，对用户和SQL Server数据库从业者来说也是巨大的福音。因此，可以说SQL Server与Linux相爱了，SQL Server 2017就是他们爱的结晶。

SQL Server 2017新特性简介

微软对于新一代数据库产品SQL Server 2017的发布，植入了非常多的新特性和看点，重要包括：

对Linux平台的支持：当然最大的特性是对Linux平台的支持。

对容器类产品Docker的支持：对容器类产品的支持。

内置图数据库：将图数据库功能内置到SQL Server引擎中。

内置机器学习功能：对Python语言的支持，大大扩展了机器学习功能特性。

自适应查询处理：全新的Batch Model查询语句执行方式，边执行便优化。

支持Linux平台

SQL Server 2017对Linux平台的支持，是它最大的看点和进步，说明微软拥抱变化的决心初现成果。SQL Server 2017支持的Linux平台包括：

RedHat Enterprise Linux (RHEL)

SUSE Enterprise Linux (SLES)

Ubuntu

[1]:SQL Server 2017对Linux平台的支持

支持容器化

SQL Server 2017除了支持这些常见的开源Linux平台外，还支持将SQL Server服务跑在容器中，这一点对于需要将SQL Server服务进行容器化管理的用户来讲，非常便利。SQL Server支持的容器产品包括：

Windows Container：微软自家亲儿子，是不遗余力的毫无疑问支持。

Linux Docker：目前最为火爆的容器技术，当然也是支持的。

内置图数据库

SQL Server 2017中内置了关于图数据的查询功能，使得图数据的查询变得简单而高效。

2
:SQL Server 2017内置图数据库的功能

内置机器学习

SQL Server 2017中提供了R语言和Python语言的支持，用户可以利用列存技术和内存优化表存储基础数据，然后利用Python语言本身关于机器学习的天然优势，来实现深置于数据库系统内部的机器学习，实时分析，及时决策的目的。

[1]:SQL Server 2017提供机器学习功能

自适应查询处理

针对于SQL Server Batch Model Processing查询语句，SQL Server 2017引入了自适应查询处理机制，使得查询更加高效。简单的讲就是一边处理查询一边进行优化的策略，而不是传统的根据统计信息首先生成执行计划。这样可以应对很多因为统计信息过时或者统计信息片面导致的执行计划不准确的，而影响查询性能的场景。

SQL Server架构演进

按照以往微软对SQL Server数据库产品的发布节奏，一般情况下是两年一个大版本更新迭代，比如SQL Server 2012，2014和2016。但是，SQL Server 2017的发布仅仅只用了一年时间，而且实现了Linux版本SQL Server的巨大转变，并且所有功能和Windows版本对齐。很多用户和从业者对这一点都非常好奇，微软到底是如何做到这一点的？要回答这个问题，我们从SQL Server底层的架构演进来分析这个问题的答案。总结来看，到SQL Server 2017的出现，微软对数据库底层架构的演进经历了以下几个阶段：

使用Windows对SQL Server系统进行资源管理：这个阶段没有一个特定的名称叫法，这个阶段的SQL Server服务无法突破Windows内核对资源的限制。

SQL OS阶段：为了使得SQL Server数据库拥有更好的性能，SQL OS（也叫SOS）出现了。

Drawbridge的出现：研究性项目，用于实现应用的沙盒（Sandbox），最开始不是为SQL Server专门设计的，但在SQL Server 2017中扮演中非常重要的角色。

SQL PAL的出现：SQL Server 2017整合了SQL OS和Drawbridge，进行底层封装，形成了SQL PAL层。

SQL Server 2005之前

追述到SQL Server 2005版本之前（SQL Server 2000及更早版本），SQL Server服务是以一个用户态进程运行在Windows操作系统中，这个服务进程与其他普通的进程没有任何差异，它依赖于操作系统内核对底层硬件资源进行管理和交互，SQL Server服务本身没有对系统资源的管理能力。具体的架构图大致如下所示：

3
:SQL Server 2005之前的底层架构图

这个架构最大的缺点是SQL Server服务本身无法突破Windows内核对系统资源使用的限制，换话句话说SQL Server无法榨干系统硬件资源，加之缺乏对操作系统资源的控制能力，只能依赖于操作系统内核对底层硬件资源进行调度，因此SQL Server服务很难最大限度充分利用系统所有硬件资源，阻碍了SQL Server系统性能的进一步提升。

SQL OS

为了解决上面的问题和获取更好的性能，微软花了很大的力气来抽象一个中间层对系统硬件资源进行调度和管理，并发布在SQL Server 2005版本中，也因此SQL Server 2005版本经历了长达5年的时间才得以面世。这个对硬件资源进行集中调度和管理的中间层叫着SQL OS（也叫着SOS）。SQL OS的主要职责包括：Processor Scheduling，Memory Management，Network，Disk I/O使得SQL Server性能最大化（可以使得SQL Server用户进程最大限度的充分利用操作系统硬件资源）。SQL Server 2005引入了SQL OS后的底层架构图如下所示：

SQL Server 2005赋予了SQL OS非常全面的资源管理功能，涉及到数据库系统核心功能的方方面面，具体包括：

Deadlock Monitor：死锁监控

Resource Monitor：资源监控

Lazy Writer：延迟写，将随机I/O写，转化为顺序I/O写

Scheduler Monitor：调度器监控

Buffer Pool：缓存池

Memory Manager：内存管理

Scheduling：调度

Synchronization Service：同步服务

Lock Manager：锁管理器

I/O：I/O资源管理

详细架构如下图SQLOS API部分所示：

有了SQL OS层次的抽象，得以在数据库内部实现对系统资源的集中管理，摆脱系统内核对SQL Server资源使用的限制，使得SQL Server服务队系统资源有了很强的控制能力，SQL Server 2005性能有了大幅的提升，成了微软关系型数据库历史上划时代的版本，也为SQL Server 2017能够提供跨平台能力提供了可能性，可以毫不夸张的说，没有SQL OS的出现，微软不可能在如此短的时间内实现Linux版的SQL Server。

Drawbridge

微软研究院在2011年9月建立了一个全新的研究性项目，名称叫Drawbridge，目的是提供应用程序新的虚拟化资源隔离解决方案，减少虚拟资源的使用，使得在同一个硬件主机上，可以运行更多的虚拟机（类似于Docker产品对硬件资源的管理）。Drawbridge其中一个非常重要的组件Library OS仅依靠约50个底层内核应用二进制接口（ABI：Application Binary Interface）实现了一千多个常用的Windows API，同时还具备了为其他组件提供宿主的能力，比如：MSXML和CLR等组件。 在Windows 10版本中存在着Drawbridge的大量应用。

3
:引入Drawbridge后的系统架构

SQL PAL

SQL Server数据库团队基于Drawbridge项目与SQL OS两者进行了必要的重写和充分的融合，形成了新一代数据库底层抽象和封装，叫SQL PAL （Platform Abstract Layer），同时将上层逻辑代码移植到SQL PAL之上。如此，微软只需要确保SQL PAL层可以在Windows平台和Linux平台运行良好即可。这样SQL Server即使运行在Linux平台，也无需修改SQL Server本身的代码，SQL Server自己本身与平台无关。能做到这一点完全是由Drawbridge中的ABI（Application Binary Interface）来达到目的的，这些ABI我们叫着Host Extension，所以为了支持SQL Server 2017的跨平台特性，微软只需要实现基于Windows平台的Host Extension和Linux平台的Host Extension，这样做最大的好处是：

大大缩短开发周期：微软无需对SQL Server本身做任何的代码修改就可以将SQL Server移植到Linux平台。

产品功能一贯性：对SQL Server新功能、新特性的支持，无需对两个平台进行重复开发，Windows平台支持了，Linux平台也就支持了，保持了产品功能的一致性。

良好的后期维护性：假如SQL Server存在某个Bug，只需要修复SQL Server本身，那么Windows平台，Linux平台上相应的Bug也同样被修复掉了，具备良好的可维护性。

以上架构图是比较宏观的层面展示，以下是SQL PAL功能更为详细的描述架构图：

[1]:SQL PAL详细架构图

从这张图，我们可以清晰的看到SQL PAL层次对于Host Extension的调用，以及构建在这层次之上的SQL Server服务，包括：数据库引擎、集成服务、分析服务和报表服务。

SQL PAL性能影响

提到SQL PAL对SQL Server 2017数据库服务的影响，很多用户最为担忧的应该就是性能的影响了。请不要担心，根据TPC-H测试来看，SQL Server 2017相对于SQL Server 2016来看，性能不但没有任何损失，反而性能不降反升。

TPC-H性能测试

从TPC-H测试数据总结来看，相对于SQL Server 2016来看，不论是性能和性价比，都有小幅提升，如下截图：

[1]: SQL Server 2017 TPC-H性能比较

附带TPC官网公布的性能数据截图：

微软内部测试

以下展示微软内部测试实例，在拥有一台12 TB内存，480个逻辑CPUs的机器上，处理30 TB，2500亿条数据的8个字段的3种类型复杂统计汇总查询，耗时仅用18秒。由此可见，性能还是相当强劲的，截图留恋：

总结

本篇文章介绍了SQL Server 2017支持Linux平台，支持容器化，内置图数据库，内置机器学习和自适应查询处理的功能新特性；同时从底层架构演进的层面分析了微软能够在短时间内实现Linux版SQL Server 2017的根本原因是SQL PAL架构中间层的出现，而SQL PAL是站在SQL OS和Drawbridge的肩膀之上的。由此可见，微软对SQL Server支持Linux平台在SQL Server 2005版本中已经开始布局，应该说还是非常具有远见的。

备注

1：图片来自于微软Lindsey Allen的培训“SQL Server 2017 - Power your entire data estate from on-premises to cloud”截图。

2：图片来自于吴晓晨在云栖大会上关于“SQL Server 2017”的分享。

3：图片来自于“Everything you need to know about SQL Server 2017”截图。

4：截图来自于《Inside Microsoft SQL Server 2005_ The Storage Engine, 2005 Edition》Components of the SQL Server Engine章节。

  

    

		

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
