# JBOSS 添加达梦数据源 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/jboss-development.html

JBOSS 添加达梦数据源 | 达梦技术文档

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

JBOSS 添加达梦数据源

一、前言

JBoss 是一个基于 JavaEE 的开源容器，遵循 LGPL 许可，意味着可以在任何商业应用中免费使用。

二、环境准备

2.1 达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考数据库环境准备。

2.2 JBOSS 下载

进入 JBOSS 官网进行下载。

三、JBOSS 安装配置步骤

下面给出 jboss-eap-8.0.0 版本的配置过程，提供参考。

3.1 解压 JBOSS 包

unzip jboss-eap-8.0.0.zip

3.2 添加达梦 JDBC 驱动包

cd /add/jboss/jboss-eap-8.0/modules/system/layers/base/com/ mkdir -p dm/main cd /add/jboss/jboss-eap-8.0/modules/system/layers/base/com/dm/main cp /opt/dmdbms/drivers/jdbc/DmJdbcDriver18.jar  /add/jboss/jboss-eap-8.0/modules/system/layers/base/com/dm/main/

3.3 添加配置文件

cd /add/jboss/jboss-eap-8.0/modules/system/layers/base/com/dm/main vi module.xml

3.4 创建用户

cd /add/jboss/jboss-eap-8.0/bin ./add-user.sh

3.5 修改监听地址和端口

cd /add/jboss/jboss-eap-8.0/standalone/configuration //修改 ip 地址为本地 ip vi standalone.xml

四、添加达梦数据源

4.1 启动 JBOSS

cd /add/jboss/jboss-eap-8.0/bin/ ./standalone.sh

4.2 使用浏览器登陆

地址为 standalone.xml 配置文件中的 ip 地址，默认端口号为 9990 。

4.3 添加达梦 JDBC 驱动

内容最终如下：

4.4 添加达梦数据源

测试连接，出现下面图片，则连接成功。

内容最终如下：

上次更新：2026-09-26 上一篇下一篇

JBOSS 添加达梦数据源

一、前言 二、环境准备
2.1 达梦数据库安装
2.2 JBOSS 下载
三、JBOSS 安装配置步骤
3.1 解压 JBOSS 包
3.2 添加达梦 JDBC 驱动包
3.3 添加配置文件
3.4 创建用户
3.5 修改监听地址和端口
四、添加达梦数据源
4.1 启动 JBOSS
4.2 使用浏览器登陆
4.3 添加达梦 JDBC 驱动
4.4 添加达梦数据源

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
