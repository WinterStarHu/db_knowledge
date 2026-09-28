# 字符类型

openGauss支持的字符类型请参见[表1](#zh-cn_topic_0283136755_zh-cn_topic_0237121950_zh-cn_topic_0059777889_zh-cn_topic_0058966269_table29186418)。字符串操作符和相关的内置函数请参见[字符处理函数和操作符](character_processing_functions_and_operators.md)。

**表 1**  字符类型

存储空间 CHAR(n [BYTE|CHAR]) CHARACTER(n [BYTE|CHAR]) NCHAR(n [BYTE|CHAR]) 定长字符串，不足补空格。默认是BYTE语义，n是字节长度，如指定CHAR语义，n是字符长度，如不带精度n，默认精度为1。
最大为10MB。
VARCHAR(n [BYTE|CHAR]) CHARACTER VARYING(n [BYTE|CHAR]) 变长字符串。默认是BYTE语义，PG兼容模式下，n是字符长度。其他兼容模式下，n是指字节长度，如指定CHAR语义，n是字符长度。
最大为10MB。
VARCHAR2(n [BYTE|CHAR]) 变长字符串。是VARCHAR(n)类型的别名。默认是BYTE语义，n是字节长度，如指定CHAR语义，n是字符长度。
最大为10MB。
NVARCHAR2(n) 变长字符串。n是指字符长度。
最大为10MB。
NVARCHAR(n) 变长字符串。是NVARCHAR2(n)类型的别名。n是指字符长度。
最大为10MB。
TEXT 变长字符串。
最大为1GB-1，但还需要考虑到列描述头信息的大小， 以及列所在元组的大小限制（也小于1GB-1），因此TEXT类型最大大小可能小于1GB-1。
CLOB 文本大对象。是TEXT类型的别名。
最大为1GB-1，但还需要考虑到列描述头信息的大小， 以及列所在元组的大小限制（也小于1GB-1），因此CLOB类型最大大小可能小于1GB-1。

>[!NOTE]说明
>
>1. 除了每列的大小限制以外，每个元组的总大小也不可超过1GB-1字节，主要受列的控制头信息、元组控制头信息以及元组中是否存在NULL字段等影响。
>2. NCHAR为bpchar类型的别名，NCHAR(n)为bpchar(n)类型的别名。
>3. 当不指定字符串长度语义时默认是BYTE语义，可使用GUC参数nls_length_semantics设置长度的默认语义

在openGauss里另外还有两种定长字符类型。在[表2](#zh-cn_topic_0283136755_zh-cn_topic_0237121950_zh-cn_topic_0059777889_tf74658686f5e4d979adf0ac04769ea16)里显示。name类型只用在内部系统表中，作为存储标识符，不建议普通用户使用。该类型长度当前定为64字节（63可用字符加结束符）。类型“char”只用了一个字节的存储空间。他在系统内部主要用于系统表，主要作为简单化的枚举类型使用。

**表 2**  特殊字符类型

存储空间 name 用于对象名的内部类型。
64字节。
"char" 单字节内部类型。
1字节。

## 示例

```
--创建表。
openGauss=# CREATE TABLE char_type_t1
(
    CT_COL1 CHARACTER(4)
);

--插入数据。
openGauss=# INSERT INTO char_type_t1 VALUES ('ok');

--查询表中的数据。
openGauss=# SELECT ct_col1, char_length(ct_col1) FROM char_type_t1;
 ct_col1 | char_length
---------+-------------
 ok      |           4
(1 row)

--删除表。
openGauss=# DROP TABLE char_type_t1;

--创建表。
openGauss=# CREATE TABLE char_type_t2
(
    CT_COL1 VARCHAR(5)
);

--插入数据。
openGauss=# INSERT INTO char_type_t2 VALUES ('ok');

openGauss=# INSERT INTO char_type_t2 VALUES ('good');

--插入的数据长度超过类型规定的长度报错。
openGauss=# INSERT INTO char_type_t2 VALUES ('too long');
ERROR:  value too long for type character varying(5)
CONTEXT:  referenced column: ct_col1

--明确类型的长度，超过数据类型长度后会自动截断。
openGauss=# INSERT INTO char_type_t2 VALUES ('too long'::varchar(5));

--查询数据。
openGauss=# SELECT ct_col1, char_length(ct_col1) FROM char_type_t2;
 ct_col1 | char_length
---------+-------------
 ok      |           2
 good    |           4
 too l   |           5
(3 rows)

--删除数据。
openGauss=# DROP TABLE char_type_t2;
```
