# DBE\_PLDEBUGGER.info\_breakpoints

debug端调试过程中，调用info\_breakpoints，查看当前的函数断点。

**表 1**  info\_breakpoints返回值列表

breakpointno OUT integer 断点编号。
funcoid OUT oid 函数ID。
lineno OUT integer 行号。
query OUT text 断点内容。
enable OUT boolean 是否有效
