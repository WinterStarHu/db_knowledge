# PG\_NAMESPACE

PG\_NAMESPACE系统表存储名称空间，即存储schema相关的信息。

**表 1**  PG\_NAMESPACE字段

oid oid 行标识符（隐含属性，必须明确选择）。
nspname name 名称空间的名称。
nspowner oid 名称空间的所有者。
nsptimeline bigint 在数据库节点上创建此命名空间时的时间线。此字段为内部使用，仅在数据库节点上有效。
nspacl aclitem[] 访问权限。
in_redistribution “char” 是否处于重发布状态。
nspblockchain boolean 如果为真，则该模式为防篡改模式。如果为假，则此模式为非防篡改模式。
nspcollation oid 名称空间的默认字符序（仅在sql_compatibility='b'时可能有值）。
