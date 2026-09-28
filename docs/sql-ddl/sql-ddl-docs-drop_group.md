# DROP GROUP

## 功能描述

删除用户组。

DROP GROUP是DROP ROLE的别名。

## 注意事项

DROP GROUP是openGauss管理工具封装的接口，用来实现openGauss管理。该接口不建议用户直接使用，以免对openGauss状态造成影响。

## 语法格式

```
DROP GROUP [ IF EXISTS ] group_name [, ...];
```

## 参数说明

请参见DROP ROLE的[参数说明](drop_role.md#zh-cn_topic_0283136937_zh-cn_topic_0237122147_zh-cn_topic_0059778848_sabe550f7ed48409b8ffd1d88ca9f0725)。

## 相关链接

[CREATE GROUP](create_group.md)，[ALTER GROUP](alter_group.md)，[DROP ROLE](drop_role.md)
