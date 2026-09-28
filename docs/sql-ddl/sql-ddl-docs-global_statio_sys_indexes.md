# GLOBAL\_STATIO\_SYS\_INDEXES

GLOBAL\_STATIO\_SYS\_INDEXES视图显示各节点的命名空间中所有系统表索引的IO状态信息。

**表 1**  GLOBAL\_STATIO\_SYS\_INDEXES字段

node_name name 数据库进程名称。
relid oid 索引的表的OID。
indexrelid oid 该索引的OID。
schemaname name 该索引的模式名。
relname name 该索引的表名。
indexrelname name 索引名称。
idx_blks_read numeric 从索引中读取的磁盘块数。
idx_blks_hit numeric 索引命中缓存数。
