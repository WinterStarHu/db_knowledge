# GS\_AUDITING\_POLICY\_PRIVILEGES

GS\_AUDITING\_POLICY\_PRIVILEGES系统表记录统一审计DDL数据库相关操作信息，每条记录对应一个设计策略。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1**  GS\_AUDITING\_POLICY\_PRIVI字段

oid oid 行标识符（隐含属性，必须明确选择）。
privilegetype name DDL数据库操作相关类型。例如CREATE、ALTER、DROP等。
labelname name 资源标签名称。对应系统表gs_auditing_policy中的polname字段。
policyoid oid 对应审计策略系统表GS_AUDITING_POLICY中的oid。
modifydate timestamp 创建或修改的最新时间戳。
