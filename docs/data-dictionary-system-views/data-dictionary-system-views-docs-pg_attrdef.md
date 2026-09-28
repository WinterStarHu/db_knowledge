# PG\_ATTRDEF

PG\_ATTRDEF系统表存储列的默认值。

**表 1**  PG\_ATTRDEF字段

oid oid 行标识符（隐含属性，必须明确选择）。
adrelid oid 该列的所属表。
adnum smallint 该列的数目。
adbin pg_node_tree 字段缺省值或生成表达式的内部表现形式。
adsrc text 可读缺省值或生成表达式的内部表现形式。
adgencol "char" 标识该列是否为生成列。取值为's'表示该列为生成列，取值为'p'表示该列为D库兼容的生成列，取值为'\0'表示该列为普通列，默认值为'\0'。
adbin_on_update pg_node_tree 存储表达式转换成字符串格式。
adsrc_on_update text 存储表达式名称。
