# 创建数据库对象 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-create-objects.html

创建数据库对象 | 达梦技术文档

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

创建数据库对象

一、创建表

在模式 DMHR 下创建表 CITY，并插入数据。示例语句如下所示：

CREATE TABLE dmhr.city ( city_id CHAR(3) NOT NULL, city_name VARCHAR(40) NULL, region_id INT NULL );

1.1 插入数据

在 CITY 表中插入 11 条数据，为后续创建视图与创建触发器做准备。示例语句如下所示：

INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('BJ','北京',1);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('SJZ','石家庄',1);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('SH','上海',2);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('NJ','南京',2);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('GZ','广州',3);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('HK','海口',3);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('WH','武汉',4);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('CS','长沙',4);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('SY','沈阳',5);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('XA','西安',6);
INSERT INTO dmhr.city(city_id,city_name,region_id) VALUES('CD','成都',7);

1.2 查询插入数据

示例语句如下所示：

SELECT * FROM dmhr.city;

输出结果：

二、创建视图

对 CITY 表创建一个视图，命名为 V_CITY，保存 region_id 小于 4 的数据，列名有：city_id，city_name，region_id。示例语句如下所示：

CREATE VIEW dmhr.v_city AS SELECT city_id  , city_name , region_id FROM dmhr.city WHERE region_id < 4;

查询视图结果，示例语句如下所示：

SELECT * FROM dmhr.v_city;

输出结果：

三、创建存储过程

创建一个名为 PROC_1 的存储过程，入参数据类型为 INT，变量 B 赋予初始值 10，输出变量 A 的值为输入的变量 A 值与变量 B 值之和。示例语句如下所示：

CREATE PROCEDURE dmhr.proc_1 (a IN OUT INT) AS b INT:=10;
BEGIN a:=a+b;
PRINT 'DMHR.PROC_1调用结果:'||a;
END;

调用存储过程，输入变量值 3，得到结果值 13。

CALL dmhr.proc_1(3);

输出结果：

四、创建函数

创建一个名为 FUN_1 的存储函数。该函数的返回类型为 INT 类型。两个参数 A、B 的和赋给了变量 S，RETURN 语句则将变量 S 的值作为函数的返回值返回。示例语句如下所示：

CREATE FUNCTION dmhr.fun_1 (a INT, b INT) RETURN INT AS s INT;
BEGIN s:=a+b;
RETURN s;
END;

调用函数，给变量 A、B 分别赋值 4 和 5，得出结果 9。示例语句如下所示：

SELECT dmhr.fun_1(4,5);

输出结果：

五、创建序列

创建序列 SEQ_QUANTITY，起始值为 5，增量值为 2，最大值为 200。示例语句如下所示：

CREATE SEQUENCE dmhr.seq_quantity START WITH 5 INCREMENT BY 2 MAXVALUE 200;

查询序列下一个值，示例语句如下所示：

SELECT dmhr.seq_quantity.nextval FROM dual;

输出结果：

六、创建触发器

创建一个触发器 TRG_UPD，当对表 CITY 进行更新操作时，定义的触发器 TRG_UPD 将被激发。示例语句如下所示：

CREATE TRIGGER dmhr.trg_upd AFTER UPDATE ON dmhr.city FOR EACH ROW BEGIN PRINT 'UPDATE OPERATION ON CITY !!';
END;

对 CITY 表数据进行更新操作，测试触发器结果，示例语句如下所示：

UPDATE dmhr.city SET city.region_id=8 WHERE city.city_id='XA';

输出结果：

七、创建定时作业

7.1 创建代理环境

右键代理模块，点击创建代理环境。

7.2 新建作业

右键作业，点击新建作业。

7.2.3 作业设置

常规

配置作业名，作业描述等。

配置“作业步骤”。

作业步骤为需要定时执行的 sql 语句或者备份数据库操作等，以定时执行 sql 为例。

填写步骤名称为定时执行查询语句，步骤类型为 sql 脚本。

填写脚本语句为需要定时执行的 sql 脚本。

点击确定。

作业调度

作业调度模块可以设置发生频率，每日频率，持续时间等。

新建作业调度，设置为星期日，每隔一小时执行一次。

点击确定为设置成功。

确定后能看到作业下有 TEST 为设置成功。

上次更新：2026-09-26 上一篇下一篇

创建数据库对象

一、创建表
1.1 插入数据
1.2 查询插入数据
二、创建视图 三、创建存储过程 四、创建函数 五、创建序列 六、创建触发器 七、创建定时作业
7.1 创建代理环境
7.2 新建作业
7.2.3 作业设置

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
