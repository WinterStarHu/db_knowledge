# DROP AUDIT POLICY

## 功能描述

删除一个审计策略。

## 注意事项

只有poladmin、sysadmin或初始用户才能进行此操作。

## 语法格式

```
DROP AUDIT POLICY [IF EXISTS] policy_name;
```

## 参数说明

policy\_name

审计策略名称，需要唯一，不可重复。

取值范围：字符串，要符合标识符的命名规范。

## 示例

请参考CREATE AUDIT POLICY的[示例](create_audit_policy.md#section7854941155112)。

## 相关链接

[ALTER AUDIT POLICY](alter_audit_policy.md)，[CREATE AUDIT POLICY](create_audit_policy.md)。
