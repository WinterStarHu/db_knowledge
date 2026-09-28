# WLM\_USER\_RESOURCE\_CONFIG

WLM\_USER\_RESOURCE\_CONFIG视图显示用户的资源配置信息。

**表 1**  WLM\_USER\_RESOURCE\_CONFIG字段

userid oid 用户oid。
username name 用户名称。
sysadmin boolean 是否是sysadmin。
rpoid oid 资源池的oid。
respool name 资源池的名称。
parentid oid 父用户的oid。
totalspace bigint 占用总空间大小。
spacelimit bigint 空间大上限。
childcount integer 子用户数量。
childlist text 子用户的列表。
