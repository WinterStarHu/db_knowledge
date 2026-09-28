# GS\_SESSION\_CPU\_STATISTICS

GS\_SESSION\_CPU\_STATISTICS视图显示当前用户执行的正在运行的复杂作业的CPU使用的负载管理信息。

**表 1**  GS\_SESSION\_CPU\_STATISTICS字段

datid oid 连接后端的数据库OID。
usename name 登录到该后端的用户名。
pid bigint 后端线程ID。
start_time timestamp with time zone 语句执行的开始时间。
min_cpu_time bigint 语句在数据库节点上的最小CPU时间，单位为ms。
max_cpu_time bigint 语句在数据库节点上的最大CPU时间，单位为ms。
total_cpu_time bigint 语句在数据库节点上的CPU总时间，单位为ms。
query text 正在执行的语句。
node_group text 该字段不支持。
top_cpu_dn text cpu使用量信息。
