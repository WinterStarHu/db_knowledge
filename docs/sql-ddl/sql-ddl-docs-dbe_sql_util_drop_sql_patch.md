# DBE\_SQL\_UTIL.drop\_sql\_patch

drop\_sql\_patch是用于删除SQL PATCH的接口函数，返回执行是否成功。

限制仅初始用户、sysadmin、opradmin、monadmin用户有权限调用。

**表 1**  DBE\_SQL\_UTIL.drop\_sql\_patch入参和返回值列表

patch_name IN name PATCH名称。
result OUT bool 执行是否成功。
