# REASSIGN OWNED

## 功能描述

修改数据库对象的属主。

REASSIGN OWNED要求系统将当前数据库中old_role拥有的所有数据库对象的属主更改为new_role。

## 注意事项

- REASSIGN OWNED常用于在删除角色之前的准备工作。
- 执行REASSIGN OWNED需要有原角色和目标角色上的权限。
- REASSIGN OWNED不会更改数据本身的所有权。
- REASSIGN OWNED不会更改TRIGGER对象的所有权。

## 语法格式

```
REASSIGN OWNED BY old_role [, ...] TO new_role;
```

## 参数说明

- **old\_role**

旧属主的角色名。

- **new\_role**

将要成为这些对象属主的新角色的名称。

## 示例

无。
