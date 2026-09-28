# DROP COLUMN ENCRYPTION KEY

## 功能描述

删除一个列加密密钥（CEK）。

## 注意事项

只有列加密密钥所有者或者被授予了DROP权限的用户有权限执行命令，系统管理员默认拥有此权限。

## 语法格式

```
DROP COLUMN ENCRYPTION KEY [ IF EXISTS ] column_encryption_key_name [CASCADE];
```

## 参数说明

- **IF EXISTS**

如果指定的列加密密钥不存在，则发出一个notice而不是抛出一个错误。

- **column\_encryption\_key\_name**

要删除的列加密密钥名称。

取值范围：字符串，已存在的列加密密钥名称。

## 示例

```
--删除列加密密钥。
openGauss=# DROP COLUMN ENCRYPTION KEY ImgCEK CASCADE;
ERROR:  cannot drop column setting: imgcek cascadely because encrypted column depend on it.
HINT:  we have to drop encrypted column: name, ... before drop column setting: imgcek cascadely.
```
