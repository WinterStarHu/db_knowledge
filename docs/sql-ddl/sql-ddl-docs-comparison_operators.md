# 比较操作符

大部分数据类型都可用比较操作符进行比较，并返回一个布尔类型的值。

比较操作符均为双目操作符，被比较的两个数据类型必须是相同的数据类型或者是可以进行隐式转换的类型。

openGauss提供的比较操作符请参见[表1](#zh-cn_topic_0283137685_zh-cn_topic_0237121966_zh-cn_topic_0059777421_zh-cn_topic_0058965550_table65067702)。

**表 1**  比较操作符

操作符 &lt;
&gt;
&lt;= 小于或等于 &gt;= 大于或等于 &lt;&gt; 或 !=或^= 不等于

比较操作符可以用于所有相关的数据类型。所有比较操作符都是双目操作符，返回布尔类型数值。不等号的计算优先级高于等号。当输入的数据不同且无法隐式转换时, 比较操作将会失败。例如像1<2<3这样的表达式是非法的，因为布尔值和3之间无法用小于号（<）比较。

示例：

```
openGauss=# select 1<2;
 ?column?
----------
 t
(1 row)

openGauss=# select 1>2;
 ?column?
----------
 f
(1 row)

openGauss=# select 1>=2;
 ?column?
----------
 f
(1 row)

openGauss=# select 1<=2;
 ?column?
----------
 t
(1 row)

openGauss=# select 1=2;
 ?column?
----------
 f
(1 row)

openGauss=# select 1!=2;
 ?column?
----------
 t
(1 row)
```
