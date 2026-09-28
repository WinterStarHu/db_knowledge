# PG\_STAT\_USER\_INDEXES

PG\_STAT\_USER\_INDEXES视图显示数据库中用户自定义普通表和toast表的索引状态信息。

示例：

```sql
openGauss=# select * from PG_STAT_USER_INDEXES;
 relid | indexrelid |   schemaname    |  relname  |   indexrelname   | idx_scan | idx_tup_read | idx_tup_fetch
-------+------------+-----------------+-----------+------------------+----------+--------------+---------------
```

**表 1**  PG\_STAT\_USER\_INDEXES字段

relid oid 这个索引的表的OID。
indexrelid oid 索引的OID。
schemaname name 索引的模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan bigint 索引上开始的索引扫描数。
last_idx_scan timestamptz 索引的最后扫描时间，依据最近一次事务停止时间。
idx_tup_read bigint 通过索引上扫描返回的索引项数。
idx_tup_fetch bigint 通过使用索引的简单索引扫描抓取的活表行数。
