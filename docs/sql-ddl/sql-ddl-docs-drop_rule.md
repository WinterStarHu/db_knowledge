# DROP RULE

## 功能描述

删除一个重写规则。

## 语法格式

```
DROP RULE [ IF EXISTS ] name ON table_name [ CASCADE | RESTRICT ]
```

## 参数说明

- IF EXISTS

如果该规则不存在，会抛出一个NOTICE。

- name

要删除的现存规则名称。

- table\_name

该规则应用的表名。

- CASCADE

自动级联删除依赖于此规则的对象。

- RESTRICT

缺省情况下，如果有任何依赖对象，则拒绝删除此规则。

## 示例

```
--删除重写规则newrule
DROP RULE newrule ON mytable;
```
