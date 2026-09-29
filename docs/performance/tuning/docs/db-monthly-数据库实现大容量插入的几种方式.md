# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/06/09/
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
	

  

    
数据库内核月报 － 2016 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 特性分析 · innodb 锁分裂继承与迁移
                      

                    

                    

                  
                      

                        MySQL · 特性分析 ·MySQL 5.7新特性系列二
                      

                    

                    

                  
                      

                        PgSQL · 实战经验 · 如何预测Freeze IO风暴
                      

                    

                    

                  
                      

                        GPDB · 特性分析· Filespace和Tablespace
                      

                    

                    

                  
                      

                        MariaDB · 新特性 · 窗口函数
                      

                    

                    

                  
                      

                        MySQL · TokuDB  · checkpoint过程
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 内部临时表
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 空间优化
                      

                    

                    

                  
                      

                        SQLServer · 最佳实践 · 数据库实现大容量插入的几种方式
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB COUNT(*) 优化(?)
                      

                    

 
        

    

  

    
 SQLServer · 最佳实践 · 数据库实现大容量插入的几种方式  

    
 Author: 石沫  

  

  

  
背景

很多用户在使用阿里云云数据库SQL Server时，为了加快插入速度，都尝试使用大容量插入的方式，大家都知道，对于完整恢复模式下的数据库，大容量导入执行的所有行插入操作都会完整地记录在事务日志中。如果使用完整恢复模式，大型数据导入会导致填充事务日志的速度很快。相反，对于简单恢复模式或大容量日志恢复模式，大容量导入操作的按最小方式记录日志减少了大容量导入操作填满日志空间的可能性。另外，按最小方式记录日志的效率也比按完整方式记录日志高  。
但实际上，当大容量导入与数据库镜像共存时，会出现镜像 Suspend的情况，这个情况是由于
微软在2008 R2上的BUG
导致,微软已经明确表示在2008 R2不会FIXED，那么如何正确在RDS使用大容量导入并避免镜像异常，下面介绍几种方式.

实现方法

  
通过ADO.NET SQLBulkCopy 方式

只需要将SqlBulkCopy 指定SqlBulkCopyOptions.CheckConstraints就好，即：SqlBulkCopy blkcpy = new SqlBulkCopy(desConnString, SqlBulkCopyOptions.CheckConstraints)
例如：将本地的一个大表通过SQLBulkCopy方式导入到RDS的实例中

static void Main()
{
  string srcConnString = "Data Source=(local);Integrated Security=true;
  Initial Catalog=testdb";
  string desConnString = "Data Source=****.sqlserver.rds.aliyuncs.com,3433;
  UserID=**;Password=**;Initial Catalog=testdb";

  SqlConnection srcConnection = new SqlConnection();
  SqlConnection desConnection = new SqlConnection();

  SqlCommand sqlcmd = new SqlCommand();
  SqlDataAdapter da = new SqlDataAdapter();
  DataTable dt = new DataTable();

  srcConnection.ConnectionString = srcConnString;
  desConnection.ConnectionString = desConnString;
  sqlcmd.Connection = srcConnection;

  sqlcmd.CommandText = @"
  SELECT top 1000000 [PersonType],[NameStyle],[Title],[FirstName],[MiddleName],
  [LastName] ,[Suffix],[EmailPromotion],[AdditionalContactInfo],[Demographics],NULL 
  as rowguid,[ModifiedDate] FROM [testdb].[dbo].[Person]";

  sqlcmd.CommandType = CommandType.Text;
  sqlcmd.Connection.Open();
  da.SelectCommand = sqlcmd;
  da.Fill(dt);

  using (SqlBulkCopy blkcpy = 
  new  SqlBulkCopy(desConnString,SqlBulkCopyOptions.CheckConstraints))
  // using (SqlBulkCopy blkcpy = 
  // new SqlBulkCopy(desConnString, SqlBulkCopyOptions.Default))
  {
    blkcpy.BatchSize = 2000;
    blkcpy.BulkCopyTimeout = 5000;
    blkcpy.SqlRowsCopied += new SqlRowsCopiedEventHandler(OnSqlRowsCopied);
    blkcpy.NotifyAfter = 2000;

    foreach (DataColumn dc in dt.Columns)
    {
      blkcpy.ColumnMappings.Add(dc.ColumnName, dc.ColumnName);
    }

    try
    {
      blkcpy.DestinationTableName = "Person";
      blkcpy.WriteToServer(dt);
    }
    catch (Exception ex)
    {
      Console.WriteLine(ex.Message);
    }
    finally
    {
      sqlcmd.Clone();
      srcConnection.Close();
      desConnection.Close();
    }
  }
}

private static void OnSqlRowsCopied(
    object sender, SqlRowsCopiedEventArgs e)
{
  Console.WriteLine("Copied {0} so far...", e.RowsCopied);
}

  
通过JDBC SQLServerBulkCopy 方式

同样的道理，需要在copyOptions指定检查约束性
SQLServerBulkCopyOptions copyOptions = new SQLServerBulkCopyOptions();  
copyOptions.setCheckConstraints(true);
测试时，请用Microsoft JDBC Drivers 6.0 的sqljdbc41.jar，sqljdbc4.jar及更老版本没有SQLServerBulkCopy 实现。

例如: 将本地的一个大表通过SQLServerBulkCopy方式导入到RDS的实例中

import java.sql.*;
import com.microsoft.sqlserver.jdbc.SQLServerBulkCopy;
import com.microsoft.sqlserver.jdbc.SQLServerBulkCopyOptions;

public class Program {
  public static void main(String[] args)  
  {  
    String sourceConnectionString  = "jdbc:sqlserver://localhost:1433;" +  
            "databaseName=testdb;user=****;password=****";  
    String destConnectionString  = "jdbc:sqlserver://*****.sqlserver.rds.aliyuncs.com:3433;" +  
            "databaseName=testdb;user=****;password=**** ";  
    try  
    {  
      Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");  
      try (Connection sourceConnection =
           DriverManager.getConnection(sourceConnectionString))  
      {  
        try (Statement stmt = sourceConnection.createStatement())  
        {  
          try (ResultSet rsSourceData = stmt.executeQuery(  
                " SELECT top 1000000 " +
                "[PersonType],[NameStyle],[Title],[FirstName],[MiddleName],[LastName] ," +
                "[Suffix],[EmailPromotion],[AdditionalContactInfo]," +
                "[Demographics],NULL as rowguid,[ModifiedDate] " +
                "FROM [testdb].[dbo].[Person]"))  
          {   
            try (Connection destinationConnection =  DriverManager.getConnection(destConnectionString))  
            {  
              Statement stmt1 = destinationConnection.createStatement();
              			
              long countStart = 0;  
              try (ResultSet rsRowCount = stmt1.executeQuery(  
                      "SELECT COUNT(*) FROM dbo.Person;"))  
              {  
                rsRowCount.next();  
                countStart = rsRowCount.getInt(1);  
                System.out.println("Starting row count = " + countStart);  
              }  
                 
              try (SQLServerBulkCopy bulkCopy =   new SQLServerBulkCopy(destinationConnection))  
              {  
                SQLServerBulkCopyOptions copyOptions = new SQLServerBulkCopyOptions();  
                copyOptions.setKeepIdentity(true);  
                copyOptions.setBatchSize(2000);
                copyOptions.setBulkCopyTimeout(5000);
                //this is importance setting
                copyOptions.setCheckConstraints(true);
                bulkCopy.setBulkCopyOptions(copyOptions);
                bulkCopy.setDestinationTableName("dbo.Person");  
                bulkCopy.addColumnMapping("PersonType", "PersonType");  
                bulkCopy.addColumnMapping("NameStyle", "NameStyle");  
                bulkCopy.addColumnMapping("Title", "Title");  
                bulkCopy.addColumnMapping("FirstName", "FirstName");  
                bulkCopy.addColumnMapping("MiddleName", "MiddleName");  
                bulkCopy.addColumnMapping("LastName", "LastName");  
                bulkCopy.addColumnMapping("Suffix", "Suffix");  
                bulkCopy.addColumnMapping("EmailPromotion", "EmailPromotion");  
                bulkCopy.addColumnMapping("AdditionalContactInfo", "AdditionalContactInfo");  
                bulkCopy.addColumnMapping("Demographics", "Demographics");  
                bulkCopy.addColumnMapping("rowguid", "rowguid");  
                bulkCopy.addColumnMapping("ModifiedDate", "ModifiedDate");  
                try  
                {  
                  bulkCopy.writeToServer(rsSourceData);  
                }  
                catch (Exception e)  
                {  
                  e.printStackTrace();  
                }  
                
                try (ResultSet rsRowCount = stmt1.executeQuery(  
                      "SELECT COUNT(*) FROM dbo.Person;"))  
                {  
                  rsRowCount.next();  
                  long countEnd = rsRowCount.getInt(1);  
                  System.out.println("Ending row count = " + countEnd);  
                  System.out.println((countEnd - countStart) + " rows were added.");  
                }  
              }  
            }  
          }  
        }  
      }  
    }  
    catch (Exception e)  
    {  
        e.printStackTrace();  
    }  
  }  
}

  
通过BCP方式

第一步：需要将数据BCP到本地

BCP testdb.dbo.person Out "bcp_data" /t  /N /U **** /P *** /S "****.sqlserver.rds.aliyuncs.com,3433"    

第二步：将导出的文件直接导入到RDS的实例中,但需要指定提示：/h “CHECK_CONSTRAINTS”

BCP testdb.dbo.person In "bcp_data" /C /N /q /k /h "CHECK_CONSTRAINTS" /U *** /P *** /b 500 /S  "***.sqlserver.rds.aliyuncs.com,3433"  

  
通过DTS/SSIS方式

第一种：import/export data方式需要先保存SSIS包，然后修改Connection Manager的属性 ，如下图

第二种：直接使用SQL Server Business Intelligence Development Stuidio新建 SSIS包：

  
特别说明

不能在RDS通过下列两种方式进行大容量插入: 原因是基于安全考虑不提供上传文件到RDS 数据库服务器。

第一种：

BULK INSERT testdb.dbo.person_in
FROM N'D:\trace\bcp.txt'
WITH
(
 CHECK_CONSTRAINTS 
);  

第二种：

INSERT ... SELECT * FROM OPENROWSET(BULK...)

  
总结

大容量导入数据会带来更快的插入，解决了用户在有大量数据导入缓慢困惑，在阿里云数据库中，你可以使用五种方式来实现业务场景，但是基于镜像的主备关系，需要特别加入一个检查约束的选项，这是写这个最佳实践的目的，一旦镜像SUSPEND，不断有DUMP文件产生，一来需要时间来修正，二来DUMP文件也会不断占用空间，但不会影响用户的可用性和可靠性。有两种方式在RDS中不能实现，另外，还可以通过ODBC来实现大容量导入，具体请
参见
。希望这些对大家有用，特别是阿里云云数据库使用用户。

  

    

		

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
