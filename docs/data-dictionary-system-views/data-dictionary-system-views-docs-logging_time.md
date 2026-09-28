# 记录日志的时间

## client\_min\_messages

**参数说明**： 控制发送到客户端的消息级别。每个级别都包含排在它后面的所有级别中的信息。级别越低，发送给客户端的消息就越少。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>当client\_min\_messages和[log\_min\_messages](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_sc6c47ec8cc1b47e28be98dbb24b1b39a)取相同值时，其值所代表的级别不同。

**取值范围**： 枚举类型，有效值有debug、debug5、debug4、debug3、debug2、debug1、info、log、notice、warning、error、fatal、panic。参数的详细信息请参见[表1](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_zh-cn_topic_0058967791_table55180162)。在实际设置过程中，如果设置的级别大于error，为fatal或panic，系统会默认将级别转为error。

**默认值**： notice

## log\_min\_messages

**参数说明**： 控制写到服务器日志文件中的消息级别。每个级别都包含排在它后面的所有级别中的信息。级别越低，服务器运行日志中记录的消息就越少。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>当[client\_min\_messages](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_s2955da1f1cb24b0aa68ddc77700233e0)和log\_min\_messages取相同值log时所代表的消息级别不同。
>部分日志信息的打印需要同时配置该参数与logging_module，即设置该参数打开后可能还需要设置logging_module打开对应模块的日志打印开关。

**取值范围**： 枚举类型，有效值有debug、debug5、debug4、debug3、debug2、debug1、info、log、notice、warning、error、fatal、panic。参数的详细信息请参见[表1](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_zh-cn_topic_0058967791_table55180162)。

**默认值**： warning

## log\_min\_error\_statement

**参数说明**： 控制在服务器日志中记录错误的SQL语句。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 枚举类型，有效值有debug、debug5、debug4、debug3、debug2、debug1、info、log、notice、warning、error、fatal、panic。参数的详细信息请参见[表1](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_zh-cn_topic_0058967791_table55180162)。

>[!NOTE]说明
>
>- 设置为error，表示导致错误、日志消息、致命错误、panic的语句都将被记录。
>- 设置为panic，表示关闭此特性。

**默认值**： error

## log\_min\_duration\_statement

**参数说明**： 当某条语句的持续时间大于或者等于特定的毫秒数时，log\_min\_duration\_statement参数用于控制记录每条完成语句的持续时间。

设置log\_min\_duration\_statement可以很方便地跟踪需要优化的查询语句。对于使用扩展查询协议的客户端，语法分析、绑定、执行每一步所花时间被独立记录。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>当此选项与[log\_statement](logging_content.md#zh-cn_topic_0237124723_zh-cn_topic_0059778400_s77b3e2e16a3e4705a139bef98688be8a)同时使用时，已经被log\_statement记录的语句文本不会被重复记录。在没有使用syslog情况下，推荐使用[log\_line\_prefix](logging_content.md#zh-cn_topic_0237124723_zh-cn_topic_0059778400_sd57ce2167a8149239e10ab0cef12b949)记录PID或会话ID，方便将当前语句消息连接到最后的持续时间消息。

**取值范围**： 整型，-1 \~ INT\_MAX，单位为毫秒。

- 设置为250，所有运行时间不短于250ms的SQL语句都会被记录。
- 设置为0，输出所有语句的持续时间。
- 设置为-1，关闭此功能。

**默认值**： 30min

## backtrace\_min\_messages

**参数说明**： 控制当产生该设置参数级别相等或更高级别的信息时，会打印函数的堆栈信息到服务器日志文件中。

该参数属于SUSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>该参数作为客户现场问题定位手段使用，且由于频繁的打印函数栈会对系统的开销及稳定性有一定的影响，因此如果需要进行问题定位时，建议避免将backtrace\_min\_messages的值设置为fatal及panic以外的级别。

**取值范围**： 枚举类型

有效值有debug、debug5、debug4、debug3、debug2、debug1、info、log、notice、warning、error、fatal、panic。参数的详细信息请参见[表1](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_zh-cn_topic_0058967791_table55180162)。

**默认值**： panic

[表1](#zh-cn_topic_0237124722_zh-cn_topic_0059778452_zh-cn_topic_0058967791_table55180162)解释openGauss中使用的消息安全级别。当日志输出到syslog或者eventlog（仅windows环境下，openGauss版本不涉及该参数）时，openGauss进行如表中的转换。

**表 1**  信息严重程度分类

信息严重程度类型 详细说明 系统日志 事件日志 debug[1-5] 报告详细调试信息。
DEBUG INFORMATION log 报告对数据库管理员有用的信息，比如检查点操作统计信息。
INFO INFORMATION info 报告用户可能需求的信息，比如在VACUUM VERBOSE过程中的信息。
INFO INFORMATION notice 报告可能对用户有帮助的信息， 比如，长标识符的截断，作为主键一部分创建的索引等。
NOTICE INFORMATION warning 报告警告信息，比如在事务块范围之外的COMMIT。
NOTICE WARNING error 报告导致当前命令退出的错误。
WARNING ERROR fatal 报告导致当前会话终止的原因。
ERR ERROR panic 报告导致整个数据库被关闭的原因。
CRIT ERROR

## plog\_merge\_age

**参数说明**： 该参数用于控制性能日志数据输出的周期。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>该参数以毫秒为单位，建议在使用过程中设置值为1000的整数倍，即设置值以秒为最小单位。该参数所控制的性能日志文件以prf为扩展名，文件放置在$GAUSSLOG/gs\_profile/目录下面，其中node\_name是由postgres.conf文件中的pgxc\_node\_name的值，不建议外部使用该参数。

**取值范围**： 0\~2147483647，单位为毫秒（ms）。

当设置为0时，当前会话不再输出性能日志数据。当设置为非0时，当前会话按照指定的时间周期进行输出性能日志数据。

该参数设置得越小，输出的日志数据越多，对性能的负面影响越大。

**默认值**： 0
