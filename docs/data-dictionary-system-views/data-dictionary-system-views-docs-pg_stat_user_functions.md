# PG\_STAT\_USER\_FUNCTIONS

PG\_STAT\_USER\_FUNCTIONS视图显示命名空间中用户自定义函数（函数语言为非内部语言）的状态信息。

**表 1**  PG\_STAT\_USER\_FUNCTIONS字段

funcid oid 函数标识。
schemaname name 模式的名称。
funcname name 函数名称。
calls bigint 函数被调用的次数。
total_time double precision 函数的总执行时长。
self_time double precision 当前线程调用函数的总的时长。
