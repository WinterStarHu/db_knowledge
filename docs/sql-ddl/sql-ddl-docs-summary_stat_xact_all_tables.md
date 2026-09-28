# SUMMARY\_STAT\_XACT\_ALL\_TABLES

显示openGauss内汇聚的命名空间中所有普通表和toast表的事务状态信息。

示例：

```sql
openGauss=# select * from DBE_PERF.SUMMARY_STAT_XACT_ALL_TABLES;
     schemaname     |            relname            | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd
--------------------+-------------------------------+----------+--------------+----------+---------------+-----------+-----------+-----------+---------------
```

**表 1**  SUMMARY\_STAT\_XACT\_ALL\_TABLES字段

schemaname name 此表的模式名。
relname name 表名。
seq_scan numeric 此表发起的顺序扫描数。
seq_tup_read numeric 顺序扫描抓取的活跃行数。
idx_scan numeric 此表发起的索引扫描数。
idx_tup_fetch numeric 索引扫描抓取的活跃行数。
n_tup_ins numeric 插入行数。
n_tup_upd numeric 更新行数。
n_tup_del numeric 删除行数。
n_tup_hot_upd numeric HOT更新行数（比如没有更新所需的单独索引）。
