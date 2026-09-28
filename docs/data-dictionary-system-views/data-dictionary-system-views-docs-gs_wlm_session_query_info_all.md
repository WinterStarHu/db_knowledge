# GS\_WLM\_SESSION\_QUERY\_INFO\_ALL

GS\_WLM\_SESSION\_QUERY\_INFO\_ALL系统表显示当前数据库实例执行作业结束后的负载管理记录。此数据是从内核中转储到系统表中的数据。当设置GUC参数[enable\_resource\_record](workload_management.md)为on时，系统会定时（周期为3分钟）将内核中query信息导入GS\_WLM\_SESSION\_QUERY\_INFO\_ALL系统表。查询该系统表需要sysadmin权限，且仅在数据库postgres下面查询时有数据。

**表 1**  GS\_WLM\_SESSION\_QUERY\_INFO\_ALL字段

datid oid 连接后端的数据库OID。
dbname text 连接后端的数据库名称。
schemaname text 模式的名称。
nodename text 语句执行的数据库实例名称。
username text 连接到后端的用户名。
application_name text 连接到后端的应用名。
client_addr inet 连接到后端的客户端的IP地址。 如果此字段是null，它表明通过服务器机器上UNIX套接字连接客户端或者这是内部进程，如autovacuum。
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
estimate_memory integer 语句估算内存大小。
min_peak_memory integer 语句在数据库实例上的最小内存峰值，单位MB。
max_peak_memory integer 语句在数据库实例上的最大内存峰值，单位MB。
average_peak_memory integer 语句执行过程中的内存使用平均值，单位MB。
memory_skew_percent integer 语句数据库实例间的内存使用倾斜率。
spill_info text min_spill_size integer 若发生下盘，数据库实例上下盘的最小数据量，单位MB，默认为0。
max_spill_size integer 若发生下盘，数据库实例上下盘的最大数据量，单位MB，默认为0。
average_spill_size integer 若发生下盘，数据库实例上下盘的平均数据量，单位MB，默认为0。
spill_skew_percent integer 若发生下盘，数据库实例间下盘倾斜率。
min_dn_time bigint 语句在数据库实例上的最小执行时间，单位ms。
max_dn_time bigint 语句在数据库实例上的最大执行时间，单位ms。
average_dn_time bigint 语句在数据库实例上的平均执行时间，单位ms。
dntime_skew_percent integer 语句在数据库实例间的执行时间倾斜率。
min_cpu_time bigint 语句在数据库实例上的最小CPU时间，单位ms。
max_cpu_time bigint 语句在数据库实例上的最大CPU时间，单位ms。
total_cpu_time bigint 语句在数据库实例上的CPU总时间，单位ms。
cpu_skew_percent integer 语句在数据库实例间的CPU时间倾斜率。
min_peak_iops integer 语句在数据库实例上的每秒最小IO峰值（列存单位是次/s，行存单位是万次/s）。
max_peak_iops integer 语句在数据库实例上的每秒最大IO峰值（列存单位是次/s，行存单位是万次/s）。
average_peak_iops integer 语句在数据库实例上的每秒平均IO峰值（列存单位是次/s，行存单位是万次/s）。
iops_skew_percent integer 语句在数据库实例间的IO倾斜率。
warning text queryid bigint 语句执行使用的内部query id。
query text 执行的语句。
query_plan text 语句的执行计划。
node_group text 语句所属用户对应的逻辑数据库实例。
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
n_returned_rows bigint Select返回的结果集行数。
n_tuples_fetched bigint 随机扫描行数。
n_tuples_returned bigint 顺序扫描行数。
n_tuples_inserted bigint 插入行数。
n_tuples_updated bigint 更新行数。
n_tuples_deleted bigint 删除行数。
n_blocks_fetched bigint Cache加载次数。
n_blocks_hit bigint Cache命中数。
db_time bigint 有效的DB时间花费，多线程将累加（单位：微秒）。
cpu_time bigint CPU时间（单位：微秒）。
execution_time bigint 执行器内执行时间（单位：微秒）。
parse_time bigint SQL解析时间（单位：微秒）。
plan_time bigint SQL生成计划时间（单位：微秒）。
rewrite_time bigint SQL重写时间（单位：微秒）。
pl_execution_time bigint plpgsql上的执行时间（单位：微秒）。
pl_compilation_time bigint plpgsql上的编译时间（单位：微秒）。
net_send_time bigint 网络上的时间花费（单位：微秒）。
data_io_time bigint IO上的时间花费（单位：微秒）。
is_slow_query bigint 标记是否为慢查询。
取值为1时表示其为慢查询。
srt1_q bigint Q报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt2_simple_query bigint exec_simple_query执行耗时（单位：微秒) 取值为1时表示其为慢查询。
srt3_analyze_rewrite bigint pg_analyze_and_rewrite执行耗时（单位：微秒) 取值为1时表示其为慢查询。
srt4_plan_query bigint pg_plan_queries执行耗时（单位：微秒) 取值为1时表示其为慢查询。
srt5_light_query bigint exec_query_through_light_proxy执行耗时（单位：微秒) 取值为1时表示其为慢查询。
srt6_p bigint P报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt7_b bigint B报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt8_e bigint E报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt9_d bigint D报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt10_s bigint S报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt11_c bigint C报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt12_u bigint U报文执行的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt13_before_query bigint 进入下一次报文处理前的耗时（单位：微秒) 取值为1时表示其为慢查询。
srt14_after_query bigint 完成报文处理后的耗时（单位：微秒) 取值为1时表示其为慢查询。
rtt_unknown bigint 未知时间消耗，可能是session切换耗时（单位：微秒) 取值为1时表示其为慢查询。
