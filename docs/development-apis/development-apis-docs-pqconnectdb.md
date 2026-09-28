# PQconnectdb

## 功能描述

与数据库服务器建立一个新的连接。

## 原型

```
PGconn *PQconnectdb(const char *conninfo);
```

## 参数

**表 1**  PQconnectdb参数

关键字 参数说明 conninfo 链接参数串，字符串中的字段见链接参数章节。

## 返回值

PGconn \*：指向包含链接的对象指针，内存在函数内部申请。

## 注意事项

- 这个函数用从一个字符串conninfo来的参数与数据库打开一个新的链接。
- 传入的参数可以为空，表明使用所有缺省的参数，或者可以包含一个或更多个用空白间隔的参数设置，或者它可以包含一个URL。

## 示例

请参见[示例](example_libpq.md)章节。
