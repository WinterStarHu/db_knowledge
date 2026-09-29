# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/04/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态 · 从库OOM  

    
 Author:   

  

  

  

bug背景

官方最近发布的版本(5.7.5)修复了这样一个bug，主备复制场景下，如果主库和备库对应的表结构中有数据类型不一致，并且主库的 binlog 是 row 格式的，这时候如果主库对不一致的表做了一个大事务更新，备库在应用 relay-log 的时候报OOM(Out of Memory)。bug地址在这里，主备数据类型不一致主要发生在这2种情况下：

主备库版本不一致，不同版本之间的数据类型可能存在不一致。用户在报这个bug时，就是在5.5到5.6的复制场景下，用到了时间类型，时间类型在5.6.4版本时发生了变化
人为直接的连上从库 alter 表

bug分析

为啥数据类型不一致会导致 OOM 呢？OOM 表示程序在持续申请内存，把内存给用爆了。从库的slave thread在应用Rows_log_event时，如果发现主库的表和从库的表不兼容，就会创建一个临时中间表，做数据转化：

Rows_log_event::do_apply_event()
table_def::compatible_with()
table_def::create_conversion_table()
create_conversion_table()

在此过程中用的临时表结构和field字段都是从thd的mem_root分配的，而每个Rows_log_event应用时分配内存空间再do_apply_event后就不会再用了，但是 Rows_log_event::do_apply_event() 结束后并没有free_root释放，而是在事务所有event做完后释放的。类似下面这种包含大量更新语句的事务，每一个更新对应一个Rows_log_event，备库在应用时，在事务执行中间所有申请的内存都会保持，如果语句非常多的话，就导致OOM了。

begin;
insert into t1 values (xxx); /* 1 */
insert into t1 values (xxx); /* 2 */
insert into t1 values (xxx); /* 3 */
....
insert into t1 values (xxx); /* 1000000 */
end;

bug 修复

像 Query_log_event::do_apply_event() 在结束会调用free_root，来释放thd->mem_root空间，而Rows_log_event::do_apply_event()却不能这样干，因为在下面的场景下，用户的线程会调用 Rows_log_event::do_apply_event()

mysqlbinlog mysql-bin.00000x | mysql -hxxxx -Pxx -u

如果在中间释放用户线程的thd->mem_root的话，会有问题。

因此官方的修复方法是在Log_event类构造函数初始化一个属于log_event的 mem_root

Log_event::Log_event()
init_sql_alloc(PSI_INSTRUMENT_ME, &m_event_mem_root, 4096, 0);

在析构函数里释放

virtual ~Log_event()
free_root(&m_event_mem_root, MYF(MY_KEEP_PREALLOC));

然后把Rows_log_event::do_apply_event()本来从thd->mem_root申请的内存改为从自身的 m_event_mem_root 申请，这样每个event应用完，被delete时其转化过程中申请的内存也一并被释放，避免了OOM的产生。

  

    

		

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
