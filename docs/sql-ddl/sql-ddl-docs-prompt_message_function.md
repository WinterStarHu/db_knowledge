# 提示信息函数

- report\_application\_error

描述：PL执行过程中，可以使用此函数来抛ERROR。

返回值类型：void

**表 1**  report\_application\_error参数说明

是否必选 log text error消息的内容。
code int4 error消息对应的error code，范围为：-20999 ~ -20000。

- raise\_application\_error

描述：PL执行过程中，可以使用此函数抛出自定义的错误信息。它允许开发人员在存储过程、函数或触发器中定义自己的错误代码和错误消息，并将这些信息传递给客户端。

返回值类型：void

**表 1**  raise\_application\_error参数说明

是否必选 code int4 error消息对应的error code，范围为：-20999 ~ -20000。
message text error消息的内容。
keep_errors bool 如果为 TRUE，新的错误将被添加到已有的错误堆中；如果为 FALSE（默认值），新的错误将替换当前的错误堆。
