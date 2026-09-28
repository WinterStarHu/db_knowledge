# GLOBAL_PLANCACHE_STATUS

GPC相关视图在enable\_global\_plancache打开且线程池打开的状态下才有效。

GLOBAL_PLANCACHE_STATUS视图显示GPC全局计划缓存状态信息。

**表 1**  GLOBAL_PLANCACHE_STATUS字段

nodename text 所属节点名称。
query text 查询语句text。
refcount integer 被引用次数。
valid bool 是否合法。
databaseid oid 所属数据库id。
schema_name text 所属schema。
params_num integer 参数数量。
func_id oid 该plancache所在存储过程oid，如果不属于存储过程则为0。
