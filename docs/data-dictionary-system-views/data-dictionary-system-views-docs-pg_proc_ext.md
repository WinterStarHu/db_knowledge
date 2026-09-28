# PG\_PROC\_EXT

PG\_PROC\_EXT系统表是PG\_PROC的扩展，存储函数或过程的额外信息。

**表 1**  PG\_PROC\_EXT字段

proc_oid oid 函数或过程标识符。
parallel_cursor_seq int2 仅函数使用，指定入参中并行游标的序号。
parallel_cursor_strategy int2 仅函数使用，指定并行游标数据分布方式。0：表示ANY。1：表示HASH。
parallel_cursor_partkey text[] 仅函数使用，指定并行游标以HASH分布时的分布键。
result_cache bool 是否支持函数结果缓存。true：表示支持。false：表示不支持。
