# 调试

用户可以根据自己的需要，通过修改实例数据目录下的postgresql.conf文件中特定的配置参数来控制日志的输出，从而更好地了解数据库的运行状态。

可调整的配置参数请参见[表1](#zh-cn_topic_0237120444_zh-cn_topic_0059779333_tec23904511dd4695b8b01f8c7c04563a)。

**表 1**  配置参数

参数名称 取值范围 client_min_messages 配置发送到客户端信息的级别。
DEBUG5DEBUG4DEBUG3DEBUG2DEBUG1LOGNOTICEWARNINGERRORFATALPANIC 默认值：NOTICE 。
设置级别后，发送到客户端的信息包含所设级别及以下所有低级别会发送的信息。级别越低，发送的信息越少。
log_min_messages 配置写到服务器日志里信息的级别。
DEBUG5DEBUG4DEBUG3DEBUG2DEBUG1INFONOTICEWARNINGERRORLOGFATALPANIC 默认值：WARNING。
指定某一级别后，写到日志的信息包含所有更高级别会输出的信息。级别越高，服务器日志的信息越少。
log_min_error_statement 配置写到服务器日志中错误SQL语句的级别。
DEBUG5DEBUG4DEBUG3DEBUG2DEBUG1INFONOTICEWARNINGERRORFATALPANIC 缺省值：ERROR。
所有导致一个特定级别（或者更高级别）错误的SQL语句都将记录在服务器日志中。
只有系统管理员可以修改该参数。
log_min_duration_statement 配置语句执行持续的最短时间。如果某个语句的持续时间大于或者等于设置的毫秒数，则会在日志中记录该语句及其持续时间。打开这个选项可以方便地跟踪需要优化的查询。
INT类型。
默认值：30min。
单位：毫秒。
设置为-1表示关闭这个功能。
只有系统管理员可以修改该参数。
log_connections/log_disconnections 配置是否在每次会话连接或结束时向服务器日志里打印一条信息。
on：每次会话连接或结束时向日志里打印一条信息。off：每次会话连接或结束时不向日志里打印信息。
默认值：off。
log_duration 配置是否记录每个已完成语句的持续时间。
on：记录每个已完成语句的持续时间。off：不记录已完成语句的持续时间。
默认值：off 。
只有系统管理员可以修改该参数。
log_statement 配置日志中记录哪些SQL语句。
none：不记录任何SQL语句。ddl：记录数据定义语句。mod：记录数据定义语句和数据操作语句。all ：记录所有语句。
默认值： none。
只有系统管理员可以修改该参数。
log_hostname 配置是否记录主机名。
on：记录主机名。off：不记录主机名。
默认值：off。
缺省时，连接日志只记录所连接主机的IP地址。打开这个选项会同时记录主机名。
该参数同时影响 查看审计结果、GS_WLM_SESSION_HISTORY、PG_STAT_ACTIVITY和log_line_prefix参数。
log_online_ddl_level 配置在线DDL相关调试日志的日志级别。
0: 流程相关的必要日志NOTICE级别，tuple相关调试日志DEBUG级别1：tuple相关调试日志LOG级别。2: tuple相关调试日志NOTICE级别 默认值：0。
SIGHUP级别

上表有关参数级别的说明请参见[表2](#zh-cn_topic_0237120444_zh-cn_topic_0059779333_t3c729a4a94d145c7bdc4ca788236d8a7)。

**表 2**  日志级别参数说明

DEBUG[1-5] 提供开发人员使用的信息。5级为最高级别，依次类推，1级为最低级别。
INFO 提供用户隐含要求的信息。如在VACUUM VERBOSE过程中的信息。
NOTICE 提供可能对用户有用的信息。如长标识符的截断，作为主键一部分创建的索引。
WARNING 提供给用户的警告。如在事务块范围之外的COMMIT。
ERROR 报告导致当前命令退出的错误。
LOG 报告一些管理员感兴趣的信息。如检查点活跃性。
FATAL 报告导致当前会话终止的原因。
PANIC 报告导致所有会话退出的原因。
