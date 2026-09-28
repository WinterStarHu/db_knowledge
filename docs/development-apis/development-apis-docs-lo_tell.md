# lo_tell

## 功能描述

得到一个大对象描述符的当前读或写位置。

## 原型

```
int lo_tell(PGconn* conn, int fd);
```

## 参数

**表 1**  lo\_tell参数

关键字 参数说明 conn 一个数据库连接 文件描述符

## 返回值

int：失败时返回值为-1。

# lo_tell64

## 功能描述

将一个\(可能超过2GB大小\)大对象截断成一个给定长度。

## 原型

```
long int lo_tell64(PGconn *conn, int fd);
```

## 参数

**表 1**  lo\_tell64参数

关键字 参数说明 conn 一个数据库连接 文件描述符

## 返回值

int：失败时返回值为-1。

## 示例

请参见[示例](example_libpq.md)章节。
