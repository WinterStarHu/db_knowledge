# PG\_OPFAMILY

PG\_OPFAMILY系统表定义操作符族。

每个操作符族是一个操作符和相关支持例程的集合，其中的例程实现为一个特定的索引访问方式指定的语义。另外，族中的操作符都是“兼容的”，通过由访问方式指定的方法。操作符族的概念允许交叉数据类型操作符和索引一起使用，并且合理的使用访问方式的语义的知识。

**表 1**  PG\_OPFAMILY字段

oid oid 行标识符（隐含属性，必须明确选择）。
opfmethod oid PG_AM.oid 操作符族使用的索引方法。
opfname name 这个操作符族的名称。
opfnamespace oid PG_NAMESPACE.oid 这个操作符的名称空间。
opfowner oid PG_AUTHID.oid 操作符族的所有者。

定义一个操作符族的大多数信息不在它的PG\_OPFAMILY行里面，而是在相关的行[PG\_AMOP](pg_amop.md)，[PG\_AMPROC](pg_amproc.md)和[PG\_OPCLASS](pg_opclass.md)里。
