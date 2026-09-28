# PG\_STAT\_SUBSCRIPTION

获取订阅的详细同步信息。

**表 1**  PG\_STAT\_SUBSCRIPTION字段

subid oid 订阅的OID。
subname name 订阅的名称。
pid thread_id 后台apply线程的thread id。
received_lsn LSN 从发布端接收到的最近的lsn。
last_msg_send_time timestamp 最近发布端发送消息的时间。
last_msg_receipt_time timestamp 最新订阅端收到消息的时间。
latest_end_lsn LSN 最近一次收到保活消息时发布端的lsn。
latest_end_time timestamp 最近一次收到保活消息的时间。
