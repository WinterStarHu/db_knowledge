# 架构概览  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/schema-and-data-model

架构概览  |  Spanner  |  Google Cloud Documentation

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

架构概览

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页介绍了 Spanner 架构要求、如何使用架构创建层次结构关系以及架构功能。它还引入了交错表，在查询父子关系中的表时，交错表可以提高查询性能。

架构是一个包含数据库对象（例如表、视图、索引和函数）的命名空间。您可以使用架构来整理对象、应用精细的访问权限，并避免命名冲突。您必须为 Spanner 中的每个数据库定义一个架构。

您还可以进一步对不同地理区域中数据库表内的行进行细分和存储。如需了解详情，请参阅地理位置分区概览。

强类型数据

Spanner 中的数据经过强类型化。数据类型包括标量和复杂类型，GoogleSQL 中的数据类型和 PostgreSQL 数据类型中对此进行了介绍。

选择主键

Spanner 数据库可以包含一个或多个表。表的结构为行和列。表架构将一个或多个表列定义为表的主键，用于唯一标识每行。主键始终会编入索引，以便快速查找行。如果您想要更新或删除表中的现有行，则该表必须具有主键。没有主键列的表只能有一行。只有 GoogleSQL 方言数据库可以包含没有主键的表。

通常，您的应用已经有一个本身就适合用作主键的字段。例如，对于 Customers 表，可能有一个应用提供的 CustomerId 充当主键。在其他情况下，您可能需要在插入行时生成主键。这通常是一个没有业务意义的唯一整数值（代理主键）。

无论哪种情况，都请务必小心谨慎，千万不要在选择主键时形成热点。例如，如果您插入一些记录，而这些记录将单调递增的整数用作键，那么您将始终在键空间末尾进插入记录。这种情况是不理想的，因为 Spanner 会按照键范围划分服务器之间的数据，这意味着，您的插入操作将集中于单个服务器，从而形成一个热点。可利用一些方法将负载分散到多个服务器上，从而避免热点：

对键进行哈希处理，并将其存储在一列中。使用哈希列（或同时使用哈希列和唯一键列）作为主键。

交换主键中列的顺序。

使用通用唯一标识符 (UUID)。建议使用版本 4 UUID，因为它使用高位随机值。请勿使用将时间戳存储在高位中的 UUID 算法（如版本 1 UUID）。

对顺序值进行位反转。

父子表关系

您可以通过两种方式在 Spanner 中定义父子关系：表交织和外键。

Spanner 的表交错是许多父子关系的理想选择。借助交错，Spanner 会在存储空间中将子行与父行物理地放置在一起。共存可以显著提高性能。例如，如果您有一个 Customers 表和一个 Invoices 表，并且您的应用经常为客户提取所有发票，那么您可以将 Invoices 定义为 Customers 的交错子表。这样做可声明两个独立的表之间的数据存储区域关系。您指示 Spanner 以物理方式将一个或多个 Invoices 行与一个 Customers 行存储在一起。与 INTERLEAVE IN PARENT 子句交错时，系统会强制执行此父子关系。INTERLEAVE IN 子表具有相同的物理行交错特性，但 Spanner 不会在父表和子表之间强制执行引用完整性。

您可以使用 DDL 将子表与父表相关联，该 DDL 会将子表声明为父表中的交错表，并将父表主键作为子表复合主键的第一部分。

如需详细了解交错，请参阅创建交错表。

外键是一种较通用的父子解决方案，并解决了其他用例。外键不限于主键列，而表可以具有多个外键关系，二者在某些关系中可以作为父键，而在其他关系中可以作为子键。但是，外键关系不隐含表在存储层中的共用位置关系。

Google 建议您选择将父子关系表示为交错表或外键，但不能同时表示为这两者。如需详细了解外键及其与交织表的比较，请参阅外键概览。

交错表中的主键

对于交错，每个表都必须具有主键。如果您将某个表声明为另一个表的交错子表，则该表必须具有复合主键，其中包含父主键的所有组成部分（按相同顺序），并且通常还包含一个或多个额外的子表列。

Spanner 会按主键值的排序顺序存储行，并在父行之间插入子行。如需查看交错行的图示，请参阅本页面后面部分的创建交错表。

总而言之，Spanner 能以物理方式将相关表的行存储在一起。架构示例展示了此物理布局的外观。

数据库分片

您可以定义最多七层的父子关系层次结构，这意味着您可以将七个独立表的行存储在一起。如果表中的数据量比较少，那么单个 Spanner 服务器或许可以处理您的数据库。然而，当相关表不断增长，开始达到单个服务器的资源限制时，会发生什么情况呢？Spanner 是一个分布式数据库，这意味着随着数据库不断增长，Spanner 会将数据划分为称作“分块”的区块。各个分片可以彼此独立移动并被分配给可能位于不同物理位置的多个服务器。分块包含一系列连续的行。这一范围的开始和结束键称为“分块边界”。Spanner 会根据大小和负载自动添加和移除分块边界，这样做会改变数据库中的分块数量。

基于负载进行分片

我们来看一个 Spanner 如何基于负载进行分块从而缓解读取热点的示例，假设您的数据库中有一个表，其中有 10 行的读取频率高于表中的所有其他行。Spanner 就可以在这 10 行中的每一行之间添加分块边界，以便每一行分别由不同的服务器处理，这样可避免这些行的所有读取操作消耗单台服务器的资源。

一般来说，如果您遵循架构设计最佳做法，则 Spanner 可以减少热点，使读取吞吐量应该每隔几分钟就改善性能，直到您耗尽实例中的资源或者运行时无法添加新分块边界（因为您有一个分块仅覆盖一行，没有交织子项）。

命名的架构

命名架构可帮助您将类似数据整理到一起。这有助于您在 Google Cloud 控制台中快速查找对象、应用权限并避免命名冲突。

与其他数据库对象一样，命名的架构使用 DDL 进行管理。

借助 Spanner 命名架构，您可以使用完全限定名称 (FQN) 查询数据。借助 FQN，您可以组合架构名称和对象名称来标识数据库对象。例如，您可以为仓库业务部门创建一个名为 warehouse 的架构。使用此架构的表可能包括：product、order 和 customer information。或者，您也可以为执行业务单位创建一个名为 fulfillment 的架构。此架构还可以包含名为 product、order 和 customer information 的表。在第一个示例中，FQN 为 warehouse.product；在第二个示例中，FQN 为 fulfillment.product。这样可以避免在多个对象共用同一名称的情况下造成混淆。

在 CREATE SCHEMA DDL 中，表对象会同时获得一个 FQN（例如 sales.customers）和一个简称（例如 sales）。

以下数据库对象支持命名的架构：

TABLE

CREATE

INTERLEAVE IN [PARENT]

FOREIGN KEY

SYNONYM

VIEW

INDEX

SEARCH INDEX

FOREIGN KEY

SEQUENCE

如需详细了解如何使用命名的架构，请参阅管理命名的架构。

将精细访问权限控制与命名的架构搭配使用

借助命名的架构，您可以授予对架构中每个对象的架构级访问权限。这适用于您授予访问权限时存在的架构对象。您必须授予对日后添加的对象的访问权限。

精细访问权限控制可限制对整个数据库对象组的访问，例如表、列和表中的行。

如需了解详情，请参阅授予对命名架构的精细访问权限控制权限。

架构示例

本部分中的架构示例展示了如何创建具有和不具有交错的父子表，并说明了相应的数据物理布局。

创建父表

假设您正在创建一个音乐应用，并且您需要一个表来存储歌手数据行：

请注意，该表包含一个主键列 SingerId，其显示在粗线的左侧，并且该表是由行和列构成的。

您可以使用以下 DDL 定义该表：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), );

PostgreSQL

CREATE TABLE singers ( singer_id   BIGINT PRIMARY KEY, first_name  VARCHAR(1024), last_name   VARCHAR(1024), singer_info BYTEA );

请注意有关示例架构的以下事项：

Singers 是位于数据库层次结构根目录层的表（因为它没有被定义为另一个表的交织子表）。

对于 GoogleSQL 方言数据库，主键列通常带有 NOT NULL 注解（但是，如果希望在键列中允许 NULL 值，则可以忽略此注解；如需了解详情，请参阅键列）。

未包含在主键中的列称为非键列，它们可以具有可选的 NOT NULL 注释。

必须为GoogleSQL中使用 STRING 或 BYTES 类型的列定义一个长度，该长度表示可以在该字段中存储的最多 Unicode 字符数。对于 PostgreSQL varchar 和 character varying 类型，长度规范是可选的。如需了解详情，请参阅 GoogleSQL 方言数据库的标量数据类型和 PostgreSQL 方言数据库的 PostgreSQL 数据类型。

Singers 表中行的物理布局是什么样的？ 下图显示了 Singers 表的行，它们是按主键（“Singers(1)”，然后是“Singers(2)”，其中圆括号中的数字是主键值）进行存储的。

上图说明了 Singers(3) 和 Singers(4) 键控的行之间有一个示例分块边界，系统会将生成的分块中的数据分配给不同服务器进行处理。随着此表不断增长，Singers 数据的行可能存储在不同位置。

创建父表和子表

假设您现在想要将每个歌手的专辑相关的一些基本数据添加到音乐应用中。

请注意，Albums 的主键由两列组成：SingerId 和 AlbumId，它们将每个专辑与其歌手相关联。以下示例架构在数据库层次结构的根目录层定义 Albums 和 Singers 表，这使它们成为同级表。

-- Schema hierarchy:
-- + Singers (sibling table of Albums) -- + Albums (sibling table of Singers)

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), );

CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId);

PostgreSQL

CREATE TABLE singers ( singer_id   BIGINT PRIMARY KEY, first_name  VARCHAR(1024), last_name   VARCHAR(1024), singer_info BYTEA );

CREATE TABLE albums ( singer_id     BIGINT, album_id      BIGINT, album_title   VARCHAR, PRIMARY KEY (singer_id, album_id) );

Singers 和 Albums 的行物理布局如下图所示，首先，Albums 表的行按相应的连续主键进行存储，随后，Singers 表的行按相应的连续主键进行存储：

请注意，在该架构中，Spanner 假定 Singers 和 Albums 表之间没有数据存储区域关系，因为这两个表都是顶级表。随着数据库不断增长，Spanner 可以在任何行之间添加分块边界。这意味着，Albums 表行的分块结束位置可能不同于 Singers 表行，并且两个分块可以彼此独立移动。

根据您的应用的具体需求，可以让 Albums 数据位于不同于 Singers 数据的分片上。不过，由于需要协调不同资源之间的读取和更新，这可能会导致性能下降。如果您的应用经常需要检索有关特定歌手的所有专辑的信息，则应将 Albums 创建为 Singers 的交错子表，这样做可沿着主键维度协同定位两个表中的行。下面的示例更详细地对此进行了介绍。

创建交错表

交错表是指您声明为另一个表的交错子表的表，目的是让子表的行与关联的父行实际存储在一起。如前所述，父表主键必须是子表复合主键的第一部分。

将表交错后，它就永久生效了。您无法撤消交错操作。您需要重新创建表，并将数据迁移到该表。

在设计音乐应用时，假设您意识到应用在访问 Singers 行时需要频繁访问 Albums 表中的行。例如，当您访问行 Singers(1) 时，还需要访问行 Albums(1, 1) 和 Albums(1, 2)。在这种情况下，Singers 和 Albums 需要具有强大的数据存储区域关系。您可以通过将 Albums 创建为 Singers 的交错子表，来声明此数据存储区域关系。

-- Schema hierarchy:
-- + Singers --   + Albums (interleaved table, child table of Singers)

以下架构中的粗体行演示了如何将 Albums 创建为 Singers 的交错表。

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), );

CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

PostgreSQL

CREATE TABLE singers ( singer_id   BIGINT PRIMARY KEY, first_name  VARCHAR(1024), last_name   VARCHAR(1024), singer_info BYTEA );

CREATE TABLE albums ( singer_id     BIGINT, album_id      BIGINT, album_title   VARCHAR, PRIMARY KEY (singer_id, album_id) ) INTERLEAVE IN PARENT singers ON DELETE CASCADE;

有关此架构的注意事项：

SingerId 是子表 Albums 主键的前一部分，也是其父表 Singers 的主键。

ON DELETE CASCADE 注解表示，当父表中的行被删除时，其子行也会自动被删除。如果子表没有此注解，或注解为 ON DELETE NO ACTION，则您必须先删除子行，然后才能删除父行。

交错行首先按父表的行进行排序，然后按共享父表主键的子表的连续行进行排序。例如，依次按“Singers(1)”、“Albums(1, 1)”和“Albums(1, 2)”排序。

如果对此数据库进行拆分，只要 Singers 行及其所有 Albums 行的大小保持在分块大小限制以下，并且在这些 Albums 行中没有热点，则每个歌手与其专辑数据的数据存储区域关系都将保留下来。

在插入子行之前，父行必须已经存在。 父行可以已经存在于数据库中，也可以在将子行插入到同一事务中之前插入。

假设您想将 Projects 及其 Resources 建模为交错表。某些场景可以从 INTERLEAVE IN 中受益，即不需要 Projects 行存在，其下实体即可存在（例如，项目已被删除，但其资源需要先清理后再删除）。

GoogleSQL

CREATE TABLE Projects ( ProjectId   INT64 NOT NULL, ProjectName STRING(1024), ) PRIMARY KEY (ProjectId);

CREATE TABLE Resources ( ProjectId    INT64 NOT NULL, ResourceId   INT64 NOT NULL, ResourceName STRING(1024), ) PRIMARY KEY (ProjectId, ResourceId), INTERLEAVE IN Projects;

PostgreSQL

CREATE TABLE Projects ( ProjectId   BIGINT PRIMARY KEY, ProjectName VARCHAR(1024), );

CREATE TABLE Resources ( ProjectId    BIGINT, ResourceId   BIGINT, ResourceName VARCHAR(1024), PRIMARY KEY (ProjectId, ResourceId) ) INTERLEAVE IN Projects;

请注意，在此示例中，我们使用的是 INTERLEAVE IN Projects 子句，而不是 INTERLEAVE IN PARENT Projects。这表示我们不会强制执行项目与资源之间的父级/子级关系。

在此示例中，即使 Projects(1) 行不存在，Resources(1, 10) 和 Resources(1, 20) 行也可以存在于数据库中。即使 Resources(1, 10) 和 Resources(1, 20) 仍存在，Projects(1) 也可以删除，并且删除不会影响这些 Resources 行。

创建交错表的层次结构

Singers 和 Albums 之间的父子关系可以扩展到更多的后代表。例如，您可以创建一个名为 Songs 的交错表作为 Albums 的子表，用于存储每个专辑的曲目清单：

Songs 必须具有一个主键，并且该主键必须包含层次结构中更高级别表的所有主键（即 SingerId 和 AlbumId）。

-- Schema hierarchy:
-- + Singers --   + Albums (interleaved table, child table of Singers) --     + Songs (interleaved table, child table of Albums)

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), );

CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

CREATE TABLE Songs ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, TrackId      INT64 NOT NULL, SongName     STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId, TrackId), INTERLEAVE IN PARENT Albums ON DELETE CASCADE;

PostgreSQL

CREATE TABLE singers ( singer_id   BIGINT PRIMARY KEY, first_name  VARCHAR(1024), last_name   VARCHAR(1024), singer_info BYTEA );

CREATE TABLE albums ( singer_id     BIGINT, album_id      BIGINT, album_title   VARCHAR, PRIMARY KEY (singer_id, album_id) ) INTERLEAVE IN PARENT singers ON DELETE CASCADE;

CREATE TABLE songs ( singer_id     BIGINT, album_id      BIGINT, track_id      BIGINT, song_name     VARCHAR, PRIMARY KEY (singer_id, album_id, track_id) ) INTERLEAVE IN PARENT albums ON DELETE CASCADE;

下图显示了交织行的物理视图。

在此示例中，随着歌手数量增长，Spanner 会增加歌手之间的分块边界，以保留歌手与其专辑和歌曲数据之间的数据存储区域。但是，如果歌手行及其子行的大小超过分块大小限制，或在子行中检测到热点，Spanner 会尝试添加分块边界以隔离该热点行及其下的所有子行。

总之，父表及其所有子表和后代表形成架构中的表层次结构。尽管层次结构中的每个表在逻辑上是独立的，但是通过物理方式交织排列表可以提高性能，这种方式可有效地预联接表，既让您能够访问相关行，又可最大限度地减少存储空间访问次数。

与交错表联接

如果可能，请通过主键联接交错表中的数据。因为每个交织行通常与其父行存储在同一分块中，所以 Spanner 可以在本地通过主键执行联接，最大限度地减少存储空间访问和网络流量。在以下示例中，Singers 和 Albums 通过主键 SingerId 进行联接。

GoogleSQL

SELECT s.FirstName, a.AlbumTitle FROM Singers AS s JOIN Albums AS a ON s.SingerId = a.SingerId;

PostgreSQL

SELECT s.first_name, a.album_title FROM singers AS s JOIN albums AS a ON s.singer_id = a.singer_id;

位置组

注意：此功能适用于 Spanner 企业版和企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

Spanner 使用存储位置群组来保留跨表列的数据存储位置关系。如果您未为表明确创建任何存储位置群组，Spanner 会将所有列归入 default 存储位置群组，并将所有表的数据存储在 SSD 存储空间中。您可以使用存储位置群组执行以下操作：

使用分层存储。分层存储是一种全托管式存储功能，可让您选择是将数据存储在固态硬盘 (SSD) 还是普通硬盘 (HDD) 上。默认情况下，如果不使用分层存储，Spanner 会将所有数据存储在 SSD 存储空间中。

使用列分组功能将指定的列与其他列分开存储。由于指定列的数据是单独存储的，因此从这些列读取数据的速度比将所有数据组合在一起时更快。如需使用列分组，您需要创建一个存储位置群组，而无需指定任何分层存储选项。Spanner 使用存储位置群组来单独存储指定的列。如果指定了存储分层政策，则列会从表或默认存储区域群组继承存储分层政策。然后，使用 CREATE TABLE DDL 语句为指定的列设置存储位置群组，或使用 ALTER TABLE DDL 语句更改表列所使用的存储位置群组。DDL 语句决定了存储在存储位置群组中的列。最后，您可以更高效地读取这些列中的数据。

键列

本部分包含一些关于关键列的说明。

更改表键

表的键不可更改；您无法在现有表中添加键列，也不能从现有表中移除键列。

将 NULL 存储在主键中

在 GoogleSQL 中，如果您希望将 NULL 存储在主键列中，请在架构中省略该列的 NOT NULL 子句。（PostgreSQL 方言数据库不支持主键列中的 NULL 值。）

以下示例在主键列 SingerId 中省略了 NOT NULL 子句。请注意，由于 SingerId 是主键，因此该列中只能有一行存储 NULL。

CREATE TABLE Singers ( SingerId   INT64 PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), );

主键列可为 null 的属性必须在父表和子表声明之间匹配。在此示例中，不允许使用列 Albums.SingerId 的 NOT NULL，因为 Singers.SingerId 会忽略该列。

CREATE TABLE Singers ( SingerId   INT64 PRIMARY KEY, FirstName  STRING(1024), LastName   STRING(1024), );

CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

不允许的类型

以下列的类型不能为 ARRAY：

表的键列。

索引的键列。

针对多租户进行设计

如果您存储的数据属于不同客户，那么您可能需要实现多租户解决方案。例如，某个音乐服务可能想要分开存储每个唱片公司的内容。

经典多租户架构

设计多租户架构的经典方法是为每个客户创建一个单独的数据库。在此示例中，每个数据库都有自己的 Singers 表：

数据库 1：Ackworth Records

SingerId FirstName LastName

1MarcRichards

2CatalinaSmith

数据库 2：Cama Records

SingerId FirstName LastName

1AliceTrentor

2GabrielWright

数据库 3：Eagan Records

SingerId FirstName LastName

1BenjaminMartinez

2HannahHarris

由架构管理的多租户

在 Spanner 中设计多租户的另一种方法是，将所有客户都放在单个数据库中的单个表中，并为每个客户使用不同的主键值。例如，您可以在表中添加一个 CustomerId 键列。如果您将 CustomerId 作为第一个键列，那么每位客户的数据都能具有良好的存储区域。然后，Spanner 可以有效地使用数据库分块，以根据数据大小和负载模式最大限度地提高性能。在以下示例中，所有客户都位于一个 Singers 表中：

Spanner 多租户数据库

CustomerId SingerId FirstName LastName

11MarcRichards

12CatalinaSmith

21AliceTrentor

22GabrielWright

31BenjaminMartinez

32HannahHarris

如果每个租户必须拥有单独的数据库，请注意以下限制：

每个实例的数据库数量以及每个数据库的表和索引数量都有相应限制。取决于客户的具体数量，可能无法安排单独的数据库或表。

添加新表和非交织索引可能需要很长时间。
如果您的架构设计依赖于添加新表和索引，那么您可能无法获得所需的性能。

如果想要创建单独的数据库，那么当您将表分布到不同数据库时，您成功的几率更大，因为采用这种方式，每个数据库每周的架构更改量较少。

如果要为您的应用的每位客户创建单独的表和索引，请不要将所有表和索引放在同一个数据库中。相反，请将它们拆分到多个数据库中，以减轻创建大量索引带来的性能问题。

如需详细了解针对多租户的其他数据管理模式和应用设计，请参阅在 Spanner 中实现多租户

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-03-04。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-03-04。"],[],[]]

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
