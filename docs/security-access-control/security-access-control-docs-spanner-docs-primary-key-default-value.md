# 主键默认值管理  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/primary-key-default-value

主键默认值管理  |  Spanner  |  Google Cloud Documentation

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

主键默认值管理

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面讨论了使用默认值表达式在表中生成主键值的策略。本页面中的信息适用于 GoogleSQL 方言数据库和 PostgreSQL 方言数据库。这些策略具有以下优势：

防止出现热点

简化从其他数据库的迁移

将关键逻辑封装在数据库中，以便您不必担心在应用中对该逻辑的管理

在大多数情况下，无需自行创建和管理序列

自动生成主键的方法

如需自动生成主键值，您可以在包含 DEFAULT 表达式的列中使用以下策略：

生成 UUID 版本 4 值的 UUID 函数。

IDENTITY 列，可为键列和非键列自动生成整数值。

PostgreSQL 中的 SERIAL 和 GoogleSQL 中的 AUTO_INCREMENT，它们是 IDENTITY 列的 DDL 别名。

具有 bit_reversed_positive 选项的架构对象 SEQUENCE。SEQUENCE 同时适用于 GoogleSQL 和 PostgreSQL。

通用唯一标识符 (UUID)

Spanner 可以自动生成一个 UUID 版本 4 字符串以用作主键。UUID 非常适合新应用和包含许多行的表。它们大致均匀地分布在整个键空间中，这可防止大规模热点。UUID 生成可以创建大量值 (2122)，并且每个值实际上具有唯一性。例如，对于 50% 的碰撞概率，您需要 2.71×1018 个值，或者每秒生成 10 亿个值，持续 86 年。这样可确保在大型表中使用时获得唯一值。无论是在数据库中还是在客户端中生成 UUID，它们都是唯一的。我们建议您尽可能使用 UUID。如果客户端生成的 UUID 按照 RFC 4122 序列化为小写，则可以在同一表中安全地混合使用客户端生成的 UUID 和 Spanner 生成的 UUID。

对于需要默认值的列，您可以使用 GENERATE_UUID 函数生成它们。以下示例展示了如何创建一个表，其中的 FanId 键列将值列中的 GENERATE_UUID 作为其默认值。该示例为 GoogleSQL STRING 和 PostgreSQL varchar 属性使用 36 个字符，因为 UUID 包含 36 个字符。当您使用 INSERT with THEN RETURN 语句插入到 Fans 表中时，GENERATE_UUID 会为 FanId 生成并返回 UUID 值。

GoogleSQL

CREATE TABLE Fans ( FanId STRING(36) DEFAULT (GENERATE_UUID()), Name STRING(MAX), ) PRIMARY KEY (FanId);

PostgreSQL

CREATE TABLE Fans ( FanId varchar(36) DEFAULT spanner.generate_uuid(), Name text, PRIMARY KEY (FanId) );

GoogleSQL

INSERT INTO Fans (Name) VALUES ('Melissa Garcia') THEN RETURN FanId;

PostgreSQL

INSERT INTO fans (name) VALUES ('Melissa Garcia') RETURNING (fanid);

此语句会返回类似于以下内容的结果：

FanId

6af91072-f009-4c15-8c42-ebe38ae83751

如需详细了解 GENERATE_UUID() 函数，请参阅 GoogleSQL 或 PostgreSQL 参考页面。

IDENTITY 列

借助 IDENTITY 列，您可以为键列和非键列自动生成整数值。IDENTITY 列不需要用户手动维护底层序列，也不需要管理列与底层序列之间的关系。当自动生成的标识列被舍弃时，底层序列也会自动删除。

您可以通过在生成序列时提供起始整数值，或者让 Spanner 为您生成整数序列，来使用 IDENTITY 列。如需提供起始整数值，您必须使用 START COUNTER WITH 选项，并使用正数 INT64 起始值。Spanner 使用此值为其自动生成的内部序列计数器生成下一个值，并在将该值插入此列之前对其进行位反转。

在 Spanner 中，GoogleSQL 和 PostgreSQL 都支持 IDENTITY 列。

GoogleSQL 以下示例展示了如何在使用 CREATE TABLE 命令创建新表时，使用 IDENTITY 列为 SingerId 创建自动生成的整数主键列：

CREATE TABLE Singers ( SingerId INT64 GENERATED BY DEFAULT AS IDENTITY (BIT_REVERSED_POSITIVE), Name STRING(MAX), Rank INT64 ) PRIMARY KEY (SingerId);

您还可以使用 START_WITH_COUNTER 选项为列指定计数器起始值。在以下示例中，为 SingerId 创建了一个自动生成的整数列，该列具有位反转正值和一个从 1,000 开始的内部计数器。

CREATE TABLE Singers ( SingerId INT64 GENERATED BY DEFAULT AS IDENTITY (BIT_REVERSED_POSITIVE START COUNTER WITH 1000), Name STRING(MAX), Rank INT64 ) PRIMARY KEY (SingerId);

PostgreSQL 以下示例展示了如何在使用 CREATE TABLE 命令创建新表时，使用 IDENTITY 列为 SingerId 创建自动生成的整数列：

CREATE TABLE Singers ( SingerId bigint GENERATED BY DEFAULT AS IDENTITY (BIT_REVERSED_POSITIVE), Name text, PRIMARY KEY (SingerId) );

您还可以使用 START COUNTER WITH 选项为列指定计数器起始值。在以下示例中，为 SingerId 创建了一个自动生成的整数列，该列会生成位反转正值，并且在位反转之前，内部计数器从 1,000 开始。

CREATE TABLE Singers ( SingerId bigint GENERATED BY DEFAULT AS IDENTITY (BIT_REVERSED_POSITIVE START COUNTER WITH 1000), Name text, PRIMARY KEY (SingerId) );

SERIAL和AUTO_INCREMENT之间

Spanner 支持 PostgreSQL 中的 SERIAL 和 GoogleSQL 中的 AUTO_INCREMENT，它们是 IDENTITY 列的 DDL 别名，用于创建唯一的整数列。您必须先设置数据库 default_sequence_kind 选项，然后才能使用 SERIAL 或 AUTO_INCREMENT。您可以使用以下 SQL 语句设置数据库 default_squence_kind 选项：

GoogleSQL

ALTER DATABASE db SET OPTIONS (default_sequence_kind = 'bit_reversed_positive');

CREATE TABLE Singers ( id INT64 AUTO_INCREMENT PRIMARY KEY, name STRING(MAX), )

PostgreSQL

ALTER DATABASE db SET spanner.default_sequence_kind = 'bit_reversed_positive';

CREATE TABLE Singers ( id serial PRIMARY KEY, name text );

请注意，由于 SERIAL 和 AUTO_INCREMENT 映射到 IDENTITY 列，因此在序列化架构时，您不会看到它们。对于此架构，GetDatabaseDDL 的输出会是：

GoogleSQL

ALTER DATABASE db SET OPTIONS (default_sequence_kind = 'bit_reversed_positive');

CREATE TABLE Singers ( id INT64 GENERATED BY DEFAULT AS IDENTITY, name STRING(MAX), ) PRIMARY KEY (id);

PostgreSQL

ALTER DATABASE db SET spanner.default_sequence_kind = 'bit_reversed_positive';

CREATE TABLE Singers ( id bigint GENERATED BY DEFAULT AS IDENTITY NOT NULL, name character varying, PRIMARY KEY(id) );

位反转序列

位反转序列是一种架构对象，用于生成整数序列并对其进行位反转。此对象对专用内部 Spanner 计数器使用位反转，以确保唯一性。生成的位反转值在用于主键时，有助于避免大规模热点。

在 Spanner 中，您可以使用 SEQUENCE DDL 语句以及 bit_reversed_positive 属性来创建、更改或删除生成位反转正值的序列（GoogleSQL 或 PostgreSQL）。

每个序列都会维护一组内部计数器，并使用这些计数器生成值。序列计数器为位反转算法提供输入。

当您使用将 GoogleSQL GET-NEXT-SEQUENCE-VALUE 或 PostgreSQL nextval 函数用作默认值的 DEFAULT 表达式定义列时，Spanner 会自动调用相应函数，并将位反转输出值放入该列中。位反转序列对于主键尤其有用，因为位反转值在整个键空间中均匀分布，因此不会导致热点。

以下示例展示了如何创建一个位反转序列，以及其中的键列使用该序列作为默认值的表：

GoogleSQL

CREATE SEQUENCE SingerIdSequence OPTIONS ( sequence_kind="bit_reversed_positive" );

CREATE TABLE Singers ( SingerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(SEQUENCE SingerIdSequence)), Name STRING(MAX), Rank INT64, ) PRIMARY KEY (SingerId);

PostgreSQL

CREATE SEQUENCE SingerIdSequence bit_reversed_positive;

CREATE TABLE Singers ( SingerId bigint DEFAULT nextval('SingerIdSequence'), Name text, PRIMARY KEY (SingerId) );

然后，您可以使用以下 SQL 语句插入并返回主键值：

GoogleSQL

INSERT INTO Singers (Name) VALUES ('Melissa Garcia') THEN RETURN SingerId;

PostgreSQL

INSERT INTO Singers (name) VALUES ('Melissa Garcia') RETURNING (SingerId);

此语句会返回类似于以下内容的结果：

SingerId

3458764513820540928

使用 UUID 和序列作为主键默认值的场景

适用于 UUID 和序列的场景包括：

新应用

迁移

以下部分将分别介绍每种场景。

新应用

如果您的现有应用需要 GoogleSQL 中的 INT64 键或 PostgreSQL 中的 bigint 键，Spanner 提供了位反转正值序列架构对象（PostgreSQL 或 GoogleSQL）。否则，对于新应用，我们建议您使用通用唯一标识符 (UUID)。如需了解详情，请参阅使用通用唯一标识符 (UUID)。

迁移

对于将表迁移到 Spanner，您有以下几种选择：

如果您在源数据库中使用 UUID，则在 Spanner 上，您可以使用 STRING 类型的键列并将 GENERATE_UUID() 函数（GoogleSQL 或 PostgreSQL）作为其默认值。

如果您使用的是整数主键，并且您的应用只需要键是唯一的，那么您可以在 INT64 中使用键列，并使用位反转正值序列作为主键的默认值。请参阅迁移位反转键列。

Spanner 不支持生成单调值。

如果您使用的是单调键（例如 PostgreSQL SERIAL 类型或 MySQL AUTO_INCREMENT 属性），并且需要在 Spanner 上使用新的单调键，则可以使用复合键。如需了解详情，请参阅交换键的顺序和对唯一键进行哈希处理并将写入分布到逻辑分片中。

如果您的应用手动对 INT64 键（GoogleSQL 中）或 bigint 键（PostgreSQL 中）进行位反转，您可以使用位反转正值序列（GoogleSQL 或 PostgreSQL），让它为您生成新的键值。如需了解详情，请参阅迁移位反转键列。

后续步骤

详细了解如何将序列与精细访问权限控制搭配使用。

了解 GoogleSQL 或 PostgreSQL 的 DDL SEQUENCE 语句。

了解 GoogleSQL 或 PostgreSQL 中的序列函数。

了解 GoogleSQL 或 PostgreSQL 的 INFORMATION_SCHEMA 中的序列。

了解 GoogleSQL 的 INFORMATION_SCHEMA 中的序列选项。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-23。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-23。"],[],[]]

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
