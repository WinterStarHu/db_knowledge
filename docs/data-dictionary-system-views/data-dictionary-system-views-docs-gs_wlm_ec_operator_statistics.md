# GS\_WLM\_EC\_OPERATOR\_STATISTICS

GS\_WLM\_EC\_OPERATOR\_STATISTICS视图显示当前用户正在执行的EC（Extension Connector）作业的算子相关信息。查询该视图需要sysadmin权限。

**表 1** GS\_WLM\_EC\_OPERATOR\_STATISTICS的字段

queryid bigint EC语句执行使用的内部query_id。
plan_node_id integer EC算子对应的执行计划的plan node id。
start_time timestamp with time zone EC算子处理第一条数据的开始时间。
ec_status text EC作业的执行状态。
EC_STATUS_INIT：初始化。EC_STATUS_CONNECTED：已连接。EC_STATUS_EXECUTED：已执行。EC_STATUS_FETCHING：获取中。EC_STATUS_END：已结束。
ec_execute_datanode text 执行EC作业的DN名称。
ec_dsn text EC作业所使用的DSN。
ec_username text EC作业访问远端数据库实例的USERNAME（远端集群为SPARK类型时该值为空）。
ec_query text EC作业发送给远端数据库实例执行的语句。
ec_libodbc_type text EC作业使用的unixODBC驱动类型。
类型1：对应 libodbc.so.1。类型2：对应 libodbc.so.2。
ec_fetch_count bigint EC作业当前处理的数据条数。
