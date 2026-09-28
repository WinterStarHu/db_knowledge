# DBE\_PLDEBUGGER.finish

执行存储过程中当前的SQL直到下一个断点触发或执行到上层栈的下一行。

**表 1**  finish入参和返回值列表

funcoid OUT oid 函数id。
funcname OUT text 函数名。
lineno OUT integer 当前调试运行的下一行行号。
query OUT text 当前调试的下一行函数源码。
