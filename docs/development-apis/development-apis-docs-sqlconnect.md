# SQLConnect

## 功能描述

在驱动程序和数据源之间建立连接。连接上数据源之后，可以通过连接句柄访问到所有有关连接数据源的信息，包括程序运行状态、事务处理状态和错误信息。

## 原型

```
SQLRETURN  SQLConnect(SQLHDBC        ConnectionHandle,
                      SQLCHAR        *ServerName,
                      SQLSMALLINT    NameLength1,
                      SQLCHAR        *UserName,
                      SQLSMALLINT    NameLength2,
                      SQLCHAR        *Authentication,
                      SQLSMALLINT    NameLength3);
```

## 参数

**表 1**  SQLConnect参数

关键字 参数说明 ConnectionHandle 连接句柄，通过SQLAllocHandle获得。
ServerName 要连接数据源的名称。
NameLength1 ServerName的长度。
UserName 数据源中数据库用户名。
NameLength2 UserName的长度。
Authentication 数据源中数据库用户密码。
NameLength3 Authentication的长度。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。
- SQL\_STILL\_EXECUTING：表示语句正在执行。

## 注意事项

当调用SQLConnect函数返回SQL\_ERROR或SQL\_SUCCESS\_WITH\_INFO时，通过调用[SQLGetDiagRec](sqlgetdiagrec.md)函数，并将HandleType和Handle参数设置为SQL\_HANDLE\_DBC和ConnectionHandle，可得到一个相关的SQLSTATE值，通过SQLSTATE值可以查出调用此函数的具体信息。

## 示例

参见：[示例](example_odbc.md)
