# DBE\_PLDEBUGGER.turn\_off

用于去掉turn\_on添加的调试标记，返回值表示成功或失败。可通过DBE\_PLDEBUGGER.local\_debug\_server\_info查找已经turn\_on的存储过程oid。

函数原型为：

```
DBE_PLDEBUGGER.turn_off(Oid)
RETURN boolean;
```

**表 1**  turn\_off 入参和返回值列表

func_oid IN oid 函数oid。
turn_off OUT boolean turn off是否成功。
