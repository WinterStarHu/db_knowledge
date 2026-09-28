# \_PG\_USER\_MAPPINGS

存储从本地用户到远程的映射。该视图只有sysadmin权限可以查看。

**表 1**  \_PG\_USER\_MAPPINGS字段

oid oid 从本地用户到远程的映射的oid。
umoptions text[] 用户映射指定选项，使用“keyword=value”格式的字符串。
umuser oid 被映射的本地用户的OID，如果用户映射是公共的则为0。
authorization_identifier information_schema.sql_identifier 本地用户角色名称。
foreign_server_catalog information_schema.sql_identifier 外部服务器定义所在的database名称。
foreign_server_name information_schema.sql_identifier 外部服务器名称。
srvowner information_schema.sql_identifier 外部服务器所有者。
