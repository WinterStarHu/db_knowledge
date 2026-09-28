# PG\_TYPE

PG\_TYPE系统表存储数据类型的相关信息。

**表 1**  PG\_TYPE字段

oid oid 行标识符（隐含属性，必须明确选择）。
typname name 数据类型名称。
typnamespace oid 包含这个类型的名称空间的OID。
typowner oid 该类型的所有者。
typlen smallint typbyval boolean 指定内部传递这个类型的数值时是传值（该值为true）还是传引用（该值为false）。如果该类型的TYPLEN不是1、2、4、8， TYPBYVAL最好为false。变长类型通常是传引用。即使TYPLEN允许传值，TYPBYVAL也可以为false。
typtype "char" 对于基础类型是b。对于复合类型是c（比如，一个表的行类型）。对于域类型是d。对于伪类型是p。对于范围类型是r。对于枚举类型是e。对于未定义类型是u。对于集合类型是o。
参见typrelid和typbasetype。
typcategory "char" 是数据类型的模糊分类，可用于解析器做为数据转换的依据。
typispreferred boolean 如果为真，则数据符合TYPCATEGORY所指定的转换规则时进行转换。
typisdefined boolean 如果定义了类型则为真，如果是一种尚未定义的类型的占位符则为假。如果为假，则除了该类型名称，名称空间和OID之外没有可靠的信息。
typdelim "char" 当分析数组输入时，分隔两个此类型数值的字符请注意该分隔符是与数组元素数据类型相关联的，而不是和数组数据类型关联。
typrelid oid 如果是复合类型（请参见typtype），则这个字段指向pg_class中定义该表的行。对于自由存在的复合类型，pg_class记录并不表示一个表，但是总需要它来查找该类型连接的pg_attribute记录。对于非复合类型为零。
typelem oid 如果不为0，则它标识pg_type里面的另外一行。当前类型可以当做一个产生类型为typelem的数组来描述。一个“真正的”数组类型是变长的（typlen= -1），但是一些定长的（typlen &gt; 0）类型也拥有非零的typelem（比如name和point）。如果一个定长类型拥有一个typelem ，则他的内部形式必须是typelem数据类型的某个数目的个数值，不能有其他数据。变长数组类型有一个该数组子过程定义的头（文件）。
typarray oid 如果不为0，则表示在pg_type中有对应的类型记录。
typinput regproc 输入转换函数（文本格式）。
typoutput regproc 输出转换函数（文本格式）。
typreceive regproc 输入转换函数（二进制格式），如果没有则为0。
typsend regproc 输出转换函数（二进制格式），如果没有则为0。
typmodin regproc 输入类型修改符函数，如果为0，则不支持。
typmodout regproc 输出类型修改符函数，如果为0，则不支持。
typanalyze regproc 自定义的ANALYZE函数，如果使用标准函数，则为0。
typalign "char" typstorage "char" typnotnull boolean 该类型是否存在NOTNULL约束。目前只用于域。
typbasetype oid 如果这是一个衍生类型（请参见typtype），则该标识作为这个类型的基础的类型。如果不是衍生类型则为零。
typtypmod integer 域使用typtypmod记录要作用到它们的基础类型上的typmod（如果基础类型不使用typmod则为-1）。如果这种类型不是域，则为-1。
typndims integer 如果一个域是数组，则typndims是数组维数的数值（也就是说，typbasetype是一个数组类型；域的typelem将匹配基本类型的typelem）。非域非数组域为零。
typcollation oid 指定类型的排序规则。取值参考PG_COLLATION系统表。如果为0，则表示不支持排序。
typdefaultbin pg_node_tree 如果为非NULL，则它是该类型缺省表达式的nodeToString()表现形式。目前这个字段只用于域。
typdefault text 如果某类型没有相关缺省值，则取值是NULL。
如果typdefaultbin为非NULL，则typdefault必须包含一个typdefaultbin代表的缺省表达式。如果typdefaultbin为NULL但typdefault不是，typdefault则是该类型缺省值的外部表现形式，可以把它作为该类型的输入，转换器生成一个常量。
typacl aclitem[] 访问权限。
