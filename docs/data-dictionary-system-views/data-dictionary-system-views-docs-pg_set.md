# PG\_SET

PG\_SET系统表存储SET数据类型定义的元数据。

**表 1**  PG\_SET字段

settypid oid SET数据类型的OID。
setnum int1 SET数据类型的成员数量，最大64个成员。
setsortorder int1 SET数据类型定义时成员的排序位置，从0开始编号。
setlabel text SET数据类型的成员名称。
