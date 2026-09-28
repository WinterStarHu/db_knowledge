# C/C++ | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/C_C++_development.html

C/C++ | 达梦技术文档

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

C/C++

本章主要介绍在 C/C++ 开发的时候，如何快速连接 DM 数据库。

一、获取 ODBC 驱动

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版，在数据库安装路径 drivers 目录下，找到对应驱动程序，请参考 DM 数据库安装。

二、通过 ODBC 连接数据库

2.1 Windows 环境创建 ODBC 数据源

在客户使用 ODBC 方法访问 DM 数据库服务器之前，必须先对自己的应用程序所用的 ODBC 数据源进行配置。本小节将介绍如何安装和配置 ODBC 数据源。

在 Windows 上使用 ODBC 数据源管理程序，配置 ODBC 数据源的步骤如下：

在控制面板上访问 ODBC 构件，显示 ODBC 数据源管理器对话框，如下图所示：

ODBC 数据源管理器对话框包含的标签如下所示：

用户 DSN：添加、删除或配置本机上的数据源，它们只可由当前用户使用。
系统 DSN：添加、删除或配置本机上的数据源，它们可由任何用户使用。
文件 DSN：添加、删除或配置在分离文件中的数据源。这些文件可以被安装了同样数据库驱动器的用户共享。
驱动程序：列出了安装在客户机上的数据库驱动器。
跟踪：用于测试你的数据库应用程序。它跟踪客户机和数据库服务器之间的 ODBC API 的调用。
连接池：允许不同的应用程序自动复用多个连接。这有助于限制和数据库服务器的通信过载。
关于：显示主要 ODBC 组件的版本。

设置和配置一个系统 DSN，请单击系统 DSN 标签，单击添加按钮增加一个新的 DSN，如下图所示：

选择 DM ODBC 3.0 驱动程序即 DM ODBC DRIVER，单击【完成】按钮，显示 DM ODBC 3.0 数据源配置对话框，如下图所示：

输入数据源的名称、描述，并选择你想要连接的数据库服务器的名字使用的端口号、验证登录用户 ID 真伪的方式。如果使用 DMServer 验证方式则需要输入登录数据源的 ID 以及密码等信息，选择系统提示信息的语种，以及选择是否使用 DMServer 的增强选项。

单击测试按钮测试配置的数据源是否正确，如下图所示：

单击确定按钮保存新的系统数据源，如下图所示：

单击确定按钮关闭 ODBC 数据源管理器对话框。

2.2 Linux 环境创建 ODBC 数据源

DMODBC 在 Linux 操作系统依赖于 UnixODBC 库。

此链接为 2.3.12 版本安装包，https://www.unixodbc.org/unixODBC-2.3.12.tar.gz 。

如果需要下载其他版本 ,点击链接进入官网 https://www.unixodbc.org/ ，选择合适版本进行下载。

下载好后，进行解压，使用命令进行配置

./configure --enable -gui=no

配置好后进行编译

make && make install

编译后查找配置文件位置

odbcinst -j

注意

如果出现so文件缺失的情况，大部分可以通过 yum install unixODBC-devel 方式进行解决，如果还有部分缺失，需要自行下载

编辑 /etc/odbcinst.ini ，如下所示：

[DM8 ODBC DRIVER] Description = ODBC DRIVER FOR DM8 Driver = /home/dmdba/dmdbms/bin/libdodbc.so

编辑 /etc/odbc.ini ，如下所示：

[dm8] Description = DM ODBC DSN Driver = DM8 ODBC DRIVER SERVER = localhost UID = SYSDBA PWD = ***** TCP_PORT = 5236

注意 odbc.ini 中的 Driver 内容一定要与 odbcinst.ini 中的 DM 驱动定义的节点名称相同。
odbc.ini 中的 SERVER 可以输入数据库服务器的 IP 。

测试连接，出现以下内容说明连接成功

isql  dm8

上次更新：2026-09-26 上一篇下一篇

C/C++

一、获取 ODBC 驱动 二、通过 ODBC 连接数据库
2.1 Windows 环境创建 ODBC 数据源
2.2 Linux 环境创建 ODBC 数据源

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
