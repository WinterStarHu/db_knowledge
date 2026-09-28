# API 与参考文档  |  Spanner  |  Google Cloud Documentation

> 来源: https://docs.cloud.google.com/spanner/docs/apis?hl=zh-cn

API 与参考文档  |  Spanner  |  Google Cloud Documentation

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

Spanner

所有 API 与参考

API 和客户端库概览

客户端库及驱动程序

客户端库

概览 C++ 参考文档 C# 参考文档 Go 参考文档 Java 参考文档 Node.js 参考文档 PHP 参考文档 Python 参考文档 Ruby 参考文档

推动因素

驱动程序概览

JDBC 驱动程序

概览 将 JDBC 连接到 GoogleSQL 方言数据库 将 JDBC 连接到 PostgreSQL 方言数据库

会话管理命令

对于 GoogleSQL 方言数据库 对于 PostgreSQL 方言数据库 Spanner JDBC 驱动程序 R2DBC 驱动程序 Go 数据库/SQL 驱动程序 适用于 Golang 的 pgx 驱动程序 适用于 Python 的 psycopg2 驱动程序 适用于 Python 的 psycopg3 驱动程序 适用于 Node.js 的 node-postgres 驱动程序

API

REST 参考文档

概览 标准 API 参数 全球和区域服务端点

v1

REST 资源

projects.instanceConfigOperations

概览 list

projects.instanceConfigs

概览 create delete get list patch

projects.instanceConfigs.operations

概览 cancel delete get list

projects.instances

概览 create delete get getIamPolicy list move patch setIamPolicy testIamPermissions

projects.instances.backupOperations

概览 list

projects.instances.backups

概览 复制 create delete get getIamPolicy list patch setIamPolicy testIamPermissions

projects.instances.backups.operations

概览 cancel delete get list

projects.instances.databaseOperations

概览 list

projects.instances.databases

概览 addSplitPoints changequorum create dropDatabase get getDdl getIamPolicy list patch 恢复 setIamPolicy testIamPermissions updateDdl

projects.instances.databases.backupSchedules

概览 create delete get getIamPolicy list patch setIamPolicy testIamPermissions

projects.instances.databases.databaseRoles

概览 list testIamPermissions

projects.instances.databases.operations

概览 cancel delete get list

projects.instances.databases.sessions

概览 adaptMessage 适配器 batchCreate batchWrite beginTransaction commit create delete executeBatchDml executeSql executeStreamingSql get list partitionQuery partitionRead read 回滚 streamingRead

projects.instances.instancePartitionOperations

概览 list

projects.instances.instancePartitions

概览 create delete get list patch

projects.instances.instancePartitions.operations

概览 cancel delete get list

projects.instances.operations

概览 cancel delete get list

类型

ChangeQuorumMetadata 代码 CopyBackupMetadata CreateBackupMetadata CreateDatabaseMetadata CreateInstanceConfigMetadata CreateInstanceMetadata CreateInstancePartitionMetadata DatabaseDialect DdlStatementActionInfo DirectedReadOptions EncryptionInfo ErrorInfo FulfillmentPeriod GetPolicyOptions 帮助 KeySet ListOperationsResponse MoveInstanceMetadata MoveInstanceResponse MultiplexedSessionPrecommitToken 变更 OperationProgress OptimizeRestoredDatabaseMetadata PartialResultSet PartitionOptions PartitionResponse 政策 QueryMode QueryOptions RequestOptions RestoreDatabaseMetadata ResultSet ResultSetMetadata ResultSetStats Status StructType TestIamPermissionsResponse 交易 TransactionOptions TransactionSelector 类型 UpdateDatabaseDdlMetadata UpdateDatabaseMetadata UpdateInstanceConfigMetadata UpdateInstanceMetadata UpdateInstancePartitionMetadata WaitOperationRequest

RPC 参考文档

概览 google.iam.v1 google.longrunning google.rpc google.spanner.adapter.v1 google.spanner.admin.database.v1 google.spanner.admin.instance.v1 google.spanner.v1 google.type

SQL

GoogleSQL 与 PostgreSQL 之间的方言对等性

GoogleSQL

一般参考信息

GoogleSQL 概览 数据类型 词汇结构和语法 转换规则 排序规则 设置元素格式 存储过程

表达式

函数调用次数 聚合函数调用 运算符 条件表达式 子查询 查询语法

函数

所有函数

汇总函数

概览 ANY_VALUE ARRAY_AGG ARRAY_CONCAT_AGG AVG BIT_AND BIT_OR BIT_XOR COUNT COUNTIF LOGICAL_AND LOGICAL_OR MAX MIN STRING_AGG SUM

数组函数

概览 ARRAY ARRAY_CONCAT ARRAY_FILTER ARRAY_FIRST ARRAY_INCLUDES ARRAY_INCLUDES_ALL ARRAY_INCLUDES_ANY ARRAY_IS_DISTINCT ARRAY_LAST ARRAY_LENGTH ARRAY_MAX ARRAY_MIN ARRAY_REVERSE ARRAY_SLICE ARRAY_TO_STRING ARRAY_TRANSFORM GENERATE_ARRAY GENERATE_DATE_ARRAY JSON_ARRAY JSON_QUERY_ARRAY JSON_VALUE_ARRAY

位函数

概览 BIT_COUNT BIT_REVERSE

转换函数

概览 CAST SAFE_CAST

日期函数

概览 ADDDATE CURRENT_DATE DATE DATE_ADD DATE_DIFF DATE_FROM_UNIX_DATE DATE_SUB DATE_TRUNC EXTRACT（日期） FORMAT_DATE PARSE_DATE SUBDATE UNIX_DATE

调试函数

概览 错误

图表函数

概览 DESTINATION_NODE_ID EDGES ELEMENT_ID IS_ACYCLIC IS_FIRST IS_TRAIL 标签 NODES PATH PATH_FIRST PATH_LAST PATH_LENGTH PROPERTY_NAMES SOURCE_NODE_ID

哈希函数

概览 FARM_FINGERPRINT SHA1 SHA256 SHA512

间隔时间函数

概览 EXTRACT（间隔） JUSTIFY_DAYS JUSTIFY_HOURS JUSTIFY_INTERVAL MAKE_INTERVAL

JSON 函数

概览 BOOL BOOL_ARRAY FLOAT64 FLOAT64_ARRAY FLOAT32 FLOAT32_ARRAY INT64 INT64_ARRAY JSON_ARRAY JSON_ARRAY_APPEND JSON_ARRAY_INSERT JSON_CONTAINS JSON_OBJECT JSON_QUERY JSON_QUERY_ARRAY JSON_REMOVE JSON_SET JSON_STRIP_NULLS JSON_TYPE JSON_VALUE JSON_VALUE_ARRAY LAX_BOOL LAX_FLOAT64 LAX_INT64 LAX_STRING PARSE_JSON SAFE_TO_JSON STRING (JSON) STRING_ARRAY TO_JSON TO_JSON_STRING

机器学习函数

概览 ML.PREDICT

数学函数

概览 ABS ACOS ACOSH APPROX_COSINE_DISTANCE APPROX_DOT_PRODUCT APPROX_EUCLIDEAN_DISTANCE ASIN ASINH ATAN ATAN2 ATANH CEIL CEILING COS COSH COSINE_DISTANCE DIV DOT_PRODUCT EXP EUCLIDEAN_DISTANCE FLOOR GREATEST IEEE_DIVIDE IS_INF IS_NAN LEAST LN LOG LOG10 MOD POW POWER ROUND SAFE_ADD SAFE_DIVIDE SAFE_MULTIPLY SAFE_NEGATE SAFE_SUBTRACT SIGN SIN SINH SQRT TAN TANH TRUNC

网络函数

概览 NET.HOST NET.IP_FROM_STRING NET.IP_NET_MASK NET.IP_TO_STRING NET.IP_TRUNC NET.IPV4_FROM_INT64 NET.IPV4_TO_INT64 NET.PUBLIC_SUFFIX NET.REG_DOMAIN NET.SAFE_IP_FROM_STRING

协议缓冲区函数

概览 REPLACE_FIELDS

搜索函数

概览 DEBUG_TOKENLIST SCORE SCORE_NGRAMS SEARCH SEARCH_NGRAMS SEARCH_SUBSTRING SNIPPET TOKEN TOKENIZE_BOOL TOKENIZE_FULLTEXT TOKENIZE_JSON TOKENIZE_NGRAMS TOKENIZE_NUMBER TOKENIZE_SUBSTRING TOKENLIST_CONCAT

序列函数

概览 GET_INTERNAL_SEQUENCE_STATE GET_NEXT_SEQUENCE_VALUE

统计聚合函数

概览 STDDEV STDDEV_SAMP VAR_SAMP VARIANCE

字符串函数

概览 BYTE_LENGTH CHAR_LENGTH CHARACTER_LENGTH CODE_POINTS_TO_BYTES CODE_POINTS_TO_STRING CONCAT ENDS_WITH FORMAT FROM_BASE32 FROM_BASE64 FROM_HEX LCASE LENGTH LOWER LPAD LTRIM NORMALIZE NORMALIZE_AND_CASEFOLD OCTET_LENGTH REGEXP_CONTAINS REGEXP_EXTRACT REGEXP_EXTRACT_ALL REGEXP_REPLACE REPEAT 替换 REVERSE RPAD RTRIM SAFE_CONVERT_BYTES_TO_STRING SOUNDEX SPLIT SPLIT_SUBSTR STARTS_WITH STRPOS SUBSTR SUBSTRING TO_BASE32 TO_BASE64 TO_CODE_POINTS TO_HEX TRIM UPPER UCASE

时间戳函数

概览 CURRENT_TIMESTAMP EXTRACT（时间戳） FORMAT_TIMESTAMP PARSE_TIMESTAMP PENDING_COMMIT_TIMESTAMP STRING（时间戳） TIMESTAMP TIMESTAMP_ADD TIMESTAMP_DIFF TIMESTAMP_MICROS TIMESTAMP_MILLIS TIMESTAMP_SECONDS TIMESTAMP_SUB TIMESTAMP_TRUNC UNIX_MICROS UNIX_MILLIS UNIX_SECONDS

实用函数

概览 GENERATE_UUID

MySQL 函数

所有 MySQL 函数

日期和时间函数

概览 DATE_FORMAT DAY DAYNAME DAYOFMONTH DAYOFWEEK DAYOFYEAR FROM_DAYS FROM_UNIXTIME HOUR MAKEDATE MICROSECOND MINUTE 月 MONTHNAME PERIOD_ADD PERIOD_DIFF QUARTER SECOND STR_TO_DATE SYSDATE 时间 TO_DAYS TO_SECONDS UNIX_TIMESTAMP UTC_DATE UTC_TIMESTAMP WEEK WEEKDAY WEEKOFYEAR YEAR

加密和压缩函数

概览 SHA2

JSON 函数

概览 JSON_QUOTE JSON_UNQUOTE

数值函数

概览 DEGREES LOG2 PI RADIANS TRUNCATE

字符串函数

概览 BIT_LENGTH CHAR CONCAT_WS HEX INSERT LOCATE MID OCT ORD POSITION QUOTE REGEXP_LIKE REGEXP_SUBSTR SPACE STRCMP SUBSTRING_INDEX UNHEX

时间戳函数

概览 DATEDIFF LOCALTIME LOCALTIMESTAMP 现在

实用函数

概览 BIN_TO_UUID INET_ATON INET_NTOA INET6_ATON INET6_NTOA IS_IPV4 IS_IPV4_COMPAT IS_IPV4_MAPPED IS_IPV6 IS_UUID UUID UUID_TO_BIN

对账单

DDL（数据定义语言） DML（数据操纵语言） 过程语言

PostgreSQL

PostgreSQL 概览 词汇结构和语法 数据定义 (DDL) 数据操纵 (DML) 查询语法 子查询 数据类型 函数 运算符 存储过程 PostgreSQL 系统目录表 PostgreSQL 系统目录视图 PostgreSQL 接口中的已知问题

信息架构

对于 GoogleSQL 数据库 对于 PostgreSQL 数据库

查询执行运算符

GQL

概览

Spanner Graph 和 ISO 标准

架构语句

概览 CREATE PROPERTY GRAPH 语句 DROP PROPERTY GRAPH 语句

查询语句

概览 GQL 语法 图表子句 CALL 语句 FILTER 语句 FOR 语句 LET 语句 LIMIT 语句 MATCH 语句 NEXT 语句 OFFSET 语句 ORDER BY 语句 RETURN 语句 SKIP 语句 WITH 语句 图表提示

SQL 中的 GQL

概览 GRAPH_TABLE 运算符

模式

概览 图表模式 元素模式 子路径模式 量化路径模式 标签表达式 路径搜索前缀 路径模式

子查询

概览 ARRAY 子查询 EXISTS 子查询 IN 子查询 VALUE 子查询

数据类型

概览 图表元素类型 图表路径类型

运算符

概览 串联运算符 逻辑运算符 ALL_DIFFERENT 谓词 IS DESTINATION 谓词 IS SOURCE 谓词 PROPERTY_EXISTS 谓词 SAME 谓词

函数

概览 DESTINATION_NODE_ID 函数 EDGES 函数 ELEMENT_ID 函数 IS_ACYCLIC 函数 IS_FIRST 函数 IS_TRAIL 函数 LABELS 函数 NODES 函数 PATH 函数 PATH_FIRST 函数 PATH_LAST 函数 PATH_LENGTH 函数 PROPERTY_NAMES 函数 SOURCE_NODE_ID 函数

条件表达式

概览

CLI

gcloud 命令行工具

psql 命令行工具

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

参考文档

发送反馈

API 与参考文档

使用集合让一切井井有条

根据您的偏好保存内容并对其进行分类。

API 和客户端库概览

客户端库、RPC API 和 REST API 提供对 Spanner 的编程访问。

Spanner 客户端库

以您选择的语言开始使用 Spanner。

JDBC 驱动程序

可用于 Spanner 的 JDBC 驱动程序的概览。

将 JDBC 连接到 GoogleSQL 方言数据库

如何使用 Spanner JDBC 驱动程序更新数据库架构、作为批处理事务的一部分在自动提交模式下使用 DML 语句添加和更新行，以及运行 SQL 查询。

Spanner JDBC 驱动程序常见问题解答

Google 编写的 Spanner 开源 JDBC 驱动程序的常见问题解答。

将 JDBC 连接到 PostgreSQL 方言数据库

如何将 PostgreSQL JDBC 驱动程序与 PostgreSQL 方言数据库搭配使用。

将 JDBC 连接到 PostgreSQL 方言数据库

如何将 PostgreSQL JDBC 驱动程序与 PostgreSQL 方言数据库搭配使用。

RPC 参考文档

Spanner 的 RPC API 参考文档。

REST 参考文档

Spanner 的 REST API 参考文档。

GoogleSQL 词法结构和语法

标识符、字面量、关键字、运算符和特殊字符的相关 GoogleSQL 参考文档。

GoogleSQL 数据定义语言 (DDL)

有关在 GoogleSQL 数据库中创建、修改或删除表和索引的 DDL 参考文档。

GoogleSQL 数据操纵语言语法

有关 GoogleSQL 数据操纵语言的参考文档。

GoogleSQL 查询语法

有关执行 SELECT 语句的 GoogleSQL 参考文档。

GoogleSQL 函数

有关受支持的 GoogleSQL 函数的参考文档。

PostgreSQL 词汇结构和语法

有关 PostgreSQL 数据库中的标识符、字面量、关键字、运算符和特殊字符的参考文档。

PostgreSQL 数据定义语言

有关 PostgreSQL 数据库中的数据定义语言 (DDL) 语句的参考文档。

PostgreSQL 数据操纵语言

有关 PostgreSQL 数据库中的数据操纵语言 (DML) 语句的参考文档。

PostgreSQL 查询

有关 PostgreSQL 数据库中的 SELECT 语句的参考文档。

PostgreSQL 子查询

有关 PostgreSQL 数据库中的子查询的参考文档。

PostgreSQL 数据类型

有关 PostgreSQL 数据库中支持的数据类型的参考文档。

PostgreSQL 函数

有关 PostgreSQL 数据库中支持的函数的参考文档。

信息架构

有关每个 Spanner 数据库通用的内置架构的参考文档。

查询优化器版本记录

存储优化器版本信息的内置表。

查询执行运算符

Spanner 查询执行计划中使用的运算符。

Google Cloud CLI

用于从命令行与 Cloud Spanner 交互的常用 gcloud 命令。

psql 命令行工具

有关适用于 Spanner 的 PostgreSQL 接口中的 psql 命令支持的参考文档。

发送反馈

如未另行说明，那么本页面中的内容已根据知识共享署名 4.0 许可获得了许可，并且代码示例已根据 Apache 2.0 许可获得了许可。有关详情，请参阅 Google 开发者网站政策。Java 是 Oracle 和/或其关联公司的注册商标。

需要向我们提供更多信息？

[[["易于理解","easyToUnderstand","thumb-up"],["解决了我的问题","solvedMyProblem","thumb-up"],["其他","otherUp","thumb-up"]],[["很难理解","hardToUnderstand","thumb-down"],["信息或示例代码不正确","incorrectInformationOrSampleCode","thumb-down"],["没有我需要的信息/示例","missingTheInformationSamplesINeed","thumb-down"],["翻译问题","translationIssue","thumb-down"],["其他","otherDown","thumb-down"]],[],[],[]]

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
