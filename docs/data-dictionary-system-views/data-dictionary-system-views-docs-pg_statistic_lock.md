# PG_STATISTIC_LOCK

PG_STATISTIC_LOCK表用于记录对统计信息操作加锁状态。

**表 1** PG_STATISTIC_LOCK字段

namespaceid oid 操作加锁对象schema的Oid stalocktype char 操作加锁标志类型 s：指定当前锁对象类型为schema。
t：指定当前锁对象类型为表。
p：指定当前锁对象类型为分区。
relid oid 操作加锁表的Oid partid oid 操作加锁分区的Oid lock bool 标志当前对象是否上锁
