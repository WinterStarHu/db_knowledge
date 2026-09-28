# SUMMARY\_STAT\_USER\_FUNCTIONS

SUMMARY\_STAT\_USER\_FUNCTIONS用来统计所数据库节点用户自定义函数的相关统计信息。

**表 1**  SUMMARY\_STAT\_USER\_FUNCTIONS字段

schemaname name schema的名称。
funcname name 用户function的名称。
calls numeric 总调用次数。
total_time double precision 调用此function的总时间花费，包含调用其它function的时间（单位：毫秒）。
self_time double precision 调用此function自己时间的花费，不包含调用其它function的时间（单位：毫秒）。
