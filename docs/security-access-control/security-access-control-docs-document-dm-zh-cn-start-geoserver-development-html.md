# GeoServer | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/GeoServer-development.html

GeoServer | 达梦技术文档

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

GeoServer

一、前言

GeoServer 是 OpenGIS Web 服务器规范的 J2ee 实现，利用 GeoServer 可以方便的发布地图数据，允许用户对特征数据进行更新、删除、插入操作，通过 GeoServer 可以比较容易的在用户之间迅速共享空间地理信息。

二、版本对应

GeoServer Geotools gt-dmgeo2 gt-dameng JDK

2.8
14 14(gt-dmgeo2-2.8.jar) gt-dameng-2.8.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.7 及以上环境

2.9
15 17(gt-dmgeo2-2.11.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.10
16 17(gt-dmgeo2-2.11.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.11
17 17(gt-dmgeo2-2.11.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.12
18 17(gt-dmgeo2-2.11.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.13
19 19(gt-dmgeo2-2.13.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.14
20 20(gt-dmgeo2-2.14.jar) gt-dameng-2.11.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.15
21 21(gt-dmgeo2-2.15.jar) gt-dameng-2.15.jar 如果只使用 gt-dameng 需要 Jdk1.6 及以上环境，如果使用 gt-dmgeo2 需要 Jdk1.8 及以上环境

2.16
22 22(gt-dmgeo2-2.16.jar) gt-dameng-2.16.jar Jdk1.8 及以上环境

2.17
23 22(gt-dmgeo2-2.16.jar) gt-dameng-2.17.jar Jdk1.8 及以上环境

2.18
24 22(gt-dmgeo2-2.16.jar) gt-dameng-2.18.jar Jdk1.8 及以上环境

2.19
25 26(gt-dmgeo2-2.20.jar) gt-dameng-2.19.jar Jdk1.8 及以上环境

2.20
26 26(gt-dmgeo2-2.20.jar) gt-dameng-2.20.jar Jdk1.8 及以上环境

2.21
27 26(gt-dmgeo2-2.20.jar) gt-dameng-2.21.jar Jdk1.8 及以上环境

2.22
28 26(gt-dmgeo2-2.20.jar) gt-dameng-2.21.jar Jdk1.8 及以上环境

2.23
29 26(gt-dmgeo2-2.20.jar) gt-dameng-2.21.jar Jdk1.8 及以上环境

注意

达梦支持的是 geo 和 geo2,请自行查找支持 geo 和 geo2 功能的数据库版本，本文测试使用的达梦数据库版本为 --03134284132-20231226-213242-20081 。

三、准备工作

3.1 达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考 DM 数据库安装。

3.2 JDK 和 GeoServer 下载

JDK 下载地址为 https://www.oracle.com/java/technologies/downloads/ 。

GeoServer 官网地址为 https://geoserver.org/ 。

本次使用 JDK 版本为 java version "18.0.2"，GeoServer 版本为 geoserver-2.15.5，对应达梦 GeoServer 2.15 环境方言包版本为 gt-dameng-2.15.jar、gt-dmgeo2-2.15.jar，达梦 JDBC 驱动版本为 DmJDBCDriver18.jar 。

四、配置环境

添加 JAVA_HOME 到系统变量后，使用 cmd 查询当前 java 环境：

java  -version

方言包位于达梦数据库安装路径下的 drivers\jdbc\dialect 文件夹，本文测试对应方言包位于 C:\dmdbms\drivers\jdbc\dialect 。

解压 geoserver  包，并把所需驱动复制到 GeoServer 安装目录下的 webapps\geoserver\WEB-INF\lib 中，本次测试放入路径为 C:\Users\Administrator\Desktop\geo\geoserver\geoserver-2.15.5\webapps\geoserver\WEB-INF\lib 。

五、创建测试表

5.1 创建数据库实例

创建两个数据库实例，端口号分别为 5236 和 5237，分别对 dmgeo 和 dmgeo2 进行测试。

5.2 创建测试表并插入数据

5.2.1 实例一

5236 实例执行以下 sql：

SP_INIT_GEO_SYS(1);

//点 CREATE TABLE GEOTABLE1(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE1 VALUES(DMGEO.ST_POINTFROMTEXT('POINT (1111 1)' , 0),'WW');
//线 CREATE TABLE GEOTABLE2(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE2 VALUES(DMGEO.ST_GEOMFROMTEXT('MULTILINESTRING ((0 5,4 1),(4 4,0 0))', 0),2);
//多边形 CREATE TABLE GEOTABLE3(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE3 VALUES (DMGEO.ST_MPOLYFROMTEXT ('MULTIPOLYGON(((10 10, 10 20, 20 20, 20 15, 10 10)), ((50 40, 50 50, 60 50, 60 40, 50 40)))' , 4269),'DAD');
//多点 CREATE TABLE GEOTABLE4(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE4 VALUES (DMGEO.ST_MPOINTFROMTEXT('MULTIPOINT (1 1, 2 2)', 12 ) ,'QE');
//多线 CREATE TABLE GEOTABLE5(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE5 VALUES(DMGEO.ST_MLINEFROMTEXT('MULTILINESTRING ((1 1,2 1),(4 4, 3 3))', 22),'DD');
//多边形 CREATE TABLE GEOTABLE6(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE6 VALUES(DMGEO.ST_MPOLYFROMTEXT('MULTIPOLYGON (((1 1, 1 2, 2 2, 2 1, 1 1)), ((3 3, 3 4, 4 4, 4 3, 3 3)))' , 23),'BIAN');
//圆 CREATE TABLE GEOTABLE7(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE7 VALUES(DMGEO.ST_CREATECIRCLE(DMGEO.ST_GEOMFROMTEXT('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))', 4296), 6),'YUAN');
//弧线 CREATE TABLE GEOTABLE8(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE8 VALUES(DMGEO.ST_CREATEARC(DMGEO.ST_GEOMFROMTEXT('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))', 4296), 6, 0, 1.772),'YUAN');
//扇形 CREATE TABLE GEOTABLE9(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE9 VALUES(DMGEO.ST_CREATEARCPOLYGON(DMGEO.ST_GEOMFROMTEXT( 'POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))', 4296), 6, 0, 1.772),'SAN');
//圆环 CREATE TABLE GEOTABLE10(GEOM SYSGEO.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEOTABLE10 VALUES(DMGEO.ST_CREATEANNULUS(DMGEO.ST_GEOMFROMTEXT('POLYGON((0 0,0 10,10 10,10 0,0 0))', 4296),DMGEO.ST_GEOMFROMTEXT('POLYGON((3 3,3 7,7 7,7 3,3 3))', 4296),6),'DAD');

5.2.2 实例二

5237 实例执行以下 sql:

SP_INIT_GEO2_SYS(1);

//几何数据类型，带有 M 坐标的点的 EWKT 格式 CREATE TABLE GEO2TABLE(GEOM SYSGEO2.ST_GEOMETRY, NAME VARCHAR);
INSERT INTO GEO2TABLE(GEOM, NAME) VALUES(DMGEO2.ST_GEOMFROMEWKT('SRID=312;POINTM (-126.4 45.32 15)'),'A PLACE');
INSERT INTO GEO2TABLE(GEOM, NAME) VALUES(DMGEO2.ST_GEOMFROMWKB(DMGEO2.ST_ASEWKB(DMGEO2.ST_GEOMFROMTEXT('POINT(2 5)'))), 'A PLACE');

//WKB形式的几何对象 CREATE TABLE GEO2GEOM(ID INT, NAME VARCHAR(20), GEOM SYSGEO2.ST_GEOMETRY);
INSERT INTO GEO2GEOM VALUES(1, 'TEST', DMGEO2.ST_GEOMFROMTEXT('SRID=4326;POINT(-77.009 2 38.889588)'));

//地理数据类型 CREATE TABLE GEO2POINTS(ID INT, NAME VARCHAR, GEOG SYSGEO2.ST_GEOGRAPHY);
INSERT INTO GEO2POINTS VALUES (1, 'TOWN', DMGEO2.ST_GEOGFROMTEXT('SRID=4326;POINT(-110 30)'));
INSERT INTO GEO2POINTS VALUES(2, 'FOREST', DMGEO2.ST_GEOGFROMTEXT('SRID=4326;POINT(-109 29)'));
INSERT INTO GEO2POINTS VALUES (3, 'LONDON', DMGEO2.ST_GEOGFROMTEXT('SRID=4326;POINT(0 49)'));

六、使用 GeoServer

第一步：进入 geoserver 安装目录下的 bin 目录，本次测试对应的目录是 C:\Users\Administrator\Desktop\geo\geoserver\geoserver-2.15.5\bin 。

第二步：双击 startup.bat 启动

第三步：访问 web 界面，注意配置的 web 端口号，默认 8080，例如： http://localhost:8080/geoserver ，登录用户名默认为 admin，密码默认为 geoserver，出现以下图片说明登陆成功。

第四步：添加工作区，编写命名和命名空间，命名和 URl 没有具体要求，尽量规范，后续需要使用此工作区。

第五步：添加数据存储，本次测试对 geo 和 geo2 包的使用，Dameng 对应 geo 包数据源， Dameng(geo2) 对应 geo2 包数据源。

以下图片为建 geo 数据源截图，框起来的为必须填写的项，工作区选择第三步创建的工作区。

以下图片为建 geo2 数据源截图，框起来的为必须填写的项，工作区选择第三步创建的工作区 。

创建完成后本处会多出 2 个数据存储。

第六步：添加图层，分别添加 geo 和 geo2 对应表的图层并发布，重复此步骤，把所有测试表进行加入图层。

以下为添加 geo 包图层的方法，新建图层时会显示达梦数据库里面表，找到对应表 "sub_types" 并添加，添加后点击发布，在发布页面点击从数据中计算和 "Compute from native bounds" 后保存。

a) 新建图层

b) 编辑图层，点击以下按钮后保存

c) 添加后如图所示

第七步：图层预览，搜索需要预览的图层名称，点击 OpenLayers 进行预览。

GEOTABLE1 表显示如下：

GEOTABLE2 表显示如下：

GEOTABLE3 表显示如下：

GEOTABLE4 表显示如下：

GEOTABLE5 表显示如下：

GEOTABLE6 表显示如下：

GEOTABLE7 表显示如下：

GEOTABLE8 表显示如下：

GEOTABLE9 表显示如下：

GEOTABLE10 表显示如下：

GEO2TABLE 表显示如下:

GEO2GEOM 表显示如下:

GEO2POINTS 表显示如下:

上次更新：2026-09-26 上一篇下一篇

GeoServer

一、前言 二、版本对应 三、准备工作
3.1 达梦数据库安装
3.2 JDK 和 GeoServer 下载
四、配置环境 五、创建测试表
5.1 创建数据库实例
5.2 创建测试表并插入数据
5.2.1 实例一
5.2.2 实例二
六、使用 GeoServer

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
