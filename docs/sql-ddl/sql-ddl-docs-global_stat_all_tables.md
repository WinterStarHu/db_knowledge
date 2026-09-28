# GLOBAL\_STAT\_ALL\_TABLES

得到各节点数据中每个表的一行（包括TOAST表）的统计信息。

```sql
openGauss=# select * from DBE_PERF.GLOBAL_STAT_ALL_TABLES;
 node_name | relid |     schemaname     |            relname            | seq_scan | seq_tup_read | idx_scan | idx_tup_fetch | n_tup_ins | n_tup_upd | n_tup_del | n_tup_hot_upd | n_live_tup | n_dead_tup | last_vacuum | last_autovacuum | last_analyze | last_autoanalyze | vacuum_count | autovacuum_count | analyze_count | autoanalyze_count
-----------+-------+--------------------+-------------------------------+----------+--------------+----------+---------------+-----------+-----------+-----------+---------------+------------+------------+-------------+-----------------+--------------+------------------+--------------+------------------+---------------+-------------------
```

**表 1**  GLOBAL\_STAT\_ALL\_TABLES字段

node_name name 数据库进程名称。
relid oid 表的OID。
schemaname name 此表的模式名。
relname name 表名。
seq_scan bigint 此表发起的顺序扫描数。
seq_tup_read bigint 顺序扫描抓取的活跃行数。
idx_scan bigint 此表发起的索引扫描数。
idx_tup_fetch bigint 索引扫描抓取的活跃行数。
n_tup_ins bigint 插入行数。
n_tup_upd bigint 更新行数。
n_tup_del bigint 删除行数。
n_tup_hot_upd bigint HOT更新行数（比如没有更新所需的单独索引）。
n_live_tup bigint 估计活跃行数。
n_dead_tup bigint 估计死行数。
last_vacuum timestamp with time zone 最后一次此表是手动清理的（不计算VACUUM FULL）的时间。
last_autovacuum timestamp with time zone 上次被autovacuum守护进程清理的时间。
last_analyze timestamp with time zone 上次手动分析这个表的时间。
last_autoanalyze timestamp with time zone 上次被autovacuum守护进程分析时间。
vacuum_count bigint 这个表被手动清理的次数（不计算VACUUM FULL）。
autovacuum_count bigint 这个表被autovacuum清理的次数。
analyze_count bigint 这个表被手动分析的次数。
autoanalyze_count bigint 这个表被autovacuum守护进程分析的次数。
