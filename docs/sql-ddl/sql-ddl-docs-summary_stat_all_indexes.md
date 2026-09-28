# SUMMARY\_STAT\_ALL\_INDEXES

将包含openGauss内汇聚数据库中的每个索引行，显示访问特定索引的统计。

**表 1**  SUMMARY\_STAT\_ALL\_INDEXES字段

schemaname name 索引中模式名。
relname name 索引的表名。
indexrelname name 索引名。
idx_scan numeric 索引上开始的索引扫描数。
idx_tup_read numeric 通过索引上扫描返回的索引项数。
idx_tup_fetch numeric 通过使用索引的简单索引扫描抓取的活表行数。
