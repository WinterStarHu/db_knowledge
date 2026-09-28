# Python | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/python-development.html

Python | 达梦技术文档

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

Python

本章主要介绍在 Python 开发的时候，如何使用 Python 快速连接达梦数据库。

一、dmPython 简介

dmPython 是 DM 提供的依据 Python DB API version 2.0 中 API 使用规定而开发的数据库访问接口。

使用 Python 连接达梦数据库时需要安装 dmPython。安装完 DM 数据库软件后，在安装路径下的 drivers 目录下，可以找到 dmPython 的驱动源码，由于提供的是源码，需要自己编译安装，下面分别介绍如何在 Windows 和 Linux 环境下编译安装 dmPython。

二、Windows 环境编译安装 dmPython

2.1 安装 DM 数据库软件并设置 DM_HOME 环境变量

dmPython 源码依赖 DM 安装目录中提供的 include 头文件，编译安装前需要检查是否安装 DM 数据库软件，并设置 DM_HOME 环境变量。

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，请参考 DM 数据库安装。

设置 DM_HOME 环境变量

2.2 安装编译工具 Microsoft Visual C++ Build Tools

2.3 编译安装 dmPython

安装完 DM 数据库软件后，在安装路径下的 drivers 目录下，找到 dmPython 的驱动源码。

进入到 dmPython 驱动源码目录

cd D:\dmdbms\drivers\python\dmPython

编译安装 dmPython

python setup.py install

编译安装结束后使用 pip list 命令查看是否安装成功

2.4 查看搜索路径并将 dpi 目录文件拷贝到搜索路径下

dmPython 通过调用 DM DPI 接口完成 Python 模块扩展。在其使用过程中，除 Python 标准库以外，还需要 DPI 的运行环境。

进入 python 解释器查看搜索路径

python
import sys
sys.path

C:\Users\Admin\AppData\Local\Programs\Python\Python39\lib\site-packages\dmpython-2.3-py3.9-win-amd64.egg

2.5 编写测试代码

import dmPython
conn=dmPython.connect(user='SYSDBA',password='*****',server= '192.168.201.118',port=5236) cursor = conn.cursor() cursor.execute('select username from dba_users') values = cursor.fetchall() print(values) cursor.close() conn.close()

输出数据库中的用户名则表示连接数据库成功。

三、Linux 环境编译安装 dmPython

3.1 安装 DM 数据库软件和设置 DM_HOME 环境变量

dmPython 源码依赖 DM 安装目录中提供的 include 头文件，编译安装前需要检查是否安装 DM 数据库软件，并设置 DM_HOME 环境变量。

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，请参考 DM 数据库安装。

设置 DM_HOME 环境变量：

vi /root/.bash_profile export DM_HOME=/home/dmdba/dmdbms source /root/.bash_profile

3.2 安装编译工具 gcc

yum install gcc

3.3 确认当前使用的 Python 版本是自己编译安装的还是系统自带或通过 yum 源方式安装

如果是自己编译安装的 Python 则不需要安装 python3-devel。

如果是系统自带或通过 yum 源方式安装的 Python，需要安装 python3-devel 依赖。

3.4 编译并安装 dmPython

安装完 DM 数据库软件后，在安装路径下的 drivers 目录下，找到 dmPython 的驱动源码。

进入到 dmPython 驱动源码目录

cd /home/dmdba/dmdbms/drivers/python/dmPython

编译安装 dmPython

python3 setup.py install

编译安装结束后使用 pip3 list 命令查看是否安装成功

3.5 设置 LD_LIBRARY_PATH 环境变量

dmPython 通过调用 DM DPI 接口完成 Python 模块扩展。在其使用过程中，除 Python 标准库以外，还需要 DPI 的运行环境。

vi /root/.bash_profile export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/dmdba/dmdbms/drivers/dpi/ source /root/.bash_profile

3.6 编写的测试代码

import dmPython
conn=dmPython.connect(user='SYSDBA',password='*****',server= '192.168.201.118',port=5236) cursor = conn.cursor() cursor.execute('select username from dba_users') values = cursor.fetchall() print(values) cursor.close() conn.close()

输出数据库中的用户名则表示连接数据库成功。

上次更新：2026-09-26 上一篇下一篇

Python

一、dmPython 简介 二、Windows 环境编译安装 dmPython
2.1 安装 DM 数据库软件并设置 DM_HOME 环境变量
2.2 安装编译工具 Microsoft Visual C++ Build Tools
2.3 编译安装 dmPython
2.4 查看搜索路径并将 dpi 目录文件拷贝到搜索路径下
2.5 编写测试代码
三、Linux 环境编译安装 dmPython
3.1 安装 DM 数据库软件和设置 DM_HOME 环境变量
3.2 安装编译工具 gcc
3.3 确认当前使用的 Python 版本是自己编译安装的还是系统自带或通过 yum 源方式安装
3.4 编译并安装 dmPython
3.5 设置 LD_LIBRARY_PATH 环境变量
3.6 编写的测试代码

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
