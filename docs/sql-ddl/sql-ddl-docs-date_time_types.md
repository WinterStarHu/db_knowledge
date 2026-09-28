# 日期/时间类型

openGauss支持的日期/时间类型请参见[表1](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_zh-cn_topic_0059779229_zh-cn_topic_0058965827_table60826369)。该类型的操作符和内置函数请参见[时间和日期处理函数和操作符](date_and_time_processing_functions_and_operators.md)。

>[!NOTE]说明
>如果其他的数据库时间格式和openGauss的时间格式不一致，可通过修改配置参数DateStyle的值来保持一致。

**表 1**  日期/时间类型

存储空间 DATE 日期和时间。
4字节（兼容模式A下存储空间大小为8字节） TIME [(p)] [WITHOUT TIME ZONE] 只用于一日内时间。
p表示小数点后的精度，取值范围为0~6。
8字节 TIME [(p)] [WITH TIME ZONE] 只用于一日内时间，带时区。
p表示小数点后的精度，取值范围为0~6。
12字节 TIMESTAMP[(p)] [WITHOUT TIME ZONE] 日期和时间。
p表示小数点后的精度，取值范围为0~6。
8字节 TIMESTAMP[(p)][WITH TIME ZONE] 日期和时间，带时区。TIMESTAMP的别名为TIMESTAMPTZ。
p表示小数点后的精度，取值范围为0~6。
8字节 SMALLDATETIME 日期和时间，不带时区。
精确到分钟，秒位大于等于30秒进一位。
8字节 INTERVAL DAY (l) TO SECOND (p) 时间间隔，X天X小时X分X秒。
l：天数的精度，取值范围为0~6。兼容性考虑，目前未实现具体功能。p：秒数的精度，取值范围为0~6。小数末尾的零不显示。
16字节 INTERVAL [FIELDS] [ (p) ] 时间间隔。
fields：可以是YEAR、MONTH、DAY、HOUR、MINUTE、SECOND、DAY TO HOUR、DAY TO MINUTE、DAY TO SECOND、HOUR TO MINUTE、HOUR TO SECOND、MINUTE TO SECOND。
p：秒数的精度，取值范围为0~6，且fields为SECOND、DAY TO SECOND、HOUR TO SECOND或MINUTE TO SECOND时，参数p才有效。小数末尾的零不显示。
12字节 reltime 相对时间间隔。格式为： X years X mons X days XX:XX:XX。
采用儒略历计时，规定一年为365.25天，一个月为30天，计算输入值对应的相对时间间隔，输出采用POSTGRES格式。
4字节 abstime 日期和时间。格式为： YYYY-MM-DD hh:mm:ss+timezone 取值范围为1901-12-13 20:45:53 GMT~2038-01-18 23:59:59 GMT，精度为秒。
4字节

示例：

```
--创建表。
openGauss=# CREATE TABLE date_type_tab(coll date);

--插入数据。
openGauss=# INSERT INTO date_type_tab VALUES (date '12-10-2010');

--查看数据。
openGauss=# SELECT * FROM date_type_tab;
        coll
---------------------
 2010-12-10 00:00:00
(1 row)

--删除表。
openGauss=# DROP TABLE date_type_tab;

--创建表。
openGauss=# CREATE TABLE time_type_tab (da time without time zone ,dai time with time zone,dfgh timestamp without time zone,dfga timestamp with time zone, vbg smalldatetime);

--插入数据。
openGauss=# INSERT INTO time_type_tab VALUES ('21:21:21','21:21:21 pst','2010-12-12','2013-12-11 pst','2003-04-12 04:05:06');

--查看数据。
openGauss=# SELECT * FROM time_type_tab;
    da    |     dai     |        dfgh         |          dfga          |         vbg
----------+-------------+---------------------+------------------------+---------------------
 21:21:21 | 21:21:21-08 | 2010-12-12 00:00:00 | 2013-12-11 16:00:00+08 | 2003-04-12 04:05:00
(1 row)

--删除表。
openGauss=# DROP TABLE time_type_tab;

--创建表。
openGauss=# CREATE TABLE day_type_tab (a int,b INTERVAL DAY(3) TO SECOND (4));

--插入数据。
openGauss=# INSERT INTO day_type_tab VALUES (1, INTERVAL '3' DAY);

--查看数据。
openGauss=# SELECT * FROM day_type_tab;
 a |   b
---+--------
 1 | 3 days
(1 row)

--删除表。
openGauss=# DROP TABLE day_type_tab;

--创建表。
openGauss=# CREATE TABLE year_type_tab(a int, b interval year (6));

--插入数据。
openGauss=# INSERT INTO year_type_tab VALUES(1,interval '2' year);

--查看数据。
openGauss=# SELECT * FROM year_type_tab;
 a |    b
---+---------
 1 | 2 years
(1 row)

--删除表。
openGauss=# DROP TABLE year_type_tab;
```

## 日期输入

日期和时间的输入几乎可以是任何合理的格式，包括ISO-8601格式、SQL-兼容格式、传统POSTGRES格式或者其它的形式。系统支持按照日、月、年的顺序自定义日期输入。如果把DateStyle参数设置为MDY就按照“月-日-年”解析，设置为DMY就按照“日-月-年”解析，设置为YMD就按照“年-月-日”解析。

日期的文本输入需要加单引号包围，语法如下：

type \[ \( p \) \] 'value'

可选的精度声明中的p是一个整数，表示在秒域中小数部分的位数。[表2](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_zh-cn_topic_0059779229_t0606b0d8bec74d34a6440ef1de8d1e67)显示了date类型的输入方式。

>[!NOTE]说明
>合法的日期分隔符是“-”和“/”，混用日期分隔符（“-”和“/”也不能混用）可能导致解析错误。

**表 2**  日期输入方式

1999-01-08 ISO 8601格式（建议格式），任何方式下都是1999年1月8号。
January 8, 1999 在任何datestyle输入模式下都无歧义。
1/8/1999 有歧义，在MDY模式下是一月八号，在DMY模式下是八月一号。
1/18/1999 MDY模式下是一月十八日，其它模式下被拒绝。
01/02/03 MDY模式下的2003年1月2日。DMY模式下的2003年2月1日。YMD模式下的2001年2月3日。
1999-Jan-08 任何模式下都是1月8日。
Jan-08-1999 任何模式下都是1月8日。
08-Jan-1999 任何模式下都是1月8日。
99-Jan-08 YMD模式下是1月8日，否则错误。
08-Jan-99 一月八日，除了在YMD模式下是错误的之外。
Jan-08-99 一月八日，除了在YMD模式下是错误的之外。
19990108 ISO 8601；任何模式下都是1999年1月8日。
990108 ISO 8601；任何模式下都是1999年1月8日。
1999.008
年和年里的第几天。
J2451187 儒略日。
January 8, 99 BC 公元前99年。

示例：

```
--创建表。
openGauss=# CREATE TABLE date_type_tab(coll date);

--插入数据。
openGauss=# INSERT INTO date_type_tab VALUES (date '12-10-2010');

--查看数据。
openGauss=# SELECT * FROM date_type_tab;
        coll
---------------------
 2010-12-10 00:00:00
(1 row)

--查看日期格式。
openGauss=# SHOW datestyle;
 DateStyle
-----------
 ISO, MDY
(1 row)

--设置日期格式。
openGauss=# SET datestyle='YMD';
SET

--插入数据。
openGauss=# INSERT INTO date_type_tab VALUES(date '2010-12-11');

--查看数据。
openGauss=# SELECT * FROM date_type_tab;
        coll
---------------------
 2010-12-10 00:00:00
 2010-12-11 00:00:00
(2 rows)

--删除表。
openGauss=# DROP TABLE date_type_tab;
```

## 时间

时间类型包括time \[ \(p\) \] without time zone和time \[ \(p\) \] with time zone。如果只写time等效于time without time zone。

如果在time without time zone类型的输入中声明了时区，则会忽略这个时区。

时间输入类型的详细信息请参见[表3](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_zh-cn_topic_0059779229_tc5d1089552ca4fb2a9f5ba27767a26b6)，时区输入类型的详细信息请参加[表4](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_zh-cn_topic_0059779229_te78a582bdc984cd3b5ecac5502f7793e)。

**表 3**  时间输入

05:06.8 ISO 8601 4:05:06 ISO 8601 4:05 ISO 8601 040506 ISO 8601 4:05 AM 与04:05一样，AM不影响数值 4:05 PM 与16:05一样，输入小时数必须&lt;= 12 04:05:06.789-8 ISO 8601 04:05:06-08:00 ISO 8601 04:05-08:00 ISO 8601 040506-08 ISO 8601 04:05:06 PST 缩写的时区 2003-04-12 04:05:06 America/New_York 用名称声明的时区

**表 4**  时区输入

PST 太平洋标准时间（Pacific Standard Time） America/New_York 完整时区名称 -8:00 ISO 8601与PST的偏移 -800 ISO 8601与PST的偏移 ISO 8601与PST的偏移

示例：

```
openGauss=# SELECT time '04:05:06';
   time
----------
 04:05:06
(1 row)

openGauss=# SELECT time '04:05:06 PST';
   time
----------
 04:05:06
(1 row)

openGauss=# SELECT time with time zone '04:05:06 PST';
   timetz
-------------
 04:05:06-08
(1 row)
```

## 特殊值

openGauss支持几个特殊值，在读取的时候将被转换成普通的日期/时间值，请参考[表5](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_zh-cn_topic_0059779229_t8366745d681748c28d5a76843c7f0d4b)。

**表 5**  特殊值

输入字符串 适用类型 epoch date、timestamp 1970-01-01 00:00:00+00 （Unix系统零时） infinity timestamp 比任何其他时间戳都晚 -infinity timestamp 比任何其他时间戳都早 now date、time、timestamp 当前事务的开始时间 today date、timestamp 今日午夜 tomorrow date、timestamp 明日午夜 yesterday date、timestamp 昨日午夜 allballs time 00:00:00.00 UTC

```
--创建表。
openGauss=# CREATE TABLE realtime_type_special(col1 varchar(20), col2 date, col3 timestamp, col4 time);

--插入数据。
openGauss=# INSERT INTO realtime_type_special VALUES('epoch', 'epoch', 'epoch', NULL);
openGauss=# INSERT INTO realtime_type_special VALUES('infinity', NULL, 'epoch', NULL);
openGauss=# INSERT INTO realtime_type_special VALUES('now', 'now', 'now', 'now');
openGauss=# INSERT INTO realtime_type_special VALUES('today', 'today', 'today', NULL);
openGauss=# INSERT INTO realtime_type_special VALUES('tomorrow', 'tomorrow', 'tomorrow', NULL);
openGauss=# INSERT INTO realtime_type_special VALUES('yesterday', 'yesterday', 'yesterday', NULL);

--查看数据
openGauss=# SELECT * FROM realtime_type_special;
   col1    |        col2         |            col3            |      col4
-----------+---------------------+----------------------------+-----------------
 epoch     | 1970-01-01 00:00:00 | 1970-01-01 00:00:00        |
 now       | 2023-02-27 11:38:13 | 2023-02-27 11:38:13.032815 | 11:38:13.032815
 today     | 2023-02-27 00:00:00 | 2023-02-27 00:00:00        |
 tomorrow  | 2023-02-28 00:00:00 | 2023-02-28 00:00:00        |
 yesterday | 2023-02-26 00:00:00 | 2023-02-26 00:00:00        |
(5 rows)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 < 'infinity';
   col1    |        col2         |            col3            |      col4
-----------+---------------------+----------------------------+-----------------
 epoch     | 1970-01-01 00:00:00 | 1970-01-01 00:00:00        |
 now       | 2023-02-27 11:38:13 | 2023-02-27 11:38:13.032815 | 11:38:13.032815
 today     | 2023-02-27 00:00:00 | 2023-02-27 00:00:00        |
 tomorrow  | 2023-02-28 00:00:00 | 2023-02-28 00:00:00        |
 yesterday | 2023-02-26 00:00:00 | 2023-02-26 00:00:00        |
(5 rows)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 > '-infinity';
   col1    |        col2         |            col3            |      col4
-----------+---------------------+----------------------------+-----------------
 epoch     | 1970-01-01 00:00:00 | 1970-01-01 00:00:00        |
 now       | 2023-02-27 11:38:13 | 2023-02-27 11:38:13.032815 | 11:38:13.032815
 today     | 2023-02-27 00:00:00 | 2023-02-27 00:00:00        |
 tomorrow  | 2023-02-28 00:00:00 | 2023-02-28 00:00:00        |
 yesterday | 2023-02-26 00:00:00 | 2023-02-26 00:00:00        |
(5 rows)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 > 'now';
   col1   |        col2         |        col3         | col4
----------+---------------------+---------------------+------
 tomorrow | 2023-02-28 00:00:00 | 2023-02-28 00:00:00 |
(1 row)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 = 'today';
 col1  |        col2         |        col3         | col4
-------+---------------------+---------------------+------
 today | 2023-02-27 00:00:00 | 2023-02-27 00:00:00 |
(1 row)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 = 'tomorrow';
   col1   |        col2         |        col3         | col4
----------+---------------------+---------------------+------
 tomorrow | 2023-02-28 00:00:00 | 2023-02-28 00:00:00 |
(1 row)

openGauss=# SELECT * FROM realtime_type_special WHERE col3 > 'yesterday';
   col1   |        col2         |            col3            |      col4
----------+---------------------+----------------------------+-----------------
 now      | 2023-02-27 11:38:13 | 2023-02-27 11:38:13.032815 | 11:38:13.032815
 today    | 2023-02-27 00:00:00 | 2023-02-27 00:00:00        |
 tomorrow | 2023-02-28 00:00:00 | 2023-02-28 00:00:00        |
(3 rows)

openGauss=# SELECT TIME 'allballs';
   time
----------
 00:00:00
(1 row)

--删除表。
openGauss=# DROP TABLE realtime_type_special;
```

## 时间段输入

reltime的输入方式可以采用任何合法的时间段文本格式，包括数字形式（含负数和小数）及时间形式，其中时间形式的输入支持SQL标准格式、ISO-8601格式、POSTGRES格式等。另外，文本输入需要加单引号。

时间段输入的详细信息请参考[表6](#zh-cn_topic_0283136973_zh-cn_topic_0237121952_table1747116463276)。

**表 6**  时间段输入

输入示例 输出结果 2 mons 采用数字表示时间段，默认单位是day，可以是小数或负数。特别的，负数时间段，在语义上，可以理解为“早于多久”。
31.25
1 mons 1 days 06:00:00 -365 -12 mons -5 days 1 years 1 mons 8 days 12:00:00 1 years  1 mons 8 days 12:00:00 采用POSTGRES格式表示时间段，可以正负混用，不区分大小写，输出结果为将输入时间段计算并转换得到的简化POSTGRES格式时间段。
-13 months -10 hours -1 years -25 days -04:00:00 -2 YEARS +5 MONTHS 10 DAYS -1 years -6 mons -25 days -06:00:00 P-1.1Y10M -3 mons -5 days -06:00:00 采用ISO-8601格式表示时间段，可以正负混用，不区分大小写，输出结果为将输入时间段计算并转换得到的简化POSTGRES格式时间段。
-12H -12:00:00

示例：

```
--创建表。
openGauss=# CREATE TABLE reltime_type_tab(col1 character(30), col2 reltime);

--插入数据。
openGauss=# INSERT INTO reltime_type_tab VALUES ('90', '90');
openGauss=# INSERT INTO reltime_type_tab VALUES ('-366', '-366');
openGauss=# INSERT INTO reltime_type_tab VALUES ('1975.25', '1975.25');
openGauss=# INSERT INTO reltime_type_tab VALUES ('-2 YEARS +5 MONTHS 10 DAYS', '-2 YEARS +5 MONTHS 10 DAYS');
openGauss=# INSERT INTO reltime_type_tab VALUES ('30 DAYS 12:00:00', '30 DAYS 12:00:00');
openGauss=# INSERT INTO reltime_type_tab VALUES ('P-1.1Y10M', 'P-1.1Y10M');

--查看数据。
openGauss=# SELECT * FROM reltime_type_tab;
              col1              |                col2
--------------------------------+-------------------------------------
 1975.25                        | 5 years 4 mons 29 days
 -2 YEARS +5 MONTHS 10 DAYS     | -1 years -6 mons -25 days -06:00:00
 P-1.1Y10M                      | -3 mons -5 days -06:00:00
 -366                           | -1 years -18:00:00
 90                             | 3 mons
 30 DAYS 12:00:00               | 1 mon 12:00:00
(6 rows)

--删除表。
openGauss=# DROP TABLE reltime_type_tab;
```
