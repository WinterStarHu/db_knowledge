# GS\_AUDITING\_POLICY\_FILTERS

GS\_AUDITING\_POLICY\_FILTERS系统表记录统一审计相关的过滤策略相关信息，每条记录对应一个设计策略。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1**  GS\_AUDITING\_POLICY\_FILTERS字段

oid oid 行标识符（隐含属性，必须明确选择）。
filtertype name 过滤类型。目前值仅为logical_expr。
labelname name 名称。目前值仅为logical_expr。
policyoid oid 所属审计策略的oid，对应系统表GS_AUDITING_POLICY中的oid。
modifydate timestamp 创建或修改的最新时间戳。
logicaloperator text 过滤条件的逻辑字符串。
