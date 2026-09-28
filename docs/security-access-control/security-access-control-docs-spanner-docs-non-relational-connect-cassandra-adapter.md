# 使用 Cassandra 适配器连接到 Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/non-relational/connect-cassandra-adapter

使用 Cassandra 适配器连接到 Spanner  |  Google Cloud Documentation

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

使用 Cassandra 适配器连接到 Spanner

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页介绍了 Cassandra 适配器，并说明了如何使用 Spanner，以及如何通过 Cassandra 适配器来连接 Spanner。

Cassandra 适配器设计为与您的应用在同一台机器上运行。该适配器会在 localhost 上公开支持 Cassandra 查询语言 (CQL) 传输协议的端点。它会将 CQL 传输协议转换为 gRPC，即 Spanner 传输协议。在本地运行此代理后，Cassandra 客户端可以连接到 Spanner 数据库。

您可以通过以下方式启动 Cassandra 适配器：

与 Go 应用一起启动

与 Java 应用一起启动

作为独立进程

在Docker容器中

准备工作

在启动 Cassandra 适配器之前，请确保您已在将运行 Cassandra 适配器的机器上使用用户账号或服务账号进行身份验证。如果您使用的是服务账号，则必须知道 JSON 密钥文件（凭证文件）的位置。您可以设置 GOOGLE_APPLICATION_CREDENTIALS 环境变量来指定凭证路径。
在启动 Cassandra 适配器之前，请确保您已在将运行 Cassandra 适配器的机器上使用用户账号或服务账号进行身份验证。如果您使用的是服务账号，则必须知道 JSON 密钥文件（凭证文件）的位置。您可以设置 GOOGLE_APPLICATION_CREDENTIALS 环境变量来指定凭证路径。

有关详情，请参阅：

向 Spanner 进行身份验证

向 gcloud CLI 授权

将 Cassandra 适配器连接到您的应用

Cassandra 适配器需要以下信息：

项目名称

Spanner 实例名称

要连接到的数据库

如果您使用的是 Docker，则需要 JSON 格式的凭证文件（密钥文件）的路径。

Java 进程中

如果您使用的是服务账号进行身份验证，请确保 GOOGLE_APPLICATION_CREDENTIALS 环境变量设置为凭证文件的路径。

对于 Java 应用，您可以将 google-cloud-spanner-cassandra 作为依赖项添加到项目中，从而将 Cassandra 适配器直接关联到应用。

对于 Maven，请在  部分下添加以下新依赖项：

com.google.cloud google-cloud-spanner-cassandra
1.1.0

对于 Gradle，请添加以下内容：

dependencies { implementation 'com.google.cloud:google-cloud-spanner-cassandra:1.1.0' }

修改 CqlSession 创建代码。请使用 SpannerCqlSessionBuilder 并提供 Spanner 数据库 URI，而不是使用 CqlSessionBuilder：

import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.config.DefaultDriverOption;
import com.datastax.oss.driver.api.core.config.DriverConfigLoader;
import com.datastax.oss.driver.api.core.cql.ResultSet;
import com.datastax.oss.driver.api.core.cql.Row;
import com.google.cloud.spanner.adapter.SpannerCqlSession;
import java.net.InetSocketAddress;
import java.time.Duration;
import java.util.Random;

// This sample assumes your spanner database  contains a table // with the following schema:

// CREATE TABLE users ( //  id        INT64          OPTIONS (cassandra_type = 'int'), //  active    BOOL           OPTIONS (cassandra_type = 'boolean'), //  username  STRING(MAX)    OPTIONS (cassandra_type = 'text'), // ) PRIMARY KEY (id);

class QuickStartSample {

public static void main(String[] args) {

// TODO(developer): Replace these variables before running the sample.
final String projectId = "my-gcp-project";
final String instanceId = "my-spanner-instance";
final String databaseId = "my_db";

final String databaseUri = String.format("projects/%s/instances/%s/databases/%s", projectId, instanceId, databaseId);

try (CqlSession session = SpannerCqlSession.builder() // `SpannerCqlSession` instead of `CqlSession` .setDatabaseUri(databaseUri) // Set spanner database URI.
.addContactPoint(new InetSocketAddress("localhost", 9042)) .withLocalDatacenter("datacenter1") .withKeyspace(databaseId) // Keyspace name should be the same as spanner database name .withConfigLoader( DriverConfigLoader.programmaticBuilder() .withString(DefaultDriverOption.PROTOCOL_VERSION, "V4") .withDuration( DefaultDriverOption.CONNECTION_INIT_QUERY_TIMEOUT, Duration.ofSeconds(5)) .build()) .build()) {

final int randomUserId = new Random().nextInt(Integer.MAX_VALUE);

System.out.printf("Inserting user with ID: %d%n", randomUserId);

// INSERT data session.execute( "INSERT INTO users (id, active, username) VALUES (?, ?, ?)", randomUserId, true, "John Doe");

System.out.printf("Successfully inserted user: %d%n", randomUserId);
System.out.printf("Querying user: %d%n", randomUserId);

// SELECT data ResultSet rs = session.execute("SELECT id, active, username FROM users WHERE id = ?", randomUserId);

// Get the first row from the result set Row row = rs.one();

System.out.printf( "%d %b %s%n", row.getInt("id"), row.getBoolean("active"), row.getString("username"));

} catch (Exception e) { e.printStackTrace();
} } }

Go 进程中 对于 Go 应用，您只需对集群初始化文件进行一行更改，即可集成 Spanner Cassandra Go 客户端。然后，您可以将 Cassandra 适配器直接关联到应用。

在 Go 应用中从 Spanner Cassandra Go 客户端导入适配器的 spanner 软件包。

import spanner "github.com/googleapis/go-spanner-cassandra/cassandra/gocql"

将集群创建代码修改为使用 spanner.NewCluster（而非 gocql.NewCluster），并提供 Spanner 数据库 URI：

import (
"fmt" "io" "math" "math/rand/v2" "time"

spanner "github.com/googleapis/go-spanner-cassandra/cassandra/gocql" )

// This sample assumes your spanner database  contains a table // with the following schema:
// // CREATE TABLE users ( //	id   	 	INT64          OPTIONS (cassandra_type = 'int'), //	active    	BOOL           OPTIONS (cassandra_type = 'boolean'), //	username  	STRING(MAX)    OPTIONS (cassandra_type = 'text'), // ) PRIMARY KEY (id);

func quickStart(databaseURI string, w io.Writer) error { opts := &spanner.Options{ DatabaseUri: databaseURI, } cluster := spanner.NewCluster(opts) if cluster == nil { return fmt.Errorf("failed to create cluster") } defer spanner.CloseCluster(cluster)

// You can still configure your cluster as usual after connecting to your // spanner database cluster.Timeout = 5 * time.Second cluster.Keyspace = "your_db_name"

session, err := cluster.CreateSession()

if err != nil { return err }

randomUserId := rand.IntN(math.MaxInt32) if err = session.Query("INSERT INTO users (id, active, username) VALUES (?, ?, ?)", randomUserId, true, "John Doe").
Exec(); err != nil { return err }

var id int var active bool var username string if err = session.Query("SELECT id, active, username FROM users WHERE id = ?", randomUserId).
Scan(&id, &active, &username); err != nil { return err } fmt.Fprintf(w, "%d %v %s\n", id, active, username) return nil }

连接到 Spanner 数据库后，您可以照常配置集群。

独立

克隆代码库：

git clone https://github.com/googleapis/go-spanner-cassandra.git cd go-spanner-cassandra

使用必需的 -db 标志运行 cassandra_launcher.go：

go run cassandra_launcher.go \ -db "projects/my_project/instances/my_instance/databases/my_database"

将 -db 替换为您的 Spanner 数据库 URI。

Docker 使用以下命令启动 Cassandra 适配器。

export GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json docker run -d -p 9042:9042 \ -e GOOGLE_APPLICATION_CREDENTIALS \ -v ${GOOGLE_APPLICATION_CREDENTIALS}:${GOOGLE_APPLICATION_CREDENTIALS}:ro \ gcr.io/cloud-spanner-adapter/cassandra-adapter \ -db DATABASE_URI

以下列表包含 Spanner Cassandra 适配器最常用的启动选项：

-db

Spanner 数据库 URI（必需）。此选项指定客户端连接到的 Spanner 数据库。例如 projects/YOUR_PROJECT/instances/YOUR_INSTANCE/databases/YOUR_DATABASE。

-tcp

客户端代理监听器地址。此选项定义客户端监听传入 Cassandra 客户端连接的 TCP 端点。默认：localhost:9042

-grpc-channels

连接到 Spanner 时要使用的 gRPC 通道数。默认值：4

例如，以下命令使用应用凭证在端口 9042 上启动 Cassandra 适配器，并将适配器连接到 projects/my_project/instances/my_instance/databases/my_database 数据库：

export GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json docker run -d -p 9042:9042 \ -e GOOGLE_APPLICATION_CREDENTIALS \ -v ${GOOGLE_APPLICATION_CREDENTIALS}:${GOOGLE_APPLICATION_CREDENTIALS}:ro \ gcr.io/cloud-spanner-adapter/cassandra-adapter \ -db projects/my_project/instances/my_instance/databases/my_database

建议

以下建议有助于您改善 Cassandra 适配器的使用体验。这些建议主要针对 Java，尤其是 Java 版本 4 Cassandra 客户端驱动程序。

增加请求超时时间

与默认值 2 秒相比，请求超时时间为 5 秒或更长时间可提供更好的 Cassandra 适配器体验。

# Sample application.conf: increases request timeout to five seconds
datastax-java-driver { basic { request { timeout = 5 seconds } } }

调整连接池

默认的连接数上限和每个连接或主机的并发请求数上限配置适用于开发环境、测试环境，以及低数据量生产环境或预演环境。不过，我们建议您增加这些值，因为 Cassandra 适配器会伪装成单个节点，而非 Cassandra 集群中的节点池。

增加这些值可在客户端和 Cassandra 接口之间实现更多并发连接。这样可以防止在高负载下耗尽连接池。

# Sample application.conf: increases maximum number of requests that can be
# executed concurrently on a connection
advanced.connection { max-requests-per-connection = 32000 pool { local.size = 10 } }

调整 gRPC 通道

Spanner 客户端使用 gRPC 通道进行通信。一个 gRPC 通道大致相当于一条 TCP 连接。一个 gRPC 通道最多可处理 100 个并发请求。这意味着，应用需要的 gRPC 通道数至少应等于应用将执行的并发请求数除以 100 的值。

停用令牌感知路由

使用令牌感知型负载均衡的驱动程序在使用 Cassandra 适配器时可能会输出警告，也可能无法正常运行。由于 Cassandra 适配器伪装成单节点，因此 Cassandra 适配器并不总是能很好地与令牌感知型驱动程序搭配使用，因为令牌感知驱动程序要求集群中至少有复制因子数量的节点。有些驱动程序可能会输出警告（可忽略），并回退到类似轮循均衡政策的功能，而有些驱动程序可能会失败并显示错误。对于失败并显示错误的驱动程序，您必须停用令牌感知或配置轮循负载均衡政策。

# Sample application.conf: disables token-aware routing
metadata { token-map { enabled = false } }

将协议版本固定为 V4

Cassandra 适配器与任何符合CQL Binary v4 传输协议的开源 Apache Cassandra 客户端驱动程序兼容。请务必将 PROTOCOL_VERSION 固定为 V4，否则您可能会看到连接错误。

# Sample application.conf: overrides protocol version to V4
datastax-java-driver { advanced.protocol.version = V4 }

后续步骤

如需详细了解 Java 版 Spanner Cassandra 适配器，请参阅 java-spanner-cassandra GitHub 仓库。

如需详细了解 Go 版 Spanner Cassandra 适配器，请参阅 go-spanner-cassandra GitHub 仓库。

查看 Cassandra 和 Spanner 概念和架构的比较。

了解如何从 Cassandra 迁移到 Spanner。

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
