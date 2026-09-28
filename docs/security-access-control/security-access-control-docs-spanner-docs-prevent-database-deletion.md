# 防止意外删除数据库  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/prevent-database-deletion

防止意外删除数据库  |  Spanner  |  Google Cloud Documentation

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

防止意外删除数据库

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何保护 Spanner 数据库免遭意外删除。

Spanner 数据库删除防护可防止拥有删除数据库所需的 IAM 权限的用户或服务账号意外删除现有数据库。通过启用数据库删除防护，您可以保护对应用和服务至关重要的数据库。使用数据库删除防护以及时间点恢复和备份功能可为您的 Spanner 数据库提供一套全面的数据保护功能。

默认情况下，在您创建新数据库时，删除防护设置处于停用状态。您可以在数据库创建成功后启用删除防护设置。此外，您还可以对现有数据库启用此设置。如果您要保护多个数据库，请分别对每个数据库启用此设置。启用或停用删除防护不会对数据库的性能产生任何影响。如果您需要删除启用了数据库删除防护的数据库，则需要先停用删除防护，然后才能删除数据库。

限制

在以下情况下，您无法启用数据库删除防护：

如果数据库正在进行删除。

如果数据库正在从备份进行恢复。（恢复操作完成后，您可以启用数据库删除防护）。

此外，数据库的备份以及从备份恢复的数据库不会继承其源数据库的数据库删除防护设置。从备份恢复数据库后，您必须单独启用其数据库删除防护。

如果您删除项目，Spanner 数据库删除防护不会阻止删除您的数据库或实例。如需详细了解删除项目后会出现什么情况，请参阅关停（删除）项目。

使用 IAM 进行访问权限控制

如需启用数据库的删除防护设置，您必须拥有特定的 IAM 权限。

您需要拥有 spanner.databases.update 权限才能启用或停用数据库删除防护。如果您只需要查看数据库配置的状态，则需要拥有 spanner.databases.list 或 spanner.databases.get 权限。如需了解如何授予 Spanner IAM 权限，请参阅应用 IAM 权限。

如果您为数据库预定义了 Spanner Database Admin roles/spanner.databaseAdmin 角色，则可以更新并启用数据库删除防护。

您可以对现有数据库启用数据库删除防护设置，以防止意外删除数据库。

启用数据库删除防护

您可以使用 gcloud CLI、客户端库以及 REST 或 RPC API 启用数据库删除防护。您无法使用 Google Cloud 控制台启用数据库删除防护。

gcloud 如需启用数据库的删除防护设置，请运行以下命令：

gcloud spanner databases update DATABASE_ID --instance=INSTANCE_ID --enable-drop-protection [--async]

以下选项为必需：

DATABASE_ID 数据库的 ID。
INSTANCE_ID 数据库所属实例的 ID。

以下选项为可选：

--async 立即返回结果，而无需等待正在进行的操作完成。

客户端库

C++

void UpdateDatabase(google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& database_id, bool drop_protection) { google::cloud::spanner::Database db(project_id, instance_id, database_id);
google::spanner::admin::database::v1::Database database;
database.set_name(db.FullName());
database.set_enable_drop_protection(drop_protection);
google::protobuf::FieldMask update_mask;
update_mask.add_paths("enable_drop_protection");
auto updated = client.UpdateDatabase(database, update_mask).get();
if (!updated) throw std::move(updated).status();
std::cout name() << " successfully updated.\n";
}

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.Protobuf.WellKnownTypes;
using System;
using System.Threading.Tasks;

public class UpdateDatabaseAsyncSample { public async Task UpdateDatabaseAsync(string projectId, string instanceId, string databaseId) { var databaseAdminClient = await DatabaseAdminClient.CreateAsync();
var databaseName = DatabaseName.Format(projectId, instanceId, databaseId);
Database databaseToUpdate = await databaseAdminClient.GetDatabaseAsync(databaseName);

databaseToUpdate.EnableDropProtection = true;
var updateDatabaseRequest = new UpdateDatabaseRequest() { Database = databaseToUpdate, UpdateMask = new FieldMask { Paths = { "enable_drop_protection" } } };

var operation = await databaseAdminClient.UpdateDatabaseAsync(updateDatabaseRequest);

// Wait until the operation has finished.
Console.WriteLine("Waiting for the operation to finish.");
var completedResponse = await operation.PollUntilCompletedAsync();

if (completedResponse.IsFaulted) { Console.WriteLine($"Error while updating database {databaseId}: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine($"Updated database {databaseId}.");

// Return the updated database.
return completedResponse.Result;
} }

Go

import (
"context" "fmt" "io"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/genproto/protobuf/field_mask" )

func updateDatabase(ctx context.Context, w io.Writer, db string) error { // db = `projects//instances//database/` // Instantiate database admin client.
adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return fmt.Errorf("updateDatabase.NewDatabaseAdminClient: %w", err) } defer adminClient.Close()

// Instantiate the request for performing update database operation.
op, err := adminClient.UpdateDatabase(ctx, &adminpb.UpdateDatabaseRequest{ Database: &adminpb.Database{ Name:                 db, EnableDropProtection: true, }, UpdateMask: &field_mask.FieldMask{ Paths: []string{"enable_drop_protection"}, }, }) if err != nil { return fmt.Errorf("updateDatabase.UpdateDatabase: %w", err) }

// Wait for update database operation to complete.
fmt.Fprintf(w, "Waiting for update database operation to complete [%s]\n", db) if _, err := op.Wait(ctx); err != nil { return fmt.Errorf("updateDatabase.Wait: %w", err) } fmt.Fprintf(w, "Updated database [%s]\n", db) return nil }

Java

import com.google.api.gax.longrunning.OperationFuture;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.Lists;
import com.google.protobuf.FieldMask;
import com.google.spanner.admin.database.v1.Database;
import com.google.spanner.admin.database.v1.DatabaseName;
import com.google.spanner.admin.database.v1.UpdateDatabaseMetadata;
import com.google.spanner.admin.database.v1.UpdateDatabaseRequest;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class UpdateDatabaseSample {

static void updateDatabase() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";

updateDatabase(projectId, instanceId, databaseId);
}

static void updateDatabase( String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { final Database database = Database.newBuilder() .setName(DatabaseName.of(projectId, instanceId, databaseId).toString()) .setEnableDropProtection(true).build();
final UpdateDatabaseRequest updateDatabaseRequest = UpdateDatabaseRequest.newBuilder() .setDatabase(database) .setUpdateMask( FieldMask.newBuilder().addAllPaths( Lists.newArrayList("enable_drop_protection")).build()) .build();
OperationFuture operation = databaseAdminClient.updateDatabaseAsync(updateDatabaseRequest);
System.out.printf("Waiting for update operation for %s to complete...\n", databaseId);
Database updatedDb = operation.get(5, TimeUnit.MINUTES);
System.out.printf("Updated database %s.\n", updatedDb.getName());
} catch (ExecutionException | TimeoutException e) { // If the operation failed during execution, expose the cause.
throw SpannerExceptionFactory.asSpannerException(e.getCause());
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment these variables before running the sample.
*/ // const instanceId = 'my-instance';
// const databaseId = 'my-database';
// const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

// creates a client const spanner = new Spanner({ projectId: projectId, });

const databaseAdminClient = spanner.getDatabaseAdminClient();

async function updateDatabase() { // Update the database metadata fields try { console.log( `Updating database ${databaseAdminClient.databasePath( projectId, instanceId, databaseId, )}.`, );
const [operation] = await databaseAdminClient.updateDatabase({ database: { name: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), enableDropProtection: true, }, // updateMask contains the fields to be updated in database updateMask: (protos.google.protobuf.FieldMask = { paths: ['enable_drop_protection'], }), });
console.log( `Waiting for update operation for ${databaseId} to complete...`, );
await operation.promise();
console.log(`Updated database ${databaseId}.`);
} catch (err) { console.log('ERROR:', err);
} } updateDatabase();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\Database;
use Google\Cloud\Spanner\Admin\Database\V1\GetDatabaseRequest;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseRequest;
use Google\Protobuf\FieldMask;

/**
 * Updates the drop protection setting for a database.
 * Example:
 * ```
 * update_database($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function update_database(string $projectId, string $instanceId, string $databaseId): void { $newUpdateMaskField = new FieldMask([ 'paths' => ['enable_drop_protection'] ]);
$databaseAdminClient = new DatabaseAdminClient();
$databaseFullName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);
$database = (new Database()) ->setEnableDropProtection(true) ->setName($databaseFullName);

printf('Updating database %s', $databaseId);
$operation = $databaseAdminClient->updateDatabase((new UpdateDatabaseRequest()) ->setDatabase($database) ->setUpdateMask($newUpdateMaskField));

$operation->pollUntilComplete();

$database = $databaseAdminClient->getDatabase( new GetDatabaseRequest(['name' => $databaseFullName]) );
printf( 'Updated the drop protection for %s to %s' . PHP_EOL, $database->getName(), $database->getEnableDropProtection() );
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def update_database(instance_id, database_id):
"""Updates the drop protection setting for a database.""" from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseRequest( database=spanner_database_admin.Database( name=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), enable_drop_protection=True, ), update_mask={"paths": ["enable_drop_protection"]}, ) operation = database_admin_api.update_database(request=request) print( "Waiting for update operation for {}/databases/{} to complete...".format( database_admin_api.instance_path(spanner_client.project, instance_id), database_id, ) ) operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Updated database {}/databases/{}.".format( database_admin_api.instance_path(spanner_client.project, instance_id), database_id, ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

require "google/cloud/spanner/admin/database"

##
# This is a snippet for showcasing how to update database.
#
# @param project_id  [String] The ID of the Google Cloud project.
# @param instance_id [String] The ID of the spanner instance.
# @param database_id [String] The ID of the database.
#
def spanner_update_database project_id:, instance_id:, database_id:
client = Google::Cloud::Spanner::Admin::Database.database_admin project_id: project_id db_path = client.database_path project: project_id, instance: instance_id, database: database_id database = client.get_database name: db_path

puts "Updating database #{database.name}" database.enable_drop_protection = true job = client.update_database database: database, update_mask: { paths: ["enable_drop_protection"] } puts "Waiting for update operation for #{database.name} to complete..." job.wait_until_done!
puts "Updated database #{database.name}" end

检查数据库是否启用了删除防护

您可以通过查看数据库配置来确定数据库是否启用了删除防护。

gcloud 如需检查数据库是否启用了删除防护，您可以运行 gcloud spanner databases describe 命令以获取有关数据库的详细信息，也可以运行 gcloud spanner databases list 以获取有关实例中数据库的详细信息。

gcloud spanner databases describe projects/PROJECT_ID/instances/INSTANCE_ID/databases/DATABASE_ID

以下选项为必需：

PROJECT_ID 数据库所属项目的 ID。
INSTANCE_ID 数据库所属实例的 ID。
DATABASE_ID 数据库的 ID。

如果启用了删除防护，则输出中会显示 enableDropProtection: true 参数。

停用数据库删除防护

如果数据库不再需要此防护，或者您需要删除启用了此设置的数据库，则可以停用数据库删除防护。

如果您要删除的实例包含一个或多个启用了删除防护的数据库，则必须先对该实例中的所有数据库停用删除防护，然后才能删除该实例。

gcloud 如需停用数据库的删除防护设置，请运行以下命令：

gcloud spanner databases update DATABASE_ID --instance=INSTANCE_ID --no-enable-drop-protection [--async]

以下选项为必需：

DATABASE_ID 数据库的 ID。
INSTANCE_ID 数据库所属实例的 ID。

以下选项为可选：

--async 立即返回结果，而无需等待正在进行的操作完成。

后续步骤

了解如何创建和管理数据库。

详细了解如何备份和恢复数据库。

了解如何更新架构。

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
