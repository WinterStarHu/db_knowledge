# PG\_FOREIGN\_TABLE

PG\_FOREIGN\_TABLE系统表存储外部表的辅助信息。

**表 1**  PG\_FOREIGN\_TABLE字段

ftrelid oid 外部表的ID。
ftserver oid 外部表的所在服务器。
ftwriteonly boolean 外部表是否可写。取值如下： t（true）：表示可写。f（false）：表示不可写。
ftoptions text[] 外部表的可选项，具体参考CREATE FOREIGN TABLE语法说明。
