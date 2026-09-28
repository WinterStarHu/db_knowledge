# PG\_SHSECLABEL

PG\_SHSECLABEL系统表存储在共享数据库对象上的安全标签。安全标签可以用SECURITY LABEL命令操作。

查看安全标签的简单点的方法，请参阅[PG\_SECLABELS](pg_seclabels.md)。

[PG\_SECLABEL](pg_seclabel.md)的作用类似，只是它是用于在单个数据库内部的对象的安全标签的。

不同于大多数的系统表，PG\_SHSECLABEL在openGauss中的所有数据库中共享：每个openGauss只有一个PG\_SHSECLABEL，而不是每个数据库一个。

**表 1**  PG\_SHSECLABEL字段

objoid oid 任意OID属性 这个安全标签所属的对象的OID。
classoid oid PG_CLASS.oid 出现这个对象的系统目录的OID。
provider text 与这个标签相关的标签提供程序。
label text 应用于这个对象的安全标签。
