# `GS_AUDITING_POLICY_ACCESS`

`GS_AUDITING_POLICY_ACCESS` 系统表记录与DML数据库相关操作的统一审计信息。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1** `GS_AUDITING_POLICY_ACCESS` 字段

oid oid 行标识符（隐含属性，必须明确选择）。
accesstype name DML数据库操作相关类型。例如SELECT、INSERT、DELETE等。
labelname name 资源标签名称。对应系统表gs_auditing_policy中的polname字段。
policyoid oid 所属审计策略的oid，对应系统表GS_AUDITING_POLICY中的oid。
modifydate timestamp without time zone 创建或修改的最新时间戳。
