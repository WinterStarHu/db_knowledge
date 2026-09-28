# DBE\_PLDEBUGGER.set\_var

将指定的调试的存储过程中最上层栈上的变量修改为入参的取值。如果存储过程中包含同名的变量，set\_var只支持第一个变量值的设置。

**表 1**  set\_var入参和返回值列表

var_name IN text 变量名。
value IN text 修改值。
result OUT boolean 结果，是否成功。
