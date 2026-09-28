# connection.rollback\(\)

## 功能描述

此方法回滚当前挂起事务。

>[!WARNING]注意
>执行关闭连接“close\(\)”而不先提交更改“commit\(\)”将导致执行隐式回滚。

## 原型

```
connection.rollback()
```

## 参数

无。

## 返回值

无。

## 示例

请参见[示例：常用操作](example_common_operations_psycopg.md)。
