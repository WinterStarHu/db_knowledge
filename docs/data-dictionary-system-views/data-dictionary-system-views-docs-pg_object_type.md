# PG\_OBJECT\_TYPE

PG\_OBJECT\_TYPE系统表记录所有对象类型。

**表 1**  PG\_OBJECT\_TYPE字段

typoid oid 类型的唯一标识。
supertypeoid oid 父类型的oid isfinal bool 是否允许被继承 isinstantiable bool 是否允许被实例化 ispersistable bool 是否允许被持久化 isbodydefined bool 是否定义了type body mapmethod oid map函数的oid。
ordermethod oid order函数的oid。
objectrelid oid 对象表的oid。
objectoptions int4 预留编码位。
typespecsrc text type specification的内容。
typebodydeclsrc text type body的内容。
objectextensions text[] 预留text数组。
