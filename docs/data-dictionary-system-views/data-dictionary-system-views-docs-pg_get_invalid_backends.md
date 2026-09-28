# PG\_GET\_INVALID\_BACKENDS

PG\_GET\_INVALID\_BACKENDS视图提供显示数据库主节点上连接到当前备机的后台线程信息。

**表 1**  PG\_GET\_INVALID\_BACKENDS字段

pid bigint 线程ID。
node_name text 后台线程中连接的节点信息。
dbname name 当前连接的数据库。
backend_start timestamp with time zone 后台线程启动的时间。
query text 后台线程正在执行的查询语句。
