# 创建和管理实例  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/create-manage-instances

创建和管理实例  |  Spanner  |  Google Cloud Documentation

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

创建和管理实例

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何创建、列出、修改和删除 Spanner实例。

注意：如需使用 90 天免费试用实例探索 Spanner，请参阅创建 Spanner 免费试用实例。

创建实例

您可以使用 Google Cloud 控制台、Google Cloud CLI 或客户端库创建实例。您还可以通过添加可选的只读副本，创建使用自定义实例配置的实例。

注意：您无需在 Spanner 中预配存储空间，只需为您使用的存储空间付费。详细了解存储价格。

控制台

在 Google Cloud 控制台中，前往 Spanner 实例页面。

点击创建实例。

转到“创建实例”

在选择版本部分，选择 Spanner 版本。

如果您想比较不同版本之间的规范，请点击比较版本。如需了解详情，请参阅 Spanner 版本概览。

点击继续。

在指定实例名称部分中，输入要在 Google Cloud 控制台中显示的实例名称。此实例名称在您的 Google Cloud 项目中必须是唯一的。

输入用于永久标识实例的实例 ID。此实例 ID 在您的 Google Cloud 项目中也必须是唯一的。您以后无法更改实例 ID。

点击继续。

在配置实例部分的选择配置下方，选择区域级、双区域或多区域。
注意：双区域和多区域实例配置仅适用于企业 Plus 版。如果您想比较这三种配置之间的规范，请点击比较区域配置。

从下拉菜单中选择配置位置。

可选：如需向 Spanner 基本配置添加只读副本，请先使用 Google Cloud CLI 创建自定义实例配置。在企业版和企业 Plus 版中，您可以向基本配置添加可选的只读副本。

点击继续。

在分配计算容量部分的选择单位下，点击以下任一选项：

适用于大型实例的节点。一个节点等于 1000 个处理单元。

适用于小型实例的处理单元。

如需了解详情，请参阅计算容量、节点和处理单元。

在选择扩缩模式下，点击以下任一选项：

手动分配（如果您想针对固定的计算资源和费用手动设置计算容量）。

数量表示要为此实例使用的处理单元或节点的数量。

自动扩缩，可让 Spanner 自动添加和移除计算容量。Spanner 企业版和企业 Plus 版中提供了托管式自动扩缩器。如需详细了解托管式自动扩缩器，请参阅 Spanner 的托管式自动扩缩器。配置以下托管式自动扩缩器选项：

下限表示缩容时的下限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定下限。

上限表示扩容时的上限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定上限。

高优先级 CPU 利用率目标表示要使用的高优先级 CPU 的目标百分比。如需了解详情，请参阅确定 CPU 利用率目标。

存储空间利用率目标表示要使用的存储空间的目标百分比。如需了解详情，请参阅确定存储空间利用率目标。

可选：如果您选择自动扩缩作为扩缩模式，则可以点击显示非对称自动扩缩选项下拉菜单，以便独立于其他副本自动扩缩您的只读副本。如需了解详情，请参阅非对称只读自动扩缩。

选择要以非对称方式自动扩缩的只读副本。

配置以下非对称自动扩缩器选项：

下限表示缩容时的下限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定下限。

上限表示扩容时的上限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定上限。

高优先级 CPU 利用率目标表示要使用的高优先级 CPU 的目标百分比。如需了解详情，请参阅确定 CPU 利用率目标。

在备份下，启用默认备份时间表复选框默认处于选中状态。如需停用默认备份时间表，请取消选中该复选框。启用后，实例中的所有新数据库都会每 24 小时创建一次完整备份。这些备份会保留 7 天。
您可以随时修改或删除默认备份时间表。如需了解详情，请参阅默认备份时间表。

点击创建以创建实例。

gcloud 使用 gcloud spanner instances create 命令创建一个实例。将计算容量指定为您希望对实例使用的节点数或处理单元数。

gcloud spanner instances create INSTANCE_ID \ --edition=EDITION \ --config=INSTANCE_CONFIG \ --description=INSTANCE_DESCRIPTION \ --default-backup-schedule-type=DEFAULT_BACKUP_SCHEDULE_TYPE \ --nodes=NODE_COUNT

或

gcloud spanner instances create INSTANCE_ID \ --edition=EDITION \ --config=INSTANCE_CONFIG \ --description=INSTANCE_DESCRIPTION \ --default-backup-schedule-type=DEFAULT_BACKUP_SCHEDULE_TYPE \ --processing-units=PROCESSING_UNIT_COUNT

替换以下内容：

INSTANCE-ID：在您的 Google Cloud 项目中唯一的永久性标识符。您以后无法更改实例 ID。

INSTANCE-CONFIG：实例配置的永久性标识符，该标识符定义实例的地理位置，并且会影响数据的复制方式。对于自定义实例配置，它以 custom- 开头。如需了解详情，请参阅实例配置。

INSTANCE_DESCRIPTION：要在 Google Cloud 控制台中为实例显示的名称。此实例名称在您的Google Cloud 项目中必须是唯一的。

DEFAULT_BACKUP_SCHEDULE_TYPE：实例中使用的默认备份时间表类型。必须是以下值之一：

AUTOMATIC：在实例中创建新数据库时，系统会自动创建默认备份时间表。默认备份时间表会每 24 小时创建一次完整备份。这些完整备份会保留 7 天。默认备份时间表创建完成后，您可以修改或删除。

NONE：在实例中创建新数据库时，系统不会自动创建默认备份时间表。

NODE-COUNT：实例的计算容量，以节点数表示。每个节点等于 1000 个处理单元。

PROCESSING_UNIT_COUNT：实例的计算容量，以处理单元数表示。以 100 的倍数（100、200、300 等）输入最多 1000 的数量，并以 1000 的倍数（1000、2000、3000 等）输入更大的数量。注意：如果您创建以后打算启用托管式自动扩缩器的实例，请勿使用此参数。

添加托管式自动扩缩功能

您还可以使用 gcloud spanner instances create 命令创建企业版和企业 Plus 版实例，以便使用托管式自动扩缩功能。如需了解详情，请参阅 Spanner 的托管式自动扩缩器。

使用以下命令创建具有托管式自动扩缩器的实例。

gcloud spanner instances create INSTANCE_ID \ --edition=EDITION \ --config=INSTANCE_CONFIG \ --description=INSTANCE_DESCRIPTION \ --autoscaling-min-processing-units=MINIMUM_PROCESSING_UNITS \ --autoscaling-max-processing-units=MAXIMUM_PROCESSING_UNITS \ --autoscaling-high-priority-cpu-target=CPU_PERCENTAGE \ --autoscaling-storage-target=STORAGE_PERCENTAGE \ [--asymmetric-autoscaling-option \ location=ASYMMETRIC_AUTOSCALING_LOCATION,min_nodes=ASYMMETRIC_AUTOSCALING_MIN,\ max_nodes=ASYMMETRIC_AUTOSCALING_MAX,high_priority_cpu_target=ASYMMETRIC_CPU_TARGET]

或

gcloud spanner instances create INSTANCE_ID \ --edition=EDITION \ --config=INSTANCE_CONFIG \ --description=INSTANCE_DESCRIPTION \ --autoscaling-min-nodes=MINIMUM_NODES \ --autoscaling-max-nodes=MAXIMUM_NODES \ --autoscaling-high-priority-cpu-target=CPU_PERCENTAGE \ --autoscaling-storage-target=STORAGE_PERCENTAGE \ [--asymmetric-autoscaling-option \ location=ASYMMETRIC_AUTOSCALING_LOCATION,min_nodes=ASYMMETRIC_AUTOSCALING_MIN,\ max_nodes=ASYMMETRIC_AUTOSCALING_MAX,high_priority_cpu_target=ASYMMETRIC_CPU_TARGET]

替换以下内容：

INSTANCE-ID：在您的 Google Cloud 项目中唯一的永久性标识符。您以后无法更改实例 ID。

INSTANCE-CONFIG：实例配置的永久性标识符，该标识符定义实例的地理位置，并且会影响数据的复制方式。对于自定义实例配置，它以 custom- 开头。如需了解详情，请参阅实例配置。

INSTANCE-DESCRIPTION：要在 Google Cloud 控制台中为实例显示的名称。此实例名称在您的Google Cloud 项目中必须是唯一的。

MINIMUM_PROCESSING_UNITS、MINIMUM_NODES：缩容时的处理单元或节点数下限。如需了解详情，请参阅确定下限。

MAXIMUM_PROCESSING_UNITS、MAXIMUM_NODES：扩容时的处理单元或节点数上限。如需了解详情，请参阅确定上限。

CPU_PERCENTAGE：要使用的高优先级 CPU 的目标百分比，介于 10% 到 90% 之间。如果您要针对费用进行优化，请使用较高的百分比。如需了解详情，请参阅确定 CPU 利用率目标。

STORAGE_PERCENTAGE：要使用的存储空间的目标百分比，介于 10% 到 99% 之间。如需了解详情，请参阅确定存储空间利用率目标。

可选标志：

--asymmetric-autoscaling-option：使用此标志可启用非对称自动扩缩。替换以下参数：

ASYMMETRIC_AUTOSCALING_LOCATION：如果使用了该标志，则必须使用此参数。您要以非对称方式扩缩的只读区域的位置。

ASYMMETRIC_AUTOSCALING_MIN：可选参数。缩容时的节点数下限。

ASYMMETRIC_AUTOSCALING_MAX：可选参数。扩容时的节点数上限。

ASYMMETRIC_CPU_TARGET：可选参数。要使用的高优先级 CPU 的目标百分比，介于 10% 到 90% 之间。如果您要针对费用进行优化，请使用较高的百分比。

使用自定义配置的示例

如需在基本区域级实例配置 us-central1 中创建实例 test-instance，请运行以下命令：

gcloud spanner instances create test-instance --edition=STANDARD --config=regional-us-central1 \ --description="Test Instance" --nodes=1

如需在自定义多区域实例配置 custom-eur6 中创建实例 custom-eur6-instance，请先创建自定义实例配置。

然后运行以下命令：

gcloud spanner instances create custom-eur6-instance --edition=ENTERPRISE_PLUS --config=custom-eur6 \ --description="Instance with custom read-only" --nodes=1

运行上述任一命令后，您应该会看到类似于以下示例的消息：

Creating instance...done.

C++

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

void CreateInstance(google::cloud::spanner_admin::InstanceAdminClient client, std::string const& project_id, std::string const& instance_id, std::string const& display_name, std::string const& config_id) { namespace spanner = ::google::cloud::spanner;
spanner::Instance in(project_id, instance_id);

auto project = google::cloud::Project(project_id);
std::string config_name = project.FullName() + "/instanceConfigs/" + config_id;
auto instance = client .CreateInstance(spanner::CreateInstanceRequestBuilder(in, config_name) .SetDisplayName(display_name) .SetNodeCount(1) .SetLabels({{"cloud_spanner_samples", "true"}}) .Build()) .get();
if (!instance) throw std::move(instance).status();
std::cout DebugString();
}

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

using Google.Api.Gax.ResourceNames;
using Google.Cloud.Spanner.Admin.Instance.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.LongRunning;
using System;
using System.Threading.Tasks;

public class CreateInstanceAsyncSample { public async Task CreateInstanceAsync( string projectId, string instanceId, Instance.Types.Edition edition = Instance.Types.Edition.Standard) { // Create the InstanceAdminClient instance.
InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();

// Initialize request parameters.
Instance instance = new Instance { InstanceName = InstanceName.FromProjectInstance(projectId, instanceId), ConfigAsInstanceConfigName = InstanceConfigName.FromProjectInstanceConfig(projectId, "regional-us-central1"), DisplayName = "This is a display name.", NodeCount = 1, Labels = { { "cloud_spanner_samples", "true" }, }, Edition = edition, };
ProjectName projectName = ProjectName.FromProject(projectId);

// Make the CreateInstance request.
Operation response = await instanceAdminClient.CreateInstanceAsync(projectName, instanceId, instance);

Console.WriteLine("Waiting for the operation to finish.");

// Poll until the returned long-running operation is complete.
Operation completedResponse = await response.PollUntilCompletedAsync();

if (completedResponse.IsFaulted) { Console.WriteLine($"Error while creating instance: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine($"Instance created successfully.");

return completedResponse.Result;
} }

创建不带默认备份时间表的实例

using Google.Api.Gax.ResourceNames;
using Google.Cloud.Spanner.Admin.Instance.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.LongRunning;
using System;
using System.Threading.Tasks;

public class CreateInstanceWithoutDefaultBackupSchedulesAsyncSample { public async Task CreateInstanceWithoutDefaultBackupSchedulesAsync(string projectId, string instanceId) { // Create the InstanceAdminClient instance.
InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();

// Initialize request parameters.
Instance instance = new Instance { InstanceName = InstanceName.FromProjectInstance(projectId, instanceId), ConfigAsInstanceConfigName = InstanceConfigName.FromProjectInstanceConfig(projectId, "regional-me-central2"), DisplayName = "This is a display name.", NodeCount = 1, Labels = { { "cloud_spanner_samples", "true" }, }, DefaultBackupScheduleType = Instance.Types.DefaultBackupScheduleType.None, };
ProjectName projectName = ProjectName.FromProject(projectId);

// Make the CreateInstance request.
Operation response = await instanceAdminClient.CreateInstanceAsync(projectName, instanceId, instance);

Console.WriteLine("Waiting for the operation to finish.");

// Poll until the returned long-running operation is complete.
Operation completedResponse = await response.PollUntilCompletedAsync();

if (completedResponse.IsFaulted) { Console.WriteLine($"Error while creating instance: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine($"Instance created successfully.");
return completedResponse.Result;
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

func createInstance(w io.Writer, projectID, instanceID string) error { // projectID := "my-project-id" // instanceID := "my-instance" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

op, err := instanceAdmin.CreateInstance(ctx, &instancepb.CreateInstanceRequest{ Parent:     fmt.Sprintf("projects/%s", projectID), InstanceId: instanceID, Instance: &instancepb.Instance{ Config:      fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, "regional-us-central1"), DisplayName: instanceID, NodeCount:   1, Labels:      map[string]string{"cloud_spanner_samples": "true"}, Edition:     instancepb.Instance_STANDARD, }, }) if err != nil { return fmt.Errorf("could not create instance %s: %w", fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), err) } // Wait for the instance creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance creation to finish failed: %w", err) } // The instance may not be ready to serve yet.
if i.State != instancepb.Instance_READY { fmt.Fprintf(w, "instance state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Created instance [%s]\n", instanceID) return nil }

使用 Go 创建具有托管式自动扩缩功能的实例

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/genproto/protobuf/field_mask" )

// Example of creating an autoscaling instance with Go.
// projectID is the ID of the project that the new instance will be in.
// instanceID is the ID of the new instance to be created.
func createInstanceWithAutoscalingConfig(w io.Writer, projectID, instanceID string) error { // projectID := "my-project-id" // instanceID := "my-instance" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return fmt.Errorf("could not create instance admin client for project %s: %w", projectID, err) } defer instanceAdmin.Close()

instanceName := fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID) fmt.Fprintf(w, "Creating instance %s.", instanceName)

op, err := instanceAdmin.CreateInstance(ctx, &instancepb.CreateInstanceRequest{ Parent:     fmt.Sprintf("projects/%s", projectID), InstanceId: instanceID, Instance: &instancepb.Instance{ Config:      fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, "regional-us-central1"), DisplayName: "Create instance example", AutoscalingConfig: &instancepb.AutoscalingConfig{ AutoscalingLimits: &instancepb.AutoscalingConfig_AutoscalingLimits{ MinLimit: &instancepb.AutoscalingConfig_AutoscalingLimits_MinNodes{ MinNodes: 1, }, MaxLimit: &instancepb.AutoscalingConfig_AutoscalingLimits_MaxNodes{ MaxNodes: 2, }, }, AutoscalingTargets: &instancepb.AutoscalingConfig_AutoscalingTargets{ HighPriorityCpuUtilizationPercent: 65, StorageUtilizationPercent:         95, }, }, Labels:  map[string]string{"cloud_spanner_samples": "true"}, Edition: instancepb.Instance_ENTERPRISE_PLUS, }, }) if err != nil { return fmt.Errorf("could not create instance %s: %w", instanceName, err) } fmt.Fprintf(w, "Waiting for operation on %s to complete...", instanceID) // Wait for the instance creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance creation to finish failed: %w", err) } // The instance may not be ready to serve yet.
if i.State != instancepb.Instance_READY { fmt.Fprintf(w, "instance state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Created instance [%s].\n", instanceID)

instance, err := instanceAdmin.GetInstance(ctx, &instancepb.GetInstanceRequest{ Name: instanceName, // Get the autoscaling_config field from the newly created instance.
FieldMask: &field_mask.FieldMask{Paths: []string{"autoscaling_config"}}, }) if err != nil { return fmt.Errorf("failed to get instance [%s]: %w", instanceName, err) } fmt.Fprintf(w, "Instance %s has autoscaling_config: %s.", instanceID, instance.AutoscalingConfig) return nil }

使用 Go 创建具有非对称只读自动扩缩功能的实例

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/genproto/protobuf/field_mask" )

// createInstanceWithAsymmetricAutoscalingConfig is a code snippet to show // an example of creating an asymmetric autoscaling enabled instance in Go.
// // projectID is the ID of the project that the new instance will be in.
// instanceID is the ID of the new instance to be created.
func createInstanceWithAsymmetricAutoscalingConfig(w io.Writer, projectID, instanceID string) error { ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return fmt.Errorf("could not create instance admin client for project %s: %w", projectID, err) } defer instanceAdmin.Close()

instanceName := fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID) fmt.Fprintf(w, "Creating instance %s.", instanceName)

op, err := instanceAdmin.CreateInstance(ctx, &instancepb.CreateInstanceRequest{ Parent:     fmt.Sprintf("projects/%s", projectID), InstanceId: instanceID, Instance: &instancepb.Instance{ Config:      fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, "nam-eur-asia3"), DisplayName: "Create instance example", AutoscalingConfig: &instancepb.AutoscalingConfig{ AutoscalingLimits: &instancepb.AutoscalingConfig_AutoscalingLimits{ MinLimit: &instancepb.AutoscalingConfig_AutoscalingLimits_MinNodes{ MinNodes: 1, }, MaxLimit: &instancepb.AutoscalingConfig_AutoscalingLimits_MaxNodes{ MaxNodes: 10, }, }, AutoscalingTargets: &instancepb.AutoscalingConfig_AutoscalingTargets{ HighPriorityCpuUtilizationPercent: 65, StorageUtilizationPercent:         95, }, // Read-only replicas in europe-west1, europe-west4, and asia-east1 are autoscaled // independly from other replicas based on the usage in the respective region.
AsymmetricAutoscalingOptions: []*instancepb.AutoscalingConfig_AsymmetricAutoscalingOption{ &instancepb.AutoscalingConfig_AsymmetricAutoscalingOption{ ReplicaSelection: &instancepb.ReplicaSelection{ Location: "europe-west1", }, }, &instancepb.AutoscalingConfig_AsymmetricAutoscalingOption{ ReplicaSelection: &instancepb.ReplicaSelection{ Location: "europe-west4", }, }, &instancepb.AutoscalingConfig_AsymmetricAutoscalingOption{ ReplicaSelection: &instancepb.ReplicaSelection{ Location: "asia-east1", }, }, }, }, Labels:  map[string]string{"cloud_spanner_samples": "true"}, Edition: instancepb.Instance_ENTERPRISE_PLUS, }, }) if err != nil { return fmt.Errorf("could not create instance %s: %w", instanceName, err) } fmt.Fprintf(w, "Waiting for operation on %s to complete...", instanceID) // Wait for the instance creation to finish.
i, err := op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance creation to finish failed: %w", err) } // The instance may not be ready to serve yet.
if i.State != instancepb.Instance_READY { fmt.Fprintf(w, "instance state is not READY yet. Got state %v\n", i.State) } fmt.Fprintf(w, "Created instance [%s].\n", instanceID)

instance, err := instanceAdmin.GetInstance(ctx, &instancepb.GetInstanceRequest{ Name: instanceName, // Get the autoscaling_config field from the newly created instance.
FieldMask: &field_mask.FieldMask{Paths: []string{"autoscaling_config"}}, }) if err != nil { return fmt.Errorf("failed to get instance [%s]: %w", instanceName, err) } fmt.Fprintf(w, "Instance %s has autoscaling_config: %s.", instanceID, instance.AutoscalingConfig) return nil }

创建不带默认备份时间表的实例

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" )

// createInstanceWithoutDefaultBackupSchedule creates instance with default backup schedule disabled.
func createInstanceWithoutDefaultBackupSchedule(w io.Writer, projectID, instanceID string) error { // projectID := "my-project-id" // instanceID := "my-instance" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

// Create an instance without default backup schedule, whicn means no default backup schedule will // be created automatically on creation of a database within the instance.
req := &instancepb.CreateInstanceRequest{ Parent:     fmt.Sprintf("projects/%s", projectID), InstanceId: instanceID, Instance: &instancepb.Instance{ Config:                    fmt.Sprintf("projects/%s/instanceConfigs/%s", projectID, "regional-us-central1"), DisplayName:               instanceID, NodeCount:                 1, Labels:                    map[string]string{"cloud_spanner_samples": "true"}, DefaultBackupScheduleType: instancepb.Instance_NONE, }, }

op, err := instanceAdmin.CreateInstance(ctx, req) if err != nil { return fmt.Errorf("could not create instance %s: %w", fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), err) } // Wait for the instance creation to finish.  For more information about instances, see // https://cloud.google.com/spanner/docs/instances.
instance, err := op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance creation to finish failed: %w", err) } // The instance may not be ready to serve yet.
if instance.State != instancepb.Instance_READY { fmt.Fprintf(w, "instance state is not READY yet. Got state %v\n", instance.State) } fmt.Fprintf(w, "Created instance [%s]\n", instanceID) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.CreateInstanceRequest;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.ProjectName;
import java.util.concurrent.ExecutionException;

class CreateInstanceExample {

static void createInstance() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
createInstance(projectId, instanceId);
}

static void createInstance(String projectId, String instanceId) { // Set Instance configuration.
int nodeCount = 2;
String displayName = "Descriptive name";

// Create an Instance object that will be used to create the instance.
Instance instance = Instance.newBuilder() .setDisplayName(displayName) .setEdition(Instance.Edition.STANDARD) .setNodeCount(nodeCount) .setConfig(InstanceConfigName.of(projectId, "regional-us-east4").toString()) .build();

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) {

// Wait for the createInstance operation to finish.
Instance createdInstance = instanceAdminClient .createInstanceAsync( CreateInstanceRequest.newBuilder() .setParent(ProjectName.of(projectId).toString()) .setInstanceId(instanceId) .setInstance(instance) .build()) .get();
System.out.printf("Instance %s was successfully created%n", createdInstance.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Creating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for createInstance operation to finish was interrupted");
} } }

使用 Java 创建具有托管式自动扩缩功能的实例

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.AutoscalingConfig;
import com.google.spanner.admin.instance.v1.CreateInstanceRequest;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.ProjectName;
import com.google.spanner.admin.instance.v1.ReplicaSelection;
import java.util.concurrent.ExecutionException;

class CreateInstanceWithAsymmetricAutoscalingConfigExample {

static void createInstance() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
createInstance(projectId, instanceId);
}

static void createInstance(String projectId, String instanceId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { // Set Instance configuration.
String configId = "nam-eur-asia3";
String displayName = "Descriptive name";

// Create an autoscaling config.
// When autoscaling_config is enabled, node_count and processing_units fields // need not be specified.
// The read-only replicas listed in the asymmetric autoscaling options scale independently // from other replicas.
AutoscalingConfig autoscalingConfig = AutoscalingConfig.newBuilder() .setAutoscalingLimits( AutoscalingConfig.AutoscalingLimits.newBuilder().setMinNodes(1).setMaxNodes(2)) .setAutoscalingTargets( AutoscalingConfig.AutoscalingTargets.newBuilder() .setHighPriorityCpuUtilizationPercent(65) .setStorageUtilizationPercent(95)) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("europe-west1"))) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("europe-west4"))) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("asia-east1"))) .build();
Instance instance = Instance.newBuilder() .setAutoscalingConfig(autoscalingConfig) .setDisplayName(displayName) .setConfig( InstanceConfigName.of(projectId, configId).toString()) .build();

// Creates a new instance System.out.printf("Creating instance %s.%n", instanceId);
try { // Wait for the createInstance operation to finish.
Instance instanceResult = instanceAdminClient.createInstanceAsync( CreateInstanceRequest.newBuilder() .setParent(ProjectName.of(projectId).toString()) .setInstanceId(instanceId) .setInstance(instance) .build()).get();
System.out.printf("Asymmetric Autoscaling instance %s was successfully created%n", instanceResult.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Creating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for createInstance operation to finish was interrupted");
} } } }

使用 Java 创建具有非对称只读自动扩缩功能的实例

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.AutoscalingConfig;
import com.google.spanner.admin.instance.v1.CreateInstanceRequest;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.ProjectName;
import com.google.spanner.admin.instance.v1.ReplicaSelection;
import java.util.concurrent.ExecutionException;

class CreateInstanceWithAsymmetricAutoscalingConfigExample {

static void createInstance() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
createInstance(projectId, instanceId);
}

static void createInstance(String projectId, String instanceId) { try (Spanner spanner = SpannerOptions.newBuilder() .setProjectId(projectId) .build() .getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) { // Set Instance configuration.
String configId = "nam-eur-asia3";
String displayName = "Descriptive name";

// Create an autoscaling config.
// When autoscaling_config is enabled, node_count and processing_units fields // need not be specified.
// The read-only replicas listed in the asymmetric autoscaling options scale independently // from other replicas.
AutoscalingConfig autoscalingConfig = AutoscalingConfig.newBuilder() .setAutoscalingLimits( AutoscalingConfig.AutoscalingLimits.newBuilder().setMinNodes(1).setMaxNodes(2)) .setAutoscalingTargets( AutoscalingConfig.AutoscalingTargets.newBuilder() .setHighPriorityCpuUtilizationPercent(65) .setStorageUtilizationPercent(95)) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("europe-west1"))) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("europe-west4"))) .addAsymmetricAutoscalingOptions( AutoscalingConfig.AsymmetricAutoscalingOption.newBuilder() .setReplicaSelection(ReplicaSelection.newBuilder().setLocation("asia-east1"))) .build();
Instance instance = Instance.newBuilder() .setAutoscalingConfig(autoscalingConfig) .setDisplayName(displayName) .setConfig( InstanceConfigName.of(projectId, configId).toString()) .build();

// Creates a new instance System.out.printf("Creating instance %s.%n", instanceId);
try { // Wait for the createInstance operation to finish.
Instance instanceResult = instanceAdminClient.createInstanceAsync( CreateInstanceRequest.newBuilder() .setParent(ProjectName.of(projectId).toString()) .setInstanceId(instanceId) .setInstance(instance) .build()).get();
System.out.printf("Asymmetric Autoscaling instance %s was successfully created%n", instanceResult.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Creating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for createInstance operation to finish was interrupted");
} } } }

创建不带默认备份时间表的实例

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.spanner.admin.instance.v1.CreateInstanceRequest;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.ProjectName;
import java.util.concurrent.ExecutionException;

class CreateInstanceWithoutDefaultBackupSchedulesExample {

static void createInstanceWithoutDefaultBackupSchedules() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
createInstanceWithoutDefaultBackupSchedules(projectId, instanceId);
}

static void createInstanceWithoutDefaultBackupSchedules(String projectId, String instanceId) { // Set Instance configuration.
int nodeCount = 2;
String displayName = "Descriptive name";

// Create an Instance object that will be used to create the instance.
Instance instance = Instance.newBuilder() .setDisplayName(displayName) .setDefaultBackupScheduleType(Instance.DefaultBackupScheduleType.NONE) .setNodeCount(nodeCount) .setConfig(InstanceConfigName.of(projectId, "regional-us-east4").toString()) .build();

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) {

// Wait for the createInstance operation to finish.
Instance createdInstance = instanceAdminClient .createInstanceAsync( CreateInstanceRequest.newBuilder() .setParent(ProjectName.of(projectId).toString()) .setInstanceId(instanceId) .setInstance(instance) .build()) .get();
System.out.printf("Instance %s was successfully created%n", createdInstance.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Creating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for createInstance operation to finish was interrupted");
} } }

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = await spanner.getInstanceAdminClient();
/**
 * TODO(developer): Uncomment the following lines before running the sample.
**/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';

// Creates a new instance try { console.log( `Creating instance ${instanceAdminClient.instancePath( projectId, instanceId, )}.`, );
const [operation] = await instanceAdminClient.createInstance({ instanceId: instanceId, parent: instanceAdminClient.projectPath(projectId), instance: { config: instanceAdminClient.instanceConfigPath( projectId, 'regional-us-central1', ), nodeCount: 1, displayName: 'Display name for the instance.', labels: { cloud_spanner_samples: 'true', created: Math.round(Date.now() / 1000).toString(), // current time }, edition:
protos.google.spanner.admin.instance.v1.Instance.Edition.STANDARD, //optional }, });

console.log(`Waiting for operation on ${instanceId} to complete...`);
await operation.promise();

console.log(`Created instance ${instanceId}.`);
} catch (err) { console.error('ERROR:', err);
}

注意：Node.js 的旧版客户端库接口代码示例已在 GitHub 中归档。

使用 Node.js 创建具有托管式自动扩缩功能的实例

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

// Get the instance admin client const instanceAdminClient = spanner.getInstanceAdminClient();

const autoscalingConfig = protos.google.spanner.admin.instance.v1.AutoscalingConfig.create({ // Only one of minNodes/maxNodes or minProcessingUnits/maxProcessingUnits can be set.
autoscalingLimits:
protos.google.spanner.admin.instance.v1.AutoscalingConfig.AutoscalingLimits.create( { minNodes: 1, maxNodes: 2, }, ), // highPriorityCpuUtilizationPercent and storageUtilizationPercent are both // percentages and must lie between 0 and 100.
autoscalingTargets:
protos.google.spanner.admin.instance.v1.AutoscalingConfig.AutoscalingTargets.create( { highPriorityCpuUtilizationPercent: 65, storageUtilizationPercent: 95, }, ), });

// Creates a new instance with autoscaling configuration // When autoscalingConfig is enabled, nodeCount and processingUnits fields // need not be specified.
try { console.log( `Creating instance ${instanceAdminClient.instancePath( projectId, instanceId, )}.`, );
const [operation] = await instanceAdminClient.createInstance({ instanceId: instanceId, parent: instanceAdminClient.projectPath(projectId), instance: { config: instanceAdminClient.instanceConfigPath( projectId, 'regional-us-central1', ), displayName: 'Display name for the instance.', autoscalingConfig: autoscalingConfig, labels: { cloud_spanner_samples: 'true', created: Math.round(Date.now() / 1000).toString(), // current time }, // Managed autoscaler is available only for ENTERPRISE edition edition:
protos.google.spanner.admin.instance.v1.Instance.Edition.ENTERPRISE, }, });

console.log(`Waiting for operation on ${instanceId} to complete...`);
await operation.promise();
console.log(`Created instance ${instanceId}.`);

// get instance metadata const [metadata] = await instanceAdminClient.getInstance({ name: instanceAdminClient.instancePath(projectId, instanceId), });
console.log( `Autoscaling configurations of ${instanceId} are:  ` + '\n' + `Min nodes: ${metadata.autoscalingConfig.autoscalingLimits.minNodes} ` + 'nodes.' + '\n' + `Max nodes: ${metadata.autoscalingConfig.autoscalingLimits.maxNodes}` + ' nodes.' + '\n' + `High priority cpu utilization percent: ${metadata.autoscalingConfig.autoscalingTargets.highPriorityCpuUtilizationPercent}.` + '\n' + `Storage utilization percent: ${metadata.autoscalingConfig.autoscalingTargets.storageUtilizationPercent}.`, );
} catch (err) { console.error('ERROR:', err);
}

创建不带默认备份时间表的实例

/**
 * TODO(developer): Uncomment the following lines before running the sample.
**/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = await spanner.getInstanceAdminClient();
// Creates a new instance try { const [operation] = await instanceAdminClient.createInstance({ instanceId: instanceId, parent: instanceAdminClient.projectPath(projectId), instance: { config: instanceAdminClient.instanceConfigPath( projectId, 'regional-me-central2', ), nodeCount: 1, displayName: 'Display name for the instance.', labels: { cloud_spanner_samples: 'true', created: Math.round(Date.now() / 1000).toString(), // current time }, defaultBackupScheduleType:
protos.google.spanner.admin.instance.v1.Instance .DefaultBackupScheduleType.NONE, }, });
await operation.promise();

console.log( `Created instance ${instanceId} without default backup schedules.`, );
} catch (err) { console.error('ERROR:', err);
}

PHP

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

use Google\Cloud\Spanner\Admin\Instance\V1\Client\InstanceAdminClient;
use Google\Cloud\Spanner\Admin\Instance\V1\CreateInstanceRequest;
use Google\Cloud\Spanner\Admin\Instance\V1\Instance;

/**
 * Creates an instance.
 * Example:
 * ```
 * create_instance($projectId, $instanceId);
 * ```
*
 * @param string $projectId  The Spanner project ID.
 * @param string $instanceId The Spanner instance ID.
*/ function create_instance(string $projectId, string $instanceId): void { $instanceAdminClient = new InstanceAdminClient();
$parent = InstanceAdminClient::projectName($projectId);
$instanceName = InstanceAdminClient::instanceName($projectId, $instanceId);
$configName = $instanceAdminClient->instanceConfigName($projectId, 'regional-us-central1');
$instance = (new Instance()) ->setName($instanceName) ->setConfig($configName) ->setDisplayName('dispName') ->setNodeCount(1);

$operation = $instanceAdminClient->createInstance( (new CreateInstanceRequest()) ->setParent($parent) ->setInstanceId($instanceId) ->setInstance($instance) );

print('Waiting for operation to complete...' . PHP_EOL);
$operation->pollUntilComplete();

printf('Created instance %s' . PHP_EOL, $instanceId);
}

注意：PHP 的旧版客户端库接口代码示例已在 GitHub 中归档。

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

def create_instance(instance_id):
"""Creates an instance.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client()

config_name = "{}/instanceConfigs/regional-us-central1".format( spanner_client.project_name )

operation = spanner_client.instance_admin_api.create_instance( parent=spanner_client.project_name, instance_id=instance_id, instance=spanner_instance_admin.Instance( config=config_name, display_name="This is a display name.", node_count=1, labels={ "cloud_spanner_samples": "true", "sample_name": "snippets-create_instance-explicit", "created": str(int(time.time())), }, edition=spanner_instance_admin.Instance.Edition.STANDARD,  # Optional ), )

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print("Created instance {}".format(instance_id))

注意：Python 的旧版客户端库接口代码示例已在 GitHub 中归档。

使用 Python 创建具有托管式自动扩缩功能的实例

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

def create_instance_with_autoscaling_config(instance_id):
"""Creates a Cloud Spanner instance with an autoscaling configuration.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client()

config_name = "{}/instanceConfigs/regional-us-central1".format( spanner_client.project_name )

autoscaling_config = spanner_instance_admin.AutoscalingConfig(
# Only one of minNodes/maxNodes or minProcessingUnits/maxProcessingUnits can be set.
autoscaling_limits=spanner_instance_admin.AutoscalingConfig.AutoscalingLimits( min_nodes=1, max_nodes=2, ),
# highPriorityCpuUtilizationPercent and storageUtilizationPercent are both
# percentages and must lie between 0 and 100.
autoscaling_targets=spanner_instance_admin.AutoscalingConfig.AutoscalingTargets( high_priority_cpu_utilization_percent=65, storage_utilization_percent=95, ), )

#  Creates a new instance with autoscaling configuration
#  When autoscalingConfig is enabled, nodeCount and processingUnits fields
#  need not be specified.
request = spanner_instance_admin.CreateInstanceRequest( parent=spanner_client.project_name, instance_id=instance_id, instance=spanner_instance_admin.Instance( config=config_name, display_name="This is a display name.", autoscaling_config=autoscaling_config, labels={ "cloud_spanner_samples": "true", "sample_name": "snippets-create_instance_with_autoscaling_config", "created": str(int(time.time())), }, edition=spanner_instance_admin.Instance.Edition.ENTERPRISE,  # Optional ), )

operation = spanner_client.instance_admin_api.create_instance(request=request)

print("Waiting for operation to complete...") instance = operation.result(OPERATION_TIMEOUT_SECONDS)

print( "Created instance {} with {} autoscaling config".format( instance_id, instance.autoscaling_config ) )

创建不带默认备份时间表的实例

def create_instance_without_default_backup_schedules(instance_id):
spanner_client = spanner.Client() config_name = "{}/instanceConfigs/regional-me-central2".format( spanner_client.project_name )

operation = spanner_client.instance_admin_api.create_instance( parent=spanner_client.project_name, instance_id=instance_id, instance=spanner_instance_admin.Instance( config=config_name, display_name="This is a display name.", node_count=1, default_backup_schedule_type=spanner_instance_admin.Instance.DefaultBackupScheduleType.NONE,  # Optional ), )

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print("Created instance {} without default backup schedules".format(instance_id))

Ruby

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

# project_id  = "Your Google Cloud project ID"
# instance_id = "Your Spanner instance ID"
# instance_config_id = "Your Spanner InstanceConfig ID"

require "google/cloud/spanner" require "google/cloud/spanner/admin/instance"

instance_admin_client = Google::Cloud::Spanner::Admin::Instance.instance_admin

project_path = instance_admin_client.project_path project: project_id instance_path = instance_admin_client.instance_path project: project_id, instance: instance_id instance_config_path = instance_admin_client.instance_config_path project: project_id, instance_config: instance_config_id

job = instance_admin_client.create_instance parent: project_path, instance_id: instance_id, instance: { name: instance_path, config: instance_config_path, display_name: instance_id, node_count: 2, labels: { cloud_spanner_samples: "true" } }

puts "Waiting for create instance operation to complete"

job.wait_until_done!

if job.error?
puts job.error else puts "Created instance #{instance_id}" end

列出实例

您可以显示 Spanner 实例的列表。

控制台 前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

Google Cloud 控制台会显示 Spanner 实例的列表，以及每个实例的 ID、显示名称、配置和计算容量（以处理单元数和节点数表示）。

gcloud 使用 gcloud spanner instances list 命令：

gcloud spanner instances list

gcloud CLI 会输出 Spanner 实例的列表，以及每个实例的 ID、显示名称、配置和计算容量。

修改实例

以下部分介绍了如何升级实例的版本，以及如何更改实例的显示名称、计算容量和默认备份时间表类型。您无法更改实例 ID 或实例配置（但可以移动实例）。

升级版本

您可以将标准版实例升级到更高层级的版本。标准版实例可以升级到企业版或企业 Plus 版。企业版实例可以升级到企业 Plus 版。版本升级大约需要 10 分钟来完成，且停机时间为零。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要升级的实例的名称。

点击版本类型旁边的升级。

在实例版本页面中的更新版本下，为您的实例选择新的更高层级版本。

点击保存。

gcloud 使用 gcloud spanner instances update 命令升级实例的版本：

gcloud spanner instances update INSTANCE_ID --edition=EDITION \ [--async]

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

EDITION：为实例指定新的更高层级版本。如需了解详情，请参阅 Spanner 版本概览。

可选标志：

--async：如果您希望请求立即返回结果，而无需等待正在进行的操作完成，请使用此标志。您可以运行 gcloud spanner operations describe 来检查请求的状态。

Go

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/genproto/protobuf/field_mask" )

func updateInstance(w io.Writer, projectID, instanceID string) error { // projectID := "my-project-id" // instanceID := "my-instance" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

req := &instancepb.UpdateInstanceRequest{ Instance: &instancepb.Instance{ Name: fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), // The edition selected for this instance.
// Different editions provide different capabilities at different price points.
// For more information, see https://cloud.google.com/spanner/docs/editions-overview.
Edition: instancepb.Instance_ENTERPRISE, }, FieldMask: &field_mask.FieldMask{ Paths: []string{"edition"}, }, } op, err := instanceAdmin.UpdateInstance(ctx, req) if err != nil { return fmt.Errorf("could not update instance %s: %w", fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), err) } // Wait for the instance update to finish.
_, err = op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance update to finish failed: %w", err) }

fmt.Fprintf(w, "Updated instance [%s]\n", instanceID) return nil }

Java

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.common.collect.Lists;
import com.google.protobuf.FieldMask;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.InstanceName;
import com.google.spanner.admin.instance.v1.UpdateInstanceRequest;
import java.util.concurrent.ExecutionException;

public class UpdateInstanceExample {

static void updateInstance() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
updateInstance(projectId, instanceId);
}

static void updateInstance(String projectId, String instanceId) { // Set Instance configuration.
int nodeCount = 2;
String displayName = "Updated name";

// Update an Instance object that will be used to update the instance.
Instance instance = Instance.newBuilder() .setName(InstanceName.of(projectId, instanceId).toString()) .setDisplayName(displayName) .setNodeCount(nodeCount) .setEdition(Instance.Edition.ENTERPRISE) .setConfig(InstanceConfigName.of(projectId, "regional-us-east4").toString()) .build();

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) {

// Wait for the updatedInstance operation to finish.
Instance updatedInstance = instanceAdminClient .updateInstanceAsync( UpdateInstanceRequest.newBuilder() .setFieldMask( FieldMask.newBuilder().addAllPaths(Lists.newArrayList("edition"))) .setInstance(instance) .build()) .get();
System.out.printf("Instance %s was successfully updated%n", updatedInstance.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Updating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for updateInstance operation to finish was interrupted");
} } }

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';

// Creates a client const spanner = new Spanner({ projectId: projectId, });

const instanceAdminClient = spanner.getInstanceAdminClient();

// Updates an instance try { console.log( `Updating instance ${instanceAdminClient.instancePath( projectId, instanceId, )}.`, );
const [operation] = await instanceAdminClient.updateInstance({ instance: { name: instanceAdminClient.instancePath(projectId, instanceId), labels: { updated: 'true', created: Math.round(Date.now() / 1000).toString(), // current time }, edition:
protos.google.spanner.admin.instance.v1.Instance.Edition.ENTERPRISE, //optional }, // Field mask specifying fields that should get updated in an Instance fieldMask: (protos.google.protobuf.FieldMask = { paths: ['labels', 'edition'], }), });

console.log(`Waiting for operation on ${instanceId} to complete...`);
await operation.promise();
console.log(`Updated instance ${instanceId}.`);
const [metadata] = await instanceAdminClient.getInstance({ name: instanceAdminClient.instancePath(projectId, instanceId), });
console.log( `Instance ${instanceId} has been updated with the ${metadata.edition} ` + 'edition.', );
} catch (err) { console.error('ERROR:', err);
}

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

def update_instance(instance_id):
"""Updates an instance.""" from google.cloud.spanner_admin_instance_v1.types import spanner_instance_admin

spanner_client = spanner.Client()

name = "{}/instances/{}".format(spanner_client.project_name, instance_id)

operation = spanner_client.instance_admin_api.update_instance( instance=spanner_instance_admin.Instance( name=name, labels={ "sample_name": "snippets-update_instance-explicit", }, edition=spanner_instance_admin.Instance.Edition.ENTERPRISE,  # Optional ), field_mask=field_mask_pb2.FieldMask(paths=["labels", "edition"]), )

print("Waiting for operation to complete...") operation.result(900)

print("Updated instance {}".format(instance_id))

降级版本

您可以将 Spanner 实例降级到更低层级的版本。您必须停止使用更高层级版本的功能才能降级。企业版实例可以降级到标准版。企业 Plus 版实例可以降级到企业版或标准版。版本降级大约需要 10 分钟来完成，且停机时间为零。

gcloud 使用 gcloud spanner instances update 命令降级实例的版本：

gcloud spanner instances update INSTANCE_ID --edition=EDITION

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

EDITION：为实例指定新的更低层级版本。如需了解详情，请参阅 Spanner 版本概览。

更改显示名称

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击您要重命名的实例的名称。

点击修改实例。

输入新的实例名称。此名称在Google Cloud 项目中必须是唯一的。

点击保存。

gcloud 使用 gcloud spanner instances update 命令：

gcloud spanner instances update INSTANCE_ID --description=INSTANCE_NAME

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

INSTANCE_NAME：要在Google Cloud 控制台中为实例显示的名称。此实例名称在您的Google Cloud 项目中必须是唯一的。

更改计算容量

您必须预配足够的计算容量，以将 CPU 利用率和存储空间利用率保持在建议的上限以下。如需了解详情，请参阅 Spanner 的配额和限制。

您可以减少 Spanner 实例的计算容量，但以下情况除外：

每个节点（1,000 个处理单元）可存储的数据不超过 10 TiB。

实例的数据存在大量分块。在这种情况下，当您减少计算容量后，Spanner 可能无法管理分块。您可以尝试逐步减小计算容量，直到找到 Spanner 管理实例的所有分块所需的最小容量。

Spanner 可以创建大量分块，以适应您的使用模式。如果您的使用模式发生变化，那么在一两周后，Spanner 可能会将一些分块合并在一起，您可以尝试减小实例的计算容量。

移除计算容量时，请在 Cloud Monitoring 中监控 CPU 利用率和请求延迟时间，以确保单区域实例的 CPU 利用率保持在 65% 以下，多区域实例中每个区域的 CPU 利用率保持在 45% 以下。移除计算容量时，您可能会遇到请求延迟时间暂时增加的情况。

如果想要增加实例的计算容量，您的Google Cloud 项目必须具有足够的配额才能添加计算容量。完成增加请求所需的时间取决于请求的大小。在大多数情况下，请求会在几分钟内完成。在极少数情况下，扩容最长可能需要 1 小时才能完成。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要更改的实例名称。

点击修改实例。

选择度量单位（处理单元或节点），然后输入数量，以更改计算容量。使用处理单元时，以 100 的倍数（100、200、300 等）输入最多 1000 的数量，并以 1000 的倍数（1000、2000、3000 等）输入更大的数量。每个节点等于 1000 个处理单元。

点击保存。

如果系统对话框提示此位置没有足够的配额来添加计算容量，请按照说明请求更高配额。

gcloud 使用 gcloud spanner instances update 命令。使用此命令时，请以节点数或处理单元数的形式指定计算容量。

gcloud spanner instances update INSTANCE_ID --nodes=NODE_COUNT [--async]

或

gcloud spanner instances update INSTANCE_ID --processing-units=PROCESSING_UNIT_COUNT [--async]

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

NODE_COUNT：实例的计算容量，以节点数表示。每个节点等于 1000 个处理单元。

PROCESSING_UNIT_COUNT：实例的计算容量，以处理单元数表示。以 100 的倍数（100、200、300 等）输入最多 1000 的数量，并以 1000 的倍数（1000、2000、3000 等）输入更大的数量。

可选标志：

--async：如果您希望请求立即返回结果，而无需等待正在进行的操作完成，请使用此标志。您可以运行 gcloud spanner operations describe 来检查请求的状态。

在实例上启用或修改托管式自动扩缩器

您可以使用 Google Cloud 控制台、gcloud CLI 或 Spanner 客户端库在 Spanner 实例上启用或修改自动扩缩功能。在现有实例上添加或更改托管式自动扩缩功能时，存在以下限制：

托管式自动扩缩器仅适用于企业版或企业 Plus 版。

您无法在进行移动的实例上启用托管式自动扩缩器。

启用托管式自动扩缩器后，您无法移动实例。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要为其启用托管式自动扩缩器的实例的名称。

点击修改实例。

在配置计算容量下，点击自动扩缩。

对于下限，请选择在缩容时使用的下限。如需了解详情，请参阅确定下限。

对于上限，请选择在扩容时使用的上限。如需了解详情，请参阅确定上限。

对于高优先级 CPU 利用率目标，请选择要使用的高优先级 CPU 的百分比。如需了解详情，请参阅确定 CPU 利用率目标。

对于存储空间利用率目标，请选择要使用的存储空间的百分比。如需了解详情，请参阅确定存储空间利用率目标。

可选：如果您选择自动扩缩作为扩缩模式，则可以点击显示非对称自动扩缩选项下拉菜单，以便独立于其他副本自动扩缩您的只读副本。

选择要以非对称方式自动扩缩的只读副本。

配置以下自动扩缩器选项：

下限表示缩容时的下限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定下限。

上限表示扩容时的上限，具体取决于您为计算容量选择的度量单位。如需了解详情，请参阅确定上限。

高优先级 CPU 利用率目标表示要使用的高优先级 CPU 的目标百分比。如需了解详情，请参阅确定 CPU 利用率目标。

点击保存。

gcloud 使用 gcloud spanner instances update 命令将托管式自动扩缩器添加到实例。如需了解详情和限制，请参阅 Google Cloud CLI 标志和限制。

您可以使用以下命令添加托管式自动扩缩器：

gcloud spanner instances update INSTANCE_ID \ --autoscaling-min-processing-units=MINIMUM_PROCESSING_UNITS \ --autoscaling-max-processing-units=MAXIMUM_PROCESSING_UNITS \ --autoscaling-high-priority-cpu-target=CPU_PERCENTAGE \ --autoscaling-storage-target=STORAGE_PERCENTAGE \ [--asymmetric-autoscaling-option \ location=ASYMMETRIC_AUTOSCALING_LOCATION,min_nodes=ASYMMETRIC_AUTOSCALING_MIN,\ max_nodes=ASYMMETRIC_AUTOSCALING_MAX,high_priority_cpu_target=ASYMMETRIC_CPU_TARGET]

或

gcloud spanner instances update INSTANCE_ID \ --autoscaling-min-processing-units=MINIMUM_NODES \ --autoscaling-max-processing-units=MAXIMUM_NODES \ --autoscaling-high-priority-cpu-target=CPU_PERCENTAGE \ --autoscaling-storage-target=STORAGE_PERCENTAGE \ [--asymmetric-autoscaling-option \ location=ASYMMETRIC_AUTOSCALING_LOCATION,min_nodes=ASYMMETRIC_AUTOSCALING_MIN,\ max_nodes=ASYMMETRIC_AUTOSCALING_MAX,high_priority_cpu_target=ASYMMETRIC_CPU_TARGET]

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

MINIMUM_PROCESSING_UNITS、MINIMUM_NODES：缩容时使用的处理单元数或节点数下限。如需了解详情，请参阅确定下限。

MAXIMUM_PROCESSING_UNITS、MAXIMUM_NODES：扩容时使用的处理单元数或节点数上限。如需了解详情，请参阅确定上限。

CPU_PERCENTAGE：要使用的高优先级 CPU 的目标百分比，介于 10% 到 90% 之间。如果您要针对费用进行优化，并且不需要所有请求都具有低延迟时间，请使用较高的百分比。如需了解详情，请参阅确定 CPU 利用率目标。

STORAGE_PERCENTAGE：要使用的存储空间的目标百分比，介于 10% 到 99% 之间。如需了解详情，请参阅确定存储空间利用率目标。

可选标志：

--asymmetric-autoscaling-option：使用此标志可启用非对称自动扩缩。替换以下参数：

ASYMMETRIC_AUTOSCALING_LOCATION：如果使用了该标志，则必须使用此参数。您要以非对称方式扩缩的只读区域的位置。

ASYMMETRIC_AUTOSCALING_MIN：可选参数。缩容时的节点数下限。

ASYMMETRIC_AUTOSCALING_MAX：可选参数。扩容时的节点数上限。

ASYMMETRIC_CPU_TARGET：可选参数。要使用的高优先级 CPU 的目标百分比，介于 10% 到 90% 之间。如果您要针对费用进行优化，请使用较高的百分比。

将托管式自动扩缩器添加到实例后，您还可以修改托管式自动扩缩器设置。例如，如果您想将处理单元数上限增加到 10000，请运行以下命令：

gcloud spanner instances update test-instance \ --autoscaling-max-processing-units=10000

将实例从使用托管式自动扩缩器更改为手动扩缩

您可以使用 Google Cloud 控制台、gcloud CLI 或 Spanner 客户端库更改 Spanner 实例是使用手动扩缩还是托管式扩缩。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要为其停用托管式自动扩缩器的实例的名称。

在选择扩缩模式下，点击手动分配。

点击保存。

gcloud 使用 gcloud spanner instances update 命令更新实例。

使用以下命令将实例从使用托管式自动扩缩器更改为手动扩缩：

gcloud spanner instances update INSTANCE_ID \ --processing-units=PROCESSING_UNIT_COUNT

或

gcloud spanner instances update INSTANCE_ID \ --nodes=NODE_COUNT

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

NODE_COUNT：实例的计算容量，以节点数表示。每个节点等于 1000 个处理单元。

PROCESSING_UNIT_COUNT：实例的计算容量，以处理单元数表示。以 100 的倍数（100、200、300 等）输入最多 1000 的数量，并以 1000 的倍数（1000、2000、3000 等）输入更大的数量。

为实例添加标签

标签可帮助您整理资源。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

选中实例对应的复选框。 页面右侧将显示信息面板。

点击信息面板中的标签标签页。然后，您可以添加、删除或更新 Spanner 实例的标签。

修改默认备份时间表类型

系统会自动为所有新实例启用默认备份时间表。您可以在创建实例时，或是以后通过修改实例，在实例中启用或停用默认备份时间表。如需了解详情，请参阅默认备份时间表。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要修改默认备份时间表的实例的名称。

点击修改实例。

在备份下，启用默认备份时间表复选框确定是否启用默认备份时间表。启用后，此实例中的所有新数据库都会创建默认备份时间表。

点击保存。

gcloud 使用 gcloud spanner instances update 命令修改默认备份时间表类型。

您可以通过运行以下命令来修改默认备份时间表类型：

gcloud spanner instances update INSTANCE_ID \ --default-backup-schedule-type=DEFAULT_BACKUP_SCHEDULE_TYPE

替换以下内容：

INSTANCE_ID：实例的永久性标识符。

DEFAULT_BACKUP_SCHEDULE_TYPE：实例中使用的默认备份时间表类型。必须是以下值之一：

AUTOMATIC：在实例中创建新数据库时，系统会自动创建默认备份时间表。默认备份时间表会每 24 小时创建一次完整备份。这些完整备份会保留 7 天。默认备份时间表创建完成后，您可以修改或删除。

NONE：在实例中创建新数据库时，系统不会自动创建默认备份时间表。

C#

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

using Google.Cloud.Spanner.Admin.Instance.V1;
using Google.Cloud.Spanner.Common.V1;
using Google.LongRunning;
using Google.Protobuf.WellKnownTypes;
using System;
using System.Threading.Tasks;

public class UpdateInstanceDefaultBackupScheduleTypeAsyncSample { public async Task UpdateInstanceDefaultBackupScheduleTypeAsync(string projectId, string instanceId) { // Create the InstanceAdminClient instance.
InstanceAdminClient instanceAdminClient = await InstanceAdminClient.CreateAsync();

// Initialize request parameters.
Instance instance = new Instance { InstanceName = InstanceName.FromProjectInstance(projectId, instanceId), DefaultBackupScheduleType = Instance.Types.DefaultBackupScheduleType.Automatic, };
FieldMask mask = new FieldMask { Paths = { "default_backup_schedule_type" } };

// Make the CreateInstance request.
Operation response = await instanceAdminClient.UpdateInstanceAsync(instance, mask);

Console.WriteLine("Waiting for the operation to finish.");

// Poll until the returned long-running operation is complete.
Operation completedResponse = await response.PollUntilCompletedAsync();

if (completedResponse.IsFaulted) { Console.WriteLine($"Error while updating instance: {completedResponse.Exception}");
throw completedResponse.Exception;
}

Console.WriteLine($"Instance updated successfully.");
return completedResponse.Result;
} }

Go

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

import (
"context" "fmt" "io"

instance "cloud.google.com/go/spanner/admin/instance/apiv1" "cloud.google.com/go/spanner/admin/instance/apiv1/instancepb" "google.golang.org/genproto/protobuf/field_mask" )

// updateInstanceDefaultBackupScheduleType updates instance default backup schedule type to AUTOMATIC.
// This means a default backup schedule will be created automatically on creation of a database within the instance.
func updateInstanceDefaultBackupScheduleType(w io.Writer, projectID, instanceID string) error { // projectID := "my-project-id" // instanceID := "my-instance" ctx := context.Background() instanceAdmin, err := instance.NewInstanceAdminClient(ctx) if err != nil { return err } defer instanceAdmin.Close()

// Updates the default backup schedule type field of an instance.  The field mask is required to // indicate which field is being updated.
req := &instancepb.UpdateInstanceRequest{ Instance: &instancepb.Instance{ Name: fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), // Controls the default backup behavior for new databases within the instance.
DefaultBackupScheduleType: instancepb.Instance_AUTOMATIC, }, FieldMask: &field_mask.FieldMask{ Paths: []string{"default_backup_schedule_type"}, }, } op, err := instanceAdmin.UpdateInstance(ctx, req) if err != nil { return fmt.Errorf("could not update instance %s: %w", fmt.Sprintf("projects/%s/instances/%s", projectID, instanceID), err) } // Wait for the instance update to finish.
_, err = op.Wait(ctx) if err != nil { return fmt.Errorf("waiting for instance update to finish failed: %w", err) }

fmt.Fprintf(w, "Updated instance [%s]\n", instanceID) return nil }

Java

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

import com.google.cloud.spanner.Spanner;
import com.google.cloud.spanner.SpannerOptions;
import com.google.cloud.spanner.admin.instance.v1.InstanceAdminClient;
import com.google.common.collect.Lists;
import com.google.protobuf.FieldMask;
import com.google.spanner.admin.instance.v1.Instance;
import com.google.spanner.admin.instance.v1.InstanceConfigName;
import com.google.spanner.admin.instance.v1.InstanceName;
import com.google.spanner.admin.instance.v1.UpdateInstanceRequest;
import java.util.concurrent.ExecutionException;

public class UpdateInstanceDefaultBackupScheduleTypeExample {

static void updateInstanceDefaultBackupScheduleType() { // TODO(developer): Replace these variables before running the sample.
String projectId = "my-project";
String instanceId = "my-instance";
updateInstanceDefaultBackupScheduleType(projectId, instanceId);
}

static void updateInstanceDefaultBackupScheduleType(String projectId, String instanceId) { // Set Instance configuration.
int nodeCount = 2;
String displayName = "Updated name";

// Update an Instance object that will be used to update the instance.
Instance instance = Instance.newBuilder() .setName(InstanceName.of(projectId, instanceId).toString()) .setDisplayName(displayName) .setNodeCount(nodeCount) .setDefaultBackupScheduleType(Instance.DefaultBackupScheduleType.AUTOMATIC) .setConfig(InstanceConfigName.of(projectId, "regional-us-east4").toString()) .build();

try (Spanner spanner = SpannerOptions.newBuilder().setProjectId(projectId).build().getService();
InstanceAdminClient instanceAdminClient = spanner.createInstanceAdminClient()) {

// Wait for the updatedInstance operation to finish.
Instance updatedInstance = instanceAdminClient .updateInstanceAsync( UpdateInstanceRequest.newBuilder() .setFieldMask( FieldMask.newBuilder() .addAllPaths(Lists.newArrayList("default_backup_schedule_type"))) .setInstance(instance) .build()) .get();
System.out.printf("Instance %s was successfully updated%n", updatedInstance.getName());
} catch (ExecutionException e) { System.out.printf( "Error: Updating instance %s failed with error message %s%n", instance.getName(), e.getMessage());
} catch (InterruptedException e) { System.out.println("Error: Waiting for updateInstance operation to finish was interrupted");
} } }

Node.js

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

/**
 * TODO(developer): Uncomment the following lines before running the sample.
*/ // const projectId = 'my-project-id';
// const instanceId = 'my-instance';

// Imports the Google Cloud client library const {Spanner, protos} = require('@google-cloud/spanner');

// Creates a client const spanner = new Spanner({ projectId: projectId, });
const instanceAdminClient = await spanner.getInstanceAdminClient();

// Updates an instance try { const [operation] = await instanceAdminClient.updateInstance({ instance: { name: instanceAdminClient.instancePath(projectId, instanceId), defaultBackupScheduleType:
protos.google.spanner.admin.instance.v1.Instance .DefaultBackupScheduleType.AUTOMATIC, // optional }, // Field mask specifying fields that should get updated in an Instance fieldMask: (protos.google.protobuf.FieldMask = { paths: ['default_backup_schedule_type'], }), });

await operation.promise();
const [metadata] = await instanceAdminClient.getInstance({ name: instanceAdminClient.instancePath(projectId, instanceId), });
console.log( `Instance ${instanceId} has been updated with the ${metadata.defaultBackupScheduleType}` + ' default backup schedule type.', );
} catch (err) { console.error('ERROR:', err);
}

Python

如需了解如何安装和使用 Spanner 客户端库，请参阅 Spanner 客户端库。

如需向 Spanner 进行身份验证，请设置应用默认凭证。
如需了解详情，请参阅为本地开发环境设置身份验证。

def update_instance_default_backup_schedule_type(instance_id):
spanner_client = spanner.Client()

name = "{}/instances/{}".format(spanner_client.project_name, instance_id)

operation = spanner_client.instance_admin_api.update_instance( instance=spanner_instance_admin.Instance( name=name, default_backup_schedule_type=spanner_instance_admin.Instance.DefaultBackupScheduleType.AUTOMATIC,  # Optional ), field_mask=field_mask_pb2.FieldMask(paths=["default_backup_schedule_type"]), )

print("Waiting for operation to complete...") operation.result(OPERATION_TIMEOUT_SECONDS)

print("Updated instance {} to have default backup schedules".format(instance_id))

移动实例 注意：您无法移动启用了托管式自动扩缩器的实例。

如需了解如何将实例从任何实例配置移至任何其他实例配置（包括在区域级配置与多区域配置之间），请参阅移动实例。

删除实例 警告：删除实例将永久移除该实例及其所有数据库。此操作过后无法撤消。此外，删除第一个免费试用实例后，您将无法再创建其他免费试用实例。您可以在每个项目生命周期内创建一个免费试用实例。

您可以使用 Google Cloud 控制台或 Google Cloud CLI 删除实例。

如果您要删除的实例包含一个或多个启用了删除防护的数据库，则必须先对该实例中的所有数据库停用删除防护，然后才能删除该实例。

控制台

前往 Google Cloud 控制台中的 Spanner 实例页面。

转到“实例”页面

点击要删除的实例名称。

点击删除实例。

按照说明进行操作，确认您要删除实例。

点击删除。

gcloud 使用 gcloud spanner instances delete 命令，并将 INSTANCE_ID 替换为实例 ID：

gcloud spanner instances delete INSTANCE_ID

停止或重启实例

Spanner 是一项全托管式数据库服务，可监控自己的底层任务和资源，包括在必要时监控和重启进程（无需停机）。由于不需要手动停止或重启给定实例，因此 Spanner 不提供执行此操作的方法。

后续步骤

了解如何使用数据操纵语言 (DML) 或 gcloud CLI 插入、更新和删除数据。

为实例及其数据库授予 Identity and Access Management 角色。

了解如何设计 Spanner 架构。

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
