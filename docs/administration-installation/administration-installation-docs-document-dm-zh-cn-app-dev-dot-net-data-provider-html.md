# .Net Data Provider | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/dot-Net-Data-Provider.html

.Net Data Provider | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

.Net Data Provider

一、前言

.NET Data Provider 是 .NET Framework 编程环境下的数据库用户访问数据库的编程接口，用于连接到数据库、执行命令和检索结果。在数据源和代码之间创建了一个最小层，以便在不以功能为代价的前提下提高性能。

二、环境准备

2.1 开发环境准备

名称 版本

DM 数据库 DM 8.0 及以上版本

Visual Studio 2019

2.2 达梦数据库安装

请参考数据库环境准备。

2.3 创建项目

打开 visual studio 软件，创建一个新项目。

配置项目名。

添加一个项，右键【解决方案】->【添加】->【新建项】。

添加一个新的 visual C# 类后如图所示。

2.4 添加驱动

首先在项目中引用 DmProvider.dll，DmProvider.dll 在达梦数据库安装目录下的 ..\drivers\dotNet\DmProvider  文件夹下可以找到。添加方法：右键引用->【添加引用】。

从浏览中找到 DmProvider.dll，并添加。

添加驱动后使用，添加 using Dm。

右键【引用】->【程序集】-> 添加 System、System.Data。

在代码中引用，如图所示：

using System;
using System.Data;

三、数据库连接

DM provider 接口登录登出示例程序 provider_conn.cs 如下：

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Dm;

namespace provider_conn { class conn { static void Main(string[] args) { try { // 连接测试 DmConnection conn = new DmConnection();
conn.ConnectionString = "Server=192.168.104.21:51236; UserId=SYSDBA; PWD=*****;";
conn.Open();
Console.WriteLine("dmprovider: connect success!");
conn.Close();
} catch (Exception ex) { Console.WriteLine(ex.Message);
} } } }

执行结果如下：

注意

需要选择正确的启动对象才能启动成功，启动对象名应为想要启动的文件的文件名，如下图启动的文件则为 provider_dml.cs。

四、开发示例

4.1 基础操作示例

DM provider 接口增、删、改、查四个基本操作，示例程序 provider_dml.cs 如下：

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dm;

namespace provider_dml { class dml { static void Main(string[] args) { try { DmConnection conn = new DmConnection();
conn.ConnectionString = "Server=192.168.104.21:51236; UserId=SYSDBA; PWD=*****;";
conn.Open();

//清理测试环境 DmCommand cmd = new DmCommand();
cmd.Connection = conn;
cmd.CommandText = "delete from PRODUCTION.PRODUCT_CATEGORY";
cmd.ExecuteNonQuery();

//插入数据 cmd.CommandText = "insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values('语文'), ('数学'), ('英语'), ('体育')";
cmd.ExecuteNonQuery();
Console.WriteLine("dmprovider: insert success!");

//删除数据 cmd.CommandText = "delete from PRODUCTION.PRODUCT_CATEGORY where name='数学'";
cmd.ExecuteNonQuery();
Console.WriteLine("dmprovider: delete success!");

//更新数据 cmd.CommandText = "update PRODUCTION.PRODUCT_CATEGORY set name = '英语-新课标' where name='英语'";
cmd.ExecuteNonQuery();
Console.WriteLine("dmprovider: update success!");

//查询数据 cmd.CommandText = "select name from PRODUCTION.PRODUCT_CATEGORY";
DmDataReader reader =(DmDataReader)cmd.ExecuteReader();
while (reader.Read()) { string name = reader.GetString(0);
Console.WriteLine("name：" + name);
} reader.Close();
Console.WriteLine("dmprovider: select success!");

conn.Close();
} catch (Exception ex) { Console.WriteLine(ex.Message);
} } } }

执行结果如下：

4.2 绑定变量示例

DM provider 接口绑定变量示例程序 provider_bind.cs 如下：

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dm;

namespace provider_bind { class bind { static void Main(string[] args) { try { DmConnection conn = new DmConnection();
conn.ConnectionString = "Server=192.168.104.21:51236; UserId=SYSDBA; PWD=*****;";
conn.Open();

//清理测试环境 DmCommand cmd = new DmCommand();
cmd.Connection = conn;
cmd.CommandText = "delete from PRODUCTION.PRODUCT_CATEGORY";
cmd.ExecuteNonQuery();

//插入数据 cmd.CommandText = "insert into PRODUCTION.PRODUCT_CATEGORY(name) values(:s_name)";
var para1 = new DmParameter(":s_name", DmDbType.VarChar, 50);
cmd.Parameters.Add(para1);
para1.Value = "物理";
cmd.ExecuteNonQuery();
Console.WriteLine("dmprovider: insert with bind success!");

//查询数据 cmd.Parameters.Clear();
cmd.CommandText = "select name from PRODUCTION.PRODUCT_CATEGORY";
DmDataReader reader = (DmDataReader)cmd.ExecuteReader();
while (reader.Read()) { string name = reader.GetString(0);
Console.WriteLine("name：" + name);
} reader.Close();

conn.Close();
} catch (Exception ex) { Console.WriteLine(ex.Message);
} } } }

执行结果如下：

4.3 大字段操作示例

DM provider 接口大字段操作包括大字段的插入，查询等。示例程序 provider_lob.cs 如下：

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dm;

namespace provider_lob { class lob { static void Main(string[] args) { try { DmConnection conn = new DmConnection();
conn.ConnectionString = "Server=192.168.104.21:51236; UserId=SYSDBA; PWD=*****;";
conn.Open();

//清理测试环境 DmCommand cmd = new DmCommand();
cmd.Connection = conn;
cmd.CommandText = "drop table if exists PRODUCTION.BIG_DATA";
cmd.ExecuteNonQuery();
cmd.CommandText = "create table PRODUCTION.BIG_DATA(c1 int, c2 blob)";
cmd.ExecuteNonQuery();

// 读取文件数据，写入 lob 列 FileInfo fi = new FileInfo(@"..\..\file\DM8_SQL.pdf");
FileStream fs = fi.OpenRead();
int nBytes = (int)fs.Length;
byte[] dataArray = new byte[nBytes];
fs.Read(dataArray, 0, nBytes);
fs.Close();

cmd.CommandText = "insert into PRODUCTION.BIG_DATA values(1, :blob)";
DmParameter param1 = new DmParameter(":blob", DmDbType.Binary);
cmd.Parameters.Add(param1);
param1.Value = dataArray;
cmd.ExecuteNonQuery();
Console.WriteLine("dmprovider: write to col of lob success!");

//读取 lob 列数据，写入到文件中 DmBlob buffer;
cmd.Parameters.Clear();
cmd.CommandText = "select c2 from PRODUCTION.BIG_DATA";
DmDataReader reader = (DmDataReader)cmd.ExecuteReader();
reader.Read();
buffer = reader.GetBlob(0);
int length = buffer.Length();

FileStream fs1 = new FileStream(@"..\..\file\DM8_SQL1.pdf", FileMode.Create);
fs1.Write(buffer.GetBytes(0, length), 0, length);
fs1.Flush();
fs1.Close();
Console.WriteLine("dmprovider: get data from col of lob success!");

reader.Close();

conn.Close();
} catch (Exception ex) { Console.WriteLine(ex.Message);
} } } }

执行结果如下：

五、常见问题

1. DmException：试图在只读事务中修改数据

达梦数据库的事务隔离级分为四级，默认是“读提交隔离级”。可以检查一下是否设置隔离级别为“只读事务”。

2. NET 程序中使用 DmBulkCopy 对象执行时报错

【问题描述】：.NET 程序中使用 DmBulkCopy 对象执行时报错：

##具体报错信息如下：
Unhandled exception. Dm.DmException (0x80004005): The fastloading dll not loading!
at Dm.DmFldr.Initilize(DmConnProperty props, String desttable, DmBulkCopyOptions op, Int32 rows, DataTable table) at Dm.DmBulkCopy.WriteToServer(DataTable table)

【问题分析】：DmBulkCopy 对象用于快速批量装载数据。实现 IDisposable 接口。该功能依赖 DM 安装目录 \bin 下的 dmfldr_dll.dll 等动态链接库，需要拷贝到应用程序的执行目录。

驱动文档里的说明：

DmProvider 文件夹中是完整的 DmProvider 驱动文件。使用 DmProvider 的 DmBulkCopy 对象，需要引用 dmfldr_dll.dll 以及此 dll 依赖的其他库。

添加 dmfldr_dll.dll 引用时会报错，这种方法无效。

【问题解决】：在 Path 环境变量里面加上达梦的 bin 目录：

3. .net 程序服务名连接达梦集群，备机异常时，连接异常变慢

在 dm_svc.conf 中配置连接超时参数 connnectTimeout，可配置为 connnectTimeout=(3)。

4. 在指定的 DSN 中，驱动程序和应用程序之间的体系结构不匹配

达梦和应用的位数不匹配，检查应用是 32 位还是 64 位，安装的 dm 是 32 位还是 64 位。

5. 报错“加密模块加载失败”

【问题分析】：libeay32.dll 这个加密动态库找不到。

【问题解决】：在系统环境变量中配置达梦的 bin 目录，或者把 dm 的安装目录环境变量设置到最前面或者把这个动态库以及依赖文件拷贝到程序目录下面或者 system32（可以拷贝 bin 目录下所有动态库文件）

6. 调用“get_ProviderFactory”方法后，返回 null

【问题描述】：System.Data.Entity.Core.ProviderIncompatibleException：

对类型 “Dm.DmConnection” 的存储区提供程序实例调用“get_ProviderFactory”方法后，返回 null。存储区提供程序可能没有正确运行。

【问题解决】：DmProvider.dll 用的不是最新版本。修改为新版本即可。

7. This SQL map does not contain a MappedStatement named xxx…

【问题解决】：检查配置文件中的命名空间是否有误，例如：

8. The provider is not in 'providers.config' or is not enabled.

【问题解决】：在 Providers.config 文件中将对应的 provider 的 enabled 选项改成 true

六、参考

示例代码下载：.Net_Code.zip。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

.Net Data Provider

一、前言 二、环境准备
2.1 开发环境准备
2.2 达梦数据库安装
2.3 创建项目
2.4 添加驱动
三、数据库连接 四、开发示例
4.1 基础操作示例
4.2 绑定变量示例
4.3 大字段操作示例
五、常见问题 六、参考

微信扫码 分享文档

扫一扫 联系客服

关于我们

合作伙伴

招贤纳士

英文站

达梦官网

达梦技术

蜀天梦图

微信公众号

24小时热线

400 991 6599

商务咨询转 1 号线

技术咨询转 2 号线

技术支持

dmtech@dameng.com

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

简体中文

简体中文
