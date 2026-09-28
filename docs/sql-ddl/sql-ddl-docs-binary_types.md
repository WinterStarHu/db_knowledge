# 二进制类型

openGauss支持的二进制类型请参见[表1](#zh-cn_topic_0283136911_zh-cn_topic_0237121951_zh-cn_topic_0059778141_t910f42f45b374d94afe2798c42fc5ef6)。

**表 1**  二进制类型

存储空间 BLOB 二进制大对象。
最大为1GB-8203字节（即1073733621字节）。
LONG RAW 二进制大对象。
与其他数据库不同，它完全被映射为BLOB，所以最大为1GB-8203字节（即1073733621字节），在一张表中可以有多列为LONG RAW。
RAW 变长的十六进制类型。
4字节加上实际的十六进制字符串。最大为1GB-8203字节（即1073733621字节）。
BYTEA 变长的二进制字符串。
4字节加上实际的二进制字符串。最大为1GB-8203字节（即1073733621字节）。
BYTEAWITHOUTORDERWITHEQUALCOL 变长的二进制字符串（密态特性新增的类型，如果加密列的加密类型指定为确定性加密，则该列的实际类型为BYTEAWITHOUTORDERWITHEQUALCOL），元命令打印加密表将显示原始数据类型。
4字节加上实际的二进制字符串。最大为1GB减去53字节（即1073741771字节）。
BYTEAWITHOUTORDERCOL 变长的二进制字符串（密态特性新增的类型，如果加密列的加密类型指定为随机加密，则该列的实际类型为BYTEAWITHOUTORDERCOL），元命令打印加密表将显示原始数据类型。
4字节加上实际的二进制字符串。最大为1GB减去53字节（即1073741771字节）。
_BYTEAWITHOUTORDERWITHEQUALCOL 变长的二进制字符串，密态特性新增的类型。
4字节加上实际的二进制字符串。最大为1GB减去53字节（即1073741771字节）。
_BYTEAWITHOUTORDERCOL 变长的二进制字符串，密态特性新增的类型。
4字节加上实际的二进制字符串。最大为1GB减去53字节（即1073741771字节）。

>[!NOTE]说明
>
>- 除了每列的大小限制以外，每个元组的总大小也不可超过1GB-8203字节（即1073733621字节）。
>
>- 不支持直接使用BYTEAWITHOUTORDERWITHEQUALCOL、BYTEAWITHOUTORDERCOL、\_BYTEAWITHOUTORDERWITHEQUALCOL和\_BYTEAWITHOUTORDERCOL类型创建表。
>
>- 关于blob类型，a库写入blob类型数据需要调rawtohex()方法将其显式转为十六进制。比如查询blob数据值，sql应写为select rawtohex('1234')::blob；b库无需显式转，sql为select '1234'::blob。

示例:

```
--创建表。
openGauss=#  CREATE TABLE blob_type_t1
(
    BT_COL1 INTEGER,
    BT_COL2 BLOB,
    BT_COL3 RAW,
    BT_COL4 BYTEA
) ;

--插入数据。
openGauss=#  INSERT INTO blob_type_t1 VALUES(10,empty_blob(),
HEXTORAW('DEADBEEF'),E'\\xDEADBEEF');

--查询表中的数据。
openGauss=#  SELECT * FROM blob_type_t1;
 bt_col1 | bt_col2 | bt_col3  |  bt_col4
---------+---------+----------+------------
      10 |         | DEADBEEF | \xdeadbeef
(1 row)

--删除表。
openGauss=#  DROP TABLE blob_type_t1;
```
