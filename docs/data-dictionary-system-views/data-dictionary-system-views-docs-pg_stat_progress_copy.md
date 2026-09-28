# PG\_STAT\_PROGRESS\_COPY

PG\_STAT\_PROGRESS\__COPY视图显示当前系统内所有正在执行COPY命令的进度信息。

超级用户/管理员能够查看所有COPY命令进度信息，普通用户只能查看到到该用户执行的COPY命令进度信息，无法查看其他用户执行 的COPY命令进度信息(只会显示线程标识符和数据库oid)。

**表 1**  PG\_STAT\_PROGRESS\_COPY字段

pid int8 正在执行COPY命令的线程标识符。
datid oid 执行COPY命令的线程连接的数据库标识。
datname name 执行COPY命令的线程连接的数据库名称。
relid oid COPY命令的目标关系 command text 具体的命令：COPY TO ， COPY FROM type text COPY类型，当前支持FILE/PIPE bytes_processed bigint 当前已COPY的字节数 bytes_total bigint COPY的总字节数，仅限于COPY FROM FILE类型 tuples_processed bigint 当前COPY已处理的元组数量 tuples_excluded bigint 当前被COPY WHERE子句排除的元组数量
