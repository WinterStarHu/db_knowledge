# 使用 TTL 管理数据保留  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/ttl/working-with-ttl

使用 TTL 管理数据保留  |  Spanner  |  Google Cloud Documentation

跳至主要内容

技术领域

close

AI 和机器学习

应用开发

应用托管

计算

数据分析和流水线

数据库

分布式云、混合云和多云

生成式 AI

行业解决方案

网络

可观测性和监控

安全

Storage

跨产品工具

close

访问权限和资源管理

费用和用量管理

基础设施即代码

迁移

SDK、语言、框架和工具

/

控制台

English

Deutsch

Español

Español – América Latina

Français

Indonesia

Italiano

Português

Português – Brasil

עברית

中文 – 简体

中文 – 繁體

日本語

한국어

登录

Spanner

免费开始使用吧

概览

指南

参考文档

示例

支持

资源

技术领域

更多

概览

指南

参考文档

示例

支持

资源

跨产品工具

更多

控制台

Discover

产品概览

Spanner 版本概览

PostgreSQL 接口

适用于非关系型工作负载的 Spanner

非关系型数据库概览 Cassandra 接口

开始使用

Spanner 概念验证 playbook

设置您的环境

创建和查询数据库

使用 Google Cloud 控制台 使用 gcloud CLI

使用 Google Cloud 控制台管理数据

客户端库

C++ 快速入门 C# 快速入门 Go 版快速入门 Java 快速入门 Node.js 版快速入门 PHP 快速入门 Python 快速入门 Ruby 快速入门 REST 快速入门

推动因素

使用驱动程序进行设置 JDBC 快速入门 Go 数据库/SQL 快速入门 PostgreSQL 驱动程序快速入门

Spanner CLI

Spanner CLI 快速入门 Spanner CLI 命令

免费试用实例

免费试用实例概览 创建免费试用实例

数据驻留概览

创建和管理

实例

实例概览 节点和处理单元 单区域、双区域和多区域配置 区域类型 复制

地理分区数据

地理分区概览 创建和管理实例分区 创建和管理数据位置 领导者感知路由 全球和区域服务端点 分层存储 创建和管理实例 创建和管理实例配置 更改双区域仲裁 移动实例

自动扩缩实例

自动扩缩概览 托管式自动扩缩器

开源自动扩缩器工具

自动扩缩器工具概览 将自动扩缩器工具部署到 Cloud Run functions 将自动扩缩器工具部署到 GKE 使用标记控制访问权限和整理实例

数据库

数据库概览 在 GoogleSQL 和 PostgreSQL 之间进行选择 创建和管理数据库 防止意外删除数据库 模式对象删除保护 修改数据库的主要区域 设置数据库默认时区

使用 Data Catalog 管理资源

设计和管理数据库架构

架构概览 架构设计最佳实践 更新架构 创建和管理命名架构 视图概览 创建和管理视图 二级索引 外键 主键默认值管理 创建和管理外键关系 创建和管理检查限制条件 创建和管理生成的列 存储任意精度数值数据 创建和管理序列 管理表名称 创建和管理位置组

管理和观察长时间运行的操作

配置存留时间 (TTL)

TTL 概览 使用 TTL 管理数据保留 TTL 指标和监控

紧密联系

连接到 PostgreSQL 方言数据库

使用 PGAdapter 将 PostgreSQL 客户端连接到 Spanner

PGAdapter 概览 获取 PGAdapter 启动 PGAdapter PGAdapter 会话管理命令 将 PGAdapter 连接到模拟器

使用 Cassandra 适配器连接到 Spanner

创建并连接 Compute Engine 虚拟机实例以访问 Spanner

通过 GKE 集群连接到 Spanner

从其他 Google Cloud 服务连接到 Spanner

向 Spanner 进行身份验证

保护和控制访问权限

使用 IAM 进行访问权限控制

IAM 概览 应用 IAM 角色

精细访问权限控制

精细访问权限控制概览 变更数据流的精细访问权限控制 序列的精细访问权限控制 针对模型的精细访问权限控制 配置精细访问权限控制 使用精细访问权限控制访问数据库 精细访问权限控制权限 精细访问权限控制系统角色

添加自定义组织政策

数据加密

客户管理的加密密钥 (CMEK)

CMEK 概览 使用 CMEK 保护数据库 传输中的数据加密

迁移

迁移过程

迁移概览 评估迁移 迁移架构 迁移您的应用 优化架构和应用性能 迁移数据 验证您的数据 配置割接和回退机制

迁移工具

迁移工具概览 设置 Spanner 迁移工具 (SMT)

主键迁移

主键迁移概览 迁移主键

从 MySQL 迁移

MySQL 迁移概览

MySQL 架构迁移

从 MySQL 迁移架构概览 使用 SMT 从 MySQL 迁移架构 迁移 MySQL 数据 为 MySQL 配置回退

加载示例数据

从 DynamoDB 迁移

从 Oracle 迁移

从 PostgreSQL 迁移

迁移到 GoogleSQL 方言数据库 迁移到 PostgreSQL 方言数据库

从 Cassandra 迁移

将 Spanner 迁移到 PostgreSQL 数据库

导入和导出数据

导入和导出概览

使用 Dataflow 导入、导出和修改数据

以 Avro格式导入和导出数据

导入 Spanner Avro 文件 将数据从 Spanner 导出到 Avro 从非 Spanner 数据库导入数据

以 CSV 格式导入和导出数据

使用 COPY 从 PostgreSQL 导入数据

批量加载最佳做法

灾难恢复

灾难恢复概览

备份数据库

备份概览 创建备份 创建和管理备份时间表 管理备份

恢复数据库

恢复概览 使用备份进行恢复

时间点恢复 (PITR)

PITR 概览 使用 PITR 恢复数据

开发

在 Gemini 协助下编写 SQL

应用场景最佳实践

将 Spanner 用作游戏数据库

集成语言框架

将 Spanner 与 Hibernate 搭配使用

与 Hibernate ORM 集成 (GoogleSQL) 与 Hibernate ORM 集成 (PostgreSQL) 编写连接到 Spanner 的 Hibernate 应用

将 Spanner 与 Spring Data JPA 搭配使用

与 Spring Data JPA 集成 (GoogleSQL) 与 Spring Data JPA 集成 (PostgreSQL)

将 Spanner 与 Spring Data JDBC 搭配使用

与 Spring Data JDBC 集成 (GoogleSQL) 与 Spring Data JDBC 集成 (PostgreSQL)

将 Spanner 与 MyBatis 搭配使用

与 MyBatis 和 Spring Boot 集成 (GoogleSQL) 与 MyBatis 和 Spring Boot 集成 (PostgreSQL) 将 Spanner 与 Spring Data 搭配使用 编写连接到 Spanner 的 Spring Boot 应用

将 Spanner 与 GORM 搭配使用

与 GORM 集成 (GoogleSQL) 与 GORM 集成 (PostgreSQL) 将 Spanner 与 Django ORM 搭配使用

将 Spanner 与 SQLAlchemy 搭配使用

与 SQLAlchemy 集成 (GoogleSQL) 与 SQLAlchemy 集成 (PostgreSQL) 将 Spanner 与 Active Record 搭配使用 将 Spanner 与 Entity Framework Core 搭配使用

使用事务

事务概览 时间戳边界

提交时间戳

在 GoogleSQL 方言数据库中 在 PostgreSQL 方言数据库中 TrueTime 和外部一致性

隔离级别

隔离级别概览 使用可重复读隔离 吞吐量优化写入 检索事务的提交统计信息 在串行化隔离中使用 SELECT FOR UPDATE 在可重复读取隔离中使用 SELECT FOR UPDATE

会话数

SQL 最佳做法

读取数据

在事务外进行读取 定向读取 读取租约

使用 Data Boost 独立的计算资源进行读取

Data Boost 概览 使用 Data Boost 运行联合查询 使用 Data Boost 导出数据 在应用中使用 Data Boost 监控 Data Boost 用量 监控和管理 Data Boost 配额用量

使用保存的查询

保存的查询概览 创建和管理保存的查询

修改数据

使用 Google Cloud 控制台修改数据 使用 gcloud CLI 修改数据

使用 DML 修改数据

使用DML插入、更新和删除数据 分区 DML DML 最佳做法 使用变更修改数据 比较 DML 与变更 使用批量写入修改数据

处理数据类型

使用数组

在 GoogleSQL 方言数据库中 在 PostgreSQL 方言数据库中 使用 STRUCT 对象 处理 NUMERIC 数据 处理 JSON 数据 处理 JSONB 数据 在 GoogleSQL 中使用协议缓冲区

开发和测试

在本地模拟 Spanner 将 Terraform 与 Spanner 搭配使用 配置自定义超时和重试 配置语句超时 配置事务超时

处理和查看数据

Dataflow 模板

流式传输数据更改

变更数据流概览 创建和管理变更数据流 使用 Dataflow 构建变更数据流连接 构建与 Kafka 的变更数据流连接 变更数据流分区、记录和查询 将 Spanner 与 IntelliJ 集成 将 Spanner 与 Looker 集成 将 Spanner 与 Liquibase 集成

全文搜索

全文搜索概览

词元化和搜索索引

词法单元化 搜索索引 数值搜索索引 JSON 搜索索引 对搜索索引进行分区 合并 TOKENLIST

全文搜索查询

查询概览 搜索多个列 混合使用全文查询和非文本查询 对搜索结果进行排名 执行子字符串搜索 使用模糊搜索查找近似匹配项 执行前 k 个模式匹配 使用分面执行搜索 对搜索结果进行分页 混合全文搜索和向量搜索模式 搜索索引与二级索引

在 Spanner 中安装 MySQL 函数

在 Spanner 中实现多租户

Spanner AI 和机器学习

Spanner AI 概览

开始将 Spanner 用于生成式 AI 应用

Spanner 与 Vertex AI 的集成

向量搜索

生成嵌入

获取 Vertex AI 文本嵌入 使用分区 DML 批量生成向量嵌入 执行 K 最近邻搜索 选择最佳向量距离函数

近似最近邻 (ANN)

使用向量索引执行 ANN 搜索 创建和管理向量索引 向量索引编制最佳实践 将嵌入导出到 Vertex AI Vector Search

生成预测

使用 SQL 生成机器学习预测 将生成式 AI 与示例电子商务应用搭配使用 使用 Spanner 模拟器生成机器学习预测

与 AI 技术集成

使用 LangChain 构建依托 LLM 的应用 将 Spanner 与智能体搭配使用 使用 LlamaIndex 构建应用

Spanner Graph

产品概览

设置和查询 Spanner Graph

Spanner Graph 架构

架构概览 创建和管理 Spanner Graph 架构 设计架构的最佳实践

管理 Spanner Graph 数据

Spanner Graph 查询

查询概览 使用路径 查询调优最佳实践 将全文搜索与 Spanner Graph 搭配使用 将向量搜索与 Spanner Graph 搭配使用

Spanner Graph 可视化图表

使用 Spanner Graph 可视化图表 使用 Spanner Graph 可视化图表集成

使用 Spanner Graph 管理无架构数据

将 BigQuery 数据加载到 Spanner 图中

迁移到 Spanner Graph

适用于 openCypher 用户的 Spanner Graph 参考文档

排查 Spanner Graph 问题

监控

捕获遥测信号

信号捕获概览

跟踪记录收集

跟踪记录收集概览 使用 OpenTelemetry 设置跟踪记录收集

指标

指标列表

客户端指标收集

查看和管理客户端指标 客户端指标说明

自定义客户端指标收集

使用 OpenTelemetry 捕获自定义客户端指标 使用 OpenCensus 捕获自定义客户端指标 审核日志

监控实例

使用分析洞见监控实例性能 使用 Cloud Monitoring 监控实例

优化和问题排查

优化 Spanner 性能

性能概览 分析查询性能 监控活跃查询

查询优化器

查询优化器概览 查询优化器版本 列出查询优化器版本 管理查询优化器 查询执行计划 使用查询计划可视化工具调优查询

使用列式引擎加速分析查询

Spanner 列式引擎概览 配置 Spanner 列式引擎 查询列式数据 监控列式引擎 查找数据库中的热点 使用索引顾问

管理分块点以应对预期的流量增长

预分块概览 创建和管理拆分点

使用 Key Visualizer 分析使用模式

Key Visualizer 概览 访问 Key Visualizer 探索 Key Visualizer 热图 Key Visualizer 热图模式

排查延迟时间问题

Spanner 请求中的延迟时间点 确定出现延迟的位置 使用指标诊断延迟时间 计算流式传输和分区请求延迟时间 识别导致高延迟时间的事务

使用内置统计信息表排查问题

内置统计信息表概览 查询统计信息 最早的活跃查询统计信息 活跃的分区 DML 统计信息 读取统计信息 事务统计信息 锁定统计信息 列操作统计信息 表大小统计信息 表操作统计信息 分块统计信息

排查实例利用率问题

CPU 利用率概览 排查高 CPU 利用率问题 存储空间利用率

排查性能下降问题

在 Gemini 的协助下进行观察和并排查问题

排查 CMEK 组织政策违规问题

排查请求代码和事务代码问题

排查“已超出截止期限”错误

排查 Vertex AI 集成错误

错误代码

AI 和机器学习

应用开发

应用托管

计算

数据分析和流水线

数据库

分布式云、混合云和多云

生成式 AI

行业解决方案

网络

可观测性和监控

安全

Storage

访问权限和资源管理

费用和用量管理

基础设施即代码

迁移

SDK、语言、框架和工具

Home

Documentation

Databases

Spanner

指南

发送反馈

使用 TTL 管理数据保留

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面讨论了如何在 GoogleSQL 方言数据库和 PostgreSQL 方言数据库中对 Spanner 表使用存留时间 (TTL)。如需了解详情，请参阅关于 TTL。

准备工作

在开始之前，请遵循以下最佳实践。

启用备份和时间点恢复

在向表添加 TTL 之前，我们建议您启用 Spanner 备份和恢复。这使您可以在意外删除具有 TTL 政策的数据的情况下完全恢复数据库。

如果您已启用时间点恢复，并且已删除的数据在已配置的版本保留期限内，则可以查看和恢复这些数据，而不必从备份进行完全恢复。如需了解如何读取过去的数据，请参阅执行过时数据读取。

清理旧数据

如果您是首次使用 TTL，并且预计第一次运行会删除多行，请考虑先使用分区 DML 手动清理旧数据。这样，您就可以更好地控制资源使用情况，而不是将其留给 TTL 后台进程。TTL 以低优先级运行，非常适合增量清理。不过，由于 Spanner 的内部工作调度器会优先处理其他工作（例如用户查询），这可能会延长在繁忙数据库中删除初始行集所需的时间。

验证您的条件

对于 GoogleSQL 表，如果您希望在启用 TTL 之前验证行删除政策会影响的数据，则可以使用相同的条件查询表。例如：

GoogleSQL

SELECT COUNT(*) FROM CalculatedRoutes WHERE TIMESTAMP_ADD(CreatedAt, INTERVAL 30 DAY) < CURRENT_TIMESTAMP();

所需权限

如需更改数据库的架构，您必须拥有 spanner.databases.updateDdl 权限。如需了解详情，请参阅 Spanner 的访问权限控制。

创建行删除政策

GoogleSQL 如需使用 GoogleSQL 创建行删除政策，您可以在创建新表时定义 ROW DELETION POLICY 子句，也可以向现有表添加政策。此子句包含列的表达式和间隔。

如需在创建表时添加政策，请执行以下操作：

CREATE TABLE MyTable( Key INT64, CreatedAt TIMESTAMP, ) PRIMARY KEY (Key), ROW DELETION POLICY (OLDER_THAN(timestamp_column, INTERVAL num_days DAY));

替换以下内容：

timestamp_column 必须是类型为 TIMESTAMP 的现有列。包含提交时间戳的列是有效的，生成列也是如此。不过，您无法指定引用提交时间戳列的生成列。

num_days 是 timestamp_column 中的时间戳之后经过的天数，超过该天数的行会标记为待删除。该值必须是非负整数，DAY 是唯一支持的单位。

如需向现有表添加政策，请使用 ALTER TABLE 语句。每个表最多只能有一个行删除政策。将行删除政策添加到具有现有政策的表将失败并报错。请参阅生成的列上的 TTL 以指定更复杂的行删除逻辑。

ALTER TABLE Albums ADD ROW DELETION POLICY (OLDER_THAN(timestamp_column, INTERVAL num_days DAY));

PostgreSQL 如需使用 PostgreSQL 创建行删除政策，您可以在创建新表时定义 TTL INTERVAL 子句，也可以向现有表添加政策。

如需在创建表时添加政策，请执行以下操作：

CREATE TABLE mytable ( key bigint NOT NULL, timestamp_column_name TIMESTAMPTZ, PRIMARY KEY(key) ) TTL INTERVAL interval_specvar> ON timestamp_column_name;

替换以下内容：

timestamp_column_name 必须是数据类型为 TIMESTAMPTZ 的列。您需要在 CREATE TABLE 语句中创建此列。包含提交时间戳的列是有效的，生成列也是如此。不过，您无法指定引用提交时间戳列的生成列。

interval_spec 是 timestamp_column_name 中的时间戳之后经过的天数，超过该天数的行会标记为待删除。该值必须是非负整数，并且必须计算为整数天数。例如，允许使用 '3 days'，但 '3 days - 2 minutes' 会返回错误。

如需向现有表添加政策，请使用 ALTER TABLE 语句。每个表最多只能有一个 TTL 政策。将 TTL 政策添加到具有现有政策的表将失败并报错。请参阅生成列上的 TTL 以指定更复杂的 TTL 逻辑。

如需向现有表添加政策，请执行以下操作：

ALTER TABLE albums ADD COLUMN timestampcolumn TIMESTAMPTZ;

ALTER TABLE albums ADD TTL INTERVAL '5 days' ON timestampcolumn;

限制

行删除政策具有以下限制。

外键引用的表上的 TTL

您无法对以下对象创建行删除政策：

不包含 ON DELETE CASCADE 限制条件的外键引用的表。

不包含 ON DELETE CASCADE 参照操作的外键引用的表的父表。

在以下示例中，您无法向 Customers 表添加行删除政策，因为该表由 Orders 表中的某个外键引用，而该外键没有 ON DELETE CASCADE 限制条件。删除客户可能会违反此外键限制条件。您也无法向 Districts 表添加行删除政策。从 Districts 中删除行可能会导致在子表 Customers 中进行级联删除，这可能会违反 Orders 表中的外键限制条件。

GoogleSQL

CREATE TABLE Districts ( DistrictID INT64 ) PRIMARY KEY (DistrictID);

CREATE TABLE Customers ( DistrictID INT64, CustomerID INT64, CreatedAt TIMESTAMP ) PRIMARY KEY (DistrictID, CustomerID), INTERLEAVE IN PARENT Districts ON DELETE CASCADE;

CREATE TABLE Orders ( OrderID INT64, DistrictID INT64, CustomerID INT64, CONSTRAINT FK_CustomerOrder FOREIGN KEY (DistrictID, CustomerID) REFERENCES Customers (DistrictID, CustomerID) ) PRIMARY KEY (OrderID);

PostgreSQL

CREATE TABLE districts ( districtid   bigint NOT NULL, PRIMARY KEY(districtid) );

CREATE TABLE customers ( districtid   bigint NOT NULL, customerid   bigint NOT NULL, createdat  timestamptz, PRIMARY KEY(districtid, customerid) ) INTERLEAVE IN PARENT districts ON DELETE CASCADE;

CREATE TABLE orders ( orderid bigint NOT NULL, districtid   bigint, customerid bigint, PRIMARY KEY(orderid), CONSTRAINT fk_customerorder FOREIGN KEY (districtid, customerid) REFERENCES customers (districtid, customerid) );

您可以对使用 ON DELETE CASCADE 的外键限制条件引用的表创建行删除政策。在以下示例中，您可以对 Orders 表上定义的外键限制条件 CustomerOrder 引用的 Customers 表创建行删除政策。当 TTL 删除 Customers 中的行时，删除操作会向下级联到 Orders 表中的匹配行。

GoogleSQL

CREATE TABLE Districts ( DistrictID INT64, CreatedAt TIMESTAMP ) PRIMARY KEY (DistrictID), ROW DELETION POLICY (OLDER_THAN(CreatedAt, INTERVAL 1 DAY));

CREATE TABLE Customers ( DistrictID INT64, CustomerID INT64, CreatedAt TIMESTAMP ) PRIMARY KEY (DistrictID, CustomerID), INTERLEAVE IN PARENT Districts ON DELETE CASCADE, ROW DELETION POLICY (OLDER_THAN(CreatedAt, INTERVAL 1 DAY));

CREATE TABLE Orders ( OrderID INT64, DistrictID INT64, CustomerID INT64, CONSTRAINT FK_CustomerOrder FOREIGN KEY (DistrictID, CustomerID) REFERENCES Customers (DistrictID, CustomerID) ON DELETE CASCADE ) PRIMARY KEY (OrderID);

PostgreSQL

CREATE TABLE districts ( districtid   bigint NOT NULL, createdat  timestamptz, PRIMARY KEY(districtid) ) TTL INTERVAL '1 day' ON createdat;

CREATE TABLE customers ( districtid   bigint NOT NULL, customerid   bigint NOT NULL, createdat  timestamptz, PRIMARY KEY(districtid, customerid) ) INTERLEAVE IN PARENT districts ON DELETE CASCADE TTL INTERVAL '1 day' ON createdat;

CREATE TABLE orders ( orderid bigint NOT NULL, districtid bigint, customerid bigint, PRIMARY KEY(orderid), CONSTRAINT fk_customerorder FOREIGN KEY (districtid, customerid) REFERENCES customers (districtid, customerid) ON DELETE CASCADE );

同样，您可以对 ON DELETE CASCADE 外键限制条件引用的表的父表创建行删除政策。

具有默认值的列上的 TTL

行删除政策可以使用具有默认值的时间戳列。典型默认值为 CURRENT_TIMESTAMP。如果未明确向列分配值，或者通过 INSERT 或 UPDATE 语句将列设置为其默认值，则在规则计算中会使用默认值。

在以下示例中，表 Customers 中的列 CreatedAt 的默认值是创建相应行时的时间戳。

GoogleSQL

CREATE TABLE Customers ( CustomerID INT64, CreatedAt TIMESTAMP DEFAULT (CURRENT_TIMESTAMP()) ) PRIMARY KEY (CustomerID);

如需了解详情，请参阅 DEFAULT（表达式）。

PostgreSQL

CREATE TABLE customers ( customerid bigint NOT NULL, createdat timestamptz DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(customerid) );

如需了解详情，请参阅 CREATE TABLE。

生成的列上的 TTL

行删除政策可以使用生成列来表示更复杂的规则。例如，您可以对多个列的 greatest 时间戳（GoogleSQL 或 PostgreSQL）定义行删除政策，或将另一个值映射到时间戳。
注意：您无法指定引用提交时间戳列的生成列。

GoogleSQL 以下名为 Orders 的表会跟踪销售订单。表所有者想要设置一个行删除政策，以便在 30 天后删除已取消的订单，并在 180 天后删除未取消的订单。

Spanner TTL 仅允许每个表有一个行删除政策。如需在单个列中表示这两个条件，您可以将生成列与 IF 语句结合使用：

CREATE TABLE Orders ( OrderId INT64 NOT NULL, OrderStatus STRING(30) NOT NULL, LastModifiedDate TIMESTAMP NOT NULL, ExpiredDate TIMESTAMP AS (IF(OrderStatus = 'Cancelled', TIMESTAMP_ADD(LastModifiedDate, INTERVAL 30 DAY), TIMESTAMP_ADD(LastModifiedDate, INTERVAL 180 DAY))) STORED, ) PRIMARY KEY(OrderId), ROW DELETION POLICY (OLDER_THAN(ExpiredDate, INTERVAL 0 DAY));

该语句会创建一个名为 ExpiredDate 的列，该列会根据订单状态向 LastModifiedDate 添加 30 天或 180 天。然后通过指定 INTERVAL 0 day，将行删除政策定义为让行在 ExpiredDate 列中存储的日期过期。

PostgreSQL 以下名为 Orders 的表会跟踪销售订单。表所有者想要设置一个行删除政策，以便在非活跃状态超过 30 天后删除行。

Spanner TTL 仅允许每个表有一个行删除政策。如需在单个列中表示这两个条件，您可以创建生成列：

CREATE TABLE orders ( orderid bigint NOT NULL, orderstatus varchar(30) NOT NULL, createdate timestamptz NOT NULL, lastmodifieddate timestamptz, expireddate timestamptz GENERATED ALWAYS AS (GREATEST(createdate, lastmodifieddate)) STORED, PRIMARY KEY(orderid) ) TTL INTERVAL '30 days' ON expireddate;

该语句会创建一个名为 ExpiredDate 的生成列，用于评估两个日期（LastModifiedDate 或 CreateDate）中较晚的日期。然后，它会定义行删除政策，以在订单创建 30 天后使行过期；如果订单在这 30 天内进行了修改，则会将删除时间再延长 30 天。

TTL 和交错表

交错表是将一对多子表中的相关行与父表中的行相关联的性能优化。如需在父表上添加行删除政策，所有交织子表都必须指定 ON DELETE CASCADE，这意味着子行会与父行一起以原子方式删除。这样可以确保参照完整性，以便父表上的删除也会删除同一事务中的相关子行。Spanner TTL 不支持 ON DELETE NO ACTION。

事务大小上限

Spanner 具有事务大小限制。对具有编入索引的列的大型父子层次结构进行级联删除可能会超出这些限制，并导致一个或多个 TTL 操作失败。对于失败的操作，TTL 会使用更小的批次进行重试，直到批次减小为单个父行。但是，即使是单个父行的大型子层次结构仍有可能超出变更限制。

TTL 指标中将会报告失败的操作。

如果单个行及其交织子行由于太大而无法删除，则除了父表上的行删除政策之外，您还可以直接在子表上附加行删除政策。子表上的政策应该配置为先删除子行，然后再删除父行。

当以下两个语句适用时，请考虑将行删除政策附加到子表：

子表具有任何与之关联的全局索引；且

每个父行预计包含大量 (>100) 子行。

删除行删除政策

您可以从表中删除现有行删除政策。如果表上没有现有的行删除政策，则返回错误。

GoogleSQL

ALTER TABLE MyTable DROP ROW DELETION POLICY;

PostgreSQL

ALTER TABLE mytable DROP TTL;

删除行删除政策会立即中止在后台运行的任何 TTL 进程。正在进行的进程已删除的所有行都将被删除。

删除行删除政策引用的列

Spanner 不允许删除行删除政策引用的列。您必须先删除行删除政策，然后才能删除该列。

查看表的行删除政策

您可以查看 Spanner 表的行删除政策。

GoogleSQL

SELECT TABLE_NAME, ROW_DELETION_POLICY_EXPRESSION FROM INFORMATION_SCHEMA.TABLES WHERE ROW_DELETION_POLICY_EXPRESSION IS NOT NULL;

如需了解详情，请参阅 GoogleSQL 方言数据库的信息架构。

PostgreSQL

SELECT table_name, row_deletion_policy_expression FROM information_schema.tables WHERE row_deletion_policy_expression is not null;

如需了解详情，请参阅 PostgreSQL 方言数据库的信息架构。

修改行删除政策

您可以更改现有行删除政策的列或间隔表达式。以下示例将列从 CreatedAt 切换到 ModifiedAt，并将间隔从 1 DAY 延长到 7 DAY。如果表上没有现有的行删除政策，则返回错误。

GoogleSQL

ALTER TABLE MyTable REPLACE ROW DELETION POLICY (OLDER_THAN(ModifiedAt, INTERVAL 7 DAY));

PostgreSQL

ALTER TABLE mytable ALTER TTL INTERVAL '7 days' ON timestampcolumn;

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-05-09。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-05-09。"],[],[]]

产品和价格

查看所有产品

Google Cloud 价格

Google Cloud Marketplace

与销售人员联系

支持

社区论坛

支持

版本说明

系统状态

资源

GitHub

Google Cloud 使用入门

代码示例

云架构中心

培训和认证

互动

博客

活动

X (Twitter)

Google Cloud 在 YouTube 上的频道

YouTube 上的 Google Cloud Tech

Android

Chrome

Firebase

Google AI

关于 Google

隐私权政策

网站条款

Google Cloud 条款

Manage cookies

环境行动的第三个十年：加入我们

订阅 Google Cloud 简报

订阅

English

Deutsch

Español

Español – América Latina

Français

Indonesia

Italiano

Português

Português – Brasil

עברית

中文 – 简体

中文 – 繁體

日本語

한국어
