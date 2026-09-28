# PG\_WLM\_STATISTICS

PG\_WLM\_STATISTICS视图显示作业结束后或已被处理异常后的负载管理相关信息。查询该视图需要sysadmin权限。

**表 1**  PG\_WLM\_STATISTICS字段

statement text 执行了异常处理的语句。
block_time bigint 语句执行前的阻塞时间。
elapsed_time bigint 语句的实际执行时间。
total_cpu_time bigint 语句执行异常处理时数据库实例上CPU使用的总时间。
qualification_time bigint 语句检查倾斜率的时间周期。
cpu_skew_percent integer 语句在执行异常处理时数据库实例上CPU使用的倾斜率。
control_group text 语句执行异常处理时所使用的Cgroups。
status text action text
