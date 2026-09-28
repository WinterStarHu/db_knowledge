# SHOW EVENTS

## 功能描述

显示指定schema下所有定时任务的基本信息。

## 注意事项

定时任务相关操作只有sql\_compatibility = 'B'时支持。

## 语法格式

```
SHOW EVENTS
    [{FROM | IN} schema_name]
    [LIKE 'pattern' | WHERE condition]
```

## 参数说明

- \{FROM | IN\}

指定要查询的schema，默认情况下为当前schema。

- LIKE

LIKE可以模式匹配定时任务名称，不指定则打印当前schema下所有定时任务

- WHERE

WHERE子句构成一个行选择表达式，用来缩小SHOW EVENTS查询的范围。condition是返回值为布尔型的任意表达式，任何不满足该条件的行都不会被检索。

## 示例

```
--查看event_a schema下的通过模式匹配'_e'查询出的所有定时任务的信息
openGauss=# SHOW EVENTS IN event_a LIKE '_e';
```
