# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/04/04/
> 分类: migration/upgrade

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
	

  

    
数据库内核月报 － 2015 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB undo log 漫游
                      

                    

                    

                  
                      

                        TokuDB · 产品新闻 · RDS TokuDB小手册
                      

                    

                    

                  
                      

                        TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)
                      

                    

                    

                  
                      

                        PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 连接断开导致XA事务丢失
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID下slave_net_timeout值太小问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Relay log 中 GTID group 完整性检测
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · UPDATE交换列单表和多表的区别
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 删被引用索引导致crash
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · GTID下auto_position=0时数据不一致
                      

                    

 
        

    

  

    
 PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁  

    
 Author: 明虚  

  

  

  
PgSQL 9.4.1在2015年2月5日发布，主打的是安全方面的更新，修补了如下的安全漏洞：

  
CVE-2015-0241 Buffer overruns in “to_char” functions.

  
CVE-2015-0242 Buffer overrun in replacement printf family of functions.

  
CVE-2015-0243 Memory errors in functions in the pgcrypto extension.

  
CVE-2015-0244 An error in extended protocol message reading.

  
CVE-2014-8161 Constraint violation errors can cause display of values in columns which the user would not normally have rights to see.

也就是说，在9.4 GA版本中，是存在这些安全漏洞的，9.4.1把它们修复了。好消息是，阿里云的RDS PG将直接采用更安全的9.4.1版本。下面我们不妨分析一下这些漏洞的具体情况，看看如果使用9.4 GA，有哪些安全隐患。

CVE-2015-0244

比较起来，CVE-2015-0244这个漏洞较严重些，我们做重点分析。从修复这个问题的代码改动（
patch
）可以看出，问题主要出在前后端通信过程中。最简单的触发方式，是利用Query Cancellation机制。这里有必要先介绍一下前后端的通信过程和Query Cancellation的实现逻辑。

客户端连接PG时，后端建立一个backend（即后台进程）为其服务，服务逻辑主要在PostgresMain()中。PostgresMain()有一个无条件for循环，不断从客户端读取新的SQL命令，并进行处理。PG每次从客户端读取8K大小的消息；如果一个SQL比较大，大小超过8K，则需要多次读取。

读取一次客户端消息的调用序列如下：

PostgresMain -> ReadCommand -> SocketBackend -> pq_getmessage
                                                        |
                                                        V
             recv <- secure_read  <- pq_recvbuf <- pq_getbytes

其中pq_recvbuf调用secure_read每次读取8K的数据。如果一个SQL很大，比如

INSERT INTO tablename VALUES (1), (2),.....,(10000000)

则需要反复调用secure_read。此时如果用户端发起了一个Query Cancellation，比如在psql控制台按下了Ctl+c，则PG后台进程最终会收到一个SIGINT信号，触发它中断当前的处理，跳转到信号处理函数StatementCancelHandler。其后的函数调用过程如下：

StatementCancelHandler -> ProcessInterrupts -> elog( ERROR，......) 
                                                         |
                                                         V
                     siglongjmp  <-  PG_RE_THROW <- errfinish

可见，最后PG利用siglongjmp，实现了调转。跳转到哪里了呢？我们知道，siglongjmp一般和sigsetjmp成对使用；查看PostgresMain函数，可以发现下面这一行：

if (sigsetjmp(local_sigjmp_buf, 1) != 0)

实际上，siglongjmp就是跳转到这一行，继续执行。接下来执行的逻辑正好是对事务执行回滚和对session（即当前连接）环境做初始化，接着就又开始调用ReadCommand，继续从客户端读取消息了。

仔细分析上述过程，可以发现一个问题：如果PG在读取一个客户端消息的中间，收到了一个Query Cancellation信号，则PG会回滚事务，并将状态改为等待读取新消息，然后再次调用ReadCommand读消息。但是，此时还是从原来的网络连接中，调用recv读取，所以读取到消息，有可能是上一个消息的一部分。就是说，PG可能把上一个消息的一部分，当做一个新的消息的开始来处理！攻击者可以利用这一点，将一个完整的消息，注入到原SQL中，绕过前端的检查，执行原来不被允许的SQL。例如，如果一个网站前端有一个这样的SQL语句：

INSERT INTO table VALUES ( ? )

问号部分，由用户输入并由前端代码填充。正常情况下，如果用户的注入一个
'DELETE FROM table'
，企图删除整个表，是不符合语法的，PG会返回错误。但利用这个漏洞，用户可以在PG接收这个SQL的时候，撤销这次SQL操作，如果用户发起一个Query Cancellation，最终向后台进程发SIGINT信号，则可能会导致后台进程跳转到新消息读取阶段，继续读取消息。此时如果恰好读取到DELETE语句的开头，那么就可以把注入的SQL作为一个新的完整SQL成功执行。

此漏洞直接的修复方法是，在读取一个消息过程中，设置一个状态标识，表明目前正在读取消息的阶段。当发生Query Cancellation中断或者其他会造成中断处理的错误，后台进程跳转到中断处理代码，回滚当前事务后，检测状态标识。如果状态标识被设置，说明是从消息读取阶段被中断的，则直接使用elog( FATAL,…)退出后台进程，并断开连接，

CVE-2015-0241

这个漏洞涉及两个小问题：

一个是to_char代码里面在处理localized month（在具体某个locale下的月份名，例如，”January”在中文locale里面是”一月”）和 localized week day（具体某个locale下得星期的名称，例如，”Monday”在中文里面是”星期一”）时，使用的数组过小，在某些locale下面可能指针越界。

另一个小问题是，to_char在将输入的float类型转换为字符串时，如果指定格式的字符串过长，可能造成存放结果的数组不够大而内存越界。

为修复此漏洞，在下面的文件里面增大了处理数组长度，并加入了对长度的判断。

src/backend/utils/adt/formatting.c

CVE-2015-0242

这个漏洞是PG自带的snprintf函数，在较大的精度要求时可能导致存放结果的数组过小而造成内存越界。这个问题只影响没有snprintf支持的平台。

CVE-2015-0243

只影响插件pgcrypto。主要由于此插件所使用的imath的版本有了变化，造成原来代码里面假设的所调用函数的返回值长度有变化，可能造成数组溢出。

CVE-2014-8161

由于疏忽，
BuildIndexValueDescription
, 
ExecBuildSlotValueDescription
以及 
ri_ReportViolation
等函数在打印出错信息时，会把用户无权知道的信息打印出来。例如，在插入数据到一个有非空约束的表中时，用户会看到如下的出错信息：

INSERT INTO t1 (c1) VALUES (5); 
ERROR:  null value in column "c2" violates not-null constraint
DETAIL:  Failing row contains (c1) = (5).

用户实际上没有查看c2这个字段的权限，所以不应该让其感知到c2字段的存在。而这个错误信息暴露了这一点。

再如，假设用户没有查看c1字段值的权限，只有查看c3字段的权限并且c3上有值域约束，则在对c3赋值时，如果使用一个不符合值域约束的值，会提示错误，并且错误信息会把c1的值打印出来：

UPDATE t1 SET c3 = 10; 
ERROR:  new row for relation "t1" violates check constraint "t1_c3_check"
DETAIL:  Failing row contains (c1, c3) = (1, 10).

这样用户很容易通过执行类似
update set c3 = "any value"
 的语句，把c1的值打出来，造成信息泄露。

  

    

		

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
