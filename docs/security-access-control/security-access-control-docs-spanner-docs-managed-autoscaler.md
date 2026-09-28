# 托管式自动扩缩器  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/managed-autoscaler

托管式自动扩缩器  |  Spanner  |  Google Cloud Documentation

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

托管式自动扩缩器

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

注意：此功能适用于 Spanner 企业版和企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

本页介绍了托管式自动扩缩器的运作方式，以及使用 Spanner 受管自动扩缩器时的费用和限制。此外，它还提供了一些信息，可帮助您确定如何配置托管式自动扩缩器。

托管式自动扩缩器的工作原理

启用托管式自动扩缩器后，Spanner 会自动调整实例的大小。托管式自动扩缩器功能会根据实例工作负载或存储需求的变化（例如负载增加或减少）做出相应调整。托管式自动扩缩功能会扩容（向实例添加计算容量）或缩容（从实例中移除计算容量）。

配置托管式自动扩缩器时，您可以为小型实例使用处理单元，也可以为大型实例使用节点。在本文档中，我们使用“计算容量”一词来表示节点或处理单元。

Spanner 托管式自动扩缩器会根据以下因素确定所需的计算容量：

高优先级 CPU 利用率目标

存储空间利用率目标

下限

最大限额

每个扩缩维度都会生成建议的实例大小，Spanner 会自动使用最高的实例大小。这意味着，例如，如果实例需要 10 个节点来满足存储空间利用率目标，但需要 12 个节点来满足 CPU 利用率目标，则 Spanner 会将实例扩容到 12 个节点。

随着计算容量的变化，Spanner 会不断优化存储空间。它会重新平衡所有服务器上的数据，以确保流量均匀分布，并且没有单个服务器过载。如需了解详情，请参阅限制。

如果托管式自动扩缩器将实例扩容到上限，但工作负载仍导致 CPU 利用率高于目标值，则工作负载请求可能会出现延迟时间较长或失败的情况。如果实例扩容到其最大计算容量目标值，但工作负载需要的存储空间超过了存储空间上限，则写入请求可能会失败。如需了解是否已达到最大目标值，您可以在 Google Cloud 控制台的系统分析洞见页面中查看托管式自动扩缩器系统事件日志。如需了解详情，请参阅存储空间限制。

当 Spanner 缩减实例时，移除计算容量的速度会比扩容时慢，以减少对延迟时间的任何影响。

您可以选择以非对称方式自动扩缩只读副本。如需了解详情，请参阅非对称只读自动扩缩。

费用

您的 Spanner 总费用可能会因您在启用托管式自动扩缩器之前配置 Spanner 实例的方式以及您为托管式自动扩缩器设置的限制而有所不同。

例如，如果您过去常常手动配置 Spanner 实例，使其具有足够的计算容量来随时处理高峰工作负载，那么使用托管式自动扩缩器后，您的费用可能会降低，因为该扩缩器会在实例处于空闲状态时减少计算容量。

如果您之前手动配置 Spanner 实例，使其具有足够的计算容量来应对平均工作负载，但当工作负载流量增加时，整体性能会下降，那么使用托管式自动扩缩器后，您的费用可能会更高，因为当实例繁忙时，托管式自动扩缩器可能会增加计算容量。不过，这可为用户提供更稳定的性能。

您可以将节点数或处理单元数上限设置为您希望支出的水平，从而限制 Spanner 实例的最高费用。

限制

在实例上启用或更改托管式自动缩放功能时，存在以下限制：

启用托管式自动扩缩器功能后，您无法移动实例。您必须先停用托管式自动扩缩器，然后再迁移实例。迁移实例后，您可以重新启用托管式自动扩缩器。

您必须将自动扩缩实例的最小限制设置为 1000 个处理单元或更多，或者 1 个节点或更多。

在现有实例上启用自动扩缩功能后，现有实例的容量可能低于您在托管式自动扩缩器上配置的下限值。不过，当您启动实例时，实例会自动扩容到配置的最小值。例如，如果您的实例只有一个节点，但您将最小值设置为两个节点，那么当您启动实例时，该实例会自动扩容到 2 个节点。

如果某个可用区或区域发生故障，托管式自动扩缩器会扩缩高优先级工作负载的 CPU，以遵循 Spanner 的高优先级 CPU 建议。它不考虑总 CPU 利用率。当 CPU 利用率超过 100% 时，可能会导致性能下降。如果您的工作负载对延迟时间或性能非常敏感，不妨考虑自定义开源自动扩缩器工具，以便根据总 CPU 进行扩缩。

托管式自动扩缩器参数

创建或修改实例并选择启用托管式自动扩缩器时，您可以定义下表中显示的值。

参数 说明

高优先级 CPU 利用率目标

实例高优先级 CPU 容量的百分比。此值必须介于 10% 到 90% 之间。如果实例的 CPU 利用率超过您设置的目标，Spanner 会立即为该实例增加计算容量。当 CPU 利用率显著低于目标值时，Spanner 会移除计算容量。如需获取相关指导，请参阅确定 CPU 利用率目标。

存储空间利用率目标

在 Spanner 扩容之前，您可以使用节点上存储空间的百分比。此目标可确保始终有足够的计算容量来处理您存储的数据量波动。此值必须介于 10% 到 99% 之间。如需获取相关指导，请参阅确定存储空间利用率目标。

下限

Spanner 将实例缩减到的最低计算容量。最小值不能低于您为上限设置的值的 10%。例如，如果上限为 40 个节点，则下限必须至少为 4 个节点。10% 的要求是硬性限制。 如需获取相关指导，请参阅确定下限。

最大限额

Spanner 将实例扩容到的最高计算容量。对于节点，此值必须大于 1 个节点（或 1000 个处理单元），并且大于或等于节点数或处理单元数下限。该值不能超过您为计算容量下限选择的数值的 10 倍。此 10 倍要求是硬性限制。如需获取相关指导，请参阅确定上限。

配置托管式自动扩缩器

本部分介绍如何确定为托管式自动扩缩器参数选择哪些数值。设置初始值后，监控您的实例并在必要时调整数量。

确定高优先级 CPU 利用率目标

实例的最佳目标取决于工作负载的延迟时间和吞吐量需求。如需查看我们针对单区域、双区域和多区域实例配置建议的最大 CPU 利用率，请参阅高 CPU 利用率提醒。

托管式自动扩缩器在扩缩 CPU 使用量时会考虑高优先级工作负载。它不考虑总 CPU 利用率。当 CPU 利用率超过 100% 时，可能会导致性能下降。如果您的工作负载对延迟时间或性能非常敏感，请考虑自定义开源自动扩缩器工具，以便根据总 CPU 进行扩缩。

通常，如果观察到延迟时间过长，则应降低 CPU 利用率目标。

确定存储空间利用率目标

对于自动扩缩，存储空间利用率目标以每个节点的百分比表示。对于 1 个节点（1000 个处理单元）及更大的实例，存储空间大小限制为每个节点 10 TiB。

确定上限

您选择作为计算容量上限的值应等于实例处理最大流量所需的计算容量，即使您预计大部分时间不会达到该容量也是如此。Spanner 扩容的计算容量绝不会超出所需的数量。您也可以将此数字视为您愿意支付的最高计算容量。如需详细了解接受的值，请参阅自动扩缩器参数。

最大限值必须同时满足您为自动扩缩设置的 CPU 利用率目标和存储空间利用率目标。

如果要将实例从手动分配更改为托管式自动扩缩，请查找实例在过去一到两个月内拥有的计算容量上限。您的托管式自动扩缩器上限应至少达到此值。

如果您要为新实例启用托管式自动扩缩器，请查看其他实例的指标，并在设置上限时将其作为参考。

如果您有新的工作负载，并且不确定其增长情况，则可以估算需要满足内置存储空间利用率目标的计算容量，并在稍后再调整该容量。

您还需要了解节点的剩余配额，因为托管式自动扩缩器无法将实例配置为具有超出配额的计算容量。如需了解详情，请参阅节点限制。

实例启动后并在启用自动扩缩功能的情况下运行时，监控实例并确保您为上限选择的值至少与 CPU 目标建议上限和存储空间目标建议上限相同。

确定下限

您可以为托管式自动扩缩器设置下限，以确保您的 Spanner 实例可以缩容到最小、最经济实惠的大小。Spanner 会自动防止节点数低于保持 CPU 和存储空间利用率目标所需的最小值。

托管式自动扩缩器允许的最小下限值为 1 个节点或 1000 个处理单元。如果您为现有实例启用自动扩缩功能，但该实例的容量小于为托管式自动扩缩器配置的最小值，那么当您启动该实例时，该实例会自动扩容到此最小值。

启动已启用托管式自动扩缩的实例后，您应执行初始测试，以确保该实例能够以设置的最小规模运行。您应定期再次测试，以确保其继续按预期运行。

如需详细了解接受的值，请参阅本文档中的托管式自动扩缩器参数。

在许多情况下，您需要将最小值设置为多个值。在以下情况下，选择更大的数字或提高下限：

您有一个即将到来的高峰规模事件，预计流量会暂时增加，并且希望确保有足够的计算容量。

应用发送的流量急剧增加。当您添加新的计算容量时，Spanner 会自动重新平衡以使用新节点或处理单元。由于此过程可能需要几分钟，因此您不妨考虑采用保守的方法并选择更高的最小值。这样，您的实例就可以顺畅地应对高峰。

增加计算容量上限。下限必须始终为计算容量目标上限的 10% 或更多。例如，如果您将节点数上限设置为 30，则必须将节点数下限设置为至少 3。

如果您提高实例的最小计算容量值，Spanner 会立即尝试将实例扩容至新的最小值。适用标准限制。当您超出配额时，更改托管式自动扩缩器配置的请求会失败，并且配置不会更新。

首次配置托管式自动扩缩器后，以及之后定期测试实例，以确保实例以最小规模正常运行。

Google Cloud CLI 参数标志和限制

使用 Google Cloud CLI 配置托管式自动扩缩器时，您必须设置一些必需的标志。您可以使用可选标志来指明要使用节点还是处理单元。如需详细了解如何创建启用了托管式自动扩缩器的新实例，或如何在现有实例上启用托管式自动扩缩，请参阅以下内容：

创建实例

在实例上启用或修改托管式自动扩缩器

在实例上启用托管式自动扩缩器时，需要使用以下标志：

autoscaling-high-priority-cpu-percent

autoscaling-storage-percent

如果您选择使用节点，则在启用托管式自动扩缩器时，还必须使用以下两个标志：

autoscaling-min-nodes

autoscaling-max-nodes

如果您选择使用处理单元，则在启用托管式自动扩缩器时，还必须使用以下两个标志：

autoscaling-min-processing-units

autoscaling-max-processing-units

使用 Google Cloud CLI 将托管式自动扩缩器添加到现有实例时，存在以下限制：

您不能将 --nodes 标志与 --autoscaling-min-nodes 或 --autoscaling-max-nodes 标志搭配使用，因为使用 --nodes 会设置特定数量的节点，而不是扩缩范围。同样，您不能将 --processing-units 标志与 autoscaling-min-processing-units 或 autoscaling-max-processing-units 标志搭配使用，因为使用 --processing-units 会设置特定数量的处理单元，而不是缩放范围。

您不能将节点和处理单元的标志混用。例如，您不能将 --autoscaling-max-nodes 与 autoscaling-min-processing-units 搭配使用。

微调设置

密切关注计算容量使用情况，并在必要时调整设置，尤其是在首次启用托管式自动扩缩器后。建议使用 Google Cloud 控制台中的系统分析洞见页面。

非对称只读自动扩缩 注意： 您无法将非对称自动扩缩功能与读写副本和见证副本搭配使用。

启用托管式自动扩缩器后，您还可以启用只读副本并独立于其他副本自动扩缩只读副本。借助非对称只读自动扩缩，您可以根据只读区域的用量来控制其计算容量限制和 CPU 利用率目标值。这样可以优化本地读取流量模式并提高成本效益。以下自动扩缩配置参数可针对每个只读副本区域进行配置：

最低计算容量限制

计算容量上限

高优先级 CPU 利用率目标

您可以通过创建新实例或更新现有实例来启用非对称自动扩缩并配置这些参数。

对于每个副本，在现有实例上启用非对称自动扩缩时，适用以下规则：

如果副本的当前计算容量介于为相应区域设置的自动扩缩最小值和最大值之间，则副本的计算容量不会发生变化。

如果副本的当前计算容量低于为相应区域设置的自动扩缩下限，则计算容量会调整为与自动扩缩下限一致。

如果副本的当前计算容量高于为相应区域设置的自动扩缩上限，则计算容量会调整为与自动扩缩上限一致。

访问权限控制

如需配置托管式自动扩缩器，您必须是具有所配置实例的创建和更新权限的角色的主账号。

监控

Spanner 提供了多种指标，可帮助您了解托管式自动扩缩器在扩容和缩容规模以满足工作负载要求时的工作效果。这些指标还可以帮助您衡量您的设置是否最符合您的企业的工作负载和费用要求。例如，如果您发现实例的节点数通常接近节点数上限，则可以考虑提高节点数上限。如需详细了解如何监控 Spanner 资源，请参阅使用 Cloud Monitoring 监控实例。

以下指标显示在 Google Cloud 控制台的系统分析洞见页面上的图表中。您还可以使用 Cloud Monitoring 查看这些指标。

spanner.googleapis.com/instance/autoscaling/min_node_count

spanner.googleapis.com/instance/autoscaling/max_node_count

spanner.googleapis.com/instance/autoscaling/min_processing_units

spanner.googleapis.com/instance/autoscaling/max_processing_units

spanner.googleapis.com/instance/autoscaling/high_priority_cpu_target_utilization

spanner.googleapis.com/instance/autoscaling/storage_target_utilization

日志记录

Spanner 会在每次扩缩实例时创建系统事件审核日志。每个事件日志都包含与自动扩缩事件相关的说明文本和元数据。

在“系统分析洞见”页面上查看日志

您可以在Google Cloud 控制台的系统分析洞见页面中查看托管式自动扩缩器系统事件日志。

在 Google Cloud 控制台中，打开 Spanner：

转到 Spanner

选择已启用自动扩缩功能的实例。

在导航菜单中，点击系统分析洞见。

在“系统分析洞见”页面上，找到计算容量指标。

点击查看日志以打开日志面板。

计算容量日志窗格显示过去一小时的日志。

如果您的实例启用了非对称只读自动扩缩，则日志摘要会提供每个副本的计算容量变化的说明和位置。例如 Increased from 1 to 2 nodes in us-central1 to maintain high priority CPU utilization at 80%。如果您未使用非对称自动扩缩，则日志摘要中不会提供位置信息。例如 Increased from 9 to 10 nodes to maintain high priority CPU utilization at 65%。

使用 Logs Explorer 查看日志

您还可以使用Logs Explorer查看日志：

在 Google Cloud 控制台中，打开 Logs Explorer：

转到日志浏览器

选择相应的 Google Cloud 项目。

在查询字段中，输入以下查询：

protoPayload.methodName="AutoscaleInstance"

您可以添加以下查询，进一步过滤日志：

resource.type="spanner_instance" resource.labels.instance_id=INSTANCE_ID resource.labels.project_id=PROJECT_ID logName="projects/span-cloud-testing/logs/cloudaudit.googleapis.com%2Fsystem_event" protoPayload.methodName="AutoscaleInstance"

点击运行查询。

查询结果窗格显示过去一小时的日志。

如需详细了解如何查看日志，请参阅 Cloud Logging。
您可以在 Google Cloud 中的Logs Explorer页面中或使用 Cloud Monitoring API 设置基于日志的提醒。

后续步骤

了解如何创建启用了托管式自动扩缩器的实例

了解如何修改实例以添加自动扩缩或更改自动扩缩设置

了解如何将实例从使用自动扩缩更改为手动扩缩

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-02-20。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-02-20。"],[],[]]

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
