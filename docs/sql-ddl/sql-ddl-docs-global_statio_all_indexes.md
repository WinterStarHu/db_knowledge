# GLOBAL\_STATIO\_ALL\_INDEXES

GLOBAL\_STATIO\_ALL\_INDEXES视图包含各节点的数据库中的每个索引行，显示特定索引的I/O的统计。

**表 1**  GLOBAL\_STATIO\_ALL\_INDEXES字段

node_name name 数据库进程名称。
relid oid 索引的表的OID。
indexrelid oid 该索引的OID。
schemaname name 该索引的模式名。
relname name 该索引的表名。
indexrelname name 索引名称。
idx_blks_read numeric 从索引中读取的磁盘块数。
idx_blks_hit numeric 索引命中缓存数。
