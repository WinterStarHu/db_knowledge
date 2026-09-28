# GS\_WLM\_RESOURCE\_POOL

这是资源池上的一些统计信息。

**表 1**  GS\_WLM\_RESOURCE\_POOL的字段

rpoid oid 资源池的OID。
respool name 资源池的名称。
control_group name 该字段不支持。
parentid oid 父资源池的OID。
ref_count integer 关联到该资源池上的作业数量。
active_points integer 资源池上已经使用的点数。
running_count integer 正在资源池上运行的作业数量。
waiting_count integer 正在资源池上排队的作业数量。
io_limits integer 资源池的iops上限。
io_priority integer 资源池的io优先级。
