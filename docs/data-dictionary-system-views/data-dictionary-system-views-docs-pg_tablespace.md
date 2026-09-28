# PG\_TABLESPACE

PG\_TABLESPACE系统表存储表空间信息。

**表 1**  PG\_TABLESPACE字段

oid oid 行标识符（隐含属性，必须明确选择）。
spcname name 表空间名称。
spcowner oid 表空间的所有者，通常是创建它的人。
spcacl aclitem[] GRANT和REVOKE。
spcoptions text[] 表空间的选项。
spcmaxsize text 可使用的最大磁盘空间大小，单位Byte。
relative boolean 标识表空间指定的存储路径是否为相对路径。
