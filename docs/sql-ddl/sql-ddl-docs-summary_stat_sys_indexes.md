# SUMMARY\_STAT\_SYS\_INDEXES

openGauss内汇聚pg\_catalog、information\_schema以及pg\_toast模式中所有系统表的索引状态信息。

示例：

```sql
openGauss=# select * from DBE_PERF.SUMMARY_STAT_SYS_INDEXES;
 schemaname |            relname            |                  indexrelname                  | idx_scan | idx_tup_read | idx_tup_fetch
------------+-------------------------------+------------------------------------------------+----------+--------------+---------------
```

**表 1**  SUMMARY\_STAT\_SYS\_INDEXES字段

schemaname name 索引中模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan numeric 索引上开始的索引扫描数。
idx_tup_read numeric 通过索引上扫描返回的索引项数。
idx_tup_fetch numeric 通过使用索引的简单索引扫描抓取的活表行数。
