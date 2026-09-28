# DROP EVENT TRIGGER

## 功能描述

删除事件触发器。

## 注意事项

只有超级用户或者系统管理员才有权限删除事件触发器。

## 语法格式

DROP EVENT TRIGGER [ IF EXISTS ] name [ CASCADE | RESTRICT ];

## 参数说明

- **IF EXISTS**

如果指定的事件触发器不存在，则发出一个notice而不是抛出一个错误。

- **name**

要删除的事件触发器名称。

取值范围：已存在的事件触发器。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖此触发器的对象。
  - RESTRICT：如果有依赖对象存在，则拒绝删除此触发器。此选项为缺省值。

## 示例

请参见[CREATE EVENT TRIGGER](create_event_trigger.md)的[示例](create_event_trigger.md#zh-cn_topic_0283137014_zh-cn_topic_0237122081_zh-cn_topic_0059777895_s7f55076bb56940b7920a431c0c344669)。

## 相关链接

[ALTER EVENT TRIGGER](alter_event_trigger.md)，[CREATE EVENT TRIGGER](create_event_trigger.md)
