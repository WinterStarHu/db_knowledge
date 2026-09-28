# 移动实例  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/move-instance

移动实例  |  Spanner  |  Google Cloud Documentation

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

移动实例

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何在 Spanner 中迁移实例。

您可以将 Spanner 实例从任何实例配置迁移到任何其他实例配置，包括在单区域、双区域和多区域配置之间迁移。迁移实例不会导致停机，并且 Spanner 会在迁移过程中继续提供常规事务保证，包括强一致性。

您还可以将实例从其源实例配置迁移到自定义实例配置（例如，具有 us-west2 只读副本的 nam3 基本配置）。由于您无法更新现有实例配置的拓扑，因此需要先创建具有所需拓扑的新的自定义实例配置。创建新的自定义实例配置后，您可以将实例从源实例配置迁移到新的自定义实例配置。

为什么要迁移 Spanner 实例？

迁移实例的好处包括：

提高可用性：执行单区域到双区域或多区域迁移后，可实现 99.999% 的可用性，且停机时间为零。

缩短延迟时间：通过单区域到双区域或多区域的迁移，或者多区域到多区域的迁移，使用额外的只读副本缩短延迟时间并扩大地理覆盖范围。

降低费用：通过从双区域或多区域配置迁移到单区域配置，可降低每小时费用。

共置数据库：通过将实例迁移到更优化的位置，将 Spanner 数据库与客户端应用共置在同一位置。

价格

迁移实例时，源实例配置和目标实例配置均需按小时支付计算和存储费用。迁移完成后，您需要按目标配置为实例存储付费。

如果您要将实例迁移到新的单区域、双区域或多区域实例配置，则可能需要支付出站数据传输费用。如需了解详情，请参阅 Spanner 价格。

限制

如需迁移实例，该实例必须至少具有 1 个节点（1,000 个处理单元）。

您无法在不同项目和 Google Cloud 账号之间迁移实例。

您无法将使用标准版的实例直接从单区域实例配置迁移到双区域或多区域实例配置。您必须先将实例的版本升级到企业 Plus 版，然后再迁移实例。

如果您的活跃请求在任何实例资源上使用区域服务端点，则实例迁移会影响所有使用区域端点的请求，因为区域级强制执行会阻止对跨区域实例的访问。使用全球端点的请求不受影响。

Spanner 备份特定于实例配置，并且在迁移实例时不包含在内。如需了解详情，请参阅备份。

在实例迁移期间，以下 API 会被停用：

InstanceAdmin.DeleteInstance

InstanceAdmin.UpdateInstance

DatabaseAdmin.CreateDatabase

DatabaseAdmin.UpdateDatabaseDdl（如果在请求中指定了 default_leader，则此 API 会被停用。）

DatabaseAdmin.RestoreDatabase

DatabaseAdmin.CreateBackup

DatabaseAdmin.CreateBackupSchedule

DatabaseAdmin.CopyBackup

如果数据库具有修改后的默认主要区域，那么如果在目标实例配置中指定了读写区域，并且该配置是多区域配置，则系统会保留选择。如果目标配置是单区域配置，或者不包含指定的读写区域，则系统会清除默认主要区域选择。

迁移实例会更改实例的实例配置属性。如果您通过自动化管理 Spanner 资源，请务必做好准备并解决可能出现的任何不一致情况。

例如，如果您使用 Terraform 管理 Spanner 实例和数据库，并启用 terraform apply --auto-approve 以保持资源同步，则在迁移实例时，系统会删除所有实例和子资源。请相应地更新配置，以避免删除和数据丢失。如需详细了解 apply 命令，请参阅 Terraform Apply 选项。

在实例迁移期间，Spanner 监控指标和图表可能会同时显示源实例配置和目标实例配置中的数据，也可能仅反映一种实例配置中的性能。

如果您配置了开源自动扩缩器工具，则无需停用该工具。由于 InstanceAdmin.UpdateInstance（用于节点和处理单元更改）已停用，该工具会出现故障。

如果实例上启用了 Spanner 托管式自动扩缩器功能，您将无法迁移该实例。如需迁移实例，您需要停用托管式自动扩缩器，迁移实例，然后重新启用托管式自动扩缩器。

此外，如果您使用自动扩缩，则必须根据所述的最大建议值来预配足够的节点以应对 CPU 使用率高峰，然后在迁移实例之前停用自动扩缩功能。

您无法迁移 Spanner 免费试用实例。升级到付费实例后，您可以迁移该实例。

性能考虑因素

迁移实例时，实例的读写延迟时间较长，事务中止率也较高。迁移期间的 CPU 利用率可能会升至 100%，因为实例迁移是使用用户预配的空闲 CPU 执行的。不过，迁移实例不会造成任何停机。迁移实例所需的时间取决于多种因素，包括数据库的大小、节点数量和迁移类型（例如从单区域迁移到多区域）。

迁移实例后，实例的性能会因实例配置的详细信息而异。例如，双区域和多区域配置通常具有比单区域配置更高的写入延迟时间和更低的读取延迟时间。

备份

迁移实例时，实例原始配置中的备份不会自动迁移到新的目标配置。如果您在开始实例迁移时，实例的原始配置中存在备份，则系统会中止实例迁移。在迁移实例之前，请务必复制备份并考虑数据恢复计划。

如果实例的原始配置中有需要保留的备份，建议您将备份复制到两个小型 (100 PU) 临时实例 placeholder-source 和 placeholder-dest：

placeholder-source：与迁移实例的原始配置具有相同实例配置的实例。这样，如果您需要取消迁移，便可以将备份恢复到原始配置。

placeholder-dest：与目标实例配置具有相同实例配置的实例。这样可确保在迁移完成后，您立即就能在新配置中使用备份。

恢复功能不支持跨配置恢复，因此这些占位实例对于在需要时快速回滚或恢复到新配置至关重要，可在迁移的实例出现任何问题时提供安全保障。

将备份复制到 placeholder-source 和 placeholder-dest 后，您必须先删除实例原始配置中的所有现有备份，然后才能迁移该实例。随后一旦实例迁移完成，您便已经在目标配置中拥有备份的副本。您还可以创建新备份。

通过采用这种方法，您可以确保业务连续性，并最大限度地减少实例迁移过程中的潜在停机时间或数据丢失。

如何迁移实例

您可以通过 Google Cloud 控制台 Cloud Shell 和 gcloud CLI（使用 gcloud 命令）迁移实例。

前提条件

在迁移实例配置之前，请确保您已阅读限制和性能注意事项部分。然后按照以下步骤操作：

检查您是否拥有迁移实例的 spanner.instances.update IAM 权限。

如果适用，请先迁移非生产实例（例如测试和预演），然后再迁移生产实例，以便评估和了解实例迁移期间对工作负载的性能影响。

当您迁移 Spanner 实例时，迁移过程会删除您在 Data Catalog 中创建的实例标记。如需保留您的标记，您需要在迁移之前导出标记，并在迁移之后导入标记。如需了解详情，请参阅导出和导入标记。

如需了解最佳实践，另请遵循以下准则：

在迁移生产实例之前，先在目标实例配置的非生产实例中测试性能工作负载。尝试迁移与生产实例类似的预演实例，以了解迁移生产实例需要多长时间。

使用 Key Visualizer 检查数据库中是否存在热点。

检查以确保目标实例配置中具有足够的节点配额，以支持实例的预期用量峰值。如需了解详情，请参阅 Spanner 配额和限制。

确保对于您迁移的实例配置，实例的 CPU 利用率峰值低于 40%，并且每个节点的存储空间量低于 1 太比字节 (TiB)。

在迁移过程中，请勿更改实例。这包括更改实例节点数、更改数据库架构、创建或删除数据库以及创建或删除备份。

如果您根据这些建议迁移实例，则迁移通常会在 24 小时内完成。不过，完成时间可能会更长或更短，具体取决于应用工作负载。

移动实例

Google Cloud 控制台注意：您无法使用 Google Cloud 控制台迁移包含启用了 CMEK 的数据库的实例。请使用 gcloud CLI 迁移实例。

前往 Google Cloud 控制台中的实例页面。

实例

选择要迁移的实例。

在“实例概览”页面上，点击配置旁边的 edit 将实例移至新配置。

在将实例移至新配置窗格中，为实例选择新实例配置。

点击保存。

gcloud CLI 使用 gcloud spanner instances move 命令可迁移实例。

gcloud spanner instances move INSTANCE_ID \ --target-config=TARGET_CONFIG

替换以下内容：

INSTANCE_ID：要迁移的实例的永久性标识符。

TARGET_CONFIG：要将实例迁移到的实例配置的永久性标识符。实例的新地理位置。这可以是单区域、双区域或多区域实例配置（例如 nam3、regional-us-central1 或 custom-nam3-us-west2）。

例如，如需将实例 test-instance 从当前实例配置迁移到 nam3，请运行以下命令：

gcloud spanner instances move test-instance --target-config=nam3

可选：如果您想将 us-west2 区域中的只读副本添加到 nam3 中的基本实例配置，请执行以下操作：

克隆基本配置，并将只读副本添加到新的自定义实例配置 custom-nam3-us-west2：

gcloud spanner instance-configs create custom-nam3-us-west2 \ --clone-config=nam3 --add-replicas=location=us-west2, type=READ_ONLY

将实例 test-instance 从当前实例配置迁移到新的 custom-nam3-us-west2 实例配置：

gcloud spanner instances move test-instance --target-config=custom-nam3-us-west2

可选：迁移具有启用了 CMEK 的数据库的实例

使用 gcloud spanner instances move 命令可迁移具有启用了 CMEK 的数据库的实例。您必须在命令中添加 --target-database-move-configs 标志和 KMS 密钥值，或者使用必要的 KMS 密钥配置 JSON 或 YAML 文件。

使用说明：

如果您要迁移的实例中有多个启用了 CMEK 的数据库，则必须为每个数据库指定 --target-database-move-configs。您可以为每个数据库使用相同的密钥，但必须为每个启用了 CMEK 的数据库指定密钥。

您的密钥必须涵盖目标实例配置中的所有区域。例如，如果目标实例配置位于 nam3，则您必须在 regional-us-east4、regional-us-east1 和 regional-us-central1 中设置密钥。

迁移实例时，您无法为未启用 CMEK 的数据库设置 KMS 密钥。

迁移实例时，您不应在源实例配置或目标实例配置中停用或销毁 CMEK 密钥。如果您尝试该操作，则迁移不会继续进行。

gcloud spanner instances move INSTANCE_ID \ --target-config=TARGET_CONFIG \ --target-database-move-configs=^:^database-id=DATABASE_ID_1:kms-key-names=KMS_KEY_1[, KMS_KEY_2 ... ] \ [--target-database-move-configs=^:^database-id=DATABASE_ID_2:kms-key-names=KMS_KEY_1 ... ]

或

gcloud spanner instances move INSTANCE_ID \ --target-config=TARGET_CONFIG \ --target-database-move-configs=CONFIG_FILE_PATH

使用数据库 ID 和 KMS 密钥配置 CONFIG_FILE_PATH 文件。以下配置文件示例包含两个数据库（database-1 和 database-2）的 KMS 密钥，这些密钥在 regional-us-east4、regional-us-east1 和 regional-us-central1 中都相同，以涵盖 nam3 中的所有区域。

[ { database-id: database-1, kms-key-names:
"projects/[your-project]/locations/us-east4/keyRings/[your-keyring]/cryptoKeys/[your-key],projects/[your-project]/locations/us-east1/keyRings/[your-keyring]/cryptoKeys/[your-key],projects/[your-project]/locations/us-central1/keyRings/[your-keyring]/cryptoKeys/[your-key]", }, { database-id: database-2, kms-key-names:
"projects/[your-project]/locations/us-east4/keyRings/[your-keyring]/cryptoKeys/[your-key],projects/[your-project]/locations/us-east1/keyRings/[your-keyring]/cryptoKeys/[your-key],projects/[your-project]/locations/us-central1/keyRings/[your-keyring]/cryptoKeys/[your-key]", }, ]

如何监控实例迁移和取消进度

您可以使用 gcloud spanner operations describe 或创建自定义 Cloud Monitoring 信息中心来监控实例迁移的进度。

查看迁移和取消操作进度

如需跟踪实例迁移或实例迁移取消操作的进度，请使用 gcloud spanner operations describe 命令。此命令需要正在进行的实例迁移操作的操作 ID。

运行以下命令，以获取实例迁移操作的操作 ID：

gcloud spanner operations list --instance="INSTANCE_ID"

替换以下内容：

INSTANCE_ID：要迁移的实例的永久性标识符。

输出会显示长时间运行的操作的列表，包括实例迁移操作。

运行 gcloud spanner operations describe 命令以查看进度百分比和状态：

gcloud spanner operations describe OPERATION_ID --instance=INSTANCE_ID

替换以下内容：

OPERATION_ID：要检查的实例迁移操作的操作 ID。

INSTANCE_ID：要检查的实例的实例 ID。

监控实例迁移操作

您可以创建自定义 Cloud Monitoring 信息中心，以便在实例迁移期间显示和监控指标。实例迁移是一项长时间运行的操作，可能会对服务产生影响。

信息中心内的总存储空间和总数据库存储空间（按数据库）图表有助于监控迁移进度。您会看到，源配置中的存储内容逐渐减少，而目标配置中的存储内容增加。

Google Cloud 控制台

下载 move-instance-dashboard.json 文件。 此文件包含在 Monitoring 中填充自定义信息中心所需的信息。

在 Google Cloud 控制台中，前往  信息中心页面： 前往信息中心

如果您使用搜索栏查找此页面，请选择子标题为监控的结果。

在信息中心概览页面中，点击创建信息中心。

在信息中心工具栏中，点击信息中心设置下拉菜单。然后选择 JSON，再选择 JSON 编辑器。

在 JSON 编辑器窗格中，复制您下载的 move-instance-dashboard.json 文件的内容，并将其粘贴到编辑器中。

如需将更改应用于信息中心，请点击应用更改。如果您不想使用此信息中心，请返回到“信息中心概览”页面。

创建信息中心后，点击添加过滤条件。然后选择 project_id 或 instance_id，以监控实例迁移的进度。

gcloud CLI

下载 move-instance-dashboard.json 文件。 此文件包含在 Monitoring 中填充自定义信息中心所需的信息。

如需在项目中创建信息中心，请使用 gcloud monitoring dashboards create 命令：

gcloud monitoring dashboards create --config-from-file=move-instance-dashboard.json

如需了解详情，请参阅 gcloud monitoring dashboards create 参考文档。

如何取消实例迁移

您只能取消仍在进行中的实例迁移。如果您想还原已完成的实例迁移，则必须开始新的迁移。

您可以使用 gcloud spanner operations cancel 取消实例迁移操作。取消操作不会立即完成，所需时间大致与自迁移开始以来经过的时间相同。这是因为数据必须迁移回源实例配置。

此命令需要正在进行的实例迁移操作的操作 ID。

运行以下命令以获取操作 ID：

gcloud spanner operations list --type=INSTANCE --instance="INSTANCE_ID" --filter="done:False AND metadata.@type:MoveInstanceMetadata

替换以下内容：

INSTANCE_ID：要迁移的实例的永久性标识符。

输出会显示正在进行的实例迁移操作的列表。

运行 gcloud spanner operations cancel 命令以取消实例迁移：

gcloud spanner operations cancel OPERATION_ID

替换以下内容：

OPERATION_ID：要取消的实例迁移操作的操作 ID。

后续步骤

详细了解 Spanner 单区域、双区域和多区域配置。

详细了解Google Cloud 区域和可用区。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-14。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-14。"],[],[]]

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
