# 分层存储概览  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/tiered-storage

分层存储概览  |  Spanner  |  Google Cloud Documentation

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

分层存储概览

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

注意：此功能适用于 Spanner 企业版和企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

本页面介绍和说明了分层存储在 Spanner 中的运作方式。GoogleSQL 方言数据库和 PostgreSQL 方言数据库都支持此功能。

Spanner 分层存储是一种全托管式存储功能，可让您选择是将数据存储在固态硬盘 (SSD) 还是普通硬盘 (HDD) 上。默认情况下，如果您不使用分层存储，您的数据会存储在 SSD 存储空间中。根据您使用或访问数据的频率，您可以考虑使用分层存储，并在 SSD 和 HDD 存储空间中存储数据。

对于大多数应用场景而言，SSD 存储空间是性能最高（每秒查询次数更高）且最具成本效益的选择。您应使用它来存储具有高写入和读取吞吐量的活跃数据以及需要低延迟数据访问权限的数据。

HDD 存储空间有时适用于对延迟不敏感、不常访问的大型数据集，或者存储成本是重要考虑因素的情况。

使用分层存储，您可以同时利用 SSD 存储空间（支持活跃数据的高性能）和 HDD 存储空间（支持低成本的非频繁数据访问权限）。

在 SSD 和 HDD 存储设备之间选择

下表列出了 SSD 和 HDD 存储空间之间的异同。表中的吞吐量数据是每个节点的数据，并且与 Spanner 实例中的节点数量呈线性比例关系。如果不确定，我们建议您选择 SSD 存储空间。

SSD 存储空间 HDD 存储空间

目标应用场景 需要高写入和读取吞吐量以及低延迟数据访问权限的数据 对延迟不敏感或不常访问的大型数据集

每个节点的预期吞吐量 区域级配置 读取速度高达 22,500 QPS 写入速度高达 3,500 QPS 读取速度高达 1,500 QPS 写入速度高达 3,500 QPS

每个节点的预期吞吐量 双区域和多区域配置 每个区域读取速度高达 1,500 QPS 写入速度高达 2,700 QPS 每个区域读取速度高达 1,000 QPS 写入速度高达 2,700 QPS

支持的操作 读取、写入、更新和删除 读取、写入、更新和删除

使用吞吐量优化写入可提高写入吞吐量，使其超出表中的数字。如需了解详情，请参阅性能概览。

优势

分层存储可让您同时使用 SSD 和 HDD 存储空间，从而提供以下优势：

显著降低总拥有成本：HDD 存储空间可为对延迟不敏感或不常访问的大型数据集提供成本更低的选择。

易于管理：提供全托管式分层服务，而无需额外的流水线和拆分逻辑的复杂性。

统一且一致的体验：提供统一的数据访问权限，并针对热数据和（可变）冷数据提供一组指标

提升性能：通过将数据整理在不同的存放区域群组中来提高查询性能，从而提供跨列的数据存放区域和隔离。同一存放区域群组中的数据在物理上存储在一起。

分层存储的运作方式

默认情况下，当您创建新实例时，数据仅存储在 SSD 存储空间中。同样，现有实例中的数据也只能存储在 SSD 存储空间中。

如果您选择使用分层存储将部分数据存储在 HDD 存储空间中，则必须创建存放区域群组，以便为架构中的数据定义分层存储政策。创建存放区域群组时，您可以定义存储空间类型，即 ssd 或 hdd。您也可以选择定义数据在 SSD 存储空间中存储的时间（在数据移至 HDD 存储空间之前）。此时间是相对于数据的提交时间戳而言的。在指定时间过去后，Spanner 会在正常压缩周期内将数据迁移到 HDD 存储空间，该周期通常在指定时间后的 7 天内发生。这种政策称为基于存在时长的分层存储政策。使用基于存在时长的分层存储政策时，数据必须在 SSD 中存储的最短时间（在将其移至 HDD 存储空间之前）为 1 小时。

定义存放区域群组后，在创建表时，您可以在数据库、表、列或二级索引级别设置分层存储政策。分层存储政策决定了数据的存储方式和存储位置。如需了解相关说明，请参阅创建和管理存放区域群组。

主要行为详细信息

使用分层存储时，存在以下行为：

存储层级应用于单元级：基于存在时长的分层存储政策会根据单元的提交时间戳应用于行中的各个单元。如果数据的提交时间戳早于指定时长，则数据会被移至 HDD 存储空间。因此，单个行可能同时包含 SSD 和 HDD 上的数据，具体取决于每个单元格上次更新的时间。

交织表是独立的：交织子表不会继承存储区域群组设置和分层存储政策。您必须单独将这些设置应用于每个表格。

读取操作不会影响数据老化：从表中读取数据不会重置其老化时间，也不会阻止其移至 HDD。只有更新数据的写入操作才会重置其提交时间戳并将其保留在 SSD 存储空间中。

将数据从 HDD 移回 SSD：当您更新存储在 HDD 上的数据时，Spanner 会将新版本的数据直接写入 SSD 存储空间。HDD 上的旧版数据会被标记为过时，并由后台压缩进程稍后清理。这样可确保对冷数据的更新能够立即受益于 SSD 性能，以便后续读取新数据。

备份和恢复

您可以使用 Spanner 备份来备份和恢复数据。备份包含所有存储架构信息，包括 INFORMATION_SCHEMA.LOCALITY_GROUP_OPTIONS，用于指定每个存放区域群组的存储类型。如需将包含存放区域群组的备份恢复到新实例，目标实例必须是 Spanner 企业版或 Spanner 企业 Plus 版。

Data Boost

您可以使用 Spanner Data Boost 访问 SSD 或 HDD 存储空间中的数据。查询 HDD 中的数据会使用实例的 HDD 磁盘负载容量，这是计算容量的一部分。

搜索索引

全文搜索和向量索引会继承在数据库对象上设置的存放区域群组。

可观测性

分层存储提供以下可观测性功能。

Cloud Monitoring 指标

Spanner 提供以下指标，可帮助您使用 Cloud Monitoring 监控分层存储空间用量和数据：

spanner.googleapis.com/instance/storage/used_bytes（总存储空间）：显示 SSD 和 HDD 存储空间中存储的数据总字节数。

spanner.googleapis.com/instance/storage/combined/limit_bytes：显示 SSD 和 HDD 存储空间限制的总计。

spanner.googleapis.com/instance/storage/combined/limit_bytes_per_processing_unit：显示每个处理单元的 SSD 和 HDD 存储空间限制总计。

spanner.googleapis.com/instance/storage/combined/utilization：显示 SSD 和 HDD 存储空间利用率的总计，并与存储空间限制总计进行比较。

spanner.googleapis.com/instance/disk_load：以百分比显示 HDD 用量。如果您的实例达到 100% 的 HDD 磁盘负载，您会遇到延迟时间显著增加的情况。

如果您有现有查询会按 storage_class:ssd 过滤现有指标，则必须移除该过滤条件才能查看 HDD 用量。

如需详细了解如何监控 Spanner 资源，请参阅使用系统分析洞见监控实例和使用 Cloud Monitoring 监控实例。

信息架构

INFORMATION_SCHEMA.LOCALITY_GROUP_OPTIONS 包含 Spanner 数据库中的存放区域群组和选项列表。它包含 default 存放区域群组的信息。如需了解详情，请参阅 GoogleSQL 方言数据库的 locality_group_options 和 PostgreSQL 方言数据库的 locality_group_options。

内置统计信息表

以下内置统计信息表适用于使用分层存储的数据库：

SPANNER_SYS.TABLE_SIZES_STATS_1HOUR：显示数据库中每个表的 HDD 和 SSD 存储空间用量。

SPANNER_SYS.TABLE_SIZES_STATS_PER_LOCALITY_GROUP_1HOUR：显示数据库中每个存放区域群组的 HDD 和 SSD 存储空间用量。

如需了解详情，请参阅表大小统计信息。

查询统计信息表和读取统计信息表具有以下与分层存储相关的列：

AVG_DISK_IO_COST：此查询在 Spanner HDD 磁盘负载方面的平均成本。使用此值可在数据库中运行的读取操作之间比较相对 HDD I/O 成本。值越高，表示您使用的 HDD 磁盘负载越多，并且查询的速度可能比在 SSD 上运行时慢。此外，如果您的 HDD 磁盘负载达到容量上限，您的查询性能可能会受到进一步影响。

如需了解详情，请参阅查询统计信息和读取统计信息。

价格

使用分层存储不会产生额外费用。您需要根据实例使用的计算容量和数据库使用的存储空间支付标准 Spanner 价格。存储在 SSD 和 HDD 上的数据会按各自的存储费率计费。您在 SSD 和 HDD 存储空间之间移动数据时不会产生费用。查询 HDD 中的数据会使用实例的 HDD 磁盘负载容量，这是计算容量价格的一部分。如需了解详情，请参阅 Spanner 价格。

后续步骤

详细了解位置组。

了解如何创建和管理存放区域群组。

详细了解如何使用时间戳谓词下推优化查询。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-06-19。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-06-19。"],[],[]]

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
