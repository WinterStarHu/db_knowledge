# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/03/02/
> 分类: 性能优化

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
	

  

    
数据库内核月报 － 2015 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 答疑释惑· 并发Replace into导致的死锁分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 5.7.6 InnoDB page flush 优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· pid file丢失问题分析
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· using filesort VS using temporary
                      

                    

                    

                  
                      

                        MySQL · 优化限制· MySQL index_condition_pushdown
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· lower_case_table_names 使用问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Logical Decoding探索
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· jsonb类型解析
                      

                    

                    

                  
                      

                        TokuDB ·引擎机制· TokuDB线程池
                      

                    

 
        

    

  

    
 MySQL · 性能优化· 5.7.6 InnoDB page flush 优化  

    
 Author:   

  

  

  
在上期的
月报
中，我们已经详细介绍了Oracle MySQL以及社区分支最新的对InnoDB page flush的优化。在最近release的5.7.6版本中又有了进一步的改进。主要包括以下几点修改

修改一、更精确的loop时间

Page cleaner每做srv_flushing_avg_loops次flush后，会去计算刷脏和Redo LSN增长的速度。由于每次Page cleaner的工作量是自适应的，一次flush操作的时间可能超过1秒。

在新版本中，统一采用当前时间和上次更新速率的时间差来确认是否需要重新计算速率。因此参数innodb_flushing_avg_loops的行为实际上等同于每这么多秒后重计算速率。

修改二、根据buffer pool实例的脏页分布来决定刷脏

从5.7版本开始支持配置多个page cleaner线程以实现并行刷脏。在5.7.6之前的版本，Page cleaner协调线程根据当前的负载情况，会计算出预计需要flush的总page数和目标LSN，然后在多个bp instance间做个均分。

但是考虑一种场景：如果bp实例间的负载不平衡，某个实例在目标LSN之前的脏页很多，而有些实例很少，那么本应该多做刷脏动作的bp就可能产生堆积。 我们之前在
webscalesql google公开讨论组
 有过类似的讨论，感兴趣的可以看看。

回到正题上来，在5.7.6版本中，计算目标page数的方法大概如下：

  

    
根据当前脏页占比和Redo LSN增长状态，计算利用IO Capacity的百分比（pct_total）

  

  

    
计算目标LSN:

  

target_lsn = oldest_lsn + lsn_avg_rate * buf_flush_lsn_scan_factor

其中oldest_lsn表示当前buffer pool中最老page的LSN，lsn_avg_rate表示每秒LSN推进的平均速率，buf_flush_lsn_scan_factor目前是hardcode的，值为3。

  
统计每个buffer pool 小于target_lsn的page数pages_for_lsn

初步估定每个bp instance 的n_pages_requested= pages_for_lsn /buf_flush_lsn_scan_factor。每个bp的pages_for_lsn被累加到sum_pages_for_lsn

  
同时根据io capacity估算总的需要flush的Page数量：

sum_pages_for_lsn /= buf_flush_lsn_scan_factor;
n_pages = (PCT_IO(pct_total) + avg_page_rate + sum_pages_for_lsn) / 3;

n_pages若超过innodb_io_capacity_max，则设置为innodb_io_capacity_max

  
轮询每个Buffer pool 实例：

如果当前有足够的Redo 空间：n_pages_requested  = n_pages / srv_buf_pool_instances
否则：n_pages_requested = n_pages_requested  * n_pages / sum_pages_for_lsn

也就是说，在Redo 空间足够时，依然采用均衡的刷脏逻辑。

在早期版本中，会根据两个条件来判断每个bp刷脏的进度：目标LSN及page数。而到了5.7.6版本里，大多数情况下只根据更加准确的请求刷page数来进行判定 （系统空闲时进行100% io capactiy的page flush、崩溃恢复时、以及实例shutdown时的刷脏除外）

虽然计算公式比较清晰，但有些factor的定值依然让人很困惑，也许是官方测试的比较理想的配置。不过最好还是设置成可配置的，由有经验的用户根据自己具体的负载情况来进行定制。

修改三、用户线程在检查Redo 空间时不参与刷脏

在之前版本中，当未做checkpoint的日志量过多时，用户线程会进行batch flush操作，将每个buffer pool instance的LSN推进到某个指定值。如果某个bp instance已经有别的线程在flush，则跳过尝试下一个instance，同时认为这次的flush操作是失败的，会返回重试。

当用户线程参与到刷脏时，通常会认为这是个性能拐点，TPS会出现急剧下降，大量线程陷入condtion wait 和并发flush。因此在5.7.6里，当用户线程需要推进LSN时，不再主动发起刷脏，这些工作会留给page cleaner线程来作。 用户线程只去轮询每个bp instance，直到所有的bp instance 的LSN超过其目标LSN，每次轮询默认sleep重试时间为10000微妙

事实上, Percona Server早在5.6版本里已经使用相同的策略了。

修改四、为page cleaner线程设置更高的优先级

在Linux平台下，对于page cleaner的协调线程和worker线程，其CPU优先级被设置为-20，即最高优先级，通过函数set_priority设置。目前还不支持参数配置。

修改五、防止checkpoint LSN被覆盖

在之前的版本中，尽管每次在写Redo时都会去检查日志文件是否容留了足够百分比的可用空间，但实际上并没有考虑即将写入的Redo log长度。如果我们操作一些极大的记录并产生很长的Redo log记录，这可能导致检查点LSN被覆盖掉，如果这时候crash就会无法安全的做崩溃恢复。

在新的逻辑里，在检测到当前写入的Redo 可能造成覆盖上次的checkpoint点时，就会进入sleep，等待page cleaner线程刷脏，然后再做一次Redo log checkpoint。如此循环直到checkpoint的LSN推进到安全的位置。

参考
： 
worklog：wl#7868
，及
补丁

  

    

		

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
