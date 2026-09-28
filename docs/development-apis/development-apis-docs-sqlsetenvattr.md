# SQLSetEnvAttr

## 功能描述

设置控制环境各方面的属性。

## 原型

```
SQLRETURN SQLSetEnvAttr(SQLHENV       EnvironmentHandle
                        SQLINTEGER    Attribute,
                        SQLPOINTER    ValuePtr,
                        SQLINTEGER    StringLength);
```

## 参数

**表 1**  SQLSetEnvAttr参数

关键字 参数说明 EnvironmentHandle 环境句柄。
Attribute 需设置的环境属性，可为如下值： SQL_ATTR_ODBC_VERSION：指定ODBC版本。SQL_CONNECTION_POOLING：连接池属性。SQL_OUTPUT_NTS：指明驱动器返回字符串的形式。
ValuePtr 指向对应Attribute的值。依赖于Attribute的值，ValuePtr可能是32位整型值，或为以空结束的字符串。
StringLength 如果ValuePtr指向字符串或二进制缓冲区，这个参数是*ValuePtr长度，如果ValuePtr指向整型，忽略StringLength。

## 返回值

- SQL\_SUCCESS：表示调用正确。
- SQL\_SUCCESS\_WITH\_INFO：表示会有一些警告信息。
- SQL\_ERROR：表示比较严重的错误，如：内存分配失败、建立连接失败等。
- SQL\_INVALID\_HANDLE：表示调用无效句柄。其他API的返回值同理。

## 注意事项

当SQLSetEnvAttr的返回值为SQL\_ERROR或SQL\_SUCCESS\_WITH\_INFO时，通过借助SQL\_HANDLE\_ENV的HandleType和EnvironmentHandle的Handle，调用[SQLGetDiagRec](sqlgetdiagrec.md)可得到相关的SQLSTATE值，通过SQLSTATE值可以查出调用此函数的具体信息。

## 示例

参见：[示例](example_odbc.md)
