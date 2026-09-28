# SQLFreeHandle

## 功能描述

释放与指定环境、连接、语句或描述符相关联的资源，它替代了ODBC 2.x函数SQLFreeEnv、SQLFreeConnect及SQLFreeStmt。

## 原型

```
SQLRETURN SQLFreeHandle(SQLSMALLINT   HandleType,
                        SQLHANDLE     Handle);
```

## 参数

**表 1**  SQLFreeHandle参数

关键字 参数说明 HandleType SQLFreeHandle要释放的句柄类型。必须为下列值之一： SQL_HANDLE_ENVSQL_HANDLE_DBCSQL_HANDLE_STMTSQL_HANDLE_DESC 如果HandleType不是这些值之一，SQLFreeHandle返回SQL_INVALID_HANDLE。
Handle 要释放的句柄。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。

## 注意事项

如果SQLFreeHandle返回SQL\_ERROR，句柄仍然有效。

## 示例

参见：[示例](example_odbc.md)
