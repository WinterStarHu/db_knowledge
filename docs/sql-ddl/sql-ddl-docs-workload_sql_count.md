# WORKLOAD\_SQL\_COUNT

显示当前节点workload上的SQL数量分布。普通用户只可以看到自己在workload上的SQL分布；初始用户可以看到总的workload的负载情况。

**表 1**  WORKLOAD\_SQL\_COUNT字段

workload name 负载名称。
select_count bigint select数量。
update_count bigint update数量。
insert_count bigint insert数量。
delete_count bigint delete数量。
ddl_count bigint ddl数量。
dml_count bigint dml数量。
dcl_count bigint dcl数量。
