# DEALLOCATE

## 功能描述

DEALLOCATE用于删除前面编写的预备语句。如果用户没有明确删除一个预备语句，那么它将在会话结束的时候被删除。

PREPARE关键字总被忽略。

## 注意事项

无。

## 语法格式

```
DEALLOCATE [ PREPARE ] { name | ALL };
```

## 参数说明

- **name**

将要删除的预备语句。

- **ALL**

删除所有预备语句。

## 示例

无。
