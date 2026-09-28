# 数据类型及转换

## 数据类型

数据类型是一组值的集合以及定义在这个值集上的一组操作。openGauss数据库是由表的集合组成的，而各表中的列定义了该表，每一列都属于一种数据类型，openGauss根据数据类型有相应函数对其内容进行操作，例如openGauss可对数值型数据进行加、减、乘、除操作。

## 数据类型转换

数据库中允许有些数据类型进行隐式类型转换（赋值、函数调用的参数等），有些数据类型间不允许进行隐式数据类型转换，可尝试使用openGauss提供的类型转换函数，例如CAST进行数据类型强转。

openGauss数据库常见的隐式类型转换，请参见[表1](#zh-cn_topic_0237122212_zh-cn_topic_0059778807_tbc67231ae8bc4ca484efaebd2629a0e4)。

>[!TIP]须知
>openGauss支持的DATE的有效范围是：公元前4713年到公元294276年。

**表 1**  隐式类型转换表

原始数据类型 目标数据类型 CHAR VARCHAR2 CHAR NUMBER 原数据必须由数字组成。
CHAR DATE 原数据不能超出合法日期范围。
CHAR RAW CHAR CLOB VARCHAR2 CHAR VARCHAR2 NUMBER 原数据必须由数字组成。
VARCHAR2 DATE 原数据不能超出合法日期范围。
VARCHAR2 CLOB NUMBER CHAR NUMBER VARCHAR2 DATE CHAR DATE VARCHAR2 RAW CHAR RAW VARCHAR2 CLOB CHAR CLOB VARCHAR2 CLOB NUMBER 原数据必须由数字组成。
INT4 CHAR INT4 BOOLEAN INT4 CHAR BOOLEAN INT4
