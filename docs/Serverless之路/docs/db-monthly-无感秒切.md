# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/07/03/
> 分类: Serverless之路

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
	

  

    
数据库内核月报 － 2022 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 行业洞察 · 为什么游戏行业喜欢用PolarDB
                      

                    

                    

                  
                      

                        POLARDB · 引擎特性 · PolarDB备份与恢复介绍
                      

                    

                    

                  
                      

                        PolarDB Serverless之路 · 无感秒切
                      

                    

                    

                  
                      

                        PostgreSQL · 插件特性 · FDW 异步执行特性
                      

                    

 
        

    

  

    
 PolarDB Serverless之路 · 无感秒切  

    
 Author: 甄平  

  

  

  
背景介绍

PolarDB的架构优势

PolarDB是阿里云自主研发的云原生关系型数据库，借助物理复制、RDMA高速网络和分布式存储等技术，实现了存储计算分离架构。相比开源的MySQL，新架构在快速弹性和高可用场景下为PolarDB带来了很多优势，并长期被客户认可：

  
PolarDB支持一写多读，集群内的多个节点共享同一份数据，增减只读节点无需搬迁数据，速度快效率高；

  
当PolarDB执行升降配切换（Switchover）或主节点故障容灾（Failover）时，基于共享存储，可以轻松地将任意一个只读节点升级为新的主节点，而不用担心数据一致性的问题；

  
PolarDB通过Redo物理复制和运行时应用（Runtime Apply）技术，新升级的主节点可以立即提供服务，规避Binlog复制同步延迟的顽疾；

需求和挑战

目前PolarDB服务的客户涉及到了各行各业，既包括新兴的游戏、直播、在线教育，也包括传统的金融、保险。在和大量客户交流之后，以高可用为切入点，我们沉淀了一些新的需求。
其一，目前PolarDB的真实容灾时间大约是30s-60s。但是作为OLTP数据库系统，相比分析型业务，客户希望容灾耗时尽可能短，容灾过程最好对业务无感。其二，PolarDB支持计算节点快速升降配，但是会出现连接闪断和请求报错，因此我们还是会建议客户选择低峰期进行扩缩容。基于同样的原因，客户升级历史版本也会很谨慎，这给云服务商的托管和运维带来了一些困扰。此外，对于两种类型的客户：1. 写后读模型，对一致性和响应延迟读要求高；2. 写多读少。这两类客户倾向于直接用主节点处理所有的读写请求，简化业务逻辑。PolarDB基于容灾的考虑，至少依赖一个只读作为备节点。对于读扩展需求低的客户，闲置的备节点最好能带来额外的收益。

高可用技术演进

云数据库高可用的演进可以概括为以下几个阶段。传统主备模式的高可用采用Binlog复制，存在复制延迟的问题，典型的如DDL、大事务。PolarDB的高可用通过物理复制解决了延迟问题，通过共享存储提升了扩缩容能力，但依然会导致连接中断和事务回滚，传到到应用客户端就是大量请求报错。为了最大化的提升小版本升级、扩缩容、故障容灾等场景的实用价值，我们提出了无感秒切的技术，从故障探测、切换速度、切换体验几个方面对PolarDB进行了优化。我们认为该技术也是让PolarDB向Serverless演进的一个必要条件。

无感秒切 · 核心技术

下面的内容会详细介绍PolarDB无感秒切特性的技术细节。该特性主要针对切换场景进行优化，包括计划内的切换如升降配、小版本升级，以及计划外的故障容灾。我们从三个方面，分别是故障探测、切换速度和切换体验，整合了多项技术，来解决客户的痛点：

  
引入全新的高可用模块Voting Disk Service，基于共享存储架构，实现自治的集群节点管理，大幅降低故障检测和集群选主的耗时；

  
新增支持全局预热系统的热备节点，通过对存储引擎内部的多个模块提前预热，优化升主的执行耗时；

  
结合数据库代理Proxy，支持事务续传功能。在切换场景下，可以最大化地保证用户连接不断事务不断，实现基本无感知的主动运维。

Voting Disk Service

开启无感秒切功能后，PolarDB将启用全新的高可用系统Voting Disk Service（VDS）。首先介绍一下VDS的设计思路。PolarDB是一写多读的架构，一般情况下，分布式环境多个节点的选主需要依赖Paxos/Raft等一致性协议。我们发现，PolarDB共享存储的架构天然提供了中心化仲裁的能力，因此无需像RDS三节点那样依赖一致性协议执行复杂的多数派判定。我们仿照业界分布式锁的思路，在PolarStore存储一份特殊的数据块，实现一套基于租约的分布式锁机制。文件锁提供trylock接口用于续租，同一时刻只允许唯一的持有者。通过让多个计算节点竞争这个共享的文件锁，来执行节点的选举。这个方案我们称为Voting Disk Service，它有以下几点优势：

  
在共享存储的环境下，文件锁属于中心化的节点，不存在双主的风险；

  
通过租约机制，还可以避免短暂的系统抖动导致的频繁切换；

  
所有备节点都可以感知文件锁关联的拓扑信息改变，及时获得最新的主节点地址；

  
文件锁位于存储节点上，对IO hang或IO链路网络故障的场景可以有效覆盖；

具体来说，VDS通过以下几个模块实现自治的集群节点管理，故障检测和集群选主：

  
每个计算节点有独立的VDS线程，会分为三种不同的角色：Leader、Follower和Observer。其中Leader对应PolarDB的主节点，Follower对应热备节点，Observer对应普通的只读节点。一般情况下，一个PolarDB集群包括一个Leader、一个Follower和多个Observer。

  
VDS在PolarStore上维护了两个数据块，分别是CAS Block和Polar Cluster Registry（PCR）。
    

      
CAS Block是PolarStore提供的支持CAS（Compare-And-Swap）操作的原子数据块。VDS基于CAS提供了分布式租约锁的实现，并在数据块中记录了锁持有者、租约时间等元信息。PolarDB的计算节点，通过续租和加锁语义，完成故障探测和集群选主。

      
PCR是一个保存了PolarDB节点管理信息的数据块，维护了整个集群的拓扑状态。VDS的Leader有PCR的写入权限，Follower和Observer有只读权限。

    

  

  
当Follower获取VDS锁后，会发起升级Leader的任务，同时调用PolarStore的IO fencing接口失效老Leader的PolarStore写权限，确保分布式环境下，只有最新的主节点有共享存储的写入权限。

  
丢失VDS锁的老Leader节点会自动降级为Follower，并依赖PCR中维护的集群信息，重建复制拓扑。

正常情况下，主节点对外提供读写服务，并通过VDS Leader定期续租。当主节点故障时，备节点的VDS Follower在租约超期之后将加锁成功，升级成Leader，备升级为新的主节点。故障的老主节点恢复后，加锁失败，会自动降级为备节点。这样就完成了PolarDB的切换流程。在选主流程结束后，PCR会将新的拓扑信息广播给所有的VDS Observer，只读节点就自动感知到新上任的主节点，调整redo、binlog等复制链路。

全局预热系统

引入VDS后，PolarDB解决了故障探测和选主的难题，进一步地，我们希望备节点抢到VDS租约锁后，能快速完成切换，新引入了热备节点的角色。热备节点是一个弱化版的只读节点，同时也是一个更接近主节点、随时准备接班的灾备。相比普通的只读节点，它保留有限的读服务，预留更多的CPU、Memory资源去优化切换速度。全局预热系统是热备中最核心的模块，用于实时同步主库的元信息，将关键数据提前加载进内存，为未来潜在的升主加速，目前预热模块包括4个方面：Buffer Pool、Undo、Redo和Binlog。

Buffer Pool预热会实时监控主库BP的lru链表，并将主库数据页信息发送给热备。热备会智能地选择最热的数据页，提前执行批量内存加载，最终可以缓解传统只读升主后，BP命中率大幅下降引发的性能抖动。Undo预热是对事务系统的预热。在升主过程中，PolarDB需要从Undo Page找出悬挂事务并进行回滚。传统的只读节点会服务分析类型的大查询，不会访问主库未提交的事务，因此在切换流程中存在Undo Page的IO等待。热备提前预热Undo Page，通过Runtime Apply回放到最新版本，减少事务系统的恢复时间。对于最新的Redo，热备和只读节点一样，会实时缓存在内存的Redo Hash中。另外，如果集群开启了Binlog，升主过程中，处于Prepare状态的InnoDB事务还依赖Binlog信息来做提交或回滚的决策。完整的读取和解析最后一个Binlog文件时常需要耗费数秒甚至数分钟的时间，热备节点通过后台线程异步地将最新的Binlog数据缓存在IO Cache中，并提前进行解析，可以彻底解决这个问题。

PolarDB支持热备节点和普通备节点的动态转换。在实践中，客户可以选择长期的开启一个热备节点，或者选择仅在变配、升降级过程中，短时间开启热备，以加速任务流的执行。PolarDB支持配置不同规格的主和只读，以节约成本，但是要求至少有一个同规格的只读作为灾备。我们推荐将这个节点配置为热备节点，热备也会自动开启VDS，作为Follower角色参与选主。

事务续传

PolarDB解决故障探测和切换时间的问题后，连接保持和事务续传功能进一步优化了切换体验。常规的切换、热升级会对应用程序服务造成影响，导致连接闪断、新建连接短暂失败、存量事务回滚等问题，增加了应用开发的复杂性和风险。目前PolarDB通过数据库代理Proxy支持
连接保持
的功能。Proxy在应用程序和PolarDB之间，扮演了连接桥接的角色，当数据库主备切换时，Proxy将新的后端连接（即Proxy和数据库节点的连接）桥接到原有的前端连接（即应用程序和Proxy的连接）上，同时恢复之前的会话状态，包括原来的系统变量、用户变量、字符集编码等信息。但是连接保持只能作用于空闲的连接，如果切换瞬间，当前的会话有正在执行的事务，一方面Proxy无法从PolarDB中找回原有事务的上下文，另一方面新主会将未提交的悬挂事务回滚，释放这些事务持有的行锁。因此在这种场景下，连接保持就会失效，而PolarDB最新推出的事务续传功能可以解决这一缺陷。事务续传，配合连接保持，可以实现对应用程序基本无感知的高可用切换。那么PolarDB是如何实现事务续传的呢？

PolarDB是基于物理复制的架构，相比传统使用Binlog的逻辑复制，主库的事务在热备节点上可以完全一致的重建出来。以上图为例，假设应用程序完整的事务是begin-insert-update-commit，并开启事务续传，把innodb_trx_resume参数修改为ON。事务开始执行，Proxy在将语句转发给主节点的同时，会缓存最近执行的SQL语句。第一条insert请求在主节点执行成功后，PolarDB会自动维护最近一条语句的Savepoint，作为事务信息的一部分。之后，通过Session Tracker将当前的会话信息和事务信息返回给Proxy，Proxy会将这些数据临时保存在内部的缓存。其中会话信息用于连接保持，如字符集、用户变量；事务信息用于事务续传，包括trx_id、undo_no等信息。此外，在数据库层，事务信息会通过一个单独的RDMA链路，持续高效地同步到热备中。如果后端数据库开启了Binlog，我们还会将每个事务对应的本地Binlog缓存同步到热备，这条链路同样也是走RDMA。

假设主节点突然出现故障，应用程序的update请求执行了一半。此时Proxy并不会马上把底层的报错透传给应用连接，而是将整个请求hold一段时间。热备选主之后，会通过Redo Log构建出所有的未提交事务，但并不立刻回滚，而是在一定的时间内异步等待。之后，Proxy探测到主备切换成功，会利用自身缓存的会话信息和事务信息，借助PolarDB的Attach Trx接口，桥接事务状态。PolarDB根据Proxy的信息，判断相关的事务信息是否有效，如果有效，就把事务信息绑定到这个连接上，并回滚到之前执行一半的语句（即上文的update）对应undo_no的Savepoint。当事务桥接成功后，Proxy就可以从语句缓存中，把最近一次未执行成功的update发送给新的主节点，重新执行。

从外部视角来看，整个主备切换过程中，应用程序只感知到一条update语句变成了慢SQL，但不会接收到连接报错或事务报错，后续应用层就不需要显式执行连接重连和事务重试，整个运行风险会简化很多。另外，阿里云官网PolarDB文档有一个事务续传功能的演示视频，更直观的展现了无感秒切的效果，
参考链接
。

总结

无感秒切通过Voting Disk Service、热备预热、事务续传三大特性，解决了PolarDB故障探测、切换速度、切换体验的问题，对于弹性升降配的意义巨大。有了无感秒切，用户可以在任意时刻对集群进行升配，不需要担心连接/事务的中断对业务的影响，对于资源利用率和稳定性的提升非常重要，真正实现了云原生数据库的弹性承诺。目前PolarDB正在向多主架构以及三层解耦的Serverless架构演进，欢迎大家持续关注。

  

    

		

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
