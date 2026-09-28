# GS\_MATVIEWS

GS\_MATVIEWS视图提供了关于数据库中每一个物化视图的信息。

**表 1**  GS\_MATVIEWS字段

schemaname name PG_NAMESPACE.nspname 物化视图的模式名。
matviewname name PG_CLASS.relname 物化视图名。
matviewowner name PG_AUTHID.rolname 物化视图的所有者。
tablespace name PG_TABLESPACE.spcname 物化视图的表空间名（如果使用数据库默认表空间则为空）。
hasindexes boolean 如果物化视图有（或者最近有过）任何索引，则此列为真。
definition text 物化视图的定义（一个重构的SELECT查询）。
