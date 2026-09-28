# DBE\_PLDEBUGGER.add\_breakpoint

debug端调试过程中，调用add\_breakpoint增加新的断点。如果返回-1则说明指定的断点不合法，请参考[DBE\_PLDEBUGGER.info\_code](dbe_pldebugger_info_code.md)的canbreak字段确定断点合适的位置。

**表 1**  add\_breakpoint入参和返回值列表

funcoid IN text 函数ID。
lineno IN integer 行号。
breakpointno OUT integer 断点编号。
