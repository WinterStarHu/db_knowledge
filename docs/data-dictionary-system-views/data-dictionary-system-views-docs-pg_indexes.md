# PG\_INDEXES

PG\_INDEXES视图提供对数据库中每个索引的有用信息的访问。

**表 1**  PG\_INDEXES字段

schemaname name PG_NAMESPACE.nspname 包含表和索引的模式名称。
tablename name PG_CLASS.relname 此索引所服务的表的名称。
indexname name PG_CLASS.relname 索引的名称。
tablespace name PG_TABLESPACE.spcname 包含索引的表空间名称。
indexdef text 索引定义（一个重建的CREATE INDEX命令）。
