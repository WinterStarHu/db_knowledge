# 注册服务 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-service-registered-linux.html

注册服务 | 达梦技术文档

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

注册服务

一、命令行注册服务

DM 提供了将 DM 服务脚本注册成操作系统服务的脚本，同时也提供了卸载操作系统服务的脚本。注册和卸载脚本文件所在目录为安装目录的“/script/root”子目录下。

注册服务脚本为 dm_service_installer.sh，用户可以使用注册服务脚本将服务脚本注册成为操作系统服务。注册服务需使用 root 用户进行注册，使用 root 用户进入数据库安装目录的 /script/root 下，如下所示：

cd /home/dmdba/dmdbms/script/root/

注册实例服务，如下所示：

./dm_service_installer.sh -t dmserver -dm_ini /dmdata/data/DMTEST/dm.ini -p DMTEST

部分参数说明：

标志 参数 说明

-t 服务类型 注册服务类型，支持一下服务类型：dmap、dmamon、dmserver、dmwatcher、dmmonitor、dmasmsvr、dmasmsvrm、dmcss、dmcssm。

-dm_ini INI 文件路径 指定服务所需要的 dm.ini 文件路径。

-p 服务名后缀 指定服务名后缀，生成的操作系统服务名为“服务脚本模板名，称 + 服务名后缀”。此参数只针对 dmserver、dmwatcher、dmmonitor、dmasmsvr、dmasmsvrm、dmcss、dmcssm 服务脚本生效。

更多参数说明和脚本使用方法可参考数据库安装目录下 doc 目录中 《DM8_Linux 服务脚本使用手册》。

进入数据安装目录下 bin 目录中可以看到已经注册好的服务 DmServiceDMTEST。

cd /home/dmdba/dmdbms/bin ls

二、图形化注册服务

如果服务被删除可以通过 dbca 工具即 DM 数据库配置助手来重新注册服务。

启用图形界面前需要通过如下方法将图形界面权限放开：

[root@localhost mnt]# xhost + access control disabled, clients can connect from any host [root@localhost mnt]# echo $DISPLAY [root@localhost mnt]# su - dmdba Last login: 四 1月 25 16:41:51 CST 2024 on pts/1 [dmdba@localhost ~]$ export DISPLAY=:0.0

进入 DM 安装目录下的 tool 目录，使用如下命令打开达梦数据库配置助手，如下所示：

[dmdba@localhost ~]$ cd /home/dmdba/dmdbms/tool/ [dmdba@localhost tool]$ ll [dmdba@localhost tool]$ ./dbca.sh

选择【注册数据库服务】，如下图所示：

单击【开始】，弹出注册数据库服务页面，如下图所示：

点击【完成】后，弹出执行配置脚本页面，按页面要求执行脚本即可，如下图所示：

执行脚本成功后，该实例已启动，如下图所示：

上次更新：2026-09-26 上一篇下一篇

注册服务

一、命令行注册服务 二、图形化注册服务

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
