# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/03/04/
> 分类: BUG分析

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
	

  

    
数据库内核月报 － 2016 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · TokuDB · 事务子系统和 MVCC 实现
                      

                    

                    

                  
                      

                        MongoDB · 特性分析 · MMAPv1 存储引擎原理
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · 优化器逻辑推理
                      

                    

                    

                  
                      

                        SQLServer · BUG分析 · Agent 链接泄露分析
                      

                    

                    

                  
                      

                        Redis · 特性分析 · AOF Rewrite 分析
                      

                    

                    

                  
                      

                        MySQL · BUG分析 · Rename table 死锁分析
                      

                    

                    

                  
                      

                        MySQL · 物理备份 · Percona XtraBackup 备份原理
                      

                    

                    

                  
                      

                        GPDB · 特性分析· GreenPlum FTS 机制
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 备库Seconds_Behind_Master计算
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 锁问题最佳实践
                      

                    

 
        

    

  

    
 SQLServer · BUG分析 · Agent 链接泄露分析  

    
 Author: 天铭  

  

  

  
背景

SQLServer Agent作为Windows服务提供给用户定期执行管理任务，这些任务被称为Job；考虑应用镜像的场景如何解决Job同步问题，AWS RDS的做法是不予理会，由用户维护Job，假如发生切换用户需要在新的Principal端创建Job；另一种做法是镜像端保持同步Job，切换后尽量让用户无感知不需要多余维护动作，但这种做法在某些情况会遇到非常严重的问题——内存耗尽。

问题排查分析

第一次分析

问题发生时实例的ERRORLOG出现：

Error: 701, Severity: 17, State: 123.

并且记录了 MEMORYSTATUS，根据 MEMORYSTATUS 的信息本身已经可以做推断，但既然有现场 我们不妨用DAC（Dedicated Administrator Connection）看一下：

SELECT
	TOP 10 [type],
	sum ( single_pages_kb) as [SPA MEM/KB],
	SUM(multi_pages_kb) AS [MPA MEM/KB]
FROM sys.dm_os_memory_clerks
	GROUP BY type
	ORDER BY SUM ( single_pages_kb+multi_pages_kb) DESC ;

占用最多的 OBJECTSTORE_SNI_PACKET、MEMORYCLERK_SQLCONNECTIONPOOL 一般跟连接数、network packet size有关；

select
	c.session_id,
	c.net_packet_size,
	s.host_name as client_host_name,
	s.program_name,
	s.client_interface_name
from sys.dm_exec_connections c
join sys.dm_exec_sessions s
	on c.session_id = s.session_id
join sys.endpoints e
	on c.endpoint_id = e.endpoint_id
order by c.net_packet_size desc

select value_in_use from sys.configurations where configuration_id=1544

select program_name,count(*) as conn_num from sys.sysprocesses where spid>50 group by program_name order by conn_num desc

1W+的链接保持，根据
sys.dm_exec_sessions.program_name
可以确认都来自SQLServer Agent，每个session的packet size是4K，实例的max server memory是1G，所以出现内存耗尽；

那么这1W个链接在干嘛？根据
sys.dm_exec_sessions.program_name
中暴露的job_id我们找到对应的Job，先看下这个Job要做什么；

select * from msdb.dbo.sysjobs where job_id=0x825F84340AFD5B4BA1D5AD82A8E76C1A

第一次推论

这部分内容涉及业务逻辑我不再贴出，重点是Job_Step使用的DATABASE是镜像中的（RESTORING），因为镜像的DB不可用，Schedule又设置的过于频繁，所以SQLServer Agent没能及时释放这部分链接导致内存耗尽。

第一次验证

重新搭建了一个测试环境，制造类似的场景但问题并没能复现。感兴趣的小伙伴可以测试下：镜像 + Mirror端Job + Job链接镜像库且频度调成10s + Job内容不限（为什么不限后续通过Profiler可以看出）。

借助Profiler和Session相关视图我们可以看出，当Job-Step的链接DB设置为镜像DB时，会出现：

Error: 18456, Severity: 14, State: 38.

表示账号校验成功但数据库不可访问或登录权限不够，SQLServer Agent会重试多次，但最后都会释放链接，这跟之前的推论不符。

select program_name,count(*) as conn_num from sys.sysprocesses where spid>50 group by program_name order by conn_num desc

第二次分析

回到原现场，我们再做分析；尝试复现时我们发现完整的链接都无法建立，但这1W个链接是如何做到的：

select spid,program_name,loginame,login_time as time,db_name(dbid) as dbname from sys.sysprocesses where spid>50

根据spid我们看一下未释放的链接最后执行的SQL是什么：

(@P1 nvarchar(max),@P2 uniqueidentifier,@P3 int,@P4 int)DECLARE @logTextWithPreAndPost nvarchar(max) set @logTextWithPreAndPost = N'' + @P1 + N''; EXECUTE msdb.dbo.sp_write_sysjobstep_log @job_id = @P2, @step_id = @P3, @log_text=@logTextWithPreAndPost, @append_to_last=@P4

看下 
msdb.dbo.sp_write_sysjobstep_log
这个存储过程：

exec sp_helptext 'sp_write_sysjobstep_log'

	Text
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_write_sysjobstep_log
  @job_id    UNIQUEIDENTIFIER,
  @step_id   INT,
  @log_text  NVARCHAR(MAX),
  @append_to_last INT = 0
AS
BEGIN
  DECLARE @step_uid UNIQUEIDENTIFIER
  DECLARE @log_already_exists int
  SET @log_already_exists = 0

  SET @step_uid = ( SELECT step_uid FROM  msdb.dbo.sysjobsteps
      WHERE (job_id = @job_id)
        AND (step_id = @step_id) )

  IF(EXISTS(SELECT * FROM msdb.dbo.sysjobstepslogs
                      WHERE step_uid = @step_uid ))
  BEGIN
     SET @log_already_exists = 1
  END

  --Need create log if "overwrite is selected or log does not exists.
  IF (@append_to_last = 0) OR (@log_already_exists = 0)
  BEGIN
     -- flag is overwrite

     --if overwrite and log exists, delete it
     IF (@append_to_last = 0 AND @log_already_exists = 1)
     BEGIN
        -- remove previous logs entries
        EXEC sp_delete_jobsteplog @job_id, NULL, @step_id, NULL
     END

     INSERT INTO msdb.dbo.sysjobstepslogs
      (
         log,
         log_size,
         step_uid
      )
      VALUES
      (
         @log_text,
         DATALENGTH(@log_text),
         @step_uid
      )
  END
  ELSE
  BEGIN
     DECLARE @log_id   INT
     --Selecting TOP is just a safety net - there is only one log entry row per step.
     SET @log_id = ( SELECT TOP 1 log_id FROM msdb.dbo.sysjobstepslogs
         WHERE (step_uid = @step_uid)
           ORDER BY log_id DESC )

      -- Append @log_text to the existing log record. Note that if this
      -- action would make the value of the log column longer than
      -- nvarchar(max), then the engine will raise error 599.
      UPDATE msdb.dbo.sysjobstepslogs
        SET
             log .WRITE(@log_text,NULL,0),
             log_size = DATALENGTH(log) + DATALENGTH(@log_text) ,
             date_modified = getdate()
      WHERE log_id = @log_id
  END

  RETURN(@@error) -- 0 means success

END

MSDN 没有找到详尽 Document，但看完定义也可以确认它是Job-Step做Advanced配置时会用到的一个存储过程，作用是把Job-Step日志写到表 msdb.dbo.sysjobstepslogs 中，根据参数的不同可能会overwrite或append；

第二次推论

根据之前的信息我们可以推测出，这1W+空闲链接是由于执行完Job-Step后，内部更新msdb的日志表，更新完成后链接未释放。

第二次验证

构造的场景跟第一次基本相同，只需要增加一点的是Job-Step开启了log to table。

结果稳定复现，40s左右新增一个链接（Schedule 10s 不开启Step Retry attempts 和 Retry interval），根据msdb.dbo.sysjobstepslogs.log_size和msdb.dbo.sysjobstepslogs.log可以确认日志的更新频度在40s。

开启Profiler、不断调整Schedule时间、监控msdb.dbo.sysjobstepslogs.log_size大小，可以发现，当调度频度大于40s时，新增链接按照频度增加，当频度小于40s时，新增链接按照40s一个增加。

结论

如果Job-Step中定义的链接 DATABASE 是镜像库（RESTORING）且配置了Log To Table，那么每次做日志记录的Session（msdb.dbo.sysjobstepslogs）都不会自动关闭，即Agent在这种场景下存在链接泄露。

  

    

		

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
