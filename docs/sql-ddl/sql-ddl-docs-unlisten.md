# UNLISTEN

## 功能描述

取消对特定通道的侦听。

## 注意事项

- 事务提交后UNLISTEN语句才真正执行，但含UNLISTEN语句、且最终提交成功的事务自事务开始后收到的消息都不会再显示到会话前台。

- 暂不支持在启用线程池功能时执行该语句。

## 语法格式

```
UNLISTEN { channel | * };
```

## 参数说明

- **channel**

指定取消侦听的通道的名称。命名需符合[标识符命名规范](keywords.md)。使用通配符\*表示取消对所有通道的侦听。

## 示例

参见NOTIFY的[示例](notify.md)

## 相关链接

[NOTIFY](notify.md)

[LISTEN](listen.md)
