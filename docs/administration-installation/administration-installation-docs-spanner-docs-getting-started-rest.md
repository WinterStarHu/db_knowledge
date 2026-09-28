# Spanner 使用入门（使用 REST）  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/getting-started/rest

Spanner 使用入门（使用 REST）  |  Google Cloud Documentation

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

Spanner 使用入门（使用 REST）

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

PostgreSQL 接口说明：本主题中的示例适用于 GoogleSQL 方言数据库。此功能不支持 PostgreSQL 接口。

目标

本教程将介绍如何使用基于 REST 的 Cloud Spanner API 完成以下步骤：

创建 Spanner 实例和数据库。

写入、读取数据库中的数据和对数据执行 SQL 查询。

更新数据库架构。

向数据库添加二级索引。

使用索引来读取数据和对数据执行 SQL 查询。

使用只读事务检索数据。

如果您想使用 Spanner 客户端库，而不使用 REST API，请参阅教程。

费用

本教程使用 Spanner，它是Google Cloud的收费组件。如需了解使用 Spanner 的费用，请参阅价格。

准备工作

Sign in to your Google Cloud account. If you're new to Google Cloud, create an account to evaluate how our products perform in real-world scenarios. New customers also get $300 in free credits to run, test, and deploy workloads.

In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Go to project selector

Verify that billing is enabled for your Google Cloud project.

In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Go to project selector

Verify that billing is enabled for your Google Cloud project.

进行 REST 调用的方式

您可以使用以下方式进行 Spanner REST 调用：

Spanner API 参考文档中的 Try-It! 功能。本页面展示的示例使用的是 Try-It! 功能。

Google APIs Explorer，其中包含 Cloud Spanner API 和其他 Google API。

其他支持 HTTP REST 调用的工具或框架。

本页面使用的约定

这些示例使用 [PROJECT_ID] 作为 Google Cloud 项目 ID。请使用您的Google Cloud 项目 ID 替换 [PROJECT_ID]。请勿在项目 ID 中包含 [ 和 ]。

这些示例创建并使用 test-instance 的实例 ID。如果您未使用 test-instance，请替换您的实例 ID。

这些示例创建并使用 example-db 的数据库 ID。如果您未使用 example-db，请替换您的数据库 ID。

这些示例使用 [SESSION] 作为会话名称的一部分。请将 [SESSION] 替换成您在创建会话时收到的值。（请勿在会话名称中包含 [ 和 ]。）

这些示例使用 [TRANSACTION_ID] 的事务 ID。请将 [TRANSACTION_ID] 替换成您在创建事务时收到的值。（请勿在事务 ID 中包含 [ 和 ]。）

Try-It! 功能支持以交互方式添加个别 HTTP 请求字段。本主题中的大多数示例都提供了整个请求，而不是描述如何以交互方式将个别字段添加到请求中。

实例

在首次使用 Spanner 时，必须创建一个实例，实例是 Spanner 数据库使用的资源分配单位。创建实例时，您可以选择数据的存储位置以及实例具有的计算容量。

列出实例配置

在创建实例时，您可以指定一个实例配置，用于定义该实例中数据库的地理位置和复制。您可以选择单区域配置以将数据存储在单个区域中，也可以选择多区域配置以将数据分布到多个区域。如需了解详情，请参阅实例。

使用 projects.instanceConfigs.list 确定哪些配置可用于您的 Google Cloud 项目。

点击 projects.instanceConfigs.list。

对于 parent，输入：

projects/[PROJECT_ID]

点击 Execute。响应中会显示可用的实例配置。以下是一个示例响应（您的项目可能会采用不同的实例配置）：

{ "instanceConfigs": [ { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-asia-south1", "displayName": "asia-south1" }, { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-asia-east1", "displayName": "asia-east1" }, { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-asia-northeast1", "displayName": "asia-northeast1" }, { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-europe-west1", "displayName": "europe-west1" }, { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-us-east4", "displayName": "us-east4" }, { "name": "projects/[PROJECT_ID]/instanceConfigs/regional-us-central1", "displayName": "us-central1" } ] }

创建实例时，您可以使用其中一个实例配置的 name 值。

创建实例

点击 projects.instances.create。

对于 parent，输入：

projects/[PROJECT_ID]

点击 Add request body parameters 并选择 instance。

点击 instance 提示气泡以查看可能的字段。为以下字段添加值：

nodeCount：输入 1。

config：输入在列出实例配置时返回的其中一个区域实例配置的 name 值。

displayName：输入 Test Instance。

点击 instance 右括号后面的提示气泡，然后选择 instanceId。

对于 instanceId，输入 test-instance。
您的 Try It! 实例创建页面现在应该如下所示：

点击执行。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

您可以使用 projects.instances.list 列出您的实例。

创建数据库

创建一个名为 example-db 的数据库。

点击 projects.instances.databases.create。

对于 parent，输入：

projects/[PROJECT_ID]/instances/test-instance

点击 Add request body parameters 并选择 createStatement。

对于 createStatement，输入：

CREATE DATABASE `example-db`

（数据库名称 example-db 包含一个连字符，所以必须用反引号 (`) 括起来）。

点击 Execute。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

您可以使用 projects.instances.databases.list 列出您的数据库。

创建架构

使用 Spanner 的数据定义语言 (DDL) 来创建、修改或删除表，以及创建或删除索引。

点击 projects.instances.databases.updateDdl。

对于 database，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

对于 Request body，使用以下内容：

{ "statements": [ "CREATE TABLE Singers ( SingerId INT64 NOT NULL, FirstName STRING(1024), LastName STRING(1024), SingerInfo BYTES(MAX) ) PRIMARY KEY (SingerId)", "CREATE TABLE Albums ( SingerId INT64 NOT NULL, AlbumId INT64 NOT NULL, AlbumTitle STRING(MAX)) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE" ] }

statements 数组包含用于定义架构的 DDL 语句。

点击 Execute。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

该架构为一个基本的音乐应用定义了两个表：Singers 和 Albums。本页面会一直用到这两个表。请查看示例架构（如果您还没有查看）。

您可以使用 projects.instances.databases.getDdl 检索您的架构。

创建会话

在添加、更新、删除或查询数据之前，您必须创建一个会话，该会话代表与 Spanner 数据库服务之间的一个通信渠道。（如果您使用的是 Spanner 客户端库，则不需要直接使用会话，因为客户端库会代表您管理会话。）

点击 projects.instances.databases.sessions.create。

对于 database，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

点击执行。

响应会显示您创建的会话，形式为

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

在读取或写入数据库时，您将使用此会话。

会话设计为长期有效。Spanner 数据库服务可以在会话空闲超过一小时后删除会话。尝试使用已删除的会话会导致 NOT_FOUND 错误。如果遇到此错误，请创建并使用新会话。您可以使用 projects.instances.databases.sessions.get 查看会话是否仍处于活动状态。如需了解相关信息，请参阅使空闲会话保持活动状态。
注意：会话是一个高级概念。如需了解详情和最佳做法，请参阅会话。
下一步是将数据写入数据库。

写入数据

您可以使用 Mutation 类型来写入数据。Mutation 是用于变更操作的容器。Mutation 代表插入、更新、删除及一系列其他操作，这些操作可以原子方式应用于 Spanner 数据库中的不同行和表。

点击 projects.instances.databases.sessions.commit。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "singleUseTransaction": { "readWrite": {} }, "mutations": [ { "insertOrUpdate": { "table": "Singers", "columns": [ "SingerId", "FirstName", "LastName" ], "values": [ [ "1", "Marc", "Richards" ], [ "2", "Catalina", "Smith" ], [ "3", "Alice", "Trentor" ], [ "4", "Lea", "Martin" ], [ "5", "David", "Lomond" ] ] } }, { "insertOrUpdate": { "table": "Albums", "columns": [ "SingerId", "AlbumId", "AlbumTitle" ], "values": [ [ "1", "1", "Total Junk" ], [ "1", "2", "Go, Go, Go" ], [ "2", "1", "Green" ], [ "2", "2", "Forever Hold Your Peace" ], [ "2", "3", "Terrified" ] ] } } ] }

点击 Execute。该响应会显示提交时间戳。

本示例使用了 insertOrUpdate。Mutations 的其他操作包括 insert、update、replace 和 delete。

如需了解如何对数据类型进行编码，请参阅 TypeCode。

使用 SQL 查询数据

点击 projects.instances.databases.sessions.executeSql。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "sql": "SELECT SingerId, AlbumId, AlbumTitle FROM Albums" }

点击 Execute。该响应会显示查询结果。

使用读取 API 读取数据

点击 projects.instances.databases.sessions.read。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "table": "Albums", "columns": [ "SingerId", "AlbumId", "AlbumTitle" ], "keySet": { "all": true } }

点击 Execute。该响应会显示读取结果。

更新数据库架构

假设您需要将名为 MarketingBudget 的新列添加到 Albums 表，此操作需要更新您的数据库架构。Spanner 支持在数据库继续处理流量的同时，对数据库进行架构更新。架构更新不需要使数据库离线，并且不会锁定整个表或列；在架构更新期间，您可以继续将数据写入数据库。

添加列

点击 projects.instances.databases.updateDdl。

对于 database，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

对于 Request body，使用以下内容：

{ "statements": [ "ALTER TABLE Albums ADD COLUMN MarketingBudget INT64" ] }

statements 数组包含用于定义架构的 DDL 语句。

点击执行。即使在 REST 调用返回响应之后，该操作也可能需要几分钟才能完成。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

将数据写入新列

以下代码可将数据写入新列。对于键分别为 Albums(1, 1) 和 Albums(2, 2) 的行，该代码会将 MarketingBudget 分别设置为 100000 和 500000。

点击 projects.instances.databases.sessions.commit。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "singleUseTransaction": { "readWrite": {} }, "mutations": [ { "update": { "table": "Albums", "columns": [ "SingerId", "AlbumId", "MarketingBudget" ], "values": [ [ "1", "1", "100000" ], [ "2", "2", "500000" ] ] } } ] }

点击 Execute。该响应会显示提交时间戳。

您还可以执行 SQL 查询或读取调用来获取刚才写入的值。

以下是执行查询的方法：

点击 projects.instances.databases.sessions.executeSql。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "sql": "SELECT SingerId, AlbumId, MarketingBudget FROM Albums" }

点击 Execute。作为响应的一部分，您应该可以看到包含更新后的 MarketingBudget 值的两行：

"rows": [ [ "1", "1", "100000" ], [ "1", "2", null ], [ "2", "1", null ], [ "2", "2", "500000" ], [ "2", "3", null ] ]

使用二级索引

假设您想要提取 Albums 表中 AlbumTitle 值在特定范围内的所有行。您可以使用 SQL 语句或读取调用读取 AlbumTitle 列中的所有值，然后舍弃不符合条件的行。不过，执行全表扫描费用高昂，特别是对内含大量行的表来说更是如此。相反，如果对表创建二级索引，按非主键列进行搜索，则可以提高行检索速度。

向现有表添加二级索引需要更新架构。与其他架构更新一样，Spanner 支持在数据库继续处理流量的同时添加索引。Spanner 会使用您的现有数据自动回填索引。  回填可能需要几分钟时间才能完成，但在此过程中，您无需使数据库离线，也无需避免写入特定的表或列。如需了解详情，请参阅索引回填。

添加二级索引后，Spanner 会自动使用该索引进行 SQL 查询，使用该索引后，查询运行速度可能会提高。如果使用读取接口，则必须指定要使用的索引。

添加二级索引

您可以使用 updateDdl 添加索引。

点击 projects.instances.databases.updateDdl。

对于 database，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

对于 Request body，使用以下内容：

{ "statements": [ "CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)" ] }

点击 Execute。即使在 REST 调用返回响应之后，该操作也可能需要几分钟才能完成。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

使用索引进行查询

点击 projects.instances.databases.sessions.executeSql。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "sql": "SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums WHERE AlbumTitle >= 'Aardvark' AND AlbumTitle < 'Goo'" }

点击 Execute。作为响应的一部分，您应该可以看到以下几行：

"rows": [ [ "2", "Go, Go, Go", null ], [ "2", "Forever Hold Your Peace", "500000" ] ]

使用索引进行读取

点击 projects.instances.databases.sessions.read。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "table": "Albums", "columns": [ "AlbumId", "AlbumTitle" ], "keySet": { "all": true }, "index": "AlbumsByAlbumTitle" }

点击 Execute。作为响应的一部分，您应该可以看到以下几行：

"rows": [ [ "2", "Forever Hold Your Peace" ], [ "2", "Go, Go, Go" ], [ "1", "Green" ], [ "3", "Terrified" ], [ "1", "Total Junk" ] ]

添加带 STORING 子句的索引

您可能已经注意到，上面的读取示例不包括读取 MarketingBudget 列。这是因为，Spanner 的读取接口不支持将索引与数据表联接来查找未存储在索引中的值。

请创建 AlbumsByAlbumTitle 的备用定义，用于将 MarketingBudget 的副本存储到索引中。

您可以使用 updateDdl 添加 STORING 索引。

点击 projects.instances.databases.updateDdl。

对于 database，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

对于 Request body，使用以下内容：

{ "statements": [ "CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) STORING (MarketingBudget)" ] }

点击 Execute。即使在 REST 调用返回响应之后，该操作也可能需要几分钟才能完成。该响应会返回一个长时间运行的操作，您可以查询该操作以检查其状态。

现在，当您执行读取操作时便可从 AlbumsByAlbumTitle2 索引中提取所有 AlbumId、AlbumTitle 和 MarketingBudget 列：

点击 projects.instances.databases.sessions.read。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "table": "Albums", "columns": [ "AlbumId", "AlbumTitle", "MarketingBudget" ], "keySet": { "all": true }, "index": "AlbumsByAlbumTitle2" }

点击 Execute。作为响应的一部分，您应该可以看到以下几行：

"rows": [ [ "2", "Forever Hold Your Peace", "500000" ], [ "2", "Go, Go, Go", null ], [ "1", "Green", null ], [ "3", "Terrified", null ], [ "1", "Total Junk", "100000" ] ]

使用只读事务检索数据

假设您要在同一时间戳执行多个读取操作。只读事务会观察事务提交记录的一致前缀，以便您的应用始终获得一致的数据。

创建只读事务

点击 projects.instances.databases.sessions.beginTransaction。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

对于 Request Body，使用以下内容：

{ "options": { "readOnly": {} } }

点击执行。

该响应会显示您创建的事务的 ID。

现在您可以使用只读事务以一致的时间戳检索数据，即使自创建只读事务后数据已更改。

使用只读事务运行查询

点击 projects.instances.databases.sessions.executeSql。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "sql": "SELECT SingerId, AlbumId, AlbumTitle FROM Albums", "transaction": { "id": "[TRANSACTION_ID]" } }

点击 Execute。您应该会在响应中看到与以下内容类似的行：

"rows": [ [ "2", "2", "Forever Hold Your Peace" ], [ "1", "2", "Go, Go, Go" ], [ "2", "1", "Green" ], [ "2", "3", "Terrified" ], [ "1", "1", "Total Junk" ] ]

使用只读事务进行读取

点击 projects.instances.databases.sessions.read。

对于 session，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db/sessions/[SESSION]

（您在创建会话时会收到此值。）

对于 Request body，使用以下内容：

{ "table": "Albums", "columns": [ "SingerId", "AlbumId", "AlbumTitle" ], "keySet": { "all": true }, "transaction": { "id": "[TRANSACTION_ID]" } }

点击 Execute。您应该会在响应中看到与以下内容类似的行：

"rows": [ [ "1", "1", "Total Junk" ], [ "1", "2", "Go, Go, Go" ], [ "2", "1", "Green" ], [ "2", "2", "Forever Hold Your Peace" ], [ "2", "3", "Terrified" ] ]

Spanner 还支持读写事务，这类事务可在单个逻辑时间点以原子方式执行一组读写操作。如需了解详情，请参阅读写事务。（Try-It! 功能不适合演示读写事务。）

清理

为避免因本教程中使用的资源导致您的 Google Cloud 账号产生额外费用，请删除数据库和您创建的实例。

删除数据库

点击 projects.instances.databases.dropDatabase。

对于 name，输入：

projects/[PROJECT_ID]/instances/test-instance/databases/example-db

点击执行。

删除实例

点击 projects.instances.delete。

对于 name，输入：

projects/[PROJECT_ID]/instances/test-instance

点击执行。

后续步骤

在虚拟机实例中访问 Spanner：创建一个可访问 Spanner 数据库的虚拟机实例。

详细了解 Spanner 概念。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-06。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-06。"],[],[]]

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
