# ALTER TRIGGER

## 功能描述

修改触发器名称、所有者及单个触发器的启用/禁用。

>[!NOTE]说明
>
>目前只支持修改名称、所有者及单个触发器的启用/禁用。

## 注意事项

- 触发器所在表的所有者或者被授予了ALTER ANY TRIGGER权限的用户可以执行ALTER TRIGGER操作，系统管理员默认拥有此权限。
- 若要修改触发器owner，当前用户必须是该触发器的所有者或者系统管理员，且当前用户必须是新owner所属角色的直接或者间接成员。新owner必须有触发器所在模式上的CREATE权限。`enableSeparationOfDuty = off`时，系统管理员默认拥有该权限。`enableSeparationOfDuty = on`时，系统管理员默认没有该权限。
- 只有初始用户才能修改触发器的owner为初始用户。

## 语法格式

- 修改触发器名称。

```
ALTER TRIGGER trigger_name ON table_name RENAME TO new_name;
```

- 修改触发器owner

```
ALTER TRIGGER trigger_name ON table_name OWNER TO new_owner;
```

- 启用/禁用单个触发器。

```
ALTER TRIGGER trigger_name ENABLE|DISABLE;
```

## 参数说明

- **trigger\_name**

要修改的触发器名称。

取值范围：已存在的触发器。

- **table\_name**

要修改的触发器所在的表名称。

取值范围：已存在的含触发器的表。

- **new\_name**

修改后的新名称。

取值范围：符合标识符命名规范的字符串，最大长度不超过63个字符，且不能与所在表上其他触发器同名。

- **new\_owner**

修改后的触发器新owner名称。

取值范围：数据库中存在的用户。

- **ENABLE|DISABLE**

ENABLE： 启用单个触发器。
DISABLE：禁用单个触发器。

## 示例

请参见[CREATE TRIGGER](create_trigger.md)的示例。

## 相关链接

[CREATE TRIGGER](create_trigger.md)，[DROP TRIGGER](drop_trigger.md)，[ALTER TABLE](alter_table.md)
