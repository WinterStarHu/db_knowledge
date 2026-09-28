# PG\_USER

PG\_USER视图提供了访问数据库用户的信息，默认只有初始化用户和具有sysadmin属性的用户可以查看，其余用户需要赋权后才可以查看。

**表 1**  PG\_USER字段

usename name 用户名。
usesysid oid 此用户的ID。
usecreatedb boolean 用户是否可以创建数据库。
usesuper boolean 用户是否是拥有最高权限的初始系统管理员。
usecatupd boolean 用户是否可以直接更新系统表。只有usesysid=10的初始系统管理员拥有此权限。其他用户无法获得此权限。
userepl boolean 用户是否可以复制数据流。
passwd text 密文存储后的用户口令，始终为********。
valbegin timestamp with time zone 帐户的有效开始时间；如果没有设置有效开始时间，则为NULL。
valuntil timestamp with time zone 帐户的有效结束时间；如果没有设置有效结束时间，则为NULL。
respool name 用户所在的资源池。
parent oid 父用户OID。
spacelimit text 永久表存储空间限额。
tempspacelimit text 临时表存储空间限额。
spillspacelimit text 算子落盘空间限额。
useconfig text[] 运行时配置参数的会话缺省。
nodegroup name 用户关联的逻辑openGauss名称，如果该用户没有管理逻辑openGauss，则该字段为空。
usemonitoradmin boolean 用户是否是监控管理员。
t（true）：表示是。f（false）：表示否。
useoperatoradmin boolean 用户是否是运维管理员。
t（true）：表示是。f（false）：表示否。
usepolicyadmin boolean 用户是否是安全策略管理员。
t（true）：表示是。f（false）：表示否。
