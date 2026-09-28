# DBE\_SQL\_UTIL.create\_hint\_sql\_patch

create\_hint\_sql\_patch是用于创建调优SQL PATCH的接口函数，返回执行是否成功。

限制仅初始用户、sysadmin、opradmin、monadmin用户有权限调用。

**表 1**  DBE\_SQL\_UTIL.create\_hint\_sql\_patch入参和返回值列表

patch_name IN name PATCH名称。
unique_sql_id IN bigint 查询全局唯一ID。
hint_string IN text Hint文本。
Description IN text PATCH的备注，默认值为NULL。
enabled IN bool PATCH是否生效，默认值为true。
