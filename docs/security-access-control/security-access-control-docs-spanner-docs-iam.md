# IAM 概览  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/iam

IAM 概览  |  Spanner  |  Google Cloud Documentation

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

IAM 概览

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

借助 Identity and Access Management (IAM)，您可以控制用户和群组在项目、Spanner 实例和 Spanner 数据库级对 Spanner 资源的访问权限。例如，您可以指定某个用户对您项目中特定实例的特定数据库拥有完全控制权，但不允许该用户创建、修改或删除项目中的任何实例。通过使用 IAM 控制访问权限，您可以向用户或群组授予权限，而无需单独修改每个 Spanner 实例或数据库权限。

本文档重点介绍与 Spanner 相关的 IAM 权限和授予这些权限的 IAM 角色。如需详细了解 IAM 及其功能，请参阅 Identity and Access Management 开发者指南，尤其应参阅管理 IAM 政策部分。

权限

有了权限，用户便可对 Spanner 资源执行特定操作。例如，拥有 spanner.databases.read 权限的用户可以使用 Spanner 的读取 API 从数据库读取数据，而拥有 spanner.databases.select 权限的用户可以对数据库执行 SQL select 语句。您不能直接授予用户权限，但可以为他们分配预定义角色或自定义角色，这些角色本身会具有一项或多项权限。

下表列出了与 Spanner 相关的 IAM 权限。

实例配置

以下权限适用于 Spanner 实例配置。如需了解详情，请参阅 REST 和 RPC API 的实例配置参考文档。

实例配置权限名称 说明

spanner.instanceConfigs.create 创建自定义实例配置。

spanner.instanceConfigs.delete 删除自定义实例配置。

spanner.instanceConfigs.get 获取实例配置。

spanner.instanceConfigs.list 列出一组实例配置。

spanner.instanceConfigs.update 更新自定义实例配置。

实例配置操作

以下权限适用于 Spanner 实例配置操作。如需了解详情，请参阅 REST 和 RPC API 的实例参考信息。

实例配置操作权限名称 说明

spanner.instanceConfigOperations.cancel 取消实例配置操作。

spanner.instanceConfigOperations.delete 删除实例配置操作。

spanner.instanceConfigOperations.get 获取实例配置操作。

spanner.instanceConfigOperations.list 列出实例配置操作。

实例

以下权限适用于 Spanner 实例。如需了解详情，请参阅 REST 和 RPC API 的实例参考信息。

实例权限名称 说明

spanner.instances.create 创建实例。

spanner.instances.delete 删除实例。

spanner.instances.get 获取特定实例的配置。

spanner.instances.getIamPolicy 获取实例的 IAM 政策。

spanner.instances.list 列出实例。

spanner.instances.setIamPolicy 设置实例的 IAM 政策。

spanner.instances.update 更新实例。

实例操作

以下权限适用于 Spanner 实例操作。如需了解详情，请参阅 REST 和 RPC API 的实例参考文档。

实例操作权限名称 说明

spanner.instanceOperations.cancel 取消实例操作。

spanner.instanceOperations.delete 删除实例操作。

spanner.instanceOperations.get 获取特定的实例操作。

spanner.instanceOperations.list 列出实例操作。

实例分区

以下权限适用于 Spanner 实例分区。如需了解详情，请参阅 REST 和 RPC API 的实例分区参考信息。

实例权限名称 说明

spanner.instancePartitions.create 创建实例分区。

spanner.instancePartitions.delete 删除实例分区。

spanner.instancePartitions.get 获取特定实例分区的配置。

spanner.instancePartitions.list 列出实例分区。

spanner.instancePartitions.update 更新实例分区。

实例分区操作

以下权限适用于 Spanner 实例分区操作。如需了解详情，请参阅 REST 和 RPC API 的实例分区参考信息。

实例分区操作权限名称 说明

spanner.instancePartitionOperations.cancel 取消实例分区操作。

spanner.instancePartitionOperations.delete 删除实例分区操作。

spanner.instancePartitionOperations.get 获取特定的实例分区操作。

spanner.instancePartitionOperations.list 列出实例分区操作。

数据库

以下权限适用于 Spanner 数据库。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。

数据库权限名称 说明

spanner.databases.adapt 使 Spanner Adapter API 可以直接与 Spanner 交互。

spanner.databases.beginOrRollbackReadWriteTransaction 在 Spanner 数据库上开始或回滚读写事务。

spanner.databases.beginPartitionedDmlTransaction 执行实例分区数据操纵语言 (DML) 语句。如需详细了解实例分区查询，请参阅并行读取数据。

spanner.databases.beginReadOnlyTransaction 在 Spanner 数据库上开始只读事务。

spanner.databases.create 创建数据库。

spanner.databases.createBackup 从数据库创建备份。此外，还需要 spanner.backups.create 以创建备份资源。

spanner.databases.drop 删除数据库。

spanner.databases.get 获取数据库的元数据。

spanner.databases.getDdl 获取数据库的架构。

spanner.databases.getIamPolicy 获取数据库的 IAM 政策。

spanner.databases.list 列出数据库。

spanner.databases.read 使用读取 API 从数据库读取数据。

spanner.databases.select 对数据库执行 SQL select 语句。

spanner.databases.setIamPolicy 设置数据库的 IAM 政策。

spanner.databases.update 更新数据库的元数据。
目前不适用于 IAM 自定义角色。

spanner.databases.updateDdl 更新数据库架构。

spanner.databases.useDataBoost 使用 Spanner Data Boost 的计算资源处理实例分区查询。

spanner.databases.useRoleBasedAccess 使用精细访问权限控制。

spanner.databases.write 写入数据库。

数据库角色

以下权限适用于 Spanner 数据库角色。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。

数据库角色权限名称 说明

spanner.databaseRoles.list 列出数据库角色。

spanner.databaseRoles.use 使用指定的数据库角色。

数据库操作

以下权限适用于 Spanner 数据库操作。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。

数据库操作权限名称 说明

spanner.databaseOperations.cancel 取消数据库操作。

spanner.databaseOperations.get 获取特定的数据库操作。

spanner.databaseOperations.list 列出数据库并恢复数据库操作。

备份

以下权限适用于 Spanner 备份。如需了解详情，请参阅 REST 和 RPC API 的备份参考信息。

备份权限名称 说明

spanner.backups.create 创建备份。 此外，还需要对源数据库使用 spanner.databases.createBackup。

spanner.backups.delete 删除备份。

spanner.backups.get 获取备份。

spanner.backups.getIamPolicy 获取备份的 IAM 政策。

spanner.backups.list 列出备份。

spanner.backups.restoreDatabase 使用备份恢复数据库。此外，还需要 spanner.databases.create 在目标实例上创建恢复的数据库。

spanner.backups.setIamPolicy 设置备份的 IAM 政策。

spanner.backups.update 更新备份。

备份操作

以下权限适用于 Spanner 备份操作。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。

备份操作权限名称 说明

spanner.backupOperations.cancel 取消备份操作。

spanner.backupOperations.get 获取特定的备份操作。

spanner.backupOperations.list 列出备份操作。

备份时间表

以下权限适用于 Spanner 备份时间表。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。

备份时间表权限名称 说明

spanner.backupSchedules.create 创建备份时间表。此外，还需要对源数据库使用 spanner.databases.createBackup。

spanner.backupSchedules.delete 删除备份时间表。

spanner.backupSchedules.get 获取备份时间表。

spanner.backupSchedules.list 列出备份时间表。

spanner.backupSchedules.update 更新备份时间表。

会话

以下权限适用于 Spanner 会话。如需了解详情，请参阅 REST 和 RPC API 的数据库参考信息。
注意：会话是一个高级概念，仅适用于 REST API 用户以及正在创建自己的客户端库的用户。如需了解详情，请参阅会话。

会话权限名称 说明

spanner.sessions.create 创建会话。

spanner.sessions.delete 删除会话。

spanner.sessions.get 获取会话。

spanner.sessions.list 列出会话。

预定义角色

预定义角色是一个或多个权限的集合。例如，预定义角色 roles/spanner.databaseUser 包含 spanner.databases.read 和 spanner.databases.write 权限。Spanner 有两种预定义角色：

人员角色：分配给用户或群组的角色，允许他们对项目中的资源执行操作。

机器角色：分配给服务账号的角色，允许以这些服务账号的身份运行的机器对项目中的资源执行操作。

注意：为避免给机器提供过多不必要的权限，请勿将人员角色分配给服务账号。

下表列出了 IAM 访问权限控制预定义的角色，包括与每个角色关联的权限列表：

Role Permissions

Cloud Spanner Admin

(roles/spanner.admin)

Has complete access to all Spanner resources in a Google Cloud project. A principal with this role can:

Grant and revoke permissions to other principals for all Spanner resources in the project.

Allocate and delete chargeable Spanner resources.

Issue get/list/modify operations on Cloud Spanner resources.

Read from and write to all Cloud Spanner databases in the project.

Fetch project metadata.

Lowest-level resources where you can grant this role:

Instance

Database

cloudkms.keyHandles.*

cloudkms.keyHandles.create

cloudkms.keyHandles.get

cloudkms.keyHandles.list

cloudkms.operations.get

cloudkms.projects.showEffectiveAutokeyConfig

monitoring.timeSeries.*

monitoring.timeSeries.create

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.*

spanner.backupOperations.cancel

spanner.backupOperations.get

spanner.backupOperations.list

spanner.backupSchedules.create

spanner.backupSchedules.delete

spanner.backupSchedules.get

spanner.backupSchedules.getIamPolicy

spanner.backupSchedules.list

spanner.backupSchedules.setIamPolicy

spanner.backupSchedules.update

spanner.backups.copy

spanner.backups.create

spanner.backups.delete

spanner.backups.get

spanner.backups.getIamPolicy

spanner.backups.list

spanner.backups.restoreDatabase

spanner.backups.setIamPolicy

spanner.backups.update

spanner.databaseOperations.cancel

spanner.databaseOperations.get

spanner.databaseOperations.list

spanner.databaseRoles.list

spanner.databases.adapt

spanner.databases.addSplitPoints

spanner.databases.beginOrRollbackReadWriteTransaction

spanner.databases.beginPartitionedDmlTransaction

spanner.databases.beginReadOnlyTransaction

spanner.databases.changequorum

spanner.databases.create

spanner.databases.createBackup

spanner.databases.drop

spanner.databases.get

spanner.databases.getDdl

spanner.databases.getIamPolicy

spanner.databases.list

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.runGraphAlgorithms

spanner.databases.select

spanner.databases.setIamPolicy

spanner.databases.update

spanner.databases.updateDdl

spanner.databases.useDataBoost

spanner.databases.useRoleBasedAccess

spanner.databases.write

spanner.instanceConfigOperations.cancel

spanner.instanceConfigOperations.delete

spanner.instanceConfigOperations.get

spanner.instanceConfigOperations.list

spanner.instanceConfigs.create

spanner.instanceConfigs.delete

spanner.instanceConfigs.get

spanner.instanceConfigs.list

spanner.instanceConfigs.update

spanner.instanceOperations.cancel

spanner.instanceOperations.delete

spanner.instanceOperations.get

spanner.instanceOperations.list

spanner.instancePartitionOperations.cancel

spanner.instancePartitionOperations.delete

spanner.instancePartitionOperations.get

spanner.instancePartitionOperations.list

spanner.instancePartitions.create

spanner.instancePartitions.delete

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instancePartitions.update

spanner.instances.create

spanner.instances.createTagBinding

spanner.instances.delete

spanner.instances.deleteTagBinding

spanner.instances.get

spanner.instances.getIamPolicy

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

spanner.instances.setIamPolicy

spanner.instances.update

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Editor

(roles/spanner.editor)

Editor role for Cloud Spanner

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.backupOperations.*

spanner.backupOperations.cancel

spanner.backupOperations.get

spanner.backupOperations.list

spanner.backupSchedules.create

spanner.backupSchedules.delete

spanner.backupSchedules.get

spanner.backupSchedules.getIamPolicy

spanner.backupSchedules.list

spanner.backupSchedules.update

spanner.backups.copy

spanner.backups.create

spanner.backups.delete

spanner.backups.get

spanner.backups.getIamPolicy

spanner.backups.list

spanner.backups.restoreDatabase

spanner.backups.update

spanner.databaseOperations.*

spanner.databaseOperations.cancel

spanner.databaseOperations.get

spanner.databaseOperations.list

spanner.databaseRoles.list

spanner.databases.adapt

spanner.databases.addSplitPoints

spanner.databases.beginOrRollbackReadWriteTransaction

spanner.databases.beginPartitionedDmlTransaction

spanner.databases.beginReadOnlyTransaction

spanner.databases.changequorum

spanner.databases.create

spanner.databases.createBackup

spanner.databases.drop

spanner.databases.get

spanner.databases.getDdl

spanner.databases.getIamPolicy

spanner.databases.list

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.runGraphAlgorithms

spanner.databases.select

spanner.databases.update

spanner.databases.updateDdl

spanner.databases.useDataBoost

spanner.databases.useRoleBasedAccess

spanner.databases.write

spanner.instanceConfigOperations.*

spanner.instanceConfigOperations.cancel

spanner.instanceConfigOperations.delete

spanner.instanceConfigOperations.get

spanner.instanceConfigOperations.list

spanner.instanceConfigs.*

spanner.instanceConfigs.create

spanner.instanceConfigs.delete

spanner.instanceConfigs.get

spanner.instanceConfigs.list

spanner.instanceConfigs.update

spanner.instanceOperations.*

spanner.instanceOperations.cancel

spanner.instanceOperations.delete

spanner.instanceOperations.get

spanner.instanceOperations.list

spanner.instancePartitionOperations.*

spanner.instancePartitionOperations.cancel

spanner.instancePartitionOperations.delete

spanner.instancePartitionOperations.get

spanner.instancePartitionOperations.list

spanner.instancePartitions.*

spanner.instancePartitions.create

spanner.instancePartitions.delete

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instancePartitions.update

spanner.instances.create

spanner.instances.delete

spanner.instances.get

spanner.instances.getIamPolicy

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

spanner.instances.update

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Viewer

(roles/spanner.viewer)

A principal with this role can:

View all Spanner instances (but cannot modify instances).

View all Spanner databases (but cannot modify or read from databases).

For example, you can combine this role with the roles/spanner.databaseUser role to grant a user with access to a specific database, but only view access to other instances and databases.

This role is recommended at the Google Cloud project level for users interacting with Cloud Spanner resources in the Google Cloud console.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.databases.get

spanner.databases.list

spanner.instanceConfigs.get

spanner.instanceConfigs.list

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instances.get

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

Cloud Spanner Backup Admin

(roles/spanner.backupAdmin)

A principal with this role can:

Create, view, update, and delete backups.

View and manage a backup's allow policy.

This role cannot restore a database from a backup.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.backupOperations.*

spanner.backupOperations.cancel

spanner.backupOperations.get

spanner.backupOperations.list

spanner.backupSchedules.create

spanner.backupSchedules.delete

spanner.backupSchedules.get

spanner.backupSchedules.list

spanner.backupSchedules.update

spanner.backups.copy

spanner.backups.create

spanner.backups.delete

spanner.backups.get

spanner.backups.getIamPolicy

spanner.backups.list

spanner.backups.setIamPolicy

spanner.backups.update

spanner.databases.createBackup

spanner.databases.get

spanner.databases.list

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instances.createTagBinding

spanner.instances.deleteTagBinding

spanner.instances.get

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

Cloud Spanner Backup Writer

(roles/spanner.backupWriter)

This role is intended to be used by scripts that automate backup creation.
A principal with this role can create backups, but cannot update or delete them.

Lowest-level resources where you can grant this role:

Instance

Database

spanner.backupOperations.get

spanner.backupOperations.list

spanner.backupSchedules.create

spanner.backupSchedules.get

spanner.backupSchedules.list

spanner.backups.copy

spanner.backups.create

spanner.backups.get

spanner.backups.list

spanner.databases.createBackup

spanner.databases.get

spanner.databases.list

spanner.instancePartitions.get

spanner.instances.get

Cloud Spanner Database Admin

(roles/spanner.databaseAdmin)

A principal with this role can:

Get/list all Spanner instances in the project.

Create/list/drop databases in an instance.

Grant/revoke access to databases in the project.

Read from and write to all Cloud Spanner databases in the project.

Lowest-level resources where you can grant this role:

Instance

Database

cloudkms.keyHandles.*

cloudkms.keyHandles.create

cloudkms.keyHandles.get

cloudkms.keyHandles.list

cloudkms.operations.get

cloudkms.projects.showEffectiveAutokeyConfig

monitoring.timeSeries.*

monitoring.timeSeries.create

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.databaseOperations.*

spanner.databaseOperations.cancel

spanner.databaseOperations.get

spanner.databaseOperations.list

spanner.databaseRoles.list

spanner.databases.adapt

spanner.databases.addSplitPoints

spanner.databases.beginOrRollbackReadWriteTransaction

spanner.databases.beginPartitionedDmlTransaction

spanner.databases.beginReadOnlyTransaction

spanner.databases.changequorum

spanner.databases.create

spanner.databases.drop

spanner.databases.get

spanner.databases.getDdl

spanner.databases.getIamPolicy

spanner.databases.list

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.runGraphAlgorithms

spanner.databases.select

spanner.databases.setIamPolicy

spanner.databases.update

spanner.databases.updateDdl

spanner.databases.useDataBoost

spanner.databases.useRoleBasedAccess

spanner.databases.write

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instances.createTagBinding

spanner.instances.deleteTagBinding

spanner.instances.get

spanner.instances.getIamPolicy

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Database Reader

(roles/spanner.databaseReader)

A principal with this role can:

Read from the Spanner database.

Execute SQL queries on the database.

View schema for the database.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.create

spanner.databases.beginReadOnlyTransaction

spanner.databases.get

spanner.databases.getDdl

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.select

spanner.instancePartitions.get

spanner.instances.get

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Database Reader with DataBoost

(roles/spanner.databaseReaderWithDataBoost)

Includes all permissions in the spanner.databaseReader role enabling access to read and/or query a Cloud Spanner database using instance resources, as well as the permission to access the database with Data Boost, a fully managed serverless service that provides independent compute resources.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.create

spanner.databases.beginReadOnlyTransaction

spanner.databases.get

spanner.databases.getDdl

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.select

spanner.databases.useDataBoost

spanner.instancePartitions.get

spanner.instances.get

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Database Role User

(roles/spanner.databaseRoleUser)

In conjunction with the IAM role Cloud Spanner Fine-grained Access User, grants permissions to individual Spanner database roles. Add a condition for each desired Spanner database role that includes the resource type of `spanner.googleapis.com/DatabaseRole` and the resource name ending with `/YOUR_SPANNER_DATABASE_ROLE`.

Lowest-level resources where you can grant this role:

Instance

Database

Cloud Spanner Database User

(roles/spanner.databaseUser)

A principal with this role can:

Read from and write to the Spanner database.

Execute SQL queries on the database, including DML and Partitioned DML.

View and update schema for the database.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.create

spanner.databaseOperations.*

spanner.databaseOperations.cancel

spanner.databaseOperations.get

spanner.databaseOperations.list

spanner.databases.adapt

spanner.databases.beginOrRollbackReadWriteTransaction

spanner.databases.beginPartitionedDmlTransaction

spanner.databases.beginReadOnlyTransaction

spanner.databases.changequorum

spanner.databases.get

spanner.databases.getDdl

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.select

spanner.databases.updateDdl

spanner.databases.write

spanner.instancePartitions.get

spanner.instances.get

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Fine-grained Access User

(roles/spanner.fineGrainedAccessUser)

Grants permissions to use Spanner's fine-grained access control framework. To grant access to specific database roles, also add the `roles/spanner.databaseRoleUser` IAM role and its necessary conditions.

Lowest-level resources where you can grant this role:

Instance

Database

spanner.databaseRoles.list

spanner.databases.useRoleBasedAccess

Cloud Spanner Database Graph Intelligence features user

(roles/spanner.graphIntelligenceUser)

Access to Graph Intelligence features.

monitoring.timeSeries.create

spanner.databases.beginReadOnlyTransaction

spanner.databases.get

spanner.databases.getDdl

spanner.databases.partitionQuery

spanner.databases.partitionRead

spanner.databases.read

spanner.databases.runGraphAlgorithms

spanner.databases.select

spanner.databases.useDataBoost

spanner.instancePartitions.get

spanner.instances.get

spanner.sessions.*

spanner.sessions.create

spanner.sessions.delete

spanner.sessions.get

spanner.sessions.list

Cloud Spanner Restore Admin

(roles/spanner.restoreAdmin)

A principal with this role can restore databases from backups.

If you need to restore a backup to a different instance, apply this role at the project level or to both instances. This role cannot create backups.

Lowest-level resources where you can grant this role:

Instance

Database

monitoring.timeSeries.list

resourcemanager.projects.get

resourcemanager.projects.list

spanner.backups.get

spanner.backups.list

spanner.backups.restoreDatabase

spanner.databaseOperations.*

spanner.databaseOperations.cancel

spanner.databaseOperations.get

spanner.databaseOperations.list

spanner.databases.create

spanner.databases.get

spanner.databases.list

spanner.instancePartitions.get

spanner.instancePartitions.list

spanner.instances.createTagBinding

spanner.instances.deleteTagBinding

spanner.instances.get

spanner.instances.list

spanner.instances.listEffectiveTags

spanner.instances.listTagBindings

Service agent roles

Service agent roles should only be granted to service agents.

Role Permissions

Cloud Spanner API Service Agent

(roles/spanner.serviceAgent)

Cloud Spanner API Service Agent

Warning: Do not grant service agent roles to any principals except service agents.

aiplatform.endpoints.get

aiplatform.endpoints.list

aiplatform.endpoints.predict

aiplatform.models.get

aiplatform.models.list

compute.disks.create

compute.disks.createTagBinding

compute.disks.use

compute.instances.create

compute.instances.createTagBinding

compute.instances.delete

compute.instances.get

compute.instances.setLabels

compute.instances.setMetadata

compute.instances.setServiceAccount

compute.networks.create

compute.networks.use

compute.networks.useExternalIp

compute.subnetworks.create

compute.subnetworks.use

compute.subnetworks.useExternalIp

logging.logEntries.create

run.jobs.run

run.routes.invoke

spanner.databases.beginOrRollbackReadWriteTransaction

spanner.databases.beginReadOnlyTransaction

spanner.databases.partitionQuery

spanner.databases.select

spanner.databases.useDataBoost

spanner.databases.write

spanner.sessions.create

storage.buckets.create

storage.buckets.get

storage.buckets.list

storage.objects.create

storage.objects.delete

storage.objects.get

storage.objects.list

注意：当分配的角色为 spanner.databaseReader 时，对只读事务的请求可能偶尔会因权限错误而失败。要解决此问题，请参阅管理写入会话比例。

基本角色

基本角色指在引入 IAM 之前的项目级层角色。如需了解详情，请参阅基本角色。

虽然 Spanner 支持以下基本角色，但您应尽可能使用上述预定义角色之一。基本角色包括适用于您的所有 Google Cloud 资源的一系列权限；与此相对，Spanner 的预定义角色则包括仅适用于 Spanner 的精细权限。

基本角色 说明

roles/editor 可以完成 roles/viewer 能够完成的所有操作。也可以创建实例和数据库，以及将数据写入数据库。

roles/owner 可以完成 roles/editor 能够完成的所有操作。也可以修改对数据库和实例的访问权限。

roles/viewer 可以列出及获取架构和实例的元数据。也可以使用 SQL 对数据库进行读取和查询。

自定义角色

如果 Spanner 的预定义角色不能满足您的业务需求，您可自行定义角色，使其具备您指定的权限。

在创建自定义角色之前，您必须确定需要执行的任务。然后，您可以确定每个任务所需的权限，并将这些权限添加到自定义角色中。

适用于服务账号任务的自定义角色

对于大多数任务而言，需要添加到自定义角色中的权限非常明确。例如，如果您希望您的服务账号能够创建数据库，请将权限 spanner.databases.create 添加到您的自定义角色中。

但是，在 Spanner 表中读取或写入数据时，您需要为自定义角色添加多个不同的权限。下表显示了读取和写入数据所需的权限。

服务账号任务 所需权限

创建备份 spanner.backups.create spanner.databases.createBackup

读取数据 spanner.databases.select spanner.sessions.create spanner.sessions.delete

恢复数据库 spanner.backups.restoreDatabase spanner.databases.create

插入、更新或删除数据 spanner.databases.beginOrRollbackReadWriteTransaction spanner.sessions.create spanner.sessions.delete spanner.databases.write

用于 Google Cloud 控制台任务的自定义角色

如需确定Google Cloud 控制台中指定任务所需的权限列表，请确定该任务的工作流并为该工作流编译权限。例如，如需查看某个表中的数据，您可以在 Google Cloud 控制台中执行以下步骤：

步骤 权限

1. 访问该项目
resourcemanager.projects.get

2. 查看实例列表
spanner.instances.list

3. 选择实例
spanner.instances.get

4.  查看数据库列表
spanner.databases.list

5. 选择数据库和表
spanner.databases.getDdl

6.  查看表中的数据
spanner.databases.select、spanner.sessions.create、spanner.sessions.delete

在这个例子中，您需要以下权限：

resourcemanager.projects.get

spanner.databases.getDdl

spanner.databases.list

spanner.databases.select

spanner.instances.get

spanner.instances.list

spanner.sessions.create

spanner.sessions.delete

下表列出了Google Cloud 控制台中的操作所需的权限。

权限 操作

spanner.databases.setIamPolicy 在“数据库详细信息”页面的“权限”标签页中添加主账号

spanner.instances.setIamPolicy 在“实例”页面的“权限”标签页中添加主账号

spanner.backups.create spanner.databases.createBackup spanner.databases.list1 spanner.backupOperations.list1 创建备份

spanner.backupSchedules.create spanner.databases.createBackup 创建备份时间表

spanner.databases.create 创建数据库

spanner.instancePartitions.list spanner.instancePartitionOperations.get spanner.instancePartitions.create 创建实例分区

spanner.databaseOperations.get spanner.databaseOperations.list spanner.databases.updateDdl 创建表 更新表架构

spanner.instanceConfigs.list spanner.instanceOperations.get spanner.instances.create 创建实例

spanner.backups.delete 删除备份

spanner.backupSchedules.delete 删除备份时间表

spanner.databases.drop 删除数据库

spanner.instancePartitions.delete 删除实例分区

spanner.instances.delete 删除实例

spanner.instancePartitionOperations.get spanner.instancePartitions.update 修改实例分区

spanner.instanceOperations.get spanner.instances.update 修改实例

spanner.databases.beginOrRollbackReadWriteTransaction spanner.databases.select spanner.databases.write spanner.sessions.create spanner.sessions.delete 修改表中的数据

spanner.instanceConfigs.list spanner.instances.get spanner.backups.get spanner.backups.restoreDatabase spanner.instances.list spanner.databases.create 从备份中恢复数据库

spanner.databases.get spanner.databases.getDdl 从数据库列表中选择一个数据库，并查看“数据库详细信息”页面中的架构

spanner.instances.get 从实例列表中选择一个实例以查看“实例详情”页面

spanner.backups.update 更新备份

spanner.backupSchedules.update 更新备份时间表

spanner.databases.select spanner.sessions.create spanner.sessions.delete 查看“数据库详情”页面上“数据”标签页中的数据 创建并运行查询

spanner.backups.list spanner.backups.get 查看“备份/恢复”页面

monitoring.metricDescriptors.get monitoring.metricDescriptors.list monitoring.timeSeries.list spanner.instances.get 查看“实例详情”页面或“数据库详细信息”页面上“监视器”标签中的图表

spanner.backupOperations.list 查看备份操作列表

spanner.databases.list 查看“实例详情”页面中的数据库列表

resourcemanager.projects.get spanner.instances.list 查看“实例”页面中的实例列表

spanner.databaseOperations.list 查看恢复操作列表

spanner.databases.getIamPolicy 查看“数据库详细信息”页面的“权限”标签中的列表

spanner.instances.getIamPolicy 查看“实例”页面的“权限”标签中的列表

1 如果您要在实例级层（而非数据库级层）通过备份/恢复页面创建备份，则必须提供此属性。

Spanner IAM 政策管理

您可以对 Spanner 实例、数据库和备份资源使用 REST 或 RPC API，以获取、设置和测试 IAM 政策。

实例

REST API RPC API

projects.instances.getIamPolicy GetIamPolicy

projects.instances.setIamPolicy SetIamPolicy

projects.instances.testIamPermissions TestIamPermissions

数据库

REST API RPC API

projects.instances.databases.getIamPolicy GetIamPolicy

projects.instances.databases.setIamPolicy SetIamPolicy

projects.instances.databases.testIamPermissions TestIamPermissions

备份

REST API RPC API

projects.instances.backups.getIamPolicy GetIamPolicy

projects.instances.backups.setIamPolicy SetIamPolicy

projects.instances.backups.testIamPermissions TestIamPermissions

后续步骤

详细了解 Identity and Access Management。

了解如何为 Spanner 数据库、实例或 Google Cloud 项目应用 IAM 角色。

了解如何控制从互联网访问 Google Cloud 资源（包括 Spanner）。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

最后更新时间 (UTC)：2026-09-26。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],["最后更新时间 (UTC)：2026-09-26。"],[],[]]

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
