# GS\_SQL\_LIMIT

GS\_SQL\_LIMIT系统表存储所有SQL防火墙规则的信息。

**表 1**  GS\_SQL\_LIMIT字段

limit_id int8 规则ID。
limit_name name 规则名称。
is_valid boolean 是否生效。当时间范围无效或最大并发数为负时，表示不生效。
work_node int1 生效的节点。0表示生效所有节点，1表示生效主节点，2表示生效备节点。其他值默认生效备节点 max_concurrency int8 最大并发数。-1表示不生效。
start_time timestampTz 生效时间。
end_time timestampTz 失效时间。
limit_type text 规则类型。支持sqlid，select，insert，update，delete。
databases name[] 数据库列表。
users name[] 用户列表。
limit_opt text[] 规则具体内容。
