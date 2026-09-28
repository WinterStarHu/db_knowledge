# 第三方库错误码说明

第三方错误码的值是包含五个字符的字符串，由3个字符的错误类型和2个字符的子类构成。五个字符包含数值或者大写字母，代表各种错误或者警告条件的代码。

**表 1**  liborc的错误码对照表

错误级别 错误码 错误说明 ORC_INFO ORC00 无效错误类型（INVALID_ERROR_CODE） ORC_ERROR ORC01 不支持或无法实现的错误类型（NOTIMPLEMENTEDYET） ORC_ERROR ORC02 编译错误类型（PARSEERROR） ORC_ERROR ORC03 逻辑错误类型（LOGICERROR） ORC_ERROR ORC04 范围错误类型（RANGEERROR） ORC_ERROR ORC05 写错误类型（WRITEERROR） ORC_FATAL ORC06 中断错误类型（ASSERTERROR） ORC_ERROR ORC07 内存错误类型（MEMORYERROR） ORC_ERROR ORC08 其他未归类的错误类型（OTHERERROR）

>[!TIP]须知
>
>1. 根据错误级别的不同，将ORC\_ERROR及其以上级别的错误打印在gsql端，将详细的堆栈信息打印在对应的CN/DN日志中，ORC\_ERROR以下级别的错误打印仅打印在对应的CN/DN日志中。
>2. 用户可根据错误码及对应的报错信息定位错误位置分析并解决问题。
