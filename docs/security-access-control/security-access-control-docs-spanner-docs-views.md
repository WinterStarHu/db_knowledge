# 视图概览  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/views

视图概览  |  Spanner  |  Google Cloud Documentation

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

视图概览

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

PostgreSQL 接口说明：视图在 PostgreSQL 方言数据库中受支持，但与开源 PostgreSQL 存在一些差异。在 Spanner 中，视图是只读的。视图不能作为 INSERT、UPDATE 或 DELETE 语句的目标。

本文档介绍并描述了 Spanner 视图。

概览

视图是由 SQL 查询定义的虚拟表。创建视图时，您可以指定视图所代表的 SQL 查询。创建视图后，您可以执行引用该视图的查询，就像使用表一样。

当执行引用视图的查询时，Spanner 将通过执行视图中定义的查询来创建虚拟表，并且引用查询会使用该虚拟表的内容。

由于每次执行引用视图的查询时都会执行定义视图的查询，因此视图有时称为“逻辑视图”或“动态视图”，以便与 SQL 物化视图区分，后者将定义视图的查询结果存储为数据存储空间中的实际表。

在 Spanner 中，您可以采用调用方权限视图或定义方权限视图的形式创建视图。它们是两种类型的安全模型，用于控制用户对视图的访问权限。

调用方权限视图定义方权限视图

说明 如果您创建具有调用方权限的视图，则数据库角色需要对该视图以及该视图引用的所有架构对象拥有权限，才能查询该视图。如需了解详情，请参阅调用方权限视图。
如果您创建具有定义方权限的视图，则数据库角色需要对该视图（且仅对该视图）拥有权限才能查询该视图。请将精细访问权限控制与定义方权限视图搭配使用，否则定义方权限视图不会添加任何额外的访问权限控制。如需了解详情，请参阅定义方权限视图。

创建视图所需的权限 如需创建、授予和撤消对任一视图类型的访问权限，您必须拥有数据库级 spanner.database.updateDdl 权限。

查询视图所需的权限 数据库角色需要对相应视图及其所有底层架构对象拥有权限，才能查询该视图。
数据库角色需要对相应视图（且仅对该视图）拥有权限才能查询该视图。

视图的优势

与在应用逻辑中添加定义的查询相比，视图具有一些优势。

视图可为应用提供逻辑数据建模。

有时，对 Spanner 上的物理数据建模有意义的选择不是读取该数据的应用的最佳抽象。视图可以呈现一个更合适的应用抽象作为备用表架构。

视图可集中管理查询定义，从而简化维护工作。

通过为广泛使用或复杂的查询创建视图，您可以从应用中分离开查询文本并将其集中。这样做可以使各个应用中的查询文本保持最新，并使修订和调整查询的变更无需更改应用代码。

视图可跨架构更改提供稳定性。

由于定义视图的查询存储在数据库架构中（而不是应用逻辑中），因此 Spanner 可以确保对查询所引用对象（表、列等等）进行的架构更改不会使查询失效。

常见使用场景

如果您的 Spanner 数据库包含不应向所有数据库用户公开的高特权数据，或者您想要封装数据，请使用视图。

如果您的视图不需要额外的安全功能，并且视图的所有调用方都有权访问视图引用的所有架构对象，请创建调用方权限视图。

如果您想创建一个视图，其中并非所有调用方都有权访问视图引用的所有架构对象，请创建定义方权限视图。定义方权限视图会受到更好的保护，并且具有更多限制，因为数据库管理员可以向更少的用户授予对视图中引用的表和列的权限。当用户需要一种安全的方式来访问 Spanner 数据库的相关子集时，定义方权限视图非常有用。例如，您可能需要为以下数据创建定义方权限视图：

个人账号数据（例如应用客户）。

特定于角色的数据（例如，HR 人员、销售助理）。

特定于位置的数据。

调用方权限视图

如果视图具有调用方权限，则意味着当用户（即调用方）针对该视图执行查询时，Spanner 会检查用户对该视图以及该视图引用的所有架构对象的权限。用户必须拥有对所有架构对象的权限才能查询该视图。

定义方权限视图

定义方权限视图会向视图添加额外的安全功能。它针对视图和底层架构对象提供不同的权限。与调用方权限视图类似，用户必须拥有数据库级权限才能创建定义方权限视图。主要区别在于，当数据库角色查询定义方权限视图时，Spanner 会验证角色是否对该视图本身（并且仅对该视图）拥有访问权限。因此，即使查询视图的用户无权访问所有底层架构对象，也可以访问该视图并查看其内容。定义方权限视图可让用户有权访问最新数据，但仅限于视图中定义的行。

Spanner Identity and Access Management (IAM) 权限是在数据库级进行授予的。请将精细访问权限控制与定义方权限视图搭配使用，否则定义方权限视图不会添加任何额外的访问权限控制。这是因为，如果用户对数据库拥有读取权限，则对数据库中的所有架构对象都拥有读取权限。对数据库配置精细访问权限控制后，对视图拥有 SELECT 权限的精细访问权限控制用户以及对数据库拥有数据库级权限的用户可以查询视图。不同之处在于，精细访问权限控制用户不需要对底层对象拥有权限。

视图的限制

与实际表相比，视图具有一些限制，因此不适合某些使用场景。

视图是只读的。不能用于添加、更新或删除数据。

您不能在 DML 语句（INSERT、UPDATE、DELETE）中使用视图。

定义视图的查询无法使用查询参数。

视图无法编入索引。

对视图的引用不能使用表提示。

但是，定义视图的查询可以在其引用的表上包含表提示。

Read API 不支持视图。

Spanner Data Boost 不支持定义方权限视图。

在 Data Boost 中运行包含定义方权限视图的查询会导致错误。

访问定义方权限视图的推荐查询模式是 NORMAL 模式。

如果用户无权访问定义方权限视图的底层架构对象，则在以正常模式之外的查询模式进行查询时会收到错误。

用户可以创建精心设计的查询，使 Spanner 抛出错误，以显示或揭示存在定义方权限视图中不可用的数据。

例如，假设存在以下视图 QualifiedStudentScores，该视图会返回符合课程资格条件的学生的分数。资格条件取决于学生的级别和考试分数。如果学生的级别等于或低于 6，则分数很重要，学生必须在考试中获得至少 50 分才符合资格条件。否则，级别等于或高于 6 的学生默认符合资格条件。

CREATE VIEW QualifiedStudentScores SQL SECURITY DEFINER AS SELECT s.Name, s.Level, sc.Score FROM Students AS s JOIN Scores AS sc ON sc.StudentId = s.StudentId WHERE (CASE WHEN (s.Level = 6 AND sc.Score >= 50) THEN 'QUALIFIED';
ELSE 'FAILED';
END) = 'QUALIFIED';

用户可以运行 SELECT * FROM QualifiedStudentScores s WHERE s.Level = 7 AND 1/(s.Score - 20) = 1; 形式的查询。如果一个级别为 7 的学生的分数为 20 分，即使视图将该级别的数据限制为 50 分及以上，此查询也可能会因除数为零错误而失败。

使用视图时的查询性能

引用视图的查询与其视图引用被视图定义所取代后的同一查询等效。

适用于视图的配额和限制

配额和限制页面列出了专门针对视图的配额和限制信息。

在查询中使用视图可能会影响该查询的查询限制，因为视图定义将成为查询的一部分。

费用冲击

使用视图对实例费用的影响非常小：

与将定义的查询文本嵌入到引用它们的查询相比，使用视图对实例的计算容量需求没有影响。

使用视图对实例的数据库存储空间影响极小，因为通过执行视图的查询定义生成的表不会保存到永久性数据库存储空间。

后续步骤

了解如何创建和管理视图。

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
