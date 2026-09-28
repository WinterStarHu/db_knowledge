# STATISTICS

存储索引相关的信息。

**表 1**  STATISTICS字段

table_catalog varchar(64) 索引的物理表所在的数据库名。
table_schema varchar(64) 索引的物理表所在的schema名。
table_name varchar(64) 索引所在的物理表名。
non_unique int 是否是唯一索引。
index_schema varchar(64) 索引所在的schema名。
index_name varchar(64) 索引名称。
seq_in_index int 索引所在的位置。
column_name varchar(64) 索引所在的列名。
collation varchar(1) 是升序还是降序索引。
cardinality bigint 索引的行数估算。
sub_part bigint 索引的字符长度。
packed varchar(64) 是否为压缩索引。
nullable varchar(3) 索引是否允许为空。
index_type varchar(11) 索引类型。
comment varchar(8) 索引的注释信息。
index_comment varchar(2048) 索引的注释信息。
is_visible varchar(3) 索引是否可见。
expression text 索引表达式。
