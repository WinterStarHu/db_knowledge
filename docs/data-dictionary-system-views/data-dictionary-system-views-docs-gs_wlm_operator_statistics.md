# GS\_WLM\_OPERATOR\_STATISTICS

GS\_WLM\_OPERATOR\_STATISTICS视图显示当前用户正在执行的作业的算子相关信息。查询该视图需要sysadmin权限。

**表 1**  GS\_WLM\_OPERATOR\_STATISTICS的字段

queryid bigint 语句执行使用的内部query_id。
pid bigint 后端线程id。
plan_node_id integer 查询对应的执行计划的plan node id。
plan_node_name text 对应于plan_node_id的算子的名称。
start_time timestamp with time zone 该算子处理第一条数据的开始时间。
duration bigint 该算子到结束时候总的执行时间（ms）。
status text 当前算子的执行状态，包括finished和running。
query_dop integer 当前算子执行时的并行度。
estimated_rows bigint 优化器估算的行数信息。
tuple_processed bigint 当前算子返回的元素个数。
min_peak_memory integer 当前算子在数据库实例上的最小内存峰值（MB）。
max_peak_memory integer 当前算子在数据库实例上的最大内存峰值（MB）。
average_peak_memory integer 当前算子在数据库实例上的平均内存峰值（MB）。
memory_skew_percent integer 当前算子在数据库实例间的内存使用倾斜率。
min_spill_size integer 若发生下盘，数据库实例上下盘的最小数据量（MB)，默认为0。
max_spill_size integer 若发生下盘，数据库实例上下盘的最大数据量（MB），默认为0。
average_spill_size integer 若发生下盘，数据库实例上下盘的平均数据量（MB），默认为0。
spill_skew_percent integer 若发生下盘，数据库实例间下盘倾斜率。
min_cpu_time bigint 该算子在数据库实例上的最小执行时间（ms)。
max_cpu_time bigint 该算子在数据库实例上的最大执行时间（ms)。
total_cpu_time bigint 该算子在数据库实例上的总执行时间（ms）。
cpu_skew_percent integer 数据库实例间执行时间的倾斜率。
warning text
