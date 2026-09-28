# GLOBAL\_REDO\_STATUS

GLOBAL\_REDO\_STATUS视图显示openGauss实例的日志回放情况。

示例：

```sql
openGauss=# select * from DBE_PERF.GLOBAL_REDO_STATUS;
 node_name | redo_start_ptr | redo_start_time | redo_done_time | curr_time | min_recovery_point | read_ptr | last_replayed_read_ptr | recovery_done_ptr | read_xlog_io_counter | read_xlog_io_total_dur | read_data_io_counter | read_data_io_total_dur | write_data_io_counter | write_data_io_total_dur | process_pending_counter | process_pending_total_dur | apply_counter | apply_total_dur | speed | local_max_ptr | primary_flush_ptr |   worker_info
-----------+----------------+-----------------+----------------+-----------+--------------------+----------+------------------------+-------------------+----------------------+------------------------+----------------------+------------------------+-----------------------+-------------------------+-------------------------+---------------------------+---------------+-----------------+-------+---------------+-------------------+------------------
```

**表 1**  GLOBAL\_REDO\_STATUS字段

node_name text 数据库进程名称。
redo_start_ptr bigint 当前实例日志回放的起始点。
redo_start_time bigint 当前实例日志回放的起始UTC时间。
redo_done_time bigint 当前实例日志回放的结束UTC时间。
curr_time bigint 当前实例的当前UTC时间。
min_recovery_point bigint 当前实例日志的最小一致性点位置。
read_ptr bigint 当前实例日志的读取位置。
last_replayed_read_ptr bigint 当前实例的日志回放位置。
recovery_done_ptr bigint 当前实例启动完成时的回放位置。
read_xlog_io_counter bigint 当前实例读取回放日志的io次数计数。
read_xlog_io_total_dur bigint 当前实例读取回放日志的io总时延。
read_data_io_counter bigint 当前实例回放过程中读取数据页面的io次数计数。
read_data_io_total_dur bigint 当前实例回放过程中读取数据页面的io总时延。
write_data_io_counter bigint 当前实例回放过程中写数据页面的io次数计数。
write_data_io_total_dur bigint 当前实例回放过程中写数据页面的io总时延。
process_pending_counter bigint 当前实例回放过程中日志分发线程的同步次数计数。
process_pending_total_dur bigint 当前实例回放过程中日志分发线程的同步总时延。
apply_counter bigint 当前实例回放过程中回放线程的同步次数计数。
apply_total_dur bigint 当前实例回放过程中回放线程的同步总时延。
speed bigint 当前实例日志回放速率。
local_max_ptr bigint 当前实例启动成功后本地收到的回放日志的最大值。
primary_flush_ptr bigint 主机落盘日志的位置。
worker_info text 当前实例回放线程信息，若没有开并行回放则该值为空。
