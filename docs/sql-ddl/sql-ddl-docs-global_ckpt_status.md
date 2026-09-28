# GLOBAL\_CKPT\_STATUS

GLOBAL\_CKPT\_STATUS视图用于显示openGauss所有实例的检查点信息和各类日志刷页情况。

示例：

```sql
openGauss=# select * from DBE_PERF.GLOBAL_CKPT_STATUS;
 node_name | ckpt_redo_point | ckpt_clog_flush_num | ckpt_csnlog_flush_num | ckpt_multixact_flush_num | ckpt_predicate_flush_num | ckpt_twophase_flush_num
-----------+-----------------+---------------------+-----------------------+--------------------------+--------------------------+-------------------------
```

**表 1**  GLOBAL\_CKPT\_STATUS字段

node_name text 数据库进程名称。
ckpt_redo_point test 当前实例的检查点。
ckpt_clog_flush_num bigint 从启动到当前时间clog刷盘页面数。
ckpt_csnlog_flush_num bigint 从启动到当前时间csnlog刷盘页面数。
ckpt_multixact_flush_num bigint 从启动到当前时间multixact刷盘页面数。
ckpt_predicate_flush_num bigint 从启动到当前时间predicate刷盘页面数。
ckpt_twophase_flush_num bigint 从启动到当前时间twophase刷盘页面数。
