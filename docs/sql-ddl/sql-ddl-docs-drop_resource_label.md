# DROP RESOURCE LABEL

## 功能描述

删除资源标签。

## 注意事项

只有poladmin、sysadmin或初始用户才能执行此操作。

## 语法格式

```
DROP RESOURCE LABEL [IF EXISTS] policy_name[, ...]*;
```

## 参数说明

**label\_name**

资源标签名称；

取值范围：字符串，要符合标识符的命名规范。

## 示例

```
--删除一个资源标签。
openGauss=# DROP RESOURCE LABEL IF EXISTS res_label1;

--删除一组资源标签。
openGauss=# DROP RESOURCE LABEL IF EXISTS res_label1, res_label2, res_label3;
```

## 相关链接

[ALTER RESOURCE LABEL](alter_resource_label.md)，[CREATE RESOURCE LABEL](create_resource_label.md)
