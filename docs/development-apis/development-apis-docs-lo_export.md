# lo_export

## 功能描述

把一个大对象导出到一个服务器端的操作系统文件。

## 原型

```
int lo_export(PGconn* conn, Oid lobjId, const char* filename);
```

## 参数

**表 1**  lo\_export参数

关键字 参数说明 conn 一个数据库连接 lobjId 要导出的大对象的OID filename 要导出的文件路径

## 返回值

int：成功时返回1，失败时返回-1。

## 示例

请参见[示例](example_libpq.md)章节。
