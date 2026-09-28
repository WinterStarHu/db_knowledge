# PGAdapter 会话管理命令  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/pgadapter-session-mgmt-commands

PGAdapter 会话管理命令  |  Spanner  |  Google Cloud Documentation

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

PGAdapter 会话管理命令

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

Spanner PGAdapter 支持会话管理语句，让您可以修改连接的状态和行为、执行事务并高效执行批量语句。本文档中描述的所有语句都可以与连接到 PGAdapter 的任何客户端或驱动程序搭配使用。

如需了解详情，请参阅受支持的 PostgreSQL 驱动程序和 ORM 的完整列表。以下命令适用于 PostgreSQL 方言数据库。

如需详细了解如何使用 PGAdapter，请参阅启动 PGAdapter。

连接语句

以下语句会更改或显示当前连接的属性。

SPANNER.READONLY

一个布尔值，指示连接是否处于只读模式。默认为 false。

SHOW [VARIABLE] SPANNER.READONLY SET SPANNER.READONLY {TO|=} { true | false }

仅当没有活跃事务时，您才能更改此属性的值。

▶ 示例：只读事务（点击可展开）

以下示例展示了如何使用此属性在 Spanner 中执行只读事务。

SET SPANNER.READONLY = TRUE;
-- This transaction is a read-only transaction.
BEGIN TRANSACTION;

-- The following two queries both use the read-only transaction.
SELECT first_name, last_name FROM singers ORDER BY last_name;

SELECT first_name, last_name FROM albums ORDER BY title;

-- This shows the read timestamp that was used for the two queries.
SHOW SPANNER.READ_TIMESTAMP;

-- This marks the end of the read-only transaction. The next statement will -- start a new read-only transaction.
COMMIT;

AUTOCOMMIT

一个布尔值，用于指示连接是否处于自动提交模式。默认为 true。

NOTE：将 PostgreSQL 驱动程序与 PGAdapter 搭配使用时，您通常不需要修改此变量的值。这些驱动程序会在必要时执行 BEGIN 和 COMMIT，从而自动为您管理事务。使用 psql 等命令行工具时，您可以关闭 autocommit，以防止自动提交意外的数据修改。

SHOW [VARIABLE] AUTOCOMMIT SET AUTOCOMMIT {TO|=} { true | false }

仅当没有活跃事务时，您才能更改此属性的值。

当 AUTOCOMMIT 设置为 false 时，在您执行 COMMIT 或 ROLLBACK 后，系统会自动启动新事务。您执行的第一个语句会启动事务。

▶ 示例：自动提交（点击可展开）

以下示例展示了如何使用 autocommit 属性。

-- The default value for AUTOCOMMIT is true.
SHOW AUTOCOMMIT;

-- This insert statement is automatically committed after it is executed, as -- the connection is in autocommit mode.
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);

-- Turning off autocommit means that a new transaction is automatically started -- when the next statement is executed.
SET AUTOCOMMIT = FALSE;
-- The following statement starts a new transaction.
INSERT INTO T (id, col_a, col_b) VALUES (2, 200, 2);

-- This statement uses the same transaction as the previous statement.
INSERT INTO T (id, col_a, col_b) VALUES (3, 300, 3);

-- Commit the current transaction with the two INSERT statements.
COMMIT;

-- Transactions can also be executed in autocommit mode by executing the BEGIN -- statement.
SET AUTOCOMMIT = TRUE;

-- Execute a transaction while in autocommit mode.
BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (4, 400, 4);
INSERT INTO T (id, col_a, col_b) VALUES (5, 500, 5);
COMMIT;

SPANNER.RETRY_ABORTS_INTERNALLY

布尔值，指示连接是否自动重试已中止的事务。默认值为 true。

SHOW [VARIABLE] SPANNER.RETRY_ABORTS_INTERNALLY SET SPANNER.RETRY_ABORTS_INTERNALLY {TO|=} { true | false }

只有在事务开始后（请参阅 BEGIN [TRANSACTION | WORK]）且在事务内执行任何语句之前，才能执行此命令。

启用 SPANNER.RETRY_ABORTS_INTERNALLY 后，连接会保留连接返回给客户端应用的所有数据的校验和。这用于在事务被 Spanner 中止时重试事务。

此设置默认为启用状态。如果您已经在应用中重试中止的事务，我们建议您停用此设置。

SPANNER.AUTOCOMMIT_DML_MODE

一个 STRING 属性，用于指示数据操纵语言 (DML) 语句的自动提交模式。

SHOW [VARIABLE] SPANNER.AUTOCOMMIT_DML_MODE SET SPANNER.AUTOCOMMIT_DML_MODE {TO|=} { 'TRANSACTIONAL' | 'PARTITIONED_NON_ATOMIC' }

可能的值包括：

在 TRANSACTIONAL 模式下，驱动程序将 DML 语句作为单独的原子化事务执行。驱动程序会创建新事务、执行 DML 语句，并在成功执行后提交事务，或在发生错误时回滚事务。

在 PARTITIONED_NON_ATOMIC 模式下，驱动程序将 DML 语句作为分区更新语句执行。分区更新语句可以作为一系列多个事务运行，每个事务均涵盖一部分受影响的行。分区语句会提供弱化语义，从而换取更高的可伸缩性和性能。

默认值为 TRANSACTIONAL。

▶ 示例：分区 DML（点击可展开）

以下示例展示了如何使用 PGAdapter 执行分区 DML。

-- Change autocommit DML mode to use Partitioned DML.
SET SPANNER.AUTOCOMMIT_DML_MODE = 'PARTITIONED_NON_ATOMIC';

-- Delete all singers that have been marked as inactive.
-- This statement is executed using Partitioned DML.
DELETE FROM singers WHERE active=false;

-- Change DML mode back to standard `TRANSACTIONAL`.
SET SPANNER.AUTOCOMMIT_DML_MODE = 'TRANSACTIONAL';

STATEMENT_TIMEOUT

类型为 STRING 的属性，用于指示语句的当前超时值。

SHOW [VARIABLE] STATEMENT_TIMEOUT SET STATEMENT_TIMEOUT {TO|=} { '{ s | ms | us | ns }' |  | DEFAULT }

int8 值为一个整数，后跟表示时间单位的后缀。值 DEFAULT 表示未设置超时值。如果已设置语句超时值，则超过指定超时值的语句将导致超时错误并使事务失效。

受支持的时间单位包括：

s：秒

ms：毫秒

us：微秒

ns：纳秒

DEFAULT 为 0 秒，表示不超时。不带单位的 int8 数值表示 int8 ms。例如，以下两个命令都将语句超时设置为 2 秒。

SET STATEMENT_TIMEOUT TO 2000;
SET STATEMENT_TIMEOUT TO '2s';

事务期间语句超时会使事务失效，失效事务中的所有后续语句（ROLLBACK 除外）均会失败。

READ_ONLY_STALENESS

类型为 STRING 的属性，用于指示 Spanner 用于只读事务和 AUTOCOMMIT 模式下的查询的当前只读过时设置。

SHOW [VARIABLE] SPANNER.READ_ONLY_STALENESS SET SPANNER.READ_ONLY_STALENESS {TO|=} staleness_type

staleness_type:

{ 'STRONG'
  | 'MIN_READ_TIMESTAMP timestamp'
  | 'READ_TIMESTAMP timestamp'
  | 'MAX_STALENESS { s | ms | us | ns }'
  | 'EXACT_STALENESS { s | ms | us | ns }' }

只读过时值会应用于所有后续的只读事务以及 AUTOCOMMIT 模式下的所有查询。

默认值为 STRONG。

时间戳边界选项如下所示：

STRONG 指示 Spanner 执行强读取。

MAX_STALENESS 定义 Spanner 相对于 now() 执行有界限过时数据读取的时间间隔。

MIN_READ_TIMESTAMP 定义 Spanner 用于执行有界限过时数据读取的绝对时间。

EXACT_STALENESS 定义 Spanner 相对于 now() 执行精确过时数据读取的时间间隔。

READ_TIMESTAMP 定义 Spanner 执行精确过时数据读取的绝对时间。

时间戳必须采用以下格式：

YYYY-[M]M-[D]D [[H]H:[M]M:[S]S[.DDDDDD]][timezone]

设置 MAX_STALENESS 和 EXACT_STALENESS 值所支持的时间单位包括：

s：秒

ms：毫秒

us：微秒

ns：纳秒

仅当没有活跃事务时，您才能修改此属性的值。
注意：您只能对 AUTOCOMMIT 模式下的查询使用值 MIN_READ_TIMESTAMP 和 MAX_STALENESS。

▶ 示例：只读过时（点击可展开）

以下示例展示了如何使用 PGAdapter 使用自定义过期值执行查询。

-- Set the read-only staleness to MAX_STALENESS 10 seconds.
SET SPANNER.READ_ONLY_STALENESS = 'MAX_STALENESS 10s';

-- Execute a query in auto-commit mode. This will return results that are up to -- 10 seconds stale.
SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Read-only staleness can also be applied to read-only transactions.
-- MAX_STALENESS is however only allowed for queries in autocommit mode.
-- Change the staleness to EXACT_STALENESS and start a read-only transaction.
SET SPANNER.READ_ONLY_STALENESS = 'EXACT_STALENESS 10s';
BEGIN;
SET TRANSACTION READ ONLY;

SELECT first_name, last_name FROM singers ORDER BY last_name;

SELECT title, singer_id FROM albums ORDER BY title;

COMMIT;

-- Read staleness can also be an exact timestamp.
SET SPANNER.READ_ONLY_STALENESS = 'READ_TIMESTAMP 2024-01-26T10:36:00Z';

SELECT first_name, last_name FROM singers ORDER BY last_name;

SPANNER.OPTIMIZER_VERSION

类型为 STRING 的属性，用于指示优化器版本。版本可以是数字，也可以是“LATEST”。

SHOW [VARIABLE] SPANNER.OPTIMIZER_VERSION SET SPANNER.OPTIMIZER_VERSION {TO|=} { 'version'|'LATEST'|'' }

为连接中的所有后续语句设置要使用的优化器版本。将优化器版本设置为 ''（空字符串）表示使用最新版本。如果未设置优化器版本，Spanner 会使用在数据库级层设置的优化器版本。

默认值为 ''。

▶ 示例：优化器版本（点击可展开）

以下示例展示了如何通过 PGAdapter 使用特定的优化器版本执行查询。

-- Set the optimizer version to 5 and execute a query.
SET SPANNER.OPTIMIZER_VERSION = '5';

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Execute the same query with the latest optimizer version.
SET SPANNER.OPTIMIZER_VERSION = 'LATEST';

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Revert back to using the default optimizer version that has been set for the -- database.
SET SPANNER.OPTIMIZER_VERSION = '';

SELECT first_name, last_name FROM singers ORDER BY last_name;

SPANNER.OPTIMIZER_STATISTICS_PACKAGE

类型为 STRING 的属性，用于指示此连接使用的当前优化器统计信息软件包。

SHOW [VARIABLE] SPANNER.OPTIMIZER_STATISTICS_PACKAGE SET SPANNER.OPTIMIZER_STATISTICS_PACKAGE {TO|=} { 'package'|'' }

为连接中的所有后续语句设置要使用的优化器统计信息软件包。 必须是有效的软件包名称。如果未设置优化器统计信息软件包，Spanner 会使用在数据库级别设置的优化器统计信息软件包。

默认值为 ''。

▶ 示例：优化器统计信息软件包（点击可展开）

以下示例展示了如何通过 PGAdapter 使用特定的优化器统计信息软件包执行查询。

-- Show the available optimizer statistics packages in this database.
SELECT * FROM INFORMATION_SCHEMA.SPANNER_STATISTICS;

-- Set the optimizer statistics package and execute a query.
SET SPANNER.OPTIMIZER_STATISTICS_PACKAGE = 'auto_20240124_06_47_29UTC';

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Execute the same query with the default optimizer statistics package.
SET SPANNER.OPTIMIZER_VERSION = '';

SELECT first_name, last_name FROM singers ORDER BY last_name;

SPANNER.RETURN_COMMIT_STATS

类型为 BOOL 的属性，用于指示是否应针对此连接中的事务返回统计信息。您可以通过执行 SHOW [VARIABLE] COMMIT_RESPONSE 命令来查看返回的统计信息。

SHOW [VARIABLE] SPANNER.RETURN_COMMIT_STATS SET SPANNER.RETURN_COMMIT_STATS {TO|=} { true | false }

默认值为 false。

▶ 示例：提交统计信息（点击可展开）

以下示例展示了如何使用 PGAdapter 查看事务的提交统计信息。

-- Enable the returning of commit stats.
SET SPANNER.RETURN_COMMIT_STATS = true;

-- Execute a transaction.
BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1), (2, 200, 2), (3, 300, 3);
COMMIT;

-- View the commit response with the transaction statistics for the last -- transaction that was committed.
SHOW SPANNER.COMMIT_RESPONSE;

SPANNER.RPC_PRIORITY

类型为 STRING 的属性，用于指示 Spanner 请求的相对优先级。优先级充当 Spanner 调度器的提示，并不保证执行顺序。

SHOW [VARIABLE] SPANNER.RPC_PRIORITY SET SPANNER.RPC_PRIORITY {TO|=} {'HIGH'|'MEDIUM'|'LOW'|'NULL'}

'NULL' 表示请求中不应包含任何提示。

默认值为 'NULL'。

您还可以使用语句提示来指定 RPC 优先级：

/*@RPC_PRIORITY=PRIORITY_LOW*/ SELECT * FROM Albums

如需了解详情，请参阅 Priority。

事务语句

以下语句用于管理和提交 Spanner 事务。

TRANSACTION ISOLATION LEVEL

SHOW [ VARIABLE ] TRANSACTION ISOLATION LEVEL

返回一个结果集，其中包含 STRING 类型的一行和一列。返回值始终为 serializable，因为这是 Spanner PostgreSQL 方言数据库唯一支持的隔离级别。

SPANNER.READ_TIMESTAMP

SHOW [VARIABLE] SPANNER.READ_TIMESTAMP

返回一个结果集，其中包含 TIMESTAMP 类型的一行和一列，该结果集包括最近一次只读事务的读取时间戳。只有在只读事务仍处于活跃状态并且已执行至少一个查询时，或者只有在紧接着已提交只读事务之后且新事务启动之前，此语句才会返回时间戳。否则，结果为 NULL。

▶ 示例：读取时间戳（点击可展开）

以下示例展示了如何使用 PGAdapter 查看只读操作的最后读取时间戳。

-- Execute a query in autocommit mode using the default read-only staleness -- (strong).
SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Shows the read timestamp that was used for the previous query.
SHOW SPANNER.READ_TIMESTAMP;

-- Set a non-deterministic read-only staleness and execute the same query.
SET SPANNER.READ_ONLY_STALENESS = 'MAX_STALENESS 20s';

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Shows the read timestamp that was used for the previous query. The timestamp -- is determined by Spanner, and is guaranteed to be no less than 20 -- seconds stale.
SHOW SPANNER.READ_TIMESTAMP;

-- The read timestamp of a read-only transaction can also be retrieved.
SET SPANNER.READ_ONLY_STALENESS = 'STRONG';
BEGIN;
SET TRANSACTION READ ONLY;

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Shows the read timestamp of the current read-only transaction. All queries in -- this transaction will use this read timestamp.
SHOW SPANNER.READ_TIMESTAMP;

SELECT title FROM albums ORDER BY title;

-- The read timestamp is the same as for the previous query, as all queries in -- the same transaction use the same read timestamp.
SHOW SPANNER.READ_TIMESTAMP;

COMMIT;

SPANNER.COMMIT_TIMESTAMP

SHOW [VARIABLE] SPANNER.COMMIT_TIMESTAMP

返回一个结果集，其中包含 TIMESTAMP 类型的一行和一列，该结果集包括 Spanner 提交的最近一次读写事务的提交时间戳。只有当您在提交读写事务之后、执行任何后续 SELECT、DML 或架构更改语句之前执行此语句时，此语句才会返回时间戳。否则，结果为 NULL。

▶ 示例：提交时间戳（点击可展开）

以下示例展示了如何使用 PGAdapter 查看写入操作的最后提交时间戳。

-- Execute a DML statement.
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1), (2, 200, 2), (3, 300, 3);

-- Show the timestamp that the statement was committed.
SHOW SPANNER.COMMIT_TIMESTAMP;

SPANNER.COMMIT_RESPONSE

SHOW [VARIABLE] SPANNER.COMMIT_RESPONSE

返回一个结果集，其中包含一行和两列：

COMMIT_TIMESTAMP（类型为 TIMESTAMP）表示最近一次事务提交的时间。

MUTATION_COUNT（类型为 int8）：指示在提交的事务中应用的变更数量。在模拟器上执行时，此值始终为空。

仅当在事务提交之前将 SET RETURN_COMMIT_STATS 设置为 true 时，才会提供变更计数。

▶ 示例：提交响应（点击可展开）

以下示例展示了如何使用 PGAdapter 查看写入操作的最后提交响应。

-- Enable returning commit stats in addition to the commit timestamp.
SET SPANNER.RETURN_COMMIT_STATS = true;

-- Execute a DML statement.
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1), (2, 200, 2), (3, 300, 3);

-- Show the timestamp that the statement was committed.
SHOW SPANNER.COMMIT_RESPONSE;

{ START | BEGIN } [ TRANSACTION | WORK ]

{ START | BEGIN } [ TRANSACTION | WORK ] [{ READ ONLY | READ WRITE }]

启动新事务。 关键字 TRANSACTION 和 WORK 是可选且等效的，不会产生任何影响。

使用 COMMIT 或 ROLLBACK 可终止事务。

如果您启用了 AUTOCOMMIT 模式，则此语句会暂时将连接退出 AUTOCOMMIT 模式。当事务结束时，连接将返回 AUTOCOMMIT 模式。

如果未指定 READ ONLY 或 READ WRITE，则事务模式由会话的默认事务模式确定。此默认值使用 SET SESSION CHARACTERISTICS AS TRANSACTION 命令设置。

只有在没有活跃事务的情况下您才能执行此语句。

▶ 示例：开始事务（点击可展开）

以下示例展示了如何使用 PGAdapter 启动不同类型的事务。

-- This starts a transaction using the current defaults of this connection.
-- The value of SPANNER.READONLY determines whether the transaction is a -- read/write or a read-only transaction.

BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);
COMMIT;

-- Set SPANNER.READONLY to TRUE to use read-only transactions by default.
SET SPANNER.READONLY=TRUE;

-- This starts a read-only transaction.
BEGIN;
SELECT first_name, last_name FROM singers ORDER BY last_name;
COMMIT;

-- Use the 'READ WRITE' or 'READ ONLY' qualifier in the BEGIN statement to -- override the current default of the connection.
SET SPANNER.READONLY=FALSE;
BEGIN READ ONLY;
SELECT first_name, last_name FROM singers ORDER BY last_name;
COMMIT;

COMMIT [TRANSACTION | WORK]

COMMIT [TRANSACTION | WORK]

提交当前事务。关键字 TRANSACTION 和 WORK 是可选且等效的，不会产生任何影响。

提交读写事务会使此事务的所有更新对其他事务可见，并解除对 Spanner 的所有事务锁定。

提交只读事务会结束当前的只读事务。
任何后续语句都会启动新事务。对于只读事务，COMMIT 和 ROLLBACK 之间没有语义差异。

只有在存在活跃事务的情况下才能执行此语句。

▶ 示例：提交事务（点击可展开）

以下示例展示了如何使用 PGAdapter 提交事务。

-- Execute a regular read/write transaction.
BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);
COMMIT;

-- Execute a read-only transaction. Read-only transactions also need to be -- either committed or rolled back in PGAdapter in order to mark the -- end of the transaction.
BEGIN READ ONLY;
SELECT first_name, last_name FROM singers ORDER BY last_name;
COMMIT;

ROLLBACK [TRANSACTION | WORK]

ROLLBACK [TRANSACTION | WORK]

对当前事务执行 ROLLBACK。 关键字 TRANSACTION 和 WORK 是可选的，并且是等效的，不会产生任何影响。

对读写事务执行 ROLLBACK 操作会清除所有缓存的变更，在 Spanner 上回滚该事务，并解除该事务持有的所有锁定。

对只读事务执行 ROLLBACK 会结束当前的只读事务。任何后续语句都会启动新事务。
对于连接上的只读事务，COMMIT 和 ROLLBACK 之间没有语义差异。

只有在存在活跃事务的情况下才能执行此语句。

▶ 示例：回滚事务（点击可展开）

以下示例展示了如何使用 PGAdapter 回滚事务。

-- Use ROLLBACK to undo the effects of a transaction.
BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);
-- This will ensure that the insert statement is not persisted in the database.
ROLLBACK;

-- Read-only transactions also need to be either committed or rolled back in -- PGAdapter in order to mark the end of the transaction. There is no -- semantic difference between rolling back or committing a read-only -- transaction.
BEGIN READ ONLY;
SELECT first_name, last_name FROM singers ORDER BY last_name;
ROLLBACK;

SET TRANSACTION

SET TRANSACTION { READ ONLY | READ WRITE }

设置当前事务的事务模式。

只有在 AUTOCOMMIT 为 false 时，或者已通过执行 BEGIN [TRANSACTION | WORK] 来启动事务并且尚未在该事务中执行任何语句的情况下，才能执行此语句。

此语句仅为当前事务设置事务模式。当事务提交或回滚时，下一个事务将使用连接的默认模式。（请参阅 SET SESSION CHARACTERISTICS。） 注意：如果连接处于 READ ONLY 模式，则您无法将事务模式设置为 READ WRITE。

▶ 示例：设置事务（点击可展开）

以下示例展示了如何使用 PGAdapter 设置事务特征。

-- Start a transaction and set the transaction mode to read-only.
BEGIN;
SET TRANSACTION READ ONLY;

SELECT first_name, last_name FROM singers ORDER BY last_name;

-- Commit the read-only transaction to mark the end of the transaction.
COMMIT;

-- Start a transaction and set the transaction mode to read/write.
BEGIN;
SET TRANSACTION READ WRITE;

INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);

COMMIT;

设置会话特征

SET SESSION CHARACTERISTICS AS TRANSACTION { READ ONLY | READ WRITE }

将相应会话中事务的默认事务模式设置为 READ ONLY 或 READ WRITE。只有在没有活跃事务的情况下，系统才会允许使用此语句。

SET TRANSACTION 命令可以覆盖此设置。

▶ 示例：设置会话特征（点击可展开）

以下示例展示了如何使用 PGAdapter 设置会话特征。

-- Set the default transaction mode to read-only.
SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;

-- This will now start a read-only transaction.
BEGIN;
SELECT first_name, last_name FROM singers ORDER BY last_name;
COMMIT;

-- You can override the default transaction mode with the SET TRANSACTION -- statement.
SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;
BEGIN;
SET TRANSACTION READ ONLY;
SELECT first_name, last_name FROM singers ORDER BY last_name;
COMMIT;

SPANNER.STATEMENT_TAG

类型为 STRING 的属性，其中包含下一个语句的请求标记。

SHOW [ VARIABLE ] SPANNER.STATEMENT_TAG SET SPANNER.STATEMENT_TAG {TO|=} 'tag-name'

为要执行的下一个语句设置请求标记。每个语句只能设置一个标记。该标记不会跨越多个语句；必须按语句进行设置。可以通过将请求标记设置为空字符串 ('') 来移除该标记。

默认值为 ''。

您可以为同一语句设置事务标记和语句标记。

您还可以使用语句提示添加语句标记：

/*@STATEMENT_TAG='my-tag'*/ SELECT * FROM albums

如需了解详情，请参阅排查请求标记和事务标记问题。

▶ 示例：语句标记（点击展开）

以下示例展示了如何使用 PGAdapter 设置语句标记。

-- Set the statement tag that should be included with the next statement.
SET SPANNER.STATEMENT_TAG = 'tag1';
SELECT first_name, last_name FROM singers ORDER BY last_name;

-- The statement tag property is cleared after each statement execution.
SHOW SPANNER.STATEMENT_TAG;
-- Set another tag for the next statement.
SET SPANNER.STATEMENT_TAG = 'tag2';
SELECT title FROM albums ORDER BY title;

-- Set a statement tag with a query hint.
/*@STATEMENT_TAG='tag3'*/ SELECT track_number, title FROM tracks WHERE album_id=1 AND singer_id=1 ORDER BY track_number;

SPANNER.TRANSACTION_TAG

类型为 STRING 的属性，其中包含下一个事务的标记。

SHOW [ VARIABLE ] SPANNER.TRANSACTION_TAG SET SPANNER.TRANSACTION_TAG {TO|=} 'tag-name'

为要执行的当前事务设置事务标记。每个事务只能设置一个标记。该标记不会跨越多个事务；必须按事务进行设置。可以通过将事务标记设置为空字符串 ('') 来移除该标记。必须在事务中执行任何语句之前设置事务标记。

默认值为 ''。

您可以为同一语句设置事务标记和语句标记。

如需了解详情，请参阅排查请求标记和事务标记问题。

▶ 示例：事务标记（点击可展开）

以下示例展示了如何使用 PGAdapter 设置事务标记。

BEGIN;
-- Set the transaction tag for the current transaction.
SET SPANNER.TRANSACTION_TAG = 'transaction-tag-1';

-- Set the statement tag that should be included with the next statement.
-- The statement will include both the statement tag and the transaction tag.
SET SPANNER.STATEMENT_TAG = 'select-statement';
SELECT first_name, last_name FROM singers ORDER BY last_name;

-- The statement tag property is cleared after each statement execution.
SHOW SPANNER.STATEMENT_TAG;

-- Set another tag for the next statement.
SET SPANNER.STATEMENT_TAG = 'insert-statement';
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);

COMMIT;

-- The transaction tag property is cleared when the transaction finishes.
SHOW SPANNER.TRANSACTION_TAG;

批量语句

以下语句用于管理批量 DDL 语句并将这些批量 DDL 语句发送到 Spanner。

START BATCH DDL

START BATCH DDL

在连接上启动一批 DDL 语句。批处理期间的所有后续语句都必须是 DDL 语句。DDL 语句在本地缓存，并在执行 RUN BATCH 时作为一个批次发送到 Spanner。将多个 DDL 语句作为一个批次执行通常比单独运行语句速度快。

只有在没有活跃事务的情况下您才能执行此语句。

▶ 示例：DDL 批处理（点击展开）

以下示例展示了如何使用 PGAdapter 执行 DDL 批处理。

-- Start a DDL batch. All following statements must be DDL statements.
START BATCH DDL;

-- This statement is buffered locally until RUN BATCH is executed.
CREATE TABLE singers ( id bigint primary key, first_name varchar, last_name varchar );

-- This statement is buffered locally until RUN BATCH is executed.
CREATE TABLE albums ( id bigint primary key,
  title varchar,
singer_id bigint, constraint fk_albums_singers foreign key (singer_id) references singers (id) );

-- This runs the DDL statements as one batch.
RUN BATCH;

RUN BATCH

RUN BATCH

将当前 DDL 批次中所有缓存的 DDL 语句发送到数据库，等待 Spanner 执行这些语句，然后结束当前 DDL 批次。

如果 Spanner 无法执行至少一个 DDL 语句，则 RUN BATCH 会针对 Spanner 无法执行的第一个 DDL 语句返回错误。否则，RUN BATCH 会成功返回。注意：如果该批次中的 DDL 语句返回错误，则 Spanner 可能仍会将同一批次中前面的 DDL 语句应用于数据库。
ABORT BATCH

清除当前 DDL 批次中所有缓存的 DDL 语句，然后结束该批次。

只有在 DDL 批次处于活跃状态的情况下您才能执行此语句。无论该批次是否包含缓存的 DDL 语句，您都可以使用 ABORT BATCH。 批处理中的所有先前 DDL 语句都将被中止。

▶ 示例：取消 DDL 批处理（点击可展开）

以下示例展示了如何使用 PGAdapter 中止 DDL 批处理。

-- Start a DDL batch. All following statements must be DDL statements.
START BATCH DDL;

-- The following statements are buffered locally.
CREATE TABLE singers ( id bigint primary key, first_name varchar, last_name varchar );
CREATE TABLE albums ( id bigint primary key,
  title varchar,
singer_id bigint, constraint fk_albums_singers foreign key (singer_id) references singers (id) );

-- This aborts the DDL batch and removes the DDL statements from the buffer.
ABORT BATCH;

START BATCH DML

以下语句同时批处理两个 DML 语句，并通过一次调用将其发送到服务器。DML 批处理可以作为事务的一部分执行，也可以在自动提交模式下执行。

START BATCH DML;
INSERT INTO MYTABLE (ID, NAME) VALUES (1, 'ONE');
INSERT INTO MYTABLE (ID, NAME) VALUES (2, 'TWO');
RUN BATCH;

▶ 示例：DML 批处理（点击可展开）

以下示例展示了如何使用 PGAdapter 执行 DML 批处理。

-- Start a DML batch. All following statements must be a DML statement.
START BATCH DML;

-- The following statements are buffered locally.
INSERT INTO MYTABLE (ID, NAME) VALUES (1, 'ONE');
INSERT INTO MYTABLE (ID, NAME) VALUES (2, 'TWO');

-- This sends the statements to Spanner.
RUN BATCH;

-- DML batches can also be part of a read/write transaction.
BEGIN;
-- Insert a row using a single statement.
INSERT INTO MYTABLE (ID, NAME) VALUES (3, 'THREE');

-- Insert two rows using a batch.
START BATCH DML;
INSERT INTO MYTABLE (ID, NAME) VALUES (4, 'FOUR');
INSERT INTO MYTABLE (ID, NAME) VALUES (5, 'FIVE');
RUN BATCH;

-- Rollback the current transaction. This rolls back both the single DML -- statement and the DML batch.
ROLLBACK;

Savepoint 命令

系统会模拟 PGAdapter 中的 Savepoint。回滚到某个 Savepoint 会回滚整个事务，并重试到设置 Savepoint 的点。如果事务在 Savepoint 之前使用过的底层数据发生了更改，此操作将失败并显示 AbortedDueToConcurrentModificationException 错误。

启用 Savepoint 支持后，Savepoint 的创建和释放始终会成功。

以下语句用于在事务中启用和停用模拟的 Savepoint。

SPANNER.SAVEPOINT_SUPPORT

SHOW [VARIABLE] SPANNER.SAVEPOINT_SUPPORT SET SPANNER.SAVEPOINT_SUPPORT = { 'DISABLED' | 'FAIL_AFTER_ROLLBACK' | 'ENABLED' }

类型为 STRING 的属性，用于指示当前的 SAVEPOINT_SUPPORT 配置。可能的值包括：

DISABLED：所有 Savepoint 命令都处于停用状态，并且会失败。

FAIL_AFTER_ROLLBACK：已启用 Savepoint 命令。回滚到某个 Savepoint 会回滚整个事务。如果您在回滚到某个 Savepoint 后尝试使用事务，操作将失败。

ENABLED：所有 Savepoint 命令都处于启用状态。回滚到某个 Savepoint 会回滚事务，并重试到 Savepoint。如果事务在 Savepoint 之前使用的底层数据已更改，此操作会失败并显示 AbortedDueToConcurrentModificationException 错误。

默认值为 ENABLED。

只有在没有活跃事务的情况下您才能执行此语句。

SAVEPOINT savepoint_name

SAVEPOINT savepoint-name;

SAVEPOINT 在当前事务中创建一个新的 Savepoint。 事务可以回滚到某个 Savepoint，以撤消自创建该 Savepoint 以来执行的所有操作。

▶ 示例：Savepoint（点击可展开）

以下示例展示了如何使用 PGAdapter 运行 Savepoint 命令。

-- Start a transaction and execute an insert statement.
BEGIN;
INSERT INTO T (id, col_a, col_b) VALUES (1, 100, 1);

-- Set a savepoint and then execute another insert statement.
SAVEPOINT one_row_inserted;
INSERT INTO T (id, col_a, col_b) VALUES (2, 200, 2);

-- Roll back to the savepoint. This will undo all statements that have been -- executed after the savepoint.
ROLLBACK TO one_row_inserted;

-- This only commits the first insert statement.
COMMIT;

ROLLBACK TO savepoint_name

ROLLBACK TO savepoint_name

将当前事务回滚到具有指定名称的 Savepoint。

无法保证在所有情况下回滚到某个 Savepoint 都能成功。回滚到某个 Savepoint 会回滚整个事务，并重试到设置 Savepoint 的点。如果事务在 Savepoint 之前使用的底层数据发生了更改，此操作将失败并返回 AbortedDueToConcurrentModificationException。

RELEASE [SAVEPOINT] savepoint_name

RELEASE savepoint_name

从当前事务中移除 Savepoint。它不再可用于执行 ROLLBACK TO savepoint_name 语句。

预处理语句

以下语句可创建和执行预处理语句。

PREPARE

PREPARE statement_name [(data_type, ...)] AS statement

在此连接中预处理语句。该语句由 Spanner 解析和验证，并存储在 PGAdapter 的内存中。

▶ 示例：预处理语句（点击可展开）

以下示例展示了如何使用 PGAdapter 创建和执行预处理语句。

-- Create a prepared statement that can be used to insert a single row.
PREPARE insert_t AS INSERT INTO T (id, col_a, col_b) VALUES ($1, $2, $3);

-- The prepared statement can be used to insert rows both in autocommit, in a -- transaction, and in DML batches.

-- Execute in autocommit.
EXECUTE insert_t (1, 100, 1);

-- Execute in transaction.
BEGIN;
EXECUTE insert_t (2, 200, 2);
EXECUTE insert_t (3, 300, 3);
COMMIT;

-- Execute in a DML batch.
START BATCH DML;
EXECUTE insert_t (4, 400, 4);
EXECUTE insert_t (5, 500, 5);
RUN BATCH;

-- Prepared statements can be removed with the DEALLOCATE command.
DEALLOCATE insert_t;

EXECUTE

EXECUTE statement_name [(value, ...)]

执行已在此连接上使用 PREPARE 创建的语句。

▶ 示例：执行（点击可展开）

以下示例展示了如何使用 PGAdapter 预处理和执行语句。

-- Create a prepared statement.
PREPARE my_statement AS insert into my_table (id, value) values ($1, $2);

-- Execute the statement twice with different parameter values.
EXECUTE my_statement (1, 'One');
EXECUTE my_statement (2, 'Two');

DEALLOCATE

DEALLOCATE statement_name

从此连接中移除已预处理的语句。

复制

PGAdapter 支持部分 PostgreSQL COPY 命令。

COPY table_name FROM STDIN

COPY table_name FROM STDIN [BINARY]

将数据从 stdin 复制到 Spanner。与执行 INSERT 语句相比，使用 COPY 将大型数据集导入到 Spanner 中更为高效。

COPY 可与 SPANNER.AUTOCOMMIT_DML_MODE 结合使用，以执行非原子事务。这样一来，该事务就可以执行超出标准事务变更上限的变更。

▶ 示例：复制（点击可展开）

以下示例展示了如何使用 PGAdapter 在 Spanner 之间复制数据。

create table numbers (number bigint not null primary key, name varchar);

执行原子 COPY 操作：

cat numbers.txt | psql -h /tmp -d test-db -c "copy numbers from stdin;"

执行非原子 COPY 操作：

cat numbers.txt | psql -h /tmp -d test-db \ -c "set spanner.autocommit_dml_mode='partitioned_non_atomic'; copy numbers from stdin;"

将数据从 PostgreSQL 复制到 Spanner：

psql -h localhost -p 5432 -d my-local-db \ -c "copy (select i, to_char(i, 'fm000') from generate_series(1, 1000000) s(i)) to stdout binary" \
  | psql -h localhost -p 5433 -d my-spanner-db \
-c "set spanner.autocommit_dml_mode='partitioned_non_atomic'; copy numbers from stdin binary;"

此示例假设 PostgreSQL 在端口 5432 上运行，PGAdapter 在端口 5433 上运行。

如需查看更多示例，请参阅 PGAdapter - COPY 支持。

COPY table_name TO STDOUT [BINARY]

COPY table_name TO STDOUT [BINARY]

将表中的数据或查询结果复制到 stdout。

Data Boost 和分区查询语句

Data Boost 使您能够执行分析查询和数据导出，同时对预配的 Spanner 实例上的现有工作负载几乎不造成影响。Data Boost 仅支持分区查询。

您可以使用 SET SPANNER.DATA_BOOST_ENABLED 语句启用 Data Boost。

PGAdapter 支持以下三种执行分区查询的替代方案：

SET SPANNER.AUTO_PARTITION_MODE = true

RUN PARTITIONED QUERY sql

PARTITION sql 后跟多个 RUN PARTITION 'partition-token'

以下各部分介绍了所有这些方法。

SPANNER.DATA_BOOST_ENABLED

SHOW SPANNER.DATA_BOOST_ENABLED SET SPANNER.DATA_BOOST_ENABLED {TO|=} { true | false }

设置此连接是否应针对分区查询使用 Data Boost。

默认值为 false。

▶ 示例：使用 Data Boost 执行查询（点击可展开）

以下示例展示了如何使用 PGAdapter 结合 Data Boost 进行查询。

-- Enable Data Boost on this connection.
SET SPANNER.DATA_BOOST_ENABLED = true;

-- Execute a partitioned query. Data Boost is only used for partitioned queries.
RUN PARTITIONED QUERY SELECT FirstName, LastName FROM Singers;

SPANNER.AUTO_PARTITION_MODE

SHOW SPANNER.AUTO_PARTITION_MODE SET SPANNER.AUTO_PARTITION_MODE {TO|=} { true | false}

类型为 BOOL 的属性，用于指示连接是否自动对执行的所有查询使用分区查询。

如果您希望连接对执行的所有查询使用分区查询，请将此变量设置为 true。

如果您希望连接对所有查询使用 Data Boost，请将 SPANNER.DATA_BOOST_ENABLED 也设置为 true。

默认值为 false。

▶ 示例：执行（点击可展开）

此示例使用 Data Boost 通过 PGAdapter 执行两个查询

SET SPANNER.AUTO_PARTITION_MODE = true SET SPANNER.DATA_BOOST_ENABLED = true SELECT first_name, last_name FROM singers SELECT singer_id, title FROM albums

RUN PARTITIONED QUERY

RUN PARTITIONED QUERY

在 Spanner 上以分区查询的形式执行查询。确保将 SPANNER.DATA_BOOST_ENABLED 设置为 true，以便使用 Data Boost 执行查询：

SET SPANNER.DATA_BOOST_ENABLED = true RUN PARTITIONED QUERY SELECT FirstName, LastName FROM Singers

PGAdapter 在内部对查询进行分区，并且并行执行分区。结果会合并到一个结果集中，并返回给应用。可以使用变量 SPANNER.MAX_PARTITIONED_PARALLELISM 设置执行分区的工作器线程数。

PARTITION

PARTITION

创建要针对 Spanner 执行查询的分区的列表，并返回对应的分区令牌列表。每个分区令牌都可以使用 RUN PARTITION 'partition-token' 命令在同一个或另一个 PGAdapter 实例上的单独连接中执行。

▶ 示例：对查询进行分区（点击可展开）

以下示例展示了如何对查询进行分区，然后使用 PGAdapter 单独执行每个分区。

-- Partition a query. This returns a list of partition tokens that can be -- executed either on this connection or on any other connection to the same -- database.
PARTITION SELECT FirstName, LastName FROM Singers;

-- Run the partitions that were returned from the previous statement.
RUN PARTITION 'partition-token-1';
RUN PARTITION 'partition-token-2';

RUN PARTITION 'partition-token'

RUN PARTITION 'partition-token'

执行之前由 PARTITION 命令返回的查询分区。该命令可在连接到创建分区令牌的同一数据库的任何连接上执行。

SPANNER.MAX_PARTITIONED_PARALLELISM

类型为 bigint 的属性，指示 PGAdapter 用于执行分区的工作器线程数。此值用于以下用途：

SPANNER.AUTO_PARTITION_MODE = true

RUN PARTITIONED QUERY sql

SHOW SPANNER.MAX_PARTITIONED_PARALLELISM SET SPANNER.MAX_PARTITIONED_PARALLELISM {TO|=}

设置 PGAdapter 可用于执行分区的工作器线程的数量上限。将此值设置为 0 会指示 PGAdapter 将客户端机器上的 CPU 核心数量用作最大值。

默认值为 0。

后续步骤

详细了解如何启动 PGAdapter。

查看支持的 PostgreSQL 驱动程序和 ORM 的完整列表。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-09-26。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-09-26。"],[],[]]

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
