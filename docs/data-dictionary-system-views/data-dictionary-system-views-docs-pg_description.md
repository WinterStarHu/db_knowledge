# PG\_DESCRIPTION

PG\_DESCRIPTION系统表可以给每个数据库对象存储一个可选的描述（注释）。许多内置的系统对象的描述提供了PG\_DESCRIPTION的初始内容。

这个表的功能类似[PG_SHDESCRIPTION](pg_shdescription.md)，用于记录openGauss范围内共享对象的注释。

**表 1**  PG_SHDESCRIPTION字段

objoid oid 任意OID属性 这条描述所描述的对象的OID。
classoid oid PG_CLASS.oid 这个对象出现的系统表的OID。
objsubid integer 对于一个表字段的注释，它是字段号（objoid和classoid指向表自身）。对于其它对象类型，它是零。
Description text 对该对象描述的任意文本。
