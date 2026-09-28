# 启动 PGAdapter  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/pgadapter-start

启动 PGAdapter  |  Spanner  |  Google Cloud Documentation

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

启动 PGAdapter

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何在 Spanner 中启动 PGAdapter。如需了解 PGAdapter，请参阅关于 PGAdapter。如需获取 PGAdapter 二进制文件，请参阅获取 PGAdapter。

您可以通过以下方式启动 PGAdapter：

作为独立进程

在 Docker 容器内

在 Cloud Run 上

将 PGAdapter 用作边车代理（例如，在 Kubernetes 集群中）

与 Java 应用一起启动

准备工作

在启动 PGAdapter 之前，请确保您已在运行 PGAdapter 的机器上通过用户账号或服务账号进行了身份验证。如果您使用的是服务账号，则必须知道 JSON 密钥文件（凭证文件）的位置。然后，您可以使用 PGAdapter -c 选项或通过设置 GOOGLE_APPLICATION_CREDENTIALS 环境变量来指定凭证路径。

有关详情，请参阅：

向 Spanner 进行身份验证

向 gcloud CLI 授权

选择运行 PGAdapter 的方法

您可以将 PGAdapter 作为独立进程启动、在 Docker 容器内启动、在 Cloud Run 上启动，或者是在 Java 应用的进程内启动。启动 PGAdapter 时，您需要指定要连接到的项目、Spanner 实例、ID 和数据库。您还可以指定 JSON 格式的凭证文件（密钥文件）的路径。

独立

使用以下命令下载 PGAdapter。

wget https://storage.googleapis.com/pgadapter-jar-releases/pgadapter.tar.gz \ && tar -xzvf pgadapter.tar.gz

使用以下命令启动 PGAdapter。

java -jar pgadapter.jar -p PROJECT_ID -i INSTANCE_ID -d DATABASE_ID \ -c CREDENTIALS_FILE_PATH \ ADDITIONAL_OPTIONS

以下选项为必需：

-p project_id

Spanner 数据库在其中运行的项目的 ID。

-i instance_id

Spanner 实例 ID。

-d database_ID

要连接到的 Spanner 数据库的 ID。

以下选项为可选：

-r databaseRole=database_role

要用于会话的数据库角色。
如需了解详情，请参阅使用 PGAdapter 进行授权。

-c credentials_file_path

包含 JSON 格式的服务账号凭证的密钥文件完整路径。如果未设置此选项，则系统会从 GOOGLE_APPLICATION_CREDENTIALS 环境变量指定的路径中读取凭证。
如需了解如何创建服务账号并下载 JSON 格式的密钥文件，请参阅 创建服务账号。

请确保您向服务账号授予足够的凭证，以允许其访问数据库。

如果您先使用以下命令通过 Google Cloud CLI 进行身份验证，则可以省略此选项：

gcloud auth application-default login

如需了解详情，请参阅 设置身份验证和授权。

-s port

PGAdapter 侦听的端口。默认为 5432（即默认的 PostgreSQL 端口）。

-v version_number

要在连接过程中公开给客户端的 PostgreSQL 的版本号。默认值为 14.1。

某些 PostgreSQL 应用和驱动程序会根据此版本号启用额外的功能。Spanner 可能并不支持这些功能。
如需查看支持的客户端的完整列表，请参阅 驱动程序和客户端。

-x

启用 localhost 以外的主机发起的连接。在独立模式下启动 PGAdapter 时，请勿使用此项。只有在 Docker 容器内启动时才能使用。

默认情况下，出于安全考虑，PGAdapter 仅接受 localhost 发起的连接。

以下示例使用默认应用凭证在端口 5432 上以独立模式启动 PGAdapter。

java -jar pgadapter.jar \ -p my-project \ -i my-instance \ -d my-database \ -s 5432

Docker

使用以下命令启动 PGAdapter。

docker run -d -p HOST-PORT:DOCKER-PORT \ -v CREDENTIALS_FILE_PATH:/acct_credentials.json \ gcr.io/cloud-spanner-pg-adapter/pgadapter:latest \ -p PROJECT_ID -i INSTANCE_ID -d DATABASE_ID  \ -c /acct_credentials.json -x OTHER_PGAdapter_OPTIONS

除了用于指定项目、实例、数据库和凭证的 PGAdapter 选项之外，还需要使用以下选项：

-p
127.0.0.1:HOST-PORT:DOCKER-PORT

此 Docker 选项会将 Docker 容器内部的端口 DOCKER-PORT 映射到容器外部的端口 HOST-PORT。DOCKER-PORT 必须与 PGAdapter 在容器内部的配置方式相匹配。默认值为 5432。HOST-PORT 是 Docker 应在容器外部监听连接请求的端口。它必须始终是 localhost 上的可用端口。

如需了解详情，请参阅 Docker 文档中的发布或公开端口（-p、--expos）。

-v CREDENTIALS_FILE_PATH:in_container_mount_point

此 Docker 选项绑定会装载一个共享卷。它将容器外部的主机路径映射到容器内的一个卷（装载点）。主机路径和容器路径之间使用英文冒号 (:) 分隔。

通过此选项，PGAdapter 可以访问容器之外的 JSON 凭证文件。在前面的示例中，-c 选项引用容器内的装载点。此示例将容器内装载点命名为 /acct_credentials.json。您可以随意为其命名。

如需了解详情，请参阅 Docker 文档中的卷（共享文件系统）。

-x

启用 localhost 以外的主机发起的连接。之所以需要这样做，是因为映射到主机端口的容器内部端口不会对 PGAdapter 显示为 localhost。

以下选项为可选：

-r databaseRole=database_role

要用于会话的数据库角色。
如需了解详情，请参阅使用 PGAdapter 进行授权。

在以下示例中，Docker 端口和主机端口均设置为 PostgreSQL 数据库服务默认端口 5432。

docker run -d -p 127.0.0.1:5432:5432 \ -v /tmp/credentials.json:/acct_credentials.json \ gcr.io/cloud-spanner-pg-adapter/pgadapter:latest \ -p my_project -i my_instance -d my_database \ -c /acct_credentials.json -x

Cloud Run

您无法在 Cloud Run 上将 PGAdapter 部署为独立服务，但可以将其部署为边车代理。

与将 PGAdapter 作为单独的服务运行相比，我们建议以边车模式运行它，原因如下：

防止出现单点故障；每个应用对您的数据库的访问都独立于其他应用，从而提高其弹性。

PGAdapter 实例的数量会随着应用实例的数量自动线性扩缩。

PGAdapter GitHub 代码库包含多个 使用 Cloud Run 和 PGAdapter 作为边车代理的有效示例应用，这些应用采用各种编程语言。

以下配置文件展示了如何将 PGAdapter 添加为 Cloud Run 的边车代理：

apiVersion: serving.knative.dev/v1 kind: Service metadata:
annotations:
# This example uses an in-memory volume for Unix domain sockets.
# This is a Cloud Run beta feature.
run.googleapis.com/launch-stage: BETA name: pgadapter-sidecar-example spec:
template:
metadata:
annotations:
run.googleapis.com/execution-environment: gen1
# This registers 'pgadapter' as a dependency of 'app' and ensures that pgadapter starts
# before the app container.
run.googleapis.com/container-dependencies: '{"app":["pgadapter"]}' spec:
# Create an in-memory volume that can be used for Unix domain sockets.
volumes:
  - name: sockets-dir
emptyDir:
# This directory contains the virtual socket files that are used to
# communicate between your application and PGAdapter.
sizeLimit: 50Mi medium: Memory containers:
# This is the main application container.
  - name: app
# Example: europe-north1-docker.pkg.dev/my-test-project/cloud-run-source-deploy/pgadapter-sidecar-example
image: MY-REGION.pkg.dev/MY-PROJECT/cloud-run-source-deploy/pgadapter-sidecar-example
# The PGADAPTER_HOST variable is set to point to /sockets, which is the shared in-memory
# volume that is used for Unix domain sockets.
env:
  - name: SPANNER_PROJECT
value: my-project
  - name: SPANNER_INSTANCE
value: my-instance
  - name: SPANNER_DATABASE
value: my-database
  - name: PGADAPTER_HOST
value: /sockets
  - name: PGADAPTER_PORT
value: "5432" ports:
  - containerPort: 8080
volumeMounts:
  - mountPath: /sockets
name: sockets-dir
# This is the PGAdapter sidecar container.
  - name: pgadapter
image: gcr.io/cloud-spanner-pg-adapter/pgadapter volumeMounts:
  - mountPath: /sockets
name: sockets-dir args:
  - -dir /sockets
  - -x
# Add a startup probe that checks that PGAdapter is listening on port 5432.
startupProbe:
initialDelaySeconds: 10 timeoutSeconds: 10 periodSeconds: 10 failureThreshold: 3 tcpSocket:
port: 5432

边车代理

您可以在 Kubernetes 集群等环境中将 PGAdapter 用作边车代理。Kubernetes 边车容器与 Pod 中的主容器并行运行。

与将 PGAdapter 作为单独的服务运行相比，我们建议以边车模式运行它，原因如下：

防止出现单点故障；每个应用对您的数据库的访问都独立于其他应用，从而提高其弹性。

由于 PGAdapter 会根据用量以线性方式使用资源，因此此模式可让您更准确地确定资源范围，并按应用扩缩情况请求资源。

以下配置文件展示了如何将 PGAdapter 添加为 Kubernetes 集群的边车代理：

containers:
- name: pgadapter
image: gcr.io/cloud-spanner-pg-adapter/pgadapter ports:
  - containerPort: 5432
args:
  - "-p my-project"
  - "-i my-instance"
  - "-d my-database"
  - "-x"
resources:
requests:
# PGAdapter's memory use scales linearly with the number of active
# connections. Fewer open connections will use less memory. Adjust
# this value based on your application's requirements.
memory: "512Mi"
# PGAdapter's CPU use scales linearly with the amount of IO between
# the database and the application. Adjust this value based on your
# application's requirements.
cpu: "1"

PGAdapter GitHub 代码库包含分步指南和示例应用。
此示例包含有关将 Workload Identity Federation for GKE 与 PGAdapter 搭配使用的说明。

Java 进程中

使用您的 Java 代码创建并启动 PGAdapter 实例。
这是建议用于 Java 应用的设置。

如果您使用的是服务账号进行身份验证，请确保 GOOGLE_APPLICATION_CREDENTIALS 环境变量设置为凭证文件的路径。

将 google-cloud-spanner-pgadapter 作为依赖项添加到您的项目中。
如需了解详情，请参阅获取 PGAdapter。

使用 com.google.cloud.spanner.pgadapter.ProxyServer 类构建一个服务器。

/**
* Starts PGAdapter in-process and returns a reference to the server. Use this reference to
* gracefully shut down the server when your application shuts down.
*
* @param project the Google Cloud project that PGAdapter should connect to
* @param instance the Spanner instance that PGAdapter should connect to
* @param credentialsFile the full path of a credentials file that PGAdapter should use, or
*     null if PGAdapter should use the application default credentials
*/ static Server startPGAdapter(String project, String instance, String credentialsFile) { OptionsMetadata.Builder builder = OptionsMetadata.newBuilder() .setProject(project) .setInstance(instance) // Start PGAdapter on any available port.
.setPort(0);
if (credentialsFile != null) { builder.setCredentialsFile(credentialsFile);
} ProxyServer server = new ProxyServer(builder.build());
server.startServer();
server.awaitRunning();

return new PGAdapter(server);
}

PGAdapter GitHub 代码库包含一个完整的示例应用。

PGAdapter 边车代理的资源分配指南

以下准则可帮助您为 PGAdapter 边车代理配置 CPU 和内存资源。最佳值因具体工作负载而异。

内存

由于 PGAdapter 不会缓存太多数据，因此需要内存来将查询结果从 Spanner gRPC 格式转换为 PostgreSQL 有线协议格式。对于具有大型二进制列的工作负载，这一点尤其重要，因为 Spanner 和 PostgreSQL 处理这些数据类型的方式不同。

如需确定要分配的内存量，请使用以下内存分配公式，其中 number of concurrent connections 是应用处理的并发连接数：

384 MB + (2 MB * number of concurrent connections)

例如，如果您的应用处理 200 个并发连接，请分配大约 784 MB 的内存：

384 MB + (2 MB * 200) = 784 MB

从这个基准内存分配开始。在实际负载下监控其使用情况，以根据您的具体需求微调该值。

CPU

PGAdapter 不会占用大量 CPU。这是因为其主要作用是充当直通代理。不过，CPU 使用率会随着发送和接收的数据量而增加。

分配 CPU 时，请考虑以下因素：

工作负载：执行返回大量数据的查询的应用，与仅返回少量行和列的应用相比，每个连接需要更多的 CPU 功率。

应用访问模式：如果应用以同步方式访问 Spanner，则在等待来自代理的数据时处于空闲状态。在这种情况下，应用和代理不太可能争用 CPU 资源。

从基准 CPU 分配开始。在实际负载下监控其使用情况，以便根据您的具体需求微调该值。

后续步骤

将 psql 连接到 PostgreSQL 数据库

将 JDBC 连接到 PostgreSQL 数据库

将 pgx 连接到 PostgreSQL 数据库

将 psycopg2 连接到 PostgreSQL 数据库

将 psycopg3 连接到 PostgreSQL 数据库

将 node-postgres 连接到 PostgreSQL 数据库

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-05-15。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-05-15。"],[],[]]

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
