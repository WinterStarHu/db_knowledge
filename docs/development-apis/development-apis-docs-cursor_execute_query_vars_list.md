# cursor.execute\(query,vars\_list\)

## 功能描述

此方法执行被参数化的SQL语句（即占位符，而不是SQL文字）。psycopg2模块支持用％s标志的占位符。

## 原型

```
curosr.execute(query,vars_list)
```

## 参数

**表 1**  curosr.execute参数

关键字 参数说明 query 待执行的sql语句。
vars_list 变量列表，匹配query中%s占位符。

## 返回值

无。

## 示例

请参见[示例：常用操作](example_common_operations_psycopg.md)。
