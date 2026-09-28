# 数据库目录结构介绍 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-directory.html

数据库目录结构介绍 | 达梦技术文档

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

数据库目录结构介绍

一、数据库安装目录

下图展示为 DM8 数据库目录。

/home/dmdba/dmdbms/bin 目录存放 DM 数据库的可执行文件，例如 disql 命令、dminit 命令、dmrman 工具等。

/home/dmdba/dmdbms/desktop/icons  存放 DM 数据库各个工具的桌面图标。

/home/dmdba/dmdbms/doc 存放 DM 数据库用户手册。

/home/dmdba/dmdbms/drivers 存放连接 DM 数据库的驱动文件。

/home/dmdba/dmdbms/log 存放 DM 数据库日志，包括工具的日志、数据库日志、服务日志等。

/home/dmdba/dmdbms/samples 存放 DM 数据库各类配置文件的示例文件。

/home/dmdba/dmdbms/script/root 存放注册、注销 DM 数据库服务的工具，例如 dm_service_installer.sh 等。

/home/dmdba/dmdbms/tool 存放 DM 数据库的各个工具，例如 manager 管理工具、dbca 数据库配置助手等。

/home/dmdba/dmdbms/uninstall 目录存放卸载 DM 数据库的脚本。

/home/dmdba/dmdbms/web 目录存放 DM 数据库 dem 工具的 web 环境。

二、数据库实例目录

/dmdata/data 为数据库实例目录，该目录存放各个实例的文件。

以实例 DAMENG 为例，该目录下存放 DAMENG 实例的配置文件 *.ini、控制文件 dm.ctl、数据文件 *.DBF、日志文件 *.log 等。

上次更新：2026-09-26 上一篇下一篇

数据库目录结构介绍

一、数据库安装目录 二、数据库实例目录

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
