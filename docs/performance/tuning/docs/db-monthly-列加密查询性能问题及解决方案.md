# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/11/07/
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
	

  

    
数据库内核月报 － 2018 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 理论基础 · 敢问路在何方 — 论B+树索引的演进方向（上）
                      

                    

                    

                  
                      

                        Database · 原理介绍 · Google Percolator 分布式事务实现原理解读
                      

                    

                    

                  
                      

                        Database · 原理介绍 · 关于Paxos 幽灵复现问题
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB MVCC 相关实现
                      

                    

                    

                  
                      

                        MySQL · RocksDB · 数据的读取(一)
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · EXPLAIN 使用浅析
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 列加密查询性能问题及解决方案
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 性能问题多维度诊断
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 8.0 CTE和窗口函数的用法
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · Heap Only Tuple (降低UPDATE引入的索引写IO放大)
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 · 列加密查询性能问题及解决方案  

    
 Author: 风移  

  

  

  
摘要

在SQL Server安全系列专题月报分享中，我们已经分享了：如何
使用对称密钥实现SQL Server列加密技术
、
使用非对称密钥加密方式实现SQL Server列加密
和
使用混合密钥实现SQL Server列加密技术
三篇文章。本期月报我们分享列加密技术带来的查询性能问题以及相应的解决方案。

问题引入

根据SQL Server安全系列专题前三篇的月报分享，我们已经可以非常轻松的实现SQL Server的列加密，来保护我们关键数据列的安全性。但是，如果我们需要使用加密列来做为条件查询的话，会导致SQL Server No-SARG查询，进而导致查询性能低下。比如：在我们场景中，使用电话号码做为查询、更新、删除客户信息的条件。

电话号码条件查询

在很多种场景中，业务系统需要通过电话号码来查询客户详细信息，但是由于我们已经将电话号码加密存储，于是查询语句必须先将电话号码密文解密后为明文后，再做查询。比如，我们需要查找电话号码为13487759293的客户详细信息，查询语句会是：

USE [TestDb]
GO

OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY ASYMMETRIC KEY AsymKey_TestDb WITH PASSWORD = 'Password4@Asy';

SELECT 
	*,
	DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13487759293'

/** 
UPDATE A
SET EncryptedCustomerPhone = EncryptByKey( Key_GUID('SymKey_TestDb'), '13487759293')
FROM dbo.CustomerInfo AS A
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13487759293'

DELETE A
FROM dbo.CustomerInfo AS A
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13402872514'
**/

CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

查询结果为：

这个使用电话号码做为查询条件的语句，会导致查询语句存在非常大的性能问题：
在WHERE语句中使用函数运算解密电话号码密文，即No-SARG查询
电话号码密文字段EncryptedCustomerPhone无法建立索引
类似导致查询性能问题会同样出现在客户信息更细、客户信息删除等场景中，详细的原理分析及解决方案，参加下一章节。

原理分析

为什么说使用电话号码做为查询条件，会带来非常大的性能问题呢，这一章节将从以下两个方面来进行分析：

No-SARG查询

宽字段无法建立索引

No-SARG查询

由于用户只知道电话号码的明文，即查询条件的输入端是明文，而在数据库的表中，存储的是电话号码加密过的密文。如果要使用电话号码做为查询条件，必须解密电话号码密文后，再与电话号码明文匹配。即WHERE语句呈现如下的写法：
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = ‘13487759293’
这种在WHERE语句对表中正式字段进行函数运算的查询是典型的No-SARG查询，会导致SQL Server Scan表中该字段的所有值，导致IO，CPU资源的极大消耗，进而导致查询时间消耗过长，性能低下。
在这里，可能会有人挑战说，为什么不先加密电话号码为密文后，再与数据库表中的电话号码密文进行对比呢？这样就不会对表字段进行函数运算了吗？这个方法提的非常好，这也是我们平时解决No-SARG查询的思路。但是，在这个场景中变得行不通了，如下示例我们针对同一个电话号码明文加密，出来的密文是完全不一致：

DECLARE
	@phone VARCHAR(11) = '13880975623'
;
SELECT 
	encrypted_phone_1 = EncryptByKey( Key_GUID('SymKey_TestDb'), @phone), 
	encrypted_phone_2 = EncryptByKey( Key_GUID('SymKey_TestDb'), @phone)
;

如下结果，加密同一个电话号码明文13880975623，加密密文encrypted_phone_1和encrypted_phone_2值却完全不一样。

因此，采用加密电话号码明文后，再与表中字段数据匹配的方法不可行。

宽字段无法建立索引

由于创建索引的字段宽度，最大不允许超过900 bytes，但是EncryptByKey函数最多可能会返回8000个bytes，加之EncryptedCustomerPhone字段定义为varbinary(MAX)。因此，电话号码密文字段不允许创建索引，尝试创建索引。

USE [TestDb]
GO
CREATE INDEX ix_EncryptedCustomerPhone 
ON dbo.CustomerInfo(EncryptedCustomerPhone)
;

会报告如下错误：

解决方案

我们可以创建一个列，用于存放用户电话号码明文Hash值，然后再该Hash列上建立索引。查询的时候，先将电话号码明文计算Hash值，再与该Hash列进行匹配查找到对应的行即可。

解决方法

详细的解决方法有如下几个步骤：

添加Hash列

初始化Hash列数据

创建Hash列索引

新增数据行

添加Hash列

我们选择CHECKSUM函数来计算电话号码的Hash值，因此，添加一个INT数据类型的CustomerPhone_Hashkey列即可。

USE [TestDb]
GO
ALTER TABLE dbo.CustomerInfo
ADD CustomerPhone_Hashkey INT NULL
;
GO

初始化Hash列数据

初始化Hash列数据时，由于电话号码已经加密为密文，需要先将其解密出来，然后再计算Hash值。

USE [TestDb]
GO
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY ASYMMETRIC KEY AsymKey_TestDb WITH PASSWORD = 'Password4@Asy';

WHILE EXISTS(
			SELECT TOP 1 *
			FROM dbo.CustomerInfo WITH(NOLOCK)
			WHERE CustomerPhone_Hashkey IS NULL
)
BEGIN
	UPDATE TOP(10000) A
	SET CustomerPhone_Hashkey = CHECKSUM(CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)))
	FROM dbo.CustomerInfo AS A
	WHERE CustomerPhone_Hashkey IS NULL
	
	WAITFOR DELAY '00:00:01'
END
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

创建Hash列索引

在电话号码Hash值列上，建立相应的索引。

USE [TestDb]
GO
CREATE INDEX IX_CustomerPhone_Hashkey 
ON dbo.CustomerInfo(CustomerPhone_Hashkey)
WITH(FILLFACTOR=90, ONLINE=ON);
GO

新增数据

添加了电话号码Hash列后，新增数据时，需要计算电话号码的Hash值，存储在CustomerPhone_Hashkey列中。

USE [TestDb]
GO 
OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY ASYMMETRIC KEY AsymKey_TestDb WITH PASSWORD = 'Password4@Asy';
GO
-- Performs the update of the record
INSERT INTO dbo.CustomerInfo (CustomerName, CustomerPhone_Hashkey, EncryptedCustomerPhone)
VALUES ('CustomerD', CHECKSUM('13880975623'), EncryptByKey( Key_GUID('SymKey_TestDb'), '13880975623'));  

-- Close the symmetric key
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

性能对比

以下是对优化前后的查询语句写法以及性能对比展示。

优化前

优化前，是对电话号码密文在WHERE语句中解密出来，然后和用户侧输入的电话号码明文进行比较，获取到相应的数据行。

查询语句

查询的语句写法如下，关键点请注意WHERE语句：WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = ‘13487759293’

USE [TestDb]
GO

-- empty buffer cache
DBCC DROPCLEANBUFFERS
GO

OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY ASYMMETRIC KEY AsymKey_TestDb WITH PASSWORD = 'Password4@Asy';

SET STATISTICS TIME ON
SET STATISTICS IO ON
GO

SELECT 
	*,
	DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo
WHERE CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13487759293'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

执行计划

从查询语句的执行计划来看，走的Clustered Index Scan，几乎等价于表扫描，SQL Server需要扫面这张表的所有数据，才能找到对应的数据行。

性能指标

从性能指标来看，Logical reads: 13957，CPU: 13010 ms，Duration: 41682 ms，性能消耗非常严重，查询性能低下。

优化后

优化后的查询，我们使用电话号码明文Hash值列CustomerPhone_Hashkey进行查询，去找到对应的数据行。

查询语句

查询的关键点在WHERE CustomerPhone_Hashkey = CHECKSUM(‘13487759293’)。

USE [TestDb]
GO 
-- empty buffer cache
DBCC DROPCLEANBUFFERS
GO

OPEN SYMMETRIC KEY SymKey_TestDb
DECRYPTION BY ASYMMETRIC KEY AsymKey_TestDb WITH PASSWORD = 'Password4@Asy';
GO
SET STATISTICS TIME ON
SET STATISTICS IO ON
GO

SELECT 
		*,
		DescryptedCustomerPhone = CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone))
FROM dbo.CustomerInfo WITH(NOLOCK)
WHERE CustomerPhone_Hashkey = CHECKSUM('13487759293')
	AND CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = '13487759293'

-- Close the symmetric key
CLOSE SYMMETRIC KEY SymKey_TestDb;
GO

执行计划

从执行计划我们也可以看出，SQL Server从Clustered Index Scan操作变成了Index Seek操作了，可以直接定位到具体的数据行。

性能指标

优化后的性能指标来看，性能天壤之别，Logical reads: 6，CPU: 0ms，Duration: 2ms。

注意：
为了防止Hash对撞，在WHERE语句中需要添加如下条件语句：
AND CONVERT(CHAR(11), DecryptByKey(EncryptedCustomerPhone)) = ‘13487759293’

性能对比图

总结下优化前后的LogicalReads、CPU和Duration指标，如下表所示：

从此表格，我们可以看到查询性能有质的飞跃，不论是从IO逻辑读、CPU消耗还是从执行时间，性能都有非常大的提升。

最后总结

本文分享了使用SQL Server列加密技术后，应用端可能面临的查询性能问题以及完整的解决方案。通过此方案，我们可以很好兼顾：最大限度保证用户数据安全性的前提下，还能最大程度的提升我们的查询性能。

  

    

		

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
