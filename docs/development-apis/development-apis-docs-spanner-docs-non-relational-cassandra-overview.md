# Cassandra 接口  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/non-relational/cassandra-overview

Cassandra 接口  |  Spanner  |  Google Cloud Documentation

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

Cassandra 接口

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面比较了 Apache Cassandra 和 Spanner 架构，并有助于您了解 Spanner Cassandra 接口的功能和限制。本文档假定您熟悉 Cassandra，并希望在将 Spanner 用作数据库的时迁移现有应用或设计新应用。

Cassandra 和 Spanner 都是为需要高可伸缩性和低延迟的应用而构建的大规模分布式数据库。虽然这两种数据库都可以支持要求苛刻的 NoSQL 工作负载，但 Spanner 为数据建模、查询和事务操作提供了高级功能。如需详细了解 Spanner 如何满足 NoSQL 数据库条件，请参阅 适用于非关系型工作负载的 Spanner。

核心概念

本部分比较了 Cassandra 和 Spanner 的关键概念。

术语

Cassandra Spanner

集群

实例

Cassandra 集群相当于 Spanner 实例 - 一组服务器和存储资源。由于 Spanner 是一项托管式服务，因此您无需配置底层硬件或软件。您只需指定要为实例预留的节点数量，或使用自动扩缩来自动扩缩实例。实例就像是数据库的容器。您还可以在实例级别选择数据复制拓扑（单区域、双区域或多区域）。

键空间

数据库

Cassandra 键空间相当于 Spanner 数据库，后者是一系列表和其他架构元素（例如索引和角色）。与键空间不同，您无需配置复制位置。
Spanner 会自动将您的数据复制到实例中指定的区域。

表格

表

在 Cassandra 和 Spanner 中，表都是由表架构中指定的主键标识的行集合。

分区

分块

Cassandra 和 Spanner 都通过对数据进行分片来实现扩容。
在 Cassandra 中，每个分片称为分区；而在 Spanner 中，每个分片称为分块。Cassandra 使用哈希分区，这意味着系统会根据主键的哈希值，将每行独立分配给一个存储节点。Spanner 是范围分片的，这意味着在主键空间中相邻的行在存储空间中也是相邻的（分块边界除外）。
Spanner 会根据负载和存储空间进行拆分和合并，这对应用来说是透明的。关键含义在于，与 Cassandra 不同，在 Spanner 中，对主键前缀进行范围扫描是一种高效操作。

Row

行

在 Cassandra 和 Spanner 中，行都是由主键唯一标识的列集合。与 Cassandra 一样，Spanner 也支持复合主键。与 Cassandra 不同，Spanner 不区分分区键和聚簇列，因为数据是按范围分片的。您可以将 Spanner 视为仅具有聚簇列，并在后台管理分区。

列

列

在 Cassandra 和 Spanner 中，列都是一组具有相同类型的数据值。表中的每一行都有一个值。如需详细了解如何将 Cassandra 列类型与 Spanner 进行比较，请参阅数据类型。

架构

Cassandra 集群由一组服务器和与这些服务器同位于一个位置的存储空间组成。哈希函数会将来自分区键空间的行映射到虚拟节点 (vnode)。然后，系统会为每个服务器随机分配一组虚拟节点来处理一部分集群键空间。vNode 的存储空间会本地附加到服务节点。客户端驱动程序直接连接到服务节点，并处理负载均衡和查询路由。

Spanner 实例由复制拓扑结构中的一些服务器组成。Spanner 会根据 CPU 和磁盘用量，动态地将每个表分割成行范围。系统会将分片分配给计算节点以提供服务。数据实际存储在 Google 的分布式文件系统 Colossus 上，与计算节点分开存储。客户端驱动程序连接到 Spanner 的前端服务器，这些服务器会执行请求路由和负载均衡。如需了解详情，请参阅 Spanner 读取和写入生命周期白皮书。

从总体上看，这两种架构都会随着资源添加到底层集群而进行扩缩。借助 Spanner 的计算和存储分离功能，计算节点之间的负载可以更快地重新平衡，以应对工作负载变化。与 Cassandra 不同，分片移动不会涉及数据移动，因为数据会保留在 Colossus 上。此外，对于希望按分区键对数据进行排序的应用，Spanner 的基于范围的分区可能更自然。基于范围的分区的另一面是，如果未考虑其他架构设计，写入键空间一端（例如，按当前时间戳键入的表）的工作负载可能会出现热点。如需详细了解如何克服热点问题，请参阅架构设计最佳实践。

一致性

在 Cassandra 中，您必须为每项操作指定一致性级别。如果您使用仲裁一致性级别，大多数副本节点必须响应协调器节点，才能将操作视为成功。如果您使用一致性级别 1，Cassandra 需要单个副本节点响应，才能将操作视为成功。

Spanner 提供强一致性。Spanner API 不会向客户端公开副本。Spanner 客户端与 Spanner 交互时，就像它是一个单机数据库一样。在 Spanner 向用户报告写入成功之前，写入操作始终会写入大多数副本。任何后续读取都会反映新写入的数据。应用可以选择在过去某个时间点读取数据库的快照，这可能会比强读取带来更好的性能。如需详细了解 Spanner 的一致性属性，请参阅事务概览。

Spanner 旨在支持大规模应用所需的一致性和可用性。Spanner 可大规模提供强一致性和高性能。对于需要此功能的用例，Spanner 支持快照（过时）读取，以降低新鲜度要求。

Cassandra 接口

借助 Cassandra 接口，您可以使用熟悉的 Cassandra 工具和语法来利用 Spanner 的全全托管式、可扩缩且高度可用的基础设施。本页面有助于您了解 Cassandra 接口的功能和限制。

Cassandra 接口的优势

可移植性：Cassandra 接口可使用与 Cassandra 兼容的架构、查询和客户端来访问广泛的 Spanner 功能。这简化了将基于 Spanner 构建的应用迁移到其他 Cassandra 环境的过程，反之亦然。这种可移植性可提供部署灵活性，并支持灾难恢复场景，例如紧急退出。

熟悉性：如果您已经在使用 Cassandra，那么可以使用许多相同的 CQL 语句和类型快速开始使用 Spanner。

不妥协地使用 Spanner：由于 Cassandra 接口是基于 Spanner 现有基础构建的，因此它可以提供 Spanner 现有的所有可用性、一致性和性价比优势，而无需在 GoogleSQL 生态系统的补充功能中妥协任何可用功能。

CQL 兼容性

支持 CQL 方言：Spanner 提供了一部分 CQL 方言，包括数据查询语言 (DQL)、数据操纵语言 (DML)、轻量级事务 (LWT)、聚合函数和日期时间函数。

支持的 Cassandra 功能：Cassandra 接口支持 Cassandra 的许多最常用功能。这包括架构和类型系统的核心部分、许多常见查询形状、各种函数和运算符，以及 Cassandra 系统目录的关键方面。应用可以通过 Spanner 实现的 Cassandra 传输协议连接来使用多个 Cassandra 客户端或驱动程序。

客户端和传输协议支持：Spanner 使用 Cassandra 适配器（与您的应用一起运行的轻量级客户端）支持 Cassandra 传输协议 v4 的核心查询功能。这样，许多 Cassandra 客户端就可以与 Spanner Cassandra 接口数据库一起使用，同时利用 Spanner 的全球端点和连接管理以及 IAM 身份验证。

支持的 Cassandra 数据类型

下表列出了支持的 Cassandra 数据类型，并将每种数据类型映射到等效的 Spanner GoogleSQL 数据类型。

支持的 Cassandra 数据类型 Spanner GoogleSQL 数据类型

数值类型 tinyint（8 位有符号整数） INT64（64 位有符号整数） Spanner 支持单个 64 位宽数据类型，用于有符号整数。

smallint（16 位有符号整数）

int（32 位有符号整数）

bigint（64 位有符号整数）

float（32 位 IEEE-754 浮点） FLOAT32（32 位 IEEE-754 浮点）

double（64 位 IEEE-754 浮点） FLOAT64（64 位 IEEE-754 浮点）

decimal 对于精度固定的小数，请使用 NUMERIC 数据类型（精度 38 标度 9）。

varint（可变精度整数）

字符串类型 text STRING(MAX)

text 和 varchar 都会存储和验证 UTF-8 字符串。在 Spanner 中，STRING 列需要指定其最大长度。这不会影响存储空间；此操作仅用于验证目的。

varchar

ascii STRING(MAX)

uuid STRING(MAX)

timeuuid STRING(MAX)

inet STRING(MAX)

blob BYTES(MAX)

如需存储二进制数据，请使用 BYTES 数据类型。

日期和时间类型 date DATE

time INT64

Spanner 不支持专用时间数据类型。使用 INT64 存储纳秒级时长。

timestamp TIMESTAMP

duration STRING(MAX)

Spanner 不支持存储时长类型。使用 STRING 存储时长。

容器类型 set ARRAY

Spanner 不支持专用的 set 数据类型。使用 ARRAY 列表示 set。

list ARRAY

使用 ARRAY 存储类型化的对象列表。

map JSON

Spanner 不支持专用映射类型。使用 JSON 列表示映射。

其他类型 boolean BOOL

counter INT64

数据类型注解

借助 cassandra_type 列选项，您可以定义 Cassandra 和 Spanner 数据类型之间的映射。如果您在 Spanner 中创建了一个表，并打算使用与 Cassandra 兼容的查询与该表进行交互，则可以使用 cassandra_type 选项为每个列指定相应的 Cassandra 数据类型。然后，Spanner 会使用此映射在两个数据库系统之间传输数据时正确解释和转换数据。

例如，如果 Cassandra 中有一个架构如下的表：

CREATE TABLE Albums ( albumId uuid,
  title varchar,
artists set, tags  map, numberOfSongs tinyint, releaseDate date, copiesSold bigint, score frozen> ....
PRIMARY KEY(albumId) )

在 Spanner 中，您可以使用类型注解映射到 Cassandra 数据类型，如下所示：

CREATE TABLE Albums ( albumId       STRING(MAX) OPTIONS (cassandra_type = 'uuid'),
  title         STRING(MAX) OPTIONS (cassandra_type = 'varchar'),
artists       ARRAY OPTIONS (cassandra_type = 'set'), tags          JSON OPTIONS (cassandra_type = 'map'), numberOfSongs INT64 OPTIONS (cassandra_type = 'tinyint'), releaseDate   DATE OPTIONS (cassandra_type = 'date'), copiesSold    INT64 OPTIONS (cassandra_type = 'bigint'), score         ARRAY OPTIONS (cassandra_type = 'frozen>') ...
) PRIMARY KEY (albumId);

在上一个示例中，OPTIONS 子句会将列的 Spanner 数据类型映射到其对应的 Cassandra 数据类型。

albumId (Spanner STRING(MAX)) 映射到 Cassandra 中的 uuid。

title (Spanner STRING(MAX)) 映射到 Cassandra 中的 varchar。

artists (Spanner ARRAY) 映射到 Cassandra 中的 set。

tags (Spanner JSON) 映射到 Cassandra 中的 map。

numberOfSongs (Spanner INT64) 映射到 Cassandra 中的 tinyint。

releaseDate (Spanner DATE) 映射到 Cassandra 中的 date。

copiesSold (Spanner INT64) 映射到 Cassandra 中的 bigint。

score (Spanner ARRAY) 在 Cassandra 中映射到 frozen>。

修改 cassandra_type 选项

您可以使用 ALTER TABLE 语句对现有列添加或修改 cassandra_type 选项。

如需向尚无 cassandra_type 选项的列添加该选项，请使用以下语句：

ALTER TABLE Albums ALTER COLUMN uuid SET OPTIONS (cassandra_type='uuid');

在此示例中，Albums 表中的 uuid 列使用设置为 uuid 的 cassandra_type 选项进行了更新。

如需修改现有的 cassandra_type 选项，请将 ALTER TABLE 语句与新 cassandra_type 值结合使用。例如，如需将 Albums 表中 numberOfSongs 列的 cassandra_type 从 tinyint 更改为 bigint，请使用以下语句：

ALTER TABLE Albums ALTER COLUMN numberOfSongs SET OPTIONS (cassandra_type='bigint');

您只能修改以下类型：

来源 目标

tinyint smallint、int、bigint

smallint int、bigint

int bigint

float double

text varchar

ascii varchar、text

直接和精细映射

在许多情况下，Spanner 和 Cassandra 数据类型之间的映射非常简单。例如，Spanner STRING(MAX) 映射到 Cassandra varchar，Spanner INT64 映射到 Cassandra bigint。

不过，在某些情况下，映射需要更多考虑和调整。例如，您可能需要将 Cassandra smallint 映射到 Spanner INT64。

支持的 Cassandra 函数

本部分列出了 Spanner 中支持的 Cassandra 函数。

下面列出了 Spanner 对 Cassandra 函数的支持。

所有聚合函数

所有日期时间函数（currentTimeUUID 除外）

所有转换函数（blob 转换函数除外）

所有轻量级事务函数（BATCH 条件除外）

存留时间 (TTL)

从 Cassandra 迁移时，请向 Spanner 表中添加行删除政策，以便在 INSERT 或 UPDATE 语句中使用 USING TTL 选项，或者使用 Spanner TTL。

Spanner TTL 逻辑在行级层运行，而 Cassandra 的 TTL 逻辑可在单元级层应用。如需使用 Spanner TTL，您必须在行删除政策中包含时间戳列和时间间隔。在相应行相对于时间戳超过指定时长后，Spanner 会删除该行。

Spanner TTL 删除操作不是即时完成的。异步后台过程会删除过期的行，删除操作最多可能需要 72 小时。

如需了解详情，请参阅为 Cassandra 数据启用 TTL。

Spanner 中不支持的 Cassandra 功能

请务必了解，Cassandra 接口通过与 Cassandra 兼容的架构、类型、查询和客户端提供 Spanner 的功能。它不支持 Cassandra 的所有功能。将现有 Cassandra 应用迁移到 Spanner 可能需要进行一些重做，以适应不受支持的 Cassandra 功能或行为差异，例如查询优化或主键设计。不过，迁移后，您的工作负载可以利用 Spanner 的可靠性和独特的多模型功能。

下面列出了有关不支持的 Cassandra 功能的详细信息：

不支持的某些 CQL 语言功能：用户定义的类型和函数、token 函数。

Spanner 和 Google Cloud 控制平面：具有 Cassandra 接口的数据库使用 Spanner 和 Google Cloud工具来预配、保护、监控和优化实例。Spanner 不支持 nodetool 等工具来执行管理活动。

DDL 支持

使用 Cassandra 接口不直接支持 CQL DDL 语句。对于 DDL 更改，您必须使用 Spanner Google Cloud 控制台、gcloud 命令或客户端库。

连接

Cassandra 客户端支持

借助 Spanner，您可以通过各种客户端连接到数据库：

Cassandra 适配器可用作进程内帮助程序或边车代理，用于将 Cassandra 应用连接到 Cassandra 接口。如需了解详情，请参阅使用 Cassandra 适配器连接到 Spanner。

Cassandra 适配器可以作为独立进程本地启动，并使用 CQLSH 进行连接。如需了解详情，请参阅将 Cassandra 接口连接到您的应用。

使用 Identity and Access Management 控制访问权限

您需要拥有 spanner.databases.adapt、spanner.databases.select 和 spanner.databases.write 权限才能对 Cassandra 端点执行读写操作。如需了解详情，请参阅 IAM 概览。

如需详细了解如何授予 Spanner IAM 权限，请参阅应用 IAM 角色。

监控

Spanner 提供以下指标，以帮助您监控 Cassandra 适配器：

spanner.googleapis.com/api/adapter_request_count：捕获并公开 Spanner 每秒执行的适配器请求数，或每秒在 Spanner 服务器上发生的错误数。

spanner.googleapis.com/api/adapter_request_latencies：捕获并公开 Spanner 处理适配器请求所用的时间。

您可以创建自定义 Cloud Monitoring 信息中心，以显示和监控 Cassandra 适配器的指标。自定义信息中心包含以下图表：

P99 请求延迟时间：数据库的每 message_type 服务器请求延迟时间的第 99 百分位分布情况。

P50 请求延迟时间：数据库的每 message_type 服务器请求延迟时间的第 50 百分位分布情况。

API 请求数（按消息类型）：数据库的每 message_type 的 API 请求数。

API 请求数（按操作类型）：您的数据库的每 op_type 的 API 请求数。

错误率：数据库的 API 错误率。

Google Cloud 控制台

下载 cassandra-adapter-dashboard.json 文件。 此文件包含在 Monitoring 中填充自定义信息中心所需的信息。

在 Google Cloud 控制台中，前往  信息中心页面： 前往信息中心

如果您使用搜索栏查找此页面，请选择子标题为监控的结果。

在信息中心概览页面中，点击创建自定义信息中心。

在信息中心工具栏中，点击信息中心设置图标。然后依次选择 JSON 和 JSON 编辑器。

在 JSON 编辑器窗格中，复制您下载的 cassandra-adapter-dashboard.json 文件的内容，并将其粘贴到编辑器中。

如需将更改应用于信息中心，请点击应用更改。如果您不想使用此信息中心，请返回到“信息中心概览”页面。

创建信息中心后，点击添加过滤条件。然后选择 project_id 或 instance_id 以监控 Cassandra 适配器。

gcloud CLI

下载 cassandra-adapter-dashboard.json 文件。 此文件包含在 Monitoring 中填充自定义信息中心所需的信息。

如需在项目中创建信息中心，请使用 gcloud monitoring dashboards create 命令：

gcloud monitoring dashboards create --config-from-file=cassandra-adapter-dashboard.json

如需了解详情，请参阅 gcloud monitoring dashboards create 参考文档。

此外，以下 Spanner 指标有助于监控 Cassandra 适配器：

CPU 利用率指标提供有关用户和系统任务的 CPU 使用率的信息，并按优先级和操作类型细分。

存储空间利用率指标提供有关数据库和备份存储空间的信息。

Spanner 的内置统计信息表提供有关查询、事务和读取的数据分析，帮助您发现数据库中的问题。

如需查看系统分析洞见的完整列表，请参阅使用系统分析洞见监控实例。如需详细了解如何监控 Spanner 资源，请参阅使用 Cloud Monitoring 监控实例。

价格

使用 Cassandra 端点无需额外付费。您需要根据实例使用的计算容量和数据库使用的存储空间支付标准 Spanner 价格。

如需了解详情，请参阅 Spanner 价格。

后续步骤

了解如何从 Cassandra 迁移到 Spanner。

了解如何使用 Cassandra 适配器连接到 Spanner。

试用面向 Cassandra 用户的 Spanner Codelab。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-02-05。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-02-05。"],[],[]]

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
