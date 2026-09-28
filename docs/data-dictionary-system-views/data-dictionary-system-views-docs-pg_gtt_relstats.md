# PG\_GTT\_RELSTATS

PG\_GTT\_RELSTATS视图查看当前会话所有全局临时表基本信息，调用pg\_get\_gtt\_relstats函数。

**表 1**  PG\_GTT\_RELSTATS字段

schemaname name schema名称。
tablename name 全局临时表名称。
relfilenode oid 文件对象的ID。
relpages integer 全局临时表的磁盘页面数。
reltuples real 全局临时表的记录数。
relallvisible integer 被标识为全可见的页面数。
relfrozenxid xid 该表中所有在这个之前的事务ID已经被一个固定的（frozen）事务ID替换。
relminmxid xid 预留接口，暂未启用。
