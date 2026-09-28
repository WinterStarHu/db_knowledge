# SUMMARY\_STATEMENT

获得各数据库主节点的执行语句（归一化SQL）的全量信息（包含数据库节点）。

**表 1**  SUMMARY\_STATEMENT字段

node_name name 数据库进程名称。
node_id integer 节点的ID。
user_name name 用户名称。
user_id oid 用户OID。
unique_sql_id bigint 归一化的SQL ID。
query text 归一化的SQL。
备注：长度受track_activity_query_size控制。
n_calls bigint 调用次数。
min_elapse_time bigint SQL在内核内的最小运行时间（单位：微秒）。
max_elapse_time bigint SQL在内核内的最大运行时间（单位：微秒）。
total_elapse_time bigint SQL在内核内的总运行时间（单位：微秒）。
n_returned_rows bigint SELECT返回的结果集行数。
n_tuples_fetched bigint 随机扫描行。
n_tuples_returned bigint 顺序扫描行。
n_tuples_inserted bigint 插入行。
n_tuples_updated bigint 更新行。
n_tuples_deleted bigint 删除行。
n_blocks_fetched bigint buffer的块访问次数。
n_blocks_hit bigint buffer的块命中次数。
n_soft_parse bigint 软解析次数。
n_hard_parse bigint 硬解析次数。
db_time bigint 有效的DB时间花费，多线程将累加（单位：微秒）。
cpu_time bigint CPU时间（单位：微秒）。
execution_time bigint 执行器内执行时间（单位：微秒）。
parse_time bigint SQL解析时间（单位：微秒）。
plan_time bigint SQL生成计划时间（单位：微秒）。
rewrite_time bigint SQL重写时间（单位：微秒）。
pl_execution_time bigint plpgsql上的执行时间（单位：微秒）。
pl_compilation_time bigint plpgsql上的编译时间（单位：微秒）。
data_io_time bigint IO上的时间花费（单位：微秒）。
net_send_info text 通过物理连接发送消息的网络状态，包含时间（微秒）、调用次数、吞吐量（字节）。通过该字段可以分析SQL在分布式系统下的网络开销，单机模式下不支持该字段。例如：{"time":xxx, "n_calls":xxx, "size":xxx}。
net_recv_info text 通过物理连接接收消息的网络状态，包含时间（微秒）、调用次数、吞吐量（字节）。通过该字段可以分析SQL在分布式系统下的网络开销，单机模式下不支持该字段。例如：{"time":xxx, "n_calls":xxx, "size":xxx}。
net_stream_send_info text 通过逻辑连接发送消息的网络状态，包含时间（微秒）、调用次数、吞吐量（字节）。通过该字段可以分析SQL在分布式系统下的网络开销，单机模式下不支持该字段。例如：{"time":xxx, "n_calls":xxx, "size":xxx}。
net_stream_recv_info text 通过逻辑连接接收消息的网络状态，包含时间（微秒）、调用次数、吞吐量（字节）。通过该字段可以分析SQL在分布式系统下的网络开销，单机模式下不支持该字段。例如：{"time":xxx, "n_calls":xxx, "size":xxx}。
last_updated timestamp with time zone 最后一次更新该语句的时间。
sort_count bigint 排序执行的次数。
sort_time bigint 排序执行的时间（单位：微秒）。
sort_mem_used bigint 排序过程中使用的work memory大小（单位：KB）。
sort_spill_count bigint 排序过程中，若发生落盘，写文件的次数。
sort_spill_size bigint 排序过程中，若发生落盘，使用的文件大小（单位：KB）。
hash_count bigint hash执行的次数。
hash_time bigint hash执行的时间（单位：微秒）。
hash_mem_used bigint hash过程中使用的work memory大小（单位：KB）。
hash_spill_count bigint hash过程中，若发生落盘，写文件的次数。
hash_spill_size bigint hash过程中，若发生落盘，使用的文件大小（单位：KB）。
net_send_time bigint 网络上的时间花销。（单位：微秒) srt1_q bigint Q报文执行的耗时（单位：微秒) srt2_simple_query bigint exec_simple_query执行耗时（单位：微秒) srt3_analyze_rewrite bigint pg_analyze_and_rewrite执行耗时（单位：微秒) srt4_plan_query bigint pg_plan_queries执行耗时（单位：微秒) srt5_light_query bigint exec_query_through_light_proxy执行耗时（单位：微秒) srt6_p bigint P报文执行的耗时（单位：微秒) srt7_b bigint B报文执行的耗时（单位：微秒) srt8_e bigint E报文执行的耗时（单位：微秒) srt9_d bigint D报文执行的耗时（单位：微秒) srt10_s bigint S报文执行的耗时（单位：微秒) srt11_c bigint C报文执行的耗时（单位：微秒) srt12_u bigint U报文执行的耗时（单位：微秒) srt13_before_query bigint 进入下一次报文处理前的耗时（单位：微秒) srt14_after_query bigint 完成报文处理后的耗时（单位：微秒) rtt_unknown bigint 未知时间消耗，可能是session切换耗时（单位：微秒) net_trans_time bigint 驱动执行sql的全链路网络耗时，当前仅支持jdbc驱动。（单位：微秒）
