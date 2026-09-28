# STATEMENT\_HISTORY

获得当前节点的执行语句的信息。查询系统表必须具有sysadmin权限。只可在系统库中查询到结果，用户库中无法查询。

对于此系统表查询有如下约束：

- 必须在postgres库内查询，其它库中不存数据。
- 此系统表受enable\_stmt\_track控制，默认为"on"。
- 此系统表受track\_stmt\_stat\_level控制，默认为“OFF,L0”，第一部分控制Full SQL，第二部分控制Slow SQL，具体字段记录级别见下表。考虑性能影响，更改该参数的值时建议通过set方式设置，使该参数仅对当前会话生效。
- 对于Slow SQL，当track\_stmt\_stat\_level的值为非OFF时，且SQL执行时间超过log\_min\_duration\_statement，会记录为慢SQL。注：当SQL执行时间和log_min_duration_statement接近时，由于存在执行时间的波动，会有少部分SQL的query_plan记录不到。为了记录这类慢SQL，建议适当缩小log_min_duration_statement的值。
- 对于Slow SQL，当track\_stmt\_stat\_level的值为非OFF时，且SQL执行时间超过log\_min\_duration\_statement，会记录为慢SQL。
对于存储过程内的SQL语句(parent_query_id非0)，当设置instr_unique_sql_track_type为all时才可以记录，其中记录了query、query_plan、unique_query_id、parent_query_id、db_time、cpu_time、start_time、finish_time、is_slow_sql以及一些当前数据库使用信息的基本参数，n_tuples_fetched、n_tuples_returned、n_tuples_inserted、n_tuples_updated、n_tuples_deleted、n_blocks_fetched、n_blocks_hit、execution_time、parse_time、plan_time、rewrite_time、pl_execution_time、pl_compilation_time、data_io_time、net_send_info、net_recv_info、net_stream_send_info、net_stream_recv_info、lock_wait_count、lock_wait_time、lwlock_count、lwlock_wait_count、lwlock_ti、lwlock_wait_time、details、trace_id、advise、net_send_time、 srt1_q、 srt2_simple_query、 srt3_analyze_rewrite、 srt4_plan_query、 srt5_light_query、 srt6_p、 srt7_b、 srt8_e、 srt9_d、 srt10_s、 srt11_c、 srt12_u、 srt13_before_query、 srt14_after_query、rtt_unknown列不支持，记录的值没有实际意义。

**表 1**  STATEMENT\_HISTORY字段

记录级别 db_name name 数据库名称。
schema_name name schema名称。
origin_node integer 节点名称。
user_name name 用户名。
application_name text 用户发起的请求的应用程序名称。
client_addr text 用户发起的请求的客户端地址。
client_port integer 用户发起的请求的客户端端口。
unique_query_id bigint 归一化SQL ID。
debug_query_id bigint 唯一SQL ID。
query text 归一化SQL。
start_time timestamp with time zone 语句启动的时间。
finish_time timestamp with time zone 语句结束的时间。
slow_sql_threshold bigint 语句执行时慢SQL的标准。
transaction_id bigint 事务ID。
thread_id bigint 执行线程ID。
session_id bigint 用户session id。
n_soft_parse bigint 软解析次数，n_soft_parse + n_hard_parse可能大于n_calls，因为子查询未计入n_calls。
n_hard_parse bigint 硬解析次数，n_soft_parse + n_hard_parse可能大于n_calls，因为子查询未计入n_calls。
query_plan text 语句执行计划。
n_returned_rows bigint SELECT返回的结果集行数。
n_tuples_fetched bigint 随机扫描行。
n_tuples_returned bigint 顺序扫描行。
n_tuples_inserted bigint 插入行。
n_tuples_updated bigint 更新行。
n_tuples_deleted bigint 删除行。
n_blocks_fetched bigint buffer的块访问次数。
n_blocks_hit bigint buffer的块命中次数。
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
lock_count bigint 加锁次数。
lock_time bigint 加锁耗时。
lock_wait_count bigint 加锁等待次数。
lock_wait_time bigint 加锁等待耗时。
lock_max_count bigint 最大持锁数量。
lwlock_count bigint 轻量级加锁次数（预留）。
lwlock_wait_count bigint 轻量级等锁次数。
lwlock_time bigint 轻量级加锁时间（预留）。
lwlock_wait_time bigint 轻量级等锁时间。
details bytea 等待事件和语句锁事件的列表。记录级别的值是L0时，开始记录等待事件的列表。显示当前语句event等待相关的统计信息。具体事件信息见等待状态列表、轻量级锁等待事件列表、IO等待事件列表和事务锁等待事件列表。关于每种事务锁对业务的影响程度，请参考LOCK语法小节的详细描述。记录级别的值是L2时，开始记录语句锁事件的列表。该列表按时间顺序记录事件，记录的数量受参数track_stmt_details_size的影响。该字段为二进制，需要借助解析函数pg_catalog.statement_detail_decode读取，见（表6）。
事件包括： 加锁开始加锁结束等锁开始等锁结束放锁开始放锁结束轻量级等锁开始轻量级等锁结束 is_slow_sql boolean 该SQL是否为slow SQL。
t（true）：表示是。f（false）：表示不是。
trace_id text 驱动传入的trace id，与应用的一次请求相关联。
advise text 可能导致该SQL为slow SQL的风险信息。
parent_query_id bigint 存储过程中plsql父语句的信息。
net_send_time bigint 网络上的时间花销。
srt1_q bigint Q报文执行的耗时 srt2_simple_query bigint exec_simple_query执行耗时 srt3_analyze_rewrite bigint pg_analyze_and_rewrite执行耗时 srt4_plan_query bigint pg_plan_queries执行耗时 srt5_light_query bigint exec_query_through_light_proxy执行耗时 srt6_p bigint P报文执行的耗时 srt7_b bigint B报文执行的耗时 srt8_e bigint E报文执行的耗时 srt9_d bigint D报文执行的耗时 srt10_s bigint S报文执行的耗时 srt11_c bigint C报文执行的耗时 srt12_u bigint U报文执行的耗时 srt13_before_query bigint 进入下一次报文处理前的耗时 srt14_after_query bigint 完成报文处理后的耗时 rtt_unknown bigint 未知时间消耗，可能是session切换耗时 net_trans_time bigint 驱动执行sql的全链路网络耗时，当前仅支持jdbc驱动。（单位：微秒） trace bytea 记录SQL语句执行各算子耗时。trace记录字段容量大小受track_stmt_trace_size控制，范围见track_stmt_trace_size参数说明。trace记录级别受track_stmt_stat_level控制，默认为'OFF,L0'，参数第一部分代表Full SQL，第二部分是慢SQL；对于全链路信息，只有Full SQL大于等于L1级别或慢SQL大于等于L1级别才会被记录。
