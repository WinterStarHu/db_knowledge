# 创建 Spanner 免费试用实例和示例应用  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/free-trial-quickstart

创建 Spanner 免费试用实例和示例应用  |  Google Cloud Documentation

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

创建 Spanner 免费试用实例和示例应用

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

注意 ：Spanner 免费试用实例支持标准版功能和企业版功能，例如 KNN 向量距离函数、全文搜索和 Spanner Graph。如需了解详情，请参阅 Spanner 版本概览。

本快速入门介绍了如何使用 Spanner 免费试用实例和示例应用。如需了解详情，请参阅 Spanner 免费试用实例概览。

开始免费试用实例

任何拥有 Google 账号并在项目中启用了 Cloud Billing 的用户都可以使用 Spanner 90 天免费试用实例。除非您选择将免费试用实例升级为付费实例，否则无需支付费用。

您可以使用 Google Cloud 控制台或 Google Cloud CLI 创建免费试用实例。
注意：您只能在每个项目生命周期内创建一个免费试用实例，并且每个 Cloud Billing 账号最多只能创建五个免费试用实例。

准备工作

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 页面。

转到 Spanner

选择或创建 Google Cloud 项目（如果尚未创建）。

如果您的项目已启用 Cloud Billing，请继续执行下一部分中的创建免费试用实例。

如果您的项目未启用 Cloud Billing，请关联现有的 Cloud Billing 账号或创建新的 Cloud Billing 账号。Google 会利用这些支付信息验证您的身份。除非您明确将 Cloud Billing 账号升级为付费账号，并且将 Spanner 免费试用实例升级为付费实例，否则我们不会向您的 Spanner 实例收费。

a. 点击前往“结算”。

b. 然后，点击关联结算账号。
注意：如果您是新的 Google Cloud 客户，也可能有资格获享Google Cloud 90 天 $300 免费试用机会，其中包含价值 $300 的免费 Cloud Billing 赠金，可用于支付任何 Google Cloud资源费用。Spanner 免费试用实例是 Google Cloud 免费试用提供的 300 美元免费试用赠金之外的额外赠送实例，您无需使用任何免费的 Cloud Billing 赠金即可创建免费试用实例。

c. 按照相应步骤创建结算账号，然后将其关联到您的项目。

d. 为项目启用 Cloud Billing 后，请前往 Spanner 页面。

转到 Spanner

e. 点击创建免费实例，然后继续执行下一部分中的创建免费试用实例。

可选：如果您之前在项目中创建了 Spanner 实例，则会看到以下 Spanner 实例页面。

点击创建免费实例。

gcloud

Sign in to your Google Cloud account. If you're new to Google Cloud, create an account to evaluate how our products perform in real-world scenarios. New customers also get $300 in free credits to run, test, and deploy workloads.

Install the Google Cloud CLI.

如果您使用的是外部身份提供方 (IdP)，则必须先使用联合身份登录 gcloud CLI。

如需初始化 gcloud CLI，请运行以下命令：

gcloud init

Create or select a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Create a Google Cloud project:

gcloud projects create PROJECT_ID

Replace PROJECT_ID with a name for the Google Cloud project you are creating.

Select the Google Cloud project that you created:

gcloud config set project PROJECT_ID

Replace PROJECT_ID with your Google Cloud project name.

Verify that billing is enabled for your Google Cloud project.

If you're using a local shell, then create local authentication credentials for your user account:

gcloud auth application-default login

You don't need to do this if you're using Cloud Shell.

If an authentication error is returned, and you are using an external identity provider (IdP), confirm that you have

signed in to the gcloud CLI with your federated identity.

Install the Google Cloud CLI.

如果您使用的是外部身份提供方 (IdP)，则必须先使用联合身份登录 gcloud CLI。

如需初始化 gcloud CLI，请运行以下命令：

gcloud init

Create or select a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Create a Google Cloud project:

gcloud projects create PROJECT_ID

Replace PROJECT_ID with a name for the Google Cloud project you are creating.

Select the Google Cloud project that you created:

gcloud config set project PROJECT_ID

Replace PROJECT_ID with your Google Cloud project name.

Verify that billing is enabled for your Google Cloud project.

If you're using a local shell, then create local authentication credentials for your user account:

gcloud auth application-default login

You don't need to do this if you're using Cloud Shell.

If an authentication error is returned, and you are using an external identity provider (IdP), confirm that you have

signed in to the gcloud CLI with your federated identity.

创建免费试用实例

Google Cloud 控制台 以下步骤介绍了如何使用Google Cloud 控制台创建免费试用实例。

在创建免费试用实例页面上，执行以下操作：

输入要在 Google Cloud 控制台上显示的实例名称。
此实例在您的 Google Cloud 项目中必须是唯一的。

输入用于永久标识实例的实例 ID。此实例 ID 在您的 Google Cloud 项目中也必须是唯一的。 您以后无法更改实例 ID。

从区域下拉菜单中选择配置位置。

您的实例配置决定了您的实例会存储和复制到什么地理位置。您可以在任何 Spanner 区域级实例配置中创建免费试用实例。如需查看所有可用实例配置的完整列表，请参阅单区域、双区域和多区域配置。

点击创建免费实例。

创建免费试用实例后，Spanner 会为您创建一个示例数据库，以便您探索和熟悉 Spanner 功能。如需了解详情，请参阅免费试用实例概览。

gcloud 如需创建免费试用实例，请使用 gcloud spanner instances create 命令。

gcloud spanner instances create INSTANCE_ID \ --instance-type=free-instance --config=INSTANCE_CONFIG \ --description=INSTANCE_DESCRIPTION

替换以下内容：

INSTANCE_ID：在您的 Google Cloud 项目中唯一的永久性标识符。您以后无法更改实例 ID。

INSTANCE_CONFIG：实例配置的永久性标识符，该标识符定义实例的地理位置。您可以在任何 Spanner 区域级实例配置中创建免费试用实例：

INSTANCE_DESCRIPTION：要在Google Cloud 控制台中为实例显示的名称。此实例名称在您的Google Cloud 项目中必须是唯一的。

例如，如需使用区域实例配置 regional-us-east5 创建名为 trial-instance、显示名称为 Trial Instance 的免费试用实例，请运行以下命令：

gcloud spanner instances create trial-instance --config=regional-us-east5 \ --instance-type=free-instance --description="Trial Instance" 注意：在 gcloud CLI 命令中引用实例时，请使用实例 ID，而不是显示名称。

创建免费试用实例后，系统会提示您启动分步式教程，通过该教程了解并探索 Spanner，学习如何使用示例应用创建数据库。如需了解详情，请参阅开始使用示例应用。

开始使用示例数据库

使用 Google Cloud 控制台创建免费试用实例后，Spanner 会为您创建一个示例数据库，以便您探索和熟悉 Spanner 功能。

您可以使用 Google Cloud 控制台访问示例数据库。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

转到“实例”页面

点击免费试用实例的名称。

点击示例数据库的名称。

您可以查看示例数据库中的表和数据。您还可以在 Spanner Studio 页面上访问和查看已保存的查询。保存的查询展示了不同的 Spanner 特性和功能。

开始使用示例应用

Spanner 还提供开源示例应用，可帮助您开始使用 Spanner 免费试用实例。示例应用由一个后端 gRPC 服务（由 Spanner 数据库提供支持）和一个用于将流量引导到该服务的工作负载生成器组成。

您可以使用 Google Cloud CLI 访问示例应用。

gcloud

完成 gcloud 设置中介绍的步骤，包括创建和设置默认 Google Cloud 项目、启用 Cloud Spanner API 以及设置 OAuth 2.0 来获取身份验证凭证以使用 Cloud Spanner API。

运行 gcloud auth application-default login 命令，以便使用身份验证凭证设置本地开发环境。

运行 gcloud spanner samples run 命令，以下载示例应用并启动给定示例应用的后端 gRPC 服务和工作负载生成器：

gcloud spanner samples run APPNAME --instance-id INSTANCE_ID

如需了解详情并查看示例应用的其他可用命令的列表，请参阅 gcloud CLI 文档。

导入自己的数据

您可以使用 CSV 文件、MySQL 转储文件或 PostgreSQL 转储文件将自己的数据导入到 Spanner 数据库中。您可以使用 Cloud Storage 上传本地文件，也可以直接从 Cloud Storage 存储桶上传本地文件。使用 Cloud Storage 上传本地文件可能会产生费用。

如果您选择使用 CSV 文件，还需要上传一个包含数据库架构的单独 JSON 文件。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择要在其中创建数据库的实例。

点击导入我自己的数据。

输入以下值：

选择文件类型。

从计算机上传文件，或选择文件所在的 Cloud Storage 存储桶路径。

（可选）如果您选择使用 CSV 文件，还需要上传一个包含数据库架构的单独 JSON 文件。JSON 文件必须使用以下结构来定义架构：

{ "name": "COLUMN_NAME", "type": "TYPE", "notNull": NOT_NULL_VALUE, "primaryKeyOrder": PRIMARY_KEY_ORDER }

替换以下内容：

COLUMN_NAME：表格中的列名称。

TYPE：列的数据类型。

（可选）NOT_NULL_VALUE：列是否可以存储 null 值。有效输入为 true 或 false。默认值为 false。

（可选）：PRIMARY_KEY_ORDER：确定主键顺序。对于非主键列，将值设置为 0。对于主键列，请将该值设置为一个整数（例如 1）。在复合主键中，编号较小的列会显示在前面。

默认情况下，CSV 文件使用英文逗号作为字段分隔符，使用换行符作为行分隔符。如需详细了解如何使用自定义分隔符，请参阅 gcloud alpha spanner databases import 参考文档。

选择新数据库或现有数据库作为目标数据库。

点击导入。

Spanner 会打开 Cloud Shell 并填充一个命令，该命令用于安装 Spanner 迁移工具并运行 gcloud alpha spanner databases import 命令。按 ENTER 键将数据导入数据库。

升级免费试用实例

以下步骤介绍了如何升级免费试用实例。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

转到“实例”页面

点击免费试用实例的名称。

在实例概览页面上，点击修改实例或修改以升级。

在更新实例名称字段中，为付费实例输入更合适的名称（如果适用）。

选择升级选项。您可以选择以下选项之一：

立即升级

试用期结束后自动升级为企业版的完整版

以后再提醒我

摘要部分介绍了您选择的升级付费实例的计算和存储费用。

点击保存以升级免费试用实例。

gcloud 如需将免费试用实例升级为具有相同实例配置的付费企业版实例，请运行以下 gcloud spanner instances update 命令：

gcloud spanner instances update INSTANCE_ID --instance-type=provisioned

删除实例 警告：删除实例将永久移除该实例及其所有数据库。您之后无法撤消此操作。此外，在删除第一个免费试用实例后，您无法再创建其他免费试用实例。您可以在每个项目生命周期内创建一个免费试用实例。

Google Cloud 控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要删除的实例名称。

在实例概览页面上，点击删除实例。

按照说明进行操作，确认您要删除实例。

点击删除。

gcloud 如需删除免费试用实例，请使用以下 gcloud spanner instances delete 命令：

gcloud spanner instances delete INSTANCE_ID

后续步骤

详细了解 Spanner 免费试用实例。

详细了解 Spanner 实例和数据库。

如需详细了解免费试用期结束后的 Spanner 价格，请参阅价格页面。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-05。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-05。"],[],[]]

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
