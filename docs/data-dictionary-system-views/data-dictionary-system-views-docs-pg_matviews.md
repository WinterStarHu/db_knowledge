# PG\_MATVIEWS

PG\_MATVIEWS视图提供访问数据库中当前用户有权限查看的物化视图的信息。

**表 1**  PG\_MATVIEWS字段

schemaname name PG_NAMESPACE.nspname 包含物化视图的模式名。
matviewname name PG_CLASS.relname 物化视图的名称。
matviewowner name PG_AUTHID.rolname 物化视图的所有者。
tablespace name PG_TABLESPACE.spcname 物化视图的表空间名称，默认命名空间为NULL。
hasindexes boolean 如果物化视图包含索引则为T。
isincremental boolean GS_MATVIEW.ivm 如果物化视图是增量物化视图则为T。
ispopulated boolean 如果物化视图已填充有效数据则为T。
definition text 物化视图的定义。
