# NOTIFY

## 功能描述

向某一通道发出特定消息。发出消息后，所有已通过LISTEN语句注册侦听该通道、且与执行NOTIFY语句的会话连接到同一数据库的会话都将收到这一消息。

## 注意事项

- NOTIFY语句发出的消息在事务提交后才会真正发出，因此如果有会话在执行NOTIFY语句后、事务提交前成功注册成为通道的侦听者，那么这一会话也会收到NOTIFY语句发出的消息。

- 暂不支持在启用线程池功能时执行该语句。

- NOTIFY语句产生的消息发出后，如果有任意正在侦听通道的会话未查看消息（即便该会话侦听的通道与堆积的消息所属的通道不同），将会造成消息堆积。允许堆积的消息量由可配置参数[max\_notify\_queue\_pages](../database_reference/disk_space.md#max_notify_queue_pages)控制，堆积的消息量超过配置的一半时将发出警告，此时可根据警告中提示的PID找到对应的未查看消息时间最长的会话，通过执行任意SQL触发该会话或结束该会话减少消息堆积。

## 语法格式

```
NOTIFY channel [ , 'payload' ];
```

## 参数说明

- **channel**

指定发布消息的通道的名称。命名需符合[标识符命名规范](keywords.md)。

- **payload**

指定携带的具体消息内容。

取值范围：空字符串或长度不超过8000（不包括8000）的非空字符串。

## 示例

```sql
openGauss=# LISTEN ch1;
LISTEN
openGauss=# SELECT pg_listening_channels();
 pg_listening_channels
-----------------------
 ch1
(1 row)

openGauss=# NOTIFY ch1;
NOTIFY
Asynchronous notification "ch1" received from server process with PID 1412740224.
openGauss=# NOTIFY ch1, 'message1';
NOTIFY
Asynchronous notification "ch1" with payload "message1" received from server process with PID 1412740224.
openGauss=# UNLISTEN ch1;
UNLISTEN
openGauss=# SELECT pg_listening_channels();
 pg_listening_channels
-----------------------
(0 rows)

```

## 相关链接

[LISTEN](listen.md)

[UNLISTEN](unlisten.md)
