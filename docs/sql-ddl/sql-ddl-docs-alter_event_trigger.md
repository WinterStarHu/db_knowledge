# ALTER EVENT TRIGGER

## 功能描述

修改事件触发器。

## 注意事项

只有系统管理员或者超级用户才有权限对事件触发器进行修改。

## 语法格式

```
ALTER EVENT TRIGGER name DISABLE
ALTER EVENT TRIGGER name ENABLE [ REPLICA | ALWAYS ]
ALTER EVENT TRIGGER name OWNER TO { new_owner | CURRENT_USER | SESSION_USER }
ALTER EVENT TRIGGER name RENAME TO new_name
```

## 参数说明

- **name**

要修改的事件触发器名称。

取值范围：已存在的事件触发器。

- **new\_name**

修改后的新名称。

取值范围：符合标识符命名规范的字符串，最大长度不超过63个字符，且不能与所在表上其他事件触发器同名。

## 示例

请参见[CREATE EVENT TRIGGER](create_event_trigger.md)的[示例](create_event_trigger.md#zh-cn_topic_0283137014_zh-cn_topic_0237122081_zh-cn_topic_0059777895_s7f55076bb56940b7920a431c0c344669)。

## 相关链接

[CREATE EVENT TRIGGER](create_event_trigger.md)，[DROP EVENT TRIGGER](drop_event_trigger.md)
