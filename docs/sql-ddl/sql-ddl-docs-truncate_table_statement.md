# TRUNCATE TABLE语句

清理表数据，TRUNCATE TABLE用于删除表的数据，但不删除表结构。也可以用DROP TABLE删除表，但是这个命令会连表的结构一起删除，如果想插入数据，需要重新建立这张表。

它和在目标表上进行无条件的DELETE有同样的效果，但由于TRUNCATE不做表扫描，因而快得多。在大表上操作效果更明显。此外，TRUNCATE TABLE 可以立即释放表空间，而不需要后续 VACUUM 操作。

## 语法格式

```
TRUNCATE TABLE  table_name ;
```

## 参数说明

- **table\_name**

目标表的名称（可以有模式修饰）。

取值范围：已存在的表名。

## 示例

使用TRUNCATE TABLE 来清除customer\_t1表内数据。

```
openGauss=# TRUNCATE TABLE customer_t1;
TRUNCATE TABLE
```

查询表customer\_t1，结果如下。

```
openGauss=# SELECT * FROM customer_t1;
 c_customer_sk | c_customer_id | c_first_name | c_last_name | amount
---------------+---------------+--------------+-------------+--------
(0 rows)
```
