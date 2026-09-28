# DBE\_PLDEBUGGER.print\_var

debug端调试过程中，调用print\_var，打印当前存储过程内变量中指定的变量名及其取值。该函数入参frameno表示查询遍历的栈层数，支持不加入该参数调用，缺省为查看最上层栈变量。

**表 1**  print\_var入参和返回值列表

var_name IN text 变量。
frameno IN integer（可选） 指定的栈层数，缺省为最顶层。
varname OUT text 变量名。
vartype OUT text 变量类型。
value OUT text 变量值。
package_name OUT text 变量对应的package名，预留使用，当前均为空。
isconst OUT boolean 是否为常量。
