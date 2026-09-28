# PG\_STATS

PG\_STATS视图提供对存储在pg\_statistic表里面的单列统计信息的访问。该视图记录的统计信息更新时间间隔由参数autovacuum\_naptime设置。

**表 1**  PG\_STATS字段

schemaname name PG_NAMESPACE.nspname 包含表的模式名。
tablename name PG_CLASS.relname 表名。
attname name PG_ATTRIBUTE.attname 字段的名称。
inherited boolean 如果为真，则包含继承的子列，否则只是指定表的字段。
null_frac real 记录中字段为空的百分比。
avg_width integer 字段记录以字节记的平均宽度。
n_distinct real 如果大于零，表示字段中独立数值的估计数目。如果小于零，表示独立数值的数目被行数除的负数。用负数形式是因为ANALYZE认为独立数值的数目是随着表增长而增长；正数的形式用于在字段看上去好像有固定的可能值数目的情况下。比如，-1表示一个唯一字段，独立数值的个数和行数相同。
n_dndistinct real most_common_vals anyarray 一个字段里最常用数值的列表。如果里面的字段数值是最常见的，则为NULL。
most_common_freqs real[] 一个最常用数值的频率的列表，也就是说，每个出现的次数除以行数。如果most_common_vals是NULL，则为NULL。
histogram_bounds anyarray 一个数值的列表，它把字段的数值分成几组大致相同热门的组。如果在most_common_vals里有数值，则在这个饼图的计算中省略。如果字段数据类型没有&lt;操作符或者most_common_vals列表代表了整个分布性，则这个字段为NULL。
correlation real 统计与字段值的物理行序和逻辑行序有关。它的范围从-1到+1。在数值接近-1或者+1的时候，在字段上的索引扫描将被认为比它接近零的时候开销更少，因为减少了对磁盘的随机访问。如果字段数据类型没有&lt;操作符，则这个字段为NULL。
most_common_elems anyarray 一个最常用的非空元素的列表。
most_common_elem_freqs real[] 一个最常用元素的频率的列表。
elem_count_histogram real[] 对于独立的非空元素的统计直方图。
