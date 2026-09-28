# GS\_MASKING\_POLICY\_ACTIONS

GS\_MASKING\_POLICY\_ACTIONS系统表记录动态数据脱敏策略中相应的脱敏策略包含的脱敏行为，一个脱敏策略对应着该表的一行或多行记录。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1**  GS\_MASKING\_POLICY\_ACTIONS表字段

oid oid 行标识符（隐含属性，必须明确选择）。
actiontype name 脱敏函数，标识脱敏策略使用的脱敏函数。
actparams name 向脱敏函数中传递的参数信息。
actlabelname name 被脱敏的label名称。
policyoid oid 该条记录所属的脱敏策略oid，对应GS_MASKING_POLICY中的oid。
modifydate timestamp 该条记录创建或修改的最新时间戳。
