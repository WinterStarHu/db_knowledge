# PG\_RLSPOLICIES

PG\_RLSPOLICIES视图提供查询行级访问控制策略。

**表 1**  PG\_RLSPOLICIES字段

schemaname name 行级访问控制策略作用的表对象所属模式名称。
tablename name 行级访问控制策略作用的表对象名称。
policyname name 行级访问控制策略名称。
policypermissive text 行级访问控制策略属性。
policyroles name[] 行级访问控制策略影响的用户列表，不指定表示影响所有的用户。
policycmd text 行级访问控制策略影响的SQL操作。
policyqual text 行级访问控制策略的表达式。
