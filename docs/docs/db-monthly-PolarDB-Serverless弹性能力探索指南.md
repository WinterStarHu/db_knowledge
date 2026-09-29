# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/10/01/
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
	

  

    
数据库内核月报 － 2023 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB Serverless弹性能力探索指南
                      

                    

                    

                  
                      

                        PolarDB MySQL DBA工具库新增一员猛将Statement Outline
                      

                    

                    

                  
                      

                        MySQL 中的元数据管理
                      

                    

 
        

    

  

    
 PolarDB Serverless弹性能力探索指南  

    
 Author: 甄平  

  

  

  
前言

PolarDB Serverless脱胎于PolarDB团队发表在 
SIGMOD 2021的论文
 ，是选取其中成熟的技术最终产品化的结果。我们借助两大核心技术，高性能全局一致性SCC和热备无感秒切，无论在跨机扩展还是跨机切换，都达到了业界领先的能力。PolarDB MySQL Serverless于去年底正式上线，获评 
信通院事务型数据库Serverless认证最高“先进级”
 ，目前已经有1000+用户使用。

本文期望从实践角度，演示如何测试PolarDB Serverless的弹性能力。

购买实例

PolarDB的Serverless分两种，一种是新购的Serverless类型实例，一种是在原有实例基础上开启Serverless，也称固定规格Serverless实例。前者有更大的弹性范围，所有资源完全按Serverless弹性计费；后者可以直接在老实例开启，计费分固定规格费用和弹性费用。这里我们直接购买Serverless类型实例进行测试。当前Serverless类型支持5.7、8.0.1和8.0.2，5.6还在支持中。本文的演示中，我们购买北京可用区K的8.0.1进行测试。

只读节点弹性上下限的可选范围是0-7，单节点伸缩的弹性上下限的可选范围是1-32 PCU。其中PCU是PolarDB Serverless的计费单位，1 PCU大约是1核2G的资源，不同机型我们会对齐算力，因此会有略微差别。这两个配置在实例创建后都可以随时动态修改，因此这里任意选择即可。

对于Serverless实例默认会创建数据库代理，否则无法使用只读节点进行横向弹性。数据库代理也会以Serverless形态运行，范围是0.5-32 PCU，随着实际负载动态调整。无活动暂停功能，面向的业务类型比较窄。当负载降低，一般情况下Serverless会降配到最低的1 PCU运行。如果开启了无活动暂停，且请求量完全降为0，会直接关闭实例，释放资源。后续有新的请求过来，会暂时hold住请求，等实例快速拉起后再发送到DB执行。存储类型目前支持Polarstore的PSL5和PSL4规格，不同规格对应不同的性能和成本，不再赘述。

以上是新购Serverless实例的一些关键选项，创建实例大约耗时5-10min。这段时间可以先提前创建一个ECS，作为压测机器，最好是同可用区的。由于PolarDB Serverless理论上最大的计算能力是256核（8 * 32 PCU），ECS也要尽量买大一些规格的。在这次的测试中，我选择了16核64g的ecs.g7.4xlarge规格。
成功购买实例后，进入PolarDB控制台，实例的系列会显示为_集群版(Serverless)_。下一步，我们在白名单配置ECS的地址，创建一个polartest账号，创建用于压测的数据库sbtest。数据库代理区域，已经默认创建了主地址和集群地址，直接用集群地址就可以测试。因为Serverless的只读节点是动态伸缩的，因此没有创建自定义地址的必要性。数据库节点区域，初始会默认生产一个1 PCU的主节点。点击右上角的Serverless配置按钮，可以重新配置资源弹升和只读弹升的上下限。最下方是存储区域，存储的计费和PolarDB企业版一样，按量付费。

单节点弹性测试（Scale-up）

点击Serverless配置，单节点资源弹升上下限分别配置到最大值32和最小值1，只读节点个数扩展上下限都配置为0。这一节通过sysbench压测，验证主节点的规格能够根据负载进行自动伸缩，达到Serverless的能力。

sysbench采用如下命令进行压测，使用oltp_read_write负载，注意其中的mysql-host填写集群地址，同时配置–db-ps-mode=disable确保所有的事务Query以原始SQL的方式执行。

sysbench /usr/share/sysbench/oltp_read_write.lua 
--mysql-host

=
xxxx.rwlb.rds.aliyuncs.com 
--mysql-port

=
3306 
--mysql-user

=
xxxx 
--mysql-password

=
xxxx 
--mysql-db

=
sbtest 
--tables

=
128 
--table-size

=
1000000 
--report-interval

=
1 
--range_selects

=
1 
--db-ps-mode

=
disable 
--rand-type

=
uniform 
--threads

=
xxx 
--time

=
12000 prepare
sysbench /usr/share/sysbench/oltp_read_write.lua 
--mysql-host

=
xxxx.rwlb.rds.aliyuncs.com 
--mysql-port

=
3306 
--mysql-user

=
xxxx 
--mysql-password

=
xxxx 
--mysql-db

=
sbtest 
--tables

=
128 
--table-size

=
1000000 
--report-interval

=
1 
--range_selects

=
1 
--db-ps-mode

=
disable 
--rand-type

=
uniform 
--threads

=
xxx 
--time

=
12000 run

测试开始之前，要先为sbtest库prepare数据，比如我选择了128张表，每张表1000000行数据。prepare过程中可能会造成实例弹升，所以prepare完建议等1分钟，直到主节点降回1 PCU后再压测。先简单测试一下16线程的效果（–threads=16）。从sysbench的输出来看，在并发数固定16的负载下，随着时间的推移，吞吐量tps逐步增加，延迟lat逐步降低，最终达到一个稳定值。这说明PolarDB Serverless触发弹性后，性能获得提升。

点击控制台左侧的性能监控标签，可以看到集群监控中展示了“Serverless监控指标项”。时间范围选择最近5分钟，可以看到如下监控信息。PCU数量从1弹升到5，并保持稳定，在弹升过程中，CPU的使用率随着资源的扩容逐步降低。看内存使用率曲线，每次弹升会有尖刺一样的形状。这是因为每次PCU增加，内存资源扩容，此时内存使用率会瞬间降低。之后数据库开始利用扩充的内存资源提高计算能力（比如Buffer Pool），因此使用率会逐步增加，最终到达一个稳定状态。

停止sysbench压测，稍等一段时间，再调整合适的时间范围，刷新监控。随着压力的停止，规格从5 PCU逐步阶梯式的降低回1 PCU。首先观察CPU，CPU使用率瞬间降为接近0，由于读写混合测试包含update请求，在压力停止后，PolarDB还会继续purge undo（和MySQL原有机制一致），因此还会占用微量的CPU。再观察内存，每次缩容，内存使用率会立即降低然后再升高一个台阶。这个是因为PolarDB缩容之前，会首先调小内存相关参数，如Buffer Pool、Table Open Cache等，触发这些缓存的回收，使用率会立刻降低。参数调整完，确保内存资源已经被释放，才会真正调小容器的Mem规格，当Mem上限调小后，相当于分母变小，计算出来的内存使用率则会上升。

下面我们尝试增加sysbench压力，使用128线程数，看看PolarDB弹升到32 PCU的最大规格需要消耗多长时间。从sysbench输出可以很明显看到tps和latency的变化。同样的，压测一段时间后停止，PCU也会自动缩容。从1 PCU升到32 PCU耗时大约42s，缩容相比扩容更显得平缓，耗时大约220s。这样的设计既能有效面对突发流量，也能防止遇到波动性业务扩缩容过于频繁。

多节点弹性测试（Scale-out）

PolarDB借助SCC技术实现了
高性能的全局一致性
，可以实现跨节点无损读扩展。Serverless实例会在所有弹出只读节点上默认开启SCC。对于传统的MySQL主备一写多读实例，只读节点存在Binlog复制延迟，一般不转发TP业务的读，只服务报表这类对全局一致性不敏感的业务。同时由于Binlog复制只会同步已提交事务的日志，只读节点无法处理事务中的写后读。

在PolarDB上，SCC通过提交时间戳技术CTS和事务状态RDMA同步，实现低延迟的只读节点读扩展。同时，SCC加上Proxy的高级事务拆分技术，跨事务、事务前和事务中的写后读请求，都可以轻松扩展到PolarDB的只读节点，且保证全局一致性。最终，主节点省下来的资源就可以支持更多写请求。在SCC的加持下，PolarDB Serverless使用唯一的集群地址访问实例，用户不会受到跨节点的读一致性的问题困扰，即无需关心请求是由主节点直接执行，或是被转发到只读执行。

这一节我们验证多节点弹性测试的效果。点击Serverless配置，只读节点个数扩展上限从0修改为7。在确认主节点在之前的测试结束后，确保已经降回1 PCU，重新发起和上一节一样的sysbench压力，即128线程的oltp_read_write压测。在上一节我们已经看到，128并发已经足够让主节点扩容到32 PCU的最大值了，我们看下在调整只读扩展上限后，会发生什么变化。

sysbench /usr/share/sysbench/oltp_read_write.lua 
--mysql-host

=
xxxx.rwlb.rds.aliyuncs.com 
--mysql-port

=
3306 
--mysql-user

=
xxxx 
--mysql-password

=
xxxx 
--mysql-db

=
sbtest 
--tables

=
128 
--table-size

=
1000000 
--report-interval

=
1 
--range_selects

=
1 
--db-ps-mode

=
disable 
--rand-type

=
uniform 
--threads

=
128 
--time

=
12000 run

首先在控制台主页，我们能观察到，在压力执行一段时间后，系统开始自动创建只读节点。

过一段时间后，进入稳定的状态，系统不再继续增加只读。

进入稳定状态后，sysbench的输出如下。对比之前单节点同压力的测试结果，性能略有下降，从34-35w下降到32-33w。这个我理解为全局一致性读的性能损耗，带来的收益是释放了宝贵的主节点资源。

查看监控中的“Serverless监控指标项”，可以看到类似如下的曲线。一开始主节点很快弹到32 PCU，之后只读创建出来，开始承担一部分负载，主节点cpu使用率下降，PCU缩容。由于弹出的只读CPU使用率没有超过弹性阈值80%，因此该压力下只会扩容一个只读。

尝试将并发数增大到2倍，停止sysbench压力，立即执行256并发的oltp_read_write。等待一段时间，会发现系统开始大量弹出新的只读。同时查看sysbench的输出，oltp_read_write的性能也有大幅提升，从32-33w上升到44-46w，从QPS上已经突破了上一节单节点的最大吞吐。这说明成功验证了Serverless scale-out的效果。

查看Serverless监控，会看到多个只读节点的曲线。注意一个明显的现象，当新的只读弹出来后，先前的节点就会逐步降低负载，最终达到一个大致的均衡，这说明Proxy成功将负载均衡到新弹出的只读节点中。由于目前Serverless为了避免频繁的规格震荡，弹升弹降的阈值是一个大区间，同时降配对性能也存在一定负反馈，因此Proxy很难做到100%的均衡，先降配的PCU最终值会偏低。

运行一段时间后，停止sysbench，PolarDB的计算节点首先会自动缩容，大约1-2min会逐步降到1 PCU。压力停止之后，只读的cpu使用率会立刻降低，而主节点还需要purge undo，CPU消耗会持续一小段时间，最终降到1 PCU。此后，如果等待较长一段时间，新增的只读节点也会逐步回收（15-20min）。为了避免只读节点频繁的弹性震荡，Serverless没有选择立刻回收无负载的只读。

总结

PolarDB Serverless的弹性探索就到这里。后续还会有更多文章，分享固定规格Serverless的最佳实践和Serverless的技术细节。此外，今年云栖大会数据库产品体验馆也会上线一个新的PolarDB Serverless实验室，注册阿里云账号后可以免费体验Serverless机制弹性的能力。欢迎大家试用PolarDB for MySQL Serverless。

  

    

		

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
