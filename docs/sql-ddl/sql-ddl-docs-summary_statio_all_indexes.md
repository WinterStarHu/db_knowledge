# SUMMARY\_STATIO\_ALL\_INDEXES

SUMMARY\_STATIO\_ALL\_INDEXES视图包含openGauss内汇聚的数据库中的每个索引行， 显示特定索引的I/O的统计。

schemaname name 该索引的模式名。
relname name 该索引的表名。
indexrelname name 索引名称。
idx_blks_read numeric 从索引中读取的磁盘块数。
idx_blks_hit numeric 索引命中缓存数。
