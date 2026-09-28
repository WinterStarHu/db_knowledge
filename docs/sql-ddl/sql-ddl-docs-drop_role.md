# DROP ROLE

## 功能描述

删除指定的角色。

## 注意事项

无。

## 语法格式

```
DROP ROLE [ IF EXISTS ] role_name [, ...];
```

## 参数说明

- **IF EXISTS**

如果指定的角色不存在，则发出一个notice而不是抛出一个错误。

- **role\_name**

要删除的角色名称。

取值范围：已存在的角色。

## 示例

请参见CREATE ROLE的[示例](create_role.md#zh-cn_topic_0283136858_zh-cn_topic_0237122112_zh-cn_topic_0059778189_s0dea2f90b8474387aff0ab3f366a611e)。

## 相关链接

[CREATE ROLE](create_role.md)，[ALTER ROLE](alter_role.md)，[SET ROLE](set_role.md)
