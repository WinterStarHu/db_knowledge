# PG\_TIMEZONE\_NAMES

PG\_TIMEZONE\_NAMES视图提供了显示了所有能够被SET TIMEZONE识别的时区名及其缩写、UTC偏移量、是否夏时制。

**表 1**  PG\_TIMEZONE\_NAMES字段

name text 时区名。
abbrev text 时区名缩写。
utc_offset interval 相对于UTC的偏移量。
is_dst boolean 如果当前正处于夏令时范围则为TRUE，否则为FALSE。
