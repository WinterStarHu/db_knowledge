# INSTANCE\_TIME

提供当前节点下的各种时间消耗信息，主要分为以下类型：

- DB\_TIME：作业在多核下的有效时间花销。
- CPU\_TIME：CPU的时间花销。
- EXECUTION\_TIME：执行器内的时间花销。
- PARSE\_TIME：SQL解析的时间花销。
- PLAN\_TIME：生成Plan的时间花销。
- REWRITE\_TIME：SQL重写的时间花销。
- PL\_EXECUTION\_TIME：plpgsql（存储过程）执行的时间花销。
- PL\_COMPILATION\_TIME：plpgsql（存储过程）编译的时间花销。
- NET\_SEND\_TIME：网络上的时间花销。
- DATA\_IO\_TIME：IO上的时间花销。
- SRT1_Q: Q报文执行的耗时
- SRT2_SIMPLE_QUERY: exec_simple_query执行耗时
- SRT3_ANALYZE_REWRITE: pg_analyze_and_rewrite执行耗时
- SRT4_PLAN_QUERY: pg_plan_queries执行耗时
- SRT5_LIGHT_QUERY: exec_query_through_light_proxy执行耗时
- SRT6_P：P报文执行的耗时
- SRT7_B：B报文执行的耗时
- SRT8_E：E报文执行的耗时
- SRT9_D：D报文执行的耗时
- SRT10_S：S报文执行的耗时
- SRT11_C：C报文执行的耗时
- SRT12_U：U报文执行的耗时
- SRT13_BEFORE_QUERY：进入下一次报文处理前的耗时
- SRT14_AFTER_QUERY: 完成报文处理后的耗时
- RTT_UNKNOWN: 未知时间消耗，可能是session切换耗时。

**表 1**  INSTANCE\_TIME字段

stat_id integer 统计编号。
stat_name text 类型名称。
value bigint 时间值（单位：微秒）。
