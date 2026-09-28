# GS\_SESSION\_TIME

GS\_SESSION\_TIME视图用于统计会话线程的运行时间信息，及各执行阶段所消耗时间。

**表 1**  GS\_SESSION\_TIME字段

sessid text 线程标识+线程启动时间。
stat_id integer 统计编号。
stat_name text 会话类型名称。
value bigint 会话值。
