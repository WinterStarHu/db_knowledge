# PostgreSQL 接口  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/postgresql-interface

PostgreSQL 接口  |  Spanner  |  Google Cloud Documentation

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

PostgreSQL 接口

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

借助适用于 Spanner 的 PostgreSQL 接口，您可以使用熟悉的 PostgreSQL 工具和语法来利用 Spanner 的全托管式、可扩缩且高度可用的基础设施。本页面可帮助您了解 PostgreSQL 接口的功能和限制。

PostgreSQL 接口的优势

可移植性：PostgreSQL 接口使用与开源 PostgreSQL 兼容的架构、查询和客户端，提供对各种 Spanner 功能的访问权限。因此，将基于 Spanner 构建的应用迁移到其他 PostgreSQL 环境就变得十分简单。这种可移植性可提供部署灵活性，并支持灾难恢复场景，例如被迫退出。

熟悉程度：如果您已使用 PostgreSQL，则可以使用许多相同的 PostgreSQL 语句和工具快速开始使用 Spanner。在整个数据库产品组合中使用 PostgreSQL 意味着特定产品之间的差异更少，并且有一套通用的最佳实践。

不妥协地使用 Spanner：由于 PostgreSQL 接口是基于 Spanner 现有基础构建的，因此它可以提供 Spanner 现有的所有可用性、一致性和性价比优势，而无需在互补的 GoogleSQL 生态系统中牺牲任何可用功能。

Spanner 中不支持的 PostgreSQL 功能

请务必了解，PostgreSQL 接口通过与 PostgreSQL 兼容的架构、类型、查询和客户端来提供 Spanner 的功能。它并不支持 PostgreSQL 的所有功能。将现有 PostgreSQL 应用迁移到 Spanner，即便使用 Spanner 的 PostgreSQL 接口，也可能需要进行一些改造，以适应不受支持的 PostgreSQL 功能或行为差异，例如查询优化或主键设计。不过，迁移完成后，工作负载便可充分利用 Spanner 的可靠性和独特的多模型功能。

下表列出了支持和不支持的 PostgreSQL 功能的详细信息：

支持的 PostgreSQL 功能：PostgreSQL 接口支持许多最常用的 PostgreSQL 功能。包括架构和类型系统的核心部分、许多常见的查询形状、各种函数和运算符，以及 PostgreSQL 系统目录的关键方面。应用可以通过 Spanner 实现的 PostgreSQL 传输协议进行连接，从而使用多个 PostgreSQL 客户端。

不支持的某些 PostgreSQL 语言功能：不支持扩展程序、用户定义的数据类型、用户定义的存储过程和其他功能。如需查看完整列表，请参阅 Spanner 中的 PostgreSQL 语言。此外，PostgreSQL 中还有一些功能的行为与开源 PostgreSQL 不同。如需了解详情，请参阅适用于 Spanner 的 PostgreSQL 接口中的已知问题。

Spanner 和 Spanner 控制平面：具有 PostgreSQL 接口的数据库使用 Spanner 和 Google Cloud工具来预配、保护、监控和优化实例。Spanner 不支持使用 pgAdmin 等工具来执行管理活动。

客户端和传输协议支持：Spanner 使用 PGAdapter（与您的应用一起运行的轻量级代理）支持 PostgreSQL 传输协议的核心查询功能。这使许多 Spanner 客户端可以正常使用 Spanner PostgreSQL 接口数据库，同时利用 Spanner 的全局端点和连接管理以及 IAM 身份验证。Google 的内部基准测试结果显示，与直接连接到 Spanner 的内置端点相比，PGAdapter 不会增加任何明显的额外延迟时间。

行政和管理

PostgreSQL 接口支持通过以下功能来控制和管理 Spanner 数据库：

统一体验：使用 Spanner 的现有控制台、API 和工具（如 Google Cloud CLI）预配、管理和监控启用了 PostgreSQL 接口的数据库。

灵活配置：在创建时按数据库配置 PostgreSQL 接口。单个 Spanner 实例可以同时容纳 GoogleSQL 和 PostgreSQL 接口数据库。

共同优势：这两种数据库方言共享相同的底层分布式数据库引擎，可确保一致的可伸缩性、一致性、性能和安全性。

特性

Spanner 的 PostgreSQL 接口提供两项主要功能来实现与 PostgreSQL 生态系统的集成：

PostgreSQL 方言支持

Spanner 提供了一部分 PostgreSQL SQL 方言，包括数据查询语言 (DQL)、数据操纵语言 (DML) 和数据定义语言 (DDL)。此外，它还包含一些扩展，可支持 Spanner 特有的功能，例如交错表、存留时间 (TTL) 和查询提示。

如需详细了解支持的 PostgreSQL 语言元素，请参阅 Spanner 中的 PostgreSQL 语言。如需了解如何将 Spanner 功能与 PostgreSQL 方言搭配使用，请参阅相应功能的文档。

PostgreSQL 客户端支持

借助 Spanner，您可以通过各种客户端连接到数据库：

PostgreSQL 生态系统工具：您可以使用熟悉的工具（例如 PostgreSQL JDBC 驱动程序和 PostgreSQL pgx 驱动程序）将应用连接到 PostgreSQL 接口数据库。如需查看受支持的驱动程序、ORM 和工具的列表，请参阅 PostgreSQL 驱动程序和 ORM。

psql 命令行工具：支持常用的 psql 交互式环境，让您能够直接从终端运行查询、探索元数据和加载数据。

PGAdapter：此轻量级代理可简化连接管理和身份验证。如需了解详情，请参阅 PGAdapter 概览。

Spanner 客户端：Spanner 为各种编程语言（Java、Go、Python、Node.js、Ruby、PHP、C#、C++）提供了开源 Spanner 客户端，以及 Spanner JDBC 驱动程序和 Go 的 SQL 软件包的驱动程序。Spanner 客户端直接连接到 Spanner 的全球端点，无需使用代理。但是，Spanner 客户端与现有的 PostgreSQL 客户端、ORM 或工具不兼容。

使用 PostgreSQL 接口的最佳实践

使用 PostgreSQL 接口时，请遵循以下最佳实践：

连接应用：使用一组受支持的 PostgreSQL 工具实现高效连接。

与数据库交互：对于交互式工作，请选择以下选项之一：

熟悉的 psql 命令行工具（使用 PGAdapter 代理）

Google Cloud 控制台中直观的 Spanner Studio 页面

IDE，例如 DBeaver 和 Visual Studio Code、JetBrains 和 IntelliJ

Spanner 模拟器，可让您在本地机器上模拟 Spanner。这在开发和测试过程中非常有用。

后续步骤

了解如何在 PostgreSQL 和 GoogleSQL 之间进行选择。

按照快速入门创建 PostgreSQL 数据库并与之交互。

详细了解 Spanner 的 PostgreSQL 语言支持。

了解 PGAdapter。

了解 PGAdapter GitHub 代码库。

查看 PostgreSQL 接口中的已知问题。

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
