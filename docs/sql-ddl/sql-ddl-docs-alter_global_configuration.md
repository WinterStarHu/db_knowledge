# ALTER GLOBAL CONFIGURATION

## 功能描述

新增、修改系统表gs\_global\_config，增加key-value值。

## 注意事项

- 仅支持数据库初始用户运行此命令。
- 不支持创建修改关键字为weak\_password。

## 语法格式

```
ALTER GLOBAL CONFIGURATION with(paraname=value,paraname=value...);
```

## 参数说明

+ paraname

参数名称，text类型。

+ value

参数值，text类型。
