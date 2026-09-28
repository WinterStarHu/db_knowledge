# COLUMNS

存储列相关的信息。

**表 1**  COLUMNS相比于PGXC/PG新增字段

privileges varchar(154) 当前用户对该列拥有的权限。
column_key varchar(3) 列的索引类型。
srs_id int 空间参考系统ID。
