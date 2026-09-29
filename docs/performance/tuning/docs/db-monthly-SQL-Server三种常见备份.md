# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/11/03/
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
	

  

    
数据库内核月报 － 2017 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 数据恢复 · undrop-for-innodb
                      

                    

                    

                  
                      

                        MySQL ·  引擎特性 ·  DROP TABLE之binlog解析
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 ·  SQL Server三种常见备份
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 什么时候该升级内存规格
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · InnoDB LRU List刷脏改进之路
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MySQL 5.7 外部XA Replication实现及缺陷分析
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 ·  双十一数据运营平台订单Feed数据洪流实时分析方案
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · TokuDB hot-index机制
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 分区表基本类型
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 流式计算与异步消息在阿里实时订单监测中的应用
                      

                    

 
        

    

  

    
 MSSQL · 最佳实践 ·  SQL Server三种常见备份  

    
 Author: fengyi  

  

  

  
摘要

本期月报是SQL Server数据库备份技术系列文章的开篇，介绍三种常见的SQL Server备份方法的工作方式、使用T-SQL语句和使用SSMS IDE创建备份集三个层面，介绍SQL Server的三种常见备份的工作原理和使用方法。三种常见的备份包括：

数据库完全备份（Full Backup）

数据库日志备份（Transaction Log Backup）

数据库差异备份（Differential Backup）

备份的重要性

在开始分享之前，我们首先来看看数据库备份的重要性。进入DT时代，数据的价值越发体现，数据已经成为每个公司赖以生存的生命线，数据的重要性不言而喻，而公司绝大多数核心数据都存放在数据库里。数据库本身的灾难恢复（DR）能力是数据安全的最后一道防线，也是数据库从业者对数据安全底线的坚守。数据库中数据潜在的安全风险包括：硬件故障、恶意入侵、用户误操作、数据库损坏和自然灾害导致的数据损失等。在关系型数据库SQL Server中，数据库备份是灾难恢复的能力有力保证。

Full Backup

Full Backup（完全备份）是SQL Server所有备份类型中，最为简单、最基础的数据库备份方法，它提供了某个数据库在备份时间点的完整拷贝。但是，它仅支持还原到数据库备份成功结束的时间点，即不支持任意时间点还原操作。

Full Backup工作方式

以上是Full Backup是什么的解释，那么接下来，我们通过一张图和案例来解释Full Backup的工作原理。

这是一张某数据库的数据产生以及数据库备份在时间轴上的分布图，从左往右，我们可以分析如下：
7 P.m.：产生了数据#1

10 P.m.：数据库完全备份，备份文件中包含了#1

2 a.m.：产生了数据#2，目前数据包含#1，#2

6 a.m.：产生了数据#3，目前数据包含#1，#2，#3

10 a.m.：数据库完全备份，备份文件中包含#1，#2，#3

1 p.m.：产生了数据#4，目前数据包含#1，#2，#3，#4

5 p.m.：产生了数据#5，目前数据包含#1，#2，#3，#4，#5

8 p.m.：产生了数据#6，目前数据包含#1，#2，#3，#4，#5，#6

10 p.m.：数据库完全备份，备份文件中包含了数据#1，#2，#3，#4，#5，#6

从这张图和相应的解释分析来看，数据库完全备份工作原理应该是非常简单的，它就是数据库在备份时间点对所有数据的一个完整拷贝。当然在现实的生产环境中，事务的操作远比这个复杂，因此，在这个图里面有两个非常重要的点没有展示出来，那就是：

备份操作可能会导致I/O变慢：由于数据库备份是一个I/O密集型操作，所以在数据库备份过程中，可能会导致数据库的I/O操作变慢。

全备份过程中，数据库的事务日志不能够被截断：对于具有大事务频繁操作的数据库，可能会导致事务日志空间一直不停频繁增长，直到占满所有的磁盘剩余空间，这个场景在阿里云RDS SQL产品中有很多的客户都遇到过。其中之一解决方法就需要依赖于我们后面要谈到的事务日志备份技术。

T-SQL创建Full Backup

使用T-SQL语句来完成数据库的完全备份，使用BACKUP DATABASE语句即可，如下，对AdventureWorks2008R2数据库进行一个完全备份：

USE master
GO

BACKUP DATABASE [AdventureWorks2008R2] 
TO DISK = 'C:\Temp\AdventureWorks2008R2_20171112_FULL.bak' WITH COMPRESSION, INIT, STATS = 5;
GO

SSMS IDE创建Full Backup

除了使用T-SQL语句创建数据库的完全备份外，我们还可以使用SSMS IDE界面操作来完成，方法：
右键点击想要备份的数据库 => Tasks => Backup => 选择FULL Backup Type => 选择Disk 做为备份文件存储 => 点击Add 添加备份文件 => 选择你需要存储备份文件的目录 => 输入备份文件名，如下图两张图展示。

Back up Database设置界面

Transaction Log Backup

SQL Server数据库完全备份是数据库的完整拷贝，所以备份文件空间占用相对较大，加之可能会在备份过程中导致事务日志一直不断增长。为了解决这个问题，事务日志备份可以很好的解决这个问题，因为：事务日志备份记录了数据库从上一次日志备份到当前时间内的所有事务提交的数据变更，它可以配合数据库完全备份和差异备份（可选）来实现时间点的还原。当日志备份操作成功以后，事务日志文件会被截断，事务日志空间将会被重复循环利用，以此来解决完全备份过程中事务日志文件一致不停增长的问题，因此我们最好能够周期性对数据库进行事务日志备份，以此来控制事务日志文件的大小。但是这里需要有一个前提是数据库必须是FULL恢复模式，SIMPLE恢复模式的数据库不支持事务日志的备份，当然就无法实现时间点的还原。请使用下面的语句将数据库修改为FULL恢复模式，比如针对AdventureWorks2008R2数据库：

USE [master]
GO
ALTER DATABASE [AdventureWorks2008R2] SET RECOVERY FULL WITH NO_WAIT
GO

Transaction Log Backup工作方式

事务日志备份与数据完全备份工作方式截然不同，它不是数据库的一个完整拷贝，而是至上一次日志备份到当前时间内所有提交的事务数据变更。用一张图来解释事务日志备份的工作方式：

00:01：事务#1，#2，#3开始，未提交

00:02：事务#1，#2，#3成功提交；#4，#5，#6事务开始，未提交；这时备份事务日志；事务日志备份文件中仅包含已提交的#1，#2，#3的事务（图中的LSN 1-4，不包含#4）

00:04：由于在00:02做了事务日志备份，所以#1，#2，#3所占用的空间被回收；#4，#5，#6事务提交完成

00:05：事务#7已经提交成功；#8，#9，#10开始，但未提交；事务日志备份文件中包含#4，#5，#6，#7的事务（图中的LSN4-8，不包含#8）。

从这张图我们看到，每个事务日志备份文件中包含的是已经完成的事务变更，两次事务日志备份中存放的是完全不同的变更数据。而每一次事务日志备份成功以后，事务日志空间可以被成功回收，重复利用，达到了解决数据库完全备份过程中事务日志一致不断增长的问题。

T-SQL创建事务日志备份

使用T-SQL语句来创建事务日志的备份方法如下：

USE Master
GO

BACKUP LOG [AdventureWorks2008R2]
TO DISK = N'C:\temp\AdventureWorks2008R2_log_201711122201.trn' with compression,stats=1;
GO
BACKUP LOG [AdventureWorks2008R2]
TO DISK = N'C:\temp\AdventureWorks2008R2_log_201711122202.trn' with compression,stats=1;
GO
BACKUP LOG [AdventureWorks2008R2]
TO DISK = N'C:\temp\AdventureWorks2008R2_log_201711122203.trn' with compression,stats=1;
GO

SSMS IDE创建事务日志备份

使用SSMS IDE创建事务日志备份的方法：
右键点击想要创建事务日志备份的数据库 => Tasks => Backup => 选择Transaction Log Backup Type => 选择Disk 做为备份文件存储 => 点击Add 添加备份文件 => 选择你需要存储备份文件的目录 => 输入备份文件名，如下图展示：

事务日志备份链

由于数据库完全备份是时间点数据的完整拷贝，每个数据库完整备份相互独立，而多个事务日志备份是通过事务日志链条连接在一起，事务日志链起点于完全备份，SQL Server中的每一个事务日志备份文件都拥有自己的FirstLSN和LastLSN，FirstLSN用于指向前一个事务日志备份文件的LastLSN；而LastLSN指向下一个日志的FirstLSN，以此来建立这种链接关系。这种链接关系决定了事务日志备份文件还原的先后顺序。当然，如果其中任何一个事务日志备份文件丢失或者破坏，都会导致无法恢复整个事务日志链，仅可能恢复到你拥有的事务日志链条的最后一个。事务日志备份链条的关系如下图所示：

我们使用前面“T-SQL创建事务日志备份”创建的事务日志链，使用RESTORE HEADERONLY方法来查看事务日志链的关系：

USE Master
GO
RESTORE HEADERONLY FROM DISK = N'C:\temp\AdventureWorks2008R2_log_201711122201.trn';
RESTORE HEADERONLY FROM DISK = N'C:\temp\AdventureWorks2008R2_log_201711122202.trn';
RESTORE HEADERONLY FROM DISK = N'C:\temp\AdventureWorks2008R2_log_201711122203.trn';

查询结果如下：

从这个结果展示来看，事务日志备份文件AdventureWorks2008R2_log_201711122201的LastLSN指向了的AdventureWorks2008R2_log_201711122202的FirstLSN，而AdventureWorks2008R2_log_201711122202的LastLSN又指向了AdventureWorks2008R2_log_201711122203的FirstLSN，以此来建立了事务日志备份链条关系。假如AdventureWorks2008R2_log_201711122202的事务日志备份文件丢失或者损坏的话，数据库只能还原到AdventureWorks2008R2_log_201711122201所包含的所有事务行为。
这里有一个问题是：为了防止数据库事务日志一直不断的增长，而我们又不想每次都对数据库做完全备份，那么我们就必须对数据库事务日志做周期性的日志备份，比如：5分钟甚至更短，以此来降低数据丢失的风险，以此推算每天会产生24 * 12 = 288个事务日志备份，这样势必会导致事务日志恢复链条过长，拉长恢复时间，增大了数据库还原时间（RTO）。这个问题如何解决就是我们下面章节要分享到的差异备份技术。

Differential Backup

事务日志备份会导致数据库还原链条过长的问题，而差异备份就是来解决事务日志备份的这个问题的。差异备份是备份至上一次数据库全量备份以来的所有变更的数据页，所以差异备份相对于数据库完全备份而言往往数据空间占用会小很多。因此，备份的效率更高，还原的速度更快，可以大大提升我们灾难恢复的能力。

Differential Backup工作方式

我们还是从一张图来了解数据库差异备份的工作方式：

7 a.m.：数据包含#1

10 a.m.：数据库完全备份，备份文件中包含#1

1 p.m.：数据包含#1，#2，#3，#4

2 p.m.：数据库差异备份，备份文件中包含#2，#3，#4（上一次全备到目前的变更数据）

4 p.m.：数据包含#1，#2，…，#6

6 p.m.：数据库差异备份，备份文件中包含#2，#3，#4，#5，#6

8 p.m.：数据包含#1，#2，…，#8

10 p.m.：数据库完全备份，备份文件中包含#1，#2，…，#8

11 p.m.：产生新的数据#9，#10;数据包含#1，#2，…，#10

2 a.m.：数据库差异备份，备份文件中包含#9，#10

从这个差异备份的工作方式图，我们可以很清楚的看出差异备份的工作原理：它是备份继上一次完全备份以来的所有数据变更，所以它大大减少了备份日之链条的长度和缩小备份集的大小。

T-SQL创建差异备份

使用T-SQL语句创建差异备份的方法如下：

USE master
GO
BACKUP DATABASE [AdventureWorks2008R2] 
TO DISK = 'C:\Temp\AdventureWorks2008R2_20171112_diff.bak' WITH DIFFERENTIAL
GO

SSMS创建差异备份

使用SSMS IDE创建差异备份的方法：
右键点击想要创建事务日志备份的数据库 => Tasks => Backup => 选择Differential Backup Type => 选择Disk 做为备份文件存储 => 点击Add 添加备份文件 => 选择你需要存储备份文件的目录 => 输入备份文件名，如下图展示：

最后总结

本期月报分享了SQL Server三种常见的备份技术的工作方式和备份方法。数据库完全备份是数据库备份时间的一个完整拷贝；事务日志备份是上一次日志备份到当前时间的事务日志变更，它解决了数据库完全备份过程中事务日志一直增长的问题；差异备份上一次完全备份到当前时间的数据变更，它解决了事务日志备份链过长的问题。
将SQL Server这三种备份方式的工作方式，优缺点总结如下表格：

从这个表格，我们知道每种备份有其各自的优缺点，那么我们如何来制定我们的备份和还原策略以达到快速灾难恢复的能力呢？这个话题，我们将在下一期月报中进行分享。

参考

Full Backup工作方式图参考

Transaction Log Backup工作方式图参考

Differential Backup工作方式图参考

  

    

		

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
