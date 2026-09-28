# PG\_AVAILABLE\_Extension\_VERSIONS

PG\_AVAILABLE\_Extension\_VERSIONS视图显示数据库中某些特性的扩展版本信息。

**表 1**  PG\_AVAILABLE\_Extension\_VERSIONS字段

name name 扩展名。
version text 版本名。
installed boolean 如果这个扩展的版本是当前已经安装了的则为真。
superuser boolean 如果只允许系统管理员安装这个扩展则为真。
relocatable boolean 如果扩展可以重新加载到另一个模式则为真。
schema name 扩展必须安装到的模式名，如果部分或全部可重新定位则为NULL。
requires name[] 先决条件扩展的名称，如果没有则为NULL。
comment text 扩展的控制文件中的评论字符串。
