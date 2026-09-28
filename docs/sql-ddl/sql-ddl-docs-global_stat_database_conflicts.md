# GLOBAL\_STAT\_DATABASE\_CONFLICTS

显示每个节点的数据库冲突状态的统计信息。

**表 1**  GLOBAL\_STAT\_DATABASE\_CONFLICTS字段

node_name name 数据库进程名称。
datid oid 数据库标识。
datname name 数据库名称。
confl_tablespace bigint 冲突的表空间的数目。
confl_lock bigint 冲突的锁数目。
confl_snapshot bigint 冲突的快照数目。
confl_bufferpin bigint 冲突的缓冲区数目。
confl_deadlock bigint 冲突的死锁数目。
