# GLOBAL\_PAGEWRITER\_STATUS

GLOBAL\_PAGEWRITER\_STATUS视图显示openGauss实例的刷页信息和检查点信息。

**表 1**  GLOBAL\_PAGEWRITER\_STATUS字段

node_name text 数据库进程名称。
pgwr_actual_flush_total_num bigint 从启动到当前时间总计刷脏页数量。
pgwr_last_flush_num integer 上一批刷脏页数量。
remain_dirty_page_num bigint 当前预计还剩余多少脏页。
queue_head_page_rec_lsn text 当前实例的脏页队列第一个脏页的recovery_lsn。
queue_rec_lsn text 当前实例的脏页队列的recovery_lsn。
current_xlog_insert_lsn text 当前实例XLog写入的位置。
ckpt_redo_point text 当前实例的检查点。
