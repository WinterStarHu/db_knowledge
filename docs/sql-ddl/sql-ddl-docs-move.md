# MOVE

## 功能描述

MOVE在不检索数据的情况下重新定位一个游标。MOVE的作用类似于[FETCH](fetch.md)命令，但只是重定位游标而不返回行。

## 注意事项

无。

## 语法格式

```
MOVE [ direction [ FROM | IN ] ] cursor_name;
```

其中direction子句为可选参数。

```
NEXT
   | PRIOR
   | FIRST
   | LAST
   | ABSOLUTE count
   | RELATIVE count
   | count
   | ALL
   | FORWARD
   | FORWARD count
   | FORWARD ALL
   | BACKWARD
   | BACKWARD count
   | BACKWARD ALL
```

## 参数说明

MOVE命令的参数与FETCH的相同，详细请参见FETCH的[参数说明](fetch.md#zh-cn_topic_0283137321_zh-cn_topic_0237122165_zh-cn_topic_0059778422_sceb763c430654064b8f61e9aa0792af9)。

>[!NOTE]说明
>成功完成时，MOVE命令将返回一个“MOVE count”的标签，count是一个使用相同参数的FETCH命令会返回的行数（可能为零）。

## 示例

```
--开始一个事务。
openGauss=# START TRANSACTION;

--定义一个名为cursor1的游标。
openGauss=# CURSOR cursor1 FOR SELECT * FROM tpcds.reason;

--忽略游标cursor1的前3行。
openGauss=# MOVE FORWARD 3 FROM cursor1;

--抓取游标cursor1的前4行。
openGauss=# FETCH 4 FROM cursor1;
 r_reason_sk |   r_reason_id    |                                            r_reason_desc
-------------+------------------+------------------------------------------------------------------------------------------------------
           4 | AAAAAAAAEAAAAAAA | Not the product that was ordred
           5 | AAAAAAAAFAAAAAAA | Parts missing
           6 | AAAAAAAAGAAAAAAA | Does not work with a product that I have
           7 | AAAAAAAAHAAAAAAA | pngt exchange
(4 rows)

--关闭游标。
openGauss=# CLOSE cursor1;

--结束一个事务。
openGauss=# END;
```

## 相关链接

[CLOSE](close.md)，[FETCH](fetch.md)
