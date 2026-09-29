# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/12/05/
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
                      

                    

 
        

    

  

    
 PgSQL · 特性分析 · 备库激活过程分析  

    
 Author: digoal  

  

  

  
前言

PostgreSQL standby 可以通过两种方法来激活成为主库：

  
trigger file，配置在recovery.conf中。

  
pg_ctl promote发送SIGUSR1信号给postmaster进程。

同时，PostgreSQL支持快速激活（fast promote）和非快速激活(fallback promote)：

  

fast promote
 开启数据库读写前，不需要做检查点。而是推到开启读写之后执行一个CHECKPOINT_FORCE检查点。

  

fallback_promote
 在开启数据库读写前，需要先做一个检查点，现在这个模式已经不对用户开放，需要修改代码，只是用作调试。

实现分析

激活数据库的代码分析如下：

激活过程，根据fast_promote变量判断是否需要先做检查点，再激活。

src/backend/access/transam/xlog.c
        if (InRecovery)
        {
                if (bgwriterLaunched)
                {
                        if (fast_promote)  // 如果是快速promote，在打开数据库读写前，不需要创建检查点。只需要创建一个recovery结束标记
                        {
                                checkPointLoc = ControlFile->prevCheckPoint;

                                record = ReadCheckpointRecord(xlogreader, checkPointLoc, 1, false);
                                if (record != NULL)
                                {
                                        fast_promoted = true;
                                        CreateEndOfRecoveryRecord();
                                }
                        }

                        if (!fast_promoted)  //  如果是fallback_promote模式，须先创建一个检查点，再开启读写模式。
                                RequestCheckpoint(CHECKPOINT_END_OF_RECOVERY |
                                                                  CHECKPOINT_IMMEDIATE |
                                                                  CHECKPOINT_WAIT);
                }
...

        InRecovery = false;    //  开启读写模式,允许接收用户写请求.

        LWLockAcquire(ControlFileLock, LW_EXCLUSIVE);
        ControlFile->state = DB_IN_PRODUCTION;   //  改写控制文件的数据库状态
        ControlFile->time = (pg_time_t) time(NULL);
        UpdateControlFile();   //  更新控制文件
        LWLockRelease(ControlFileLock);

...
        if (fast_promoted)   //  如果是快速promote，在允许用户写请求后，在这里执行一个检查点。所以提高了数据库的可用时间。
                RequestCheckpoint(CHECKPOINT_FORCE);
......

通过pg_ctl命令行工具，向postmaster发SIGUSR1信号，通知它激活数据库。
首先会写一个promote文件，告诉postmaster，是fast_promote。

src/bin/pg_ctl/pg_ctl.c
/*
 * promote
 */

static void
do_promote(void)
{
        FILE       *prmfile;
        pgpid_t         pid;
        struct stat statbuf;

        pid = get_pgpid(false);

......
        sig = SIGUSR1;
        if (kill((pid_t) pid, sig) != 0)  // 发送SIGUSR1信号，通知postmaster激活数据库。
        {
                write_stderr(_("%s: could not send promote signal (PID: %ld): %s\n"),
                                         progname, pid, strerror(errno));
                if (unlink(promote_file) != 0)
                        write_stderr(_("%s: could not remove promote signal file \"%s\": %s\n"),
                                                 progname, promote_file, strerror(errno));
                exit(1);
        }

        print_msg(_("server promoting\n"));
}

数据恢复时，检查standby是否收到promote请求或是否存在trigger文件。
如果是promote请求，则检查有没有promote文件，或者fallback_promote文件，如果有promote文件，则是fast_promote请求。如果有fallback_promote文件，则不是fast_promote请求（实际上根本不可能检测到fallback_promote文件，因为没有写这个文件的操作）。所以通过pg_ctl promote来激活，一定是fast promote的，即不需要先做检查点再激活。
如果检查到trigger文件，同样也是fast promote激活模式。

src/backend/access/transam/xlog.c
#define PROMOTE_SIGNAL_FILE             "promote"
#define FALLBACK_PROMOTE_SIGNAL_FILE "fallback_promote"

/*
 * Check to see whether the user-specified trigger file exists and whether a
 * promote request has arrived.  If either condition holds, return true.
 */
static bool
CheckForStandbyTrigger(void)
{
        struct stat stat_buf;
        static bool triggered = false;

        if (triggered)
                return true;

        if (IsPromoteTriggered())   // 检查是否收到pg_ctl promote信号
        {
......
                if (stat(PROMOTE_SIGNAL_FILE, &stat_buf) == 0)    // 先检查promote文件是否存在
                {
                        unlink(PROMOTE_SIGNAL_FILE);
                        unlink(FALLBACK_PROMOTE_SIGNAL_FILE);
                        fast_promote = true;    //  快速promote
                }
                else if (stat(FALLBACK_PROMOTE_SIGNAL_FILE, &stat_buf) == 0)  // 否则再检查fallback_promote文件是否存在
                {
                        unlink(FALLBACK_PROMOTE_SIGNAL_FILE);
                        fast_promote = false;    //  先执行checkpoint再promote
                }

                ereport(LOG, (errmsg("received promote request")));

                ResetPromoteTriggered();
                triggered = true;
                return true;
        }

        if (TriggerFile == NULL)   //  检查recovery.conf是否配置了trigger_file
                return false;

        if (stat(TriggerFile, &stat_buf) == 0)
        {
                ereport(LOG,
                                (errmsg("trigger file found: %s", TriggerFile)));
                unlink(TriggerFile);
                triggered = true;
                fast_promote = true;    //   快速promote
                return true;
        }
        else if (errno != ENOENT)
                ereport(ERROR,
                                (errcode_for_file_access(),
                                 errmsg("could not stat trigger file \"%s\": %m",
                                                TriggerFile)));

        return false;
}

src/backend/postmaster/startup.c
        pqsignal(SIGUSR2, StartupProcTriggerHandler);  // 注册SIGUSR2信号处理函数

/* SIGUSR2: set flag to finish recovery */
static void
StartupProcTriggerHandler(SIGNAL_ARGS)
{
        int                     save_errno = errno;

        promote_triggered = true;
        WakeupRecovery();

        errno = save_errno;
}

bool
IsPromoteTriggered(void)
{
        return promote_triggered;
}

postmaster收到SIGUSER1信号后，检查是否收到promote信号，判断当前的状态是否处于恢复中的任意状态，然后向startup进程发一个SIGUSR2的信号，触发promote。

src/backend/postmaster/postmaster.c

        pqsignal(SIGUSR1, sigusr1_handler); /* message from child process */  // 注册SIGUSR1信号处理函数

/*
 * sigusr1_handler - handle signal conditions from child processes
 */
static void
sigusr1_handler(SIGNAL_ARGS)
{
......
        if (CheckPromoteSignal() && StartupPID != 0 &&
                (pmState == PM_STARTUP || pmState == PM_RECOVERY ||
                 pmState == PM_HOT_STANDBY || pmState == PM_WAIT_READONLY))
        {
                /* Tell startup process to finish recovery */
                signal_child(StartupPID, SIGUSR2);  //  向startup进程发SIGUSR2信号，通知它处理promote
        }
......

src/backend/access/transam/xlog.c
/*
 * Check to see if a promote request has arrived. Should be
 * called by postmaster after receiving SIGUSR1.
 */
bool
CheckPromoteSignal(void)
{
        struct stat stat_buf;

        if (stat(PROMOTE_SIGNAL_FILE, &stat_buf) == 0 ||
                stat(FALLBACK_PROMOTE_SIGNAL_FILE, &stat_buf) == 0)
                return true;

        return false;
}

最后提一点， 9.3以前，曾经出现过pg_ctl promote -m 来指定是否需要fast promote或者fallback promote。

  

    

		

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
