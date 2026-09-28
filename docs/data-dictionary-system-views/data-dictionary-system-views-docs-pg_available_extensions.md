# PG\_AVAILABLE\_ExtensionS

PG\_AVAILABLE\_ExtensionS视图显示数据库中某些特性的扩展信息。

**表 1**  PG\_AVAILABLE\_ExtensionS字段

name name 扩展名。
default_version text 缺省版本的名称，如果没有指定则为NULL。
installed_version text 扩展当前安装版本，如果没有安装任何版本则为NULL。
comment text 扩展的控制文件中的评论字符串。
