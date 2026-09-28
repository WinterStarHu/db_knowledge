# PLAN\_TABLE

PLAN\_TABLE显示用户通过执行EXPLAIN PLAN收集到的计划信息。计划信息的生命周期是session级别，session退出后相应的数据将被清除。同时不同session和不同user间的数据是相互隔离的。

示例：

```sql
openGauss=# select * from PLAN_TABLE;
 statement_id | plan_id | id | operation | options | object_name | object_type | object_owner | projection | cost | cardinality
--------------+---------+----+-----------+---------+-------------+-------------+--------------+------------+------+-------------
```

**表 1**  PLAN\_TABLE字段

statement_id varchar2(30) 用户输入的查询标签。
plan_id bigint 查询标识。
int 查询生成的计划中的每一个执行算子的编号。
operation varchar2(30) 计划中算子的操作描述。
options varchar2(255) 操作选项。
object_name name 操作对应的对象名，非查询中使用到的对象别名。来自于用户定义。
object_type varchar2(30) 对象类型。
object_owner name 对象所属schema，来自于用户定义。
projection varchar2(4000) 操作输出的列信息。

>[!NOTE]说明
>
>- object\_type取值范围为[PG\_CLASS](pg_class.md)中定义的relkind类型（TABLE普通表，INDEX索引，SEQUENCE序列，VIEW视图，COMPOSITE TYPE复合类型，TOASTVALUE TOAST表）和计划使用到的rtekind\(SUBQUERY,JOIN,FUNCTION,VALUES,CTE,REMOTE\_QUERY\)。
>- object\_owner对于RTE来说是计划中使用的对象描述，非用户定义的类型不存在object\_owner。
>- statement\_id、object\_name、object\_owner、projection字段内容遵循用户定义的大小写存储，其它字段内容采用大写存储。
>- 支持用户对PLAN\_TABLE进行SELECT和DELETE操作，不支持其它DML操作。
