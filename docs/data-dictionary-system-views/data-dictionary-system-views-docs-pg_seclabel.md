# PG\_SECLABEL

PG\_SECLABEL系统表存储数据对象上的安全标签。

[PG\_SHSECLABEL](pg_shseclabel.md)的作用类似，只是它是用于在一个openGauss内共享的数据库对象的安全标签上的。

**表 1**  PG\_SECLABEL字段

objoid oid 任意OID属性 这个安全标签所属的对象的OID。
classoid oid PG_CLASS.oid 出现这个对象的系统目录的OID。
objsubid integer 出现在这个对象中的列的序号。
provider text 与这个标签相关的标签提供程序。
label text 应用于这个对象的安全标签。
