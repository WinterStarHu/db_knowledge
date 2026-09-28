# STATIO\_ALL\_SEQUENCES

STATIO\_ALL\_SEQUENCES视图包含数据库中每个序列的每一行，显示特定序列关于I/O的统计。

**表 1**  STATIO\_ALL\_SEQUENCES字段

relid oid 序列OID。
schemaname name 序列中模式名。
relname name 序列名。
blks_read bigint 从序列中读取的磁盘块数。
blks_hit bigint 序列中缓存命中数。
