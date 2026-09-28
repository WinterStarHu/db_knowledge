# PGXC\_CLASS

PGXC\_CLASS系统表存储每张表的复制或分布信息。PGXC\_CLASS系统表仅在分布式场景下有具体含义，openGauss只能查询表定义。

**表 1**  PGXC\_CLASS字段

pcrelid oid 表的OID。
pclocatortype "char" pchashalgorithm smallint 使用哈希算法分布元组。
pchashbuckets smallint 哈希容器的值。
pgroup name 节点群的名称。
redistributed "char" 表已经完成重分布。
redis_order integer 重分布的顺序。该值等于0的表在本轮重分布过程中不进行重分布。
pcattnum int2vector 用作分布键的列标号。
nodeoids oidvector_extend 表分布的节点OID列表。
options text 系统内部保留字段，存储扩展状态信息。
