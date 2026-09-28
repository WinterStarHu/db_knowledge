# DROP RESOURCE POOL

## 功能描述

删除一个资源池。

>[!NOTE]说明
>如果某个角色已关联到该资源池，无法删除。

## 注意事项

只有SYSADMIN、VCADMIN可以删除资源池。

## 语法格式

```
DROP RESOURCE POOL [ IF EXISTS ] pool_name;
```

## 参数说明

- **IF EXISTS**

如果指定的资源池不存在，发出一个notice而不是抛出一个错误。

- **pool\_name**

已创建过的资源池名称。

取值范围：字符串，要符合标识符的命名规范。

## 示例

请参见CREATE RESOURCE POOL的[示例](create_resource_pool.md#zh-cn_topic_0059777569_s44181f6d005b4da1952aaeff4ef66e0e)。

## 相关链接

[ALTER RESOURCE POOL](alter_resource_pool.md)，[CREATE RESOURCE POOL](create_resource_pool.md)
