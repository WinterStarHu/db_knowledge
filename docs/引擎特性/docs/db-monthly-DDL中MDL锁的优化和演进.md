# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/05/02/
> 分类: 引擎特性

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
	

  

    
数据库内核月报 － 2023 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码解析 · InnoDB中undo日志的组织及实现
                      

                    

                    

                  
                      

                        PolarDB ·引擎特性· DDL中MDL锁的优化和演进
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 鉴权过程
                      

                    

                    

                  
                      

                        PolarDB·引擎特性·PolarDB IMCI中的行列融合执行
                      

                    

                    

                  
                      

                        PolarDB MySQL · 功能特性 · Cube, grouping sets功能介绍与实现
                      

                    

 
        

    

  

    
 PolarDB ·引擎特性· DDL中MDL锁的优化和演进  

    
 Author: saimu  

  

  

  
摘要

DDL是数据库所有SQL操作中最繁重的一种，本文总结介绍了PolarDB中DDL全链路MDL锁治理的经验和进展，持续优化用户的使用体验，为用户打造最佳的云原生关系型数据库。

1. 概述

在日常数据库操作中，用户总是谈DDL色变，原因在于总是担心DDL的执行会影响业务SQL，这里面最核心的因素在于DDL持有的MDL表锁导致的锁堵塞问题。另一方面，由于DDL类型众多，用户难以区分不同类型DDL的锁行为，无法判断执行DDL可能导致的后果，这进一步加剧了该问题的复杂度。通过多年大量线上实例的经验积累， 我们非常理解用户在面对这类MDL锁问题时的困惑。本文整理总结了PolarDB MySQL内核团队在全链路MDL锁治理这块的经验和进展，鞭策我们为“DDL无锁”、为用户可以毫无担忧地执行DDL而持续努力。针对MDL锁相关的背景知识，我们有持续的内核月报在介绍这方面的原理，感兴趣的读者可以自行查询 
常用SQL语句的MDL加锁及源码分析
和 
MDL锁实现分析
。在开始全文前，我们首先回顾用户主要关注哪些方面的DDL锁问题：

  

1.什么时候拿锁

很不幸的是，无论是MySQL内核原生的DDL，还是各种第三方插件（gh-ost、pt-osc，以及云厂商们的“无锁变更”），几乎所有的DDL都会申请表级别的MDL互斥锁。这里的核心原因在于：DDL的目标是表结构/表定义变更，它必然会修改元数据/字典信息，因此DDL依赖MDL锁来完成元信息、文件操作和相应缓存信息的正确更新。当DDL修改元数据时，它申请表级别的MDL互斥锁，从而堵塞并发的元数据查询/修改操作，继而可以线程安全地更新元信息缓存，从而保证所有线程用正确版本的元数据解析对应版本的表数据。

说到这里，很多熟悉MySQL的读者一定会问，那为什么gh-ost等第三方插件在做DDL时似乎呈现出一种类似“无锁”的表现呢？其实这里的核心差别在于，MySQL内核和第三方插件，在处理“拿不到锁”这个问题时采用了完全不一样的策略。

  

2.拿不到锁会导致什么问题（雪崩 vs. 饥饿，本文关注的核心问题）

相比于第三方插件，MySQL内核的MDL拿锁机制简单粗暴：当DDL申请MDL-X（互斥锁）时，如果目标表存在未提交的长事务或大查询，DDL将持续等待获取MDL-X锁。由于MDL-X锁具有最高的优先级，DDL在等待MDL-X锁的过程中将阻塞目标表上所有的新事务，这将导致业务连接的堆积和阻塞，继而可能带来整个业务系统「
雪崩
」的严重后果。

为了避免这个问题，MySQL社区开发了很多外部工具，比如pt-osc和github的gh-ost。它们均采用拷表方式实现，即创建一个空的新表，通过select + insert的方式拷贝存量数据，然后通过触发器或者binlog的方式拷贝增量数据，最后通过rename操作切换新表和旧表。云厂商的各种工具，例如DMS的无锁变更也与这些外部工具原理类似。但很遗憾，这种方式也存在明显的劣势：1. 可能由于大事务/大查询的存在，DDL持续拿不到锁，持续等待直到反复失败（「
饥饿
」）；2. 不管是Instant DDL（例如秒级加列），还是仅增加二级索引，第三方工具都无脑选择了全表重建的方式，通过大幅牺牲性能来追求稳定性。我们之前的测试表明（
月报链接
），相比于内核原生的DDL执行方式（INSTANT / INPLACE / COPY），gh-ost有着10倍甚至几个数量级的性能下降，这在数据量快速增长的今天是完全无法忍受的。

不管是第三方插件，还是MySQL内核，很遗憾，任何一种方式都不能在所有场景里都达到最优。PolarDB-MySQL内核团队尝试在保留最佳性能的前提下，同时解决雪崩和饥饿这两个问题。

  

3.拿到锁又会导致什么问题（持有锁的时间，Fast DDL会在以后的文章中介绍）

在解决了「拿不到锁」的问题后，我们同样要解决「拿到锁后」会有什么问题，即如果互斥锁持有时间过久，同样会导致业务堆积雪崩等问题。熟悉MySQL的用户都知道，MySQL有三种DDL类型，分别是「INSTANT DDL」、「INPLACE DDL」和「COPY DDL」。其中，Online DDL（用户常说的“非锁表”DDL，包括INSTANT DDL和绝大多数INPLACE DDL）在执行DDL期间绝大多数时刻并不锁表，只在修改元数据时短暂持有表的MDL-X锁（持有时间一般秒级），用户体验良好。当前的MySQL 8.0，已经实现了常见高频DDL的Online能力，例如增加索引、秒级加列，加减主键等等。但是，因为涉及一些SQL层的操作，目前依然存在COPY类型的DDL，它在执行DDL期间「全程锁表」（只能读不能写），例如修改表的字符集、修改列类型等操作。针对这类COPY DDL，PolarDB MySQL的解决方案是扩展Online DDL（不锁表）的范围，例如支持Instant Modify Column（秒级修改列类型），例如尝试在SQL层支持所有DDL的Online能力，我们将这类能力统称为「
Fast DDL
」，笔者后续会统一介绍这方面的工作，本文不再赘述。

相比于MySQL，PolarDB的集群架构使得这一问题变得更加复杂：MDL锁不仅要关注单个节点，更要关注集群多个节点/集群同步链路上的锁问题，需要集群维度的全链路解决方案。熟悉MySQL的用户，对基于Binlog的MySQL主备集群一定非常熟悉。在依赖Binlog的MySQL主备复制集群上，主备节点是逻辑隔离的。也就是说，主节点的MDL锁行为，并不会对备节点的MDL锁有任何影响，因此MySQL只需要考虑单个节点的MDL锁问题。然而，PolarDB MySQL是基于共享存储的架构。以一写多读集群为例，写节点和多个只读节点共享同一个分布式存储，依赖物理复制完成不同节点之间的数据同步。写节点在做DDL操作时，多个只读节点都会看到DDL过程中的实时数据。因此，PolarDB的MDL表锁，是一个集群维度的分布式锁，需要考虑多节点上的锁堵塞问题。

​       基于PolarDB的架构特征，结合多年的线上运维经验，我们认为从集群维度看，要实现用户体验良好的DDL锁机制，需要达到以下几个目标：

  

    

      
解决
雪崩
问题。不管是RW写节点上的大事务/大查询，还是只读节点集群上任何一个节点的大事务/大查询，抑或是RW->RO物理复制链路上任何可能的堵塞点，都可能导致DDL拿不到锁，从而触发业务雪崩。针对这类问题，PolarDB MySQL在去年发布了
Non-Block DDL
功能（
用户文档
，
月报链接
），可以保证即使在无法获得MDL-X锁的情况下，依然允许新事务访问目标表，从而保证整个业务系统的稳定。该功能受到了很多客户的欢迎，多个客户认为这个功能是执行DDL的刚需能力；

    

  

  

    

      
解决
饥饿
问题。Non-Block DDL在拿不到锁时，通过Retry等方式避免DML的堆积和雪崩。然而如果存在大事务或者大查询，DDL可能一直拿不到锁而持续失败。进一步的，随着PolarDB MySQL的大客户越来越多，单实例不乏10+个只读节点的用户，这大大增加了集群维度出现大查询/大事务的概率，导致DDL拿不到锁。针对这类问题，PolarDB MySQL最近推出了
Preemptive DDL
能力（
用户文档
），即赋予DDL最高的MDL锁权限，在满足条件的情况下主动kill堵塞它的事务/查询，保证DDL的顺利执行；

    

  

  

    

      
解决表「数据变更」、「元信息/元信息缓存变更」和「文件操作」 这三者之间的
数据一致性
和
实时性
问题。众所周知，TP数据库对事务的要求极高，而DDL过程中涉及的数据变更、表结构变更和文件操作这三者之间需要在任何一个时间点都要满足Consistency的要求。而在基于共享存储的PolarDB MySQL中，这一问题变得更加复杂：不仅在所有阶段（正常数据同步、数据库Recovery、按时间点还原等等）需要满足多节点在数据变更、表结构变更和文件操作这三者的一致性要求，而且需要保证良好的性能，满足强实时性的要求。针对这类问题，PolarDB MySQL做了一系列的优化，由于这部分内容要求的数据库背景和对代码的理解要求过高，并且用户业务无需感知，本文不展开介绍这一部分的工作；

    

  

  

    

      
解决DDL过程中RW->RO
物理复制链路
的堵塞问题。上线五年以来，PolarDB MySQL支持了大量行业，不同行业的业务场景对DDL的要求是不同，具体表现在：1. 高频DDL导致的高性能MDL锁需求，例如SAAS等行业场景，DDL是个非常常见和高频的操作。PolarDB需要避免分布式MDL锁和物理复制的耦合性，避免因为锁堵塞等行为影响整个集群的数据同步；2. DDL伴随高负载的业务压力，例如在大压力场景下加索引。这种场景会产生大量的redo日志，PolarDB需要保证DDL过程下物理复制链路的稳定性、低延迟。针对上述问题，PolarDB MySQL在物理复制全链路做了优化（
用户文档
)，采用了异步线程池和反馈机制，解耦了MDL锁同步和物理复制的强耦合性，并优化了DDL过程中redo日志的同步&复制速度（
用户文档
)，满足了大压力DDL场景下的同步要求；

    

  

  

    

      

持续演进的能力：DDL & DML MVCC
。如前文所述，在极限情况下，用户依然需要手动执行Preemptive DDL来解决饥饿问题。我们一直在想，有没有更理想的方式，用户可以完全无感知MDL锁的存在。熟悉InnoDB的读者一定知道，InnoDB提供了行级别的MVCC能力，即使修改某行数据的事务没有提交，这时候另一个事务查询同一行数据时，事务根据它的时间戳，通过undo list构建出对应的版本，无需等待锁的释放。细心的读者一定会问，为什么DDL没有提供DDL和DML互不堵塞这种MVCC的能力？原因在于，DDL操作涉及了文件操作/表数据/元信息/表结构缓存等多种信息的变更，因此为了达到DDL & DML的MVCC能力，涉及大量的模块/代码修改，带来的代码切口过大，稳定性风险较高。但是为了满足客户的诉求，PolarDB内核团队一直在这条路径上试图找到工程上的最优路径。在PolarDB 802的下个版本中，我们将提供给用户这一实验室功能，即满足Instant Add Column这种高频DDL与DML的「MVCC」能力，后续我们会陆续支持Add Index等高频DDL与DML的MVCC能力。

    

  

2. Non-Block DDL (雪崩问题)

2.1 功能概述

如前文所述，非阻塞DDL（
用户文档
，
月报链接
）用于解决因MDL锁堵塞而导致的业务雪崩问题。非阻塞DDL功能采用了和第三方插件（gh-ost、pt-osc）类似的拿锁逻辑：当DDL操作获取MDL锁失败时，拿锁线程会进入短暂的Sleep阶段，接着重新尝试获取MDL锁。通过此种方式，非阻塞DDL保证了DDL执行过程中，业务真正的online。非阻塞DDL目前已经灰度一段时间，受到大量用户的欢迎，后面会尝试默认开启此功能。此外，我们将在8.0.2的2.2.15版本中，支持集群维度的Non-Block DDL：如果主节点已经获取MDL锁，但是只读节点同步MDL锁堵塞（当前默认堵塞时间为50s，由参数loose_replica_lock_wait_timeout控制），Non-Block DDL会在集群维度重试拿锁的操作，从而实现集群维度的非阻塞DDL。

2.2 测试效果

可以通过设置参数loose_polar_nonblock_ddl_mode为ON来打开非阻塞DDL功能（
用户文档
），下面给出使用sysbench模拟用户业务，对比开启Non-Block DDL功能和使用原生DDL功能对业务的影响。

  
在目标表sbtest1上开启一个事务但不提交，该事务将持有目标表sbtest1的MDL锁。

begin

;

select
 
*
 
from
 
sbtest1

;

  
在新会话中，分别在开启和关闭Non-Block DDL情况下，对表sbtest1进行加列操作，观察TPS的变化情况。

#
 
由于当前

session
 
1

大查询持有

MDL

锁，当前

DDL

无法获取

MDL

锁，被堵塞

alter
 
table
 
sbtest1
 
add
 
column
 
d
 
int

;

  
关闭Non-Block DDL功能

​      TPS持续跌零，默认超时时间为31536000，严重影响用户业务。

  
开启Non-Block DDL功能

TPS周期性下降，但未跌零。对用户业务影响较小，能保证业务系统的稳定。

3. Preemptive DDL （饥饿问题）

3.1 功能概述

上文非阻塞DDL解决了DDL获取MDL锁阻塞导致的业务雪崩问题，但是如果DDL迟迟无法获取MDL锁，会导致DDL执行频繁失败。目前线上值班偶尔会遇到由于RO上面存在大查询、长事务导致的DDL执行失败问题，并返回错误ERROR 8007 (HY000): Fail to get MDL on replica during DDL synchronize。由于此报错与PolarDB共享存储的架构相关，与传统MySQL不一致，用户经常会一头雾水，无从下手。当前已有官方文档（
执行DDL操作提示“获取不到MDL锁”
）介绍这类问题的解决方案，用户可以根据此文档找到只读节点上持有表MDL锁的事务，手动进行Kill，来保证DDL同步MDL锁的成功。但是这种方式在部分场景下依然非常晦涩，一方面用户进行kill操作的时间窗口有限（当前同步MDL锁超时时间为50秒，可通过loose_replica_lock_wait_timeout进行调整），另一方面随着PolarDB上面客户不断增多，出现了许多10+个只读节点的集群，手动kill操作显得狼狈且低效，为此我们提供了抢占式DDL功能。

当只读节点通过物理复制，解析到当前表上有DDL操作时，只读节点会尝试获取表的MDL锁。如果此时表上存在大查询或长事务时，开启Preemptive DDL后（
用户文档
），如果只读节点在预期时间内无法获得MDL锁，便会尝试kill掉占有MDL锁的线程，从而保证MDL锁同步的成功，解决DDL的饥饿问题。

3.2 测试效果

可以通过设置参数loose_polar_support_mdl_sync_preemption为ON来打开抢占式DDL功能，下面给出DDL同步MDL锁被只读节点长事务堵塞时，开启和关闭抢占式DDL的实验效果。

  
关闭抢占式DDL功能

  
在只读节点上查询test.t1：

mysql

>
 
use
 
test

Database
 
changed

#

大查询，执行

100

s

mysql

>
 
select
 
sleep

(

100

)
 
from
 
t1

;

  
在主节点进行加列操作，被block，执行失败：

mysql
 
>
 
alter
 
table
 
t1
 
add
 
column
 
c
 
int

;

ERROR
 
8007
 
(

HY000

):
 
Fail
 
to
 
get
 
MDL
 
on
 
replica
 
during
 
DDL
 
synchronize

由于只读节点存在大查询，同步MDL锁失败，DDL执行失败，并回滚。

  
开启抢占式DDL功能

  
在只读节点上查询test.t1：

mysql

>
 
use
 
test

Database
 
changed

#

大查询，执行

100

s

mysql

>
 
select
 
sleep

(

100

)
 
from
 
t1

;

  
在主节点进行加列操作操作，被block，等待一段时间，发生抢占，执行成功：

mysql

>
 
alter
 
table
 
t1
 
add
 
column
 
c
 
int

;

Query
 
OK

,
 
0
 
rows
 
affected
 
(

11

.

13
 
sec

)

Records

:
 
0
  
Duplicates

:
 
0
  
Warnings

:
 
0

开启抢占式DDL功能后，加列操作完成，同时可以看到只读节点（右图），大查询连接已经断开。

4. 多版本DD：DDL & DML的MVCC能力

4.1 功能概述

不管是Non-Block DDL还是Preemptive DDL，都是在有互斥锁的场景下，尽可能最优地满足用户的DDL变更需求。然而，用户在部分场景下依然要感知MDL锁的存在，例如在极限场景下，用户依然需要手动触发Preemptive DDL，来解决DDL饥饿的问题。我们一直在探索，是否可以实现DDL与DML更细粒度的并发控制，类似于InnoDB MVCC能力。然而，如前文所述，DDL是个复杂操作，其执行过程涉及文件操作/表数据变更/元信息变更/表缓存处理等一系列流程。因此，考虑到MySQL代码的强耦合性，我们对这一目标做了切分，在控制代码切口和稳定性风险的情况下，逐步支持这一能力。在第一阶段，我们优先支持线上高频DDL与DML的MVCC能力，即按照statement维度，满足Instant Add Column与DML的MVCC能力（用户文档待新版本802上线）。为了兼容MySQL的默认表现，我们不仅支持DDL和未提交事务的并发，而且支持DD的readview，使得跨越了DDL的DML事务可以选择以RC或者RR的隔离级别读取表结构信息，从而让用户自行决定使用新或者旧的表定义。

4.2 测试效果

具体的效果如下：

  

    
步骤一：开启会话A，创建一个新的表t1并插入一些数据；随后开启一个新事务，在事务中进行数据的插入和更新操作，但事务不提交：

    

  

  

    
步骤二（
DDL不会被未提交的事务所堵塞
）：开启一个新的会话B，查询performance_schema，此时t1的MDL正被会话A中未提交的事务持有。进行DDL操作（add column），该操作可以立即完成，而不会被未提交的事务阻塞。

  

  

    
步骤三（
跨DDL的事务可以选择访问表时使用的隔离级别
）：回到第一个会话A，将表访问的隔离级别参数table_def_isolation设置REPEATABLE-READ，因为DDL的执行在该事务之后，因此新增的列c不可见，该事务将始终看到与事务开始时一致的表定义。
将table_def_isolation设置为READ-COMMITTED，因为DDL已经提交，列c将对该事务可见

  

  

    
提交事务后，DD的readview随之释放，随后将只能看到最新的表结构。

  

5. 全链路优化的分布式MDL锁（多节点数据同步问题）

目前的云原生数据库，不论是PolarDB，或者是Aurora等其它厂商的数据库，都以“存算分离”+“共享存储”的形态提供一写多读的能力。对这类架构感兴趣的读者，可以阅读我们之前的相关月报（
PolarDB 物理复制解读
，
PolarDB 物理复制热点页优化
）。对这类针对存算分离场景下IO优化感兴趣的读者，可以阅读我们去年发表在VLDB上的相关论文（
CloudJump: Optimizing Cloud Databases for Cloud Storages
）。简单来说，云原生数据库依赖物理复制（Redo日志）完成不同节点之间的数据同步，而DDL触发的元数据/表数据/文件变更同样随着物理复制完成多节点的同步，这三者之间依赖分布式MDL锁提供 实时&一致性 的保证。然而，当MDL锁和物理复制相耦合时，会产生一系列的问题，尤其是日志流 / 锁同步 / 文件操作这三者之间的一致性问题。这里，我们介绍与用户密切相关的两类问题：

5.1 异步元数据锁同步

高频DDL场景下分布式MDL锁的稳定性&实时性。尤其是在MDL锁被堵塞时，不能影响正常物理日志的进行。为了解决这个问题，PolarDB设计了全新的分布式MDL锁机制（
用户文档
，已默认开启），主要体现在以下两个方面：

  
异步MDL锁复制：将分布式MDL锁与物理复制相互解耦，实现了即使在等待MDL锁时，只读节点仍能继续解析并应用物理日志，保证了物理复制的实时性；

  
并行MDL锁：为了优化高频DDL场景下分布式MDL锁的性能，我们采用一组线程池来并发响应MDL锁的需求。即使某个MDL锁被堵塞，也不会影响其它线程去获取MDL锁，并且这部分线程池会随着DDL的情况动态调整，保证了MDL锁同步的高并发。

5.2 DDL物理复制优化

高压力DDL场景下物理复制的稳定性&实时性。PolarDB中的数据是通过B-Tree来维护索引的，然而大部分Slow DDL操作（如增加主键或二级索引、Optimize Table等）往往需要重建或新增B-Tree索引，导致大量物理日志的产生。而针对物理日志进行的操作往往出现在DDL执行的关键路径上，增加了DDL操作的执行时间。此外，物理复制技术要求只读节点解析和应用这些新生成的物理日志，DDL操作而产生的大量物理日志可能严重影响只读节点的日志同步进程，甚至导致只读节点不可用等问题。 针对上述问题，PolarDB提供了DDL物理复制优化功能（
用户文档
，已默认开启），主要体现在以下两个方面：

  
主节点加快DDL写日志速度：在主节点写物理日志和只读节点应用物理日志的关键路径上做了全面的优化，使得主节点在执行创建主键DDL操作的执行时间最多可减少20.6%；

  
只读节点加快物理复制速度：只读节点解析DDL的复制延迟时间最多约可减少至原来的0.4%，并且明显降低了CPU / Memory / IO的硬件开销。以下面测试数据为例，在主节点上不论执行1个DDL还是8个DDL，只读节点非常稳定，没有明显抖动。

6. 总结

DDL是PolarDB所有SQL操作中最繁重的一种，DDL的易用性是PolarDB良好使用体验非常重要的一环。本文总结介绍了PolarDB 在全链路MDL锁治理的经验和进展，把简单留给客户，把复杂留给自己，持续优化用户的使用体验。后续将总结介绍PolarDB在Fast DDL方面的工作，PolarDB内核团队将始终如一地为用户打造最佳的云原生关系型数据库。

  

    

		

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
