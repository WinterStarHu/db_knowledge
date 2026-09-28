# connection.commit\(\)

## 功能描述

此方法将当前挂起的事务提交到数据库。

>[!WARNING]注意
>默认情况下，Psycopg在执行第一个命令之前打开一个事务：如果不调用commit\(\)，任何数据操作的效果都将丢失。

## 原型

```
connection.commit()
```

## 参数

无。

## 返回值

无。

## 示例

请参见[示例：常用操作](example_common_operations_psycopg.md)。
