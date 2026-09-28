# PG\_AGGREGATE

PG\_AGGREGATE系统表存储与聚集函数有关的信息。PG\_AGGREGATE里的每条记录都是一条pg\_proc里面的记录的扩展。PG\_PROC记录承载该聚集的名称、输入和输出数据类型，以及其它一些和普通函数类似的信息。

**表 1**  PG\_AGGREGATE字段

aggfnoid regproc PG_PROC.proname 此聚集函数的PG_PROC proname。
aggtransfn regproc PG_PROC.proname 转换函数。
aggcollectfn regproc PG_PROC.proname 收集函数。
aggfinalfn regproc PG_PROC.proname 最终处理函数（如果没有则为零）。
aggsortop oid PG_OPERATOR.oid 关联排序操作符（如果没有则为零）。
aggtranstype oid PG_TYPE.oid 此聚集函数的内部转换（状态）数据的数据类型。
可能取值及其描述见于系统表pg_type或查看源码中的pg_type.h文件中type定义，主要分为多态（isPolymorphicType）和非多态两类。
agginitval text 转换状态的初始值。这是一个文本数据域，它包含初始值的外部字符串表现形式。如果数据域是null，则转换状态值从null开始。
agginitcollect text 收集状态的初始值。这是一个文本数据域，它包含初始值的外部字符串表现形式。如果数据域是null，则收集状态值从null开始。
aggkind "char" aggnumdirectargs smallint Ordered Set Agg类型聚集函数的直接参数（非聚集相关参数）数量。对Normal Agg类型聚集函数，该值为0。
