# connection.close\(\)

## 功能描述

此方法关闭数据库连接。

>[!WARNING]注意
>此方法关闭数据库连接，并不自动调用commit\(\)。如果只是关闭数据库连接而不调用commit\(\)方法，那么所有更改将会丢失。

## 原型

```
connection.close()
```

## 参数

无。

## 返回值

无。

## 示例

请参见[示例：常用操作](example_common_operations_psycopg.md)。
