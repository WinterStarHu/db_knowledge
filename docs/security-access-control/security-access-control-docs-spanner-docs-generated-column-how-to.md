# 创建和管理生成的列  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/generated-column/how-to

创建和管理生成的列  |  Spanner  |  Google Cloud Documentation

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

创建和管理生成的列

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

生成的列始终是由某行中的其他列计算得出的列。这些列可简化查询、查询时评估表达式的费用，并可编织索引或作为外键。本页介绍了如何在数据库中管理此列类型，适用于 GoogleSQL 方言数据库和 PostgreSQL 方言数据库。

向新表添加生成的列

在以下 CREATE TABLE 代码段中，我们将创建一个表来存储用户的相关信息。我们有 FirstName 和 LastName 的列，并为 FullName（它由 FirstName 与 LastName 串联而成）定义了一个生成的列。英文括号中的 SQL 称为 generation expression。

生成的列可以标记为 STORED，以节省查询时对表达式求值的费用。因此，只有在插入新行或为现有行更新 FirstName 或 LastName 时，系统才会计算 FullName 的值。计算值与表中的其他列一起存储。

GoogleSQL

CREATE TABLE Users ( Id STRING(20) NOT NULL, FirstName STRING(50), LastName STRING(50), Age INT64 NOT NULL, FullName STRING(100) AS (FirstName || ' ' || LastName) STORED ) PRIMARY KEY (Id);

PostgreSQL

CREATE TABLE users ( id VARCHAR(20) NOT NULL, firstname VARCHAR(50), lastname VARCHAR(50), age BIGINT NOT NULL, fullname VARCHAR(100) GENERATED ALWAYS AS (firstname || ' ' || lastname) STORED, PRIMARY KEY(id) );

您可以通过在 DDL 中省略 STORED 属性来创建非存储生成的列。这种类型的生成列会在查询时进行评估，可简化查询。在 PostgreSQL 中，您可以使用 VIRTUAL 属性创建非存储生成列。

GoogleSQL

FullName STRING(MAX) AS (CONCAT(FirstName, " ", LastName))

PostgreSQL

fullname text GENERATED ALWAYS AS (firstname || ' ' || lastname) VIRTUAL

expression 可以是可分配给列数据类型的任何有效 SQL 表达式，但存在以下限制。

表达式只能引用同一表中的列。

表达式不能包含子查询。

包含非确定性函数的表达式（例如 PENDING_COMMIT_TIMESTAMP()、CURRENT_DATE() 和 CURRENT_TIMESTAMP()）无法转换为 STORED 生成的列或已编入索引的生成的列。

您无法修改 STORED 或已编入索引的生成列的表达式。

对于 GoogleSQL 方言数据库，类型为 STRING 或 BYTES 的非存储生成列的长度必须为 MAX。

对于 PostgreSQL 方言数据库，类型为 VARCHAR 的非存储或虚拟生成列的长度必须为 MAX。

表达式后的 STORED 属性会将表达式的结果与表的其他列一起存储。对任何被引用的列的后续更新都将导致 Spanner 重新评估和存储表达式。

非 STORED 的生成列无法标记为 NOT NULL。

不允许直接写入生成的列。

生成的列或生成的列引用的任何列都不允许使用列选项 allow_commit_timestamp。

对于已编入索引的 STORED 或生成的列，您无法更改该列或生成的列引用的任何列的数据类型。

您无法删除生成列引用的列。

您可以将生成的列用作主键，但需遵守以下额外限制：

生成的主键不能引用其他生成的列。

生成的主键最多可以引用一个非键列。

生成的主键不能依赖于带有 DEFAULT 子句的非键列。

使用生成的键列时，请遵循以下规则：

读取 API：您必须完全指定键列，包括生成的键列。

变更 API：对于 INSERT、INSERT_OR_UPDATE 和 REPLACE，Spanner 不允许您指定生成的键列。对于 UPDATE，您可以选择指定生成的键列。对于 DELETE，您需要完全指定键列，包括生成的键。

DML：您无法在 INSERT 或 UPDATE 语句中显式写入生成的键。

查询：通常情况下，我们建议您在查询中使用生成的键列作为过滤条件。（可选）如果生成的键列的表达式仅使用一列作为引用，则查询可以对引用的列应用等式 (=) 或 IN 条件。如需了解详情并查看示例，请参阅创建由值列派生的唯一键。

生成的列可以像任何其他列一样进行查询，如以下示例所示。

GoogleSQL

SELECT Id, FullName FROM Users;

PostgreSQL

SELECT id, fullname FROM users;

使用 Fullname 的查询等效于使用生成的表达式的查询。因此，生成的列可以简化查询。

GoogleSQL

SELECT Id, ARRAY_TO_STRING([FirstName, LastName], " ") as FullName FROM Users;

PostgreSQL

SELECT id, firstname || ' ' || lastname as fullname FROM users;

为生成的列创建索引

您还可以为生成的列编制索引或将其用作外键。

为了帮助查询我们 FullName 生成的列，我们可以创建二级索引，如以下代码段所示。

GoogleSQL

CREATE INDEX UsersByFullName ON Users (FullName);

PostgreSQL

CREATE INDEX UserByFullName ON users (fullname);

将生成的列添加到现有表中

使用以下 ALTER TABLE 语句，我们可以将生成的列添加到 Users 表中以生成并存储用户名的首写字母。

GoogleSQL

ALTER TABLE Users ADD COLUMN Initials STRING(2) AS (ARRAY_TO_STRING([SUBSTR(FirstName, 0, 1), SUBSTR(LastName, 0, 1)], "")) STORED;

PostgreSQL

ALTER TABLE users ADD COLUMN initials VARCHAR(2) GENERATED ALWAYS AS (SUBSTR(firstname, 0, 1) || SUBSTR(lastname, 0, 1)) STORED;

如果您将存储的生成列添加到现有表，系统会启动一个长时间运行的操作来回填列值。回填期间，无法读取或查询存储的列。回填状态会反映在 INFORMATION_SCHEMA 表中。

使用生成的列创建部分索引

如果我们只想查询 18 岁以上的用户，该怎么办？对表进行完整扫描的效率很低，因此我们使用部分索引。

使用以下语句添加另一个生成的列，如果用户年龄超过 18 岁，将返回用户年龄；否则返回 NULL。

GoogleSQL

ALTER TABLE Users ADD COLUMN AgeAbove18 INT64 AS (IF(Age > 18, Age, NULL));

PostgreSQL

ALTER TABLE Users ADD COLUMN AgeAbove18 BIGINT GENERATED ALWAYS AS (nullif( Age , least( 18, Age) )) VIRTUAL;

为该新列创建索引，并使用 GoogleSQL 中的 NULL_FILTERED 关键字或 PostgreSQL 中的 IS NOT NULL 谓词停用对 NULL 值的索引。部分索引比普通索引更小、更高效，因为它排除了年满 18 周岁或不足 18 周岁的所有人。

GoogleSQL

CREATE NULL_FILTERED INDEX UsersAbove18ByAge ON Users (AgeAbove18);

PostgreSQL

CREATE INDEX UsersAbove18ByAge ON users (AgeAbove18) WHERE AgeAbove18 IS NOT NULL;

如需检索所有 18 岁以上的用户的 Id 和 Age，请运行以下查询。

GoogleSQL

SELECT Id, Age FROM Users@{FORCE_INDEX=UsersAbove18ByAge} WHERE AgeAbove18 IS NOT NULL;

PostgreSQL

SELECT Id, Age FROM users /*@ FORCE_INDEX = UsersAbove18ByAge */ WHERE AgeAbove18 IS NOT NULL;

要按不同年龄过滤用户，例如，要检索超过 21 岁的所有用户，请对生成的列使用同一索引和过滤条件，如下所示：

GoogleSQL

SELECT Id, Age FROM Users@{FORCE_INDEX=UsersAbove18ByAge} WHERE AgeAbove18 > 21;

PostgreSQL

SELECT Id, Age FROM users /*@ FORCE_INDEX = UsersAbove18ByAge */ WHERE AgeAbove18 > 21;

与 STORED 生成的列相比，编入索引的生成的列可以节省在查询时对表达式求值的费用，并避免将值存储两次（在基本表和索引中）。

移除生成的列

以下 DDL 语句会从 Users 表中删除生成列：

GoogleSQL

ALTER TABLE Users DROP COLUMN Initials;

PostgreSQL

ALTER TABLE users DROP COLUMN initials;

修改生成的列表达式

GoogleSQL

ALTER TABLE Users ALTER COLUMN FullName STRING(100) AS (ARRAY_TO_STRING(ARRAY_TO_STRING([LastName, FirstName ], " ")));

PostgreSQL

ALTER TABLE users ADD COLUMN Initials VARCHAR(2) GENERATED ALWAYS AS (lastname || ' ' || firstname) VIRTUAL;

不允许更新 STORED 生成列或已编入索引的非存储生成列的表达式。

为生成的列创建主键

在 Spanner 中，您可以在主键中使用 STORED 生成的列。

以下示例展示了使用 ShardId 生成列创建 UserInfoLog 表的 DDL 语句。ShardId 列的值取决于另一列。它是通过对 UserId 列使用 MOD 函数派生而来的。ShardId 声明为主键的一部分。

GoogleSQL

CREATE TABLE UserInfoLog ( ShardId INT64 NOT NULL AS (MOD(UserId, 2048)) STORED, UserId INT64 NOT NULL, FullName STRING(1024) NOT NULL, ) PRIMARY KEY (ShardId, UserId);

PostgreSQL

CREATE TABLE UserInfoLog ( ShardId BIGINT GENERATED ALWAYS AS (MOD(UserId, '2048'::BIGINT)) STORED NOT NULL, UserId BIGINT NOT NULL, FullName VARCHAR(1024) NOT NULL, PRIMARY KEY(ShardId, UserId));

通常，如需高效地访问特定行，您需要指定所有键列。在前面的示例中，这意味着需要提供 ShardId 和 UserId。不过，如果生成的主键列依赖于单个其他列，并且该列的值已完全确定，Spanner 有时可以推断出该主键列的值。如果生成的主键列引用的列满足以下任一条件，则会出现这种情况：

它等于 WHERE 子句中的常量值或绑定参数，或者

其值由 WHERE 子句中的 IN 运算符设置

它会从等值联接条件中获取值

例如，对于以下查询：

GoogleSQL

SELECT * FROM UserInfoLog AS T WHERE T.UserId=1;

PostgreSQL

SELECT * FROM UserInfoLog AS T WHERE T.UserId=1;

Spanner 可以根据提供的 UserId 推断 ShardId 的值。上述查询在经过查询优化后等效于以下查询：

GoogleSQL

SELECT * FROM UserInfoLog AS T WHERE T.ShardId = MOD(1, 2048) AND T.UserId=1;

PostgreSQL

SELECT * FROM UserInfoLog AS T WHERE T.ShardId = MOD(1, 2048) AND T.UserId=1;

以下示例展示了如何创建 Students 表并使用表达式，该表达式检索 StudentInfo JSON 列的 id 字段并将其用作主键：

GoogleSQL

CREATE TABLE Students ( StudentId INT64 NOT NULL AS (INT64(StudentInfo.id)) STORED, StudentInfo JSON NOT NULL, ) PRIMARY KEY (StudentId);

PostgreSQL

CREATE TABLE Students ( StudentId BIGINT GENERATED ALWAYS AS ((StudentInfo ->> 'id')::BIGINT) STORED NOT NULL, StudentInfo JSONB NOT NULL, PRIMARY KEY(StudentId));

查看生成的列的属性

Spanner 的 INFORMATION_SCHEMA 包含有关数据库中的生成的列的信息。以下示例介绍了您在查询信息架构时可以回答的一些问题。

我的数据库中定义了哪些生成的列？

GoogleSQL

SELECT c.TABLE_NAME, c.COLUMN_NAME, C.IS_STORED FROM INFORMATION_SCHEMA.COLUMNS as c WHERE c.GENERATION_EXPRESSION IS NOT NULL;

PostgreSQL

SELECT c.TABLE_NAME, c.COLUMN_NAME, C.IS_STORED FROM INFORMATION_SCHEMA.COLUMNS as c WHERE c.GENERATION_EXPRESSION IS NOT NULL;

IS_STORED 是YES（对于存储的生成列）、NO（对于非存储的生成列）或 NULL（对于非生成列）。

表 Users 中生成的列的当前状态如何？

如果您向现有表添加了生成的列，则可能需要在查询中传递 SPANNER_STATE 以查找该列的当前状态。SPANNER_STATE 会返回以下值：

COMMITTED：该列完全可用。

WRITE_ONLY：正在回填列。不允许读取。

使用以下查询查找列的状态：

GoogleSQL

SELECT c.TABLE_NAME, c.COLUMN_NAME, c.SPANNER_STATE FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.TABLE_NAME="Users" AND c.GENERATION_EXPRESSION IS NOT NULL;

PostgreSQL

SELECT c.TABLE_NAME, c.COLUMN_NAME, c.SPANNER_STATE FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.TABLE_NAME='users' AND c.GENERATION_EXPRESSION IS NOT NULL;

注意：对于非存储的生成列，只能使用 SQL 查询进行访问。不过，如果该列已编入索引，您可以使用读取 API 从索引中访问值。

性能

STORED 生成的列不会影响读取或查询操作的性能。不过，查询中使用的非存储生成的列可能会影响其性能，因为生成的列表达式需要进行评估，这会产生开销。

使用 STORED 生成的列或已编入索引的生成的列时，写入操作（DML 语句和变更）的性能会受到影响。写入操作插入或修改生成的列表达式中引用的任何列时，系统会评估生成的列表达式，因此会产生开销。由于开销因应用的写入工作负载、架构设计和数据集特性而异，因此我们建议您在使用生成的列之前对应用进行基准测试。

后续步骤

详细了解 Spanner 的 GoogleSQL 方言数据库的信息架构和 PostgreSQL 方言数据库的信息架构。

如需详细了解生成的列，请参阅 CREATE TABLE 参数详细信息。

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
