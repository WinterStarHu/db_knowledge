# GS\_WLM\_USER\_INFO

用户统计信息视图。

**表 1**  GS\_WLM\_USER\_INFO字段

userid oid 用户OID。
username name 用户名。
sysadmin boolean 是否是管理员用户。
rpoid oid 关联的资源池的OID。
respool name 关联的资源池的名称。
parentid oid 用户组的OID。
totalspace bigint 用户的可用空间上限。
spacelimit bigint 用户表空间限制。
childcount interger 子用户的个数。
childlist text 子用户列表。
