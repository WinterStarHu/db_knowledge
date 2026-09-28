# SQLFetch

## 功能描述

从结果集中取下一个行集的数据，并返回所有被绑定列的数据。

## 原型

```
SQLRETURN SQLFetch(SQLHSTMT    StatementHandle);
```

## 参数

**表 1**  SQLFetch参数

关键字 参数说明 StatementHandle 语句句柄，通过SQLAllocHandle获得。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_NO\_DATA：表示SQL语句不返回结果集。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。
- SQL\_STILL\_EXECUTING：表示语句正在执行。

## 注意事项

当调用SQLFetch函数返回SQL\_ERROR或SQL\_SUCCESS\_WITH\_INFO时，通过调用[SQLGetDiagRec](sqlgetdiagrec.md)函数，并将HandleType和Handle参数设置为SQL\_HANDLE\_STMT和StatementHandle，可得到一个相关的SQLSTATE值，通过SQLSTATE值可以查出调用此函数的具体信息。

## 示例

参见：[示例](example_odbc.md)
