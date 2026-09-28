# 用户与模式的关系 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-user-mode-relation.html

用户与模式的关系 | 达梦技术文档

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

用户与模式的关系

每个用户有一个默认的同名的模式，访问自己模式下的表、视图等，不需要加模式名，访问其他模式下的对象需要拥有访问权限，访问时还需加上模式名。

一、查询当前用户模式下的表，无需加对象名

以 TEST 用户为例，当查询自己模式下得表时，可以直接进行查询，无需加对象名，如下图所示：

select * from test

二、查询其他用户模式下的表，需要加对象名

以 TEST 用户为例，查询 DBTEST 用户模式下的表 TABLE_TEST，如不加对象名，则查询会报错“无效的表名或者视图名[TABLE_TEST]”，如下图所示：

select * from TABLE_TEST;

加上对象名后，没有授予查询权限，则查询会报错“没有对象[DBTEST.TABLE_TEST]的查询权限”，如下图所示：

select * from DBTEST.TABLE_TEST;

这时需要授予 TEST 用户查询表 TABLE_TEST 的权限，如下图所示：

--使用 root 用户授予 TEST 用户查询表 TABLE_TEST 的权限 grant SELECT on "DBTEST"."TABLE_TEST" to "TEST";
--使用 TEST 用户登录数据库查询表 TABLE_TEST select * from DBTEST.TABLE_TEST;

上次更新：2026-09-26 上一篇下一篇

用户与模式的关系

一、查询当前用户模式下的表，无需加对象名 二、查询其他用户模式下的表，需要加对象名

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
