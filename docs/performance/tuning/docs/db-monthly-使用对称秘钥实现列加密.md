# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/08/03/
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
	

  

    
数据库内核月报 － 2018 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 主库 binlog 概览
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Write Prepared Policy
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 使用对称秘钥实现列加密
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · InnoDB对binlog_format的限制
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · sharding chunk 分裂与迁移详解
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PostgreSQL物理备份内部原理
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 连接与认证过程
                      

                    

                    

                  
                      

                        MySQL · RocksDB ·  MemTable的写入逻辑
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · Greenplum RoaringBitmap多阶段聚合
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 高并发空间位置更新、多属性KNN搜索并测
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 使用对称秘钥实现列加密  

    
 Author: 风移  

  

  

  
摘要

从SQL Server 2005开始引入了列加密技术，实现一些关键、核心的隐私数据列信息加密。本期月报是我们分享SQL Server安全系列专题的开篇：如何使用对称秘钥实现SQL Server列加密技术。

场景引入

在平日的生活中，我相信大家或多或少都经历过广告、推销、诈骗电话的骚扰，不厌其烦，比如：“喂，您XXX的房子要不要考虑出售？XXX的楼盘您要不要考虑购买？”。

往往这个时候，我们会想，我的电话，手机号码都是被谁，哪些途径泄露出去呢？到底有没有技术手段来尽量或最大限度的减少手机号码的泄露呢？答案是肯定的，那就让我们一起来看看在SQL Server数据库中如何实现类似于手机号、身份证号、驾照号等关键信息如何被加密存储。

原理分析

为了避免枯燥的原理性解释，我们用一句话、一张图、以及简单的实现方法，三个方面来介绍SQL Server数据库列加密技术。

一句话解释

一句话解释SQL Server数据库的列加密技术：是使用加密算法，将表中关键字段信息列从明文变成密文，使得用户信息可以被严格保护，不被轻易获取的技术。

一张图解释

从下面这张图，我们可以清楚的看到SQL Server数据库中的关键信息列是如何被加密的：

图片来自
微软官方网站

实现方法

要实现SQL Server数据库列级别加密（本例中使用对称秘钥进行列加密方法，当然还有其他方法），我们需要：

创建实例级别的Master Key

创建数据库级别Master Key

创建数据库级别证书

创建数据库级别对称秘钥

使用对称秘钥加密关键列数据

具体实现

以下是使用对称秘钥加密用户手机号码的具体实现步骤以及详细过程。

创建测试数据库

创建一个专门的测试数据库，名为：TestDb。

--Step 1 - Create MSSQL sample database
USE master
GO
IF DB_ID('TestDb') IS NULL
	CREATE DATABASE [TestDb];
GO

创建测试表

在TestDb数据库下，创建一张专门的测试表，名为：CustomerInfo。

--Step 2 - Create Test Table, init data & verify
USE [TestDb]
GO
IF OBJECT_ID('dbo.CustomerInfo', 'U') IS NOT NULL
	DROP TABLE dbo.CustomerInfo
CREATE TABLE dbo.CustomerInfo
(
CustomerId		INT IDENTITY(10000,1)	NOT NULL PRIMARY KEY,
CustomerName	VARCHAR(100)			NOT NULL,
CustomerPhone	CHAR(11)				NOT NULL
);

-- Init Table
INSERT INTO dbo.CustomerInfo 
VALUES ('CustomerA','13402872514')
,('CustomerB','13880674722')
,('CustomerC','13487759293')
GO

-- Verify data
SELECT * 
FROM dbo.CustomerInfo
GO

原始数据中，用户的电话号码为明文存储，任何有权限查看表数据的用户，都可以清楚明了的获取到用户的电话号码信息，展示如下：

创建实例级别Master Key

在SQL Server数据库实例级别创建Master Key（在Master数据库下，使用CREATE MASTER KEY语句）：

-- Step 3 - Create SQL Server Service Master Key
USE master;
GO
IF NOT EXISTS(
	SELECT *
	FROM sys.symmetric_keys
	WHERE name = '##MS_ServiceMasterKey##')
BEGIN
	CREATE MASTER KEY ENCRYPTION BY 
	PASSWORD = 'MSSQLSerivceMasterKey'
END;
GO

创建数据库级别Master Key

在用户数据库TestDb数据库下，创建Master Key：

-- Step 4 - Create MSSQL Database level master key
USE [TestDb]
GO
IF NOT EXISTS (SELECT * 
				FROM sys.symmetric_keys 
				WHERE name LIKE '%MS_DatabaseMasterKey%')
BEGIN		
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'TestDbMasterKey@3*';
END
GO

创建数据库级别证书

在测试数据库TestDb下，创建证书，用于加密对称秘钥：

-- Step 5 - Create a Self Signed MSSQL Certificate:
USE [TestDb]
GO
IF NOT EXISTS(
	SELECT *
	FROM sys.certificates
	WHERE name = 'Cert_TestDb'
)
BEGIN
	CREATE CERTIFICATE Cert_TestDb
	AUTHORIZATION dbo
	WITH SUBJECT = 'Cert_TestDb to protect my phone',
	START_DATE = '08/10/2018',
	EXPIRY_DATE = '12/30/9999'
END
GO

我们强烈建议您备份您的证书到本地：

-- It's better to BACKUP your certificate to local disk.
USE [TestDb]
GO
BACKUP CERTIFICATE Cert_TestDb
TO FILE = 'C:\Temp\Cert_TestDb.cer';
GO

创建对称秘钥

在用户数据库下，创建对称秘钥，并使用证书对其进行加密：

-- Step 6 - Create MSSQL Symmetric Key
USE [TestDb]
GO
IF NOT EXISTS (SELECT * 
				FROM sys.symmetric_keys 
				WHERE name = 'SymKey_TestDb')
BEGIN
	CREATE SYMMETRIC KEY SymKey_TestDb 
	WITH ALGORITHM = AES_256 
	ENCRYPTION BY CERTIFICATE Cert_TestDb
	;
END
GO

查看证书和对称秘钥

您可以使用如下查询语句查看对称秘钥以及证书：

USE [TestDb]
GO
SELECT *
FROM  sys.symmetric_keys

SELECT *
FROM sys.certificates

结果展示如下：

当然，您也可以用SSMS图形界面来查看证书和对称秘钥对象，方法是在用户数据库下，打开Security => Certificates => Symmetric Keys，如下图所示：

修改表结构

接下来，我们需要修改表结构，添加一个数据类型为varbinary(max)的新列，假设列名为EncryptedCustomerPhone ，用于存储加密后的手机号码密文。

-- Step 7 - Change your table structure
USE [TestDb]
GO 
ALTER TABLE CustomerInfo 
ADD EncryptedCustomerPhone varbinary(MAX) NULL
GO

新列数据初始化

新列添加完毕后，我们将表中历史数据的用户手机号CustomerPhone，加密为密文，并存储在新字段EncryptedCustomerPhone中。方法是打开对称秘钥，然后使用EncryptByKey函数加密CustomerPhone列，如下语句所示：

-- Step 8 - init the encrypted data into the newly column
USE [TestDb]
GO 
-- Opens the symmetric key: SymKey_TestDb
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;
GO
UPDATE A
SET EncryptedCustomerPhone = EncryptByKey (Key_GUID('SymKey_TestDb'), CustomerPhone)
FROM dbo.CustomerInfo AS A;
GO
-- Closes the symmetric key: SymKey_TestDb
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO
-- Double check the encrypted data of the new column
SELECT * FROM dbo.CustomerInfo

查看表中EncryptedCustomerPhone列的数据，已经变成CustomerPhone加密后的密文，如下展示：

查看加密数据

手机号被加密为密文后，我们需要使用DecryptByKey函数将其解密为明文（解密前，需要打开对称秘钥），让我们尝试看看能否成功解密EncryptedCustomerPhone字段。

-- Step 9 - Reading the SQL Server Encrypted Data
USE [TestDb]
GO 
-- Opens the symmetric key: SymKey_TestDb
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;
GO

-- Now, it's time to list the original phone, encrypted phone and the descrypted phone.
SELECT 
	*,
	DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo;
 
-- Close the symmetric key
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

查询语句执行结果如下，CustomerPhone和DescryptedCustomerPhone字段数据内容是一模一样的，因此加密和解密成功。

添加新数据

历史数据加密解密后的数据保持一致，然后，让我们看看新添加的数据：

-- Step 10 - What if we add new record to table.
USE [TestDb]
GO 
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;
GO
-- Performs the update of the record
INSERT INTO dbo.CustomerInfo (CustomerName, CustomerPhone, EncryptedCustomerPhone)
VALUES ('CustomerD', '13880975623', EncryptByKey( Key_GUID('SymKey_TestDb'), '13880975623'));  

-- Close the symmetric key
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

更新数据手机号

接下来，我们尝试更新用户手机号：

-- Step 11 - So, what if we upadate the phone
USE [TestDb]
GO 
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;

-- Performs the update of the record
UPDATE A
SET EncryptedCustomerPhone = EncryptByKey( Key_GUID('SymKey_TestDb'), '13880971234')
FROM dbo.CustomerInfo AS A
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13880975623'

-- Close the symmetric key
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

删除手机号明文列

一切没有问题，我们可以将用户手机号明文列CustomerPhone删除：

-- Step 12 - Remove old column
USE [TestDb]
GO 
ALTER TABLE CustomerInfo
DROP COLUMN CustomerPhone;
GO

再次检查数据

再次尝试解密密文字段数据：

--Step 13 - verify again
USE [TestDb]
GO 
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;

SELECT 
	*,
	DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo
 
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

结果展示如下：

一切正常，历史数据、新添加的数据、更新的数据，都可以工作完美。按理，文章到这里也就结束。但是有一个问题我们是需要搞清楚的，那就是：如果我们新创建了用户，他能够访问这个表的数据吗？以及我们如何让新用户能够访问该表的数据呢？

添加新用户

模拟新添加一个用户EncryptedDbo:

-- Step 14 - Create a new user & access the encrypted data
USE [TestDb]
GO 
CREATE LOGIN EncryptedDbo
	WITH PASSWORD=N'EncryptedDbo@3*', CHECK_POLICY = OFF;
CREATE USER EncryptedDbo FOR LOGIN EncryptedDbo;

GRANT SELECT ON OBJECT::dbo.CustomerInfo TO EncryptedDbo;
GO

新用户查询数据

使用刚才创建的用户，在SSMS中新打开一个连接，查询数据：

-- Step 15 -- OPEN a new connection query window using the new user and query data 
USE [TestDb]
GO

OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY CERTIFICATE Cert_TestDb;

SELECT 
	*,
	DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo

CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

首先，新用户无法OPEN SYMMETRIC KEY和CLOSE SYMMETRIC KEY，会报告如下异常：

其次，新用户也无法解密EncryptedCustomerPhone，解密后的DescryptedCustomerPhone 字段值为NULL，即新用户无法查看到用户手机号明文，避免了未知用户获取用户手机号等核心数据信息。

为新用户赋权限

新用户没有查看加密列数据的权限，如果需要赋予权限，方法如下：

--Step 16 - Grant permissions to EncryptedDbo
USE [TestDb]
GO

GRANT VIEW DEFINITION ON 
	SYMMETRIC KEY::[SymKey_TestDb] TO [EncryptedDbo];
	 
GRANT VIEW DEFINITION ON 
	CERTIFICATE::[Cert_TestDb] TO EncryptedDbo;
GO
GRANT CONTROL ON 
	CERTIFICATE::[Cert_TestDb] TO [EncryptedDbo];
GO

新用户再次查询

赋权限完毕后，新用户再次执行“新用户查询数据”中的查询语句，已经可以正常获取到加密列的明文数据了。展示如下：

最后总结

本文做为SQL Server安全系列文章开篇，介绍了如何使用对称秘钥实现列加密的详细步骤和过程，实现关键信息列加密，保护用户核心信息安全。

  

    

		

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
