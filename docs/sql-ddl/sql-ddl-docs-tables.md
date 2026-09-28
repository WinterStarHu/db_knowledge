# TABLES

存储表相关的信息。

**表 1**  TABLES相比于PGXC/PG新增字段

table_collation varchar(64) 表的字符序。
engine varchar(64) 表的存储引擎。
version int 表的版本。
row_format varchar(64) 表的行存储格式。
table_rows bigint 表的行数估算。
avg_row_length bigint 表的平均每行长度估算。
data_length bigint 表数据的总大小。
max_data_length bigint 表最大可存储数据量。
index_length bigint 索引总大小。
data_free bigint 表的剩余空间大小。
auto_increment int128 自增列的下一个值。
create_time timestamp 表的创建时间。
update_time timestamp 表的修改时间。
check_time timestamp 表的最后一次检查时间。
checksum bigint 表的校验和。
create_options varchar(64) 建表时的额外信息。
