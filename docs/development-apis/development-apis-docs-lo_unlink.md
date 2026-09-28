# lo_unlink

## 功能描述

从数据库中移除一个大对象。

## 原型

```
int lo_unlink(PGconn* conn, Oid lobjId);
```

## 参数

**表 1**  lo\_unlink参数

关键字 参数说明 conn 一个数据库连接 lobjId 要移除的大对象的OID

## 返回值

int：成功时返回1，失败时返回-1。

## 示例

请参见[示例](example_libpq.md)章节。
