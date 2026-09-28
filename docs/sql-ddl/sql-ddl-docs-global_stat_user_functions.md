# GLOBAL\_STAT\_USER\_FUNCTIONS

提供openGauss中各个节点的用户所创建的函数的状态的统计信息。

**表 1**  GLOBAL\_STAT\_USER\_FUNCTIONS字段

node_name name 数据库进程名称。
funcid oid 函数的id。
schemaname name 此函数所在模式的名称。
funcname name 函数名称。
calls bigint 该函数被调用的次数。
total_time double precision 此函数及其调用的所有其他函数所花费的总时间（以毫秒为单位）。
self_time double precision 在此函数本身中花费的总时间（不包括它调用的其他函数），以毫秒为单位。
