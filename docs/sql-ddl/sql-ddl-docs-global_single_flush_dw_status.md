# GLOBAL\_SINGLE\_FLUSH\_DW\_STATUS

GLOBAL\_SINGLE\_FLUSH\_DW\_STATUS视图显示数据库所有实例单页面淘汰双写文件信息。展示内容中，/前是第一个版本双写文件刷页情况，/后是第二个版本双写文件刷页情况。

**表 1**  GLOBAL\_SINGLE\_FLUSH\_DW\_STATUS字段

node_name text 实例名称。
curr_dwn text 当前双写文件的序列号。
curr_start_page text 当前双写文件start位置。
total_writes text 当前双写文件总计写数据页面个数。
file_trunc_num text 当前双写文件复用的次数。
file_reset_num text 当前双写文件写满后发生重置的次数。
