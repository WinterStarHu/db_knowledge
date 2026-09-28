# PGXC\_GROUP

PGXC\_GROUP系统表存储节点组信息。PGXC\_GROUP系统表仅在分布式场景下有具体含义，openGauss只能查询表定义。

**表 1**  PGXC\_GROUP字段

oid oid 行标识符（隐含字段，必须明确选择）。
group_name name 节点组名称。
in_redistribution "char" group_members oidvector_extend 节点组的节点OID列表。
group_buckets text 分布数据桶的集合。
is_InstallationGuide Boolean 是否安装子集群。
t（true）：表示安装。f（false）：表示不安装。
group_acl aclitem[] 访问权限。
group_kind "char" group_parent oid 如果是子node group，该字段表示父node group的OID，如果是父node group，该字段值为空。
