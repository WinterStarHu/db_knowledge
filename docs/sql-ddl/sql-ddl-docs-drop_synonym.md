# DROP SYNONYM

## 功能描述

删除指定的SYNONYM对象。

## 注意事项

SYNONYM的所有者或者被授予了DROP ANY SEQUENCE权限的用户有权限执行DROP SYNONYM命令，系统管理员默认拥有此权限。

只有被授予了DROP PUBLIC SYNONYM权限的用户才能删除PUBLIC SYNONYM。

## 语法格式

```
DROP [ PUBLIC ] SYNONYM [ IF EXISTS ] synonym_name [ CASCADE | RESTRICT ];
```

## 参数描述

- **PUBLIC**

删除公共同义词。如果不指定PUBLIC，则删除私有同义词。

- **IF EXISTS**

如果指定的同义词不存在，则发出一个notice而不是抛出一个错误。

- **synonym\_name**

同义词名字，可以带模式名。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖同义词的对象（比如视图）。
  - RESTRICT：如果有依赖对象存在，则拒绝删除同义词。此选项为缺省值。

## 示例

请参考CREATE SYNONYM的[示例](create_synonym.md#zh-cn_topic_0283136599_zh-cn_topic_0237122116_section1853433744413)。

## 相关链接

[ALTER SYNONYM](alter_synonym.md)，[CREATE SYNONYM](create_synonym.md)
