# GS\_SESSION\_STAT

GS\_SESSION\_STAT视图以会话线程或AutoVacuum线程为单位，统计会话状态信息。

**表 1**  GS\_SESSION\_STAT字段

sessid text 线程标识+线程启动时间。
statid integer 统计编号。
statname text 统计会话名称。
statunit text 统计会话单位。
value bigint 统计会话值。
