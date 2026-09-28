# SUMMARY\_STAT\_XACT\_USER\_FUNCTIONS

视图包含openGauss内汇聚的本事务内函数执行的统计信息。

**表 1**  SUMMARY\_STAT\_XACT\_USER\_FUNCTIONS字段

schemaname name 模式的名称。
funcname name 函数名称。
calls numeric 函数被调用的次数。
total_time double precision 函数的总执行时长。
self_time double precision 当前线程调用函数的总的时长。
