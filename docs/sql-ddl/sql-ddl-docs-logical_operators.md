# 逻辑操作符

常用的逻辑操作符有AND、OR和NOT，他们的运算结果有三个值，分别为TRUE、FALSE和NULL，其中NULL代表未知。他们运算优先级顺序为：NOT\>AND\>OR。

运算规则请参见[表1](#zh-cn_topic_0283137740_zh-cn_topic_0237121965_zh-cn_topic_0059778733_zh-cn_topic_0058966260_table261968)，表中的a和b代表逻辑表达式。

**表 1**  运算规则表

a AND b的结果 a OR b的结果 NOT a的结果 TRUE TRUE TRUE TRUE FALSE TRUE FALSE FALSE TRUE FALSE TRUE NULL NULL TRUE FALSE FALSE FALSE FALSE FALSE TRUE FALSE NULL FALSE NULL TRUE NULL NULL NULL NULL NOT NULL

>[!NOTE]说明
>
>操作符AND和OR具有交换性，即交换左右两个操作数，不影响其结果。

示例请参见[示例](./brief_tutorial/where_clause.md#zh-cn_topic_0000001225258419_section36861642133019)。
