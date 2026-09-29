# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/01/06/
> 分类: performance/tuning

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
	

  

    
数据库内核月报 － 2018 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL ·  引擎特性 ·  Group Replication内核解析之二
                      

                    

                    

                  
                      

                        MySQL ·  引擎特性 ·  MySQL内核对读写分离的支持
                      

                    

                    

                  
                      

                        PgSQL · 内核解析 · 同步流复制实现分析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · UK 包含 NULL 值备库延迟分析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Error in munmap() "Cannot allocate memory"
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 数据库备份链
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 字符集相关变量介绍及binlog中字符集相关缺陷分析
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  传统分库分表(sharding)的缺陷与破解之法
                      

                    

                    

                  
                      

                        MySQL · MyRocks · MyRocks参数介绍
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  惊天性能！单RDS PostgreSQL实例支撑 2000亿
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 数据库备份链  

    
 Author: 风移  

  

  

  
摘要

在SQL Server备份专题分享中，前两期我们分享了三种常见的备份以及备份策略的制定，在第三期分享中，我们将要分享SQL Server的数据库备份链。完整的数据库备份链是保证数据库能够实现灾难恢复的基础，如果备份链条被打断或者备份链条上的文件损坏，势必会导致数据恢复不完整或者不能满足预期，而造成数据丢失，危害数据完整性生命线，后果非常严重。所以，理解SQL Server数据库备份链非常重要。

MSSQL· 最佳实践· SQL Server三种常见备份

MSSQL · 最佳实践 · SQL Server备份策略

场景引入

在开始今天关于SQL Server数据库备份链的分享之前，我们还是以上一期SQL Server备份策略分享的场景引入。假设我们存在如下图所示的备份文件列表，为什么我们就可以使用“全备 + 差备 + 日志备份”来实现快速的数据库还原操作呢？我们又是如何快速的查找到TestDR数据库的备份链条，并以此来还原的呢？这两个话题是我们今天要解答和解决的。
TestDR数据库备份文件列表如下图所示：

LSN介绍

在解决今天的问题之前，我需要首先介绍一个非常重要的概念：LSN。SQL Server的每一个事务日志都有自己的唯一标识号Log Sequence Number(简写为LSN)。LSN会随着时间的推移和事务日志的产生而不断增大。那么在SQL Server中如何查看以及有几种类型的LSN呢？

备份文件LSN

在SQL Server中，查看备份的LSN非常简单，我们可以使用RESTORE HEADERONLY命令跟上备份文件路径，即可查看。

RESTORE HEADERONLY FROM DISK='C:\Temp\TestDR_20171217@00:00_FULL.bak'
RESTORE HEADERONLY FROM DISK='C:\Temp\TestDR_20171217@01:00_LOG.trn'

执行的展示结果如下：

LSN种类

从以上截图红色方框中我们可以看出来，SQL Server的LSN分为以下四类：

  
FirstLSN：备份集中第一个事务日志的LSN；

  
LastLSN：备份集中最后一个事务日志的下一个LSN；

  
CheckpointLSN：最后一个Checkpoint发生时的LSN；

  
DatabaseBackupLSN：最后一个FULL Backup备份的LSN。

备份链原理

LSN是查找SQL Server 数据库备份链不可或缺的神一般存在的关键信息。我们可以利用前面讲到的四类LSN，使用如下五步骤来实现SQL Server备份链的查找。

  
获取Full Backup: 查找最新一个FULL Backup文件，拿到对应CheckpointLSN；

  
获取Diff Backup：查找Diff Backup文件，Diff Backup文件的DatabaseBackupLSN等于第一步中的CheckpointLSN，如果有多个Diff Backup文件，取FirstLSN最大者，然后拿到相应LastLSN；

  
获取第一个Log Backup：查找第二步中的LastLSN位于Log Backup文件的FirstLSN和LastLSN之间的Log Backup，并获取相应的LastLSN；

  
获取下一个Log Backup: 下一个Log Backup文件的FirstLSN等于第三步中获取到额LastLSN；

  
获取第N个Log Backup：按照步骤四中的方法查找，直到所有日志文件查找完毕后，一个完整的备份链条查找完毕。

以上的理论解释稍显枯燥，我们用具体的示例来解释，就显得更为丰满和易于理解。我们把“场景引入”中的十五个备份文件，参照“备份文件LSN”中的方法来获取到LSN，如下面的截图所示：

那么，TestDR数据库的备份链可以通过如下的方法来查找：

  
获取Full Backup: 查找最新一个FULL Backup（BackType=1）文件，拿到CheckpointLSN：24000000012800197，图中红色方框标示；

  
获取Diff Backup：查找Diff Backup（BackType=5）文件，Diff Backup文件的DatabaseBackupLSN等于第一步中的CheckpointLSN:24000000012800197，图中黄色方框标示，取FirstLSN最大者: 24000000037600007，然后拿到LastLSN: 24000000039200001；

  
获取第一个Log Backup：查找第二步中的LastLSN（24000000039200001）位于Log Backup（BackType=5）的FirstLSN（24000000036800001）与LastLSN（24000000040000001）之间的Log Backup，如图中绿色方框标示，并获取到LastLSN：24000000040000001；

  
获取下一个Log Backup: 下一个Log Backup文件的FirstLSN（24000000040000001）应该等于上一步获取到额LastLSN，如图中粉红色标示；

  
获取第N个Log Backup：按照步骤四中的方法查找，直到所有日志文件查找完毕。
所以，我们最终获取到的TestDR数据库的最简单，快速恢复的备份链是：

C:\Temp\TestDR_20171217@00:00_FULL.bak => C:\Temp\TestDR_20171217@12:00_DIFF.bak => C:\Temp\TestDR_20171217@13:00_LOG.trn => C:\Temp\TestDR_20171217@14:00_LOG.trn。

这个链条和我们上一期分享的数据库备份文件还原操作是完全吻合的。

具体实现

在“备份链原理”章节中，我们找出备份链是通过“用眼睛看”的查找方式来实现的。但是现实中如果数据库实例众多，数据库纷繁复杂，用眼睛看的方法就显得低效而准确率不高。那么，如何实现数据库备份链的自动查找呢？不着急，我已经为大家写好了，你只需要把相同数据库的多个备份文件路径放入输入参数中，我们就非常轻松、快捷的查找到数据库的备份链，并以此为依据来还原数据库。还是以TestDR的十五个备份文件为例来查找备份链条，代码如下：

USE master
GO

SET NOCOUNT ON
DECLARE
-- all the backup files
	@backup_file_list NVARCHAR(MAX) = N'
C:\Temp\TestDR_20171217@00:00_FULL.bak
C:\Temp\TestDR_20171217@01:00_LOG.trn
C:\Temp\TestDR_20171217@02:00_LOG.trn
C:\Temp\TestDR_20171217@03:00_LOG.trn
C:\Temp\TestDR_20171217@04:00_LOG.trn
C:\Temp\TestDR_20171217@05:00_LOG.trn
C:\Temp\TestDR_20171217@06:00_DIFF.bak
C:\Temp\TestDR_20171217@07:00_LOG.trn
C:\Temp\TestDR_20171217@08:00_LOG.trn
C:\Temp\TestDR_20171217@09:00_LOG.trn
C:\Temp\TestDR_20171217@10:00_LOG.trn
C:\Temp\TestDR_20171217@11:00_LOG.trn
C:\Temp\TestDR_20171217@12:00_DIFF.bak
C:\Temp\TestDR_20171217@13:00_LOG.trn
C:\Temp\TestDR_20171217@14:00_LOG.trn
'
;

-- Create temp table to save headeronly info
IF OBJECT_ID('tempdb..#headeronly') IS NOT NULL
	DROP TABLE #headeronly
CREATE TABLE #headeronly(
	RowId INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,BackupName	nvarchar(128) NULL
	,BackupDescription	nvarchar(255) NULL	
	,BackupType	smallint  NULL
	,ExpirationDate	datetime
	,Compressed	bit  NULL
	,Position	smallint  NULL	
	,DeviceType	tinyint	 NULL
	,UserName	nvarchar(128)  NULL	
	,ServerName	nvarchar(128)  NULL	
	,DatabaseName	nvarchar(128)  NULL
	,DatabaseVersion	int	  NULL
	,DatabaseCreationDate	datetime  NULL
	,BackupSize	numeric(20,0)  NULL
	,FirstLSN	numeric(25,0)  NULL
	,LastLSN	numeric(25,0)  NULL
	,CheckpointLSN	numeric(25,0)  NULL
	,DatabaseBackupLSN	numeric(25,0)  NULL
	,BackupStartDate	datetime  NULL
	,BackupFinishDate	datetime  NULL
	,SortOrder	smallint  NULL
	,CodePage	smallint  NULL
	,UnicodeLocaleId	int  NULL
	,UnicodeComparisonStyle	int  NULL
	,CompatibilityLevel	tinyint  NULL
	,SoftwareVendorId	int  NULL
	,SoftwareVersionMajor	int  NULL
	,SoftwareVersionMinor	int  NULL
	,SoftwareVersionBuild	int  NULL
	,MachineName	nvarchar(128)  NULL
	,Flags	int  NULL
	,BindingID	uniqueidentifier  NULL
	,RecoveryForkID	uniqueidentifier  NULL
	,Collation	nvarchar(128)  NULL
	,FamilyGUID	uniqueidentifier  NULL
	,HasBulkLoggedData	bit  NULL
	,IsSnapshot	bit  NULL
	,IsReadOnly	bit  NULL
	,IsSingleUser	bit  NULL
	,HasBackupChecksums	bit  NULL
	,IsDamaged	bit  NULL
	,BeginsLogChain	bit  NULL
	,HasIncompleteMetaData	bit  NULL
	,IsForceOffline	bit  NULL
	,IsCopyOnly	bit  NULL
	,FirstRecoveryForkID	uniqueidentifier   NULL
	,ForkPointLSN	numeric(25,0) NULL
	,RecoveryModel	nvarchar(60)  NULL
	,DifferentialBaseLSN	numeric(25,0)  NULL
	,DifferentialBaseGUID	uniqueidentifier  NULL
	,BackupTypeDescription	nvarchar(60)  NULL
	,BackupSetGUID	uniqueidentifier NULL
	,CompressedBackupSize	bigint  NULL
);

-- private variables
DECLARE
	@backup_file_list_xml xml
	,@backup_file sysname
	,@row_count int
	,@do int = 0
	,@sql NVARCHAR(MAX) = N''
	,@full_backup_CheckPointLSN numeric(25,0)
	,@full_backup_familyGUID uniqueidentifier
	,@diff_backup_LastLSN numeric(25,0)
	,@log_backup_LastLSN numeric(25,0)
	,@back_chain_level_number INT = 0
	,@full_backup_rowid INT
	,@diff_backup_rowid INT
;

SELECT
	@backup_file_list_xml = '<V><![CDATA[' + REPLACE(
													REPLACE(
																REPLACE(
																			@backup_file_list,CHAR(10),']]></V><V><![CDATA['
																		),',',']]></V><V><![CDATA['
															),CHAR(13),']]></V><V><![CDATA['
												  ) + ']]></V>'
;

DECLARE
	@tb_back_files TABLE(
	Rowid INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	backup_file sysname not null
);

DECLARE
	@tb_back_file_rowid TABLE(
	Bak_row_id INT NOT NULL,
	Level_Number INT NOT NULL
);

-- split backup files into @table
INSERT INTO @tb_back_files
SELECT 
	DISTINCT	
	backup_file = RTRIM(LTRIM(T.C.value('(./text())[1]','sysname'))) 
FROM @backup_file_list_xml.nodes('./V') AS T(C)
WHERE T.C.value('(./text())[1]','sysname') IS NOT NULL
	AND LEFT(RTRIM(LTRIM(T.C.value('(./text())[1]','sysname'))), 2) <> '--'
ORDER BY 1 ASC

-- cursor for each backup file to get headeronly info 
DECLARE CUR_backup_file CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR
SELECT 	
	 backup_file
FROM @tb_back_files
ORDER BY Rowid ASC

OPEN CUR_backup_file
FETCH NEXT FROM CUR_backup_file INTO @backup_file

SET @row_count = @@CURSOR_ROWS

WHILE @@FETCH_STATUS = 0
BEGIN
	RAISERROR('--=== %d/%d ===Processing on %s', 10, 1, @do, @row_count, @backup_file) WITH NOWAIT
	SET
		@sql = N'RESTORE HEADERONLY FROM DISK = N' + QUOTENAME(@backup_file, '''') + N';'
	; 
	INSERT INTO #headeronly
	EXEC sys.sp_executesql @sql
	;

	SET @do = @do + 1
	FETCH NEXT FROM CUR_backup_file INTO @backup_file
END

CLOSE CUR_backup_file
DEALLOCATE CUR_backup_file

/**
* FULL backup file checking
*1. make sure those backup files came from the same database.
*2. there is  no full backup
*3. There have more than one FULL backup files.
*/
-- make sure backup files came from the same database.
IF EXISTS(
	SELECT TOP 1 1
	FROM #headeronly
	GROUP BY FamilyGUID
	HAVING COUNT(DISTINCT FamilyGUID) >= 2
)
BEGIN
	RAISERROR('Those backup fils didn''t backup from the same database, process terminated.', 16, 1) WITH NOWAIT
	RETURN
END

-- There is no full backup file
IF NOT EXISTS(
	SELECT TOP 1 1
	FROM #headeronly
	WHERE BackupType = 1 -- FULL Backup
)
BEGIN
	RAISERROR('There is no FULL BACKUP included, process terminated.', 16, 1) WITH NOWAIT
	RETURN
END

-- Have more than one FULL Backup, we don't know use which one.
IF EXISTS(
	SELECT TOP 1 1
	FROM #headeronly
	WHERE BackupType = 1
	GROUP BY BackupType
	HAVING COUNT(1) >= 2
)
BEGIN
	RAISERROR('Those backup fils are more than one FULL BACKUP including, we may don''t know use which one, process terminated.', 16, 1) WITH NOWAIT
	RETURN
END

-- We have only one full backup, get FULL Backup file CheckPointLSN
SELECT TOP 1 
	@full_backup_CheckPointLSN = CheckPointLSN
	,@full_backup_familyGUID = FamilyGUID
	,@back_chain_level_number = 0
	,@full_backup_rowid = RowId
FROM #headeronly
WHERE BackupType = 1

INSERT INTO @tb_back_file_rowid
SELECT @full_backup_rowid, @back_chain_level_number;

PRINT 'We got full backup check point LSN: ' + cast(@full_backup_CheckPointLSN as varchar)

/**
*get the very last diff backup file
**/
-- if exists diff backup, get the newest one whose DatabaseBackupLSN equals @full_backup_CheckPointLSN got above
IF EXISTS(
	SELECT TOP 1 1
	FROM #headeronly
	WHERE BackupType = 5 -- DIFF Backup
		AND DatabaseBackupLSN = @full_backup_CheckPointLSN
		AND FamilyGUID = @full_backup_familyGUID
)
BEGIN
	RAISERROR('We are searching the Differential Database Backup.', 10, 1) WITH NOWAIT

	SELECT TOP 1 
		@diff_backup_LastLSN = LastLSN
		,@back_chain_level_number = @back_chain_level_number + 1
		,@diff_backup_rowid = RowId
	FROM #headeronly
	WHERE BackupType = 5 -- DIFF Backup
		AND DatabaseBackupLSN = @full_backup_CheckPointLSN
		AND FamilyGUID = @full_backup_familyGUID
	ORDER BY FirstLSN DESC -- get the max firstLSN (means newest one)

	INSERT INTO @tb_back_file_rowid
	SELECT @diff_backup_rowid, @back_chain_level_number;

	PRINT 'We got newest Differential backup Last LSN: ' + cast(@diff_backup_LastLSN as varchar)
END
ELSE
	RAISERROR('We didn''t find any differential backups yet match the full backup.', 10, 1) WITH NOWAIT

-- get the very first log backup whose FirstLSN littler and LastLSN greater than @diff_backup_LastLSN 
-- when exists differential backup
IF @diff_backup_LastLSN IS NOT NULL
BEGIN
	IF EXISTS(
		SELECT TOP 1 1 
		FROM #headeronly
		WHERE BackupType = 2 -- Log backup
			AND FirstLSN <@diff_backup_LastLSN
			AND LastLSN>= @diff_backup_LastLSN
			AND FamilyGUID = @full_backup_familyGUID
	)
	BEGIN
		SELECT TOP 1 
			@log_backup_LastLSN = LastLSN
			,@back_chain_level_number = @back_chain_level_number + 1
		FROM #headeronly
		WHERE BackupType = 2
			AND FirstLSN <@diff_backup_LastLSN
			AND LastLSN>= @diff_backup_LastLSN
			AND FamilyGUID = @full_backup_familyGUID

		PRINT 'We got log backup Last LSN: ' + cast(@log_backup_LastLSN as varchar)
	END
END
ELSE
-- There is no differential backup, we have to find between log backups.
-- Find the very first log backup LastLSN
BEGIN
	SELECT TOP 1 
		@log_backup_LastLSN = LastLSN
		,@back_chain_level_number = @back_chain_level_number + 1
	FROM #headeronly
	WHERE BackupType = 2 -- Log Backup
		AND FamilyGUID = @full_backup_familyGUID
		AND DatabaseBackupLSN = @full_backup_CheckPointLSN
		AND FirstLSN = @full_backup_CheckPointLSN
END

-- There is no log backup belongs to this full backup
IF @log_backup_LastLSN IS NULL
BEGIN
	RAISERROR('There is no any log backups belong to this full backup.', 10, 1) WITH NOWAIT
	RETURN
END

--SELECT 
--	full_backup_CheckPointLSN = @full_backup_CheckPointLSN
--	,diff_backup_LastLSN = @diff_backup_LastLSN	
--	,log_backup_LastLSN = @log_backup_LastLSN
--	,back_chain_level_number = @back_chain_level_number
--;

-- find out all the log backup need to be restore
;
WITH backup_files
AS
(
	SELECT lv = @back_chain_level_number,*
	FROM #headeronly
	WHERE LastLSN = @log_backup_LastLSN
		AND FamilyGUID = @full_backup_familyGUID
	UNION ALL
	SELECT bf.lv + 1,lg.*
	FROM #headeronly AS lg
		INNER JOIN backup_files as bf
		ON lg.FirstLSN = bf.LastLSN AND lg.FamilyGUID = bf.FamilyGUID
	WHERE lg.BackupType = 2
		AND lg.FamilyGUID = @full_backup_familyGUID
)

INSERT INTO @tb_back_file_rowid
SELECT RowId, lv FROM backup_files

SELECT 
	bkf.Backup_file, 
	hd.BackupType,
	BackupTypeDescription = 
		CASE hd.BackupType
			WHEN 1 THEN 'FULL'
			WHEN 2 THEN 'LOG'
			WHEN 5 THEN 'DIFF'
			ELSE ''
		END,
	hd.IsDamaged,
	restore_order = bkr.Level_Number 
FROM @tb_back_file_rowid AS bkr
	INNER JOIN @tb_back_files AS bkf
	ON bkr.Bak_row_id = bkf.Rowid
	INNER  JOIN #headeronly AS hd
	ON bkr.Bak_row_id = hd.RowId
ORDER BY bkr.Level_Number

--SELECT * 
--FROM #headeronly
--ORDER BY rowid asc

SELECT 
	bkf.backup_file,
	hd.BackupType, 
	hd.Compressed, 
	hd.DatabaseName, 
	hd.FirstLSN, 
	hd.LastLSN, 
	hd.CheckpointLSN, 
	hd.DatabaseBackupLSN, 
	hd.IsDamaged, 
	hd.BackupTypeDescription
FROM #headeronly AS hd
	INNER JOIN @tb_back_files AS bkf
	ON hd.RowId = bkf.Rowid
ORDER BY hd.RowId

备份链结果截图展示如下：

从这个截图中，restore_order和Backup_file字段可以很清楚的看到数据库还原的顺序，以及相应的备份文件路径。所有备份文件的LSN分布如下截图：

差异备份文件损坏

从备份链条我们发现，12:00的这个差异备份C:\Temp\TestDR_20171217@12:00_DIFF.bak非常关键，假设现实中，我们发现这个文件恰恰损坏掉了，那么我们的可以实现应用的数据库还原吗？答案是肯定的，我们把刚才的脚本输入参数修改如下：

DECLARE
-- all the backup files
	@backup_file_list NVARCHAR(MAX) = N'
C:\Temp\TestDR_20171217@00:00_FULL.bak
C:\Temp\TestDR_20171217@01:00_LOG.trn
C:\Temp\TestDR_20171217@02:00_LOG.trn
C:\Temp\TestDR_20171217@03:00_LOG.trn
C:\Temp\TestDR_20171217@04:00_LOG.trn
C:\Temp\TestDR_20171217@05:00_LOG.trn
C:\Temp\TestDR_20171217@06:00_DIFF.bak
C:\Temp\TestDR_20171217@07:00_LOG.trn
C:\Temp\TestDR_20171217@08:00_LOG.trn
C:\Temp\TestDR_20171217@09:00_LOG.trn
C:\Temp\TestDR_20171217@10:00_LOG.trn
C:\Temp\TestDR_20171217@11:00_LOG.trn
C:\Temp\TestDR_20171217@13:00_LOG.trn
C:\Temp\TestDR_20171217@14:00_LOG.trn
'
;

得到如下备份还原链条：

从这个结果，我们可以看到，系统选择了06:00这个差异备份文件，然后一步步使用接下来的事务日志备份文件进行还原。

最后总结

本期是SQL Server备份专题的第三期，在前两期基础上分享了如何通过备份文件查找SQL Server数据库备份链，并以此来还原数据库的理论方法和具体实现，可以帮助用户实现简单、快速查找数据库备份还原链条。

  

    

		

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
