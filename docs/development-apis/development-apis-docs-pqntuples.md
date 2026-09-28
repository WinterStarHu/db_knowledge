# PQntuples

## 功能描述

返回查询结果中的行（元组）数。因为它返回一个整数结果，在 32 位操作系统上大型的结果集可能使返回值溢出。

## 原型

```
int PQntuples(const PGresult *res);
```

## 参数

**表 1** PQntuples参数

关键字 参数说明 res 操作结果句柄。

## 返回值

int类型数字。

## 示例

参见：[示例](example_libpq.md)
