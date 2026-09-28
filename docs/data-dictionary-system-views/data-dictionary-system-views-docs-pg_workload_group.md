# PG\_WORKLOAD\_GROUP

PG\_WORKLOAD\_GROUP系统表提供了数据库负载组的信息。

**表 1**  PG\_WORKLOAD\_GROUP字段

oid oid 行标识符（隐含属性，必须明确选择）。
workload_gpname name 负载组名称。
respool_oid oid 绑定到的资源池的id。
act_statements integer 负载组内最大的活跃语句数。
