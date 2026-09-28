# ALTER LANGUAGE

## 功能描述

修改一个过程语言的定义。单机和集中式暂不支持修改过程语言。

## 语法格式

```
ALTER [ PROCEDURAL ] LANGUAGE name RENAME TO new_name ALTER [ PROCEDURAL ] LANGUAGE name OWNER TO new_owner
```

## 参数说明

- **name**

语言的名字。

- **new\_name**

语言的新名字。

- **new\_owner**

语言的新的所有者。

## 兼容性

SQL标准里没有ALTER LANGUAGE语句。
