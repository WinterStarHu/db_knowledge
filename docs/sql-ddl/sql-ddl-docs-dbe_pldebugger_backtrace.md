# DBE\_PLDEBUGGER.backtrace

debug端调试过程中，调用backtrace，查看当前的调用堆栈。

**表 1**  backtrace返回值列表

frameno OUT integer 调用栈编号。
funcname OUT oid 函数名。
lineno OUT integer 行号。
query OUT text 断点内容。
funcoid OUT oid 函数oid。
