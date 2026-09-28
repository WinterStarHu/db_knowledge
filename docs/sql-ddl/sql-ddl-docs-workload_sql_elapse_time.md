# WORKLOAD\_SQL\_ELAPSE\_TIME

WORKLOAD\_SQL\_ELAPSE\_TIME用来统计workload（业务负载）上的SUID信息。

**表 1**  WORKLOAD\_SQL\_ELAPSE\_TIME字段

workload name workload（业务负载）名称。
total_select_elapse bigint 总select的时间花费（单位：微秒）。
max_select_elapse bigint 最大select的时间花费（单位：微秒）。
min_select_elapse bigint 最小select的时间花费（单位：微秒）。
avg_select_elapse bigint 平均select的时间花费（单位：微秒）。
total_update_elapse bigint 总update的时间花费（单位：微秒）。
max_update_elapse bigint 最大update的时间花费（单位：微秒）。
min_update_elapse bigint 最小update的时间花费（单位：微秒）。
avg_update_elapse bigint 平均update的时间花费（单位：微秒）。
total_insert_elapse bigint 总insert的时间花费（单位：微秒）。
max_insert_elapse bigint 最大insert的时间花费（单位：微秒）。
min_insert_elapse bigint 最小insert的时间花费（单位：微秒）。
avg_insert_elapse bigint 平均insert的时间花费（单位：微秒）。
total_delete_elapse bigint 总delete的时间花费（单位：微秒）。
max_delete_elapse bigint 最大delete的时间花费（单位：微秒）。
min_delete_elapse bigint 最小delete的时间花费（单位：微秒）。
avg_delete_elapse bigint 平均delete的时间花费（单位：微秒）。
