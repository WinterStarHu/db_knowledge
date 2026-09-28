# lo_open

## 功能描述

打开一个现有的大对象进行读写。

## 原型

```
int lo_open(PGconn* conn, Oid lobjId, int mode);
```

## 参数

**表 1**  lo\_open参数

关键字 参数说明 conn 一个数据库连接 lobjId 要打开的大对象的OID mode 控制打开对象后只读、只写或者读写

## 返回值

int：成功时返回非负文件描述符，失败时返回-1。

## 示例

请参见[示例](example_libpq.md)章节。
