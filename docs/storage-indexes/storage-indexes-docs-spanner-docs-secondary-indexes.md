# 二级索引  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/secondary-indexes

二级索引  |  Spanner  |  Google Cloud Documentation

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

二级索引

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

在 Spanner 数据库中，Spanner 会自动为每个表的主键创建索引。例如，您无需执行任何操作即可为 Singers 的主键编制索引，因为系统会自动为您编制索引。

除此之外，您可以针对非主键列创建“二级索引”。针对非主键列添加二级索引有助于更高效地查找此类列中的数据。例如，如果您需要按标题快速查找专辑，则应对 AlbumTitle 创建二级索引，这样 Spanner 便无需扫描整个表。

如果上述示例中的查找在读写事务中完成，则更高效的查找还可以避免对整个表保持锁定，从而允许针对 AlbumTitle 查找范围以外的行对表进行并发插入和更新。

除了为查询带来的优势之外，二级索引还可以帮助 Spanner 更高效地执行扫描，从而启用索引扫描而不是全表扫描。

Spanner 会将以下数据存储在各个二级索引中：

基表中的所有键列

索引中包含的所有列

索引定义的可选 STORING 子句（GoogleSQL 方言数据库）或 INCLUDE 子句（PostgreSQL 方言数据库）中指定的所有列。

随着时间的推移，Spanner 会逐步分析您的表，以确保为适合的查询使用二级索引。

添加二级索引

在创建表时添加二级索引最为高效。要同时创建表及其索引，请在一个请求中将添加新表和添加新索引的 DDL 语句一并发送到 Spanner。

在 Spanner 中，您还可以向现有表添加新的二级索引，添加过程中数据库可继续处理流量。与 Spanner 中的其他所有架构更改一样，向现有数据库添加索引不需要使数据库离线，也不会锁定整个列或表。

每当新索引添加到现有表时，Spanner 就会自动回填或填充索引，以反映被编入索引的数据的最新视图。Spanner 会为您管理此回填过程，该过程会以低优先级使用节点资源在后台运行。索引回填速度会适应在创建索引期间不断变化的节点资源，并且回填不会显著影响数据库的性能。

创建索引可能需要几分钟到数小时才能完成。由于创建索引属于架构更新，因此须遵循与其他架构更新一样的性能限制。创建二级索引所需的时间取决于以下几个因素：

数据集的大小

实例的计算容量

实例上的负载

如需查看索引回填流程的进度，请参阅进度部分。

请注意，将提交时间戳列用作二级索引的第一部分可能会引发热点，并降低写入性能。注意：如果要向数据库添加大量二级索引，请在创建索引时，遵循大型架构更新指南操作。

使用 CREATE INDEX 语句在您的架构中定义二级索引。下面是一些示例：

要按名字和姓氏将数据库中的所有 Singers 编入索引，请使用以下语句：

GoogleSQL

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName);

PostgreSQL

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName);

要按照 SongName 的值为数据库中的所有 Songs 创建索引，请使用以下语句：

GoogleSQL

CREATE INDEX SongsBySongName ON Songs(SongName);

PostgreSQL

CREATE INDEX SongsBySongName ON Songs(SongName);

要仅将特定歌手的歌曲编入索引，请使用 INTERLEAVE IN 子句在表 Singers 中交错索引：

GoogleSQL

CREATE INDEX SongsBySingerSongName ON Songs(SingerId, SongName), INTERLEAVE IN Singers;

PostgreSQL

CREATE INDEX SongsBySingerSongName ON Songs(SingerId, SongName) INTERLEAVE IN Singers;

要仅将特定专辑中的歌曲编入索引，请使用以下语句：

GoogleSQL

CREATE INDEX SongsBySingerAlbumSongName ON Songs(SingerId, AlbumId, SongName), INTERLEAVE IN Albums;

PostgreSQL

CREATE INDEX SongsBySingerAlbumSongName ON Songs(SingerId, AlbumId, SongName) INTERLEAVE IN Albums;

要按照 SongName 的降序顺序编制索引，请使用以下语句：

GoogleSQL

CREATE INDEX SongsBySingerAlbumSongNameDesc ON Songs(SingerId, AlbumId, SongName DESC), INTERLEAVE IN Albums;

PostgreSQL

CREATE INDEX SongsBySingerAlbumSongNameDesc ON Songs(SingerId, AlbumId, SongName DESC) INTERLEAVE IN Albums;

请注意，上面的 DESC 注解仅适用于 SongName。要按其他索引键的降序顺序编制索引，请同样为这些索引键添加注释 DESC，例如：SingerId DESC, AlbumId DESC。

另请注意，PRIMARY_KEY 是保留字，不能用作索引的名称。它是伪索引的名称，是在创建具有 PRIMARY KEY 规范的表时创建的

有关选择非交错索引和交错索引的详细信息和最佳做法，请参阅索引选项和在其值单调递增或递减的列上使用交错索引。

索引和交织

Spanner 索引可以与其他表交织，以便将索引行与其他表中的行放置在一起。与 Spanner 表交织类似，索引父项的主键列必须是索引列的前缀，并且在类型和排序顺序上相匹配。与交织表不同，列名称匹配不是必需的。交织索引的每一行都会与关联的父行一起存储。

例如，请考虑以下架构：

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo PROTO(MAX) ) PRIMARY KEY (SingerId);

CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX), PublisherId  INT64 NOT NULL ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

CREATE TABLE Songs ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, TrackId      INT64 NOT NULL, PublisherId  INT64 NOT NULL, SongName     STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId, TrackId), INTERLEAVE IN PARENT Albums ON DELETE CASCADE;

CREATE TABLE Publishers ( Id            INT64 NOT NULL, PublisherName STRING(MAX) ) PRIMARY KEY (Id);

如需按名字和姓氏将数据库中的所有 Singers 编入索引，您必须创建索引。以下演示了如何定义索引 SingersByFirstLastName：

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName);

如果您想对 (SingerId, AlbumId, SongName) 创建 Songs 索引，可以执行以下操作：

CREATE INDEX SongsBySingerAlbumSongName ON Songs(SingerId, AlbumId, SongName);

或者，您可以创建一个与 Songs 的祖先交织的索引，如下所示：

CREATE INDEX SongsBySingerAlbumSongName ON Songs(SingerId, AlbumId, SongName), INTERLEAVE IN Albums;

此外，您还可以在 (PublisherId, SingerId, AlbumId, SongName) 上创建 Songs 索引，该索引与非 Songs 祖先的表（如 Publishers）交织。请注意，Publishers 表的主键 (id) 不是以下示例中编入索引的列的前缀。这种情况仍然是允许的，因为 Publishers.Id 和 Songs.PublisherId 具有相同的类型、排序顺序以及可为 null 性。

CREATE INDEX SongsByPublisherSingerAlbumSongName ON Songs(PublisherId, SingerId, AlbumId, SongName), INTERLEAVE IN Publishers;

检查索引回填进度

控制台

在 Spanner 导航菜单中，点击操作标签页。操作页面会显示正在运行的操作的列表。

在列表中找到回填操作。如果任务仍在运行，结束时间列中的进度指示器会显示操作已完成的百分比，如下图所示：

gcloud 使用 gcloud spanner operations describe 检查操作的进度。

获取操作 ID：

gcloud spanner operations list --instance=INSTANCE-NAME \ --database=DATABASE-NAME --type=DATABASE_UPDATE_DDL

替换以下内容：

将 INSTANCE-NAME 替换为 Spanner 实例名称。

将 DATABASE-NAME 替换为数据库的名称。

使用说明：

要限制列表，请指定 --filter 标志。例如：

--filter="metadata.name:example-db" 仅列出对特定数据库的操作。

--filter="error:*" 仅列出失败的备份操作。

如需了解过滤条件语法，请参阅 gcloud topic filters。如需了解如何过滤备份操作，请参阅 ListBackupOperationsRequest 中的 filter 字段。

--type 标志不区分大小写。

输出类似于以下内容：

OPERATION_ID     STATEMENTS                                                                                          DONE   @TYPE _auto_op_123456  CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName)                                 False  UpdateDatabaseDdlMetadata CREATE INDEX SongsBySingerAlbumSongName ON Songs(SingerId, AlbumId, SongName), INTERLEAVE IN Albums _auto_op_234567                                                                                                      True   CreateDatabaseMetadata

运行 gcloud spanner operations describe：

gcloud spanner operations describe \ --instance=INSTANCE-NAME \ --database=DATABASE-NAME \ projects/PROJECT-NAME/instances/INSTANCE-NAME/databases/DATABASE-NAME/operations/OPERATION_ID

替换以下内容：

INSTANCE-NAME：Spanner 实例名称。

DATABASE-NAME：Spanner 数据库名称。

PROJECT-NAME：项目名称。

OPERATION-ID：要检查的操作的 ID。

输出中的 progress 部分显示操作的完成百分比。输出类似于以下内容：

done: true ...
progress:
  - endTime: '2021-01-22T21:58:42.912540Z'
progressPercent: 100 startTime: '2021-01-22T21:58:11.053996Z'
  - progressPercent: 67
startTime: '2021-01-22T21:58:11.053996Z' ...

REST v1 获取操作 ID：

gcloud spanner operations list --instance=INSTANCE-NAME

--database=DATABASE-NAME --type=DATABASE_UPDATE_DDL

替换以下内容：

将 INSTANCE-NAME 替换为 Spanner 实例名称。

将 DATABASE-NAME 替换为数据库的名称。

在使用任何请求数据之前，请先进行以下替换：

PROJECT-ID：项目 ID。

INSTANCE-ID：实例 ID。

DATABASE-ID：数据库 ID。

OPERATION-ID：操作 ID。

HTTP 方法和网址：

GET https://spanner.googleapis.com/v1/projects/PROJECT-ID/instances/INSTANCE-ID/databases/DATABASE-ID/operations/OPERATION-ID

如需发送您的请求，请展开以下选项之一：

curl（Linux、macOS 或 Cloud Shell）

注意：以下命令假定您已使用您的用户账号通过运行 gcloud init 或 gcloud auth login 登录 gcloud CLI，或者使用了 Cloud Shell，这会使您自动登录 gcloud CLI。您可以运行 gcloud auth list 来检查当前活跃的账号。

执行以下命令：

curl -X GET \ -H "Authorization: Bearer $(gcloud auth print-access-token)" \ "https://spanner.googleapis.com/v1/projects/PROJECT-ID/instances/INSTANCE-ID/databases/DATABASE-ID/operations/OPERATION-ID"

PowerShell (Windows)

注意：以下命令假定您已使用您的用户账号通过运行 gcloud init 或 gcloud auth login 登录 gcloud CLI。您可以运行 gcloud auth list 来检查当前活跃的账号。

执行以下命令：

$cred = gcloud auth print-access-token $headers = @{ "Authorization" = "Bearer $cred" }

Invoke-WebRequest ` -Method GET ` -Headers $headers ` -Uri "https://spanner.googleapis.com/v1/projects/PROJECT-ID/instances/INSTANCE-ID/databases/DATABASE-ID/operations/OPERATION-ID" | Select-Object -Expand Content

您应该收到类似以下内容的 JSON 响应：

{ ...
"progress": [ { "progressPercent": 100, "startTime": "2023-05-27T00:52:27.366688Z", "endTime": "2023-05-27T00:52:30.184845Z" }, { "progressPercent": 100, "startTime": "2023-05-27T00:52:30.184845Z", "endTime": "2023-05-27T00:52:40.750959Z" } ], ...
"done": true, "response": { "@type": "type.googleapis.com/google.protobuf.Empty" } }

对于 gcloud 和 REST，您可以在 progress 部分中找到每个索引回填语句的进度。对于语句数组中的每个语句，进度数组都有一个对应的字段。此进度数组顺序与语句数组的顺序对应。成为可用状态后，系统会相应地填充 startTime、progressPercent 和 endTime 字段。请注意，输出内容不会显示回填进度完成的预计时间。

如果操作花费的时间过长，您可以取消它。如需了解详情，请参阅取消索引创建。

查看索引回填进度时的场景

在尝试检查索引回填的进度时，您可能会遇到不同的场景。需要索引回填的索引创建语句是架构更新操作的一部分，并且架构更新操作中可能有多个语句。

第一个场景最简单，即索引创建语句是架构更新操作中的第一个语句。因为索引创建语句是第一个语句，所以根据执行顺序，它是第一个处理和执行的语句。索引创建语句的 startTime 字段将立即使用架构更新操作的开始时间进行填充。接下来，当索引回填的进度超过 0% 时，系统会填充索引创建语句的 progressPercent 字段。最后，在提交语句后，系统会填充 endTime 字段。

第二个场景是，索引创建语句不是架构更新操作中的第一个语句。由于执行顺序，在提交上一个语句之前，不会填充与索引创建语句相关的字段。与上一个场景类似，提交前面的语句后，系统会先填充索引创建语句的 startTime 字段，然后填充 progressPercent 字段。最后，一旦语句提交完成，系统会填充 endTime 字段。

取消索引创建

您可以使用 Google Cloud CLI 取消索引创建操作。要检索 Spanner 数据库的一系列架构更新操作，请使用 gcloud spanner operations list 命令，并添加 --filter 选项：

gcloud spanner operations list \ --instance=INSTANCE \ --database=DATABASE \ --filter="@TYPE:UpdateDatabaseDdlMetadata"

找到要取消操作的 OPERATION_ID，然后使用 gcloud spanner operations cancel 命令将其取消：

gcloud spanner operations cancel OPERATION_ID \ --instance=INSTANCE \ --database=DATABASE 注意：如果您取消创建多个索引的正在进行的操作，系统只会取消尚未创建的索引。已创建的索引不会因取消操作而被删除。

查看现有索引

如需查看数据库中现有索引的相关信息，您可以使用Google Cloud 控制台或 Google Cloud CLI：

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要查看的实例的名称。

在左侧窗格中，点击要查看的数据库，然后点击要查看的表。

点击索引标签页。 Google Cloud 控制台会显示索引列表。

可选：要获取有关索引的详细信息（例如其中包含的列），请点击相应索引的名称。

gcloud 使用 gcloud spanner databases ddl describe 命令：

gcloud spanner databases ddl describe DATABASE \ --instance=INSTANCE

gcloud CLI 可输出数据定义语言 (DDL) 语句来创建数据库的表和索引。CREATE INDEX 语句描述了现有索引。例如：

--- |-
CREATE TABLE Singers ( SingerId INT64 NOT NULL, FirstName STRING(1024), LastName STRING(1024), SingerInfo BYTES(MAX), ) PRIMARY KEY(SingerId)
---
CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName)

使用特定索引进行查询

以下部分介绍了如何在 SQL 语句中指定索引以及如何使用 Spanner 的读取接口指定索引。这些部分中的示例假定您向 Albums 表添加了 MarketingBudget 列并创建了名为 AlbumsByAlbumTitle 的索引：

GoogleSQL

CREATE TABLE Albums ( SingerId         INT64 NOT NULL, AlbumId          INT64 NOT NULL, AlbumTitle       STRING(MAX), MarketingBudget  INT64, ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle);

PostgreSQL

CREATE TABLE Albums ( SingerId         BIGINT NOT NULL, AlbumId          BIGINT NOT NULL, AlbumTitle       VARCHAR, MarketingBudget  BIGINT, PRIMARY KEY (SingerId, AlbumId) ) INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle);

在 SQL 语句中指定索引

在您使用 SQL 来查询 Spanner 表时，Spanner 会自动使用任何有可能提高查询效率的索引。因此，您不需要为 SQL 查询指定索引。但是，对于工作负载至关重要的查询，Google 建议您在 SQL 语句中使用 FORCE_INDEX 指令以实现更一致的性能。
注意：对数据库的数据或架构进行重大更改后，构建新的统计信息软件包可以改进查询优化器的自动索引选择。

在少数情况下，Spanner 可能会选择让查询延迟时间增加的索引。如果您已按照性能回归问题排查步骤进行操作，并确认有必要为查询尝试其他索引，则可以在查询中指定索引。

如需在 SQL 语句中指定索引，请使用 FORCE_INDEX 提示来提供“索引指令”。索引指令使用以下语法：

GoogleSQL

FROM MyTable@{FORCE_INDEX=MyTableIndex}

PostgreSQL

FROM MyTable /*@ FORCE_INDEX = MyTableIndex */

您还可以使用索引指令来指示 Spanner 扫描基表（而不是使用索引）：

GoogleSQL

FROM MyTable@{FORCE_INDEX=_BASE_TABLE}

PostgreSQL

FROM MyTable /*@ FORCE_INDEX = _BASE_TABLE */

您可以使用索引指令来指示 Spanner 扫描具有命名架构的表中的索引：

GoogleSQL

FROM NAMED_SCHEMA_NAME.TABLE_NAME@{FORCE_INDEX="NAMED_SCHEMA_NAME.TABLE_INDEX_NAME"}

PostgreSQL

FROM NAMED_SCHEMA_NAME.TABLE_NAME /*@ FORCE_INDEX = TABLE_INDEX_NAME */

以下示例演示了指定索引的 SQL 查询：

GoogleSQL

SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} WHERE AlbumTitle >= "Aardvark" AND AlbumTitle < "Goo";

PostgreSQL

SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums /*@ FORCE_INDEX = AlbumsByAlbumTitle */ WHERE AlbumTitle >= 'Aardvark' AND AlbumTitle < 'Goo';

索引指令可能会强制 Spanner 的查询处理器读取查询需要但未存储在索引中的其他列。查询处理器通过联接索引和基表来检索这些列。如需避免这种额外的联接，请使用 STORING 子句（GoogleSQL 方言数据库）或 INCLUDE 子句（PostgreSQL 方言数据库）将其他列存储在索引中。

在上面的示例中，MarketingBudget 列未存储在索引中，但 SQL 查询会选择此列。因此，Spanner 必须在基表中查找 MarketingBudget 列，然后将其与索引中的数据联接，以返回查询结果。

如果索引指令存在以下任何问题，则 Spanner 将发生错误：

索引不存在。

索引位于不同的基表上。

查询缺少 NULL_FILTERED 索引必需的 NULL 过滤表达式。

下面的示例演示了如何编写和执行查询，以使用索引 AlbumsByAlbumTitle 提取 AlbumId、AlbumTitle 和 MarketingBudget 的值：

C++

void QueryUsingIndex(google::cloud::spanner::Client client) { namespace spanner = ::google::cloud::spanner;

spanner::SqlStatement select( "SELECT AlbumId, AlbumTitle, MarketingBudget" " FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle}" " WHERE AlbumTitle >= @start_title AND AlbumTitle < @end_title", {{"start_title", spanner::Value("Aardvark")}, {"end_title", spanner::Value("Goo")}});
using RowType = std::tuple>;
auto rows = client.ExecuteQuery(std::move(select));
for (auto& row : spanner::StreamOf(rows)) { if (!row) throw std::move(row).status();
std::cout (*row) << "\t";
std::cout (*row) << "\t";
auto marketing_budget = std::get(*row);
if (marketing_budget) { std::cout << "MarketingBudget: " << *marketing_budget << "\n";
} else { std::cout << "MarketingBudget: NULL\n";
} } std::cout << "Read completed for [spanner_query_data_with_index]\n";
}

C#

using Google.Cloud.Spanner.Data;
using System.Collections.Generic;
using System.Threading.Tasks;

public class QueryDataWithIndexAsyncSample { public class Album { public int AlbumId { get; set; } public string AlbumTitle { get; set; } public long MarketingBudget { get; set; } }

public async Task> QueryDataWithIndexAsync(string projectId, string instanceId, string databaseId, string startTitle, string endTitle) { string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
using var cmd = connection.CreateSelectCommand( "SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@ " + "{FORCE_INDEX=AlbumsByAlbumTitle} " + $"WHERE AlbumTitle >= @startTitle " + $"AND AlbumTitle < @endTitle", new SpannerParameterCollection { { "startTitle", SpannerDbType.String, startTitle }, { "endTitle", SpannerDbType.String, endTitle } });

var albums = new List();
using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync()) { albums.Add(new Album { AlbumId = reader.GetFieldValue("AlbumId"), AlbumTitle = reader.GetFieldValue("AlbumTitle"), MarketingBudget = reader.IsDBNull(reader.GetOrdinal("MarketingBudget")) ? 0 : reader.GetFieldValue("MarketingBudget") });
} return albums;
} }

Go

import (
"context" "fmt" "io" "strconv"

"cloud.google.com/go/spanner" "google.golang.org/api/iterator" )

func queryUsingIndex(w io.Writer, db string) error { ctx := context.Background() client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

stmt := spanner.Statement{ SQL: `SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} WHERE AlbumTitle >= @start_title AND AlbumTitle < @end_title`, Params: map[string]interface{}{ "start_title": "Aardvark", "end_title":   "Goo", }, } iter := client.Single().Query(ctx, stmt) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } var albumID int64 var marketingBudget spanner.NullInt64 var albumTitle string if err := row.ColumnByName("AlbumId", &albumID); err != nil { return err } if err := row.ColumnByName("AlbumTitle", &albumTitle); err != nil { return err } if err := row.ColumnByName("MarketingBudget", &marketingBudget); err != nil { return err } budget := "NULL" if marketingBudget.Valid { budget = strconv.FormatInt(marketingBudget.Int64, 10) } fmt.Fprintf(w, "%d %s %s\n", albumID, albumTitle, budget) } return nil }

Java

static void queryUsingIndex(DatabaseClient dbClient) { Statement statement = Statement // We use FORCE_INDEX hint to specify which index to use. For more details see // https://cloud.google.com/spanner/docs/query-syntax#from-clause .newBuilder( "SELECT AlbumId, AlbumTitle, MarketingBudget " + "FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} " + "WHERE AlbumTitle >= @StartTitle AND AlbumTitle < @EndTitle") // We use @BoundParameters to help speed up frequently executed queries.
//  For more details see https://cloud.google.com/spanner/docs/sql-best-practices .bind("StartTitle") .to("Aardvark") .bind("EndTitle") .to("Goo") .build();
try (ResultSet resultSet = dbClient.singleUse().executeQuery(statement)) { while (resultSet.next()) { System.out.printf( "%d %s %s\n", resultSet.getLong("AlbumId"), resultSet.getString("AlbumTitle"), resultSet.isNull("MarketingBudget") ? "NULL" : resultSet.getLong("MarketingBudget"));
} } }

Node.js

/**
 * TODO(developer): Uncomment these variables before running the sample.
*/ // const instanceId = 'my-instance';
// const databaseId = 'my-database';
// const projectId = 'my-project-id';
// const startTitle = 'Ardvark';
// const endTitle = 'Goo';

// Imports the Google Cloud Spanner client library const {Spanner} = require('@google-cloud/spanner');

// Instantiates a client const spanner = new Spanner({ projectId: projectId, });

async function queryDataWithIndex() { // Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

const query = { sql: `SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} WHERE AlbumTitle >= @startTitle AND AlbumTitle <= @endTitle`, params: { startTitle: startTitle, endTitle: endTitle, }, };

// Queries rows from the Albums table try { const [rows] = await database.run(query);

rows.forEach(row => { const json = row.toJSON();
const marketingBudget = json.MarketingBudget ? json.MarketingBudget : null; // This value is nullable console.log( `AlbumId: ${json.AlbumId}, AlbumTitle: ${json.AlbumTitle}, MarketingBudget: ${marketingBudget}`, );
});
} catch (err) { console.error('ERROR:', err);
} finally { // Close the database when finished.
database.close();
} } queryDataWithIndex();

PHP

use Google\Cloud\Spanner\SpannerClient;

/**
 * Queries sample data from the database using SQL and an index.
*
 * The index must exist before running this sample. You can add the index
 * by running the `add_index` sample or by running this DDL statement against
 * your database:
*
 *     CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)
*
 * Example:
 * ```
 * query_data_with_index($instanceId, $databaseId);
 * ```
*
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
 * @param string $startTitle The start of the title index.
 * @param string $endTitle   The end of the title index.
*/ function query_data_with_index( string $instanceId, string $databaseId, string $startTitle = 'Aardvark', string $endTitle = 'Goo' ): void { $spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);

$parameters = [ 'startTitle' => $startTitle, 'endTitle' => $endTitle ];

$results = $database->execute( 'SELECT AlbumId, AlbumTitle, MarketingBudget ' .
'FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} ' .
'WHERE AlbumTitle >= @startTitle AND AlbumTitle < @endTitle', ['parameters' => $parameters] );

foreach ($results as $row) { printf('AlbumId: %s, AlbumTitle: %s, MarketingBudget: %d' . PHP_EOL, $row['AlbumId'], $row['AlbumTitle'], $row['MarketingBudget']);
} }

Python

def query_data_with_index( instance_id, database_id, start_title="Aardvark", end_title="Goo" ):
"""Queries sample data from the database using SQL and an index.

The index must exist before running this sample. You can add the index by running the `add_index` sample or by running this DDL statement against your database:

CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)

This sample also uses the `MarketingBudget` column. You can add the column by running the `add_column` sample or by running this DDL statement against your database:

ALTER TABLE Albums ADD COLUMN MarketingBudget INT64

""" spanner_client = spanner.Client() instance = spanner_client.instance(instance_id) database = instance.database(database_id)

params = {"start_title": start_title, "end_title": end_title} param_types = { "start_title": spanner.param_types.STRING, "end_title": spanner.param_types.STRING, }

with database.snapshot() as snapshot:
results = snapshot.execute_sql( "SELECT AlbumId, AlbumTitle, MarketingBudget " "FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} " "WHERE AlbumTitle >= @start_title AND AlbumTitle < @end_title", params=params, param_types=param_types, )

for row in results:
print("AlbumId: {}, AlbumTitle: {}, " "MarketingBudget: {}".format(*row))

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"
# start_title = "An album title to start with such as 'Ardvark'"
# end_title   = "An album title to end with such as 'Goo'"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

sql_query = "SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@{FORCE_INDEX=AlbumsByAlbumTitle} WHERE AlbumTitle >= @start_title AND AlbumTitle < @end_title"

params      = { start_title: start_title, end_title: end_title } param_types = { start_title: :STRING,     end_title: :STRING }

client.execute(sql_query, params: params, types: param_types).rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]} #{row[:MarketingBudget]}" end

在读取接口中指定索引

如果您使用了 Spanner 的读取接口，并且希望 Spanner 使用索引，则必须指定索引。读取接口不会自动选择索引。

此外，您的索引必须包含查询结果中显示的所有数据，属于主键的列除外。存在此限制是因为读取接口不支持索引和基表之间的联接。如果您需要在查询结果中包含其他列，可以使用以下几种方法：

使用 STORING 或 INCLUDE 子句将其他列存储在索引中。

执行不包含其他列的查询，然后再使用主键发送另一个读取其他列的查询。

Spanner 按索引键的升序顺序返回索引中的值。要按降序顺序检索值，请完成以下步骤：

为索引键添加注释 DESC。例如：

CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle DESC);

DESC 注释适用于单个索引键。如果索引包含多个键，并且您希望按照所有键的降序顺序显示查询结果，请为每个键添加 DESC 注释。

如果读取接口指定了键范围，请确保该键范围也按降序顺序排列。换句话说，也就是起始键的值必须大于结束键的值。

以下示例演示了如何使用索引 AlbumsByAlbumTitle 检索 AlbumId 和 AlbumTitle 的值：

C++

void ReadDataWithIndex(google::cloud::spanner::Client client) { namespace spanner = ::google::cloud::spanner;

auto rows = client.Read("Albums", google::cloud::spanner::KeySet::All(), {"AlbumId", "AlbumTitle"}, google::cloud::Options{}.set( "AlbumsByAlbumTitle"));
using RowType = std::tuple;
for (auto& row : spanner::StreamOf(rows)) { if (!row) throw std::move(row).status();
std::cout (*row) << "\t";
std::cout (*row) << "\n";
} std::cout << "Read completed for [spanner_read_data_with_index]\n";
}

C#

using Google.Cloud.Spanner.Data;
using System.Collections.Generic;
using System.Threading.Tasks;

public class QueryDataWithIndexAsyncSample { public class Album { public int AlbumId { get; set; } public string AlbumTitle { get; set; } public long MarketingBudget { get; set; } }

public async Task> QueryDataWithIndexAsync(string projectId, string instanceId, string databaseId, string startTitle, string endTitle) { string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
using var cmd = connection.CreateSelectCommand( "SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@ " + "{FORCE_INDEX=AlbumsByAlbumTitle} " + $"WHERE AlbumTitle >= @startTitle " + $"AND AlbumTitle < @endTitle", new SpannerParameterCollection { { "startTitle", SpannerDbType.String, startTitle }, { "endTitle", SpannerDbType.String, endTitle } });

var albums = new List();
using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync()) { albums.Add(new Album { AlbumId = reader.GetFieldValue("AlbumId"), AlbumTitle = reader.GetFieldValue("AlbumTitle"), MarketingBudget = reader.IsDBNull(reader.GetOrdinal("MarketingBudget")) ? 0 : reader.GetFieldValue("MarketingBudget") });
} return albums;
} }

Go

import (
"context" "fmt" "io"

"cloud.google.com/go/spanner" "google.golang.org/api/iterator" )

func readUsingIndex(w io.Writer, db string) error { ctx := context.Background() client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

iter := client.Single().ReadUsingIndex(ctx, "Albums", "AlbumsByAlbumTitle", spanner.AllKeys(), []string{"AlbumId", "AlbumTitle"}) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { return nil } if err != nil { return err } var albumID int64 var albumTitle string if err := row.Columns(&albumID, &albumTitle); err != nil { return err } fmt.Fprintf(w, "%d %s\n", albumID, albumTitle) } }

Java

static void readUsingIndex(DatabaseClient dbClient) { try (ResultSet resultSet = dbClient .singleUse() .readUsingIndex( "Albums", "AlbumsByAlbumTitle", KeySet.all(), Arrays.asList("AlbumId", "AlbumTitle"))) { while (resultSet.next()) { System.out.printf("%d %s\n", resultSet.getLong(0), resultSet.getString(1));
} } }

Node.js

/**
 * TODO(developer): Uncomment these variables before running the sample.
*/ // const instanceId = 'my-instance';
// const databaseId = 'my-database';
// const projectId = 'my-project-id';

// Imports the Google Cloud Spanner client library const {Spanner} = require('@google-cloud/spanner');

// Instantiates a client const spanner = new Spanner({ projectId: projectId, });

async function readDataWithIndex() { // Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

const albumsTable = database.table('Albums');

const query = { columns: ['AlbumId', 'AlbumTitle'], keySet: { all: true, }, index: 'AlbumsByAlbumTitle', };

// Reads the Albums table using an index try { const [rows] = await albumsTable.read(query);

rows.forEach(row => { const json = row.toJSON();
console.log(`AlbumId: ${json.AlbumId}, AlbumTitle: ${json.AlbumTitle}`);
});
} catch (err) { console.error('ERROR:', err);
} finally { // Close the database when finished.
database.close();
} } readDataWithIndex();

PHP

use Google\Cloud\Spanner\SpannerClient;

/**
 * Reads sample data from the database using an index.
*
 * The index must exist before running this sample. You can add the index
 * by running the `add_index` sample or by running this DDL statement against
 * your database:
*
 *     CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)
*
 * Example:
 * ```
 * read_data_with_index($instanceId, $databaseId);
 * ```
*
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function read_data_with_index(string $instanceId, string $databaseId): void { $spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);

$keySet = $spanner->keySet(['all' => true]);
$results = $database->read( 'Albums', $keySet, ['AlbumId', 'AlbumTitle'], ['index' => 'AlbumsByAlbumTitle'] );

foreach ($results->rows() as $row) { printf('AlbumId: %s, AlbumTitle: %s' . PHP_EOL, $row['AlbumId'], $row['AlbumTitle']);
} }

Python

def read_data_with_index(instance_id, database_id):
"""Reads sample data from the database using an index.

The index must exist before running this sample. You can add the index by running the `add_index` sample or by running this DDL statement against your database:

CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)

""" spanner_client = spanner.Client() instance = spanner_client.instance(instance_id) database = instance.database(database_id)

with database.snapshot() as snapshot:
keyset = spanner.KeySet(all_=True) results = snapshot.read( table="Albums", columns=("AlbumId", "AlbumTitle"), keyset=keyset, index="AlbumsByAlbumTitle", )

for row in results:
print("AlbumId: {}, AlbumTitle: {}".format(*row))

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

result = client.read "Albums", [:AlbumId, :AlbumTitle], index: "AlbumsByAlbumTitle"

result.rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]}" end

为纯索引扫描创建索引

您可以选择使用 STORING 子句（对于 GoogleSQL 方言数据库）或 INCLUDE 子句（对于 PostgreSQL 方言数据库）将列的副本存储在索引中。此类索引为使用索引的查询和读取调用提供了便利，但会占用额外存储空间：

如果 SQL 查询使用索引且选择存储在 STORING 或 INCLUDE 子句中的列，则不需要与基表建立额外联接。

使用索引的 read() 调用可以读取由 STORING/INCLUDE 子句存储的列。

例如，假设您创建了 AlbumsByAlbumTitle 的替代版本，将 MarketingBudget 列的副本存储在索引中（请注意，STORING 或 INCLUDE 子句以粗体显示）：

GoogleSQL

CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) STORING (MarketingBudget);

PostgreSQL

CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) INCLUDE (MarketingBudget);

使用旧的 AlbumsByAlbumTitle 索引时，Spanner 必须将索引与基表联接，然后从基表检索该列。借助新的 AlbumsByAlbumTitle2 索引，Spanner 可直接从索引中读取该列，效率更高。

如果您使用读取接口（而非 SQL），新的 AlbumsByAlbumTitle2 索引也可让您直接读取 MarketingBudget 列：

C++

void ReadDataWithStoringIndex(google::cloud::spanner::Client client) { namespace spanner = ::google::cloud::spanner;

auto rows = client.Read("Albums", google::cloud::spanner::KeySet::All(), {"AlbumId", "AlbumTitle", "MarketingBudget"}, google::cloud::Options{}.set( "AlbumsByAlbumTitle2"));
using RowType = std::tuple>;
for (auto& row : spanner::StreamOf(rows)) { if (!row) throw std::move(row).status();
std::cout (*row) << "\t";
std::cout (*row) << "\t";
auto marketing_budget = std::get(*row);
if (marketing_budget) { std::cout << "MarketingBudget: " << *marketing_budget << "\n";
} else { std::cout << "MarketingBudget: NULL\n";
} } std::cout << "Read completed for [spanner_read_data_with_storing_index]\n";
}

C#

using Google.Cloud.Spanner.Data;
using System.Collections.Generic;
using System.Threading.Tasks;

public class QueryDataWithStoringIndexAsyncSample { public class Album { public int AlbumId { get; set; } public string AlbumTitle { get; set; } public long? MarketingBudget { get; set; } }

public async Task> QueryDataWithStoringIndexAsync(string projectId, string instanceId, string databaseId) { string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";

using var connection = new SpannerConnection(connectionString);
var cmd = connection.CreateSelectCommand( "SELECT AlbumId, AlbumTitle, MarketingBudget FROM Albums@ " + "{FORCE_INDEX=AlbumsByAlbumTitle2}");

var albums = new List();
using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync()) { albums.Add(new Album { AlbumId = reader.GetFieldValue("AlbumId"), AlbumTitle = reader.GetFieldValue("AlbumTitle"), MarketingBudget = reader.IsDBNull(reader.GetOrdinal("MarketingBudget")) ? 0 : reader.GetFieldValue("MarketingBudget") });
} return albums;
} }

Go

import (
"context" "fmt" "io" "strconv"

"cloud.google.com/go/spanner" "google.golang.org/api/iterator" )

func readStoringIndex(w io.Writer, db string) error { ctx := context.Background() client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

iter := client.Single().ReadUsingIndex(ctx, "Albums", "AlbumsByAlbumTitle2", spanner.AllKeys(), []string{"AlbumId", "AlbumTitle", "MarketingBudget"}) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { return nil } if err != nil { return err } var albumID int64 var marketingBudget spanner.NullInt64 var albumTitle string if err := row.Columns(&albumID, &albumTitle, &marketingBudget); err != nil { return err } budget := "NULL" if marketingBudget.Valid { budget = strconv.FormatInt(marketingBudget.Int64, 10) } fmt.Fprintf(w, "%d %s %s\n", albumID, albumTitle, budget) } }

Java

static void readStoringIndex(DatabaseClient dbClient) { // We can read MarketingBudget also from the index since it stores a copy of MarketingBudget.
try (ResultSet resultSet = dbClient .singleUse() .readUsingIndex( "Albums", "AlbumsByAlbumTitle2", KeySet.all(), Arrays.asList("AlbumId", "AlbumTitle", "MarketingBudget"))) { while (resultSet.next()) { System.out.printf( "%d %s %s\n", resultSet.getLong(0), resultSet.getString(1), resultSet.isNull("MarketingBudget") ? "NULL" : resultSet.getLong("MarketingBudget"));
} } }

Node.js

/**
 * TODO(developer): Uncomment these variables before running the sample.
*/ // const instanceId = 'my-instance';
// const databaseId = 'my-database';
// const projectId = 'my-project-id';

// Imports the Google Cloud Spanner client library const {Spanner} = require('@google-cloud/spanner');

// Instantiates a client const spanner = new Spanner({ projectId: projectId, });

// "Storing" indexes store copies of the columns they index // This speeds up queries, but takes more space compared to normal indexes // See the link below for more information:
// https://cloud.google.com/spanner/docs/secondary-indexes#storing_clause async function readDataWithStoringIndex() { // Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

const albumsTable = database.table('Albums');

const query = { columns: ['AlbumId', 'AlbumTitle', 'MarketingBudget'], keySet: { all: true, }, index: 'AlbumsByAlbumTitle2', };

// Reads the Albums table using a storing index try { const [rows] = await albumsTable.read(query);

rows.forEach(row => { const json = row.toJSON();
let rowString = `AlbumId: ${json.AlbumId}`;
rowString += `, AlbumTitle: ${json.AlbumTitle}`;
if (json.MarketingBudget) { rowString += `, MarketingBudget: ${json.MarketingBudget}`;
} console.log(rowString);
});
} catch (err) { console.error('ERROR:', err);
} finally { // Close the database when finished.
database.close();
} } readDataWithStoringIndex();

PHP

use Google\Cloud\Spanner\SpannerClient;

/**
 * Reads sample data from the database using an index with a storing
 * clause.
*
 * The index must exist before running this sample. You can add the index
 * by running the `add_storing_index` sample or by running this DDL statement
 * against your database:
*
 *     CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle)
 *     STORING (MarketingBudget)
*
 * Example:
 * ```
 * read_data_with_storing_index($instanceId, $databaseId);
 * ```
*
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function read_data_with_storing_index(string $instanceId, string $databaseId): void { $spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);

$keySet = $spanner->keySet(['all' => true]);
$results = $database->read( 'Albums', $keySet, ['AlbumId', 'AlbumTitle', 'MarketingBudget'], ['index' => 'AlbumsByAlbumTitle2'] );

foreach ($results->rows() as $row) { printf('AlbumId: %s, AlbumTitle: %s, MarketingBudget: %d' . PHP_EOL, $row['AlbumId'], $row['AlbumTitle'], $row['MarketingBudget']);
} }

Python

def read_data_with_storing_index(instance_id, database_id):
"""Reads sample data from the database using an index with a storing clause.

The index must exist before running this sample. You can add the index by running the `add_scoring_index` sample or by running this DDL statement against your database:

CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) STORING (MarketingBudget)

""" spanner_client = spanner.Client() instance = spanner_client.instance(instance_id) database = instance.database(database_id)

with database.snapshot() as snapshot:
keyset = spanner.KeySet(all_=True) results = snapshot.read( table="Albums", columns=("AlbumId", "AlbumTitle", "MarketingBudget"), keyset=keyset, index="AlbumsByAlbumTitle2", )

for row in results:
print("AlbumId: {}, AlbumTitle: {}, " "MarketingBudget: {}".format(*row))

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

result = client.read "Albums", [:AlbumId, :AlbumTitle, :MarketingBudget], index: "AlbumsByAlbumTitle2"

result.rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]} #{row[:MarketingBudget]}" end

更改索引

您可以使用 ALTER INDEX 语句向现有索引中添加其他列或删除列。这可以更新您在创建索引时由 STORING 子句（GoogleSQL 方言数据库）或 INCLUDE 子句（PostgreSQL 方言数据库）定义的列列表。您无法使用此语句对索引键添加列或删除列。例如，您可以使用 ALTER INDEX 将列添加到 AlbumsByAlbumTitle 中，而不是创建新索引 AlbumsByAlbumTitle2，如以下示例所示：

GoogleSQL

ALTER INDEX AlbumsByAlbumTitle ADD STORED COLUMN MarketingBudget

PostgreSQL

ALTER INDEX AlbumsByAlbumTitle ADD INCLUDE COLUMN MarketingBudget

当您向现有索引添加新列时，Spanner 会使用后台回填过程。在回填正在进行期间，索引中的列不可读，因此您可能无法获得预期的性能提升。您可以使用 gcloud spanner operations 命令列出长时间运行的操作并查看其状态。如需了解详情，请参阅描述操作。

您还可以使用取消操作来取消正在运行的操作。

回填完成后，Spanner 会将相应列添加到索引中。随着索引变得越来越大，这可能会降低使用该索引的查询的速度。

以下示例展示了如何从索引中删除列：

GoogleSQL

ALTER INDEX AlbumsByAlbumTitle DROP STORED COLUMN MarketingBudget

PostgreSQL

ALTER INDEX AlbumsByAlbumTitle DROP INCLUDE COLUMN MarketingBudget

NULL 值的索引

默认情况下，Spanner 会将 NULL 值编入索引。例如，回顾一下表 Singers 上的索引 SingersByFirstLastName 的定义：

CREATE INDEX SingersByFirstLastName ON Singers(FirstName, LastName);

即使 FirstName 和/或 LastName 为 NULL，系统仍会将 Singers 的所有行编入索引。

将 NULL 值编入索引后，您便可以针对包含 NULL 值的数据执行有效的 SQL 查询和读取。例如，使用以下 SQL 查询语句可查找 FirstName 为 NULL 的所有 Singers：

GoogleSQL

SELECT s.SingerId, s.FirstName, s.LastName FROM Singers@{FORCE_INDEX=SingersByFirstLastName} AS s WHERE s.FirstName IS NULL;

PostgreSQL

SELECT s.SingerId, s.FirstName, s.LastName FROM Singers /* @ FORCE_INDEX = SingersByFirstLastName */ AS s WHERE s.FirstName IS NULL;

NULL 值的排列顺序

Spanner 将 NULL 作为任何给定类型的最小值进行排序。也就是说，如果列按升序 (ASC) 顺序排列，则 NULL 值排在最前。如果列按降序 (DESC) 顺序排列，则 NULL 值排在最后。

禁止将 NULL 值编入索引

GoogleSQL 要禁止将 NULL 值编入索引，请在索引定义中添加 NULL_FILTERED 关键字。NULL_FILTERED 索引特别适用于将大部分行都包含 NULL 值的稀疏列编入索引。在这些情况下，与包含 NULL 的一般索引相比，NULL_FILTERED 索引非常小，维护起来也更为高效。

下面是不将 NULL 编入索引的 SingersByFirstLastName 的一个替代定义：

CREATE NULL_FILTERED INDEX SingersByFirstLastNameNoNulls ON Singers(FirstName, LastName);

NULL_FILTERED 关键字适用于所有索引键列。您无法针对每个列指定 NULL 过滤。

PostgreSQL 如需过滤掉在一个或多个编入索引的列中包含 null 值的行，请使用 WHERE COLUMN IS NOT NULL 谓词。过滤掉 null 值的索引特别适用于将大部分行包含 NULL 值的稀疏列编入索引。在这些情况下，与包含 NULL 的一般索引相比，过滤掉 NULL 值的索引非常小，维护起来也更为高效。

下面是不将 NULL 编入索引的 SingersByFirstLastName 的一个替代定义：

CREATE INDEX SingersByFirstLastNameNoNulls ON Singers(FirstName, LastName) WHERE FirstName IS NOT NULL AND LastName IS NOT NULL;

过滤掉 NULL 值会使 Spanner 无法对部分查询使用该值。例如，Spanner 不会为此查询使用索引，因为索引会忽略所有 LastName 为 NULL 的 Singers 行；因此，使用索引会导致查询无法返回正确的行：

GoogleSQL

FROM Singers@{FORCE_INDEX=SingersByFirstLastNameNoNulls} WHERE FirstName = "John";

PostgreSQL

FROM Singers /*@ FORCE_INDEX = SingersByFirstLastNameNoNulls */ WHERE FirstName = 'John';

要让 Spanner 正常使用索引，您必须重新撰写查询，另行排除索引中已排除的行：

GoogleSQL

SELECT FirstName, LastName FROM Singers@{FORCE_INDEX=SingersByFirstLastNameNoNulls} WHERE FirstName = 'John' AND LastName IS NOT NULL;

PostgreSQL

SELECT FirstName, LastName FROM Singers /*@ FORCE_INDEX = SingersByFirstLastNameNoNulls */ WHERE FirstName = 'John' AND LastName IS NOT NULL;

将 proto 字段编入索引

使用生成的列可将存储在 PROTO 列中的协议缓冲区中的字段编入索引，只要被编入索引的字段使用的是原始数据类型或 ENUM 数据类型即可。

如果您为某个协议消息字段定义了索引，则无法修改该字段或从 proto 架构中移除该字段。如需了解详情，请参阅包含 proto 字段索引的架构的更新。

下面是包含 SingerInfo proto 消息列的 Singers 表的示例。如需为 PROTO 的 nationality 字段定义索引，您需要创建存储的生成列：

GoogleSQL

CREATE PROTO BUNDLE (googlesql.example.SingerInfo, googlesql.example.SingerInfo.Residence);

CREATE TABLE Singers ( SingerId INT64 NOT NULL, ...
SingerInfo googlesql.example.SingerInfo, SingerNationality STRING(MAX) AS (SingerInfo.nationality) STORED ) PRIMARY KEY (SingerId);

它对 googlesql.example.SingerInfo proto 类型有以下定义：

GoogleSQL

package googlesql.example;

message SingerInfo { optional string    nationality = 1;
repeated Residence residence   = 2;

message Residence { required int64  start_year   = 1;
optional int64  end_year     = 2;
optional string city         = 3;
optional string country      = 4;
} }

然后对 proto 的 nationality 字段定义索引：

GoogleSQL

CREATE INDEX SingersByNationality ON Singers(SingerNationality);

以下 SQL 查询使用前面的索引读取数据：

GoogleSQL

SELECT s.SingerId, s.FirstName FROM Singers AS s WHERE s.SingerNationality = "English";

注意：

使用索引指令访问协议缓冲区列字段的索引。

您无法为重复的协议缓冲区字段创建索引。

包含 proto 字段索引的架构的更新

如果您为某个协议消息字段定义了索引，则无法修改该字段或从 proto 架构中移除该字段。这是因为在您定义索引后，系统会在每次更新架构时执行类型检查。Spanner 会捕获相应路径中在索引定义中使用的所有字段的类型信息。

唯一索引

索引可声明为是 UNIQUE 的。UNIQUE 索引会对要编入索引的数据施加一项限制，禁止给定索引键有重复条目。在提交事务时，Spanner 会强制执行此限制。具体而言，任何会导致同一个键出现多个索引条目的事务都将提交失败。

如果某个表的开头包含非 UNIQUE 数据，那么尝试为其创建 UNIQUE 索引将失败。

有关 UNIQUE NULL_FILTERED 索引的注意事项

当 UNIQUE NULL_FILTERED 索引至少有一个键包含 NULL 值时，系统便不会强制施加索引键唯一性限制。

例如，假设您创建了以下表和索引：

GoogleSQL

CREATE TABLE ExampleTable ( Key1 INT64 NOT NULL, Key2 INT64, Key3 INT64, Col1 INT64, ) PRIMARY KEY (Key1, Key2, Key3);

CREATE UNIQUE NULL_FILTERED INDEX ExampleIndex ON ExampleTable (Key1, Key2, Col1);

PostgreSQL

CREATE TABLE ExampleTable ( Key1 BIGINT NOT NULL, Key2 BIGINT, Key3 BIGINT, Col1 BIGINT, PRIMARY KEY (Key1, Key2, Key3) );

CREATE UNIQUE INDEX ExampleIndex ON ExampleTable (Key1, Key2, Col1) WHERE Key1 IS NOT NULL AND Key2 IS NOT NULL AND Col1 IS NOT NULL;

ExampleTable 中的以下两行的二级索引键 Key1、Key2 和 Col1 具有相同的值：

1, NULL, 1, 1 1, NULL, 2, 1

由于 Key2 为 NULL 且索引已过滤掉 null 值，因此这些行不会出现在索引 ExampleIndex 中。而由于这些行没有插入到索引中，索引不会因为 (Key1, Key2, Col1) 违反唯一性而拒绝它们。

如果希望索引强制对元组（Key1、Key2 和 Col1）的值施加唯一性限制，那么您必须在表定义中为 Key2 添加注解 NOT NULL，或者创建未过滤掉 NULL 值的索引。

删除索引

可使用 DROP INDEX 语句从架构中删除二级索引。

要删除名为 SingersByFirstLastName 的索引，请使用以下语句：

DROP INDEX SingersByFirstLastName;

编入索引以加快扫描速度

当 Spanner 需要执行表扫描（而不是索引查找）以从一个或多个列中获取值时，如果这些列存在索引并且按照查询指定的顺序，您可以获得更快的结果。如果您经常执行需要扫描的查询，请考虑创建二级索引，以帮助更高效地执行这些扫描。

具体来说，如果您需要 Spanner 以反向顺序频繁扫描表的主键或其他索引，则可以通过使所选顺序明确显示的二级索引来提高其效率。

例如，以下查询会始终快速返回结果，即使 Spanner 需要扫描 Songs 以查找最低的 SongId 值：

SELECT SongId FROM Songs LIMIT 1;

SongId 是表的主键（与所有主键一样），按升序存储。Spanner 可以扫描该键的索引并快速查找第一个结果。

但是，如果没有二级索引的帮助，以下查询不会快速返回，尤其是在 Songs 包含大量数据的情况下：

SELECT SongId FROM Songs ORDER BY SongId DESC LIMIT 1;

尽管 SongId 是表的主键，但如果没有进行全表扫描，Spanner 也无法提取列的最高值。

添加以下索引可让此查询更快地返回：

CREATE INDEX SongIdDesc On Songs(SongId DESC);

有了此索引，Spanner 将会以更快的速度返回第二个查询的结果。

后续步骤

了解 Spanner 的 SQL 最佳做法。

了解 Spanner 的查询执行计划。

了解如何排查 SQL 查询中的性能回归问题。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-04-23。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-04-23。"],[],[]]

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
