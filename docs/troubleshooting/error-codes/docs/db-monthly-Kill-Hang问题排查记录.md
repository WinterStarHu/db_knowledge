# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/12/03/
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
	

  

    
数据库内核月报 － 2015 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 事务子系统介绍
                      

                    

                    

                  
                      

                        PgSQL · 特性介绍 · 全文搜索介绍
                      

                    

                    

                  
                      

                        MongoDB · 捉虫动态 · Kill Hang问题排查记录
                      

                    

                    

                  
                      

                        MySQL · 参数优化 ·RDS MySQL参数调优最佳实践
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 备库激活过程分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 让Hot Backup更完美
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 表膨胀
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · Index Condition Pushdown (ICP)
                      

                    

                    

                  
                      

                        MariaDB · 社区动态 · MariaDB on Power8
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 企业版特性一览
                      

                    

 
        

    

  

    
 MongoDB · 捉虫动态 · Kill Hang问题排查记录  

    
 Author: yexiang  

  

  

  
AliCloudDB MongoDB在开发过程中遇到一个无法正常退出的BUG，由于是Release版本的编译（-O3），debuginfo已经不能很好的展现出堆栈的情况。这时又该如何确定问题所在呢？本篇文章完整的记录了整个排查过程。

场景

kill命令正常执行，但进程迟迟没有退出。非必现场景，在批量回收资源时比较容易出现，平时开发测试时没有遇到。从场景上看出现的概率并不高，可能是在某种极端条件下才能触发，由于第一次收到报告后没有保留现场，先到官方JIRA平台上去搜相关的BUG，无果，又盲目的尝试了几个场景后只能先Hold住，等待下次出现。

排查

确认BUG方向

很幸运，第二天BUG再次出现，僵尸进程？死循环？死锁？没有收到Kill信号？无数想法蹦出来，迅速登陆机器，查看现场，先从最简单的可能性开始开始排查。

ps
 
top
第一套组合拳，排除了僵尸进程可能性，并且TOP显示CPU使用率为0并不高；strace继续跟进查看，也没有发现有系统调用，最后在补一个pstack打印堆栈信息，全部线程都在wait。BUG的排查方向大致确定：线程间资源同步的问题（当然也不能排除是其他的可能性）。

确认代码范围

详细分析pstack内容，从堆栈信息中看一个长相特别的（其他大部分的线程堆栈都是雷同的）：

Thread 46 (Thread 0x2b5f079be700 (LWP 613)):
#0  0x000000301800b43c in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
#1  0x0000000000fec763 in boost::thread::join() ()
#2  0x0000000000c8eebc in mongo::repl::ReplicationCoordinatorExternalStateImpl::shutdown() ()
#3  0x0000000000c93fed in mongo::repl::ReplicationCoordinatorImpl::shutdown() ()
#4  0x0000000000ad2463 in mongo::exitCleanly(mongo::ExitCode) ()
#5  0x0000000000f9c176 in ?? ()
#6  0x0000000000feb384 in ?? ()
#7  0x0000003018007851 in start_thread () from /lib64/libpthread.so.0
#8  0x000000300a4e767d in clone () from /lib64/libc.so.6

从函数名上看起来是MongoDB退出的关键路径，就从这里入手，人肉翻下源码：

 97 void ReplicationCoordinatorExternalStateImpl::shutdown() {
 98     boost::lock_guard<boost::mutex> lk(_threadMutex);
 99     if (_startedThreads) {
100         log() << "Stopping replication applier threads";
101         _syncSourceFeedback.shutdown();
102         _syncSourceFeedbackThread->join();
103         _applierThread->join();
104         BackgroundSync* bgsync = BackgroundSync::get();
105         bgsync->shutdown();
106         _producerThread->join();
107     }
108 }

这么多的join，到底是哪个呢。上GDB，我们来看看Thread 46到底在等谁。先加载symbol-file，失败，加载后堆栈变得更乱了，换
disassemble
命令，显示汇编信息：

   0x0000000000c8ee6b <+75>:	mov    %rsp,%rdi
   0x0000000000c8ee6e <+78>:	callq  0xdc8670 <_ZN5mongo6logger16LogstreamBuilder10makeStreamEv>
   0x0000000000c8ee73 <+83>:	mov    0x20(%rsp),%rdi
   0x0000000000c8ee78 <+88>:	lea    0x86e299(%rip),%rsi        # 0x14fd118
   0x0000000000c8ee7f <+95>:	mov    $0x24,%edx
   0x0000000000c8ee84 <+100>:	callq  0x1456550 <_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l>
   0x0000000000c8ee89 <+105>:	mov    %rsp,%rdi
   0x0000000000c8ee8c <+108>:	callq  0xdc88d0 <_ZN5mongo6logger16LogstreamBuilderD2Ev>
   0x0000000000c8ee91 <+113>:	lea    0x38(%rbp),%rdi
   0x0000000000c8ee95 <+117>:	callq  0xcce810 <_ZN5mongo4repl18SyncSourceFeedback8shutdownEv>
   0x0000000000c8ee9a <+122>:	mov    0xe8(%rbp),%rdi
   0x0000000000c8eea1 <+129>:	test   %rdi,%rdi
   0x0000000000c8eea4 <+132>:	je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eea6 <+134>:	callq  0xfec600 <_ZN5boost6thread4joinEv>
   0x0000000000c8eeab <+139>:	mov    0xf0(%rbp),%rdi
   0x0000000000c8eeb2 <+146>:	test   %rdi,%rdi
   0x0000000000c8eeb5 <+149>:	je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eeb7 <+151>:	callq  0xfec600 <_ZN5boost6thread4joinEv>
=> 0x0000000000c8eebc <+156>:	callq  0xc284a0 <_ZN5mongo4repl14BackgroundSync3getEv>
   0x0000000000c8eec1 <+161>:	mov    %rax,%rdi
   0x0000000000c8eec4 <+164>:	callq  0xc27f60 <_ZN5mongo4repl14BackgroundSync8shutdownEv>
   0x0000000000c8eec9 <+169>:	mov    0xf8(%rbp),%rdi
   0x0000000000c8eed0 <+176>:	test   %rdi,%rdi
   0x0000000000c8eed3 <+179>:	je     0xc8ef14 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+244>
   0x0000000000c8eed5 <+181>:	callq  0xfec600 <_ZN5boost6thread4joinEv>
   0x0000000000c8eeda <+186>:	nopw   0x0(%rax,%rax,1)
   0x0000000000c8eee0 <+192>:	mov    %rbx,%rdi
   0x0000000000c8eee3 <+195>:	callq  0x804a38 <pthread_mutex_unlock@plt>
   0x0000000000c8eee8 <+200>:	cmp    $0x4,%eax
   0x0000000000c8eeeb <+203>:	je     0xc8eee0 <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+192>
   0x0000000000c8eeed <+205>:	test   %eax,%eax
   0x0000000000c8eeef <+207>:	jne    0xc8ef0f <_ZN5mongo4repl39ReplicationCoordinatorExternalStateImpl8shutdownEv+239>
   0x0000000000c8eef1 <+209>:	add    $0x38,%rsp
   0x0000000000c8eef5 <+213>:	pop    %rbx
   0x0000000000c8eef6 <+214>:	pop    %rbp
   0x0000000000c8eef7 <+215>:	pop    %r12
   0x0000000000c8eef9 <+217>:	pop    %r13
   0x0000000000c8eefb <+219>:	retq

查看
0x0000000000c8eeb7
地址的上下文，通过前后指令的函数符号名确定了目前代码是在
_applierThread->join()
，这里可以思考下是否还有的其他方法获得代码行。

_applierThread
 同样也是个线程，如果shutdown在等它，那它又在等谁呢，回头继续查pstack输出，找到相关的堆栈：

Thread 34 (Thread 0x2b5f0a6d8700 (LWP 1355)):
#0  0x000000301800b43c in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
#1  0x0000000000c2687b in mongo::repl::BackgroundSync::waitUntilPaused() ()
#2  0x0000000000cd192e in mongo::repl::SyncTail::tryPopAndWaitForMore(mongo::OperationContext*, mongo::repl::SyncTail::OpQueue*, mongo::repl::ReplicationCoordinator*) ()
#3  0x0000000000cd2823 in mongo::repl::SyncTail::oplogApplication() ()
#4  0x0000000000ccaaaf in mongo::repl::runSyncThread() ()
#5  0x0000000000feb384 in ?? ()
#6  0x0000003018007851 in start_thread () from /lib64/libpthread.so.0
#7  0x000000300a4e767d in clone () from /lib64/libc.so.6

注意这里与shutdown的等待是不同的，shutdown是在等待线程退出，而这里是在等待某个条件变量，再次上GDB，查看Thread 34 & backtrace 1, 
info locals
：

_lastOpTimeFetched = {i = 4, secs = 1448986976}, 
_lastAppliedHash = 3485900536827542548, 
_lastFetchedHash = 3485900536827542548, 
_pause = false, 
_pausedCondition = {internal_mutex = 
	{	__data = 
		{__lock = 0, __count = 0, __owner = 0, __nusers = 1, __kind = 0, __spins = 0, __list = 
			{__prev = 0x0, __next = 0x0}
		},
		__size = '\000' <repeats 12 times>, "\001", '\000' <repeats 26 times>, __align = 0
	}

找到代码BUG

看看代码怎么写的吧：

469 void BackgroundSync::waitUntilPaused() {
470     boost::unique_lock<boost::mutex> lock(_mutex);
471     while (!_pause) {
472         _pausedCondition.wait(lock);
473     }
474 }

_pause
变量一直都是0，所以会hang在这里。继续查看代码，跟踪
_pausedCondition
的调用，有两个函数会去唤醒，一个是stop，另一个是shutdown，但shutdown的调用应该在线程退后调用，以便释放资源。

同时，再次回过来在pstack中查看
BackgroundSync
的堆栈信息，想看看到底卡在了哪里。结果找不到
BackgroundSync
线程，问题更清晰了，所有
_pausedCondition
条件变量的唤醒，都是在该线程中完成的，如果
BackgroundSync
已经不存在了，一定会hang住。

再反复阅读代码，
BackgroundSync
在判断到
inShutdown()
时会自动结束生命周期，但结束后并没有更改
_pause
状态。

FIX BUG

解决办法是线程最后退出前执行stop函数，修改
_pause
状态，（shutdown会提前释放资源），查看官方最最新代码，确认有同样的修改，反向追踪提交，找到相关
JIRA
，抱怨JIRA的搜索弱爆了。

复现和验证

为何该BUG出现的频率会非常低呢，主要在判断是否等待的条件上：

if (replCoord->isWaitingForApplierToDrain()) {
506                 BackgroundSync::get()->waitUntilPaused();
507                 if (peek(&op)) {
508                     // The producer generated a last batch of ops before pausing so return
509                     // false so that we'll come back and apply them before signaling the drain
510                     // is complete.
511                     return false;
512                 }
513                 replCoord->signalDrainComplete(txn);
514             }

1908         case kActionWinElection: {
1909             boost::unique_lock<boost::mutex> lk(_mutex);
1910             _electionId = OID::gen();
1911             _topCoord->processWinElection(_electionId, getNextGlobalOptime());
1912             _isWaitingForDrainToComplete = true;
1913             const PostMemberStateUpdateAction nextAction =
1914                 _updateMemberStateFromTopologyCoordinator_inlock();
1915             invariant(nextAction != kActionWinElection);
1916             lk.unlock();
1917             _performPostMemberStateUpdateAction(nextAction);
1918             break;
1919         }

也就是说刚刚赢得了选举后会产生
_isWaitingForDrainToComplete == true
状态，恰巧这个时间窗口内进程接受到退出信号。复现的办法就是在
kActionWinElection 
的后面加上sleep，以此来延长时间窗口，当然也可以通过GDB BLOCK的方式来复现。

  

    

		

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
