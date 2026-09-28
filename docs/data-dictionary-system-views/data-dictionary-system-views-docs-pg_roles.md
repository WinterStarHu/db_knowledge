# PG\_ROLES

PG\_ROLES视图提供访问数据库角色的相关信息，初始化用户和具有sysadmin属性或createrole属性的用户可以查看全部角色的信息，其他用户只能查看自己的信息。

**表 1**  PG\_ROLES字段

rolname name 角色名称。
rolsuper boolean 该角色是否是拥有最高权限的初始系统管理员。
rolinherit boolean 该角色是否继承角色的权限。
rolcreaterole boolean 该角色是否可以创建其他的角色。
rolcreatedb boolean 该角色是否可以创建数据库。
rolcatupdate boolean 该角色是否可以直接更新系统表。只有usesysid=10的初始系统管理员拥有此权限。其他用户无法获得此权限。
rolcanlogin boolean 该角色是否可以登录数据库。
rolreplication boolean 该角色是否可以复制。
rolauditadmin boolean 该角色是否为审计管理员。
rolsystemadmin boolean 该角色是否为系统管理员。
rolconnlimit integer 对于可以登录的角色，这里限制了该角色允许发起的最大并发连接数。-1表示无限制。
rolpassword text 不是口令，总是********。
rolvalidbegin timestamp with time zone 帐户的有效开始时间；如果没有设置有效开始时间，则为NULL。
rolvaliduntil timestamp with time zone 帐户的有效结束时间；如果没有设置有效结束时间，则为NULL。
rolrespool name 用户所能够使用的resource pool。
rolparentid oid PG_AUTHID.rolparentid 用户所在组用户的OID。
roltabspace text 用户永久表存储空间限额。
roltempspace text 用户临时表存储空间限额，单位为KB。
rolspillspace text 用户算子落盘空间限额，单位为KB。
rolconfig text[] 运行时配置变量的会话缺省。
oid oid PG_AUTHID.oid 角色的ID。
roluseft boolean PG_AUTHID.roluseft 角色是否可以操作外表。
rolkind "char" 角色类型。
nodegroup name 该字段不支持。
rolmonitoradmin boolean 该角色是否为监控管理员。
roloperatoradmin Boolean 该角色是否为运维管理员。
rolpolicyadmin boolean 该角色是否为安全策略管理员。
