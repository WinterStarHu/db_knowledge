# GLOBAL\_RECOVERY\_STATUS

GLOBAL\_RECOVERY\_STATUS视图显示关于主机和备机的日志流控信息。

**表 1**  GLOBAL\_RECOVERY\_STATUS字段

node_name text 主机进程名称，包含主机和备机。
standby_node_name text 备机进程名称。
source_ip text 主机的IP地址。
source_port integer 主机的端口号。
dest_ip text 备机的IP地址。
dest_port integer 备机的端口号。
current_rto bigint 备机当前的日志流控时间，单位秒。
target_rto bigint 备机通过GUC参数设置的预期流控时间，单位秒。
current_sleep_time bigint 为了达到这个预期主机所需要的睡眠时间，单位微妙。
