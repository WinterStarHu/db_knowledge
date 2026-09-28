# 布尔类型

**表 1**  布尔类型

存储空间 BOOLEAN 布尔类型 1字节。
true：真false：假null：未知（unknown）

- “真”值的有效文本值是：

`TRUE`、`'t'`、`'true'`、`'y'`、`'yes'`、`'1'`、`'TRUE'`、`true`、任意非零数值类型。

- “假”值的有效文本值是：

`FALSE`、`'f'`、`'false'`、`'n'`、`'no'`、`'0'`、`0`、`'FALSE'`、`false`。

当文本值为数值类型时，实际会发生隐式类型转换。
比如文本值 `123456.1223` 会先被解析为 `numeric` 再转换为 `bool` 类型。

使用 `TRUE` 和 `FALSE` 是比较规范的用法（也是 SQL 兼容的用法）。

## 示例

显示用字母t和f输出Boolean值。

```
--创建表。
openGauss=# CREATE TABLE bool_type_t1
(
    BT_COL1 BOOLEAN,
    BT_COL2 TEXT
);

--插入数据。
openGauss=# INSERT INTO bool_type_t1 VALUES (TRUE, 'sic est');

openGauss=# INSERT INTO bool_type_t1 VALUES (FALSE, 'non est');

--查看数据。
openGauss=# SELECT * FROM bool_type_t1;
 bt_col1 | bt_col2
---------+---------
 t       | sic est
 f       | non est
(2 rows)

openGauss=# SELECT * FROM bool_type_t1 WHERE bt_col1 = 't';
 bt_col1 | bt_col2
---------+---------
 t       | sic est
(1 row)

--删除表。
openGauss=# DROP TABLE bool_type_t1;
```
