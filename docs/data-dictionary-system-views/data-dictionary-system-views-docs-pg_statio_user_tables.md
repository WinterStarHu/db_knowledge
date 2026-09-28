# PG\_STATIO\_USER\_TABLES

PG\_STATIO\_USER\_TABLES视图显示命名空间中所有用户关系表的IO状态信息。

示例：

```sql
openGauss=# select * from PG_STATIO_USER_TABLES;
 relid |   schemaname    |    relname    | heap_blks_read | heap_blks_hit | idx_blks_read | idx_blks_hit | toast_blks_read | toast_blks_hit | tidx_blks_read | tidx_blks_hit
-------+-----------------+---------------+----------------+---------------+---------------+--------------+-----------------+----------------+----------------+---------------
```

**表 1**  PG\_STATIO\_USER\_TABLES字段

relid oid 表OID。
schemaname name 该表模式名。
relname name 表名。
heap_blks_read bigint 从该表中读取的磁盘块数。
heap_blks_hit bigint 该表缓存命中数。
idx_blks_read bigint 从表中所有索引读取的磁盘块数。
idx_blks_hit bigint 表中所有索引命中缓存数。
toast_blks_read bigint 该表的TOAST表读取的磁盘块数（如果存在）。
toast_blks_hit bigint 该表的TOAST表命中缓冲区数（如果存在）。
tidx_blks_read bigint 该表的TOAST表索引读取的磁盘块数（如果存在）。
tidx_blks_hit bigint 该表的TOAST表索引命中缓冲区数（如果存在）。
