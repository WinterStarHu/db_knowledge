# RESET

## 功能描述

RESET将指定的运行时参数恢复为缺省值。这些参数的缺省值是指postgresql.conf配置文件中所描述的参数缺省值。

RESET命令与如下命令的作用相同：

SET configuration\_parameter TO DEFAULT

## 注意事项

RESET的事务性行为和SET相同：它的影响将会被事务回滚撤销。

## 语法格式

```
RESET {configuration_parameter | CURRENT_SCHEMA | TIME ZONE | SESSION AUTHORIZATION | ALL };
```

## 参数说明

- **configuration\_parameter**

运行时参数的名称。

取值范围：可以使用SHOW ALL命令查看运行时参数。

- **CURRENT\_SCHEMA**

当前模式。

- **TIME ZONE**

时区。

- **SESSION AUTHORIZATION**

当前会话的用户标识符。

- **ALL**

所有运行时参数。

## 示例

```
--把timezone设为缺省值。
openGauss=# RESET timezone;

--把所有参数设置为缺省值。
openGauss=# RESET ALL;
```

## 相关链接

[SET](set.md)，[SHOW](show.md)
