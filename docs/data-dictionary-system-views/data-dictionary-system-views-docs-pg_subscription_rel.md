# PG\_SUBSCRIPTION\_REL

系统表PG\_SUBSCRIPTION\_REL包含每个订阅中每个被复制表的状态，是多对多的映射关系。

该系统表仅包含运行[CREATE SUBSCRIPTION](../sql_reference/create_subscription.md)或[ALTER SUBSCRIPTION ... REFRESH PUBLICATION](../sql_reference/alter_subscription.md)后对订阅已知的表。

**表 1**  PG\_SUBSCRIPTION\_REL字段

srsubid oid 订阅标识符。
srrelid oid 订阅关系标识符。
srsubstate char 订阅状态。i：初始化d：基础数据正在复制f：基础数据复制完成s：已与增量复制进度同步r：准备好增量复制 srcsn int8 基础数据复制过程中快照csn。
srsublsn text 在s或r状态中，用于同步增量复制进度的远端LSN，否则为空。
