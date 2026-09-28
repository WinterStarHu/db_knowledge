# DROP MASKING POLICY

## 功能描述

删除脱敏策略。

## 注意事项

只有poladmin、sysadmin或初始用户才能执行此操作。

## 语法格式

```
DROP MASKING POLICY [IF EXISTS] policy_name;
```

## 参数说明

**policy\_name**

审计策略名称，需要唯一，不可重复。

取值范围：字符串，要符合标识符的命名规范。

## 示例

```
--删除一个脱敏策略。
openGauss=# DROP MASKING POLICY IF EXISTS maskpol1;

--删除一组脱敏策略。
openGauss=# DROP MASKING POLICY IF EXISTS maskpol1, maskpol2, maskpol3;
```

## 相关链接

[ALTER MASKING POLICY](alter_masking_policy.md)，[CREATE MASKING POLICY](create_masking_policy.md)。
