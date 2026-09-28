# GS\_DEPENDENCIES

GS\_DEPENDENCIES系统表记录存储过程/包与被引用对象的依赖信息。与现有记录依赖信息的PG\_DEPEND系统表不同的是，GS\_DEPENDENCIES系统表允许记录存储过程/包对象与当前尚未定义的引用对象之间的依赖关系。引用对象的信息记录在GS\_DEPENDENCIES\_OBJ系统表中，refobjoid字段记录了引用对象在GS\_DEPENDENCIES\_OBJ系统表中的OID。在GS\_DEPENDENCIES系统表记录依赖关系需要设置guc参数behavior\_compat\_options='plpgsql\_dependency'。

**表 1**  GS\_DEPENDENCIES字段

schemaname name 依赖对象所属的schema名字。
packagename name 依赖对象所属的package名字。
refobjpos int8 引用对象在依赖对象中的位置信息。包括位于类型中(字段值为1，下同)，package的specification(2)，函数头(4)，函数体(8)和package的body(16)。
refobjoid oid 引用对象在GS_DEPENDENCIES_OBJ系统表中的OID。
objectname text 依赖对象的名字。
