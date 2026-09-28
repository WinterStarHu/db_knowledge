# 更新架构  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/schema-updates

更新架构  |  Spanner  |  Google Cloud Documentation

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

更新架构

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

Spanner 允许您在不停机的情况下进行架构更新。您可以通过几种方式更新现有数据库的架构：

在 Google Cloud 控制台中

在 Spanner Studio 页面上提交 ALTER TABLE 命令。

如需访问 Spanner Studio 页面，请在数据库概览或表概览页面中点击 Spanner Studio。

使用 gcloud spanner 命令行工具

使用 gcloud spanner databases ddl update 命令提交 ALTER TABLE 命令。

使用客户端库

使用 projects.instances.databases.updateDdl REST API

使用 UpdateDatabaseDdl RPC API

支持的架构更新

Spanner 支持对现有数据库执行以下架构更新操作：

添加或删除命名架构。

新建一个表。 新表格中的列可以为 NOT NULL。

删除一个表，前提是该表内没有交错其他表，并且没有二级索引。

创建或删除带有外键的表。

在现有表中添加或移除外键。

将一个非键列添加到任何表。新的非键列不能为 NOT NULL。

从任何表中删除非键列，除非二级索引、外键、存储的生成列或检查限制条件使用该列。

将 NOT NULL 添加到非键列，从而排除 ARRAY 列。

从非键列中移除 NOT NULL。

将 STRING 列更改为 BYTES 列，或将 BYTES 列更改为 STRING 列。

将 PROTO 列更改为 BYTES 列，或将 BYTES 列更改为 PROTO 列。

更改 PROTO 列的 proto 消息类型。

使用 ALTER PROTO BUNDLE 向 ENUM 定义添加新值并重命名现有值。

以任意方式更改 PROTO BUNDLE 中定义的消息，前提是这些消息的被修改字段不会用作任何表中的键，并且现有数据满足新限制条件。

增加或减少 STRING 或 BYTES 类型的长度限制（包括增加到 MAX），前提是它不是由一个或多个子表继承的主键列。

将 ARRAY、ARRAY 或 ARRAY 列的长度限制增加或减少到允许的最大值。

在值和主键列中启用或停用提交时间戳。

添加或移除二级索引。

在现有表中添加或移除检查限制条件。

在现有表中添加或移除存储的生成列。

构建新的优化器统计信息软件包。

创建和管理视图。

创建和管理序列。

创建数据库角色并授予权限。

设置、更改或删除列的默认值。

更改数据库选项（例如 default_leader 或 version_retention_period）。

创建和管理变更数据流。

创建和管理机器学习模型。

不支持的架构更新

Spanner 不支持对现有数据库执行以下架构更新操作：

如果存在由表或索引键引用的 ENUM 类型的 PROTO 字段，则无法从 proto 枚举中移除 ENUM 值。（支持从 ENUM<> 列所使用的枚举中移除 ENUM 值，包括当这些列用作键时。）

架构更新性能

Spanner 中的架构更新不需要停机。如果您向某个 Spanner 数据库发出一批 DDL 语句，当 Spanner 以长时间运行的操作形式应用更新时，您可以继续从该数据库写入和读取数据而不会发生中断。

执行 DDL 语句所需的时间取决于更新是否需要验证现有数据或回填任何数据。例如，如果您向现有列添加 NOT NULL 注解，则 Spanner 必须读取列中的所有值，以确保该列不包含任何 NULL 值。如果有大量数据需要验证，则此步骤可能需要很长时间。另一个示例是，如果您向数据库添加索引：Spanner 会使用现有数据回填索引，并且该过程可能需要很长时间，具体取决于索引的定义和相应基表的大小。但是，如果向表中添加新列，则不需要验证任何现有数据，因此 Spanner 可以更快地进行更新。

总之，不需要 Spanner 验证现有数据的架构更新可以在几分钟内完成。需要验证的架构更新可能需要更长时间，具体取决于需要验证的现有数据量，但数据验证操作会在后台以低于生产流量的优先级执行。下一节将详细讨论需要验证数据的架构更新。

根据视图定义验证的架构更新

进行架构更新时，Spanner 会验证更新是否不会使用于定义现有视图的查询无效。如果验证成功，则架构更新就会成功。如果验证不成功，则架构更新将失败。如需了解详情，请参阅创建视图时的最佳做法。

需要验证数据的架构更新

您可以执行需要验证现有数据是否符合新的限制条件的架构更新。当架构更新需要验证数据时，Spanner 不允许对受影响的架构实体进行冲突的架构更新，而且会在后台验证数据。如果验证成功，则架构更新就会成功。如果验证失败，则架构更新不成功。验证操作会作为长时间运行的操作执行。您可以检查这些操作的状态，以此确定这些操作是成功还是失败。

例如，假设您已定义以下 music.proto 文件，其中包含 RecordLabel 枚举和 Songwriter 协议消息：

enum RecordLabel { COOL_MUSIC_INC = 0;
PACIFIC_ENTERTAINMENT = 1;
XYZ_RECORDS = 2;
}

message Songwriter { required string nationality   = 1;
optional int64  year_of_birth = 2;
}

如需在您的架构中添加 Songwriters 表，请执行以下操作：

GoogleSQL

CREATE PROTO BUNDLE ( googlesql.example.music.Songwriter, googlesql.example.music.RecordLabel, );

CREATE TABLE Songwriters ( Id         INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), Nickname   STRING(MAX), OpaqueData BYTES(MAX), SongWriter googlesql.example.music.Songwriter ) PRIMARY KEY (Id);

CREATE TABLE Albums ( SongwriterId     INT64 NOT NULL, AlbumId          INT64 NOT NULL, AlbumTitle       STRING(MAX), Label            INT32 ) PRIMARY KEY (SongwriterId, AlbumId);

可进行以下架构更新，但这些架构更新需要验证，并且可能需要较长时间才能完成，具体取决于现有数据量：

将 NOT NULL 注释添加到非键列。例如：

ALTER TABLE Songwriters ALTER COLUMN Nickname STRING(MAX) NOT NULL;

缩短列的长度。例如：

ALTER TABLE Songwriters ALTER COLUMN FirstName STRING(10);

从 BYTES 改为 STRING。例如：

ALTER TABLE Songwriters ALTER COLUMN OpaqueData STRING(MAX);

从 INT64/INT32 改为 ENUM。例如：

ALTER TABLE Albums ALTER COLUMN Label googlesql.example.music.RecordLabel;

从 RecordLabel 枚举定义中移除现有值。

在现有 TIMESTAMP 列上启用提交时间戳。例如：

ALTER TABLE Albums ALTER COLUMN LastUpdateTime SET OPTIONS (allow_commit_timestamp = true);

向现有表添加检查限制条件。

将存储的生成列添加到现有表中。

创建带有外键的新表。

向现有表中添加外键。

如果基础数据不满足新的限制条件，则这些架构更新会失败。例如，如果 Nickname 列中的任何值为 NULL，则 ALTER TABLE Songwriters ALTER COLUMN Nickname STRING(MAX) NOT NULL 语句会失败，因为现有数据不符合新定义的 NOT NULL 限制条件。

验证数据操作可能需要数分钟到数小时。完成数据验证的时间取决于以下因素：

数据集的大小

实例的计算容量

实例上的负载

在更新完成之前，某些架构更新可以更改数据库请求的行为。例如，如果在某列中添加 NOT NULL，对于那些要对该列使用 NULL 的新请求，Spanner 会几乎立即开始拒绝写入。如果新的架构更新因未通过数据验证而最终失败，那么写入操作会在一段时间内被阻止，即使这些操作原本应该会被旧架构接受，也是如此。

您可以使用 projects.instances.databases.operations.cancel 方法或使用 gcloud spanner operations 取消长时间运行的数据验证操作。

批量执行语句的顺序

如果使用 Google Cloud CLI、REST API 或 RPC API，您可以发出一批（一个或多个）CREATE、ALTER 或 DROP 语句。

Spanner 将按顺序应用同一批次中的语句，并在第一个错误处停止。如果应用语句时产生错误，则系统会回滚该语句。该批次中以前应用过的语句的结果不会回滚。这种按顺序应用语句的方式意味着，如果您希望某些语句并行运行（例如各自可能需要很长时间的索引回填），则应在单独的批次中提交这些语句。

Spanner 可能会对不同批次中的语句进行组合和重新排序，从而可能会将来自不同批次的语句混合到应用于数据库的一个原子更改中。在每个原子更改中，不同批次的语句按照任意顺序执行。例如，如果一批语句包含 ALTER TABLE MyTable ALTER COLUMN MyColumn STRING(50)，而另一批语句包含 ALTER TABLE MyTable ALTER COLUMN MyColumn STRING(20)，则 Spanner 将会使相应列处于这两个状态中的某个状态，但不具体指定哪一个状态。

在架构更新期间创建的架构版本

Spanner 使用架构版本控制，以便在对大型数据库进行架构更新时不会出现停机。Spanner 维护旧的架构版本，以便在处理架构更新时支持读取。然后，Spanner 会创建一个或多个新版本的架构来处理架构更新。每个版本都包含单个原子更改中的语句集合的结果。

架构版本不一定与批量 DDL 语句或单独的 DDL 语句一一对应。某些单独的 DDL 语句（例如为现有基表或需要数据验证的语句创建索引）会导致产生多个架构版本。在其他情况下，可以在单个版本中将多个 DDL 语句作为一批进行处理。旧架构版本可能会占用大量服务器和存储资源，并且会一直保留，直到过期（不再需要为旧版本数据的读取提供服务）。
注意：如果您需要添加多个索引，请参阅大型更新方法。

下表显示了 Spanner 更新架构所需的时间。

架构操作 估计用时

CREATE TABLE 分钟

CREATE INDEX

如果基表是在索引之前创建的，则为几分钟到几个小时。
如果语句与基表的 CREATE TABLE 语句同时执行，则为几分钟。

DROP TABLE 分钟

DROP INDEX 分钟

ALTER TABLE ... ADD COLUMN 分钟

ALTER TABLE ... ALTER COLUMN

如果需要后台验证，则为几个小时。
如果不需要后台验证，则为几分钟。

ALTER TABLE ... DROP COLUMN 分钟

ANALYZE

几分钟到几小时，具体取决于数据库大小。

数据类型更改和变更数据流

如果您更改了变更数据流所监控的列的数据类型，相关后续变更数据流记录的 column_types 字段会反映其新类型，记录的 mods 字段中的 old_values JSON 数据也会反映其新类型。

变更数据流记录 mods 字段的 new_values 始终与列的当前类型一致。更改受监控列的数据类型不会影响该更改之前的任何变更数据流记录。

在从 BYTES 更改为 STRING 的特定情况下，Spanner 会在架构更新过程中验证列的旧值。因此，在写入任何后续变更数据流记录时，Spanner 已安全地将旧的 BYTES 类型值解码为字符串。

架构更新的最佳做法

以下各节介绍了更新架构的最佳做法。

发出架构更新之前的过程

在您发出架构更新之前，请完成以下操作：

验证数据库中您正在更改的所有现有数据是否满足架构更新所施加的限制条件。由于某些类型的架构更新的成功取决于数据库中的数据，而不仅仅取决于其当前架构，因此，测试数据库的架构成功更新并不能保证生产数据库的架构可成功更新。下面是一些常见的示例：

如果您向现有列添加 NOT NULL 注释，则需要确认该列不包含任何现有的 NULL 值。

如果缩短 STRING 或 BYTES 列允许的长度，请检查该列中的所有现有值是否符合长度限制条件。

如果要向正在进行架构更新的列、表或索引中写入数据，请确保所写入的值符合新的限制条件。

如果要删除某个列、表或索引，请确保不再向其中写入数据或从中读取数据。

限制架构更新的频率

如果您在短时间内执行的架构更新过多，Spanner 可能会对排队架构更新的处理执行 throttle 操作。这是因为 Spanner 限制了用于存储架构版本的空间量。如果保留期限内的旧架构版本过多，您的架构更新可能会受到节流。架构更改的最大速率取决于许多因素，其中一个因素是数据库中的总列数。例如，如果数据库有 2,000 列（INFORMATION_SCHEMA.COLUMNS 中大约有 2,000 行），则在保留期限内最多能够执行 1,500 次架构更改（如果架构更改需要多个版本，则次数会更少）。如需查看正在进行的架构更新的状态，请使用 gcloud spanner operations list 命令，并按类型为 DATABASE_UPDATE_DDL 的操作进行过滤。如需取消正在进行的架构更新，请使用 gcloud spanner operations cancel 命令并指定操作 ID。

DDL 语句的批处理方式以及每个批次内的顺序可能会影响生成的架构版本数量。如需最大限度地提高在任意给定时间段内可执行的架构更新次数，您应使用可最大限度地减少架构版本数量的批处理。大型更新中介绍了一些经验法则。

如架构版本中所述，某些 DDL 语句将创建多个架构版本，当考虑进行批处理以及每个批次内的排序时，这些版本非常重要。有两种主要类型的语句可能会创建多个架构版本：

可能需要回填索引数据的语句，例如 CREATE INDEX

可能需要验证现有数据的语句，例如添加 NOT NULL

但是，这些类型的语句不一定会创建多个架构版本。Spanner 将尝试检测何时可以优化这些类型的语句以避免使用多个架构版本（这取决于批处理）。例如，与用于索引基表的 CREATE TABLE 语句位于同一批次的 CREATE INDEX 语句（不干预用于其他表的语句）无需回填索引数据，因为 Spanner 可以保证在创建索引时基表为空。大型更新部分介绍了如何使用此属性高效地创建多个索引。

如果无法批量处理 DDL 语句以避免创建多个架构版本，您应限制单个数据库的架构在其保留期限内的架构更新次数。请增加进行架构更新的时间范围，以便 Spanner 能在创建新版本之前移除旧的架构版本。

对于某些关系型数据库管理系统，有一些软件包会在每次生产部署时对数据库进行一连串的升级和降级架构更新。Spanner 不建议使用这些类型的处理。

Spanner 经过优化，可使用主键对多租户解决方案的数据进行分区。对每个客户使用单独表的多租户解决方案可能会导致大量架构更新操作积压，需要很长时间才能完成。

需要验证或索引回填的架构更新会使用更多服务器资源，因为每个语句都会在内部创建多个架构版本。

大型架构更新方法

创建表并对该表创建大量索引的最佳方式是同时创建所有这些内容，这样只会创建一个架构版本。最佳实践是在 DDL 语句列表中紧跟在表之后创建索引。您可以在创建数据库时创建表及其索引，也可以在单个大批量 DDL 语句中创建表及其索引。如果您需要创建许多表，每个表都包含许多索引，则可以将所有语句都包含在一个批次中。如果所有语句都可以使用单个架构版本一起执行，您可以在单个批次中包含数千个语句。

当语句需要回填索引数据或需要执行数据验证时，它无法在单个架构版本中执行。当索引的基表已存在（原因可能是在上一批次的 DDL 语句中创建了基表，或者是需要多个架构版本的 CREATE TABLE 和 CREATE INDEX 语句之间的批次中有一个语句）时，CREATE INDEX 语句便会发生上述问题。Spanner 要求每个批次中的此类语句不超过 10 个。创建需要回填的索引时，请特别注意，每个索引需要使用多个架构版本，因此最好每天创建不超过 3 个需要回填的新索引（无论以何种方式进行批处理，除非这种批处理方式能够避免回填）。

例如，以下这批语句将使用单个架构版本：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), ) PRIMARY KEY (SingerId);

CREATE INDEX SingersByFirstName ON Singers(FirstName);

CREATE INDEX SingersByLastName ON Singers(LastName);

CREATE TABLE Albums ( SingerId   INT64 NOT NULL, AlbumId    INT64 NOT NULL, AlbumTitle STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId);

CREATE INDEX AlbumsByTitle ON Albums(AlbumTitle);

相比之下，该批次将使用许多架构版本，因为 UnrelatedIndex 需要回填（因为其基表必须已存在），并且强制要求以下所有索引也需要进行回填（即使它们与其基表位于同一批次）：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), ) PRIMARY KEY (SingerId);

CREATE TABLE Albums ( SingerId   INT64 NOT NULL, AlbumId    INT64 NOT NULL, AlbumTitle STRING(MAX), ) PRIMARY KEY (SingerId, AlbumId);

CREATE INDEX UnrelatedIndex ON UnrelatedTable(UnrelatedIndexKey);

CREATE INDEX SingersByFirstName ON Singers(FirstName);

CREATE INDEX SingersByLastName ON Singers(LastName);

CREATE INDEX AlbumsByTitle ON Albums(AlbumTitle);

最好是将 UnrelatedIndex 的创建操作移到批次的末尾或移到其他批次，以最大限度地减少架构版本。

等待 API 请求完成

在发出 projects.instances.databases.updateDdl (REST API) 或 UpdateDatabaseDdl (RPC API) 请求时，请分别使用 projects.instances.databases.operations.get (REST API) 或 GetOperation (RPC API) 等待每个请求完成，然后再开始新的请求。等待每个请求完成后，您的应用就可以跟踪架构更新的进度。这样做还可将待处理架构更新的积压量保持在可管理的范围内。

批量加载

如果您在创建表后将数据批量加载到表中，则在加载数据后创建索引通常更高效。如果要添加多个索引，则更高效的做法可能是在创建数据库时在初始架构中包含所有表和索引，如大型更新方法中所述。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-23。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-23。"],[],[]]

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
