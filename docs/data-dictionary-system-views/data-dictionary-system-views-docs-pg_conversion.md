# PG\_CONVERSION

PG\_CONVERSION系统表描述编码转换信息。

**表 1**  PG\_CONVERSION字段

oid oid 行标识符（隐藏属性，必须明确选择）。
conname name 转换名称（在一个名称空间里是唯一的）。
connamespace oid PG_NAMESPACE.oid 包含这个转换的名称空间的OID。
conowner oid PG_AUTHID.oid 编码转换的属主。
conforencoding integer 源编码ID。
contoencoding integer 目的编码ID。
conproc regproc PG_PROC.proname 转换过程。
condefault boolean 如果这是缺省转换则为真。
