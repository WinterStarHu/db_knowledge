# ALTER RESOURCE LABEL

## 功能描述

修改资源标签。

## 注意事项

只有poladmin、 sysadmin或初始用户才能执行此操作。

## 语法格式

```
ALTER RESOURCE LABEL label_name (ADD|REMOVE)
  label_item_list[, ...]*;
```

- label\_item\_list：

    ```
    resource_type(resource_path[, ...]*)
    ```

- resource\_type：

    ```
    TABLE | COLUMN | SCHEMA | VIEW | FUNCTION
    ```

## 参数说明

- **label\_name**

资源标签名称。

取值范围：字符串，要符合标识符的命名规范。

- **resource\_type**

指的是要标记的数据库资源类型。

- **resource\_path**

指的是描述具体的数据库资源的路径。

## 示例

```
--创建基本表table_for_label。
openGauss=# CREATE TABLE table_for_label(col1 int, col2 text);

--创建资源标签table_label。
openGauss=# CREATE RESOURCE LABEL table_label ADD COLUMN(table_for_label.col1);

--将col2添加至资源标签table_label中
openGauss=# ALTER RESOURCE LABEL table_label ADD COLUMN(table_for_label.col2);

--将资源标签table_label中的一项移除
openGauss=# ALTER RESOURCE LABEL table_label REMOVE COLUMN(table_for_label.col1);
```

## 相关链接

[CREATE RESOURCE LABEL](create_resource_label.md)，[DROP RESOURCE LABEL](drop_resource_label.md)。
