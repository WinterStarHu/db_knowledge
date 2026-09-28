# GLOBAL\_SESSION\_STAT

各节点上以会话线程或AutoVacuum线程为单位，统计会话状态信息。

**表 1**  GLOBAL\_SESSION\_STAT字段

node_name name 数据库进程名称。
sessid text 线程启动时间+线程标识。
statid integer 统计编号。
statname text 统计会话名称。
statunit text 统计会话单位。
value bigint 统计会话值。
