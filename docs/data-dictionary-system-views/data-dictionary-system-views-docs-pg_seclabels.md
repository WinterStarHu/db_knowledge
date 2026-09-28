# PG\_SECLABELS

PG\_SECLABELS视图提供关于安全标签的信息。

**表 1**  PG\_SECLABELS字段

objoid oid 任意OID属性 这个安全标签指向的对象的OID。
classoid oid PG_CLASS.oid 这个对象出现的系统表的OID。
objsubid integer 对于一个在表字段上的安全标签，是字段编号（引用表本身的objoid和classoid）。对于所有其他对象类型，这个字段为0。
objtype text 这个标签出现的对象的类型，文本格式。
objnamespace oid PG_NAMESPACE.oid 这个对象的名称空间的OID，如果适用；否则为NULL。
objname text 这个标签适用的对象的名称，文本格式。
provider text PG_SECLABEL.provider 与这个标签相关的标签提供者。
label text PG_SECLABEL.label 适用于这个对象的安全标签。
