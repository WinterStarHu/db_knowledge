# GLOBAL\_STATIO\_USER\_SEQUENCES

GLOBAL\_STATIO\_USER\_SEQUENCES视图显示各节点的命名空间中所有用户关系表类型为序列的IO状态信息。

**表 1**  GLOBAL\_STATIO\_USER\_SEQUENCES字段

node_name name 数据库进程名称。
relid oid 序列OID。
schemaname name 序列中模式名。
relname name 序列名。
blks_read bigint 从序列中读取的磁盘块数。
blks_hit bigint 序列中缓存命中数。
