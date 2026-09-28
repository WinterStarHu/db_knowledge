# GLOBAL\_WAIT\_EVENTS

GLOBAL\_WAIT\_EVENTS视图显示各节点的event的等待相关的统计信息。

**表 1**  GLOBAL\_WAIT\_EVENTS字段

nodename text 数据库进程名称。
type text event类型。
event text event名称。
wait bigint 等待次数。
failed_wait bigint 失败的等待次数。
total_wait_time bigint 总等待时间（单位：微秒）。
avg_wait_time bigint 平均等待时间（单位：微秒）。
max_wait_time bigint 最大等待时间（单位：微秒）。
min_wait_time bigint 最小等待时间（单位：微秒）。
last_updated timestamp with time zone 最后一次更新该事件的时间。
