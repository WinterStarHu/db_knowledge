# DBE\_SQL\_UTIL.show\_sql\_patch

show\_sql\_patch是用于显示给定patch\_name对应的SQL PATCH的接口函数，返回运行结果。

限制仅初始用户、sysadmin、opradmin、monadmin用户有权限调用。

**表 1**  DBE\_SQL\_UTIL.show\_sql\_patch入参和返回值列表

patch_name IN name PATCH名称。
unique_sql_id OUT bigint 查询全局唯一ID。
enabled OUT bool PATCH是否生效。
abort OUT bool 是否是AbortHint。
hint_str OUT text Hint文本。
