# PolarDB-X返回的常见错误码及解决方法-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/error-codes-3

PolarDB-X返回的常见错误码及解决方法-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

AI和智能体

快速入门

产品计费

动态与公告

用户指南

开发指南

SQL调优指南

技术白皮书

性能白皮书

最佳实践

分布式常见问题

安全合规

API参考

错误码

术语表

相关协议

PolarDB-X 1.0（DRDS）

PolarDB分布式轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB分布式版

错误码

错误码

更新时间：

复制 MD 格式

产品详情 我的收藏

本文为您介绍PolarDB-X常见的错误码及解决方法。

TDDL-1305 ERR_UNKNOWN_SAVEPOINT

描述：指定名称的SAVEPOINT不存在。

示例：ERR-CODE: [TDDL-1305][ERR_UNKNOWN_SAVEPOINT] SAVEPOINT ***** does not exist

说明：在PolarDB-X上执行ROLLBACK TO SAVEPOINT或者RELEASE SAVEPOINT命令时，如果指定的SAVEPOINT名称不存在，会提示TDDL-1305错误。
建议检查SAVEPOINT命令返回的名称是否和使用的名称一致。
TDDL-1094 ERR_UNKNOWN_THREAD_ID

描述：KILL命令指定的会话ID不存在。

示例：ERR-CODE: [TDDL-1094][ERR_UNKNOWN_THREAD_ID] Unknown thread id: *****

说明：在PolarDB-X上执行KILL命令取消执行的SQL语句时，如果指定的会话ID不存在，或者对应的SQL语句已经结束执行，会提示TDDL-1094错误。
建议使用SHOW PROCESSLIST命令查看正在执行的SQL语句会话ID，并只针对返回的ID执行KILL命令。
TDDL-4006 ERR_TABLE_NOT_EXIST

描述：PolarDB-X数据表不存在。

示例：ERR-CODE: [TDDL-4006][ERR_TABLE_NOT_EXIST] Table '*****' doesn't exist.

说明：该错误码表示PolarDB-X数据表不存在，或者由于未知原因，PolarDB-X无法加载数据表的元数据信息。
TDDL-4007 ERR_CANNOT_FETCH_TABLE_META

描述：PolarDB-X无法加载数据表的元数据信息。

示例：ERR-CODE: [TDDL-4007][ERR_CANNOT_FETCH_TABLE_META] Table '*****' metadata cannot be fetched because Table '*****.*****' doesn't exist.

说明：该错误码表示PolarDB-X尝试读取数据表的元数据信息失败。可能的错误原因如下：

数据表未创建。

维护的元数据库信息不一致。

表被删除或者改名。
出现该错误时，首先检查表名是否存在，或者执行check table 命令确认PolarDB-X维护的元数据库信息是否一致。如果确定表被人为删除或改名，可以通过PolarDB-X提供的数据恢复功能修复。如果仍无法修复，请联系技术支持。
TDDL-4018 ERR_INVALID_DDL_PARAMS

描述：PolarDB-X执行DDL过程失败。

示例：ERR-CODE: [TDDL-4018][ERR_INVALID_DDL_PARAMS] invalid '*****'.

说明：该错误表示用户执行DDL的参数有错误，请检查参数正确性。如果确认参数正确，请联系技术支持。
TDDL-4100 ERR_ATOM_NOT_AVALILABLE

描述：PolarDB-X后端存储节点暂时不可用。

示例：ERR-CODE: [TDDL-4100][ERR_ATOM_NOT_AVALILABLE] Atom : ***** isNotAvailable

说明：如果PolarDB-X探测到后端某个存储节点状态异常，会临时阻止访问该实例并提示TDDL-4100错误。
当遇到该错误，请检查PolarDB-X后端所有存储节点是否异常。当后端存储节点从异常状态恢复后，PolarDB-X将自动解除不可用状态，恢复应用正常访问。
TDDL-4101 ERR_ATOM_GET_CONNECTION_FAILED_UNKNOWN_REASON

描述：PolarDB-X计算节点和存储节点连接获取失败。

示例：ERR-CODE: [TDDL-4101][ERR_ATOM_GET_CONNECTION_FAILED_UNKNOWN_REASON] Get connection for db '*****' from pool failed. AppName:*****, Env:*****, UnitName:null. Message from pool: wait millis 5000, active 0, maxActive 5. You should look for the following logs which contains the real reason.

说明：PolarDB-X在处理请求时会向存储节点异步创建连接。如果无法在等待时间内完成存储节点连接创建，而异步任务又尚未返回错误原因，PolarDB-X会向应用返回TDDL-4101错误。
该错误通常是由后端存储节点异常导致的。如果排除存储节点问题后仍然出现该错误，请联系技术支持。
TDDL-4102 ERR_ATOM_GET_CONNECTION_FAILED_KNOWN_REASON

描述：已知原因的PolarDB-X后端连接获取失败。

示例：ERR-CODE: [TDDL-4102][ERR_ATOM_GET_CONNECTION_FAILED_KNOWN_REASON] Get connection for db '*****' failed because wait millis 5000, active 0, maxActive 5

说明：PolarDB-X计算节点获取存储节点连接时出错，错误原因已经在ERR-CODE消息中给出。常见PolarDB-X存储节点连接失败的原因如下：

后端存储节点连接数已满

计算节点到存储节点的连接超时

存储节点拒绝连接 如果排除后端存储节点问题后仍然出现该错误，请联系技术支持。
TDDL-4103 ERR_ATOM_CONNECTION_POOL_FULL

描述：PolarDB-X后端存储节点连接池已满。

示例：ERR-CODE: [TDDL-4103][ERR_ATOM_CONNECTION_POOL_FULL] Pool of DB '*****' is full. Message from pool: wait millis 5000, active 5, maxActive 5. AppName:*****, Env:*****, UnitName:null.

说明：该错误表示PolarDB-X后端连接池已满。导致TDDL-4103错误的常见原因如下：

应用SQL语句执行比较慢，占用单个连接的时间过长，导致连接数不够；

应用端没有关闭数据库连接，导致连接泄露；

有很多跨库查询（例如聚合统计类查询，未带分库条件的查询）同时执行，占用大量连接。

解决方法建议如下：

尽量使用框架访问数据库，如Spring JDBC、MyBatis等；

按性能分析报告与DBA建议优化业务SQL语句；

使用PolarDB-X读写分离将跨库查询转发至读库处理；

升级更高规格的PolarDB-X，提升后端处理能力；

联系技术支持调整PolarDB-X后端连接数。
TDDL-4104 ERR_ATOM_CREATE_CONNECTION_TOO_SLOW

描述：PolarDB-X后端存储节点连接创建太慢。

示例：ERR-CODE: [TDDL-4104][ERR_ATOM_CREATE_CONNECTION_TOO_SLOW] Get connection for db '*****' from pool timeout. AppName:*****, Env:*****, UnitName:null. Message from pool: wait millis 5000, active 3, maxActive 5.

说明：PolarDB-X向后端存储节点异步创建连接时，如果在短时间创建大量连接，或者存储节点建立连接速度太慢，会出现等待超时。该问题通常是由于后端存储节点压力过大或异常导致的，建议使用PolarDB-X读写分离，或者升级更高规格，减轻后端处理压力。
如果排除后端存储节点问题后仍然出现该错误，请联系技术支持。如果问题是由短时间创建大量连接导致，建议联系技术支持调整PolarDB-X最小连接数。
TDDL-4105 ERR_ATOM_ACCESS_DENIED

描述：PolarDB-X后端存储节点拒绝创建连接。

示例：ERR-CODE: [TDDL-4105][ERR_ATOM_ACCESS_DENIED] DB '*****' Access denied for user '*****'@'*****'. AppName:*****, Env:*****, UnitName:null. Please contact DBA to check.

说明：该错误表明PolarDB-X通过用户名和密码连接存储节点时被拒绝访问，请联系技术支持。
TDDL-4106 ERR_ATOM_DB_DOWN

描述：PolarDB-X后端存储节点无法连接。

示例：ERR-CODE: [TDDL-4106][ERR_ATOM_DB_DOWN] DB '*****' cannot be connected. AppName:*****, Env:*****, UnitName:null. It seems a very real possibility that this DB IS DOWN. Please contact DBA to check.

说明：该错误表明PolarDB-X向后端存储节点创建连接超时或者没有响应。遇到该错误的通常原因是存储节点故障，请联系技术支持。
TDDL-4108 ERR_VARIABLE_CAN_NOT_SET_TO_NULL_FOR_NOW

描述：变量（variable）不允许被设置为NULL。

示例：ERR-CODE: [TDDL-4108][ERR_VARIABLE_CAN_NOT_SET_TO_NULL_FOR_NOW] System variable ***** can''t set to null for now;

说明：有些存储节点变量（variable）不允许用SET var = x语句设置成NULL值。遇到这种情况，PolarDB-X会提示TDDL-4108错误。
TDDL-4200 ERR_GROUP_NOT_AVALILABLE

描述：PolarDB-X下的某个存储节点暂时不可用。

示例：ERR-CODE: [TDDL-4200][ERR_GROUP_NOT_AVALILABLE] The TDDL Group ***** is running in fail-fast status, caused by this SQL:***** which threw a fatal exception as *****.

说明：当分库包含的存储节点出现访问异常，并且分库下没有其他可用存储节点时，PolarDB-X会将分库置于fail-fast状态并提示TDDL-4200错误。
通常该错误是由于存储节点故障导致的。请根据包含的存储节点异常信息定位和解决问题。当故障存储节点恢复后，PolarDB-X将自动取消fail-fast状态。
如果存储节点故障解决后仍然出现TDDL-4200错误，请联系技术支持。
TDDL-4201 ERR_GROUP_NO_ATOM_AVALILABLE

描述：PolarDB-X分库内暂时没有可用存储节点。

示例：ERR-CODE: [TDDL-4201][ERR_GROUP_NO_ATOM_AVALILABLE] All weights of DBs in Group '*****' is 0. Weights is: *****.

说明：当分库包含的存储节点全都不可用，或者处于fail-fast状态时，PolarDB-X会提示TDDL-4201错误。
通常该错误是由于存储节点故障导致的。请检查后端存储节点状态以定位和解决问题。如果故障解决后仍然出现TDDL-4201错误，请联系技术支持。
TDDL-4202 ERR_SQL_QUERY_TIMEOUT

描述：PolarDB-X查询超时。

示例：ERR-CODE: [TDDL-4202][ERR_SQL_QUERY_TIMEOUT] Slow query leads to a timeout exception, please contact DBA to check slow sql. SocketTimout:*** ms, Atom:*****, Group:*****, AppName:*****, Env:*****, UnitName:null.

说明：该错误表示SQL语句在后端存储节点上的执行时间超过PolarDB-X设置的socketTimeout参数限制。默认的PolarDB-X超时（socketTimeout）时间设置是900秒。
建议优化SQL语句，以及在后端存储节点上创建适合的索引以提升SQL语句的执行性能。如果优化后的SQL语句仍然较慢，可以参见如下Hint语法临时设置PolarDB-X的超时时间：/*TDDL:SOCKET_TIMEOUT=900000*/ SELECT * FROM dual;，其中SOCKET_TIMEOUT设置的单位是毫秒。关于PolarDB-X的Hint用法，详情请参见如何自定义SQL超时时间。如果需要永久调整PolarDB-X超时设置，请联系技术支持。
TDDL-4203 ERR_SQL_QUERY_MERGE_TIMEOUT

描述：PolarDB-X分布式查询超时。

示例：ERR-CODE: [TDDL-4203][ERR_SQL_QUERY_MERGE_TIMEOUT] Slow sql query leads to a timeout exception during merging results, please optimize the slow sql. The the default timeout is *** ms. DB is *****

说明：PolarDB-X执行分布式查询超时，默认的超时设置是900秒。产生TDDL-4203错误表示SQL语句扫描了多个分库的数据并且执行时间超过900秒。

建议进行如下优化：

在WHERE条件中添加分库键（Sharding key）条件，将SQL语句优化成单库执行；

检查是否可以在后端存储节点上创建适合的索引，提升扫描各个分库数据的性能；

设法消除分布式查询中的跨库JOIN，数据重排序等耗时操作，降低PolarDB-X数据合并阶段的消耗。
如果优化后的SQL语句仍然较慢，可以使用如下Hint语法临时设置PolarDB-X的超时时间：/*TDDL:SOCKET_TIMEOUT=900000*/ SELECT * FROM dual;，其中SOCKET_TIMEOUT设置的单位是毫秒。关于PolarDB-X的Hint用法，详情请参见如何自定义SQL超时时间。
TDDL-4400 ERR_SEQUENCE

描述：处理Sequence（全局唯一序列）失败。

示例：ERR-CODE: [TDDL-4400][ERR_SEQUENCE] Sequence : All dataSource faild to get value!

说明：处理Sequence出错，错误信息在Sequence :中给出。导致TDDL-4400的常见原因是存储节点故障，无法访问Sequence有关的数据表。
建议先检查后端存储节点状态。如果排除存储节点故障后仍然发生错误，请联系技术支持。
TDDL-4401 ERR_MISS_SEQUENCE

描述：Sequence不存在。

示例：ERR-CODE: [TDDL-4401][ERR_MISS_SEQUENCE] Sequence '*****' is not found

说明：命令中使用的Sequence名称不存在。建议用SHOW SEQUENCES命令检查PolarDB-X中所有已创建的Sequence名称，并且选择正确的Sequence使用。

如果使用的Sequence尚不存在，可以用如下语句创建： CREATE SEQUENCE  [ START WITH  ] [ INCREMENT BY  ] [ MAXVALUE  ] [ CYCLE | NOCYCLE ]` 如果使用的Sequence已经存在，但是仍然提示TDDL-4401错误，请联系技术支持。关于PolarDB-X的Sequence用法，详情请参见概述。
TDDL-4403 ERR_MISS_SEQUENCE_TABLE_ON_DEFAULT_DB

描述：Sequence使用的数据表不存在。

示例：ERR-CODE: [TDDL-4403][ERR_MISS_SEQUENCE_TABLE_ON_DEFAULT_DB] Sequence table is not in default db.

说明：无法在PolarDB-X后端的数据库里访问名称叫sequence或者sequence_opt的数据表，请联系技术支持。
TDDL-4404 ERR_SEQUENCE_TABLE_META

描述：Sequence数据表结构错误。

示例：ERR-CODE: [TDDL-4404][ERR_SEQUENCE_TABLE_META] the meta of sequence table is error, some columns missed

说明：Sequence相关数据表（如sequence或sequence_opt）中缺少相应的字段，请联系技术支持。
TDDL-4405 ERR_INIT_SEQUENCE_FROM_DB

描述：初始化Sequence错误。

示例：ERR-CODE: [TDDL-4405][ERR_INIT_SEQUENCE_FROM_DB] init sequence manager error: *****

说明：初始化需要访问的Sequence时出错，错误信息在init sequence manager error后给出。建议先检查PolarDB-X后端存储节点状态。如果排除存储节点故障后仍然提示TDDL-4405错误，请联系技术支持。
TDDL-4407 ERR_OTHER_WHEN_BUILD_SEQUENCE

描述：访问Sequence数据表出错。

示例：ERR-CODE: [TDDL-4407][ERR_OTHER_WHEN_BUILD_SEQUENCE] error when build sequence: *****

说明：在访问Sequence相关数据表（如sequence或sequence_opt）时发生错误。错误信息在error when build sequence后给出。
建议先检查PolarDB-X后端存储节点状态。如果排除存储节点故障后仍然提示TDDL-4407错误，请联系技术支持。
TDDL-4408 ERR_SEQUENCE_NEXT_VALUE

描述：获取Sequence值出错。

示例：ERR-CODE: [TDDL-4408][ERR_SEQUENCE_NEXT_VALUE] error when get sequence's next value, sequence is: *****, error: *****

说明：使用PolarDB-X自增主键，或者使用.NEXTVAL语法手工获取全局唯一ID时发生错误。错误原因在error提示后给出。
产生TDDL-4408错误的原因是后端存储节点故障。建议先检查PolarDB-X后端存储节点状态和访问压力。如果排除存储节点故障后仍然提示TDDL-4408错误，请联系技术支持。
TDDL-4500 ERR_PARSER

描述：解析SQL语句失败。

示例：ERR-CODE: [TDDL-4500][ERR_PARSER] not support statement: '*****'

说明：PolarDB-X支持符合SQL-92标准的SQL语法，以及MySQL支持的语法扩展与函数。请检查执行的SQL语句是否符合PolarDB-X兼容的SQL标准及MySQL规范。
关于SQL标准语法，请参见SQL标准语法。关于SQL兼容性，请参见SQL语法使用限制。如果您的SQL语句符合上述语法规则仍然提示TDDL-4500错误，请联系技术支持。
TDDL-4501 ERR_OPTIMIZER

描述：优化器转换SQL语句失败。

示例：ERR-CODE: [TDDL-4501][ERR_OPTIMIZER] optimize error by: Unknown column '*****' in 'order clause'

说明：PolarDB-X优化器的工作是转换SQL语句到内部语法树。如果SQL语句中出现逻辑错误，优化器转换就会失败，产生TDDL-4501错误。
建议按照optimize error by后的提示检查和调整您的SQL语句。如果调整SQL语句后仍然提示TDDL-4501错误，请联系技术支持。
TDDL-4502 ERR_OPTIMIZER_MISS_ORDER_FUNCTION_IN_SELECT

描述：ORDER BY包含的函数列在SELECT子句中不存在。

示例：ERR-CODE: [TDDL-4502][ERR_OPTIMIZER_MISS_ORDER_FUNCTION_IN_SELECT] Syntax Error: orderBy/GroupBy Column ***** is not existed in select clause`

说明：当SQL语句中的ORDER BY子句包含函数列（例如RAND()）时，PolarDB-X要求同样的函数列必须也在SELECT子句中出现，否则提示TDDL-4502错误。
建议在SELECT子句中添加相应的函数列。
TDDL-4504 ERR_OPTIMIZER_SELF_CROSS_JOIN

描述：相同表JOIN的条件不足。

示例：ERR-CODE: [TDDL-4504][ERR_OPTIMIZER_SELF_CROSS_JOIN] self cross join case, add shard column filter on right table

说明：PolarDB-X在执行相同表的JOIN时，如果WHERE子句只包含其中一张左表（或右表）的拆分字段（sharding column）条件，会提示TDDL-4504错误。
建议调整SQL语句，在WHERE子句中补全JOIN左表（或右表）的拆分字段条件。
TDDL-4506 ERR_MODIFY_SHARD_COLUMN

描述：禁止更新拆分键。

示例：ERR-CODE: [TDDL-4506][ERR_MODIFY_SHARD_COLUMN] Column '*****' is a sharding key of table '*****', which is forbidden to be modified.

说明：这是禁止修改拆分键（sharding key）的异常，PolarDB-X目前禁止修改包含GSI的表的分区键。
建议将对应UPDATE语句修改为相同效果的INSERT+DELETE语句。
TDDL-4508 ERR_OPTIMIZER_NOT_ALLOWED_SORT_MERGE_JOIN

描述：无法执行合并排序JOIN。

示例：ERR-CODE: [TDDL-4508][ERR_OPTIMIZER_NOT_ALLOWED_SORT_MERGE_JOIN] sort merge join is not allowed when missing equivalent filter

说明：如果SQL语句中需要JOIN的数据表分别来自不同的存储节点，PolarDB-X会优先选择合并排序（Sort-merge Join）算法。该算法要求JOIN的左表与右表必须包含字段相等的关联条件，否则PolarDB-X将提示TDDL-4508错误。
建议调整SQL语句，在JOIN或WHERE部分添加相应的关联条件。
TDDL-4509 ERR_OPTIMIZER_ERROR_HINT

示例：ERR-CODE: [TDDL-4509][ERR_OPTIMIZER_ERROR_HINT] Hint Syntax Error: unexpected operation: *****.

说明：该错误表示SQL语句中的Hint语法无法被PolarDB-X解析。更多关于Hint语法信息，请参见如何使用HINT。
TDDL-4510 ERR_CONTAINS_NO_SHARDING_KEY

描述：缺少拆分键（sharding key）条件。

示例：ERR-CODE: [TDDL-4510][ERR_CONTAINS_NO_SHARDING_KEY] Your SQL contains NO SHARDING KEY '*****' for table '*****', which is not allowed in DEFAULT.

说明：禁止全表扫描（full-table scan）功能，PolarDB-X在建表时默认开启全表扫描功能。如果手动关闭全表扫描，建议确认与该表有关的SQL语句都已添加拆分键条件。
TDDL-4511 ERR_INSERT_CONTAINS_NO_SHARDING_KEY

描述：INSERT语句缺少拆分键 (sharding key）。

示例：ERR-CODE: [TDDL-4511][ERR_INSERT_CONTAINS_NO_SHARDING_KEY] Your INSERT SQL contains NO SHARDING KEY '*****' for table '*****'.

说明：当INSERT语句的目标是一张PolarDB-X拆分表时，必须在插入数据中包含拆分键的值（拆分键是自增主键例外）。否则，PolarDB-X将提示TDDL-4511错误。
如果遇到该错误，建议修改INSERT语句补充缺少的拆分键值。
TDDL-4515 ERR_CONNECTION_CHARSET_NOT_MATCH

描述：输入的字符串与数据库的字符集不匹配。

示例：ERR-CODE: [TDDL-4515][ERR_CONNECTION_CHARSET_NOT_MATCH] Caused by MySQL's character_set_connection doesn't match your input charset. Partition DDL can only take ASCII or chinese column name. If you want use chinese table or column name, Make sure MySQL connection's charset support chinese character. Use "set names xxx" to set correct charset.

说明：PolarDB-X支持用中文字符命名表名及字段名。在执行含有中文字符的SQL语句时，如果数据库连接的字符集设置（character_set_connection）不支持中文（如 latin1），会提示TDDL-4515错误。
您可以使用SHOW VARIABLES LIKE 'character_set_connection'查询MySQL客户端当前的连接字符集，使用SET NAMES命令修改当前连接字符集。如果是Java程序JDBC方式连接PolarDB-X，请设置数据库连接参数characterEncoding。
TDDL-4517 ERR_MODIFY_SYSTEM_TABLE

描述：禁止修改系统表。

示例：ERR-CODE: [TDDL-4617][ERR_MODIFY_SYSTEM_TABLE] Table '*****' is PolarDB-XSYSTEM TABLE, which is forbidden to be modified.

说明：PolarDB-X内部维护了一些系统表，使用SQL语句更新其中的数据会提示TDDL-4517错误。限制的系统表包括sequence、sequence_opt、txc_undo_log等，请避免在业务或数据库设计中使用这些表名。
TDDL-4520 ERR_DML_WITH_SUBQUERY

描述：不支持在DML使用子查询语句。

示例：ERR-CODE: [TDDL-4520][ERR_DML_WITH_SUBQUERY] DO NOT support UPDATE/DELETE with subQuery

说明：目前PolarDB-X中禁止在DML语句中包含子查询语句，遇到此类问题建议先从业务上改写SQL，避免使用子查询。
TDDL-4521 ERR_INSERT_SHARD

描述：Insert过程中一条记录被路由到了多个分片。

示例：ERR-CODE: [TDDL-4521][ERR_INSERT_SHARD] Cannot decide which group to insert

说明：Insert过程中一条记录被路由到了多个分片，导致不知道这条记录被插入到哪个分片，出现这类问题，请联系技术支持。
TDDL-4523 ERR_TODNF_LIMIT_EXCEED

描述：where后面的过滤条件太多。

示例：ERR-CODE: [TDDL-4523][ERR_TODNF_LIMIT_EXCEED] toDnf has exceed the limit size

说明：PolarDB-X会对用户SQL的查询条件（即where子句）进行CNF/DNF的条件范式转换，并进行条件推导与优化，为了优化稳定性，限制了条件数2000。用户可以将DNF_REX_NODE_LIMIT参数调整大。
TDDL-4524 ERR_TOCNF_LIMIT_EXCEED

描述：where后面的过滤条件太多。

示例：ERR-CODE: [TDDL-4524][ERR_TODNF_LIMIT_EXCEED] toCnf has exceed the limit size

说明：PolarDB-X会对用户SQL的查询条件（即where子句）进行CNF/DNF的条件范式转换，并进行条件推导与优化，为了优化稳定性，限制了条件数2000。用户可以将CNF_REX_NODE_LIMIT参数调整大。
TDDL-4526 ERR_FUNCTION_NOT_FOUND

描述：该函数不支持调用。

示例：ERR-CODE: [TDDL-4526][ERR_FUNCTION_NOT_FOUND] No match found for function signature

说明：该错误表明在SQL语句中使用了错误的语法或不支持的函数。建议仔细检查SQL语句中的函数调用部分，使用正确的参数个数和类型调用函数。
TDDL-4527 ERR_MODIFY_SHARD_COLUMN_ON_TABLE_WITHOUT_PK

描述：不允许在无主键的表上修改分库键。

示例：ERR-CODE: [TDDL-4527][ERR_MODIFY_SHARD_COLUMN_ON_TABLE_WITHOUT_PK]

说明：PolarDB-X目前不允许在无主键的表上修改分库键。
TDDL-4595 ERR_UNKNOWN_TZ

描述：设置错误的时区。

示例：ERR-CODE: [TDDL-4595][ERR_UNKNOWN_TZ]

说明：建议检查时间的语法和格式是否设置正确。
TDDL-4600 ERR_FUNCTION

描述：错误的函数调用。

示例：ERR-CODE: [TDDL-4600][ERR_FUNCTION] function compute error by Incorrect parameter count in the call to native function '*****'

说明：该错误表明在SQL语句中使用了错误的语法或参数调用函数。建议仔细检查SQL语句中的函数调用部分，使用正确的参数个数和类型调用函数。
TDDL-4601 ERR_EXECUTOR

示例： ERR-CODE: [TDDL-4601][ERR_EXECUTOR] only one column is supported in distinct aggregate

说明：SQL执行过程出错。该错误代表PolarDB-X在执行SQL语句过程中出现了意外错误。这类错误通常与后端RDS MySQL异常状态有关。
TDDL-4602 ERR_CONVERTOR

描述：错误的类型转换。

示例：ERR-CODE: [TDDL-4602][ERR_CONVERTOR] convertor error by Unsupported convert: [*****]

说明：该错误表明PolarDB-X在执行SQL时进行数据类型转换失败。请检查SQL语句中是否存在需要隐式类型转换的数据，并且尽量使用相同类型进行比较和计算。
TDDL-4603 ERR_ACCROSS_DB_TRANSACTION

描述：跨库事务失败。

示例：ERR-CODE: [TDDL-4603][ERR_ACCROSS_DB_TRANSACTION] Transaction accross db is not supported in current transaction policy, transaction node is: {0}, but this sql execute on: *****.

说明：PolarDB-X默认支持跨库事务，请检查之前是否设置过其他事务策略。
TDDL-4604 ERR_CONCURRENT_TRANSACTION

描述：嵌套事务失败。

示例：ERR-CODE: [TDDL-4604][ERR_CONCURRENT_TRANSACTION] Concurrent query is not supported on transaction group, transaction group is: {0}.

说明：PolarDB-X不支持嵌套事务，如果在同一个数据库连接里尝试同时开启2个以上事务，将提示TDDL-4604错误。
建议在应用开发时避免使用嵌套事务，或者使用应用层的事务框架防止产生嵌套事务。
TDDL-4606 ERR_QUERY_CANCLED

描述：当前执行的SQL被取消。

示例：ERR-CODE: [TDDL-4606][ERR_QUERY_CANCLED] Getting connection is not allowed when query has been cancled, group is *****

说明：使用KILL取消某条SQL语句的执行时，被取消的SQL语句会返回该错误。如果经常出现这一情况，请排查是否有客户端或程序在执行KILL命令。
TDDL-4610 ERR_CONNECTION_CLOSED

描述：连接已经关闭。

示例：ERR-CODE: [TDDL-4610][ERR_CONNECTION_CLOSED] connection has been closed

说明：当事务中的SQL语句执行出错，或者被KILL命令取消后，重复使用同一个数据库连接执行其他SQL语句会提示TDDL-4610错误。
建议在该情况下关闭连接，重新获取一个新的数据库连接。
TDDL-4612 ERR_CHECK_SQL_PRIV

描述：由于权限不够，SQL语句无法执行。

示例：ERR-CODE: [TDDL-4612][ERR_CHECK_SQL_PRIV] check user ***** on db ***** sql privileges failed.

说明：PolarDB-X的新版本支持为账号授权，类似MySQL账号权限体系，只有拥有对应类型权限的账号才能执行该SQL语句。如果账号权限不足，PolarDB-X将提示TDDL-4612错误。
建议检查用户拥有的PolarDB-X权限。如果权限不足，请在PolarDB-X控制台设置。关于PolarDB-X账号与权限设置，请参见管理数据库账号。
TDDL-4614 ERR_EXECUTE_ON_MYSQL

描述：SQL语句在DN上执行报错。

示例： ERR-CODE: [TDDL-4614][ERR_EXECUTE_ON_MYSQL] Error occurs when execute on  GROUP '*****': Duplicate entry '*****' for key 'PRIMARY' PolarDB-X在后端存储节点数据库上执行SQL语句报错，末尾包含了从存储节点返回的原始错误信息，例如：

Duplicate entry '*****' for key 'PRIMARY' 表示写入存储节点数据表发生了主键冲突，订正数据后重新执行。

The table '*****' is full 表示存储节点使用的临时表已满，需要调整临时表空间或优化SQL语句。

Deadlock found when trying to get lock;
表示在存储节点中出现了死锁，通常是数据写入存在较多事务冲突导致的。

INSERT INTO ... ON DUPLICATE KEY UPDATE报错

报错信息：用INSERT INTO ... ON DUPLICATE KEY UPDATE...语句写入数据会遇到Error occurs when execute on GROUP 'PROMOTION_P00000_GROUP' ATOM 'dskeyxxxxxxx000_group#pxc-xdb-s-xxxxxxxxxxx#x.x.x.x-3080#promotion_p00000': Duplicate entry '2024xxxxxxxx' for key 'uk_orderId'报错。

问题原因：UPSERT会分先SELECT FOR UPDATE，如果没有结果则下发INSERT，否则下发UPDATE。用户的隔离级别是读已提交（RC），没有GAP锁，SELECT FOR UPDATE这一结果在并发时并不准确。并且由于修改了分区键，导致RT增加，增大了这一概率。

解决方法：将数据库隔离级别改为可重复读（RR），去掉UPSERT中的分区键，如果只去掉分区键也能极大降低这一概率。

自增主键导致插入报错

报错信息：数据插入失败，SHOW CREATE TABLE看到自增主键为2900006，插入的数据不涉及自增主键id，但是插入报主键错误：[179473d091c1a001][xxxx:3074][nationaltax]ERR-CODE: [TDDL-4614][ERR_EXECUTE_ON_MYSQL] Error occurs when execute on GROUP 'NATIOXXXXXGROUP' ATOM 'dskey_nationaltax_single_group#pxc-xdb-s-pxcxxxxxxqimhg2639#x.x.x.x-3001#nationaltax_single': Duplicate entry '200001' for key 'PRIMARY'。

问题原因：SHOW SEQUENCE展示的是PolarDB-X内部分配的自增值起始值，SHOW CREATE TABLE查看单表时展示的是该表实际数据的最大值+1。执行SHOW SEQUENCE查看当前主键报错表的自增序列值，问题表的自增值为200000，因此报错。

解决办法：执行ALTER SEQUENCE AUTO_SEQ_xxxxxxxx START WITH 修正SEQUENCE的值，更多信息，请参见ALTER SEQUENCE。

含有全局二级索引（GSI）的表UPDATE报错

报错信息：对某些表进行UPDATE操作时出现大量主键冲突报错：TDDL-4614 Error occurs when execute on GROUP 'JMXXXXXXXXXXX00000' ATOM 'dskey_xdafdsfads': Duplicate entry '3204347' for key 'PRIMARY'。

问题原因：报错的UPDATE语句都涉及GLOBAL INDEX上的分区键变更操作。

解决办法：建议删除对应表上的GSI索引再执行UPDATE。

说明 对于分区表的本地索引，可以理解为根据id分区键区分了很多物理表，本地索引是物理表的约束，即根据id分区相同的物理表内，这个唯一约束是生效的，但是从全局来看，是不生效的，需要改为全局二级索引（GSI）才能保证逻辑表全局唯一，对写开销会增加一些。Polardb-X可以保证DN单个物理表唯一，无法保证Polardb-X实例全局唯一，需要利用全局二级索引（GSI）来保证，您可以创建GLOBAL UNIQUE INDEX来保证全局唯一。

说明：建议参见TDDL-4614提供的原始错误信息排查问题。更多关于SQL语句错误信息请参见MySQL 5.6文档。如果排除应用或存储节点问题后仍然发生TDDL-4614错误，请联系技术支持。
TDDL-4616 ERR_UNKNOWN_DATABASE

描述：错误的数据库。

示例：ERR-CODE: [TDDL-4616][ERR_UNKNOWN_DATABASE] Unknown database '*****'

说明：PolarDB-X允许在DDL语句中指定数据库名称。如果指定的数据库名称与PolarDB-X提供的数据库名称不一致，将返回TDDL-4616错误。
建议修改DDL语句中的数据库名称，确保与PolarDB-X数据库名称一致。
TDDL-4620 ERR_FORBID_EXECUTE_DML_ALL 说明：PolarDB-X禁止不带where条件执行delete和update操作。
TDDL-4633 ERR_DB_STATUS_READ_ONLY

示例：ERR-CODE: [TDDL-4633][ERR_DB_STATUS_READ_ONLY] Database is read-only, only read sql are supported

说明：该错误码表示数据库只有读权限，请检查下当前账号的权限是否受限。
TDDL-4636 ERR_DDL_JOB_ERROR DDL语句执行失败。
示例： ERR-CODE: [TDDL-4636][ERR_DDL_JOB_ERROR] xxxx 该错误码表示DDL语句执行失败，处理方法请参见如何处理DDL异常。
TDDL-4642 ERR_UNKNOWN_TABLE 数据库中不存在这张表。
示例： ERR-CODE: [TDDL-4642][ERR_UNKNOWN_TABLE] Unknown table XX.XX 请检查当前数据库中是否有这张表。
TDDL-4707 ERR_OUT_OF_MEMORY

描述：临时表使用内存超限。

示例：ERR-CODE: [TDDL-4707][ERR_OUT_OF_MEMORY]

说明：为了保证数据库稳定性，PolarDB-X限制了每条查询的临时表使用内存量，说明用户当前的查询涉及到的数据比较多，可以打开SPILL或者调大当前查询临时表内存限制。
TDDL-4709 ERR_IVENTORY_HINT_NOT_SUPPORT_CROSS_SHARD

示例：ERR-CODE: [TDDL-4709][ERR_IVENTORY_HINT_NOT_SUPPORT_CROSS_SHARD]

说明：热点秒杀功能要求是单分片事务，如果涉及到多分片事务，会出现该错误。请调整业务逻辑，确保在单分片事务下使用热点功能。
TDDL-4994 ERR_FLOW_CONTROL

描述：流量已达上限。

示例：ERR-CODE: [TDDL-4994][ERR_FLOW_CONTROL] [*****] flow control by *****

说明：该错误代表PolarDB-X处理SQL请求已达到内部流量上限，当前请求被拒绝。建议检查SQL请求量是否存在异常峰值。如果观察到SQL请求量下降后，仍然大量提示TDDL-4994错误，请联系技术支持。
TDDL-4998 ERR_NOT_SUPPORT

描述：不支持的特性。

示例：ERR-CODE: [TDDL-4998][ERR_NOT_SUPPORT] ***** not support yet!

说明：该错误代表使用的SQL语法或者功能PolarDB-X尚不支持。如果这些SQL语法或者功能对您十分重要，请联系技术支持。
TDDL-5001 ERR_TRANS

描述：一般性的事务错误。

示例：ERR-CODE: [TDDL-5001][ERR_TRANS] Too many lines updated in statement.

说明：请参见错误信息处理。

Too many lines updated in statement 事务中的UPDATE语句更新行数超出限制（1000），建议检查UPDATE语句的WHERE条件。如果需要在事务中执行大批量数据更新，可以使用PolarDB-XHint/*TDDL:UNDO_LOG_LIMIT={number}*/调整限制值。

Deferred execution is only supported in Flexible or XA Transaction 后置执行功能仅仅在柔性事务与XA事务策略下可用。在用PolarDB-X的Hint/*TDDL:DEFER*/语句提交后置执行功能之前，请先用SET drds_transaction_policy = ***命令更改PolarDB-X事务策略。

其他错误信息，请联系技术支持。
TDDL-5002 ERR_TRANS_UNSUPPORTED

描述：事务中的语法或功能尚不支持。

示例：ERR-CODE: [TDDL-5002][ERR_TRANS_UNSUPPORTED] Table without primary keys is not supported.

说明：该功能在PolarDB-X事务中尚不支持。如果此功能很重要，请联系技术支持。
TDDL-5003 ERR_TRANS_LOG

描述：无法访问事务日志。

示例：ERR-CODE: [TDDL-5003][ERR_TRANS_LOG] Failed to update transaction state: *****

说明：为保证分布式事务的原子性，PolarDB-X在事务中会访问后端存储节点上的事务日志。如果PolarDB-X在读写事务日志时出错，将返回TDDL-5003错误。
产生TDDL-5003错误的原因通常来自后端的存储节点故障。建议检查PolarDB-X后端存储节点状态和访问压力。如果排除存储节点问题后仍然产生TDDL-5003错误，请联系技术支持。
TDDL-5006 ERR_TRANS_COMMIT

描述：事务提交过程中出错。

示例：ERR-CODE: [TDDL-5006][ERR_TRANS_COMMIT] Failed to commit primary group *****: *****, TRANS_ID = *****

说明：PolarDB-X在提交事务分支过程中出错，TRANS_ID对应的事务将被自动回滚。产生TDDL-5006错误的原因通常来自后端的存储节点故障。建议检查PolarDB-X后端存储节点状态和访问压力。如果排除存储节点问题后仍然产生TDDL-5006错误，请联系技术支持。
TDDL-5008 ERR_TRANS_TERMINATED

描述：事务已被Kill或超时中止。

示例：ERR-CODE: [TDDL-5008][ERR_TRANS_TERMINATED] Current transaction was killed or timeout. You may need to set a longer timeout value.

说明：如果PolarDB-X事务在执行中被Kill或者超时（执行时间超出drds_transaction_timeout值），则出现该错误。如果是事务超时导致报错，建议使用SET drds_transaction_timeout = ***命令修改PolarDB-X事务的执行时间上限，单位是毫秒。
TDDL-5010 ERR_TRANS_CONTINUE_AFTER_WRITE_FAIL

描述：写入失败后，不允许继续进行事务操作。

示例：ERR-CODE: [TDDL-5010][ERR_TRANS_CONTINUE_AFTER_WRITE_FAIL] Cannot continue or commit transaction after writing failed

说明：如果PolarDB-X事务中涉及到分布式事务，执行失败后，不允许继续进行事务，这个时候需要前端主动执行rollback，重试事务操作。您也可以通过日志分析慢事务。
TDDL-5108 ERR_CHECK_PRIVILEGE_FAILED_ON_TABLE 说明：当前账号没有对当前表的操作权限，请检查权限。
TDDL-5119 ERR_FILE_CANNOT_BE_CREATE 说明：PolarDB-X默认关闭对SELECT INTO OUTFILE语句的支持，如有需要请联系技术支持。
TDDL-5302 ERR_GLOBAL_SECONDARY_INDEX_UNSUPPORTED 说明：当前表不支持创建全局二级索引。可能是如下原因导致的：1. 当前表是单表或者广播表；2. 全局二级索引的列不包含分区键。其他情况请联系技术支持。
TDDL-5306 ERR_GLOBAL_SECONDARY_INDEX_INSERT_DUPLICATE_VALUES 说明：在数据写入到全局二级索引表过程中存在主键冲突，请根据报错信息提示的记录值，确认是否存在主键冲突。
TDDL-5308 ERR_GLOBAL_SECONDARY_INDEX_MODIFY_UNIQUE_KEY 说明：在执行DML过程中，全局二级索引表存在唯一键冲突，请根据报错信息提示的记录值，确认是否存在唯一键冲突。
TDDL-5310 ERR_GLOBAL_SECONDARY_INDEX_ONLY_SUPPORT_XA 说明：PolarDB-X只有在XA/TSO分布式事务下，才支持全局二级索引，如果产生此报错，可能业务之前调整过默认事务策略，请调整回XA/TSO分布式事务，再创建全局二级索引。
TDDL-5313 ERR_GLOBAL_SECONDARY_INDEX_MODIFY_GSI_TABLE_WITH_DDL 说明：PolarDB-X默认不支持对全局二级索引表做DDL操作，如有需要请联系技术支持。
TDDL-5316 ERR_GLOBAL_SECONDARY_INDEX_INDEX_AND_SHARDING_COLUMNS_NOT_MATCH 说明：PolarDB-X在创建全局二级索引时，要求索引字段中必须包含全局索引的区键（如果全局索引有多个分区键，例如分库键和分表键，则必须全部包含在索引列中），例如CREATE GLOBAL INDEX idx_1 ON t(a, b) DBPARTITION BY HASH(c)会产生错误TDDL-5316，原因是ON t(a, b)子句指定了a和b为索引列，但未包含全局索引的分区键c。如果产生此报错，请检查DDL语句中索引字段是否包含了全局索引的全部分区键。
TDDL-5317 ERR_GLOBAL_SECONDARY_INDEX_CONTINUE_AFTER_WRITE_FAIL

示例：ERR-CODE: [TDDL-5317][ERR_GLOBAL_SECONDARY_INDEX_CONTINUE_AFTER_WRITE_FAIL] Cannot continue or commit transaction after writing global secondary index failed

说明：在包含GSI的表上执行DML语句时，如果产生此报错，则不允许继续提交包含该失败DML语句的事务。需要修改业务代码，DML报错后需要回滚事务之后重试。
TDDL-5321 ERR_GLOBAL_SECONDARY_INDEX_BACKFILL_DUPLICATE_ENTRY 说明：在创建全局二级索引过程中，数据回填出现了索引表主键冲突，请确认索引表的主键是否存在相同值。
TDDL-8007 ERR_ABANDONED_TASK 说明：查询过慢或者由于不明原因卡住超过2小时，数据库系统会终止查询，出现该异常。请先优化查询，确保不会出现超慢查询，若无法解决，请联系技术支持。
TDDL-8008 ERR_EXECUTE_SPILL 说明：查询过程中，数据过大会触发临时表落盘，这个错误是在数据落盘过程中出现的异常，请联系技术支持。
TDDL-8011 ERR_OUT_OF_SPILL_SPACE 说明：查询过程中，数据过大会触发临时表落盘，如果临时表生产的文件过多，超过了系统允许的可落盘的最大磁盘空间就会出现此错误。请先优化查询，减少计算过程中对临时表的依赖。若无法解决请联系技术支持。
TDDL-8012 ERR_OUT_OF_SPILL_FD 说明：查询过程中，数据过大会触发临时表落盘，如果临时表生产的文件过多，超过了系统允许的文件句柄个数就会出现此错误。请联系技术支持，确保是否存在文件句柄泄漏，若没有泄漏，可以适当调大文件句柄个数限制。
TDDL-8102 ERR_PAGE_TOO_LARGE 说明：在MPP并计算过程中，数据是按批在多个计算节点网络交互，如果一个批的数据过大超过RPC限制最大值，就会出现此错误，可以尝试调小默认CHUNK_SIZE值。
TDDL-8103 ERR_NO_NODES_AVAILABLE 说明：在MPP并行计算过程中可能有计算节点出现故障，导致执行调度之初没有计算节点可调度，请确认计算节点服务是否正常，如果计算节点服务都正常仍然出现报此类错误，请联系技术支持。
TDDL-9301 ERR_DUPLICATED_PARTITION_NAME 说明：在执行分区表相关的DDL操作过程中，使用了相同的分区表名。
TDDL-9305 ERR_PARTITION_NAME_NOT_EXISTS 说明：在执行分区表相关的DDL操作过程中，提示分区表名不存在。请检查下分表名是否拼写正常，使用show create table和 check table检查表元数据是否一致，如果不一致，可能是元数据维护信息不一致导致。请联系技术支持。
TDDL-10004 ERR_X_PROTOCOL_RESULT

示例：ERR-CODE: [TDDL-10004][ERR_X_PROTOCOL_RESULT] Should use chunk2chunk to fetch data

说明：PolarDB-X计算节点和存储节点采用的是私有RPC通信，出现这类异常主要是计算节点和存储节点建立的连接异常，具体原因有很多种，需要查看异常信息，如果无法定位具体问题，请联系技术支持。

上一篇：API参考下一篇：术语表

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
