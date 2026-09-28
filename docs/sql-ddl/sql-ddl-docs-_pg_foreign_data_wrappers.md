# \_PG\_FOREIGN\_DATA\_WRAPPERS

显示外部数据封装器的信息。该视图只有sysadmin权限可以查看。

**表 1**  \_PG\_FOREIGN\_DATA\_WRAPPERS字段

oid oid 外部数据封装器的oid。
fdwowner oid 外部数据封装器的所有者的oid。
fdwoptions text[] 外部数据封装器指定选项，使用“keyword=value”格式的字符串。
foreign_data_wrapper_catalog information_schema.sql_identifier 外部封装器所在的数据库名称（永远为当前数据库）。
foreign_data_wrapper_name information_schema.sql_identifier 外部数据封装器名称。
authorization_identifier information_schema.sql_identifier 外部数据封装器所有者的角色名称。
foreign_data_wrapper_language information_schema.character_data 外部数据封装器的实现语言。
