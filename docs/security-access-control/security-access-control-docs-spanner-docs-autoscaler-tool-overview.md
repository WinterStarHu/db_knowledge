# 自动扩缩器工具概览  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/autoscaler-tool-overview

自动扩缩器工具概览  |  Spanner  |  Google Cloud Documentation

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

自动扩缩器工具概览

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了 Spanner 的自动扩缩器工具（自动扩缩器）。它是一种开源工具，可用作 Spanner 的配套工具。借助此工具，您可以根据容量的使用量自动增加或减少一个或多个 Spanner 实例中的计算容量。

如需详细了解 Spanner 中的扩缩，请参阅自动伸缩 Spanner。如需了解如何部署自动扩缩器工具，请参阅以下内容：

将 Spanner 的自动扩缩器工具部署到 Cloud Run functions。

将 Spanner 的自动扩缩器工具部署到 Google Kubernetes Engine (GKE)。

本页面介绍了自动扩缩器的功能、架构和高级别配置。这些主题将引导您完成在每种不同拓扑中将自动扩缩器部署到某个受支持的运行时。

自动扩缩器

自动扩缩器工具对于管理 Spanner 部署的利用率和性能非常有用。为了帮助您在费用控制和性能需求之间取得平衡，自动扩缩器会监控您的实例并自动添加或移除节点或处理单元，以帮助确保它们保持在以下参数范围内：

建议的 CPU 利用率最大值。

每个节点的建议存储限制。

加上或减去可配置的边际。

自动扩缩 Spanner 部署可让您的基础设施自动适应和扩缩以满足负载要求，且几乎不需要干预。自动扩缩还可适当调整预配的基础设施的规模，从而帮助您最大限度地减少产生的费用。

架构

自动扩缩器有两个主要组件，即轮询器和扩缩器和 。虽然您可以将具有不同配置的自动扩缩器部署到具有不同配置的多个拓扑中的多个运行时，但这些核心组件的功能是相同的。

本部分详细介绍了这两个组件及其用途。

轮询器

轮询器负责收集和处理一个或多个 Spanner 实例的时序指标。轮询器对每个 Spanner 实例的指标数据进行预处理，以便仅评估最相关的数据点并将其发送到扩缩器。轮询器执行的预处理还可以简化区域级、双区域和多区域 Spanner 实例的阈值的评估流程。

扩缩器

扩缩器会评估从轮询器组件接收的数据点，并确定是否需要调整节点或处理单元数量，以及如果需要，则调整多大的幅度。扩缩器会将指标值与阈值进行比较，加上或减去允许的边际，并根据配置的扩缩方法调整节点或处理单元数量。如需了解详情，请参阅扩缩方法。

在整个流程中，自动扩缩器工具会将建议和操作的摘要写入 Cloud Logging 以进行跟踪和审核。

自动扩缩器功能

本部分介绍了自动扩缩器工具的主要功能。

管理多个实例

自动扩缩器工具能够跨多个项目管理多个 Spanner 实例。多区域级实例、双区域实例和区域级实例在扩缩时使用的利用率阈值各不相同。例如，多区域级部署和双区域部署在 45% 高优先级 CPU 利用率时进行扩缩，而区域级部署在 65% 的高优先级 CPU 利用率时进行扩缩，两者加上或减去允许的边际。如需详细了解不同的扩缩阈值，请参阅针对高 CPU 利用率的提醒。

独立的配置参数

每个自动扩缩的 Spanner 实例可以有一个或多个轮询时间表。每个轮询时间表都有自己的一组配置参数。

这些参数确定以下因素：

控制实例大小的节点数或处理单元数上限和上限，可帮助您控制产生的费用。

扩缩方法，用于调整工作负载特有的 Spanner 实例。

冷却期，可让 Spanner 管理数据分块。

扩缩方法

自动扩缩器工具提供了三种不同的扩容和缩容 Spanner 实例的方法：阶梯、线性和直接。每种方法旨在支持不同类型的工作负载。创建独立的轮询时间表时，您可以将一个或多个方法应用于自动扩缩的每个 Spanner 实例。

以下部分包含有关这些扩缩方法的更多信息。

阶梯

阶梯扩缩对于规模较小或具有多个峰值的工作负载非常有用。它预配了容量，可通过一个自动扩缩事件平滑处理所有工作负载。

下图显示了具有多个负载水平或阶梯的负载模式，其中每个阶梯有多个小峰值。此模式非常适合阶梯方法。

超过负载阈值时，此方法会使用固定但可配置的数字预配和移除节点或处理单元。例如，系统会为每个扩缩操作添加或移除三个节点。通过更改配置，您可以允许在任何时间添加或移除增量更大的容量。

线性

线性扩缩最适合负载逐步变化或具有一些大峰值的负载模式。该方法会计算使利用率低于扩缩阈值所需的最小节点数或处理单元数。 每个扩缩事件中添加或移除的节点或处理单元数量不限于固定步数。

下图中的示例负载模式展示了负载较大的突然增加和减少。这些波动不会像在上一张图表中的阶梯一样明显。使用线性扩缩可能会更好地处理此模式。

自动扩缩器工具会使用观察到的利用率与利用率阈值的比率，计算在当前总数中增加还是减少节点数或处理单元数。

计算新节点或处理单元数的公式如下所示：

newSize = currentSize * currentUtilization / utilizationThreshold

直接

直接扩缩功能可以即时提升容量。此方法旨在支持批处理工作负载，在其中，需要定期按已知的开始时间调度预先定义的较高节点计数。此方法会将实例扩容到在时间表中指定的节点或处理单元数量上限，并且旨在用作线性或阶梯方法之外的补充方法。

下图描述了负载计划的计划大幅增加，而自动扩缩器为使用直接方法提前预配了容量。

当批量工作负载完成并且利用率达到正常水平（具体取决于您的配置）后，系统将应用线性或阶梯扩缩功能来自动缩减实例。

配置

自动扩缩器工具有不同的配置选项，可用于管理 Spanner 部署的扩缩。虽然 Cloud Run 函数和 GKE 参数类似，但它们的提供方式不同。如需详细了解如何配置自动扩缩器工具，请参阅配置 Cloud Run 函数部署和配置 GKE 部署。

高级配置

自动扩缩器工具具有高级配置选项，让您可以更精细地控制 Spanner 实例的管理时间和方式。以下各部分介绍了这些控制机制的选择。

自定义阈值

自动扩缩器工具使用针对以下负载指标建议的 Spanner 阈值确定要为实例增加或减少的节点数或处理单元数：

高优先级 CPU

CPU 24 小时滚动平均值

存储空间利用率

我们建议您使用针对 Spanner 指标创建提醒中所述的默认阈值。但是在某些情况下，您可能需要修改自动扩缩器工具使用的阈值。例如，您可以使用较低的阈值，让自动扩缩器工具的响应速度比较高的阈值还快。此修改有助于防止系统以更高的阈值触发提醒。

自定义指标

虽然自动扩缩器工具中的默认指标可以应对大多数性能和扩缩场景，但在某些情况下，您可能需要指定自己的指标，用于确定何时进行扩缩。在这些场景中，您可以使用 metrics 属性在配置中定义自定义指标。

边际

边际定义了阈值的上限和下限。只有在指标值大于上限或小于下限时，自动扩缩器工具才会触发自动扩缩事件。

此参数的目标是避免自动扩缩事件因阈值造成较小工作负载波动触发，从而减少自动扩缩器操作中的波动量。阈值和边际共同根据指标值您想要定义以下范围：

[threshold - margin, threshold + margin]

边际越小，范围越小，自动扩缩事件触发的可能性就越高。

指定指标的边际参数是可选的，并且默认为该参数前后的 5 个百分点。

数据拆分

Spanner 将称为“分块”的数据范围分配给节点或称为处理单元的节点细分。节点或处理单元独立管理和处理分配的分块中的数据。数据分块是基于多个因素创建的，包括数据量和访问模式。如需了解详情，请参阅 Spanner - 架构和数据模型。

注意：Spanner 每小时的费用为该小时内存在的节点或处理单元数量上限乘以每小时费率。因此，对于您预配的任何节点或处理单元，您都至少需要支付一小时的费用。我们不建议您针对一小时内缩容来优化您的自动扩缩器配置。如需了解详情，请参阅 Spanner 价格概览。

数据会整理成分块，Spanner 会自动管理分块。因此，当自动扩缩器工具添加或移除节点或处理单元时，它需要为 Spanner 后端留出足够的时间来重新分配和重新整理分块，因为在实例中添加或移除了新容量。

自动扩缩器工具对扩容和缩容事件使用冷却期来控制在实例中添加或移除节点或处理单元的速度。此方法会为实例留出重新整理计算节点或处理单元与数据分块之间的关系所需的时间。默认情况下，扩容和缩容冷却期设置为以下最小值：

扩容值：5 分钟

缩减值：30 分钟

如需详细了解扩缩建议和冷却期，请参阅扩缩 Spanner 实例。

价格

自动扩缩器工具在计算、内存和存储方面的资源消耗量很小。根据您自动扩缩器的配置，当自动扩缩器部署到 Cloud Run functions 时，其资源利用率通常在其依赖服务（Cloud Run functions、Cloud Scheduler、Pub/Sub 和 Firestore）的免费层级内。
注意：此分析不包括由自动扩缩器管理的 Spanner 实例产生的费用。这些费用仅包括自动扩缩器的组件。如需详细了解 Spanner 实例的价格，请参阅 Spanner 价格页面。

您可使用价格计算器根据您的预计使用情况来估算环境费用。

后续步骤

了解如何将自动扩缩器工具部署到 Cloud Run functions。

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
