# 创建和管理外键关系  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/foreign-keys/how-to

创建和管理外键关系  |  Spanner  |  Google Cloud Documentation

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

创建和管理外键关系

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

本页面介绍了如何管理数据库中的外键关系。

外键是表之间共享的列，用于建立相关数据之间的关联。当您使用外键时，Spanner 会确保维护这种关联。

下图显示了一个基本的数据库架构，其中一个表中的数据与另一个表中的数据存在关联。

图 1. 订单处理数据库架构图

图 1 中显示了架构中的三个表：

Customers 表记录了每个客户的名称。

Orders 表跟踪所有订单。

Products 表存储每个产品的产品信息。

这些表之间存在两个外键关系：

在 Orders 表和 Customers 表之间定义一个外键关系，以确保除非有相应的客户，否则无法创建订单。

Orders 表和 Products 表之间的外键关系确保了无法为不存在的产品创建订单。

本主题以之前的架构为例，讨论了可用于管理数据库中表之间关系的数据定义语言 (DDL) CONSTRAINT 语句。

默认情况下，Spanner 中的所有外键都是强制执行的外键，它们强制执行引用完整性。在 Spanner 中，您也可以选择使用信息性外键，它们不验证或强制执行引用完整性。如需了解详情，请参阅外键比较和选择要使用的外键类型。如果未指定，则本页面示例中的外键均为强制执行的外键。

向新表添加外键

假设您已在基本商品订购数据库中创建了 Customers 表。现在，您需要一个 Orders 表来存储客户所下订单的相关信息。为了确保所有订单都有效，您不希望系统将 Orders 表中没有匹配条目的行插入 Customers 表。因此，您需要一个强制执行的外键来建立这两个表之间的关系。一种选择是向新表添加 CustomerID 列，并将其用作外键以与 Customers 表中的 CustomerID 列建立关系。

当您创建一个带有外键的新表时，您可以使用 REFERENCE 来建立与另一个表的关系。包含 REFERENCE 语句的表称为引用表。REFERENCE 语句中指定的表是被引用表。REFERENCE 语句中指定的列称为引用列。

以下示例展示了如何使用 CREATE TABLE DDL 语句创建 Orders 表，并带有一个引用 Customers 表中 CustomerID 的外键限制条件。

GoogleSQL

CREATE TABLE Orders ( OrderID INT64 NOT NULL, CustomerID INT64 NOT NULL, Quantity INT64 NOT NULL, ProductID INT64 NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ) PRIMARY KEY (OrderID);

PostgreSQL

CREATE TABLE Orders ( OrderID BIGINT NOT NULL, CustomerID BIGINT NOT NULL, Quantity BIGINT NOT NULL, ProductID BIGINT NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID), PRIMARY KEY (OrderID) );

前面的语句包含一个 CONSTRAINT 子句，该子句具有以下特征：

使用 CONSTRAINT 语法命名限制条件，以便您以后可以使用所选名称轻松删除该表。

限制条件的名称为 FK_CustomerOrder。限制条件名称的范围限定为架构，并且在架构内必须具有唯一性。

您在其中定义限制条件的 Orders 表是引用表。Customers表是“被引用”表。

引用表中的引用列为 CustomerID。它引用 Customers 表中的 CustomerID 字段。如果有人尝试使用 Customers 中不存在的 CustomerID 将行插入 Orders，则该插入将失败。
注意：被引用表的被引用列通常与主键列相对应，但这不是必需的。引用表还可以引用被引用表的非主列。

以下示例显示了一个替代的表创建语句。此处定义了没有名称的外键限制条件。使用此语法时，Spanner 会为您生成名称。如需查看所有外键的名称，请参阅查看外键关系的属性。

GoogleSQL

CREATE TABLE Orders ( OrderID INT64 NOT NULL, CustomerID INT64 NOT NULL, ProductID INT64 NOT NULL, FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ) PRIMARY KEY (OrderID);

PostgreSQL

CREATE TABLE Orders ( OrderID BIGINT NOT NULL, CustomerID BIGINT NOT NULL, Quantity BIGINT NOT NULL, ProductID BIGINT NOT NULL, FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID), PRIMARY KEY (OrderID) );

向现有表中添加外键

您还希望确保客户只能订购现有的产品。如果您的表已有限制条件，则必须先删除所有限制条件。在 Spanner 中，表中的所有强制执行的限制条件都必须在单个批处理 DDL 语句中同时实现。

如果您的表没有现有限制条件，则可以使用 ALTER TABLE DDL 语句向现有 Orders 表添加强制执行的外键限制条件，如以下示例所示：

ALTER TABLE Orders ADD CONSTRAINT DB_ProductOrder FOREIGN KEY (ProductID) REFERENCES Products (ProductID);

Orders 中的引用列为 ProductID，它引用了 Products 中的 ProductID 列。如果您不介意 Spanner 为您命名这些约束条件，请使用以下语法：

ALTER TABLE Orders ADD FOREIGN KEY (ProductID) REFERENCES Products (ProductID);

向新表添加具有删除操作的外键

不妨回顾一下之前的示例，其中商品订购数据库中有一个 Customers 表，需要一个 Orders 表。您想要添加引用 Customers 表的外键限制条件。不过，您希望确保将来删除客户记录时，Spanner 也会删除该客户的所有订单。在这种情况下，您需要对外键限制条件使用 ON DELETE CASCADE 操作。

以下是用于 Orders 表的 CREATE TABLE DDL 语句，其中包含引用 Customers 表并带有 ON DELETE CASCADE 操作的外键限制条件。

GoogleSQL

CREATE TABLE Orders ( OrderID INT64 NOT NULL, CustomerID INT64 NOT NULL, Quantity INT64 NOT NULL, ProductID INT64 NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON DELETE CASCADE ) PRIMARY KEY (OrderID);

PostgreSQL

CREATE TABLE Orders ( OrderID BIGINT NOT NULL, CustomerID BIGINT NOT NULL, Quantity BIGINT NOT NULL, ProductID BIGINT NOT NULL, FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON DELETE CASCADE, PRIMARY KEY (OrderID) );

前面的语句包含一个带有 ON DELETE CASCADE 子句的外键限制条件。CustomerID 列是引用 Customers 表中 CustomerID 字段的外键。这意味着，Orders 表中的每个 CustomerID 值也必须存在于 Customers 表中。如果有人试图从 Customers 表中删除某一行，那么 Orders 表中所有引用已删除 CustomerID 值的行也会在同一事务中被一并删除。
注意：如果您未指定外键操作，则默认操作为 NO ACTION。这意味着，如果有人试图从 Customers 表中删除某一行，而 Orders 表中有行引用了已删除的 CustomerID 值，则删除操作会失败并显示外键限制条件违规错误。

向表添加具有删除操作的外键

您还希望确保仅为现有的产品创建订单。您可以使用 ALTER TABLE 向 orders 表中添加另一个带有 ON DELETE CASCADE 操作的外键限制条件，如下所示：

ALTER TABLE Orders ADD CONSTRAINT DB_ProductOrder FOREIGN KEY (ProductID) REFERENCES Products (ProductID) ON DELETE CASCADE;

从 Products 表中删除某一行会删除 Orders 表中引用了已删除的 ProductID 值的所有行。
注意：不支持对现有外键限制条件添加或删除外键操作。您需要添加一个新的带有相应操作的外键限制条件。如需了解详情，请参阅长时间运行的架构变更。

使用信息性外键（仅限 GoogleSQL）

借助信息性外键，查询优化器可以利用外键关系，而无需承担强制执行的外键所执行的引用完整性检查带来的开销。如果强制执行严格的引用完整性不可行或会产生显著的性能开销，那么信息性外键就非常有用。

继续前面的例子，假设您想要为 Customers、Orders 和 Products 表之间的关系建模。不过，在表格数据中强制执行严格的参照完整性可能会导致性能瓶颈，尤其是在订单量较高的购物高峰期。此外，客户可能会订购已停产并从 Products 表中移除的商品。

您可以使用信息性外键创建 Orders 表：

CREATE TABLE Orders ( OrderID INT64 NOT NULL, CustomerID INT64 NOT NULL, Quantity INT64 NOT NULL, ProductID INT64 NOT NULL, CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) NOT ENFORCED, CONSTRAINT FK_ProductOrder FOREIGN KEY (ProductID) REFERENCES Products (ProductID) NOT ENFORCED ) PRIMARY KEY (OrderID);

通过使用 NOT ENFORCED 创建信息性外键，您可以允许订单引用不存在的客户或商品。如果客户账号可能会被删除或产品可能会停售，最好使用信息性外键，而不是强制执行的外键限制条件。使用信息性外键时，Spanner 不会执行参照完整性验证。这样可以减少写入开销，从而可能在订单处理高峰期提高性能。

您可以允许查询优化器使用这些关系来生成高效的查询计划。这有助于提高在外键列上联接表的查询的性能。如需了解详情，请参阅用于优化查询的信息性外键。
注意：如果您的应用逻辑需要严格的引用完整性（例如，防止订购不存在的产品），您需要在应用级别实施额外的检查。如果数据存在不一致，查询结果可能会受到影响。例如，如果优化器使用信息性外键，则将 Orders 与 Products 联接的查询可能会返回包含已停产 ProductID 的订单。

跨外键关系查询数据

SELECT * FROM Orders INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID INNER JOIN Products ON Orders.ProductsID = Products.ProductID;

使用强制执行外键实现参照完整性

添加强制执行的外键关系的主要原因是为了让 Spanner 能够维护数据的引用完整性。如果您以破坏外键限制条件的方式修改数据，则更新将失败并显示错误。

请参考图 2 中的数据。一些客户已经订购了商品，如 Orders 表中所示。由于实施了强制执行的外键限制条件，因此插入到 Orders 表中的数据具有引用完整性。

图 2. 订购数据库中的示例数据。

以下示例展示了当您尝试以破坏参照完整性的方式修改数据时会发生什么情况。

在 Customers 中不存在 CustomerID 值的 Orders 表中添加一行

根据上图中的示例数据，如果您尝试以下修改，会发生什么？

INSERT INTO Orders (OrderID, ProductID, Quantity, CustomerID) VALUES (19, 337876, 4, 447);

在这种情况下，系统会尝试向 Orders 插入一行，其中的 CustomerID (447) 在 Customers 表中不存在。如果系统执行了此操作，您的系统中将存在一个无效订单。不过，由于您已向 Orders 表添加了强制执行的外键限制条件，因此您的表会受到保护。INSERT 失败并显示以下消息（假设限制条件名为 FK_CustomerOrder）。

Foreign key constraint `FK_CustomerOrder` is violated on table `Orders`.
Cannot find referenced values in Customers(CustomerID).

与强制执行的外键不同，信息性外键不会强制执行引用完整性。如果 FK_CustomerOrder 是信息性外键，则插入语句会成功，因为 Spanner 不会验证 Customers 表中是否存在相应的 CustomerID。正因如此，数据可能不符合 FK_CustomerOrder 定义的引用完整性。

当客户在强制执行的外键限制条件中被引用时，尝试从 Customers 表中删除一行。

假设有一位客户退订了您的网店。
您想从后端移除该客户，因此您尝试执行以下操作。

DELETE FROM Customers WHERE CustomerID = 721;

在本示例中，Spanner 通过外键限制条件检测到 Orders 表中仍然存在引用您尝试删除的客户行的记录。这种情况下会显示以下错误。

Foreign key constraint violation when deleting or updating referenced row(s): referencing row(s) found in table `Orders`.

如需解决此问题，您需要先删除 Orders 中的所有引用条目。您也可以定义带有 ON DELETE CASCADE 操作的外键，让 Spanner 处理引用条目的删除。

同样，如果 FK_CustomerOrder 是信息性外键，则删除操作会成功，因为 Spanner 不保证信息性外键的引用完整性。

查看外键关系的属性

Spanner 的 INFORMATION_SCHEMA 包含有关外键及其支持性索引的信息。以下示例介绍了您可以通过查询“信息架构”回答的一些问题。

如需详细了解支持性索引，请参阅外键支持性索引。

我的数据库中定义了哪些限制条件？

SELECT tc.CONSTRAINT_NAME, tc.TABLE_NAME, tc.CONSTRAINT_TYPE FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc WHERE tc.CONSTRAINT_TYPE = 'FOREIGN KEY';

我的数据库中定义了哪些外键？

SELECT rc.CONSTRAINT_NAME, rc.UNIQUE_CONSTRAINT_NAME, rc.SPANNER_STATE FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as rc;

哪些索引是外键的二级索引（也称为支持性索引）？

外键支持性索引由 Spanner 管理，因此在 INDEXES 视图中查询 SPANNER_IS_MANAGED 会返回所有支持性索引。

SELECT i.TABLE_NAME, i.INDEX_NAME, i.INDEX_TYPE, i.INDEX_STATE, i.IS_UNIQUE, i.IS_NULL_FILTERED, i.SPANNER_IS_MANAGED FROM INFORMATION_SCHEMA.INDEXES as i WHERE SPANNER_IS_MANAGED = 'YES';

外键限制条件定义了哪些引用操作？

SELECT rc.CONSTRAINT_NAME, rc.UNIQUE_CONSTRAINT_NAME, rc.DELETE_RULE, rc.UPDATE_RULE FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as rc;

外键是强制执行还是不强制执行？

SELECT tc.CONSTRAINT_NAME, tc.TABLE_NAME, tc.CONSTRAINT_TYPE, tc.ENFORCED FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc WHERE tc.CONSTRAINT_TYPE = 'FOREIGN KEY';

如需了解详情，请参阅信息架构。

移除外键关系

以下 DDL 会从Orders表中丢弃外键限制条件。

ALTER TABLE Orders DROP CONSTRAINT FK_CustomerOrder;

删除限制条件本身时，系统会自动删除外键支持性索引。

支持更复杂的外键关系

以下主题将介绍如何使用外键来强制执行表之间更复杂的关系。

多列

外键可以引用多个列。列的列表构成一个键，它对应于表的主键或支持性索引。引用表包含被引用表键的外键。

在以下示例中，强制执行的外键定义表明：

TopHits 表中的每个 SongName 值都必须在 Songs 表中有一个匹配的值。

每对 SingerFirstName 和 SingerLastName 值都必须在 Singers 表中有一对匹配的 FirstName 和 LastName 值。

GoogleSQL

CREATE TABLE TopHits ( Rank INT64 NOT NULL, SongName STRING(MAX), SingerFirstName STRING(MAX), SingerLastName STRING(MAX),

-- Song names must either be NULL or have matching values in Songs.
FOREIGN KEY (SongName) REFERENCES Songs (SongName),

-- Singer names must either be NULL or have matching values in Singers.
FOREIGN KEY (SingerFirstName, SingerLastName) REFERENCES Singers (FirstName, LastName)

) PRIMARY KEY (Rank);

PostgreSQL

CREATE TABLE TopHits ( Rank BIGINT NOT NULL, SongName VARCHAR, SingerFirstName VARCHAR, SingerLastName VARCHAR,

-- Song names must either be NULL or have matching values in Songs.
FOREIGN KEY (SongName) REFERENCES Songs (SongName),

-- Singer names must either be NULL or have matching values in Singers.
FOREIGN KEY (SingerFirstName, SingerLastName) REFERENCES Singers (FirstName, LastName),

PRIMARY KEY (Rank) );

循环引用

可能由于旧版原因或反规范化，有时表具有循环依赖项。Spanner 外键允许循环引用。由于必须先有被引用表，然后外键才能引用该表，因此其中一个外键必须添加 ALTER TABLE 语句。示例如下

创建 TableA，但没有外键。

创建 TableB，并对 TableA 应用外键限制条件。

在 TableA 上使用 ALTER TABLE 以创建外键对 TableB 的引用。

自引用表

循环引用的一种特殊类型是定义引用同一个表的外键的表。例如，以下代码段显示了用于强制要求员工的 ManagerId 也是员工的外键。

GoogleSQL

CREATE TABLE Employees ( EmployeeId INT64 NOT NULL, EmployeeName STRING(MAX) NOT NULL, ManagerId INT64, FOREIGN KEY (ManagerId) REFERENCES Employees (EmployeeId) ) PRIMARY KEY (EmployeeId);

PostgreSQL

CREATE TABLE Employees ( EmployeeId BIGINT NOT NULL, EmployeeName VARCHAR NOT NULL, ManagerId BIGINT, FOREIGN KEY (ManagerId) REFERENCES Employees (EmployeeId), PRIMARY KEY (EmployeeId) );

后续步骤

详细了解 Spanner 中的外键支持。

详细了解 Spanner 的 信息架构。

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
