# 货币类型

货币类型存储带有固定小数精度的货币金额。

[表1](#zh-cn_topic_0283137734_zh-cn_topic_0237121928_zh-cn_topic_0059778615_t7ceeb3b97d5d489a84770f824d7e017b)中显示的范围假设有两位小数。可以以任意格式输入，包括整型、浮点型或者典型的货币格式（如“$1,000.00”）。根据区域字符集，输出一般是最后一种形式。

**表 1**  货币类型

存储容量 money 8 字节 货币金额 -92233720368547758.08 到 +92233720368547758.07

numeric、int和bigint类型的值可以转化为money类型。如果从real和double precision类型转换到money类型，可以先转化为numeric类型，再转化为money类型，例如：

```
openGauss=#  SELECT '12.34'::float8::numeric::money;
```

这种用法是不推荐使用的。浮点数不应该用来处理货币类型，因为小数点的位数可能会导致错误。

money类型的值可以转换为numeric类型而不丢失精度。转换为其他类型可能丢失精度，并且必须通过以下两步来完成：

```
openGauss=#  SELECT '52093.89'::money::numeric::float8;
```

当一个money类型的值除以另一个money类型的值时，结果是double precision（也就是一个纯数字，而不是money类型）；在运算过程中货币单位相互抵消。
