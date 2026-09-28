# 修改数据库的主要区域  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/modifying-leader-region

修改数据库的主要区域  |  Spanner  |  Google Cloud Documentation

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

修改数据库的主要区域

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何修改数据库的主要区域。您只能更改使用双区域或多区域实例配置的 Spanner 实例的主要区域。新的主要区域必须是数据库的双区域或多区域配置中的两个读写区域之一。如需详细了解如何更改主要区域，请参阅配置默认主要区域。

如需查看双区域或多区域实例的数据库主节点分布情况数据，请打开 Google Cloud 控制台，然后查看主节点分布情况图表。如需了解详情，请参阅 Spanner 图表和指标。

更改数据库的主要区域

您可以更改数据库的主要区域。如需监控此更改的进度，您可以参考“主节点分布情况”图表。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要更改其主要区域的数据库的实例名称。

点击您要更改其主要区域的数据库。

点击主要区域旁边的铅笔图标。

通过将所需的主要区域用作 default_leader 来修改 DDL 语句。

gcloud

如需更改现有数据库的主要区域，请运行以下命令：

gcloud spanner databases ddl update DATABASE_NAME \ --instance=INSTANCE_ID \ --ddl='ALTER DATABASE `DATABASE_NAME` \ SET OPTIONS ( default_leader = "REGION" )'

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

REGION：要设置为默认主要区域的区域。

客户端库

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.LongRunning;
using Google.Protobuf.WellKnownTypes;
using System;
using System.Threading.Tasks;

public class UpdateDatabaseWithDefaultLeaderAsyncSample { public async Task> UpdateDatabaseWithDefaultLeaderAsync(string projectId, string instanceId, string databaseId, string defaultLeader) { DatabaseAdminClient databaseAdminClient = await DatabaseAdminClient.CreateAsync();

var alterDatabaseStatement = @$"ALTER DATABASE `{databaseId}` SET OPTIONS (default_leader = '{defaultLeader}')";

// Create the UpdateDatabaseDdl request and execute it.
var request = new UpdateDatabaseDdlRequest { DatabaseAsDatabaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId), Statements = { alterDatabaseStatement } };
var operation = await databaseAdminClient.UpdateDatabaseDdlAsync(request);

// Wait until the operation has finished.
Console.WriteLine("Waiting for the operation to finish.");
Operation completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { Console.WriteLine($"Error while updating database: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine("Updated default leader");
return completedResponse;
} }

C++

void UpdateDatabaseWithDefaultLeader( google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& database_id, std::string const& default_leader) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
std::vector statements;
statements.push_back("ALTER DATABASE `" + database_id + "` " + "SET OPTIONS (default_leader='" + default_leader + "')");
auto metadata = client.UpdateDatabaseDdl(database.FullName(), std::move(statements)) .get();
if (!metadata) throw std::move(metadata).status();
std::cout << "`default_leader` altered, new DDL metadata:\n" DebugString();
}

Go

import (
"context" "fmt" "io" "regexp"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

// updateDatabaseWithDefaultLeader updates the default leader for a given database func updateDatabaseWithDefaultLeader(w io.Writer, db string, defaultLeader string) error { // db = `projects//instances//database/` // defaultLeader = `nam3` matches := regexp.MustCompile("^(.+)/databases/(.+)$").FindStringSubmatch(db) if matches == nil || len(matches) != 3 { return fmt.Errorf("updateDatabaseWithDefaultLeader: invalid database id %q", db) }

ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

op, err := adminClient.UpdateDatabaseDdl(ctx, &adminpb.UpdateDatabaseDdlRequest{ Database: db, Statements: []string{ fmt.Sprintf( "ALTER DATABASE `%s` SET OPTIONS (default_leader = '%s')", matches[2], defaultLeader, ), }, }) if err != nil { return err } if err := op.Wait(ctx); err != nil { return err } fmt.Fprintf(w, "Updated the default leader\n") return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerException;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.spanner.admin.database.v1.DatabaseName;
import java.util.Collections;
import java.util.concurrent.ExecutionException;

public class UpdateDatabaseWithDefaultLeaderSample {

static void updateDatabaseWithDefaultLeader() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
final String defaultLeader = "my-default-leader";
updateDatabaseWithDefaultLeader(projectId, instanceId, databaseId, defaultLeader);
}

static void updateDatabaseWithDefaultLeader( String projectId, String instanceId, String databaseId, String defaultLeader) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { databaseAdminClient .updateDatabaseDdlAsync( DatabaseName.of(projectId, instanceId, databaseId), Collections.singletonList( String.format( "ALTER DATABASE `%s` SET OPTIONS (default_leader = '%s')", databaseId, defaultLeader ) ) ).get();
System.out.println("Updated default leader to " + defaultLeader);
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw (SpannerException) e.getCause();
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance-id';
// const databaseId = 'my-database-id';
// const defaultLeader = 'my-default-leader';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// creates a client const spanner = new Spanner({ projectId: projectId, });

const databaseAdminClient = spanner.getDatabaseAdminClient();

async function updateDatabaseWithDefaultLeader() { console.log( `Updating database ${databaseAdminClient.databasePath( projectId, instanceId, databaseId, )}.`, );
const setDefaultLeaderStatement = ` ALTER DATABASE \`${databaseId}\` SET OPTIONS (default_leader = '${defaultLeader}')`;
const [operation] = await databaseAdminClient.updateDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), statements: [setDefaultLeaderStatement], });

console.log(`Waiting for updating of ${databaseId} to complete...`);
await operation.promise();
console.log( `Updated database ${databaseId} with default leader ${defaultLeader}.`, );
} updateDatabaseWithDefaultLeader();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\GetDatabaseRequest;
use Google\Cloud\Spanner\Admin\Database\V1\UpdateDatabaseDdlRequest;

/**
 * Updates the default leader of the database.
 * Example:
 * ```
 * update_database_with_default_leader($projectId, $instanceId, $databaseId, $defaultLeader);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
 * @param string $defaultLeader The leader instance configuration used by default.
*/ function update_database_with_default_leader( string $projectId, string $instanceId, string $databaseId, string $defaultLeader ): void { $databaseAdminClient = new DatabaseAdminClient();
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);
$statement = "ALTER DATABASE `$databaseId` SET OPTIONS (default_leader = '$defaultLeader')";
$request = new UpdateDatabaseDdlRequest([ 'database' => $databaseName, 'statements' => [$statement] ]);

$operation = $databaseAdminClient->updateDatabaseDdl($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

$database = $databaseAdminClient->getDatabase( new GetDatabaseRequest(['name' => $databaseName]) );

printf('Updated the default leader to %s' . PHP_EOL, $database->getDefaultLeader());
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def update_database_with_default_leader(instance_id, database_id, default_leader):
"""Updates a database with tables with a default leader.""" from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.UpdateDatabaseDdlRequest( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ), statements=[ "ALTER DATABASE {}" " SET OPTIONS (default_leader = '{}')".format(database_id, default_leader) ], ) operation = database_admin_api.update_database_ddl(request)

operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Database {} updated with default leader {}".format(database_id, default_leader) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"
# default_leader = "Spanner database default leader"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin project_id: project_id

db_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id statements = [ "ALTER DATABASE `#{database_id}` SET OPTIONS ( default_leader = '#{default_leader}' )" ]

job = db_admin_client.update_database_ddl database: db_path, statements: statements

job.wait_until_done!
database = job.results

puts "Updated default leader"

将数据库主要区域重置为系统默认设置

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要更改其主要区域的数据库的实例名称。

点击您要更改其主要区域的数据库。

点击主要区域旁边的铅笔图标。

使用所需的主要区域修改 DDL 语句，并将 default_leader 设置为 NULL。

gcloud 如需将现有数据库的主要区域重置为默认主要区域，请运行以下命令：

GoogleSQL

gcloud spanner databases ddl update DATABASE_NAME \ --instance=INSTANCE_ID \ --ddl='ALTER DATABASE `DATABASE_NAME` \ SET OPTIONS ( default_leader = NULL )'

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

PostgreSQL

gcloud spanner databases ddl update DATABASE_NAME \ --instance=INSTANCE_ID \ --ddl='ALTER DATABASE DATABASE_NAME \ RESET spanner.default_leader'

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

创建数据库时设置主要区域

gcloud 如需在创建数据库时设置默认主要区域，请运行以下命令：

gcloud spanner databases create DATABASE_NAME \ --instance=INSTANCE_ID \ --ddl='CREATE TABLE TABLE_NAME (a INT64, b INT64) PRIMARY KEY(a); \ ALTER DATABASE `DATABASE_NAME` \ SET OPTIONS (default_leader = "REGION")'

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

TABLE_NAME：数据库表的名称。

REGION：要设置为默认主要区域的区域。

客户端库

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using System;
using System.Threading.Tasks;

public class CreateDatabaseWithDefaultLeaderAsyncSample { public async Task CreateDatabaseWithDefaultLeaderAsync(string projectId, string instanceId, string databaseId, string defaultLeader) { DatabaseAdminClient databaseAdminClient = await DatabaseAdminClient.CreateAsync();
// Define create table statement for table #1.
var createSingersTable = @"CREATE TABLE Singers ( SingerId INT64 NOT NULL, FirstName STRING(1024), LastName STRING(1024), ComposerInfo BYTES(MAX) ) PRIMARY KEY (SingerId)";
// Define create table statement for table #2.
var createAlbumsTable = @"CREATE TABLE Albums ( SingerId INT64 NOT NULL, AlbumId INT64 NOT NULL, AlbumTitle STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE";

// Define alter database statement to set default leader.
var alterDatabaseStatement = @$"ALTER DATABASE `{databaseId}` SET OPTIONS (default_leader = '{defaultLeader}')";

// Create the CreateDatabase request with default leader and execute it.
var request = new CreateDatabaseRequest { ParentAsInstanceName = InstanceName.FromProjectInstance(projectId, instanceId), CreateStatement = $"CREATE DATABASE `{databaseId}`", ExtraStatements = { createSingersTable, createAlbumsTable, alterDatabaseStatement }, };
var operation = await databaseAdminClient.CreateDatabaseAsync(request);

// Wait until the operation has finished.
Console.WriteLine("Waiting for the operation to finish.");
var completedResponse = await operation.PollUntilCompletedAsync();
if (completedResponse.IsFaulted) { Console.WriteLine($"Error while creating database: {completedResponse.Exception}");
throw completedResponse.Exception;
}

var database = completedResponse.Result;
Console.WriteLine($"Created database [{databaseId}]");
Console.WriteLine($"\t Default leader: {database.DefaultLeader}");
return database;
} }

C++

void CreateDatabaseWithDefaultLeader( google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& database_id, std::string const& default_leader) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
google::spanner::admin::database::v1::CreateDatabaseRequest request;
request.set_parent(database.instance().FullName());
request.set_create_statement("CREATE DATABASE `" + database.database_id() + "`");
request.add_extra_statements("ALTER DATABASE `" + database_id + "` " + "SET OPTIONS (default_leader='" + default_leader + "')");
auto db = client.CreateDatabase(request).get();
if (!db) throw std::move(db).status();
std::cout name() DebugString();
}

Go

import (
"context" "fmt" "io" "regexp"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

// createDatabaseWithDefaultLeader creates a database with a default leader func createDatabaseWithDefaultLeader(w io.Writer, db string, defaultLeader string) error { // db = `projects//instances//database/` // defaultLeader = `my-default-leader` matches := regexp.MustCompile("^(.*)/databases/(.*)$").FindStringSubmatch(db) if matches == nil || len(matches) != 3 { return fmt.Errorf("createDatabaseWithDefaultLeader: invalid database id %s", db) }

ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

alterDatabase := fmt.Sprintf( "ALTER DATABASE `%s` SET OPTIONS (default_leader = '%s')", matches[2], defaultLeader, )

req := adminpb.CreateDatabaseRequest{ Parent:          matches[1], CreateStatement: "CREATE DATABASE `" + matches[2] + "`", ExtraStatements: []string{ `CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX) ) PRIMARY KEY (SingerId)`, `CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE`, alterDatabase, }, } op, err := adminClient.CreateDatabase(ctx, &req) if err != nil { return fmt.Errorf("createDatabaseWithDefaultLeader.CreateDatabase: %w", err) } dbObj, err := op.Wait(ctx) if err != nil { return fmt.Errorf("createDatabaseWithDefaultLeader.Wait: %w", err) } fmt.Fprintf(w, "Created database [%s] with default leader%q\n", dbObj.Name, dbObj.DefaultLeader) return nil

}

Java

import com.google.cloud.spanner.SpannerException;
import com.google.cloud.spanner.SpannerExceptionFactory;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.spanner.admin.database.v1.CreateDatabaseRequest;
import com.google.spanner.admin.database.v1.Database;
import java.io.IOException;
import java.util.concurrent.ExecutionException;

public class CreateDatabaseWithDefaultLeaderSample {

static void createDatabaseWithDefaultLeader() throws IOException { // TODO(developer): Replace these variables before running the sample.
final String instanceName = "projects/my-project/instances/my-instance-id";
final String databaseId = "my-database-name";
final String defaultLeader = "my-default-leader";
createDatabaseWithDefaultLeader(instanceName, databaseId, defaultLeader);
}

static void createDatabaseWithDefaultLeader(String instanceName, String databaseId, String defaultLeader) throws IOException { try (DatabaseAdminClient databaseAdminClient = DatabaseAdminClient.create()) { Database createdDatabase = databaseAdminClient.createDatabaseAsync( CreateDatabaseRequest.newBuilder() .setParent(instanceName) .setCreateStatement("CREATE DATABASE `" + databaseId + "`") .addAllExtraStatements( ImmutableList.of("CREATE TABLE Singers (" + "  SingerId   INT64 NOT NULL," + "  FirstName  STRING(1024)," + "  LastName   STRING(1024)," + "  SingerInfo BYTES(MAX)" + ") PRIMARY KEY (SingerId)", "CREATE TABLE Albums (" + "  SingerId     INT64 NOT NULL," + "  AlbumId      INT64 NOT NULL," + "  AlbumTitle   STRING(MAX)" + ") PRIMARY KEY (SingerId, AlbumId)," + "  INTERLEAVE IN PARENT Singers ON DELETE CASCADE", "ALTER DATABASE " + "`" + databaseId + "`" + " SET OPTIONS ( default_leader = '" + defaultLeader + "' )")) .build()).get();
System.out.println("Created database [" + createdDatabase.getName() + "]");
System.out.println("\tDefault leader: " + createdDatabase.getDefaultLeader());
} catch (ExecutionException e) { // If the operation failed during execution, expose the cause.
throw (SpannerException) e.getCause();
} catch (InterruptedException e) { // Throw when a thread is waiting, sleeping, or otherwise occupied, // and the thread is interrupted, either before or during the activity.
throw SpannerExceptionFactory.propagateInterrupt(e);
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance-id';
// const databaseId = 'my-database-id';
// const defaultLeader = 'my-default-leader'; example: 'asia-northeast1'

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// creates a client const spanner = new Spanner({ projectId: projectId, });

// Gets a reference to a Cloud Spanner Database Admin Client object const databaseAdminClient = spanner.getDatabaseAdminClient();

async function createDatabaseWithDefaultLeader() { // Create a new database with an extra statement which will alter the // database after creation to set the default leader.
console.log( `Creating database ${databaseAdminClient.databasePath( projectId, instanceId, databaseId, )}.`, );
const createSingersTableStatement = ` CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX) ) PRIMARY KEY (SingerId)`;
const createAlbumsStatement = ` CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE`;

// Default leader is one of the possible values in the leaderOptions field of the // instance config of the instance where the database is created.
const setDefaultLeaderStatement = ` ALTER DATABASE \`${databaseId}\` SET OPTIONS (default_leader = '${defaultLeader}')`;

const [operation] = await databaseAdminClient.createDatabase({ createStatement: 'CREATE DATABASE `' + databaseId + '`', extraStatements: [ createSingersTableStatement, createAlbumsStatement, setDefaultLeaderStatement, ], parent: databaseAdminClient.instancePath(projectId, instanceId), });

console.log(`Waiting for creation of ${databaseId} to complete...`);
await operation.promise();
console.log( `Created database ${databaseId} with default leader ${defaultLeader}.`, );
} createDatabaseWithDefaultLeader();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\CreateDatabaseRequest;
use Google\Cloud\Spanner\Admin\Database\V1\GetDatabaseRequest;

/**
 * Creates a database with a default leader.
 * Example:
 * ```
 * create_database_with_default_leader($projectId, $instanceId, $databaseId, $defaultLeader);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
 * @param string $defaultLeader The leader instance configuration used by default.
*/ function create_database_with_default_leader( string $projectId, string $instanceId, string $databaseId, string $defaultLeader ): void { $databaseAdminClient = new DatabaseAdminClient();

$instance = $databaseAdminClient->instanceName($projectId, $instanceId);
$databaseIdFull = $databaseAdminClient->databaseName($projectId, $instanceId, $databaseId);

$operation = $databaseAdminClient->createDatabase( new CreateDatabaseRequest([ 'parent' => $instance, 'create_statement' => sprintf('CREATE DATABASE `%s`', $databaseId), 'extra_statements' => [ 'CREATE TABLE Singers (' .
'SingerId     INT64 NOT NULL,' .
'FirstName    STRING(1024),' .
'LastName     STRING(1024),' .
'SingerInfo   BYTES(MAX)' .
') PRIMARY KEY (SingerId)', 'CREATE TABLE Albums (' .
'SingerId     INT64 NOT NULL,' .
'AlbumId      INT64 NOT NULL,' .
'AlbumTitle   STRING(MAX)' .
') PRIMARY KEY (SingerId, AlbumId),' .
'INTERLEAVE IN PARENT Singers ON DELETE CASCADE', "ALTER DATABASE `$databaseId` SET OPTIONS(default_leader='$defaultLeader')" ] ]) );

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

$database = $databaseAdminClient->getDatabase( new GetDatabaseRequest(['name' => $databaseIdFull]) );
printf('Created database %s on instance %s with default leader %s' . PHP_EOL, $databaseId, $instanceId, $database->getDefaultLeader());
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def create_database_with_default_leader(instance_id, database_id, default_leader):
"""Creates a database with tables with a default leader.""" from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.CreateDatabaseRequest( parent=database_admin_api.instance_path(spanner_client.project, instance_id), create_statement=f"CREATE DATABASE `{database_id}`", extra_statements=[ """CREATE TABLE Singers ( SingerId     INT64 NOT NULL, FirstName    STRING(1024), LastName     STRING(1024), SingerInfo   BYTES(MAX) ) PRIMARY KEY (SingerId)""", """CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE""", "ALTER DATABASE {}" " SET OPTIONS (default_leader = '{}')".format(database_id, default_leader), ], ) operation = database_admin_api.create_database(request=request)

print("Waiting for operation to complete...") database = operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Database {} created with default leader {}".format( database.name, database.default_leader ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"
# default_leader = "Spanner database default leader"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin project_id: project_id

instance_path = db_admin_client.instance_path project: project_id, instance: instance_id statements = [ "CREATE TABLE Singers ( SingerId     INT64 NOT NULL, FirstName    STRING(1024), LastName     STRING(1024), SingerInfo   BYTES(MAX) ) PRIMARY KEY (SingerId)",

"CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE",

"ALTER DATABASE `#{database_id}` SET OPTIONS ( default_leader = '#{default_leader}' )" ]

job = db_admin_client.create_database \ parent: instance_path, create_statement: "CREATE DATABASE `#{database_id}`", extra_statements: statements

job.wait_until_done!
database = job.results

puts "Created database [#{database.name}] with default leader: #{database.default_leader}"

查看主要区域

使用 Google Cloud 控制台和 gcloud 查看数据库的主要区域

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

数据库的主要区域列在主要区域下。

gcloud 如需查看现有数据库的主要区域，请运行以下命令：

gcloud spanner databases describe DATABASE_NAME \ --instance=INSTANCE_ID

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

如果已经设置了默认的主要区域，则该区域会列在 defaultLeader 下。

如果未设置默认默认的主要区域，则不会列出 defaultLeader。在这种情况下，Spanner 会将 Google 定义的默认主区域用于您的双区域或多区域配置，如相应的可用配置所示。

在 DDL 中查看主要区域

gcloud 如需在 DDL 中查看数据库的主要区域，请运行以下命令：

gcloud spanner databases ddl describe DATABASE_NAME \ --instance=INSTANCE_NAME

替换以下内容：

DATABASE_NAME：数据库的名称。

INSTANCE_ID：数据库实例的标识符。

客户端库

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public class GetDatabaseDdlAsyncSample { public async Task GetDatabaseDdlAsync(string projectId, string instanceId, string databaseId) { DatabaseAdminClient databaseAdminClient = await DatabaseAdminClient.CreateAsync();
DatabaseName databaseName = DatabaseName.FromProjectInstanceDatabase(projectId, instanceId, databaseId);
GetDatabaseDdlResponse databaseDdl = await databaseAdminClient.GetDatabaseDdlAsync(databaseName);

Console.WriteLine($"DDL statements for database {databaseId}:");
foreach (var statement in databaseDdl.Statements) { Console.WriteLine(statement);
}

return databaseDdl;
} }

C++

void GetDatabaseDdl(google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& database_id) { namespace spanner = ::google::cloud::spanner;
auto database = client.GetDatabaseDdl( spanner::Database(project_id, instance_id, database_id).FullName());
if (!database) throw std::move(database).status();
std::cout DebugString();
}

Go

import (
"context" "fmt" "io" "regexp"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

// getDatabaseDdl gets the DDL for the database func getDatabaseDdl(w io.Writer, db string) error { // db = `projects//instances//database/` matches := regexp.MustCompile("^(.*)/databases/(.*)$").FindStringSubmatch(db) if matches == nil || len(matches) != 3 { return fmt.Errorf("getDatabaseDdl: invalid database id %s", db) }

ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

op, err := adminClient.GetDatabaseDdl(ctx, &adminpb.GetDatabaseDdlRequest{ Database: db, })

if err != nil { return err }

fmt.Fprintf(w, "Database DDL is as follows: \n [%v]", op.GetStatements())

return nil

}

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.spanner.admin.database.v1.DatabaseName;
import com.google.spanner.admin.database.v1.GetDatabaseDdlResponse;

public class GetDatabaseDdlSample {

static void getDatabaseDdl() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
getDatabaseDdl(projectId, instanceId, databaseId);
}

static void getDatabaseDdl( String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { final GetDatabaseDdlResponse response = databaseAdminClient.getDatabaseDdl(DatabaseName.of(projectId, instanceId, databaseId));
System.out.println("Retrieved database DDL for " + databaseId);
for (String ddl : response.getStatementsList()) { System.out.println(ddl);
} } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance-id';
// const databaseId = 'my-database-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// creates a client const spanner = new Spanner({ projectId: projectId, });

const databaseAdminClient = spanner.getDatabaseAdminClient();

async function getDatabaseDdl() { // Get the schema definition of the database.
const [ddlStatements] = await databaseAdminClient.getDatabaseDdl({ database: databaseAdminClient.databasePath( projectId, instanceId, databaseId, ), });

console.log( `Retrieved database DDL for ${databaseAdminClient.databasePath( projectId, instanceId, databaseId, )}:`, );
ddlStatements.statements.forEach(element => { console.log(element);
});
} getDatabaseDdl();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\GetDatabaseDdlRequest;

/**
 * Gets the database DDL statements.
 * Example:
 * ```
 * get_database_ddl($projectId, $instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function get_database_ddl(string $projectId, string $instanceId, string $databaseId): void { $databaseAdminClient = new DatabaseAdminClient();
$databaseName = DatabaseAdminClient::databaseName($projectId, $instanceId, $databaseId);

$request = new GetDatabaseDdlRequest(['database' => $databaseName]);

$statements = $databaseAdminClient->getDatabaseDdl($request)->getStatements();

printf("Retrieved database DDL for $databaseId" . PHP_EOL);
foreach ($statements as $statement) { printf($statement . PHP_EOL);
} }

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def get_database_ddl(instance_id, database_id):
"""Gets the database DDL statements.""" spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api ddl = database_admin_api.get_database_ddl( database=database_admin_api.database_path( spanner_client.project, instance_id, database_id ) ) print("Retrieved database DDL for {}".format(database_id)) for statement in ddl.statements:
print(statement)

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin project_id: project_id

db_path = db_admin_client.database_path project: project_id, instance: instance_id, database: database_id ddl = db_admin_client.get_database_ddl database: db_path

puts ddl.statements

在信息架构中查看主要区域

gcloud 如需查看现有数据库的主要区域，请运行以下命令：

gcloud spanner databases execute-sql DATABASE_NAME \ --instance=INSTANCE_ID \ --sql="SELECT s.OPTION_NAME, s.OPTION_VALUE \ FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s \ WHERE s.OPTION_NAME = 'default_leader'"

替换以下内容：

DATABASE_NAME：您的数据库的名称。

INSTANCE_ID：数据库实例的标识符。

客户端库

C#

using Google.Cloud.Spanner.Data;
using System;
using System.Threading.Tasks;

public class GetDatabaseDefaultLeaderFromInformationSchemaAsyncSample { public async Task GetDatabaseDefaultLeaderFromInformationSchemaAsync(string projectId, string instanceId, string databaseId) { string connectionString = $"Data Source=projects/{projectId}/instances/{instanceId}/databases/{databaseId}";

using var connection = new SpannerConnection(connectionString);
var cmd = connection.CreateSelectCommand( @"SELECT s.OPTION_NAME, s.OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s WHERE s.OPTION_NAME = 'default_leader'");

var defaultLeader = string.Empty;

Console.WriteLine($"Default leader for {databaseId}:");
using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync()) { defaultLeader = reader.GetFieldValue("OPTION_VALUE");
Console.WriteLine(defaultLeader);
}

return defaultLeader;
} }

C++

void QueryInformationSchemaDatabaseOptions( google::cloud::spanner::Client client) { namespace spanner = ::google::cloud::spanner;
// clang-format misinterprets the namespace alias followed by a block as // introducing a sub-namespace and so adds a misleading namespace-closing // comment at the end. This separating comment defeats that.
{ auto rows = client.ExecuteQuery(spanner::SqlStatement(R"""( SELECT s.OPTION_NAME, s.OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s WHERE s.OPTION_NAME = 'default_leader' )"""));
using RowType = std::tuple;
for (auto& row : spanner::StreamOf(rows)) { if (!row) throw std::move(row).status();
std::cout (*row) (*row) << "\n";
} } { auto rows = client.ExecuteQuery(spanner::SqlStatement(R"""( SELECT s.OPTION_NAME, s.OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s WHERE s.OPTION_NAME = 'version_retention_period' )"""));
using RowType = std::tuple;
for (auto& row : spanner::StreamOf(rows)) { if (!row) throw std::move(row).status();
std::cout (*row) (*row) << "\n";
} } }

Go

import (
"context" "fmt" "io" "regexp"

"cloud.google.com/go/spanner" "google.golang.org/api/iterator" )

// queryInformationSchemaDatabaseOptions queries the database options from the // information schema table.
func queryInformationSchemaDatabaseOptions(w io.Writer, db string) error { // db = `projects//instances//database/` matches := regexp.MustCompile("^(.+)/databases/(.+)$").FindStringSubmatch(db) if matches == nil || len(matches) != 3 { return fmt.Errorf("queryInformationSchemaDatabaseOptions: invalid database id %q", db) } databaseID := matches[2]

ctx := context.Background() client, err := spanner.NewClient(ctx, db) if err != nil { return err } defer client.Close()

stmt := spanner.Statement{SQL: `SELECT OPTION_NAME, OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS WHERE OPTION_NAME = 'default_leader'`} iter := client.Single().Query(ctx, stmt) defer iter.Stop()

for { row, err := iter.Next() if err == iterator.Done { return nil } if err != nil { return err } var option_name, option_value string if err := row.Columns(&option_name, &option_value); err != nil { return err } fmt.Fprintf(w, "The result of the query to get %s for %s is %s", option_name, databaseID, option_value) } }

Java

import com.google.cloud.spanner.DatabaseClient;
import com.google.cloud.spanner.DatabaseId;
import com.google.cloud.spanner.ResultSet;
import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.Statement;

public class QueryInformationSchemaDatabaseOptionsSample {

static void queryInformationSchemaDatabaseOptions() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
final String databaseId = "my-database";
queryInformationSchemaDatabaseOptions(projectId, instanceId, databaseId);
}

static void queryInformationSchemaDatabaseOptions( String projectId, String instanceId, String databaseId) { try (Spanner spanner = SpannerOptions .newBuilder() .setProjectId(projectId) .build() .getService()) { final DatabaseId id = DatabaseId.of(projectId, instanceId, databaseId);
final DatabaseClient databaseClient = spanner.getDatabaseClient(id);

try (ResultSet resultSet = databaseClient .singleUse() .executeQuery(Statement.of( "SELECT OPTION_NAME, OPTION_VALUE" + " FROM INFORMATION_SCHEMA.DATABASE_OPTIONS" + " WHERE OPTION_NAME = 'default_leader'") )) { if (resultSet.next()) { final String optionName = resultSet.getString("OPTION_NAME");
final String optionValue = resultSet.getString("OPTION_VALUE");

System.out.println("The " + optionName + " for " + id + " is " + optionValue);
} else { System.out.println( "Database " + id + " does not have a value for option 'default_leader'" );
} } } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance-id';
// const databaseId = 'my-database-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });
// Gets a reference to a Cloud Spanner instance and a database.
const instance = spanner.instance(instanceId);
const database = instance.database(databaseId);

async function getDatabaseDdl() { // Get the default leader option for the database.
const [rows] = await database.run({ sql: ` SELECT s.OPTION_NAME, s.OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s WHERE s.OPTION_NAME = 'default_leader'`, json: true, });
if (rows.length > 0) { const option = rows[0];
console.log( `The ${option.OPTION_NAME} for ${databaseId} is ${option.OPTION_VALUE}`, );
} else { console.log( `Database ${databaseId} does not have a value for option 'default_leader'`, );
} } getDatabaseDdl();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\SpannerClient;

/**
 * Queries the default leader of a database.
 * Example:
 * ```
 * query_information_schema_database_options($instanceId, $databaseId);
 * ```
*
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function query_information_schema_database_options(string $instanceId, string $databaseId): void { $spanner = new SpannerClient();
$instance = $spanner->instance($instanceId);
$database = $instance->database($databaseId);

$results = $database->execute( "SELECT s.OPTION_NAME, s.OPTION_VALUE FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s WHERE s.OPTION_NAME = 'default_leader'" );

foreach ($results as $row) { $optionName = $row['OPTION_NAME'];
$optionValue = $row['OPTION_VALUE'];
printf("The $optionName for $databaseId is $optionValue" . PHP_EOL);
} if (!$results->stats()['rowCountExact']) { printf("Database $databaseId does not have a value for option 'default_leader'");
} }

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def query_information_schema_database_options(instance_id, database_id):
"""Queries the default leader of a database.""" spanner_client = spanner.Client() instance = spanner_client.instance(instance_id) database = instance.database(database_id) with database.snapshot() as snapshot:
results = snapshot.execute_sql( "SELECT OPTION_VALUE AS default_leader " "FROM INFORMATION_SCHEMA.DATABASE_OPTIONS " "WHERE SCHEMA_NAME = '' AND OPTION_NAME = 'default_leader'" ) for result in results:
print("Database {} has default leader {}".format(database_id, result[0]))

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# database_id = "Your Spanner database ID

require "google/cloud/spanner"

spanner = Google::Cloud::Spanner.new project: project_id client = spanner.client instance_id, database_id

client.execute( "SELECT s.OPTION_NAME, s.OPTION_VALUE " \ "FROM INFORMATION_SCHEMA.DATABASE_OPTIONS s " \ "WHERE s.OPTION_NAME = 'default_leader'" ).rows.each do |row| puts row end

查看多个数据库的主要区域

客户端库

C#

using Google.Cloud.Spanner.Admin.Database.V1;
using Google.Cloud.Spanner.Common.V1;
using System;
using System.Collections.Generic;
using System.Linq;

public class ListDatabasesSample { public IEnumerable ListDatabases(string projectId, string instanceId) { var databaseAdminClient = DatabaseAdminClient.Create();
var instanceName = InstanceName.FromProjectInstance(projectId, instanceId);
var databases = databaseAdminClient.ListDatabases(instanceName);

// We print the first 5 elements for demonstration purposes.
// You can print all databases in the sequence by removing the call to Take(5).
// The sequence will lazily fetch elements in pages as needed.
foreach (var database in databases.Take(5)) { Console.WriteLine($"Default leader for database {database.DatabaseName.DatabaseId}: {database.DefaultLeader}");
}

return databases;
} }

C++

void ListDatabases(google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id) { google::cloud::spanner::Instance in(project_id, instance_id);
int count = 0;
for (auto& database : client.ListDatabases(in.FullName())) { if (!database) throw std::move(database).status();
std::cout name() << " full metadata:\n" DebugString();
++count;
} if (count == 0) { std::cout << "No databases found in instance " << instance_id << " for project << " << project_id << "\n";
} }

Go

import (
"context" "fmt" "io"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" "google.golang.org/api/iterator" )

// listDatabases gets list of all databases for an instance func listDatabases(w io.Writer, instanceId string) error { // instanceId = `projects//instances/ ctx := context.Background() adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

iter := adminClient.ListDatabases(ctx, &adminpb.ListDatabasesRequest{ Parent: instanceId, })

fmt.Fprintf(w, "Databases for instance/[%s]", instanceId) for { resp, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } fmt.Fprintf(w, "%s\n", resp.Name) }

return nil

}

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient.ListDatabasesPage;
import com.google.cloud.spanner.admin.database.v1.DatabaseAdminClient.ListDatabasesPagedResponse;
import com.google.spanner.admin.database.v1.Database;
import com.google.spanner.admin.database.v1.InstanceName;

public class ListDatabasesSample {

static void listDatabases() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceId = "my-instance";
listDatabases(projectId, instanceId);
}

static void listDatabases(String projectId, String instanceId) { try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
DatabaseAdminClient databaseAdminClient = spanner.createDatabaseAdminClient()) { ListDatabasesPagedResponse response = databaseAdminClient.listDatabases(InstanceName.of(projectId, instanceId));

System.out.println("Databases for projects/" + projectId + "/instances/" + instanceId);

for (ListDatabasesPage page : response.iteratePages()) { for (Database database : page.iterateAll()) { final String defaultLeader = database.getDefaultLeader().equals("") ? "" : "(default leader = " + database.getDefaultLeader() + ")";
System.out.println("\t" + database.getName() + " " + defaultLeader);
} } } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// creates a client const spanner = new Spanner({ projectId: projectId, });

const databaseAdminClient = spanner.getDatabaseAdminClient();

async function listDatabases() { // Lists all databases on the instance.
const [databases] = await databaseAdminClient.listDatabases({ parent: databaseAdminClient.instancePath(projectId, instanceId), });
console.log(`Databases for projects/${projectId}/instances/${instanceId}:`);
databases.forEach(database => { const defaultLeader = database.defaultLeader ? `(default leader = ${database.defaultLeader})` : '';
console.log(`\t${database.name} ${defaultLeader}`);
});
} listDatabases();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\ListDatabasesRequest;

/**
 * Lists the databases and their leader options.
 * Example:
 * ```
 * list_databases($projectId, $instanceId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
*/ function list_databases(string $projectId, string $instanceId): void { $databaseAdminClient = new DatabaseAdminClient();
$instanceName = DatabaseAdminClient::instanceName($projectId, $instanceId);

$request = new ListDatabasesRequest(['parent' => $instanceName]);
$resp = $databaseAdminClient->listDatabases($request);
$databases = $resp->iterateAllElements();
printf('Databases for %s' . PHP_EOL, $instanceName);
foreach ($databases as $database) { printf("\t%s (default leader = %s)" . PHP_EOL, $database->getName(), $database->getDefaultLeader());
} }

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def list_databases(instance_id):
"""Lists databases and their leader options.""" from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.ListDatabasesRequest( parent=database_admin_api.instance_path(spanner_client.project, instance_id) )

for database in database_admin_api.list_databases(request=request):
print( "Database {} has default leader {}".format( database.name, database.default_leader ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/database"

db_admin_client = Google::Cloud::Spanner::Admin::Database.database_admin project_id: project_id

instance_path = db_admin_client.instance_path project: project_id, instance: instance_id databases = db_admin_client.list_databases parent: instance_path

databases.each do |db| puts "#{db.name} : default leader #{db.default_leader}" end

查看可用主要区域选项

查看实例配置的可用主要区域选项

gcloud 如需查看可设置为默认主要区域的区域，请使用以下命令：

gcloud spanner instance-configs describe INSTANCE_CONFIG

替换以下内容：

INSTANCE_CONFIG：实例配置的永久性标识符，该标识符定义实例的地理位置，并且会影响数据的复制方式。对于自定义实例配置，它以 custom- 开头。如需了解详情，请参阅实例配置。

leaderOptions 下列出了您可以选择的区域。

客户端库

C#

using Google.Cloud.Spanner.Admin.Instance.V1;
using System;
using System.Threading.Tasks;

public class GetInstanceConfigAsyncSample { public async Task GetInstanceConfigAsync(string projectId, string instanceConfigId) { var instanceAdminClient = await InstanceAdminClient.CreateAsync();
var instanceConfigName = InstanceConfigName.FromProjectInstanceConfig(projectId, instanceConfigId);
var instanceConfig = await instanceAdminClient.GetInstanceConfigAsync(instanceConfigName);

Console.WriteLine($"Available leader options for instance config {instanceConfigName.InstanceConfigId}:");
foreach (var leader in instanceConfig.LeaderOptions) { Console.WriteLine(leader);
} return instanceConfig;
} }

C++

void GetInstanceConfig(google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& config_id) { auto project = google::cloud::Project(project_id);
auto config = client.GetInstanceConfig(project.FullName() + "/instanceConfigs/" + config_id);
if (!config) throw std::move(config).status();
std::cout name() << " exists and its metadata is:\n" DebugString();
}

Go

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// getInstanceConfig gets available leader options func getInstanceConfig(w io.Writer, instanceConfigName string) error { // defaultLeader = `nam3` ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

ic, err := instanceAdmin.GetInstanceConfig(ctx, &instancepb.GetInstanceConfigRequest{ Name: instanceConfigName, })

if err != nil { return fmt.Errorf("could not get instance config %s: %w", instanceConfigName, err) }

fmt.Fprintf(w, "Available leader options for instance config %s: %v", instanceConfigName, ic.LeaderOptions)

return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.InstanceConfig;
import com.google.spanner.admin.instance.v1.InstanceConfigName;

public class GetInstanceConfigSample {

static void getInstanceConfig() { // TODO(developer): Replace these variables before running the sample.
final String projectId = "my-project";
final String instanceConfigId = "nam6";
getInstanceConfig(projectId, instanceConfigId);
}

static void getInstanceConfig(String projectId, String instanceConfigId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { final InstanceConfigName instanceConfigName = InstanceConfigName.of(projectId, instanceConfigId);

final InstanceConfig instanceConfig = instanceAdminClient.getInstanceConfig(instanceConfigName.toString());

System.out.printf( "Available leader options for instance config %s: %s%n", instanceConfig.getName(), instanceConfig.getLeaderOptionsList() );
} } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following line before running the sample.
*/ // const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

async function getInstanceConfig() { // Get the instance config for the multi-region North America 6 (NAM6).
// See https://cloud.google.com/spanner/docs/instance-configurations#configuration for a list of all available // configurations.
const [instanceConfig] = await instanceAdminClient.getInstanceConfig({ name: instanceAdminClient.instanceConfigPath(projectId, 'nam6'), });
console.log( `Available leader options for instance config ${instanceConfig.name} ('${ instanceConfig.displayName }'):
${instanceConfig.leaderOptions.join()}`, );
} getInstanceConfig();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\GetInstanceConfigRequest;

/**
 * Gets the leader options for the instance configuration.
*
 * @param string $projectId The Google Cloud Project ID.
 * @param string $instanceConfig The name of the instance configuration.
*/ function get_instance_config(string $projectId, string $instanceConfig): void { $instanceAdminClient = new InstanceAdminClient();
$instanceConfigName = InstanceAdminClient::instanceConfigName($projectId, $instanceConfig);

$request = (new GetInstanceConfigRequest()) ->setName($instanceConfigName);
$configInfo = $instanceAdminClient->getInstanceConfig($request);

printf('Available leader options for instance config %s: %s' . PHP_EOL, $instanceConfig, implode(',', array_keys(iterator_to_array($configInfo->getLeaderOptions()))) );
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def get_instance_config(instance_config):
"""Gets the leader options for the instance configuration.""" spanner_client = spanner.Client() config_name = "{}/instanceConfigs/{}".format( spanner_client.project_name, instance_config ) config = spanner_client.instance_admin_api.get_instance_config(name=config_name) print( "Available leader options for instance config {}: {}".format( instance_config, config.leader_options ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"
# instance_config_id = "Spanner instance config ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin

instance_config_path = instance_admin_client.instance_config_path \ project: project_id, instance_config: instance_config_id config = instance_admin_client.get_instance_config name: instance_config_path

puts "Available leader options for instance config #{config.name} : #{config.leader_options}"

查看所有实例配置的可用主要区域选项

gcloud 如需查看可设置为所有实例配置的默认主要区域的区域，请运行以下命令：

gcloud spanner instance-configs list

客户端库

C#

using Google.Api.Gax.ResourceNames;
using Google.Cloud.Spanner.Admin.Instance.V1;
using System;
using System.Collections.Generic;
using System.Linq;

public class ListInstanceConfigsSample { public IEnumerable ListInstanceConfigs(string projectId) { var instanceAdminClient = InstanceAdminClient.Create();
var projectName = ProjectName.FromProject(projectId);
var instanceConfigs = instanceAdminClient.ListInstanceConfigs(projectName);

// We print the first 5 elements for demonstration purposes.
// You can print all configs in the sequence by removing the call to Take(5).
// The sequence will lazily fetch elements in pages as needed.
foreach (var instanceConfig in instanceConfigs.Take(5)) { Console.WriteLine($"Available leader options for instance config {instanceConfig.InstanceConfigName.InstanceConfigId}:");
foreach (var leader in instanceConfig.LeaderOptions) { Console.WriteLine(leader);
}

Console.WriteLine($"Available optional replica for instance config {instanceConfig.InstanceConfigName.InstanceConfigId}:");
foreach (var optionalReplica in instanceConfig.OptionalReplicas) { Console.WriteLine($"Replica type - {optionalReplica.Type}, default leader location - {optionalReplica.DefaultLeaderLocation}, location - {optionalReplica.Location}");
} } return instanceConfigs;
} }

C++

void ListInstanceConfigs( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id) { int count = 0;
auto project = google::cloud::Project(project_id);
for (auto& config : client.ListInstanceConfigs(project.FullName())) { if (!config) throw std::move(config).status();
++count;
std::cout << "Instance config [" << count << "]:\n" DebugString();
} if (count == 0) { std::cout << "No instance configs found in project " << project_id << "\n";
} }

Go

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/api/iterator" )

// istInstanceConfigs gets available leader options for all instances func listInstanceConfigs(w io.Writer, projectName string) error { // projectName = `projects/ ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

request := &instancepb.ListInstanceConfigsRequest{ Parent: projectName, } for { iter := instanceAdmin.ListInstanceConfigs(ctx, request) for { ic, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } fmt.Fprintf(w, "Available leader options for instance config %s: %v\n", ic.Name, ic.LeaderOptions) } pageToken := iter.PageInfo().Token if pageToken == "" { break } else { request.PageToken = pageToken } }

return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.InstanceConfig;
import com.google.spanner.admin.instance.v1.ProjectName;

public class ListInstanceConfigsSample {

static void listInstanceConfigs() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
listInstanceConfigs(projectId);
}

static void listInstanceConfigs(String projectId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { final ProjectName projectName = ProjectName.of(projectId);
for (InstanceConfig instanceConfig :
instanceAdminClient.listInstanceConfigs(projectName).iterateAll()) { System.out.printf( "Available leader options for instance config %s: %s%n", instanceConfig.getName(), instanceConfig.getLeaderOptionsList() );
} } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

/**
 * TODO(developer): Uncomment the following line before running the sample.
*/ // const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

async function listInstanceConfigs() { // Lists all available instance configurations in the project.
// See https://cloud.google.com/spanner/docs/instance-configurations#configuration for a list of all available // configurations.
const [instanceConfigs] = await instanceAdminClient.listInstanceConfigs({ parent: instanceAdminClient.projectPath(projectId), });
console.log(`Available instance configs for project ${projectId}:`);
instanceConfigs.forEach(instanceConfig => { console.log( `Available leader options for instance config ${ instanceConfig.name } ('${instanceConfig.displayName}'):
${instanceConfig.leaderOptions.join()}`, );
});
} listInstanceConfigs();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\ListInstanceConfigsRequest;

/**
 * Lists the available instance configurations.
 * Example:
 * ```
 * list_instance_configs();
 * ```
*
 * @param string $projectId The Google Cloud project ID.
*/ function list_instance_configs(string $projectId): void { $instanceAdminClient = new InstanceAdminClient();
$projectName = InstanceAdminClient::projectName($projectId);
$request = new ListInstanceConfigsRequest();
$request->setParent($projectName);
$resp = $instanceAdminClient->listInstanceConfigs($request);
foreach ($resp as $element) { printf( 'Available leader options for instance config %s: %s' . PHP_EOL, $element->getDisplayName(), implode(',', iterator_to_array($element->getLeaderOptions())) );
} }

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

def list_instance_config():
"""Lists the available instance configurations.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client()

request = spanner_instance_admin.ListInstanceConfigsRequest( parent=spanner_client.project_name ) for config in spanner_client.instance_admin_api.list_instance_configs( request=request ):
print( "Available leader options for instance config {}: {}".format( config.name, config.leader_options ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

# project_id  = "Your Google Cloud project ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin

project_path = instance_admin_client.project_path project: project_id configs = instance_admin_client.list_instance_configs parent: project_path

configs.each do |c| puts "Available leader options for instance config #{c.name} : #{c.leader_options}" end

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
