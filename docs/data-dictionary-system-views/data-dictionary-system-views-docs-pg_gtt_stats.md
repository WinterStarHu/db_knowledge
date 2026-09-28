# PG\_GTT\_STATS

PG\_GTT\_STATS视图查看当前会话所有全局临时表单列统计信息，调用pg\_get\_gtt\_statistics函数。

**表 1**  PG\_GTT\_STATS字段

schemaname name schema名称。
tablename name 全局临时表名称。
attname name 属性名称。
inherited boolean 是否统计有继承关系的对象。
null_frac real 该字段中为NULL的记录的比率。
avg_width integer 非NULL记录的平均存储宽度，以字节计算。
n_distinct real 标识全局统计信息中字段里唯一的非NULL数据值的数目。
most_common_vals text[] 高频值列表，按照出现的频率排序。
most_common_freqs real[] 高频值的频率。
histogram_bounds text[] 等频直方图描述列中的数据分布（不包含高频值）。
correlation real 相关系数。
most_common_elems text[] 类型高频值列表，用于数组类型或一些其他类型。
most_common_elem_freqs real[] 类型高频值的频率。
elem_count_histogram real[] 数组类型直方图。
