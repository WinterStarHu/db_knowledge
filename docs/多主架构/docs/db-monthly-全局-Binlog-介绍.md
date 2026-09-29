# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/09/02/
> 分类: 多主架构

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
                      

                    

 
        

    

  

    
 PolarDB MySQL · 多主架构 · 全局 Binlog 介绍  

    
 Author: 夏特  

  

  

  
背景介绍

PolarDB MySQL多主架构集群版
包含多个RW计算节点，支持不同数据库在不同计算节点并发写入，支持最多32个节点同时写入，且支持数据库跨节点动态调度、秒级完成切换。

这些特性给PolarDB MySQL多主架构的binlog带来了新的挑战：

  
每个RW计算节点写入自己的binlog文件。

  
用户可以对某个db的写入进行切换，即从一个RW节点切换到另一个RW节点。

这就导致了没有一份全局的binlog呈现给用户，且多个RW节点上的binlog可能逻辑上相互依赖，用户无法根据这些binlog进行增量同步等操作。
例如用户在RW 1上对某张表插入了数据a，然后切换到RW 2上对该表删除了数据a。这两条信息分别记录在两个 RW节点各自的binlog文件中。如果用户在增量同步时先同步了RW 2的binlog，后同步了RW 1的binlog，就会导致数据错误。
为了给出一份全局唯一、逻辑有序的binlog，我们增加了多主架构集群版全局binlog功能：

PolarDB MySQL多主架构全局Binlog

从原理上讲，多主架构全局Binlog采用multi-srouce replication来获取所有RW节点的binlog。同时在数据库跨节点动态调度时，在对应RW节点写入一个sequence event；合并所有RW节点binlog时，根据sequence进行排序，从而聚合出全局有序的binlog。

MySQL multi-source replication

MySQL multi-source replication支持对一个slave配置多个primary，也就是该slave同时从多个 primary dump binlog。multi-source replication在原来的单primary配置命令基础上增加了 [channel option]来区分不同的primary。例如：

change
 
master
 
to
 
master_host

,
 
master_port

,
 
master_user

,
 
master_password
 
for
 
channel
 
"channel_1"

;

start
 
slave
 
for
 
channel
 
"channel_1"

;

stop
 
slave
 
for
 
channel
 
"channel_1"

;

也就是每个channel对应一个primary。代码实现中，每个channel都有一个slave_io线程和一个slave_sql线程；每个channel也对应在mysql.slave_master_info和mysql.slave_relay_log_info中有一行数据。
由于固有的限制，MySQL multi-source replication无法处理上游不同primary存在同名db/table的场景，在该场景下可能出现未定义行为。

RW切换时写入binlog sequence event

多主架构集群版对某个特定的db/table，在同一时间内只能有一个RW访问；通过跨节点切换，可以将该db/table的访问切换到另一个特定的节点。
为了解决multi-source replication对同名db/table无法合并的问题，我们在跨节点切换时，在原节点写入一条binlog event a，在新节点写入另一条binlog event b，其中b的sequence大于a的sequence（所有写入的sequence全局有序）。

如图所示，Lock table表示RW节点拥有某个table的读写权限，UnLock table为释放该table的读写权限。当跨节点切换时，先在原RW节点Unlock，后在新RW节点Lock。这样就能产生逻辑有序的binlog event，我们就可以根据sequence来合并binlog了。

其他优化

  

    
直接合并：通过multi-source replication获取到所有RW节点的binlog后，我们并不需要slave_sql线程apply这些binlog，而是根据sequence直接合并。这样可以节省计算资源。

  

  

    
直接读取：由于PolarDB基于共享存储实现，所以在multi-source replication中并不需要传输实际的binlog文件，直接从PolarFS读取即可。

  

如何使用

和PolarDB MySQL一写多读版本一样，用户在阿里云控制台通过”loose_polar_log_bin”来
开启多主架构集群版的binlog功能
。

开启该参数后，整个集群所有节点都会开启binlog，合并任务也会同步启动。用户就可以dump全局binlog，或者使用DTS进行增量同步了。

全局binlog是PolarDB多主架构兼容MySQL生态的重要一步。目前PolarDB正在向多主架构以及三层解耦的Serverless架构演进，欢迎大家持续关注。

  

    

		

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
