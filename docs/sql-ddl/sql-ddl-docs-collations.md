# COLLATIONS

存储字符序相关的信息。

**表 1**  COLLATIONS相比于PGXC/PG新增字段

character_set_name varchar(64) 字符序对应的字符集名称。
bigint 字符序ID。
is_default varchar(3) 是否为对应字符集的默认字符序。
is_compiled varchar(3) 是否为内置字符序。
sortlen int 字符序的比较长度。
