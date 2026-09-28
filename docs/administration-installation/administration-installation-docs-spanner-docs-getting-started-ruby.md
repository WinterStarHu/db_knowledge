# Spanner 使用入门 (Ruby)  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/getting-started/ruby

Spanner 使用入门 (Ruby)  |  Google Cloud Documentation

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

Spanner 使用入门 (Ruby)

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

PostgreSQL 接口说明：本主题中的示例适用于 GoogleSQL 方言数据库。

目标

本教程将介绍如何使用 Ruby 版 Cloud Spanner 客户端库完成以下步骤：

创建 Spanner 实例和数据库。

写入、读取数据库中的数据和对数据执行 SQL 查询。

更新数据库架构。

使用读写事务更新数据。

向数据库添加二级索引。

使用索引来读取数据和对数据执行 SQL 查询。

使用只读事务检索数据。

费用

本教程使用 Spanner，它是Google Cloud的收费组件。如需了解使用 Spanner 的费用，请参阅价格。

准备工作

完成设置中介绍的步骤，包括创建和设置默认 Google Cloud 项目、启用结算功能、启用 Cloud Spanner API 以及设置 OAuth 2.0 来获取身份验证凭据以使用 Cloud Spanner API。

尤其要确保运行 gcloud auth application-default login，以便使用身份验证凭据设置本地开发环境。
注意：如果您不打算保留在本教程中创建的资源，请考虑创建新的 Google Cloud 项目，而不是选择现有项目。完成本教程后，您可以删除项目，并移除与该项目关联的所有资源。

准备本地 Ruby 环境

在开发机器上安装以下内容（如果尚未安装）：

Ruby

Bundler

将示例应用代码库克隆到本地机器：

git clone https://github.com/GoogleCloudPlatform/ruby-docs-samples

或者，也可以下载该示例的 zip 文件并将其解压缩。

切换到包含 Spanner 示例代码的目录：

cd ruby-docs-samples/spanner/

安装依赖项：

bundle install

将 GOOGLE_CLOUD_PROJECT 环境变量设置为您的 Google Cloud项目 ID：

export GOOGLE_CLOUD_PROJECT=[MY_PROJECT_ID]

创建实例

在首次使用 Spanner 时，必须创建一个实例，实例是 Spanner 数据库使用的资源分配单位。创建实例时，请选择一个实例配置（决定数据的存储位置），同时选择要使用的节点数（决定实例中服务资源和存储资源的数量）。

如需了解如何使用以下任一方法创建 Spanner 实例，请参阅创建实例。您可以将实例命名为 test-instance，以便将其用于本文档中引用名为 test-instance 的实例的其他主题。

Google Cloud CLI

Google Cloud 控制台

客户端库（C++、C#、Go、Java、Node.js、PHP、Python 或 Ruby）

浏览示例文件

示例仓库包含一个示例，展示了如何将 Spanner 与 Ruby 搭配使用。

请浏览 spanner_samples.rb 文件，其中说明了如何使用 Spanner。代码展示了如何创建和使用新数据库。数据使用架构和数据模型页面中显示的示例架构。

创建数据库

GoogleSQL

bundle exec ruby spanner_samples.rb create_database test-instance example-db

PostgreSQL

bundle exec ruby spanner_postgresql_create_database.rb postgresql_create_database MY_PROJECT_ID test-instance example-db

您应该会看到：

Created database example-db on instance test-instance

以下代码会创建一个数据库以及该数据库中的两个表。

注意：后续的代码示例会使用这两个表。如果您不执行此代码，请使用 Google Cloud 控制台或 gcloud CLI 创建表。如需了解详情，请参阅示例架构。

GoogleSQL

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

database_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

instance_path = database_admin_client.instance_path project: project_id, instance: instance_id

job = database_admin_client.create_database parent: instance_path, create_statement: "CREATE DATABASE `#{database_id}`", extra_statements: [ "CREATE TABLE Singers ( SingerId     INT64 NOT NULL, FirstName    STRING(1024), LastName     STRING(1024), SingerInfo   BYTES(MAX) ) PRIMARY KEY (SingerId)",

"CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE" ]

puts "Waiting for create database operation to complete"

job.wait_until_done!

puts "Created database #{database_id} on instance #{instance_id}"

PostgreSQL

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

def postgresql_create_database project_id:, instance_id:, database_id:
  # project_id  = "Your Google Cloud project ID"
  # instance_id = "Your Spanner instance ID"
  # database_id = "Your Spanner database ID"

database_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin project: project_id

instance_path = database_admin_client.instance_path project: project_id, instance: instance_id

job = database_admin_client.create_database parent: instance_path, create_statement: "CREATE DATABASE \"#{database_id}\"", database_dialect: :POSTGRESQL

puts "Waiting for create database operation to complete"

job.wait_until_done!

puts "Created database #{database_id} on instance #{instance_id}" end

下一步是将数据写入数据库。

创建数据库客户端

您必须先创建一个 Client，然后才能执行读写操作。您可以将 Client 视为数据库连接：您与 Spanner 的所有交互都必须通过 Client 进行。通常，您可以在应用启动时创建 Client，然后重复使用该 Client 来读取、写入和执行事务。以下代码演示了如何创建客户端。

# Imports the Google Cloud client library
require "google/cloud/spanner"

# Your Google Cloud Platform project ID
project_id = "YOUR_PROJECT_ID"

# Instantiates a client
spanner = Google::Cloud::Spanner.new project: project_id

# Your Cloud Spanner instance ID
instance_id = "my-instance"

# Your Cloud Spanner database ID
database_id = "my-database"

# Gets a reference to a Cloud Spanner instance database
database_client = spanner.client instance_id, database_id

# Execute a simple SQL statement
results = database_client.execute_query "SELECT 1" results.rows.each do |row| puts row end

如需了解详情，请参阅 Client 参考文档。

使用 DML 写入数据

您可以在读写事务中使用数据操纵语言 (DML) 插入数据。

使用 execute_update() 方法来执行 DML 语句。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id row_count = 0

client.transaction do |transaction| row_count = transaction.execute_update( "INSERT INTO Singers (SingerId, FirstName, LastName) VALUES (12, 'Melissa', 'Garcia'), (13, 'Russell', 'Morales'), (14, 'Jacqueline', 'Long'), (15, 'Dylan', 'Shaw'), (16, 'Billie', 'Eillish'), (17, 'Judy', 'Garland'), (18, 'Taylor', 'Swift'), (19, 'Miley', 'Cyrus'), (20, 'Michael', 'Jackson'), (21, 'Ariana', 'Grande'), (22, 'Elvis', 'Presley'), (23, 'Kanye', 'West'), (24, 'Lady', 'Gaga'), (25, 'Nick', 'Jonas')" ) end

puts "#{row_count} records inserted."

使用 write_using_dml 参数运行示例。

bundle exec ruby spanner_samples.rb write_using_dml test-instance example-db

您应该会看到：

4 records inserted.

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用变更写入数据

您还可以使用变更插入数据。

您可以使用 Client 对象来写入数据。Client#commit 方法跨数据库中的列、行和表，为在单个逻辑时间点以原子方式执行的写入创建并提交事务。

此代码演示了如何使用变更写入数据：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.commit do |c| c.insert "Singers", [ { SingerId: 1, FirstName: "Marc",     LastName: "Richards" }, { SingerId: 2, FirstName: "Catalina", LastName: "Smith"    }, { SingerId: 3, FirstName: "Alice",    LastName: "Trentor"  }, { SingerId: 4, FirstName: "Lea",      LastName: "Martin"   }, { SingerId: 5, FirstName: "David",    LastName: "Lomond"   } ] c.insert "Albums", [ { SingerId: 1, AlbumId: 1, AlbumTitle: "Total Junk" }, { SingerId: 1, AlbumId: 2, AlbumTitle: "Go, Go, Go" }, { SingerId: 2, AlbumId: 1, AlbumTitle: "Green" }, { SingerId: 2, AlbumId: 2, AlbumTitle: "Forever Hold Your Peace" }, { SingerId: 2, AlbumId: 3, AlbumTitle: "Terrified" } ] end

puts "Inserted data"

使用 insert_data 参数运行示例。

bundle exec ruby spanner_samples.rb insert_data test-instance example-db

您应该会看到：

Inserted data

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用 SQL 查询数据

Spanner 支持使用 SQL 接口读取数据，您可以使用 Google Cloud CLI 在命令行中访问该接口，也可以使用 Ruby 版 Spanner 客户端库以编程方式访问该接口。

在命令行中

执行以下 SQL 语句，读取 Albums 表中所有列的值：

gcloud spanner databases execute-sql example-db --instance=test-instance \ --sql='SELECT SingerId, AlbumId, AlbumTitle FROM Albums'

注意：如需查看 GoogleSQL 参考文档，请参阅 GoogleSQL 中的查询语法；如需查看 PostgreSQL 参考文档，请参阅 PostgreSQL 词汇结构和语法。

结果会显示以下内容：

SingerId AlbumId AlbumTitle 1        1       Total Junk 1        2       Go, Go, Go 2        1       Green 2        2       Forever Hold Your Peace 2        3       Terrified

使用 Ruby 版 Spanner 客户端库

除了在命令行中执行 SQL 语句外，还可以使用 Ruby 版 Spanner 客户端库以编程方式发出相同的 SQL 语句。

使用 Client#execute 方法运行 SQL 查询。使用 Ruby 符号 :ColumnName 可访问某一行特定列的数据。

下面演示了如何发出查询并访问数据：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.execute("SELECT SingerId, AlbumId, AlbumTitle FROM Albums").rows.each do |row| puts "#{row[:SingerId]} #{row[:AlbumId]} #{row[:AlbumTitle]}" end

使用 query_data 参数运行示例。

bundle exec ruby spanner_samples.rb query_data test-instance example-db

您应该会看到以下结果：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified

使用 SQL 参数进行查询

如果您的应用具有频繁执行的查询，您可以通过将其参数化来提高其性能。生成的参数查询可以缓存下来并重复使用，这样做可以降低编译开销。如需了解详情，请参阅使用查询参数来加快频繁执行的查询的运行速度。

以下示例演示了如何在 WHERE 子句中使用参数来查询包含特定 LastName 值的记录。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

sql_query = "SELECT SingerId, FirstName, LastName FROM Singers WHERE LastName = @lastName"

params      = { lastName: "Garcia" } param_types = { lastName: :STRING }

client.execute(sql_query, params: params, types: param_types).rows.each do |row| puts "#{row[:SingerId]} #{row[:FirstName]} #{row[:LastName]}" end

使用 query_with_parameter 参数运行示例。

bundle exec ruby spanner_samples.rb query_with_parameter test-instance example-db

您应该会看到以下结果：

12 Melissa Garcia

使用读取 API 读取数据

除了 Spanner 的 SQL 接口外，Spanner 还支持读取接口。

使用 Client 类的 Client#read 方法从数据库中读取行。

下面演示了如何读取数据：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.read("Albums", [:SingerId, :AlbumId, :AlbumTitle]).rows.each do |row| puts "#{row[:SingerId]} #{row[:AlbumId]} #{row[:AlbumTitle]}" end

使用 read_data 参数运行示例。

bundle exec ruby spanner_samples.rb read_data test-instance example-db

您看到的输出结果应该类似于以下内容：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified

更新数据库架构

假设您需要将名为 MarketingBudget 的新列添加到 Albums 表。向现有表添加新列需要更新数据库架构。Spanner 支持在数据库继续处理流量的同时，对数据库进行架构更新。架构更新不需要使数据库离线，并且不会锁定整个表或列；在架构更新期间，您可以继续将数据写入数据库。如需详细了解支持的架构更新和架构更改性能，请参阅更新架构。

添加列

您可以使用 Google Cloud CLI 在命令行中添加列，也可以使用 Ruby 版 Spanner 客户端库以编程方式添加列。

在命令行中

使用以下 ALTER TABLE 命令向表添加新列：

GoogleSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='ALTER TABLE Albums ADD COLUMN MarketingBudget INT64'

PostgreSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='ALTER TABLE Albums ADD COLUMN MarketingBudget BIGINT'

您应该会看到：

Schema updating...done.

使用 Ruby 版 Spanner 客户端库

使用 Database 类的 Database#update 方法来修改架构：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

database_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

db_path = database_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = database_admin_client.update_database_ddl database: db_path, statements: [ "ALTER TABLE Albums ADD COLUMN MarketingBudget INT64" ]

puts "Waiting for database update to complete"

job.wait_until_done!

puts "Added the MarketingBudget column"

使用 add_column 参数运行示例。

bundle exec ruby spanner_samples.rb add_column test-instance example-db

您应该会看到：

Added the MarketingBudget column

将数据写入新列

以下代码可将数据写入新列。对于 Albums(1, 1) 键控的行，该代码会将 MarketingBudget 设置为 100000；而对于 Albums(2, 2) 键控的行，该代码会将其设置为 500000。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.commit do |c| c.update "Albums", [ { SingerId: 1, AlbumId: 1, MarketingBudget: 100_000 }, { SingerId: 2, AlbumId: 2, MarketingBudget: 500_000 } ] end

puts "Updated data"

使用 update_data 参数运行示例。

bundle exec ruby spanner_samples.rb update_data test-instance example-db

您应该会看到：

Updated data

您还可以执行 SQL 查询或读取调用来获取刚才写入的值。

以下是执行查询的代码：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.execute("SELECT SingerId, AlbumId, MarketingBudget FROM Albums").rows.each do |row| puts "#{row[:SingerId]} #{row[:AlbumId]} #{row[:MarketingBudget]}" end

如需执行此查询，请使用 query_data_with_new_column 参数运行示例。

bundle exec ruby spanner_samples.rb query_data_with_new_column test-instance example-db

您应该会看到：

1 1 100000 1 2 2 1 2 2 500000 2 3

更新数据

您可以在读写事务中使用 DML 来更新数据。

使用 execute_update() 方法来执行 DML 语句。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner         = Google::Cloud::Spanner.new project: project_id client          = spanner.client instance_id, database_id transfer_amount = 200_000

client.transaction do |transaction| first_album = transaction.execute( "SELECT MarketingBudget from Albums WHERE SingerId = 1 and AlbumId = 1" ).rows.first second_album = transaction.execute( "SELECT MarketingBudget from Albums WHERE SingerId = 2 and AlbumId = 2" ).rows.first raise "The second album does not have enough funds to transfer" if second_album[:MarketingBudget] < transfer_amount

new_first_album_budget  = first_album[:MarketingBudget] + transfer_amount new_second_album_budget = second_album[:MarketingBudget] - transfer_amount

transaction.execute_update( "UPDATE Albums SET MarketingBudget = @albumBudget WHERE SingerId = 1 and AlbumId = 1", params: { albumBudget: new_first_album_budget } ) transaction.execute_update( "UPDATE Albums SET MarketingBudget = @albumBudget WHERE SingerId = 2 and AlbumId = 2", params: { albumBudget: new_second_album_budget } ) end

puts "Transaction complete"

使用 write_with_transaction_using_dml 参数运行示例。

bundle exec ruby spanner_samples.rb write_with_transaction_using_dml test-instance example-db

您应该会看到：

Transaction complete

注意：您还可以使用变更来更新数据。

使用二级索引

假设您想要提取 Albums 表中 AlbumTitle 值在特定范围内的所有行。您可以使用 SQL 语句或读取调用读取 AlbumTitle 列中的所有值，然后舍弃不符合条件的行。不过，执行全表扫描费用高昂，特别是对内含大量行的表来说更是如此。相反，如果对表创建二级索引，按非主键列进行搜索，则可以提高行检索速度。

向现有表添加二级索引需要更新架构。与其他架构更新一样，Spanner 支持在数据库继续处理流量的同时添加索引。Spanner 会使用您的现有数据自动回填索引。回填可能需要几分钟时间才能完成，但在此过程中，您无需使数据库离线，也无需避免写入已编入索引的表。如需了解详情，请参阅添加二级索引。

添加二级索引后，Spanner 会自动使用该索引进行 SQL 查询，使用该索引后，查询运行速度可能会提高。如果使用读取接口，则必须指定要使用的索引。

添加二级索引

您可以使用 gcloud CLI 在命令行中添加索引，也可以使用 Ruby 版 Spanner 客户端库以编程方式添加索引。

在命令行中

使用以下 CREATE INDEX 命令向数据库添加索引：

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)'

您应该会看到：

Schema updating...done.

使用 Ruby 版 Spanner 客户端库

使用 Database 类的 Database#update 方法来添加索引：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

database_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

db_path = database_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = database_admin_client.update_database_ddl database: db_path, statements: [ "CREATE INDEX AlbumsByAlbumTitle ON Albums(AlbumTitle)" ]

puts "Waiting for database update to complete"

job.wait_until_done!

puts "Added the AlbumsByAlbumTitle index"

使用 create_index 参数运行示例。

bundle exec ruby spanner_samples.rb create_index test-instance example-db

添加索引可能需要几分钟时间。添加索引后，您应该会看到：

Added the AlbumsByAlbumTitle index

使用索引进行读取

对于 SQL 查询，Spanner 会自动使用适当的索引。在读取接口中，您必须在请求中指定索引。

如需在读取接口中使用索引，请向 Client 类的 read 方法提供 index 参数。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

result = client.read "Albums", [:AlbumId, :AlbumTitle], index: "AlbumsByAlbumTitle"

result.rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]}" end

使用 read_data_with_index 参数运行示例。

bundle exec ruby spanner_samples.rb read_data_with_index test-instance example-db

您应该会看到：

2 Forever Hold Your Peace 2 Go, Go, Go 1 Green 3 Terrified 1 Total Junk

添加索引以进行纯索引读取

您可能已经注意到，上面的读取示例不包括读取 MarketingBudget 列。这是因为，Spanner 的读取接口不支持将索引与数据表联接来查找未存储在索引中的值。

请创建 AlbumsByAlbumTitle 的备用定义，用于将 MarketingBudget 的副本存储到索引中。

在命令行中

GoogleSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) STORING (MarketingBudget)

PostgreSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) INCLUDE (MarketingBudget)

添加索引可能需要几分钟时间。添加索引后，您应该会看到：

Schema updating...done.

使用 Ruby 版 Spanner 客户端库

使用 Database 类的 Database#update 方法来添加带 STORING 子句的索引：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

database_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

db_path = database_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = database_admin_client.update_database_ddl database: db_path, statements: [ "CREATE INDEX AlbumsByAlbumTitle2 ON Albums(AlbumTitle) STORING (MarketingBudget)" ]

puts "Waiting for database update to complete"

job.wait_until_done!

puts "Added the AlbumsByAlbumTitle2 storing index"

使用 create_storing_index 参数运行示例。

bundle exec ruby spanner_samples.rb create_storing_index test-instance example-db

您应该会看到：

Added the AlbumsByAlbumTitle2 index

现在，当您执行读取操作时便可从 AlbumsByAlbumTitle2 索引中提取所有 AlbumId、AlbumTitle 和 MarketingBudget 列：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

result = client.read "Albums", [:AlbumId, :AlbumTitle, :MarketingBudget], index: "AlbumsByAlbumTitle2"

result.rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]} #{row[:MarketingBudget]}" end

使用 read_data_with_storing_index 参数运行示例。

bundle exec ruby spanner_samples.rb read_data_with_storing_index test-instance example-db

您看到的输出结果应该类似于以下内容：

2 Forever Hold Your Peace 300000 2 Go, Go, Go 1 Green 3 Terrified 1 Total Junk 300000

使用只读事务检索数据

假设您要在同一时间戳执行多个读取操作。只读事务会观察事务提交记录的一致前缀，以便应用始终获得一致的数据。

使用 Snapshot 对象执行只读事务。使用 Client 类的 snapshot 方法来获取 Snapshot 对象。
下面演示了如何运行查询并在同一只读事务中执行读取操作：

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client  = spanner.client instance_id, database_id

client.snapshot do |snapshot| snapshot.execute("SELECT SingerId, AlbumId, AlbumTitle FROM Albums").rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]} #{row[:SingerId]}" end

  # Even if changes occur in-between the reads, the transaction ensures that
  # both return the same data.
snapshot.read("Albums", [:AlbumId, :AlbumTitle, :SingerId]).rows.each do |row| puts "#{row[:AlbumId]} #{row[:AlbumTitle]} #{row[:SingerId]}" end end

使用 read_only_transaction 参数运行示例。

bundle exec ruby spanner_samples.rb read_only_transaction test-instance example-db

您看到的输出结果应该类似于以下内容：

2 Forever Hold Your Peace 2 2 Go, Go, Go 1 1 Green 2 3 Terrified 2 1 Total Junk 1 1 Total Junk 1 2 Go, Go, Go 1 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified 2

清理

为避免因本教程中使用的资源导致您的 Google Cloud 账号产生额外费用，请删除数据库和您创建的实例。

删除数据库

如果您删除一个实例，则该实例中的所有数据库都会自动删除。
本步骤演示了如何在不删除实例的情况下删除数据库（您仍需为该实例付费）。

在命令行中

gcloud spanner databases delete example-db --instance=test-instance

使用 Google Cloud 控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击实例。

点击您想删除的数据库。

在数据库详细信息页面中，点击删除。

确认您要删除数据库并点击删除。

删除实例

删除实例会自动删除在该实例中创建的所有数据库。

在命令行中

gcloud spanner instances delete test-instance

使用 Google Cloud 控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击您的实例。

点击删除。

确认您要删除实例并点击删除。

后续步骤

了解如何使用虚拟机实例访问 Spanner。

在使用客户端库向 Cloud 服务进行身份验证中了解授权和身份验证凭证。

详细了解 Spanner 架构设计最佳实践。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2025-12-17。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2025-12-17。"],[],[]]

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
