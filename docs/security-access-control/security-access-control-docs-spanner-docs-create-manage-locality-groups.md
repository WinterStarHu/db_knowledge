# 创建和管理位置组  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-manage-locality-groups

创建和管理位置组  |  Spanner  |  Google Cloud Documentation

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

创建和管理位置组

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

注意：此功能适用于 Spanner 企业版和企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

本页介绍了如何创建和管理 Spanner 位置组。您可以使用位置组为数据库架构中的数据定义分层存储空间政策。如需了解分层存储的运作方式，请参阅分层存储。

创建存储位置组

您可以创建不包含任何分层存储空间政策的位置组，也可以创建位置组来定义数据库架构中数据的存储空间政策。

如果您创建的位置组没有分层存储空间政策，则该位置组会继承 default 位置组的分层存储空间政策。如果您尚未手动设置 default 位置组的存储空间政策，则存储空间政策会设置为仅限 SSD。

控制台

前往Google Cloud 控制台中的 Spanner 实例页面。

实例

选择要使用分层存储空间的实例。

选择要使用分层存储空间的数据库。

在导航菜单中，点击 Spanner Studio。

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 CREATE LOCALITY GROUP DDL 语句。

例如，您可以运行以下命令来创建一个位置组 separate_storage，以便将列存储在与其他列数据不同的文件中：

GoogleSQL

CREATE LOCALITY GROUP separate_storage;

PostgreSQL

CREATE LOCALITY GROUP separate_storage;

例如，您可以运行以下命令来创建一个将数据存储在 SSD 存储空间中的位置组 ssd_only：

GoogleSQL

CREATE LOCALITY GROUP ssd_only OPTIONS (storage='ssd');

PostgreSQL

CREATE LOCALITY GROUP ssd_only STORAGE 'ssd';

例如，您可以运行以下命令来创建一个将数据存储在 HDD 存储空间中的 hdd_only 位置组：

GoogleSQL

CREATE LOCALITY GROUP hdd_only OPTIONS (storage='hdd');

PostgreSQL

CREATE LOCALITY GROUP hdd_only STORAGE 'hdd';

点击运行。

gcloud 如需使用 gcloud CLI 命令创建位置组，请使用 gcloud spanner databases ddl update。

例如，您可以运行以下命令来创建一个位置组 separate_storage，以便将列存储在与其他列数据不同的文件中：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP separate_storage"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP separate_storage"

例如，您可以运行以下命令来创建一个将数据存储在 SSD 上的位置组 ssd_only：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP ssd_only OPTIONS (storage='ssd')"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP ssd_only STORAGE 'ssd'"

例如，您可以运行以下命令来创建一个将数据存储在 HDD 存储空间中的 hdd_only 位置组：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP hdd_only OPTIONS (storage='hdd')"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP hdd_only STORAGE 'hdd'"

为位置组创建基于存储时长的政策

具有基于存在时间的政策的位置组会将较新的数据存储在 SSD 存储空间中，并在指定时间内保留这些数据。此时间是相对于数据的提交时间戳而言的。在指定时间过去后，Spanner 会在正常压缩周期内将数据迁移到 HDD 存储空间，该周期通常在指定时间后的 7 天内发生。使用基于存在时长的分层存储政策时，数据必须在 SSD 中存储的最短时间（在将其移至 HDD 存储空间之前）为 1 小时。

如需创建基于存储时长的位置组，请使用 CREATE LOCALITY GROUP DDL 语句。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 CREATE LOCALITY GROUP DDL 语句。

例如，以下 DDL 语句会创建一个位置组 spill_to_hdd，该组会在前 10 天将数据存储在 SSD 存储空间中，然后在正常压缩周期内将较旧的数据迁移到 HDD 存储空间：

GoogleSQL

CREATE LOCALITY GROUP spill_to_hdd OPTIONS (storage = 'ssd', ssd_to_hdd_spill_timespan = '10d');

PostgreSQL

CREATE LOCALITY GROUP spill_to_hdd STORAGE 'ssd' SSD_TO_HDD_SPILL_TIMESPAN '10d';

点击运行。

gcloud 如需使用 gcloud CLI 命令创建基于存储时长的位置组，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会创建一个位置组 spill_to_hdd，该组会在前 10 天将数据存储在 SSD 中，然后在正常压缩周期内将较旧的数据迁移到 HDD。

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP spill_to_hdd OPTIONS (storage='ssd', ssd_to_hdd_spill_timespan='10d')"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE LOCALITY GROUP spill_to_hdd STORAGE 'ssd' SSD_TO_HDD_SPILL_TIMESPAN '10d'"

为数据设置分层存储空间政策

创建位置组后，您可以为数据设置分层存储空间政策。分层存储空间政策决定了数据使用的位置组。您可以在数据库、表、列或二级索引级别设置分层存储空间政策。除非明确替换，否则每个数据库对象都会从其父级继承分层存储空间政策。

如果您创建的位置组没有分层存储空间政策，则该位置组会继承 default 位置组的分层存储空间政策。如果您尚未手动设置 default 位置组的存储空间政策，则存储空间政策会设置为仅限 SSD。

设置数据库级位置组

默认的分层存储空间政策是将所有数据存储在 SSD 存储空间中。您可以通过更改 default 位置组来更改数据库级分层存储空间政策。对于 GoogleSQL 方言数据库，您的 ALTER LOCALITY GROUP DDL 语句必须在反引号 (`default`) 内包含 default。您只需为 default 位置组添加反引号。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 ALTER LOCALITY GROUP DDL 语句。

例如，以下 DDL 语句会更改 default 位置组以使用基于存储时长的存储空间分层政策。数据库中的所有数据会在 10 天后移至 HDD 存储空间。

GoogleSQL

ALTER LOCALITY GROUP `default` SET OPTIONS (storage = 'ssd', ssd_to_hdd_spill_timespan = '10d');

PostgreSQL

ALTER LOCALITY GROUP "default" STORAGE 'ssd' SSD_TO_HDD_SPILL_TIMESPAN '10d';

点击运行。

gcloud 如需使用 gcloud CLI 命令更改 default 位置组的分层存储空间政策，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会更改 default 位置组以使用基于存储时长的存储空间分层政策。数据库中的所有数据在 10 天后会移至 HDD 存储空间。

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP \`default\` SET OPTIONS (storage = 'ssd', ssd_to_hdd_spill_timespan = '10d');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP \"default\" STORAGE 'ssd' SSD_TO_HDD_SPILL_TIMESPAN '10d';"

设置表级位置组

您可以为数据设置表级分层存储空间政策，以替换数据库级分层存储空间政策。除非您设置了列级替换分层存储空间政策，否则表级分层存储空间政策也适用于表中的所有列。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 CREATE TABLE DDL 语句。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的表 Singers：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX) ) PRIMARY KEY (SingerId), OPTIONS (locality_group = 'ssd_only');

PostgreSQL

CREATE TABLE Singers ( SingerId   bigint PRIMARY KEY, FirstName  varchar(1024), LastName   varchar(1024), SingerInfo bytea ) LOCALITY GROUP ssd_only;

点击运行。

gcloud 如需使用 gcloud CLI 命令设置表级分层存储空间政策，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的表 Singers。

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Singers ( SingerId   INT64 NOT NULL, \ FirstName  STRING(1024), \ LastName   STRING(1024), \ SingerInfo BYTES(MAX) \ ) PRIMARY KEY (SingerId), OPTIONS (locality_group = 'ssd_only');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Singers ( \ SingerId bigint PRIMARY KEY, \ FirstName  varchar(1024), \ LastName   varchar(1024), \ SingerInfo bytea \ ) LOCALITY GROUP ssd_only;"

设置列级替换分层存储空间政策

您可以为数据设置列级别的替换分层存储空间政策。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入带有列级替换分层存储空间政策的 CREATE TABLE DDL 语句。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的 Singers 表。不过，Awards 列会替换此表级位置组，并使用 spill_to_hdd 位置组作为分层存储空间政策：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), Awards     ARRAY OPTIONS (locality_group = 'spill_to_hdd') ) PRIMARY KEY (SingerId), OPTIONS (locality_group = 'ssd_only');

PostgreSQL

CREATE TABLE Singers ( SingerId   bigint PRIMARY KEY, FirstName  varchar(1024), LastName   varchar(1024), Awards     varchar[] LOCALITY GROUP spill_to_hdd ) LOCALITY GROUP ssd_only;

点击运行。

gcloud 如需使用 gcloud CLI 命令设置列级替换分层存储空间政策，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的 Singers 表。不过，Awards 列会替换此表级分层存储空间政策，并使用 spill_to_hdd 位置组作为其分层存储空间政策：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Singers ( \ SingerId   INT64 NOT NULL, \ FirstName  STRING(1024), \ LastName   STRING(1024), \ Awards     ARRAY OPTIONS (locality_group = 'spill_to_hdd') \ ) PRIMARY KEY (SingerId), OPTIONS (locality_group = 'ssd_only');" \

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Singers ( \ SingerId   bigint PRIMARY KEY, \ FirstName  varchar(1024), \ LastName   varchar(1024), \ Awards     varchar[] LOCALITY GROUP spill_to_hdd \ ) LOCALITY GROUP ssd_only;"

设置二级索引级替换分层存储空间政策

您可以为数据设置二级索引级别的替换分层存储空间政策。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL，输入带有二级索引级别替换分层存储空间政策的 CREATE INDEX DDL 语句。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的 Singers 表。数据库还会按名字和姓氏为数据库中的所有 Singers 创建二级索引。SingersByFirstLastName 索引会替换表级分层存储空间政策，并使用 spill_to_hdd 位置组作为其分层存储空间政策：

GoogleSQL

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName) OPTIONS (locality_group = 'spill_to_hdd');

PostgreSQL

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName) LOCALITY GROUP spill_to_hdd;

点击运行。

gcloud 如需使用 gcloud CLI 命令设置二级索引级别的替换分层存储空间政策，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会创建一个使用位置组 ssd_only 的 Singers 表。数据库还会按名字和姓氏为数据库中的所有 Singers 创建二级索引。SingersByFirstLastName 索引会替换表级分层存储空间政策，并使用 spill_to_hdd 位置组作为其分层存储空间政策：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName) \ OPTIONS (locality_group = 'spill_to_hdd');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName) \ LOCALITY GROUP spill_to_hdd;"

设置列级位置组

您可以为数据设置列级别的位置组，即使该位置组没有分层存储空间政策也是如此。从此列读取数据比读取与其他列分组的数据更快。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

输入 CREATE TABLE DDL 语句，该语句会使用 GoogleSQL 或 PostgreSQL 将列分配到一个位置组。

例如，以下 DDL 语句会创建一个 Songs 表，其中包含一个在 hdd_only 位置组中单独存储的 LyricsCompressed 列：

GoogleSQL

CREATE TABLE Songs ( SingerId INT64 NOT NULL, SongId INT64 NOT NULL, Title STRING(MAX), Description STRING(MAX), LyricsCompressed BYTES(MAX) OPTIONS (locality_group = 'hdd_only') ) PRIMARY KEY (SingerId, SongId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE, OPTIONS (locality_group = 'ssd_only');

PostgreSQL

CREATE TABLE Songs ( SingerId BIGINT NOT NULL, SongId BIGINT NOT NULL, Title VARCHAR, Description TEXT, LyricsCompressed BYTEA LOCALITY GROUP hdd_only, PRIMARY KEY (SingerId, SongId) ) LOCALITY GROUP ssd_only INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

点击运行。

gcloud 如需使用 gcloud CLI 命令为数据设置列级别的位置组，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会创建一个 Songs 表，其中包含一个在 hdd_only 位置组中单独存储的 LyricsCompressed 列：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Songs ( \ SingerId INT64 NOT NULL, \ SongId INT64 NOT NULL, \ Title STRING(MAX), \ Description STRING(MAX), LyricsCompressed BYTES(MAX) OPTIONS (locality_group = 'hdd_only') \ ) PRIMARY KEY (SingerId, SongId), \ INTERLEAVE IN PARENT Singers ON DELETE CASCADE, \ OPTIONS (locality_group = 'ssd_only');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="CREATE TABLE Songs ( \ SingerId BIGINT NOT NULL, \ SongId BIGINT NOT NULL, \ Title VARCHAR, \ Description TEXT, \ LyricsCompressed BYTEA LOCALITY GROUP hdd_only, \ PRIMARY KEY (SingerId, SongId) \ ) LOCALITY GROUP ssd_only INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

在存储空间选项之间移动数据

您可以在 SSD 存储空间和 HDD 存储空间之间移动数据。数据迁移最多可能需要 7 天。您可以通过查询内置的 SPANNER_SYS.TABLE_SIZES_STATS_1HOUR 表来监控迁移进度，以检查数据库中每个表的 HDD 和 SSD 存储空间用量。您还可以使用 Cloud Monitoring spanner.googleapis.com/instance/storage/used_bytes 指标来监控存储空间用量，以显示数据库或实例的 SSD 和 HDD 细分数据。如需了解详情，请参阅分层存储可观测性。

将数据从 SSD 移动到 HDD 存储空间

如需将数据从 SSD 移动到 HDD 存储空间，您可以使用基于存储时长的分层存储空间政策创建新的位置组，也可以更改现有位置组的分层存储空间政策。Spanner 会在正常压缩周期内移动数据，该周期通常持续 7 天。如果您使用以下 ALTER DDL 语句之一加载数据并更新存放区域组，则必须等待最多 7 天，以便完成对存放区域组的更改：

GoogleSQL

ALTER TABLE ... SET OPTIONS (locality_group = '')

ALTER TABLE ... ALTER COLUMN ... SET OPTIONS (locality_group = '')

ALTER INDEX ... SET OPTIONS (locality_group = '')

PostgreSQL

ALTER TABLE ... SET LOCALITY GROUP ...

ALTER TABLE ... ALTER COLUMN ... SET LOCALITY GROUP ...

ALTER INDEX ... SET LOCALITY GROUP ...

如果您要创建新表、列或索引，并在 CREATE 或 ADD COLUMN 语法中添加存放区域组，则等候期不适用。

如需了解详情，请参阅为存放区域组创建基于存在时长的政策或更改存储空间选项。

将数据从 HDD 移动到 SSD 存储空间

如需将数据从 HDD 移动到 SSD 存储空间，您可以更改现有位置组的存储选项，或更改表所用的位置组。Spanner 会在正常压缩周期内移动数据，该周期通常持续 7 天。如果您使用以下 ALTER DDL 语句之一加载数据并更新存放区域组，则必须等待最多 7 天，以便完成对存放区域组的更改：

GoogleSQL

ALTER TABLE ... SET OPTIONS (locality_group = '')

ALTER TABLE ... ALTER COLUMN ... SET OPTIONS (locality_group = '')

ALTER INDEX ... SET OPTIONS (locality_group = '')

PostgreSQL

ALTER TABLE ... SET LOCALITY GROUP ...

ALTER TABLE ... ALTER COLUMN ... SET LOCALITY GROUP ...

ALTER INDEX ... SET LOCALITY GROUP ...

如果您要创建新表、列或索引，并在 CREATE 或 ADD COLUMN 语法中添加存放区域组，则等候期不适用。

更改表所使用的位置组

您可以在表选项中设置新的或不同的位置组，从而更改表所使用的位置组。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 ALTER TABLE DDL 语句，以更改表所用的位置组。

例如，以下 DDL 语句会将表 Singers 使用的位置组更改为 spill_to_hdd：

GoogleSQL

ALTER TABLE Singers SET OPTIONS (locality_group = 'spill_to_hdd');

PostgreSQL

ALTER TABLE Singers SET LOCALITY GROUP spill_to_hdd;

点击运行。

gcloud 如需使用 gcloud CLI 命令更改表所使用的位置组，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会将表 Singers 使用的位置组更改为 spill_to_hdd：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER TABLE Singers SET OPTIONS(locality_group = 'spill_to_hdd');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER TABLE Singers SET LOCALITY GROUP spill_to_hdd;"

更改表列所用的位置组

您可以通过在列选项中设置位置组来更改表列所使用的位置组。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 ALTER TABLE DDL 语句，以更改表所用的位置组。

例如，以下 DDL 语句会将表的列 LastName 使用的位置组更改为 spill_to_hdd：

GoogleSQL

ALTER TABLE Singers ALTER COLUMN LastName SET OPTIONS(locality_group = 'spill_to_hdd');

PostgreSQL

ALTER TABLE Singers ALTER COLUMN LastName SET LOCALITY GROUP spill_to_hdd;

点击运行。

gcloud 如需使用 gcloud CLI 命令更改表所使用的位置组，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会将表的列 LastName 使用的位置组更改为 spill_to_hdd：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER TABLE Singers ALTER COLUMN LastName SET OPTIONS(locality_group = 'spill_to_hdd');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER TABLE Singers ALTER COLUMN SET LOCALITY GROUP spill_to_hdd;"

更改位置组

您可以通过更改其存储选项或更改其基于存储时长的政策来更改位置组。
Spanner 会在正常压缩周期内移动数据，该周期通常持续 7 天。如果您使用 ALTER LOCALITY GROUP 加载数据并更新存放区域组，则必须等待最多 7 天，以便迁移现有数据。更新后的设置会立即应用于向相应存放区域组写入的所有新数据。

更改存储空间选项

您可以将某个位置组的存储空间选项从 SSD 更改为 HDD，或者从 HDD 更改为 SSD。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 ALTER LOCALITY GROUP DDL 语句。

例如，以下 DDL 语句会将 separate_storage 的存储选项更改为 HDD：

GoogleSQL

ALTER LOCALITY GROUP separate_storage SET OPTIONS (storage='hdd');

PostgreSQL

ALTER LOCALITY GROUP separate_storage STORAGE 'hdd';

点击运行。

gcloud 如需使用 gcloud CLI 命令更改位置组的存储选项，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会将 separate_storage 的存储选项更改为 HDD：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP separate_storage SET OPTIONS (storage = 'hdd');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP separate_storage STORAGE 'hdd';"

更改基于存储时长的政策

您可以通过延长或缩短数据在 SSD 中存储的时间（在数据被移至 HDD 存储空间之前）来更改位置组的基于存储时长的政策。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 ALTER LOCALITY GROUP DDL 语句。

例如，以下 DDL 语句会更改位置组 spill_to_hdd 的基于存储时长的政策，将数据在 SSD 中存储的时间延长至 20 天：

GoogleSQL

ALTER LOCALITY GROUP spill_to_hdd SET OPTIONS (ssd_to_hdd_spill_timespan = '20d');

PostgreSQL

ALTER LOCALITY GROUP spill_to_hdd SSD_TO_HDD_SPILL_TIMESPAN '20d';

点击运行。

gcloud 如需使用 gcloud CLI 命令更改位置组的基于存储时长的政策，请使用 gcloud spanner databases ddl update。

例如，以下 DDL 语句会更改位置组 spill_to_hdd 的基于存储时长的政策，将数据在 SSD 中存储的时间延长至 20 天：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP spill_to_hdd SET OPTIONS (ssd_to_hdd_spill_timespan = '20d');"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="ALTER LOCALITY GROUP spill_to_hdd SSD_TO_HDD_SPILL_TIMESPAN '20d';"

删除位置组

如果某个位置组包含数据，则无法将其删除。您必须先将该级别组中的所有数据移至其他级别组。如需了解详情，请参阅更改表所用的位置组。

控制台

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

使用 GoogleSQL 或 PostgreSQL 输入 DROP LOCALITY GROUP DDL 语句。

例如，您可以运行以下命令以删除位置组 ssd_only：

GoogleSQL

DROP LOCALITY GROUP ssd_only;

PostgreSQL

DROP LOCALITY GROUP ssd_only;

点击运行。

gcloud 如需使用 gcloud CLI 命令删除位置组，请使用 gcloud spanner databases ddl update。

例如，如要删除 ssd_only 位置组，请运行以下命令：

GoogleSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="DROP LOCALITY GROUP ssd_only"

PostgreSQL

gcloud spanner databases ddl update example-db \ --instance=test-instance \ --ddl="DROP LOCALITY GROUP ssd_only"

后续步骤

详细了解分层存储。

详细了解位置组。

详细了解如何使用时间戳谓词下推优化查询。

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
