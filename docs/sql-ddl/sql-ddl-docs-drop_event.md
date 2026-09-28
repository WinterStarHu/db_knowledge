# DROP EVENT

## 功能描述

删除一个定时任务。

## 注意事项

定时任务相关操作只有sql\_compatibility = 'B'时支持。
只有定时任务的所有者有权删除待修改的定时任务，用户通过DROP EVENT修改定时任务时需要拥有被指定schema的USAGE权限。系统管理员默认拥有删除所有定时任务的权限。

## 语法格式

```
DROP EVENT [IF EXISTS] event_name
```

## 参数说明

- IF EXISTS

如果定时任务不存在，会输出一个NOTICE。

## 示例

```
openGauss=# DROP EVENT event_e1;
```
