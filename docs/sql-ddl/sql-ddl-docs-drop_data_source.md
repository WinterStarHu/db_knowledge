# DROP DATA SOURCE

## 功能描述

删除一个Data Source对象。

## 注意事项

只有属主/系统管理员/初始用户才可以删除一个Data Source对象。

## 语法格式

```
DROP DATA SOURCE [IF EXISTS] src_name [CASCADE | RESTRICT];
```

## 参数说明

- **src\_name**

待删除的Data Source对象名称。

取值范围：字符串，符合标识符命名规范。

- **IF EXISTS**

如果指定的Data Source不存在，则发出一个notice而不是报错。

- **CASCADE | RESTRICT**
  - **CASCADE**：表示允许级联删除依赖于Data Source的对象。
  - **RESTRICT**（缺省值）：表示有依赖于该Data Source的对象存在，则该Data Source无法删除。

目前Data Source对象没有被依赖的对象，CASCADE和RESTRICT效果一样，保留此选项是为了向后兼容性。

## 示例

```
--创建Data Source对象。
openGauss=# CREATE DATA SOURCE ds_tst1;

--删除Data Source对象。
openGauss=# DROP DATA SOURCE ds_tst1 CASCADE;
openGauss=# DROP DATA SOURCE IF EXISTS ds_tst1 RESTRICT;
```

## 相关链接

[CREATE DATA SOURCE](create_data_source.md)，[ALTER DATA SOURCE](alter_data_source.md)
