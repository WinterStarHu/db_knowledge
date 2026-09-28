# GS\_TOTAL\_MEMORY\_DETAIL

GS\_TOTAL\_MEMORY\_DETAIL视图统计当前数据库节点使用内存的信息，单位为MB。当GUC参数enable\_memory\_limit的值为off时，本视图不可用。

**表 1**  GS\_TOTAL\_MEMORY\_DETAIL字段

nodename text 节点名称。
memorytype text memorymbytes integer 内存类型分配内存的大小。
