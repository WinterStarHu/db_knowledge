# lo_write

## 功能描述

向一个大对象写入数据。

## 原型

```
int lo_write(PGconn* conn, int fd, const char* buf, size_t len);
```

## 参数

**表 1**  lo\_write参数

关键字 参数说明 conn 一个数据库连接 文件描述符 buf 要写入的数据，长度必须等于len len 要写入的长度

## 返回值

int：函数将返回实际写入的字节数。在出错时，返回值为-1。

## 示例

请参见[示例](example_libpq.md)章节。
