# DROP ACCESS METHOD

## 功能描述

移除一种现有的访问方法。只有超级用户能够删除访问方法。。

## 注意事项

不允许移除系统内置的访问方法。

## 语法格式

```
DROP ACCESS METHOD [ IF EXISTS ] name [ CASCADE | RESTRICT ];
```

## 参数说明

- **IF EXISTS**

如果指定的访问方法不存在，则发出一个notice而不是抛出一个错误。

- **name**

要移除的访问方法的名称。

取值范围：已存在，且非系统内置的访问方法。

- **CASCADE | RESTRICT**
  - CASCADE：表示允许级联删除依赖于该访问方法的对象。
  - RESTRICT（缺省值）：表示有依赖与此访问方法的对象存在，则该访问方法无法被删除。

## 示例

```

--删除访问方法ivfflat。
DROP ACCESS METHOD ivfflat;
```

## 相关链接

[CREATE ACCESS METHOD](create_access_method.md)
