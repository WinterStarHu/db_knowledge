# SUMMARY\_WORKLOAD\_SQL\_COUNT

显示openGauss内各数据库主节点的workload上的SQL数量分布。

**表 1**  SUMMARY\_WORKLOAD\_SQL\_COUNT字段

node_name name 数据库进程名称。
workload name 负载名称。
select_count bigint select数量。
update_count bigint update数量。
insert_count bigint insert数量。
delete_count bigint delete数量。
ddl_count bigint ddl数量。
dml_count bigint dml数量。
dcl_count bigint dcl数量。
