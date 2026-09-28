# SESSION\_MEMORY\_RUNTIME

SESSION\_MEMORY\_RUNTIME视图显示和当前用户执行复杂作业正在运行时的负载管理内存使用的信息。

**表 1**  SESSION\_MEMORY\_RUNTIME字段

datid oid 连接后端的数据库OID。
usename name 登录到该后端的用户名。
pid bigint 后端线程ID。
start_time timestamp with time zone 语句执行的开始时间。
min_peak_memory integer 语句在数据库节点上的最小内存峰值大小，单位MB。
max_peak_memory integer 语句在数据库节点上的最大内存峰值大小，单位MB。
spill_info text query text 正在执行的语句。
node_group text 语句所属用户对应的逻辑openGauss。
top_mem_dn text mem使用量topN信息。
