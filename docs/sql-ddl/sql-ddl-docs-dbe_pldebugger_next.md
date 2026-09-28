# DBE\_PLDEBUGGER.next

执行存储过程中当前的sql，返回执行的下一条的行数和对应query。

**表 1**  next返回值列表

funcoid OUT oid 函数id。
funcname OUT text 函数名。
lineno OUT integer 当前调试运行的下一行行号。
query OUT text 当前调试的下一行函数源码。
