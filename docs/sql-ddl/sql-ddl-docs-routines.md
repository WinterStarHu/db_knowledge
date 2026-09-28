# ROUTINES

存储外键约束相关的信息。

**表 1**  ROUTINES相比于PGXC/PG新增字段

routine_comment text 函数或者存储过程的注释。
sql_mode text 当前dolphin.sql_mode的配置值。
sql_mode text 当前dolphin.sql_mode的配置值。
definer varchar(288) 创建者。
character_set_client varchar(64) 客户端的字符集。
collation_connection varchar(64) 当前数据库的字符序。
database_collation varchar(64) 当前数据库的字符序。
