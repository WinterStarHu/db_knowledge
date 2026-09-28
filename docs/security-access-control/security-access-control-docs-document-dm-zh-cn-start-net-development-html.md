# .NET | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/net-development.html

.NET | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

DM 数据库版本介绍

版本区别 版本获取

DM 数据库安装

Windows 安装

安装前准备 数据库安装 配置实例 启动、停止数据库

Linux 安装

安装前准备 数据库安装 配置实例 注册服务 启动、停止数据库

数据库目录结构介绍

DM 数据库工具介绍

DM 服务查看器 DM 管理工具 DM 数据迁移工具 SQL 交互式查询工具 DM 数据库配置助手 DM 性能监视工具 DM 控制台工具 SQLark 数据库开发、管理和迁移工具

DM 数据库基本操作

创建表空间

创建用户

创建用户关联表空间 授予权限 用户与模式的关系

创建数据库对象

DM 数据移植

从 Oracle 移植到 DM 从 MySQL 移植到 DM 从 PostgreSQL 移植到 DM 从 SQL Server 移植到 DM 从 DB2 移植到 DM

基于 SQLark 进行数据迁移

从Oracle迁移到DM 从MySQL迁移到DM 从PostgreSQL迁移到DM

DM 应用程序开发

C/C++ Python .NET

GO

GO_DM GO_ODBC

JAVA PHP QODBC GeoServer JBOSS 添加达梦数据源

DM 数据库集群介绍

数据守护集群 共享存储集群 新一代分布式集群

达梦数据复制软件DMDRS

产品介绍 安装部署 功能特性 平台介绍

.NET

一、获取 DmProvider 驱动

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版，在数据库安装路径 drivers 目录下，找到对应驱动程序，请参考 DM 数据库安装。

二、通过 DmProvider 连接数据库

使用 DmProvider 时需要注册 .NET 驱动，例如通过 DbProviderFactories 类调用 DmProvider 创建连接，NHibernate 及 EFDmProvider 的使用，都需要注册 .net 驱动。

2.1 注册 DmProvider

使用 NETFX 注册 DmProvider 驱动

我的电脑路径在 C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8.1 Tools

执行以下命令

gacutil.exe  /if  C:\Users\Administrator\source\repos\EFDMDem\EFDMDem\bin\Debug\DmProvider.dll

记得用管理员启动

如果出现以下则是没有权限

使用管理员使用此命令，出现下图说明添加成功

2.2 读取达梦 dll 公钥

此步骤可以不做，达梦此驱动公钥都是 7a2d44aa446c6d01，没有跟随版本变化

我的 NETFX 路径位于 C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8.1 Tools

执行以下命令读取公钥

SN -T C:\Users\Administrator\source\repos\EFDMDem\EFDMDem\bin\Debug\DmProvider.dll

2.3 修改 machine.config

C:\Windows\Microsoft.NET\Framework 下找到使用的版本里面修改 machine.config 配置

我的电脑路径为 C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config

在配置文件 machine.config 中添加以下内容：

注意

记得在里面搜索DbProviderFactorie，里面默认使用了DbProviderFactorie标签，配置文件只允许有一个DbProviderFactorie标签，找到标签位置，进行修改。

例如通过 DbProviderFactories 类调用 DmProvider 创建连接使用 .NET 驱动的情况，using System.Data.Common，如下所示：

using System.Data.Common;
using System;

namespace EFDMDem { class ProcDemo { public static void Main() { DbProviderFactory factory = DbProviderFactories.GetFactory("Dm");
DbConnection sconn = factory.CreateConnection();
sconn.ConnectionString = "Server=localhost; UserId=SYSDBA; PWD=*****";
sconn.Open();
DbCommand scmd = factory.CreateCommand();
scmd.Connection = sconn;
try { scmd.CommandText = "CREATE TABLE TEST(ID INT)";
scmd.ExecuteNonQuery();
} catch (Exception) { } } } }

登陆达梦管理工具进行查看，发现表已经添加成功

上次更新：2026-09-26 上一篇下一篇

.NET

一、获取 DmProvider 驱动 二、通过 DmProvider 连接数据库
2.1 注册 DmProvider
2.2 读取达梦 dll 公钥
2.3 修改 machine.config

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

DM 数据库版本介绍

版本区别 版本获取

DM 数据库安装

Windows 安装

安装前准备 数据库安装 配置实例 启动、停止数据库

Linux 安装

安装前准备 数据库安装 配置实例 注册服务 启动、停止数据库

数据库目录结构介绍

DM 数据库工具介绍

DM 服务查看器 DM 管理工具 DM 数据迁移工具 SQL 交互式查询工具 DM 数据库配置助手 DM 性能监视工具 DM 控制台工具 SQLark 数据库开发、管理和迁移工具

DM 数据库基本操作

创建表空间

创建用户

创建用户关联表空间 授予权限 用户与模式的关系

创建数据库对象

DM 数据移植

从 Oracle 移植到 DM 从 MySQL 移植到 DM 从 PostgreSQL 移植到 DM 从 SQL Server 移植到 DM 从 DB2 移植到 DM

基于 SQLark 进行数据迁移

从Oracle迁移到DM 从MySQL迁移到DM 从PostgreSQL迁移到DM

DM 应用程序开发

C/C++ Python .NET

GO

GO_DM GO_ODBC

JAVA PHP QODBC GeoServer JBOSS 添加达梦数据源

DM 数据库集群介绍

数据守护集群 共享存储集群 新一代分布式集群

达梦数据复制软件DMDRS

产品介绍 安装部署 功能特性 平台介绍

简体中文

简体中文
