# DROP CAST

## 功能描述

删除一个类型转换。

## 注意事项

DROP CAST删除一个先前定义过的类型转换。

要能删除一个类型转换，你必须拥有源或者目的数据类型。这是和创建一个类型转换相同的权限。

## 语法格式

```
DROP CAST [ IF EXISTS ] (source_type AS target_type) [ CASCADE | RESTRICT ]
```

## 参数说明

- **IF EXISTS**

如果指定的转换不存在，那么发出一个 notice 而不是抛出一个错误。

- **source\_type**

类型转换里的源数据类型。

- **target\_type**

类型转换里的目标数据类型。

- **CASCADE**

**RESTRICT**

这些键字没有任何效果，因为在类型转换上没有依赖关系。

## 示例

删除从text到int的转换：

```
DROP CAST (text AS int);
```

## 兼容性

DROP CAST遵循 SQL 标准。
