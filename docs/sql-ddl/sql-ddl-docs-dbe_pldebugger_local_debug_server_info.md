# DBE\_PLDEBUGGER.local\_debug\_server\_info

用于查找当前连接中已经turn\_on的存储过程oid。便于用户确认在调试哪些存储过程，需要通过funcoid和pg\_proc配合使用。

**表 1**  local\_debug\_server\_info 返回值列表

nodename OUT text 节点名称。
port OUT bigint 端口号。
funcoid OUT oid 存储过程oid。
