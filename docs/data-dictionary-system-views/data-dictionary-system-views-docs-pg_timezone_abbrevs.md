# PG\_TIMEZONE\_ABBREVS

PG\_TIMEZONE\_ABBREVS视图提供了显示了所有可用的时区信息。

**表 1**  PG\_TIMEZONE\_ABBREVS字段

abbrev text 时区名缩写。
utc_offset interval 相对于UTC的偏移量。
is_dst boolean 如果当前正处于夏令时范围则为TRUE，否则为FALSE。
