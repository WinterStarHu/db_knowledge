# GLOBAL\_THREAD\_WAIT\_STATUS

通过该视图可以检测所有节点上工作线程（backend thread）以及辅助线程（auxiliary thread）的阻塞等待情况。具体事件信息请参见[15.3.67-表2 等待状态列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_zh-cn_topic_0059777957_t794f802302c24514a5db22d51eabacc4)、[15.3.67-表3 轻量级锁等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table38811324183420)、[15.3.67-表4 IO等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table124603113369)和[15.3.67-表5 事务锁等待事件列表](../database_reference/pg_thread_wait_status.md#zh-cn_topic_0283136724_zh-cn_topic_0237122466_table11826123533718)。

通过GLOBAL\_THREAD\_WAIT\_STATUS视图，可以查看openGauss全局各个节点上所有SQL语句产生的线程之间的调用层次关系，以及各个线程的阻塞等待状态，从而更容易定位hang以及类似现象的原因。

GLOBAL\_THREAD\_WAIT\_STATUS视图和THREAD\_WAIT\_STATUS视图列定义完全相同，这是由于GLOBAL\_THREAD\_WAIT\_STATUS视图本质是到openGauss中各个节点上查询THREAD\_WAIT\_STATUS视图汇总的结果。

**表 1**  GLOBAL\_THREAD\_WAIT\_STATUS字段

node_name text 数据库进程名称。
db_name text 数据库名称。
thread_name text 线程名称。
query_id bigint 查询ID，对应debug_query_id。
tid bigint 当前线程的线程号。
sessionid bigint session的ID。
lwtid integer 当前线程的轻量级线程号。
psessionid bigint streaming线程的父线程。
tlevel integer streaming线程的层级。
smpid integer 并行线程的ID。
wait_status text 当前线程的等待状态。等待状态的详细信息请参见15.3.67-表2 等待状态列表。
wait_event text 如果wait_status是acquire lock、acquire lwlock、wait io三种类型，此列描述具体的锁、轻量级锁、IO的信息。否则是空。
locktag text 当前线程正在等待锁的信息。
lockmode text 当前线程正等待获取的锁模式。包含表级锁、行级锁、页级锁下的各模式。
block_sessionid bigint 阻塞当前线程获取锁的会话标识。
global_sessionid text 全局会话ID。
