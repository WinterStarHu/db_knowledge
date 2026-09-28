# PG\_FOREIGN\_SERVER

PG\_FOREIGN\_SERVER系统表存储外部服务器定义。一个外部服务器描述了一个外部数据源，例如一个远程服务器。外部服务器通过外部数据封装器访问。

**表 1**  PG\_FOREIGN\_SERVER字段

oid oid 行标识符（隐含属性，必须明确选择）。
srvname name 外部服务器名。
srvowner oid PG_AUTHID.oid 外部服务器的所有者。
srvfdw oid PG_FOREIGN_DATA_WRAPPER.oid 这个外部服务器的外部数据封装器的OID。
srvtype text 服务器的类型（可选）。
srvversion text 服务器的版本（可选）。
srvacl aclitem[] 访问权限。
srvoptions text[] 外部服务器指定选项，使用“keyword=value”格式的字符串。
