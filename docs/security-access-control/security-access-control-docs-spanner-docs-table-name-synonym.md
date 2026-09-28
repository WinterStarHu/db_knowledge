# 管理表名称  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/table-name-synonym

管理表名称  |  Spanner  |  Google Cloud Documentation

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

管理表名称

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何重命名表，以及如何在 GoogleSQL 方言数据库和 PostgreSQL 方言数据库中添加、使用和删除表同义词。

表重命名和同义词选项

您可以使用 ALTER TABLE 语句执行以下操作：

重命名表并将旧名称添加到同义词中。

交换表名称。

重命名单个表。

创建包含单个同义词的新表。

在不重命名表的情况下向表中添加单个同义词。

使用同义词重命名表的工作原理

一种常见场景是重命名表并添加包含旧表名称的同义词。重命名表后，您可以更新应用，以便在您的时间表中使用新名称。在此期间，有些应用可能会使用旧名称，有些应用可能会使用新名称。

将所有应用都更新为使用新名称后，我们建议您移除同义词。虽然使用同义词不会影响性能，但在同义词被舍弃之前，您无法在其他地方使用旧名称。

同义词以 synonym 对象的形式存储在架构中。一个表只能有一个同义词。

如需了解详情，请参阅重命名表并添加同义词。

表名称交换的工作原理

如果需要在两个表之间交换名称，您可以将 RENAME TO 语句链接在一起，以便在同一语句中重命名两个表。这样，您就可以在不中断的情况下将应用关联到其他表。

如需了解详情，请参阅交换表名称。

表重命名的工作原理

重命名表时，Spanner 会更改表架构中的表名称。重命名表会将所有子表与新表名称交织。表重命名还会更改对以下内容的表的引用：

索引

外键

变更流

精细访问权限控制 (FGAC)

Spanner 不会自动更新视图以使用新表名称。
警告 ：请谨慎重命名表，因为如果有进程引用该表，重命名可能会导致服务中断。您可能会重命名表的一种情况是，在创建表时拼写错误。

如需了解详情，请参阅重命名表。

表重命名限制

表重命名有以下限制：

如果表与另一个表交织，则无法将表重命名为该表中列的名称。

您无法重命名索引。如需更改索引的名称，请先删除该索引，然后使用新名称重新创建索引。

如果表具有视图，您可能需要先删除该视图，然后在重命名表后重新创建视图。

同义词的工作原理

您可以创建包含同义词的新表，也可以修改表以向其中添加同义词，而无需重命名表。您可能需要执行此操作的场景是，您希望在生产环境和测试环境中都使用一个数据库。

如需了解详情，请参阅向表添加同义词。

权限

如需重命名表或为表添加同义词，您需要拥有 spanner.databases.updateDdl 权限。如需查看或修改您的权限，请参阅向主账号授予权限。

重命名表并添加同义词

GoogleSQL 使用 ALTER TABLE RENAME TO ADD SYNONYM 重命名表并添加同义词。

ALTER TABLE table_name RENAME TO new_table_name, ADD SYNONYM table_name;

PostgreSQL 使用 ALTER TABLE RENAME WITH ADD SYNONYM 重命名表并添加同义词。

ALTER TABLE table_name RENAME WITH SYNONYM TO new_table_name;

以下示例展示了如何重命名表并添加同义词。例如，如果您使用以下 DDL 创建表：

GoogleSQL

CREATE TABLE Singers ( SingerId INT64 NOT NULL, SingerName STRING(1024) ), PRIMARY KEY (SingerId);

PostgreSQL

CREATE TABLE singers ( singer_id BIGINT, singer_name VARCHAR(1024), PRIMARY KEY (singer_id));

您可以发出以下 DDL 请求来重命名表，并将现有名称移至 synonym 对象。

GoogleSQL

ALTER TABLE Singers RENAME TO SingersNew, ADD SYNONYM Singers;

PostgreSQL

ALTER TABLE singers RENAME WITH SYNONYM TO singers_new;

交换表名称 警告 ：重命名具有进程引用的表可能会导致服务中断，除非在同一语句中将表名称分配给其他表。

以下 DDL 语句会原子性地更改多个表的名称。在一个或多个表对之间交换名称时，此方法非常有用。

GoogleSQL 使用RENAME TABLE。

RENAME TABLE old_name1 TO new_name1 [,old_name2 TO new_name2 ...];

PostgreSQL 使用ALTER TABLE RENAME TO。

ALTER TABLE [ IF EXISTS ] [ ONLY ] table_name1 RENAME TO new_table_name1 [, ALTER TABLE [ IF EXISTS ] [ ONLY ] table_name2 RENAME TO new_table_name2 ...];

以下示例展示了如何交换两个表的名称。这需要将第一个表重命名为临时名称，将第二个表重命名为第一个表的名称，然后将第一个表重命名为第二个表的名称。

如果您已创建如下所示的两个表：

GoogleSQL

CREATE TABLE Singers ( SingerId INT64 NOT NULL, SingerName STRING(1024) ), PRIMARY KEY (SingerId);

CREATE TABLE SingersNew ( SingerId INT64 NOT NULL, FirstName STRING(1024), MiddleName STRING(1024), LastName STRING(1024) ), PRIMARY KEY (SingerId);

PostgreSQL

CREATE TABLE singers ( singer_id BIGINT, singer_name VARCHAR(1024), PRIMARY KEY (singer_id) );

CREATE TABLE singers_new ( singer_id BIGINT, first_name VARCHAR(1024), middle_name VARCHAR(1024), last_name VARCHAR(1024) PRIMARY KEY (singer_id) );

您可以使用以下 DDL 请求来交换表名称：

GoogleSQL

RENAME TABLE Singers TO Temp, SingersNew TO Singers, Temp TO SingersNew;

PostgreSQL

ALTER TABLE singers RENAME TO temp, ALTER TABLE singers_new RENAME TO singers, ALTER TABLE temp RENAME TO singers_new;

应用 DDL 语句后，表名称会互换，如下所示：

GoogleSQL

CREATE TABLE Singers ( SingerId INT64 NOT NULL, FirstName STRING(1024), MiddleName STRING(1024), LastName STRING(1024) ), PRIMARY KEY (SingerId);

CREATE TABLE SingersNew ( SingerId INT64 NOT NULL, SingerName STRING(1024) ), PRIMARY KEY (SingerId);

PostgreSQL

CREATE TABLE singers ( singer_id BIGINT, first_name VARCHAR(1024), middle_name VARCHAR(1024), last_name VARCHAR(1024) PRIMARY KEY (singer_id) );

CREATE TABLE singers_new ( singer_id BIGINT, singer_name VARCHAR(1024), PRIMARY KEY (singer_id) );

重命名表 警告 ：重命名具有进程引用的表可能会导致服务中断。

如需重命名表，请使用以下语法：

GoogleSQL 使用 ALTER NAME 或 RENAME TABLE 语句。

ALTER TABLE table_name RENAME TO new_table_name;
RENAME TABLE table_name TO new_table_name;

PostgreSQL 使用 ALTER TABLE RENAME TO 语句。

ALTER TABLE [ IF EXISTS ] [ ONLY ] table_name RENAME TO new_table_name;

以下示例展示了用于重命名表的 DDL 请求：

GoogleSQL

RENAME TABLE Singers TO SingersNew;

PostgreSQL

ALTER TABLE singers RENAME TO singers_new;

向表添加同义词

如需向表添加同义词，请执行以下操作：

GoogleSQL

ALTER TABLE table_name ADD SYNONYM synonym;

PostgreSQL

ALTER TABLE [ IF EXISTS ] [ ONLY ] table_name ADD SYNONYM synonym;

以下示例展示了向表中添加同义词的 DDL 请求：

GoogleSQL

ALTER TABLE Singers ADD SYNONYM SingersTest;

PostgreSQL

ALTER TABLE singers ADD SYNONYM singers_test;

创建包含同义词的表

如需创建包含同义词的表，请执行以下操作：

GoogleSQL 使用CREATE TABLE SYNONYM synonym_name。

CREATE TABLE table_name ( ...
SYNONYM (synonym) ) PRIMARY KEY (primary_key);

PostgreSQL 使用CREATE TABLE SYNONYM synonym_name。

CREATE TABLE table_name ( ...
SYNONYM (synonym), PRIMARY KEY (primary_key));

以下示例创建了一个表并添加了同义词。

GoogleSQL

  # The table's name is Singers and the synonym is Artists.
CREATE TABLE Singers ( SingerId INT64 NOT NULL, SingerName STRING(1024), SYNONYM (Artists) ) PRIMARY KEY (SingerId);

PostgreSQL

  # The table's name is singers and the synonym is artists.
CREATE TABLE singers ( singer_id BIGINT, singer_name VARCHAR(1024), SYNONYM (artists), PRIMARY KEY (singer_id));

从表中移除同义词

GoogleSQL 使用 ALTER TABLE DROP SYNONYM 从表中移除同义词。

ALTER TABLE table_name DROP SYNONYM synonym;

PostgreSQL 使用 ALTER TABLE DROP SYNONYM 从表中移除同义词。

ALTER TABLE [ IF EXISTS ] [ ONLY ] table_name DROP SYNONYM synonym;

以下示例展示了从表中删除同义词的 DDL 请求：

GoogleSQL

ALTER TABLE Singers DROP SYNONYM SingersTest;

PostgreSQL

ALTER TABLE singers DROP SYNONYM singers_test;

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
