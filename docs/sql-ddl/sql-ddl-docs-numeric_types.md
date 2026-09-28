# 数值类型

[表1](#zh-cn_topic_0283136992_zh-cn_topic_0237121927_zh-cn_topic_0059778296_zh-cn_topic_0058965945_table40398258)列出了所有的可用类型。数字操作符和相关的内置函数请参见[数字操作函数和操作符](mathematical_functions_and_operators.md)。

**表 1**  整数类型

存储空间 TINYINT 微整数，别名为INT1。
1字节 0 ~ 255 SMALLINT 小范围整数，别名为INT2。
2字节 -32,768 ~ +32,767 INTEGER 常用的整数，别名为INT4。
4字节 -2,147,483,648 ~ +2,147,483,647 BINARY_INTEGER 常用的整数INTEGER的别名。
4字节 -2,147,483,648 ~ +2,147,483,647 BIGINT 大范围的整数，别名为INT8。
8字节 -9,223,372,036,854,775,808 ~ +9,223,372,036,854,775,807 int16 十六字节的大范围整数，目前不支持用户用于建表等使用。
16字节 -170,141,183,460,469,231,731,687,303,715,884,105,728 ~ +170,141,183,460,469,231,731,687,303,715,884,105,727

NATURAL 非负整数，即自然数，目前不支持在该类型的列上创建索引。
4字节 0 ~ +2,147,483,647 NATURALN 带有非空约束的非负整数，目前不支持在该类型的列上创建索引。
4字节 0 ~ +2,147,483,647 POSITIVE 正整数，目前不支持在该类型的列上创建索引。
4字节 +1 ~ +2,147,483,647 POSITIVEN 带有非空约束的正整数，目前不支持在该类型的列上创建索引。
4字节 +1 ~ +2,147,483,647 SIGNTYPE 仅能取值为-1，0或+1的整数，目前不支持在该类型的列上创建索引。
4字节 -1, 0，+1 SIMPLE_INTEGER 带有非空约束、且支持加减乘法溢出的整数，目前不支持在该类型的列上创建索引。
4字节 -2,147,483,648 ~ +2,147,483,647

示例：

```
--创建具有TINYINT类型数据的表。
openGauss=# CREATE TABLE int_type_t1
           (
            IT_COL1 TINYINT
           );

--向创建的表中插入数据。
openGauss=# INSERT INTO int_type_t1 VALUES(10);

--查看数据。
openGauss=# SELECT * FROM int_type_t1;
 it_col1
---------
 10
(1 row)

--删除表。
openGauss=# DROP TABLE int_type_t1;

```

```
--创建具有TINYINT,INTEGER,BIGINT类型数据的表。
openGauss=# CREATE TABLE int_type_t2
(
    a TINYINT,
    b TINYINT,
    c INTEGER,
    d BIGINT
);

--插入数据。
openGauss=# INSERT INTO int_type_t2 VALUES(100, 10, 1000, 10000);

--查看数据。
openGauss=# SELECT * FROM int_type_t2;
  a  | b  |  c   |   d
-----+----+------+-------
 100 | 10 | 1000 | 10000
(1 row)

--删除表。
openGauss=# DROP TABLE int_type_t2;
```

>[!NOTE]说明
>
>- TINYINT、SMALLINT、INTEGER、BIGINT和INT16类型存储各种范围的数字，也就是整数。试图存储超出范围以外的数值将会导致错误。
>
>- 常用的类型是INTEGER，因为它提供了在范围、存储空间、性能之间的最佳平衡。一般只有取值范围确定不超过SMALLINT的情况下，才会使用SMALLINT类型。而只有在INTEGER的范围不够的时候才使用BIGINT，因为前者相对快得多。

**表 2**  任意精度型

存储空间 NUMERIC[(p[,s])], DECIMAL[(p[,s])] 精度p取值范围为[1,1000]，标度s取值范围为[-84,1000]。
用户声明精度。每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。
未指定精度的情况下，小数点前最大131,072位，小数点后最大16,383位。
NUMBER[(p[,s])] NUMERIC类型的别名。
用户声明精度。每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。
未指定精度的情况下，小数点前最大131,072位，小数点后最大16,383位。

示例：

```
--创建表。
openGauss=# CREATE TABLE decimal_type_t1
(
    DT_COL1 DECIMAL(10,4)
);

--插入数据。
openGauss=# INSERT INTO decimal_type_t1 VALUES(123456.122331);

--查询表中的数据。
openGauss=# SELECT * FROM decimal_type_t1;
   dt_col1
-------------
 123456.1223
(1 row)

--删除表。
openGauss=# DROP TABLE decimal_type_t1;
```

```
--创建表。
openGauss=# CREATE TABLE numeric_type_t1
(
    NT_COL1 NUMERIC(10,4)
);

--插入数据。
openGauss=# INSERT INTO numeric_type_t1 VALUES(123456.12354);

--查询表中的数据。
openGauss=# SELECT * FROM numeric_type_t1;
   nt_col1
-------------
 123456.1235
(1 row)

--删除表。
openGauss=# DROP TABLE numeric_type_t1;
```

>[!NOTE]说明
>
>- 与整数类型相比，任意精度类型需要更大的存储空间，其存储效率、运算效率以及压缩比效果都要差一些。在进行数值类型定义时，优先选择整数类型。当且仅当数值超出整数可表示最大范围时，再选用任意精度类型。
>
>- 使用Numeric/Decimal进行列定义时，建议指定该列的精度p以及标度s。

**表 3**  序列整型

存储空间 SMALLSERIAL 二字节序列整型。
2字节 -32,768 ~ +32,767 SERIAL 四字节序列整型。
4字节 -2,147,483,648 ~ +2,147,483,647 BIGSERIAL 八字节序列整型。
8字节 -9,223,372,036,854,775,808 ~ +9,223,372,036,854,775,807 LARGESERIAL 默认插入十六字节序列整形，实际数值类型和numeric相同。
变长类型，每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。
小数点前最大131,072位，小数点后最大16,383位。

示例：

```
--创建表。
openGauss=# CREATE TABLE smallserial_type_tab(a SMALLSERIAL);

--插入数据。
openGauss=# INSERT INTO smallserial_type_tab VALUES(default);

--再次插入数据。
openGauss=# INSERT INTO smallserial_type_tab VALUES(default);

--查看数据。
openGauss=# SELECT * FROM smallserial_type_tab;
 a
---
 1
 2
(2 rows)

--创建表。
openGauss=# CREATE TABLE serial_type_tab(b SERIAL);

--插入数据。
openGauss=# INSERT INTO serial_type_tab VALUES(default);

--再次插入数据。
openGauss=# INSERT INTO serial_type_tab VALUES(default);

--查看数据。
openGauss=# SELECT * FROM serial_type_tab;
 b
---
 1
 2
(2 rows)

--创建表。
openGauss=# CREATE TABLE bigserial_type_tab(c BIGSERIAL);

--插入数据。
openGauss=# INSERT INTO bigserial_type_tab VALUES(default);

--插入数据。
openGauss=# INSERT INTO bigserial_type_tab VALUES(default);

--查看数据。
openGauss=# SELECT * FROM bigserial_type_tab;
 c
---
 1
 2
(2 rows)

--创建表。
openGauss=# CREATE TABLE largeserial_type_tab(c LARGESERIAL);

--插入数据。
openGauss=# INSERT INTO largeserial_type_tab VALUES(default);

--插入数据。
openGauss=# INSERT INTO largeserial_type_tab VALUES(default);

--查看数据。
openGauss=# SELECT * FROM largeserial_type_tab;
 c
---
 1
 2
(2 rows)

--删除表。
openGauss=# DROP TABLE smallserial_type_tab;

openGauss=# DROP TABLE serial_type_tab;

openGauss=# DROP TABLE bigserial_type_tab;

openGauss=# DROP TABLE largeserial_type_tab;
```

>[!NOTE]说明
>
>SMALLSERIAL、SERIAL、BIGSERIAL和LARGESERIAL类型不是真正的类型，只是为在表中设置唯一标识做的概念上的便利。因此，创建一个整数字段，并且把它的缺省数值安排为从一个序列发生器读取。应用了一个NOT NULL约束以确保NULL不会被插入。在大多数情况下用户可能还希望附加一个UNIQUE或PRIMARY KEY约束避免意外地插入重复的数值，但这个不是自动的。最后，将序列发生器从属于那个字段，这样当该字段或表被删除的时候也一并删除它。目前只支持在创建表时候指定SERIAL列，不可以在已有的表中，增加SERIAL列。另外临时表也不支持创建SERIAL列。因为SERIAL不是真正的类型，也不可以将表中存在的列类型转化为SERIAL。

**表 4**  浮点类型

存储空间 REAL, FLOAT4 单精度浮点数，不精准。
4字节 -3.402E+38~3.402E+38，6位十进制数字精度。
DOUBLE PRECISION, FLOAT8 双精度浮点数，不精准。
8字节 -1.79E+308~1.79E+308，15位十进制数字精度。
FLOAT[(p)] 兼容选项 float_as_numeric 未开启时：浮点数，不精准；二进制精度 p 取值范围为 [1, 53]。兼容选项 float_as_numeric 开启时：映射至 NUMERIC；二进制精度 p 取值范围为 [1, 126]，对应的十进制精度范围为 [1, 38]。
兼容选项 float_as_numeric 未开启时，占用 4 字节或 8 字节。兼容选项 float_as_numeric 开启时，每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。
当兼容选项 float_as_numeric 未开启时，根据二进制精度 p 不同选择 REAL 或 DOUBLE PRECISION 作为内部实现。如不指定精度，则使用 DOUBLE PRECISION。当兼容选项 float_as_numeric 开启时，二进制精度 p 默认为 126 位，对应十进制精度 38 位。
BINARY_DOUBLE 是DOUBLE PRECISION的别名。支持浮点数特殊值BINARY_DOUBLE_INFINITY与BINARY_DOUBLE_NAN。
8字节 -1.79E+308~1.79E+308，15位十进制数字精度。
DEC[(p[,s])] 精度p取值范围为[1,1000]，标度s取值范围为[-84,1000]。
用户声明精度。每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。
未指定精度的情况下，小数点前最大131,072位，小数点后最大16,383位。
INTEGER[(p[,s])] 精度p取值范围为[1,1000]，标度s取值范围为[-84,1000]。
用户声明精度。每四位（十进制位）占用两个字节，然后在整个数据上加上八个字节的额外开销。

示例：

```
--创建表。
openGauss=# CREATE TABLE float_type_t2
(
    FT_COL1 INTEGER,
    FT_COL2 FLOAT4,
    FT_COL3 FLOAT8,
    FT_COL4 FLOAT(3),
    FT_COL5 BINARY_DOUBLE,
    FT_COL6 DECIMAL(10,4),
    FT_COL7 INTEGER(6,3)
);

--插入数据。
openGauss=# INSERT INTO float_type_t2 VALUES(10,10.365456,123456.1234,10.3214, 321.321, 123.123654, 123.123654);

--查看数据。
openGauss=# SELECT * FROM float_type_t2 ;
 ft_col1 | ft_col2 |   ft_col3   | ft_col4 | ft_col5 | ft_col6  | ft_col7
---------+---------+-------------+---------+---------+----------+---------
      10 | 10.3655 | 123456.1234 | 10.3214 | 321.321 | 123.1237 | 123.124
(1 row)

--删除表。
openGauss=# DROP TABLE float_type_t2;

--打开float_as_numeric
openGauss=# set behavior_compat_options = 'float_as_numeric';

--创建表。
openGauss=# CREATE TABLE float_type_t3
(
    FT_COL1 FLOAT(1),
    FT_COL2 FLOAT(5),
    FT_COL3 FLOAT
);

--插入数据。
openGauss=# INSERT INTO float_type_t3 VALUES(11.365456,11.365456,11.365456);
openGauss=# INSERT INTO float_type_t3 VALUES(123456.1234,123456.1234,123456.1234);

--查看数据。
openGauss=# SELECT * FROM float_type_t3;
 ft_col1 | ft_col2 |   ft_col3
---------+---------+-------------
      10 |      11 |   11.365456
  100000 |  120000 | 123456.1234
(2 rows)

--删除表。
openGauss=# DROP TABLE float_type_t3;
```

>[!NOTE]说明
>
>REAL、FLOAT4、DOUBLE PRECISION、FLOAT8、FLOAT（未开启float_as_numeric）、BINARY_DOUBLE等浮点数类型是不精确的，不精确意味着一些数值不能精确地转换成内部格式并且是以近似值存储的，因此存储后再把数据打印出来可能有一些差异。如果想用精确的数值和计算，应使用`numeric`类型。如果想用这些不精确的类型做任何重要的复杂计算，尤其是那些对范围情况（无穷/下溢）严重依赖的事情，应该仔细评诂SQL和应用实现，直接拿两个浮点数值进行比较，不一定总是能得到预期的结果。
>开启float_as_numeric后，FLOAT的精度默认为二进制精度，不是常见的十进制精度，换算关系如下：
`decimal_precision = ceil(log10(2) * binary_precision)`
>开启float_as_numeric后，由于FLOAT会映射至`numeric`，FLOAT类型在与其他值比较的时候不再使用FLOAT4、FLOAT8的索引，因而会造成一定的性能损失；FLOAT类型相关的隐式转换、索引的表现需要参考`numeric`类型。
