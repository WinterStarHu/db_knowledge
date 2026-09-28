# PG\_SHDescription

PG\_SHDescription系统表为共享数据库对象存储可选的注释。可以使用COMMENT命令操作注释的内容，使用gsql的\\d命令查看注释内容。

PG\_Description提供了类似的功能，它记录了单个数据库中对象的注释。

不同于大多数系统表，PG\_SHDescription是在openGauss里面所有的数据库之间共享的：每个openGauss只有一个PG\_SHDescription，而不是每个数据库一个。

**表 1**  PG\_SHDescription字段

objoid oid 任意OID属性 这条描述所描述的对象的OID。
classoid oid PG_CLASS.oid 这个对象出现的系统表的OID。
Description text 作为对该对象的描述的任意文本。
