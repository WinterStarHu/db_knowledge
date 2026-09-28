# \_PG\_FOREIGN\_SERVERS

显示外部服务器的信息。该视图只有sysadmin权限可以查看。

**表 1**  \_PG\_FOREIGN\_SERVERS字段

oid oid 外部服务器的oid。
srvoptions text[] 外部服务器指定选项，使用“keyword=value”格式的字符串。
foreign_server_catalog information_schema.sql_identifier 外部服务器所在database名称（永远为当前数据库）。
foreign_server_name information_schema.sql_identifier 外部服务器名称。
foreign_data_wrapper_catalog information_schema.sql_identifier 外部数据封装器所在database名称（永远为当前数据库）。
foreign_data_wrapper_name information_schema.sql_identifier 外部数据封装器名称。
foreign_server_type information_schema.character_data 外部服务器的类型。
foreign_server_version information_schema.character_data 外部服务器的版本。
authorization_identifier information_schema.sql_identifier 外部服务器的所有者的角色名称。
