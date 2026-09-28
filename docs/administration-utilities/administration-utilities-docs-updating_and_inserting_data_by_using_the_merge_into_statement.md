# 使用合并方式更新和插入数据

在用户需要将一个表中所有的数据或大量的数据添加至现有表的场景下，openGauss提供了MERGE INTO语句通过两个表合并的方式高效地将新数据添加到现有表。

MERGE INTO语句将目标表和源表中数据针对关联条件进行匹配，若关联条件匹配时对目标表进行UPDATE，关联条件不匹配时对目标表执行INSERT。此方法可以很方便地用来将两个表合并执行UPDATE和INSERT，避免多次执行。

## 前提条件

进行MERGE  INTO操作的用户需要同时拥有目标表的UPDATE和INSERT权限，以及源表的SELECT权限。

## 操作步骤

1. 创建源表products，并插入数据。

    ```
    openGauss=# CREATE TABLE products
    ( product_id INTEGER,
      product_name VARCHAR2(60),
      category VARCHAR2(60)
    );

    openGauss=# INSERT INTO products VALUES
    (1502, 'olympus camera', 'electrncs'),
    (1601, 'lamaze', 'toys'),
    (1666, 'harry potter', 'toys'),
    (1700, 'wait interface', 'books');
    ```

2. 创建目标表newproducts，并插入数据。

    ```
    openGauss=# CREATE TABLE newproducts
    ( product_id INTEGER,
      product_name VARCHAR2(60),
      category VARCHAR2(60)
    );

    openGauss=# INSERT INTO newproducts VALUES
    (1501, 'vivitar 35mm', 'electrncs'),
    (1502, 'olympus ', 'electrncs'),
    (1600, 'play gym', 'toys'),
    (1601, 'lamaze', 'toys'),
    (1666, 'harry potter', 'dvd');
    ```

3. 使用MERGE INTO 语句将源表products的数据合并至目标表newproducts。

    ```
    MERGE INTO newproducts np
    USING products p
    ON (np.product_id = p.product_id )
    WHEN MATCHED THEN
      UPDATE SET np.product_name = p.product_name, np.category = p.category
    WHEN NOT MATCHED THEN
      INSERT VALUES (p.product_id, p.product_name, p.category) ;
    ```

上述语句中使用的参数说明，请见[表1](#zh-cn_topic_0237121140_zh-cn_topic_0165787112_table1973914406416)。更多信息，请参见[MERGE INTO](../sql_reference/merge_into.md)。

**表 1**  MERGE INTO语句参数说明

INTO 子句 指定需要更新或插入数据的目标表。
目标表支持指定别名。
取值：newproducts np 说明：名为newproducts，别名为np的目标表。
USING子句 指定源表。源表支持指定别名。
取值：products p 说明：名为products，别名为p的源表。
ON子句 指定目标表和源表的关联条件。
关联条件中的字段不支持更新。
取值：np.product_id = p.product_id 说明：指定的关联条件为，目标表newproducts的product_id字段和源表products的product_id字段相等。
WHEN MATCHED子句 当源表和目标表中数据针对关联条件可以匹配上时，选择WHEN MATCHED子句进行UPDATE操作。
仅支持指定一个WHEN MATCHED子句。WHEN MATCHED子句可缺省，缺省时，对于满足ON子句条件的行，不进行任何操作。若目标表中存在分布列，则该列不支持更新。
取值：WHEN MATCHED THEN    UPDATE SET np.product_name = p.product_name,  np.category = p.category 说明：当满足ON子句条件时，将目标表newproducts的product_name、category字段的值替换为源表products相对应字段的值。
WHEN NOT MATCHED子句 当源表和目标表中数据针对关联条件无法匹配时，选择WHEN NOT  MATCHED子句进行INSERT操作。
仅支持指定一个WHEN NOT MATCHED子句。WHEN NOT MATCHED子句可缺省。不支持INSERT子句中包含多个VALUES。
WHEN MATCHED和WHEN NOT  MATCHED子句顺序可以交换，可以缺省其中一个，但不能同时缺省。
取值：WHEN NOT MATCHED THEN INSERT VALUES (p.product_id, p.product_name, p.category) 说明：将源表products中，不满足ON子句条件的行插入目标表newproducts。

4. 查询合并后的目标表newproducts。

    ```
    SELECT * FROM newproducts;
    ```

返回信息如下：

    ```
     product_id |  product_name  | category
    ------------+----------------+-----------
           1501 | vivitar 35mm   | electrncs
           1502 | olympus camera | electrncs
           1666 | harry potter   | toys
           1600 | play gym       | toys
           1601 | lamaze         | toys
           1700 | wait interface | books
    (6 rows)
    ```
