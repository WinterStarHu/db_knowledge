# DROP TYPE

## 功能描述

删除一个用户定义的数据类型。

## 注意事项

类型的所有者或者被授予了类型DROP权限的用户或者被授予了DROP ANY TYPE权限的用户有权限执行DROP TYPE命令，系统管理员默认拥有此权限。

用户定义类型支持以部分关键词（甚至包括内建类型名）作为类型名，但删除时需要指定其所属的 schema。
比如 schema 为 `public` 的默认场景下，用户可使用 `DROP TYPE public.;` 等语句删除这些以关键词命名的用户定义类型。

## 语法格式

```
DROP TYPE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ]
```

## 参数说明

- **IF EXISTS**

如果指定的类型不存在，那么发出一个notice而不是抛出一个错误。

- **name**

要删除的类型名\(可以有模式修饰\)。

- **CASCADE**

级联删除依赖该类型的对象\(比如字段、函数、操作符等\)。

**RESTRICT**

如果有依赖对象，则拒绝删除该类型（缺省行为）。

## 示例

请参考CREATE TYPE的[示例](create_type.md#zh-cn_topic_0283136568_zh-cn_topic_0237122124_zh-cn_topic_0059779377_s66a0b4a6a1df4ba4a116c6c565a0fe9d)。

## 相关链接

[CREATE TYPE](create_type.md)，[ALTER TYPE](alter_type.md)
