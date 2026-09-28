# `GS_TXN_SNAPSHOT`

`GS_TXN_SNAPSHOT` 是“时间戳-CSN”映射表，周期性采样，并维护适当的时间范围，用于估算范围内的时间戳对应的CSN值。

示例：

```sql
openGauss=# select * from gs_txn_snapshot;
 snptime | snpxmin | snpcsn | snpsnapshot
---------+---------+--------+-------------
```

**表 1** `GS_TXN_SNAPSHOT` 字段

snptime timestamp with time zone 快照捕获时间。
snpxmin bigint 快照xmin。
snpcsn bigint 快照csn。
snpsnapshot text 快照序列化文本。
