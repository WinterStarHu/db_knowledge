# PG\_LARGEOBJECT

PG\_LARGEOBJECT系统表保存那些标记着“大对象”的数据。一个大对象是使用其创建时分配的OID标识的。每个大对象都分解成足够小的小段或者“页面”以便以行的形式存储在PG\_LARGEOBJECT里。每页的数据定义为LOBLKSIZE。

需要有系统管理员权限才可以访问此系统表。

**表 1**  PG\_LARGEOBJECT字段

loid oid PG_LARGEOBJECT_METADATA.oid 包含本页的大对象的标识符。
pageno integer 本页在其大对象数据中的页码从零开始计算。
data bytea 存储在大对象中的实际数据。这些数据绝不会超过LOBLKSIZE字节，而且可能更少。

PG\_LARGEOBJECT的每一行保存一个大对象的一个页面，从该对象内部的字节偏移（pageno \* LOBLKSIZE）开始。这种实现允许松散的存储：页面可以丢失，而且可以比LOBLKSIZE字节少（即使它们不是对象的最后一页）。大对象内丢失的部分读做零。
