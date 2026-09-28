# PG\_AUTH\_HISTORY

PG\_AUTH\_HISTORY系统表记录了角色的认证历史。需要有系统管理员权限才可以访问此系统表。

**表 1**  PG\_AUTH\_HISTORY字段

oid oid 行标识符（隐含属性，必须明确选择）。
roloid oid 角色标识。
passwordtime timestamp with time zone 创建和修改密码的时间。
rolpassword text 角色密码密文，加密方式由GUC参数password_encryption_type确定。
