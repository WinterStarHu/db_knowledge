# GS\_DEPENDENCIES\_OBJ

GS\_DEPENDENCIES\_OBJ系统表记录被存储过程/包/类型所引用的对象信息。信息允许记录当前尚未定义的引用对象，并在引用对象创建/更改/删除时修改表中记录的对象信息。在GS\_DEPENDENCIES\_OBJ系统表记录引用对象信息需要设置guc参数behavior\_compat\_options='plpgsql\_dependency'。

**表 1**  GS\_DEPENDENCIES字段

oid oid 行标识符（隐含属性，必须明确选择）。
schemaname name 引用对象所属的schema名字。
packagename name 引用对象所属的package名字。
type int8 引用对象的类型信息。包括未定义(字段值为1，下同)，变量(2)，类型(3)，函数(4)，函数头(5)，包头(6)和包体(7)。
name text 引用对象的名字。
objnode pg_node_tree 引用对象的Node信息。包括未定义Node(标识为Undefined，不记录任何信息)，类型Node(记录类型分类，字段信息等)，变量Node(记录变量类型名等)和函数头Node(记录函数名，参数列表等)。
