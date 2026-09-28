# PG\_LARGEOBJECT\_METADATA

PG\_LARGEOBJECT\_METADATA系统表存储与大数据相关的元数据。实际的大对象数据存储在PG\_LARGEOBJECT里。

**表 1**  PG\_LARGEOBJECT\_METADATA字段

oid oid 行标识符（隐含属性，必须明确选择）。
lomowner oid PG_AUTHID.oid 大对象的所有者。
lomacl aclitem[] 访问权限。
