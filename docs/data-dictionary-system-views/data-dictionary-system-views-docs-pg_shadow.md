# PG\_SHADOW

PG\_SHADOW视图显示了所有在PG\_AUTHID中标记了rolcanlogin的角色的属性。

这个视图的名称来自于该视图是不可读的，因为它包含口令。[PG\_USER](pg_user.md)是一个在PG\_SHADOW上公开可读的视图，只是把口令域填成了空白。

**表 1**  PG\_SHADOW字段

usename name PG_AUTHID.rolname 用户名。
usesysid oid PG_AUTHID.oid 用户的ID。
usecreatedb boolean 用户可以创建数据库。
usesuper boolean 用户是系统管理员。
usecatupd boolean 用户可以更新视图。即使是系统管理员，如果这个字段不是真，也不能更新视图。
userepl boolean 用户可以初始化流复制和使系统处于或不处于备份模式。
passwd text 口令（可能是加密的）；如果没有则为null。参阅PG_AUTHID获取加密的口令是如何存储的信息。
valbegin timestamp with time zone 帐户的有效开始时间；如果没有设置有效开始时间，则为NULL。
valuntil timestamp with time zone 帐户的有效结束时间；如果没有设置有效结束时间，则为NULL。
respool name 用户使用的资源池。
parent oid 父资源池。
spacelimit text 永久表存储空间限额。
tempspacelimit text 临时表存储空间限额。
spillspacelimit text 算子落盘空间限额。
useconfig text[ ] 运行时配置变量的会话缺省。
usemonitoradmin boolean 用户是否是监控管理员。
t（true）：表示是。f（false）：表示否。
useoperatoradmin boolean 用户是否是运维管理员。
t（true）：表示是。f（false）：表示否。
usepolicyadmin boolean 用户是否是安全策略管理员。
t（true）：表示是。f（false）：表示否。
