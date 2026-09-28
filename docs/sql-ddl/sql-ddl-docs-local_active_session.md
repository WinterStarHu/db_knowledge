# LOCAL\_ACTIVE\_SESSION

LOCAL\_ACTIVE\_SESSION视图显示本节点上的ACTIVE SESSION PROFILE内存中的样本。

**表 1**  LOCAL\_ACTIVE\_SESSION字段

sampleid bigint 采样ID。
sample_time timestamp with time zone 采样的时间。
need_flush_sample boolean 该样本是否需要刷新的磁盘。
databaseid oid 数据库ID。
thread_id bigint 线程的ID。
sessionid bigint 会话的ID。
start_time timestamp with time zone 会话的启动时间。
event text 具体的事件名称。
lwtid integer 当前线程的轻量级线程号。
psessionid bigint streaming线程的父线程。
tlevel integer streaming线程的层级。与执行计划的层级（ID）相对应。
smpid integer smp执行模式下并行线程的并行编号。
userid oid session用户的ID。
application_name text 应用的名称。
client_addr inet client端的地址。
client_hostname text client端的名称。
client_port integer 客户端用于与后端通讯的TCP端口号。
query_id bigint debug query id。
unique_query_id bigint unique query id。
user_id oid unique query的key中的user_id。
cn_id integer cn id，在DN上表示下发该unique sql的节点id，unique query的key中的cn_id。
unique_query text 规范化后的UniqueSQL文本串。
locktag text 会话等待锁信息，可通过locktag_decode解析。
lockmode text 会话等待锁模式。
block_sessionid bigint 如果会话正在等待锁，阻塞该会话获取锁的会话标识。
final_block_sessionid bigint 表示源头阻塞会话ID。
wait_status text 描述event列的更多详细信息。
global_sessionid text 全局会话ID。
xact_start_time timestamp with time zone 事务开始时间。
query_start_time timestamp with time zone 查询开始时间。
state text 状态。
