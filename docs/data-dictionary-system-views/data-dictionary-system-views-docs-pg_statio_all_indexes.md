# PG\_STATIO\_ALL\_INDEXES

PG\_STATIO\_ALL\_INDEXES视图将包含当前数据库中的每个索引行，显示特定索引的I/O的统计。

**表 1**  PG\_STATIO\_ALL\_INDEXES字段

relid oid 索引的表的OID。
indexrelid oid 该索引的OID。
schemaname name 该索引的模式名。
relname name 该索引的表名。
indexrelname name 索引名称。
idx_blks_read bigint 从索引中读取的磁盘块数。
idx_blks_hit bigint 索引命中缓存数。
