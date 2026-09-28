# DROP GLOBAL CONFIGURATION

## 功能描述

删除系统表gs\_global\_config中的参数值。

## 注意事项

- 仅支持数据库初始用户运行此命令。
- 不支持删除关键字为weak\_password。

## 语法格式

```
DROP GLOBAL CONFIGURATION 参数名称，参数名称...;
```

## 参数说明

参数名称是gs\_global\_config中已经存在的参数，删除不存在的参数将报错。
