# 创建和管理实例配置  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-manage-configurations

创建和管理实例配置  |  Spanner  |  Google Cloud Documentation

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

创建和管理实例配置

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何列出、创建、更新、删除和显示 Spanner 实例配置的详细信息。Google Cloud 控制台界面中不提供某些自定义实例配置功能。在这些情况下，请使用提供的 Google Cloud CLI (gcloud) 命令。

列出实例配置

您可以使用 Google Cloud CLI 和客户端库列出所有可用的 Spanner 实例配置。如需获得所有 Spanner 实例配置的列表，请参阅区域级和多区域配置。

gcloud 运行 gcloud spanner instance-configs list 命令：

gcloud spanner instance-configs list

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void ListInstanceConfigs( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id) { int count = 0;
auto project = google::cloud::Project(project_id);
for (auto& config : client.ListInstanceConfigs(project.FullName())) { if (!config) throw std::move(config).status();
++count;
std::cout << "Instance config [" << count << "]:\n" DebugString();
} if (count == 0) { std::cout << "No instance configs found in project " << project_id << "\n";
} }

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/api/iterator" )

// istInstanceConfigs gets available leader options for all instances func listInstanceConfigs(w io.Writer, projectName string) error { // projectName = `projects/ ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

request := &instancepb.ListInstanceConfigsRequest{ Parent: projectName, } for { iter := instanceAdmin.ListInstanceConfigs(ctx, request) for { ic, err := iter.Next() if err == iterator.Done { break } if err != nil { return err } fmt.Fprintf(w, "Available leader options for instance config %s: %v\n", ic.Name, ic.LeaderOptions) } pageToken := iter.PageInfo().Token if pageToken == "" { break } else { request.PageToken = pageToken } }

return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def list_instance_config():
"""Lists the available instance configurations.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client()

request = spanner_instance_admin.ListInstanceConfigsRequest( parent=spanner_client.project_name ) for config in spanner_client.instance_admin_api.list_instance_configs( request=request ):
print( "Available leader options for instance config {}: {}".format( config.name, config.leader_options ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

# project_id  = "Your Google Cloud project ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin

project_path = instance_admin_client.project_path project: project_id configs = instance_admin_client.list_instance_configs parent: project_path

configs.each do |c| puts "Available leader options for instance config #{c.name} : #{c.leader_options}" end

显示实例配置详细信息

您可以使用 Google Cloud CLI 和客户端库显示任何实例配置的详细信息。创建新的自定义实例配置时，您可以将 optionalReplicas 下列出的任何位置添加为可选副本。如果您没有看到所需的只读副本位置，可以申请新的可选只读副本区域。

如需了解详情，请参阅创建自定义实例配置。

gcloud 运行 gcloud spanner instance-configs describe 命令：

gcloud spanner instance-configs describe INSTANCE-CONFIG

请提供以下值：

INSTANCE-CONFIG 实例配置，该配置定义了实例的地理位置，并且会影响数据的复制方式。例如 eur6 或 regional-us-central1。

如需显示 eur6 基本配置的详细信息，请运行以下命令：

gcloud spanner instance-configs describe eur6

以下是 eur6 基本配置的示例输出：

configType: GOOGLE_MANAGED displayName: Europe (Netherlands, Frankfurt) freeInstanceAvailability: UNSUPPORTED leaderOptions:
  - europe-west3
  - europe-west4
name: projects/cloud-spanner-demo/instanceConfigs/eur6 optionalReplicas:
  - displayName: South Carolina
labels:
cloud.googleapis.com/country: US cloud.googleapis.com/location: us-east1 cloud.googleapis.com/region: us-east1 location: us-east1 type: READ_ONLY
  - displayName: South Carolina
labels:
cloud.googleapis.com/country: US cloud.googleapis.com/location: us-east1 cloud.googleapis.com/region: us-east1 location: us-east1 type: READ_ONLY replicas:
  - defaultLeaderLocation: true
location: europe-west4 type: READ_WRITE
  - location: europe-west4
type: READ_WRITE
  - location: europe-west3
type: READ_WRITE
  - location: europe-west3
type: READ_WRITE
  - location: europe-west6
type: WITNESS

其他使用说明：

baseConfig（仅适用于自定义配置）指向基本实例配置。如需查看可用于创建自定义实例配置的基本实例配置列表，请参阅可用的区域级配置和可用的多区域配置。

configType 表示此实例配置是基本实例配置还是自定义实例配置。

etag（仅适用于自定义配置）是配置的 base64 编码字符串表示形式。它用于乐观并发控制。

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void GetInstanceConfig(google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& config_id) { auto project = google::cloud::Project(project_id);
auto config = client.GetInstanceConfig(project.FullName() + "/instanceConfigs/" + config_id);
if (!config) throw std::move(config).status();
std::cout name() << " exists and its metadata is:\n" DebugString();
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// getInstanceConfig gets available leader options func getInstanceConfig(w io.Writer, instanceConfigName string) error { // defaultLeader = `nam3` ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

ic, err := instanceAdmin.GetInstanceConfig(ctx, &instancepb.GetInstanceConfigRequest{ Name: instanceConfigName, })

if err != nil { return fmt.Errorf("could not get instance config %s: %w", instanceConfigName, err) }

fmt.Fprintf(w, "Available leader options for instance config %s: %v", instanceConfigName, ic.LeaderOptions)

return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

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

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def get_instance_config(instance_config):
"""Gets the leader options for the instance configuration.""" spanner_client = spanner.Client() config_name = "{}/instanceConfigs/{}".format( spanner_client.project_name, instance_config ) config = spanner_client.instance_admin_api.get_instance_config(name=config_name) print( "Available leader options for instance config {}: {}".format( instance_config, config.leader_options ) )

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

# project_id  = "Your Google Cloud project ID"
# instance_config_id = "Spanner instance config ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin

instance_config_path = instance_admin_client.instance_config_path \ project: project_id, instance_config: instance_config_id config = instance_admin_client.get_instance_config name: instance_config_path

puts "Available leader options for instance config #{config.name} : #{config.leader_options}"

创建自定义实例配置

具有预定义区域和复制拓扑的实例配置称为“基本实例配置”。您无法更改基本实例配置的复制拓扑。

您可以创建自定义实例配置，以便向预定义的基本实例配置添加额外的可选只读副本。这可以扩缩读取能力并支持低延迟过时读取。添加的只读副本必须位于不属于现有实例配置的区域中。如需查看可用于创建自定义实例配置的可选只读区域的列表，请参阅可用的单区域配置和可用的多区域配置下的“可选区域”列。

您无法创建自定义双区域实例配置。如需详细了解 Spanner 复制和副本类型，请参阅复制。

如需创建自定义实例配置，您必须具有 spanner.instanceConfigs.create 权限。默认情况下，具有 spanner.instances.create 权限的角色也会具有 spanner.instanceConfigs.create 权限。

控制台

您无法使用Google Cloud 控制台创建自定义实例配置。如需创建具有只读副本的实例，请使用 gcloud CLI 或客户端库。

gcloud

使用 gcloud spanner instance-configs create 命令：

gcloud spanner instance-configs create CUSTOM-INSTANCE-CONFIG-ID  \ --display-name=DISPLAY-NAME \ --base-config=BASE-CONFIG \ --labels=KEY=VALUE,[...] \ --replicas=location=LOCATION,type=TYPE[:...]

您可以使用 --clone-config 标志来方便地克隆其他基本或自定义实例配置，同时还声明特定自定义副本的位置和类型。

gcloud spanner instance-configs create CUSTOM-INSTANCE-CONFIG-ID  \ --display-name=DISPLAY-NAME \ --clone-config=INSTANCE-CONFIG \ --labels=KEY=VALUE,[...] \ --add-replicas=location=LOCATION,type=TYPE[:...] \ --skip-replicas=location=LOCATION,type=TYPE[:...]

请提供以下值：

CUSTOM-INSTANCE-CONFIG-ID 在您的 Google Cloud 项目中唯一的永久性标识符。您以后无法更改实例配置 ID。必须使用 custom- 前缀，以避免与基本实例配置发生名称冲突。DISPLAY-NAME 要在Google Cloud 控制台中为自定义实例配置显示的名称。

如果您选择使用标志“--base-config”和“--replicas”，请提供以下值：

BASE-CONFIG 自定义实例配置所基于的基本实例配置的区域名称。例如 eur6 或 regional-us-central1。
LOCATION 服务资源（副本）的区域名称，例如 us-east1。如需了解所接受的位置名称，请运行 gcloud spanner instance-configs describe INSTANCE-CONFIG 并参考 replicas 和 optionalReplicas 列表。
TYPE 副本的类型。如需了解所接受的对应位置和副本类型，请运行 gcloud spanner instance-configs describe INSTANCE-CONFIG 并参考 replicas 和 optionalReplicas 列表。类型为以下各项之一：

READ_ONLY

READ_WRITE

WITNESS

列表中的各项以“:”分隔。
除非使用 --[clone-config] 标志，否则在创建自定义实例配置时必须指定所有副本 LOCATION 和 TYPE，包括在基本配置中预定义的副本。如需了解详情，请参阅 gcloud instance-configs describe 帮助文本。

如果您选择使用 --clone-config 和 --add-replicas 标志（仅当您希望对某些副本跳过克隆时，才使用 --skip-replicas），请提供以下值：

--clone-config=INSTANCE-CONFIG

可使用此标志来方便地克隆其他基本或自定义实例配置，同时还声明特定自定义副本的位置和类型。然后使用 --add-replicas=location=LOCATION,type=TYPE 指定要添加可选副本的位置。

例如，如需创建有两个只读副本位于 us-east1 中的自定义实例配置，同时从 eur6 基本实例配置复制所有其他副本位置，请运行以下命令：

gcloud spanner instance-configs create custom-eur6 --clone-config=eur6 \ --add-replicas=location=us-east1,type=READ_ONLY:location=us-east1,type=READ_ONLY

--skip-replicas=location=LOCATION,type=TYPE

使用此标志可使任何副本跳过克隆。

例如，如需创建有一个只读副本位于 us-east4 中的自定义实例配置，同时从 nam3 基本实例配置复制所有其他副本位置（除了 us-central1 中的只读副本），请运行以下命令：

gcloud spanner instance-configs create custom-nam3 --clone-config=nam3 \ --add-replicas=location=us-east4,type=READ_ONLY \ --skip-replicas=location=us-central1,type=READ_ONLY

以下标志和值是可选的：

--labels=KEY=VALUE,[...]

KEY 和 VALUE：要添加到自定义实例配置中的键值对的列表。

键必须以小写字符开头，并且只能包含连字符 (-)、下划线 (_)、小写字符和数字。值只能包含连字符 (-)、下划线 (_)、小写字符和数字。

--validate-only

使用此标志可在执行请求之前验证请求是否会成功。

例如，如需创建使用 eur6 基本配置并且有一个额外的只读副本位于 us-east1 中的自定义实例配置，请运行以下命令：

gcloud spanner instance-configs create custom-eur6 \ --display-name="Custom eur6" --clone-config=eur6 \ --add-replicas=location=us-east1,type=READ_ONLY \

您也可以在不使用 --clone-config 标志的情况下创建自定义实例配置：

gcloud spanner instance-configs create custom-eur6 \ --display-name="Custom eur6" --base-config=eur6 \ --replicas=location=europe-west4,type=READ_WRITE:location=europe-west3,type=READ_WRITE:location=europe-west4,type=READ_WRITE:location=europe-west3,type=READ_WRITE:location=europe-west6,type=WITNESS:location=us-east1,type=READ_ONLY

您应该会看到以下输出内容：

Creating instance-config...done.

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void CreateInstanceConfig( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& user_config_id, std::string const& base_config_id) { auto project = google::cloud::Project(project_id);
auto base_config = client.GetInstanceConfig( project.FullName() + "/instanceConfigs/" + base_config_id);
if (!base_config) throw std::move(base_config).status();
if (base_config->optional_replicas().empty()) { throw std::runtime_error("No optional replicas in base config");
} google::spanner::admin::instance::v1::CreateInstanceConfigRequest request;
request.set_parent(project.FullName());
request.set_instance_config_id(user_config_id);
auto* request_config = request.mutable_instance_config();
request_config->set_name(project.FullName() + "/instanceConfigs/" + user_config_id);
request_config->set_display_name("My instance config");
// The user-managed instance config must contain all the replicas // of the base config plus at least one of the optional replicas.
*request_config->mutable_replicas() = base_config->replicas();
for (auto const& replica : base_config->optional_replicas()) { *request_config->add_replicas() = replica;
} request_config->set_base_config(base_config->name());
*request_config->mutable_leader_options() = base_config->leader_options();
request.set_validate_only(false);
auto user_config = client.CreateInstanceConfig(request).get();
if (!user_config) throw std::move(user_config).status();
std::cout << "Created instance config [" << user_config_id << "]:\n" DebugString();
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

using System;
using System.Threading.Tasks;
using Google.Api.Gax.ResourceNames;
using Google.Cloud.Spanner.Admin.Instance.V1;

public class CreateInstanceConfigAsyncSample { public async Task CreateInstanceConfigAsync(string projectId, string baseInstanceConfigId, string customInstanceConfigId) { InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();
var instanceConfigName = new InstanceConfigName(projectId, baseInstanceConfigId);
var instanceConfig = await instanceAdminClient.GetInstanceConfigAsync(instanceConfigName);

var customInstanceConfigName = new InstanceConfigName(projectId, customInstanceConfigId);

//Create a custom config.
InstanceConfig userInstanceConfig = new InstanceConfig { DisplayName = "C# test custom instance config", ConfigType = InstanceConfig.Types.Type.UserManaged, BaseConfigAsInstanceConfigName = instanceConfigName, InstanceConfigName = customInstanceConfigName, //The replicas for the custom instance configuration must include all the replicas of the base //configuration, in addition to at least one from the list of optional replicas of the base //configuration.
Replicas = { instanceConfig.Replicas }, OptionalReplicas = { new ReplicaInfo { Type = ReplicaInfo.Types.ReplicaType.ReadOnly, Location = "us-east1", DefaultLeaderLocation = false }, //The replicas for the custom instance configuration must include all the replicas of the base //configuration, in addition to at least one from the list of optional replicas of the base //configuration.
instanceConfig.OptionalReplicas } };

var operationResult = await instanceAdminClient.CreateInstanceConfigAsync(new CreateInstanceConfigRequest { ParentAsProjectName = ProjectName.FromProject(projectId), InstanceConfig = userInstanceConfig, InstanceConfigId = customInstanceConfigId });

var pollResult = await operationResult.PollUntilCompletedAsync();

if (pollResult.IsFaulted) { throw pollResult.Exception;
}

Console.WriteLine($"Instance config created successfully");
Console.WriteLine($"Available custom replication options for instance config {pollResult.Result.Name}\r\n{pollResult.Result.OptionalReplicas}");

return pollResult.Result;
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io" "time"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// createInstanceConfig creates a custom spanner instance config func createInstanceConfig(w io.Writer, projectID, userConfigID, baseConfigID string) error { // projectID := "my-project-id" // userConfigID := "custom-config", custom config names must start with the prefix “custom-”.
// baseConfigID := "my-base-config"

// Add timeout to context.
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute) defer cancel()

adminClient, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer admiadminClient.ClosebaseConfig, err := adminClient.GetInstanceConfig(ctx, &instancepb.GetInstanceConfigRequest{ Name: fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, baseConfigID), }) if err != nil { return fmt.Errorf("createInstanceConfig.GetInstanceConfig: %w", err) } if baseConfig.OptionalReplicas == nil || len(baseConfig.OptionalReplicas) == 0 { return fmt.Errorf("CreateInstanceConfig expects base config with at least from the list of optional replicas") } op, err := adminClient.CreateInstanceConfig(ctx, &instancepb.CreateInstanceConfigRequest{ Parent: fmt.Sprintf("projects/%s", projectID), // Custom config names must start with the prefix “custom-”.
InstanceConfigId: userConfigID, InstanceConfig: &instancepb.InstanceConfig{ Name:        fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, userConfigID), DisplayName: "custom-golang-samples", ConfigType:  instanceinstancepb.InstanceConfig_USER_MANAGEDThe replicas for the custom instance configuration must include all the replicas of the base // configuration, in addition to at least one from the list of optional replicas of the base // configuration.
Replicas:   append(baseConfig.Replicas, baseConfig.OptionalReplicas...), BaseConfig: baseConfig.Name, Labels:     map[string]string{"go_cloud_spanner_samples": "true"}, }, }) if err != nil { return err } fmt.Fprintf(w, "Waiting for create operation on projects/%s/instanceConfigs/%s to complete...\n", projectID, userConfigID) // Wait for the instance configuration creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("Waiting for instance config creation to finish failed: %w", err) } // The instance configuration may not be ready to serve yet.
if i.State != instanceinstancepb.InstanceConfig_READY.Fprintf(w, "InstanceConfig state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Created instance configuration [%s]\n", userConfigID) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.CreateInstanceConfigRequest;
import com.google.spanner.admin.instance.v1.InstanceConfig;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.ProjectName;
import com.google.spanner.admin.instance.v1.ReplicaInfo;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class CreateInstanceConfigSample {

static void createInstanceConfig() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String baseInstanceConfigId = "nam11";
String instanceConfigId = "custom-instance-config4";

createInstanceConfig(projectId, baseInstanceConfigId, instanceConfigId);
}

static void createInstanceConfig( String projectId, String baseInstanceConfigId, String instanceConfigId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { final InstanceConfigName baseInstanceConfigName = InstanceConfigName.of(projectId, baseInstanceConfigId);
final InstanceConfig baseConfig = instanceAdminClient.getInstanceConfig(baseInstanceConfigName.toString());
final InstanceConfigName instanceConfigName = InstanceConfigName.of(projectId, instanceConfigId);
/**
  * The replicas for the custom instance configuration must include all the replicas of the
  * base configuration, in addition to at least one from the list of optional replicas of the
  * base configuration.
*/ final List replicas = Stream.concat(baseConfig.getReplicasList().stream(), baseConfig.getOptionalReplicasList().stream().limit(1)).collect(Collectors.toList());
final InstanceConfig instanceConfig = InstanceConfig.newBuilder().setName(instanceConfigName.toString()) .setBaseConfig(baseInstanceConfigName.toString()) .setDisplayName("Instance Configuration").addAllReplicas(replicas).build();
final CreateInstanceConfigRequest createInstanceConfigRequest = CreateInstanceConfigRequest.newBuilder().setParent(ProjectName.of(projectId).toString()) .setInstanceConfigId(instanceConfigId).setInstanceConfig(instanceConfig).build();
try { System.out.printf("Waiting for create operation for %s to complete...\n", instanceConfigName);
InstanceConfig instanceConfigResult = instanceAdminClient.createInstanceConfigAsync( createInstanceConfigRequest).get(5, TimeUnit.MINUTES);
System.out.printf("Created instance configuration %s\n", instanceConfigResult.getName());
} catch (ExecutionException | TimeoutException e) { System.out.printf( "Error: Creating instance configuration %s failed with error message %s\n", instanceConfig.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println( "Error: Waiting for createInstanceConfig operation to finish was interrupted");
} } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const instanceConfigId = 'custom-my-instance-config-id' // const baseInstanceConfigId = 'my-base-instance-config-id';
// const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

// Creates a new instance config async function createInstanceConfig() { const [baseInstanceConfig] = await instanceAdminClient.getInstanceConfig({ name: instanceAdminClient.instanceConfigPath( projectId, baseInstanceConfigId, ), });
try { console.log( `Creating instance config ${instanceAdminClient.instanceConfigPath( projectId, instanceConfigId, )}.`, );
const [operation] = await instanceAdminClient.createInstanceConfig({ instanceConfigId: instanceConfigId, parent: instanceAdminClient.projectPath(projectId), instanceConfig: { name: instanceAdminClient.instanceConfigPath( projectId, instanceConfigId, ), baseConfig: instanceAdminClient.instanceConfigPath( projectId, baseInstanceConfigId, ), displayName: instanceConfigId, replicas: baseInstanceConfig.replicas.concat( baseInstanceConfig.optionalReplicas[0], ), }, });
console.log( `Waiting for create operation for ${instanceConfigId} to complete...`, );
await operation.promise();
console.log(`Created instance config ${instanceConfigId}.`);
} catch (err) { console.error( 'ERROR: Creating instance config ', instanceConfigId, ' failed with error message ', err, );
} } createInstanceConfig();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

use Google\Cloud\Spanner\Admin\Instance\V1\CreateInstanceConfigRequest;
use Google\Cloud\Spanner\Admin\Instance\V1\GetInstanceConfigRequest;
use Google\Cloud\Spanner\Admin\Instance\V1\InstanceConfig;
use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\ReplicaInfo;

/**
 * Creates a customer managed instance configuration.
 * Example:
 * ```
 * create_instance_config($instanceConfigId);
 * ```
*
 * @param string $projectId The Google Cloud Project ID.
 * @param string $instanceConfigId The customer managed instance configuration id. The id must start with 'custom-'.
 * @param string $baseConfigId Base configuration ID to be used for creation, e.g. nam11.
*/ function create_instance_config(string $projectId, string $instanceConfigId, string $baseConfigId): void { $instanceAdminClient = new InstanceAdminClient();
$projectName = InstanceAdminClient::projectName($projectId);
$instanceConfigName = $instanceAdminClient->instanceConfigName( $projectId, $instanceConfigId );

// Get a Google Managed instance configuration to use as the base for our custom instance configuration.
$baseInstanceConfig = $instanceAdminClient->instanceConfigName( $projectId, $baseConfigId );

$request = new GetInstanceConfigRequest(['name' => $baseInstanceConfig]);
$baseInstanceConfigInfo = $instanceAdminClient->getInstanceConfig($request);

$instanceConfig = (new InstanceConfig()) ->setBaseConfig($baseInstanceConfig) ->setName($instanceConfigName) ->setDisplayName('My custom instance configuration') ->setLabels(['php-cloud-spanner-samples' => true]) ->setReplicas(array_merge( iterator_to_array($baseInstanceConfigInfo->getReplicas()), [new ReplicaInfo([ 'location' => 'us-east1', 'type' => ReplicaInfo\ReplicaType::READ_ONLY, 'default_leader_location' => false ])] ));

$request = new CreateInstanceConfigRequest([ 'parent' => $projectName, 'instance_config' => $instanceConfig, 'instance_config_id' => $instanceConfigId ]);
$operation = $instanceAdminClient->createInstanceConfig($request);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf('Created instance configuration %s' . PHP_EOL, $instanceConfigId);
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def create_instance_config(user_config_name, base_config_id):
"""Creates the new user-managed instance configuration using base instance config."""

# user_config_name = `custom-nam11`
# base_config_id = `projects//instanceConfigs/nam11`
spanner_client = spanner.Client() base_config = spanner_client.instance_admin_api.get_instance_config( name=base_config_id )

# The replicas for the custom instance configuration must include all the replicas of the base
# configuration, in addition to at least one from the list of optional replicas of the base
# configuration.
replicas = [] for replica in base_config.replicas:
replicas.append(replica) replicas.append(base_config.optional_replicas[0]) operation = spanner_client.instance_admin_api.create_instance_config( parent=spanner_client.project_name, instance_config_id=user_config_name, instance_config=spanner_instance_admin.InstanceConfig( name="{}/instanceConfigs/{}".format( spanner_client.project_name, user_config_name ), display_name="custom-python-samples", config_type=spanner_instance_admin.InstanceConfig.Type.USER_MANAGED, replicas=replicas, base_config=base_config.name, labels={"python_cloud_spanner_samples": "true"}, ), ) print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print("Created instance configuration {}".format(user_config_name))

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

def spanner_create_instance_config project_id:, user_config_name:, base_config_id:
  # project_id  = "Your Google Cloud project ID"
  # user_config_name = "Your custom instance configuration name, The name must start with 'custom-'"
  # base_config_id = "Base configuration ID to be used for creation, e.g projects//instanceConfigs/nam11"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin project_path = instance_admin_client.project_path project: project_id base_instance_config = instance_admin_client.get_instance_config name: base_config_id
  # The replicas for the custom instance configuration must include all the replicas of the base
  # configuration, in addition to at least one from the list of optional replicas of the base
  # configuration.
custom_replicas = [] base_instance_config.replicas.each do |replica| custom_replicas << replica end custom_replicas << base_instance_config.optional_replicas[0] custom_instance_config_id = instance_admin_client.instance_config_path \ project: project_id, instance_config: user_config_name custom_instance_config = { name: custom_instance_config_id, display_name: "custom-ruby-samples", config_type: :USER_MANAGED, replicas: custom_replicas, base_config: base_config_id, labels: { ruby_cloud_spanner_samples: "true" } } request = { parent: project_path,
# Custom config names must start with the prefix “custom-”.
instance_config_id: user_config_name, instance_config: custom_instance_config } job = instance_admin_client.create_instance_config request

puts "Waiting for create instance config operation to complete"

job.wait_until_done!

if job.error?
puts job.error else puts "Created instance configuration #{user_config_name}" end end

在自定义实例配置中创建实例

您可以在自定义实例配置中创建实例。

控制台 如需在自定义实例配置中创建实例，请使用 gcloud CLI 或客户端库。

gcloud 创建自定义实例配置后，请按照创建实例中提供的说明操作。

C++ 创建自定义实例配置后，请按照创建实例中提供的说明操作。

C# 创建自定义实例配置后，请按照创建实例中提供的说明操作。

Go 创建自定义实例配置后，请按照创建实例中提供的说明操作。

Java 创建自定义实例配置后，请按照创建实例中提供的说明操作。

Node.js 创建自定义实例配置后，请按照创建实例中提供的说明操作。

PHP 创建自定义实例配置后，请按照创建实例中提供的说明操作。

Python 创建自定义实例配置后，请按照创建实例中提供的说明操作。

Ruby 创建自定义实例配置后，请按照创建实例中提供的说明操作。

更新自定义实例配置

您可以更改自定义实例配置的显示名称和标签。

您无法更改或更新自定义实例配置的副本。不过，您可以创建包含额外副本的新自定义实例配置，然后将您的实例移至包含您所选额外副本的新自定义实例配置。例如，如果您的实例位于 regional-us-central1 中，并且您想要添加只读副本 us-west1，则需要创建一个将 regional-us-central1 作为基本配置的新自定义实例配置，然后将 us-west1 添加为只读副本。接下来将实例移至这一新自定义实例配置。

gcloud 使用 gcloud spanner instance-configs update 命令：

gcloud spanner instance-configs update CUSTOM-INSTANCE-CONFIG-ID \ --display-name=NEW-DISPLAY-NAME \ --update-labels=KEY=VALUE,[...], \ --etag=ETAG

请提供以下值：

CUSTOM-INSTANCE-CONFIG-ID 自定义实例配置的永久性标识符。它会以 custom- 开头。
NEW-DISPLAY-NAME 要在 Google Cloud 控制台中为实例配置显示的新名称。
“KEY”和“VALUE” 要更新的键值对的列表。
键必须以小写字符开头，并且只能包含连字符 (-)、下划线 (_)、小写字符和数字。值只能包含连字符 (-)、下划线 (_)、小写字符和数字。

以下标志和值是可选的：

--etag=ETAG：ETAG 参数可用于在读取-修改-写入场景中选择并跳过同时更新。

--validate-only：使用此标志可在执行请求之前验证请求是否会成功。

例如：

gcloud spanner instance-configs update custom-eur6 \ --display-name="Customer managed europe replicas"

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void UpdateInstanceConfig( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& config_id) { auto project = google::cloud::Project(project_id);
auto config = client.GetInstanceConfig(project.FullName() + "/instanceConfigs/" + config_id);
if (!config) throw std::move(config).status();
google::spanner::admin::instance::v1::UpdateInstanceConfigRequest request;
auto* request_config = request.mutable_instance_config();
request_config->set_name(config->name());
request_config->mutable_labels()->insert({"key", "value"});
request.mutable_update_mask()->add_paths("labels");
request_config->set_etag(config->etag());
request.set_validate_only(false);
auto updated_config = client.UpdateInstanceConfig(request).get();
if (!updated_config) throw std::move(updated_config).status();
std::cout << "Updated instance config [" << config_id << "]:\n" DebugString();
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Google.Cloud.Spanner.Admin.Instance.V1;
using Google.LongRunning;
using Google.Protobuf.WellKnownTypes;

public class UpdateInstanceConfigAsyncSample { public async Task> UpdateInstanceConfigAsync(string projectId, string instanceConfigId) { InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();
var instanceConfigName = new InstanceConfigName(projectId, instanceConfigId);

var instanceConfig = new InstanceConfig();
instanceConfig.InstanceConfigName  = instanceConfigName;

instanceConfig.DisplayName = "New display name";
instanceConfig.Labels.Add(new Dictionary { {"cloud_spanner_samples","true"}, {"updated","true"}, });

var updateInstanceConfigOperation = await instanceAdminClient.UpdateInstanceConfigAsync(new UpdateInstanceConfigRequest { InstanceConfig = instanceConfig, UpdateMask = new FieldMask { Paths = { "display_name", "labels" } } });

updateInstanceConfigOperation = await updateInstanceConfigOperation.PollUntilCompletedAsync();

if (updateInstanceConfigOperation.IsFaulted) { throw updateInstanceConfigOperation.Exception;
}

Console.WriteLine("Update Instance Config operation completed successfully.");
return updateInstanceConfigOperation;
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io" "time"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/genproto/protobuf/field_mask" )

// updateInstanceConfig updates the custom spanner instance config func updateInstanceConfig(w io.Writer, projectID, userConfigID string) error { // projectID := "my-project-id" // userConfigID := "custom-config", custom config names must start with the prefix “custom-”.

// Add timeout to context.
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute) defer cancel()

adminClient, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer admiadminClient.Closeconfig, err := adminClient.GetInstanceConfig(ctx, &instancepb.GetInstanceConfigRequest{ Name: fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, userConfigID), }) if err != nil { return fmt.Errorf("updateInstanceConfig.GetInstanceConfig: %w", err) } config.DisplayName = "updated custom instance config" config.Labels["updated"] = "true" op, err := adminClient.UpdateInstanceConfig(ctx, &instancepb.UpdateInstanceConfigRequest{ InstanceConfig: config, UpdateMask: &field_mask.FieldMask{ Paths: []string{"display_name", "labels"}, }, ValidateOnly: false, }) if err != nil { return err } fmt.Fprintf(w, "Waiting for update operation on %s to complete...\n", userConfigID) // Wait for the instance configuration creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("Waiting for instance config creation to finish failed: %w", err) } // The instance configuration may not be ready to serve yet.
if i.State != instinstancepb.InstanceConfig_READY	fmt.Fprintf(w, "InstanceConfig state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Updated instance configuration [%s]\n", config.Name) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.common.collect.ImmutableList;
import com.google.protobuf.FieldMask;
import com.google.spanner.admin.instance.v1.InstanceConfig;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.UpdateInstanceConfigRequest;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

class UpdateInstanceConfigSample {

static void updateInstanceConfig() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceConfigId = "custom-instance-config";
updateInstanceConfig(projectId, instanceConfigId);
}

static void updateInstanceConfig(String projectId, String instanceConfigId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { final InstanceConfigName instanceConfigName = InstanceConfigName.of(projectId, instanceConfigId);
final InstanceConfig instanceConfig = InstanceConfig.newBuilder() .setName(instanceConfigName.toString()) .setDisplayName("updated custom instance config") .putLabels("updated", "true").build();
/**
  * The field mask must always be specified; this prevents any future
  * fields in [InstanceConfig][google.spanner.admin.instance.v1.InstanceConfig]
  * from being erased accidentally by clients that do not know about them.
*/ final UpdateInstanceConfigRequest updateInstanceConfigRequest = UpdateInstanceConfigRequest.newBuilder() .setInstanceConfig(instanceConfig) .setUpdateMask( FieldMask.newBuilder().addAllPaths(ImmutableList.of("display_name", "labels")) .build()).build();
try { System.out.printf("Waiting for update operation on %s to complete...\n", instanceConfigName);
InstanceConfig instanceConfigResult = instanceAdminClient.updateInstanceConfigAsync( updateInstanceConfigRequest).get(5, TimeUnit.MINUTES);
System.out.printf( "Updated instance configuration %s with new display name %s\n", instanceConfigResult.getName(), instanceConfig.getDisplayName());
} catch (ExecutionException | TimeoutException e) { System.out.printf( "Error: Updating instance config %s failed with error message %s\n", instanceConfig.getName(), e.getMessage());
e.printStackTrace();
} catch (InterruptedException e) { System.out.println( "Error: Waiting for updateInstanceConfig operation to finish was interrupted");
} } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const instanceConfigId = 'custom-my-instance-config-id';
// const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

async function updateInstanceConfig() { // Updates an instance config try { console.log( `Updating instance config ${instanceAdminClient.instanceConfigPath( projectId, instanceConfigId, )}.`, );
const [operation] = await instanceAdminClient.updateInstanceConfig({ instanceConfig: { name: instanceAdminClient.instanceConfigPath( projectId, instanceConfigId, ), displayName: 'updated custom instance config', labels: { updated: 'true', created: Math.round(Date.now() / 1000).toString(), // current time }, }, // Field mask specifying fields that should get updated in InstanceConfig // Only display_name and labels can be updated updateMask: (protos.google.protobuf.FieldMask = { paths: ['display_name', 'labels'], }), });
console.log( `Waiting for update operation for ${instanceConfigId} to complete...`, );
await operation.promise();
console.log(`Updated instance config ${instanceConfigId}.`);
} catch (err) { console.error( 'ERROR: Updating instance config ', instanceConfigId, ' failed with error message ', err, );
} } updateInstanceConfig();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\InstanceConfig;
use Google\Cloud\Spanner\Admin\Instance\V1\UpdateInstanceConfigRequest;
use Google\Protobuf\FieldMask;

/**
 * Updates a customer managed instance configuration.
 * Example:
 * ```
 * update_instance_config($instanceConfigId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceConfigId The customer managed instance configuration id. The id must start with 'custom-'.
*/ function update_instance_config(string $projectId, string $instanceConfigId): void { $instanceAdminClient = new InstanceAdminClient();

$instanceConfigPath = $instanceAdminClient->instanceConfigName($projectId, $instanceConfigId);
$displayName = 'New display name';

$instanceConfig = new InstanceConfig();
$instanceConfig->setName($instanceConfigPath);
$instanceConfig->setDisplayName($displayName);
$instanceConfig->setLabels(['cloud_spanner_samples' => true, 'updated' => true]);

$fieldMask = new FieldMask();
$fieldMask->setPaths(['display_name', 'labels']);

$updateInstanceConfigRequest = (new UpdateInstanceConfigRequest()) ->setInstanceConfig($instanceConfig) ->setUpdateMask($fieldMask);

$operation = $instanceAdminClient->updateInstanceConfig($updateInstanceConfigRequest);

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf('Updated instance configuration %s' . PHP_EOL, $instanceConfigId);
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def update_instance_config(user_config_name):
"""Updates the user-managed instance configuration."""

# user_config_name = `custom-nam11`
spanner_client = spanner.Client() config = spanner_client.instance_admin_api.get_instance_config( name="{}/instanceConfigs/{}".format( spanner_client.project_name, user_config_name ) ) config.display_name = "updated custom instance config" config.labels["updated"] = "true" operation = spanner_client.instance_admin_api.update_instance_config( instance_config=config, update_mask=field_mask_pb2.FieldMask(paths=["display_name", "labels"]), ) print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS) print("Updated instance configuration {}".format(user_config_name))

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

def spanner_update_instance_config user_config_id:
  # user_config_id = "The customer managed instance configuration ID, e.g projects//instanceConfigs/custom-nam11"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin config = instance_admin_client.get_instance_config name: user_config_id config.display_name = "updated custom instance config" config.labels["updated"] = "true" request = { instance_config: config, update_mask: { paths: ["display_name", "labels"] }, validate_only: false } job = instance_admin_client.update_instance_config request

puts "Waiting for update instance config operation to complete"

job.wait_until_done!

if job.error?
puts job.error else puts "Updated instance configuration #{config.name}" end end

删除自定义实例配置 注意：删除实例配置会永久移除实例配置。您无法删除实例使用的自定义实例配置。如需删除实例，请参阅删除实例。

如需删除自定义实例配置，请先删除实例配置中的所有实例。

gcloud 使用 gcloud spanner instance-configs delete 命令，并将 CUSTOM-INSTANCE-CONFIG-ID 替换为自定义实例配置 ID：

gcloud spanner instance-configs delete CUSTOM-INSTANCE-CONFIG-ID

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void DeleteInstanceConfig( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& config_id) { auto project = google::cloud::Project(project_id);
auto config_name = project.FullName() + "/instanceConfigs/" + config_id;
auto status = client.DeleteInstanceConfig(config_name);
if (!status.ok()) throw std::move(status);
std::cout << "Instance config " << config_name << " successfully deleted\n";
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

using System;
using System.Threading.Tasks;
using Google.Cloud.Spanner.Admin.Instance.V1;
using Grpc.Core;

public class DeleteInstanceConfigAsyncSample {

public async Task DeleteInstanceConfigAsync(string projectId, string instanceConfigId) { InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();
var instanceConfigName = new InstanceConfigName(projectId, instanceConfigId);

try { await instanceAdminClient.DeleteInstanceConfigAsync(new DeleteInstanceConfigRequest { InstanceConfigName = instanceConfigName });
} catch (RpcException ex) when (ex.Status.StatusCode == StatusCode.NotFound) { Console.WriteLine("The specified instance config does not exist. It cannot be deleted.");
return;
}

Console.WriteLine("Delete Instance Config operation is completed");
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// deleteInstanceConfig deletes the custom spanner instance config func deleteInstanceConfig(w io.Writer, projectID, userConfigID string) error { // projectID := "my-project-id" // userConfigID := "custom-config", custom config names must start with the prefix “custom-”.

ctx := context.Background() adminClient, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer admiadminClient.Closeerr = adminClient.DeleteInstanceConfig(ctx, &instancepb.DeleteInstanceConfigRequest{ Name: fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, userConfigID), }) if err != nil { return err } fmt.Fprintf(w, "Deleted instance configuration [%s]\n", userConfigID) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerException;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.DeleteInstanceConfigRequest;
import com.google.spanner.admin.instance.v1.InstanceConfigName;

class DeleteInstanceConfigSample {

static void deleteInstanceConfig() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceConfigId = "custom-user-config";
deleteInstanceConfig(projectId, instanceConfigId);
}

static void deleteInstanceConfig(String projectId, String instanceConfigId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { final InstanceConfigName instanceConfigName = InstanceConfigName.of(projectId, instanceConfigId);
final DeleteInstanceConfigRequest request = DeleteInstanceConfigRequest.newBuilder().setName(instanceConfigName.toString()).build();

try { System.out.printf("Deleting %s...\n", instanceConfigName);
instanceAdminClient.deleteInstanceConfig(request);
System.out.printf("Deleted instance configuration %s\n", instanceConfigName);
} catch (SpannerException e) { System.out.printf( "Error: Deleting instance configuration %s failed with error message: %s\n", instanceConfigName, e.getMessage());
} } } }

注意：Java 的旧版客户端库接口代码示例已在 GitHub 中归档。

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const instanceConfigId = 'custom-my-instance-config-id';
// const projectId = 'my-project-id';

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

async function deleteInstanceConfig() { // Deletes an instance config.

try { // Delete the instance config.
console.log(`Deleting ${instanceConfigId}...\n`);
await instanceAdminClient.deleteInstanceConfig({ name: instanceAdminClient.instanceConfigPath( projectId, instanceConfigId, ), });
console.log(`Deleted instance config ${instanceConfigId}.\n`);
} catch (err) { console.error( 'ERROR: Deleting instance config ', instanceConfigId, ' failed with error message ', err, );
} } deleteInstanceConfig();

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

PHP

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\DeleteInstanceConfigRequest;

/**
 * Deletes a customer managed instance configuration.
 * Example:
 * ```
 * delete_instance_config($instanceConfigId);
 * ```
*
 * @param string $projectId The Google Cloud Project ID.
 * @param string $instanceConfigId The customer managed instance configuration id. The id must start with 'custom-'.
*/ function delete_instance_config(string $projectId, string $instanceConfigId) { $instanceAdminClient = new InstanceAdminClient();
$instanceConfigName = $instanceAdminClient->instanceConfigName( $projectId, $instanceConfigId );

$request = new DeleteInstanceConfigRequest();
$request->setName($instanceConfigName);

$instanceAdminClient->deleteInstanceConfig($request);
printf('Deleted instance configuration %s' . PHP_EOL, $instanceConfigId);
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def delete_instance_config(user_config_id):
"""Deleted the user-managed instance configuration.""" spanner_client = spanner.Client() spanner_client.instance_admin_api.delete_instance_config(name=user_config_id) print("Instance config {} successfully deleted".format(user_config_id))

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

def spanner_delete_instance_config user_config_id:
  # user_config_id = "The customer managed instance configuration ID, e.g projects//instanceConfigs/custom-nam11"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin instance_admin_client.delete_instance_config name: user_config_id puts "Deleted instance configuration #{user_config_id}" end

后续步骤

了解如何使用数据操纵语言 (DML) 或 gcloud CLI 插入、更新和删除数据。

为实例及其数据库授予 IAM 角色。

了解如何设计 Spanner 架构。

Spanner 配额和限制。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-01-30。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-01-30。"],[],[]]

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
