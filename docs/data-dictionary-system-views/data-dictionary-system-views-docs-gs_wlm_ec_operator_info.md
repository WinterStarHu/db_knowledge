# GS\_WLM\_EC\_OPERATOR\_INFO

GS\_WLM\_EC\_OPERATOR\_INFO系统表存储执行EC（Extension Connector）作业结束后的算子相关的记录。当设置GUC参数[enable\_resource\_record](workload_management.md#zh-cn_topic_0283137479_zh-cn_topic_0237124729_zh-cn_topic_0059777791_s77bd1023b63c4cd489760aa33f08d1ea)为on时，系统会每3分钟将GS\_WLM\_EC\_OPERATOR\_HISTORY中的记录导入此系统表，开启此功能会占用系统存储空间并对性能有一定影响。查询该系统表需要sysadmin权限。

**表 1**  GS\_WLM\_EC\_OPERATOR\_INFO的字段

queryid bigint EC语句执行使用的内部query_id。
plan_node_id integer EC算子对应的执行计划的plan node id。
start_time timestamp with time zone EC算子处理第一条数据的开始时间。
duration bigint EC算子到结束时候总的执行时间（ms）。
tuple_processed bigint EC算子返回的元素个数。
min_peak_memory integer EC算子在所有DN上的最小内存峰值（MB）。
max_peak_memory integer EC算子在所有DN上的最大内存峰值（MB）。
average_peak_memory integer EC算子在所有DN上的平均内存峰值（MB）。
ec_status text EC作业的执行状态。
ec_execute_datanode text 执行EC作业的DN名称。
ec_dsn text EC作业所使用的DSN。
ec_username text EC作业访问远端数据库实例的USERNAME（远端数据库实例为SPARK类型时该值为空）。
ec_query text EC作业发送给远端数据库实例执行的语句。
ec_libodbc_type text EC作业使用的unixODBC驱动类型。
