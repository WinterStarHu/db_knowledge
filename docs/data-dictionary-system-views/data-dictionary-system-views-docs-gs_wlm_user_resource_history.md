# GS\_WLM\_USER\_RESOURCE\_HISTORY

GS\_WLM\_USER\_RESOURCE\_HISTORY系统表存储与用户使用资源相关的信息。该系统表的每条记录都是对应时间点某用户的资源使用情况，包括：内存、CPU核数、存储空间、临时空间、算子落盘空间、逻辑IO流量、逻辑IO次数和逻辑IO速率信息。其中，内存、CPU、IO相关监控项仅记录用户复杂作业的资源使用情况。对于IO相关监控项，当参数enable\_logical\_io\_statistics为on时才有效；当参数enable\_user\_metric\_persistent为on时，才会开启用户监控数据保存功能。GS\_WLM\_USER\_RESOURCE\_HISTORY系统表的数据来源于PG\_TOTAL\_USER\_RESOURCE\_INFO视图。查询该系统表需要sysadmin权限，且仅在数据库postgres下面查询时有数据。

**表 1**  GS\_WLM\_USER\_RESOURCE\_HISTORY

username text 用户名。
timestamp timestamp with time zone 时间戳。
used_memory integer 正在使用的内存大小（表示用户当前活跃的session已使用的内存总大小，若当前未运行业务或会话已结束，则动态内存会自动回收即为0。），单位MB。
total_memory integer 可以使用的内存大小，单位为MB。值为0表示未限制最大可用内存，其限制取决于数据库最大可用内存。
used_cpu real 正在使用的CPU核数（仅统计复杂作业CPU使用 情况，且该值为相关控制组的CPU使用统计值）。
total_cpu integer 该机器节点上，用户关联控制组的CPU核数总和。
used_space bigint 已使用的存储空间大小，单位KB。
total_space bigint 可使用的存储空间大小，单位KB，值为-1表示未限制最大存储空间。
used_temp_space bigint 已使用的临时存储空间大小（预留字段，暂未使用），单位KB。
total_temp_space bigint 可使用的临存储空间大小（预留字段，暂未使用），单位KB，值为-1表示未限制最大临时存储空间。
used_spill_space bigint 已使用的算子落盘存储空间大小（预留字段，暂未使用），单位KB。
total_spill_space bigint 可使用的算子落盘存储空间大小（预留字段，暂未使用），单位KB，值为-1表示未限制最大算子落盘存储空间。
read_kbytes bigint 监控周期内，读操作的字节流量，单位KB。
当前不支持，仅分布式可用。
write_kbytes bigint 监控周期内，写操作的字节流量，单位KB。
当前不支持，仅分布式可用。
read_counts bigint 监控周期内，读操作的次数，单位次。
当前不支持，仅分布式可用。
write_counts bigint 监控周期内，写操作的次数，单位次。
当前不支持，仅分布式可用。
read_speed real 监控周期内，读操作的字节速率，单位KB/s。
当前不支持，仅分布式可用。
write_speed real 监控周期内，写操作的字节速率，单位KB/s。
当前不支持，仅分布式可用。
