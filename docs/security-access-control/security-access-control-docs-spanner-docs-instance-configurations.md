# 单区域、双区域和多区域配置  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/instance-configurations

单区域、双区域和多区域配置  |  Spanner  |  Google Cloud Documentation

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

单区域、双区域和多区域配置

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了 Spanner 中提供的不同类型的实例配置，以及它们之间的差异和权衡。

实例配置

Spanner 实例配置定义了相应实例中数据库的地理位置和复制方式。创建实例时，您必须将其配置为单区域、双区域或多区域。您可以通过选择确定实例的数据存储位置的实例配置来进行该选择：

单区域配置：所有资源都位于单个 Google Cloud 区域中

双区域配置：所有资源都分布在两个区域中，但位于一个国家/地区内（适用于企业 Plus 版）

多区域配置：资源分布在两个以上的区域中（适用于企业 Plus 版）

如需详细了解特定于区域的注意事项，请参阅地理位置和区域。

具有预定义区域和复制拓扑的实例配置称为基本实例配置。您可以创建自定义实例配置，并向预定义基本实例配置添加额外的可选只读副本（适用于企业版和企业 Plus 版）。添加的只读副本必须位于不属于现有实例配置的区域中。如需查看可添加的可选只读区域的列表，请参阅可用的单区域配置和可用的多区域配置下的“可选区域”列。您无法更改基本实例配置的复制拓扑。如需了解详情，请参阅只读副本。

您可以从任何实例配置将实例移至任何其他单区域、双区域或多区域实例配置（例如，从 regional-us-central1 移至 nam3）。您还可以创建包含额外副本的新自定义实例配置，然后将实例移至新自定义实例配置。例如，如果您的实例位于 regional-us-central1 中，并且您想要添加只读副本 us-west1，则需要创建一个将 regional-us-central1 作为基本配置的新自定义实例配置，然后将 us-west1 添加为只读副本。接下来将实例移至这一新自定义实例配置。

单区域配置

Google Cloud 服务在北美洲、南美洲、欧洲、亚洲和澳洲的多个位置提供。如果您的用户和服务位于单个区域内，请选择单区域实例配置以实现最低延迟的读取和写入。

对于任何基本单区域配置，Spanner 维护三个读写副本，每个副本都位于该区域的不同 Google Cloud可用区中。每个读写副本均包含可操作数据库的完整副本，能够处理读写请求和只读请求。Spanner 使用位于不同可用区的副本，以便在发生单可用区故障时，您的数据库仍然可用。

可用配置

Spanner 提供以下基本单区域实例配置。如需请求下表中未列出的可选只读副本区域，请填写此请求表单。请注意，我们会根据这些请求来评估未来区域的需求，但可能不会直接回复您的提交内容。

基本配置名称 区域说明 可选区域

美洲

regional-northamerica-northeast1 蒙特利尔

二氧化碳排放量低

regional-northamerica-northeast2 多伦多

二氧化碳排放量低

regional-northamerica-south1 克雷塔罗州

regional-southamerica-east1 圣保罗

二氧化碳排放量低

regional-southamerica-west1 圣地亚哥

二氧化碳排放量低

regional-us-central1 爱荷华

二氧化碳排放量低

只读：asia-northeast1 1-OR asia-south1 1-OR europe-west2 1-OR europe-west9 1-OR us-west3 1-OR

regional-us-east1 南卡罗来纳州

只读：us-central1 1-OR us-west1 1-OR europe-west1 1-OR europe-west3 1-OR

regional-us-east4 北弗吉尼亚

regional-us-east5 哥伦布

regional-us-south1 达拉斯

二氧化碳排放量低

regional-us-west1 俄勒冈

二氧化碳排放量低

regional-us-west2 洛杉矶

regional-us-west3 盐湖城

regional-us-west4 拉斯维加斯

欧洲

regional-europe-central2 华沙

regional-europe-north1 芬兰

二氧化碳排放量低

regional-europe-north2 斯德哥尔摩

二氧化碳排放量低

regional-europe-southwest1 马德里

二氧化碳排放量低

regional-europe-west1 比利时

二氧化碳排放量低

只读：us-central1 1-OR us-west1 1-OR

regional-europe-west2 伦敦

二氧化碳排放量低

regional-europe-west3 法兰克福

regional-europe-west4 荷兰

二氧化碳排放量低

regional-europe-west6 苏黎世

二氧化碳排放量低

regional-europe-west8 米兰

regional-europe-west9 巴黎

二氧化碳排放量低

regional-europe-west10 柏林

regional-europe-west12 都灵

亚太地区

regional-asia-east1 台湾

regional-asia-east2 香港

regional-asia-northeast1 东京

regional-asia-northeast2 大阪

regional-asia-northeast3 首尔

regional-asia-south1 孟买

regional-asia-south2 德里

regional-asia-southeast1 新加坡

regional-asia-southeast2 雅加达

regional-australia-southeast1 悉尼

regional-australia-southeast2 墨尔本

中东

regional-me-central1 多哈

regional-me-central2 Dammam

regional-me-west1 特拉维夫

非洲

regional-africa-south1 约翰内斯堡

复制

基本单区域配置包含三个读写副本。每项 Spanner 变更都需要由大多数投票副本组成的写入仲裁。在单区域配置中，写入仲裁由三个副本中的两个副本组成。如需详细了解主要区域和投票副本，请参阅复制。

您可以创建自定义单区域实例配置，并添加可选只读副本。只读副本有助于扩容读取并支持低延迟时间过时数据读取。这些只读副本不参与写入仲裁。对于区域级实例，副本不会影响 Spanner >= 99.99% 服务等级协议 (SLA)。您可以将“可选区域”列下列出的位置添加为可选只读副本。如果您没有看到所选择的只读副本位置，可以申请新的可选只读副本区域。如需了解详情，请参阅只读副本。

单区域配置的性能最佳实践

为了实现最佳性能，请遵循以下最佳做法：

设计架构以防止出现热点和其他性能问题。

将关键计算资源放到您的 Spanner 实例所在的同一区域中。

预配足够的计算容量，使高优先级总 CPU 利用率保持在 65% 以下。

如需了解每个 Spanner 节点的吞吐量，请参阅单区域配置的性能。

双区域配置 注意：双区域配置适用于 Spanner 企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

通过双区域配置，您可以按照实例配置的定义，在一个国家/地区的两个区域中的多个可用区内复制数据库数据。

双区域配置会执行以下操作：

从一个国家/地区内的两个区域为读取请求提供数据。

满足数据驻留要求。

提供比区域级配置更高的可用性和 SLA。

Spanner 在澳大利亚、德国、印度和日本提供双区域配置。

如需了解每个 Spanner 节点的吞吐量，请参阅双区域配置的性能。

可用配置

Spanner 提供以下基本双区域实例配置：

基本配置名称 资源位置 区域

dual-region-australia1 au（澳大利亚） 悉尼：australia-southeast1L、2RW+1W 墨尔本：australia-southeast2 2RW+1W

dual-region-germany1 de（德国） 柏林：europe-west10 L、2RW+1W 法兰克福：europe-west3 2RW+1W

dual-region-india1 in（印度） 孟买：asia-south1 L、2RW+1W 德里：asia-south2 2RW+1W

dual-region-japan1 jp（日本） 东京：asia-northeast1 L、2RW+1W 大阪：asia-northeast2 2RW+1W

优势

双区域实例提供了以下主要优势：

可用性达 99.999%：跨同一国家/地区的两个区域，大于 Spanner 单区域配置所提供的 99.99% 可用性。

数据分布：可在保证强一致性的前提下，自动在两个区域之间复制数据。

数据驻留要求：在双区域可用配置下列出的国家/地区中满足数据驻留要求。

复制

双区域包含六个副本，每个区域三个副本。其中一个区域被指定为默认主要区域（在上表中列出）。您可以更改数据库的主要区域。在每个区域中，有两个读写副本和一个见证者副本。在双区域配置中，当两个区域都健康状况良好且正在运行时，会在所有六个副本之间建立仲裁。每个区域内至少要有两个副本，才能组成仲裁并提交事务。

故障切换和故障恢复

创建双区域配置后，您可以在系统数据分析信息中心内查看“双区域仲裁健康状况时间轴”指标。此指标仅适用于双区域配置。它会显示三个仲裁的健康状况：

双区域仲裁：Global

每个区域（例如 Sydney 和 Melbourne）中的单区域仲裁

当服务中断时，时间轴中会显示一个橙色条。您可以将鼠标悬停在橙色条上方，查看中断的开始时间和结束时间。

如需实现更快的恢复时间目标 (RTO)，我们建议您监控双区域仲裁健康状况时间轴指标或针对该指标设置提醒。此指标有助于您在发生区域级故障时，针对何时进行故障切换做出自行管理的决策。触发实例故障切换后，故障切换通常会在 1 分钟内完成。

Spanner 还支持由 Google 管理的自动故障切换，从首次检测到故障到故障切换完成可能需要长达 45 分钟的时间。RTO 较长是因为 Google 会在整个服务范围内进行监控。我们需要收集更多信号来验证整个区域是否中断，并验证是否存在区域级影响。这样还可确保通过故障切换为相应配置中的用户提供更好的整体服务。

如需手动执行故障切换和故障恢复，请参阅更改双区域仲裁。

在进行手动故障切换和故障恢复决策时，请考虑以下事项：

如果所有三个仲裁都健康状况良好，则无需执行任何操作。

如果其中一个区域显示中断，则可能存在区域级服务中断。这可能会导致在双区域仲裁中运行的数据库的可用性降低。写入也可能会因无法建立仲裁而失败，并且事务最终会超时。使用“系统数据分析”信息中心，观察数据库中的错误率和延迟时间。如果错误率或延迟时间有所增加，我们建议您进行故障切换，即将双区域仲裁从双区域更改为仍然健康状况良好的区域。在中断的区域再次健康状况良好后，您必须执行故障恢复，将双区域仲裁从单区域更改为双区域。当 Google 检测到区域级服务中断时，会自动执行故障切换和故障恢复。如果您检测到中断，也可以手动进行故障切换。不过，如果您执行了手动故障切换，请务必记得手动进行故障恢复。

如果双区域仲裁显示中断，即使两个单一区域都健康状况良好，也表示存在网络分区问题。这两个区域无法再相互通信，因此即使整个系统健康状况不佳，它们也会各自显示为健康状况良好。在这种情况下，我们建议您故障切换到默认主要区域。在网络分区问题得到解决且双区域仲裁恢复为健康状况良好后，您必须手动进行故障恢复。

双区域可实现零恢复点目标 (RPO)，因为在区域级服务中断期间或出现网络分区问题时，不会丢失任何数据。

如需检查双区域仲裁的模式（单区域或双区域），请参阅检查双区域仲裁。

故障切换和故障恢复最佳实践

故障切换和故障恢复最佳实践包括：

如果没有发生区域故障或中断，请勿故障切换到单一区域。如果故障切换到单一区域，那么在该单一区域发生故障时，整个系统不可用的可能性会增加。

选择进行故障切换的区域时，请务必谨慎。如果选择进行故障切换的区域有误，会导致数据库不可用，并且在相应区域恢复在线状态之前不可恢复。如需验证，您可以使用 Bash 脚本在执行故障切换之前检查单一区域的健康状况。

如果健康状况不佳的区域是默认主要区域，请在执行故障切换后将默认主要区域更改为故障切换区域。确认两个区域都再次健康状况良好后，执行故障恢复，然后将主要区域重新更改为原始主要区域。

如果您执行了手动故障切换，请记得手动进行故障恢复。

限制

您无法创建自定义双区域实例配置。您无法向双区域实例配置添加只读副本。

多区域配置 注意：多区域配置适用于 Spanner 企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

Spanner 单区域配置在单个区域内的多个可用区之间复制数据。不过，在以下情况下，单区域配置可能不是最佳选择：

您的应用通常需要从多个地理位置读取数据（例如，向北美洲和亚洲的用户提供数据）。

您的写入操作源自与读取操作不同的位置（例如，如果您在北美洲有大型写入工作负载，而在欧洲有大型读取工作负载）。

多区域配置可以：

处理来自多个区域的写入。

在发生区域级故障时保持可用性。

提供比单区域配置更高的可用性和 SLA。

通过多区域配置，您可以按照实例配置的定义，在多个区域中的多个可用区内复制数据库。每个多区域配置包含两个读写区域。读写区域包含两个位于不同可用区的读写副本。这些副本使您能够从靠近配置所在区域或位于该区域内的多个位置以较低的延迟时间读取数据。

不过，有得也有失，因为在多区域配置中，仲裁（读写）副本分布在多个区域中。当这些副本互相通信以组成仲裁时，您可能会注意到额外的网络延迟时间。读取不需要仲裁。这样一来，您的应用可以在更多位置实现更快的读取速度，但代价是写入延迟时间会略有增加。如需了解详情，请参阅副本在写入和读取中的作用。

可用配置

Spanner 提供以下基本多区域实例配置。如需请求下表中未列出的可选只读副本区域，请填写此请求表单。请注意，我们会根据这些请求来评估未来区域的需求，但可能不会直接回复您的提交内容。

一个大洲

基本配置名称 资源位置 读写区域 只读区域 见证者区域 可选区域

asia1 全局 东京：asia-northeast1 L，2R 大阪：asia-northeast2 2R 无 首尔：asia-northeast3 只读： us-west1 1-OR us-east5 1-OR

asia2 A 全局 孟买：asia-south1 L、2R 德里：asia-south2 2R 新加坡：asia-southeast1 1R 无 无

eur3 eu（欧盟） 比利时：europe-west1 L，2R 荷兰：europe-west4 2R 无 芬兰：europe-north1 只读： us-central1 1-OR us-east4 1-OR

eur5 全局 伦敦：europe-west2 L，2R 比利时：europe-west1 2R 无 荷兰：europe-west4 只读： us-central1 1-OR us-east1 1-OR

eur6 全局 荷兰：europe-west4 L、2R 法兰克福：europe-west3 2R 无 苏黎世：europe-west6 只读： us-east1 2-OR

eur7 eu（欧盟） 米兰：europe-west8 L、2R 法兰克福：europe-west3 2R 无 都灵：europe-west12

nam3 us（美国） 北弗吉尼亚州：us-east4 L，2R 南卡罗来纳州：us-east1 2R 无 爱荷华：us-central1 只读： us-west2 1-OR asia-southeast1 1-OR asia-southeast2 1-OR europe-west1 1-OR europe-west2 1-OR

nam6 us（美国） 爱荷华：us-central1 L，2R 南卡罗来纳州：us-east1 2R 俄勒冈：us-west1 1R 洛杉矶：us-west2 1R 俄克拉荷马：us-central2

nam7 us（美国） 爱荷华：us-central1 L,2R 北弗吉尼亚：us-east4 2R 无 俄克拉荷马：us-central2 只读： us-east1 2-OR us-south1 1-OR us-west1 1-OR europe-west1 2-OR

nam8 us（美国） 洛杉矶： us-west2 L,2R Oregon: us-west1 2R 无 盐湖城： us-west3 只读： asia-southeast1 2-OR europe-west2 2-OR us-east5 1-OR

nam9 us（美国） 北弗吉尼亚州：us-east4 L，2R 爱荷华州：us-central1 2R 俄勒冈州：us-west1 2R 南卡罗来纳：us-east1

nam10 us（美国） 爱荷华：us-central1 L，2R 盐湖城：us-west3 2R 无 俄克拉荷马：us-central2

nam11 us（美国） 爱荷华：us-central1 L，2R 南卡罗来纳州：us-east1 2R 无 俄克拉荷马：us-central2 只读： us-west1 1-OR

nam12 us（美国） 爱荷华：us-central1 L,2R 北弗吉尼亚：us-east4 2R 俄勒冈州：us-west1 2R 俄克拉荷马：us-central2

nam13 us（美国） 俄克拉荷马：us-central2 L、2R 爱荷华：us-central1 2R 无 盐湖城： us-west3

nam14 全局 北弗吉尼亚：us-east4 L、2R 蒙特利尔：northamerica-northeast1 2R 无 南卡罗来纳：us-east1

nam15 us（美国） 达拉斯：us-south1 L、2R 北弗吉尼亚：us-east4 2R 无 爱荷华：us-central1

nam16 us（美国） 爱荷华：us-central1 L,2R 北弗吉尼亚：us-east4 2R 无 哥伦布：us-east5 只读： us-west2 2-OR

三个大洲

基本配置名称 资源位置 读写区域 只读区域 见证者区域 可选区域

nam-eur-asia1 全局 爱荷华：us-central1 L，2R 俄克拉何马：us-central2 2R 比利时：europe-west1 2R 台湾：asia-east1 2R 南 卡罗来纳：us-east1 只读： us-west2 1-OR

nam-eur-asia3 全局 爱荷华：us-central1 L、2R 南卡罗来纳：us-east1 2R 比利时：europe-west1 1R 荷兰：europe-west4 1R 台湾：asia-east1 2R 俄克拉荷马：us-central2

L：默认主要区域。如需了解详情，请参阅修改数据库的主要区域。

1R：相应区域中有 1 个副本。

2R：相应区域中有 2 个副本。

2RW+1W：相应区域中有两个读写副本和一个见证者副本。

1-OR：一个可选副本。您可以创建自定义单区域实例配置，并添加一个可选只读副本。如需了解详情，请参阅创建自定义实例配置。

2-OR：最多两个可选副本。您可以创建自定义单区域实例配置，并添加一个或两个可选只读副本。我们建议添加两个（如果可能），以帮助保持较低的读取延迟时间。如需了解详情，请参阅创建自定义实例配置。

A：此实例配置受许可清单限制。如需获取访问权限，请与您的技术支持客户经理联系。

多区域实例配置的资源位置决定了针对相应配置的灾难恢复可用区保证。它定义了数据的静态存储位置。

优势

多区域实例提供了以下主要优势：

可用性达 99.999%，大于 Spanner 单区域配置所提供的 99.99% 可用性。

数据分布：Spanner 可在保证强一致性的前提下，自动在区域之间复制数据。这样您就可以将数据存储在使用位置，从而缩短延迟时间并改善用户体验。

外部一致性：虽然 Spanner 能够跨地理上相距遥远的位置进行复制，但您仍然可以像使用在单台机器上运行的数据库一样使用 Spanner。事务保证可序列化，并且数据库中的事务顺序与客户端观察所提交的事务的顺序相同。外部一致性是比其他一些产品提供的“高度一致性”更有力的保证。如需详细了解此属性，请参阅 TrueTime 和外部一致性。

复制

每个基本多区域配置包含两个指定为读写区域的区域，每个区域包含两个读写副本。其中一个读写区域被指定为“默认主要区域”，也就是说，它包含您的数据库的主要副本。Spanner 还将见证者副本放到称为见证者区域的第三个区域中。

每当客户端向您的数据库发出变更时，就会形成一个最小写票数，该最小写票数由默认主要区域中的一个副本和其他四个投票副本中的任意两个副本共同达成。（最小写票数可以由构成您的配置的两个或三个区域的副本达成，具体取决于有哪些其他副本参与了投票。）除了这五个投票副本之外，某些基本多区域配置还包含用于处理低延迟时间读取的只读副本。包含只读副本的区域称为只读区域。

通常情况下，多区域配置中的投票区域地理位置相近（相距不到一千英里），以便以低延迟达成最小写票数，从而实现快速写入（了解详情）。但是，为了避免协调故障，这些区域之间仍然保持足够远的距离（通常至少有几百英里）。 此外，如果您的客户端应用位于非主要区域，Spanner 会使用主要区域感知路由来动态路由读写事务，以缩短数据库的延迟时间。如需了解详情，请参阅主要区域感知路由。

您可以创建具有可选只读副本的自定义多区域实例配置。您创建的任何自定义只读副本都不能包含在写入仲裁中。您可以将“可选区域”列下列出的位置添加为可选只读副本。如果您没有看到所选择的只读副本位置，可以申请新的可选只读副本区域。如需了解详情，请参阅只读副本。
注意：如果您想详细了解 Spanner 中数据的复制方式以及不同类型的副本及其在读取和写入中的作用，请参阅复制。

多区域配置的性能最佳实践

为了实现最佳性能，请遵循以下最佳做法：

设计架构以防止出现热点和其他性能问题。

将写入操作频繁的工作负载的计算资源布置在默认主要区域中或其附近，以尽可能减少写入延迟时间。

使用至少 15 秒的过期设置，以使默认主要区域外的读取性能达到最佳。

将重要的计算资源放到至少两个区域中，以免您的工作负载出现单区域依赖性。 最好将它们放置在两个不同的读写区域之旁，以便任何单区域中断都不会影响您的所有应用。

预配足够的计算容量，使每个区域的高优先级 CPU 总利用率保持在 45% 以下。

如需了解每个 Spanner 节点的吞吐量，请参阅多区域配置的性能。

移动实例

您可以将 Spanner 实例从任何实例配置移至任何其他实例配置，包括单区域配置和多区域配置之间。移动实例不会导致停机，并且 Spanner 会在移动过程中继续提供常规事务保证，包括强一致性。

如需详细了解 Spanner 实例移动，请参阅移动实例。

配置默认主要区域

如需将数据库的默认主要区域的位置更改为更靠近连接客户端，以减少应用延迟时间，您可以为使用双区域或多区域配置的任何 Spanner 实例更改主要区域。如需了解如何更改主要区域的位置，请参阅更改数据库的主要区域。如要成为数据库的默认主要区域，区域必须是双区域或多区域配置中的读写区域。

主要区域负责处理所有数据库写入，因此，如果您的大部分流量来自一个地理区域，您可以将其移动到该区域以缩短延迟时间。更新默认主要区域费用很低，并且不涉及任何数据移动。新值将在几分钟后生效。
注意：如果默认主要区域发生故障或不可用，Spanner 会自动将数据库的主要副本置于实例配置的辅助读写区域中，确保高可用性且不会对应用产生任何影响。

更改默认主要区域是一种架构更改，会使用长时间运行的操作。如果需要，您可以获取长时间运行的操作的状态。

权衡：单区域配置与双区域配置与多区域配置

配置 可用性 延迟时间 费用 数据存储区域

区域
99.99%
单区域内的写入延迟时间较短。
费用较低；请参阅价格。
支持按地理位置进行数据治理。

双区域
99.999%
两个地理区域的读取延迟时间较短；写入延迟时间略有增加。
费用较高；请参阅价格。
在一个国家/地区的两个区域中分布数据。

多区域
99.999%
多个地理区域的读取延迟时间较短；写入延迟时间略有增加。
费用较高；请参阅价格。
数据分布在配置内的多个区域。

后续步骤

了解如何创建 Spanner 实例。

详细了解Google Cloud 地理位置和区域。

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
