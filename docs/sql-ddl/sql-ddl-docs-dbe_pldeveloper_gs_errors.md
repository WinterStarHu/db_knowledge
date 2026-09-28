# DBE\_PLDEVELOPER.gs\_errors

用于记录PLPGSQL对象（存储过程、函数、包、包体）编译过程中遇到的报错信息，具体内容见下列字段描述。

打开plsql\_show\_all\_error参数后，如果编译过程中存在报错，则会跳过报错继续编译并把报错信息记录在gs\_errors中，如果关闭plsql\_show\_all\_error参数则不会将相关信息插入此表中。

**表 1**  DBE\_PLDEVELOPER.gs\_errors字段

oid 对象的ID。
owner bigint 对象创建用户ID。
nspid oid 对象的模式ID。
name name 对象名。
type text 对象类型（procedure/function/package/package body）。
line integer 行号。
src text 对象创建的原始语句。
