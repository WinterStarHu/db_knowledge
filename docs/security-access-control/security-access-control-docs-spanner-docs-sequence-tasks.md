# 创建和管理序列  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/sequence-tasks

创建和管理序列  |  Spanner  |  Google Cloud Documentation

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

创建和管理序列

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何使用数据定义语言 (DDL) 语句在 Spanner 中创建、更改和删除序列。您还可以了解如何在默认值中使用序列来填充主键列。

请参阅完整的序列 DDL 语法参考文档（GoogleSQL 方言数据库和 PostgreSQL 方言数据库）。
注意：Spanner 现在支持自动生成的主键值。
如需了解详情，请参阅使用 Spanner 中自动生成的键大规模简化最佳实践。

创建序列

以下代码示例会创建序列 Seq，在表 Customers 的主键默认值中使用该序列，并向 Customers 表中插入三个新行。

GoogleSQL

C++

void CreateSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, google::cloud::spanner::Client client, std::string const& project_id, std::string const& instance_id, std::string const& database_id) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
std::vector statements;
statements.emplace_back(R"""( CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive') )""");
statements.emplace_back(R"""( CREATE TABLE Customers ( CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(SEQUENCE Seq)), CustomerName STRING(1024) ) PRIMARY KEY (CustomerId) )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Created `Seq` sequence and `Customers` table," << " where the key column `CustomerId`" << " uses the sequence as a default value," << " new DDL:\n" DebugString();
auto commit = client.Commit( [&client](google::cloud::spanner::Transaction txn) -> google::cloud::StatusOr { auto sql = google::cloud::spanner::SqlStatement(R"""( INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') THEN RETURN CustomerId )""");
using RowType = std::tuple;
auto rows = client.ExecuteQuery(std::move(txn), std::move(sql));
// Note: This mutator might be re-run, or its effects discarded, so // changing non-transactional state (e.g., by producing output) is, // in general, not something to be imitated.
for (auto& row : google::cloud::spanner::StreamOf(rows)) { if (!row) return std::move(row).status();
std::cout << "Inserted customer record with CustomerId: " (*row) << "\n";
} std::cout << "Number of customer records inserted is: " << rows.RowsModified() << "\n";
return google::cloud::spanner::Mutations{};
});
if (!commit) throw std::move(commit).status();
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.Cloud.Spanner.Data;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public class CreateSequenceSample { public async Task> CreateSequenceAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();

DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", "CREATE TABLE Customers (CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(SEQUENCE Seq)), CustomerName STRING(1024)) PRIMARY KEY (CustomerId)" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);

var completedResponse = await operation.PollUntilCompletedAsync();

if (completedResponse.IsFaulted) { throw completedResponse.Exception;
}

Console.WriteLine("Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value");

string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
await connection.OpenAsync();

using var cmd = connection.CreateDmlCommand( @"INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') THEN RETURN CustomerId");

var reader = await cmd.ExecuteReaderAsync();
var customerIds = new List();
while (await reader.ReadAsync()) { var customerId = reader.GetFieldValue("CustomerId");
Console.WriteLine($"Inserted customer record with CustomerId: {customerId}");
customerIds.Add(customerId);
} Console.WriteLine($"Number of customer records inserted is: {customerIds.Count}");
return customerIds;
} }

Go

import (
"context" "fmt" "io"

"cloud.google.com/go/spanner" database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/api/iterator" )

func createSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Create a sequence, and then use the sequence as auto generated primary key in Customers table.
ddl := []string{ "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", "CREATE TABLE Customers (CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(Sequence Seq)), CustomerName STRING(1024)) PRIMARY KEY (CustomerId)", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence creation to finish failed: %w", err) } fmt.Fprintf(w, "Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value\n")

client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

// Inserts records into the Customers table.
// The ReadWriteTransaction function returns the commit timestamp and an error.
// The commit timestamp is ignored in this case.
_, err = client.ReadWriteTransaction(ctx, func(ctx context.Context, txn *spanner.ReadWriteTransaction) error { stmt := spanner.Statement{ SQL: `INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') THEN RETURN CustomerId`, } iter := txn.Query(ctx, stmt) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } var customerId int64 if err := row.Columns(&customerId); err != nil { return err } fmt.Fprintf(w, "Inserted customer record with CustomerId: %d\n", customerId) } fmt.Fprintf(w, "Number of customer records inserted is: %d\n", iter.RowCount) return nil }) return err }

Java

import com.google.cloud.spanner.DatabaseClient;
import com.google.cloud.spanner.DatabaseId;
import com.google.cloud.spanner.ResultSet;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.Statement;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class CreateSequenceSample {

static void createSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
createSequence(projectId, instanceId, databaseId);
}

static void createSequence(String projectId, String instanceId, String databaseId) {

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { databaseAdminClient .updateDatabaseDdlAsync( DatabaseName.of(projectId, instanceId, databaseId), ImmutableList.of( "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", "CREATE TABLE Customers (CustomerId INT64 DEFAULT " + "(GET_NEXT_SEQUENCE_VALUE(SEQUENCE Seq)), CustomerName STRING(1024)) " + "PRIMARY KEY (CustomerId)")) .get(5, TimeUnit.MINUTES);

System.out.println( "Created Seq sequence and Customers table, where the key column CustomerId " + "uses the sequence as a default value");

final DatabaseClient dbClient = spanner.getDatabaseClient(DatabaseId.of(projectId, instanceId, databaseId));

Long insertCount = dbClient .readWriteTransaction() .run( transaction -> { try (ResultSet rs = transaction.executeQuery( Statement.of( "INSERT INTO Customers (CustomerName) VALUES " + "('Alice'), ('David'), ('Marc') THEN RETURN CustomerId"))) { while (rs.next()) { System.out.printf( "Inserted customer record with CustomerId: %d\n", rs.getLong(0));
} return Objects.requireNonNull(rs.getStats()).getRowCountExact();
} });
System.out.printf("Number of customer records inserted is: %d\n", insertCount);
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function createSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = [ "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", 'CREATE TABLE Customers (CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(Sequence Seq)), CustomerName STRING(1024)) PRIMARY KEY (CustomerId)', ];

// Creates a new table with sequence try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value.', );
} catch (err) { console.error('ERROR:', err);
}

// Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

database.runTransaction(async (err, transaction) => { if (err) { console.error(err);
return;
} try { const [rows, stats] = await transaction.run({ sql: "INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') THEN RETURN CustomerId", });

rows.forEach(row => { console.log( `Inserted customer record with CustomerId: ${ row.toJSON({wrapNumbers: true}).CustomerId.value }`, );
});

const rowCount = Math.floor(stats[stats.rowCount]);
console.log(`Number of customer records inserted is: ${rowCount}`);

await transaction.commit();
} catch (err) { console.error('ERROR:', err);
} finally { // Close the database when finished.
await database.close();
} });
} await createSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;
use Google\Cloud\Spanner\SpannerClient;
use Google\Cloud\Spanner\Result;

/**
 * Creates a sequence.
*
 * Example:
 * ```
 * create_sequence($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function create_sequence(string $projectId, string $instanceId, string $databaseId): void { $databaseAdminClient = new DatabaseAdminClient();
$spanner = new SpannerClient();

$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);

$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => [ "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", 'CREATE TABLE Customers (CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(' .
'Sequence Seq)), CustomerName STRING(1024)) PRIMARY KEY (CustomerId)' ] ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Created Seq sequence and Customers table, where ' .
'the key column CustomerId uses the sequence as a default value' .
PHP_EOL );

$transaction = $database->transaction();
$res = $transaction->execute( 'INSERT INTO Customers (CustomerName) VALUES ' .
"('Alice'), ('David'), ('Marc') THEN RETURN CustomerId" );
$rows = $res->rows(Result::RETURN_ASSOCIATIVE);

foreach ($rows as $row) { printf('Inserted customer record with CustomerId: %d %s', $row['CustomerId'], PHP_EOL );
} $transaction->commit();

printf(sprintf( 'Number of customer records inserted is: %d %s', $res->stats()['rowCountExact'], PHP_EOL ));
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def create_sequence(instance_id, database_id):
"""Creates the Sequence and insert data"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", """CREATE TABLE Customers ( CustomerId     INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(Sequence Seq)), CustomerName      STRING(1024) ) PRIMARY KEY (CustomerId)""", ], )

operation = database_admin_api.update_database_ddl(request)

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value on database {} on instance {}".format( database_id, instance_id ) )

def insert_customers(transaction):
results = transaction.execute_sql( "INSERT INTO Customers (CustomerName) VALUES " "('Alice'), " "('David'), " "('Marc') " "THEN RETURN CustomerId" ) for result in results:
print("Inserted customer record with Customer Id: {}".format(*result)) print( "Number of customer records inserted is {}".format( results.stats.row_count_exact ) )

instance = spanner_client.instance(instance_id) database = instance.database(database_id)

database.run_in_transaction(insert_customers)

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to create a sequence.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_create_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "CREATE SEQUENCE Seq OPTIONS (sequence_kind = 'bit_reversed_positive')", "CREATE TABLE Customers (CustomerId INT64 DEFAULT (GET_NEXT_SEQUENCE_VALUE(Sequence Seq)), CustomerName STRING(1024)) PRIMARY KEY (CustomerId)" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value" end

PostgreSQL

C++

void CreateSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, google::cloud::spanner::Database const& database, google::cloud::spanner::Client client) { std::vector statements;
statements.emplace_back(R"""( CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE )""");
statements.emplace_back(R"""( CREATE TABLE Customers ( CustomerId    BIGINT DEFAULT NEXTVAL('Seq'), CustomerName  CHARACTER VARYING(1024), PRIMARY KEY (CustomerId) ) )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Created `Seq` sequence and `Customers` table," << " where the key column `CustomerId`" << " uses the sequence as a default value," << " new DDL:\n" DebugString();
auto commit = client.Commit( [&client](google::cloud::spanner::Transaction txn) -> google::cloud::StatusOr { auto sql = google::cloud::spanner::SqlStatement(R"""( INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') RETURNING CustomerId )""");
using RowType = std::tuple;
auto rows = client.ExecuteQuery(std::move(txn), std::move(sql));
// Note: This mutator might be re-run, or its effects discarded, so // changing non-transactional state (e.g., by producing output) is, // in general, not something to be imitated.
for (auto& row : google::cloud::spanner::StreamOf(rows)) { if (!row) return std::move(row).status();
std::cout << "Inserted customer record with CustomerId: " (*row) << "\n";
} std::cout << "Number of customer records inserted is: " << rows.RowsModified() << "\n";
return google::cloud::spanner::Mutations{};
});
if (!commit) throw std::move(commit).status();
}

C#

using Google.Cloud.Spanner.Common.V1;
using System.Threading.Tasks;
using System;
using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Data;
using System.Collections.Generic;

public class CreateSequencePostgresqlSample { public async Task> CreateSequencePostgresqlSampleAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();

DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE ;", "CREATE TABLE Customers (CustomerId BIGINT DEFAULT nextval('Seq'), CustomerName character varying(1024), PRIMARY KEY (CustomerId))" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);

var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { throw completedResponse.Exception;
}

Console.WriteLine("Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value");

string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
await connection.OpenAsync();

using var cmd = connection.CreateDmlCommand( @"INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') RETURNING CustomerId");

var reader = await cmd.ExecuteReaderAsync();
var customerIds = new List();
while (await reader.ReadAsync()) { var customerId = reader.GetFieldValue("customerid");
Console.WriteLine($"Inserted customer record with CustomerId: {customerId}");
customerIds.Add(customerId);
} Console.WriteLine($"Number of customer records inserted is: {customerIds.Count}");
return customerIds;
} }

Go

import (
"context" "fmt" "io"

"cloud.google.com/go/spanner" database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/api/iterator" )

func pgCreateSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Create a sequence, and then use the sequence as auto generated primary key in Customers table.
ddl := []string{ "CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE", "CREATE TABLE Customers (CustomerId BIGINT DEFAULT nextval('Seq'), CustomerName character varying(1024), PRIMARY KEY (CustomerId))", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence creation to finish failed: %w", err) } fmt.Fprintf(w, "Created Seq sequence and Customers table, where its key column CustomerId uses the sequence as a default value\n")

client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

// Inserts records into the Customers table.
// The ReadWriteTransaction function returns the commit timestamp and an error.
// The commit timestamp is ignored in this case.
_, err = client.ReadWriteTransaction(ctx, func(ctx context.Context, txn *spanner.ReadWriteTransaction) error { stmt := spanner.Statement{ SQL: `INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') RETURNING CustomerId`, } iter := txn.Query(ctx, stmt) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } var customerId int64 if err := row.Columns(&customerId); err != nil { return err } fmt.Fprintf(w, "Inserted customer record with CustomerId: %d\n", customerId) } fmt.Fprintf(w, "Number of customer records inserted is: %d\n", iter.RowCount) return nil }) return err }

Java

import com.google.cloud.spanner.DatabaseClient;
import com.google.cloud.spanner.DatabaseId;
import com.google.cloud.spanner.ResultSet;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.Statement;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class PgCreateSequenceSample {

static void pgCreateSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
pgCreateSequence(projectId, instanceId, databaseId);
}

static void pgCreateSequence(String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { databaseAdminClient .updateDatabaseDdlAsync(DatabaseName.of(projectId, instanceId, databaseId).toString(), ImmutableList.of( "CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE;", "CREATE TABLE Customers (CustomerId BIGINT DEFAULT nextval('Seq'), " + "CustomerName character varying(1024), PRIMARY KEY (CustomerId))")) .get(5, TimeUnit.MINUTES);

System.out.println( "Created Seq sequence and Customers table, where the key column " + "CustomerId uses the sequence as a default value");

final DatabaseClient dbClient = spanner.getDatabaseClient(DatabaseId.of(projectId, instanceId, databaseId));

Long insertCount = dbClient .readWriteTransaction() .run( transaction -> { try (ResultSet rs = transaction.executeQuery( Statement.of( "INSERT INTO Customers (CustomerName) VALUES " + "('Alice'), ('David'), ('Marc') RETURNING CustomerId"))) { while (rs.next()) { System.out.printf( "Inserted customer record with CustomerId: %d\n", rs.getLong(0));
} return Objects.requireNonNull(rs.getStats()).getRowCountExact();
} });
System.out.printf("Number of customer records inserted is: %d\n", insertCount);
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function createSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = [ 'CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE', "CREATE TABLE Customers (CustomerId BIGINT DEFAULT nextval('Seq'), CustomerName character varying(1024), PRIMARY KEY (CustomerId))", ];

// Creates a new table with sequence try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value', );
} catch (err) { console.error('ERROR:', err);
}

// Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

database.runTransaction(async (err, transaction) => { if (err) { console.error(err);
return;
} try { const [rows, stats] = await transaction.run({ sql: "INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') RETURNING CustomerId", });

rows.forEach(row => { console.log( `Inserted customer record with CustomerId: ${ row.toJSON({wrapNumbers: true}).customerid.value }`, );
});

const rowCount = Math.floor(stats[stats.rowCount]);
console.log(`Number of customer records inserted is: ${rowCount}`);

await transaction.commit();
} catch (err) { console.error('ERROR:', err);
} finally { // Close the spanner client when finished.
// The databaseAdminClient does not require explicit closure. The closure of the Spanner client will automatically close the databaseAdminClient.
spanner.close();
} });
} await createSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;
use Google\Cloud\Spanner\SpannerClient;
use Google\Cloud\Spanner\Result;

/**
 * Creates a sequence.
 * Example:
 * ```
 * pg_create_sequence($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud Project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function pg_create_sequence( string $projectId, string $instanceId, string $databaseId ): void { $databaseAdminClient = new DatabaseAdminClient();
$spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);
$transaction = $database->transaction();
$operation = $databaseAdminClient->updateDatabaseDdl(new UpdateDatabaseDdlRequest([ 'database' => DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId), 'statements' => [ 'CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE', "CREATE TABLE Customers ( CustomerId           BIGINT DEFAULT nextval('Seq'), CustomerName         CHARACTER VARYING(1024), PRIMARY KEY (CustomerId))" ] ]));

print('Waiting for operation to complete ...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Created Seq sequence and Customers table, where ' .
'the key column CustomerId uses the sequence as a default value' .
PHP_EOL );

$res = $transaction->execute( 'INSERT INTO Customers (CustomerName) VALUES ' .
"('Alice'), ('David'), ('Marc') RETURNING CustomerId" );
$rows = $res->rows(Result::RETURN_ASSOCIATIVE);

foreach ($rows as $row) { printf('Inserted customer record with CustomerId: %d %s', $row['customerid'], PHP_EOL );
} $transaction->commit();

printf(sprintf( 'Number of customer records inserted is: %d %s', $res->stats()['rowCountExact'], PHP_EOL ));
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def create_sequence(instance_id, database_id):
"""Creates the Sequence and insert data"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE", """CREATE TABLE Customers ( CustomerId  BIGINT DEFAULT nextval('Seq'), CustomerName  character varying(1024), PRIMARY KEY (CustomerId) )""", ], ) operation = database_admin_api.update_database_ddl(request) print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Created Seq sequence and Customers table, where the key column CustomerId uses the sequence as a default value on database {} on instance {}".format( database_id, instance_id ) )

def insert_customers(transaction):
results = transaction.execute_sql( "INSERT INTO Customers (CustomerName) VALUES " "('Alice'), " "('David'), " "('Marc') " "RETURNING CustomerId" ) for result in results:
print("Inserted customer record with Customer Id: {}".format(*result)) print( "Number of customer records inserted is {}".format( results.stats.row_count_exact ) )

instance = spanner_client.instance(instance_id) database = instance.database(database_id)

database.run_in_transaction(insert_customers)

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to create a sequence using postgresql.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_postgresql_create_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "CREATE SEQUENCE Seq BIT_REVERSED_POSITIVE", "CREATE TABLE Customers (CustomerId BIGINT DEFAULT nextval('Seq'), CustomerName character varying(1024), PRIMARY KEY (CustomerId))" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Created Seq sequence and Customers table, where its key column CustomerId uses the sequence as a default value" end

更改序列

以下代码示例会更改序列 Seq，以跳过 1,000 到 500 万之间的值范围。然后，它会在 Customers 表中插入三个新行。

GoogleSQL

C++

void AlterSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, google::cloud::spanner::Client client, std::string const& project_id, std::string const& instance_id, std::string const& database_id) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
std::vector statements;
statements.emplace_back(R"""( ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000) )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Altered `Seq` sequence" << "  to skip an inclusive range between 1000 and 5000000," << " new DDL:\n" DebugString();
auto commit = client.Commit( [&client](google::cloud::spanner::Transaction txn) -> google::cloud::StatusOr { auto sql = google::cloud::spanner::SqlStatement(R"""( INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') THEN RETURN CustomerId )""");
using RowType = std::tuple;
auto rows = client.ExecuteQuery(std::move(txn), std::move(sql));
// Note: This mutator might be re-run, or its effects discarded, so // changing non-transactional state (e.g., by producing output) is, // in general, not something to be imitated.
for (auto& row : google::cloud::spanner::StreamOf(rows)) { if (!row) return std::move(row).status();
std::cout << "Inserted customer record with CustomerId: " (*row) << "\n";
} std::cout << "Number of customer records inserted is: " << rows.RowsModified() << "\n";
return google::cloud::spanner::Mutations{};
});
if (!commit) throw std::move(commit).status();
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.Cloud.Spanner.Data;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public class AlterSequenceSample { public async Task> AlterSequenceSampleAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();

DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000)" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);

var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { throw completedResponse.Exception;
} Console.WriteLine("Altered Seq sequence to skip an inclusive range between 1000 and 5000000");

string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
await connection.OpenAsync();

using var cmd = connection.CreateDmlCommand( @"INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') THEN RETURN CustomerId");

var reader = await cmd.ExecuteReaderAsync();
var customerIds = new List();
while (await reader.ReadAsync()) { long customerId = reader.GetFieldValue("CustomerId");
Console.WriteLine($"Inserted customer record with CustomerId: {customerId}");
customerIds.Add(customerId);
} Console.WriteLine($"Number of customer records inserted is: {customerIds.Count}");

return customerIds;
} }

Go

import (
"context" "fmt" "io"

"cloud.google.com/go/spanner" database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/api/iterator" )

func alterSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Alter the sequence to skip range [1000-5000000] for new keys.
ddl := []string{ "ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000)", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence skip range to finish failed: %w", err) } fmt.Fprintf(w, "Altered Seq sequence to skip an inclusive range between 1000 and 5000000\n")

client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

// Inserts records into the Customers table.
// The ReadWriteTransaction function returns the commit timestamp and an error.
// The commit timestamp is ignored in this case.
_, err = client.ReadWriteTransaction(ctx, func(ctx context.Context, txn *spanner.ReadWriteTransaction) error { stmt := spanner.Statement{ SQL: `INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') THEN RETURN CustomerId`, } iter := txn.Query(ctx, stmt) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } var customerId int64 if err := row.Columns(&customerId); err != nil { return err } fmt.Fprintf(w, "Inserted customer record with CustomerId: %d\n", customerId) } fmt.Fprintf(w, "Number of customer records inserted is: %d\n", iter.RowCount) return nil }) return err }

Java

import com.google.cloud.spanner.DatabaseClient;
import com.google.cloud.spanner.DatabaseId;
import com.google.cloud.spanner.ResultSet;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.Statement;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class AlterSequenceSample {

static void alterSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
alterSequence(projectId, instanceId, databaseId);
}

static void alterSequence(String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) {

databaseAdminClient .updateDatabaseDdlAsync(DatabaseName.of(projectId, instanceId, databaseId), ImmutableList.of( "ALTER SEQUENCE Seq SET OPTIONS " + "(skip_range_min = 1000, skip_range_max = 5000000)")) .get(5, TimeUnit.MINUTES);

System.out.println( "Altered Seq sequence to skip an inclusive range between 1000 and 5000000");

final DatabaseClient dbClient = spanner.getDatabaseClient(DatabaseId.of(projectId, instanceId, databaseId));

Long insertCount = dbClient .readWriteTransaction() .run( transaction -> { try (ResultSet rs = transaction.executeQuery( Statement.of( "INSERT INTO Customers (CustomerName) VALUES " + "('Lea'), ('Catalina'), ('Smith') " + "THEN RETURN CustomerId"))) { while (rs.next()) { System.out.printf( "Inserted customer record with CustomerId: %d\n", rs.getLong(0));
} return Objects.requireNonNull(rs.getStats()).getRowCountExact();
} });
System.out.printf("Number of customer records inserted is: %d\n", insertCount);
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function alterSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = [ 'ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000)', ];

try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Altered Seq sequence to skip an inclusive range between 1000 and 5000000.', );
} catch (err) { console.error('ERROR:', err);
}

// Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

database.runTransaction(async (err, transaction) => { if (err) { console.error(err);
return;
} try { const [rows, stats] = await transaction.run({ sql: "INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') THEN RETURN CustomerId", });

rows.forEach(row => { console.log( `Inserted customer record with CustomerId: ${ row.toJSON({wrapNumbers: true}).CustomerId.value }`, );
});

const rowCount = Math.floor(stats[stats.rowCount]);
console.log(`Number of customer records inserted is: ${rowCount}`);

await transaction.commit();
} catch (err) { console.error('ERROR:', err);
} finally { // Close the database when finished.
await database.close();
} });
} await alterSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;
use Google\Cloud\Spanner\Result;
use Google\Cloud\Spanner\SpannerClient;

/**
 * Alters a sequence.
 * Example:
 * ```
 * alter_sequence($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function alter_sequence(string $projectId, string $instanceId, string $databaseId): void { $databaseAdminClient = new DatabaseAdminClient();
$spanner = new SpannerClient();

$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);
$transaction = $database->transaction();

$statements = [ 'ALTER SEQUENCE Seq SET OPTIONS ' .
'(skip_range_min = 1000, skip_range_max = 5000000)' ];
$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => $statements ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Altered Seq sequence to skip an inclusive range between 1000 and 5000000' .
PHP_EOL );

$res = $transaction->execute( 'INSERT INTO Customers (CustomerName) VALUES ' .
"('Lea'), ('Catalina'), ('Smith') THEN RETURN CustomerId" );
$rows = $res->rows(Result::RETURN_ASSOCIATIVE);

foreach ($rows as $row) { printf('Inserted customer record with CustomerId: %d %s', $row['CustomerId'], PHP_EOL );
} $transaction->commit();

printf(sprintf( 'Number of customer records inserted is: %d %s', $res->stats()['rowCountExact'], PHP_EOL ));
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def alter_sequence(instance_id, database_id):
"""Alters the Sequence and insert data"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000)", ], )

operation = database_admin_api.update_database_ddl(request)

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Altered Seq sequence to skip an inclusive range between 1000 and 5000000 on database {} on instance {}".format( database_id, instance_id ) )

def insert_customers(transaction):
results = transaction.execute_sql( "INSERT INTO Customers (CustomerName) VALUES " "('Lea'), " "('Cataline'), " "('Smith') " "THEN RETURN CustomerId" ) for result in results:
print("Inserted customer record with Customer Id: {}".format(*result)) print( "Number of customer records inserted is {}".format( results.stats.row_count_exact ) )

instance = spanner_client.instance(instance_id) database = instance.database(database_id)

database.run_in_transaction(insert_customers)

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to alter a sequence.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_alter_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "ALTER SEQUENCE Seq SET OPTIONS (skip_range_min = 1000, skip_range_max = 5000000)" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Altered Seq sequence to skip an inclusive range between 1000 and 5000000" end

PostgreSQL

C++

void AlterSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, google::cloud::spanner::Database const& database, google::cloud::spanner::Client client) { std::vector statements;
statements.emplace_back(R"""( ALTER SEQUENCE Seq SKIP RANGE 1000 5000000 )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Altered `Seq` sequence" << "  to skip an inclusive range between 1000 and 5000000," << " new DDL:\n" DebugString();
auto commit = client.Commit( [&client](google::cloud::spanner::Transaction txn) -> google::cloud::StatusOr { auto sql = google::cloud::spanner::SqlStatement(R"""( INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') RETURNING CustomerId )""");
using RowType = std::tuple;
auto rows = client.ExecuteQuery(std::move(txn), std::move(sql));
// Note: This mutator might be re-run, or its effects discarded, so // changing non-transactional state (e.g., by producing output) is, // in general, not something to be imitated.
for (auto& row : google::cloud::spanner::StreamOf(rows)) { if (!row) return std::move(row).status();
std::cout << "Inserted customer record with CustomerId: " (*row) << "\n";
} std::cout << "Number of customer records inserted is: " << rows.RowsModified() << "\n";
return google::cloud::spanner::Mutations{};
});
if (!commit) throw std::move(commit).status();
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.Cloud.Spanner.Data;
using Google.LongRunning;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public class AlterSequencePostgresqlSample { public async Task> AlterSequencePostgresqlSampleAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();
DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "ALTER SEQUENCE Seq SKIP RANGE 1000 5000000;" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);
var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { throw completedResponse.Exception;
} Console.WriteLine("Altered Seq sequence to skip an inclusive range between 1000 and 5000000");

string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";
using var connection = new SpannerConnection(connectionString);
await connection.OpenAsync();

using var cmd = connection.CreateDmlCommand( @"INSERT INTO Customers (CustomerName) VALUES ('Alice'), ('David'), ('Marc') RETURNING CustomerId");

var reader = await cmd.ExecuteReaderAsync();
var customerIds = new List();
while (await reader.ReadAsync()) { var customerId = reader.GetFieldValue("customerid");
Console.WriteLine($"Inserted customer record with CustomerId: {customerId}");
customerIds.Add(customerId);
} Console.WriteLine($"Number of customer records inserted is: {customerIds.Count}");
return customerIds;
} }

Go

import (
"context" "fmt" "io"

"cloud.google.com/go/spanner" database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/api/iterator" )

func pgAlterSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Alter the sequence to skip range [1000-5000000] for new keys.
ddl := []string{ "ALTER SEQUENCE Seq SKIP RANGE 1000 5000000", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence skip range to finish failed: %w", err) } fmt.Fprintf(w, "Altered Seq sequence to skip an inclusive range between 1000 and 5000000\n")

client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

// Inserts records into the Customers table.
// The ReadWriteTransaction function returns the commit timestamp and an error.
// The commit timestamp is ignored in this case.
_, err = client.ReadWriteTransaction(ctx, func(ctx context.Context, txn *spanner.ReadWriteTransaction) error { stmt := spanner.Statement{ SQL: `INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') RETURNING CustomerId`, } iter := txn.Query(ctx, stmt) defer iter.Stop() for { row, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } var customerId int64 if err := row.Columns(&customerId); err != nil { return err } fmt.Fprintf(w, "Inserted customer record with CustomerId: %d\n", customerId) } fmt.Fprintf(w, "Number of customer records inserted is: %d\n", iter.RowCount) return nil }) return err }

Java

import com.google.cloud.spanner.DatabaseClient;
import com.google.cloud.spanner.DatabaseId;
import com.google.cloud.spanner.ResultSet;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.Statement;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class PgAlterSequenceSample {

static void pgAlterSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
pgAlterSequence(projectId, instanceId, databaseId);
}

static void pgAlterSequence(String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) {

databaseAdminClient .updateDatabaseDdlAsync( DatabaseName.of(projectId, instanceId, databaseId), ImmutableList.of("ALTER SEQUENCE Seq SKIP RANGE 1000 5000000")) .get(5, TimeUnit.MINUTES);
System.out.println( "Altered Seq sequence to skip an inclusive range between 1000 and 5000000");
final DatabaseClient dbClient = spanner.getDatabaseClient(DatabaseId.of(projectId, instanceId, databaseId));
Long insertCount = dbClient .readWriteTransaction() .run( transaction -> { try (ResultSet rs = transaction.executeQuery( Statement.of( "INSERT INTO Customers (CustomerName) VALUES " + "('Lea'), ('Catalina'), ('Smith') RETURNING CustomerId"))) { while (rs.next()) { System.out.printf( "Inserted customer record with CustomerId: %d\n", rs.getLong(0));
} return Objects.requireNonNull(rs.getStats()).getRowCountExact();
} });
System.out.printf("Number of customer records inserted is: %d\n", insertCount);
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function alterSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = ['ALTER SEQUENCE Seq SKIP RANGE 1000 5000000'];

try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Altered Seq sequence to skip an inclusive range between 1000 and 5000000.', );
} catch (err) { console.error('ERROR:', err);
}

// Gets a reference to a Cloud Spanner instance and database const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

database.runTransaction(async (err, transaction) => { if (err) { console.error(err);
return;
} try { const [rows, stats] = await transaction.run({ sql: "INSERT INTO Customers (CustomerName) VALUES ('Lea'), ('Catalina'), ('Smith') RETURNING CustomerId", });

rows.forEach(row => { console.log( `Inserted customer record with CustomerId: ${ row.toJSON({wrapNumbers: true}).customerid.value }`, );
});

const rowCount = Math.floor(stats[stats.rowCount]);
console.log(`Number of customer records inserted is: ${rowCount}`);

await transaction.commit();
} catch (err) { console.error('ERROR:', err);
} finally { // Close the spanner client when finished.
// The databaseAdminClient does not require explicit closure. The closure of the Spanner client will automatically close the databaseAdminClient.
spanner.close();
} });
} await alterSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;
use Google\Cloud\Spanner\SpannerClient;
use Google\Cloud\Spanner\Result;

/**
 * Alters a sequence.
 * Example:
 * ```
 * pg_alter_sequence($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function pg_alter_sequence( string $projectId, string $instanceId, string $databaseId ): void { $databaseAdminClient = new DatabaseAdminClient();
$spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);
$transaction = $database->transaction();
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);
$statement = 'ALTER SEQUENCE Seq SKIP RANGE 1000 5000000';
$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => [$statement] ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Altered Seq sequence to skip an inclusive range between 1000 and 5000000' .
PHP_EOL );

$res = $transaction->execute( 'INSERT INTO Customers (CustomerName) VALUES ' .
"('Lea'), ('Catalina'), ('Smith') RETURNING CustomerId" );
$rows = $res->rows(Result::RETURN_ASSOCIATIVE);

foreach ($rows as $row) { printf('Inserted customer record with CustomerId: %d %s', $row['customerid'], PHP_EOL );
} $transaction->commit();

printf(sprintf( 'Number of customer records inserted is: %d %s', $res->stats()['rowCountExact'], PHP_EOL ));
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def alter_sequence(instance_id, database_id):
"""Alters the Sequence and insert data"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=["ALTER SEQUENCE Seq SKIP RANGE 1000 5000000"], ) operation = database_admin_api.update_database_ddl(request)

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Altered Seq sequence to skip an inclusive range between 1000 and 5000000 on database {} on instance {}".format( database_id, instance_id ) )

def insert_customers(transaction):
results = transaction.execute_sql( "INSERT INTO Customers (CustomerName) VALUES " "('Lea'), " "('Cataline'), " "('Smith') " "RETURNING CustomerId" ) for result in results:
print("Inserted customer record with Customer Id: {}".format(*result)) print( "Number of customer records inserted is {}".format( results.stats.row_count_exact ) )

instance = spanner_client.instance(instance_id) database = instance.database(database_id)

database.run_in_transaction(insert_customers)

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to alter a sequence using postgresql.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_postgresql_alter_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "ALTER SEQUENCE Seq SKIP RANGE 1000 5000000" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Altered Seq sequence to skip an inclusive range between 1000 and 5000000" end

删除序列

以下代码示例会更改表 Customers，以从主键默认值中移除序列 Seq，然后删除序列 Seq。

GoogleSQL

C++

void DropSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, std::string const& project_id, std::string const& instance_id, std::string const& database_id) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
std::vector statements;
statements.emplace_back(R"""( ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT )""");
statements.emplace_back(R"""( DROP SEQUENCE Seq )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Altered `Customers` table to" << " drop DEFAULT from `CustomerId` column," << " and dropped the `Seq` sequence," << " new DDL:\n" DebugString();
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using System;
using System.Threading.Tasks;

public class DropSequenceSample { public async Task DropSequenceSampleAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();

DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);

var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { throw completedResponse.Exception;
} Console.WriteLine("Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence");
} }

Go

import (
"context" "fmt" "io"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

func dropSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Drop the DEFAULT from CustomerId column and drop the sequence.
ddl := []string{ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence drop to finish failed: %w", err) } fmt.Fprintf(w, "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence\n") return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class DropSequenceSample {

static void dropSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
dropSequence(projectId, instanceId, databaseId);
}

static void dropSequence(String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { databaseAdminClient .updateDatabaseDdlAsync(DatabaseName.of(projectId, instanceId, databaseId), ImmutableList.of( "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq")) .get(5, TimeUnit.MINUTES);
System.out.println( "Altered Customers table to drop DEFAULT from CustomerId column " + "and dropped the Seq sequence");
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function dropSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = [ 'ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT', 'DROP SEQUENCE Seq', ];

// Drop sequence from DDL try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence.', );
} catch (err) { console.error('ERROR:', err);
} finally { // Close the spanner client when finished.
// The databaseAdminClient does not require explicit closure. The closure of the Spanner client will automatically close the databaseAdminClient.
spanner.close();
} } await dropSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;

/**
 * Drops a sequence.
 * Example:
 * ```
 * drop_sequence($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function drop_sequence( string $projectId, string $instanceId, string $databaseId ): void { $databaseAdminClient = new DatabaseAdminClient();
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);

$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => [ 'ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT', 'DROP SEQUENCE Seq' ] ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Altered Customers table to drop DEFAULT from CustomerId ' .
'column and dropped the Seq sequence' .
PHP_EOL );
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def drop_sequence(instance_id, database_id):
"""Drops the Sequence"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq", ], )

operation = database_admin_api.update_database_ddl(request)

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence on database {} on instance {}".format( database_id, instance_id ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to drop a sequence.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_drop_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence" end

PostgreSQL

C++

void DropSequence( google::cloud::spanner_admin::DatabaseAdminClient admin_client, google::cloud::spanner::Database const& database) { std::vector statements;
statements.emplace_back(R"""( ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT )""");
statements.emplace_back(R"""( DROP SEQUENCE Seq )""");
auto metadata = admin_client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "Altered `Customers` table to" << " drop DEFAULT from `CustomerId` column," << " and dropped the `Seq` sequence," << " new DDL:\n" DebugString();
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using System;
using System.Threading.Tasks;

public class DropSequenceSample { public async Task DropSequenceSampleAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.Create();

DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
string[] statements = { "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq" };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(databaseName, statements);

var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { throw completedResponse.Exception;
} Console.WriteLine("Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence");
} }

Go

import (
"context" "fmt" "io"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

func dropSequence(w io.Writer, db string) error { // db := "projects/my-project/instances/my-instance/databases/my-database" ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

// List of DDL statements to be applied to the database.
// Drop the DEFAULT from CustomerId column and drop the sequence.
ddl := []string{ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq", } op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database:   db, Statements: ddl, }) if err != nil { return err } // Wait for the UpdateDatabaseDdl operation to finish.
if err := op.Wait(ctx); err != nil { return fmt.Errorf("waiting for bit reverse sequence drop to finish failed: %w", err) } fmt.Fprintf(w, "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence\n") return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class PgDropSequenceSample {

static void pgDropSequence() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
pgDropSequence(projectId, instanceId, databaseId);
}

static void pgDropSequence(String projectId, String instanceId, String databaseId) {

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { databaseAdminClient .updateDatabaseDdlAsync( DatabaseName.of(projectId, instanceId, databaseId), ImmutableList.of( "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq")) .get(5, TimeUnit.MINUTES);
System.out.println( "Altered Customers table to drop DEFAULT from " + "CustomerId column and dropped the Seq sequence");
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} catch (TimeoutException e) { // If the operation timed out propagate the timeout throw SpannerExceptionFactory.propagateTimeout(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

// Imports the Google Cloud client library.
const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const databaseId = 'my-database';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

async function dropSequence(instanceId, databaseId) { // Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

const request = [ 'ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT', 'DROP SEQUENCE Seq', ];

// Drop sequence from DDL try { const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: request, });

console.log('Waiting for operation to complete...');
await operation.promise();

console.log( 'Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence.', );
} catch (err) { console.error('ERROR:', err);
} finally { // Close the spanner client when finished.
// The databaseAdminClient does not require explicit closure. The closure of the Spanner client will automatically close the databaseAdminClient.
spanner.close();
} } await dropSequence(instanceId, databaseId);

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;

/**
 * Drops a sequence.
 * Example:
 * ```
 * pg_drop_sequence($instanceId, $databaseId);
 * ```
*
 * @param string $projectId Your Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function pg_drop_sequence( string $projectId, string $instanceId, string $databaseId ): void { $databaseAdminClient = new DatabaseAdminClient();
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);
$statements = [ 'ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT', 'DROP SEQUENCE Seq' ];

$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => $statements ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf( 'Altered Customers table to drop DEFAULT from CustomerId ' .
'column and dropped the Seq sequence' .
PHP_EOL );
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def drop_sequence(instance_id, database_id):
"""Drops the Sequence"""

from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq", ], ) operation = database_admin_api.update_database_ddl(request)

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence on database {} on instance {}".format( database_id, instance_id ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner"

##
# This is a snippet for showcasing how to drop a sequence using postgresql.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_postgresql_drop_sequence project_id:, instance_id:, database_id:
db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin

database_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id

job = db_admin_client.update_database_ddl database: database_path, statements: [ "ALTER TABLE Customers ALTER COLUMN CustomerId DROP DEFAULT", "DROP SEQUENCE Seq" ]

puts "Waiting for operation to complete..." job.wait_until_done!
puts "Altered Customers table to drop DEFAULT from CustomerId column and dropped the Seq sequence" end

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
