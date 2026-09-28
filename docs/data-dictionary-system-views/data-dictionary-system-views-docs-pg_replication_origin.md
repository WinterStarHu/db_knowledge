# PG\_REPLICATION\_ORIGIN

PG\_REPLICATION\_ORIGIN系统表包含所有已创建的复制源，该表为全局共享表，即在每个节点上只有一份pg\_replication\_origin，而不是每个数据库一份。

**表 1**  PG\_REPLICATION\_ORIGIN字段

roident oid 一个集群范围内唯一的复制源标识符。
roname text 外部的由用户定义的复制源名称。
