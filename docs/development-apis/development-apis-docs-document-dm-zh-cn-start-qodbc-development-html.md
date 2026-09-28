# QODBC | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/QODBC_development.html

QODBC | 达梦技术文档

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

QODBC

本章节主要介绍使用 QT 语言开发时，使用 QODBC 驱动连接达梦数据库。

一、达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考 DM 数据库安装。

二、 QT 下载链接

QT 官网下载链接 。

三、注册 ODBC  数据源

请参考 通过 odbc 连接数据源 章节。

四、QT 使用 QODBC 连接达梦

先通过第三章节步骤增加 ODBC 用户数据源。

测试连接。

#include
#include
#include
#include

int main(int argc, char *argv[]) { QCoreApplication a(argc, argv);
QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
db.setHostName("127.0.0.1");
db.setPort(5236);
db.setDatabaseName("DM8");
db.setUserName("SYSDBA");
db.setPassword("*****");
if (db.open()) qDebug() << "connect ok!";
else { qDebug() << "connect fail! " << db.lastError().text().toLatin1();
}

return a.exec();
}

运行示例截图：

注意

如果 ODBC 数据源是 32 位，构建项目需要使用 32位 构建套件编译，如果 ODBC 数据源是 64 位，构建项目则需要使用 64 位构建套件编译，因当前数据源为 64 位，因此使用 64 位构建套件编译 。使用时需要添加core和sql。

上次更新：2026-09-26 上一篇下一篇

QODBC

一、达梦数据库安装 二、 QT 下载链接 三、注册 ODBC  数据源 四、QT 使用 QODBC 连接达梦

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
