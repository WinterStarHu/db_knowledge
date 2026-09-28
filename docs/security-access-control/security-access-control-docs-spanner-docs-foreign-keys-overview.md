# 外键  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/foreign-keys/overview

外键  |  Spanner  |  Google Cloud Documentation

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

外键

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本文档介绍了 Spanner 中的外键，以及如何使用这些键在数据库中实施参照完整性。以下主题可帮助您了解外键及其使用方式：

Spanner 中的外键概览

外键的类型

外键类型比较

选择要使用的外键类型

使用强制执行的外键

使用信息性外键

支持性索引

长时间运行架构更改

Spanner 中的外键概览

外键用于定义表之间的关系。您可以使用外键来确保 Spanner 中这些关系的数据完整性。

假设您是电子商务企业的首席开发者。您正在设计一个数据库来处理客户订单。数据库必须存储每个订单、客户和产品的相关信息。图 1 展示了应用的基本数据库结构。

图 1：订单处理数据库示意图

您可以定义一个存储客户信息的 Customers 表、一个跟踪所有订单的 Orders 表以及一个存储每件商品的相关信息的 Products 表。

图 1 还展示了映射到以下现实世界关系的表之间的关联：

客户下单。

下了某商品的订单。

您决定数据库应实施以下规则，以确保系统中的订单有效。

您无法为不存在的客户创建订单。

客户无法对您没有的商品下订单。

实施这些规则（即“限制条件”），即表示您正在维护数据的参照完整性。当数据库保持参照完整性时，所有尝试添加无效数据的操作都将失败，这将导致数据之间出现无效链接或引用。参照完整性可防止用户出错。 默认情况下，Spanner 使用外键来强制执行参照完整性。

使用外键定义参照完整性

下面我们再次看一下订单处理示例，如图 2 所示，在设计中添加了更多细节。

图 2. 采用外键的数据库架构示意图

现在设计为每个表中都显示了列名称和类型。Orders 表还定义了两个外键关系。FK_CustomerOrder 预期 Orders 中所有行都具有有效的 CustomerId。FK_ProductOrder 外键要求 Orders 表中的所有 ProductId 值都有效。下表将这些限制条件与您希望强制执行的实际规则一一对应。

外键名称 限制 实际说明

FK_CustomerOrder

要求 Orders 中所有行都具有有效 CustomerId 有效客户下单

FK_ProductOrder

要求 Orders 中所有行都具有有效 ProductId 对有效商品下了订单

Spanner 会强制执行使用强制执行外键指定的限制。这意味着，Spanner 无法执行在 Orders 表中尝试插入或更新行的任何事务，该表具有的 CustomerId 或 ProductId 在 Customers 和 Products 表中找不到。此外，它也无法执行在 Customers 和 Products 表中尝试更新或删除行的事务，从而导致 Orders 表中的 ID 失效。如需详细了解 Spanner 如何验证限制条件，请参阅事务限制条件验证部分。

与强制执行的外键不同，Spanner 不会验证信息性外键的限制条件。这意味着，如果您在此场景中使用信息性外键，则尝试在 Orders 表中插入或更新行的事务（该行具有在 Customers 和 Products 表中找不到的 CustomerId 或 ProductId）不会经过验证，并且该事务不会失败。此外，与强制执行的外键不同，信息性外键仅受 GoogleSQL 支持，不受 PostgreSQL 支持。

外键特征

下面列出了 Spanner 中的外键特性。

定义外键的表是引用表，而外键列是引用列。

外键引用“被引用”表的“被引用”列。

在示例中，您可以为每个外键限制条件指定名称。如果您未指定名称，Spanner 会为您生成一个名称。您可以从 Spanner 的 INFORMATION_SCHEMA 中查询生成的名称。限制条件名称的范围限定为架构以及表和索引的名称，并且在架构内必须具有唯一性。

引用列数和被引用列数必须相同。顺序很重要。例如，第一个引用列引用第一个被引用列，第二个引用列引用第二个被引用列。

引用列及其被引用的对应项目的类型必须相同。
您必须能够为列编制索引。

您无法使用 allow_commit_timestamp=true 选项在列上创建外键。

数组列不受支持。

不支持 JSON 列。

外键可以引用同一表的列（“自引用”外键）。例如，一个 Employee 表具有一个引用该表的 EmployeeId 列的 ManagerId 列。

外键还可以在表之间形成循环关系，其中两个表直接或间接地相互引用。必须先有被引用表，然后才能创建外键。这意味着，必须使用 ALTER TABLE 语句添加至少其中一个外键。

被引用键必须是唯一的。如果外键的被引用列与被引用表的主键列匹配，则 Spanner 使用被引用表的 PRIMARY KEY。如果 Spanner 无法使用被引用表的主键，则会在被引用列上创建 UNIQUE NULL_FILTERED INDEX。

外键不使用您创建的二级索引。它们会创建自己的支持性索引。支持性索引可用于查询评估，包括明确的 force_index 指令。您可以通过 Spanner 的 INFORMATION_SCHEMA 查询支持性索引的名称。如需了解详情，请参阅支持性索引。

外键类型

外键分为两种类型：强制执行和信息性。强制执行的外键是默认设置，可强制执行参照完整性。信息性外键不强制执行参照完整性，最好用于声明预期用于查询优化的逻辑数据模型。如需了解详情，请参阅以下强制执行和信息性外键部分以及外键类型比较表。

强制执行外键

强制执行的外键（Spanner 中的默认外键类型）会强制执行参照完整性。由于强制执行的外键会强制执行参照完整性，因此尝试执行以下操作会导致失败：

如果向引用表中添加的行的外键值在被引用表中不存在，则添加操作会失败。

如果被引用表中的行被引用表中的行引用，则无法删除该行。

所有 PostgreSQL 外键都会强制执行。默认情况下，系统会强制执行 GoogleSQL 外键。由于默认情况下会强制执行外键，因此使用 ENFORCED 关键字指定强制执行 GoogleSQL 外键是可选操作。

信息性外键

信息性外键用于声明查询优化的预期逻辑数据模型。虽然对于信息性外键，被引用表键必须是唯一的，但不会强制执行参照完整性。如果您想在使用信息性外键时有选择地验证引用完整性，则需要在客户端管理验证逻辑。如需了解详情，请参阅使用信息性外键。

使用 NOT ENFORCED 关键字指定 GoogleSQL 外键是否为信息性外键。PostgreSQL 不支持信息性外键。

外键类型比较

强制执行和信息性都有各自的优势。以下部分将比较这两种类型的外键，并提供一些最佳实践。

外键方面的高级别差异

从总体上讲，强制执行外键和信息性外键之间存在以下一些区别：

强制执行。强制执行外键可在写入时验证并保证参照完整性。信息性外键不会验证或保证参照完整性。

存储。强制执行的外键可能需要额外的存储空间来存储受限表上的支持性索引。

写入吞吐量。在写入路径中，强制执行外键可能比信息性外键产生更多开销。

查询优化。这两种类型的外键均可用于查询优化。如果允许优化器使用信息性外键，那么如果数据与信息性外键关系不匹配（例如，如果某些受限键在被引用表中没有匹配的被引用键），查询结果可能无法反映实际数据。

外键差异表

下表列出了强制执行外键与信息性外键之间的详细区别：

强制执行外键 信息性外键

关键字 ENFORCED NOT ENFORCED

受 GoogleSQL 支持 是。默认情况下，GoogleSQL 中的外键是强制执行的。
是。

受 PostgreSQL 支持 是。PostgreSQL 中的外键只能是强制执行的。
否。

存储 强制执行的外键最多需要两个支持性索引的存储空间。
信息性外键最多需要一个支持性索引的存储空间。

在需要时，为被引用的表列创建支持性索引 是。
是。

在需要时，为引用表列创建支持性索引 是。
否。

支持外键操作 是。
否。

验证并强制执行参照完整性 是。
否。不进行验证可以提高写入性能，但如果使用信息性外键进行查询优化，则可能会影响查询结果。您可以使用客户端验证或强制执行的外键来确保引用完整性。

选择要使用的外键类型

您可以根据以下准则决定使用哪种外键类型：

我们建议您先从强制执行的外键开始。强制执行的外键可确保数据和逻辑模型始终保持一致。除非强制执行的外键不适合您的使用情形，否则建议您使用此选项。

如果以下所有条件都成立，我们建议您考虑使用信息性外键：

您希望在查询优化中使用信息性外键描述的逻辑数据模型。

严格保持参照完整性不切实际或会严重影响性能。以下是一些您可能需要考虑使用信息性外键的情况示例：

您的上游数据源遵循最终一致性模型。在这种情况下，源系统中所做的更新可能不会立即反映在 Spanner 中。由于更新可能不会立即生效，因此外键关系可能会出现短暂的不一致。

您的数据包含具有大量引用关系的被引用行。对这些行的更新可能会使用大量资源，因为 Spanner 必须验证或（在某些情况下）删除与维护参照完整性相关的所有行。在这种情况下，更新可能会影响 Spanner 性能，并降低并发事务的速度。

您的应用可以处理潜在的数据不一致性及其对查询结果的影响。

使用信息性外键

以下主题仅适用于信息性外键。如需了解适用于信息性外键和强制执行外键的主题，请参阅以下内容：

长时间运行架构更改

支持性索引

创建具有信息性外键的新表

您可以使用 DDL 语句在 Spanner 数据库中创建和移除信息性外键 。您可以使用 CREATE TABLE 语句向新表添加外键。同样，您也可以使用 ALTER TABLE 语句在现有表中添加或移除外键。

以下示例使用 GoogleSQL 创建了一个具有信息性外键的新表。PostgreSQL 不支持信息性外键。

GoogleSQL

CREATE TABLE Customers ( CustomerId INT64 NOT NULL, CustomerName STRING(MAX) NOT NULL, ) PRIMARY KEY(CustomerId);

CREATE TABLE Orders ( OrderId INT64 NOT NULL, CustomerId INT64 NOT NULL, Quantity INT64 NOT NULL, ProductId INT64 NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerId) REFERENCES Customers (CustomerId) NOT ENFORCED ) PRIMARY KEY (OrderId);

PostgreSQL

Not Supported

如需查看如何创建和管理外键的更多示例，请参阅创建和管理外键关系。如需详细了解 DDL 语句，请参阅 DDL 参考文档。
注意： 您还可以使用 Google Cloud 控制台添加和移除外键。
从表创建界面中选择以文本形式修改，然后输入 DDL 以管理表的外键。
使用信息性外键进行查询优化

查询优化器可以使用强制执行外键和信息性外键来提高查询性能。使用信息性外键可让您利用优化的查询计划，而无需严格强制执行参照完整性，从而避免产生开销。

如果您允许查询优化器利用信息性外键信息，请务必了解，优化是否正确取决于数据是否与信息性外键所描述的逻辑模型保持一致。如果存在不一致的情况，查询结果可能无法反映实际数据。不一致的一个示例是，受限列中的值在被引用列中没有匹配的值。

默认情况下，查询优化器使用 NOT ENFORCED 外键。如需更改此设置，请将数据库选项 use_unenforced_foreign_key_for_query_optimization 设置为 false。以下是一个 GoogleSQL 示例，展示了这一点（PostgreSQL 中没有信息性外键）：

SET DATABASE OPTIONS ( use_unenforced_foreign_key_for_query_optimization = false );

布尔值查询语句提示 @{use_unenforced_foreign_key} 会按查询替换数据库选项，该选项用于控制优化器是否使用 NOT ENFORCED 外键。在排查意外的查询结果时，停用此提示或数据库选项可能会很有用。以下示例展示了如何使用 @{use_unenforced_foreign_key}：

@{use_unenforced_foreign_key=false} SELECT Orders.CustomerId FROM Orders INNER JOIN Customers ON Customers.CustomerId = Orders.CustomerId;

使用强制执行的外键

以下主题仅适用于强制执行的外键。如需了解适用于信息性外键和强制执行外键的主题，请参阅以下内容：

长时间运行架构更改

支持性索引

创建具有强制执行的外键的新表

您可以使用 DDL 在 Spanner 数据库中创建、移除和强制执行外键。您可以使用 CREATE TABLE 语句向新表添加外键。同样，您可以使用 ALTER TABLE 语句在现有表中添加或移除外键。

您可以使用 DDL 在 Spanner 数据库中创建和移除外键。您可以使用 CREATE TABLE 语句向新表添加外键。同样，您可以使用 ALTER TABLE 语句在现有表中添加或移除外键。

以下是使用强制执行的外键创建新表的示例。

GoogleSQL

CREATE TABLE Customers ( CustomerId INT64 NOT NULL, CustomerName STRING(MAX) NOT NULL, ) PRIMARY KEY(CustomerId);

CREATE TABLE Orders ( OrderId INT64 NOT NULL, CustomerId INT64 NOT NULL, Quantity INT64 NOT NULL, ProductId INT64 NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerId) REFERENCES Customers (CustomerId) ENFORCED ) PRIMARY KEY (OrderId);

PostgreSQL

CREATE TABLE Customers ( CustomerId bigint NOT NULL, CustomerName character varying(1024) NOT NULL, PRIMARY KEY(CustomerId) );

CREATE TABLE Orders ( OrderId BIGINT NOT NULL, CustomerId BIGINT NOT NULL, Quantity BIGINT NOT NULL, ProductId BIGINT NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerId) REFERENCES Customers (CustomerId), PRIMARY KEY (OrderId) );

如需查看如何创建和管理外键的更多示例，请参阅创建和管理外键关系。
注意： 您还可以使用 Google Cloud 控制台添加和移除外键。
从表创建界面中选择以文本形式修改，然后输入 DDL 以管理表的外键。
外键操作

只能在强制执行的外键上定义外键操作。

外键操作用于控制在所引用的列被删除或更新时，受限列会发生什么情况。Spanner 支持使用 ON DELETE CASCADE 操作。使用外键 ON DELETE CASCADE 操作时，如果您删除包含被引用外键的行，那么引用该键的所有行也会在同一事务中被删除。

使用 DDL 创建数据库时，您可以添加带有操作的外键。使用 CREATE TABLE 语句向新表添加具有操作的外键。同样，您可以使用 ALTER TABLE 语句向现有表添加外键操作或移除外键操作。以下示例展示了如何创建具有外键操作的新表。

GoogleSQL

CREATE TABLE ShoppingCarts ( CartId INT64 NOT NULL, CustomerId INT64 NOT NULL, CustomerName STRING(MAX) NOT NULL, CONSTRAINT FKShoppingCartsCustomers FOREIGN KEY(CustomerId, CustomerName) REFERENCES Customers(CustomerId, CustomerName) ON DELETE CASCADE, ) PRIMARY KEY(CartId);

PostgreSQL

CREATE TABLE ShoppingCarts ( CartId bigint NOT NULL, CustomerId bigint NOT NULL, CustomerName character varying(1024) NOT NULL, PRIMARY KEY(CartId), CONSTRAINT fkshoppingcartscustomers FOREIGN KEY (CustomerId, CustomerName) REFERENCES Customers(CustomerId, CustomerName) ON DELETE CASCADE );

下面列出了 Spanner 中外键操作的特征。

外键操作为 ON DELETE CASCADE 或 ON DELETE NO ACTION。

您可以查询 INFORMATION_SCHEMA 以查找具有操作的外键限制条件。

不支持在现有外键限制条件上添加外键操作。您必须添加具有操作的新外键限制条件。

限制条件验证

限制条件验证仅适用于强制执行的外键。

在提交事务时或在写入影响对事务中的后续操作可见时，Spanner 会验证强制执行的外键限制条件。

插入到引用列中的值将与被引用表和被引用列的值进行匹配。系统不会检查具有 NULL 引用值的行，这意味着您可以将这些行添加到引用表中。

在尝试使用 DML 语句或 API 更新数据时，Spanner 会验证所有适用的强制执行的外键引用限制条件。如果有任何限制条件无效，则所有待更改项都将回滚。

每个 DML 语句完成之后立即进行验证。例如，您必须在插入引用行之前先插入被引用的行。使用 Mutation API 时，Mutation 会进行缓冲，直到提交事务为止。
强制执行的外键验证将推迟到提交事务之后进行。在这种情况下，可以先插入引用行。

将评估每个事务的修改是否会影响外键限制条件。此类评估可能需要向服务器发送额外请求。
支持性索引还需要额外的处理时间来评估事务修改并维护索引。此外，每个索引都需要额外的存储空间。

长时间运行的删除级联操作

从被引用表中删除某一行时，Spanner 必须删除引用表中引用了被删除行的所有行。这可能会导致连锁效应，即一次删除操作会导致数千次其他删除操作。向表添加具有删除级联操作的外键限制条件，或创建具有删除级联操作的外键限制条件的表，可能会减慢删除操作的速度。

外键删除级联的变更限制已超出

使用外键删除级联删除大量记录可能会影响性能。这是因为每条已删除的记录都会触发对与其相关的所有记录的删除操作。如果您需要使用外键删除级联来删除大量记录，请先从子表中显式删除行，然后再从父表中删除行。这样可防止事务因变更限制而失败。

强制执行的外键和表交织的比较

Spanner 的表交织是许多父子关系的理想选择，其中子表的主键包含父表的主键列。子行及其父行存储在一起，可以显著提高性能。

外键是一种较通用的父子解决方案，并解决了其他用例。外键不限于主键列，而表可以具有多个外键关系，二者在某些关系中可以作为父键，而在其他关系中可以作为子键。但是，外键关系不会隐含表在存储层中共处同一位置的关系。

不妨考虑一个使用 Orders 表的示例，该表的定义如下：

图 3.采用强制执行外键的数据库架构示意图

图 3 中的设计存在一些限制。例如，每个订单只能包含一个订购商品。

假设您的客户希望每笔订单能够订购多件商品。我们可以通过引入 OrderItems 表来增强设计，该表包含客户订购的每件商品。您可以引入另一个强制执行的外键来表示 Orders 和 OrderItems 之间新的一对多关系。不过，您也知道，您经常需要对各个订单及其各自的订购商品运行查询。由于此类数据共用空间可以提高性能，因此您需要使用 Spanner 的表交织功能创建父子关系。

下面是您对 OrderItems 表的定义（与 Orders 交织）。

GoogleSQL

CREATE TABLE Products ( ProductId INT64 NOT NULL, Name STRING(256) NOT NULL, Price FLOAT64 ) PRIMARY KEY(ProductId);

CREATE TABLE OrderItems ( OrderId INT64 NOT NULL, ProductId INT64 NOT NULL, Quantity INT64 NOT NULL, FOREIGN KEY (ProductId) REFERENCES Products (ProductId) ) PRIMARY KEY (OrderId, ProductId), INTERLEAVE IN PARENT Orders ON DELETE CASCADE;

PostgreSQL

CREATE TABLE Products ( ProductId BIGINT NOT NULL, Name varchar(256) NOT NULL, Price float8, PRIMARY KEY(ProductId) );

CREATE TABLE OrderItems ( OrderId BIGINT NOT NULL, ProductId BIGINT NOT NULL, Quantity BIGINT NOT NULL, FOREIGN KEY (ProductId) REFERENCES Products (ProductId), PRIMARY KEY (OrderId, ProductId) ) INTERLEAVE IN PARENT Orders ON DELETE CASCADE;

图 4 直观展示了更新后的数据库架构，因为引入了这个新表 OrderItems 与 Orders 交错。在这里，您还可以看到这两个表之间的一对多关系。

图 4. 添加交错的 OrderItems 表

在此配置中，您可以在每个订单中拥有多个 OrderItems 条目，每个订单的 OrderItems 条目是交织的，因此与这些订单位于同一位置。通过这种方式进行物理交织 Orders 和 OrderItems 可以提高性能，有效地预连接表并允许您一起访问相关的行，同时最小化磁盘访问。例如，Spanner 可以在本地通过主键执行联接，这样做可最大限度减少磁盘访问次数和网络流量。

如果事务中的变更数超过 80,000，则事务会失败。这种大规模的级联删除操作非常适合具有“在父表中交织”关系的表，但不适合具有外键关系的表。如果您有外键关系，并且需要删除大量行，则应先明确删除子表中的行。

如果您有一个用户表，该表与另一个表具有外键关系，并且从被引用表中删除一行会触发数百万行的删除操作，那么您应该将架构设计为具有“在父表中交织”的删除级联操作。
注意：Google 建议您选择将父子关系表示为交错表或外键，但不能同时表示为这两者。同时使用两者是冗余的，可能会消耗额外的存储和计算资源来验证限制条件并维护支持性索引。
对照表

下表汇总了强制执行的外键与表交织的比较方式。您可以根据这些信息来确定什么方式适合您的设计。

父子关系类型 表交织 强制执行外键

可以使用主键 是 是

可以使用非主键列 否 是

支持的父数据数量 0 .. 1 0 .. N

同时存储父数据和子数据 是 否

支持级联删除 是 是

Null 匹配模式 如果所有引用值与被引用值没有区别，则传递。
Null 值与 Null 值没有区别，但 Null 值与非 Null 值有区别。
如果有任何引用值为 Null，则传递。
如果所有引用值均为非 Null 值，且被引用表中有值等于引用值的行，则传递。
如果找不到匹配的行，则失败。

强制执行时间 使用 Mutation API 时的操作。
使用 DML 时的每个语句。
使用变更 API 时的每项事务。
使用 DML 时的每个语句。

可以移除。
不可以。除非删除整个子表，否则一旦创建表交织就无法移除。
是

支持性索引

外键不使用用户创建的索引。它们会创建自己的支持性索引。强制执行和信息性外键在 Spanner 中创建支持性索引的方式有所不同：

对于强制执行的外键，Spanner 可以为每个外键创建最多两个二级支持性索引，一个用于引用列，另一个用于被引用列。

对于信息性外键，Spanner 可以根据需要为被引用列创建一个支持性索引。信息性外键不会为引用列创建支持性索引。

对于强制性外键和信息性外键，外键通常会引用被引用表的主键，因此通常不需要被引用表的索引。因此，信息性外键通常没有支持性索引。如果需要，为被引用的表创建的支持性索引是 UNIQUE NULL_FILTERED 索引。如果任何现有数据违反了索引的唯一性限制条件，则无法创建外键。

信息性外键没有引用表的支持性索引。对于强制执行的外键，引用表的支持性索引为 NULL_FILTERED。

如果两个或更多外键需要相同的支持性索引，则 Spanner 会为每个外键创建一个索引。丢弃使用该索引的外键，将同时丢弃支持性索引。您无法更改或丢弃支持性索引。

Spanner 使用每个数据库的信息架构来存储有关支持性索引的元数据。INFORMATION_SCHEMA.INDEXES 中 SPANNER_IS_MANAGED 值为 true 的行描述的是支持性索引。

除了直接调用信息架构的 SQL 查询之外，Google Cloud 控制台不会显示有关数据库支持性索引的任何信息。

长时间运行架构更改

将强制执行的外键添加到现有表或使用外键创建新表可能导致产生长时间运行的操作。对于新表，只有在长时间运行的操作完成之后，才能写入该表。

下表显示了在 Spanner 中，当新表或现有表中包含强制执行外键和信息性外键时会发生什么情况：

表类型 强制执行外键 信息性外键

新 Spanner 会根据需要为每个外键回填被引用索引。
Spanner 会根据需要为每个外键回填被引用索引。

现有 Spanner 会根据需要回填引用索引和被引用索引。Spanner 还会验证表中的现有数据，以确保其符合外键的参照完整性限制条件。如果有任何数据无效，架构更改将失败。
Spanner 会根据需要回填被引用索引，但不会验证表中的现有数据。

不支持：

向现有强制执行的外键限制条件添加外键操作。

更改现有外键的强制执行情况。

对于这两种情况，我们建议您改为执行以下操作：

添加具有所需操作或强制执行的新限制。

舍弃旧的限制条件。

添加新限制条件并舍弃旧限制条件可防止出现长时间运行的 Alter Constraint 操作问题。例如，假设您想在现有外键上添加 DELETE CASCADE 操作。使用 ON DELETE CASCADE 操作创建新的外键后，这两个限制条件的效果都是 DELETE CASCADE 操作。然后，您可以安全地舍弃旧的限制条件。

如果索引未被其他外键限制条件使用，则丢弃限制条件可能会导致丢弃外键支持性索引。因此，如果您先删除旧的限制条件，之后再添加具有操作的相同外键限制条件，可能会导致长时间运行的操作，例如回填索引、验证唯一索引限制条件或验证外键参照完整性限制条件。
注意： 如果不舍弃旧的外键限制条件，则需要验证额外的外键限制条件，这会导致不必要的开销。此外，如果 UNIQUE 限制条件违规导致无法创建所引用的索引，则添加新限制条件可能会失败。

您可以查询 INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS.SPANNER_STATE 以检查外键创建状态。

后续步骤

了解如何创建和管理外键关系。

详细了解信息架构。

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
