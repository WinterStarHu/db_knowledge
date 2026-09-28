# DBE\_PLDEBUGGER.turn\_on

该函数用于标记某一存储过程为可调试，执行turn\_on后server端可以执行该存储过程来进行调试。需要用户根据系统表PG\_PROC手动获取存储过程oid，传入函数中。turn\_on后本session内执行该存储过程会停在第一条sql前等待debug端的调试操作。该设置会在session断连后默认被清理掉。目前不支持对启用自治事务的存储过程/函数进行调试。

函数原型为：

```
DBE_PLDEBUGGER.turn_on(Oid)
RETURN Record;
```

**表 1**  turn\_on 入参和返回值列表

func_oid IN oid 函数oid。
nodename OUT text 节点名称。
port OUT integer 连接端口号。
