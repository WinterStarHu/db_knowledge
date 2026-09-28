# GS\_WLM\_CGROUP\_INFO

GS\_WLM\_CGROUP\_INFO视图显示当前执行作业的控制组的信息。

**表 1**  GS\_WLM\_CGROUP\_INFO字段

cgroup_name text 控制组的名称。
priority interger 作业的优先级。
usage_percent interger 控制组占用的百分比。
shares bigint 控制组分配的CPU资源配额。
cpuacct bigint CPU配额分配。
cpuset text CPU限额分配。
relpath text 控制组的相对路径。
valid text 该控制组是否有效。
node_group text 逻辑数据库实例名称。
