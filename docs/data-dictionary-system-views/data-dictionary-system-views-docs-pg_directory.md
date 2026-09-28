# PG\_DIRECTORY

PG\_DIRECTORY系统表用于保存用户添加的directory对象可以通过CREATE DIRECTORY语句向该表中添加记录，目前只有系统管理员用户可以向该表中添加记录。

**表 1**  PG\_DIRECTORY字段

oid oid 行标识符（隐含属性，必须明确选择）。
dirname name 目录对象的名称。
owner oid 目录对象的所有者。
dirpath text 目录路径。
diracl aclitem[] 访问权限。
