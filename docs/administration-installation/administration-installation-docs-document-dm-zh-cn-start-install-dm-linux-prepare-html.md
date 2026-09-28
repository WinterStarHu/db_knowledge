# 安装前准备 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/install-dm-linux-prepare.html

安装前准备 | 达梦技术文档

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

安装前准备

一、前言

用户在安装 DM 数据库之前需要检查或修改操作系统的配置，以保证 DM 数据库能够正确安装和运行。

本文演示环境如下：

操作系统 CPU 数据库

CentOS7 x86_64 架构 dm8_20240116_x86_rh7_64

信创环境安装部署也可以参考此篇文章，但需注意 CPU 和操作系统对应的 DM 数据库版本。

二、新建 dmdba 用户

注意

安装前必须创建 dmdba 用户，禁止使用 root 用户安装数据库。

创建用户所在的组，命令如下：

groupadd dinstall -g 2001

创建用户，命令如下：

useradd  -G dinstall -m -d /home/dmdba -s /bin/bash -u 2001 dmdba

修改用户密码，命令如下：

passwd dmdba

三、修改文件打开最大数

在 Linux、Solaris、AIX 和 HP-UNIX 等系统中，操作系统默认会对程序使用资源进行限制。如果不取消对应的限制，则数据库的性能将会受到影响。

永久修改和临时修改。

重启服务器后永久生效。

使用 root 用户打开 /etc/security/limits.conf 文件进行修改，命令如下：

vi /etc/security/limits.conf

在最后需要添加如下配置：

dmdba  soft      nice       0 dmdba  hard      nice       0 dmdba  soft      as         unlimited dmdba  hard      as         unlimited dmdba  soft      fsize      unlimited dmdba  hard      fsize      unlimited dmdba  soft      nproc      65536 dmdba  hard      nproc      65536 dmdba  soft      nofile     65536 dmdba  hard      nofile     65536 dmdba  soft      core       unlimited dmdba  hard      core       unlimited dmdba  soft      data       unlimited dmdba  hard      data       unlimited

注意

修改配置文件后重启服务器生效。

切换到 dmdba 用户，查看是否生效，命令如下：

su - dmdba

ulimit -a

参数配置已生效。

设置参数临时生效

可使用 dmdba 用户执行如下命令，使设置临时生效：

ulimit -n 65536 ulimit -u 65536

建议

使用永久修改方式进行配置。

四、目录规划

1.可根据实际需求规划安装目录，本示例使用默认配置 DM 数据库安装在 /home/dmdba 文件夹下。

2.规划创建实例保存目录、归档保存目录、备份保存目录。

##实例保存目录
mkdir -p /dmdata/data
##归档保存目录
mkdir -p /dmdata/arch
##备份保存目录
mkdir -p /dmdata/dmbak

注意 使用 root 用户建立文件夹，待 dmdba 用户建立完成后需将文件所有者更改为 dmdba 用户，否则无法安装到该目录下

五、修改目录权限

将新建的路径目录权限的用户修改为 dmdba，用户组修改为 dinstall。命令如下：

chown -R dmdba:dinstall /dmdata/data chown -R dmdba:dinstall /dmdata/arch chown -R dmdba:dinstall /dmdata/dmbak

给路径下的文件设置 755 权限。命令如下：

chmod -R 755 /dmdata/data chmod -R 755 /dmdata/arch chmod -R 755 /dmdata/dmbak

上次更新：2026-09-26 上一篇下一篇

安装前准备

一、前言 二、新建 dmdba 用户 三、修改文件打开最大数 四、目录规划 五、修改目录权限

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
