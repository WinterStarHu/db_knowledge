# PG\_USER\_STATUS

PG\_USER\_STATUS系统表提供了访问数据库用户的状态。需要有系统管理员权限才可以访问此系统表

**表 1**  PG\_USER\_STATUS字段

oid oid 行标识符（隐含字段，必须明确选择）。
roloid oid 角色的标识。
failcount integer 尝试失败次数。
locktime timestamp with time zone 角色被锁定的时间点。
rolstatus smallint permspace bigint 角色已经使用的永久表存储空间大小。
tempspace bigint 角色已经使用的临时表存储空间大小。
passwordexpired smallint 密码是否失效。
0：密码有效。1：密码失效。
