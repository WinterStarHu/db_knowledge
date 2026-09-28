# Spanner 和 PGAdapter 使用入门  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/getting-started/pgadapter

Spanner 和 PGAdapter 使用入门  |  Google Cloud Documentation

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

Spanner 和 PGAdapter 使用入门

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

目标

本教程将介绍如何使用 PostgreSQL 驱动程序的 Spanner PGAdapter 本地代理完成以下步骤：

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

准备本地 PGAdapter 环境

您可以将 PostgreSQL 驱动程序与 PGAdapter 结合使用，以连接到 Spanner。PGAdapter 是一个本地代理，用于将 PostgreSQL 网络协议转换为 Spanner gRPC 协议。
提示：如需查看比较 PGAdapter 和常规 Spanner 客户端库延迟时间的基准比较，请参阅延迟时间比较。

PGAdapter 需要 Java 或 Docker 才能运行。

在开发机器上安装以下内容之一（如果尚未安装）：

Java 8 JDK（下载）。

Docker（下载）。

将示例应用代码库克隆到本地机器：

git clone https://github.com/GoogleCloudPlatform/pgadapter.git

切换到包含 Spanner 示例代码的目录：

psql

cd pgadapter/samples/snippets/psql-snippets

Java

cd pgadapter/samples/snippets/java-snippets mvn package -DskipTests

Go

cd pgadapter/samples/snippets/golang-snippets

Node.js

cd pgadapter/samples/snippets/nodejs-snippets npm install

Python

cd pgadapter/samples/snippets/python-snippets python -m venv ./venv pip install -r requirements.txt cd samples

C#

cd pgadapter/samples/snippets/dotnet-snippets

PHP

cd pgadapter/samples/snippets/php-snippets composer install cd samples

创建实例

提示：如果您将 PGAdapter 与模拟器搭配使用，则可以跳过此步骤。当您连接到 PGAdapter 时，PGAdapter 会自动在模拟器上创建实例。

在首次使用 Spanner 时，必须创建一个实例，实例是 Spanner 数据库使用的资源分配单位。创建实例时，请选择一个实例配置（决定数据的存储位置），同时选择要使用的节点数（决定实例中服务资源和存储资源的数量）。

如需了解如何使用以下任一方法创建 Spanner 实例，请参阅创建实例。您可以将实例命名为 test-instance，以便将其用于本文档中引用名为 test-instance 的实例的其他主题。

Google Cloud CLI

Google Cloud 控制台

客户端库（C++、C#、Go、Java、Node.js、PHP、Python 或 Ruby）

浏览示例文件

示例代码库包含一个示例，展示了如何将 Spanner 与 PGAdapter 搭配使用。

请浏览 samples/snippets 文件夹，其中说明了如何使用 Spanner。代码展示了如何创建和使用新数据库。数据使用架构和数据模型页面中显示的示例架构。

启动 PGAdapter

在本地开发机器上启动 PGAdapter，并使其指向您创建的实例。

以下命令假定您执行了 gcloud auth application-default login。

Java 应用

wget https://storage.googleapis.com/pgadapter-jar-releases/pgadapter.tar.gz \ && tar -xzvf pgadapter.tar.gz java -jar pgadapter.jar -i test-instance

Docker

docker pull gcr.io/cloud-spanner-pg-adapter/pgadapter docker run \ --name pgadapter \ --rm -d -p 5432:5432 \ -v "$HOME/.config/gcloud":/gcloud:ro \ --env CLOUDSDK_CONFIG=/gcloud \ gcr.io/cloud-spanner-pg-adapter/pgadapter \ -i test-instance -x 注意：如果您使用的是 Windows，请将 $HOME/.config/gcloud/ 替换为 %APPDATA%\gcloud，或者运行 gcloud info --format='value(config.paths.global_config_dir)' 以查找当前 gcloud 配置文件夹。

模拟器

docker pull gcr.io/cloud-spanner-pg-adapter/pgadapter-emulator docker run \ --name pgadapter-emulator \ --rm -d \ -p 5432:5432 \ -p 9010:9010 \ -p 9020:9020 \ gcr.io/cloud-spanner-pg-adapter/pgadapter-emulator

这会使用嵌入式 Spanner 模拟器启动 PGAdapter。此嵌入式模拟器会自动创建您连接到的任何 Spanner 实例或数据库，而无需您事先手动创建。

我们建议您在生产环境中将 PGAdapter 作为边车容器或进程中依赖项来运行。如需详细了解如何在生产环境中部署 PGAdapter，请参阅选择运行 PGAdapter 的方法。

创建数据库

提示：如果您将 PGAdapter 与模拟器搭配使用，则可以跳过此步骤。当您连接到 PGAdapter 时，PGAdapter 会自动在模拟器上创建数据库。

gcloud spanner databases create example-db --instance=test-instance \ --database-dialect=POSTGRESQL

您应该会看到：

Creating database...done.

创建表

以下代码会在数据库中创建两个表。

注意：后续的代码示例会使用这两个表。如果您不执行此代码，请使用 Google Cloud 控制台或 gcloud CLI 创建表。如需了解详情，请参阅示例架构。

psql

#!/bin/bash

# Set the connection variables for psql.
# The following statements use the existing value of the variable if it has
# already been set, and otherwise assigns a default value.
export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Create two tables in one batch.
psql << SQL -- Create the singers table CREATE TABLE singers ( singer_id   bigint not null primary key, first_name  character varying(1024), last_name   character varying(1024), singer_info bytea, full_name   character varying(2048) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED );

-- Create the albums table. This table is interleaved in the parent table -- "singers".
CREATE TABLE albums ( singer_id     bigint not null, album_id      bigint not null, album_title   character varying(1024), primary key (singer_id, album_id) ) -- The 'interleave in parent' clause is a Spanner-specific extension to -- open-source PostgreSQL.
INTERLEAVE IN PARENT singers ON DELETE CASCADE;
SQL

echo "Created Singers & Albums tables in database: [${PGDATABASE}]"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

class CreateTables { static void createTables(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (Statement statement = connection.createStatement()) { // Create two tables in one batch.
statement.addBatch( "create table singers (" + "  singer_id   bigint primary key not null," + "  first_name  varchar(1024)," + "  last_name   varchar(1024)," + "  singer_info bytea," + "  full_name   varchar(2048) generated always as (\n" + "      case when first_name is null then last_name\n" + "          when last_name  is null then first_name\n" + "          else first_name || ' ' || last_name\n" + "      end) stored" + ")");
statement.addBatch( "create table albums (" + "  singer_id     bigint not null," + "  album_id      bigint not null," + "  album_title   varchar," + "  primary key (singer_id, album_id)" + ") interleave in parent singers on delete cascade");
statement.executeBatch();
System.out.println("Created Singers & Albums tables in database: [" + database + "]");
} } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func CreateTables(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Create two tables in one batch on Spanner.
br := conn.SendBatch(ctx, &pgx.Batch{QueuedQueries: []*pgx.QueuedQuery{ {SQL: "create table singers (" + "  singer_id   bigint primary key not null," + "  first_name  character varying(1024)," + "  last_name   character varying(1024)," + "  singer_info bytea," + "  full_name   character varying(2048) generated " + "  always as (first_name || ' ' || last_name) stored" + ")"}, {SQL: "create table albums (" + "  singer_id     bigint not null," + "  album_id      bigint not null," + "  album_title   character varying(1024)," + "  primary key (singer_id, album_id)" + ") interleave in parent singers on delete cascade"}, }}) cmd, err := br.Exec() if err != nil { return err } if cmd.String() != "CREATE" { return fmt.Errorf("unexpected command tag: %v", cmd.String()) } if err := br.Close(); err != nil { return err } fmt.Printf("Created Singers & Albums tables in database: [%s]\n", database)

return nil }

Node.js

import { Client } from 'pg';

async function createTables(host: string, port: number, database: string): Promise { // Connect to Spanner through PGAdapter.
const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Create two tables in one batch.
await connection.query("start batch ddl");
await connection.query("create table singers (" + "  singer_id   bigint primary key not null," + "  first_name  character varying(1024)," + "  last_name   character varying(1024)," + "  singer_info bytea," + "  full_name   character varying(2048) generated " + "  always as (first_name || ' ' || last_name) stored" + ")");
await connection.query("create table albums (" + "  singer_id     bigint not null," + "  album_id      bigint not null," + "  album_title   character varying(1024)," + "  primary key (singer_id, album_id)" + ") interleave in parent singers on delete cascade");
await connection.query("run batch");
console.log(`Created Singers & Albums tables in database: [${database}]`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def create_tables(host: string, port: int, database: string):
# Connect to Cloud Spanner using psycopg3 through PGAdapter.
with psycopg.connect("host={host} port={port} " "dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
# Enable autocommit to execute DDL statements, as psycopg otherwise
# tries to use a read/write transaction.
conn.autocommit = True

# Use a pipeline to execute multiple DDL statements in one batch.
with conn.pipeline():
conn.execute("create table singers (" + "  singer_id   bigint primary key not null," + "  first_name  character varying(1024)," + "  last_name   character varying(1024)," + "  singer_info bytea," + "  full_name   character varying(2048) generated " + "  always as (first_name || ' ' || last_name) stored" + ")") conn.execute("create table albums (" + "  singer_id     bigint not null," + "  album_id      bigint not null," + "  album_title   character varying(1024)," + "  primary key (singer_id, album_id)" + ") interleave in parent singers on delete cascade") print("Created Singers & Albums tables in database: [{database}]" .format(database=database))

C#

using Npgsql;

namespace dotnet_snippets;

public static class CreateTablesSample { public static void CreateTables(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Create two tables in one batch.
var batch = connection.CreateBatch();
batch.BatchCommands.Add(new NpgsqlBatchCommand( "create table singers (" + "  singer_id   bigint primary key not null," + "  first_name  varchar(1024)," + "  last_name   varchar(1024)," + "  singer_info bytea," + "  full_name   varchar(2048) generated always as (\n" + "      case when first_name is null then last_name\n" + "          when last_name  is null then first_name\n" + "          else first_name || ' ' || last_name\n" + "      end) stored" + ")"));
batch.BatchCommands.Add(new NpgsqlBatchCommand( "create table albums (" + "  singer_id     bigint not null," + "  album_id      bigint not null," + "  album_title   varchar," + "  primary key (singer_id, album_id)" + ") interleave in parent singers on delete cascade"));
batch.ExecuteNonQuery();
Console.WriteLine($"Created Singers & Albums tables in database: [{database}]");
} }

PHP

function create_tables(string $host, string $port, string $database): void { // Connect to Spanner through PGAdapter using the PostgreSQL PDO driver.
$dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Create two tables in one batch.
$connection->exec("start batch ddl");
$connection->exec("create table singers (" ."  singer_id   bigint primary key not null," ."  first_name  character varying(1024)," ."  last_name   character varying(1024)," ."  singer_info bytea," ."  full_name   character varying(2048) generated " ."  always as (first_name || ' ' || last_name) stored" .")");
$connection->exec("create table albums (" ."  singer_id     bigint not null," ."  album_id      bigint not null," ."  album_title   character varying(1024)," ."  primary key (singer_id, album_id)" .") interleave in parent singers on delete cascade");
$connection->exec("run batch");
print("Created Singers & Albums tables in database: [{$database}]\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./create_tables.sh example-db

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar createtables example-db

Go

go run sample_runner.go createtables example-db

Node.js

npm start createtables example-db

Python

python create_tables.py example-db

C#

dotnet run createtables example-db

PHP

php create_tables.php example-db

下一步是将数据写入数据库。

创建连接

您必须先创建一个与 PGAdapter 的连接，然后才能执行读写操作。您与 Spanner 的所有交互都必须通过 Connection 进行。数据库名称在连接字符串中指定。

psql

#!/bin/bash

# Set the connection variables for psql.
# The following statements use the existing value of the variable if it has
# already been set, and otherwise assigns a default value.
export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Connect to Cloud Spanner using psql through PGAdapter
# and execute a simple query.
psql -c "select 'Hello world!' as hello"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

class CreateConnection { static void createConnection(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (ResultSet resultSet = connection.createStatement().executeQuery("select 'Hello world!' as hello")) { while (resultSet.next()) { System.out.printf("Greeting from Cloud Spanner PostgreSQL: %s\n", resultSet.getString(1));
} } } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func CreateConnection(host string, port int, database string) error { ctx := context.Background() // Connect to Cloud Spanner using pgx through PGAdapter.
// 'sslmode=disable' is optional, but adding it reduces the connection time, // as pgx will then skip first trying to create an SSL connection.
connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

row := conn.QueryRow(ctx, "select 'Hello world!' as hello") var msg string if err := row.Scan(&msg); err != nil { return err } fmt.Printf("Greeting from Cloud Spanner PostgreSQL: %s\n", msg)

return nil }

Node.js

import { Client } from 'pg';

async function createConnection(host: string, port: number, database: string): Promise { // Connect to Spanner through PGAdapter.
const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

const result = await connection.query("select 'Hello world!' as hello");
console.log(`Greeting from Cloud Spanner PostgreSQL: ${result.rows[0]['hello']}`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def create_connection(host: string, port: int, database: string):
# Connect to Cloud Spanner using psycopg3 through PGAdapter.
# 'sslmode=disable' is optional, but adding it reduces the connection time,
# as psycopg3 will then skip first trying to create an SSL connection.
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.execute("select 'Hello world!' as hello") print("Greeting from Cloud Spanner PostgreSQL:", cur.fetchone()[0])

C#

using Npgsql;

namespace dotnet_snippets;

public static class CreateConnectionSample { public static void CreateConnection(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = new NpgsqlCommand("select 'Hello World!' as hello", connection);
using var reader = cmd.ExecuteReader();
while (reader.Read()) { var greeting = reader.GetString(0);
Console.WriteLine($"Greeting from Cloud Spanner PostgreSQL: {greeting}");
} } }

PHP

function create_connection(string $host, string $port, string $database): void { // Connect to Spanner through PGAdapter using the PostgreSQL PDO driver.
$dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Execute a query on Spanner through PGAdapter.
$statement = $connection->query("select 'Hello world!' as hello");
$rows = $statement->fetchAll();

printf("Greeting from Cloud Spanner PostgreSQL: %s\n", $rows[0][0]);

// Cleanup resources.
$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./create_connection.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar createconnection example-db

Go

go run sample_runner.go createconnection example-db

Node.js

npm start createconnection example-db

Python

python create_connection.py example-db

C#

dotnet run createconnection example-db

PHP

php create_connection.php example-db

使用 DML 写入数据

您可以在读写事务中使用数据操纵语言 (DML) 插入数据。

这些示例展示了如何使用 PostgreSQL 驱动程序在 Spanner 上执行 DML 语句。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql -c "INSERT INTO singers (singer_id, first_name, last_name) VALUES (12, 'Melissa', 'Garcia'), (13, 'Russel', 'Morales'), (14, 'Jacqueline', 'Long'), (15, 'Dylan', 'Shaw')"

echo "4 records inserted"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

class WriteDataWithDml { static class Singer { private final long singerId;
private final String firstName;
private final String lastName;

Singer(final long id, final String first, final String last) { this.singerId = id;
this.firstName = first;
this.lastName = last;
} }

static void writeDataWithDml(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Add 4 rows in one statement.
// JDBC always uses '?' as a parameter placeholder.
try (PreparedStatement preparedStatement = connection.prepareStatement( "INSERT INTO singers (singer_id, first_name, last_name) VALUES " + "(?, ?, ?), " + "(?, ?, ?), " + "(?, ?, ?), " + "(?, ?, ?)")) {

final List singers = Arrays.asList( new Singer(/* SingerId= */ 12L, "Melissa", "Garcia"), new Singer(/* SingerId= */ 13L, "Russel", "Morales"), new Singer(/* SingerId= */ 14L, "Jacqueline", "Long"), new Singer(/* SingerId= */ 15L, "Dylan", "Shaw"));

// Note that JDBC parameters start at index 1.
int paramIndex = 0;
for (Singer singer : singers) { preparedStatement.setLong(++paramIndex, singer.singerId);
preparedStatement.setString(++paramIndex, singer.firstName);
preparedStatement.setString(++paramIndex, singer.lastName);
}

int updateCount = preparedStatement.executeUpdate();
System.out.printf("%d records inserted.\n", updateCount);
} } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func WriteDataWithDml(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

tag, err := conn.Exec(ctx, "INSERT INTO singers (singer_id, first_name, last_name) "+ "VALUES ($1, $2, $3), ($4, $5, $6), "+ "       ($7, $8, $9), ($10, $11, $12)", 12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw") if err != nil { return err } fmt.Printf("%v records inserted\n", tag.RowsAffected())

return nil }

Node.js

import { Client } from 'pg';

async function writeDataWithDml(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

const result = await connection.query("INSERT INTO singers (singer_id, first_name, last_name) " + "VALUES ($1, $2, $3), ($4, $5, $6), " + "       ($7, $8, $9), ($10, $11, $12)", [12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw"]) console.log(`${result.rowCount} records inserted`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def write_data_with_dml(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.execute("INSERT INTO singers (singer_id, first_name, last_name)" " VALUES (%s, %s, %s), (%s, %s, %s), " "        (%s, %s, %s), (%s, %s, %s)", (12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw",)) print("%d records inserted" % cur.rowcount)

C#

using Npgsql;

namespace dotnet_snippets;

public static class WriteDataWithDmlSample { readonly struct Singer { public Singer(long singerId, string firstName, string lastName) { SingerId = singerId;
FirstName = firstName;
LastName = lastName;
}

public long SingerId { get; } public string FirstName { get; } public string LastName { get; } }

public static void WriteDataWithDml(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();
// Add 4 rows in one statement.
using var cmd = new NpgsqlCommand("INSERT INTO singers (singer_id, first_name, last_name) VALUES " + "($1, $2, $3), " + "($4, $5, $6), " + "($7, $8, $9), " + "($10, $11, $12)", connection);
List singers = [ new Singer(/* SingerId = */ 12L, "Melissa", "Garcia"), new Singer(/* SingerId = */ 13L, "Russel", "Morales"), new Singer(/* SingerId = */ 14L, "Jacqueline", "Long"), new Singer(/* SingerId = */ 15L, "Dylan", "Shaw") ];
foreach (var singer in singers) { cmd.Parameters.Add(new NpgsqlParameter { Value = singer.SingerId });
cmd.Parameters.Add(new NpgsqlParameter { Value = singer.FirstName });
cmd.Parameters.Add(new NpgsqlParameter { Value = singer.LastName });
} var updateCount = cmd.ExecuteNonQuery();
Console.WriteLine($"{updateCount} records inserted.");
} }

PHP

function write_data_with_dml(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$sql = "INSERT INTO singers (singer_id, first_name, last_name)" ." VALUES (?, ?, ?), (?, ?, ?), " ."        (?, ?, ?), (?, ?, ?)";
$statement = $connection->prepare($sql);
$statement->execute([ 12, "Melissa", "Garcia", 13, "Russel", "Morales", 14, "Jacqueline", "Long", 15, "Dylan", "Shaw" ]);
printf("%d records inserted\n", $statement->rowCount());

$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./write_data_with_dml.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar writeusingdml example-db

Go

go run sample_runner.go writeusingdml example-db

Node.js

npm start writeusingdml example-db

Python

python write_data_with_dml.py example-db

C#

dotnet run writeusingdml example-db

PHP

php write_data_with_dml.php example-db

您应该会看到以下响应：

4 records inserted.

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用 DML 批处理写入数据

PGAdapter 支持执行 DML 批处理。在一个批处理操作中发送多个 DML 语句可减少与 Spanner 之间的往返次数，并提高应用的性能。
提示：您还可以使用 START BATCH DML 命令执行 DML 批处理。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Create a prepared insert statement and execute this prepared
# insert statement three times in one SQL string. The single
# SQL string with three insert statements will be executed as
# a single DML batch on Spanner.
psql -c "PREPARE insert_singer AS INSERT INTO singers (singer_id, first_name, last_name) VALUES (\$1, \$2, \$3)" \ -c "EXECUTE insert_singer (16, 'Sarah', 'Wilson');
EXECUTE insert_singer (17, 'Ethan', 'Miller');
EXECUTE insert_singer (18, 'Maya', 'Patel');"

echo "3 records inserted"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

class WriteDataWithDmlBatch { static class Singer { private final long singerId;
private final String firstName;
private final String lastName;

Singer(final long id, final String first, final String last) { this.singerId = id;
this.firstName = first;
this.lastName = last;
} }

static void writeDataWithDmlBatch(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Add multiple rows in one DML batch.
// JDBC always uses '?' as a parameter placeholder.
try (PreparedStatement preparedStatement = connection.prepareStatement( "INSERT INTO singers (singer_id, first_name, last_name) VALUES (?, ?, ?)")) { final List singers = Arrays.asList( new Singer(/* SingerId= */ 16L, "Sarah", "Wilson"), new Singer(/* SingerId= */ 17L, "Ethan", "Miller"), new Singer(/* SingerId= */ 18L, "Maya", "Patel"));

for (Singer singer : singers) { // Note that JDBC parameters start at index 1.
int paramIndex = 0;
preparedStatement.setLong(++paramIndex, singer.singerId);
preparedStatement.setString(++paramIndex, singer.firstName);
preparedStatement.setString(++paramIndex, singer.lastName);
preparedStatement.addBatch();
}

int[] updateCounts = preparedStatement.executeBatch();
System.out.printf("%d records inserted.\n", Arrays.stream(updateCounts).sum());
} } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func WriteDataWithDmlBatch(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

sql := "INSERT INTO singers (singer_id, first_name, last_name) " + "VALUES ($1, $2, $3)" batch := &pgx.Batch{} batch.Queue(sql, 16, "Sarah", "Wilson") batch.Queue(sql, 17, "Ethan", "Miller") batch.Queue(sql, 18, "Maya", "Patel") br := conn.SendBatch(ctx, batch) _, err = br.Exec() if err := br.Close(); err != nil { return err }

if err != nil { return err } fmt.Printf("%v records inserted\n", batch.Len())

return nil }

Node.js

import { Client } from 'pg';

async function writeDataWithDmlBatch(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// node-postgres does not support PostgreSQL pipeline mode, so we must use the // `start batch dml` / `run batch` statements to execute a DML batch.
const sql = "INSERT INTO singers (singer_id, first_name, last_name) VALUES ($1, $2, $3)";
await connection.query("start batch dml");
await connection.query(sql, [16, "Sarah", "Wilson"]);
await connection.query(sql, [17, "Ethan", "Miller"]);
await connection.query(sql, [18, "Maya", "Patel"]);
const result = await connection.query("run batch");
// RUN BATCH returns the update counts as an array of strings, with one element for each // DML statement in the batch. This calculates the total number of affected rows from that array.
const updateCount = result.rows[0]["UPDATE_COUNTS"] .map((s: string) => parseInt(s)) .reduce((c: number, current: number) => c + current, 0);
console.log(`${updateCount} records inserted`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def write_data_with_dml_batch(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.executemany("INSERT INTO singers " "(singer_id, first_name, last_name) " "VALUES (%s, %s, %s)", [(16, "Sarah", "Wilson",), (17, "Ethan", "Miller",), (18, "Maya", "Patel",), ]) print("%d records inserted" % cur.rowcount)

C#

using Npgsql;

namespace dotnet_snippets;

public static class WriteDataWithDmlBatchSample { readonly struct Singer { public Singer(long singerId, string firstName, string lastName) { SingerId = singerId;
FirstName = firstName;
LastName = lastName;
}

public long SingerId { get; } public string FirstName { get; } public string LastName { get; } }

public static void WriteDataWithDmlBatch(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Add multiple rows in one DML batch.
const string sql = "INSERT INTO singers (singer_id, first_name, last_name) VALUES ($1, $2, $3)";
List singers = [ new Singer(/* SingerId = */ 16L, "Sarah", "Wilson"), new Singer(/* SingerId = */ 17L, "Ethan", "Miller"), new Singer(/* SingerId = */ 18L, "Maya", "Patel") ];
using var batch = new NpgsqlBatch(connection);
foreach (var singer in singers) { batch.BatchCommands.Add(new NpgsqlBatchCommand { CommandText = sql, Parameters = { new NpgsqlParameter {Value = singer.SingerId}, new NpgsqlParameter {Value = singer.FirstName}, new NpgsqlParameter {Value = singer.LastName} } });
} var updateCount = batch.ExecuteNonQuery();
Console.WriteLine($"{updateCount} records inserted.");
} }

PHP

function write_data_with_dml_batch(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Use START BATCH DML / RUN BATCH to run a batch of DML statements.
// Create a prepared statement for the DML that should be executed.
$sql = "INSERT INTO singers (singer_id, first_name, last_name) VALUES (?, ?, ?)";
$statement = $connection->prepare($sql);
// Start a DML batch.
$connection->exec("START BATCH DML");

$statement->execute([16, "Sarah", "Wilson"]);
$statement->execute([17, "Ethan", "Miller"]);
$statement->execute([18, "Maya", "Patel"]);

// Run the DML batch. Use the 'query(..)' method, as the update counts are returned as a row // containing an array with the update count of each statement in the batch.
$statement = $connection->query("RUN BATCH");
$result = $statement->fetchAll();
$update_count = $result[0][0];

printf("%s records inserted\n", $update_count);

$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./write_data_with_dml_batch.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar writeusingdmlbatch example-db

Go

go run sample_runner.go writeusingdmlbatch example-db

Node.js

npm start writeusingdmlbatch example-db

Python

python write_data_with_dml_batch.py example-db

C#

dotnet run writeusingdmlbatch example-db

PHP

php write_data_with_dml_batch.php example-db

您应该会看到：

3 records inserted.

使用变更写入数据

您还可以使用变更插入数据。

PGAdapter 会将 PostgreSQL COPY 命令转换为变更。使用 COPY 是快速将数据插入 Spanner 数据库的最高效方法。

COPY 操作默认是原子操作。Spanner 中的原子操作受提交大小限制的约束。如需了解详情，请参阅 CRUD 限制。

以下示例展示了如何执行非原子 COPY 操作。这使 COPY 操作可以超出提交大小限制。
提示：如需详细了解如何直接将数据从 PostgreSQL 复制到 Spanner，请参阅复制支持。您还可以使用 COPY 命令直接从 MySQL 导入数据。

psql

#!/bin/bash

# Get the source directory of this script.
directory=${BASH_SOURCE%/*}/

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Copy data to Spanner from a tab-separated text file using the COPY command.
psql -c "COPY singers (singer_id, first_name, last_name) FROM STDIN" \ < "${directory}singers_data.txt" psql -c "COPY albums FROM STDIN" \ < "${directory}albums_data.txt"

echo "Copied singers and albums"

Java

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.postgresql.PGConnection;
import org.postgresql.copy.CopyManager;

class WriteDataWithCopy {

static void writeDataWithCopy(String host, int port, String database) throws SQLException, IOException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Unwrap the PostgreSQL JDBC connection interface to get access to // a CopyManager.
PGConnection pgConnection = connection.unwrap(PGConnection.class);
CopyManager copyManager = pgConnection.getCopyAPI();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
connection .createStatement() .execute("set spanner.autocommit_dml_mode='partitioned_non_atomic'");
long numSingers = copyManager.copyIn( "COPY singers (singer_id, first_name, last_name) FROM STDIN", WriteDataWithCopy.class.getResourceAsStream("singers_data.txt"));
System.out.printf("Copied %d singers\n", numSingers);

long numAlbums = copyManager.copyIn( "COPY albums FROM STDIN", WriteDataWithCopy.class.getResourceAsStream("albums_data.txt"));
System.out.printf("Copied %d albums\n", numAlbums);
} } }

Go

import (
"context" "fmt" "os"

"github.com/jackc/pgx/v5" )

func WriteDataWithCopy(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
conn.Exec(ctx, "set spanner.autocommit_dml_mode='partitioned_non_atomic'")

file, err := os.Open("samples/singers_data.txt") if err != nil { return err } tag, err := conn.PgConn().CopyFrom(ctx, file, "copy singers (singer_id, first_name, last_name) from stdin") if err != nil { return err } fmt.Printf("Copied %v singers\n", tag.RowsAffected())

file, err = os.Open("samples/albums_data.txt") if err != nil { return err } tag, err = conn.PgConn().CopyFrom(ctx, file, "copy albums from stdin") if err != nil { return err } fmt.Printf("Copied %v albums\n", tag.RowsAffected())

return nil }

Node.js

import { Client } from 'pg';
import { pipeline } from 'node:stream/promises'
import fs from 'node:fs'
import { from as copyFrom } from 'pg-copy-streams'
import path from "path";

async function writeDataWithCopy(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
await connection.query("set spanner.autocommit_dml_mode='partitioned_non_atomic'");
// Copy data from a csv file to Spanner using the COPY command.
// Note that even though the command says 'from stdin', the actual input comes from a file.
const copySingersStream = copyFrom('copy singers (singer_id, first_name, last_name) from stdin');
const ingestSingersStream = connection.query(copySingersStream);
const sourceSingersStream = fs.createReadStream(path.join(__dirname, 'singers_data.txt'));
await pipeline(sourceSingersStream, ingestSingersStream);
console.log(`Copied ${copySingersStream.rowCount} singers`);

const copyAlbumsStream = copyFrom('copy albums from stdin');
const ingestAlbumsStream = connection.query(copyAlbumsStream);
const sourceAlbumsStream = fs.createReadStream(path.join(__dirname, 'albums_data.txt'));
await pipeline(sourceAlbumsStream, ingestAlbumsStream);
console.log(`Copied ${copyAlbumsStream.rowCount} albums`);

// Close the connection.
await connection.end();
}

Python

import os
import string
import psycopg

def write_data_with_copy(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:

script_dir = os.path.dirname(os.path.abspath(__file__)) singers_file_path = os.path.join(script_dir, "singers_data.txt") albums_file_path = os.path.join(script_dir, "albums_data.txt")

conn.autocommit = True block_size = 1024 with conn.cursor() as cur:
with open(singers_file_path, "r") as f:
with cur.copy("COPY singers (singer_id, first_name, last_name) " "FROM STDIN") as copy:
while data := f.read(block_size):
copy.write(data) print("Copied %d singers" % cur.rowcount)

with open(albums_file_path, "r") as f:
with cur.copy("COPY albums " "FROM STDIN") as copy:
while data := f.read(block_size):
copy.write(data) print("Copied %d albums" % cur.rowcount)

C#

using Npgsql;

namespace dotnet_snippets;

public static class WriteDataWithCopySample { public static void WriteDataWithCopy(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
using var cmd = new NpgsqlCommand("set spanner.autocommit_dml_mode='partitioned_non_atomic'", connection);
cmd.ExecuteNonQuery();

var singerCount = 0;
using var singerReader = new StreamReader("singers_data.txt");
using (var singerWriter = connection.BeginTextImport("COPY singers (singer_id, first_name, last_name) FROM STDIN")) { while (singerReader.ReadLine() is { } line) { singerWriter.WriteLine(line);
singerCount++;
} } Console.WriteLine($"Copied {singerCount} singers");

var albumCount = 0;
using var albumReader = new StreamReader("albums_data.txt");
using (var albumWriter = connection.BeginTextImport("COPY albums FROM STDIN")) { while (albumReader.ReadLine() is { } line) { albumWriter.WriteLine(line);
albumCount++;
} } Console.WriteLine($"Copied {albumCount} albums");
} }

PHP

function write_data_with_copy(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$dir = dirname(__FILE__);

$connection->pgsqlCopyFromFile( "singers", sprintf("%s/singers_data.txt", $dir), "\t", "\\\\N", "singer_id, first_name, last_name");
print("Copied 5 singers\n");

$connection->pgsqlCopyFromFile( "albums", sprintf("%s/albums_data.txt", $dir));
print("Copied 5 albums\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./write_data_with_copy.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar write example-db

Go

go run sample_runner.go write example-db

Node.js

npm start write example-db

Python

python write_data_with_copy.py example-db

C#

dotnet run write example-db

PHP

php write_data_with_copy.php example-db

您应该会看到：

Copied 5 singers Copied 5 albums

注意：提交大小有限制。如需了解详情，请参阅 CRUD 限制。

使用 SQL 查询数据

Spanner 支持使用 SQL 接口读取数据，您可以使用 Google Cloud CLI 在命令行中访问该接口，也可以使用 PostgreSQL 驱动程序以编程方式访问该接口。

在命令行中

执行以下 SQL 语句，读取 Albums 表中所有列的值：

gcloud spanner databases execute-sql example-db --instance=test-instance \ --sql='SELECT singer_id, album_id, album_title FROM albums'

注意：如需查看 GoogleSQL 参考文档，请参阅 GoogleSQL 中的查询语法；如需查看 PostgreSQL 参考文档，请参阅 PostgreSQL 词汇结构和语法。

结果会显示以下内容：

SingerId AlbumId AlbumTitle 1        1       Total Junk 1        2       Go, Go, Go 2        1       Green 2        2       Forever Hold Your Peace 2        3       Terrified

使用 PostgreSQL 驱动程序

除了在命令行中执行 SQL 语句外，还可以使用 PostgreSQL 驱动程序以编程方式发出相同的 SQL 语句。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql -c "SELECT singer_id, album_id, album_title FROM albums"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

class QueryData { static void queryData(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (ResultSet resultSet = connection .createStatement() .executeQuery("SELECT singer_id, album_id, album_title FROM albums")) { while (resultSet.next()) { System.out.printf( "%d %d %s\n", resultSet.getLong("singer_id"), resultSet.getLong("album_id"), resultSet.getString("album_title"));
} } } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func QueryData(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

rows, err := conn.Query(ctx, "SELECT singer_id, album_id, album_title "+ "FROM albums") defer rows.Close() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var title string err = rows.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Printf("%v %v %v\n", singerId, albumId, title) }

return rows.Err() }

Node.js

import { Client } from 'pg';

async function queryData(host: string, port: number, database: string): Promise { // Connect to Spanner through PGAdapter.
const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

const result = await connection.query("SELECT singer_id, album_id, album_title " + "FROM albums");
for (const row of result.rows) { console.log(`${row["singer_id"]} ${row["album_id"]} ${row["album_title"]}`);
}

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def query_data(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.execute("SELECT singer_id, album_id, album_title " "FROM albums") for album in cur:
print(album)

C#

using Npgsql;

namespace dotnet_snippets;

public static class QueryDataSample { public static void QueryData(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = new NpgsqlCommand("SELECT singer_id, album_id, album_title FROM albums", connection);
using var reader = cmd.ExecuteReader();
while (reader.Read()) { Console.WriteLine($"{reader.GetInt64(0)} {reader.GetInt64(1)} {reader.GetString(2)}");
} } }

PHP

function query_data(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$statement = $connection->query("SELECT singer_id, album_id, album_title " ."FROM albums " ."ORDER BY singer_id, album_id" );
$rows = $statement->fetchAll();
foreach ($rows as $album) { printf("%s\t%s\t%s\n", $album["singer_id"], $album["album_id"], $album["album_title"]);
}

$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./query_data.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar query example-db

Go

go run sample_runner.go query example-db

Node.js

npm start query example-db

Python

python query_data.py example-db

C#

dotnet run query example-db

PHP

php query_data.php example-db

您应该会看到以下结果：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified

使用 SQL 参数进行查询

如果您的应用具有频繁执行的查询，您可以通过将其参数化来提高其性能。生成的参数查询可以缓存下来并重复使用，这样做可以降低编译开销。如需了解详情，请参阅使用查询参数来加快频繁执行的查询的运行速度。

以下示例演示了如何在 WHERE 子句中使用参数来查询包含特定 LastName 值的记录。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Create a prepared statement to use a query parameter.
# Using a prepared statement for executing the same SQL string multiple
# times increases the execution speed of the statement.
psql -c "PREPARE select_singer AS SELECT singer_id, first_name, last_name FROM singers WHERE last_name = \$1" \ -c "EXECUTE select_singer ('Garcia')"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

class QueryDataWithParameter { static void queryDataWithParameter(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (PreparedStatement statement = connection.prepareStatement( "SELECT singer_id, first_name, last_name " + "FROM singers " + "WHERE last_name = ?")) { statement.setString(1, "Garcia");
try (ResultSet resultSet = statement.executeQuery()) { while (resultSet.next()) { System.out.printf( "%d %s %s\n", resultSet.getLong("singer_id"), resultSet.getString("first_name"), resultSet.getString("last_name"));
} } } } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func QueryDataWithParameter(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

rows, err := conn.Query(ctx, "SELECT singer_id, first_name, last_name "+ "FROM singers "+ "WHERE last_name = $1", "Garcia") defer rows.Close() if err != nil { return err } for rows.Next() { var singerId int64 var firstName, lastName string err = rows.Scan(&singerId, &firstName, &lastName) if err != nil { return err } fmt.Printf("%v %v %v\n", singerId, firstName, lastName) }

return rows.Err() }

Node.js

import { Client } from 'pg';

async function queryWithParameter(host: string, port: number, database: string): Promise { // Connect to Spanner through PGAdapter.
const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

const result = await connection.query( "SELECT singer_id, first_name, last_name " + "FROM singers " + "WHERE last_name = $1", ["Garcia"]);
for (const row of result.rows) { console.log(`${row["singer_id"]} ${row["first_name"]} ${row["last_name"]}`);
}

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def query_data_with_parameter(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.execute("SELECT singer_id, first_name, last_name " "FROM singers " "WHERE last_name = %s", ("Garcia",)) for singer in cur:
print(singer)

C#

using Npgsql;

namespace dotnet_snippets;

public static class QueryDataWithParameterSample { public static void QueryDataWithParameter(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = new NpgsqlCommand("SELECT singer_id, first_name, last_name " + "FROM singers " + "WHERE last_name = $1", connection);
cmd.Parameters.Add(new NpgsqlParameter { Value = "Garcia" });
using var reader = cmd.ExecuteReader();
while (reader.Read()) { Console.WriteLine($"{reader["singer_id"]} {reader["first_name"]} {reader["last_name"]}");
} } }

PHP

function query_data_with_parameter(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$statement = $connection->prepare("SELECT singer_id, first_name, last_name " ."FROM singers " ."WHERE last_name = ?" );
$statement->execute(["Garcia"]);
$rows = $statement->fetchAll();
foreach ($rows as $singer) { printf("%s\t%s\t%s\n", $singer["singer_id"], $singer["first_name"], $singer["last_name"]);
}

$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./query_data_with_parameter.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar querywithparameter example-db

Go

go run sample_runner.go querywithparameter example-db

Node.js

npm start querywithparameter example-db

Python

python query_data_with_parameter.py example-db

C#

dotnet run querywithparameter example-db

PHP

php query_data_with_parameter.php example-db

您应该会看到以下结果：

12 Melissa Garcia

更新数据库架构

假设您需要将名为 MarketingBudget 的新列添加到 Albums 表。向现有表添加新列需要更新数据库架构。Spanner 支持在数据库继续处理流量的同时，对数据库进行架构更新。架构更新不需要使数据库离线，并且不会锁定整个表或列；在架构更新期间，您可以继续将数据写入数据库。如需详细了解支持的架构更新和架构更改性能，请参阅更新架构。

添加列

您可以使用 Google Cloud CLI 在命令行中添加列，也可以使用 PostgreSQL 驱动程序以编程方式添加列。

在命令行中

使用以下 ALTER TABLE 命令向表添加新列：

gcloud spanner databases ddl update example-db --instance=test-instance \ --ddl='ALTER TABLE albums ADD COLUMN marketing_budget BIGINT'

您应该会看到：

Schema updating...done.

使用 PostgreSQL 驱动程序

使用 PostgreSQL 驱动程序执行 DDL 语句以修改架构：

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql -c "ALTER TABLE albums ADD COLUMN marketing_budget bigint" echo "Added marketing_budget column"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

class AddColumn { static void addColumn(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { connection.createStatement().execute("alter table albums add column marketing_budget bigint");
System.out.println("Added marketing_budget column");
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func AddColumn(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

_, err = conn.Exec(ctx, "ALTER TABLE albums "+ "ADD COLUMN marketing_budget bigint") if err != nil { return err } fmt.Println("Added marketing_budget column")

return nil }

Node.js

import { Client } from 'pg';

async function addColumn(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

await connection.query( "ALTER TABLE albums " + "ADD COLUMN marketing_budget bigint");
console.log("Added marketing_budget column");

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def add_column(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
# DDL can only be executed when autocommit=True.
conn.autocommit = True with conn.cursor() as cur:
cur.execute("ALTER TABLE albums " "ADD COLUMN marketing_budget bigint") print("Added marketing_budget column")

C#

using Npgsql;

namespace dotnet_snippets;

public static class AddColumnSample { public static void AddColumn(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = connection.CreateCommand();
cmd.CommandText = "alter table albums add column marketing_budget bigint";
cmd.ExecuteNonQuery();
Console.WriteLine("Added marketing_budget column");
} }

PHP

function add_column(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$connection->exec("ALTER TABLE albums ADD COLUMN marketing_budget bigint");
print("Added marketing_budget column\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./add_column.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar addmarketingbudget example-db

Go

go run sample_runner.go addmarketingbudget example-db

Node.js

npm start addmarketingbudget example-db

Python

python add_column.py example-db

C#

dotnet run addmarketingbudget example-db

PHP

php add_column.php example-db

您应该会看到：

Added marketing_budget column

执行 DDL 批处理

建议在一个批处理操作中执行多个架构修改。您可以通过以下方式在一个批处理操作中执行多个 DDL 语句：使用 PostgreSQL 驱动程序的内置批处理功能、以一个 SQL 字符串的形式提交所有 DDL 语句（用英文分号分隔）或是使用 START BATCH DDL 和 RUN BATCH 语句。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Use a single SQL command to batch multiple statements together.
# Executing multiple DDL statements as one batch is more efficient
# than executing each statement individually.
# Separate the statements with semicolons.
psql << SQL

CREATE TABLE venues ( venue_id    bigint not null primary key, name        varchar(1024),
  description jsonb
);

CREATE TABLE concerts ( concert_id bigint not null primary key , venue_id   bigint not null, singer_id  bigint not null, start_time timestamptz, end_time   timestamptz, constraint fk_concerts_venues foreign key (venue_id) references venues (venue_id), constraint fk_concerts_singers foreign key (singer_id) references singers (singer_id) );

SQL

echo "Added venues and concerts tables"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

class DdlBatch { static void ddlBatch(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (Statement statement = connection.createStatement()) { // Create two new tables in one batch.
statement.addBatch( "CREATE TABLE venues (" + "  venue_id    bigint not null primary key," + "  name        varchar(1024)," + "  description jsonb" + ")");
statement.addBatch( "CREATE TABLE concerts (" + "  concert_id bigint not null primary key ," + "  venue_id   bigint not null," + "  singer_id  bigint not null," + "  start_time timestamptz," + "  end_time   timestamptz," + "  constraint fk_concerts_venues foreign key" + "    (venue_id) references venues (venue_id)," + "  constraint fk_concerts_singers foreign key" + "    (singer_id) references singers (singer_id)" + ")");
statement.executeBatch();
} System.out.println("Added venues and concerts tables");
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func DdlBatch(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Executing multiple DDL statements as one batch is // more efficient than executing each statement // individually.
br := conn.SendBatch(ctx, &pgx.Batch{QueuedQueries: []*pgx.QueuedQuery{ {SQL: "CREATE TABLE venues (" + "  venue_id    bigint not null primary key," + "  name        varchar(1024)," + "  description jsonb" + ")"}, {SQL: "CREATE TABLE concerts (" + "  concert_id bigint not null primary key ," + "  venue_id   bigint not null," + "  singer_id  bigint not null," + "  start_time timestamptz," + "  end_time   timestamptz," + "  constraint fk_concerts_venues foreign key" + "    (venue_id) references venues (venue_id)," + "  constraint fk_concerts_singers foreign key" + "    (singer_id) references singers (singer_id)" + ")"}, }}) if _, err := br.Exec(); err != nil { return err } if err := br.Close(); err != nil { return err } fmt.Println("Added venues and concerts tables")

return nil }

Node.js

import { Client } from 'pg';

async function ddlBatch(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Executing multiple DDL statements as one batch is // more efficient than executing each statement // individually.
await connection.query("start batch ddl");
await connection.query("CREATE TABLE venues (" + "  venue_id    bigint not null primary key," + "  name        varchar(1024)," + "  description jsonb" + ")");
await connection.query("CREATE TABLE concerts (" + "  concert_id bigint not null primary key ," + "  venue_id   bigint not null," + "  singer_id  bigint not null," + "  start_time timestamptz," + "  end_time   timestamptz," + "  constraint fk_concerts_venues foreign key" + "    (venue_id) references venues (venue_id)," + "  constraint fk_concerts_singers foreign key" + "    (singer_id) references singers (singer_id)" + ")");
await connection.query("run batch");
console.log("Added venues and concerts tables");

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def ddl_batch(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
# DDL can only be executed when autocommit=True.
conn.autocommit = True
# Use a pipeline to batch multiple statements together.
# Executing multiple DDL statements as one batch is
# more efficient than executing each statement
# individually.
with conn.pipeline():
# The following statements are buffered on PGAdapter
# until the pipeline ends.
conn.execute("CREATE TABLE venues (" "  venue_id    bigint not null primary key," "  name        varchar(1024)," "  description jsonb" ")") conn.execute("CREATE TABLE concerts (" "  concert_id bigint not null primary key ," "  venue_id   bigint not null," "  singer_id  bigint not null," "  start_time timestamptz," "  end_time   timestamptz," "  constraint fk_concerts_venues foreign key" "    (venue_id) references venues (venue_id)," "  constraint fk_concerts_singers foreign key" "    (singer_id) references singers (singer_id)" ")") print("Added venues and concerts tables")

C#

using Npgsql;

namespace dotnet_snippets;

public static class DdlBatchSample { public static void DdlBatch(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Create two new tables in one batch.
var batch = connection.CreateBatch();
batch.BatchCommands.Add(new NpgsqlBatchCommand( "CREATE TABLE venues (" + "  venue_id    bigint not null primary key," + "  name        varchar(1024)," + "  description jsonb" + ")"));
batch.BatchCommands.Add(new NpgsqlBatchCommand( "CREATE TABLE concerts (" + "  concert_id bigint not null primary key ," + "  venue_id   bigint not null," + "  singer_id  bigint not null," + "  start_time timestamptz," + "  end_time   timestamptz," + "  constraint fk_concerts_venues foreign key" + "    (venue_id) references venues (venue_id)," + "  constraint fk_concerts_singers foreign key" + "    (singer_id) references singers (singer_id)" + ")"));
batch.ExecuteNonQuery();
Console.WriteLine("Added venues and concerts tables");
} }

PHP

function ddl_batch(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Executing multiple DDL statements as one batch is // more efficient than executing each statement // individually.
$connection->exec("start batch ddl");
$connection->exec("CREATE TABLE venues (" ."  venue_id    bigint not null primary key," ."  name        varchar(1024)," ."  description jsonb" .")");
$connection->exec("CREATE TABLE concerts (" ."  concert_id bigint not null primary key ," ."  venue_id   bigint not null," ."  singer_id  bigint not null," ."  start_time timestamptz," ."  end_time   timestamptz," ."  constraint fk_concerts_venues foreign key" ."    (venue_id) references venues (venue_id)," ."  constraint fk_concerts_singers foreign key" ."    (singer_id) references singers (singer_id)" .")");
$connection->exec("run batch");
print("Added venues and concerts tables\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./ddl_batch.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar ddlbatch example-db

Go

go run sample_runner.go ddlbatch example-db

Node.js

npm start ddlbatch example-db

Python

python ddl_batch.py example-db

C#

dotnet run ddlbatch example-db

PHP

php ddl_batch.php example-db

您应该会看到：

Added venues and concerts tables

将数据写入新列

以下代码可将数据写入新列。对于 Albums(1, 1) 键控的行，该代码会将 MarketingBudget 设置为 100000；而对于 Albums(2, 2) 键控的行，该代码会将其设置为 500000。

PGAdapter 会将 PostgreSQL COPY 命令转换为变更。COPY 命令默认会转换为 Insert 变更。执行 set spanner.copy_upsert=true 可将 COPY 命令转换为 InsertOrUpdate 变更。这可用于更新 Spanner 中的现有数据。

提示：如需查看可用于通过 PGAdapter 访问 Spanner 功能的完整命令列表，请参阅 PGAdapter 会话管理命令。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Instruct PGAdapter to use insert-or-update for COPY statements.
# This enables us to use COPY to update data.
psql -c "set spanner.copy_upsert=true" \ -c "COPY albums (singer_id, album_id, marketing_budget) FROM STDIN WITH (DELIMITER ';')" \ << DATA 1;1;100000 2;2;500000 DATA

echo "Copied albums using upsert"

Java

import java.io.IOException;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.postgresql.PGConnection;
import org.postgresql.copy.CopyManager;

class UpdateDataWithCopy {

static void updateDataWithCopy(String host, int port, String database) throws SQLException, IOException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Unwrap the PostgreSQL JDBC connection interface to get access to // a CopyManager.
PGConnection pgConnection = connection.unwrap(PGConnection.class);
CopyManager copyManager = pgConnection.getCopyAPI();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
connection .createStatement() .execute("set spanner.autocommit_dml_mode='partitioned_non_atomic'");

// Instruct PGAdapter to use insert-or-update for COPY statements.
// This enables us to use COPY to update existing data.
connection.createStatement().execute("set spanner.copy_upsert=true");

// COPY uses mutations to insert or update existing data in Spanner.
long numAlbums = copyManager.copyIn( "COPY albums (singer_id, album_id, marketing_budget) FROM STDIN", new StringReader("1\t1\t100000\n" + "2\t2\t500000\n"));
System.out.printf("Updated %d albums\n", numAlbums);
} } }

Go

import (
"context" "fmt" "io"

"github.com/jackc/pgx/v5" )

func UpdateDataWithCopy(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Enable non-atomic mode. This makes the COPY operation non-atomic, // and allows it to exceed the Spanner mutation limit.
if _, err := conn.Exec(ctx, "set spanner.autocommit_dml_mode='partitioned_non_atomic'"); err != nil { return err } // Instruct PGAdapter to use insert-or-update for COPY statements.
// This enables us to use COPY to update data.
if _, err := conn.Exec(ctx, "set spanner.copy_upsert=true"); err != nil { return err }

// Create a pipe that can be used to write the data manually that we want to copy.
reader, writer := io.Pipe() // Write the data to the pipe using a separate goroutine. This allows us to stream the data // to the COPY operation row-by-row.
go func() error { for _, record := range []string{"1\t1\t100000\n", "2\t2\t500000\n"} { if _, err := writer.Write([]byte(record)); err != nil { return err } } if err := writer.Close(); err != nil { return err } return nil }() tag, err := conn.PgConn().CopyFrom(ctx, reader, "COPY albums (singer_id, album_id, marketing_budget) FROM STDIN") if err != nil { return err } fmt.Printf("Updated %v albums\n", tag.RowsAffected())

return nil }

Node.js

import { Client } from 'pg';
import { pipeline } from 'node:stream/promises'
import { from as copyFrom } from 'pg-copy-streams'
import {Readable} from "stream";

async function updateDataWithCopy(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
await connection.query("set spanner.autocommit_dml_mode='partitioned_non_atomic'");

// Instruct PGAdapter to use insert-or-update for COPY statements.
// This enables us to use COPY to update existing data.
await connection.query("set spanner.copy_upsert=true");

// Copy data to Spanner using the COPY command.
const copyStream = copyFrom('COPY albums (singer_id, album_id, marketing_budget) FROM STDIN');
const ingestStream = connection.query(copyStream);

// Create a source stream and attach the source to the destination.
const sourceStream = new Readable();
const operation = pipeline(sourceStream, ingestStream);
// Manually push data to the source stream to write data to Spanner.
sourceStream.push("1\t1\t100000\n");
sourceStream.push("2\t2\t500000\n");
// Push a 'null' to indicate the end of the stream.
sourceStream.push(null);
// Wait for the copy operation to finish.
await operation;
console.log(`Updated ${copyStream.rowCount} albums`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def update_data_with_copy(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
# Instruct PGAdapter to use insert-or-update for COPY statements.
# This enables us to use COPY to update data.
cur.execute("set spanner.copy_upsert=true")

# COPY uses mutations to insert or update existing data in Spanner.
with cur.copy("COPY albums (singer_id, album_id, marketing_budget) " "FROM STDIN") as copy:
copy.write_row((1, 1, 100000)) copy.write_row((2, 2, 500000)) print("Updated %d albums" % cur.rowcount)

C#

using Npgsql;

namespace dotnet_snippets;

public static class UpdateDataWithCopySample { public static void UpdateDataWithCopy(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Enable 'partitioned_non_atomic' mode. This ensures that the COPY operation // will succeed even if it exceeds Spanner's mutation limit per transaction.
using var cmd = connection.CreateCommand();
cmd.CommandText = "set spanner.autocommit_dml_mode='partitioned_non_atomic'";
cmd.ExecuteNonQuery();

// Instruct PGAdapter to use insert-or-update for COPY statements.
// This enables us to use COPY to update existing data.
cmd.CommandText = "set spanner.copy_upsert=true";
cmd.ExecuteNonQuery();

// COPY uses mutations to insert or update existing data in Spanner.
using (var albumWriter = connection.BeginTextImport( "COPY albums (singer_id, album_id, marketing_budget) FROM STDIN")) { albumWriter.WriteLine("1\t1\t100000");
albumWriter.WriteLine("2\t2\t500000");
} Console.WriteLine($"Updated 2 albums");
} }

PHP

function update_data_with_copy(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Instruct PGAdapter to use insert-or-update for COPY statements.
// This enables us to use COPY to update data.
$connection->exec("set spanner.copy_upsert=true");

// COPY uses mutations to insert or update existing data in Spanner.
$connection->pgsqlCopyFromArray( "albums", ["1\t1\t100000", "2\t2\t500000"], "\t", "\\\\N", "singer_id, album_id, marketing_budget", );
print("Updated 2 albums\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./update_data_with_copy.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar update example-db

Go

go run sample_runner.go update example-db

Node.js

npm start update example-db

Python

python update_data_with_copy.py example-db

C#

dotnet run update example-db

PHP

php update_data_with_copy.php example-db

您应该会看到：

Updated 2 albums

您也可以执行 SQL 查询来获取刚刚写入的值。

以下是执行查询的代码：

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql -c "SELECT singer_id, album_id, marketing_budget FROM albums ORDER BY singer_id, album_id"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

class QueryDataWithNewColumn { static void queryDataWithNewColumn(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { try (ResultSet resultSet = connection .createStatement() .executeQuery( "SELECT singer_id, album_id, marketing_budget " + "FROM albums " + "ORDER BY singer_id, album_id")) { while (resultSet.next()) { System.out.printf( "%d %d %s\n", resultSet.getLong("singer_id"), resultSet.getLong("album_id"), resultSet.getString("marketing_budget"));
} } } } }

Go

import (
"context" "database/sql" "fmt"

"github.com/jackc/pgx/v5" )

func QueryDataWithNewColumn(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

rows, err := conn.Query(ctx, "SELECT singer_id, album_id, marketing_budget "+ "FROM albums "+ "ORDER BY singer_id, album_id") defer rows.Close() if err != nil { return err } for rows.Next() { var singerId, albumId int64 var marketingBudget sql.NullString err = rows.Scan(&singerId, &albumId, &marketingBudget) if err != nil { return err } var budget string if marketingBudget.Valid { budget = marketingBudget.String } else { budget = "NULL" } fmt.Printf("%v %v %v\n", singerId, albumId, budget) }

return rows.Err() }

Node.js

import { Client } from 'pg';

async function queryDataWithNewColumn(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

const result = await connection.query( "SELECT singer_id, album_id, marketing_budget " + "FROM albums " + "ORDER BY singer_id, album_id" );
for (const row of result.rows) { console.log(`${row["singer_id"]} ${row["album_id"]} ${row["marketing_budget"]}`);
}

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def query_data_with_new_column(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
cur.execute("SELECT singer_id, album_id, marketing_budget " "FROM albums " "ORDER BY singer_id, album_id") for album in cur:
print(album)

C#

using Npgsql;

namespace dotnet_snippets;

public static class QueryDataWithNewColumnSample { public static void QueryWithNewColumnData(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = new NpgsqlCommand("SELECT singer_id, album_id, marketing_budget " + "FROM albums " + "ORDER BY singer_id, album_id", connection);
using var reader = cmd.ExecuteReader();
while (reader.Read()) { Console.WriteLine($"{reader["singer_id"]} {reader["album_id"]} {reader["marketing_budget"]}");
} } }

PHP

function query_data_with_new_column(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

$statement = $connection->query( "SELECT singer_id, album_id, marketing_budget " ."FROM albums " ."ORDER BY singer_id, album_id" );
$rows = $statement->fetchAll();
foreach ($rows as $album) { printf("%s\t%s\t%s\n", $album["singer_id"], $album["album_id"], $album["marketing_budget"]);
}

$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行查询：

psql

PGDATABASE=example-db ./query_data_with_new_column.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar querymarketingbudget example-db

Go

go run sample_runner.go querymarketingbudget example-db

Node.js

npm start querymarketingbudget example-db

Python

python query_data_with_new_column.py example-db

C#

dotnet run querymarketingbudget example-db

PHP

php query_data_with_new_column.php example-db

您应该会看到：

1 1 100000 1 2 null 2 1 null 2 2 500000 2 3 null

更新数据

您可以在读写事务中使用 DML 来更新数据。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql << SQL -- Transfer marketing budget from one album to another.
-- We do it in a transaction to ensure that the transfer is atomic.
-- Begin a read/write transaction.
begin;

-- Increase the marketing budget of album 1 if album 2 has enough budget.
-- The condition that album 2 has enough budget is guaranteed for the -- duration of the transaction, as read/write transactions in Spanner use -- external consistency as the default isolation level.
update albums set marketing_budget = marketing_budget + 200000 where singer_id = 1 and  album_id = 1 and exists ( select album_id from albums where singer_id = 2 and  album_id = 2 and marketing_budget > 200000 );

-- Decrease the marketing budget of album 2.
update albums set marketing_budget = marketing_budget - 200000 where singer_id = 2 and  album_id = 2 and marketing_budget > 200000;

-- Commit the transaction to make the changes to both marketing budgets -- durably stored in the database and visible to other transactions.
commit;
SQL

echo "Transferred marketing budget from Album 2 to Album 1"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

class UpdateDataWithTransaction {

static void writeWithTransactionUsingDml(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Set AutoCommit=false to enable transactions.
connection.setAutoCommit(false);

// Transfer marketing budget from one album to another. We do it in a // transaction to ensure that the transfer is atomic. There is no need // to explicitly start the transaction. The first statement on the // connection will start a transaction when AutoCommit=false.
String selectMarketingBudgetSql = "SELECT marketing_budget from albums WHERE singer_id = ? and album_id = ?";
long album2Budget = 0;
try (PreparedStatement selectMarketingBudgetStatement = connection.prepareStatement(selectMarketingBudgetSql)) { // Bind the query parameters to SingerId=2 and AlbumId=2.
selectMarketingBudgetStatement.setLong(1, 2);
selectMarketingBudgetStatement.setLong(2, 2);
try (ResultSet resultSet = selectMarketingBudgetStatement.executeQuery()) { while (resultSet.next()) { album2Budget = resultSet.getLong("marketing_budget");
} } // The transaction will only be committed if this condition still holds // at the time of commit. Otherwise, the transaction will be aborted.
final long transfer = 200000;
if (album2Budget >= transfer) { long album1Budget = 0;
// Re-use the existing PreparedStatement for selecting the // marketing_budget to get the budget for Album 1.
// Bind the query parameters to SingerId=1 and AlbumId=1.
selectMarketingBudgetStatement.setLong(1, 1);
selectMarketingBudgetStatement.setLong(2, 1);
try (ResultSet resultSet = selectMarketingBudgetStatement.executeQuery()) { while (resultSet.next()) { album1Budget = resultSet.getLong("marketing_budget");
} }

// Transfer part of the marketing budget of Album 2 to Album 1.
album1Budget += transfer;
album2Budget -= transfer;
String updateSql = "UPDATE albums " + "SET marketing_budget = ? " + "WHERE singer_id = ? and album_id = ?";
try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) { // Update Album 1.
int paramIndex = 0;
updateStatement.setLong(++paramIndex, album1Budget);
updateStatement.setLong(++paramIndex, 1);
updateStatement.setLong(++paramIndex, 1);
// Create a DML batch by calling addBatch // on the current PreparedStatement.
updateStatement.addBatch();

// Update Album 2 in the same DML batch.
paramIndex = 0;
updateStatement.setLong(++paramIndex, album2Budget);
updateStatement.setLong(++paramIndex, 2);
updateStatement.setLong(++paramIndex, 2);
updateStatement.addBatch();

// Execute both DML statements in one batch.
updateStatement.executeBatch();
} } } // Commit the current transaction.
connection.commit();
System.out.println("Transferred marketing budget from Album 2 to Album 1");
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func WriteWithTransactionUsingDml(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Transfer marketing budget from one album to another. We do it in a // transaction to ensure that the transfer is atomic.
tx, err := conn.Begin(ctx) if err != nil { return err } const selectSql = "SELECT marketing_budget " + "from albums " + "WHERE singer_id = $1 and album_id = $2" // Get the marketing_budget of singer 2 / album 2.
row := tx.QueryRow(ctx, selectSql, 2, 2) var budget2 int64 if err := row.Scan(&budget2); err != nil { tx.Rollback(ctx) return err } const transfer = 20000 // The transaction will only be committed if this condition still holds // at the time of commit. Otherwise, the transaction will be aborted.
if budget2 >= transfer { // Get the marketing_budget of singer 1 / album 1.
row := tx.QueryRow(ctx, selectSql, 1, 1) var budget1 int64 if err := row.Scan(&budget1); err != nil { tx.Rollback(ctx) return err } // Transfer part of the marketing budget of Album 2 to Album 1.
budget1 += transfer budget2 -= transfer const updateSql = "UPDATE albums " + "SET marketing_budget = $1 " + "WHERE singer_id = $2 and album_id = $3" // Start a DML batch and execute it as part of the current transaction.
batch := &pgx.Batch{} batch.Queue(updateSql, budget1, 1, 1) batch.Queue(updateSql, budget2, 2, 2) br := tx.SendBatch(ctx, batch) _, err = br.Exec() if err := br.Close(); err != nil { tx.Rollback(ctx) return err } } // Commit the current transaction.
tx.Commit(ctx) fmt.Println("Transferred marketing budget from Album 2 to Album 1")

return nil }

Node.js

import { Client } from 'pg';

async function writeWithTransactionUsingDml(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Transfer marketing budget from one album to another. We do it in a // transaction to ensure that the transfer is atomic. node-postgres // requires you to explicitly start the transaction by executing 'begin'.
await connection.query("begin");
const selectMarketingBudgetSql = "SELECT marketing_budget " + "from albums " + "WHERE singer_id = $1 and album_id = $2";
// Get the marketing_budget of singer 2 / album 2.
const album2BudgetResult = await connection.query(selectMarketingBudgetSql, [2, 2]);
let album2Budget = album2BudgetResult.rows[0]["marketing_budget"];
const transfer = 200000;
// The transaction will only be committed if this condition still holds // at the time of commit. Otherwise, the transaction will be aborted.
if (album2Budget >= transfer) { // Get the marketing budget of singer 1 / album 1.
const album1BudgetResult = await connection.query(selectMarketingBudgetSql, [1, 1]);
let album1Budget = album1BudgetResult.rows[0]["marketing_budget"];
// Transfer part of the marketing budget of Album 2 to Album 1.
album1Budget += transfer;
album2Budget -= transfer;
const updateSql = "UPDATE albums " + "SET marketing_budget = $1 " + "WHERE singer_id = $2 and album_id = $3";
// Start a DML batch. This batch will become part of the current transaction.
// TODO: Enable when https://github.com/googleapis/java-spanner/pull/3114 has been merged // await connection.query("start batch dml");
// Update the marketing budget of both albums.
await connection.query(updateSql, [album1Budget, 1, 1]);
await connection.query(updateSql, [album2Budget, 2, 2]);
// TODO: Enable when https://github.com/googleapis/java-spanner/pull/3114 has been merged // await connection.query("run batch");
} // Commit the current transaction.
await connection.query("commit");
console.log("Transferred marketing budget from Album 2 to Album 1");

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def update_data_with_transaction(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
# Set autocommit=False to use transactions.
# The first statement that is executed starts the transaction.
conn.autocommit = False with conn.cursor() as cur:
# Transfer marketing budget from one album to another.
# We do it in a transaction to ensure that the transfer is atomic.
# There is no need to explicitly start the transaction. The first
# statement on the connection will start a transaction when
# AutoCommit=false.
select_marketing_budget_sql = ("SELECT marketing_budget " "from albums " "WHERE singer_id = %s " "and album_id = %s")
# Get the marketing budget of Album #2.
cur.execute(select_marketing_budget_sql, (2, 2)) album2_budget = cur.fetchone()[0] transfer = 200000 if album2_budget > transfer:
# Get the marketing budget of Album #1.
cur.execute(select_marketing_budget_sql, (1, 1)) album1_budget = cur.fetchone()[0]
# Transfer the marketing budgets and write the update back
# to the database.
album1_budget += transfer album2_budget -= transfer update_sql = ("update albums " "set marketing_budget = %s " "where singer_id = %s " "and   album_id = %s")
# Use a pipeline to execute two DML statements in one batch.
with conn.pipeline():
cur.execute(update_sql, (album1_budget, 1, 1,)) cur.execute(update_sql, (album2_budget, 2, 2,)) else:
print("Insufficient budget to transfer")
# Commit the transaction.
conn.commit() print("Transferred marketing budget from Album 2 to Album 1")

C#

using Npgsql;
using System.Data;

namespace dotnet_snippets;

public static class TagsSample { public static void Tags(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Start a transaction with isolation level Serializable.
// Spanner only supports this isolation level. Trying to use a lower // isolation level (including the default isolation level READ COMMITTED), // will result in an error.
var transaction = connection.BeginTransaction(IsolationLevel.Serializable);

// Create a command that uses the current transaction.
using var cmd = connection.CreateCommand();
cmd.Transaction = transaction;

// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
cmd.CommandText = "set spanner.transaction_tag='example-tx-tag'";
cmd.ExecuteNonQuery();

// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
cmd.CommandText = "set spanner.statement_tag='query-marketing-budget'";
cmd.ExecuteNonQuery();

// Get the marketing_budget of Album (1,1).
cmd.CommandText = "select marketing_budget from albums where singer_id=$1 and album_id=$2";
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
var marketingBudget = (long?)cmd.ExecuteScalar();

// Reduce the marketing budget by 10% if it is more than 1,000.
if (marketingBudget > 1000L) { marketingBudget -= (long) (marketingBudget * 0.1);

// Set the statement tag to use for the update statement.
cmd.Parameters.Clear();
cmd.CommandText = "set spanner.statement_tag='reduce-marketing-budget'";
cmd.ExecuteNonQuery();

cmd.CommandText = "update albums set marketing_budget=$1 where singer_id=$2 AND album_id=$3";
cmd.Parameters.Add(new NpgsqlParameter { Value = marketingBudget });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.ExecuteNonQuery();
}

// Commit the current transaction.
transaction.Commit();
Console.WriteLine("Reduced marketing budget");
} }

PHP

function update_data_with_transaction(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Start a read/write transaction.
$connection->beginTransaction();
// Transfer marketing budget from one album to another.
// We do it in a transaction to ensure that the transfer is atomic.

// Create a prepared statement that we can use to execute the same // SQL string multiple times with different parameter values.
$select_marketing_budget_statement = $connection->prepare( "SELECT marketing_budget " ."from albums " ."WHERE singer_id = ? " ."and album_id = ?" );
// Get the marketing budget of Album #2.
$select_marketing_budget_statement->execute([2, 2]);
$album2_budget = $select_marketing_budget_statement->fetchAll()[0][0];
$select_marketing_budget_statement->closeCursor();

$transfer = 200000;
if ($album2_budget > $transfer) { // Get the marketing budget of Album #1.
$select_marketing_budget_statement->execute([1, 1]);
$album1_budget = $select_marketing_budget_statement->fetchAll()[0][0];
$select_marketing_budget_statement->closeCursor();
// Transfer the marketing budgets and write the update back // to the database.
$album1_budget += $transfer;
$album2_budget -= $transfer;
// PHP PDO also supports named query parameters.
$update_statement = $connection->prepare( "update albums " ."set marketing_budget = :budget " ."where singer_id = :singer_id " ."and   album_id = :album_id" );
// Start a DML batch. This batch will become part of the current transaction.
// $connection->exec("start batch dml");
// Update the marketing budget of both albums.
$update_statement->execute(["budget" => $album1_budget, "singer_id" => 1, "album_id" => 1]);
$update_statement->execute(["budget" => $album2_budget, "singer_id" => 2, "album_id" => 2]);
// $connection->exec("run batch");
} else { print("Insufficient budget to transfer\n");
} // Commit the transaction.
$connection->commit();
print("Transferred marketing budget from Album 2 to Album 1\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./update_data_with_transaction.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar writewithtransactionusingdml example-db

Go

go run sample_runner.go writewithtransactionusingdml example-db

Node.js

npm start writewithtransactionusingdml example-db

Python

python update_data_with_transaction.py example-db

C#

dotnet run writewithtransactionusingdml example-db

PHP

php update_data_with_transaction.php example-db

您应该会看到：

Transferred marketing budget from Album 2 to Album 1

事务标记和请求标记

使用事务标记和请求标记可排查 Spanner 中的事务和查询问题。您可以使用 SPANNER.TRANSACTION_TAG 和 SPANNER.STATEMENT_TAG 会话变量设置事务标记和请求标记。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql << SQL -- Start a transaction.
begin;
-- Set the TRANSACTION_TAG session variable to set a transaction tag -- for the current transaction. This can only be executed at the start -- of the transaction.
set spanner.transaction_TAG='example-tx-tag';

-- Set the STATEMENT_TAG session variable to set the request tag -- that should be included with the next SQL statement.
set spanner.statement_tag='query-marketing-budget';

select marketing_budget from albums where singer_id = 1 and album_id  = 1;

-- Reduce the marketing budget by 10% if it is more than 1,000.
-- Set a statement tag for the update statement.
set spanner.statement_tag='reduce-marketing-budget';

update albums set marketing_budget = marketing_budget - (marketing_budget * 0.1)::bigint where singer_id = 1 and album_id  = 1 and marketing_budget > 1000;

commit;
SQL

echo "Reduced marketing budget"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

class Tags {

static void tags(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Set AutoCommit=false to enable transactions.
connection.setAutoCommit(false);
// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
connection.createStatement().execute("set spanner.transaction_tag='example-tx-tag'");

// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
connection.createStatement().execute("set spanner.statement_tag='query-marketing-budget'");
long marketingBudget = 0L;
long singerId = 1L;
long albumId = 1L;
try (PreparedStatement statement = connection.prepareStatement( "select marketing_budget from albums where singer_id=? and album_id=?")) { statement.setLong(1, singerId);
statement.setLong(2, albumId);
try (ResultSet albumResultSet = statement.executeQuery()) { while (albumResultSet.next()) { marketingBudget = albumResultSet.getLong(1);
} } } // Reduce the marketing budget by 10% if it is more than 1,000.
final long maxMarketingBudget = 1000L;
final float reduction = 0.1f;
if (marketingBudget > maxMarketingBudget) { marketingBudget -= (long) (marketingBudget * reduction);
connection.createStatement().execute("set spanner.statement_tag='reduce-marketing-budget'");
try (PreparedStatement statement = connection.prepareStatement( "update albums set marketing_budget=? where singer_id=? AND album_id=?")) { int paramIndex = 0;
statement.setLong(++paramIndex, marketingBudget);
statement.setLong(++paramIndex, singerId);
statement.setLong(++paramIndex, albumId);
statement.executeUpdate();
} }

// Commit the current transaction.
connection.commit();
System.out.println("Reduced marketing budget");
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func Tags(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

tx, err := conn.Begin(ctx) if err != nil { return err }

// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
_, _ = tx.Exec(ctx, "set spanner.transaction_tag='example-tx-tag'")

// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
_, _ = tx.Exec(ctx, "set spanner.statement_tag='query-marketing-budget'")

row := tx.QueryRow(ctx, "select marketing_budget "+ "from albums "+ "where singer_id=$1 and album_id=$2", 1, 1) var budget int64 if err := row.Scan(&budget); err != nil { tx.Rollback(ctx) return err }

// Reduce the marketing budget by 10% if it is more than 1,000.
if budget > 1000 { budget = int64(float64(budget) - float64(budget)*0.1) _, _ = tx.Exec(ctx, "set spanner.statement_tag='reduce-marketing-budget'") if _, err := tx.Exec(ctx, "update albums set marketing_budget=$1 where singer_id=$2 AND album_id=$3", budget, 1, 1); err != nil { tx.Rollback(ctx) return err } } // Commit the current transaction.
tx.Commit(ctx) fmt.Println("Reduced marketing budget")

return nil }

Node.js

import { Client } from 'pg';

async function tags(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

await connection.query("begin");
// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
await connection.query("set spanner.transaction_tag='example-tx-tag'");
// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
await connection.query("set spanner.statement_tag='query-marketing-budget'");
const budgetResult = await connection.query( "select marketing_budget " + "from albums " + "where singer_id=$1 and album_id=$2", [1, 1]) let budget = budgetResult.rows[0]["marketing_budget"];
// Reduce the marketing budget by 10% if it is more than 1,000.
if (budget > 1000) { budget = budget - budget * 0.1;
await connection.query("set spanner.statement_tag='reduce-marketing-budget'");
await connection.query("update albums set marketing_budget=$1 " + "where singer_id=$2 AND album_id=$3", [budget, 1, 1]);
} // Commit the current transaction.
await connection.query("commit");
console.log("Reduced marketing budget");

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def tags(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
# Set autocommit=False to enable transactions.
conn.autocommit = False with conn.cursor() as cur:
# Set the TRANSACTION_TAG session variable to set a transaction tag
# for the current transaction.
cur.execute("set spanner.transaction_TAG='example-tx-tag'")

# Set the STATEMENT_TAG session variable to set the request tag
# that should be included with the next SQL statement.
cur.execute("set spanner.statement_tag='query-marketing-budget'")

singer_id = 1 album_id = 1 cur.execute("select marketing_budget " "from albums " "where singer_id = %s " "  and album_id  = %s", (singer_id, album_id,)) marketing_budget = cur.fetchone()[0]

# Reduce the marketing budget by 10% if it is more than 1,000.
max_marketing_budget = 1000 reduction = 0.1 if marketing_budget > max_marketing_budget:
# Make sure the marketing_budget remains an int.
marketing_budget -= int(marketing_budget * reduction)
# Set a statement tag for the update statement.
cur.execute( "set spanner.statement_tag='reduce-marketing-budget'") cur.execute("update albums set marketing_budget = %s " "where singer_id = %s " "  and album_id  = %s", (marketing_budget, singer_id, album_id,)) else:
print("Marketing budget already less than or equal to 1,000")
# Commit the transaction.
conn.commit() print("Reduced marketing budget")

C#

using Npgsql;
using System.Data;

namespace dotnet_snippets;

public static class TagsSample { public static void Tags(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Start a transaction with isolation level Serializable.
// Spanner only supports this isolation level. Trying to use a lower // isolation level (including the default isolation level READ COMMITTED), // will result in an error.
var transaction = connection.BeginTransaction(IsolationLevel.Serializable);

// Create a command that uses the current transaction.
using var cmd = connection.CreateCommand();
cmd.Transaction = transaction;

// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
cmd.CommandText = "set spanner.transaction_tag='example-tx-tag'";
cmd.ExecuteNonQuery();

// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
cmd.CommandText = "set spanner.statement_tag='query-marketing-budget'";
cmd.ExecuteNonQuery();

// Get the marketing_budget of Album (1,1).
cmd.CommandText = "select marketing_budget from albums where singer_id=$1 and album_id=$2";
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
var marketingBudget = (long?)cmd.ExecuteScalar();

// Reduce the marketing budget by 10% if it is more than 1,000.
if (marketingBudget > 1000L) { marketingBudget -= (long) (marketingBudget * 0.1);

// Set the statement tag to use for the update statement.
cmd.Parameters.Clear();
cmd.CommandText = "set spanner.statement_tag='reduce-marketing-budget'";
cmd.ExecuteNonQuery();

cmd.CommandText = "update albums set marketing_budget=$1 where singer_id=$2 AND album_id=$3";
cmd.Parameters.Add(new NpgsqlParameter { Value = marketingBudget });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.Parameters.Add(new NpgsqlParameter { Value = 1L });
cmd.ExecuteNonQuery();
}

// Commit the current transaction.
transaction.Commit();
Console.WriteLine("Reduced marketing budget");
} }

PHP

function tags(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Start a read/write transaction.
$connection->beginTransaction();

// Set the TRANSACTION_TAG session variable to set a transaction tag // for the current transaction.
$connection->exec("set spanner.transaction_TAG='example-tx-tag'");

// Set the STATEMENT_TAG session variable to set the request tag // that should be included with the next SQL statement.
$connection->exec("set spanner.statement_tag='query-marketing-budget'");

$singer_id = 1;
$album_id = 1;
$statement = $connection->prepare( "select marketing_budget " ."from albums " ."where singer_id = ? " ."  and album_id  = ?" );
$statement->execute([1, 1]);
$marketing_budget = $statement->fetchAll()[0][0];
$statement->closeCursor();

# Reduce the marketing budget by 10% if it is more than 1,000.
$max_marketing_budget = 1000;
$reduction = 0.1;
if ($marketing_budget > $max_marketing_budget) { // Make sure the marketing_budget remains an int.
$marketing_budget -= intval($marketing_budget * $reduction);
// Set a statement tag for the update statement.
$connection->exec("set spanner.statement_tag='reduce-marketing-budget'");
$update_statement = $connection->prepare( "update albums set marketing_budget = :budget " ."where singer_id = :singer_id " ."  and album_id  = :album_id" );
$update_statement->execute([ "budget" => $marketing_budget, "singer_id" => $singer_id, "album_id" => $album_id, ]);
} else { print("Marketing budget already less than or equal to 1,000\n");
} // Commit the transaction.
$connection->commit();
print("Reduced marketing budget\n");

$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./tags.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar tags example-db

Go

go run sample_runner.go tags example-db

Node.js

npm start tags example-db

Python

python tags.py example-db

C#

dotnet run tags example-db

PHP

php tags.php example-db

提示：如需查看可用于通过 PGAdapter 访问 Spanner 功能的完整命令列表，请参阅 PGAdapter 会话管理命令。

使用只读事务检索数据

假设您要在同一时间戳执行多个读取操作。只读事务会观察事务提交记录的一致前缀，以便应用始终获得一致的数据。

将连接设置为只读状态，或使用 SET TRANSACTION READ ONLY SQL 语句执行只读事务。
提示：PGAdapter 支持多个其他 SQL 语句，用于执行特定类型的事务和批处理，以及访问特定 Spanner 功能。如需查看支持的语句的完整列表，请参阅 PGAdapter 会话管理命令

下面演示了如何运行查询并在同一只读事务中执行读取操作：

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

psql << SQL -- Begin a transaction.
begin;
-- Change the current transaction to a read-only transaction.
-- This statement can only be executed at the start of a transaction.
set transaction read only;

-- The following two queries use the same read-only transaction.
select singer_id, album_id, album_title from albums order by singer_id, album_id;

select singer_id, album_id, album_title from albums order by album_title;

-- Read-only transactions must also be committed or rolled back to mark -- the end of the transaction. There is no semantic difference between -- rolling back or committing a read-only transaction.
commit;
SQL

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

class ReadOnlyTransaction { static void readOnlyTransaction(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Set AutoCommit=false to enable transactions.
connection.setAutoCommit(false);
// This SQL statement instructs the JDBC driver to use // a read-only transaction.
connection.createStatement().execute("set transaction read only");

try (ResultSet resultSet = connection .createStatement() .executeQuery( "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY singer_id, album_id")) { while (resultSet.next()) { System.out.printf( "%d %d %s\n", resultSet.getLong("singer_id"), resultSet.getLong("album_id"), resultSet.getString("album_title"));
} } try (ResultSet resultSet = connection .createStatement() .executeQuery( "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY album_title")) { while (resultSet.next()) { System.out.printf( "%d %d %s\n", resultSet.getLong("singer_id"), resultSet.getLong("album_id"), resultSet.getString("album_title"));
} } // End the read-only transaction by calling commit().
connection.commit();
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func ReadOnlyTransaction(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Start a read-only transaction by supplying additional transaction options.
tx, err := conn.BeginTx(ctx, pgx.TxOptions{AccessMode: pgx.ReadOnly})

albumsOrderedById, err := tx.Query(ctx, "SELECT singer_id, album_id, album_title FROM albums ORDER BY singer_id, album_id") defer albumsOrderedById.Close() if err != nil { return err } for albumsOrderedById.Next() { var singerId, albumId int64 var title string err = albumsOrderedById.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Printf("%v %v %v\n", singerId, albumId, title) }

albumsOrderedTitle, err := tx.Query(ctx, "SELECT singer_id, album_id, album_title FROM albums ORDER BY album_title") defer albumsOrderedTitle.Close() if err != nil { return err } for albumsOrderedTitle.Next() { var singerId, albumId int64 var title string err = albumsOrderedTitle.Scan(&singerId, &albumId, &title) if err != nil { return err } fmt.Printf("%v %v %v\n", singerId, albumId, title) }

// End the read-only transaction by calling Commit().
return tx.Commit(ctx) }

Node.js

import { Client } from 'pg';

async function readOnlyTransaction(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Start a transaction.
await connection.query("begin");
// This SQL statement instructs the PGAdapter to make it a read-only transaction.
await connection.query("set transaction read only");

const albumsOrderById = await connection.query( "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY singer_id, album_id");
for (const row of albumsOrderById.rows) { console.log(`${row["singer_id"]} ${row["album_id"]} ${row["album_title"]}`);
} const albumsOrderByTitle = await connection.query( "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY album_title");
for (const row of albumsOrderByTitle.rows) { console.log(`${row["singer_id"]} ${row["album_id"]} ${row["album_title"]}`);
} // End the read-only transaction by executing commit.
await connection.query("commit");

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def read_only_transaction(host: string, port: int, database: string):
with (psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn):
# Set autocommit=False to enable transactions.
conn.autocommit = False

with conn.cursor() as cur:
# Change the current transaction to a read-only transaction.
# This statement can only be executed at the start of a transaction.
cur.execute("set transaction read only")

# The following two queries use the same read-only transaction.
cur.execute("select singer_id, album_id, album_title " "from albums " "order by singer_id, album_id") for album in cur:
print(album)

cur.execute("select singer_id, album_id, album_title " "from albums " "order by album_title") for album in cur:
print(album)

# Read-only transactions must also be committed or rolled back to mark
# the end of the transaction. There is no semantic difference between
# rolling back or committing a read-only transaction.
conn.commit()

C#

using Npgsql;
using System.Data;

namespace dotnet_snippets;

public static class ReadOnlyTransactionSample { public static void ReadOnlyTransaction(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Start a read-only transaction.
// You must specify Serializable as the isolation level, as the npgsql driver // will otherwise automatically set the isolation level to read-committed.
var transaction = connection.BeginTransaction(IsolationLevel.Serializable);
using var cmd = connection.CreateCommand();
cmd.Transaction = transaction;
// This SQL statement instructs the npgsql driver to use // a read-only transaction.
cmd.CommandText = "set transaction read only";
cmd.ExecuteNonQuery();

cmd.CommandText = "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY singer_id, album_id";
using (var reader = cmd.ExecuteReader()) { while (reader.Read()) { Console.WriteLine($"{reader["singer_id"]} {reader["album_id"]} {reader["album_title"]}");
} } cmd.CommandText = "SELECT singer_id, album_id, album_title " + "FROM albums " + "ORDER BY album_title";
using (var reader = cmd.ExecuteReader()) { while (reader.Read()) { Console.WriteLine($"{reader["singer_id"]} {reader["album_id"]} {reader["album_title"]}");
} } // End the read-only transaction by calling commit().
transaction.Commit();
} }

PHP

function read_only_transaction(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Start a transaction.
$connection->beginTransaction();
// Change the current transaction to a read-only transaction.
// This statement can only be executed at the start of a transaction.
$connection->exec("set transaction read only");

// The following two queries use the same read-only transaction.
$statement = $connection->query( "select singer_id, album_id, album_title " ."from albums " ."order by singer_id, album_id" );
$rows = $statement->fetchAll();
foreach ($rows as $album) { printf("%s\t%s\t%s\n", $album["singer_id"], $album["album_id"], $album["album_title"]);
}

$statement = $connection->query( "select singer_id, album_id, album_title " ."from albums " ."order by album_title" );
$rows = $statement->fetchAll();
foreach ($rows as $album) { printf("%s\t%s\t%s\n", $album["singer_id"], $album["album_id"], $album["album_title"]);
}

# Read-only transactions must also be committed or rolled back to mark
# the end of the transaction. There is no semantic difference between
# rolling back or committing a read-only transaction.
$connection->commit();

$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./read_only_transaction.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar readonlytransaction example-db

Go

go run sample_runner.go readonlytransaction example-db

Node.js

npm start readonlytransaction example-db

Python

python read_only_transaction.py example-db

C#

dotnet run readonlytransaction example-db

PHP

php read_only_transaction.php example-db

您看到的输出结果应该类似于以下内容：

1 1 Total Junk 1 2 Go, Go, Go 2 1 Green 2 2 Forever Hold Your Peace 2 3 Terrified 2 2 Forever Hold Your Peace 1 2 Go, Go, Go 2 1 Green 2 3 Terrified 1 1 Total Junk

分区查询和 Data Boost

partitionQuery API 会将查询划分为较小部分（即分区），并使用多台机器并行提取这些分区。每个分区都由一个分区令牌标识。PartitionQuery API 的延迟时间比标准查询 API 更长，因为它仅适用于批量操作，例如导出或扫描整个数据库。

Data Boost 使您可以执行分析查询和数据导出操作，且对预配的 Spanner 实例上的现有工作负载几乎没有影响。
Data Boost 仅支持分区查询。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# 'set spanner.data_boost_enabled=true' enables Data Boost for
# all partitioned queries on this connection.

# 'run partitioned query' is a shortcut for partitioning the query
# that follows and executing each of the partitions that is returned
# by Spanner.

psql -c "set spanner.data_boost_enabled=true" \ -c "run partitioned query select singer_id, first_name, last_name from singers"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

class DataBoost { static void dataBoost(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // This enables Data Boost for all partitioned queries on this connection.
connection.createStatement().execute("set spanner.data_boost_enabled=true");

// Run a partitioned query. This query will use Data Boost.
try (ResultSet resultSet = connection .createStatement() .executeQuery( "run partitioned query " + "select singer_id, first_name, last_name " + "from singers")) { while (resultSet.next()) { System.out.printf( "%d %s %s\n", resultSet.getLong("singer_id"), resultSet.getString("first_name"), resultSet.getString("last_name"));
} } } } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func DataBoost(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// This enables Data Boost for all partitioned queries on this connection.
_, _ = conn.Exec(ctx, "set spanner.data_boost_enabled=true")

// Run a partitioned query. This query will use Data Boost.
rows, err := conn.Query(ctx, "run partitioned query select singer_id, first_name, last_name from singers") defer rows.Close() if err != nil { return err } for rows.Next() { var singerId int64 var firstName, lastName string err = rows.Scan(&singerId, &firstName, &lastName) if err != nil { return err } fmt.Printf("%v %v %v\n", singerId, firstName, lastName) }

return nil }

Node.js

import { Client } from 'pg';

async function dataBoost(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// This enables Data Boost for all partitioned queries on this connection.
await connection.query("set spanner.data_boost_enabled=true");

// Run a partitioned query. This query will use Data Boost.
const singers = await connection.query( "run partitioned query " + "select singer_id, first_name, last_name " + "from singers");
for (const row of singers.rows) { console.log(`${row["singer_id"]} ${row["first_name"]} ${row["last_name"]}`);
}

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def data_boost(host: string, port: int, database: string):
with (psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn):
# Set autocommit=True so each query uses a separate transaction.
conn.autocommit = True

with conn.cursor() as cur:
# This enables Data Boost for all partitioned queries on this
# connection.
cur.execute("set spanner.data_boost_enabled=true")

# Run a partitioned query. This query will use Data Boost.
cur.execute("run partitioned query " "select singer_id, first_name, last_name " "from singers") for singer in cur:
print(singer)

C#

using Npgsql;

namespace dotnet_snippets;

public static class DataBoostSample { public static void DataBoost(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

using var cmd = connection.CreateCommand();
// This enables Data Boost for all partitioned queries on this connection.
cmd.CommandText = "set spanner.data_boost_enabled=true";
cmd.ExecuteNonQuery();

// Run a partitioned query. This query will use Data Boost.
cmd.CommandText = "run partitioned query " + "select singer_id, first_name, last_name " + "from singers";
using var reader = cmd.ExecuteReader();
while (reader.Read()) { Console.WriteLine($"{reader["singer_id"]} {reader["first_name"]} {reader["last_name"]}");
} } }

PHP

function data_boost(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// This enables Data Boost for all partitioned queries on this // connection.
$connection->exec("set spanner.data_boost_enabled=true");

// Run a partitioned query. This query will use Data Boost.
$statement = $connection->query( "run partitioned query " ."select singer_id, first_name, last_name " ."from singers" );
$rows = $statement->fetchAll();
foreach ($rows as $singer) { printf("%s\t%s\t%s\n", $singer["singer_id"], $singer["first_name"], $singer["last_name"]);
}

$rows = null;
$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./data_boost.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar databoost example-db

Go

go run sample_runner.go databoost example-db

Node.js

npm start databoost example-db

Python

python data_boost.py example-db

C#

dotnet run databoost example-db

PHP

php data_boost.php example-db

如需详细了解如何运行分区查询以及如何将 Data Boost 与 PGAdapter 搭配使用，请参阅：Data Boost 和分区查询语句

分区 DML

分区数据操纵语言 (DML) 旨在用于以下类型的批量更新和删除：

定期清理和垃圾回收。

使用默认值回填新列。

psql

#!/bin/bash

export PGHOST="${PGHOST:-localhost}" export PGPORT="${PGPORT:-5432}" export PGDATABASE="${PGDATABASE:-example-db}"

# Change the DML mode that is used by this connection to Partitioned
# DML. Partitioned DML is designed for bulk updates and deletes.
# See https://cloud.google.com/spanner/docs/dml-partitioned for more
# information.
psql -c "set spanner.autocommit_dml_mode='partitioned_non_atomic'" \ -c "update albums set marketing_budget=0 where marketing_budget is null"

echo "Updated albums using Partitioned DML"

Java

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

class PartitionedDml {

static void partitionedDml(String host, int port, String database) throws SQLException { String connectionUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
try (Connection connection = DriverManager.getConnection(connectionUrl)) { // Enable Partitioned DML on this connection.
connection .createStatement() .execute("set spanner.autocommit_dml_mode='partitioned_non_atomic'");
// Back-fill a default value for the MarketingBudget column.
long lowerBoundUpdateCount = connection .createStatement() .executeUpdate("update albums set marketing_budget=0 where marketing_budget is null");
System.out.printf("Updated at least %d albums\n", lowerBoundUpdateCount);
} } }

Go

import (
"context" "fmt"

"github.com/jackc/pgx/v5" )

func PartitionedDML(host string, port int, database string) error { ctx := context.Background() connString := fmt.Sprintf( "postgres://uid:pwd@%s:%d/%s?sslmode=disable", host, port, database) conn, err := pgx.Connect(ctx, connString) if err != nil { return err } defer conn.Close(ctx)

// Enable Partitioned DML on this connection.
if _, err := conn.Exec(ctx, "set spanner.autocommit_dml_mode='partitioned_non_atomic'"); err != nil { return err } // Back-fill a default value for the MarketingBudget column.
tag, err := conn.Exec(ctx, "update albums set marketing_budget=0 where marketing_budget is null") if err != nil { return err } fmt.Printf("Updated at least %v albums\n", tag.RowsAffected())

return nil }

Node.js

import { Client } from 'pg';

async function partitionedDml(host: string, port: number, database: string): Promise { const connection = new Client({ host: host, port: port, database: database, });
await connection.connect();

// Enable Partitioned DML on this connection.
await connection.query("set spanner.autocommit_dml_mode='partitioned_non_atomic'");

// Back-fill a default value for the MarketingBudget column.
const lowerBoundUpdateCount = await connection.query( "update albums " + "set marketing_budget=0 " + "where marketing_budget is null");
console.log(`Updated at least ${lowerBoundUpdateCount.rowCount} albums`);

// Close the connection.
await connection.end();
}

Python

import string
import psycopg

def execute_partitioned_dml(host: string, port: int, database: string):
with psycopg.connect("host={host} port={port} dbname={database} " "sslmode=disable".format(host=host, port=port, database=database)) as conn:
conn.autocommit = True with conn.cursor() as cur:
# Change the DML mode that is used by this connection to Partitioned
# DML. Partitioned DML is designed for bulk updates and deletes.
# See https://cloud.google.com/spanner/docs/dml-partitioned for more
# information.
cur.execute( "set spanner.autocommit_dml_mode='partitioned_non_atomic'")

# The following statement will use Partitioned DML.
cur.execute("update albums " "set marketing_budget=0 " "where marketing_budget is null") print("Updated at least %d albums" % cur.rowcount)

C#

using Npgsql;

namespace dotnet_snippets;

public static class PartitionedDmlSample { public static void PartitionedDml(string host, int port, string database) { var connectionString = $"Host={host};Port={port};Database={database};SSL Mode=Disable";
using var connection = new NpgsqlConnection(connectionString);
connection.Open();

// Enable Partitioned DML on this connection.
using var cmd = connection.CreateCommand();
cmd.CommandText = "set spanner.autocommit_dml_mode='partitioned_non_atomic'";
cmd.ExecuteNonQuery();

// Back-fill a default value for the MarketingBudget column.
cmd.CommandText = "update albums set marketing_budget=0 where marketing_budget is null";
var lowerBoundUpdateCount = cmd.ExecuteNonQuery();

Console.WriteLine($"Updated at least {lowerBoundUpdateCount} albums");
} }

PHP

function execute_partitioned_dml(string $host, string $port, string $database): void { $dsn = sprintf("pgsql:host=%s;port=%s;dbname=%s", $host, $port, $database);
$connection = new PDO($dsn);

// Change the DML mode that is used by this connection to Partitioned // DML. Partitioned DML is designed for bulk updates and deletes.
// See https://cloud.google.com/spanner/docs/dml-partitioned for more // information.
$connection->exec("set spanner.autocommit_dml_mode='partitioned_non_atomic'");

// The following statement will use Partitioned DML.
$rowcount = $connection->exec( "update albums " ."set marketing_budget=0 " ."where marketing_budget is null" );
printf("Updated at least %d albums\n", $rowcount);

$statement = null;
$connection = null;
}

使用以下命令运行示例：

psql

PGDATABASE=example-db ./partitioned_dml.sh

Java

java -jar target/pgadapter-snippets/pgadapter-samples.jar partitioneddml example-db

Go

go run sample_runner.go partitioneddml example-db

Node.js

npm start partitioneddml example-db

Python

python partitioned_dml.py example-db

C#

dotnet run datpartitioneddmlboost example-db

PHP

php partitioned_dml.php example-db

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
