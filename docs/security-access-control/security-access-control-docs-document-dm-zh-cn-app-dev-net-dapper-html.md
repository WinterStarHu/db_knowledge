# Dapper 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/net-Dapper.html

Dapper 框架 | 达梦技术文档

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

Dapper 框架

一、前言

Dapper 是一个简单的.NET 对象映射器，在速度方面具有"King of Micro ORM"的头衔，几乎与使用原始的 ADO.NET 数据读取器一样快。ORM 是一个对象关系映射器，它负责数据库和编程语言之间的映射。 Dapper 通过扩展 IDbConnection 提供一些有用的扩展方法去查询您的数据库。

二、环境准备

2.1 开发工具准备

Visual Studio 下载地址为 https://visualstudio.microsoft.com/zh-hans/vs/  。

本次  Windows 环境下使用 Visual Studio 版本为 Microsoft Visual Studio Professional 2022 (64 位) - Current 版本 17.6.2 。

2.2 达梦数据库安装

请参考数据库环境准备。

2.3 创建项目

打开 visual stdio 软件，创建一个新项目。

配置项目名。

新建一个类。

2.4 添加驱动

使用 DmProvider 时，需要注意提前装好对应框架，本次使用 Visual Studio 时已经下好了对应 SDK , 本次使用 NET Framework 版本为 4.8  ，需采用对应或接近达梦驱动版本，因此对应达梦 net45  。

首先在项目中引用 DmProvider.dll ， DmProvider.dll 在达梦数据库安装目录下的 ..\drivers\dotNet\DmProvider 文件夹下可以找到。添加方法：右键引用->【添加引用】，本案例使用 net45 版本的 DmProvider 。

添加 Dapper , 添加方法：右键引用-> 管理 NuGet 程序包，搜索 Dapper 并下载。

三、开发示例

提前准备好测试表，以下为建表语句：

CREATE TABLE "SYSDBA"."PERSON" ( "ID" INT IDENTITY(1, 1) NOT NULL, "NAME" CHAR(10), "CITY" CHAR(10), NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "MAIN", CLUSTERBTR) ;

测试代码如下：

using Dapper;
using Dm;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Runtime.ConstrainedExecution;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

/*Dapper是一个轻量级的ORM框架，现在使用的也很广泛，可以简化代码编写。因为Dapper扩展的IDbConnection，这是ADO.NET中的东西，我们使用的DmProvider也是实现了ADO.NET相关接口，所以Dapper可以通过DmProvider操作达梦数据库。*/ namespace netDemo { class Dapper2 {

public class DmConnectionFactory { static string sqlConnString = "Server=127.0.0.1; UserId=SYSDBA; PWD=*****";
public static IDbConnection GetConn() { return new DmConnection(sqlConnString);
} }

public static void Main() { Dapper2 dapper = new Dapper2();
PersonModel model = new PersonModel();

model.Name = "dad";
model.City = "dadafaf";
dapper.Add(model);

model=dapper.Get(1);
Console.WriteLine(model.ToString());
Console.ReadLine();
Console.ReadKey();

List list = dapper.GetList();
foreach (PersonModel model2 in list) { Console.WriteLine(model2.ToString());
} Console.ReadKey();

model.Name = "sdadfa";
model.City = "wqrqr";
model.Id = 1;
bool a=dapper.Update(model);
Console.WriteLine(a);
Console.ReadLine();

bool b = dapper.Delete(2);
Console.WriteLine(b);
Console.ReadLine();

}

public PersonModel Get(int id) { string sql = "select Id,Name,City from Person where Id=:Id";
return DmConnectionFactory.GetConn().QueryFirstOrDefault(sql, new { Id = id });
}

public List GetList() { string sql = "select Id,Name,City from Person";
return DmConnectionFactory.GetConn().Query(sql).ToList();
}

public int Add(PersonModel model) { string sql = "insert into Person(Name,City) Values(:Name,:City);Select @@IDENTITY";
return DmConnectionFactory.GetConn().QuerySingle(sql, model);
}

public bool Update(PersonModel model) { string sql = "update Person set City=:City where Id=:Id";
int result = DmConnectionFactory.GetConn().Execute(sql, model);
return result > 0;
}

public bool Delete(int id) { string sql = "delete from Person where Id=:Id";
int result = DmConnectionFactory.GetConn().Execute(sql, new { Id = id });
return result > 0;
}

}

struct PersonModel { public int Id { set; get; } public string Name { set; get; } public string City { set; get; } public override string ToString() { return Id + "," + Name +"," + City; } } }

四、常见问题

4.1 使用 VS 下载 Dapper 失败

【问题描述】：使用 VS 的 Nuget 下载如果出现下载慢的情况。

【解决方法】：添加国内的资源地址。

腾讯的资源地址为：

https://mirrors.cloud.tencent.com/nuget/ 。

华为的资源地址为:

https://repo.huaweicloud.com/repository/nuget/v3/index.json 。

4.2  VS Nuget 安装出现 "System.AggregateException"

【问题描述】：尝试添加源“。。。。”的引发了类型 “System.AggregateException” ，请检查你的所有联机包源是否都可用的错误。

【解决方法】：如果出现此问题其实是这个源地址已经无效了，所以需要把这个源地址删除，或者不勾选。配置好华为或腾讯数据源后，数据源 nuget.org 进行删除即可。

4.3  Nuget 无法访问

【问题描述】：Nuget:https://api.nuget.org/v3/index.json 无法访问。

【解决方法】：转到 Visual Studio 安装位置，本机安装路径为 C:\Microsoft Visual Studio\2022\Professional\Common7\IDE ，以管理员身份打开 devenv.exe.config 文件。

如下所示，在现有的 system.net 标签中添加 defaultProxy 标签。

五、参考

1．示例代码下载：Dapper.zip 文件。

2．以上文档内容参考过程中遇到任何问题，可到达梦技术社区提问交流。

上次更新：2026-09-26 上一篇下一篇

Dapper 框架

一、前言 二、环境准备
2.1 开发工具准备
2.2 达梦数据库安装
2.3 创建项目
2.4 添加驱动
三、开发示例 四、常见问题
4.1 使用 VS 下载 Dapper 失败
4.2  VS Nuget 安装出现 "System.AggregateException"
4.3  Nuget 无法访问
五、参考

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
