# `GS_MASKING_POLICY_FILTERS`

`GS_MASKING_POLICY_FILTERS` 系统表记录动态数据脱敏策略对应的用户过滤条件，当用户条件满足FILTER条件时，对应的脱敏策略才会生效。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1** `GS_MASKING_POLICY_FILTERS`表字段

oid oid 行标识符（隐含属性，必须明确选择）。
filtertype name 过滤类型。目前值仅为logical_expr。
filterlabelname name 过滤范围。目前值仅为logical_expr。
policyoid oid 该条用户过滤条件所属的脱敏策略oid，对应GS_MASKING_POLICY中的oid。
modifydate timestamp without time zone 该条用户过滤条件创建或修改的最新时间戳。
logicaloperator text 过滤条件的波兰表达式。
