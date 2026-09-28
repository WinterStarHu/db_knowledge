# WLM\_USER\_RESOURCE\_RUNTIME

WLM\_USER\_RESOURCE\_RUNTIME视图显示所有用户资源使用情况，需要使用管理员用户进行查询。此视图在GUC参数“use\_workload\_manager”为“on”时才有效。

**表 1**  WLM\_USER\_RESOURCE\_RUNTIME字段

username name 用户名。
used_memory integer 正在使用的内存大小（表示用户当前活跃的session已使用的内存总大小，若当前未运行业务或会话已结束，则动态内存会自动回收即为0。），单位MB。
total_memory integer 可以使用的内存大小，单位MB。值为0表示未限制最大可用内存，其限制取决于数据库最大可用内存。
used_cpu integer 正在使用的CPU核数（仅统计复杂作业CPU使用 情况，且该值为相关控制组的CPU使用统计值）。
total_cpu integer 在该机器节点上，用户关联控制组的CPU核数总和。
used_space bigint 已使用的存储空间大小，单位KB。
total_space bigint 可使用的存储空间大小，单位KB，值为-1表示未限制最大存储空间。
used_temp_space bigint 已使用的临时空间大小（预留字段，暂未使用），单位KB。
total_temp_space bigint 可使用的临时空间大小（预留字段，暂未使用），单位KB，值为-1表示未限制最大临时存储空间。
used_spill_space bigint 已使用的下盘空间大小（预留字段，暂未使用），单位KB。
total_spill_space bigint 可使用的下盘空间大小（预留字段，暂未使用），单位KB，值为-1表示未限制最大下盘空间。
