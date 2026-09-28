# PG\_EXT\_STATS

PG\_EXT\_STATS视图提供对存储在[PG\_STATISTIC\_EXT](pg_statistic_ext.md)表里面的扩展统计信息的访问。扩展统计信息目前包括多列统计信息。

**表 1**  PG\_EXT\_STATS字段

schemaname name PG_NAMESPACE.nspname 包含表的模式名。
tablename name PG_CLASS.relname 表名。
attname int2vector PG_STATISTIC_EXT.stakey 统计信息扩展的多列信息。
inherited boolean 如果为真，则包含继承的子列，否则只是指定表的字段。
null_frac real 记录中字段组合为空的百分比。
avg_width integer 字段组合记录以字节记的平均宽度。
n_distinct real 如果大于零，表示字段组合中独立数值的估计数目。如果小于零，表示独立数值的数目被行数除的负数。用负数形式是因为ANALYZE认为独立数值的数目是随着表增长而增长；正数的形式用于在字段看上去好像有固定的可能值数目的情况下。比如，-1表示一个字段组合中独立数值的个数和行数相同。
如果等于零，表示独立数值的数目未知。
n_dndistinct real most_common_vals anyarray 一个字段组合里最常用数值的列表。如果该字段组合不存在最常用数值，则为NULL。本列保存的多列常用数值均不为NULL。
most_common_freqs real[] 一个最常用数值组合的频率的列表，也就是说，每个出现的次数除以行数。如果most_common_vals是NULL，则为NULL。
most_common_vals_null anyarray 一个字段组合里最常用数值的列表。如果该字段组合不存在最常用数值，则为NULL。本列保存的多列常用数值中至少有一个值为NULL。
most_common_freqs_null real[] 一个最常用数值组合的频率的列表，也就是说，每个出现的次数除以行数。如果most_common_vals_null是NULL，则为NULL。
histogram_bounds anyarray 直方图的边界值列表。
