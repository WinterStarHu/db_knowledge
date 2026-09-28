# Spanner 使用入门 (Go database/sql)  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/getting-started/database_sql

Spanner 使用入门 (Go database/sql)  |  Google Cloud Documentation

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

Spanner 使用入门 (Go database/sql)

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

目标

本教程将介绍如何使用 Spanner database/sql 驱动程序完成以下步骤：

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

准备本地 database/sql 环境

在开发机器上下载并安装 Go（如果尚未安装）。

将示例代码库克隆到您的本地机器：

git clone https://github.com/googleapis/go-sql-spanner.git

切换到包含 Spanner 示例代码的目录：

cd go-sql-spanner/snippets

创建实例

在首次使用 Spanner 时，必须创建一个实例，实例是 Spanner 数据库使用的资源分配单位。创建实例时，请选择一个实例配置（决定数据的存储位置），同时选择要使用的节点数（决定实例中服务资源和存储资源的数量）。

如需了解如何使用以下任一方法创建 Spanner 实例，请参阅创建实例。您可以将实例命名为 test-instance，以便将其用于本文档中引用名为 test-instance 的实例的其他主题。

Google Cloud CLI

Google Cloud 控制台

客户端库（C++、C#、Go、Java、Node.js、PHP、Python 或 Ruby）

浏览示例文件

示例仓库包含一个示例，展示了如何将 Spanner 与 database/sql 搭配使用。

请浏览 getting_started_guide.go 文件，其中说明了如何使用 Spanner。代码展示了如何创建和使用新数据库。数据使用架构和数据模型页面中显示的示例架构。

创建数据库

GoogleSQL

gcloud spanner databases create example-db --instance=test-instance

PostgreSQL

gcloud spanner databases create example-db --instance=test-instance \ --database-dialect=POSTGRESQL

您应该会看到：

Creating database...done.

创建表

以下代码会在数据库中创建两个表。

注意：后续的代码示例会使用这两个表。如果您不执行此代码，请使用 Google Cloud 控制台或 gcloud CLI 创建表。如需了解详情，请参阅示例架构。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func CreateTables(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Create two tables in one batch on Spanner.
conn, err := db.Conn(ctx) defer conn.Close()

// Start a DDL batch on the connection.
// This instructs the connection to buffer all DDL statements until the // command `run batch` is executed.
if _, err := conn.ExecContext(ctx, "start batch ddl"); err != nil { return err } if _, err := conn.ExecContext(ctx, `CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX) ) PRIMARY KEY (SingerId)`); err != nil { return err } if _, err := conn.ExecContext(ctx, `CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE`); err != nil { return err } // `run batch` sends the DDL statements to Spanner and blocks until // all statements have finished executing.
if _, err := conn.ExecContext(ctx, "run batch"); err != nil { return err }

fmt.Fprintf(w, "Created Singers & Albums tables in database: [%s]\n", databaseName) return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func CreateTablesPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Create two tables in one batch on Spanner PostgreSQL.
conn, err := db.Conn(ctx) if err != nil { return err } defer func() { _ = conn.Close() }()

// Start a DDL batch on the connection.
// This instructs the connection to buffer all DDL statements until the // command `run batch` is executed.
if _, err := conn.ExecContext(ctx, "start batch ddl"); err != nil { return err } if _, err := conn.ExecContext(ctx, `create table singers ( singer_id   bigint not null primary key, first_name  varchar(1024), last_name   varchar(1024), singer_info bytea )`); err != nil { return err } if _, err := conn.ExecContext(ctx, `create table albums ( singer_id     bigint not null, album_id      bigint not null, album_title   varchar, primary key (singer_id, album_id) ) interleave in parent singers on delete cascade`); err != nil { return err } // `run batch` sends the DDL statements to Spanner and blocks until // all statements have finished executing.
if _, err := conn.ExecContext(ctx, "run batch"); err != nil { return err }

_, _ = fmt.Fprintf(w, "Created singers & albums tables in database: [%s]\n", databaseName) return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go createtables projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go createtablespg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

下一步是将数据写入数据库。

创建连接

您必须先创建一个 sql.DB，然后才能执行读写操作。sql.DB 包含一个连接池，可用于与 Spanner 进行交互。数据库名称和其他连接属性在 database/sql 数据源名称中指定。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func CreateConnection(ctx context.Context, w io.Writer, databaseName string) error { // The dataSourceName should start with a fully qualified Spanner database name // in the format `projects/my-project/instances/my-instance/databases/my-database`.
// Additional properties can be added after the database name by // adding one or more `;name=value` pairs.

dsn := fmt.Sprintf("%s;numChannels=8", databaseName) db, err := sql.Open("spanner", dsn) if err != nil { return err } defer db.Close()

row := db.QueryRowContext(ctx, "select 'Hello world!' as hello") var msg string if err := row.Scan(&msg); err != nil { return err } fmt.Fprintf(w, "Greeting from Spanner: %s\n", msg) return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func CreateConnectionPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { // The dataSourceName should start with a fully qualified Spanner database name // in the format `projects/my-project/instances/my-instance/databases/my-database`.
// Additional properties can be added after the database name by // adding one or more `;name=value` pairs.

dsn := fmt.Sprintf("%s;numChannels=8", databaseName) db, err := sql.Open("spanner", dsn) if err != nil { return err } defer func() { _ = db.Close() }()

// The Spanner database/sql driver supports both PostgreSQL-style query // parameters ($1, $2, ...) and positional query parameters (?, ?, ...).
row := db.QueryRowContext(ctx, "select $1 as hello", "Hello world!") var msg string if err := row.Scan(&msg); err != nil { return err } _, _ = fmt.Fprintf(w, "Greeting from Spanner PostgreSQL: %s\n", msg) return nil }

使用 DML 写入数据

您可以在读写事务中使用数据操纵语言 (DML) 插入数据。

使用 ExecContext 函数来执行 DML 语句。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func WriteDataWithDml(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Add 4 rows in one statement.
// The database/sql driver supports positional query parameters.
res, err := db.ExecContext(ctx, "INSERT INTO Singers (SingerId, FirstName, LastName) "+ "VALUES (?, ?, ?), (?, ?, ?), "+ "       (?, ?, ?), (?, ?, ?)", 12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw") if err != nil { return err } c, err := res.RowsAffected() if err != nil { return err } fmt.Fprintf(w, "%v records inserted\n", c)

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func WriteDataWithDmlPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Add 4 rows in one statement.
// The database/sql driver supports positional query parameters.
res, err := db.ExecContext(ctx, "insert into singers (singer_id, first_name, last_name) "+ "values (?, ?, ?), (?, ?, ?), "+ "       (?, ?, ?), (?, ?, ?)", 12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw") if err != nil { return err } c, err := res.RowsAffected() if err != nil { return err } _, _ = fmt.Fprintf(w, "%v records inserted\n", c)

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go dmlwrite projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go dmlwritepg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

4 records inserted.

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用变更写入数据

您还可以使用变更插入数据。

Mutation 是用于变更操作的容器。Mutation 表示插入、更新和删除等一系列操作，Spanner 将这些操作以原子方式应用于 Spanner 数据库中不同的行和表。

使用 Mutation.InsertOrUpdate() 构建 INSERT_OR_UPDATE 变更，该变更会添加新行或更新列值（如果该行已经存在）。或者，使用 Mutation.Insert() 方法构建 INSERT 变更，该变更会添加新行。

使用 conn.Raw 函数可获取对底层 Spanner 连接的引用。SpannerConn.Apply 函数以原子方式将变更应用于数据库。

以下代码演示了如何使用变更写入数据：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func WriteDataWithMutations(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Get a connection so that we can get access to the Spanner specific // connection interface SpannerConn.
conn, err := db.Conn(ctx) if err != nil { return err } defer conn.Close()

singerColumns := []string{"SingerId", "FirstName", "LastName"} albumColumns := []string{"SingerId", "AlbumId", "AlbumTitle"} mutations := []*spanner.Mutation{ spanner.Insert("Singers", singerColumns, []interface{}{int64(1), "Marc", "Richards"}), spanner.Insert("Singers", singerColumns, []interface{}{int64(2), "Catalina", "Smith"}), spanner.Insert("Singers", singerColumns, []interface{}{int64(3), "Alice", "Trentor"}), spanner.Insert("Singers", singerColumns, []interface{}{int64(4), "Lea", "Martin"}), spanner.Insert("Singers", singerColumns, []interface{}{int64(5), "David", "Lomond"}), spanner.Insert("Albums", albumColumns, []interface{}{int64(1), int64(1), "Total Junk"}), spanner.Insert("Albums", albumColumns, []interface{}{int64(1), int64(2), "Go, Go, Go"}), spanner.Insert("Albums", albumColumns, []interface{}{int64(2), int64(1), "Green"}), spanner.Insert("Albums", albumColumns, []interface{}{int64(2), int64(2), "Forever Hold Your Peace"}), spanner.Insert("Albums", albumColumns, []interface{}{int64(2), int64(3), "Terrified"}), } // Mutations can be written outside an explicit transaction using SpannerConn#Apply.
if err := conn.Raw(func(driverConn interface{}) error { spannerConn, ok := driverConn.(spannerdriver.SpannerConn) if !ok { return fmt.Errorf("unexpected driver connection %v, expected SpannerConn", driverConn) } _, err = spannerConn.Apply(ctx, mutations) return err }); err != nil { return err } fmt.Fprintf(w, "Inserted %v rows\n", len(mutations))

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func WriteDataWithMutationsPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Get a connection so that we can get access to the Spanner specific // connection interface SpannerConn.
conn, err := db.Conn(ctx) if err != nil { return err } defer func() { _ = conn.Close() }()

singerColumns := []string{"singer_id", "first_name", "last_name"} albumColumns := []string{"singer_id", "album_id", "album_title"} mutations := []*spanner.Mutation{ spanner.Insert("singers", singerColumns, []interface{}{int64(1), "Marc", "Richards"}), spanner.Insert("singers", singerColumns, []interface{}{int64(2), "Catalina", "Smith"}), spanner.Insert("singers", singerColumns, []interface{}{int64(3), "Alice", "Trentor"}), spanner.Insert("singers", singerColumns, []interface{}{int64(4), "Lea", "Martin"}), spanner.Insert("singers", singerColumns, []interface{}{int64(5), "David", "Lomond"}), spanner.Insert("albums", albumColumns, []interface{}{int64(1), int64(1), "Total Junk"}), spanner.Insert("albums", albumColumns, []interface{}{int64(1), int64(2), "Go, Go, Go"}), spanner.Insert("albums", albumColumns, []interface{}{int64(2), int64(1), "Green"}), spanner.Insert("albums", albumColumns, []interface{}{int64(2), int64(2), "Forever Hold Your Peace"}), spanner.Insert("albums", albumColumns, []interface{}{int64(2), int64(3), "Terrified"}), } // Mutations can be written outside an explicit transaction using SpannerConn#Apply.
if err := conn.Raw(func(driverConn interface{}) error { spannerConn, ok := driverConn.(spannerdriver.SpannerConn) if !ok { return fmt.Errorf("unexpected driver connection %v, expected SpannerConn", driverConn) } _, err = spannerConn.Apply(ctx, mutations) return err }); err != nil { return err } _, _ = fmt.Fprintf(w, "Inserted %v rows\n", len(mutations))

return nil }

使用 write 参数运行以下示例：

GoogleSQL

go run getting_started_guide.go write projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go writepg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用 SQL 查询数据

Spanner 支持使用 SQL 接口读取数据，您可以使用 Google Cloud CLI 在命令行中访问该接口，也可以使用 Spanner database/sql 驱动程序以编程方式访问该接口。

在命令行中

执行以下 SQL 语句，读取 Albums 表中所有列的值：

GoogleSQL

gcloud spanner databases execute-sql example-db --instance=test-instance \ --sql='SELECT SingerId, AlbumId, AlbumTitle FROM Albums'

PostgreSQL

gcloud spanner databases execute-sql example-db --instance=test-instance \ --sql='SELECT singer_id, album_id, album_title FROM albums'

注意：如需查看 GoogleSQL 参考文档，请参阅 GoogleSQL 中的查询语法；如需查看 PostgreSQL 参考文档，请参阅 PostgreSQL 词汇结构和语法。

结果会显示以下内容：

SingerId AlbumId AlbumTitle 1        1       Total Junk 1        2       Go, Go, Go 2        1       Green 2        2       Forever Hold Your Peace 2        3       Terrified

使用 Spanner database/sql 驱动程序

除了在命令行中执行 SQL 语句外，还可以使用 Spanner database/sql 驱动程序以编程方式发出相同的 SQL 语句。

以下函数和结构体用于执行 SQL 查询：

DB 结构体中的 QueryContext 函数：使用此函数可执行会返回行的 SQL 语句，例如包含 THEN RETURN 子句的查询或 DML 语句。

Rows 结构体：使用此结构体可访问由 SQL 语句返回的数据。

以下示例使用 QueryContext 函数：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryData(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

rows, err := db.QueryContext(ctx, `SELECT SingerId, AlbumId, AlbumTitle FROM Albums ORDER BY SingerId, AlbumId`) defer rows.Close() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var title string err = rows.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryDataPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

rows, err := db.QueryContext(ctx, `select singer_id, album_id, album_title from albums order by singer_id, album_id`) defer func() { _ = rows.Close() }() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var title string err = rows.Scan(&singerId, &albumId, &title) if err != nil { return err } _, _ = fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go query projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go querypg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified

使用 SQL 参数进行查询

如果您的应用具有频繁执行的查询，您可以通过将其参数化来提高其性能。生成的参数查询可以缓存下来并重复使用，这样做可以降低编译开销。如需了解详情，请参阅使用查询参数来加快频繁执行的查询的运行速度。

以下示例演示了如何在 WHERE 子句中使用参数来查询包含特定 LastName 值的记录。

Spanner database/sql 驱动程序支持位置查询参数和命名查询参数。SQL 语句中的 ? 表示位置查询参数。将查询参数值作为其他参数传递给 QueryContext 函数。例如：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryDataWithParameter(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

rows, err := db.QueryContext(ctx, `SELECT SingerId, FirstName, LastName FROM Singers WHERE LastName = ?`, "Garcia") defer rows.Close() if err != nil { return err } for rows.Next() { var singerId int64 var firstName, lastName string err = rows.Scan(&singerId, &firstName, &lastName) if err != nil { return err } fmt.Fprintf(w, "%v %v %v\n", singerId, firstName, lastName) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryDataWithParameterPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

rows, err := db.QueryContext(ctx, `select singer_id, first_name, last_name from singers where last_name = ?`, "Garcia") defer func() { _ = rows.Close() }() if err != nil { return err } for rows.Next() { var singerId int64 var firstName, lastName string err = rows.Scan(&singerId, &firstName, &lastName) if err != nil { return err } _, _ = fmt.Fprintf(w, "%v %v %v\n", singerId, firstName, lastName) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go querywithparameter projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go querywithparameterpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

12 Melissa Garcia

更新数据库架构

假设您需要将名为 MarketingBudget 的新列添加到 Albums 表。向现有表添加新列需要更新数据库架构。Spanner 支持在数据库继续处理流量的同时，对数据库进行架构更新。架构更新不需要使数据库离线，并且不会锁定整个表或列；在架构更新期间，您可以继续将数据写入数据库。如需详细了解支持的架构更新和架构更改性能，请参阅更新架构。

添加列

您可以使用 Google Cloud CLI 在命令行中添加列，也可以使用 Spanner database/sql 驱动程序以编程方式添加列。

在命令行中

使用以下 ALTER TABLE 命令向表添加新列：

GoogleSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='ALTER TABLE Albums ADD COLUMN MarketingBudget INT64'

PostgreSQL

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='alter table albums add column marketing_budget bigint'

您应该会看到：

Schema updating...done.

使用 Spanner database/sql 驱动程序

使用 ExecContext 函数修改架构：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func AddColumn(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

_, err = db.ExecContext(ctx, `ALTER TABLE Albums ADD COLUMN MarketingBudget INT64`) if err != nil { return err }

fmt.Fprint(w, "Added MarketingBudget column\n") return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func AddColumnPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

_, err = db.ExecContext(ctx, `alter table albums add column marketing_budget bigint`) if err != nil { return err }

_, _ = fmt.Fprint(w, "Added marketing_budget column\n") return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go addcolumn projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go addcolumnpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

Added MarketingBudget column.

执行 DDL 批处理

我们建议您在一个批处理操作中执行多个架构修改。使用 START BATCH DDL 和 RUN BATCH 命令可执行 DDL 批处理。以下示例会在一个批处理操作中创建两个表：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func DdlBatch(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Executing multiple DDL statements as one batch is // more efficient than executing each statement // individually.
conn, err := db.Conn(ctx) defer conn.Close()

if _, err := conn.ExecContext(ctx, "start batch ddl"); err != nil { return err } if _, err := conn.ExecContext(ctx, `CREATE TABLE Venues ( VenueId     INT64 NOT NULL, Name        STRING(1024), Description JSON, ) PRIMARY KEY (VenueId)`); err != nil { return err } if _, err := conn.ExecContext(ctx, `CREATE TABLE Concerts ( ConcertId INT64 NOT NULL, VenueId   INT64 NOT NULL, SingerId  INT64 NOT NULL, StartTime TIMESTAMP, EndTime   TIMESTAMP, CONSTRAINT Fk_Concerts_Venues FOREIGN KEY (VenueId) REFERENCES Venues (VenueId), CONSTRAINT Fk_Concerts_Singers FOREIGN KEY (SingerId) REFERENCES Singers (SingerId), ) PRIMARY KEY (ConcertId)`); err != nil { return err } // `run batch` sends the DDL statements to Spanner and blocks until // all statements have finished executing.
if _, err := conn.ExecContext(ctx, "run batch"); err != nil { return err }

fmt.Fprint(w, "Added Venues and Concerts tables\n") return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func DdlBatchPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Executing multiple DDL statements as one batch is // more efficient than executing each statement // individually.
conn, err := db.Conn(ctx) defer func() { _ = conn.Close() }()

if _, err := conn.ExecContext(ctx, "start batch ddl"); err != nil { return err } if _, err := conn.ExecContext(ctx, `create table venues ( venue_id    bigint not null primary key, name        varchar(1024),
description jsonb
)`); err != nil { return err } if _, err := conn.ExecContext(ctx, `create table concerts ( concert_id bigint not null primary key, venue_id   bigint not null, singer_id  bigint not null, start_time timestamptz, end_time   timestamptz, constraint fk_concerts_venues foreign key (venue_id) references venues (venue_id), constraint fk_concerts_singers foreign key (singer_id) references singers (singer_id) )`); err != nil { return err } // `run batch` sends the DDL statements to Spanner and blocks until // all statements have finished executing.
if _, err := conn.ExecContext(ctx, "run batch"); err != nil { return err }

_, _ = fmt.Fprint(w, "Added venues and concerts tables\n") return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go ddlbatch projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go ddlbatchpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

Added Venues and Concerts tables.

将数据写入新列

以下代码可将数据写入新列。对于 Albums(1, 1) 键控的行，该代码会将 MarketingBudget 设置为 100000；而对于 Albums(2, 2) 键控的行，该代码会将其设置为 500000。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func UpdateDataWithMutations(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Get a connection so that we can get access to the Spanner specific // connection interface SpannerConn.
conn, err := db.Conn(ctx) if err != nil { return err } defer conn.Close()

cols := []string{"SingerId", "AlbumId", "MarketingBudget"} mutations := []*spanner.Mutation{ spanner.Update("Albums", cols, []interface{}{1, 1, 100000}), spanner.Update("Albums", cols, []interface{}{2, 2, 500000}), } if err := conn.Raw(func(driverConn interface{}) error { spannerConn, ok := driverConn.(spannerdriver.SpannerConn) if !ok { return fmt.Errorf("unexpected driver connection %v, "+ "expected SpannerConn", driverConn) } _, err = spannerConn.Apply(ctx, mutations) return err }); err != nil { return err } fmt.Fprintf(w, "Updated %v albums\n", len(mutations))

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func UpdateDataWithMutationsPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Get a connection so that we can get access to the Spanner specific // connection interface SpannerConn.
conn, err := db.Conn(ctx) if err != nil { return err } defer func() { _ = conn.Close() }()

cols := []string{"singer_id", "album_id", "marketing_budget"} mutations := []*spanner.Mutation{ spanner.Update("albums", cols, []interface{}{1, 1, 100000}), spanner.Update("albums", cols, []interface{}{2, 2, 500000}), } if err := conn.Raw(func(driverConn interface{}) error { spannerConn, ok := driverConn.(spannerdriver.SpannerConn) if !ok { return fmt.Errorf("unexpected driver connection %v, "+ "expected SpannerConn", driverConn) } _, err = spannerConn.Apply(ctx, mutations) return err }); err != nil { return err } _, _ = fmt.Fprintf(w, "Updated %v albums\n", len(mutations))

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go update projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go updatepg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

Updated 2 albums

您也可以执行 SQL 查询来获取刚刚写入的值。

以下示例使用 QueryContext 函数执行查询：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryNewColumn(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

rows, err := db.QueryContext(ctx, `SELECT SingerId, AlbumId, MarketingBudget FROM Albums ORDER BY SingerId, AlbumId`) defer rows.Close() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var marketingBudget sql.NullInt64 err = rows.Scan(&singerId, &albumId, &marketingBudget) if err != nil { return err } budget := "NULL" if marketingBudget.Valid { budget = fmt.Sprintf("%v", marketingBudget.Int64) } fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, budget) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func QueryNewColumnPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

rows, err := db.QueryContext(ctx, `select singer_id, album_id, marketing_budget from albums order by singer_id, album_id`) defer func() { _ = rows.Close() }() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var marketingBudget sql.NullInt64 err = rows.Scan(&singerId, &albumId, &marketingBudget) if err != nil { return err } budget := "null" if marketingBudget.Valid { budget = fmt.Sprintf("%v", marketingBudget.Int64) } _, _ = fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, budget) } if rows.Err() != nil { return rows.Err() } return rows.Close() }

如需执行此查询，请运行以下命令：

GoogleSQL

go run getting_started_guide.go querymarketingbudget projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go querymarketingbudgetpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

您应该会看到：

1 1 100000 1 2 null 2 1 null 2 2 500000 2 3 null

更新数据

您可以在读写事务中使用 DML 来更新数据。

调用 DB.BeginTx 可在 database/sql 中执行读写事务。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func WriteWithTransactionUsingDml(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Transfer marketing budget from one album to another. We do it in a // transaction to ensure that the transfer is atomic.
tx, err := db.BeginTx(ctx, &sql.TxOptions{}) if err != nil { return err } // The Spanner database/sql driver supports both positional and named // query parameters. This query uses named query parameters.
const selectSql = "SELECT MarketingBudget " + "FROM Albums " + "WHERE SingerId = @singerId and AlbumId = @albumId" // Get the marketing_budget of singer 2 / album 2.
row := tx.QueryRowContext(ctx, selectSql, sql.Named("singerId", 2), sql.Named("albumId", 2)) var budget2 int64 if err := row.Scan(&budget2); err != nil { tx.Rollback() return err } const transfer = 20000 // The transaction will only be committed if this condition still holds // at the time of commit. Otherwise, the transaction will be aborted.
if budget2 >= transfer { // Get the marketing_budget of singer 1 / album 1.
row := tx.QueryRowContext(ctx, selectSql, sql.Named("singerId", 1), sql.Named("albumId", 1)) var budget1 int64 if err := row.Scan(&budget1); err != nil { tx.Rollback() return err } // Transfer part of the marketing budget of Album 2 to Album 1.
budget1 += transfer budget2 -= transfer const updateSql = "UPDATE Albums " + "SET MarketingBudget = @budget " + "WHERE SingerId = @singerId and AlbumId = @albumId" // Start a DML batch and execute it as part of the current transaction.
if _, err := tx.ExecContext(ctx, "start batch dml"); err != nil { tx.Rollback() return err } if _, err := tx.ExecContext(ctx, updateSql, sql.Named("singerId", 1), sql.Named("albumId", 1), sql.Named("budget", budget1)); err != nil { _, _ = tx.ExecContext(ctx, "abort batch") tx.Rollback() return err } if _, err := tx.ExecContext(ctx, updateSql, sql.Named("singerId", 2), sql.Named("albumId", 2), sql.Named("budget", budget2)); err != nil { _, _ = tx.ExecContext(ctx, "abort batch") tx.Rollback() return err } // `run batch` sends the DML statements to Spanner.
// The result contains the total affected rows across the entire batch.
result, err := tx.ExecContext(ctx, "run batch") if err != nil { tx.Rollback() return err } if affected, err := result.RowsAffected(); err != nil { tx.Rollback() return err } else if affected != 2 { // The batch should update 2 rows.
tx.Rollback() return fmt.Errorf("unexpected number of rows affected: %v", affected) } } // Commit the current transaction.
if err := tx.Commit(); err != nil { return err }

fmt.Fprintln(w, "Transferred marketing budget from Album 2 to Album 1")

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func WriteWithTransactionUsingDmlPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Transfer marketing budget from one album to another. We do it in a // transaction to ensure that the transfer is atomic.
tx, err := db.BeginTx(ctx, &sql.TxOptions{}) if err != nil { return err } const selectSql = "select marketing_budget " + "from albums " + "where singer_id = $1 and album_id = $2" // Get the marketing_budget of singer 2 / album 2.
row := tx.QueryRowContext(ctx, selectSql, 2, 2) var budget2 int64 if err := row.Scan(&budget2); err != nil { _ = tx.Rollback() return err } const transfer = 20000 // The transaction will only be committed if this condition still holds // at the time of commit. Otherwise, the transaction will be aborted.
if budget2 >= transfer { // Get the marketing_budget of singer 1 / album 1.
row := tx.QueryRowContext(ctx, selectSql, 1, 1) var budget1 int64 if err := row.Scan(&budget1); err != nil { _ = tx.Rollback() return err } // Transfer part of the marketing budget of Album 2 to Album 1.
budget1 += transfer budget2 -= transfer const updateSql = "update albums " + "set marketing_budget = $1 " + "where singer_id = $2 and album_id = $3" // Start a DML batch and execute it as part of the current transaction.
if _, err := tx.ExecContext(ctx, "start batch dml"); err != nil { _ = tx.Rollback() return err } if _, err := tx.ExecContext(ctx, updateSql, budget1, 1, 1); err != nil { _, _ = tx.ExecContext(ctx, "abort batch") _ = tx.Rollback() return err } if _, err := tx.ExecContext(ctx, updateSql, budget2, 2, 2); err != nil { _, _ = tx.ExecContext(ctx, "abort batch") _ = tx.Rollback() return err } // `run batch` sends the DML statements to Spanner.
// The result contains the total affected rows across the entire batch.
result, err := tx.ExecContext(ctx, "run batch") if err != nil { _ = tx.Rollback() return err } if affected, err := result.RowsAffected(); err != nil { _ = tx.Rollback() return err } else if affected != 2 { // The batch should update 2 rows.
_ = tx.Rollback() return fmt.Errorf("unexpected number of rows affected: %v", affected) } } // Commit the current transaction.
if err := tx.Commit(); err != nil { return err }

_, _ = fmt.Fprintln(w, "Transferred marketing budget from Album 2 to Album 1")

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go writewithtransactionusingdml projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go writewithtransactionusingdmlpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

事务标记和请求标记

使用事务标记和请求标记可排查 Spanner 中的事务和查询问题。您可以将其他事务选项传递给 spannerdriver.BeginReadWriteTransaction 函数。

使用 spannerdriver.ExecOptions 可为 SQL 语句传递其他查询选项。例如：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func Tags(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Use the spannerdriver.BeginReadWriteTransaction function // to specify specific Spanner options, such as transaction tags.
tx, err := spannerdriver.BeginReadWriteTransaction(ctx, db, spannerdriver.ReadWriteTransactionOptions{ TransactionOptions: spanner.TransactionOptions{ TransactionTag: "example-tx-tag", }, }) if err != nil { return err }

// Pass in an argument of type spannerdriver.ExecOptions to supply // additional options for a statement.
row := tx.QueryRowContext(ctx, "SELECT MarketingBudget "+ "FROM Albums "+ "WHERE SingerId=? and AlbumId=?", spannerdriver.ExecOptions{ QueryOptions: spanner.QueryOptions{RequestTag: "query-marketing-budget"}, }, 1, 1) var budget int64 if err := row.Scan(&budget); err != nil { tx.Rollback() return err }

// Reduce the marketing budget by 10% if it is more than 1,000.
if budget > 1000 { budget = int64(float64(budget) - float64(budget)*0.1) if _, err := tx.ExecContext(ctx, `UPDATE Albums SET MarketingBudget=@budget WHERE SingerId=@singerId AND AlbumId=@albumId`, spannerdriver.ExecOptions{ QueryOptions: spanner.QueryOptions{RequestTag: "reduce-marketing-budget"}, }, sql.Named("budget", budget), sql.Named("singerId", 1), sql.Named("albumId", 1)); err != nil { tx.Rollback() return err } } // Commit the current transaction.
if err := tx.Commit(); err != nil { return err } fmt.Fprintln(w, "Reduced marketing budget")

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func TagsPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Use the spannerdriver.BeginReadWriteTransaction function // to specify specific Spanner options, such as transaction tags.
tx, err := spannerdriver.BeginReadWriteTransaction(ctx, db, spannerdriver.ReadWriteTransactionOptions{ TransactionOptions: spanner.TransactionOptions{ TransactionTag: "example-tx-tag", }, }) if err != nil { return err }

// Pass in an argument of type spannerdriver.ExecOptions to supply // additional options for a statement.
row := tx.QueryRowContext(ctx, "select marketing_budget "+ "from albums "+ "where singer_id=? and album_id=?", spannerdriver.ExecOptions{ QueryOptions: spanner.QueryOptions{RequestTag: "query-marketing-budget"}, }, 1, 1) var budget int64 if err := row.Scan(&budget); err != nil { _ = tx.Rollback() return err }

// Reduce the marketing budget by 10% if it is more than 1,000.
if budget > 1000 { budget = int64(float64(budget) - float64(budget)*0.1) if _, err := tx.ExecContext(ctx, `update albums set marketing_budget=$1 where singer_id=$2 and album_id=$3`, spannerdriver.ExecOptions{ QueryOptions: spanner.QueryOptions{RequestTag: "reduce-marketing-budget"}, }, budget, 1, 1); err != nil { _ = tx.Rollback() return err } } // Commit the current transaction.
if err := tx.Commit(); err != nil { return err } _, _ = fmt.Fprintln(w, "Reduced marketing budget")

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go tags projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go tagspg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

使用只读事务检索数据

假设您要在同一时间戳执行多个读取操作。只读事务会遵从一致的事务提交历史记录前缀，因此您的应用始终可获得一致的数据。

将 TxOptions.ReadOnly 字段设置为 true 可执行只读事务。

下面演示了如何运行查询并在同一只读事务中执行读取操作：

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func ReadOnlyTransaction(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Start a read-only transaction by supplying additional transaction options.
tx, err := db.BeginTx(ctx, &sql.TxOptions{ReadOnly: true})

albumsOrderedById, err := tx.QueryContext(ctx, `SELECT SingerId, AlbumId, AlbumTitle FROM Albums ORDER BY SingerId, AlbumId`) defer albumsOrderedById.Close() if err != nil { return err } for albumsOrderedById.Next() { var singerId, albumId int64 var title string err = albumsOrderedById.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) }

albumsOrderedTitle, err := tx.QueryContext(ctx, `SELECT SingerId, AlbumId, AlbumTitle FROM Albums ORDER BY AlbumTitle`) defer albumsOrderedTitle.Close() if err != nil { return err } for albumsOrderedTitle.Next() { var singerId, albumId int64 var title string err = albumsOrderedTitle.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) }

// End the read-only transaction by calling Commit.
return tx.Commit() }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func ReadOnlyTransactionPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Start a read-only transaction by supplying additional transaction options.
tx, err := db.BeginTx(ctx, &sql.TxOptions{ReadOnly: true}) if err != nil { return err }

albumsOrderedById, err := tx.QueryContext(ctx, `select singer_id, album_id, album_title from albums order by singer_id, album_id`) defer func() { _ = albumsOrderedById.Close() }() if err != nil { return err } for albumsOrderedById.Next() { var singerId, albumId int64 var title string err = albumsOrderedById.Scan(&singerId, &albumId, &title) if err != nil { return err } _, _ = fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) }

albumsOrderedTitle, err := tx.QueryContext(ctx, `select singer_id, album_id, album_title from albums order by album_title`) defer func() { _ = albumsOrderedTitle.Close() }() if err != nil { return err } for albumsOrderedTitle.Next() { var singerId, albumId int64 var title string err = albumsOrderedTitle.Scan(&singerId, &albumId, &title) if err != nil { return err } _, _ = fmt.Fprintf(w, "%v %v %v\n", singerId, albumId, title) }

// End the read-only transaction by calling Commit.
return tx.Commit() }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go readonlytransaction projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go readonlytransactionpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

结果会显示以下内容：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified 2 2 Forever Hold Your Peace 1 2 Go, Go, Go 2 1 Green 2 3 Terrified 1 1 Total Junk

分区查询和 Data Boost

partitionQuery API 会将查询划分为较小部分（即分区），并使用多台机器并行提取这些分区。每个分区都由一个分区令牌标识。partitionQuery API 的延迟时间比标准查询 API 更长，因为它仅适用于批量操作，例如导出或扫描整个数据库。

Data Boost 使您可以执行分析查询和数据导出操作，且对预配的 Spanner 实例上的现有工作负载几乎没有影响。
Data Boost 仅支持分区查询。

以下示例展示了如何使用 database/sql 驱动程序通过 Data Boost 执行分区查询：

GoogleSQL

import (
"context" "database/sql" "fmt" "io" "slices"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func DataBoost(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

// Run a partitioned query that uses Data Boost.
rows, err := db.QueryContext(ctx, "SELECT SingerId, FirstName, LastName from Singers", spannerdriver.ExecOptions{ PartitionedQueryOptions: spannerdriver.PartitionedQueryOptions{ // AutoPartitionQuery instructs the Spanner database/sql driver to // automatically partition the query and execute each partition in parallel.
// The rows are returned as one result set in undefined order.
AutoPartitionQuery: true, }, QueryOptions: spanner.QueryOptions{ // Set DataBoostEnabled to true to enable DataBoost.
// See https://cloud.google.com/spanner/docs/databoost/databoost-overview // for more information.
DataBoostEnabled: true, }, }) defer rows.Close() if err != nil { return err } type Singer struct { SingerId  int64 FirstName string LastName  string } var singers []Singer for rows.Next() { var singer Singer err = rows.Scan(&singer.SingerId, &singer.FirstName, &singer.LastName) if err != nil { return err } singers = append(singers, singer) } // Queries that use the AutoPartition option return rows in undefined order, // so we need to sort them in memory to guarantee the output order.
slices.SortFunc(singers, func(a, b Singer) int { return int(a.SingerId - b.SingerId) }) for _, s := range singers { fmt.Fprintf(w, "%v %v %v\n", s.SingerId, s.FirstName, s.LastName) }

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io" "slices"

"cloud.google.com/go/spanner" spannerdriver "github.com/googleapis/go-sql-spanner" )

func DataBoostPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

// Run a partitioned query that uses Data Boost.
rows, err := db.QueryContext(ctx, "select singer_id, first_name, last_name from singers", spannerdriver.ExecOptions{ PartitionedQueryOptions: spannerdriver.PartitionedQueryOptions{ // AutoPartitionQuery instructs the Spanner database/sql driver to // automatically partition the query and execute each partition in parallel.
// The rows are returned as one result set in undefined order.
AutoPartitionQuery: true, }, QueryOptions: spanner.QueryOptions{ // Set DataBoostEnabled to true to enable DataBoost.
// See https://cloud.google.com/spanner/docs/databoost/databoost-overview // for more information.
DataBoostEnabled: true, }, }) defer func() { _ = rows.Close() }() if err != nil { return err } type Singer struct { SingerId  int64 FirstName string LastName  string } var singers []Singer for rows.Next() { var singer Singer err = rows.Scan(&singer.SingerId, &singer.FirstName, &singer.LastName) if err != nil { return err } singers = append(singers, singer) } // Queries that use the AutoPartition option return rows in undefined order, // so we need to sort them in memory to guarantee the output order.
slices.SortFunc(singers, func(a, b Singer) int { return int(a.SingerId - b.SingerId) }) for _, s := range singers { _, _ = fmt.Fprintf(w, "%v %v %v\n", s.SingerId, s.FirstName, s.LastName) }

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go databoost projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go databoostpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

分区 DML

分区数据操纵语言 (DML) 旨在用于以下类型的批量更新和删除：

定期清理和垃圾回收。

使用默认值回填新列。

GoogleSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func PartitionedDml(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer db.Close()

conn, err := db.Conn(ctx) if err != nil { return err } // Enable Partitioned DML on this connection.
if _, err := conn.ExecContext(ctx, "SET AUTOCOMMIT_DML_MODE='PARTITIONED_NON_ATOMIC'"); err != nil { return fmt.Errorf("failed to change DML mode to Partitioned_Non_Atomic: %v", err) } // Back-fill a default value for the MarketingBudget column.
res, err := conn.ExecContext(ctx, "UPDATE Albums SET MarketingBudget=0 WHERE MarketingBudget IS NULL") if err != nil { return err } affected, err := res.RowsAffected() if err != nil { return fmt.Errorf("failed to get affected rows: %v", err) }

// Partitioned DML returns the minimum number of records that were affected.
fmt.Fprintf(w, "Updated at least %v albums\n", affected)

// Closing the connection will return it to the connection pool. The DML mode will automatically be reset to the // default TRANSACTIONAL mode when the connection is returned to the pool, so we do not need to change it back // manually.
_ = conn.Close()

return nil }

PostgreSQL

import (
"context" "database/sql" "fmt" "io"

_ "github.com/googleapis/go-sql-spanner" )

func PartitionedDmlPostgreSQL(ctx context.Context, w io.Writer, databaseName string) error { db, err := sql.Open("spanner", databaseName) if err != nil { return err } defer func() { _ = db.Close() }()

conn, err := db.Conn(ctx) if err != nil { return err } // Enable Partitioned DML on this connection.
if _, err := conn.ExecContext(ctx, "set autocommit_dml_mode='partitioned_non_atomic'"); err != nil { return fmt.Errorf("failed to change DML mode to Partitioned_Non_Atomic: %v", err) } // Back-fill a default value for the marketing_budget column.
res, err := conn.ExecContext(ctx, "update albums set marketing_budget=0 where marketing_budget is null") if err != nil { return err } affected, err := res.RowsAffected() if err != nil { return fmt.Errorf("failed to get affected rows: %v", err) }

// Partitioned DML returns the minimum number of records that were affected.
_, _ = fmt.Fprintf(w, "Updated at least %v albums\n", affected)

// Closing the connection will return it to the connection pool. The DML mode will automatically be reset to the // default TRANSACTIONAL mode when the connection is returned to the pool, so we do not need to change it back // manually.
_ = conn.Close()

return nil }

使用以下命令运行示例：

GoogleSQL

go run getting_started_guide.go pdml projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

PostgreSQL

go run getting_started_guide.go pdmlpg projects/GCLOUD_PROJECT/instances/test-instance/databases/example-db

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
