# PG\_STAT\_SYS\_INDEXES

PG\_STAT\_SYS\_INDEXES视图显示pg\_catalog、information\_schema模式中所有系统表的索引状态信息。

**表 1**  PG\_STAT\_SYS\_INDEXES字段

relid oid 这个索引的表的OID。
indexrelid oid 索引的OID。
schemaname name 索引的模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan bigint 索引上开始的索引扫描数。
last_idx_scan timestamptz 索引的最后扫描时间，依据最近一次事务停止时间。
idx_tup_read bigint 通过索引上扫描返回的索引项数。
idx_tup_fetch bigint 通过使用索引的简单索引扫描抓取的活表行数。
