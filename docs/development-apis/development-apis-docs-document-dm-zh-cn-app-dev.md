# 应用开发指南 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/

应用开发指南 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

应用开发指南

数据库访问是数据库应用系统中非常重要的组成部分。DM 作为一个通用数据库管理系统，提供了多种数据库访问接口，包括 ODBC 、JDBC 、DPI 等方式。本开发指南详细介绍了 DM 的各种访问接口，相应开发环境的配置，以及一些开发用例。本指南的主要读者是从事过数据库应用系统开发，并具有 SQL 使用基础的程序员。开发一个应用系统，需要对其使用的数据库管理系统所具有的功能、性能、特性有较深入的了解。DM 作为一个通用的数据库管理系统，具有非常丰富的功能和特色。

本指南主要面向以下编程语言

JAVA 语言

C/C++ 语言

.NET 语言

PHP 语言

Python 语言

GO 语言

注意

各驱动的版本需与数据库服务器版本保持一致。

数据库环境准备

Window 下环境准备

名称 版本

DM 数据库 DM 8.0 及以上版本

Window 下安装和配置

Window 下使用数据库请参考如下链接：

安装前准备工作请参考：

安装前准备 | 达梦技术文档 (dameng.com)

数据库安装请参考：

数据库安装 | 达梦技术文档 (dameng.com)

配置实例请参考：

配置实例 | 达梦技术文档 (dameng.com)

数据库启动与停止请参考：

启动、停止数据库 | 达梦技术文档 (dameng.com)

数据库安装过程中，请取消勾选“字符串比较大小写敏感”，如下图所示：

数据库安装过程中，请勾选创建 BOOKSHOP 、 DMHR 示例库，作为数据库模拟环境，如下图所示：

测试代码主要依赖 PRODUCTION 模式进行开发。

创建大字段表

执行如下 SQL 语句创建大字段表：

CREATE TABLE "PRODUCTION"."BIG_DATA" ( "ID" INT IDENTITY(1, 1) NOT NULL, "PHOTO" IMAGE, "DESCRIBE" BLOB, "TXT" CLOB, NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "BOOKSHOP", CLUSTERBTR) ;

Linux 下环境准备

名称 版本

DM 数据库 DM 8.0 及以上版本

Linux 下安装和配置

Linux 下使用数据库请参考如下链接：

安装前准备工作请参考：

安装前准备 | 达梦技术文档 (dameng.com)

数据库安装请参考：

数据库安装 | 达梦技术文档 (dameng.com)

配置实例请参考：

配置实例 | 达梦技术文档 (dameng.com)

数据库启动与停止请参考：

启动、停止数据库 | 达梦技术文档 (dameng.com)

将  SAMPLES.sql 文件放到 opt 目录，并登陆数据库，执行以下 sql 文件，创建示例库 BOOKSHOP 和 DMHR 。

./disql SYSDBA/*****@localhost:5236 start /opt/SAMPLES.sql

创建大字段表

运行如下 sql 命令，登陆数据库并创建大字段表 BIG_DATA ：

./disql SYSDBA/*****@localhost:5236

CREATE TABLE "PRODUCTION"."BIG_DATA" ( "ID" INT IDENTITY(1, 1) NOT NULL, "PHOTO" IMAGE, "DESCRIBE" BLOB, "TXT" CLOB, NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "BOOKSHOP", CLUSTERBTR) ;

上次更新：2026-09-26 下一篇

应用开发指南

本指南主要面向以下编程语言 数据库环境准备 Window 下环境准备 Window 下安装和配置 创建大字段表 Linux 下环境准备 Linux 下安装和配置 创建大字段表

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

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

简体中文

简体中文
