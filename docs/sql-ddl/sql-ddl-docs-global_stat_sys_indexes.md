# GLOBAL\_STAT\_SYS\_INDEXES

得到各节点pg\_catalog、information\_schema以及pg\_toast模式中所有系统表的索引状态信息。

示例：

  ```sql
  openGauss=# select * from DBE_PERF.GLOBAL_STAT_SYS_INDEXES;
   node_name | relid | indexrelid | schemaname |            relname            |                  indexrelname                  | idx_scan | idx_tup_read | idx_tup_fetch
  -----------+-------+------------+------------+-------------------------------+------------------------------------------------+----------+--------------+---------------
  ```

**表 1**  GLOBAL\_STAT\_SYS\_INDEXES字段

node_name name 数据库进程名称。
relid oid 这个索引的表的OID。
indexrelid oid 索引的OID。
schemaname name 索引中模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan bigint 索引上开始的索引扫描数。
idx_tup_read bigint 通过索引上扫描返回的索引项数。
idx_tup_fetch bigint 通过使用索引的简单索引扫描抓取的活表行数。
