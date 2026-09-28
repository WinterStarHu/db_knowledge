# PG\_AUTH\_MEMBERS

PG\_AUTH\_MEMBERS系统表存储显示角色之间的成员关系。

**表 1**  PG\_AUTH\_MEMBERS字段

roleid oid 拥有成员的角色ID。
member oid 属于ROLEID角色的一个成员的角色ID。
grantor oid 赋予此成员关系的角色ID。
admin_option Boolean 如果MEMBER可以把ROLEID角色的成员关系赋予其他角色，则为真。
