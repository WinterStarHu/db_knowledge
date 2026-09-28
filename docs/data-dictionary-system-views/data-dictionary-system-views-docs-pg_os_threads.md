# PG\_OS\_THREADS

PG\_OS\_THREADS视图提供当前节点下所有线程的状态信息。

**表 1**  PG\_OS\_THREADS字段

node_name text 当前节点的名称。
pid bigint 当前节点进程中正在运行的线程号。
lwpid integer 与pid对应的轻量级线程号。
thread_name text 与pid对应的线程名称。
creation_time timestamp with time zone 与pid对应的线程创建的时间。
