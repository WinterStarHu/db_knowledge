# PG\_SESSION\_IOSTAT

PG\_SESSION\_IOSTAT视图显示当前用户执行作业正在运行时的IO负载管理相关信息。查询该视图需要sysadmin权限或者monitor admin权限。

以下涉及到iops，对于行存，均以万次/s为单位，对于列存，均以次/s为单位。

**表 1**  PG\_SESSION\_IOSTAT字段

query_id bigint 作业id。
mincurriops integer 该作业当前io在数据库实例中的最小值。
maxcurriops integer 该作业当前io在数据库实例中的最大值。
minpeakiops integer 在作业运行时，作业io峰值中，数据库实例的最小值。
maxpeakiops integer 在作业运行时，作业io峰值中，数据库实例的最大值。
io_limits integer 该作业所设GUC参数io_limits。
io_priority text 该作业所设GUC参数io_priority。
query text 作业。
node_group text 该字段不支持。
curr_io_limits integer 使用io_priority管控io时的实时io_limits值。
