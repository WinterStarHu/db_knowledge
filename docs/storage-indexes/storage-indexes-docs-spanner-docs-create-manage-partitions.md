# 创建和管理实例分区  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-manage-partitions

创建和管理实例分区  |  Spanner  |  Google Cloud Documentation

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

创建和管理实例分区

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

预览版

— Geo-partitioning

此功能 受服务专用条款的约束。 非正式版功能“按原样”提供，且可能仅提供有限支持。
如需了解详情，请参阅发布阶段说明。

注意：此功能适用于 Spanner 企业 Plus 版。如需了解详情，请参阅 Spanner 版本概览。

本页面介绍了如何创建和管理 Spanner 实例分区。

创建实例分区

控制台

在 Google Cloud 控制台中，打开 Spanner 页面。

转到 Spanner

选择要在其中添加实例分区的实例。

在导航菜单中，选择实例分区。

点击创建实例分区。

输入用于永久标识实例分区的分区 ID。实例分区 ID 在您的Google Cloud 项目中也必须是唯一的。您以后无法更改实例分区 ID。

在选择配置部分中，选择单区域或多区域。或者，如果您想比较各个区域之间的规范，请点击比较区域配置。

从下拉菜单中选择配置。

在分配计算容量部分的单元下，点击以下任一选项：

适用于小型实例分区的处理单元。

适用于大型实例的节点。一个节点等于 1000 个处理单元。

为所选单元输入值。

您的实例分区必须至少有一个节点或 1,000 个处理单元。

点击创建以创建实例分区。

gcloud 如需创建实例分区，请使用 gcloud beta spanner instance-partitions create。

gcloud beta spanner instance-partitions create INSTANCE_PARTITION_ID \ --config=INSTANCE_PARTITION_CONFIG \ --description="INSTANCE_PARTITION_DESCRIPTION" \ --instance=INSTANCE_ID \ [--nodes=NODE_COUNT | --processing-units=PROCESSING_UNIT_COUNT]

替换以下内容：

INSTANCE_PARTITION_ID：在您的 Google Cloud 项目中唯一的永久性实例分区标识符。您以后无法更改实例分区 ID。

INSTANCE_PARTITION_CONFIG：实例分区配置的永久性标识符，该标识符定义实例分区的地理位置，并且会影响数据的存储位置。

INSTANCE_PARTITION_DESCRIPTION：要在 Google Cloud 控制台中显示的实例分区名称。此实例分区名称在您的 Google Cloud 项目中必须是唯一的。

INSTANCE_ID：此实例分区所在的 Spanner 实例的永久性标识符。

NODE_COUNT：实例分区的计算容量，以节点数表示。一个节点等于 1,000 个处理单元。

PROCESSING_UNIT_COUNT：实例的计算容量，以处理单元数表示。您的实例分区必须至少有 1,000 个处理单元。以 1,000 的倍数（1,000、2,000、3,000 等）输入数量。

例如，如需在 eur3 中创建包含 5 个节点的实例分区 europe-partition，请运行以下命令：

gcloud beta spanner instance-partitions create europe-partition --config=eur3 \ --description="europe-partition" --instance=test-instance --nodes=5

客户端库

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

void CreateInstancePartition( google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& instance_partition_id) { auto project = google::cloud::Project(project_id);
auto in = google::cloud::spanner::Instance(project_id, instance_id);
auto config = project.FullName() + "/instanceConfigs/nam3";

google::spanner::admin::instance::v1::CreateInstancePartitionRequest request;
request.set_parent(in.FullName());
request.set_instance_partition_id(instance_partition_id);
request.mutable_instance_partition()->set_display_name( "Test instance partition");
request.mutable_instance_partition()->set_node_count(1);
request.mutable_instance_partition()->set_config(config);

auto instance_partition = client.CreateInstancePartition(request).get();
if (!instance_partition) throw std::move(instance_partition).status();
std::cout << "Created instance partition [" << instance_partition_id << "]:\n" DebugString();
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

using Google.Cloud.Spanner.Admin.Instance.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.LongRunning;
using System;

public class CreateInstancePartitionSample { public InstancePartition CreateInstancePartition(string projectId, string instanceId, string instancePartitionId) { // Create the InstanceAdminClient instance.
InstanceAdminClient instanceAdminClient = InstanceAdminClient.Create();

// Initialize request parameters.
InstancePartition partition = new InstancePartition { DisplayName = "This is a display name.", NodeCount = 1, ConfigAsInstanceConfigName = InstanceConfigName.FromProjectInstanceConfig(projectId, "nam3"), };
InstanceName instanceName = InstanceName.FromProjectInstance(projectId, instanceId);

// Make the CreateInstancePartition request.
Operation response = instanceAdminClient.CreateInstancePartition(instanceName, partition, instancePartitionId);

Console.WriteLine("Waiting for the operation to finish.");

// Poll until the returned long-running operation is complete.
Operation completedResponse = response.PollUntilCompleted();

if (completedResponse.IsFaulted) { Console.WriteLine($"Error while creating instance partition: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine($"Instance created successfully.");

return completedResponse.Result;
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// Example of creating an instance partition with Go.
// projectID is the ID of the project that the new instance partition will be in.
// instanceID is the ID of the instance that the new instance partition will be in.
// instancePartitionID is the ID of the new instance partition to be created.
func createInstancePartition(w io.Writer, projectID, instanceID, instancePartitionID string) error { // projectID := "my-project-id" // instanceID := "my-instance" // instancePartitionID := "my-instance-partition" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

op, err := instanceAdmin.CreateInstancePartition(ctx, &instancepb.CreateInstancePartitionRequest{ Parent:              fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), InstancePartitionId: instancePartitionID, InstancePartition: &instancepb.InstancePartition{ Config:          fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, "nam3"), DisplayName:     "my-instance-partition", ComputeCapacity: &instancepb.InstancePartition_NodeCount{NodeCount: 1}, }, }) if err != nil { return fmt.Errorf("could not create instance partition %s: %w", fmt.Sprintf("projects/%s/instances/%s/instancePartitions/%s", projectID, instanceID, instancePartitionID), err) } // Wait for the instance partition creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance partition creation to finish failed: %w", err) } // The instance partition may not be ready to serve yet.
if i.State != instancepb.InstancePartition_READY { fmt.Fprintf(w, "instance partition state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Created instance partition [%s]\n", instancePartitionID) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.CreateInstancePartitionRequest;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.InstanceName;
import com.google.spanner.admin.instance.v1.InstancePartition;
import java.util.concurrent.ExecutionException;

class CreateInstancePartitionSample {

static void createInstancePartition() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
String instancePartitionId = "my-instance-partition";
createInstancePartition(projectId, instanceId, instancePartitionId);
}

static void createInstancePartition( String projectId, String instanceId, String instancePartitionId) { // Set instance partition configuration.
int nodeCount = 1;
String displayName = "Descriptive name";

// Create an InstancePartition object that will be used to create the instance partition.
InstancePartition instancePartition = InstancePartition.newBuilder() .setDisplayName(displayName) .setNodeCount(nodeCount) .setConfig(InstanceConfigName.of(projectId, "nam3").toString()) .build();

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) {

// Wait for the createInstancePartition operation to finish.
InstancePartition createdInstancePartition = instanceAdminClient .createInstancePartitionAsync( CreateInstancePartitionRequest.newBuilder() .setParent(InstanceName.of(projectId, instanceId).toString()) .setInstancePartitionId(instancePartitionId) .setInstancePartition(instancePartition) .build()) .get();
System.out.printf( "Instance partition %s was successfully created%n", createdInstancePartition.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Creating instance partition %s failed with error message %s%n", instancePartition.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println( "Error: Waiting for createInstancePartition operation to finish was interrupted");
} } }

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

// Imports the Google Cloud client library const {Spanner} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';
// const instancePartitionId = 'my-instance-partition';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

// Get the instance admin client const instanceAdminClient = spanner.getInstanceAdminClient();

// Creates a new instance partition try { console.log( `Creating instance partition ${instanceAdminClient.instancePartitionPath( projectId, instanceId, instancePartitionId, )}.`, );
const [operation] = await instanceAdminClient.createInstancePartition({ instancePartitionId: instancePartitionId, parent: instanceAdminClient.instancePath(projectId, instanceId), instancePartition: { config: instanceAdminClient.instanceConfigPath(projectId, 'nam3'), nodeCount: 1, displayName: 'Test instance partition', }, });

console.log( `Waiting for operation on ${instancePartitionId} to complete...`, );
await operation.promise();

console.log(`Created instance partition ${instancePartitionId}.`);
} catch (err) { console.error('ERROR:', err);
}

PHP

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\CreateInstancePartitionRequest;
use Google\Cloud\Spanner\Admin\Instance\V1\InstancePartition;

/**
 * Creates an instance partition.
 * Example:
 * ```
 * create_instance_partition($projectId, $instanceId, $instancePartitionId);
 * ```
*
 * @param string $projectId The Google Cloud project ID.
 * @param string $instanceId The Spanner instance ID.
 * @param string $instancePartitionId The instance partition ID.
*/ function create_instance_partition(string $projectId, string $instanceId, string $instancePartitionId): void { $instanceAdminClient = new InstanceAdminClient();

$instanceName = $instanceAdminClient->instanceName($projectId, $instanceId);
$instancePartitionName = $instanceAdminClient->instancePartitionName($projectId, $instanceId, $instancePartitionId);
$configName = $instanceAdminClient->instanceConfigName($projectId, 'nam3');

$instancePartition = (new InstancePartition()) ->setConfig($configName) ->setDisplayName('Test instance partition.') ->setNodeCount(1);

$operation = $instanceAdminClient->createInstancePartition( (new CreateInstancePartitionRequest()) ->setParent($instanceName) ->setInstancePartitionId($instancePartitionId) ->setInstancePartition($instancePartition) );

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf('Created instance partition %s' . PHP_EOL, $instancePartitionId);
}

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

def create_instance_partition(instance_id, instance_partition_id):
"""Creates an instance partition.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client() instance_admin_api = spanner_client.instance_admin_api

config_name = "{}/instanceConfigs/nam3".format(spanner_client.project_name)

operation = spanner_client.instance_admin_api.create_instance_partition( parent=instance_admin_api.instance_path(spanner_client.project, instance_id), instance_partition_id=instance_partition_id, instance_partition=spanner_instance_admin.InstancePartition( config=config_name, display_name="Test instance partition", node_count=1, ), )

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print("Created instance partition {}".format(instance_partition_id))

描述实例分区

gcloud 如需描述实例分区，请使用 gcloud beta spanner instance-partitions describe。

gcloud beta spanner instance-partitions describe PARTITION_ID \ --instance=INSTANCE_ID

替换以下内容：

INSTANCE_PARTITION_ID：实例分区的永久性标识符。

INSTANCE_ID：实例的永久性标识符。

例如，如需描述实例分区 europe-partition，请运行以下命令：

gcloud beta spanner instance-partitions describe europe-partition --instance=test-instance

列出实例分区

控制台

在 Google Cloud 控制台中，打开 Spanner 页面。

转到 Spanner

从列表中选择一个实例。

在导航菜单中，选择实例分区。

系统会显示与该实例关联的实例分区列表。

gcloud 如需列出实例分区，请使用 gcloud beta spanner instance-partitions list。

gcloud beta spanner instance-partitions list --instance=INSTANCE_ID

gcloud CLI 会输出 Spanner 实例分区的列表，以及每个实例分区的 ID、显示名称、配置和计算容量。

修改实例分区

以下部分介绍了如何更改实例分区的计算容量。您无法更改实例分区 ID、名称或配置。

更改计算容量

您必须预配足够的计算容量，以将 CPU 利用率和存储空间利用率保持在建议的上限以下。如需了解详情，请参阅 Spanner 的配额和限制。

如果想要增加实例分区的计算容量，您的Google Cloud 项目必须具有足够的配额才能添加计算容量。完成增加请求所需的时间取决于请求的大小。在大多数情况下，请求会在几分钟内完成。在极少数情况下，扩容最长可能需要 1 小时才能完成。

控制台

在 Google Cloud 控制台中，打开 Spanner 页面。

转到 Spanner

从列表中选择一个实例。

在导航菜单中，选择实例分区。

在实例分区列表的操作列下，点击更多操作，然后选择修改。

选择度量单位（处理单元或节点），然后输入数量，以更改计算容量。使用处理单元时，请以 1000 的倍数（1000、2000、3000 等）输入数量。每个节点等于 1,000 个处理单元。

您的实例分区必须至少有一个节点（1,000 个处理单元）。

点击保存。

如果系统对话框提示您没有足够的配额来添加计算容量，请按照说明请求更高配额。

gcloud 如需更改实例分区的计算容量，请使用 gcloud beta spanner instance-partitions update。
使用此命令时，请以节点数或处理单元数的形式指定计算容量。

gcloud beta spanner instance-partitions update INSTANCE_PARTITION_ID \ --instance=INSTANCE_ID \ [--nodes=NODE_COUNT | --processing-units=PROCESSING_UNIT_COUNT] [--async]

替换以下内容：

INSTANCE_PARTITION_ID：实例分区的永久性标识符。

INSTANCE_ID：实例的永久性标识符。

NODE_COUNT：实例分区的新计算容量，以节点数表示。一个节点等于 1,000 个处理单元。

PROCESSING_UNIT_COUNT：实例分区的新计算容量，以处理单元数表示。您的实例分区必须至少有 1,000 个处理单元。以 1,000 的倍数（1,000、2,000、3,000 等）输入数量。

可选标志：

--async：如果您希望请求立即返回结果，而无需等待正在进行的操作完成，请使用此标志。

您可以运行 gcloud spanner operations describe 来检查请求的状态。

删除实例分区

当某个实例分区与任何放置位置或数据关联时，您无法将其删除。您必须先移出实例分区中的所有数据或删除使用该实例分区的放置表，然后才能删除该实例分区。

控制台

在 Google Cloud 控制台中，打开 Spanner 页面。

转到 Spanner

从列表中选择一个实例。

在导航菜单中，选择实例分区。

在实例分区列表的操作列下，点击更多操作，然后选择删除。

按照说明进行操作，确认您要删除实例分区。

点击删除。

gcloud 使用 gcloud beta spanner instance-partitions delete 命令。

gcloud beta spanner instance-partitions delete INSTANCE_PARTITION_ID --instance=INSTANCE_ID

后续步骤

了解如何创建和管理布置表和键。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-02-21。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-02-21。"],[],[]]

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
