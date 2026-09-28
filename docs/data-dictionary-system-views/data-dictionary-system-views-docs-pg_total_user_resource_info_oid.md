# PG\_TOTAL\_USER\_RESOURCE\_INFO\_OID

PG\_TOTAL\_USER\_RESOURCE\_INFO\_OID视图显示所有用户资源使用情况，需要使用管理员用户进行查询。此视图在参数[use\_workload\_manager](workload_management.md)为on时才有效。

**表 1**  PG\_TOTAL\_USER\_RESOURCE\_INFO\_OID字段

userid oid 用户ID。
used_memory integer 正在使用的内存大小（表示用户当前活跃的session已使用的内存总大小，若当前未运行业务或会话已结束，则动态内存会自动回收即为0。），单位MB。
total_memory integer 可以使用的内存大小，单位MB。值为0表示未限制最大可用内存，其限制取决于数据库最大可用内存。
used_cpu double precision 正在使用的CPU核数（仅统计复杂作业CPU使用 情况，且该值为相关控制组的CPU使用统计值）。
total_cpu integer 在该机器节点上，用户关联控制组的CPU核数总和。
used_space bigint 已使用的存储空间大小，单位KB。
total_space bigint 可使用的存储空间大小，单位KB，值为-1表示未限制最大存储空间。
used_temp_space bigint 已使用的临时空间大小（预留字段，暂未使用），单位KB。
total_temp_space bigint 可使用的临时空间总大小（预留字段，暂未使用），单位KB，值为-1表示未限制。
used_spill_space bigint 已使用的下盘空间大小（预留字段，暂未使用）。单位KB。
total_spill_space bigint 可使用的下盘空间总大小（预留字段，暂未使用），单位KB，值为-1表示未限制。
read_kbytes bigint 读磁盘数据量，单位KB。（当前不支持，仅分布式可用。） write_kbytes bigint 写磁盘数据量，单位KB。（当前不支持，仅分布式可用。） read_counts bigint 读磁盘次数。（当前不支持，仅分布式可用。） write_counts bigint 写磁盘次数。（当前不支持，仅分布式可用。） read_speed double precision 读磁盘速率，单位B/ms。（当前不支持，仅分布式可用。） write_speed double precision 写磁盘速率，单位B/ms。（当前不支持，仅分布式可用。）
