# DROP VIEW

## 功能描述

数据库中强制删除已有的视图。

## 注意事项

视图的所有者或者被授予了视图DROP权限的用户或拥有DROP ANY TABLE权限的用户，有权限执行DROP VIEW的命令，系统管理员默认拥有此权限。

## 语法格式

```
DROP VIEW [ IF EXISTS ] view_name [, ...] [ CASCADE | RESTRICT ];
```

## 参数说明

- **IF EXISTS**

如果指定的视图不存在，则发出一个notice而不是抛出一个错误。

- **view\_name**

要删除的视图名称。

取值范围：已存在的视图。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖此视图的对象（比如其他视图）。
  - RESTRICT（缺省项）：如果仅存在视图依赖对象，则允许删除此视图，否则拒绝删除。查询依赖视图时会提示相应依赖错误；新建视图如果名称和列名与视图依赖相匹配，在查询视图时会重新建立与新视图的依赖，恢复视图。

## 示例

请参见CREATE VIEW的[示例](create_view.md#zh-cn_topic_0283137480_zh-cn_topic_0237122126_zh-cn_topic_0059779377_s66a0b4a6a1df4ba4a116c6c565a0fe9d)。

## 相关链接

[ALTER VIEW](alter_view.md)，[CREATE VIEW](create_view.md)
