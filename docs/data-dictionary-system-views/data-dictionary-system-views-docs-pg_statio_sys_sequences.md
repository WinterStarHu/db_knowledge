# PG\_STATIO\_SYS\_SEQUENCES

PG\_STATIO\_SYS\_SEQUENCES视图显示命名空间中所有序列的IO状态信息。

**表 1**  PG\_STATIO\_SYS\_SEQUENCES字段

relid oid 序列OID。
schemaname name 序列中模式名。
relname name 序列名。
blks_read bigint 从序列中读取的磁盘块数。
blks_hit bigint 序列中缓存命中数。
