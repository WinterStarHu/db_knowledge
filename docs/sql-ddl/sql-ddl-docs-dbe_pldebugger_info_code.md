# DBE\_PLDEBUGGER.info\_code

debug端调试过程中，调用info\_code，查看指定存储过程的源语句和各行对应的行号，行号从函数体开始，函数头部分行号为空。

**表 1**  info\_code入参和返回值列表

funcoid IN oid 函数ID。
lineno OUT integer 行号。
query OUT text 源语句。
canbreak OUT bool 当前行是否支持断点。
