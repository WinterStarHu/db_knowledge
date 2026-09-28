# 使用 Google Cloud 控制台创建和查询数据库  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-query-database-console?hl=zh-cn

使用 Google Cloud 控制台创建和查询数据库  |  Spanner  |  Google Cloud Documentation

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

使用 Google Cloud 控制台创建和查询数据库

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本快速入门介绍如何使用 Google Cloud 控制台在 Spanner 中执行基本操作。在快速入门中，您将执行以下操作：

创建 Spanner 实例。

创建数据库。

创建架构。

插入和修改数据。

运行查询。

如需了解使用 Spanner 的费用，请参阅价格。
注意：如需使用 90 天免费试用实例探索 Spanner，请参阅创建 Spanner 免费试用实例。

准备工作

Sign in to your Google Cloud account. If you're new to Google Cloud, create an account to evaluate how our products perform in real-world scenarios. New customers also get $300 in free credits to run, test, and deploy workloads.

In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Go to project selector

Verify that billing is enabled for your Google Cloud project.

In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Roles required to select or create a project

Select a project: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

Create a project: To create a project, you need the Project Creator role (roles/resourcemanager.projectCreator), which contains the resourcemanager.projects.create permission. Learn how to grant roles.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.

Go to project selector

Verify that billing is enabled for your Google Cloud project.

可选：Spanner API 应自动启用。如果未启用，请手动启用：

启用 Spanner API

如需获得创建实例和数据库所需的权限，请让您的管理员为您授予项目的

Cloud Spanner Admin (roles/spanner.admin) IAM 角色。

创建实例

首次使用 Spanner 时，您必须创建一个实例，用于分配 Spanner 数据库在该实例中使用的资源。

在 Google Cloud 控制台中，前往 Spanner 页面。

转到 Spanner

选择或创建 Google Cloud 项目（如果尚未创建）。

在 Spanner 页面上，点击创建预配实例。

如果您之前使用过 Spanner，则会看到 Spanner 实例页面，而不是产品页面。点击创建实例。

在为实例命名页面中，输入实例名称，例如 Test Instance。

系统会根据实例名称自动输入实例 ID，例如 test-instance。如有需要，请更改此设置。点击继续。

在配置实例页面中，保留默认选项区域级，然后从下拉菜单中选择配置。

您的实例配置决定了您的实例会存储和复制到什么地理位置。

点击继续。

在分配计算容量页面中，选择处理单元 (PU)，并保留默认值（1000 个处理单元）。

点击创建。

Google Cloud 控制台将显示您创建的实例的概览页面。

创建数据库

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

点击您创建的实例，例如 Test Instance。

在打开的实例“概览”页面中，点击创建数据库。

对于数据库名称，请输入一个名称，例如 example-db。

选择数据库方言。

如需了解 PostgreSQL 的支持以及如何选择方言，请参阅 PostgreSQL 接口。
如果您选择了 GoogleSQL，则会在本快速入门的下一部分的定义架构文本字段中定义架构。

数据库创建页面现在如下所示：

点击创建。

Google Cloud 控制台将显示您创建的数据库的概览页面。

创建数据库的架构 注意：Spanner Studio（在 Google Cloud 控制台中以前称为查询）支持在单个编辑器中执行 SQL、DML 和 DDL 操作。如需了解详情，请参阅使用 Google Cloud 控制台管理您的数据

在导航菜单中，点击 Spanner Studio。

在 Spanner Studio 页面上，点击 add 新标签页或使用空白编辑器标签页。

请输入：

GoogleSQL

CREATE TABLE Singers ( SingerId   INT64 NOT NULL, FirstName  STRING(1024), LastName   STRING(1024), SingerInfo BYTES(MAX), BirthDate  DATE ) PRIMARY KEY(SingerId);

PostgreSQL

CREATE TABLE Singers ( BirthDate  TIMESTAMPTZ, SingerId   BIGINT PRIMARY KEY, FirstName  VARCHAR(1024), LastName   VARCHAR(1024), SingerInfo BYTEA );

点击 play_circle 运行。

Google Cloud 控制台会返回数据库的概览页面，并且显示架构更新正在进行中。更新完成后，页面如下所示：

GoogleSQL

PostgreSQL

请注意，PostgreSQL 会将表名称转换为小写。

插入和修改数据

Google Cloud 控制台提供了一个用于插入、修改和删除数据的界面。

插入数据

在数据库概览页面上的表列表中，点击“Singers”表。

Google Cloud 控制台会显示 Singers 表的架构页面。

在导航菜单中，点击数据以显示 Singers 表的数据页面。

点击插入。

Google Cloud 控制台会显示 Singers 表的 Spanner Studio 页面，其中包含一个新的查询标签页，该标签页包含您修改的 INSERT 语句，以便在 Singers 表中插入一行并查看该插入操作的结果：

GoogleSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO Singers (SingerId, FirstName, LastName, SingerInfo, BirthDate) VALUES (, -- type: INT64 , -- type: STRING(1024) , -- type: STRING(1024) , -- type: BYTES(MAX) -- type: DATE ) THEN RETURN SingerId, FirstName, LastName, SingerInfo, BirthDate;

PostgreSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO singers (singerid, firstname, lastname, singerinfo, birthdate) VALUES (, -- type: bigint , -- type: character varying , -- type: character varying , -- type: bytea -- type: timestamp with time zone );
THEN RETURN singerid, firstname, lastname, singerinfo, birthdate;

请注意，PostgreSQL 会将列名称转换为全部小写。

修改 INSERT 语句的 VALUES 子句。

GoogleSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO Singers (SingerId, BirthDate, FirstName, LastName, SingerInfo) VALUES (1, -- type: INT64 NULL, -- type: DATE 'Marc', -- type: STRING(1024) 'Richards', -- type: STRING(1024) NULL -- type: BYTES(MAX) ) THEN RETURN SingerId, FirstName, LastName, SingerInfo, BirthDate;

PostgreSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO singers (singerid, birthdate, firstname, lastname, singerinfo) VALUES (1, -- type: bigint NULL, -- type: timestamp with time zone 'Marc', -- type: character varying 'Richards', -- type: character varying NULL -- type: bytea );
THEN RETURN singerid, firstname, lastname, singerinfo, birthdate;

点击 play_circle 运行。

Spanner 运行这些语句。完成后，结果标签页会显示该语句插入了一行：

GoogleSQL

PostgreSQL

在探索器中，点击歌手表旁边的 more_vert 查看操作，然后点击插入数据。

修改 INSERT 语句的 VALUES 子句和 SELECT 语句的 WHERE 子句：

GoogleSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO Singers (SingerId, BirthDate, FirstName, LastName, SingerInfo) VALUES (2, -- type: INT64 NULL, -- type: DATE 'Catalina', -- type: STRING(1024) 'Smith', -- type: STRING(1024) NULL -- type: BYTES(MAX) ) -- Change values in the WHERE condition to match the inserted row.
SELECT * FROM Singers WHERE SingerId=2;

PostgreSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO singers (singerid, birthdate, firstname, lastname, singerinfo) VALUES (2, -- type: bigint NULL, -- type: timestamp with time zone 'Catalina', -- type: character varying 'Smith', -- type: character varying NULL -- type: bytea );
-- Change values in the WHERE condition to match the inserted row.
SELECT * FROM singers WHERE singerid=2;

点击 play_circle 运行。

在 Spanner 运行语句之后，结果标签页会显示该语句插入了一行。

在探索器中，点击歌手表旁边的 more_vert 查看操作，然后点击预览数据。

点击 play_circle 运行。Singers 表现在有两行：

GoogleSQL

PostgreSQL

在输入数据时您也可以插入空字符串值。

点击插入以添加一行。

Spanner 再次显示 Singers 表的 Spanner Studio页面，其中包含一个新的查询标签页，该标签页包含相同的 INSERT 和 SELECT 语句。

修改模板的 INSERT 语句的 VALUES 子句和 SELECT 语句的 WHERE 子句：

GoogleSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO Singers (SingerId, BirthDate, FirstName, LastName, SingerInfo) VALUES (3, -- type: INT64 NULL, -- type: DATE 'Kena', -- type: STRING(1024) '', -- type: STRING(1024) NULL -- type: BYTES(MAX) );
-- Change values in the WHERE condition to match the inserted row.
SELECT * FROM Singers WHERE SingerId=3;

PostgreSQL

-- Add new values in the VALUES clause in order of the column list.
-- Each value must be type compatible with its associated column.
INSERT INTO singers (singerid, birthdate, firstname, lastname, singerinfo) VALUES (3, -- type: bigint NULL, -- type: timestamp with time zone 'Kena', -- type: character varying '', -- type: character varying NULL -- type: bytea );
-- Change values in the WHERE condition to match the inserted row.
SELECT * FROM singers WHERE singerid=3;

请注意，为姓氏列提供的值是空字符串 ''，而不是 NULL 值。

点击 play_circle 运行。

在 Spanner 运行语句之后，结果标签页会显示该语句插入了一行。

在探索器中，点击歌手表旁边的 more_vert 查看操作，然后点击预览数据。

点击 play_circle 运行。Singers 表现在有三行，并且主键值为 3 的行在 LastName 列中包含空字符串：

GoogleSQL

PostgreSQL

修改数据

在 Singers 表的数据页面上，选中主键值为 3 的行上的复选框，然后点击修改。

Spanner 会显示 Spanner Studio 页面，其中包含一个新的标签页，该标签页包含您可以修改的模板 UPDATE 和 SET 语句。
请注意，两个语句的 WHERE 子句都表示要更新的行是主键值为 3 的行。

GoogleSQL

-- Change values in the SET clause to update the row where the WHERE condition is true.
UPDATE Singers SET BirthDate='', FirstName='Kena', LastName='', SingerInfo='' WHERE SingerId=3;
SELECT * FROM Singers WHERE SingerId=3;

PostgreSQL

-- Change values in the SET clause to update the row where the WHERE condition is true.
UPDATE singers SET birthdate=NULL, firstname='Kena', lastname='', singerinfo=NULL WHERE singerid='3';
SELECT * FROM singers WHERE singerid='3';

修改 UPDATE 语句的 SET 子句，以仅更新出生日期：

GoogleSQL

-- Change values in the SET clause to update the row where the WHERE condition is true.
UPDATE Singers SET BirthDate='1961-04-01' WHERE SingerId=3;
SELECT * FROM Singers WHERE SingerId=3;

PostgreSQL

-- Change values in the SET clause to update the row where the WHERE condition is true.
UPDATE singers SET birthdate='1961-04-01 00:00:00 -8:00' WHERE singerid='3';
SELECT * FROM singers WHERE singerid='3';

点击 play_circle 运行。

Spanner 运行这些语句。完成后，结果标签页会显示第一个语句更新了一行。

在探索器中，点击歌手表旁边的 more_vert 查看操作，然后点击预览数据。

点击 play_circle 运行。更新后的行现在包含出生日期的值。

GoogleSQL

PostgreSQL

删除数据

在 Singers 表的数据页面上，选中第一列中包含 2 的行上的复选框，然后点击删除。

在显示的对话框中，点击确认。

Singers 表现在有两行：

GoogleSQL

PostgreSQL

运行查询

在数据库概览页面上，点击导航菜单中的 Spanner Studio。

点击新标签页以创建新的查询标签页。然后，在查询编辑器中输入以下查询：

GoogleSQL

SELECT * FROM Singers;

PostgreSQL

SELECT * FROM singers;

点击 play_circle 运行。

Spanner 运行查询。完成后，结果标签页将显示查询结果：

GoogleSQL

PostgreSQL

恭喜！您已成功创建了一个 Spanner 数据库，并使用查询编辑器执行了一条 SQL 语句！

清理

为避免您的 Google Cloud 账号产生额外费用，请删除数据库和实例。停用 Cloud Billing API 不会停止产生费用。删除实例后，该实例中的所有数据库也会一并删除。

删除数据库

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

点击包含要删除的数据库的实例的名称，例如 Test Instance。

点击要删除的数据库的名称，例如 example-db。

在数据库详细信息页面中，点击 delete 删除数据库。

输入数据库名称，然后点击删除，以确认您要删除该数据库。

删除实例

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

点击要删除的实例的名称，例如 Test Instance。

点击 delete 删除实例。

输入实例名称，然后点击删除，确认您要删除该实例。

后续步骤

了解实例。

了解 Spanner 的架构和数据模型。

详细了解GoogleSQL数据定义语言 (DDL)。

详细了解查询执行计划。

了解如何通过 C++、C#、Go、Java、Node.js、PHP、Python、Ruby、REST 或 gcloud 使用 Spanner。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-02-18。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-02-18。"],[],[]]

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
