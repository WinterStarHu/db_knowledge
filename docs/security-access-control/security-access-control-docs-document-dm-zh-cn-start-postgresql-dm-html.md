# 从 PostgreSQL 移植到 DM | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/start/PostgreSQL_dm.html

从 PostgreSQL 移植到 DM | 达梦技术文档

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

从 PostgreSQL 移植到 DM

一、概述

随着数字化转型的推进，越来越多的企业和机构开始关注数据库的自主可控性，国产数据库凭借其技术特性逐渐受到青睐。PostgreSQL 作为一款经典的开源数据库，在数据管理和分析领域具有广泛应用。达梦数据库（DM）作为国产数据库的代表，在数据安全、生态完整、性能优化等方面展现了突出能力。

本文旨在介绍从 PostgreSQL 移植到 DM 的整体流程、注意事项以及常见问题的解决方案。在迁移过程中，将详细介绍迁移流程、迁移评估、移植工具选择、制定移植计划、移植实施、移植结果校验等关键步骤，以确保迁移过程的顺利进行。同时，针对迁移过程中可能遇到的常见问题，将提供相应的解决方案，以帮助用户更好地完成数据库迁移工作。

二、迁移流程

2.1 迁移流程图

2.2 流程介绍

2.2.1 需求确认

移植会涉及诸多场景，如容灾备份、应用改造/替代、数据库版本升级/回退、数据库替代、业务分流等，不同的场景在数据流向、停机窗口、同步需求、数据处理等方面会有不同的需求，需要针对性地选择迁移方案。

2.2.2 数据库调研

考虑迁移或同步工具版本、驱动版本、基础环境、操作方式、对象个数、对象大小、数据量等均会影响迁移工作的开展，需要对源端和目的端数据库及服务器、业务系统进行调研，确保在满足相关需求的前提下稳定完成迁移。

源端数据库信息调研。

目的端数据库信息调研

确认迁移需求后，源端数据库需提前调研如下信息：

（1）环境信息。提前了解操作系统层面，对工具能否使用可视化界面，或者端口号开放情况，可以方便在后期部署安装过程中，及时避开处理问题时的一些干扰项。主要包括对服务器、内存、CPU、网络、端口、安全策略、是否具备可视化界面等信息的调研。

（2）业务系统信息。提前了解应用系统层面信息，结合应用系统特性，为后面制定迁移策略、迁移时间评估等提供参考。主要包括对业务类型、业务运行时段、停机窗口、数据量、数据增量、并发访问量等信息的调研。

（3）数据库信息。提前了解迁移数据量、字符编码、归档保留、数据库对象、表空间等信息，为后续迁移做好规划和相关准备工作。

2.2.3 迁移评估

达梦数据提供了两种工具进行迁移前源端数据库兼容性评估：

数据迁移工具 DTS：提供了异构数据源之间的评估，迁移和对比功能。DM 数据迁移工具采用向导方式引导用户通过简单的图形化进行兼容性评估操作。

达梦企业管理器 DEM：支持对 ORACLE、PostgreSQL、SQL Server 等主流数据库迁移到达梦数据库进行在线采集评估和自动转化，并提供兼容性报告。

SQLark 百灵连接：支持对 ORACLE、MySQL、PostgreSQL 等主流数据库迁移到达梦数据库进行在线采集评估和自动转化，一键生成源数据库画像，获取源库对象、不兼容对象、大表、大字段表等迁移重难点情况，评估本次迁移需要投入的工作量。SQLark 会根据源库画像，生成合理的迁移策略，为开发者后续进行的自动/手动迁移提供迁移方案参考。

除此之外，需要人工对大表、大字段表这些是否单独迁移进行评估及如何配置大表、大字段表的迁移策略。

2.2.4 移植工具选择

达梦公司提供了四种移植工具：数据迁移工具 DTS、SQLark 百灵连接、数据复制软件 DMDRS 和数据集成软件 DMDIS，可满足不同移植场景的使用需求，详细内容参考移植工具介绍。

2.2.5 制定移植计划

根据需求分析和数据库调研，结合每个应用系统的具体要求，选择合适的迁移工具，基于数据迁移的基本原则和迁移工具评估结果，制定合理的移植计划避免任何可能遗漏的步骤，保障迁移工作的稳定实施。

2.2.6 移植实施

对于异构数据库移植到达梦，在正式迁移前，需要根据源端数据库的相关调研信息，对目的库的实例参数、表空间、用户等进行配置，提高达梦对于 PostgreSQL 数据库的兼容性，保障后续移植工作稳定进行。

同时，达梦数据的迁移工具均具有自动转换功能。大多数情况下，可通过相关迁移工具进行对象和数据移植，但由于异构数据库间语法并非 100% 兼容，少量数据则需要进行手动移植。

2.2.7 移植结果校验

在进行正式环境的数据移植时，每一条数据都是真实的，有效的且完整的，在迁移完成后，必须源端数据库的所有对象都准确无误地迁移到目的端，一旦出现缺少对象、缺少数据和数据内容不正确的情况，可能会导致某些功能模块失效等严重后果。因此在迁移完成后，须确认是否出现迁移后的数据量、数据内容和对象个数不一致的情况，如果不一致应进行对应的维护。

2.2.8 移植后收尾工作

移植后的收尾工作包括：索引补录、更新统计信息、备份、整理对象脚本等内容，保障移植工作的完整性。

2.2.9 应用移植与优化

一般情况下，源端数据库迁移完成后，直接更换应用连接源端数据源到达梦数据库，应用代码适配不用修改。为了验证系统移植的完整性，还需要进行应用的相关功能和性能测试，确保改造后的应用系统和数据库处于一个最佳状态。应用的功能测试和性能测试不在这里详述。

此外，在对应用系统进行全面测试后，排除移植过程中错误的地方，还应对数据库中的慢 SQL 进行优化，保证移植后的系统高效运行。

三、移植过程

3.1 需求确认及调研

3.1.1 需求确认

本例构建了一个 PostgreSQL15.2 的单机示例库，并介绍利用 DTS 工具从 PostgreSQL15.2 移植 postgres 库中的所有对象到 DM8 数据库的详细步骤，以供参考。

示例 PG 端的 SQL 脚本如下:pg_test_schema_case.sql

该示例涵盖了 PG 中 int、varchar、text、numeric、float、bool、date、time、 json、uuid 等十多种数据类型；包括普通表、分区表、视图、物化视图、函数、触发器、序列等 7 类的对象。

3.1.2 数据库调研

PostgreSQL 源端信息

环境信息

调研项 说明

应用后台操作系统 CentOS 7 x86_64

数据库后台操作系统 CentOS 7 x86_64

后台数据库 PostgreSQL15.2

应用开发平台 JAVA

应用开发接口 JDBC

需要移植的数据库对象 表（数据量）、视图、序列、触发器、函数。

数据库信息

提前对源端 PostgreSQL 数据库做相关了解，一方面为后面的安装提供参考依据，另一方面提前了解迁移数据量、字符编码、归档保留等信息为后续迁移提前做好充分准备。如下对源端 PostgreSQL 的调研：

调研项 说明

数据库架构 单机

节点数 1

数据库版本 PostgreSQL15.2

待迁移库 postgres

IP 地址/端口
10.35.56.65/5432

服务器运维用户名(密码) root/xxxxx

数据库用户名(密码) Postgres/xxxxx

字符集编码 UTF8

大小写敏感 敏感

是否以字节为单位 //

归档保留策略 //

迁移对象统计

迁移前可先统计出需要迁移的库中的对象，提前了解迁移数据量、迁移数据对象、迁移数据类型，为考虑迁移时长、停机窗口提供依据，PostgreSQL 中统计库中的对象方法如下：

（1）统计指定模式中表的总数和总大小。

SELECT COUNT(*) AS table_count, pg_size_pretty(SUM(pg_total_relation_size(c.oid))) AS total_size FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'r'  -- 仅统计普通表（排除视图、索引等） AND n.nspname = 'test_schema;  -- 限定为 'test_schema模式

（2）创建辅助表记录所有表数据行数。

CREATE TABLE IF NOT EXISTS "test_schema".table_row_counts ( schema_name   VARCHAR(256), table_name    VARCHAR(256), row_count     BIGINT NOT NULL );
INSERT INTO table_row_counts (schema_name, table_name, row_count) SELECT schemaname AS schema_name, relname AS table_name, n_live_tup AS live_row_count FROM pg_stat_user_tables WHERE schemaname =  'test_schema' ;

（3）统计指定模式下视图、存储过程、函数、序列和用户自定义触发器数量。

SELECT '视图' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'v' -- 视图类型标识 AND n.nspname = 'test_schema' UNION ALL SELECT '物化视图' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'm' -- 物化视图类型标识 AND n.nspname = 'test_schema' UNION ALL SELECT '存储过程' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace WHERE p.prokind = 'p' -- 存储过程 AND n.nspname = 'test_schema' UNION ALL SELECT '函数' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace WHERE p.prokind = 'f' -- 函数 AND n.nspname = 'test_schema' UNION ALL SELECT '序列' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'S' -- 序列 AND n.nspname = 'test_schema' UNION ALL SELECT '触发器' AS object_type, COUNT(*) AS object_count FROM pg_catalog.pg_trigger t JOIN pg_catalog.pg_class c ON c.oid = t.tgrelid JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'test_schema' -- 触发器关联到表，通过表所属模式过滤 AND c.relkind = 'r' -- 仅统计表上的触发器（排除视图触发器） AND t.tgisinternal = 'f' -- 排除系统内部触发器 AND t.tgenabled = 'O';-- 仅统计启用状态的触发器

通过以上 SQL 统计出待迁移对象的数据，并记录，以便迁移完成后进行数据对比。

类型 数量

表 12（其中包含了一张创建的辅助表，分区表每个分区）

物化视图 1

视图 1

函数 2

存储过程 0

序列 9

触发器 1

DM 目的端信息

清楚目的端系统环境信息以便于选择对应版本的 DM 数据库进行安装。

调研项 调研命令

服务器品牌/型号 dmidecode

服务器操作系统 cat /etc/os-release

内存容量 cat /proc/meminfo

CPU 型号/核数 cat /proc/cpuinfo

端口策略 是否与目的端网络、端口互通

安全策略 是否有软件、硬件相关安全限制（比如堡垒机、网闸、文件摆渡）

是否具备可视化界面 可视化提供的方式（直连、Xmanager、VNC、BMC 等）

其他
##

3.2 迁移评估

本例中，介绍使用 DEM 工具进行迁移评估工作，对源端数据库进行迁移评估，包括数据对象和 SQL，最终形成迁移评估报告。可通过迁移评估报告提前了解哪些数据对象或 sql 需要单独处理，方便后续迁移的顺利进行，详细步骤如下（ DTS 工具迁移评估详细步骤可参考《从 Oracle 移植到 DM 》-DTS 迁移评估）。

DEM 版本 V7.6.1

DEM 安装 参考达梦企业管理器 DEM

创建评估。登录 DEM 后，第 ① 步点击左侧数据迁移图标，第 ② 步点击上面的评估，第 ③ 步点击右侧“+”号弹出“新建评估”卡片，按要求填写相关信息。

新建评估完成后选择评估方式为“PostgreSQL==>DM”。

连接 PostgreSQL 源端与 DM 目的端。在连接 PostgreSQL 源端时点击数据库名右侧的刷新后可以下拉选择对应的 PostgreSQL 库。勾选“指定目的库”可以指定目的端的 DM 库进行评估。使用指定的目的库需要用户提前安装好目的端的数据库。

连接 DM 目的端数据库。

勾选评估内容。勾选相应的评估内容，后面将对这些内容进行迁移评估。

指定要评估的数据库模式，勾选 PostgreSQL 中需要迁移的库进行评估。

选择 PostgreSQL 库中具体需要评估的对象。

执行方式选择直接点击下一步。

确认评估任务后开始评估。

评估完成后可点击右下方的“查看报告”，查看详细的评估报告。

（1）评估报告通过表格和图形方式生成总体的评估报告。

（2）“对象评估详细”模块呈现了所有对象的详细兼容性的评估结果。

（3）“SQL 评估详细”模块呈现了 SQL 的详细兼容性的评估结果。

（4）若存在不兼容的对象，可通过点击右侧查看详情按钮查看详细信息。例如：此条触发器是由于 PostgreSQL 与 DM8 语法差异导致不兼容，经 DEM 工具自动转换后，转换后的 SQL 仍然语法不兼容。此时，可点击不兼容对象右侧的修改建议，并根据系统给出的建议进行相应语法修改。

例如：

（5）在“表信息统计详细”模块对表的详细信息以表格的形式进行了统计，包括：表类型统计、表行数统计、表大小统计、表字段统计、约束统计、约束分布、索引统计、索引分布。

通过迁移评估可以将 DM 数据库不兼容的部分先整理出来，使用 DM 语法进行手动修改，在正式迁移时不兼容的部分对象就不使用工具进行迁移，待其他对象迁移完成后再将修改好的对象导入到 DM 数据库中。

3.3 制定移植计划

根据待移植的 PostgreSQL 系统信息分析的情况，制定迁移计划：先对整库进行一次性迁移，再对不兼容的对象进行补迁。

3.4 迁移准备

本文将介绍利用 DTS 工具进行通用情况下的数据移植工作，其他特殊配置可根据实际需求进行调整。

3.4.1 源端 PostgreSQL 数据库准备

DTS 工具为静态数据迁移工具，在正式开始移植前需要停止所有对 PostgreSQL 数据库的变更操作，保证数据一致性。

3.4.2 目的端达梦数据库准备

数据库版本选择

DM 数据库会定期进行产品更新迭代。在进行项目移植前，需要先确定使用的 DM 数据库版本：

（1）建议使用当前最新版本的数据库，以保证更高的兼容性。

（2）版本优先选择完整安装版本。

（3）版本与硬件环境一定要严格匹配，以减少干扰性的问题出现。

数据库架构选择

达梦数据库为用户提供多样的数据库架构适配用户不同的业务需求，用户可以根据业务系统需求选择达梦合适的数据库架构进行部署。DM 数据库架构可参考：

达梦数据库管理系统 DM8

数据共享集群 DMDSC

数据守护集群 DMDataWatch

新一代分布式集群 DMDPC

详细安装部署步骤可参考：达梦在线服务平台-运维指南-数据库规范化部署相关内容，本例中选择目的端数据库架构为单机。

初始化设置

在安装好达梦数据库后还需要初始实例用于对数据的管理，在初始实例时初始化参数尤为重要。

数据库参数 参数值

DB_NAME（数据库名） DAMENG（根据需求设置）

INSTANCE_NAME（实例名） DMSERVER（根据需求设置）

PORT_NUM（端口） 5237（正式移植环境下，为保证数据库安全，不建议使用默认端口 5236）

管理员、审计员、安全员密码（安全版本特有） 建议首次初始化实例时立即修改密码

EXTENT_SIZE（簇大小） 16

PAGE_SIZE（页大小） 32

LOG_SIZE 日志大小 2048M

CHARSET（字符集） UTF-8（一般是 UTF8，根据实际）

CASE_SENSITIVE（大小写敏感） 敏感（根据实际情况设置）

BLANK_PAD_MODE（尾部空格填充） 否

SYSDBA_PWD（SYSDBA 用户密码） xxxxxxxx

SYSAUDITOR_PWD（SYSAUDITOR 用户密码） xxxxxxxx

注意

注意：其中页大小（page_size）、簇大小（extent_size）、大小写敏感（case_sensitive）、字符集（charset）、结尾空格填充（BLANK_PAD_MODE）一旦确定无法修改，需谨慎设置。

初始化参数的详细说明可参考达梦数据库安装目录下 doc 目录中的《DM8_dminit 使用手册》或在数据库运行目录 bin 目录下执行以下命令查看部分初始化参数说明。

./dminit help

注意

用户在安装数据库初始化实例时，必须设置数据库系统用户的初始密码，并保证一定的密码强度，以保障数据安全性。

4.创建迁移用户和表空间

从 PostgreSQL 移植到 DM，要先创建好待使用的用户和这个用户的表空间，不要把数据迁移到系统默认的管理员 SYSDBA 用户下和 MAIN 表空间下。

从 PostgreSQL 迁移到达梦的时需要针对 PostgreSQL 中的每一个模式在达梦里面创建一个用户来对应。例如 PostgreSQL 中需要迁移的模式为 test_schema，达梦里面先创建一个表空间 pgpublic，然后创建一个用户 postgres ，指定默认表空间为 pgpublic。示例如下：

创建 PGPUBLIC 表空间存储 PostgreSQL 中 test_schema 库迁移过来的数据。

create tablespace "pgpublic" datafile '/data/dmdata/DAMENG/PGPUBLIC.DBF' size 2048 autoextend on CACHE = NORMAL;--创建表空间pgpublic，数据文件为PGPUBLIC.DBF。

创建 postgres 用户并授予权限，使用 pgpublic 表空间。

create user "postgres" identified by "密码" --创建用户 default tablespace "pgpublic"--指定用户postgres表空间为pgpublic default index tablespace "pgpublic";--指定用户postgres索引表空间为pgpublic grant "PUBLIC","RESOURCE","SOI","SVI","VTI" to "postgres";--授予用户postgres常规权限。

在做 PostgreSQL 迁移的时候要先分析本次迁移需要从源库中移植哪一个或者哪几个模式的数据，然后为每一个模式，分别在达梦中创建独立的表空间和用户；大多数情况下，需要迁移的数据所在的 PostgreSQL 库里面有多个模式，并不是所有的模式都需要迁移，所以在迁移准备阶段，一定要明确清楚要迁移哪些库的哪些模式。

3.4.3 迁移工具准备

本文选择“DM 数据迁移工具 V8 (Build 2025.01.22)”作为本次迁移要使用到的迁移工具，同版本上界面显示上可能会有一些差异。该工具在安装数据库客户端时已安装完成可以直接使用，工具存放在 DM 数据库安装目录下 tool 文件夹中。

Linux 环境下进入 tool 目录中执行./dts 即可运行 DM DTS 工具，window 环境下可直接双击启动。

3.5 迁移步骤

3.5.1 创建迁移

打开 DMDTS 迁移工具点击左上方的 3 色小图标新建迁移工程。

打开刚刚创建的工程右键点击“迁移”，选择“新建迁移”，并自定义迁移名称。

新建迁移完成后点击下一步。

从“其它数据库迁移到达梦”选项中选择迁移方式为“PostgreSQL ==> DM”。

3.5.2 连接数据库

迁移方式选择完毕后开始连接数据库，首先连接源端 PostgreSQL 数据库，再连接目的端 DM 数据库。

连接源端 PostgreSQL 数据库。

输入源端 PostgreSQL 数据库相关登录信息，在“数据库名”选项中选择需要迁移的数据库。

在创建连接 PostgreSQL 数据库时建议通过指定驱动的方式来连接数据，避免因为驱动版本不适配等问题导致迁移失败。驱动可以在 PostgreSQL 官网获取与 PostgreSQL 迁移版本相对应的驱动。

同时在工具目录 \tool\dropins\com.dameng\plugins\com.dameng.jdbc.drivers\postgresql 也存在相应版本的数据库驱动。

连接目的端 DM 数据库。

输入目的端 DM 数据库相关登录信息，选择与源端对应的迁移用户连接数据库。

3.5.3 配置迁移对象及策略

迁移对象方式及迁移策略。

当勾选了“使用默认数据类型映射关系”后在迁移时 DTS 会将源端 PostgreSQL 数据库中相应的数据类型采用默认的映射关系映射到目的端 DM 数据库中。如果在这里勾选了“使用默认数据类型映射关系”，后面又自定义了数据类型映射关系，DTS 会优先选择使用自定义的数据映射关系。

在“迁移策略”点击“查看数据类型映射关系”可以查看源端 PostgreSQL 到目的端 DM 的数据类型映射关系，包括“源数据类型名”、“源精度”、“源标度”、“目的数据类型名”、“目的精度”等等。

勾选源端待迁移的数据库。

在指定需要迁移的模式阶段，用户可以通过勾选对应的“源模式”选择源端要迁移的模式，通过“目的模式”来指定要迁移到 DM 的模式，通过是否勾选“创建模式”、“表”、“视图”、“序列”、“物化视图”来指定目的端 DM 是否要迁入源端 PostgreSQL 中 的这些对象。由于在 DM 数据库准备阶段已经提前将 POSTGRES 模式创建好了，所以这里就不勾选“创建模式”。

勾选源端数据库中需要迁移的对象。

这里可以看到源端待迁移库中所有的对象，用户可以自定义选择 PostgreSQL 需要迁移的具体对象。

注意

勾选在 SQL 评估阶段兼容的对象，待其它对象迁移完成后，再手动修改和导入这些不兼容的对象。

待迁移具体对象勾选完毕后可以通过双击源表或点击“转换”进行自定义对象迁移策略。

自定义对象迁移策略。点击转换后可以设置表的映射关系，包括迁移策略和列映射选项。

（1）迁移策略

在迁移策略中可根据需要设置表及数据迁移的策略。在左侧选项中可以选择“表定义”、“主键”、“约束”、“索引”等的迁移策略；在右侧选项中可以配置与迁移数据相关的策略。

部分选项说明：

① 压缩：指定迁移的目的表是否按照压缩方式存储。

② 强制聚集索引：即使源表的主键为非聚集主键，创建目的表时也会被转换为聚集主键。

③ 强制非聚集索引：即使源表的主键为聚集主键，创建目的表时也会被转换为非聚集主键。

④ 启用标志列插入：如果表上有标志列，则迁移数据时会强制向标志列插入值，以保证源和目的数据完全一致。

⑤ 显示行数：将在迁移任务过程中，显示数据的行数。

⑥ 拷贝记录：如果目的表已存在，直接拷贝记录，不需要创建表。

⑦ 删除后拷贝记录：迁移过程中先删除已存在的目的表，再重新创建新目的表。

⑧ 源一次读取行数：设置从数据源中读取数据时每次读取数据的行数，该参数决定内存中缓存结果集的大小，对于数据量很大的数据源，设置该参数，可以控制内存的使用。

⑨ 目的一次提交行数：设置向目的数据库中每次写入数据的行数。当数据量比较大时，减小该参数的值可以减少内存的使用。但会影响迁移的速度。

⑩ 缓存批数：设置缓存队列的长度。调整该参数可以调整迁移过程中内存的使用。

注意

如果数据量较大，可以选择先迁移表结构定义相关内容，再迁移数据，最后迁移索引。大字段建议单独迁移，且迁移大字段时建议把一次读取和一次提交的值调小，一般在 20 或以下效率可能会更好，较大值时迁移效率较低。

（2）列映射选项

在列映射选项中可根据需求修改源端迁移到目的端表的列名、数据类型、精度、小数位数、默认值、是否可空、主键、自增列、起始值、增量信息等。

完成映射关系的配置后，需要勾选“应用当前选择项到其他同类对象”，选择该选项后，将弹出对话框，选择其他同类对象，将此策略应用到相同对象上。如果不勾选“应用当前选择项到其他同类对象”，那么配置的迁移策略只会对当前选中的表生效。

在该示例中，已知源端表“partitioned_table”为分区表，由于 PG 和 DM 在创建分区表上语法有区别，迁移时配置的迁移策略与普通表不同，双击该表配置迁移策略。

勾选“范围分区转换”，确定保存。

表“data_types”在创建时使用了 PG 函数“gen_random_uuid()”，在进行数据迁移时需先删除该定义，待数据迁移完成后在 DM 端通过创建自定义函数和触发器实现 PG 中函数“gen_random_uuid()”的功能。

双击源表“data_types”。

在“列映射选项”中删除“uuid_col”列默认值“gen_random_uuid()”。

其他表迁移策略配置设置。

勾选“应用当前选择项到其他同类对象”后，勾选除分区表“partitioned_table”以外的表，点击确定，保存迁移策略。

迁移策略和列映射配置完成后点击下一步。

3.5.4 开始迁移

选择执行方式阶段，直接点击“下一步”。

检查迁移任务，确认迁移对象是否正确。检查确认后点击“完成”即可开始迁移。

迁移完成后可能看到由于 PostgreSQL 和 DM 数据库在某些语法上不同导致对象迁移失败。

通过点击“查看详细信息”可以确认详细的迁移错误信息，便于定位问题，修改后可以尝试重新迁移出错的对象。如果存在对象确实无法通过 DTS 迁移，可以考虑手动将相关对象迁移到 DM 数据库中。

3.5.5 对象补迁

由于 PostgreSQL 和 DM 数据库在某些语法使用上存在差异，导致某些对象可能会迁移失败，再加上在迁移评估阶段语法不兼容的对象和未通过 DMDTS 迁移的函数和触发器等，用户需要根据 DM 语法手动修改这些无法使用工具迁移的对象，再导入到 DM 数据库中。

在 DM 端手动创建该示例中迁移失败的对象。

（1）创建函数“get_uuid()”和触发器“trg_auto_uuid”，实现 PG 端表“data_types”字段“uuid_col”列缺省值使用的函数“gen_random_uuid()”自动生成的功能。

创建函数 get_uuid()，生成 UUID。

CREATE OR REPLACE  FUNCTION "POSTGRES".get_uuid() RETURN VARCHAR(36) AS guid VARCHAR(50);
BEGIN guid := LOWER(RAWTOHEX(SYS_GUID())); -- 转换为小写十六进制 RETURN SUBSTR(guid,1,8) || '-' ||        -- 8位 SUBSTR(guid,9,4) || '-' ||        -- 4位 SUBSTR(guid,13,4) || '-' ||       -- 4位 SUBSTR(guid,17,4) || '-' ||       -- 4位 SUBSTR(guid,21,12);               -- 12位 END;

创建触发器“trg_auto_uuid”，当表“data_types”插入数据时字段“uuid_col”列为缺省值时自动生成 UUID。

CREATE OR REPLACE  TRIGGER "POSTGRES".trg_auto_uuid BEFORE INSERT ON "POSTGRES"."data_types" FOR EACH ROW BEGIN -- 当uuid_col为空时自动生成UUID IF :NEW."uuid_col" IS NULL THEN :NEW."uuid_col" := GET_UUID();
END IF;
END;

（2）在 DM 端手动创建迁移失败的索引“dx_data_types_text”。

CREATE CONTEXT INDEX idx_data_types_text ON "POSTGRES"."data_types"("text_col");

（3）创建迁移失败的约束“customers_email_check”。

ALTER TABLE "POSTGRES"."customers" ADD CONSTRAINT "customers_email_check" CHECK (REGEXP_LIKE("email", '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$', 'i'));

（4）创建迁移失败的索引“idx_products_lower_name”。

CREATE UNIQUE INDEX "idx_products_lower_name" ON "POSTGRES"."products" (LOWER("product_name"));

（5）手动迁移 PG 端未迁移的触发器。在 PostgreSQL 示例中，通过函数“update_product_stock”与触发器“trg_order_items_stock”的协同作用，实现了“订单项变动时自动同步产品库存”的功能。鉴于 DM 与 PostgreSQL 在触发器和函数的语法及应用方式上存在差异，因此必须对原有的“update_product_stock”函数和“trg_order_items_stock”触发器进行改写，通过单一触发器“update_product_stock”来实现“订单项变动时自动同步产品库存”的功能。

CREATE OR REPLACE TRIGGER "POSTGRES"."update_product_stock" AFTER INSERT OR DELETE ON "POSTGRES"."order_items" REFERENCING OLD AS OLD_ROW NEW AS NEW_ROW  -- 调整别名顺序避免保留字冲突 FOR EACH ROW BEGIN -- INSERT操作处理 IF INSERTING THEN UPDATE "POSTGRES"."products" SET "stock_quantity" = "stock_quantity" - :NEW_ROW."quantity" WHERE "product_id" = :NEW_ROW."product_id";

-- DELETE操作处理 ELSIF DELETING THEN UPDATE "POSTGRES"."products" SET "stock_quantity" = "stock_quantity" + :OLD_ROW."quantity" WHERE "product_id" = :OLD_ROW."product_id";
END IF;
END;
/

（6）手动迁移函数“calculate_tax”。

CREATE OR REPLACE FUNCTION "POSTGRES"."calculate_tax"( amount DECIMAL(20,4), tax_rate DECIMAL(5,4) ) RETURN DECIMAL(20,4) AS BEGIN RETURN amount * tax_rate;
END;
/

-- 权限设置 GRANT EXECUTE ON "POSTGRES"."calculate_tax" TO "postgres";

3.6 数据校验

通过 SQL 脚本分别统计 PostgreSQL 端和 DM 端的对象和数据量，通过对比判断是否迁移完成。脚本验证步骤如下：

统计用户下各类对象的数量，在源端和目的端通过查询对比是否一致。

统计用户下的表数量及对应的数据条目，比对数据，验证表的数量和数据量是否一致。

3.6.1 统计 PostgreSQL 端对象及数据

PostgreSQL 的对象统计可参考 3.1.2 章节-迁移对象统计。

3.6.2 统计 DM 端对象及数据

统计达梦数据库中相关用户的对象数。

SELECT OBJECT_TYPE, COUNT(*) FROM ALL_OBJECTS WHERE OWNER='POSTGRES' --用户名，用户需根据实际情况修改。
AND OBJECT_NAME NOT LIKE 'INDEX%' --排除系统自己创建的索引 GROUP BY OBJECT_TYPE;

统计 PostgreSQL 迁移过来的表的数据量并记录到辅助表。

CREATE TABLE DM_TABLES ( TAB_OWNER VARCHAR(100), TAB_NAME  VARCHAR(100), TAB_COUNT INT );

DECLARE BEGIN FOR REC IN (SELECT OWNER, OBJECT_NAME FROM ALL_OBJECTS WHERE OWNER='POSTGRES' --用户名，用户需根据实际情况修改。
AND OBJECT_TYPE='TABLE' ) LOOP EXECUTE IMMEDIATE 'INSERT INTO DM_TABLES SELECT '''|| REC.OWNER ||''','''|| REC.OBJECT_NAME ||''',COUNT(*) FROM "'|| REC.OWNER || '"."' || REC.OBJECT_NAME||'"';
END LOOP;
END;

检查辅助表。

select * from DM_TABLES;

3.6.3 对象及数据量对比

对象对比

通过比较在 PostgreSQL 中和在 DM 中统计的对象数量及对象名来检查是否完成所有的对象迁移，将不对应或者少的对象重新迁移。

PostgreSQL 端前期调研统计出的对象如下：

调研项 说明

模式名 test_schema

表数目 12（实际有 10 张表，分区表子表有两个）

视图数目 2

序列 9

函数 2

触发器 1

索引 10

目的端 DM 迁移后的对象统计如下：

调研项 说明

模式名 POSTGRES

表数目 10

视图数目 2

序列 9

函数 2

触发器 2

索引 10

对比 PostgreSQL 端与 DM 端的统计结果。

（1）在进行统计表数量时，PG 端将每个子分区表视作独立的普通表进行计数，而达梦端则将所有子分区表汇总后进行统计。在本示例中，存在一个名为“partitioned_table”的分区表，该表包含两个分区。因此，尽管统计方法不同，表的数量是相同的。

（2）函数和触发器的迁移需手动完成，并在管理工具中进行检查以确认迁移结果的一致性。

数据量对比

通过以下 SQL 命令可以比对表数据量，找出数据量不相等的表重新迁移数据，结果集为空表示源端和目的端数据量一致。其中 table_row_counts 为 PostgreSQL 迁移前统计的记录所有表数据量的辅助表，DM_TABLES 为 DM 数据库中记录表数据量的辅助表。

SELECT A."table_name", A."row_count", A."row_count"-B.TAB_COUNT FROM POSTGRES."table_row_counts" A, DM_TABLES B WHERE A."table_name"=B.TAB_NAME AND A."table_name" != 'table_row_counts'--剔除辅助表 AND A."row_count"-B.TAB_COUNT<>0;

经过对辅助表 table_row_counts 和辅助表 DM_TABLES 数据量的 SQL 对比分析，结果显示仅“partitioned_table”表在 DM 端相较于 PG 端多出 4 条记录。此差异产生的原因在于 PG 端的分区表父表中不存在数据，而“partitioned_table”表包含两个分区。在进行数据行数统计时，PG 端将子分区表视作普通表进行计算。相比之下，DM 端直接统计了“partitioned_table”所有子表的数据行数，导致在 DM 端该表数据行数比 PG 端多出 4 条。至于其他普通表，由于数据行数一致，因此未显示出差异。

3.7 统计信息与备份

3.7.1 更新统计信息

数据核对完成无问题后，应进行一次全库的统计信息更新工作。统计信息更新脚本示例如下：

按模式更新统计信息：

DBMS_STATS.GATHER_SCHEMA_STATS( POSTGRES, --POSTGRES为模式名，需要根据实际情况修改为自己的模式名。
100, FALSE, 'FOR ALL COLUMNS SIZE AUTO');

如果数据量较大，该过程执行较慢，需要等待一段时间。

按照表进行统计信息的收集：

DBMS_STATS.GATHER_TABLE_STATS( 'username',--用户名 'table_name',--表名 null,100,TRUE,'FOR ALL COLUMNS SIZE AUTO');

更新统计信息的目的在于大批量迁移数据后数据库系统未对用户数据进行全面分析存在错误的统计信息，可能会导致数据库优化器根据错误的统计信息得到错误的查询计划，严重影响查询性能。

更多更新统计信息方式可参考：统计信息。

3.7.2 备份

在对数据更新完统计信息后，在数据量不大，磁盘空间足够的情况下应进行一次数据备份工作，避免在数据验证过程中对数据产生修改需要重新迁移。数据备份有三种方式：

正常停止数据库后，拷贝备份到实例目录或保存数据文件的其他目录；

开启归档日志后，进行物理备份；

逻辑备份，使用 dexp 工具进行逻辑导出。

此外，通常生产系统都需要制定定时备份任务，备份时间点建议避开业务高峰期，可根据需要配置备份作业任务。

3.8 应用迁移

一般情况下，PostgreSQL 迁移完成后，需要更换应用连接数据源到达梦数据库。为了验证系统移植的完整性，还需要进行应用的相关功能和性能测试，并改造应用到连接达梦数据库一个最佳状态。

3.8.1 语言、接口、框架

应用在适配时，可以前往达梦在线服务平台-应用开发指南模块参考相关语言的适配指南。

四、 SQL 日志开启与分析

数据库和应用系统移植完毕后开启 sql 日志，对系统进行全面测试，排除移植过程中错误的地方，对慢的 sql 语句进行优化。可以通过对 SQL 日志记录的慢 SQL 进行优化提升 SQL 执行效率。在开启 SQL 日志时可参考如下两个 SQL 日志参数的配置，通过在 sqllog.ini 中设置 SQL 过滤规则来记录需要优化的 SQL。

--设置SQL过滤规则 SQL_TRACE_MASK=2:3:22:23:25:28---指定 SQL 日志中需要被记录的语句类型，详细说明可参考达梦数据库安装目录下doc目录中《DM8系统管理员手册》。
MIN_EXEC_TIME=500 --记录执行时间大于500毫秒的SQL，用户需根据实际情况设置。

SQL 日志开启方法可参考达梦在线服务平台-运维指南-单机安装部署-配置 sql 日志。

在功能测试和性能测试的时候可以开启 SQL 日志，然后通过日志分析工具从执行时间和执行次数两个维度对 SQL 日志进行分析，生产分析结果，然后根据分析结果对系统性能进行优化。使用日志分析工具时最好采用 32k 页大小的 DM 作为分析库。

更多性能优化可参考达梦在线服务平台-运维指南-性能诊断与优化。

五、常见问题

1、Postgresql 使用 DTS 数据迁移到 DM 报错：数据转换错误

【问题解决】

首先查看报错日志，定位到错误的表，大部分是由于字符长度不够导致的错误，对于报错的表，可以重新迁移，在 DTS 迁移选项的迁移策略中选择字符长度*4 解决此问题。

2、Postgresql 使用 DTS 数据迁移到 DM 报错：创建 rang 分区表报语法分析错误

【问题解决】

PG 数据库创建 RANG 分区表的语法与达梦不一样，需要在 DTS 转换中勾选范围分区转换，另外需要注意分区的顺序，达梦中范围分区需要分区值从小到大排列，不能乱序。

3、Postgresql 迁移到 dm 后，如何实现 string_to_array 函数功能

可通过创建自定义同名函数来实现 string_to_array 函数功能，具体如下：

CREATE or replace TYPE "SPLIT_TYPE" IS TABLE OF VARCHAR2 (4000);
CREATE OR REPLACE FUNCTION "string_to_array" ( p_str       IN VARCHAR2, p_delimiter IN VARCHAR2 DEFAULT ( ',') --分隔符，默认逗号 ) RETURN split_type IS j    INT := 0;
i    INT := 1;
LEN  INT := 0;
len1 INT := 0;
str  VARCHAR2 (4000);
my_split split_type := split_type ();
BEGIN LEN    := LENGTH (p_str);
len1   := LENGTH (p_delimiter);
WHILE j < LEN LOOP j           := INSTR (p_str, p_delimiter, i);
IF j         = 0 THEN j   := LEN;
str := SUBSTR (p_str, i);
my_split.EXTEND;
my_split(my_split.COUNT) := str;
IF i                     >= LEN THEN EXIT;
END IF;
ELSE str := SUBSTR (p_str, i, j - i);
i   := j                   + len1;
my_split.EXTEND;
my_split(my_split.COUNT) := str;
END IF;
END LOOP;
RETURN my_split;
END;

4、pg 空间类型数据迁移到 DM 时报错：“函数 st_asbinary(country.geometry) 不存在”

【问题描述】

从 pg 迁移空间类型数据到 DM 时，dts 报错“函数 st_asbinary(country.geometry) 不存在，建议：没有匹配指定名称和参数类型的函数，需要增加明确的类型转换.”。

【问题分析】

dts 迁移 pg 空间类型数据时需要调用到 pg 的 st_asbinary 函数，而 pg 数据库的 st_asbinary 函数是在扩展了 postgis 的模式下使用，比如在 pg 中执行 create extension postgis schema country; 后，那么就可以在 country 模式下执行该函数。

【问题解决】

方式一：在 dts 连接时添加 url 连接属性指定使用的模式 searchpath=country 再尝试迁移。如果该方法无法解决该问题，可以尝试方式二进行解决。

方式二：在 pg 中执行如下 SQL 后，再将空间类型数据的表导入到 public 模式下再尝试迁移。

drop extension postgis cascade;
create extension postgis schema public;

六、更多帮助

更多 Postgresql 到 DM 迁移常见问题可参考达梦在线服务平台-常见问题-从其他数据库迁移到 DM。

更多 DTS 工具使用详情可参考 DTS 工具“帮助主题”，具体位置见下图：

上次更新：2026-09-26 上一篇下一篇

从 PostgreSQL 移植到 DM

一、概述 二、迁移流程
2.1 迁移流程图
2.2 流程介绍
2.2.1 需求确认
2.2.2 数据库调研
2.2.3 迁移评估
2.2.4 移植工具选择
2.2.5 制定移植计划
2.2.6 移植实施
2.2.7 移植结果校验
2.2.8 移植后收尾工作
2.2.9 应用移植与优化
三、移植过程
3.1 需求确认及调研
3.1.1 需求确认
3.1.2 数据库调研
3.2 迁移评估
3.3 制定移植计划
3.4 迁移准备
3.4.1 源端 PostgreSQL 数据库准备
3.4.2 目的端达梦数据库准备
3.4.3 迁移工具准备
3.5 迁移步骤
3.5.1 创建迁移
3.5.2 连接数据库
3.5.3 配置迁移对象及策略
3.5.4 开始迁移
3.5.5 对象补迁
3.6 数据校验
3.6.1 统计 PostgreSQL 端对象及数据
3.6.2 统计 DM 端对象及数据
3.6.3 对象及数据量对比
3.7 统计信息与备份
3.7.1 更新统计信息
3.7.2 备份
3.8 应用迁移
3.8.1 语言、接口、框架
四、 SQL 日志开启与分析 五、常见问题 六、更多帮助

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
