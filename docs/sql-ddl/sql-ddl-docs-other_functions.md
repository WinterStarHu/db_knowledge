# 其它函数

- plan\_seed\(\)

描述：获取前一次查询语句的seed值（内部使用）。

返回值类型：int

- pg\_stat\_get\_env\(\)

描述：获取当前节点的环境变量信息，仅sysadmin和monitor admin可以访问。

返回值类型：record

示例：

    ```
    openGauss=# select pg_stat_get_env();
                                                                                  pg_stat_get_env
    ---------------------------------------------------------------------------------------------------------------------------------------
     (coordinator1,localhost,144773,49100,/data1/openGauss_TRUNK/install,/data1/openGauss_TRUNK/install/data/coordinator1,pg_log)
    (1 row)
    ```

- pg\_catalog.plancache\_clean\(\)

描述：清理节点上无人使用的全局计划缓存。

返回值类型：bool

- pg\_catalog.plancache\_status\(\)

描述：显示节点上全局计划缓存的信息，函数返回信息和[GLOBAL\_PLANCACHE\_STATUS](global_plancache_status.md)一致。

返回值类型：record

- textlen\(text\)

描述：提供查询text的逻辑长度的方法。

返回值类型：int

- threadpool\_status\(\)

描述：显示线程池中工作线程及会话的状态信息。

返回值类型：record

- get\_local\_active\_session\(\)

描述：提供当前节点保存在内存中的历史活跃session状态的采样记录。

返回值类型：record

- pg\_stat\_get\_thread\(\)

描述：提供当前节点下所有线程的状态信息，sysadmin和monitor admin用户可以查看所有线程信息，普通用户查看本用户的线程信息。

返回值类型：record

- pg\_stat\_get\_sql\_count\(\)

描述：提供当前节点中用户执行的SELECT/UPDATE/INSERT/DELETE/MERGE INTO语句的计数结果，sysadmin和monitor admin用户可以查看所有用户的信息，普通用户查看本用户的统计信息。

返回值类型：record

- pg\_stat\_get\_data\_senders\(\)

描述：提供当前活跃的数据复制发送线程的详细信息。

返回值类型：record

- get\_wait\_event\_info\(\)

描述：提供wait event事件的具体信息。

返回值类型：record

- generate\_wdr\_report\(begin\_snap\_id bigint, end\_snap\_id bigint, report\_type cstring, report\_scope cstring, node\_name cstring\)

描述：基于两个snapshot生成系统诊断报告。需要在postgres库下执行，默认初始化用户或monadmin用户可以访问，V500R001C20SPC002及其之前的版本初始化用户或sysadmin用户可以访问。只可在系统库中查询到结果，用户库中无法查询。

返回值类型：record

**表 1**  generate\_wdr\_report 参数说明

取值范围 begin_snap_id 生成某段时间内性能诊断报告的开始snapshotid。
end_snap_id 结束snapshot的id，默认end_snap_id大于begin_snap_id。
report_type 指定生成report的类型。
summarydetailall，即同时包含summary 和 detail。
report_scope 指定生成report的范围。
cluster：数据库级别的信息node：节点级别的信息 node_name 在report_scope指定为node时，需要把该参数指定为对应节点的名称。（节点名称可以执行select * from pg_node_env;查询）。
在report_scope为cluster时，该值可以省略或者指定为空或NULL。
cluster：省略/空/NULLnode： openGauss中的节点名称

- create\_wdr\_snapshot\(\)

描述：手工生成系统诊断快照，该函数需要sysadmin权限。可在单机节点或集群主节点上执行。

返回值类型：text

- kill\_snapshot\(\)

描述：kill后台的WDR snapshot线程，调用该函数的用户需要具有SYSADMIN权限或具有REPLICATION权限或继承了内置角色gs\_role\_replication的权限。

返回值类型：void

- capture\_view\_to\_json\(text,integer\)

描述：将视图的结果存入GUC: perf\_directory所指定的目录，如果is\_crossdb为1，则表示对于所有的database都会访问一次view；如果is\_crossdb为0，则表示仅对当前database进行一次视图访问。该函数只有sysadmin和monitor admin用户可以执行。

返回值类型：int

- reset\_unique\_sql

描述：用来清理数据库节点内存中的Unique SQL（需要sysadmin权限）。

返回值类型：bool

**表 2**  reset\_unique\_sql参数说明

scope text 清理范围类型： 'GLOBAL'：清理所有的节点，如果是'GLOBAL'，则只可以为主节点执行此函数。'LOCAL'：清理本节点。
clean_type text 'BY_USERID'：按用户ID来进行清理Unique SQL。'BY_CNID'：按主节点的ID来进行清理Unique SQL。'ALL'：全部清理。
clean_value int8 具体清理type对应的清理值。

>[!TIP]须知
>
>- scope的取值GLOBAL和LOCAL针对分布式，对于openGauss而言两者意义相同，均表示清理本节点。
>
>- clean\_type的值BY\_CNID仅针对分布式，对于openGauss无效。

- wdr\_xdb\_query\(db\_name\_str text, query text\)

描述：提供本地跨数据库执行query的能力。例如: 在连接到postgres库时, 访问test库下的表。

    ```
    select col1 from wdr_xdb_query('dbname=test','select col1 from t1') as dd(col1 int);
    ```

返回值类型：record

- pg\_wlm\_jump\_queue\(pid int\)

描述：调整任务到数据库主节点队列的最前端。

返回值类型：boolean

  - true：成功。
  - false：失败。

- gs\_wlm\_switch\_cgroup\(pid int, cgroup text\)

描述：调整作业的优先级到新控制组。

返回值类型：boolean

  - true：成功。
  - false：失败。

- pv\_session\_memctx\_detail\(threadid tid, MemoryContextName text\)

描述：将线程tid的MemoryContextName内存上下文信息记录到“$GAUSSLOG/pg\_log/$\{node\_name\}/dumpmem”目录下的“threadid\_timestamp.log”文件中。其中threadid可通过视图GS\_SESSION\_MEMORY\_DETAIL中的sessid后获得。在正式发布的版本中仅接受MemoryContextName为空串（两个单引号表示输入为空串，即''）的输入，此时会记录所有的内存上下文信息，否则不会有任何操作。对供内部开发人员和测试人员调试用的DEBUG版本，可以指定需要统计的MemoryContextName，此时会将该Context所有的内存使用情况记录到指定文件。该函数需要管理员权限的用户才能执行。

返回值类型：boolean

  - true：成功。
  - false：失败。

- pg\_shared\_memctx\_detail\(MemoryContextName text\)

描述：将MemoryContextName内存上下文信息记录到“$GAUSSLOG/pg\_log/$\{node\_name\}/dumpmem”目录下的“threadid\_timestamp.log”文件中。该函数功能仅在DEBUG版本中供内部开发人员和测试人员调试使用，在正式发布版本中调用该函数不会有任何操作。该函数需要管理员权限的用户才能执行。

返回值类型：boolean

  - true：成功。
  - false：失败。

- local\_bgwriter\_stat\(\)

描述：显示本实例的bgwriter线程刷页信息，候选buffer链中页面个数，buffer淘汰信息。

返回值类型：record

- local\_candidate\_stat\(\)

描述：显示本实例的候选buffer链中页面个数，buffer淘汰信息，包含normal buffer pool和segment buffer pool。

返回值类型：record

- local\_ckpt\_stat\(\)

描述：显示本实例的检查点信息和各类日志刷页情况。

返回值类型：record

- local\_double\_write\_stat\(\)

描述：显示本实例的双写文件的情况。

返回值类型：record

**表 3**  local\_double\_write\_stat参数说明

node_name text 实例名称。
curr_dwn int8 当前双写文件的序列号。
curr_start_page int8 当前双写文件恢复起始页面。
file_trunc_num int8 当前双写文件复用的次数。
file_reset_num int8 当前双写文件写满后发生重置的次数。
total_writes int8 当前双写文件总的I/O次数。
low_threshold_writes int8 低效率写双写文件的I/O次数（一次I/O刷页数量少于16页面）。
high_threshold_writes int8 高效率写双写文件的I/O次数（一次I/O刷页数量多于一批，421个页面）。
total_pages int8 当前刷页到双写文件区的总的页面个数。
low_threshold_pages int8 低效率刷页的页面个数。
high_threshold_pages int8 高效率刷页的页面个数。
file_id int8 当前双写文件的id号。

- local\_single\_flush\_dw\_stat\(\)

描述：显示本实例的单页面淘汰双写文件的情况。

返回值类型：record

- local\_pagewriter\_stat\(\)

描述：显示本实例的刷页信息和检查点信息。

返回值类型：record

- local\_redo\_stat\(\)

描述：显示本实例的备机的当前回放状态。

返回值类型：record

备注：返回的回放状态主要包括当前回放位置、回放最小恢复点位置等信息。

示例：

    ```sql
    openGauss=# select * from local_redo_stat();
     node_name | redo_start_ptr | redo_start_time | redo_done_time | curr_time | min_recovery_point | read_ptr | last_replayed_read_ptr | recovery_done_ptr | read_xlog_io_counter | read_xlog_io_total_dur | read_data_io_counter | read_data_io_total_dur | write_data_io_counter | write_data_io_total_dur | process_pending_counter | process_pending_total_dur | apply_counter | apply_total_dur | speed | local_max_ptr | primary_flush_ptr |   worker_info
    -----------+----------------+-----------------+----------------+-----------+--------------------+----------+------------------------+-------------------+----------------------+------------------------+----------------------+------------------------+-----------------------+-------------------------+-------------------------+---------------------------+---------------+-----------------+-------+---------------+-------------------+------------------
    ```

**表 4**  local\_double\_write\_stat参数说明

node_name text 实例名称。
redo_start_ptr int8 redo日志开始指针（LSN），表示redo操作的起始位置。
redo_start_time int8 redo操作开始时间。
redo_done_time int8 redo操作完成时间。
curr_time int8 显示当前查询的时间。
min_recovery_point int8 用于显示最小恢复点的LSN。
redo_ptr int8 当前正在读取位置的指针，用于标识redo日志读取的进度。
last_replayed_read_ptr int8 标识redo日志最后一次重放位置的指针。
recovery_done_ptr int8 标识恢复操作完成的位置指针。
read_xlog_io_counter int8 读取xlog IO 计数器，追踪读取redo日志的 IO 次数。
read_xlog_io_total_dur int8 读取 xlog IO 的总时长。
read_data_io_counter int8 读取数据 IO 计数器。
read_data_io_total_dur int8 读取数据 IO 总时长。
write_data_io_counter int8 写入数据 IO 计数器。
write_data_io_total_dur int8 写入数据 IO 总时长。
process_pending_counter int8 处理待定事物计数器。
process_pending_total_dur int8 处理待定事物总时长。
apply_counter int8 统计应用操作的次数。
apply_total_dur int8 显示应用操作所需要的总时间。
speed int8 redo操作的处理速度。
local_max_ptr int8 标识本地记录的最大 LSN 。
primary_flush_ptr int8 标识主节点上已写入到日志的最大位置。
worker_info text 显示当前 redo 工作线程的状态信息。

- local\_recovery\_status\(\)

描述：显示本实例的主机和备机的日志流控信息。

返回值类型：record

示例：

    ```sql
    openGauss=# select * from local_recovery_status();
     node_name | standby_node_name | source_ip | source_port | dest_ip | dest_port | current_rto | target_rto | current_sleep_time
    -----------+-------------------+-----------+-------------+---------+-----------+-------------+------------+--------------------
    ```

**表 5**  local\_recovery\_status参数说明

node_name text 实例名称。
standby_node_name text 备用节点名称。
source_ip text 源 IP 地址。表明数据同步或恢复操作的源节点的 IP 地址。源节点是指从主节点或服务器，从中提取数据进行恢复。
source_port text 源端口号。表明数据同步或恢复操作的源节点的端口号。用于网络通信中识别特定的服务或进程。
dest_ip text 目标 IP 地址。表明数据同步或恢复操作的目标节点的 IP 地址。目标节点是接收数据并进行恢复的节点。
dest_port text 目标端口号。表明数据同步或恢复操作的目标节点的端口号。
current_rto text 当前恢复时间目标（Recovery Time Objective，RTO）。
target_rto text 目标恢复时间目标。
current_sleep_time text 当前休眠时间。

- gs\_wlm\_node\_recover\(boolean isForce\)

描述：获取当前内存中记录的TopSQL查询语句级别相关统计信息，当传入的参数不为0时，会将这部分信息从内存中清理掉。

返回值类型：record

- gs_wlm_node_clean(cstring nodename)

描述：动态负载管理节点故障后做数据清理操作。该函数只有管理员用户可以执行，属于数据库实例管理模块调用的，不建议用户直接调用。该视图在集中式和单机环境上不支持。

返回值类型：bool

- gs\_cgroup\_map\_ng\_conf\(group name\)

描述：读取指定逻辑数据库的cgroup配置文件。

返回值类型：record

- gs\_wlm\_switch\_cgroup\(sess\_id int8, cgroup name\)

描述：切换指定会话的控制组。

返回值类型：record

- comm\_client\_info\(\)

描述：用于查询单个节点活跃的客户端连接信息。

返回值类型：setof record

- pg\_sync\_cstore\_delta\(text\)

描述：同步指定列存表的delta表表结构，使其与列存表主表一致。

返回值类型：bigint

- pg\_sync\_cstore\_delta\(\)

描述：同步所有列存表的delta表表结构，使其与列存表主表一致。

返回值类型：bigint

- pg\_get\_flush\_lsn\(\)

描述：返回当前节点flush的xlog位置。

返回值类型：text

- pg\_get\_sync\_flush\_lsn\(\)

描述：返回当前节点多数派flush的xlog位置。

返回值类型：text

- gs\_create\_log\_tables\(\)

描述：用于创建运行日志和性能日志的外表和视图。单机模式下不支持。

返回值类型：void

示例：

    ```
    openGauss=# select gs_create_log_tables();
     gs_create_log_tables
    ----------------------

    (1 row)
    ```

- dbe\_perf.get\_global\_full\_sql\_by\_timestamp\(start\_timestamp timestamp with time zone, end\_timestamp timestamp with time zone\)

描述：获取数据库级的全量SQL\(Full SQL\)信息。只可在系统库中查询到结果，用户库中无法查询。

返回值类型：record

**表 6**  dbe\_perf.get\_global\_full\_sql\_by\_timestamp参数说明

start_timestamp timestamp with time zone SQL启动时间范围的开始时间点。
end_timestamp timestamp with time zone SQL启动时间范围的结束时间点。

- dbe\_perf.get\_global\_slow\_sql\_by\_timestamp\(start\_timestamp timestamp with time zone, end\_timestamp timestamp with time zone\)

描述：获取数据库级的慢SQL\(Slow SQL\)信息。只可在系统库中查询到结果，用户库中无法查询。

返回值类型：record

**表 7**  dbe\_perf.get\_global\_slow\_sql\_by\_timestamp参数说明

start_timestamp timestamp with time zone SQL启动时间范围的开始时间点。
end_timestamp timestamp with time zone SQL启动时间范围的结束时间点。

- statement\_detail\_decode\(detail text, format text, pretty boolean\)

描述：解析全量/慢SQL语句中的details字段的信息。只可在系统库中查询到结果，用户库中无法查询。

返回值类型：text

**表 8**  statement\_detail\_decode参数说明

detail text SQL语句产生的事件的集合（不可读）。
format text 解析输出格式，取值为 plaintext。
pretty boolean

- get\_prepared\_pending\_xid

描述：当恢复完成时，返回nextxid。

参数：nan

返回值类型：text

- pg\_clean\_region\_info

描述：清理regionmap。

参数：nan

返回值类型：character varying

- pg\_get\_delta\_info

描述：从单个dn获取delta info。

参数：rel text、 schema\_name text

返回值类型：part\_name text、 live\_tuple bigint、 data\_size bigint、 blocknum bigint

- pg\_get\_replication\_slot\_name

描述：获取slot name。

参数：nan

返回值类型：text

- pg\_get\_running\_xacts

描述：获取运行中的xact。

参数：nan

返回值类型：handle integer、 gxid xid、 state tinyint、 node text、 xmin xid、 vacuum boolean、 timeline bigint、 prepare\_xid xid、 pid bigint、 next\_xid xid

- pg\_get\_variable\_info

描述：获取共享内存变量cache。

参数：nan

返回值类型：node\_name text、 nextOid oid、 nextXid xid、 oldestXid xid、 xidVacLimit xid、 oldestXidDB oid、 lastExtendCSNLogpage xid、 startExtendCSNLogpage xid、 nextCommitSeqNo xid、 latestCompletedXid xid、 startupMaxXid xid

- pg\_get\_xidlimit

描述：从共享内存获取事物id信息。

参数：nan

返回值类型：nextXid xid、 oldestXid xid、 xidVacLimit xid、 xidWarnLimit xid、 xidStopLimit xid、 xidWrapLimit xid、 oldestXidDB oid

- get\_global\_user\_transaction\(\)

描述：返回所有节点上各用户的事务相关信息。

返回值类型：node\_name name、 usename name、 commit\_counter bigint、 rollback\_counter bigint、 resp\_min bigint、 resp\_max bigint、 resp\_avg bigint、 resp\_total bigint、 bg\_commit\_counter bigint、 bg\_rollback\_counter bigint、 bg\_resp\_min bigint、 bg\_resp\_max bigint、 bg\_resp\_avg bigint、 bg\_resp\_total bigint

- pg\_collation\_for

描述：返回入参字符串对应的排序规则。

参数：any（如果是常量必须进行显式类型转换）

返回值类型：text

- pgxc\_unlock\_for\_sp\_database\(name Name\)

描述：目前该接口已废弃，暂不可用。

- pgxc\_lock\_for\_sp\_database\(name Name\)

描述：目前该接口已废弃，暂不可用。

- copy\_error\_log\_create\(\)

描述：创建COPY FROM容错机制所需要的错误表（public.pgxc\_copy\_error\_log）。

返回值类型：Boolean

>[!NOTE]说明
>
>- 此函数会尝试创建public.pgxc\_copy\_error\_log表，表的详细信息请参见[表6](#table138318280213)。
>
>- 在relname列上创建B-tree索引，并REVOKE ALL on public.pgxc\_copy\_error\_log FROM public对错误表进行权限控制（与COPY语句权限一致）。
>
>- 由于尝试创建的public.pgxc\_copy\_error\_log定义是一张行存表，因此数据库实例上必须支持行存表的创建才能够正常运行此函数，并使用后续的COPY容错功能。需要特别注意的是，enable\_hadoop\_env这个GUC参数开启后会禁止在数据库实例内创建行存表（openGauss默认为off）。
>
>- 此函数自身权限为Sysadmin及以上（与错误表、COPY权限一致）。
>
>- 若创建前public.pgxc\_copy\_error\_log表已存在或者copy\_error\_log\_relname\_idx索引已存在，则此函数会报错回滚。

**表 9**  错误表public.pgxc\_copy\_error\_log信息

列名称 relname character varying 表名称。以模式名.表名形式显示。
begintime timestamp with time zone 出现数据格式错误的时间。
filename character varying 出现数据格式错误的数据源文件名。
lineno bigint 在数据源文件中，出现数据格式错误的行号。
rawrecord text 在数据源文件中，出现数据格式错误的原始记录。
detail text 详细错误信息。

- dynamic\_func\_control\(scope text, function\_name text, action text, "\{params\}" text\[\]\)

描述：动态开启内置的功能，当前仅支持动态开启全量SQL。

返回值类型：record

**表 10**  dynamic\_func\_control参数说明

scope text 动态开启功能的范围，当前仅支持'LOCAL'。
function_name text 功能的名称，当前仅支持'STMT'。
action text params text[]

- gs\_parse\_page\_bypath\(path text, blocknum bigint, relation\_type text, read\_memory boolean\)

描述：用于解析指定表页面，并返回存放解析内容的路径。

返回值类型：text

备注：必须是系统管理员或运维管理员才能执行此函数。

示例：

  ```sql
  openGauss=# select * from gs_parse_page_bypath('base/16384/16391', -1, 'uheap', true);
                  output_filepath
    -------------------------------------------
  ```

**表 11**  gs\_parse\_page\_bypath参数说明

path text 对于普通表或段页式表，相对路径为：tablespace name/database oid/表的relfilenode(物理文件名)。例如：base/16603/16394。表文件的相对路径可以通过pg_relation_filepath(table_name text)查找。合法的path格式列举：global/relNodebase/dbNode/relNodepg_tblspc/spcNode/version_dir/dbNode/relNode blocknum bigint -1                                  所有block的信息0- MaxBlockNumber    对应block的信息 relation_type text heap(Astore 表)uheap(Ustore 表)btree_index(Btree 索引)ubtree_index(UBtree 索引)segment(段页式) read_memory boolean false，从磁盘文件解析。true，首先尝试从共享缓冲区中解析该页面；如果共享缓冲区中不存在，则从磁盘文件解析。

- gs\_xlogdump\_lsn\(start\_lsn text, end\_lsn text\)

描述：用于解析指定lsn范围之内的XLOG日志，并返回存放解析内容的路径。可以通过pg\_current\_xlog\_location\(\)获取当前XLOG位置。

返回值类型：text

参数：LSN起始位置，LSN结束位置

备注：必须是系统管理员或运维管理员才能执行此函数。

- gs\_xlogdump\_xid\(c\_xid xid\)

描述：用于解析指定xid的XLOG日志，并返回存放解析内容的路径。可以通过txid\_current\(\)获取当前事务ID。

参数：事务ID

返回值类型：text

备注：必须是系统管理员或运维管理员才能执行此函数。

- gs\_xlogdump\_tablepath\(path text, blocknum bigint, relation\_type text\)

描述：用于解析指定表页面对应的日志，并返回存放解析内容的路径。

返回值类型：text

备注：必须是系统管理员或运维管理员才能执行此函数。

示例：

  ```sql
  openGauss=# select * from gs_xlogdump_tablepath('base/16384/16391', -1, 'uheap');
                  output_filepath
    -------------------------------------------
  ```

**表 12**  gs\_xlogdump\_tablepath参数说明

path text 对于普通表或段页式表，相对路径为：tablespace name/database oid/表的relfilenode(物理文件名)。例如：base/16603/16394。表文件的相对路径可以通过pg_relation_filepath(table_name text)查找。合法的path格式列举：global/relNodebase/dbNode/relNodepg_tblspc/spcNode/version_dir/dbNode/relNode blocknum bigint -1                                  所有block的信息0- MaxBlockNumber    对应block的信息 relation_type text heap(Astore 表)uheap(Ustore 表)btree_index(Btree 索引)ubtree_index(UBtree 索引)segment(段页式)

- gs\_xlogdump\_parsepage\_tablepath\(path text, blocknum bigint, relation\_type text, read\_memory boolean\)

描述：用于解析指定表页面和表页面对应的日志，并返回存放解析内容的路径。可以看做一次执行gs\_parse\_page\_bypath和gs\_xlogdump\_tablepath。该函数执行的前置条件是表文件存在。如果想查看已删除的表的相关日志，请直接调用gs\_xlogdump\_tablepath。

返回值类型：text

备注：必须是系统管理员或运维管理员才能执行此函数。

**表 13**  gs\_xlogdump\_parsepage\_tablepath参数说明

path text 对于普通表或段页式表，相对路径为：tablespace name/database oid/表的relfilenode(物理文件名)；例如：base/16603/16394表文件的相对路径可以通过pg_relation_filepath(table_name text)查找。合法的path格式列举：global/relNodebase/dbNode/relNodepg_tblspc/spcNode/version_dir/dbNode/relNode blocknum bigint -1                                  所有block的信息0- MaxBlockNumber    对应block的信息 relation_type text heap(Astore 表)uheap(Ustore 表)btree_index(Btree 索引)ubtree_index(UBtree 索引)segment(段页式) read_memory boolean false，从磁盘文件解析true，首先尝试从共享缓冲区中解析该页面；如果共享缓冲区中不存在，则从磁盘文件解析

- gs\_index\_verify\(Oid oid, uint32:wq blkno\)

描述：用于校验UBtree索引页面或者索引树上key的顺序是否正确。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_index_verify(16388, 0);
    ptype   | blkno | status
  -----------+-------+--------
  main page |     0 | normal
  (1 row)
  ```

**表 14**  gs\_index\_verify参数说明

oid Oid 索引文件relfilenode,可以通过select relfilenode from pg_class where relname='name'查询，其中name表示对应的索引文件名字。
blkno uint32 0 ，表示检验整个索引树上所有页面。大于0，表示校验页面编码等于blkno的索引页面。
ptype text 页面类型（Page Type）。表示索引页的类型。
status text 表示索引页的状态。

- gs\_index\_recycle\_queue\(Oid oid, int type, uint32 blkno\)

描述：用于解析UBtree索引回收队列信息。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_index_recycle_queue(16388, 0, 2);
   rblkno | item_offset | xid | dblkno | prev | next
  --------+-------------+-----+--------+------+------
  ```

**表 15**  gs\_index\_recycle\_queue参数说明

oid Oid 索引文件relfilenode,可以通过select relfilenode from pg_class where relname='name'查询，其中name表示对应的索引文件名字。
type int 0，表示解析整个待回收队列。1，表示解析整个空页队列。2，表示解析单个页面。
blkno uint32 回收队列页面编号，该参数只有在type=2的时候有效，blkno有效取值范围为1~4294967294。
rblkno oid 回收块编号。
item_offset uint32 item的偏移量。
xid text 事物ID。
dblkno oid 数据块的编号。
prev oid 前驱编号。
next oid 后继编号。

- gs\_stat\_wal\_entrytable\(int64 idx\)

描述：用于输出xlog中预写日志插入状态表的内容。

返回值类型：record

**表 16**  gs\_stat\_wal\_entrytable参数说明

参数类型 参数名 输入参数 idx int64 -1：查询数组所有元素。0-最大值：具体某个数组元素内容。
输出参数 idx uint64 记录对应数组中的下标。
输出参数 endlsn uint64 记录的LSN标签。
输出参数 lrc int32 记录对应的LRC。
输出参数 status uint32 标识当前entry对应的xlog是否已经完全拷贝到wal buffer中： 0：非COPIED1：COPIED

- gs\_walwriter\_flush\_position\(\)

描述：输出预写日志的刷新位置。

返回值类型：record

**表 17**  gs\_walwriter\_flush\_position参数说明

参数类型 参数名 输出参数 last_flush_status_entry int32 Xlog flush上一个刷盘的tblEntry下标索引。
输出参数 last_scanned_lrc int32 Xlog flush上一次扫描到的最后一个tblEntry记录的LRC。
输出参数 curr_lrc int32 WALInsertStatusEntry状态表中LRC最新的使用情况，该LRC表示下一个Xlog记录写入时在WALInsertStatusEntry对应的LRC值。
输出参数 curr_byte_pos uint64 Xlog记录写入WAL文件，最新分配的位置，下一个xlog记录插入点。
输出参数 prev_byte_size uint32 上一个xlog记录的长度。
输出参数 flush_result uint64 当前全局xlog刷盘的位置。
输出参数 send_result uint64 当前主机上xlog发送位置。
输出参数 shm_rqst_write_pos uint64 共享内存中记录的XLogCtl中LogwrtRqst请求的write位置。
输出参数 shm_rqst_flush_pos uint64 共享内存中记录的XLogCtl中LogwrtRqst请求的flush位置。
输出参数 shm_result_write_pos uint64 共享内存中记录的XLogCtl中LogwrtResult的write位置。
输出参数 shm_result_flush_pos uint64 共享内存中记录的XLogCtl中LogwrtResult的flush位置。
输出参数 curr_time text 当前时间。

- gs\_walwriter\_flush\_stat\(int operation\)

描述：用于统计预写日志write与sync的次数频率与数据量，以及xlog文件的信息。

返回值类型：record

**表 18**  gs\_walwriter\_flush\_stat参数说明

参数类型 参数名 输入参数 operation int -1：关闭统计开关(默认状态为关闭)。0：打开统计开关。1：查询统计信息。2：重置统计信息。
输出参数 write_times uint64 Xlog调用write接口的次数。
输出参数 sync_times uint64 Xlog调用sync接口次数。
输出参数 total_xlog_sync_bytes uint64 Backend线程请求写入xlog总量统计值。
输出参数 total_actual_xlog_sync_bytes uint64 调用sync接口实际刷盘的xlog总量统计值。
输出参数 avg_write_bytes uint32 每次调用XLogWrite接口请求写的xlog量。
输出参数 avg_actual_write_bytes uint32 实际每次调用write接口写的xlog量。
输出参数 avg_sync_bytes uint32 平均每次请求sync的xlog量。
输出参数 avg_actual_sync_bytes uint32 实际每次调用sync刷盘xlog量。
输出参数 total_write_time uint64 调用write操作总时间统计(单位：us)。
输出参数 total_sync_time uint64 调用sync操作总时间统计(单位：us)。
输出参数 avg_write_time uint32 每次调用write接口平均时间(单位：us)。
输出参数 avg_sync_time uint32 每次调用sync接口平均时间(单位：us)。
输出参数 curr_init_xlog_segno uint64 当前最新创建的xlog段文件编号。
输出参数 curr_open_xlog_segno uint64 当前正在写的xlog段文件编号。
输出参数 last_reset_time text 上一次重置统计信息的时间。
输出参数 curr_time text 当前时间。

- gs\_comm\_proxy\_thread\_status\(\)

描述：用于在数据库实例配置用户态网络的场景下，代理通信库comm\_proxy收发数据包统计。

参数：nan

返回值类型：record

  >[!NOTE]说明
  >此函数的查询仅在集中式环境开始部署用户态网络，且comm\_proxy\_attr参数中enable\_dfx配置为true的条件下显示具体信息。其他场景报错不支持查询。

- pg\_ls\_tmpdir\(\)

描述：返回默认表空间下临时目录（pgsql\_tmp）中每个文件的名称、大小和最后修改时间。

参数：nan

返回值类型：record

备注：必须是系统管理员或者监控管理员才能执行此函数。

参数类型 参数名 输出参数 name text 文件名称 输出参数 size int8 文件大小（单位：byte） 输出参数 modification timestamptz 文件最后修改时间

- pg\_ls\_tmpdir\(oid\)

描述：返回指定表空间下临时目录（pgsql\_tmp）中每个文件的名称、大小和最后修改时间。

参数：oid

返回值类型：record

备注：必须是系统管理员或者监控管理员才能执行此函数。

参数类型 参数名 输入参数 oid oid 表空间id 输出参数 name text 文件名称 输出参数 size int8 文件大小（单位：byte） 输出参数 modification timestamptz 文件最后修改时间

- pg\_ls\_waldir\(\)

描述：返回预写日志\(WAL\)目录中每个文件的名称、大小和最后修改时间。

参数：nan

返回值类型：record

备注：必须是系统管理员或者监控管理员才能执行此函数。

- GS\_WRITE\_TERM\_LOG(void)

描述：写入一条日志记录数据库节点当前的term值。备节点返回false，主节点写入成功后返回true。

返回值类型：Boolean

- pg_prepared_statement()

描述：查询当前会话的预备语句或者指定会话以及整个数据库实例的预备语句。

输入参数：

  |      序号      |      入参       |      类型      |      描述                                                     |
  | ------------- | -------------- | -------------- | ------------------------------------------------------------ |
  | 1             | sessionid      | int64            | 取值范围：-9223372036854775808~9223372036854775807。  |

返回字段：

  |      序号       |       返回字段            |      类型       |      描述                                                    |
  | -------------- | ------------------------ | -------------- | ------------------------------------------------------------ |
  | 1              | sessionid                | int64          | 会话的标识符。                                         |
  | 2              | username                 | text           | 会话所属用户。                                                   |
  | 3              | name                     | text           | 预备语句的标识符。                                                   |
  | 4              | statement                | text           | 创建该预备语句的查询字符串。对于从SQL创建的预备语句而言是客户端提交的PREPARE语句；对于通过前/后端协议创建的预备语句而言是预备语句自身的文本。                                          |
  | 5              | prepare_time             | timestamp with time zone    | 创建该预备语句的时间戳。                                               |
  | 6              | parameter_types          | regtype[]      | 该预备语句期望的参数类型，以regtype类型的数组格式出现。与该数组元素相对应的OID可以通过把regtype转换为oid值得到。                                               |
  | 7              | from_sql                 | boolean        | 如果该预备语句是通过PREPARE语句创建的则为true。 如果是通过前/后端协议创建的则为false。                          |

  >[!NOTE]说明
  >
  > 1. pg_prepared_statement()函数允许不传入参数，当选择不传入参数时，是查询当前会话的预备语句，查询结果只返回"name","statement","prepare_time","parameter_types","from_sql"这五个字段。
  > 2. 当pg_prepared_statement()函数传入参数为0时，为查询整个数据库实例的预备语句。

示例：

  ```sql
  select *from pg_prepared_statement();
  select *from pg_prepared_statement(0);
  select *from pg_prepared_statement(1);
  select *from pg_prepared_statement(281463436919152);

- gs_stat_walsender

  描述：统计 WalSender 发送WAL日志的平均时间间隔、发送次数等信息。支持开启、关闭、重置、查询。

  输入参数：

  |      序号      |      入参       |      类型      |      描述                                                     |
  | ------------- | -------------- | -------------- | ------------------------------------------------------------ |
  | 1             | operation      | int            | 取值范围：-1~2。  -1：关闭统计功能； 0：重置数据； 1：开启统计功能； 2：查询（默认）。  |

  返回字段：

  |      序号       |       返回字段            |      类型       |      描述                                                    |
  | -------------- | ------------------------ | -------------- | ------------------------------------------------------------ |
  | 1              | is_enable_stat           | boolean        | 是否开启，默认关闭。                                         |
  | 2              | channel                  | text           | 发送通道。                                                   |
  | 3              | cur_time                 | timestamptz    | 当前时间。                                                   |
  | 4              | send_times               | uint64         | 发送次数。                                                   |
  | 5              | first_send_time          | timestamptz    | 首次发送时间。                                               |
  | 6              | last_send_time           | timestamptz    | 末次发送时间。                                               |
  | 7              | last_reset_time          | timestamptz    | 末次重置时间，只有重置过才会有值。                           |
  | 8              | avg_send_interval        | uint64         | 平均发送间隔时间，发送次数大于等于2才会有值。
计算方式：(last_send_time - first_send_time) / (send_times - 1 ) |
  | 9              | since_last_send_interval | uint64         | 距离最近一次发送的时间，发送次数大于0才会有值。
计算方式：cur_time - last_send_time |

  >[!NOTE]说明
  >
  > 1. 只有存在 WalSender 且已初始化完成才会有数据，WalSender终止则对应数据被移除，线程重新拉起不会继承。每个 WalSender 一行，单机场景不会有数据。在没有 WalSender 的情况下，开关、重置也会更新系统内部 is_enable_stat、last_reset_time 字段的值。
  > 2. channel 与 gs_ctl query 命令查询到的发送通道一致。
  > 3. since_last_send_interval 在 send_times 为 0 时返回 NULL 值，且由于此值为查询时实时计算的，统计功能关闭后依然是 cur_time - last_send_time，尽管 last_send_time 已不再更新。
  > 4. uint64 类型目前在系统内部实际被识别为 xid，即事务ID类型，在进行运算时需要注意。
  > 5. 数据库重启后所有数据回到初始化状态，功能默认关闭。

  示例：

  ```sql
select * from gs_stat_walsender(1);
select * from gs_stat_walsender(2);
select * from gs_stat_walsender(0);
select * from gs_stat_walsender(-1);
  ```

- gs_stat_walreceiver

  描述：统计 WalReceiver 唤醒 WalRecvWriter 的时间间隔、walReceiverBuffer 的当前大小和历史上满的次数。支持开启、关闭、重置、查询。

  输入参数：

  |      序号       |      入参       |      类型      |      描述                                                    |
  | -------------- | -------------- | -------------- | ------------------------------------------------------------ |
  | 1             | operation      | int            | 取值范围：-1~2。  -1：关闭统计功能； 0：重置数据； 1：开启统计功能； 2：查询（默认）。  |

  返回字段：

  |      序号      |      返回字段            |      类型      |      描述                                                    |
  | -------------- | ------------------------ | -------------- | ------------------------------------------------------------ |
  | 1              | is_enable_stat           | boolean        | 是否开启，默认关闭。                                         |
  | 2              | buffer_current_size      | uint64         | walReceiverBuffer当前已使用的缓存大小。                      |
  | 3              | buffer_full_times        | uint64         | 缓存被写满的次数。                                           |
  | 4              | wake_writer_times        | uint64         | 唤醒WalRecvWriter的次数。                                    |
  | 5              | avg_wake_interval        | uint64         | 平均唤醒时间间隔，唤醒次数大于等于2才会有值。
计算方式：（last_wake_time - first_wake_time）/ (wake_writer_times - 1)。 |
  | 6              | since_last_wake_interval | uint64         | 距离最近一次唤醒WalRecvWriter的时间。
计算方式：cur_time - last_wake_time。 |
  | 7              | first_wake_time          | timestamptz    | 首次唤醒时间。                                               |
  | 8              | last_wake_time           | timestamptz    | 末次唤醒时间。                                               |
  | 9              | last_reset_time          | timestamptz    | 末次重置时间，只有重置过才会有值。                           |
  | 10             | cur_time                 | timestamptz    | 当前时间。                                                   |

  >[!NOTE]说明
  >
  > 1. avg_wake_interval 在 wake_writer_times 小于 2 时返回 NULL 值。
  > 2. since_last_wake_interval 在 wake_writer_times 为 0 时返回 NULL 值，且由于此值为查询时实时计算的，统计功能关闭后依然是 cur_time - last_wake_time，尽管 last_wake_time 已不再更新。
  > 3. first_wake_time、last_wake_time、last_reset_time 在没有值时返回 NULL。
  > 4. uint64 类型目前在系统内部实际被识别为 xid，即事务ID类型，在进行运算时需要注意。
  > 5. 数据库重启后所有数据回到初始化状态，功能默认关闭。

  示例：

  ```sql
select * from gs_stat_walreceiver(1);
select * from gs_stat_walreceiver(2);
select * from gs_stat_walreceiver(0);
select * from gs_stat_walreceiver(-1);
  ```

- gs_stat_walrecvwriter

  描述：统计 WalRecvWriter 线程写日志 I/O发生的次数、耗时、数据量、xlog编号等信息。

  输入参数：

  |      序号       |      入参       |      类型      |      描述                                                    |
  | -------------- | -------------- | -------------- | ------------------------------------------------------------ |
  | 1             | operation      | int            | 取值范围：-1~2。  -1：关闭统计功能； 0：重置数据； 1：开启统计功能； 2：查询（默认）。  |

  返回字段：

  |       序号      |       返回字段      |       类型      |       描述                              |
  | -------------- | ------------------ | -------------- | -------------------------------------- |
  | 1              | is_enable_stat     | boolean        | 是否开启，默认关闭。                   |
  | 2              | total_write_bytes  | uint64         | 总写入字节数。                         |
  | 3              | write_times        | uint64         | 调用write的次数。                      |
  | 4              | total_write_time   | uint64         | 调用write的总耗时（单位：us）。        |
  | 5              | avg_write_time     | uint64         | 每次调用write的平均耗时（单位：us）。  |
  | 6              | avg_write_bytes    | uint64         | 平均写字节数。                         |
  | 7              | total_sync_bytes   | uint64         | 总刷盘字节数。                         |
  | 8              | sync_times         | uint64         | 调用sync函数刷盘次数。                 |
  | 9              | total_sync_time    | uint64         | 调用sync函数刷盘总耗时（单位：us）。   |
  | 10             | avg_sync_time      | uint64         | 每次调用sync函数平均耗时（单位：us）。 |
  | 11             | avg_sync_bytes     | uint64         | 每次调用sync函数刷盘的平均字节数。     |
  | 12             | current_xlog_segno | uint64         | 当前正在写的xlog段文件编号。           |
  | 13             | inited_xlog_segno  | uint64         | 已初始化的最新的xlog段文件编号。       |
  | 14             | last_reset_time    | timestamptz    | 末次重置时间，只有重置过才会有值。     |
  | 15             | cur_time           | timestamptz    | 当前时间。                             |

  >[!NOTE]说明
  >
  > 1. 当 write_times 为0时，avg_write_time、avg_write_bytes 返回 NULL 值。
  > 2. 当 sync_times 为0时，avg_sync_time、avg_sync_bytes 返回 NULL 值。
  > 3. current_xlog_segno、inited_xlog_segno、cur_time 等字段不受开关、重置功能影响，current_xlog_segno 只有 walrecvwriter 线程在运行时才会获更新数据。
  > 4. uint64 类型目前在系统内部实际被识别为 xid，即事务ID类型，在进行运算时需要注意。
  > 5. 数据库重启后所有数据回到初始化状态，功能默认关闭。

  示例：

  ```sql
select * from gs_stat_walrecvwriter(1);
select * from gs_stat_walrecvwriter(2);
select * from gs_stat_walrecvwriter(0);
select * from gs_stat_walrecvwriter(-1);
  ```

- generate_procoverage_report

  描述：生成postgres库[coverage.proc_coverage](../sql_reference/coverage_proc_coverage.md)表中两个覆盖率序号间存储过程的覆盖率报告，需要在postgres库下执行，且打开enable_proc_coverage参数。

  输入参数：

  |参数|说明|取值范围|
  |--|--|--|
  |begin_id|生成存储过程覆盖率报告的起始id（包含）|bigint，大于0，begin_id大于end_id；begin_id与end_id同为-1时，生成所有记录的存储过程覆盖率报告|
  |end_id|生成存储过程覆盖率报告的结束id（包含）|bigint，大于0，begin_id大于end_id；begin_id与end_id同为-1时，生成所有记录的存储过程覆盖率报告|

  >[!NOTE]说明
  >
  > 1. 当begin_id和end_id符合取值范围时，生成二者间（包含）id的所有覆盖率记录的报告。如generate_procoverage_report(2, 5)，若[coverage.proc_coverage](../sql_reference/coverage_proc_coverage.md)表中存在coverage_id为2、3、4、5的报告，将生成2、3、4、5记录的覆盖率报告；若仅存在coverage_id为3、4的报告，将生成3、4记录的覆盖率报告。
  > 2. 函数直接输出html格式的text内容，配合\a、\t格式化输出，\o指定输出文件，生成html覆盖率报告

  示例：

  ```
openGauss=# \a Output format is unaligned.
openGauss=# \t Showing only tuples.
openGauss=# \o /data/openGauss/test.html openGauss=# select generate_procoverage_report(-1, -1);
openGauss=# \o
  ```

- gs_xlog_keepers()

  描述：查询所有阻止wal清理的因素，用于定位pg_xlog目录中xlog日志堆积的原因。

  返回字段说明：

  - keeptype：阻止wal清理的类型描述。

    取值范围如下：

    - Base Keep：

      在主库中，此取值的意义是已确认完成checkpoint的lsn位置所对应的wal文件名。

      在备库中，此取值的意义是当前未完成回放的wal文件名。

    - Segments Keep：由wal_keep_segments参数导致的wal文件保护。

    - Slots Keep：活跃的物理或者逻辑复制槽导致的wal文件保护。

    - Basebackup Keep：当前数据库有执行gs_basebackup命令，由于这个命令导致的wal文件保护。

    - Build Keep：当前数据库的备库在执行build命令，此为执行build命令导致的wal文件保护。

    - Unactived Wal Send Keep：由于备机未启动导致的wal文件保护。

    - Dummystandby Keep：由于dummystandby未启动导致的wal文件保护。

    - Invalid Slot Keep：由未启用的复制槽导致的wal文件保护。

    - CBM Keep：由CBM功能导致的wal文件保护。

    - Standby Checkpoint Keep：备机redo过的checkpoint记录导致的wal文件保护。

    - Archive Keep：由wal归档功能导致的wal文件保护。

    - Resist Archive：OBS归档要求的wal超过max_size_for_xlog_prune参数的限制导致的wal文件保护。

    - Other keep：由Coordinator导致的wal文件保护。

    - QuorumMin keep：由备机多数派导致的wal文件保护。

  - keepsegment：当前限制项保护的wal文件名。

  - describe：对keeptype的解释。

  示例：

  ```sql
openGauss=# select *  from gs_xlog_keepers();
keeptype    |       keepsegment        |                                         describe
  ---------------+--------------------------+-------------------------------------------------------------------------------------------
Base keep     | 00000001000000000000000B | base on redo lsn of recently checkpoint for primary or current working segment on standby Segments Keep | 000000010000000000000008 | base on wal_keep_segments GUC Slots keep    | 00000001000000000000000B | base on physical or logical slots Archive Keep  | 00000001000000000000000B | base on wal archive (4 rows)
  ```

- query_parameterization_views()

  描述: 显示已经被缓存的参数化SQL信息

  返回值类型: record

  示例:

  ```sql
openGauss=# select * from query_parameterization_views();
databaseid | query_type | is_bypass | param_types | param_nums | parameterized_query
  ------------+------------+-----------+-------------+------------+---------------------
(0 rows)
  ```

  返回字段：

  |       序号      |       返回字段      |       类型      |       描述                              |
  | -------------- | ------------------  | -------------- | -------------------------------------- |
  | 1              | databaseid          | oid            | 参数化SQL所属的数据库oid                 |
  | 2              | query_type          | name           | 参数化SQL的语句类型                      |
  | 3              | is_bypass           | bool           | 是否使用了SQL-BYPASS功能                 |
  | 4              | param_types         | int2vector     | 被参数化的数值的类型                     |
  | 5              | param_nums          | smallint       | 参数个数                                |
  | 6              | parameterized_query | text           | 被参数化后的SQL语句                      |
