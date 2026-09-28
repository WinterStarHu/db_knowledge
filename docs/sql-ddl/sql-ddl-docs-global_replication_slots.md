# GLOBAL\_REPLICATION\_SLOTS

GLOBAL\_REPLICATION\_SLOTS视图用于查看openGauss各节点的复制节点的信息。

**表 1**  GLOBAL\_REPLICATION\_SLOTS字段

node_name name 数据库进程名称。
slot_name text 复制节点的名称。
plugin text 插件名称。
slot_type text 复制节点的类型。
datoid oid 复制节点的数据库OID。
database name 复制节点的数据库名称。
active boolean 复制节点是否为激活状态。
x_min xid 复制节点事务标识。
catalog_xmin xid 逻辑复制槽对应的最早解码事务标识.
restart_lsn text 复制节点的Xlog文件信息。
dummy_standby boolean 复制节点是否为假备。
