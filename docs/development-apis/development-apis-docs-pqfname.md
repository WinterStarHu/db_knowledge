# PQfname

## 功能描述

返回与给定列号相关联的列名。列号从0开始。调用者不应该直接释放该结果。它将在相关的PGresult句柄被传递给PQclear之后被释放。

## 原型

```
char *PQfname(const PGresult *res,
              int column_number);
```

## 参数

**表 1** PQfname参数

关键字 参数说明 res 操作结果句柄。
column_number 列数。

## 返回值

char类型指针。

## 示例

参见：[示例](example_libpq.md)
