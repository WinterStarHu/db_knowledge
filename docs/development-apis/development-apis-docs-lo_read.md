# lo_read

## 功能描述

从一个大对象读取数据。

## 原型

```
int lo_read(PGconn* conn, int fd, char* buf, size_t len);
```

## 参数

**表 1**  lo\_read参数

关键字 参数说明 conn 一个数据库连接 文件描述符 buf 从大对象描述符中读取最多len字节到buf len 要读取的数据长度

## 返回值

int：实际读出的字节数将被返回，如果先到达了大对象的末尾返回值可能会小于len。出错时返回值为-1。

## 示例

请参见[示例](example_libpq.md)章节。
