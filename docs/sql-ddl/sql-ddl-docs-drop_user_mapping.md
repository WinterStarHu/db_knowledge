# DROP USER MAPPING

## 功能描述

移除一个用于外部服务器的用户映射。

## 语法格式

```
DROP USER MAPPING [ IF EXISTS ] FOR { user_name | USER | CURRENT_USER | PUBLIC } SERVER server_name;
```

## 参数描述

- **IF EXISTS**

如果该用户映射不存在则不要抛出一个错误，而是发出一个提示。

- **user\_name**

该映射的用户名。

CURRENT\_USER和USER匹配当前用户的名称。PUBLIC被用来匹配系统中所有现存和未来的用户名。

- **server\_name**

用户映射的服务器名。

## 相关链接

[ALTER USER MAPPING](alter_user_mapping.md)，[CREATE USER MAPPING](create_user_mapping.md)
