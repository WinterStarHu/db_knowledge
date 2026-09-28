# 向表中插入数据

在创建一个表后，表中并没有数据，在使用这个表之前，需要向表中插入数据。本小节介绍如何使用[INSERT](../sql_reference/insert.md)命令插入一行或多行数据，及从指定表插入数据。如果有大量数据需要批量导入表中，请参考[导入数据](../database_om_guide/import_data.md)。

## 背景信息

服务端与客户端使用不同的字符集时，两者字符集中单个字符的长度也会不同，客户端输入的字符串会以服务端字符集的格式进行处理，所以产生的最终结果可能会与预期不一致。

**表 1**  客户端和服务端设置字符集的输出结果对比

操作过程 服务端和客户端编码一致 服务端和客户端编码不一致 存入和取出过程中没有对字符串进行操作 输出预期结果 输出预期结果（输入与显示的客户端编码必须一致）。
存入取出过程对字符串有做一定的操作（如字符串函数操作） 输出预期结果 根据对字符串具体操作可能产生非预期结果。
存入过程中对超长字符串有截断处理 输出预期结果 字符集中字符编码长度是否一致，如果不一致可能会产生非预期的结果。

上述字符串函数操作和自动截断产生的效果会有叠加效果，例如：在客户端与服务端字符集不一致的场景下，如果既有字符串操作，又有字符串截断，在字符串被处理完以后的情况下继续截断，这样也会产生非预期的效果。详细的示例请参见[表2](#zh-cn_topic_0237120300_zh-cn_topic_0059779039_t8b4da148118a4913925a053cd07ca3c0)。

>[!NOTE]说明
>数据库[DBCOMPATIBILITY](../sql_reference/create_database.md)设为兼容TD模式，且[td\_compatible\_truncation](../database_reference/platform_and_client_compatibility.md#zh-cn_topic_0283137001_zh-cn_topic_0237124738_zh-cn_topic_0059779195_sb8212ce57eb9432a972e390f77203b7c)参数设置为on的情况下，才会对超长字符串进行截断。

执行如下命令建立示例中需要使用的表table1、table2。

```
openGauss=# CREATE TABLE table1(id int, a char(6), b varchar(6),c varchar(6));
openGauss=# CREATE TABLE table2(id int, a char(20), b varchar(20),c varchar(20));
```

**表 2**  示例

服务端字符集 客户端字符集 是否启用自动截断 SQL_ASCII UTF8 openGauss=# INSERT INTO table1 VALUES(1,reverse('123ＡＡ78'),reverse('123ＡＡ78'),reverse('123ＡＡ78'));
id |a|b|c
----+------+------+------
1 | 87| 87| 87 字符串在服务端翻转后，并进行截断，由于服务端和客户端的字符集不一致，字符A在客户端由多个字节表示，结果产生异常。
SQL_ASCII UTF8 openGauss=# INSERT INTO table1 VALUES(2,reverse('123Ａ78'),reverse('123Ａ78'),reverse('123Ａ78'));
id |a|b|c
----+------+------+------
2 | 873| 873| 873 字符串翻转后，又进行了自动截断，所以产生了非预期的效果。
SQL_ASCII UTF8 openGauss=# INSERT INTO table1 VALUES(3,'87Ａ123','87Ａ123','87Ａ123');
id |   a   |   b   |   c
----+-------+-------+-------
3 | 87Ａ1 | 87Ａ1 | 87Ａ1 字符串类型的字段长度是客户端字符编码长度的整数倍，所以截断后产生结果正常。
SQL_ASCII UTF8 openGauss=# INSERT INTO table2 VALUES(1,reverse('123ＡＡ78'),reverse('123ＡＡ78'),reverse('123ＡＡ78'));
openGauss=# INSERT INTO table2 VALUES(2,reverse('123Ａ78'),reverse('123Ａ78'),reverse('123Ａ78'));
id |a|b|c
----+-------------------+--------+--------
1 | 87 321| 87 321 | 87 321 2 | 87321| 87321| 87321 与示例1类似，多字节字符翻转之后不再表示原来的字符。

## 操作步骤

向表中插入数据前，意味着表已创建成功。创建表的步骤请参考[创建和管理表](creating_tables.md)。

- 向表customer\_t1中插入一行：

数据值是按照这些字段在表中出现的顺序列出的，并且用逗号分隔。通常数据值是文本（常量），但也允许使用标量表达式。

    ```
    INSERT INTO customer_t1(c_customer_sk, c_customer_id, c_first_name) VALUES (3769, 'hello', 'Grace');
    ```

如果用户已经知道表中字段的顺序，也可无需列出表中的字段。例如以下命令与上面的命令效果相同。

    ```
    INSERT INTO customer_t1 VALUES (3769, 'hello', 'Grace');
    ```

如果用户不知道所有字段的数值，可以忽略其中的一些。没有数值的字段将被填充为字段的缺省值。例如：

    ```
    openGauss=# INSERT INTO customer_t1 (c_customer_sk, c_first_name) VALUES (3769, 'Grace');

    openGauss=# INSERT INTO customer_t1 VALUES (3769, 'hello');
    ```

用户也可以对独立的字段或者整个行明确缺省值：

    ```
    openGauss=# INSERT INTO customer_t1 (c_customer_sk, c_customer_id, c_first_name) VALUES (3769, 'hello', DEFAULT);

    openGauss=# INSERT INTO customer_t1 DEFAULT VALUES;
    ```

- 如果需要在表中插入多行，请使用以下命令：

    ```
    INSERT INTO customer_t1 (c_customer_sk, c_customer_id, c_first_name) VALUES
        (6885, 'maps', 'Joes'),
        (4321, 'tpcds', 'Lily'),
        (9527, 'world', 'James');
    ```

如果需要向表中插入多条数据，除此命令外，也可以多次执行插入一行数据命令实现。但是建议使用此命令可以提升效率。

- 如果从指定表插入数据到当前表，例如在数据库中创建了一个表customer\_t1的备份表customer\_t2，现在需要将表customer\_t1中的数据插入到表customer\_t2中，则可以执行如下命令。

    ```
    openGauss=# CREATE TABLE customer_t2
    (
        c_customer_sk             integer,
        c_customer_id             char(5),
        c_first_name              char(6),
        c_last_name               char(8)
    );

    openGauss=# INSERT INTO customer_t2 SELECT * FROM customer_t1;
    ```

>[!NOTE]说明
>从指定表插入数据到当前表时，若指定表与当前表对应的字段数据类型之间不存在隐式转换，则这两种数据类型必须相同。

- 删除备份表。

    ```
    DROP TABLE customer_t2 CASCADE;
    ```

>[!NOTE]说明
>在删除表的时候，若当前需删除的表与其他表有依赖关系，需先删除关联的表，然后再删除当前表。
