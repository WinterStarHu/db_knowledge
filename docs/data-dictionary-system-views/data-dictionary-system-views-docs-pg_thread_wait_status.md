# PG\_THREAD\_WAIT\_STATUS

通过PG\_THREAD\_WAIT\_STATUS视图可以检测当前实例中工作线程（backend thread）、辅助线程（auxiliary thread）以及资源池化DMS线程（MES，需开启GUC参数 `ss_enable_dynamic_trace`）的阻塞等待情况。

**表 1**  PG\_THREAD\_WAIT\_STATUS字段

node_name text 当前节点的名称。
db_name text 数据库名称。
thread_name text 线程名称。
query_id bigint 查询ID，对应debug_query_id。
tid bigint 当前线程的线程号。
sessionid bigint 当前会话ID。
lwtid integer 当前线程的轻量级线程号。
psessionid bigint 父会话ID。
tlevel integer streaming线程的层级。
smpid integer 并行线程的ID。
wait_status text 当前线程的等待状态。等待状态的详细信息请参见表2。
wait_event text 如果wait_status是acquire lock、acquire lwlock、wait io三种类型，此列描述具体的锁、轻量级锁、IO的信息。否则是空。
locktag text 当前线程正在等待锁的信息。
lockmode text 当前线程正等待获取的锁模式。包含表级锁、行级锁、页级锁下的各模式。
block_sessionid bigint 阻塞当前线程获取锁的会话标识。
global_sessionid text 全局会话ID。

wait\_status列的等待状态有以下状态。

**表 2**  等待状态列表

wait_status值 none 没在等任意事件。
acquire lock 等待加锁，要么加锁成功，要么加锁等待超时。
acquire lwlock 等待获取轻量级锁。
wait io 等待IO完成。
wait cmd 等待完成读取网络通信包。
wait pooler get conn 等待pooler完成获取连接。
wait pooler abort conn 等待pooler完成终止连接。
wait pooler clean conn 等待pooler完成清理连接。
pooler create conn:\[nodename\], total N 等待pooler建立连接，当前正在与nodename指定节点建立连接，且仍有N个连接等待建立。
get conn 获取到其他节点的连接。
set cmd: [nodename] 在连接上执行SET/RESET/TRANSACTION BLOCK LEVEL PARA SET/SESSION LEVEL PARA SET，当前正在nodename指定节点上执行。
cancel query 取消某连接上正在执行的SQL语句。
stop query 停止某连接上正在执行的查询。
wait node: [nodename](plevel), total N, [phase] wait transaction sync: xid 等待xid指定事务同步。
wait wal sync 等待特定LSN的wal log完成到备机的同步。
wait data sync 等待完成数据页到备机的同步。
wait data sync queue 等待把行存的数据页或列存的CU放入同步队列。
flush data: \[nodename\](plevel), [phase] 等待向网络中nodename指定节点的plevel对应线程发送数据。如果状态包含phase信息，则可能的阶段状态为wait quota，即当前通信流正在等待quota值。
stream get conn: [nodename], total N 初始化stream flow时，等待与nodename节点的consumer对象建立连接，且当前有N个待建连对象。
wait producer \ready: [nodename\](plevel), total N 初始化stream flow时，等待每个producer都准备好，当前正在等待nodename节点plevel对应线程的producer对象准备好，且仍有N个producer对象处于等待状态。
synchronize quit stream plan结束时，等待stream线程组内的线程统一退出。
wait stream nodegroup destroy stream plan结束时，等待销毁stream node group。
wait active statement 等待作业执行，正在资源负载管控中。
analyze: [relname], [phase] 当前正在对表relname执行analyze。如果状态包含phase信息，则为autovacuum，表示是数据库自动开启AutoVacuum线程执行的analyze分析操作。
vacuum: [relname], [phase] 当前正在对表relname执行vacuum。如果状态包含phase信息，则为autovacuum，表示是数据库自动开启AutoVacuum线程执行的vacuum清理操作。
vacuum full: [relname] 当前正在对表relname执行vacuum full清理。
create index 当前正在创建索引。
HashJoin - [ build hash | write file ] HashAgg - [ build hash | write file ] HashSetop - [build hash | write file ] Sort | Sort - [fetch tuple | write file] 当前是Sort算子做排序，fetch tuple表示Sort算子正在获取tuple，write file表示Sort算子正在将数据写入磁盘。
Material | Material - write file 当前是Material算子，write file表示Material算子正在将数据写入磁盘。
NestLoop 当前是NestLoop算子。
wait memory 等待内存获取。
wait sync consumer next step Stream算子等待消费者执行。
wait sync producer next step Stream算子等待生产者执行。
wait reserve td 等待分配Ustore事务槽。

当wait\_status为acquire lwlock、acquire lock或者wait io时，表示有等待事件。正在等待获取wait\_event列对应类型的轻量级锁、事务锁，或者正在进行IO。

其中，wait\_status值为acquire lwlock（轻量级锁）时对应的wait\_event等待事件类型与描述信息如下。（wait\_event为Extension时，表示此时的轻量级锁是动态分配的锁，未被监控。）

**表 3**  轻量级锁等待事件列表

wait_event类型 类型描述 ShmemIndexLock 用于保护共享内存中的主索引哈希表。
OidGenLock 用于避免不同线程产生相同的OID。
XidGenLock 用于避免两个事务获得相同的xid。
ProcArrayLock 用于避免并发访问或修改ProcArray共享数组。
SInvalReadLock 用于避免与清理失效消息并发执行。
SInvalWriteLock 用于避免与其它写失效消息、清理失效消息并发执行。
WALInsertLock 用于避免与其它WAL插入操作并发执行。
WALWriteLock 用于避免并发WAL写盘。
ControlFileLock 用于避免pg_control文件的读写并发、写写并发。
CheckpointLock 用于避免多个checkpoint并发执行。
CLogControlLock 用于避免并发访问或者修改Clog控制数据结构。
SubtransControlLock 用于避免并发访问或者修改子事务控制数据结构。
MultiXactGenLock 用于串行分配唯一MultiXact id。
MultiXactOffsetControlLock 用于避免对pg_multixact/offset的写写并发和读写并发。
MultiXactMemberControlLock 用于避免对pg_multixact/members的写写并发和读写并发。
RelCacheInitLock 用于失效消息场景对init文件进行操作时加锁。
CheckpointerCommLock 用于向checkpointer发起文件刷盘请求场景，需要串行的向请求队列插入请求结构。
TwoPhaseStateLock 用于避免并发访问或者修改两阶段信息共享数组。
TablespaceCreateLock 用于确定tablespace是否已经存在。
BtreeVacuumLock 用于防止vacuum清理B-tree中还在使用的页面。
AutovacuumLock 用于串行化访问autovacuum worker数组。
AutovacuumScheduleLock 用于串行化分配需要vacuum的table。
AutoanalyzeLock 用于获取和释放允许执行Autoanalyze的任务资源。
SyncScanLock 用于确定heap扫描时某个relfilenode的起始位置。
NodeTableLock 用于保护存放数据库节点信息的共享结构。
PoolerLock 用于保证两个线程不会同时从连接池里取到相同的连接。
RelationMappingLock 用于等待更新系统表到存储位置之间映射的文件。
AsyncCtlLock 用于避免并发访问或者修改共享通知状态。
AsyncQueueLock 用于避免并发访问或者修改共享通知信息队列。
SerializableXactHashLock 用于避免对于可串行事务共享结构的写写并发和读写并发。
SerializableFinishedListLock 用于避免对于已完成可串行事务共享链表的写写并发和读写并发。
SerializablePredicateLockListLock 用于保护对于可串行事务持有的锁链表。
OldSerXidLock 用于保护记录冲突可串行事务的结构。
FileStatLock 用于保护存储统计文件信息的数据结构。
SyncRepLock 用于在主备复制时保护xlog同步信息。
DataSyncRepLock 用于在主备复制时保护数据页同步信息。
CStoreColspaceCacheLock 用于保护列存表的CU空间分配。
CStoreCUCacheSweepLock 用于列存CU Cache循环淘汰。
MetaCacheSweepLock 用于元数据循环淘汰。
ExtensionConnectorLibLock 用于初始化ODBC连接场景，在加载与卸载特定动态库时进行加锁。
SearchServerLibLock 用于GPU加速场景初始化加载特定动态库时，对读文件操作进行加锁。
LsnXlogChkFileLock 用于串行更新特定结构中记录的主备机的xlog flush位置点。
ReplicationSlotAllocationLock 用于主备复制时保护主机端的流复制槽的分配。
ReplicationSlotControlLock 用于主备复制时避免并发更新流复制槽状态。
ResourcePoolHashLock 用于避免并发访问或者修改资源池哈希表。
WorkloadStatHashLock 用于避免并发访问或者修改包含数据库主节点的SQL请求构成的哈希表。
WorkloadIoStatHashLock 用于避免并发访问或者修改用于统计当前数据库节点的IO信息的哈希表。
WorkloadCGroupHashLock 用于避免并发访问或者修改Cgroup信息构成的哈希表。
OBSGetPathLock 用于避免对obs路径的写写并发和读写并发。
WorkloadUserInfoLock 用于避免并发访问或修改负载管理的用户信息哈希表。
WorkloadRecordLock 用于避免并发访问或修改在内存自适应管理时对数据库主节点收到请求构成的哈希表。
WorkloadIOUtilLock 用于保护记录iostat，CPU等负载信息的结构。
WorkloadNodeGroupLock 用于避免并发访问或者修改内存中的nodegroup信息构成的哈希表。
JobShmemLock 用于定时任务功能中保护定时读取的全局变量。
OBSRuntimeLock 用于获取环境变量，如GASSHOME。
LLVMDumpIRLock 用于导出动态生成函数所对应的汇编语言。
LLVMParseIRLock 用于在查询开始处从IR文件中编译并解析已写好的IR函数。
CriticalCacheBuildLock 用于从共享或者本地缓存初始化文件中加载cache的场景。
WaitCountHashLock 用于保护用户语句计数功能场景中的共享结构。
BufMappingLock 用于保护对共享缓冲映射表的操作。
LockMgrLock 用于保护常规锁结构信息。
PredicateLockMgrLock 用于保护可串行事务锁结构信息。
OperatorRealTLock 用于避免并发访问或者修改记录算子级实时数据的全局结构。
OperatorHistLock 用于避免并发访问或者修改记录算子级历史数据的全局结构。
SessionRealTLock 用于避免并发访问或者修改记录query级实时数据的全局结构。
SessionHistLock 用于避免并发访问或者修改记录query级历史数据的全局结构。
CacheSlotMappingLock 用于保护CU Cache全局信息。
BarrierLock 用于保证当前只有一个线程在创建Barrier。
dummyServerInfoCacheLock 用于保护缓存加速openGauss连接信息的全局哈希表。
RPNumberLock 用于加速openGauss的数据库节点对正在执行计划的任务线程的计数。
CBMParseXlogLock Cbm解析xlog时的保护锁。
RelfilenodeReuseLock 避免错误地取消已重用的列属性文件的链接。
RcvWriteLock 防止并发调用WalDataRcvWrite。
PercentileLock 用于保护全局PercentileBuffer。
CSNBufMappingLock 保护csn页面。
UniqueSQLMappingLock 用于保护uniquesql hash table。
DelayDDLLock 防止并发ddl。
CLOG Ctl 用于避免并发访问或者修改Clog控制数据结构。
Async Ctl 保护Async buffer。
MultiXactOffset Ctl 保护MultiXact offet的slru buffer。
MultiXactMember Ctl 保护MultiXact member的slru buffer。
OldSerXid SLRU Ctl 保护old xids的slru buffer。
ReplicationSlotLock 用于保护ReplicationSlot。
PGPROCLock 用于保护pgproc。
MetaCacheLock 用于保护MetaCache。
DataCacheLock 用于保护datacache。
InstrUserLock 用于保护InstrUserHTAB。
BadBlockStatHashLock 用于保护global_bad_block_stat hash表。
BufFreelistLock 用于保证共享缓冲区空闲列表操作的原子性。
CUSlotListLock 用于控制列存缓冲区槽位的并发操作。
AddinShmemInitLock 保护共享内存对象的初始化。
AlterPortLock 保护协调节点更改注册端口号的操作。
FdwPartitionCaheLock HDFS分区表缓冲区的管理锁。
DfsConnectorCacheLock DFSConnector缓冲区的管理锁。
DfsSpaceCacheLock HDFS表空间管理缓冲区的管理锁。
FullBuildXlogCopyStartPtrLock 用于保护全量Build中Xlog拷贝的操作。
DfsUserLoginLock 用于HDFS用户登录以及认证。
LogicalReplicationSlotPersistentDataLock 用于保护逻辑复制过程中复制槽位的数据。
WorkloadSessionInfoLock 保护负载管理session info内存hash表访问。
InstrWorkloadLock 保护负载管理统计信息的内存hash表访问。
PgfdwLock 用于管理实例向Foreign server建立连接。
InstanceTimeLock 用于获取实例中会话的时间信息。
XlogRemoveSegLock 保护Xlog段文件的回收操作。
DnUsedSpaceHashLock 用于更新会话对应的空间使用信息。
CsnMinLock 用于计算CSNmin。
GPCCommitLock 用于保护全局Plan Cache hash表的添加操作。
GPCClearLock 用于保护全局Plan Cache hash表的清除操作。
GPCTimelineLock 用于保护全局Plan Cache hash表检查Timeline的操作。
TsTagsCacheLock 用于时序tag缓存管理。
InstanceRealTLock 用于保护共享实例统计信息hash表的更新操作。
CLogBufMappingLock 用于提交日志缓存管理。
GPCMappingLock 用于全局Plan Cache缓存管理。
GPCPrepareMappingLock 用于全局Plan Cache缓存管理。
BufferIOLock 保护共享缓冲区页面的IO操作。
BufferContentLock 保护共享缓冲区页面内容的读取、修改。
CSNLOG Ctl 用于CSN日志管理。
DoubleWriteLock 用于双写的管理操作。
RowPageReplicationLock 用于管理行存储的数据页复制。
Extension 其他轻量锁。

当wait\_status值为wait io时对应的wait\_event等待事件类型与描述信息如下。

**表 4**  IO等待事件列表

wait_event类型 类型描述 BufFileRead 从临时文件中读取数据到指定buffer。
BufFileWrite 向临时文件中写入指定buffer中的内容。
ControlFileRead 读取pg_control文件。主要在数据库启动、执行checkpoint和主备校验过程中发生。
ControlFileSync 将pg_control文件持久化到磁盘。数据库初始化时发生。
ControlFileSyncUpdate 将pg_control文件持久化到磁盘。主要在数据库启动、执行checkpoint和主备校验过程中发生。
ControlFileWrite 写入pg_control文件。数据库初始化时发生。
ControlFileWriteUpdate 更新pg_control文件。主要在数据库启动、执行checkpoint和主备校验过程中发生。
CopyFileRead copy文件时读取文件内容。
CopyFileWrite copy文件时写入文件内容。
DataFileExtend 扩展文件时向文件写入内容。
DataFileFlush 将表数据文件持久化到磁盘。
DataFileImmediateSync 将表数据文件立即持久化到磁盘。
DataFilePrefetch 异步读取表数据文件。
DataFileRead 同步读取表数据文件。
DataFileSync 将表数据文件的修改持久化到磁盘。
DataFileTruncate 表数据文件truncate。
DataFileWrite 向表数据文件写入内容。
LockFileAddToDataDirRead 读取“postmaster.pid”文件。
LockFileAddToDataDirSync 将“postmaster.pid”内容持久化到磁盘。
LockFileAddToDataDirWrite 将pid信息写到“postmaster.pid”文件。
LockFileCreateRead 读取LockFile文件“%s.lock”。
LockFileCreateSync 将LockFile文件“%s.lock”内容持久化到磁盘。
LockFileCreateWRITE 将pid信息写到LockFile文件“%s.lock”。
RelationMapRead 读取系统表到存储位置之间的映射文件。
RelationMapSync 将系统表到存储位置之间的映射文件持久化到磁盘。
RelationMapWrite 写入系统表到存储位置之间的映射文件。
ReplicationSlotRead 读取流复制槽文件。重新启动时发生。
ReplicationSlotRestoreSync 将流复制槽文件持久化到磁盘。重新启动时发生。
ReplicationSlotSync checkpoint时将流复制槽临时文件持久化到磁盘。
ReplicationSlotWrite checkpoint时写流复制槽临时文件。
SLRUFlushSync 将pg_clog、pg_subtrans和pg_multixact文件持久化到磁盘。主要在执行checkpoint和数据库停机时发生。
SLRURead 读取pg_clog、pg_subtrans和pg_multixact文件。
SLRUSync 将脏页写入文件pg_clog、pg_subtrans和pg_multixact并持久化到磁盘。主要在执行checkpoint和数据库停机时发生。
SLRUWrite 写入pg_clog、pg_subtrans和pg_multixact文件。
TimelineHistoryRead 读取timeline history文件。在数据库启动时发生。
TimelineHistorySync 将timeline history文件持久化到磁盘。在数据库启动时发生。
TimelineHistoryWrite 写入timeline history文件。在数据库启动时发生。
TwophaseFileRead 读取pg_twophase文件。在两阶段事务提交、两阶段事务恢复时发生。
TwophaseFileSync 将pg_twophase文件持久化到磁盘。在两阶段事务提交、两阶段事务恢复时发生。
TwophaseFileWrite 写入pg_twophase文件。在两阶段事务提交、两阶段事务恢复时发生。
WALBootstrapSync 将初始化的WAL文件持久化到磁盘。在数据库初始化发生。
WALBootstrapWrite 写入初始化的WAL文件。在数据库初始化发生。
WALCopyRead 读取已存在的WAL文件并进行复制时产生的读操作。在执行归档恢复完后发生。
WALCopySync 将复制的WAL文件持久化到磁盘。在执行归档恢复完后发生。
WALCopyWrite 读取已存在WAL文件并进行复制时产生的写操作。在执行归档恢复完后发生。
WALInitSync 将新初始化的WAL文件持久化磁盘。在日志回收或写日志时发生。
WALInitWrite 将新创建的WAL文件初始化为0。在日志回收或写日志时发生。
WALRead 从xlog日志读取数据。两阶段文件redo相关的操作产生。
WALSyncMethodAssign 将当前打开的所有WAL文件持久化到磁盘。
WALWrite 写入WAL文件。
WALBufferAccess WAL Buffer访问（出于性能考虑，内核代码里只统计访问次数，未统计其访问耗时）。
WALBufferFull WAL Buffer满时，写wal文件相关的处理。
DoubleWriteFileRead 双写 文件读取。
DoubleWriteFileSync 双写 文件强制刷盘。
DoubleWriteFileWrite 双写 文件写入。
PredoProcessPending 并行日志回放中当前记录回放等待其它记录回放完成。
PredoApply 并行日志回放中等待当前工作线程等待其他线程回放至本线程LSN。
DisableConnectFileRead HA锁分片逻辑文件读取。
DisableConnectFileSync HA锁分片逻辑文件强制刷盘。
DisableConnectFileWrite HA锁分片逻辑文件写入。

当wait\_status值为acquire lock（事务锁）时对应的wait\_event等待事件类型与描述信息如下。

**表 5**  事务锁等待事件列表

wait_event类型 类型描述 relation 对表加锁。
extend 对表扩展空间时加锁。
partition 对分区表加锁。
partition_seq 对分区表的分区加锁。
page 对表页面加锁。
tuple 对页面上的tuple加锁。
transactionid 对事务ID加锁。
virtualxid 对虚拟事务ID加锁。
object 加对象锁。
cstore_freespace 对列存空闲空间加锁。
userlock 加用户锁。
advisory 加advisory锁。
