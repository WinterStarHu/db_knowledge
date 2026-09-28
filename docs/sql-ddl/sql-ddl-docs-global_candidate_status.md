# GLOBAL\_CANDIDATE\_STATUS

GLOBAL\_CANDIDATE\_STATUS视图显示整个数据库所有实例候选buffer个数，buffer淘汰信息。

**表 1**  GLOBAL\_GET\_BGWRITER\_STATUS字段

node_name text 节点名称。
candidate_slots integer 当前Normal Buffer Pool候选buffer链中页面个数。
get_buf_from_list bigint Normal Buffer Pool，buffer淘汰从候选buffer链中获取页面的次数。
get_buf_clock_sweep bigint Normal Buffer Pool，buffer淘汰从原淘汰方案中获取页面的次数。
seg_candidate_slots integer 当前Segment Buffer Pool候选buffer链中页面个数。
seg_get_buf_from_list bigint Segment Buffer Pool，buffer淘汰从候选buffer链中获取页面的次数。
seg_get_buf_clock_sweep bigint Segment Buffer Pool，buffer淘汰从原淘汰方案中获取页面的次数。
