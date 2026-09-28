# 将自动扩缩器工具部署到 Cloud Run functions  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/set-up-autoscaling-cloud-run

将自动扩缩器工具部署到 Cloud Run functions  |  Spanner  |  Google Cloud Documentation

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

将自动扩缩器工具部署到 Cloud Run functions

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

自动扩缩器工具具有灵活性，可以适应运维和应用团队之间的现有职责分离。配置 Spanner 实例的自动扩缩功能的职责可以由单个运维团队集中管理，也可以分发给更接近这些 Spanner 实例所处理的应用的团队。

本文档是系列文章中的一篇，该系列文章还包括：

自动扩缩 Spanner

自动扩缩器工具概览

将 Spanner 的自动扩缩器工具部署到 Google Kubernetes Engine (GKE)

本系列文章适用于想要降低运维开销和优化 Spanner 部署成本的 IT、运维和站点可靠性工程 (SRE) 团队。

本页面介绍了根据您的要求将自动扩缩器部署到 Cloud Run functions 的三种方式：

每个项目的部署拓扑。 自动扩缩器基础架构与需要自动扩缩的 Spanner 部署在同一项目中。对于希望管理自己的自动扩缩器配置和基础架构的独立团队，我们建议使用此拓扑。此外，按项目部署拓扑也是测试自动扩缩器功能的良好起点。

集中式部署拓扑。自动扩缩器工具部署在单个项目中，并管理不同项目中的一个或多个 Spanner 实例。对于管理一个或多个 Spanner 实例的配置和基础架构的团队，我们建议使用此拓扑结构，同时保持自动扩缩程序的组件和配置位于中心位置。在集中式拓扑中，除了自动扩缩程序，您还设置了第二个项目，本教程中称为“应用项目”。应用项目包含应用资源，包括 Spanner。

分布式部署拓扑。大多数自动扩缩器基础架构部署在一个项目中，但某些基础架构组件会与进行自动扩缩的 Spanner 实例部署在不同的项目中。如果组织拥有多个团队，并且拥有 Spanner 实例的团队希望仅管理其实例的自动扩缩器配置参数，但其余的自动扩缩器基础架构由中心团队管理，我们建议使用此拓扑。

无服务器方便部署和管理

在此模型中，自动扩缩器工具仅使用无服务器和低管理 Google Cloud 工具（例如 Cloud Run functions、Pub/Sub、Cloud Scheduler 和 Firestore）构建。这种方法可最大限度地减少运行自动扩缩器工具的成本和运维开销。

通过使用内置 Google Cloud 工具，自动扩缩器工具可充分利用 Identity and Access Management (IAM) 来进行身份验证和授权。

配置

自动扩缩器工具通过在 Cloud Scheduler 中定义的配置管理 Spanner 实例。如果您需要以相同的间隔轮询多个 Spanner 实例，我们建议您在相同的 Cloud Scheduler 作业中配置它们。每个实例的配置都以 JSON 对象的形式表示。以下是一个配置示例，在其中使用一个 Cloud Scheduler 作业管理两个 Spanner 实例：

[ { "projectId": "my-spanner-project", "instanceId": "my-spanner", "scalerPubSubTopic": "projects/my-spanner-project/topics/spanner-scaling", "units": "NODES", "minSize": 1, "maxSize": 3 }, { "projectId": "different-project", "instanceId": "another-spanner", "scalerPubSubTopic": "projects/my-spanner-project/topics/spanner-scaling", "units": "PROCESSING_UNITS", "minSize": 500, "maxSize": 3000, "scalingMethod": "DIRECT" } ]

Spanner 实例可以在不同的 Cloud Scheduler 作业中有多个配置。例如，一个实例可以有一个包含用于正常操作的线性方法的自动扩缩器配置，但还有另一个包含用于计划批量工作负载的直接方法的自动扩缩器配置。

Cloud Scheduler 作业运行时，它将向 Polling Pub/Sub 主题发送 Pub/Sub 消息。此消息的载荷是在同一作业中配置的所有实例的配置对象的 JSON 数组。如需查看配置选项的完整列表，请参阅轮询器 README 文件。

每个项目的拓扑

在每个项目的拓扑部署中，每个需要 Spanner 实例进行自动缩放的项目也具有自己的自动扩缩器组件独立部署。对于希望管理自己的自动扩缩器配置和基础架构的独立团队，我们建议使用此拓扑。这也是测试自动扩缩器工具功能的良好起点。

下图展示了每个项目部署的高度概括的概念视图。

上图中描述的按项目部署具有以下特征：

两个应用（应用 1 和应用 2）分别使用各自的 Spanner 实例。

Spanner 实例 (A) 位于相应的应用 1 和应用 2 项目中。

独立的自动扩缩器 (B) 将部署到每个项目中，以控制项目中的实例自动扩缩。

每个项目部署具有以下优点和缺点。

优点：

最简单的设计：按项目拓扑是三种拓扑中最简单的设计，因为所有自动扩缩器组件均与进行自动扩缩的 Spanner 实例一起部署。

配置：由拥有 Spanner 实例的团队控制调度器参数，与集中式或分布式拓扑相比，这使该团队能够更灵活地按需求调整自动扩缩器。

明确承担基础架构责任：每个项目的拓扑设计可以为自动扩缩器基础架构建立明确的责任与安全性，因为 Spanner 实例的团队所有者也是自动扩缩器基础架构的所有者。

缺点：

整体维护更多：每个团队都负责自动扩缩器配置和基础架构，因此难以确保公司中的所有自动扩缩器工具都遵循相同的更新准则。

更复杂的审核：由于每个团队都具有更高级别的控制，因此集中式审核可能会更复杂。

如需了解如何使用按项目拓扑设置自动扩缩器，请参阅按项目部署分步指南。

集中式拓扑

与按项目拓扑一样，在集中式拓扑部署中，自动扩缩器工具的所有组件都位于同一项目中。但是，Spanner 实例位于不同的项目中。此部署适用于通过中央位置处的单个自动扩缩器工具部署来管理多个 Spanner 实例的配置和基础架构的团队。

下图显示集中式项目部署的高度概括的概念视图：

上图中显示的集中式部署具有以下特征：

两个应用（应用 1 和应用 2）分别使用各自的 Spanner 实例。

Spanner 实例 (A) 位于相应的应用 1 和应用 2 项目中。

自动扩缩器 (B) 部署在单独的项目中，以控制应用 1 和应用 2 项目中的 Spanner 实例的自动扩缩。

集中式部署具有以下优势和缺点。

优点：

集中式配置和基础架构：单个团队控制调度器参数和自动扩缩器基础架构。在受严格监管的行业中，这种方法非常有用。

整体维护更少：与按项目部署相比，维护和设置通常需要更少的维护工作。

集中式政策和审核：跨团队的最佳做法可能更易于指定和强制执行。审核可能更容易执行。

缺点：

集中式配置：对自动扩缩器参数的任何更改都需要通过集中式团队完成，即使请求更改的团队拥有 Spanner 实例也是如此。

可能面临额外风险：集中式团队本身可能会成为单点故障，即使自动扩缩器基础架构在设计时考虑了高可用性。

如需了解如何使用集中式拓扑设置自动扩缩器，请参阅集中式部署分步指南。

分布式拓扑

在分布式拓扑部署中，Cloud Scheduler 和需要自动扩缩的 Spanner 实例位于同一项目中。自动扩缩器工具的其余组件位于一个集中管理的项目中。此部署是混合部署。拥有 Spanner 实例的团队仅管理其实例的自动扩缩器配置参数，而中心团队负责管理其余的自动扩缩器基础架构。

下图显示分布式项目部署的高度概括的概念视图。

上图中描述的混合部署具有以下特征：

两个应用（应用 1 和应用 2）使用各自的 Spanner 实例。

Spanner 实例 (A) 位于应用 1 和应用 2 项目中。

独立的 Cloud Scheduler 组件 (C) 将部署到每个项目中：应用 1 和应用 2。

将其余的自动扩缩器组件 (B) 部署到单独的项目中。

自动扩缩器工具使用每个项目中独立 Cloud Scheduler 组件发送的配置，自动扩缩应用 1 和 2 项目中的 Spanner 实例。

转发器函数

Cloud Scheduler 只能向同一项目中的主题发布消息，因此对于分布式拓扑，需要一个名为转发器函数的中间组件。

转发器函数将消息从 Cloud Scheduler 中发布到 Pub/Sub，检查其 JSON 语法，然后将其转发到“轮询器 Pub/Sub”主题。该主题可以属于 Cloud Scheduler 的一个单独项目。

下图显示了用于转发机制的组件：

如上图所示，Spanner 实例位于名为应用 1 和应用 2 的项目中：

Cloud Scheduler 与 Spanner 实例属于同一项目。

(2a) Cloud Scheduler 会将其消息发布到应用 1 和应用 2 项目中的转发器主题。

(2b) 转发器函数从转发器主题中读取消息。

(2c) 转发器函数将消息转发到自动扩缩器项目中的轮询主题。

轮询器函数从轮询主题中读取消息，然后继续执行该过程，如轮询器部分中所述。

分布式部署具有以下优势和缺点。

优点：

应用团队控制配置和时间表：Cloud Scheduler 与进行自动扩缩的 Cloud Spanner 实例一起部署，从而让应用团队可更好地控制配置和调度。

运维团队控制基础架构：自动扩缩器工具的核心组件集中部署，从而让运维团队可控制自动扩缩器基础架构。

集中式维护：扩缩器基础架构是集中式的，降低了开销。

缺点：

配置更复杂：应用团队需要提供服务账号才能向轮询主题进行写入。

可能会面临额外风险：共享基础架构可能会成为单点故障，即使基础架构在设计时考虑了高可用性。

如需了解如何使用分布式拓扑设置自动扩缩器，请参阅分布式部署分步指南。

后续步骤

了解如何将自动扩缩器工具部署到 GKE。

详细了解 Spanner 建议的阈值。

详细了解 Spanner CPU 利用率指标和延迟时间指标。

了解 Spanner 架构设计的最佳实践，以避免热点并将数据加载到 Spanner。

探索有关 Google Cloud 的参考架构、图表和最佳做法。查看我们的 Cloud 架构中心。

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
