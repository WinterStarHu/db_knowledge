# DROP OWNED

## 功能描述

删除一个数据库角色所拥有的数据库对象。

## 注意事项

- 所有该角色在当前数据库里和共享对象（数据库、表空间）上的所有对象上的权限都将被撤销。
- DROP OWNED常常被用来为移除一个或者多个角色做准备。因为DROP OWNED只影响当前数据库中的对象，通常需要在包含将被移除角色所拥有的对象的每一个数据库中都执行这个命令。
- 使用CASCADE选项可能导致这个命令递归去删除由其他用户所拥有的对象。
- 角色所拥有的数据库、表空间将不会被移除。

## 语法格式

```
DROP OWNED BY name [, ...] [ CASCADE | RESTRICT ];
```

## 参数说明

- **name**

角色名。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除所有依赖于被删除对象的对象。
  - RESTRICT（缺省值）：拒绝删除那些有任何依赖对象存在的对象。

## 相关链接

[REASSIGN OWNED](reassign_owned.md)  ,  [DROP ROLE](drop_role.md)
