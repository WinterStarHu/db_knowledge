# SNAPSHOT

## 功能描述

针对多用户情况下，对数据进行统一的版本控制。

## 注意事项

- 本特性GUC参数db4ai\_snapshot\_mode，快照存储模型分为MSS和CSS两种；GUC参数db4ai\_snapshot\_version\_delimiter，用于设定版本分隔符，仅接受设定单字节参数值，默认为“@”;GUC参数db4ai\_snapshot\_version\_separator，用于设定子版本分隔符，仅接受设定单字节参数值，默认为“.”。
- 当快照选用增量存储方式时，各个快照中具有依赖关系。删除快照需要按照依赖顺序进行删除。
- snapshot特性用于团队不同成员间维护数据，涉及管理员和普通用户之间的数据转写。所以在私有用户、三权分立\(enableSeparationOfDuty=ON\)等状态下，数据库不支持snapshot功能特性。
- 当需要稳定可用的快照用于AI训练等任务时，用户需要将快照发布。

## 语法格式

1. 创建快照。

可以采用“CREATE SNAPSHOT … AS”以及“CREATE SNAPSHOT … FROM”语句创建**数据表快照**。

  - CREATE SNAPSHOT AS

        ```
        CREATE SNAPSHOT  [@ ]
            [COMMENT IS }
            AS query;
        ```

  - CREATE SNAPSHOT FROM

        ```
        CREATE SNAPSHOT  [@ ]
            FROM @
            [COMMENT IS }
                USING (
                { INSERT [INTO SNAPSHOT] …
                  | UPDATE [SNAPSHOT] [AS ] SET … [FROM …] [WHERE …]
                  | DELETE [FROM SNAPSHOT] [AS ] [USING …] [WHERE …]
                  | ALTER [SNAPSHOT] { ADD … | DROP … } [, …]
              } [; …]
            );
        ```

2. 删除快照。

PURGE SNAPSHOT

    ```
    PURGE SNAPSHOT  @ ;
    ```

3. 快照采样。

SAMPLE SNAPSHOT

    ```
    SAMPLE SNAPSHOT  @
        [STRATIFY BY attr_list]
        { AS  AT RATIO  [COMMENT IS ] } [, …]
    ```

4. 快照发布。

PUBLISH SNAPSHOT

    ```
    PUBLISH SNAPSHOT  @ ;
    ```

5. 快照存档。

ARCHIVE SNAPSHOT

    ```
    ARCHIVE SNAPSHOT  @ ;
    ```

## 参数说明

- qualified\_name

创建snapshot的名称。

取值范围：字符串，需要符合标识符命名规则。

- version

\(可省略\)snapshot的版本号，当省略设置。系统会自动顺延编号。

取值范围：字符串，数字编号配合分隔符。

- alias

对当前对象取的别名。

取值范围：字符串，需要符合标识符命名规则。
- attr_list

目标对象的list集合。

取值范围：字符串，需要符合标识符命名规则。

- num

指定的比例值。

取值范围：数字。

## 示例

```
create snapshot s1@1.0 comment is 'first version' as select * from t1;
```

```
create snapshot s1@3.0 from @1.0 comment is 'inherits from @1.0' using (INSERT VALUES(6, 'john'), (7, 'tim'); DELETE WHERE id = 1);
```

```
SELECT * FROM s1@1.0;
```

```
purge snapshot s1@1.0;
```

```
sample snapshot s1@2.0 stratify by name as nick at ratio .5;
```

```
publish snapshot s1@2.0;
```

```
archive snapshot s1@2.0;
```

## 相关链接

无。
