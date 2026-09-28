# \_PG\_FOREIGN\_TABLE\_COLUMNS

显示外部表的列信息。该视图只有sysadmin权限可以查看。

**表 1**  \_PG\_FOREIGN\_TABLE\_COLUMNS字段

nspname name schema名称。
relname name 表名称。
attname name 列名称。
attfdwoptions text[] 外部数据封装器的属性选项，使用“keyword=value”格式的字符串。
