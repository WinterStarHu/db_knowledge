# PG\_INDEXES\_VERBOSE
PG\_INDEXES\_VERBOSE视图可查询索引是否被其他索引覆盖。

**表 1**  PG\_INDEXES\_VERBOSE字段

indrelid oid 表 oid indexrelid oid 索引 oid tablename text schemaname text schema 名 indexname text 索引名 amname text 索引类型 idx_scan bigint 从 pg_stat_all_indexes 获取的统计信息 idx_tup_read bigint 从 pg_stat_all_indexes 获取的统计信息 idx_tup_fetch bigint 从 pg_stat_all_indexes 获取的统计信息 overlap_indexes []json 覆盖了当前索引的索引信息
