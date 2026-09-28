# CLASS\_VITAL\_INFO

CLASS\_VITAL\_INFO视图用于做WDR时校验相同的表或者索引的oid是否一致。

示例：

```sql
openGauss=# select * from DBE_PERF.CLASS_VITAL_INFO;
 relid |     schemaname     |                    relname                     | relkind
-------+--------------------+------------------------------------------------+---------
```

**表 1**  CLASS\_VITAL\_INFO字段

relid oid 表的oid。
schemaname name schema名称。
relname name 表名。
relkind "char"
