# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/09/04/
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
	

  

    
数据库内核月报 － 2022 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 · innodb-BLOB演进与实现
                      

                    

                    

                  
                      

                        PolarDB MySQL · 多主架构 · 全局 Binlog 介绍
                      

                    

                    

                  
                      

                        源码分析 · InnoDB Redo Log 重构
                      

                    

                    

                  
                      

                        PolarDB MySQL · PolarTrans事务系统介绍(一)
                      

                    

 
        

    

  

    
 PolarDB MySQL · PolarTrans事务系统介绍(一)  

    
 Author: 华洛  

  

  

  
原生事务系统

MySQL原生事务系统是基于活跃事务列表来实现的, 该方案在高并发场景下会带来较为严重的性能瓶颈, 无法充分利用CPU多核心并发处理事务逻辑; 其次, 基于活跃事务列表方案在集群一致性读,  集群多点写入, 以及Share-Nothing架构中的分布式事务管理上存在天然的缺陷.

trx_sys->mutex热点问题

MySQL原生的基于活跃事务列表的维护开销较大, 这体现在事务流程的多个方面, 比如读写事务启动, 提交, 活跃事务查询, readview构建等. 在sysbench标准OLTP readwrite场景下, 通过perf+FlameGraph可以看到view_open的瓶颈非常明显.

原生事务系统逻辑

事务系统主要维护当前的事务状态信息, 包括当前最小/最大活跃事务id, 事务活跃状态,  事务提交顺序等; 另外, InnoDB通过MVCC技术实现一致性非锁定读取来提升只读事务性能,  只读事务拷贝当前的事务状态, 保存在readview中来确定可见范围,  trx_sys_t通过多个非原子的内存对象来实现上述逻辑.

  
读写事务启动

在事务启动过程中, 在trx_sys->mutex保护下, 获取事务id, 更新rw_trx_ids(活跃事务id数组), rw_trx_set(活跃事务集合), rw_trx_list (活跃事务链表)等内存对象, 具体可以参照函数trx_set_rw_mode, trx_assign_rseg_temp,trx_start_low等.

  
读写事务提交

事务提交过程中, 在trx_sys->mutex保护下, 继续更新上述的内存对象, 从中移除对应事务, 并且提交过程引入了新的链表对象serialisation_list, 用来维护事务提交序列, 同样也需要 trx_sys->mutex保护, 这部分逻辑可以参照函数trx_commit_low, trx_commit_in_memory, trx_erase_lists.

  
读写事务状态查询

在行锁判断过程中, 存在大量的逻辑需要去判断某条记录的trx id当前是否处于活跃状态, 具体参照函数trx_get_rw_trx_by_id, trx_rw_is_active_low, lock_rec_convert_impl_to_expl等.

  
事务状态拷贝

MVCC读取前需要拷贝当前事务状态, 同样需要trx_sys mutex保护, 这里主要包括m_low_limit_id, m_up_limit_id, m_ids, m_low_limit_no. 最耗时的应该是对于m_ids数组的拷贝过程, 活跃事务较多时, 拷贝较为耗时.  这部分逻辑参照函数view_open

  
可见性判断

通过m_low_limit_id, m_up_limit_id可以快速判断可见性, 但如果写事务trx id落在m_up_limit_id和m_low_limit_id之间, 需要对m_ids进行二分查找, 这里参考changes_visible.

略过了redo/undo等相关逻辑, 不在本文讨论的重点.

上文较为笼统的介绍了MySQL原生事务处理逻辑, 细节的部分可以参照之前的内核月报. 原生事务系统的维护非常繁琐, 同时读写过程都需要trx_sys->mutex进行保护, 高并发下性能退化严重.

PolarTrans实现

PolarTrans通过提交时间戳技术(CTS)优化原生事务系统,  优化的核心思想是移除对复杂数据结构的维护,  事务状态的迭代, 获取, 查询(可见性判断)等逻辑更加轻量,  同时PolarTrans将大部分的逻辑进行无锁优化,  PolarTrans事务系统对于读写混合场景, 纯写场景都有较大性能提升.

CTS log

PolarTrans CTS技术的核心数据结构为CTS log,  事务状态迭代, 可见性判断,  事务活跃状态等核心事务逻辑, 都是通过CTS log来完成的.

全内存设计的CTS log由一段ring buffer组成，事务通过trx_id取模映射到其对应的slot，每个slot包含trx指针和csn(事务提交序列号).

●写事务启动

原生事务系统在写事务启动时, 需要通过trx sys mutex保护, 分配事务id, 写入活跃事务id数组(rw_trx_ids),  维护活跃事务id到trx映射的集合(rw_trx_set), 以及读写事务链表(rw_trx_list)等数据结构; 在PolarTrans事务系统中, 事务启动时会注册到csn Log, 根据trx id取模分配相应的slot, 并将事务状态设置为特殊的active 标记即可,  并且这个过程可以做到无锁化处理.

●写事务提交

原生事务系统写事务提交时, 需要在trx sys mutex保护下, 查找rw_trx_ids移除对应的trx id, 维护rw_trx_set, rw_trx_list等; 在PolarTrans事务系统中, 事务提交时分配提交时间戳并更新csn log中对应的csn字段即可.

●read view

InnoDB的MVCC机制核心通过read view来控制数据可见性, 原生事务系统获取read view过程同样需要trx sys mutex保护, 拷贝活跃事务id数组和当前最小活跃id, 最大事务id,  在进行可见性判断时, 可能需要查找活跃事务id数组来确定可见性. 在读写冲突较为严重的场景下, 读写事务和只读事务都需要在mutex保护下更新和拷贝当前事务状态,  维护代价极高, 并且可见性判断效率较低.  在PolarTrans事务系统中, 通过获取事务系统的最大提交时间戳来代替原生read view, 同样可以做到无锁处理, 可见性判断过程中, 对比只读事务csn和行记录的trx csn即可.

PolarTrans相对于原生事务系统来说, 高并发性能可以提升30%以上. 关于PolarTrans在PolarDB一写多读架构下的性能测试可以参照阿里云官方文档, https://help.aliyun.com/document_detail/422031.html

PolarTrans的优化远不止此, 比如在PolarDB一写多读架构中的事务同步, PolarTrans结合RDMA技术实现集群强一致性读, 跨节点的全局一致性等等, 我们会在后续月报中进行介绍.

  

    

		

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
