# PG\_AM

PG\_AM系统表存储有关索引访问方法的信息。系统支持的每种索引访问方法都有一行。

**表 1**  PG\_AM字段

oid oid 行标识符（隐含属性，必须明确选择）。
amname name 访问方法的名称。
amstrategies smallint 访问方法的操作符策略个数，或者如果访问方法没有一个固定的操作符策略集则为0。
amsupport smallint 访问方法的支持过程个数。
amcanorder boolean 这种访问方式是否支持通过索引字段值的命令扫描排序。
amcanorderbyop boolean 这种访问方式是否支持通过索引字段上操作符的结果的命令扫描排序。
amcanbackward boolean 访问方式是否支持向后扫描。
amcanunique boolean 访问方式是否支持唯一索引。
amcanmulticol boolean 访问方式是否支持多字段索引。
amoptionalkey boolean 访问方式是否支持第一个索引字段上没有任何约束的扫描。
amsearcharray boolean 访问方式是否支持ScalarArrayOpExpr搜索。
amsearchnulls boolean 访问方式是否支持IS NULL/NOT NULL搜索。
amstorage boolean 允许索引存储的数据类型与列的数据类型是否不同。
amclusterable boolean 是否允许在一个这种类型的索引上聚簇。
ampredlocks boolean 是否允许这种类型的一个索引管理细粒度的谓词锁定。
amkeytype oid PG_TYPE.oid 存储在索引里数据的类型，如果不是一个固定的类型则为0。
aminsert regproc PG_PROC.proname “插入这个行”函数。
ambeginscan regproc PG_PROC.proname “准备索引扫描”函数。
amgettuple regproc PG_PROC.proname “下一个有效行”函数，如果没有则为0。
amgetbitmap regproc PG_PROC.proname “抓取所有的有效行” 函数，如果没有则为0。
amrescan regproc PG_PROC.proname “（重新）开始索引扫描”函数。
amendscan regproc PG_PROC.proname “索引扫描后清理” 函数。
ammarkpos regproc PG_PROC.proname “标记当前扫描位置”函数。
amrestrpos regproc PG_PROC.proname “恢复已标记的扫描位置”函数。
ammerge regproc PG_PROC.proname “归并多个索引对象”函数。
ambuild regproc PG_PROC.proname “建立新索引”函数。
ambuildempty regproc PG_PROC.proname “建立空索引”函数。
ambulkdelete regproc PG_PROC.proname 批量删除函数。
amvacuumcleanup regproc PG_PROC.proname VACUUM后的清理函数。
amcanreturn regproc PG_PROC.proname 检查是否索引支持唯一索引扫描的函数，如果没有则为0。
amcostestimate regproc PG_PROC.proname 估计一个索引扫描开销的函数。
amoptions regproc PG_PROC.proname 为一个索引分析和确认reloptions的函数。
amhandler regproc PG_PROC.proname 负责提供有关该访问方法信息的处理器函数的OID amdelete regproc PG_PROC.proname 负责提供一个访问方法的删除行操作的处理程序函数
