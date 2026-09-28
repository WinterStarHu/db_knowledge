# PG\_TABLES

PG\_TABLES视图提供了对数据库中每个表访问的有用信息。

**表 1**  PG\_TABLES字段

schemaname name PG_NAMESPACE.nspname 包含表的模式名。
tablename name PG_CLASS.relname 表名。
tableowner name pg_get_userbyid(PG_CLASS.relowner) 表的所有者。
tablespace name PG_TABLESPACE.spcname 包含表的表空间，默认为NULL。
hasindexes boolean PG_CLASS.relhasindex 如果表上有索引（或者最近拥有）则为TRUE，否则为FALSE。
hasrules boolean PG_CLASS.relhasruls 如果表上有规则，则为TRUE，否则为FALSE。
hastriggers boolean PG_CLASS.RELHASTRIGGERS 如果表上有触发器，则为TRUE，否则为FALSE。
tablecreator name pg_get_userbyid(po.creator) 创建表的名称。
created timestamp with time zone pg_object.ctime 对象的创建时间。
last_ddl_time timestamp with time zone pg_object.mtime 对象的最后修改时间。
