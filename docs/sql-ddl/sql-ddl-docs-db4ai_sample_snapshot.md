# DB4AI.SAMPLE\_SNAPSHOT

SAMPLE\_SNAPSHOT是DB4AI特性用于对基数据进行采样生成快照的接口函数。通过语法SAMPLE SNAPSHOT调用。

**表 1**  DB4AI.SAMPLE\_SNAPSHOT入参和返回值列表

i_schema IN NAME 快照存储的模式名字 i_parent IN NAME 父快照名称 i_sample_infixes IN NAME[] 示例快照名称中缀 i_sample_ratios IN NUMBER[] 每个样本的大小，作为父集的比率 i_stratify IN NAME[] 分层策略 i_sample_comments IN TEXT[] 示例快照描述 res OUT  db4ai.snapshot_name
