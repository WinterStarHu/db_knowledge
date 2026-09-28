# PG\_STAT\_USER\_TABLES

PG\_STAT\_USER\_TABLES视图显示所有命名空间中用户自定义普通表和toast表的状态信息。

示例：

```sql
openGauss=# select * from PG_STAT_USER_TABLES;
 relid |   schemaname    |    relname    | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd | n_live_tup | n_dead_tup | last_vacuum | last_autovacuum | last_analyze | last_autoanalyze | vacuum_count | autovacuum_count | analyze_count | autoanalyze_count | last_data_changed
-------+-----------------+---------------+----------+--------------+----------+---------------+-----------+-----------+-----------+---------------+------------+------------+-------------+-----------------+--------------+------------------+--------------+------------------+---------------+-------------------+-------------------
```

**表 1**  PG\_STAT\_USER\_TABLES字段

relid oid 表的OID。
schemaname name 该表的模式名。
relname name 表名。
seq_scan bigint 该表发起的顺序扫描数。
last_seq_scan timestamptz 表的最后顺序扫描时间，依据最近一次事务停止时间。
seq_tup_read bigint 顺序扫描抓取的活跃行数。
idx_scan bigint 该表发起的索引扫描数。
last_idx_scan timestamptz 表的最后索引扫描时间，依据最近一次事务停止时间。
idx_tup_fetch bigint 索引扫描抓取的活跃行数。
n_tup_ins bigint 插入行数。
n_tup_upd bigint 更新行数。
n_tup_del bigint 删除行数。
n_tup_hot_upd bigint HOT更新行数（即没有更新所需的单独索引）。
n_live_tup bigint 估计活跃行数。
n_dead_tup bigint 估计死行数。
last_vacuum timestamp with time zone 最后一次该表是手动清理的（不计算VACUUM FULL）。
last_autovacuum timestamp with time zone 上次被autovacuum守护进程清理的表。
last_analyze timestamp with time zone 上次手动分析这个表。
last_autoanalyze timestamp with time zone 上次被autovacuum守护进程分析的表。
vacuum_count bigint 这个表被手动清理的次数（不计算VACUUM FULL）。
autovacuum_count bigint 这个表被autovacuum清理的次数。
analyze_count bigint 这个表被手动分析的次数。
autoanalyze_count bigint 这个表被autovacuum守护进程分析的次数。
last_data_changed timestamp with time zone 这个表数据最近修改时间。
