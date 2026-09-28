# Time Model

Time Model名称及描述如下表所示。

**表 1**  Time Model报表主要内容

DB_TIME 所有线程端到端的墙上时间（WALL TIME）消耗总和（单位：微秒）。
EXECUTION_TIME 消耗在执行器上的时间总和（单位：微秒)。
PL_EXECUTION_TIME 消耗在PL/SQL执行上的时间总和（单位：微秒）。
CPU_TIME 所有线程CPU时间消耗总和（单位：微秒）。
PLAN_TIME 消耗在执行计划生成上的时间总和（单位：微秒）。
REWRITE_TIME 消耗在查询重写上的时间总和（单位：微秒）。
PL_COMPILATION_TIME 消耗在SQL编译上的时间总和（单位：微秒）。
PARSE_TIME 消耗在SQL解析上的时间总和（单位：微秒）。
NET_SEND_TIME 消耗在网络发送上的时间总和（单位：微秒）。
DATA_IO_TIME 消耗在数据读写上的时间总和（单位：微秒）。
SRT1_Q Q报文执行的耗时（单位：微秒）。
SRT2_SIMPLE_QUERY exec_simple_query执行耗时（单位：微秒）。
SRT3_ANALYZE_REWRITE pg_analyze_and_rewrite执行耗时（单位：微秒）。
SRT4_PLAN_QUERY pg_plan_queries执行耗时（单位：微秒）。
SRT5_LIGHT_QUERY exec_query_through_light_proxy执行耗时（单位：微秒）。
SRT6_P P报文执行的耗时（单位：微秒）。
SRT7_B B报文执行的耗时（单位：微秒）。
SRT8_E E报文执行的耗时（单位：微秒）。
SRT9_D D报文执行的耗时（单位：微秒）。
SRT10_S S报文执行的耗时（单位：微秒）。
SRT11_C C报文执行的耗时（单位：微秒）。
SRT12_U U报文执行的耗时（单位：微秒）。
SRT13_BEFORE_QUERY 进入下一次报文处理前的耗时（单位：微秒）。
SRT14_AFTER_QUERY 完成报文处理后的耗时（单位：微秒）。
RTT_UNKNOWN 未知时间消耗，可能是session切换耗时（单位：微秒）。
NET_TRANS_TIME 驱动执行sql的全链路网络耗时，当前仅支持jdbc驱动。（单位：微秒）
