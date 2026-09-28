# SQLExecute

## 功能描述

如果语句中存在参数标记的话，SQLExecute函数使用参数标记参数的当前值，执行一条准备好的SQL语句。

## 原型

```
SQLRETURN SQLExecute(SQLHSTMT    StatementHandle);
```

## 参数

**表 1**  SQLExecute参数

关键字 参数说明 StatementHandle 要执行语句的语句句柄。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_NEED\_DATA：表示在执行SQL语句前没有提供足够的参数。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_NO\_DATA：表示SQL语句不返回结果集。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。
- SQL\_STILL\_EXECUTING：表示语句正在执行。

## 注意事项

当SQLExecute函数返回SQL\_ERROR或SQL\_SUCCESS\_WITH\_INFO时，可通过调用[SQLGetDiagRec](sqlgetdiagrec.md)函数，并将HandleType和Handle参数设置为SQL\_HANDLE\_STMT和StatementHandle，可得到一个相关的SQLSTATE值，通过SQLSTATE值可以查出调用此函数的具体信息。

## 示例

参见：[示例](example_odbc.md)
