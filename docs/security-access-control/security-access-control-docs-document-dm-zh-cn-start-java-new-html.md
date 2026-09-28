# JAVA | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/JAVA_NEW.html

JAVA | 达梦技术文档

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

JAVA

一、前言

JDBC (Java Database Connectivity) 是 Java 应用程序与数据库的接口规范，旨在让各数据库开发商为 Java 程序员提供标准的数据库应用程序编程接口 (API) 。JDBC 定义了一个跨数据库、跨平台的通用 SQL 数据库 API。

DM JDBC 驱动是一套能够支持基本 SQL 功能的通用应用程序编程接口，支持一般的 SQL 访问 DM 数据库。

二、环境配置

数据库安装请参考 数据库环境准备 。

JAVA 环境配置请参考: JAVA 开发环境准备 。

三、获取驱动方式

使用 java 连接达梦，需要使用达梦 jdbc 驱动，达梦 jdbc 驱动位于达梦数据库安装目录的 \drivers\jdbc 目录下，将其路径添加到项目工程下，或者通过 maven ，gradle 等方式进行导入， Maven Repository 上 DmJdbcDriver 下载地址为:

https://central.sonatype.com/artifact/com.dameng/DmJdbcDriver8

在此可找到合适版本进行下载。

注意

使用 jdbc 驱动时，需要使用和服务器端 DM 数据库相近的版本，相隔时间太久的版本，可能出现部分功能无法适配的情况。达梦的 JDBC 驱动目前有三个版本： DmJdbcDriver16.jar 、 DmJdbcDriver17.jar 和 DmJdbcDriver18.jar ，分别对应 jdk1.6 、 jdk1.7 和 jdk1.8 及以上版本。

四、工程添加驱动

普通项目可通过此方式进行添加驱动，点击文件--> 项目结构--> 库，添加 DmJdbc  驱动。

五、测试连接示例

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class jdbc_conn { // 定义连接 static Connection con = null;
// 定义 DM JDBC 驱动串 static String cname = "dm.jdbc.driver.DmDriver";
// 定义 DM URL 连接串 static String url = "jdbc:dm://localhost:5236";
// 定义连接用户名 static String userid = "SYSDBA";
// 定义连接用户口令 static String pwd = "*****";
public static void main(String[] args) { try { Class.forName(cname);
con = DriverManager.getConnection(url, userid, pwd);
con.setAutoCommit(true);
System.out.println("[SUCCESS]conn database");
} catch (Exception e) { System.out.println("[FAIL]conn database：" + e.getMessage());
} } public void disConn(Connection con) throws SQLException { if (con != null) { con.close();
} } }

运行结果截图：

上次更新：2026-09-26 上一篇下一篇

JAVA

一、前言 二、环境配置 三、获取驱动方式 四、工程添加驱动 五、测试连接示例

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
