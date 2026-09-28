# GLOBAL\_INSTANCE\_TIME

提供openGauss中所有正常节点下的各种时间消耗信息（时间类型见instance\_time视图）。

**表 1**  GLOBAL\_INSTANCE\_TIME字段

node_name name 数据库进程的名称。
stat_id integer 统计编号。
stat_name text 类型名称。
value bigint 时间值（单位：微秒）。
