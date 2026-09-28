# LOCAL\_THREADPOOL\_STATUS

LOCAL\_THREADPOOL\_STATUS视图显示线程池下工作线程及会话的状态信息。该视图仅在线程池开启（enable\_thread\_pool = on）时生效。

**表 1**  LOCAL\_THREADPOOL\_STATUS字段

node_name text 数据库进程名称。
group_id integer 线程池组ID。
bind_numa_id integer 该线程池组绑定的NUMA ID。
bind_cpu_number integer 该线程池组绑定的CPU信息。如果未绑定CPU，该值为NULL。
listener integer 该线程池组的Listener线程数量。
worker_info text 线程池中线程相关信息，包括以下信息： default：该线程池组中的初始线程数量。new：该线程池组中新增线程的数量。expect：该线程池组中预期线程的数量。actual：该线程池组中实际线程的数量。idle：该线程池组中空闲线程的数量。pending：该线程池组中等待线程的数量。
session_info text 线程池中会话相关信息，包括以下信息： total：该线程池组中所有的会话数量。waiting：该线程池组中等待调度的会话数量。running：该线程池中正在执行的会话数量。idle：该线程池组中空闲的会话数量。
stream_info text stream池相关信息，包含以下信息： total：该stream池组中所有的线程数量。running：该stream池中正在执行的线程数量。idle：该stream池组中空闲的线程数量。
