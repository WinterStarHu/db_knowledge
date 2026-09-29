# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/01/02/
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
	

  

    
数据库内核月报 － 2016 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 事务锁系统简介
                      

                    

                    

                  
                      

                        GPDB   · 特性分析· GreenPlum Primary/Mirror 同步机制
                      

                    

                    

                  
                      

                        MySQL · 专家投稿 · MySQL5.7 的 JSON 实现
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 优化器 MRR & BKA
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 物理备份死锁分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · Cachetable 的工作线程和线程池
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · drop table的优化
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · GTID不一致分析
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · Plan Hint
                      

                    

                    

                  
                      

                        MariaDB · 社区动态 · MariaDB on Power8 (下)
                      

                    

 
        

    

  

    
 GPDB   · 特性分析· GreenPlum Primary/Mirror 同步机制  

    
 Author: 康贤  

  

  

  
PostgreSQL 主备同步机制是通过流复制实现，其原理见之前的月报
PG主备流复制机制
。

Greenplum 是基于PostgreSQL开发的，它的主备也是通过流复制实现，但是Segment节点中的Primary和Mirror之间的数据同步是基于文件级别的同步实现的。为什么Primary和Mirror不能再使用流复制实现呢？主要有两个原因:

  
Append Only表不写WAL日志，所以Append Only表的数据就不能通过XLOG发送到Mirror再Apply；

  
pg_control等文件也是不写WAL日志，也只能通过文件方式同步到Mirror。

GP总体结构

Greenplum 的架构采用了MPP 无共享体系。在 MPP 系统中，每个数据节点有自己的CPU、磁盘和内存(Share nothing)，每个节点内的 CPU 不能访问另一个节点的内存。节点之间的信息交互是通过节点互联网络实现的，这个过程一般称为数据重分配(Data Redistribution)。GP master负责协调整个集群 ，一个数据节点可以配置多个节点实例(Segment Instances)，节点实例并行处理查询(SQL)。

Primary和Mirror同步机制

Primary和Mirror同步的内容主要有两部分，即文件和数据。之所以Primary和Mirror要同步文件，是Primary和Mirror之间可以自动failover，只有两者保持同步才能相互替代，如果只把数据同步过去，pg_control、pg_clog、pg_subtrans 没有同步，那么从Primary切换到Mirror会出现问题。GP master和GP slave却不用担心这些问题，Append Only 表的数据只会存在 Segment，所以WAL日志足够保持GP master和GP slave同步(只要是流复制，pg_control、pg_clog、pg_subtrans 这些文件Slave会自动更新，无需从Master同步)。

数据同步

当GP master向Primary下发执行计划后，Primary开始执行，如果是DML操作，那么Primary会产生XLOG及更新page。会在
SlruPhysicalWritePage
函数中(写数据页)产生FileRepOperationOpen、FileRepOperationWrite、FileRepOperationFlush、FileRepOperationClose等指令消息(消息中包含具体要更新的文件page及内容)，通过primary sender进程向Mirror发送Message，然后Mirror的mirror consumer等进程解析消息，执行变更。XLOG通过
XLogWrite
函数(写XLOG)执行同样的操作，把XLOG更新同步过去。

文件同步

Primary会有个recovery进程，这个进程会循环把Primary的 pg_control、pg_clog、pg_subtrans 等文件覆盖到Mirror。同时检查XLOG是否一致，如果不一致以Primary为主，对Mirror进行覆盖。除了把Primary部分文件同步到Mirror之外recovery进程还会将Mirror上面的临时文件删掉。

总结

Primary和Mirror同步数据的时候，Primary对于每一次写page都会通过消息发送到Mirror，如果Primary大量的更新page，那么Primary和Mirror同步将有可能成为瓶颈。

  

    

		

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
