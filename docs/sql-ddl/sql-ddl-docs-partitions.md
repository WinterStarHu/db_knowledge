# PARTITIONS

存储分区相关的信息。

**表 1**  PARTITIONS字段

table_catalog varchar(64) 分区所在的数据库名。
table_schema varchar(64) 分区所在schema名。
table_name varchar(64) 分区所在的表名。
partition_name varchar(64) 分区名称。
subpartition_name varchar(64) 二级分区名称。
partition_ordinal_position int 分区位置。
subpartition_ordinal_position int 二级分区位置。
partition_method varchar(13) 分区方式。
subpartition_method varchar(13) 二级分区方式。
partition_expression varchar(2048) 分区表达式。
subpartition_expression varchar(2048) 二级分区表达式。
partition_description text 分区的描述信息。
table_rows bigint 分区行数估算。
avg_row_length bigint 分区每行长度估算。
data_length bigint 分区的总大小。
max_data_length bigint 分区可存储的最大大小。
index_length bigint 分区索引的大小。
data_free bigint 分区空闲大小。
create_time timestamp 分区创建时间。
update_time timestamp 分区更新时间。
check_time timestamp 分区检查时间。
checksum bigint 分区检验和。
partition_comment text 分区注释。
nodegroup varchar(256) 节点组。
tablespace_name varchar(256) 表空间名称。
