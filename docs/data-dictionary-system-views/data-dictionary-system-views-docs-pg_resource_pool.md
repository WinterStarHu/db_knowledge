# PG\_RESOURCE\_POOL

PG\_RESOURCE\_POOL系统表提供了数据库资源池的信息。

**表 1**  PG\_RESOURCE\_POOL字段

oid oid 行标识符（隐含属性，必须明确选择）。
respool_name name 资源池名称。
mem_percent integer 内存配置的百分比。
cpu_affinity bigint CPU绑定core的数值。
control_group name 资源池所在的control group名称。
active_statements integer 资源池上最大的并发数。
max_dop integer 最大并发度。用作扩容的接口，表示数据重分布时，扫描并发度。
memory_limit name 资源池最大的内存。
parentid oid 父资源池OID。
io_limits integer 每秒触发IO的次数上限。行存单位是万次/s，列存是次/s。
io_priority name IO利用率高达90%时，重消耗IO作业进行IO资源管控时关联的优先级等级。
nodegroup name 表示资源池所在的逻辑openGauss的名称。
is_foreign boolean 表示资源池是否用于逻辑openGauss之外的用户。如果为true，表示资源池用来控制不属于当前资源池的普通用户的资源。
max_worker integer 只用于扩容的接口，表示扩容数据重分布时，表内并发度。

注：max_dop和max_worker用户扩容，不适用于openGauss。
