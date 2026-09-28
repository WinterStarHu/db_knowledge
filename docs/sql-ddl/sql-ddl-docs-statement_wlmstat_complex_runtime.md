# STATEMENT\_WLMSTAT\_COMPLEX\_RUNTIME

STATEMENT\_WLMSTAT\_COMPLEX\_RUNTIME视图显示和当前用户执行作业正在运行时的负载管理相关信息。

**表 1**  STATEMENT\_WLMSTAT\_COMPLEX\_RUNTIME字段

datid oid 连接后端的数据库OID。
datname name 连接后端的数据库名称。
threadid bigint 后端线程ID。
processid integer 后端线程的pid。
usesysid oid 登录后端的用户OID。
appname text 连接到后端的应用名。
usename name 登录到该后端的用户名。
priority bigint 语句所在Cgroups的优先级。
attribute text block_time bigint 语句当前为止的pending的时间，单位s。
elapsed_time bigint 语句当前为止的实际执行时间，单位s。
total_cpu_time bigint 语句在上一时间周期内的数据库节点上CPU使用的总时间，单位s。
cpu_skew_percent integer 语句在上一时间周期内的数据库节点上CPU使用的倾斜率。
statement_mem integer 语句执行使用的statement_mem，预留字段。
active_points integer 语句占用的资源池并发点数。
dop_value integer 语句的从资源池中获取的dop值。
control_group text 该字段不支持。
status text 该字段不支持。
enqueue text resource_pool name 语句当前所在的资源池。
query text 该后端的最新查询。如果state状态是active（活的），此字段显示当前正在执行的查询。所有其他情况表示上一个查询。
is_plana boolean 逻辑openGauss模式下，语句当前是否占用其他逻辑openGauss的资源执行。该值默认为f（否）。
node_group text 语句所属用户对应的逻辑openGauss。
