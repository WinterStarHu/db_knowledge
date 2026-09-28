# WAIT\_EVENTS

WAIT\_EVENTS显示当前节点的event的等待相关的统计信息。具体事件信息见[等待状态列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_zh-cn_topic_0059777957_t794f802302c24514a5db22d51eabacc4)、[轻量级锁等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table38811324183420)、[IO等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table124603113369)和[事务锁等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table11826123533718)。关于每种事务锁对业务的影响程度，请参考[LOCK](lock_sql.md)语法小节的详细描述。

**表 1**  WAIT\_EVENTS字段

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
