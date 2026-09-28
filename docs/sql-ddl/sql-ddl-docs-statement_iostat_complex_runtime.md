# STATEMENT\_IOSTAT\_COMPLEX\_RUNTIME

STATEMENT\_IOSTAT\_COMPLEX\_RUNTIME视图显示当前用户执行作业正在运行时的IO负载管理相关信息。以下涉及到iops，对于行存，均以万次/s为单位，对于列存，均以次/s为单位。

**表 1**  STATEMENT\_IOSTAT\_COMPLEX\_RUNTIME字段

query_id bigint 作业id。
mincurriops integer 该作业当前io在各数据库节点中的最小值。
maxcurriops integer 该作业当前io在各数据库节点中的最大值。
minpeakiops integer 在作业运行时，作业io峰值中，各数据库节点的最小值。
maxpeakiops integer 在作业运行时，作业io峰值中，各数据库节点的最大值。
io_limits integer 该作业所设GUC参数io_limits。
io_priority text 该作业所设GUC参数io_priority。
query text 作业。
node_group text 作业所属用户对应的逻辑openGauss。
