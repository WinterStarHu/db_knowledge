# 创建表空间 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/dm-create-tablespace.html

创建表空间 | 达梦技术文档

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

创建表空间

一、新建表空间

使用 SYSDBA 用户登录 DM 管理工具。右键表空间模块，点击【新建表空间】，如下图所示：

二、定义表空间名

如下图创建表空间名为 TEST，指定数据文件为 TEST.DBF：

添加数据文件时需要新建一个数据文件，直接在“文件路径”项中输入对应的数据文件名即可。
注意 添加的数据文件大小最小为 4096*页大小，如页大小为 8K，则可添加的文件最小值为 4096*8k=32M。上图中文件最小为 128 MB，对应页大小为 32 KB。

初始化页大小的选择不仅影响表空间数据文件的大小选择，也会对表中每个字段及每条记录产生限制，如下表所示：

数据库页大小 每个字符类型字段实际最大长度（字节） 每行记录最大字段外其他字段总长度（字节） 表空间单个数据文件最小 (MB)/最大 (MB)

4 KB 1938 2047 16/8388608

8 KB 3878 4095 32/16777216

16 KB 8000 8195 64/33554432

32 KB 8188 16176 128/67108864

页大小在初始化数据库时设置，详见配置实例-数据库初始化参数章节。

使用命令创建表空间 TEST， 指定数据库文件为 '/data/dmdata/DAMENG/TEST.DBF'，初始大小为 128M，其它默认，示例如下：

create tablespace "TEST" datafile '/data/dmdata/DAMENG/TEST.DBF' size 128 ;

更多详细管理表空间语法可参考数据库安装目录下 doc 目录中《DM8_SQL 语言使用手册》。

三、修改表空间参数

可根据项目需要，修改表空间文件、路径、大小、是否自动扩充、扩充上限等信息，如下图所示：

命令行修改表空间，打开自动扩展，每次自动扩展 100M ，扩展上限 10240M，参考示例如下：

alter tablespace "TEST" datafile '/data/dmdata/DAMENG/TEST.DBF' autoextend on next 100 maxsize 10240;

自动扩展默认为打开状态，每次自动扩展大小和扩展上限请根据实际业务需求设置。更多详细管理表空间语法可参考数据库安装目录下 doc 目录中《DM8_SQL 语言使用手册》。

四、设置加密算法、密码

可根据项目需要，设置加密算法、加密密码等信息，该设置均可为空，如下图所示：

上述参数设定完成后，点击【确定】即可创建完成表空间。

以上完整示例：创建表空间 TEST， 指定数据库文件为 '/data/dmdata/DAMENG/TEST.DBF'，初始大小为 128M，打开自动扩展，每次自动扩展 100M ，扩展上限 10240M，使用 RC4 加密算法。使用命令行方式创建示例表空间如下：

create tablespace "TEST" datafile '/data/dmdata/DAMENG/TEST.DBF' size 128 autoextend on next 100 maxsize 10240 CACHE = NORMAL encrypt with RC4;

更多详细管理表空间语法可参考数据库安装目录下 doc 目录中《DM8_SQL 语言使用手册》。

上次更新：2026-09-26 上一篇下一篇

创建表空间

一、新建表空间 二、定义表空间名 三、修改表空间参数 四、设置加密算法、密码

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
