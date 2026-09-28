# lo_import

## 功能描述

将一个服务器端的操作系统文件导入成一个大对象。

## 原型

```
Oid lo_import(PGconn* conn, const char* filename);
```

## 参数

**表 1**  lo\_import参数

关键字 参数说明 conn 一个数据库连接 filename 要导入的文件的路径

## 返回值

oid：导入的大对象分配到的OID或InvalidOid（0）表示发生错误。

# lo_import_with_oid

## 功能描述

将一个服务器端的操作系统文件导入成一个指定OID的大对象，若该OID已经被某个大对象使用则会产生错误。

## 原型

```
Oid lo_import_with_oid(PGconn* conn, const char* filename, Oid lobjId);
```

## 参数

**表 1**  lo\_import\_with\_oid参数

关键字 参数说明 conn 一个数据库连接 filename 要导入的文件的路径 lobjId 要导入的大对象的OID

## 返回值

oid：导入的大对象分配到的OID或InvalidOid（0）表示发生错误。

## 示例

请参见[示例](example_libpq.md)章节。
