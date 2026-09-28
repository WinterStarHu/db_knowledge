# PG\_REPLICATION\_SLOTS

PG\_REPLICATION\_SLOTS视图查看复制槽的信息。

**表 1**  PG\_REPLICATION\_SLOTS字段

slot_name text 复制槽的名称。
plugin text 逻辑复制槽对应的输出插件名称。
slot_type text datoid oid 复制槽所在的数据库OID。
database name 复制槽所在的数据库名称。
active boolean xmin xid 数据库须为复制槽保留的最早事务的事务号。
catalog_xmin xid 数据库须为逻辑复制槽保留的最早的涉及系统表的事务的事务号。
restart_lsn text 复制槽需要的最早xlog的物理位置。
dummy_standby boolean confirmed_flush text 逻辑复制槽专用，客户端确认接收到的日志位置。
