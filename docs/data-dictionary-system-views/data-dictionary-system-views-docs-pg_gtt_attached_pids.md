# PG\_GTT\_ATTACHED\_PIDS

PG\_GTT\_ATTACHED\_PIDS视图查看哪些会话正在使用全局临时表，调用pg\_get\_attached\_pid函数。

**表 1**  PG\_GTT\_ATTACHED\_PIDS字段

schemaname name schema名称。
tablename name 全局临时表名称。
relid oid 全局临时表的oid。
pids bigint[] 线程pid列表。
