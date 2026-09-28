# lo_truncate

## 功能描述

将一个大对象截断成一个给定长度。

## 原型

```
int lo_truncate(PGconn* conn, int fd, size_t len);
```

## 参数

**表 1**  lo\_truncate参数

关键字 参数说明 conn 一个数据库连接 文件描述符 len 要截断的长度

## 返回值

int：成功时返回0，失败时返回值为-1。

# lo_truncate64

## 功能描述

将一个\(可能超过2GB大小\)大对象截断成一个给定长度。

## 原型

```
int lo_truncate64(PGconn *conn, int fd, long int len);
```

## 参数

**表 1**  lo_truncate64参数

关键字 参数说明 conn 一个数据库连接 文件描述符 len 要截断的长度

## 返回值

int：成功时返回0，失败时返回值为-1。

## 示例

请参见[示例](example_libpq.md)章节。
