# 开发人员选项

## allow\_system\_table\_mods

**参数说明**： 设置是否允许修改系统表的结构。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示允许修改系统表的结构。
- off表示不允许修改系统表的结构。

**默认值**： off

>[!WARNING]注意
>不建议修改该参数默认值，若设置为on，可能导致系统表损坏，甚至数据库无法启动。

## allow_create_sysobject

**参数说明**： 设置是否允许在系统模式下创建或修改函数、存储过程、同义词、聚合函数、操作符等对象。此处的系统模式指数据库初始后自带的模式，但不包含public模式。系统模式的oid通常小于16384。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示允许初始用户和系统管理员在系统模式下创建或修改函数、存储过程、同义词、聚合函数等对象，并允许初始用户在系统模式下创建操作符。其他用户是否允许创建这些对象请参考对应模式的权限要求。
- off表示禁止所有用户在系统模式下创建或修改函数、存储过程、同义词、聚合函数、操作符等对象。

**默认值**： on

## debug\_assertions

**参数说明**： 控制打开各种断言检查。能够协助调试，当遇到奇怪的问题或者崩溃，请把此参数打开，因为它能暴露编程的错误。要使用这个参数，必须在编译openGauss的时候定义宏USE\_ASSERT\_CHECKING（通过configure选项 --enable-cassert完成）。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示打开断言检查。
- off表示不打开断言检查。

>[!NOTE]说明
>当启用断言选项编译openGauss时，debug\_assertions缺省值为on 。

**默认值**： off

## ignore\_checksum\_failure

**参数说明**： 设置读取数据时是否忽略校验信息检查失败（但仍然会告警），继续执行可能导致崩溃，传播或隐藏损坏数据，无法从远程节点恢复数据及其他严重问题。不建议用户修改设置。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示忽略数据校验错误。
- off表示数据校验错误正常报错。

**默认值**： off

## ignore\_system\_indexes

**参数说明**： 读取系统表时忽略系统索引（但是修改系统表时依然同时修改索引）。

该参数属于BACKEND类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>这个参数在从系统索引被破坏的表中恢复数据的时候非常有用。

**取值范围**： 布尔型

- on表示忽略系统索引。
- off表示不忽略系统索引。

**默认值**： off

## post\_auth\_delay

**参数说明**： 在认证成功后，延迟指定时间，启动服务器连接。允许调试器附加到启动进程上。

该参数属于BACKEND类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，最小值为0，最大值为2147，单位为秒。

**默认值**： 0

>[!NOTE]说明
>此参数只用于调试和问题定位，为避免影响正常业务运行，生产环境下请确保参数值为默认值0。参数设置为非0时可能会因认证延迟时间过长导致数据库实例状态异常。

## pre\_auth\_delay

**参数说明**： 启动服务器连接后，延迟指定时间，进行认证。允许调试器附加到认证过程上。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 整型，最小值为0～60，单位为秒。

**默认值**： 0

>[!NOTE]说明
>此参数只用于调试和问题定位，为避免影响正常业务运行，生产环境下请确保参数值为默认值0。参数设置为非0时可能会因认证延迟时间过长导致数据库实例状态异常。

## trace\_notify

**参数说明**： 为LISTEN和NOTIFY命令生成大量调试输出。[client\_min\_messages](logging_time.md#zh-cn_topic_0237124722_zh-cn_topic_0059778452_s2955da1f1cb24b0aa68ddc77700233e0)或[log\_min\_messages](logging_time.md#zh-cn_topic_0237124722_zh-cn_topic_0059778452_sc6c47ec8cc1b47e28be98dbb24b1b39a)级别必须是DEBUG1或者更低时，才能把这些输出分别发送到客户端或者服务器日志。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示打开输出功能。
- off表示关闭输出功能。

**默认值**： off

## trace\_recovery\_messages

**参数说明**： 启用恢复相关调试输出的日志录，否则将不会被记录。该参数允许覆盖正常设置的[log\_min\_messages](logging_time.md#zh-cn_topic_0237124722_zh-cn_topic_0059778452_sc6c47ec8cc1b47e28be98dbb24b1b39a)，但是仅限于特定的消息，这是为了在调试备机中使用。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 枚举类型，有效值有debug5、debug4、debug3、debug2、debug1、log，取值的详细信息请参见[log\_min\_messages](logging_time.md#zh-cn_topic_0237124722_zh-cn_topic_0059778452_sc6c47ec8cc1b47e28be98dbb24b1b39a)。

**默认值**： log

>[!NOTE]说明
>
>- 默认值log表示不影响记录决策。
>
>- 除默认值外，其他值会导致优先级更高的恢复相关调试信息被记录，因为它们有log优先权。对于常见的log\_min\_messages设置，这会导致无条件地将它们记录到服务器日志上。

## trace\_sort

**参数说明**： 控制是否在日志中打印排序操作中的资源使用相关信息。这个选项只有在编译openGauss的时候定义了TRACE\_SORT宏的时候才可用，不过目前TRACE\_SORT是由缺省定义的。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on表示打开控制功能。
- off表示关闭控制功能。

**默认值**： off

## zero\_damaged\_pages

**参数说明**： 控制检测导致openGauss报告错误的损坏的页头，终止当前事务。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

设置为on时，会导致系统报告一个警告，把损坏的页面填充为零然后继续处理。这种行为会破坏数据，也就是所有在已经损坏页面上的行记录。但是它允许绕开坏页面然后从表中尚存的未损坏页面上继续检索数据行。因此它在因为硬件或者软件错误导致的崩溃中进行恢复是很有用的。通常不应该把它设置为on，除非不需要从崩溃的页面中恢复数据。

**默认值**： off

## remotetype

**参数说明**：设置远程连接类型。

该参数不支持修改。

**取值范围**：枚举类型，有效值有application、datanode、internaltool。

**默认值**：application

## max\_user\_defined\_exception

**参数说明**：异常最大个数，默认值不可更改。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：整型，当前只能取固定值1000

**默认值**：1000

## enable\_fast\_numeric

**参数说明**： 标识是否开启Numeric类型数据运算优化。Numeric数据运算是较为耗时的操作之一，通过将Numeric转化为int64/int128类型，提高Numeric运算的性能。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on/true表示开启Numeric优化。
- off/false表示关闭Numeric优化。

**默认值**： on

## enable\_compress\_spill

**参数说明**： 标识是否开启下盘压缩功能。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 布尔型

- on/true表示开启下盘优化。
- off/false表示关闭下盘优化。

**默认值**： on

## resource\_track\_log

**参数说明**：控制自诊断的日志级别。目前仅对多列统计信息进行控制。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 字符串

- summary：显示简略的诊断信息。
- detail：显示详细的诊断信息。

目前这两个参数值只在显示多列统计信息未收集的告警的情况下有差别，summary不显示未收集多列统计信息的告警，detail会显示这类告警。

**默认值**： summary

## show\_acce\_estimate\_detail

**参数说明**：评估信息一般用于运维人员在维护工作中使用，因此该参数默认关闭，此外为了避免这些信息干扰正常的explain信息显示，只有在explain命令的verbose选项打开的情况下才显示评估信息

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

- on表示可以在explain命令的输出中显示评估信息。
- off表示不在explain命令的输出中显示评估信息。

**默认值**：off

>[!NOTE]说明
>当前版本不支持加速数据库实例，因此该参数设置后不生效。

## support\_batch\_bind

**参数说明**：控制是否允许通过JDBC、ODBC、Libpq等接口批量绑定和执行PBE形式的语句。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

- on表示使用批量绑定和执行。
- off表示不使用批量绑定和执行。

**默认值**：on

## numa\_distribute\_mode

**参数说明**：用于控制部分共享数据和线程在NUMA节点间分布的属性。用于大型多NUMA节点的ARM服务器性能调优，一般不用设置。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串，当前有效取值为'none'，'all'。

- 'none'：表示不启用本特性。
- 'all'：表示将部分共享数据和线程分布到不同的NUMA节点下，减少远端访存次数，提高性能。目前仅适用于拥有多个NUMA节点的ARM服务器，并且要求全部NUMA节点都可用于数据库进程，不支持仅选择一部分NUMA节点。

>[!NOTE]说明
>当前版本x86平台下不支持numa\_distribute\_mode设置为all。

**默认值**：'none'

## log\_pagewriter

**参数说明**：设置用于增量检查点打开后，显示线程的刷页信息以及增量检查点的详细信息，信息比较多，不建议设置为on。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

**默认值**：off

## advance\_xlog\_file\_num

**参数说明**：用于控制备机在后台周期性地提前初始化xlog文件的数目。该参数是为了避免事务提交时执行xlog文件初始化影响性能，但仅在备机超重负载时才可能出现，因此一般不用配置。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：整型，0\~1000000（0表示不提前初始化）。例如，取值10，表示后台线程会周期性地根据当前xlog写入位置提前初始化10个xlog文件。

**默认值**：0

## enable\_beta\_opfusion

**参数说明**：在enable\_opfusion参数打开的状态下，如果开启该参数，可以支持TPCC中出现的聚集函数（目前只支持count和sum两类聚集函数），排序两类SQL语句的加速执行，提升SQL执行性能。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

- on表示开启。
- off表示不开启。

**默认值**：off

## enable\_csqual\_pushdown

**参数说明**：进行查询时，是否要将过滤条件下推，进行Rough Check。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

- on表示进行查询时，要将过滤条件下推，进行Rough Check。
- off表示进行查询时，不要将过滤条件下推，进行Rough Check。

**默认值**：on

## string\_hash\_compatible

**参数说明**： 该参数用来说明char类型和varchar/text类型的hash值计算方式是否相同，以此来判断进行分布列从char类型到相同值的varchar/text类型转换，数据分布变化时，是否需要进行重分布。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

- on表示计算方式相同，不需要进行重分布。
- off表示计算方式不同，需要进行重分布。

>[!NOTE]说明
>计算方式的不同主要体现在字符串计算hash值时传入的字节长度上。（如果为char，则会忽略字符串后面空格的长度，如果为text或varchar，则会保留字符串后面空格的长度。）hash值的计算会影响到查询的计算结果，因此此参数一旦设置后，在整个数据库使用过程中不能再对其进行修改，以避免查询错误。

**默认值**： off

## pldebugger\_timeout

**参数说明**： 该参数用来控制pldebugger server端等待debug端响应的超时时间。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：整型，1 \~ 86400，单位为秒。

**默认值**：15min

## plsql\_show\_all\_error

**参数说明**： 该参数用来控制编译PLPGSQL对象时是否支持跳过报错继续编译，具体影响请参考[DBE\_PLDEVELOPER](../sql_reference/dbe_pldeveloper.md)内的说明。需要注意的是，部分语句仍会直接报错并停止编译。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

**默认值**：off

## ustore\_attr

**参数说明**： 该参数主要用来控制Ustore存储引擎表的信息统计，回滚类型，重点模块\(包括数据、索引、回滚段、回放等\)运行时数据的校验，主要用于协助研发问题定位。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串，该参数值的设置方式采用key-value模式，key和value取值对应关系和说明如下。如果是多个key-value组合设置，中间使用";"作为分隔符，例如：

ustore\_attr='ustore\_verify\_level=FAST;ustore\_verify\_module=UPAGE:UBTREE:UNDO:REDO'。

>[!NOTE]说明
>ustore\_attr设置参数值时，key和value之间的"="前后不要有空格或者其他字符，例如ustore\_attr='ustore\_verify\_level =  FAST;，内核代码校验会发现参数不合法，导致参数设置失败。

- ustore\_verify\_level：控制校验的级别。

**取值范围**：字符串，取值不区分大小写，见下述表格详细描述。

**表 1**  ustore\_verify\_level取值含义说明

参数取值 NONE NONE表示关闭校验，性能测试场景下推荐开启。
FAST FAST表示快速校验，校验内容少，性能影响最小。
COMPLETE COMPLETE表示全量校验，校验内容最多，性能影响比较大。

**默认值**：FAST

- ustore\_verify\_module：控制校验的模块。

**取值范围**：字符串，设置值UPAGE，UBTREE，UNDO, REDO中的一个或者多个，或者单独设置ALL或者NULL\(不区分大小写\)。当设置

UPAGE，UBTREE，UNDO，REDO中的多个值时，使用":"作为连接符。例如ustore\_verify\_module=UPAGE:UBTREE:UNDO:REDO。

**表 2**  ustore\_verify\_module取值含义说明

参数取值 UPAGE 表示开启数据页面校验。
UBTREE 表示开启UBTREE索引校验。
UNDO 表示开启回滚段数据校验。
REDO 表示开启REDO流程的数据页面校验。
ROACH 表示开启ROACH备份的数据页面校验。
ALL 表示同时开启UPAGE，UBTREE，UNDO，REDO模块数据的校验。
NULL 表示同时关闭UPAGE，UBTREE，UNDO，REDO模块数据的校验。

**默认值**： UPAGE:UBTREE

- index\_trace\_level：控制开启索引追踪并控制打印级别，开启后在索引扫描的过程中，会根据不同的打印级别对符合条件的索引元组的信息进行打印。

**取值范围**：字符串，取值下表格描述。

**表 3**  index\_trace\_level取值含义说明

参数取值 不打印任何额外信息。
NORMAL VISIBILITY 在NORMAL的基础上，额外打印没有通过可见性检查的索引元组的信息，并标明是否可见。
SHOWHIKEY 在VISIBILITY的基础上，尝试打印页面上HIKEY元组的信息。
ALL 打印扫描的索引页面上所有元组的相关信息。

**默认值**：NO

- enable\_log\_tuple：打印日志级提示信息时，是否允许同时将相关元组的内容打印出来，以便进行问题排查和定位。

**取值范围**：on或者off（不区分大小写）

**默认值**：off

**备注**：该参数已弃用

- enable\_ustore\_sync\_rollback：控制Ustore表是否开启同步回滚。

**取值范围**：布尔值

**默认值**：true

- enable\_ustore\_async\_rollback：控制Ustore表是否开启异步回滚。

**取值范围**：布尔值

**默认值**：true

- enable\_ustore\_page\_rollback：控制Ustore表是否开启页面回滚。

**取值范围**：布尔值

**默认值**：true

- enable\_ustore\_partial\_seqscan：是否允许Ustore表开启部分扫描。

**取值范围**：布尔值

**默认值**：false

- enable\_candidate\_buf\_usage\_count：是否开启缓存区使用计数统计。

**取值范围**：布尔值

**默认值**：false

- ustats\_tracker\_naptime：控制Ustore表统计信息周期。

**取值范围**：1\~ 2147483

**默认值**：20, 单位\(秒\)

- umax\_search\_length\_for\_prune：控制Ustore表prune操作搜索的最大深度。

**取值范围**：1\~ 2147483

**默认值**：10，单次\(次\)

- ustore\_unit\_test：研发白盒测试指定测试参数

**取值范围**：字符串

**默认值**：空

**默认值**：空字符串

>[!WARNING]注意
>
>+ ustore\_attr参数设置请慎重，建议在工程师协助下修改。
>+ 该参数只适用于集中式或者openGauss单机上的Ustore存储引擎表。

## float\_suffix\_acceptance

**参数说明**：是否允许接受以f/d结尾的浮点数，该参数只在A兼容性数据库生效。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

**默认值**：off

## enable\_binary\_special\_a\_format

**参数说明**：是否按照A兼容性模式显示浮点数特殊值。为避免接收异常，此参数在jdbc不会生效。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

**默认值**：off

```
openGauss=# select binary_double_infinity;
 binary_double_infinity
------------------------
               Infinity
(1 row)

openGauss=# set enable_binary_special_a_format = on;
SET
openGauss=# select binary_double_infinity;
 binary_double_infinity
------------------------
                    Inf
(1 row)
```

## enable_unified_memory_release

**参数说明**：是否使用统一内存释放方式，避免分散释放造成内存碎片化和内存释放接口热点，减少内存释放频率。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：布尔型

**默认值**：off
