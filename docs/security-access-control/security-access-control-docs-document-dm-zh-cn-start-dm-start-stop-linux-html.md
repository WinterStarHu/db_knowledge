# 启动、停止数据库 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-start-stop-linux.html

启动、停止数据库 | 达梦技术文档

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

启动、停止数据库

一、命令行启停数据库

1.1 服务名方式

服务注册成功后，启动数据库。

使用 dmdba 用户进入 DM 安装目录下的 bin 目录下，启动数据库，如下所示：

[dmdba@localhost ~]$ cd /home/dmdba/dmdbms/bin [dmdba@localhost bin]$ ls [dmdba@localhost bin]$ ./DmServiceDMTEST start

停止数据库

[dmdba@localhost bin]$ ./DmServiceDMTEST stop

重启数据库

[dmdba@localhost bin]$ ./DmServiceDMTEST restart

查看数据库状态，如下所示：

[dmdba@localhost bin]$ ./DmServiceDMTEST status

1.2 前台方式

前台方式启动数据库后如果启动界面会话关闭数据库也相应会关闭所以一般情况下建议采用服务的方式启动数据库。

dmdba 用户使用前台的方式启动数据库，进入 DM 安装目录下的 bin 目录下，命令如下：

[dmdba@localhost ~]$ cd /home/dmdba/dmdbms/bin [dmdba@localhost bin]$ ls [dmdba@localhost bin]$ ./dmserver /dmdata/data/DMTEST/dm.ini

该启动方式为前台启动，界面输出“SYSTEM IS READY”后表示前台启动成功，若想关闭数据库，输入 exit 退出即可。

二、图形化启停数据库

启用图形界面前需要通过如下方法将图形界面权限放开：

[root@localhost mnt]# xhost + access control disabled, clients can connect from any host [root@localhost mnt]# echo $DISPLAY [root@localhost mnt]# su - dmdba Last login: 四 1月 25 16:41:51 CST 2024 on pts/1 [dmdba@localhost ~]$ export DISPLAY=:0.0

进入 DM 安装目录下的 tool 目录，使用如下命令打开 DM 服务查看器，如下所示：

[dmdba@localhost ~]$ cd /home/dmdba/dmdbms/tool/ [dmdba@localhost tool]$ ll [dmdba@localhost tool]$ ./dmservice.sh

可以通过【DM 服务查看器】查看到对应的 DM 服务，可选择【启动】或【停止】对应的服务，如下图所示：

上次更新：2026-09-26 上一篇下一篇

启动、停止数据库

一、命令行启停数据库
1.1 服务名方式
1.2 前台方式
二、图形化启停数据库

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
