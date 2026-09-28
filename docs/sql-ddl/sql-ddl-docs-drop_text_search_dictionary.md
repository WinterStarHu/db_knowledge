# DROP TEXT SEARCH DICTIONARY

## 功能描述

删除全文检索词典。

## 注意事项

- 预定义词典不支持DROP操作。
- 只有词典的所有者可以执行DROP操作，系统管理员默认拥有此权限。
- 谨慎执行DROP...CASCADE操作，该操作将级联删除使用该词典的文本搜索配置（TEXT SEARCH CONFIGURATION）。

## 语法格式

```
DROP TEXT SEARCH DICTIONARY [ IF EXISTS ] name [ CASCADE | RESTRICT ]
```

## 参数说明

- **IF EXISTS**

如果指定的全文检索词典不存在，那么发出一个Notice而不是报错。

- **name**

要删除的词典名称（可指定模式名，否则默认在当前模式下）。

取值范围：已存在的词典名。

- **CASCADE**

自动删除依赖于该词典的对象，并依次删除依赖于这些对象的所有对象。

如果存在任何一个使用该词典的文本搜索配置，此DROP命令将不会成功。可添加CASCADE以删除引用该词典的所有文本搜索配置以及词典。

- **RESTRICT**

如果任何对象依赖词典，则拒绝删除该词典。这是缺省值。

## 示例

```
--删除词典english
openGauss=# DROP TEXT SEARCH DICTIONARY english;
```

## 相关链接

[ALTER TEXT SEARCH DICTIONARY](alter_text_search_dictionary.md)，[CREATE TEXT SEARCH DICTIONARY](create_text_search_dictionary.md)
