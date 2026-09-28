# ALTER GROUP

## 功能描述

修改一个用户组的属性。

## 注意事项

ALTER GROUP是ALTER ROLE的别名，非SQL标准语法，不推荐使用，建议用户直接使用ALTER ROLE替代。

## 语法格式

- 向用户组中添加用户。

    ```
    ALTER GROUP group_name
        ADD USER user_name [, ... ];
    ```

- 从用户组中删除用户。

    ```
    ALTER GROUP group_name
        DROP USER user_name [, ... ];
    ```

- 修改用户组的名称。

    ```
    ALTER GROUP group_name
        RENAME TO new_name;
    ```

## 参数说明

请参考ALTER ROLE的[参数说明](alter_role.md#zh-cn_topic_0283137195_zh-cn_topic_0237122068_zh-cn_topic_0059778744_s50961af6143d4aafaf8fa02febbbf331)。

## 示例

```
--向用户组中添加用户。
openGauss=# ALTER GROUP super_users ADD USER lche, jim;

--从用户组中删除用户。
openGauss=# ALTER GROUP super_users DROP USER jim;

--修改用户组的名称。
openGauss=# ALTER GROUP super_users RENAME TO normal_users;
```

## 相关链接

[ALTER GROUP](alter_group.md)，[DROP GROUP](drop_group.md)，[ALTER ROLE](alter_role.md)
