# SUMMARY\_STAT\_XACT\_SYS\_TABLES

显示openGauss内汇聚的命名空间中系统表的事务状态信息。

**表 1**  SUMMARY\_STAT\_XACT\_SYS\_TABLES字段

schemaname name 此表的模式名。
relname name 表名。
seq_scan numeric 此表发起的顺序扫描数。
seq_tup_read numeric 顺序扫描抓取的活跃行数。
idx_scan numeric 此表发起的索引扫描数。
idx_tup_fetch numeric 索引扫描抓取的活跃行数。
n_tup_ins numeric 插入行数。
n_tup_upd numeric 更新行数。
n_tup_del numeric 删除行数。
n_tup_hot_upd numeric HOT更新行数（比如没有更新所需的单独索引）。
