# lo_creat

## 功能描述

创建一个大对象。

## 原型

```
Oid lo_creat(PGconn* conn, int mode);
```

## 参数

**表 1**  lo\_creat参数

关键字 参数说明 conn 一个数据库连接 mode 指定只读、只写或者读写，已弃用、会被忽略，为兼容旧版本而保留参数

## 返回值

oid：返回值是分配给新大对象的OID或InvalidOid（0）表示发生错误。

# lo_create

## 功能描述

指定OID创建一个大对象，如果该OID已经被某个大对象使用时则会产生错误。

## 原型

```
Oid lo_create(PGconn* conn, Oid lobjId);
```

## 参数

**表 1**  lo\_create参数

关键字 参数说明 conn 一个数据库连接 lobjId 要创建的大对象的oid

## 返回值

oid：返回值是分配给新大对象的OID或InvalidOid（0）表示发生错误。

## 示例

请参见[示例](example_libpq.md)章节。
