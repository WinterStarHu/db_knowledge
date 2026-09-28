# PG\_STAT\_XACT\_ALL\_TABLES

PG\_STAT\_XACT\_ALL\_TABLES视图显示命名空间中所有普通表和toast表的事务状态信息。

示例：

```sql
openGauss=# select * from PG_STAT_XACT_ALL_TABLES;
 relid |     schemaname     |            relname            | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd
-------+--------------------+-------------------------------+----------+--------------+----------+---------------+-----------+-----------+-----------+---------------
```

**表 1**  PG\_STAT\_XACT\_ALL\_TABLES字段

relid oid 表的OID。
schemaname name 该表的模式名。
relname name 表名。
seq_scan bigint 该表发起的顺序扫描数。
seq_tup_read bigint 顺序扫描抓取的活跃行数。
idx_scan bigint 该表发起的索引扫描数。
idx_tup_fetch bigint 索引扫描抓取的活跃行数。
n_tup_ins bigint 插入行数。
n_tup_upd bigint 更新行数。
n_tup_del bigint 删除行数。
n_tup_hot_upd bigint HOT更新行数（比如没有更新所需的单独索引）。
