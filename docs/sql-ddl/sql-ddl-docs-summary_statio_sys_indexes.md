# SUMMARY\_STATIO\_SYS\_INDEXES

SUMMARY\_STATIO\_SYS\_INDEXES视图显示openGauss内汇聚的命名空间中所有系统表索引的IO状态信息。

**表 1**  SUMMARY\_STATIO\_SYS\_INDEXES字段

schemaname name 该索引的模式名。
relname name 该索引的表名。
indexrelname name 索引名称。
idx_blks_read numeric 从索引中读取的磁盘块数。
idx_blks_hit numeric 索引命中缓存数。
