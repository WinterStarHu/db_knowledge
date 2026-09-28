# STAT\_XACT\_USER\_FUNCTIONS

视图包含当前节点本事务内函数执行的统计信息。

**表 1**  STAT\_XACT\_USER\_FUNCTIONS字段

funcid oid 函数标识。
schemaname name 模式的名称。
funcname name 函数名称。
calls bigint 函数被调用的次数。
total_time double precision 函数的总执行时长。
self_time double precision 当前线程调用函数的总的时长。
