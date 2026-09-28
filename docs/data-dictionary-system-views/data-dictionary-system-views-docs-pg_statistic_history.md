# PG_STATISTIC_HISTORY

PG_STATISTIC_HISTORY用于存储统计信息历史数据版本记录，该表默认为只有管理员用户可访问，普通用户需要授权才可以访问。

**表 1** PG_STATISTIC_HISTORY字段

namespaceid oid 所描述的对象所属schema的Oid。
starelid oid 所描述的表的Oid。
partid oid 所描述的分区的Oid。
statype char 指定当前存储统计信息的类型。
t：指定当前存储的是表的统计信息。
p：指定当前存储的是分区的统计信息。
c：指定当前存储的是表字段统计信息。
last_analyzetime timestamp with time zone 指定对象上一次收集统计信息的时间，如果是第一次统计，则该值为NULL。
current_analyzetime timestamp with time zone 指定对象当前收集统计信息的时间。
starelkind char 所属对象的类型。
staattnum smallint 所描述的字段在表中的编号，从1开始。
stainherit boolean 是否统计有继承关系的对象。
stanullfrac real 该字段中为NULL的记录的比率。
stawidth integer 非NULL记录的平均存储宽度，以字节计。
stadistinct real 标识全局统计信息中数据库节点上字段里唯一的非NULL数据值的数目。
一个大于零的数值是独立数值的实际数目。一个小于零的数值是表中行数的分数的负数（比如，一个字段的数值平均出现概率为两次，则可以表示为stadistinct=-0.5）。零值表示独立数值的数目未知。
reltuples double precision 表中行的数目，只是优化器使用的一个估计值。
relpages double precision 以页（大小为BLCKSZ）为单位的此表在磁盘上的大小，它只是优化器用的一个近似值。
stalocktype char 标志当前统计历史信息对象的锁状态。若当前对象未被锁，则未NULL。
stakindN smallint 一个编码，表示这种类型的统计存储在pg_statistic行的第n个“槽位”。
n的取值范围：1～5 staopN oid 一个用于生成这些存储在第n个“槽位”的统计信息的操作符。比如，一个柱面图槽位会显示&lt;操作符，该操作符定义了该数据的排序顺序。
n的取值范围：1～5 stanumbersN real[] 第n个“槽位”的相关类型的数值类型统计，如果该槽位和数值类型没有关系，则就是NULL。
n的取值范围：1～5 stavaluesN anyarray 第n个“槽位”类型的字段数据值，如果该槽位类型不存储任何数据值，则就是NULL。每个数组的元素值实际上都是指定字段的数据类型，因此，除了把这些字段的类型定义成anyarray之外，没有更好地办法。
n的取值范围：1～5 stadndistinct real 标识dn1上字段里唯一的非NULL数据值的数目。
一个大于零的数值是独立数值的实际数目。一个小于零的数值是表中行数的分数的负数（比如，一个字段的数值平均出现概率为两次，则可以表示为stadistinct=-0.5）。零值表示独立数值的数目未知。
staextinfo text 统计信息的扩展信息。预留字段。

**须知：** PG_STATISTIC_HISTORY系统表存储了统计对象的一些敏感信息，如高频值MCV。系统管理员和授权后的其他用户可以通过访问PG_STATISTIC_HISTORY系统表查询到统计对象的这些敏感信息。
