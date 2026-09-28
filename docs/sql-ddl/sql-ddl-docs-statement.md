# STATEMENT

获得当前节点的执行语句（归一化SQL）的信息。查询视图必须具有sysadmin权限或者monitor admin权限。数据库主节点上可以看到此数据库主节点接收到的归一化的SQL的全量统计信息（包含数据库节点）；数据库节点上仅可看到归一化的SQL的此节点执行的统计信息。

**表 1**  STATEMENT字段

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
n_soft_parse bigint 软解析次数，n_soft_parse + n_hard_parse可能大于n_calls，因为子查询未计入n_calls。
n_hard_parse bigint 硬解析次数，n_soft_parse + n_hard_parse可能大于n_calls，因为子查询未计入n_calls。
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
last_updated timestamp with time zone 最后一次更新该语句的时间。
net_send_time bigint 网络上的时间花销。（单位：微秒) srt1_q bigint Q报文执行的耗时（单位：微秒) srt2_simple_query bigint exec_simple_query执行耗时（单位：微秒) srt3_analyze_rewrite bigint pg_analyze_and_rewrite执行耗时（单位：微秒) srt4_plan_query bigint pg_plan_queries执行耗时（单位：微秒) srt5_light_query bigint exec_query_through_light_proxy执行耗时（单位：微秒) srt6_p bigint P报文执行的耗时（单位：微秒) srt7_b bigint B报文执行的耗时（单位：微秒) srt8_e bigint E报文执行的耗时（单位：微秒) srt9_d bigint D报文执行的耗时（单位：微秒) srt10_s bigint S报文执行的耗时（单位：微秒) srt11_c bigint C报文执行的耗时（单位：微秒) srt12_u bigint U报文执行的耗时（单位：微秒) srt13_before_query bigint 进入下一次报文处理前的耗时（单位：微秒) srt14_after_query bigint 完成报文处理后的耗时（单位：微秒) rtt_unknown bigint 未知时间消耗，可能是session切换耗时（单位：微秒) net_trans_time bigint 驱动执行sql的全链路网络耗时，当前仅支持jdbc驱动。（单位：微秒）

## 相关特性

STATEMENT对应系统函数get_instr_unique_sql，主要目的是保留数据库启动后，运行的SQL的状态记录。

一般使用形式：

```
openGauss=# select * from dbe_perf.statement;
```

主要受到以下参数控制：

- enable_resource_track：允许运行时候的资源使用追踪。

- instr_unique_sql_count：允许记录在内存中的SQL总数量。该值由大变小将会重置掉内存中已经存在的所有的归一化SQL；从小变大不受影响。

- instr_unique_sql_track_type：归一化SQL追踪的方式，参数取值为top、all，为top时只支持记录最外层调用的语句，为all时则可记录函数及存储过程内的语句（对存储过程内部的语句，目前只支持记录部分字段）。

- enable_auto_clean_unique_sql：是否打开归一化SQL的自动清理机制，当记录达到上限后，可以自动按照更新时间清理其中10%最近更新的记录。如果不打开，则会记录错误日志，SQL相关内容也不会记录到内存中。

另请参阅：[GUC参数 - Query](../database_reference/query_62.md)
