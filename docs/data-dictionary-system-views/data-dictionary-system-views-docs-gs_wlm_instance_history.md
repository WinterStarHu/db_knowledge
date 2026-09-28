# GS\_WLM\_INSTANCE\_HISTORY

GS\_WLM\_INSTANCE\_HISTORY系统表存储与实例（数据库主节点或数据库节点）相关的资源使用相关信息。该系统表里每条记录都是对应时间点某实例资源使用情况，包括：内存、CPU核数、磁盘IO、进程物理IO和进程逻辑IO信息。查询该系统表需要sysadmin权限，且仅在数据库postgres下面查询时有数据。（IO等资源使用的相关统计仅在分布式生效，集中式不生效）

**表 1**  GS\_WLM\_INSTANCE\_HISTORY字段

instancename text 实例名称。
timestamp timestamp with time zone 时间戳。
used_cpu int 实例使用CPU所占用的百分比。
free_mem int 实例未使用的内存大小，单位MB。
used_mem int 实例已使用的内存大小，单位MB。
io_await real 实例所使用磁盘的io_wait值（10秒均值）。
io_util real 实例所使用磁盘的io_util值（10秒均值）。
disk_read real 实例所使用磁盘的读速率（10秒均值），单位KB/s。
disk_write real 实例所使用磁盘的写速率（10秒均值），单位KB/s。
process_read bigint 实例对应进程从磁盘读数据的读速率（不包括从磁盘pagecache中读取的字节数，10秒均值），单位KB/s。
process_write bigint 实例对应进程向磁盘写数据的写速率（不包括向磁盘pagecache中写入的字节数，10秒均值），单位KB/s。
logical_read bigint 数据库主节点实例：不统计。
数据库节点实例：该实例在本次统计间隙（10秒）内逻辑读字节速率，单位KB/s。
仅分布式可用。
logical_write bigint 数据库主节点实例：不统计。
数据库节点实例：该实例在本次统计间隙（10秒）内逻辑写字节速率，单位KB/s。
仅分布式可用。
read_counts bigint 数据库主节点实例：不统计。
数据库节点实例：该实例在本次统计间隙（10秒）内逻辑读操作次数之和，单位次。
仅分布式可用。
write_counts bigint 数据库主节点实例：不统计。
数据库节点实例：该实例在本次统计间隙（10秒）内逻辑写操作次数之和，单位次。
仅分布式可用。
