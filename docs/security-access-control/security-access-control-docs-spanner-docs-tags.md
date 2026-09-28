# 使用标记控制访问权限和整理实例  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/tags

使用标记控制访问权限和整理实例  |  Spanner  |  Google Cloud Documentation

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

使用标记控制访问权限和整理实例

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何使用 Google Cloud 标记来管理对 Spanner 实例的访问权限。

Google Cloud 标记是一种键值对，您可以将其附加到 Google Cloud 资源（例如项目或 Spanner 实例）。您可以使用标记对实例进行分组和整理，还可以根据实例是否具有特定标记，有条件地设置 Identity and Access Management (IAM) 访问权限政策。您可以使用 Google Cloud CLI 或Google Cloud 控制台创建和管理 Spanner 实例标记。创建标记后，您可以创建标记绑定，将标记附加到 Google Cloud 资源。资源的子级会根据Google Cloud 资源层次结构继承标记绑定。例如，如果您将标记附加到您的项目，则该项目中的所有实例都会继承标记。您还可以使用标签来整理 Google Cloud 资源，但不能使用标签对 IAM 政策设置条件。

如需详细了解标记，请参阅标记概览。

Spanner 实例标记的常见应用场景

标记的一些常见应用场景包括：

IAM 标记：根据实例是否具有特定标记来授予 IAM 角色。标记值是否存在是相应 IAM 政策的条件，有助于控制对 Spanner 实例的访问权限。

状态标记：通过创建标记来指示和管理实例的状态。例如，state:active、state:todelete 和 state:archive。

环境标记：通过创建键值对（例如 env:prod、env:dev 和 env:test）为实例指定生产、测试和开发环境。

如何创建和管理 Spanner 实例标记

标记采用键值对的结构。您可以在组织资源下创建标记键，然后将标记值附加到标记键（例如，具有值 prod 和 dev 的标记键 environment）。然后，您可以创建将标记值关联到 Google Cloud 资源（例如项目或 Spanner 实例）的标记绑定。请注意，您无法为数据库分配标记。

所需权限

您需要的权限取决于您需要执行的操作。 如需了解详情，请参阅 Resource Manager 文档中的所需权限。

创建标记键和标记值

您必须先创建标记并分配其值，然后才能将标记附加到实例。如需创建标记键和标记值，请参阅创建标记和添加标记值。

将标记附加到实例

创建标记键值对后，您可以创建标记绑定并将其附加到 Spanner 实例。

控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选中要附加标记的实例旁边的复选框。

点击label_important标记。

如果您的组织未显示在标记面板中，请点击选择范围。选择您的组织，然后点击打开。

在“标记”面板中，选择添加标记。

在键字段中，从列表中选择要附加的标记的键。您可以通过输入关键字来过滤列表。

在值字段中，从列表中选择要附加的标记的值。您可以通过输入关键字来过滤列表。

如果要附加更多标记，请点击 add添加标记，然后为每个标记选择键和值。

点击保存。

在确认对话框中，点击确认以附加标记。

系统会显示一条通知以确认您的标记已更新。

gcloud 如需创建标记绑定并将其附加到实例，请运行以下命令：

gcloud resource-manager tags bindings create --parent=//spanner.googleapis.com/projects/PROJECT_ID/instances/INSTANCE_ID --tag-value=TAG_VALUE_NAME --location=LOCATION

PROJECT_ID：项目的 ID。

INSTANCE_ID：实例的 ID。

TAG_VALUE_NAME：TAG_VALUE_NAME 是要附加的标记值的永久 ID 或命名空间 ID。例如：tagValues/4567890123（永久 ID）或 12345678/env/prod（命名空间 ID）。命名空间 ID 由以下部分组成：

ORG_ID：组织的 ID。

KEY_NAME：标记键的显示（短）名称。例如 env。

VALUE_NAME：标记值的显示（短）名称。例如 prod。

LOCATION：实例的位置因其配置而异：

对于区域级实例，其配置的位置。例如，us-east1。

对于双区域实例，2 字母资源位置。例如，de 表示 dual-region-germany1。

对于多区域实例，是其配置名称。例如 eur3 或 nam-eur-asia1。

例如，如需使用标记键值对 env:prod 在 Spanner 实例 my-instance 上创建标记绑定，请运行以下命令：

gcloud resource-manager tags bindings create --parent=//spanner.googleapis.com/projects/my-project/instances/my-instance --tag-value=123456789012/env/prod --location=us-east1

API 如需使用 REST 或 RPC API 创建标记绑定并将其附加到 Spanner 实例，请参阅将标记附加到资源。

IAM 条件和标记

您可以使用标记和 IAM 条件来有条件地向用户授予角色绑定。如果应用了具有条件角色绑定的 IAM 政策，则更改或删除附加到资源的标记可能会移除用户对该资源的访问权限。

注意： 在外部身份提供方中管理用户访问权限时，请将 Google 账号主账号标识符（例如 user:kiran@example.com、group:support@example.com 和 domain:example.com）替换为适当的员工身份联合主账号标识符。

如需了解详情，请参阅 IAM 条件概览。

控制台 如需了解如何使用标记有条件地向用户授予角色绑定，请参阅管理对标记的访问权限。

gcloud 如需将基于标记的条件应用于 IAM 政策，请确保您拥有所需的权限，然后运行以下命令：

gcloud organizations add-iam-policy-binding ORG_ID --role=roles/ROLE --member=PRINCIPAL --condition=resource.matchTag('PROJECT_ID/KEY_NAME', 'VALUE_NAME')

ORG_ID：组织的 ID。

ROLE：要分配给主账号的角色名称。角色名称是预定义角色的完整路径（例如 roles/logging.viewer），或自定义角色的角色 ID（例如 organizations/{ORG_ID}/roles/logging.viewer）。

PRINCIPAL：要添加角色绑定的主账号。此值应采用 user|group|serviceAccount:email 或 domain:domain 格式。例如 user:test-user@gmail.com、group:admins@example.com、serviceAccount:test123@example.domain.com 或 domain:example.domain.com。

PROJECT_ID：项目的 ID。

KEY_NAME：标记键的显示（短）名称。例如 env。

VALUE_NAME：标记值的显示（短）名称。例如 prod。

此命令可向组织的 IAM 政策添加 IAM 政策绑定。政策绑定由成员、角色和可选条件组成。

例如，如需在所有带有标记 env:prod 的 123456789012 项目资源中，有条件地向 user1@example.com 授予 spanner.backupAdmin 角色，请运行以下命令：

gcloud organizations add-iam-policy-binding my-organization --member=user1@example.com --role=roles/spanner.backupAdmin --condition=resource.matchTag('123456789012/env', 'prod')

列出附加到实例的标记

您可以查看直接附加到实例或由实例继承的标记绑定列表。

控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

在实例列表下方，找到标记列。标记以 key:value 格式显示。

gcloud 如需获取直接附加到资源的标记绑定列表，请使用 gcloud resource-manager tags bindings list 命令。如果添加 --effective 标志，您还会获得此资源继承的所有标记绑定。

如需列出附加到实例的所有标记绑定，请运行以下命令：

gcloud resource-manager tags bindings list --parent=//spanner.googleapis.com/projects/PROJECT_ID/instances/INSTANCE_ID --location=LOCATION --effective

PROJECT_ID：项目的 ID。

INSTANCE_ID：实例的 ID。

LOCATION：实例的位置因其配置而异：

对于区域级实例，其配置的位置。例如，us-east1。

对于双区域实例，2 字母资源位置。例如，de 表示 dual-region-germany1。

对于多区域实例，是其配置名称。例如 eur3 或 nam-eur-asia1。

API 如需使用 REST 或 RPC API 查看直接附加到实例或由实例继承的标记绑定的列表，请参阅列出附加到资源的所有标记。

删除标记绑定

移除标记键或值定义时，请确保标记已与实例分离。您必须先删除现有标记绑定，然后才能删除标记。

控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

前往 Spanner 实例

选中要删除标记绑定的实例旁边的复选框。

点击label_important标记。

在“标记”面板中，点击要分离的标记旁边的 delete 删除项。

点击保存。

在确认对话框中，点击确认以分离标记。

系统会显示一条通知以确认您的标记已更新。

gcloud 如需删除标记绑定，请运行以下命令：

gcloud resource-manager tags bindings delete --parent=//spanner.googleapis.com/projects/PROJECT_ID/instances/INSTANCE_ID --tag-value=TAG_VALUE_NAME --location=LOCATION

PROJECT_ID：项目的 ID。

INSTANCE_ID：实例的 ID。

TAG_VALUE_NAME：TAG_VALUE_NAME 是要附加的标记值的永久 ID 或命名空间 ID。例如：tagValues/4567890123（永久 ID）或 12345678/env/prod（命名空间 ID）。命名空间 ID 由以下部分组成：

ORG_ID：组织的 ID。

KEY_NAME：标记键的显示（短）名称。例如 env。

VALUE_NAME：标记值的显示（短）名称。例如 prod。

LOCATION：实例的位置因其配置而异：

对于区域级实例，其配置的位置。例如，us-east1。

对于双区域实例，2 字母资源位置。例如，de 表示 dual-region-germany1。

对于多区域实例，是其配置名称。例如 eur3 或 nam-eur-asia1。

API 如需使用 REST 或 RPC API 删除标记绑定资源，从而从资源分离标记，请参阅从资源分离标记。

删除标记

删除标记绑定后，您可以删除标记。如需删除标记键和标记值，请参阅删除标记。

后续步骤

详细了解 Google Cloud 标记。

详细了解如何使用 Resource Manager 创建和管理标记。

详细了解标签，这是整理 Google Cloud 资源的另一种方法。

详细了解如何创建具有条件的 IAM 允许政策。

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
