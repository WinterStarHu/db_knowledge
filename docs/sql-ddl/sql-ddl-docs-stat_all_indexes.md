# STAT\_ALL\_INDEXES

将包含本节点数据库中的每个索引行，显示访问特定索引的统计。

**表 1**  STAT\_ALL\_INDEXES字段

relid oid 这个索引的表的OID。
indexrelid oid 索引的OID。
schemaname name 索引中模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan bigint 索引上开始的索引扫描数。
idx_tup_read bigint 通过索引上扫描返回的索引项数。
idx_tup_fetch bigint 通过使用索引的简单索引扫描抓取的活表行数。
