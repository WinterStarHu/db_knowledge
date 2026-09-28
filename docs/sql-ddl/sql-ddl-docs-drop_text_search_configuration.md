# DROP TEXT SEARCH CONFIGURATION

## 功能描述

删除已有文本搜索配置。

## 注意事项

要执行这个命令，用户必须是该配置的所有者。

## 语法格式

```
DROP TEXT SEARCH CONFIGURATION [ IF EXISTS ] name [ CASCADE | RESTRICT ];
```

## 参数说明

- **IF EXISTS**

如果指定的文本搜索配置不存在，那么发出一个notice而不是抛出一个错误。

- **name**

要删除的文本搜索配置名称（可有模式修饰）。

- **CASCADE**

级联删除依赖文本搜索配置的对象。

- **RESTRICT**

若有任何对象依赖文本搜索配置则拒绝删除它。这是默认情况。

## 示例

请参见CREATE TEXT SEARCH CONFIGURATION的[示例](create_text_search_configuration.md#zh-cn_topic_0283137399_zh-cn_topic_0237122121_zh-cn_topic_0059777835_sc3a4aef5c0c0420eaf5a2e67097004a2)。

## 相关链接

[ALTER TEXT SEARCH CONFIGURATION](alter_text_search_configuration.md)，  [CREATE TEXT SEARCH CONFIGURATION](create_text_search_configuration.md)
