# PG\_SYNONYM

PG\_SYNONYM系统表存储同义词对象名与其他数据库对象名间的映射信息。

**表 1**  PG\_SYNONYM字段

oid oid 数据库对象id。
synname name 同义词名称。
synnamespace oid 包含该同义词的名字空间的OID。
synowner oid 同义词的所有者，通常是创建它的用户OID。
synobjschema name 关联对象指定的模式名。
synobjname name 关联对象名。
