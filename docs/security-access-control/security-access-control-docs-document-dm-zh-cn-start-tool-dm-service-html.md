# DM 服务查看器 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/tool-dm-service.html

DM 服务查看器 | 达梦技术文档

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

DM 服务查看器

一、概述

DM 服务查看器，顾名思义是对数据库服务进行查看管理的工具。通过服务查看器服务可关闭，开启，重启，查看数据库各个服务的状态，方便快捷的对数据库实例服务进行管理。

数据库实例服务运行安装在操作系统上，通常系统运行时数据库服务的状态要保持运行状态。数据库出现异常可以通过服务查看器来查看数据的状态，手动进行服务的重启和关闭等。更换硬件、系统升级等操作，需要提前停止数据库服务，防止出现故障。

二、Windows 环境

2.1 启动 DM 服务查看器

点击【开始界面】，选择【达梦数据库】，点击【DM 服务查看器】，即可启动服务查看器，如下图所示：

选中服务，鼠标右键即可对服务进行启动，停止，修改，注册等操作，如下图所示：

2.2 注册服务

可以通过以下方式图形化注册服务。以 DmWatch 服务为例，进入 DM 服务查看器，如下图所示：

右击上图空白处，选择【注册服务】，进入如下图所示界面：

在上图注册服务界面，输入服务名称后缀，选择服务启动类型为自动或者手动，选择 dmwatcher.ini 所在目录，点击确定按钮。

三、Linux 环境

3.1 启动 DM 服务查看器

Linux 图形化界面使用的时候，同样支持 DM 服务查看器的图形化方式启动，如同 Windows 服务查看器方式进行管理。

启用图形界面前需要通过如下方法将图形界面权限放开：

[root@localhost mnt]# xhost + access control disabled, clients can connect from any host [root@localhost mnt]# echo $DISPLAY [root@localhost mnt]# su - dmdba Last login: 四 1月 25 16:41:51 CST 2024 on pts/1 [dmdba@localhost ~]$ export DISPLAY=:0.0

进入数据库安装目录的 tool 目录，启动数据库服务查看器，如下所示：

[dmdba@localhost ~]$ cd /home/dmdba/dmdbms/tool/ [dmdba@localhost tool]$ ll [dmdba@localhost tool]$ ./dmservice.sh

图形化界面与 Windows 环境一致，如下图所示：

3.2 注册服务

操作与 Windows 环境一致，可参考 2.2 章节。

上次更新：2026-09-26 上一篇下一篇

DM 服务查看器

一、概述 二、Windows 环境
2.1 启动 DM 服务查看器
2.2 注册服务
三、Linux 环境
3.1 启动 DM 服务查看器
3.2 注册服务

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
