# PHP | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/php-development-new.html

PHP | 达梦技术文档

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

PHP

本章主要介绍在 PHP 开发时，如何使用 PHP 快速连接达梦数据库。

一、达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考 DM 数据库安装。

二、Linux 下安装 PHP

进入 PHP 官网 下载合适版本 PHP ，或者直接使用 php-7.4.33.zip  。

参考如下命令，安装 PHP：

./configure --prefix=/usr/local/php/  --with-config-file-path=/usr/local/php make && make install ln -s /usr/local/php/bin/php /usr/bin/php cp php.ini-production /usr/local/php/php.ini

使用 php -v 命令，查看版本：

[root@localhostphp7]# php -v PHP 7.4.33 (cli) (built: Nov  4 2022 11:47:15) ( ZTS ) Copyright (c) The PHP Group Zend Engine v3.4.0, Copyright (c) Zend Technologies

三、数据库连接

3.1 PHP 配置 DM 驱动

配置 DM 驱动，在 /usr/local/php/php.ini 中增加以下内容：

[PHP_DM] extension_dir ="/opt/dmdbms/drivers/php_pdo" extension=libphp74_dm.so extension=php74_pdo_dm.so [dm] dm.port=5236 ; ; 是否允许持久性连接 dm.allow_persistent = 1 ; ; 允许建立持久性连接的最大数. -1 为没有限制.
dm.max_persistent = -1 ; ; 允许建立连接的最大数(包括持久性连接). -1 为没有限制.
dm.max_links = -1 ; ; 默认的主机地址 dm.default_host = localhost ; ; 默认登录的数据库 dm.default_db = SYSTEM ; ; 默认的连接用户名 dm.default_user = SYSDBA ; ; 默认的连接口令.
dm.default_pw = ***** ; ;连接超时，这个参数未实际的用到，等待服务器支持 dm.connect_timeout = 10 ; ;对于各种变长数据类型，每列最大读取的字节数。如果它设置为 0 或是小于 0,那么，读取变长字段时，将显示 NULL 值 dm.defaultlrl = 4096 ; ; 是否读取二进制类型数据，如果它设置为 0，那么二进制将被 NULL 值代替 dm.defaultbinmode = 1 ; ;是否允许检察持久性连接的有效性，如果设置为 ON，那么当重用一个持久性连接时，会检察该连接是否还有效 dm.check_persistent = ON

配置完成后将动态库文件进行复制：

cp /opt/dmdbms/drivers/php_pdo/*74* /usr/local/php/lib

使用 php -m 命令 PHP 扩展，结果如下：

3.2 测试 PHP 连接 DM 数据库

连接数据库示例代码：php_conn.php

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");

//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
print "php: Connected successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

使用 php php_conn.php 命令运行代码，结果如下：

上次更新：2026-09-26 上一篇下一篇

PHP

一、达梦数据库安装 二、Linux 下安装 PHP 三、数据库连接
3.1 PHP 配置 DM 驱动
3.2 测试 PHP 连接 DM 数据库

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
