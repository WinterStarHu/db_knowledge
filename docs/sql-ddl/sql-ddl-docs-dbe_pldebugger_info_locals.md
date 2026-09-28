# DBE\_PLDEBUGGER.info\_locals

debug端调试过程中，调用info\_locals，打印当前存储过程内变量。该函数入参frameno表示查询遍历的栈层数，支持无入参调用，缺省为查看最上层栈变量。

**表 1**  info\_locals入参和返回值列表

frameno IN integer （可选） 指定的栈层数，缺省为最顶层 varname OUT text 变量名 vartype OUT text 变量类型 value OUT text 变量值 package_name OUT text 变量对应的package名，非package时为空 isconst OUT boolean 是否为常量
