# GLOBAL\_GET\_BGWRITER\_STATUS

GLOBAL\_GET\_BGWRITER\_STATUS视图显示所有实例bgwriter线程刷页信息，候选buffer链中页面个数，buffer淘汰信息。

**表 1**  GLOBAL\_GET\_BGWRITER\_STATUS字段

node_name text 实例名称。
bgwr_actual_flush_total_num bigint 从启动到当前时间bgwriter线程总计刷脏页数量。
bgwr_last_flush_num integer bgwriter线程上一批刷脏页数量。
candidate_slots integer 当前候选buffer链中页面个数。
get_buffer_from_list bigint buffer淘汰从候选buffer链中获取页面的次数。
get_buffer_clock_sweep bigint buffer淘汰从原淘汰方案中获取页面的次数。
