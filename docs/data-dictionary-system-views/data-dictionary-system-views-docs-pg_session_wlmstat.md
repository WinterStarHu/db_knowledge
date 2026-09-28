# PG\_SESSION\_WLMSTAT

PG\_SESSION\_WLMSTAT视图显示当前用户执行作业正在运行时的负载管理相关信息。查询该视图需要sysadmin权限。

**表 1**  PG\_SESSION\_WLMSTAT字段

datid oid 连接后端的数据库OID。
datname name 连接后端的数据库名称。
threadid bigint 后端线程ID。
sessionid bigint 会话ID。
processid integer 后端线程的pid。
usesysid oid 登录后端的用户OID。
appname text 连接到后端的应用名。
usename name 登录到该后端的用户名。
priority bigint 语句所在Cgroups的优先级。
attribute text block_time bigint 语句当前为止的pending的时间，单位s。
elapsed_time bigint 语句当前为止的实际执行时间，单位s。
total_cpu_time bigint 语句在上一时间周期内的数据库实例上CPU使用的总时间，单位s。
cpu_skew_percent integer 语句在上一时间周期内的数据库实例上CPU使用的倾斜率。
statement_mem integer 语句执行使用的statement_mem，预留字段。
active_points integer 语句占用的资源池并发点数。
dop_value integer 语句的从资源池中获取的dop值。
control_group text 该字段不支持。
status text enqueue text 该字段不支持。
resource_pool name 语句当前所在的资源池。
query text 该后端的最新查询。如果state状态是active（活的），此字段显示当前正在执行的查询。所有其他情况表示上一个查询。
is_plana boolean 该字段不支持。
node_group text 该字段不支持。
rowdesc_a_store_count bigint A库缓存的累计建槽次数。A库缓存计数同样适用于其他通过PG协议访问的库，包括PG库和D库。
rowdesc_a_hit_count bigint A库缓存的累计命中次数。A库缓存计数同样适用于其他通过PG协议访问的库，包括PG库和D库。
rowdesc_b_store_count bigint B库D报文缓存的累计建槽次数。仅适用于Dolphin/MySQL协议路径，不适用于通过PG协议访问的库。
rowdesc_b_hit_count bigint B库D报文缓存的累计命中次数。仅适用于Dolphin/MySQL协议路径，不适用于通过PG协议访问的库。
