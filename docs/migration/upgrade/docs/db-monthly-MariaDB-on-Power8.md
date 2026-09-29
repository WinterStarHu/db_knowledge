# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/12/09/
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
                      

                    

 
        

    

  

    
 MariaDB · 社区动态 · MariaDB on Power8  

    
 Author: plinux  

  

  

  
前言

Power平台作为IBM的企业级平台，其稳定性和高效能在业界尤其是大型金融企业有着良好的口碑，MariaDB作为MySQL的重要开源分支，也对IBM Power8平台进行了适配。

很幸运我拿到了一台Power8的机器，在Linux on Power上成功编译了MariaDB 10.1版本，不过还没有拿到同规格的PC服务器用于对比，所以本期我先介绍一下MariaDB on Power的一些信息，下期月报我会拿出实测对比数据，并且分析一下MariaDB在Power平台和x86平台上关键路径的效率。

关于Power平台

与我们常见的x86平台不同，Power平台是RISC架构，而Intel的x86是CISC架构，早期的Mac也是采用PowerPC。

RISC相对于CISC，把主要的设计放在最常用的指令上，尽量使这些执行执行更加简单高效，对于不常用的指令，通过组合指令来完成。所以在实现特殊任务时，RISC会比CISC更复杂，但是因为RISC指令简单，可以更轻松的实现更多核数更多流水线来弥补。而且RISC单元电路少，功耗低，整体能耗水平会比CISC好很多。

数据库业务属于简单业务，如果一台主机只运行数据库，那么在x86下其实有很多指令集是完全用不上的，所以理论上单位面积更低功耗，更多流水线，更高频率的Power平台运行数据库会更加高效。

同时IBM也提供了Linux on Power，并且同时提供了大端、小端两种模式，而不再要求必须是AIX，毕竟Linux大部分人会更熟悉。

MariaDB对Power的适配

MariaDB迁移到Power8平台不仅仅是简单的修改代码让编译可以通过，当然这也是很重要的。

从 git log 中可以看到，官方针对Power和Intel平台的不同，例如
CACHE_LINE_SIZE
的差异，Intel平台是64，Power平台是128。还有
MEMORY_BARRIER
上的差异，也会导致在锁操作和部分IO操作上两个平台会有差异，MariaDB在这部分也做了修改。

另外为了能使用IBM Advance Toolchain工具集编译 MariaDB 提升效率，也对代码上做了不少改动以便IBM Advance Toolchain能使用。

总之看起来一切都很好，针对很多细节都做了针对性修改。

编译中的问题

既然广告看起来这么好，那么就亲自动手试一下。

在Power on Linux上我下载了MariaDB 10.1.9的源码用GCC编译然而报错了：

[ 52%] Building CXX object storage/innobase/CMakeFiles/innobase.dir/api/api0api.cc.o
In file included from /root/mariadb-10.1.9/storage/innobase/include/ut0ut.h:36,
 from /root/mariadb-10.1.9/storage/innobase/include/univ.i:636,
 from /root/mariadb-10.1.9/storage/innobase/api/api0api.cc:27:
/root/mariadb-10.1.9/storage/innobase/include/os0sync.h:521:4: error: #error "Unsupported platform"
[ 52%] Building CXX object storage/archive/CMakeFiles/archive.dir/ha_archive.cc.o
In file included from /root/mariadb-10.1.9/storage/innobase/include/ sync0sync.h:837,
 from /root/mariadb-10.1.9/storage/innobase/include/mem0mem.h:34,
 from /root/mariadb-10.1.9/storage/innobase/include/data0data.h:33,
 from /root/mariadb-10.1.9/storage/innobase/include/que0que.h:30,
 from /root/mariadb-10.1.9/storage/innobase/include/api0misc.h:32,
 from /root/mariadb-10.1.9/storage/innobase/api/api0api.cc:38:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic: In function ‘lock_word_t ib_mutex_test_and_set(ib_mutex_t*)’:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic:85: error: ‘os_atomic_test_and_set’ was not declared in this scope
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic: In function ‘void mutex_reset_lock_word(ib_mutex_t*)’:
/root/mariadb-10.1.9/storage/innobase/include/sync0sync.ic:113: error: ‘os_atomic_clear’ was not declared in this scope
make[2]: *** [storage/innobase/CMakeFiles/innobase.dir/api/api0api.cc.o] Error 1
make[1]: *** [storage/innobase/CMakeFiles/innobase.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....

查看了下报错的代码行：
storage/innobase/include/sync0sync.ic

ib_mutex_test_and_set(
/*==================*/
        ib_mutex_t*     mutex)  /*!< in: mutex */
{
#if defined(HAVE_ATOMIC_BUILTINS)
        return(os_atomic_test_and_set(&mutex->lock_word));
#else

storage/innobase/include/os0sync.h

469 # if defined(HAVE_IB_GCC_ATOMIC_TEST_AND_SET)
470
471 /** Do an atomic test-and-set.
472 @param[in,out]  ptr   Memory location to set to non-zero
473 @return the previous value */
474 inline
475 lock_word_t
476 os_atomic_test_and_set(volatile lock_word_t* ptr)
477 {
478        return(__atomic_test_and_set(ptr, __ATOMIC_ACQUIRE));
479 }
480
481 /** Do an atomic clear.
482 @param[in,out]  ptr   Memory location to set to zero */
483 inline
484 void
485 os_atomic_clear(volatile lock_word_t* ptr)
486 {
487   __atomic_clear(ptr, __ATOMIC_RELEASE);
488 }
489
490 # elif defined(IB_STRONG_MEMORY_MODEL)
491
492 /** Do an atomic test and set.
493 @param[in,out]  ptr   Memory location to set to non-zero
494 @return the previous value */
495 inline
496 lock_word_t
497 os_atomic_test_and_set(volatile lock_word_t* ptr)
498 {
499   return(__sync_lock_test_and_set(ptr, 1));

可以看到，只有在
HAVE_IB_GCC_ATOMIC_TEST_AND_SET
或
IB_STRONG_MEMORY_MODEL
至少有一个标签打开的情况，
ib_mutex_test_and_set()
中调用的
os_atomic_test_and_set()
函数才会被开启。

然而因为RHEL6的原因，在Power8平台上GCC只有
HAVE_ATOMIC_BUILTINS
和
__powerpc__
两个宏（升级到RHEL7可以解决）。因此就出现了这一幕，
ib_mutex_test_and_set
中调用了
os_atomic_test_and_set()
而
os_atomic_test_and_set()
在头文件中没有被定义。修改很简单啦，改成用同一个宏判断就行了。

跟官方开发者沟通后这个fix可以解决这个问题

diff --git a/storage/innobase/include/os0sync.h b/storage/innobase/include/os0sync.h
index 8e4b4f4..e192a3a 100644
--- a/storage/innobase/include/os0sync.h
+++ b/storage/innobase/include/os0sync.h
@@ -487,7 +487,7 @@ os_atomic_clear(volatile lock_word_t* ptr)
 	__atomic_clear(ptr, __ATOMIC_RELEASE);
 }

-# elif defined(IB_STRONG_MEMORY_MODEL)
+# elif defined(HAVE_ATOMIC_BUILTINS)

 /** Do an atomic test and set.
 @param[in,out]	ptr		Memory location to set to non-zero

最后说两句

虽然官方也是有性能测试结果的，然而显然我们是不能相信官方测试的。因此我还会构造场景针对CPU本身的效能进行测试，下一期大家期待测试结果吧。

最后放两张官方的测试结果，看起来还是很牛X的！

  

    

		

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
