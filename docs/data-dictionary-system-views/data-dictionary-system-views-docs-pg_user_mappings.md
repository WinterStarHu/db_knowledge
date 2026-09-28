# PG\_USER\_MAPPINGS

PG\_USER\_MAPPINGS视图提供访问关于用户映射的信息的接口。

这个视图只是一个[PG\_USER\_MAPPING](pg_user_mapping.md)的可读部分的视图化表现，如果用户无权使用它则查询该表时，有些选项字段会显示为空。普通用户需要授权才可以访问。

**表 1**  PG\_USER\_MAPPINGS字段

umid oid PG_USER_MAPPING.oid 用户映射的OID。
srvid oid PG_FOREIGN_SERVER.oid 包含这个映射的外部服务器的OID。
srvname name PG_FOREIGN_SERVER.srvname 外部服务器的名称。
umuser oid PG_AUTHID.oid 被映射的本地角色的OID，如果用户映射是公共的则为0。
usename name 被映射的本地用户的名称。
umoptions text[ ] 如果当前用户是外部服务器的所有者，则为用户映射指定选项，使用“keyword=value”字符串，否则为null。
