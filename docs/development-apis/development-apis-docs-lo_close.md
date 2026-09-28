# lo_close

## 功能描述

关闭一个大对象描述符。

## 原型

```
int lo_close(PGconn* conn, int fd);
```

## 参数

**表 1**  lo\_close参数

关键字 参数说明 conn 一个数据库连接 文件描述符

## 返回值

int：成功时返回0，失败时返回-1。

## 示例

请参见[示例](example_libpq.md)章节。
