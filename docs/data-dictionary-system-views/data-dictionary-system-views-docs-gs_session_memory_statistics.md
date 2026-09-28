# GS\_SESSION\_MEMORY\_STATISTICS

GS\_SESSION\_MEMORY\_STATISTICS视图显示和当前用户执行复杂作业正在运行时的负载管理内存使用的信息。

此视图需要资源管理功能(use_workload_manager)开启才会记录更新数据。

**表 1**  GS\_SESSION\_MEMORY\_STATISTICS字段

datid oid 连接后端的数据库OID。
usename name 登录到该后端的用户名。
pid bigint 后端线程ID。
start_time timestamp with time zone 语句执行的开始时间。
min_peak_memory integer 语句在数据库节点上的最小内存峰值大小，单位MB。
max_peak_memory integer 语句在数据库节点上的最大内存峰值大小，单位MB。
spill_info text 语句在数据库节点上的下盘信息： None：数据库节点均未下盘。
All：数据库节点均下盘。
[a:b]：数量为b个数据库节点中有a个数据库节点下盘。
query text 正在执行的语句。
node_group text 该字段不支持。
top_mem_dn text mem使用量信息。
