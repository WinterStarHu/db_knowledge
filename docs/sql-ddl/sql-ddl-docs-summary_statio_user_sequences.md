# SUMMARY\_STATIO\_USER\_SEQUENCES

SUMMARY\_STATIO\_USER\_SEQUENCES视图显示openGauss内汇聚的命名空间中所有用户关系表类型为序列的IO状态信息。

**表 1**  SUMMARY\_STATIO\_USER\_SEQUENCES字段

schemaname name 序列中模式名。
relname name 序列名。
blks_read numeric 从序列中读取的磁盘块数。
blks_hit numeric 序列中缓存命中数。
