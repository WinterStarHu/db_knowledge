# STAT\_USER\_FUNCTIONS

STAT\_USER\_FUNCTIONS视图显示命名空间中用户自定义函数（函数语言为非内部语言）的状态信息。

**表 1**  STAT\_USER\_FUNCTIONS字段

funcid oid 函数标识。
schemaname name schema的名称。
funcname name 用户自定义函数的名称。
calls bigint 函数被调用的次数。
total_time double precision 调用此函数花费的总时间，包含调用其它函数的时间（单位：毫秒）。
self_time double precision 调用此函数自己花费的时间，不包含调用其它函数的时间（单位：毫秒）。
