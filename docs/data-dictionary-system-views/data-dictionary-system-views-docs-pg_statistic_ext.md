# PG\_STATISTIC\_EXT

PG\_STATISTIC\_EXT系统表存储有关该数据库中表的扩展统计数据，包括多列统计数据和表达式统计数据（后续支持）。收集哪些扩展统计数据是由用户指定的。需要有系统管理员权限才可以访问此系统表。

**表 1**  PG\_STATISTIC\_EXT字段

starelid oid 所描述的字段所属的表或者索引。
starelkind "char" 所属对象的类型，'c'表示普通表，'p'表示分区表。
stainherit boolean 是否统计有继承关系的对象。
stanullfrac real 该字段中为NULL的记录的比率。
stawidth integer 非NULL记录的平均存储宽度，以字节计。
stadistinct real stadndistinct real stakindN smallint 一个编码，表示这种类型的统计存储在pg_statistic行的第n个“槽位”。
n的取值范围：1～5 staopN oid 一个用于生成这些存储在第n个“槽位”的统计信息的操作符。比如，一个柱面图槽位会显示&lt;操作符，该操作符定义了该数据的排序顺序。
n的取值范围：1～5 stakey int2vector 所描述的字段编号的数组。
stanumbersN real[] 第n个“槽位”的相关类型的数值类型统计，如果该槽位和数值类型没有关系，则就是NULL。
n的取值范围：1～5 stavaluesN anyarray 第n个“槽位”类型的字段数据值，如果该槽位类型不存储任何数据值，则就是NULL。每个数组的元素值实际上都是指定字段的数据类型，因此，除了把这些字段的类型定义成anyarray之外，没有更好地办法。
n的取值范围：1～5 staexprs pg_node_tree 扩展统计信息对应的表达式。
**须知：** PG\_STATISTIC\_EXT系统表存储了统计对象的一些敏感信息，如高频值MCV。系统管理员和授权后的其他用户可以通过访问PG\_STATISTIC\_EXT系统表查询到统计对象的这些敏感信息。
