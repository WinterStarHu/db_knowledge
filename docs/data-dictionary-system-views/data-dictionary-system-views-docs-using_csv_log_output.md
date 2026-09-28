# 使用CSV格式写日志

## 前提条件

- [log\_destination](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_sb6c9884f69bd4765a60f80810c94f194)的值设置为csvlog。
- [logging\_collector](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_s61d6090c04ee464fb54f8b31936ba818)的值设置为on。

## csvlog定义

以“逗号分隔值” 即CSV（Comma Separated Value）的形式发出日志。

以下是简单的用来存储CSV形式日志输出的表定义：

```
CREATE TABLE gaussdb_log
(
log_time timestamp(3) with time zone,
node_name text,
user_name text,
database_name text,
process_id bigint,
connection_from text,
"session_id" text,
session_line_num bigint,
command_tag text,
session_start_time timestamp with time zone,
virtual_transaction_id text,
transaction_id bigint,
query_id bigint,
module text,
error_severity text,
sql_state_code text,
message text,
detail text,
hint text,
internal_query text,
internal_query_pos integer,
context text,
query text,
query_pos integer,
location text,
application_name text
);
```

详细说明请参见[表1](#zh-cn_topic_0237124724_zh-cn_topic_0059779007_zh-cn_topic_0058967802_table44188316)。

**表 1**  csvlog字段含义表

字段名 字段含义 字段名 字段含义 log_time 毫秒级的时间戳 module 日志所属模块 node_name 节点名称 error_severity ERRORSTATE代码 user_name 用户名 sql_state_code SQLSTATE代码 database_name 数据库名 message 错误消息 process_id 进程ID detail 详细错误消息 connection_from 客户主机：端口号 hint session_id 会话ID internal_query 内部查询（查询那些导致错误的信息，如果有的话） session_line_num 每个会话的行数 internal_query_pos 内部查询指针 command_tag 命令标签 context session_start_time 会话开始时间 query 错误发生位置的字符统计 virtual_transaction_id 常规事务 query_pos 错误发生位置指针 transaction_id 事务ID location 在openGauss源代码中错误的位置（如果log_error_verbosity的值设为verbose） query_id 查询ID application_name 应用名称

使用COPY FROM命令将日志文件导入这个表：

```
COPY gaussdb_log FROM '/opt/data/pg_log/logfile.csv' WITH csv;
```

>[!NOTE]说明
>此处的日志名“logfile.csv”要换成实际生成的日志的名称。

## 简化输入

简化输入到CSV日志文件，可以通过如下操作：

- 设置[log\_filename](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_s3226ae3209154e249928c24ec67c5809)和[log\_rotation\_age](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_s3ce09b8a7ae543b18fae13a821a725a5)，为日志文件提供一个一致的、可预测的命名方案。通过日志文件名，预测一个独立的日志文件完成并进入准备导入状态的时间。
- 将[log\_rotation\_size](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_s282e72143bb14915bedb4b432586b07e)设为0来终止基于尺寸的日志回滚，因为基于尺寸的日志回滚让预测日志文件名变得非常的困难。
- 将[log\_truncate\_on\_rotation](logging_destination.md#zh-cn_topic_0283136719_zh-cn_topic_0237124721_zh-cn_topic_0059778787_s143b6d35ddbe48b8810106a4d3929e8a)设为on以便区分在同一日志文件中旧的日志数据和新的日志数据。
