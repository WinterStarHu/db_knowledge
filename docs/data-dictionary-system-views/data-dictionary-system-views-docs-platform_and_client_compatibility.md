# 平台和客户端兼容性

很多平台都使用数据库系统，数据库系统的对外兼容性给平台提供了很大的方便。

## convert\_string\_to\_digit

**参数说明**：设置隐式转换优先级，是否优先将字符串转为数字。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示优先将字符串转为数字。
- off表示不优先将字符串转为数字。

**默认值**：on

>[!TIP]须知
>该参数调整会修改内部数据类型转换规则，导致不可预期的行为，请谨慎操作。

## nls\_timestamp\_format

**参数说明**：设置时间戳默认格式。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串

**默认值**：DD-Mon-YYYY HH:MI:SS.FF AM

## nls\_length\_semantics

**参数说明**：设置字符串类型的默认语义，设置为BYTE，按照字节计算字符串长度，设置为CHAR，按照字符计算字符串长度。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：BYTE | CHAR

**默认值**：BYTE

## group\_concat\_max\_len

**参数说明**： 搭配函数GROUP\_CONCAT使用，限制其返回值长度，超长截断。

该参数属于USERSET类型参数，请参考表[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 0-9223372036854775807

**默认值**： 1024

>[!NOTE]说明
>目前能返回的最大长度是1073741823，超出此长度后会有out of memory的报错。

## max\_function\_args

**参数说明**：函数参数最大个数。

该参数属于INTERNAL类型参数，为固定参数，用户无法修改此参数，只能查看。

**取值范围**：整型

**默认值**：8192

## transform\_null\_equals

**参数说明**： 控制表达式expr = NULL（或NULL = expr）当做expr IS NULL处理。如果expr得出NULL值则返回真，否则返回假。

- 正确的SQL标准兼容的expr = NULL总是返回NULL（未知）。
- Microsoft Access里的过滤表单生成的查询使用expr = NULL来测试空值。打开这个选项，可以使用该接口来访问数据库。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示控制表达式expr = NULL（或NULL = expr）当做expr IS NULL处理。
- off表示不控制，即expr = NULL总是返回NULL（未知）。

**默认值**： off

>[!NOTE]说明
>新用户经常在涉及NULL的表达式上语义混淆，故默认值设为off。

## ansi_nulls

**参数说明**： 与transform\_null\_equals参数含义相反，当transform\_null\_equals设置为on的时候，此参数自动设置为off，当transform\_null\_equals设置成off的时候，此参数自动设置为on。同理，当此参数设置为on时，transform\_null\_equals会自动设置成off，当此参数设置成off时，transform\_null\_equals会自动设置成on。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

**默认值**： on

## support\_extended\_features

**参数说明**： 控制是否支持数据库的扩展特性。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示支持数据库的扩展特性。
- off表示不支持数据库的扩展特性。

**默认值**： off

## sql\_compatibility

**参数说明**： 控制数据库的SQL语法和语句行为同哪一个主流数据库兼容。

该参数属于INTERNAL类型参数，用户无法修改，只能查看。

**取值范围**： 枚举型

- A表示同O数据库兼容。
- B表示同MY数据库兼容。
- C表示同TD数据库兼容。
- PG表示同POSTGRES数据库兼容。
- D表示同S数据库兼容。

**默认值**： A

>[!TIP]须知
>
>- 该参数只能在执行[CREATE DATABASE](../sql_reference/create_database.md)命令创建数据库时通过dbcompatibility设置。
>
>- 在数据库中，该参数只能是确定的一个值，要么始终设置为A，要么始终设置为B，请勿任意改动，否则会导致数据库行为不一致。

## b\_format\_behavior\_compat\_options

**参数说明**： 数据库B模式兼容性行为配置项，该参数的值由若干个配置项用逗号隔开构成。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 字符串

**默认值**： 'enable_set_variables,set_session_transaction,enable_modify_column,default_collation,fetch,enable_multi_charset,diagnostics'

>[!NOTE]说明
>
>- 当前只支持[表1 兼容性B模式配置项](#table18793103274617)。
>- 配置多个兼容性配置项时，相邻配置项用逗号隔开，例如：set b\_format\_behavior\_compat\_options='enable\_set\_variables,set\_session\_transaction';

**表 1**  兼容性B模式配置项

兼容性配置项 兼容性行为控制 enable_set_variables set语法增强控制开关。
不设置此配置时，不支持set自定义变量、set [global | session]语法。设置此配置时，支持B兼容模式下使用上述语法，比如 set @v1 = 1；。设置此配置时，会影响@相关的操作符。
set_session_transaction set session transaction控制开关。
不设置此配置时，set session transaction等效于set local transaction。设置此配置时，支持B兼容模式下使用上述语法，修改当前会话事务特性。
enable_modify_column ALTER TABLE MODIFY语义控制开关。
不设置此配置时，“ALTER TABLE table_name MODIFY column_name data_type;”只修改列的数据类型。设置此配置时，“ALTER TABLE table_name MODIFY column_name data_type;”修改整个列定义。设置此配置，修改列定义如果只指定数据类型，会导致原有列的其他属性（比如默认值，not null约束等）丢失。
default_collation 默认字符序前向兼容开关。
不设置此配置时，在未显式指定字符类型字段的字符集或字符序且表级字符序也为空时，字段为default字符序。设置此配置时，字符类型字段的字符序当表级字符序不为空时继承表级字符序，为空时设置为数据库编码对应的默认字符序。针对OM方式安装的数据库，Encoding=SQL_ASCII，Collate=C，Ctype=C，在配置'default_collation'时，建表指定varchar类型，将实际存储为varbinary类型，因此为兼容MY，建议在创建B库时指定编码为UTF8，即`create database testb with dbcompatibility = 'b' encoding 'UTF8'`;同时字符序的差异会存在大小写敏感的差异，导致部分查询结果有差异。
fetch FETCH语句结尾报错兼容开关。
不设置此配置时，FETCH抓取完了所有可用行，它就停在最后一行后面，或者在反向抓取的情况下是停在第一行前面。设置此配置时，FETCH抓取完了所有可用行后报错。
enable_multi_charset 多字符集功能的控制开关。
不设置此配置时，不允许不同于数据库字符集的数据，不处理不同于数据库字符集的表达式。设置此配置时，允许数据库中含有不同于数据库字符集的数据，合并不同字符集的表达式。不同字符集的表达式运算规则详见：字符集与字符序。xml、json、tsvector、gtsvector、tsquery、record、hll、hll_hashval、hll_trans_type类型数据不支持多字符集转换。
diagnostics GET DIAGNOSTICS兼容开关。
不设置此配置时，GET DIAGNOSTIC语法按原有实现，不支持在异常块获取行数，会抛出错误。设置此配置时，GET DIAGNOSTIC语法获取诊断信息，按MySQL兼容语法实现。

## enable_set_variable_b_format

**参数说明**： 在MY数据库模式下是否支持自定义用户变量的功能。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

**默认值**： on

- on表示在MY数据库模式下支持自定义用户变量。设置此配置时，会影响@相关的操作符。
- off表示在MY数据库模式下不支持自定义用户变量。

```
openGauss=# set b_format_behavior_compat_options = '';
SET
openGauss=# set enable_set_variable_b_format = on;
SET
openGauss=# set @v1 = 1;
SET
openGauss=# select @@ box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)

openGauss=# select @@box '(0,0),(4,4)' AS center_point;
ERROR:  syntax error at or near "AS"
LINE 1: select @@box '(0,0),(4,4)' AS center_point;
                                   ^
openGauss=# set enable_set_variable_b_format = off;
SET
openGauss=# set @v1 = 1;
ERROR:  SET UserVar/GLOBAL/SESSION is supported only in B-format database, and enable_set_variable_b_format = on.
LINE 1: set @v1 = 1;
        ^
openGauss=# select @@ box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)

openGauss=# select @@box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)

openGauss=# set enable_set_variable_b_format = off;
SET
openGauss=# set b_format_behavior_compat_options = 'enable_set_variables';
SET
openGauss=# set @v1 = 1;
SET
openGauss=# select @@ box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)

openGauss=# select @@box '(0,0),(4,4)' AS center_point;
ERROR:  syntax error at or near "AS"
LINE 1: select @@box '(0,0),(4,4)' AS center_point;
                                   ^
openGauss=# set b_format_behavior_compat_options = '';
SET
openGauss=# set @v1 = 1;
ERROR:  SET UserVar/GLOBAL/SESSION is supported only in B-format database, and enable_set_variable_b_format = on.
LINE 1: set @v1 = 1;
        ^
openGauss=# select @@ box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)

openGauss=# select @@box '(0,0),(4,4)' AS center_point;
 center_point
--------------
 (2,2)
(1 row)
```

## behavior\_compat\_options

**参数说明**： 数据库兼容性行为配置项，该参数的值由若干个配置项用逗号隔开构成。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 字符串

**默认值**： sql_mode_full_group

>[!NOTE]说明
>
>- 当前只支持[表2 兼容性配置项](#zh-cn_topic_0283137574_zh-cn_topic_0237124754_table182861153114812)。
>
>- 配置多个兼容性配置项时，相邻配置项用逗号隔开，例如：set behavior\_compat\_options='end\_month\_calculate,display\_leading\_zero';

**表 2**  兼容性配置项

name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p192861053194814"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p192861053194814"><strong id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b711224504"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b711224504"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b711224504">兼容性配置项 name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p10286553144814"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p10286553144814"><strong id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b18416212503"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b18416212503"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_b18416212503">兼容性行为控制 name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p152861153174819"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p152861153174819">display_leading_zero name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p192848725515"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p192848725515">浮点数显示配置项。控制数值类型中浮点类型、任意精度类型的小数点前零显示。并且length计算数字长度同步显示。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul11299194763811"> 不设置此配置项时，对于-1~0和0~1之间的小数，不显示小数点前的0。比如：<a name="screen182721311065"> openGauss=# select 0.1231243 as a, 0.1231243::numeric as b,0.1231243::integer(10,3) as c, length(0.1242343) as d;
a     |    b     |  c   | d
----------+----------+------+---
.1231243 | .1231243 | .123 | 8 (1 row) 设置此配置项时，对于-1~0和0~1之间的小数，显示小数点前的0。比如：<a name="screen15439342065"> openGauss=# select 0.1231243 as a, 0.1231243::numeric as b,0.1231243::integer(10,3) as c, length(0.1242343) as d;
a     |     b     |   c   | d
-----------+-----------+-------+---
 0.1231243 | 0.1231243 | 0.123 | 9
(1 row) 说明：to_char(numeric, format)函数中小数点前0的显示不受该配置项控制，而由format模板决定。对于-1~0和0~1之间的小数，小数点前没有有效整数位；当format小数点前使用9占位时，该0会按模板规则显示为空格，例如9.9、999,999.99；当format小数点前使用0占位时，该0会显示，例如0.9。对于小数点前已有有效整数位的数值，不涉及该0的隐藏问题。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15286253134812"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15286253134812">end_month_calculate name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12991318145719"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12991318145719">add_months函数计算逻辑配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p43715241715"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p43715241715">假定函数add_months的两个参数分别为param1和param2，param1的月份和param2的和为月份result。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul69601452123815"> 不设置此配置项时，如果param1的日期（Day字段）为月末，并且param1的日期（Day字段）比result月份的月末日期小，计算结果中的日期字段（Day字段）和param1的日期字段保持一致。比如， name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen568916248386"> <pre class="screen" codetype="Sql" id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen568916248386">openGauss=# select add_months('2018-02-28',3) from sys_dummy;
add_months \---------------------\ 2018-05-28 00:00:00 (1 row) name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul165115579383"> 设置此配置项时，如果param1的日期（Day字段）为月末，并且param1的日期（Day字段）比result月份的月末日期比小，计算结果中的日期字段（Day字段）和result的月末日期保持一致。比如， name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen45031931103816"> <pre class="screen" codetype="Sql" id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen45031931103816">openGauss=# select add_months('2018-02-28',3) from sys_dummy;
add_months \---------------------\ 2018-05-31 00:00:00 (1 row) name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p128618539487"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p128618539487">compat_analyze_sample name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p828635304814"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p828635304814">analyze采样行为配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p108691828173114"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p108691828173114">设置此配置项时，会优化analyze的采样行为，主要体现在analyze时全局采样会更精确的控制在3万条左右，更好的控制analyze时DBnode端的内存消耗，保证analyze性能的稳定性。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p7480171620559"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p7480171620559">bind_schema_tablespace name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p7391102013556"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p7391102013556">绑定模式与同名表空间配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p164801516195514"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p164801516195514">如果存在与模式名sche_name相同的表空间名，那么如果设置search_path为sche_name， default_tablespace也会同步切换到sche_name。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p4465122914550"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p4465122914550">bind_procedure_searchpath name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p195111830125718"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p195111830125718">未指定模式名的数据库对象的搜索路径配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12261948214"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12261948214">在存储过程中如果不显示指定模式名，会优先在存储过程所属的模式下搜索。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p716129629"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p716129629">如果找不到，则有两种情况： name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul7861812102420"> 若不设置此参数，报错退出。
若设置此参数，按照search_path中指定的顺序继续搜索。如果还是找不到，报错退出。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p20442166924"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p20442166924">correct_to_number name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p13214155316919"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p13214155316919">控制to_number()结果兼容性的配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p104421662219"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p104421662219">若设置此配置项，则to_number()函数结果与pg11保持一致，否则默认与O db保持一致。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p1289114540156"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p1289114540156">unbind_divide_bound name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p88921554101510"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p88921554101510">控制对整数除法的结果进行范围校验。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12567153015184"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p12567153015184">若设置此配置项，则不需要对除法结果做范围校验，例如，INT_MIN/(-1)可以得到输出结果为INT_MAX+1，反之，则会因为超过结果大于INT_MAX而报越界错误。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p16481102116476"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p16481102116476">return_null_string name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p17481162111477"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p17481162111477">控制函数lpad()和rpad()结果为空字符串''的显示配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul828544001313"> 不设置此配置项时，空字符串显示为NULL。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen17865171482915"> <pre class="screen" codetype="Sql" id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen17865171482915">postgres=# select length(lpad('123',0,'*')) from sys_dummy;
length \--------\ (1 row) name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_ul75590181418"> 设置此配置项时，空字符串显示为''。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen104295208294"> <pre class="screen" codetype="Sql" id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_screen104295208294">postgres=# select length(lpad('123',0,'*')) from sys_dummy;
length \--------\ 0 (1 row) name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p19552125434713"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p19552125434713">compat_concat_variadic name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15521954134717"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15521954134717">控制函数concat()和concat_ws()对variadic类型结果兼容性的配置项。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p1060812139425"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p1060812139425">若设置此配置项，当concat函数参数为variadic类型时，保留a db和Teradata兼容模式下不同的结果形式；否则默认a db和Teradata兼容模式下结果相同，且与a db保持一致。由于MY无variadic类型，所以该选项对MY无影响。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p123596109205"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p123596109205"><span id="zh-cn_topic_0283137574_zh-cn_topic_0237124754_text938325714529"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_text938325714529"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_text938325714529">merge_update_multi name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15359171062012"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p15359171062012">控制在使用MERGE INTO ...
WHEN MATCHED THEN UPDATE（参考MERGE INTO）和INSERT ... ON DUPLICATE KEY UPDATE（参考<a href="../sql_reference/insert.md">INSERT）时，当目标表中一条目标数据与多条源数据冲突时UPDATE行为。
name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p87151258513"><a name="zh-cn_topic_0283137574_zh-cn_topic_0237124754_p87151258513">若设置此配置项，当存在上述场景时，该冲突行将会多次执行UPDATE；否则（默认）报错，即MERGE或INSERT操作失败。
plstmt_implicit_savepoint 控制存储过程中更新语句的执行是否拥有独立的子事务。
name="p858064018217">若设置此配置项，存储过程中每条更新语句前开启隐式保存点，EXCEPTION块中默认回退到最近的保存点，从而保证只回退失败语句的修改。该选项是为了兼容O数据库的EXCEPTION行为。
hide_tailing_zero name="p154421657193919">numeric显示配置项。不设置此项时，numeric按照指定精度显示。设置此项时，所有输出numeric的场景均隐藏小数点后的末尾0，包括显示指定format精度情况。
openGauss=# set behavior_compat_options='hide_tailing_zero';
openGauss=# select cast(123.123 as numeric(15,10)) as a, to_char(cast(123.123 as numeric(15,10)), '999D999999');
a    | to_char
---------+----------
 123.123 |  123.123
(1 row) openGauss=# set behavior_compat_options='';
openGauss=# select cast(123.123 as numeric(15,10)) as a, to_char(cast(123.123 as numeric(15,10)), '999D999999');
a        |   to_char
----------------+-------------
 123.1230000000 |  123.123000
(1 row) rownum_type_compat name="p63603214149">控制ROWNUM的类型，ROWNUM默认类型为INT8，设置此参数后，ROWNUM类型变更为NUMERIC类型。
aformat_null_test name="p193002814811">控制rowtype类型判空逻辑,设置此项时，对于rowtype is not null判断，当一行数据有一列不为空的时候返回ture。
否则，对于rowtype is not null判断，当一行数据所有列不为空的时候返回ture.
aformat_regexp_match 控制正则表达式函数的匹配行为。

否则，正则表达式的 flags 参数支持的选项含义： . 默认能匹配 '\n' 字符。
flags 中的 n 选项表示按照多行模式匹配。
regexp_replace(source, pattern replacement) 函数仅替换第一个匹配到的子串。
regexp_replace(source, pattern, replacement, flags) 在 flags值为'' 或者null时，返回值为替换后的字符串。
compat_cursor name="p19352436185016">控制隐式游标状态兼容行为。设置此项，且兼容O，隐式游标状态（SQL%FOUND、SQL%NOTFOUND、SQL%ISOPNE、SQL%ROWCOUNT）由原先的仅在当前执行的函数有效，拓展到包括本函数调用的子函数有效。
proc_outparam_override name="p20735112918154">控制存储过程出参的重载行为，打开该参数后，对于存储过程只有out出参部分不同的情况下，也可以正常调用。
name="p943192894419">proc_implicit_for_loop_variable name="p343142824413">控制存储过程中FOR_LOOP查询语句行为设置此项时，在FOR rec IN query LOOP语句中，若rec已经定义，不会复用已经定义的rec变量，而且重新建立一个新的变量。否则，会复用已经定义的rec变量，不会建立新的变量。
name="p18130240101518">allow_procedure_compile_check 控制存储过程中select语句和open cursor语句的编译检查设置此项时，在存储过程中执行select语句、open cursor for语句、cursor%rowtype语句、for rec in语句时，若查询的表不存在，则无法创建创建存储过程，不支持trigger函数的编译检查，若查询的表存在，则成功创建存储过程。
char_coerce_compat name="p1276918101287">控制char(n)类型向其它变长字符串类型转换时的行为，以及char(n)和varchar操作时的行为。默认情况下char(n)类型转换其它变长字符串类型时会省略尾部的空格，开启该参数后，转换时不再省略尾部的空格，并且在转换时如果char(n)类型的长度超过其它变长字符串类型时将会报错；开启该参数后，char(n)和varchar操作时，例如比较操作符，首先各自转换为text类型再进行操作，具体表现为在操作时不会忽略尾部空格，如' '::char(5)和' '::varchar(5)不相等。该参数仅在sql_compatibility参数的值为A时生效。
name="p169001822183412">truncate_numeric_tail_zero name="p74891049203418">numeric显示配置项。不设置此项时，numeric按照默认精度显示。设置此项时，除去to_char(numeric, format)这种显示设置精度的情况，所有输出numeric的场景均会隐藏小数点后的末尾0。例如： openGauss=# set behavior_compat_options='truncate_numeric_tail_zero';
openGauss=# select cast(123.123 as numeric(15,10)) as a, to_char(cast(123.123 as numeric(15,10)), '999D999999');
a    |   to_char
---------+-------------
 123.123 |  123.123000
(1 row) openGauss=# set behavior_compat_options='';
openGauss=# select cast(123.123 as numeric(15,10)) as a, to_char(cast(123.123 as numeric(15,10)), '999D999999');
a        |   to_char
----------------+-------------
 123.1230000000 |  123.123000
(1 row) pgformat_substr 控制substr(str, from, for)在不同场景下的表现。默认情况下，当from小于0时，substr将从字符串尾部开始计数；当for小于1时，substr将返回NULL。开启该参数后，当from小于0时，将从字符串的第一位的前(-from + 1)位开始计数；当for小于0时，substr将报错。该参数仅在sql_compatibility参数的值为PG时生效。
plpgsql_dependency name="p1276918101287">开启此参数后，创建函数，存储过程，包支持未定义的对象。可以新建成功。可以在GS_DEPENDENCIES和GS_DEPENDENCIES_OBJ查询对应的依赖关系。
开启此参数后，创建PLSQL对象时，会主动维护依赖于该PLSQL对象的OID，不再需要用户手动更新。
注意: 1.在并发创建PLSQL对象时，如果需要维护的对象间存在竞争关系，可能会造成死锁。
2.在调用失效的PLSQL对象时，自动执行一个自治事务对PLSQL对象重编译，重编译有效时会修改pg_object表的valid字段为true，回滚调用PLSQL对象的事务不会回滚自治事务中的重编译语句，包括对pg_object表的valid字段的修改。
3.当修改对象在gs_dependencies和gs_dependencies_obj中存在时，不允许进行rename操作。
allow_orderby_undistinct_column SQL语法兼容B的情况下，开启此参数后，select语句支持order by后面的列不在distinct中。如: select distinct a from test order by b;
注意：该参数只支持distinct，不支持distinct on，且当 DOLPHIN 插件存在时不生效，转由 dolphin.sql_mode 参数控制。dolphin.sql_mode 未设置 sql_mode_full_group 选项时相当于打开此选项。
select_into_return_null 在B或PG兼容模式下，开启此参数后，存储过程语句SELECT select_expressions INTO [STRICT] target FROM ...
允许在不指定STRICT并且查询结果为空时给变量赋NULL值。
accept_empty_str name="p74891049203418">在A兼容模式下，关闭此参数后，openGauss处理空字符串时会当做NULL处理；反之则正常接受空字符串。例如： openGauss=# set behavior_compat_options='accept_empty_str';
openGauss=# select '' is null;
?column?
----------
f (1 row) openGauss=# set behavior_compat_options='';
openGauss=# select '' is null;
?column?
----------
t (1 row) proc_uncheck_default_param 此参数打开时，调用带有默认参数的函数，入参从左到右排入函数，且允许缺省默认参数个数个入参，如果存在非默认参数的入参缺失，则会用错位的默认值填充缺失参数；参数关闭时，调用函数报错。
convert_string_digit_to_numeric 控制是否将表中以字符串形式表示的numeric常量和数字类型作比较时统一都转换为numeric类型再进行比较。
openGauss=# create table test1(c1 int, c2 varchar);
openGauss=# insert into test1 values(2, '1.1');
openGauss=# set behavior_compat_options = '';
openGauss=# select * from test1 where c2 > 1;
ERROR:  invalid input syntax for type bigint: "1.1" openGauss=# set behavior_compat_options = 'convert_string_digit_to_numeric';
openGauss=# select * test1 from where c2 > 1;
c1 | c2
----+-----
2 | 1.1 (1 row) plsql_security_definer 开启此参数后，创建存储过程时默认为定义者权限。
skip_insert_gs_source 开启此参数后，创建PL/SQL对象时不再插入DBE_PLDEVELOPER.gs_source表中。
update_unusable_unique_index_on_iud 开启此参数后，在数据insert、update、delete时候会同时对unusable unique索引的数据也进行更新，非unique索引不受影响。此参数默认关闭，关闭后如果有重复数据inser或者update到unique index列，rebuild unique index的时候会失败。
prefer_parse_cursor_parentheses_as_expr 默认情况下openGauss只会把cursor(select xxx)和cursor(with xxx)两种场景的查询语句当成游标表达式执行，其他场景当成cursor function执行。如果开启此参数且系统中没注册cursor function，openGauss将所有的cursor()都当成表达式执行。比如cursor((select xxx))默认情况下会当成cursor function执行，打开其参数后将当成cursor表达式执行 update_global_index_on_partition_change 此参数关闭时，分区变更(比如drop、merge、split、truncate分区等操作)时不会对全局索引进行数据更新而是将全局索引设置为UNUSABLE状态。打开此开关时，在分区变更时自动对全局索引进行数据更新操作，因此也会导致执行DDL时间变长和阻塞其他DML并发执行。默认此开关为关闭状态。
float_as_numeric 在 A 兼容模式下，开启此选项后，FLOAT[(p)] 映射至 numeric，二进制精度 p 取值范围为 [1, 126]；未开启时取值范围为 [1, 53]。
name="p1973572931511">disable_record_type_in_dml name="zh-cn_topic_0282136579_zh-cn_topic_0237124754_row"><a name="zh-cn_topic_0282136579_zh-cn_topic_0237124754_row">禁止虚拟列插入配置项。开启此项后禁止在insert语句中使用record类型变量作为插入值。
name="zh-cn_topic_0282136579_zh-cn_topic_0237124754_row2028605318483"> create table t1(col1 varchar(10),col varchar(10));
create table t2(col1 varchar(10),col varchar(10));
set behavior_compat_options='disable_record_type_in_dml';
insert into t1 values('one','two');
declare cursor cur1 is select * from t1;
source cur1%rowtype:=('ten','wtu');
begin for source in cur1 loop raise notice '%',source;
insert into t2 values(source);
end loop;
end;
/ ERROR:  The record type variable cannot be used as an insertion value.
CONTEXT:  SQL statement "insert into t2 values(source)" PL/pgSQL function inline_code_block line 7 at SQL statement set behavior_compat_options='';
insert into t1 values('one','two');
declare cursor cur1 is select * from t1;
source cur1%rowtype:=('ten','wtu');
begin for source in cur1 loop raise notice '%',source;
insert into t2 values(source);
end loop;
end;
/ NOTICE:  (one,two) NOTICE:  (one,two) accept_float_str_as_int 是否允许float类型的字符串转成整型（int1，int2, int4, int8）类型。
openGauss=# create table t1(c1 int);
CREATE TABLE openGauss=# openGauss=# insert into t1 values ('1.5');
ERROR:  invalid input syntax for integer: "1.5" LINE 1: insert into t1 values ('1.5');
^ CONTEXT:  referenced column: c1 openGauss=# openGauss=# set behavior_compat_options ='accept_float_str_as_int';
SET openGauss=# insert into t1 values ('1.5');
INSERT 0 1 compatible_a_db_array 是否以更兼容A库的方式处理数组。启用后数组比较改为无序比较、删除arr[i]后，arr[i]仍然占位，访问它会获得NULL、支持delete(x,y)函数。
openGauss=# set behavior_compat_options='compatible_a_db_array';
SET openGauss=# CREATE OR REPLACE TYPE num_type IS TABLE OF NUMBER;
CREATE TYPE openGauss=# DECLARE TYPE my_table IS TABLE OF VARCHAR2(100);
set1 my_table := my_table('b', 'b', 'c');
set2 my_table := my_table('c', 'b', 'b');
BEGIN IF set1 = set2 THEN raise info '集合相等';
ELSE raise info'集合不相等';
END IF;
END;
/ INFO:  集合相等 openGauss=# DECLARE nt num_type := num_type(11, 22, 33, 44, 55, 66);
BEGIN nt.DELETE(1);
raise notice '%',nt(1);
raise notice '%',nt(2);
raise notice '%',nt(3);
raise notice '%',nt(4);
END;
/ NOTICE:  &lt;NULL&gt;
NOTICE:  22 NOTICE:  33 NOTICE:  44 sql_mode_full_group 此参数作用同dolphin.sql_mode的sql_mode_full_group，但是只对A库生效。

## plsql\_compile\_check\_options

**参数说明**： 数据库兼容性行为配置项，该参数的值由若干个配置项用逗号隔开构成。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 字符串

**默认值**： ""

>[!NOTE]说明
>
>- 当前只支持[表3 兼容性配置项](#table18793103274618)。
>- 配置多个兼容性配置项时，相邻配置项用逗号隔开，例如：set plsql\_compile\_check\_options='for\_loop,outparam';

**表 3**  兼容性配置项

兼容性配置项 兼容性行为控制 for_loop 控制存储过程中FOR_LOOP查询语句行为设置此项时，在FOR rec IN query LOOP语句中，若rec已经定义，不会复用已经定义的rec变量，而且重新建立一个新的变量。否则，会复用已经定义的rec变量，不会建立新的变量。(与proc_implicit_for_loop_variable相同，后续进行收编) outparam 可能存在多个同名但输出参数列表不同的重载参数，若开启改选项，将对out出参进行检查，out出参为常量时报错。

## disable_keyword_options

**参数说明**：数据库兼容性行为配置项，该参数的值由若干个配置项用逗号隔开构成。设置该参数的标识符将不会作为关键字使用。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串，支持设置以下关键字： interval。

**默认值**： ""

>[!NOTE]说明
>
>- 该参数打开后，作为关键字使用的部分功能会失效，请谨慎使用。
>- 当设置非关键字时，会有警告提示，设置的非关键字标识符将会被跳过。

## plpgsql.variable\_conflict

**参数说明**：设置同名的存储过程变量和表的列的使用优先级。

该参数属于USERSET类型参数，仅支持[表2](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t290c8f15953843db8d8e53d867cd893d)中对应设置方法3进行设置。

**取值范围**：字符串

- error表示遇到存储过程变量和表的列名同名则编译报错。
- use\_variable表示存储过程变量和表的列名同名则优先使用变量。
- use\_column表示存储过程变量和表的列名同名则优先使用列名。

**默认值**：error

## td\_compatible\_truncation

**参数说明**： 控制是否开启与Teradata数据库相应兼容的特征。该参数在用户连接上与TD兼容的数据库时，可以将参数设置成为on（即超长字符串自动截断功能启用），该功能启用后，在后续的insert语句中，对目标表中char和varchar类型的列插入超长字符串时，会按照目标表中相应列定义的最大长度对超长字符串进行自动截断。保证数据都能插入目标表中，而不是报错。

>[!NOTE]说明
>超长字符串自动截断功能不适用于insert语句包含外表的场景。如果向字符集为字节类型编码（SQL\_ASCII、LATIN1等）的数据库中插入多字节字符数据（如汉字等)，且字符数据跨越截断位置，这种情况下，按照字节长度自动截断，自动截断后会在尾部产生非预期结果。如果用户有对于截断结果正确性的要求，建议用户采用UTF8等能够按照字符截断的输入字符集作为数据库的编码集。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示启动超长字符串自动截断功能。
- off表示停止超长字符串自动截断功能。

**默认值**： off

## uppercase\_attribute\_name

**参数说明**：设置列名以大写形式返回给客户端。该参数仅限于ORA兼容模式和集中式环境下使用。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示开启列名以大写形式返回给客户端。
- off表示关闭列名以大写形式返回给客户端。

**默认值**：off

## lastval\_supported

**参数说明**： 在分布式模式中，该参数控制是否可以使用lastval函数；而在单机模式下，该参数控制nextval函数在并行查询中是否可以下推到并行算子。
事实上，无论是分布式中lastval的使用，还是单机模式下nextval是否下推到并行算子，都不是由该参数单独控制的。enable_beta_features在这两个行为的控制上也发挥着作用，因此在讨论该参数的作用时，前提都是enable_beta_features为off。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on：在分布式模式中，表示允许lastval函数的使用；在单机模式中，表示nextval函数不可以下推到并行算子。
- off：在分布式模式中，表示不允许lastval函数的使用；在单机模式中，表示nextval函数可以下推到并行算子。

**默认值**： off

## character\_set\_connection

**参数说明**： 在兼容B模式（sql\_compatibility = 'B'），并且GUC参数b\_format\_behavior\_compat\_options设置值包含enable\_multi\_charset的场景下，连接到数据库时自动设置、生效。用于设置字符串常量的默认字符集。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。仅在设置会话级时生效，设置数据库级和用户级不生效。

修改此参数会同时将GUC参数collation\_connection设置成该字符集的默认字符序。

**取值范围**： 字符串，详见[仅支持在B模式下使用的字符序](../sql_reference/character_set_and_collation.md#支持的字符序)

**默认值**： 当前数据库的字符集。

## collation\_connection

**参数说明**： 在兼容B模式（sql\_compatibility = 'B'），并且GUC参数b\_format\_behavior\_compat\_options设置值包含enable\_multi\_charset的场景下，连接到数据库时自动设置、生效。用于设置字符串常量的默认字符序。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。仅在设置会话级时生效，设置数据库级和用户级不生效。

修改此参数会同时将GUC参数character\_set\_connection设置成该字符序对应的字符集。

**取值范围**： 字符串

**默认值**： 当前数据库的字符集的默认字符序。

## foreign_key_checks

**参数说明**： 在MY数据库模式下是否开启insert，update，delete时检查数据是否满足外键约束的功能。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示MY数据库模式下在insert，update，delete时检查数据是否满足外键约束的功能。

- off表示MY数据库模式下在insert，update，delete时不检查数据是否满足外键约束的功能。

**默认值**： on。

## unique_checks

**参数说明**： 控制写入数据时是否检查非主键唯一约束。该参数仅在B兼容模式（sql_compatibility = 'B'）下生效。

主键约束始终执行唯一性检查，不受该参数影响。在非B兼容模式下，主键约束和非主键唯一约束均始终执行唯一性检查。

仅表所有者或系统管理员可以通过关闭该参数跳过非主键唯一约束检查，其他用户写入数据时仍会执行唯一性检查。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示写入数据时检查非主键唯一约束。

- off表示在B兼容模式下允许表所有者或系统管理员跳过非主键唯一约束检查，主键约束仍然执行唯一性检查。

**默认值**： on。

>[!NOTE]说明
>关闭该参数可能写入违反非主键唯一约束的数据。重新开启该参数不会自动校验或清理此前写入的重复数据。

## 附表：accept_empty_str开启后受影响函数

| 涉及SQL函数/功能                                | 功能                                                         |
| ----------------------------------------------- | ------------------------------------------------------------ |
| 空字符串常量                                    | 返回一个字符串常量的语法树节点。                             |
| lpad                                            | 通过填充字符串，把入参string填充为指定长度的字符串。（左填充） |
| rpad                                            | 通过填充字符串，把入参string填充为指定长度的字符串。（右填充） |
| btrim                                           | 从字符串string的两边删除指定模式的字符的最长的字符串。       |
| ltrim                                           | 从字符串string的开头删除指定模式的字符的最长的字符串。       |
| ltrim                                           | 从字符串string的开头删除空格的最长的字符串。                 |
| rtrim                                           | 从字符串string的结尾删除指定模式的字符的最长的字符串。       |
| rtrim                                           | 从字符串string的结尾删除空格的最长的字符串。                 |
| nlssort                                         | 以sort_method指定的排序方式返回字符串在该排序模式下的编码值，该编码值可用于排序，其决定了string在这种排序模式下的先后位置。 |
| translate                                       | 把在string中包含的任何匹配from中的字符转化为to中的字符，如果from比to长，删掉from中出现的额外的字符。 |
| repeat                                          | 将string重复number次。                                       |
| oidvectortypes                                  | 将一个由oid组成的向量（数组）转换为类型名的列表              |
| regexp_replace                                  | 替换匹配POSIX镇提供者表达式的子字符串                        |
| regexp_replace                                  | 替换匹配POSIX镇提供者表达式的子字符串，该版本默认大小写敏感，且只替换第一个匹配项。 |
| regexp_replace                                  | 替换匹配POSIX镇提供者表达式的子字符串，该版本可以添加一些对应的匹配、替换选项，详情见文档。 |
| regexp_split_to_table                           | 用POSIX正则表达式作为分隔符，分隔string。如果没有与pattern的匹配，该函数返回string。 |
| regexp_substr                                   | 用正则表达式抽取子串                                         |
| lpad                                            | lpad的向量化版本                                             |
| substr                                          | 返回字符串的子串（针对bytea）                                |
| substr                                          | 返回字符串的子串（针对bytea）                                |
| replace                                         | 对字符串string中出现的所有子字符串from替换为子字符串to       |
| split_part                                      | 根据delimiter分割string，返回生成的第field个字符串           |
| array_to_string                                 | 将数组转换为字符串，使用第一个text作为数组的新分隔符         |
| array_to_text_null                              | 将数组转换为字符串，使用第一个text作为数组的新分隔符，使用第二个text替换数组值为null的值 |
| concat
concat_ws group_concat_transfn | 连接两个字符串 以第一个参数作为分隔符，连接第二个以后的所有参数

用于聚集函数group_concat |
| left                                            | 返回前n个字符的子串                                          |
| right                                           | 返回后n个字符的子串                                          |
| substrb                                         | 提取指定位置、指定长度的子串                                 |
| substrb                                         | 提取指定位置开始到结尾的子串                                 |
| substr                                          | substr函数的codegen，是substr运行时生成特化代码用的。目前要使用需要满足一下三个条件：表为列存表，设置enable_codegen=on，设置codegen_cost_threshold=0 |
| rtrim                                           | rtrim函数的codegen，是rtrim运行时生成特化代码用的。目前要使用需要满足一下三个条件：表为列存表，设置enable_codegen=on，设置codegen_cost_threshold=0 |
| btrim                                           | btrim函数的codegen，是btrim运行时生成特化代码用的。目前要使用需要满足一下三个条件：表为列存表，设置enable_codegen=on，设置codegen_cost_threshold=0 |
| substr(列存版)                                  | 与substr相同，不过是列存版                                   |

## enable_custom_parser

该参数当前版本不支持。
