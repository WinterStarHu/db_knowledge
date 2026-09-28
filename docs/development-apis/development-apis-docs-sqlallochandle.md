# SQLAllocHandle

## 功能描述

分配环境、连接、语句或描述符的句柄，它替代了ODBC 2.x函数SQLAllocEnv、SQLAllocConnect及SQLAllocStmt。

## 原型

```
SQLRETURN SQLAllocHandle(SQLSMALLINT   HandleType,
                         SQLHANDLE     InputHandle,
                         SQLHANDLE     *OutputHandlePtr);
```

## 参数

**表 1**  SQLAllocHandle参数

关键字 参数说明 HandleType 由SQLAllocHandle分配的句柄类型。必须为下列值之一： SQL_HANDLE_ENV（环境句柄）SQL_HANDLE_DBC（连接句柄）SQL_HANDLE_STMT（语句句柄）SQL_HANDLE_DESC（描述句柄） 申请句柄顺序为，先申请环境句柄，再申请连接句柄，最后申请语句句柄，后申请的句柄都要依赖它前面申请的句柄。
InputHandle 将要分配的新句柄的类型。
如果HandleType为SQL_HANDLE_ENV，则这个值为SQL_NULL_HANDLE。如果HandleType为SQL_HANDLE_DBC，则这一定是一个环境句柄。如果HandleType为SQL_HANDLE_STMT或SQL_HANDLE_DESC，则它一定是一个连接句柄。
OutputHandlePtr 输出参数：一个缓冲区的指针，此缓冲区以新分配的数据结构存放返回的句柄。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。

## 注意事项

当分配的句柄并非环境句柄时，如果SQLAllocHandle返回的值为SQL\_ERROR，则它会将OutputHandlePtr的值设置为SQL\_NULL\_HDBC、SQL\_NULL\_HSTMT或SQL\_NULL\_HDESC。之后，通过调用带有适当参数的[SQLGetDiagRec](sqlgetdiagrec.md)，其中HandleType和Handle被设置为IntputHandle的值，可得到相关的SQLSTATE值，通过SQLSTATE值可以查出调用此函数的具体信息。

## 示例

参见：[示例](example_odbc.md)
