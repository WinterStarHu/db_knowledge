# DROP LANGUAGE

## 功能描述

删除一个过程语言。单机和集中式暂不支持删除过程语言。

## 语法格式

```
DROP [ PROCEDURAL ] LANGUAGE [ IF EXISTS ] name [ CASCADE | RESTRICT ]
```

## 参数说明

- **IF EXISTS**

如果指定的过程语言不存在，那么发出一个 notice 而不是抛出一个错误。

- **name**

现存语言的名称。出于向下兼容的考虑，这个名字可以用单引号包围。

- **CASCADE**

级联删除依赖于该语言的对象（比如该语言写的函数）。

- **RESTRICT**

如果存在依赖对象，则拒绝删除。这个是缺省。

## 示例

下面命令删除plsample语言：

```
DROP LANGUAGE plsample;
```

## 兼容性

SQL标准里没有DROP LANGUAGE语句。
