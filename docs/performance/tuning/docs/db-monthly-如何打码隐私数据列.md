# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/01/05/
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
	

  

    
数据库内核月报 － 2019 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 理论基础 · 数据库故障恢复机制的前世今生
                      

                    

                    

                  
                      

                        POLARDB · 最佳实践 · POLARDB不得不知道的秘密(二)
                      

                    

                    

                  
                      

                        MongoDB · 原理介绍 · MongoDB从事务到复制
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · PostgreSQL 并行查询概述
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 如何打码隐私数据列
                      

                    

                    

                  
                      

                        Redis · 引擎特性 · Lua脚本新姿势
                      

                    

                    

                  
                      

                        Mariadb · 源码分析 · proxy protocol
                      

                    

                    

                  
                      

                        MySQL · InnoDB · tablespace源码分析
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · MySQL中的IO共享操作
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · native partition 分区表性能优化
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 如何打码隐私数据列  

    
 Author: 风移  

  

  

  
摘要

在SQL Server安全系列专题月报分享中，我们已经分享了：如何使用对称密钥实现SQL Server列加密技术、使用非对称密钥加密方式实现SQL Server列加密、使用混合密钥实现SQL Server列加密技术、列加密技术带来的查询性能问题以及相应解决方案和行级别安全解决方案这五篇文章，文章详情可以参见往期月报。本期月报我们分享使用SQL Server 2016 dynamic data masking实现隐私数据列的打码技术最佳实践。

问题引入

在平日的生活中，我们或多或少都经历过广告推销、电话诈骗，不厌其烦，甚至更为严重到银行卡号泄漏、身份证号泄漏等更为严重的情况。这个时候，于是我们就在想有没有技术手段来尽量或最大限度的保护我们隐私数据安全呢？答案是肯定的，SQL Server 2016版本首次引入了dynamic data masking来实现隐私数据列的打码技术，让我们一起来看看如何实现类似于手机号、身份证号、驾照号等隐私数据打码技术。

原理分析

数据列打码技术的本身我们并不陌生，就是将一些比较私密的数据信息隐藏起来，仅开放给有较高权限的用户查看完整数据。打码技术本身并不会对数据做任何的加密、解密等操作。严格意义上讲，数据打码不是一个完整的数据安全解决方案，但是它可以作为安全策略中重要的一环来有效避免用户隐私数据列的泄漏。让我们一起来看看在SQL Server 2016 dynamic data masking是如何实现的。

实现方法

创建测试数据库

为了测试方便，我们专门创建了测试数据库TestDb。

--Step 1 - Create MSSQL sample database
USE master
GO
IF DB_ID('TestDb') IS NULL
	CREATE DATABASE [TestDb];
GO

创建测试表

首先，我们创建一张常规表CustomerInfo，来存放客户信息，其中，CustomerPhone列为用户隐私数据，存放了用户的手机号码。

--Step 2 - Create Test Table, init records
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

创建测试用户

为了方便观察和检查测试效果，我们创建一个测试账号DemoUser。

-- Step3: Create a DemoUser to test
USE [TestDb]
GO
CREATE USER DemoUser WITHOUT LOGIN;
GRANT SELECT ON dbo.CustomerInfo TO DemoUser;
GO

EXECUTE AS USER = 'DemoUser';
-- Verify data
SELECT * 
FROM dbo.CustomerInfo

REVERT

常规情况下，测试账号，可以清清楚楚，明明白白看到用户所有数据，包含客户手机号这种关键的隐私数据。如果，这个用户有不轨之心是非常容易将这些信息泄漏、导出的，安全风险较大。

客户手机号打码

于是，我们想，如果能够将客户隐私数据，比如，电话号码（身份证号码、银行卡号等）打码的话，那么测试账号就无法查看到用户完整的数据信息了。打码方法如下：

-- Step4: Alter phone column add data mask
USE [TestDb]
GO

ALTER TABLE dbo.CustomerInfo
ALTER COLUMN CustomerPhone ADD MASKED WITH(FUNCTION='partial(3, "****", 4)');

由于CustomerPhone是11位数字，我们使用partial方法打码隐藏中间四位，打码符号使用星号，保留前三位和后四位数数字即可。

查询打码列

打码完毕，我们使用系统试图查看打码列和打码函数：

-- Step5. Query system view to check data mask
SELECT
	db_name() as database_name, 
	SCHEMA_NAME(schema_id) AS schema_name, 
	tbl.name as table_name, 
	c.name as column_name, 
	c.is_masked, 
	c.masking_function  
FROM sys.masked_columns AS c  WITH (NOLOCK)
	INNER JOIN sys.tables AS tbl   WITH(NOLOCK)
    ON c.[object_id] = tbl.[object_id]  
WHERE c.is_masked = 1
	AND tbl.name = 'CustomerInfo';

从结果可以看到我们已经将表TestDb.dbo.CustomerInfo中字段CustomerPhone打码，打码函数为partial(3, “
**
”, 4)，结果展示如下所示：

测试用户查看数据

打码完毕后，再次使用DemoUser测试账号查看打码后的数据：

-- Step6: Demo user to query and verify data
USE [TestDb]
GO
EXECUTE AS USER = 'DemoUser';
-- Verify data
SELECT * 
FROM dbo.CustomerInfo

REVERT

从查询结果展示来看，客户手机号码列中间四位已经成功打码了，测试账号已经无法获取到完整的客户电话号码了。

修改打码符号

有时候，有的人会说，我不喜欢星号，能否换个打码姿势，我更喜欢使用字母X。只要你喜欢，随便切换，方法如下：

-- Step7: What if I want to change the mask sign from * to X
USE [TestDb]
GO

ALTER TABLE dbo.CustomerInfo
ALTER COLUMN CustomerPhone CHAR(11) MASKED WITH(FUNCTION='partial(3, "XXXX", 4)');

现在打码符号变成了X，展示如下：

新增隐私打码列

现在我们需要增加一个新的列，用来存放用户email地址，也请同时打码。非常简单，新增列的时候使用email打码函数即可，如下所示：

-- Step8: and I want to add a new email mask column
ALTER TABLE dbo.CustomerInfo
ADD Email varchar(100) MASKED WITH (FUNCTION = 'email()')  NOT NULL DEFAULT('demo.user@test.com')

查询打码列特定值

有的人可能会问，手机号码被打码了，这个列会影响我的WHERE语句查询吗？当然不会，因为data mask技术本身并没有对数据做任何修改，只是在展示的时候，打码隐藏掉部分信息而已。

-- Step9: Demo user to query the specified phone customer info
USE [TestDb]
GO
EXECUTE AS USER = 'DemoUser';
-- Verify data
SELECT * 
FROM dbo.CustomerInfo
WHERE CustomerPhone = '13880674722'

REVERT

查询结果展示，手机号码和email地址始终被打码。

拷贝存在打码列的表

我们说data mask技术并没有加密、修改数据本身。到目前为止，测试账号DemoUser已经无法获取到客人的关键隐私数据了，那么他能够将用户数据Copy、导出吗？让我们做一个简单的测试，DemoUser将表CustomerInfo复制到一个新表CustomerInfo_copied中：

-- Step10: Ops, if I copy a new table from the data masked table, I can't get the unmasked data now.
USE [TestDb]
GO
GRANT CREATE TABLE TO DemoUser;
GRANT ALTER ON SCHEMA::dbo TO DemoUser;
EXECUTE AS USER = 'DemoUser';
-- Verify data
SELECT * 
	INTO dbo.CustomerInfo_copied
FROM dbo.CustomerInfo

REVERT

GRANT SELECT ON dbo.CustomerInfo_copied TO DemoUser;
EXECUTE AS USER = 'DemoUser';
SELECT * FROM dbo.CustomerInfo_copied
REVERT

DemoUser复制了客户信息数据到新表后，查看新表中的数据，依然是被打码的，测试用户无法导出、复制客人的隐私数据。达到了安全策略保护客户隐私数据的目的，展示结果如下：

我想要在无码的世界

如果有一天DemoUser成了高权限用户，确实需要查看客户隐私数据列，这个时候，我们可以给予测试账号unmask的权限，他就可以看到完整的客户数据了。方法如下：

-- Step 11: But, how can demo user to query the unmasked data?
USE TestDB
GO

GRANT UNMASK TO DemoUser;  
EXECUTE AS USER = 'DemoUser';  
SELECT * FROM dbo.CustomerInfo;  
REVERT;   
  
-- Removing the UNMASK permission  
REVOKE UNMASK TO DemoUser;

此时，DemoUser查询到的数据，是非常完整的客人数据。

删掉打码

删除打码，让所有用户回归无码的世界。

-- Step 12: all the demos have been done, it's time to drop the mask.
USE TestDB
GO
ALTER TABLE dbo.CustomerInfo   
ALTER COLUMN CustomerPhone DROP MASKED;  

最后总结

本期月报我们分享了使用SQL Server 2016引入的新特性dynamic data masking实现客户数据打码技术，防止未授权用户查看、导出用户关键隐私数据，最大限度保证用户数据安全性。

  

    

		

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
