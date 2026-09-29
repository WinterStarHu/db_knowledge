# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/02/04/
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
	

  

    
数据库内核月报 － 2019 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 性能优化 · 敢问路在何方 — 论B+树索引的演进方向（中）
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Inspecting the Content of a MySQL Histogram
                      

                    

                    

                  
                      

                        Database · 原理介绍 · Snapshot Isolation 综述
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 数据库备份加密
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · The design of mysql8.0 redolog
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 8.0 Functional index的实现过程
                      

                    

                    

                  
                      

                        PgSQL · 源码解析 · Json — 从使用到源码
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 如何使用C++实现 MySQL 用户定义函数
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · MySQL多队列线程池优化
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL 时间线修复
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 数据库备份加密  

    
 Author: 风移  

  

  

  
摘要

在SQL Server安全系列专题月报分享中，我们已经分享了：如何使用对称密钥实现SQL Server列加密技术、使用非对称密钥实现SQL Server列加密、使用混合密钥实现SQL Server列加密技术、列加密技术带来的查询性能问题以及相应解决方案、行级别安全解决方案和SQL Server 2016 dynamic data masking实现隐私数据列打码技术这六篇文章，文章详情可以参见往期月报。本期月报我们分享使用证书做数据库备份加密的最佳实践。

问题引入

谈及数据库安全性问题，如何预防数据库备份文件泄漏，如何防止脱库安全风险，是一个非常重要的安全防范课题。这个课题的目的是万一用户数据库备份文件泄漏，也要保证用户数据的安全。在SQL Server中，2014版本之前，业界均采用的TDE技术来实现与防范脱库行为，但是TDE的原理是需要将用户所有的数据进行加密后落盘，读取时解密。这种写入时加密，读取时解密的行为，必然会导致用户查询性能的降低和CPU使用率的上升（具体对性能和CPU影响，可以参见这片测试文章
SQL Server Transparent Data Encryption (TDE) Performance Comparison
）。那么，我们一个很自然的问题是：有没有一种技术，既可以保证备份文件的安全，又能够兼顾到用户查询性能和CPU资源的消耗呢？这个技术就是我们今天要介绍的数据库备份加密技术，该技术是SQL Server 2014版本首次引入，企业版本和标准版支持备份加密，Web版和Express版支持备份加密文件的还原。

具体实现

创建测试数据库

为了测试方便，我们专门创建了测试数据库BackupEncrypted。

-- create test database
IF DB_ID('BackupEncrypted') IS NOT NULL
	DROP DATABASE BackupEncrypted
GO
CREATE DATABASE BackupEncrypted
ON PRIMARY
(NAME = BackupEncrypted_data,
	FILENAME = N'E:\SQLDATA\DATA\BackupEncrypted_data.mdf',
	SIZE = 100MB, FILEGROWTH = 10MB),
FILEGROUP SampleDB_MemoryOptimized_filegroup CONTAINS MEMORY_OPTIMIZED_DATA
  ( NAME = BackupEncrypted_MemoryOptimized,
    FILENAME = N'E:\SQLDATA\DATA\BackupEncrypted_MemoryOptimized')
LOG ON
  ( NAME = BackupEncrypted_log,
    FILENAME = N'E:\SQLDATA\DATA\BackupEncrypted_log.ldf',
	SIZE = 100MB, FILEGROWTH = 10MB)
GO

创建测试表

在测试数据库下，创建一张用于测试的表testTable，并插入一条随机数据。

USE [BackupEncrypted]
GO
-- create test table and insert one record
IF OBJECT_ID('dbo.testTable', 'U') IS NOT NULL
	DROP TABLE dbo.testTable
GO
CREATE TABLE dbo.testTable
(
 id UNIQUEIDENTIFIER default NEWID(),
 parent_id UNIQUEIDENTIFIER default NEWSEQUENTIALID()
);
GO

SET NOCOUNT ON;
INSERT INTO dbo.testTable DEFAULT VALUES;
GO

SELECT * FROM dbo.testTable ORDER BY id;

该条数据内容如下截图：

创建Master Key和证书

创建Master Key和证书，用于加密数据库备份文件。

USE master
GO
-- If the master key is not available, create it. 
IF NOT EXISTS (SELECT * 
				FROM sys.symmetric_keys
				WHERE name LIKE '%MS_DatabaseMasterKey%') 
BEGIN
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey*'; 
END 
GO

USE master
GO
-- create certificate
CREATE CERTIFICATE MasterCert_BackupEncrypted
AUTHORIZATION dbo
WITH SUBJECT = 'Backup encryption master certificate',
START_DATE = '02/10/2017',
EXPIRY_DATE = '12/30/9999'
GO

备份证书

首先，将证书和证书密钥文件备份到本地，最好它们脱机保存到第三方主机，以免主机意外宕机，导致证书文件丢失，从而造成已加密的备份文件无法还原的悲剧。

USE master
GO
EXEC sys.xp_create_subdir 'C:\Tmp'

-- then backup it up to local path
BACKUP CERTIFICATE MasterCert_BackupEncrypted 
TO FILE = 'C:\Tmp\MasterCert_BackupEncrypted.cer'
WITH PRIVATE KEY (
	FILE = 'C:\Tmp\MasterCert_BackupEncrypted.key',
	ENCRYPTION BY PASSWORD = 'aa11@@AA')
;

加密完全备份

创建完Master Key和证书文件后，我们就可以做数据库完全备份加密操作。

USE master;
GO
-- do full backup database with encryption
BACKUP DATABASE [BackupEncrypted]  
TO DISK = N'C:\Tmp\BackupEncrypted_FULL.bak'  
WITH COMPRESSION, ENCRYPTION (
	ALGORITHM = AES_256, 
	SERVER CERTIFICATE = MasterCert_BackupEncrypted),
	STATS = 10;
GO

加密差异备份

数据库差异备份加密，备份操作前，我们插入一条数据，以供后续的测试数据校验。

USE [BackupEncrypted]
GO
-- insert another record
SET NOCOUNT ON;
INSERT INTO dbo.testTable DEFAULT VALUES;
GO

SELECT * FROM dbo.testTable ORDER BY id;

USE master;
GO
--Differential backup with encryption
BACKUP DATABASE [BackupEncrypted]
TO DISK = N'C:\Tmp\BackupEncrypted_DIFF.bak'
WITH CONTINUE_AFTER_ERROR,ENCRYPTION (
	ALGORITHM = AES_256, 
	SERVER CERTIFICATE = MasterCert_BackupEncrypted),
	STATS = 10,
	DIFFERENTIAL;
GO

差异备份操作前，校验表中的两条数据如下图所示：

加密日志备份

数据库事物日志备份加密，备份前，我们照样插入一条数据，以供后续测试数据校验。

USE BackupEncrypted
GO
-- insert another record
SET NOCOUNT ON;
INSERT INTO dbo.testTable DEFAULT VALUES;
GO

SELECT * FROM dbo.testTable ORDER BY id;

USE master;
GO
-- backup transaction log with encryption
BACKUP LOG [BackupEncrypted]
TO DISK = N'C:\Tmp\BackupEncrypted_log.trn'
WITH CONTINUE_AFTER_ERROR,ENCRYPTION (
	ALGORITHM = AES_256, 
	SERVER CERTIFICATE = MasterCert_BackupEncrypted),
	STATS = 10;
GO

日志备份操作前，校验表中的三条数据如下图所示：

查看备份历史

数据完全备份、差异备份和日志备份结束后，查看备份历史记录。

use msdb
GO
-- check backups
SELECT 
	b.database_name,
	b.key_algorithm,
	b.encryptor_thumbprint,
	b.encryptor_type,
	b.media_set_id,
	m.is_encrypted, 
	b.type,
	m.is_compressed,
	bf.physical_device_name
FROM dbo.backupset b
INNER JOIN dbo.backupmediaset m 
	ON b.media_set_id = m.media_set_id
INNER JOIN dbo.backupmediafamily bf 
	on bf.media_set_id=b.media_set_id
WHERE database_name = 'BackupEncrypted'
ORDER BY b.backup_start_date  DESC

备份历史信息展示如下：

从截图中数据我们可以看出，三种备份都采用了证书做备份加密。

查看备份文件信息

备份历史检查完毕后，在清理测试环境之前，检查备份文件元数据信息，可以成功查看，没有任何报错。

USE master
GO
-- before clean environment, try to get backup files meta info, will be success
RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'

展示结果部分截图如下：

清理环境

清理环境目的是模拟在一台全新实例上还原数据库备份文件。

use master
GO
-- let's try to simulate a database crash, here we just drop this database.
DROP DATABASE [BackupEncrypted];
GO
-- and clean certificate and master key to simulate restore to a new instance.

DROP CERTIFICATE MasterCert_BackupEncrypted;
GO

DROP MASTER KEY;
GO

再次查看备份文件信息

清理掉证书和Master Key后，再次查看备份文件信息，此时会报错。因为数据库备份文件已经加密。这种报错是我们所预期的，即就算我们的数据库备份文件被脱库泄漏，我们的数据也可以保证绝对安全，而不会非预期的还原回来。

USE master
GO
-- try to get backup files meta info again after clean environment, will be not success now.
RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'

报错信息类似如下：

Msg 33111, Level 16, State 3, Line 178
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 178
RESTORE FILELIST is terminating abnormally.
Msg 33111, Level 16, State 3, Line 179
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 179
RESTORE HEADERONLY is terminating abnormally.
Msg 33111, Level 16, State 3, Line 181
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 181
RESTORE FILELIST is terminating abnormally.
Msg 33111, Level 16, State 3, Line 182
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 182
RESTORE HEADERONLY is terminating abnormally.
Msg 33111, Level 16, State 3, Line 184
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 184
RESTORE FILELIST is terminating abnormally.
Msg 33111, Level 16, State 3, Line 185
Cannot find server certificate with thumbprint '0xA938CE32CC86DFA6EAD2AED9429814F1A4C683ED'.
Msg 3013, Level 16, State 1, Line 185
RESTORE HEADERONLY is terminating abnormally.

部分错误信息截图如下：

还原证书文件

数据库备份加密，可以有效防止脱库泄漏的安全风险。当然，合法用户需要在新实例上成功还原加密备份文件。首先，创建Master Key；然后，从证书备份文件中，重新创建证书。

USE master
GO
-- so we have to re-create master key, the certificate and open the 
IF NOT EXISTS (SELECT * 
				FROM sys.symmetric_keys
				WHERE name LIKE '%MS_DatabaseMasterKey%') 
BEGIN
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey*'; 
END 
GO

use master
GO
-- re-create certificate
CREATE CERTIFICATE MasterCert_BackupEncrypted
FROM FILE = 'C:\Tmp\MasterCert_BackupEncrypted.cer'
WITH PRIVATE KEY (FILE = 'C:\Tmp\MasterCert_BackupEncrypted.key',
DECRYPTION BY PASSWORD = 'aa11@@AA');
GO

检查备份文件信息

校验备份文件信息，已经可以正确读取。

USE master
GO
-- after re-create certificate, try to get backup files meta info again, will be success.
RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_FULL.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_DIFF.bak'

RESTORE FILELISTONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'
RESTORE HEADERONLY FROM DISK='C:\Tmp\BackupEncrypted_log.trn'

还原已加密完全备份文件

首先，尝试还原数据库完全备份文件，成功。

USE [master]
-- restore encrypted full backup
RESTORE DATABASE [BackupEncrypted] 
FROM  DISK = N'C:\Tmp\BackupEncrypted_FULL.bak' 
WITH FILE = 1,  
MOVE 'BackupEncrypted_data' TO N'E:\SQLDATA\DATA\BackupEncrypted_data.mdf',
MOVE 'BackupEncrypted_MemoryOptimized' TO N'E:\SQLDATA\DATA\BackupEncrypted_MemoryOptimized',
MOVE 'BackupEncrypted_log' TO N'E:\SQLDATA\DATA\BackupEncrypted_log.ldf',
NOUNLOAD,  STATS = 5, NORECOVERY
GO

还原已加密差异备份文件

其次，尝试还原数据库差异备份文件，成功。

-- Restore encrypted diff backup
RESTORE DATABASE [BackupEncrypted] 
FROM  DISK = N'C:\Tmp\BackupEncrypted_DIFF.bak' WITH  FILE = 1,  
MOVE 'BackupEncrypted_data' TO N'E:\SQLDATA\DATA\BackupEncrypted_data.mdf',
MOVE 'BackupEncrypted_MemoryOptimized' TO N'E:\SQLDATA\DATA\BackupEncrypted_MemoryOptimized',
MOVE 'BackupEncrypted_log' TO N'E:\SQLDATA\DATA\BackupEncrypted_log.ldf',
NOUNLOAD,  STATS = 5, NORECOVERY
GO

还原已加密日志备份文件

再次，尝试还原数据库日志备份文件，成功。

-- restore encrypted transaction log backup
RESTORE LOG [BackupEncrypted] 
FROM  DISK = N'C:\Tmp\BackupEncrypted_log.trn' WITH  FILE = 1,  
MOVE 'BackupEncrypted_data' TO N'E:\SQLDATA\DATA\BackupEncrypted_data.mdf',
MOVE 'BackupEncrypted_MemoryOptimized' TO N'E:\SQLDATA\DATA\BackupEncrypted_MemoryOptimized',
MOVE 'BackupEncrypted_log' TO N'E:\SQLDATA\DATA\BackupEncrypted_log.ldf',
NOUNLOAD,  STATS = 10
GO

检查测试表数据

最后，检查测试表的三条测试数据。

USE [BackupEncrypted]
GO
-- double check the three records
SELECT * FROM dbo.testTable ORDER BY id;

三条校验数据一致。

清理测试环境

清理掉我们的测试环境。

use master
GO
-- clean up the environment
DROP DATABASE BackupEncrypted;
GO
DROP CERTIFICATE MasterCert_BackupEncrypted;
GO
DROP MASTER KEY;
GO

最后总结

本期月报我们分享了SQL Server 2014及以上版本如何使用证书实现数据库备份加密技术，在防范脱库安全风险的同时，既能够比较好的保证用户查询性能，又不会带来额外CPU资源的消耗。

参考文章

SQL Server Transparent Data Encryption (TDE) Performance Comparison

SQLServer · 最佳实践 · 透明数据加密TDE在SQLServer的应用

开启TDE的RDS SQL Server还原到本地环境

Understanding Database Backup Encryption in SQL Server

  

    

		

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
