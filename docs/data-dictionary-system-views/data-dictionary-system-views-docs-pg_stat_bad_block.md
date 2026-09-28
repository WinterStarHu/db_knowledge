# PG\_STAT\_BAD\_BLOCK

PG\_STAT\_BAD\_BLOCK视图显示自节点启动后，读取数据时出现Page/CU校验失败的统计信息。

**表 1**  PG\_STAT\_BAD\_BLOCK字段

nodename text 节点名。
databaseid integer 数据库OID。
tablespaceid integer 表空间OID。
relfilenode integer 文件对象ID。
bucketid smallint 一致性hash bucket ID。
forknum integer 文件类型。取值如下： 0，数据主文件。
1，FSM文件。
2，VM文件。
3，BCM文件。
大于4，列存表每个字段的数据文件。
error_count integer 出现校验失败的次数。
first_time timestamp with time zone 第一次出现时间。
last_time timestamp with time zone 最近一次出现时间。
