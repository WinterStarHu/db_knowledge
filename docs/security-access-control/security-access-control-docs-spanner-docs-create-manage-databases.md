# 创建和管理数据库  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-manage-databases

创建和管理数据库  |  Spanner  |  Google Cloud Documentation

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

创建和管理数据库

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何创建和管理 Spanner 数据库：

创建数据库的各种方法

修改数据库选项

删除数据库

本页面包含适用于 GoogleSQL 方言数据库和 PostgreSQL 方言数据库的信息。如需了解如何更新数据库架构，请参阅更新架构。如需详细了解如何创建实例，请参阅创建和管理实例。
您可以通过以下任一方式在现有实例中创建数据库：

创建数据库：您可以选择 SQL 方言并定义架构，从而创建新数据库。

导入您自己的数据：您可以将 CSV 文件、MySQL 转储文件或 PostgreSQL 转储文件导入到新数据库或现有数据库中。

创建包含示例数据的数据库：您可以使用其中一个可用的示例数据集填充数据库，以试用 Spanner 的各项功能。

创建数据库

您可以在现有实例中创建新数据库。对于 GoogleSQL 方言数据库，您可以在数据库创建时或数据库创建后定义数据库架构。对于 PostgreSQL 方言数据库，您必须在创建后定义架构。

架构是使用数据库定义语言定义的，该语言已针对 GoogleSQL 和 PostgreSQL 进行说明。如需详细了解如何创建和更新架构，请参阅以下链接：

架构和数据模型

架构设计最佳做法

架构更新

创建数据库后，您可以通过启用数据库防删除保护来保护对应用和服务至关重要的数据库。如需了解详情，请参阅防止意外删除数据库。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择要在其中创建数据库的实例。

点击创建数据库。

输入以下值：

要在 Google Cloud 控制台中显示的数据库名称。

要用于此数据库的方言。

对于 GoogleSQL 方言数据库，您可以选择提供一组用于定义架构的 DDL 语句。使用 DDL 模板预填充常见元素。如果 DDL 语句中存在错误， Google Cloud 控制台会在您尝试创建数据库时返回错误。

（可选）选择要用于此数据库的客户管理的加密密钥。

点击创建以创建数据库。

gcloud 使用 gcloud spanner databases create 命令。

```sh
gcloud spanner databases create DATABASE \
  --instance=INSTANCE \
  [--async] \
  [--database-dialect=DATABASE_DIALECT] \
  [--ddl=DDL] \
  [--ddl-file=DDL_FILE] \
  [--kms-key=KMS_KEY : --kms-keyring=KMS_KEYRING --kms-location=KMS_LOCATION --kms-project=KMS_PROJECT] \
  [GCLOUD_WIDE_FLAG …]
```

以下选项为必需：

DATABASE 数据库的 ID 或数据库的完全限定标识符。如果指定完全限定标识符，则可以忽略 --instance 标志。
--instance=INSTANCE 数据库的 Spanner 实例。

以下选项为可选：

--async 立即返回结果，而无需等待正在进行的操作完成。

--database-dialect=DATABASE_DIALECT Spanner 数据库的 SQL 方言。必须是以下各项之一：POSTGRESQL、GOOGLE_STANDARD_SQL。

--ddl=DDL 以分号分隔的 DDL（数据定义语言）语句，用于在新创建的数据库内运行。如果任何语句中存在错误，系统将不会创建数据库。如果设置了 --ddl_file，则会忽略此标志。PostgreSQL 方言数据库不支持。

--ddl-file=DDL_FILE 包含要在新建数据库中运行的以分号分隔的 DDL（数据定义语言）语句的文件的路径。如果任何语句中存在错误，系统将不会创建数据库。如果设置了 --ddl_file，则会忽略 --ddl。PostgreSQL 方言数据库不支持。

如果您在创建数据库时指定要使用的 Cloud Key Management Service 密钥，请添加以下选项：

--kms-key=KMS_KEY 密钥的 ID 或密钥的完全限定标识符。

如果指定了此群组中的任何其他参数，则必须指定此标志。如果提供了完全限定标识符，则可以忽略其他参数。

--kms-keyring=KMS_KEYRING 密钥的 Cloud KMS 密钥环 ID。

--kms-location=KMS_LOCATION 密钥的Google Cloud 位置。

--kms-project=KMS_PROJECT 密钥的Google Cloud 项目 ID。

客户端 (GoogleSQL)

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

void CreateDatabase(google::cloud::spanner_admin::DatabaseAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& database_id) { google::cloud::spanner::Database database(project_id, instance_id, database_id);
google::spanner::admin::database::v1::CreateDatabaseRequest request;
request.set_parent(database.instance().FullName());
request.set_create_statement("CREATE DATABASE `" + database.database_id() + "`");
request.add_extra_statements(R"""( CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), FullName   STRING(2049) AS (ARRAY_TO_STRING([FirstName, LastName], " ")) STORED ) PRIMARY KEY (SingerId))""");
request.add_extra_statements(R"""( CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE)""");
auto db = client.CreateDatabase(request).get();
if (!db) throw std::move(db).status();
std::cout name() << " created.\n";
}

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

import (
"context" "fmt" "io" "regexp"

database "cloud.google.com/go/spanner/admin/database/apiv1" adminpb "cloud.google.com/go/spanner/admin/database/apiv1/databasepb" )

func createDatabase(ctx context.Context, w io.Writer, db string) error { matches := regexp.MustCompile("^(.*)/databases/(.*)$").FindStringSubmatch(db) if matches == nil || len(matches) != 3 { return fmt.Errorf("Invalid database id %s", db) }

adminClient, err := database.NewDatabaseAdminClient(ctx) if err != nil { return err } defer adminClient.Close()

op, err := adminClient.CreateDatabase(ctx, &adminpb.CreateDatabaseRequest{ Parent:          matches[1], CreateStatement: "CREATE DATABASE `" + matches[2] + "`", ExtraStatements: []string{ `CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), FullName   STRING(2048) AS ( ARRAY_TO_STRING([FirstName, LastName], " ") ) STORED ) PRIMARY KEY (SingerId)`, `CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE`, }, }) if err != nil { return err } if _, err := op.Wait(ctx); err != nil { return err } fmt.Fprintf(w, "Created database [%s]\n", db) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

use Google\Cloud\Spanner\Admin\Database\V1\Client\DatabaseAdminClient;
use Google\Cloud\Spanner\Admin\Database\V1\CreateDatabaseRequest;

/**
 * Creates a database and tables for sample data.
 * Example:
 * ```
 * create_database($instanceId, $databaseId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $databaseId The Spanner database ID.
*/ function create_database(string $projectId, string $instanceId, string $databaseId): void { $databaseAdminClient = new DatabaseAdminClient();
$instance = $databaseAdminClient->instanceName($projectId, $instanceId);

$operation = $databaseAdminClient->createDatabase( new CreateDatabaseRequest([ 'parent' => $instance, 'create_statement' => sprintf('CREATE DATABASE `%s`', $databaseId), 'extra_statements' => [ 'CREATE TABLE Singers (' .
'SingerId     INT64 NOT NULL,' .
'FirstName    STRING(1024),' .
'LastName     STRING(1024),' .
'SingerInfo   BYTES(MAX),' .
'FullName     STRING(2048) AS' .
'(ARRAY_TO_STRING([FirstName, LastName], " ")) STORED' .
') PRIMARY KEY (SingerId)', 'CREATE TABLE Albums (' .
'SingerId     INT64 NOT NULL,' .
'AlbumId      INT64 NOT NULL,' .
'AlbumTitle   STRING(MAX)' .
') PRIMARY KEY (SingerId, AlbumId),' .
'INTERLEAVE IN PARENT Singers ON DELETE CASCADE' ] ]) );

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf('Created database %s on instance %s' . PHP_EOL, $databaseId, $instanceId);
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

def create_database(instance_id, database_id):
"""Creates a database and tables for sample data.""" from google.cloud.spanner_admin_database_v1.types import spanner_database_admin

spanner_client = spanner.Client() database_admin_api = spanner_client.database_admin_api

request = spanner_database_admin.CreateDatabaseRequest( parent=database_admin_api.instance_path(spanner_client.project, instance_id), create_statement=f"CREATE DATABASE `{database_id}`", extra_statements=[ """CREATE TABLE Singers ( SingerId     INT64 NOT NULL, FirstName    STRING(1024), LastName     STRING(1024), SingerInfo   BYTES(MAX), FullName   STRING(2048) AS ( ARRAY_TO_STRING([FirstName, LastName], " ") ) STORED ) PRIMARY KEY (SingerId)""", """CREATE TABLE Albums ( SingerId     INT64 NOT NULL, AlbumId      INT64 NOT NULL, AlbumTitle   STRING(MAX) ) PRIMARY KEY (SingerId, AlbumId), INTERLEAVE IN PARENT Singers ON DELETE CASCADE""", ], )

operation = database_admin_api.create_database(request=request)

print("Waiting for operation to complete...") database = operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Created database {} on instance {}".format( database.name, database_admin_api.instance_path(spanner_client.project, instance_id), ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

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

导入自己的数据

您可以使用 CSV 文件、MySQL 转储文件或 PostgreSQL 转储文件将自己的数据导入到 Spanner 数据库中。您可以使用 Cloud Storage 上传本地文件，也可以直接从 Cloud Storage 存储桶上传本地文件。使用 Cloud Storage 上传本地文件可能会产生费用。

如果您选择使用 CSV 文件，还需要上传一个包含数据库架构的单独 JSON 文件。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择要在其中创建数据库的实例。

点击导入我自己的数据。

输入以下值：

选择文件类型。

从计算机上传文件，或选择文件所在的 Cloud Storage 存储桶路径。

（可选）如果您选择使用 CSV 文件，还需要上传一个包含数据库架构的单独 JSON 文件。JSON 文件必须使用以下结构来定义架构：

{ "name": "COLUMN_NAME", "type": "TYPE", "notNull": NOT_NULL_VALUE, "primaryKeyOrder": PRIMARY_KEY_ORDER }

替换以下内容：

COLUMN_NAME：表格中的列名称。

TYPE：列的数据类型。

（可选）NOT_NULL_VALUE：列是否可以存储 null 值。有效输入为 true 或 false。默认值为 false。

（可选）：PRIMARY_KEY_ORDER：确定主键顺序。对于非主键列，将值设置为 0。对于主键列，请将该值设置为一个整数（例如 1）。在复合主键中，编号较小的列会显示在前面。

默认情况下，CSV 文件使用英文逗号作为字段分隔符，使用换行符作为行分隔符。如需详细了解如何使用自定义分隔符，请参阅 gcloud alpha spanner databases import 参考文档。

选择新数据库或现有数据库作为目标数据库。

点击导入。

Spanner 会打开 Cloud Shell 并填充一个命令，该命令用于安装 Spanner 迁移工具并运行 gcloud alpha spanner databases import 命令。按 ENTER 键将数据导入数据库。

使用示例数据集

您可以通过示例数据集填充现有实例中的新数据库，这些数据集可帮助您探索 Spanner 的各项功能，例如其关系模型、全文搜索或向量搜索。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择要在其中创建数据库的实例。

点击探索数据集。

选择以下某个数据集：

财务图：使用此数据集探索 Spanner 的图功能。

网上银行：使用此数据集探索 Spanner 的全文搜索功能。

在线游戏：使用此数据集探索 Spanner 的关系型数据库功能。

零售：使用此数据集探索 Spanner 的图和全文搜索功能。

点击创建数据库。

更新数据库架构或选项

您可以使用 DDL 语句更新数据库架构和选项。

例如，如需向表添加列，请使用以下 DDL 语句：

GoogleSQL

ALTER TABLE Songwriters ADD COLUMN Publisher STRING(10);

PostgreSQL

ALTER TABLE Songwriters ADD COLUMN Publisher VARCHAR(10);

如需更新查询优化器版本，请使用以下 DDL 语句：

GoogleSQL

ALTER DATABASE Music SET OPTIONS(optimizer_version=null);

PostgreSQL

ALTER DATABASE DB-NAME SET spanner.optimizer_version TO DEFAULT;

如需详细了解支持的选项，请参阅 GoogleSQL 或 PostgreSQL 的 ALTER DATABASE DDL 参考文档。

如需了解架构更新，请参阅更新架构。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择包含要更改的数据库的实例。

选择相应数据库。

点击 Spanner Studio。

点击 add 新标签页，或使用空白编辑器标签页。然后，输入要应用的 DDL 语句。

点击运行以应用更新。如果 DDL 中出现错误， Google Cloud 控制台会返回错误，并且数据库不会更改。

gcloud 如需使用 gcloud 命令行工具更改数据库，请使用 gcloud spanner databases ddl update。

gcloud spanner databases ddl update \ (DATABASE : --instance=INSTANCE) \ [--async] \ [--ddl=DDL] \ [--ddl-file=DDL_FILE] \

如需详细了解可用选项，请参阅 gcloud 参考文档。

将数据库更新传递给带有 --ddl 标志或 --ddl-file 标志的命令。如果指定了 DDL 文件，则会忽略 --ddl 标志。

如需了解要包含的 DDL 语句，请参阅 GoogleSQL 或 PostgreSQL 的 ALTER DATABASE DDL 参考文档。

DDL 如需了解详情，请参阅 GoogleSQL 或 PostgreSQL 的 ALTER DATABASE DDL 参考文档。

检查架构更新操作的进度

如需查看架构更新操作的进度，请选择以下方法之一：

Google Cloud 控制台

在 Spanner 导航菜单中，选择操作标签页。操作页面会显示正在运行的活跃操作的列表。

在列表中查找架构操作。如果任务仍在运行，结束时间列中的进度条会显示操作已完成的百分比，如下图所示：

gcloud 使用 gcloud spanner operations describe 检查操作的进度。

获取操作 ID：

gcloud spanner operations list --instance=INSTANCE-NAME \ --database=DATABASE-NAME --type=DATABASE_UPDATE_DDL

替换以下内容：

将 INSTANCE-NAME 替换为 Spanner 实例名称。

将 DATABASE-NAME 替换为数据库的名称。

运行 gcloud spanner operations describe：

gcloud spanner operations describe OPERATION_ID\ --instance=INSTANCE-NAME \ --database=DATABASE-NAME

替换以下内容：

OPERATION-ID：要检查的操作的 ID。

INSTANCE-NAME：Spanner 实例名称。

DATABASE-NAME：Spanner 数据库名称。

输出中的 progress 部分显示操作的完成百分比。输出类似于以下内容：

done: true metadata:
...
progress:
  - endTime: '2022-03-01T00:28:06.691403Z'
progressPercent: 100 startTime: '2022-03-01T00:28:04.221401Z'
  - endTime: '2022-03-01T00:28:17.624588Z'
startTime: '2022-03-01T00:28:06.691403Z' progressPercent: 100 ...

REST v1

获取操作 ID：

gcloud spanner operations list --instance=INSTANCE-NAME \ --database=DATABASE-NAME --type=DATABASE_UPDATE_DDL

替换以下内容：

将 INSTANCE-NAME 替换为 Spanner 实例名称。

DATABASE-NAME 替换为数据库名称。

检查操作的进度。

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

如果操作花费的时间过长，您可以取消它。如需了解详情，请参阅取消长时间运行的数据库操作。

Spanner 还会自动检测应用架构设计最佳实践的机会。如果您的数据库有建议，您可以在其 Spanner Studio 页面上查看这些建议。如需了解详情，请参阅查看架构设计最佳实践建议。

删除数据库

删除数据库将会永久移除该数据库及其所有数据。数据库删除操作无法撤消。如果在某个数据库上启用了数据库防删除保护，您必须先停用其防删除保护，才能删除该数据库。

删除数据库时，现有备份不会删除。如需了解详情，请参阅备份和恢复。

Google Cloud 控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选择包含要删除的数据库的实例。

选择相应数据库。

点击删除数据库。系统会显示确认消息。

输入数据库名称，然后点击删除。

gcloud 如需使用 gcloud 命令行工具删除数据库，请使用 gcloud spanner databases delete。

gcloud spanner databases delete \ (DATABASE : --instance=INSTANCE)

以下选项为必需：

DATABASE 数据库的 ID 或数据库的完全限定标识符。如果已提供完全限定标识符，应忽略 --instance 标志。
--instance=INSTANCE 数据库的 Spanner 实例。

如需了解详情，请参阅 gcloud 参考文档。

DDL DDL 不支持数据库删除语法。

后续步骤

创建数据库并使用示例数据加载该数据库。

详细了解 GoogleSQL DDL 参考文档。

详细了解 PostgreSQL DDL 参考文档。

了解如何备份和恢复数据库。

了解如何防止意外删除数据库。

了解如何更新架构。

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
