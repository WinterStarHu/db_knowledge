# GLOBAL\_STATEMENT\_COMPLEX\_HISTORY

显示各个节点执行作业结束后的负载管理记录。

**表 1**  GLOBAL\_STATEMENT\_COMPLEX\_HISTORY的字段

datid oid 连接后端的数据库OID。
dbname text 连接后端的数据库名称。
schemaname text 模式的名称。
nodename text 数据库进程名称。
username text 连接到后端的用户名。
application_name text 连接到后端的应用名。
client_addr inet 连接到后端的客户端的IP地址。如果此字段是null，它表明通过服务器机器上UNIX套接字连接客户端或者这是内部进程，如autovacuum。
client_hostname text 客户端的主机名，这个字段是通过client_addr的反向DNS查找得到。这个字段只有在启动log_hostname且使用IP连接时才非空。
client_port integer 客户端用于与后端通讯的TCP端口号，如果使用Unix套接字，则为-1。
query_band text 用于标示作业类型，可通过GUC参数query_band进行设置，默认为空字符串。
block_time bigint 语句执行前的阻塞时间，包含语句解析和优化时间，单位ms。
start_time timestamp with time zone 语句执行的开始时间。
finish_time timestamp with time zone 语句执行的结束时间。
duration bigint 语句实际执行的时间，单位ms。
estimate_total_time bigint 语句预估执行时间，单位ms。
status text 语句执行结束状态：正常为finished，异常为aborted。
abort_info text 语句执行结束状态为aborted时显示异常信息。
resource_pool text 用户使用的资源池。
control_group text 语句所使用的Cgroup。
estimate_memory integer 语句预估使用内存。
min_peak_memory integer 语句在数据库节点上的最小内存峰值，单位MB。
max_peak_memory integer 语句在数据库节点上的最大内存峰值，单位MB。
average_peak_memory integer 语句执行过程中的内存使用平均值，单位MB。
memory_skew_percent integer 语句数据库节点间的内存使用倾斜率。
spill_info text min_spill_size integer 若发生下盘，数据库节点上下盘的最小数据量，单位MB，默认为0。
max_spill_size integer 若发生下盘，数据库节点上下盘的最大数据量，单位MB，默认为0。
average_spill_size integer 若发生下盘，数据库节点上下盘的平均数据量，单位MB，默认为0。
spill_skew_percent integer 若发生下盘，数据库节点间下盘倾斜率。
min_dn_time bigint 语句在数据库节点上的最小执行时间，单位ms。
max_dn_time bigint 语句在数据库节点上的最大执行时间，单位ms。
average_dn_time bigint 语句在数据库节点上的平均执行时间，单位ms。
dntime_skew_percent integer 语句在数据库节点的执行时间倾斜率。
min_cpu_time bigint 语句在数据库节点上的最小CPU时间，单位ms。
max_cpu_time bigint 语句在数据库节点上的最大CPU时间，单位ms。
total_cpu_time bigint 语句在数据库节点上的CPU总时间，单位ms。
cpu_skew_percent integer 语句在数据库节点间的CPU时间倾斜率。
min_peak_iops integer 语句在数据库节点上的每秒最小IO峰值（列存单位是次/s，行存单位是万次/s）。
max_peak_iops integer 语句在数据库节点上的每秒最大IO峰值（列存单位是次/s，行存单位是万次/s）。
average_peak_iops integer 语句在数据库节点上的每秒平均IO峰值（列存单位是次/s，行存单位是万次/s）。
iops_skew_percent integer 语句在数据库节点间的IO倾斜率。
warning text queryid bigint 语句执行使用的内部query id。
query text 执行的语句。
query_plan text 语句的执行计划。
node_group text 语句所属用户对应的逻辑openGauss。
cpu_top1_node_name text cpu使用率第1的节点名称。
cpu_top2_node_name text cpu使用率第2的节点名称。
cpu_top3_node_name text cpu使用率第3的节点名称。
cpu_top4_node_name text cpu使用率第4的节点名称。
cpu_top5_node_name text cpu使用率第5的节点名称。
mem_top1_node_name text 内存使用量第1的节点名称。
mem_top2_node_name text 内存使用量第2的节点名称。
mem_top3_node_name text 内存使用量第3的节点名称。
mem_top4_node_name text 内存使用量第4的节点名称。
mem_top5_node_name text 内存使用量第5的节点名称。
cpu_top1_value bigint cpu使用率。
cpu_top2_value bigint cpu使用率。
cpu_top3_value bigint cpu使用率。
cpu_top4_value bigint cpu使用率。
cpu_top5_value bigint cpu使用率。
mem_top1_value bigint 内存使用量。
mem_top2_value bigint 内存使用量。
mem_top3_value bigint 内存使用量。
mem_top4_value bigint 内存使用量。
mem_top5_value bigint 内存使用量。
top_mem_dn text 内存使用量topN信息。
top_cpu_dn text cpu使用量topN信息。
