# SHOW

## 功能描述

SHOW将显示当前运行时参数的数值。

## 注意事项

无。

## 语法格式

```
SHOW
  {
    [VARIABLES LIKE] configuration_parameter |
    CURRENT_SCHEMA |
    TIME ZONE |
    TRANSACTION ISOLATION LEVEL |
    SESSION AUTHORIZATION |
    ALL
  };
```

## 参数说明

显示变量的参数请参见RESET的[参数说明](reset.md#zh-cn_topic_0283137385_zh-cn_topic_0237122178_zh-cn_topic_0059779097_s46998dbd2cc84394b47aad2adc8ea141)。

## 示例

```
--显示 timezone 参数值。
openGauss=# SHOW timezone;

--显示所有参数。
openGauss=# SHOW ALL;

--显示参数名中包含”var”的所有参数
openGauss=# SHOW VARIABLES LIKE var;
```

## 相关链接

[SET](set.md)，[RESET](reset.md)
