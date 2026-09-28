# 统计信息函数

统计信息函数根据访问对象分为两种类型：针对某个数据库进行访问的函数，以数据库中每个表或索引的OID作为参数，标识需要报告的数据库；针对某个服务器进行访问的函数，以一个服务器进程号为参数，其范围从1到当前活跃服务器的数目。

- pg\_stat\_get\_db\_conflict\_tablespace\(oid\)

描述：由于恢复与数据库中删除的表空间发生冲突而取消的查询数。

返回值类型：bigint

- pg\_control\_group\_config

描述：在当前节点上打印cgroup配置。

返回值类型：record

- pg\_stat\_get\_db\_stat\_reset\_time\(oid\)

描述：上次重置数据库统计信息的时间。首次连接到每个数据库期间初始化为系统时间。当您在数据库上调用pg\_stat\_reset以及针对其中的任何表或索引执行pg\_stat\_reset\_single\_table\_counters时，重置时间都会更新。

返回值类型：timestamptz

- pg\_stat\_get\_function\_total\_time\(oid\)

描述：该函数花费的总挂钟时间，以微秒为单位。包括花费在此函数调用其它函数上的时间。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_returned\(oid\)

描述：当前事务中参数为表时通过顺序扫描读取的行数，或参数为索引时返回的索引条目数。

返回值类型：bigint

- pg\_lock\_status\(\)

描述：查询打开事务所持有的锁信息，所有用户均可执行该函数。

返回值类型：返回字段可参考PG\_LOCKS视图返回字段，该视图是通过查询本函数得到的结果。

- pg\_stat\_get\_xact\_numscans\(oid\)

描述：当前事务中参数为表时执行的顺序扫描次数，或参数为索引时执行的索引扫描次数。

返回值类型：bigint

- pg\_stat\_get\_xact\_blocks\_fetched\(oid\)

描述：当前事务中对表或索引的磁盘块获取请求数。

返回值类型：bigint

- pg\_stat\_get\_xact\_blocks\_hit\(oid\)

描述：当前事务中对缓存中找到的表或索引的磁盘块获取请求数。

返回值类型：bigint

- pg\_stat\_get\_xact\_function\_calls\(oid\)

描述：在当前事务中调用该函数的次数。

返回值类型：bigint

- pg\_stat\_get\_xact\_function\_self\_time\(oid\)

描述：在当前事务中仅花费在此函数上的时间，不包括花费在此函数内部调用其它函数上的时间。

返回值类型：bigint

- pg\_stat\_get\_xact\_function\_total\_time\(oid\)

描述：当前事务中该函数所花费的总挂钟时间（以微秒为单位），包括花费在此函数内部调用其它函数上的时间。

返回值类型：bigint

- pg\_stat\_get\_wal\_senders\(\)

描述：在主机端查询walsender信息。

返回值类型：setofrecord

示例：

    ```sql
    openGauss=# select * from pg_stat_get_wal_senders();
     pid | sender_pid | local_role | peer_role | peer_state | state | catchup_start | catchup_end | sender_sent_location | sender_write_location | sender_flush_location | sender_replay_location | receiver_received_location | receiver_write_location | receiver_flush_location | receiver_replay_location | sync_percent | sync_state | sync_priority | sync_most_available | channel
    -----+------------+------------+-----------+------------+-------+---------------+-------------+----------------------+-----------------------+-----------------------+------------------------+----------------------------+-------------------------+-------------------------+--------------------------+--------------+------------+---------------+---------------------+---------
    ```

返回字段说明如下：

**表 1**  返回字段说明

字段名称 字段类型 字段说明 pid bigint walsender的线程号。
sender_pid integer walsender的pid相对的轻量级线程号。
local_role text 主节点类型。
peer_role text 备节点类型。
peer_state text 备节点状态。
state text walsender状态。
catchup_start timestamp with time zone catchup启动时间。
catchup_end timestamp with time zone catchup结束时间。
sender_sent_location text 主节点发送位置。
sender_write_location text 主节点落盘位置。
sender_flush_location text 主节点flush磁盘位置。
sender_replay_location text 主节点redo位置。
receiver_received_location text 备节点接收位置。
receiver_write_location text 备节点落盘位置。
receiver_flush_location text 备节点flush磁盘位置。
receiver_replay_location text 备节点redo磁盘位置。
sync_percent text 同步百分比。
sync_state text 同步状态。
sync_priority text 同步复制的优先级。
sync_most_available text 最大可用模式设置。
channel text walsender信道信息。

- get\_paxos\_replication\_info\(\)

描述：查询Paxos模式下主机或备机的复制状态。

返回值类型：setofrecord

示例：

    ```sql
    openGauss=# select * from get_paxos_replication_info();
     paxos_write_location | paxos_commit_location | local_write_location | local_flush_location | local_replay_location | dcf_replication_info
    ----------------------+-----------------------+----------------------+----------------------+-----------------------+----------------------
    ```

返回字段说明如下：

**表 2**  返回字段说明

字段名称 字段类型 字段说明 paxos_write_location text 已经写入DCF的XLog位置。
paxos_commit_location text 已经在DCF中达成一致的XLog位置。
local_write_location text 节点的落盘位置。
local_flush_location text 节点的flush磁盘位置。
local_replay_location text 节点的redo磁盘位置。
dcf_replication_info text 节点的DCF模块信息。

- pg\_stat\_get\_stream\_replications\(\)

描述：查询主备复制状态。

返回值类型：setofrecord

返回值说明如下。

**表 3**  返回值说明

返回参数 返回参数类型 返回参数说明 local_role text 本地角色。
static_connections integer 连接统计。
db_state text 数据库状态。
detail_information text 详细信息。

- pg\_stat\_get\_db\_numbackends\(oid\)

描述：处理该数据库活跃的服务器进程数目。

返回值类型：integer

- pg\_stat\_get\_db\_xact\_commit\(oid\)

描述：数据库中已提交事务的数量。

返回值类型：bigint

- pg\_stat\_get\_db\_xact\_rollback\(oid\)

描述：数据库中回滚事务的数量。

返回值类型：bigint

- pg\_stat\_get\_db\_blocks\_fetched\(oid\)

描述：数据库中磁盘块抓取请求的总数。

返回值类型：bigint

- pg\_stat\_get\_db\_blocks\_hit\(oid\)

描述：数据库在缓冲区中找到的磁盘块抓取请求的总数。

返回值类型：bigint

- pg\_stat\_get\_db\_tuples\_returned\(oid\)

描述：为数据库返回的Tuple数。

返回值类型：bigint

- pg\_stat\_get\_db\_tuples\_fetched\(oid\)

描述：为数据库中获取的Tuple数。

返回值类型：bigint

- pg\_stat\_get\_db\_tuples\_inserted\(oid\)

描述：在数据库中插入Tuple数。

返回值类型：bigint

- pg\_stat\_get\_db\_tuples\_updated\(oid\)

描述：在数据库中更新的Tuple数。

返回值类型：bigint

- pg\_stat\_get\_db\_tuples\_deleted\(oid\)

描述：数据库中删除Tuple数。

返回值类型：bigint

- pg\_stat\_get\_db\_conflict\_lock\(oid\)

描述：数据库中锁冲突的数量。

返回值类型：bigint

- pg\_stat\_get\_db\_deadlocks\(oid\)

描述：数据库中死锁的数量。

返回值类型：bigint

- pg\_stat\_get\_numscans\(oid\)

描述：如果参数是一个表，则顺序扫描读取的行数目。如果参数是一个索引，则返回索引行的数目。

返回值类型：bigint

- pg\_stat\_get\_lastscan\(oid\)

描述：如果参数是一个表，则返回表的最后扫描时间。如果参数是一个索引，则返回索引的最后扫描时间。

返回值类型：timestamptz

- pg\_stat\_force\_next\_flush\(\)

描述：强制在下次统计时机上报数据。

返回值类型：void

- pg\_stat\_get\_role\_name\(oid\)

描述：根据用户oid获取用户名。仅sysadmin和monitor admin用户可以访问。

返回值类型：text

示例：

    ```
    openGauss=# select pg_stat_get_role_name(10);
     pg_stat_get_role_name
    -----------------------
     aabbcc
    (1 row)
    ```

- pg\_stat\_get\_tuples\_returned\(oid\)

描述：如果参数是一个表，则顺序扫描读取的行数目。如果参数是一个索引，则返回的索引行的数目。

返回值类型：bigint

- pg\_stat\_get\_tuples\_fetched\(oid\)

描述：如果参数是一个表，则位图扫描抓取的行数目。如果参数是一个索引，则用简单索引扫描抓取的行数目。

返回值类型：bigint

- pg\_stat\_get\_tuples\_inserted\(oid\)

描述：插入表中行的数量。

返回值类型：bigint

- pg\_stat\_get\_tuples\_updated\(oid\)

描述：在表中已更新行的数量。

返回值类型：bigint

- pg\_stat\_get\_tuples\_deleted\(oid\)

描述：从表中删除行的数量。

返回值类型：bigint

- pg\_stat\_get\_tuples\_changed\(oid\)

描述：该表上一次analyze或autoanalyze之后插入、更新、删除行的总数量。

返回值类型：bigint

- pg\_stat\_get\_tuples\_hot\_updated\(oid\)

描述：表热更新的行数。

返回值类型：bigint

- pg\_stat\_get\_live\_tuples\(oid\)

描述：表活行数。

返回值类型：bigint

- pg\_stat\_get\_dead\_tuples\(oid\)

描述：表死行数。

返回值类型：bigint

- pg\_stat\_get\_blocks\_fetched\(oid\)

描述：表或者索引的磁盘块抓取请求的数量。

返回值类型：bigint

- pg\_stat\_get\_blocks\_hit\(oid\)

描述：在缓冲区中找到的表或者索引的磁盘块请求数目。

返回值类型：bigint

- pg\_stat\_get\_partition\_tuples\_inserted\(oid\)

描述：插入相应表分区中行的数量。

返回值类型：bigint

- pg\_stat\_get\_partition\_tuples\_updated\(oid\)

描述：在相应表分区中已更新行的数量。

返回值类型：bigint

- pg\_stat\_get\_partition\_tuples\_deleted\(oid\)

描述：从相应表分区中删除行的数量。

返回值类型：bigint

- pg\_stat\_get\_partition\_tuples\_changed\(oid\)

描述：该表分区上一次analyze或autoanalyze之后插入、更新、删除行的总数量。

返回值类型：bigint

- pg\_stat\_get\_partition\_live\_tuples\(oid\)

描述：分区表活行数。

返回值类型：bigint

- pg\_stat\_get\_partition\_dead\_tuples\(oid\)

描述：分区表死行数。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_fetched\(oid\)

描述：事务中扫描的tuple行数。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_inserted\(oid\)

描述：表相关的活跃子事务中插入的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_deleted\(oid\)

描述：表相关的活跃子事务中删除的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_hot\_updated\(oid\)

描述：表相关的活跃子事务中热更新的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_tuples\_updated\(oid\)

描述：表相关的活跃子事务中更新的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_partition\_tuples\_inserted\(oid\)

描述：表分区相关的活跃子事务中插入的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_partition\_tuples\_deleted\(oid\)

描述：表分区相关的活跃子事务中删除的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_partition\_tuples\_hot\_updated\(oid\)

描述：表分区相关的活跃子事务中热更新的tuple数。

返回值类型：bigint

- pg\_stat\_get\_xact\_partition\_tuples\_updated\(oid\)

描述：表分区相关的活跃子事务中更新的tuple数。

返回值类型：bigint

- pg\_stat\_get\_last\_vacuum\_time\(oid\)

描述：用户在该表上最后一次手动启动清理或者autovacuum线程启动清理的时间。

返回值类型：timestamptz

- pg\_stat\_get\_last\_autovacuum\_time\(oid\)

描述：autovacuum守护进程在该表上最后一次启动清理的时间。

返回值类型：timestamptz

- pg\_stat\_get\_vacuum\_count\(oid\)

描述：用户在该表上启动清理的次数。

返回值类型：bigint

- pg\_stat\_get\_autovacuum\_count\(oid\)

描述：autovacuum守护进程在该表上启动清理的次数。

返回值类型：bigint

- pg\_stat\_get\_last\_analyze\_time\(oid\)

描述：用户在该表上最后一次手动启动分析或者autovacuum线程启动分析的时间。

返回值类型：timestamptz

- pg\_stat\_get\_last\_autoanalyze\_time\(oid\)

描述：autovacuum守护进程在该表上最后一次启动分析的时间。

返回值类型：timestamptz

- pg\_stat\_get\_analyze\_count\(oid\)

描述：用户在该表上启动分析的次数。

返回值类型：bigint

- pg\_stat\_get\_autoanalyze\_count\(oid\)

描述：autovacuum守护进程在该表上启动分析的次数。

返回值类型：bigint

- pg\_total\_autovac\_tuples\(bool\)

描述：返回total autovac相关的tuple记录，如nodename,nspname,relname以及各类tuple的IUD信息，入参为：是否查询relation信息。

返回值类型：setof record

返回参数说明如下。

**表 4**  返回参数说明

返回参数 返回参数类型 返回参数说明 nodename name 节点名称。
nspname name 名称空间名称。
relname name 表、索引、视图等对象名称。
partname name 分区名称。
n_dead_tuples bigint 表分区内的死行数。
n_live_tuples bigint 表分区内的活行数。
changes_since_analyze bigint analyze产生改变的数量。

- pg\_autovac\_status\(oid\)

描述：返回和autovac状态相关的参数信息，如nodename,nspname,relname,analyze,vacuum设置，analyze/vacuum阈值, analyze/vacuum tuple数等。仅sysadmin可以使用该函数。

返回值类型：setofrecord

返回值参数说明如下。

**表 5**  返回值参数说明

返回参数 返回参数类型 返回参数说明 nspname text 名称空间名称。
relname text 表、索引、视图等对象名称。
nodename text 节点名称。
doanalyze Boolean 是否执行analyze。
anltuples bigint analyze tuple数量。
anlthresh bigint analyze阈值。
dovacuum Boolean 是否执行vacuum。
vactuples bigint vacuum tuple数量。
vacthresh bigint vacuum阈值。

- pg\_autovac\_timeout\(oid\)

描述：返回某个表做autovac连续超时的次数，表信息非法或node信息异常返回NULL。

返回值类型：bigint

- pg\_stat\_get\_last\_data\_changed\_time\(oid\)

描述：insert/update/delete, exchange/truncate/drop partition在该表上最后一次操作的时间，[PG\_STAT\_ALL\_TABLES](../database_reference/pg_stat_all_tables.md)视图last\_data\_changed列的数据是通过该函数求值，在表数量很大的场景中，通过视图获取表数据最后修改时间的性能较差，建议直接使用该函数获取表数据的最后修改时间。入参可以是表的oid或分区的oid，分别获取表或表的分区的最后修改时间。

返回值类型：timestamptz

- pg\_stat\_set\_last\_data\_changed\_time\(oid\)

描述：手动设置该表上最后一次insert/update/delete, exchange/truncate/drop partition操作的时间。

返回值类型：void

- pg\_backend\_pid\(\)

描述：当前会话的服务器线程的线程ID。

返回值类型：bigint

- pg\_stat\_get\_activity\(integer\)

描述：返回一个关于带有特殊PID的后台进程的记录信息，当参数为NULL时，则返回每个活动的后台进程的记录。返回结果不包含connection\_info列。初始用户、系统管理员和monadmin可以查看所有的数据，普通用户只能查询自己的结果。

示例：

    ```
    openGauss=# select * from pg_stat_get_activity(139881386280704);
     datid |       pid       | sessionid | usesysid | application_name | state  |                        query                         | waiting |          xact_start           |          query_start          |
        backend_start         |         state_change         | client_addr | client_hostname | client_port | enqueue |     query_id      |   srespool   | global_sessionid | unique_sql_id | trace_id
    -------+-----------------+-----------+----------+------------------+--------+------------------------------------------------------+---------+-------------------------------+-------------------------------+-----
    --------------------------+------------------------------+-------------+-----------------+-------------+---------+-------------------+--------------+------------------+---------------+----------
     16545 | 139881386280704 |        69 |       10 | gsql             | active | select * from pg_stat_get_activity(139881386280704); | f       | 2022-01-18 19:43:05.167718+08 | 2022-01-18 19:43:05.167718+08 | 2022
    -01-18 19:42:33.513507+08 | 2022-01-18 19:43:05.16773+08 |             |                 |          -1 |         | 72620543991624410 | default_pool | 1938253334#69#0  |    3751941862 |
    (1 row)
    ```

返回值类型：setofrecord

返回参数说明如下。

**表 6**  返回参数说明

返回参数 返回参数类型 返回参数说明 datid oid 用户会话在后台连接到的数据库OID。
pid bigint 后台线程ID。
sessionid bigint 会话ID。
usesysid oid 登录该后台的用户OID。
application_name text 连接到该后台的应用名。
state text 该后台当前总体状态。
query text 该后台的最新查询。如果state状态是active（活跃的），此字段显示当前正在执行的查询。所有其他情况表示上一个查询。
waiting Boolean 如果后台当前正等待锁则为true。
xact_start timestamp with time zone 启动当前事务的时间，如果没有事务是活跃的，则为null。
如果当前查询是首个事务，则这列等同于query_start列。
query_start timestamp with time zone 开始当前活跃查询的时间，如果state的值不是active，则这个值是上一个查询的开始时间。
backend_start timestamp with time zone 该过程开始的时间，即当客户端连接服务器时。
state_change timestamp with time zone 上次状态改变的时间。
client_addr inet 连接到该后台的客户端的IP地址。如果此字段是null，它表明通过服务器机器上UNIX套接字连接客户端或者这是内部进程，如autovacuum。
client_hostname text 客户端的主机名，这个字段是通过client_addr的反向DNS查找得到。这个字段只有在启动log_hostname且使用IP连接时才非空。
client_port integer 客户端用于与后台通讯的TCP端口号，如果使用Unix套接字，则为-1。
enqueue text 该字段暂不支持。
query_id bigint 查询语句的ID。
srespool name 资源池名字。
global_sessionid text 全局会话id。
unique_sql_id bigint 语句的unique sql id。
trace_id text 驱动传入的trace id，与应用的一次请求相关联。

- pg\_stat\_get\_activity\_with\_conninfo\(integer\)

描述：返回一个关于带有特殊PID的后台进程的记录信息，当参数为NULL时，则返回每个活动的后台进程的记录。初始用户、系统管理员和monadmin可以查看所有的数据，普通用户只能查询自己的结果。

返回值类型：setofrecord

返回值说明如下。

**表 7**  返回值说明

返回值 返回值类型 返回值说明 datid oid 用户会话在后台连接到的数据库OID。
pid bigint 后台线程ID。
sessionid bigint 会话ID。
usesysid oid 登录该后台的用户OID。
application_name text 连接到该后台的应用名。
state text 改后台当前总体状态 query text 该后台的最新查询。如果state状态是active（活跃的），此字段显示当前正在执行的查询。所有其他情况表示上一个查询。
waiting Boolean 如果后台当前正等待锁则为true xact_start timestamp with time zone 启动当前事务的时间，如果没有事务是活跃的，则为null。如果当前查询是首个事务，则这列等同于query_start列。
query_start timestamp with time zone 开始当前活跃查询的时间，如果state的值不是active，则这个值是上一个查询的开始时间。
backend_start timestamp with time zone 该过程开始的时间，即当客户端连接服务器时。
state_change timestamp with time zone 上次状态改变的时间。
client_addr inet 连接到该后台的客户端的IP地址。如果此字段是null，它表明通过服务器机器上UNIX套接字连接客户端或者这是内部进程，如autovacuum client_hostname text 客户端的主机名，这个字段是通过client_addr的反向DNS查找得到。这个字段只有在启动log_hostname且使用IP连接时才非空。
client_port integer 客户端用于与后台通讯的TCP端口号，如果使用Unix套接字，则为-1。
enqueue text 该字段暂不支持。
query_id bigint 查询语句的ID。
connection_info text json格式字符串，记录当前连接数据库的驱动类型、驱动版本号、当前驱动的部署路径、进程属主用户等信息。
srespool name 资源池名字。
global_sessionid text 全局会话ID。
unique_sql_id bigint 语句的unique sql id。
trace_id text 驱动传入的trace id，与应用的一次请求相关联。

- pg\_user\_iostat\(text\)

描述：显示和当前用户执行作业正在运行时的IO负载管理相关信息。

返回值类型：record

函数返回字段说明如下：

userid oid 用户id。
min_curr_iops int4 当前该用户io在数据库节点中的最小值。对于行存，以万次/s为单位；对于列存，以次/s为单位。
max_curr_iops int4 当前该用户io在数据库节点中的最大值。对于行存，以万次/s为单位；对于列存，以次/s为单位。
min_peak_iops int4 该用户io峰值中，数据库节点的最小值。对于行存，以万次/s为单位；对于列存，以次/s为单位。
max_peak_iops int4 该用户io峰值中，数据库节点的最大值。对于行存，以万次/s为单位；对于列存，以次/s为单位。
io_limits int4 用户指定的资源池所设置的io_limits。对于行存，以万次/s为单位；对于列存，以次/s为单位。
io_priority text 该用户所设io_priority。对于行存，以万次/s为单位；对于列存，以次/s为单位。
curr_io_limits int4 使用io_priority管控io时的实时io_limits值。

- pg\_stat\_get\_function\_calls\(oid\)

描述：函数已被调用次数。

返回值类型：bigint

- pg\_stat\_get\_function\_self\_time\(oid\)

描述：只有在此函数上所花费的时间。此函数调用其它函数上花费的时间被排除在外。

返回值类型：bigint

- pg\_stat\_get\_backend\_idset\(\)

描述：设置当前活动的服务器进程数（从1到活动服务器进程的数量）。

返回值类型：setofinteger

- pg\_stat\_get\_backend\_pid\(integer\)

描述：给定的服务器线程的线程ID。

返回值类型：bigint

- pg\_stat\_get\_backend\_dbid\(integer\)

描述：给定服务器进程的数据库ID。

返回值类型：oid

- pg\_stat\_get\_backend\_userid\(integer\)

描述：给定服务器进程的用户ID。

返回值类型：oid

- pg\_stat\_get\_backend\_activity\(integer\)

描述：给定服务器进程的当前活动查询，仅在调用者是系统管理员或被查询会话的用户，并且打开track\_activities的时候才能获得结果。

返回值类型：text

- pg\_stat\_get\_backend\_waiting\(integer\)

描述：如果给定服务器进程在等待某个锁，并且调用者是系统管理员或被查询会话的用户，并且打开track\_activities的时候才返回真。

返回值类型：Boolean

- pg\_stat\_get\_backend\_activity\_start\(integer\)

描述：给定服务器进程当前正在执行的查询的起始时间，仅在调用者是系统管理员或被查询会话的用户，并且打开track\_activities的时候才能获得结果。

返回值类型：timestampwithtimezone

- pg\_stat\_get\_backend\_xact\_start\(integer\)

描述：给定服务器进程当前正在执行的事务的开始时间，但只有当前用户是系统管理员或被查询会话的用户，并且打开track\_activities的时候才能获得结果。

返回值类型：timestampwithtimezone

- pg\_stat\_get\_backend\_start\(integer\)

描述：给定服务器进程启动的时间，如果当前用户不是系统管理员或被查询的后端的用户，则返回NULL。

返回值类型：timestampwithtimezone

- pg\_stat\_get\_backend\_client\_addr\(integer\)

描述：连接到给定客户端后端的IP地址。如果是通过Unix域套接字连接的则返回NULL；如果当前用户不是系统管理员或被查询会话的用户，也返回NULL。

返回值类型：inet

- pg\_stat\_get\_backend\_client\_port\(integer\)

描述：连接到给定客户端后端的TCP端口。如果是通过Unix域套接字连接的则返回-1；如果当前用户不是系统管理员或被查询会话的用户，也返回NULL。

返回值类型：integer

- pg\_stat\_get\_bgwriter\_timed\_checkpoints\(\)

描述：后台写进程开启定时检查点的时间（因为checkpoint\_timeout时间已经过期了）。

返回值类型：bigint

- pg\_stat\_get\_bgwriter\_requested\_checkpoints\(\)

描述：后台写进程开启基于后端请求的检查点的时间，因为已经超过了checkpoint\_segments或因为已经执行了CHECKPOINT。

返回值类型：bigint

- pg\_stat\_get\_bgwriter\_buf\_written\_checkpoints\(\)

描述：在检查点期间后台写进程写入的缓冲区数目。

返回值类型：bigint

- pg\_stat\_get\_bgwriter\_buf\_written\_clean\(\)

描述：为日常清理脏块，后台写进程写入的缓冲区数目。

返回值类型：bigint

- pg\_stat\_get\_bgwriter\_maxwritten\_clean\(\)

描述：后台写进程停止清理扫描的时间，因为已经写入了更多的缓冲区（相比bgwriter\_lru\_maxpages参数声明的缓冲区数）。

返回值类型：bigint

- pg\_stat\_get\_buf\_written\_backend\(\)

描述：后端进程写入的缓冲区数，因为它们需要分配一个新的缓冲区。

返回值类型：bigint

- pg\_stat\_get\_buf\_alloc\(\)

描述：分配的总缓冲区数。

返回值类型：bigint

- pg\_stat\_clear\_snapshot\(\)

描述：清理当前的统计快照。

返回值类型：void

- pg\_stat\_reset\(\)

描述：为当前数据库重置统计计数器为0（需要系统管理员权限）。

返回值类型：void

- pg\_stat\_reset\_shared\(text\)

描述：重置shared cluster每个节点当前数据统计计数器为0（需要系统管理员权限）。

返回值类型：void

- pg\_stat\_reset\_single\_table\_counters\(oid\)

描述：为当前数据库中的一个表或索引重置统计为0（需要系统管理员权限）。

返回值类型：void

- pg\_stat\_reset\_single\_function\_counters\(oid\)

描述：为当前数据库中的一个函数重置统计为0（需要系统管理员权限）。

返回值类型：void

- pg\_stat\_session\_cu\(int, int, int\)

描述：获取当前节点所运行session的CU命中统计信息。

返回值类型：record

- pg\_stat\_get\_cu\_mem\_hit\(oid\)

描述：获取当前节点当前数据库中一个列存表的CU内存命中次数。

返回值类型：bigint

- pg\_stat\_get\_cu\_hdd\_sync\(oid\)

描述：获取当前节点当前数据库中一个列存表从磁盘同步读取CU次数。

返回值类型：bigint

- pg\_stat\_get\_cu\_hdd\_asyn\(oid\)

描述：获取当前节点当前数据库中一个列存表从磁盘异步读取CU次数。

返回值类型：bigint

- pg\_stat\_get\_db\_cu\_mem\_hit\(oid\)

描述：获取当前节点一个数据库CU内存命中次数。

返回值类型：bigint

- pg\_stat\_get\_db\_cu\_hdd\_sync\(oid\)

描述：获取当前节点一个数据库从磁盘同步读取CU次数。

返回值类型：bigint

- fenced\_udf\_process\(integer\)

描述：查看本地UDF Master和Work进程数。入参为1时查看master进程数，入参为2时查看worker进程数，入参为3时杀死所有worker进程。

返回值类型：text

- total\_cpu\(\)

描述：获取当前节点使用的CPU时间，单位是jiffies。

返回值类型：bigint

- mot\_global\_memory\_detail\(\)

描述：检查MOT全局内存的大小，主要包括数据和索引。

返回值类型：record

- mot\_local\_memory\_detail\(\)

描述：检查MOT局部内存的大小，主要包括数据和索引。

返回值类型：record

- mot\_session\_memory\_detail\(\)

描述：检查所有会话对MOT内存的使用情况。

返回值类型：record

- total\_memory\(\)

描述：获取当前节点使用的虚拟内存大小，单位KB。

返回值类型：bigint

- pg\_stat\_get\_db\_cu\_hdd\_asyn\(oid\)

描述：获取当前节点一个数据库从磁盘异步读取CU次数。

返回值类型：bigint

- pg\_stat\_bad\_block\(text, int, int, int, int, int, timestamp with time zone, timestamp with time zone\)

描述：获取当前节点自启动后，读取出现Page/CU的损坏信息。

例: select \* from pg\_stat\_bad\_block\(\);

返回值类型：record

- pg\_stat\_bad\_block\_clear\(\)

描述：清理节点记录的读取出现的Page/CU损坏信息（需要系统管理员权限）。

返回值类型：void

- gs\_respool\_exception\_info\(pool text\)

描述：查看某个资源池关联的查询规则信息。

返回值类型：record

- gs\_control\_group\_info\(pool text\)

描述：查看资源池关联的控制组信息

返回值类型：record

返回信息如下：

属性值 name class_a:workload_a1 class和workload名称 class class_a Class控制组名称 workload workload_a1 Workload控制组名称 type DEFWD 控制组类型（Top、CLASS、BAKWD、DEFWD、TSWD） gid 控制组id shares 占父节点CPU资源的百分比 limits 占父节点CPU核数的百分比 rate Timeshare中的分配比例 cpucores 0-3 CPU核心数

- gs\_all\_control\_group\_info\(\)

描述：查看数据库内所有的控制组信息。

返回值类型：record

- gs\_get\_control\_group\_info\(\)

描述：查看所有的控制组信息。

返回值类型：record

- get\_instr\_workload\_info\(integer\)

描述：获取数据库主节点上事务量信息，事务时间信息。

返回值类型：record

属性值 resourcepool_oid 资源池的oid(逻辑同负载等价) commit_counter 前端事务commit数量 rollback_counter 前端事务rollback数量 resp_min 949 前端事务最小响应时间（单位：微秒） resp_max 201891 前端事务最大响应时间（单位：微秒） resp_avg 43564 前端事务平均响应时间(单位：微秒) resp_total 217822 前端事务总响应时间（单位：微秒） bg_commit_counter 910 后端事务commit数量 bg_rollback_counter 后端事务rollback数量 bg_resp_min 后端事务最小响应时间（单位：微秒） bg_resp_max 678080687 后端事务最大响应时间（单位：微秒） bg_resp_avg 327847884 后端事务平均响应时间（单位：微秒） bg_resp_total 298341575300 后端事务总响应时间（单位：微秒）

- pv\_instance\_time\(\)

描述：获取当前节点上各个关键阶段的时间消耗。

返回值类型：record

Stat_name属性 属性值 DB_TIME 1062385 所有线程端到端的墙上时间（WALL TIME）消耗总和(单位： 微秒) CPU_TIME 311777 所有线程CPU时间消耗总和(单位： 微秒) EXECUTION_TIME 380037 消耗在执行器上的时间总和(单位： 微秒) PARSE_TIME 6033 消耗在SQL解析上的时间总和(单位： 微秒) PLAN_TIME 173356 消耗在执行计划生成上的时间总和(单位： 微秒) REWRITE_TIME 2274 消耗在查询重写上的时间总和(单位： 微秒) PL_EXECUTION_TIME 消耗在PL/SQL执行上的时间总和(单位： 微秒) PL_COMPILATION_TIME 557 消耗在SQL编译上的时间总和(单位： 微秒) NET_SEND_TIME 1673 消耗在网络发送上的时间总和(单位： 微秒) DATA_IO_TIME 426622 消耗在数据读写上的时间总和(单位： 微秒) srt1_q 100 Q报文执行的耗时（单位：微秒) srt2_simple_query 100 exec_simple_query执行耗时（单位：微秒) srt3_analyze_rewrite 100 pg_analyze_and_rewrite执行耗时（单位：微秒) srt4_plan_query 100 pg_plan_queries执行耗时（单位：微秒) srt5_light_query 100 exec_query_through_light_proxy执行耗时（单位：微秒) srt6_p 100 P报文执行的耗时（单位：微秒) srt7_b 100 B报文执行的耗时（单位：微秒) srt8_e 100 E报文执行的耗时（单位：微秒) srt9_d 100 D报文执行的耗时（单位：微秒) srt10_s 100 S报文执行的耗时（单位：微秒) srt11_c 100 C报文执行的耗时（单位：微秒) srt12_u 100 U报文执行的耗时（单位：微秒) srt13_before_query 100 进入下一次报文处理前的耗时（单位：微秒) srt14_after_query 100 完成报文处理后的耗时（单位：微秒) rtt_unknown 100 未知时间消耗，可能是session切换耗时（单位：微秒) net_trans_time 100 驱动执行sql的全链路网络耗时，当前仅支持jdbc驱动。（单位：微秒）

- DBE\_PERF.get\_global\_instance\_time\(\)

描述：提供openGauss各个关键阶段的时间消耗，查询该函数必须具有sysadmin权限。

返回值类型：record

- get\_instr\_unique\_sql\(\)

描述：获取当前节点的执行语句（归一化SQL）信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- reset\_unique\_sql\(text, text, bigint\)

描述：重置系统执行语句（归一化SQL）信息，执行该函数必须具有sysadmin权限。第一个参数取值范围“global/local”，global表示清理所有节点上的信息，local表示只清理当前节点；第二参数取值范围“ALL/BY\_USERID/BY\_CNID”，ALL表示清理所有信息，BY\_USERID表示通过指定USERID清理只属于该用户的sql信息，BY\_CNID表示清理系统中涉及到该数据库主节点的sql信息；第三个参数表示具体的CNID和USERID，如果第二个参数为ALL，第三个参数不起作用，可以取任意值。

返回值类型：boolean

>[!NOTE]说明
>此函数中所说节点指分布式节点，当前openGauss为集中式数据库，global与local功能一致，取值范围不支持BY\_CNID。

- get\_instr\_wait\_event\(NULL\) 或 get\_instr\_wait\_event\(integer\)

描述：获取当前节点event等待的统计信息。

返回值类型：record

- get\_instr\_user\_login\(\)

描述：获取当前节点的用户登入登出次数信息，查询该函数必须具有sysadmin或者monitor admin权限。

返回值类型：record

- get\_instr\_rt\_percentile\(integer\)

描述：获取数据库SQL响应时间P80,P95分布信息。

返回值类型：record

- get\_node\_stat\_reset\_time\(\)

描述：获取当前节点的统计信息重置（重启，主备倒换，数据库删除）时间。

返回值类型：record

- DBE\_PERF.get\_global\_os\_runtime\(\)

描述：显示当前操作系统运行的状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_os\_threads\(\)

描述：提供openGauss中所有正常节点下的线程状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_workload\_sql\_count\(\)

描述：提供openGauss中不同负载SELECT，UPDATE，INSERT，DELETE，DDL，DML，DCL计数信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_workload\_sql\_elapse\_time\(\)

描述：提供openGauss中不同负载SELECT，UPDATE，INSERT，DELETE，响应时间信息（TOTAL,AVG, MIN, MAX），查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_workload\_transaction\(\)

描述：获取openGauss内所有节点上的事务量信息，事务时间信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_session\_stat\(\)

描述：获取openGauss节点上的会话状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

>[!NOTE]说明
>
>状态信息有17项：commit、rollback、sql、table\_scan、blocks\_fetched、physical\_read\_operation、
>shared\_blocks\_dirtied、local\_blocks\_dirtied、shared\_blocks\_read、local\_blocks\_read、
>blocks\_read\_time、blocks\_write\_time、sort\_imemory、sort\_idisk、cu\_mem\_hit、
>cu\_hdd\_sync\_read、cu\_hdd\_asyread。

- DBE\_PERF.get\_global\_session\_time\(\)

描述：提供openGauss各节点各个关键阶段的时间消耗，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_session\_memory\(\)

描述：汇聚各节点的Session级别的内存使用情况，包含执行作业在数据节点上Postgres线程和Stream线程分配的所有内存，单位为MB，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_session\_memory\_detail\(\)

描述：汇聚各节点的线程的内存使用情况，以MemoryContext节点来统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- create\_wlm\_session\_info\(int flag\)

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_wlm\_session\_info\(int flag\)

描述：目前该接口已废弃，暂不可用。

- gs\_paxos\_stat\_replication\(\)

描述：在主机端查询备机信息。目前只支持集中式DCF模式。

返回值类型：setofrecord

返回字段说明如下：

字段名称 字段类型 字段说明 local_role text 发送日志节点的角色。
peer_role text 接收日志节点的角色。
local_dcf_role text 发送日志节点的DCF角色。
peer_dcf_role text 接收日志节点的DCF角色。
peer_state text 接收日志节点的状态。
sender_write_location text 发送日志节点写到xlog buffer的位置。
sender_commit_location text 发送日志节点DCF日志达成一致性点。
sender_flush_location text 发送日志节点写到xlog disk的位置。
sender_replay_location text 发送日志节点replay的位置。
receiver_write_location text 接收日志节点写到xlog buffer的位置。
receiver_commit_location text 接收日志节点DCF日志达成一致性点。
receiver_flush_location text 接收日志节点写到xlog disk的位置。
receiver_replay_location text 接收日志节点重演xlog的位置。
sync_percent text 同步百分比。
dcf_run_mode int4 DCF同步模式。
channel text 信道信息。

- gs\_wlm\_get\_resource\_pool\_info\(int\)

描述：目前该接口已废弃，暂不可用。

- gs\_wlm\_get\_all\_user\_resource\_info\(\)

描述：目前该接口已废弃，暂不可用。

- gs\_wlm\_get\_user\_info\(int\)

描述：获取所有用户的相关信息，入参为int类型可以为可以为任意int值或NULL。该函数只有sysadmin权限的用户可以执行。

返回值类型：record

返回字段说明如下： 字段名称 字段类型 字段说明 userid oid 用户OID。
sysadmin boolean 是否是管理员用户。
rpoid oid 关联的资源池的OID。
parentid oid 用户组的OID totalspace bigint 用户可用的空间上限。
spacelimit bigint 用户的表空间限制。
childcount integer 子用户的个数。
childlist text 子用户列表。

- gs\_wlm\_get\_workload\_records\(\)

描述：目前该接口已废弃，暂不可用。

- gs\_wlm\_readjust\_user\_space\(oid)

描述：修正所有用户的存储空间使用情况。该函数只有管理员用户可以执行。

返回值类型：record

>[!NOTE]说明
>
>在use_workload_manager参数由off变为on状态后，不会统计off时的存储资源。如果需要统计off时用户使用的存储资源，在数据库中执行SQL语句：
SELECT gs_wlm_readjust_user_space(0);

- gs\_wlm\_readjust\_user\_space\_through\_username\(text name\)

描述：修正指定用户的存储空间使用情况。该函数普通用户只能修正自己的使用情况，只有管理员用户可以修正所有用户的使用情况。当name指定位“0000”，表示需要修正所有用户的使用情况。

返回值类型：record

- gs\_wlm\_readjust\_user\_space\_with\_reset\_flag\(text name, boolean isfirst\)

描述：修正指定用户的存储空间使用情况。入参isfirst为true表示从0开始统计，否则从上一次结果继续统计。该函数普通用户只能修正自己的使用情况，只有管理员用户可以修正所有用户的使用情况。当name指定位“0000”，表示需要修正所有用户的使用情况。

返回值类型：record

- gs\_wlm\_session\_respool\(bigint\)

描述：目前该接口已废弃，暂不可用。

- gs\_wlm\_get\_session\_info\(\)

描述：目前该接口已废弃，暂不可用。

- gs\_wlm\_get\_user\_session\_info\(\)

描述：目前该接口已废弃，暂不可用。

- gs\_io\_wait\_status\(\)

描述：目前该接口不支持单机和集中式，暂不可用。

- global\_stat\_get\_hotkeys\_info\(\)

描述：获取整个数据库实例中热点key的统计情况。目前该接口不支持单机和集中式，暂不可用。

- global\_stat\_clean\_hotkeys\(\)

描述：清理整个数据库实例中热点key的统计信息。目前该接口不支持单机和集中式，暂不可用。

- DBE\_PERF.get\_global\_session\_stat\_activity\(\)

描述：汇聚openGauss内各节点上正在运行的线程相关的信息，查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_thread\_wait\_status\(\)

描述：汇聚所有节点上工作线程（backend thread）以及辅助线程（auxiliary thread）的阻塞等待情况，查询该函数必须具有sysadmin和monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_operator\_history\_table\(\)

描述：汇聚当前用户数据库主节点上执行作业结束后的算子相关记录（持久化），查询该函数必须具有sysadmin和monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_operator\_history\(\)

描述：汇聚当前用户数据库主节点上执行作业结束后的算子相关记录，查询该函数必须具有sysadmin和monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_operator\_runtime\(\)

描述：汇聚当前用户数据库主节点上执行作业实时的算子相关记录，查询该函数必须具有sysadmin和monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statement\_complex\_history\(\)

描述：汇聚当前用户数据库主节点上复杂查询的历史记录，查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statement\_complex\_history\_table\(\)

描述：汇聚当前用户数据库主节点上复杂查询的历史记录（持久化），查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statement\_complex\_runtime\(\)

描述：汇聚当前用户数据库主节点上复杂查询的实时信息，查询该函数必须具有sysadmin和monadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_memory\_node\_detail\(\)

描述：汇聚所有节点某个数据库节点内存使用情况，查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_shared\_memory\_detail\(\)

描述：汇聚所有节点已产生的共享内存上下文的使用信息，查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_all\_indexes\(\)

描述：汇聚所有节点当前数据库中的每个索引行，显示特定索引的I/O的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_all\_tables\(\)

描述：显示汇聚各节点数据中每个表（包括TOAST表）的一行的统计信息

返回值类型：record

- DBE\_PERF.get\_global\_stat\_all\_tables\(\)

描述：显示各节点数据中每个表（包括TOAST表）的一行的统计信息。

返回值类型：record

- DBE\_PERF.get\_local\_toastname\_and\_toastindexname\(\)

描述：提供本地toast表的name和index和其关联表的对应关系，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_all\_indexes\(\)

描述：统计所有节点当前数据库中的每个索引行，显示特定索引的I/O的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_all\_sequences\(\)

描述：提供命名空间中所有sequences的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_all\_tables\(\)

描述：汇聚各节点的数据库中每个表I/O的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_all\_tables\(\)

描述：统计openGauss内数据库中每个表I/O的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_local\_toast\_relation\(\)

描述：提供本地toast表的name和其关联表的对应关系，查询该函数必须具有sysadmin权限

返回值类型：record

- DBE\_PERF.get\_global\_statio\_sys\_indexes\(\)

描述：汇聚各节点的命名空间中所有系统表索引的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_sys\_indexes\(\)

描述：统计各节点的命名空间中所有系统表索引的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_sys\_sequences\(\)

描述：提供命名空间中所有系统表为sequences的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_sys\_tables\(\)

描述：提供各节点的命名空间中所有系统表的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_sys\_tables\(\)

描述：openGauss内汇聚命名空间中所有系统表的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_user\_indexes\(\)

描述：各节点的命名空间中所有用户关系表索引的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_user\_indexes\(\)

描述：openGauss内汇聚命名空间中所有用户关系表索引的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_user\_sequences\(\)

描述：显示各节点的命名空间中所有用户的sequences的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statio\_user\_tables\(\)

描述：显示各节点的命名空间中所有用户关系表的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statio\_user\_tables\(\)

描述：openGauss内汇聚命名空间中所有用户关系表的IO状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_stat\_db\_cu\(\)

描述：视图查询openGauss各个节点，每个数据库的CU命中情况，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_all\_indexes\(\)

描述：汇聚所有节点数据库中每个索引的统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_all\_indexes\(\)

描述：统计所有节点数据库中每个索引的统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_sys\_tables\(\)

描述：汇聚各节点pg\_catalog、information\_schema模式的所有命名空间中系统表的统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_sys\_tables\(\)

描述：统计各节点pg\_catalog、information\_schema模式的所有命名空间中系统表的统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_sys\_indexes\(\)

描述：汇聚各节点pg\_catalog、information\_schema模式中所有系统表的索引状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_sys\_indexes\(\)

描述：统计各节点pg\_catalog、information\_schema模式中所有系统表的索引状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_user\_tables\(\)

描述：汇聚所有命名空间中用户自定义普通表的状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_user\_tables\(\)

描述：统计所有命名空间中用户自定义普通表的状态信息，查询该函数必须具有monitoradmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_user\_indexes\(\)

描述：汇聚所有数据库中用户自定义普通表的索引状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_user\_indexes\(\)

描述：统计所有数据库中用户自定义普通表的索引状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_database\(\)

描述：汇聚所有节点数据库统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_database\_conflicts\(\)

描述：统计所有节点数据库统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_xact\_all\_tables\(\)

描述：汇聚命名空间中所有普通表和toast表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_xact\_all\_tables\(\)

描述：统计命名空间中所有普通表和toast表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_xact\_sys\_tables\(\)

描述：汇聚所有节点命名空间中系统表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_xact\_sys\_tables\(\)

描述：统计所有节点命名空间中系统表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_xact\_user\_tables\(\)

描述：汇聚所有节点命名空间中用户表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_stat\_xact\_user\_tables\(\)

描述：统计所有节点命名空间中用户表的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_user\_functions\(\)

描述：汇聚所有节点命名空间中用户定义函数的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_xact\_user\_functions\(\)

描述：统计所有节点命名空间中用户定义函数的事务状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_stat\_bad\_block\(\)

描述：汇聚所有节点表、索引等文件的读取失败信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_file\_redo\_iostat\(\)

描述：统计所有节点表、索引等文件的读取失败信息，查询该函数必须具有sysadmin权限。

返回值类型：record

示例：

    ```sql
    openGauss=# select * from DBE_PERF.get_global_file_redo_iostat();
     node_name | phywrts | phyblkwrt | writetim | avgiotim | lstiotim | miniotim | maxiowtm
    -----------+---------+-----------+----------+----------+----------+----------+----------
    ```

- DBE\_PERF.get\_global\_file\_iostat\(\)

描述：汇聚所有节点数据文件IO的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_locks\(\)

描述：汇聚所有节点的锁信息，查询该函数必须具有sysadmin和monadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_replication\_slots\(\)

描述：汇聚所有节点上逻辑复制信息，查询该函数必须具有sysadmin和monadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_bgwriter\_stat\(\)

描述：汇聚所有节点后端写线程活动的统计信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_replication\_stat\(\)

描述：汇聚各节点日志同步状态信息，如发起端发送日志位置，收端接收日志位置等，查询该函数必须具有sysadmin和monadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_transactions\_running\_xacts\(\)

描述：汇聚各节点运行事务的信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_transactions\_running\_xacts\(\)

描述：统计各节点运行事务的信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_transactions\_prepared\_xacts\(\)

描述：汇聚各节点当前准备好进行两阶段提交的事务的信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_transactions\_prepared\_xacts\(\)

描述：统计各节点当前准备好进行两阶段提交的事务的信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_statement\(\)

描述：汇聚各节点历史执行语句状态信息，查询该函数必须具有monitor admin和sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_statement\_count\(\)

描述：汇聚各节点SELECT，UPDATE，INSERT，DELETE，响应时间信息（TOTAL,AVG, MIN, MAX），查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_config\_settings\(\)

描述：汇聚各节点GUC参数配置信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_wait\_events\(\)

描述：汇聚各节点wait events状态信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_statement\_responsetime\_percentile\(\)

描述：获取openGaussSQL响应时间P80，P95分布信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_summary\_user\_login\(\)

描述：统计openGauss各节点用户登入登出次数信息，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.get\_global\_record\_reset\_time\(\)

描述：汇聚openGauss统计信息重置（重启，主备倒换，数据库删除）时间，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.track\_memory\_context\(context\_list text\)

描述：目前该接口已废弃，暂不可用。

- DBE\_PERF.track\_memory\_context\_detail\(\)

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_mem\_mbytes\_reserved\(tid\)

描述：统计资源管理相关变量值，仅用于定位问题使用。

参数：线程id。

返回值类型：text

- gs\_wlm\_user\_resource\_info\(name text\)

描述：目前该接口已废弃，暂不可用。

- pg\_stat\_get\_file\_stat\(\)

描述：通过对数据文件IO的统计，反映数据的IO性能，用以发现IO操作异常等性能问题。

返回值类型: record

- pg\_stat\_get\_redo\_stat\(\)

描述：用于统计会话线程日志回放情况。

返回值类型: record

示例：

    ```sql
    openGauss=# select * from pg_stat_get_redo_stat();
     phywrts | phyblkwrt | writetim | avgiotim | lstiotim | miniotim | maxiowtm
    ---------+-----------+----------+----------+----------+----------+----------
    ```

函数返回字段如下：

phywrts int8 向 wal buffer 中写的次数。
phyblkwrt int8 向 wal buffer 中写的block的块数。
writetim int8 向 xlog 文件中写操作的时间（单位：微秒）。
avgiotim int8 平均写 xlog 的时间（单位：微秒）。
lstiotim int8 最后一次写 xlog 的时间（单位：微秒）。
miniotim int8 最小的写 xlog 时间（单位：微秒）。
maxiowtm int8 最大的写 xlog 时间（单位：微秒）。

- pg\_stat\_get\_status\(int8\)

描述：可以检测当前实例中工作线程（backend thread）以及辅助线程（auxiliary thread）的阻塞等待情况。

返回值类型：record

- get\_local\_rel\_iostat\(\)

描述：查询当前节点的数据文件IO状态累计值。

返回值类型：record

- DBE\_PERF.get\_global\_rel\_iostat\(\)

描述：汇聚所有节点数据文件IO的统计，查询该函数必须具有sysadmin权限。

返回值类型：record

- DBE\_PERF.global\_threadpool\_status\(\)

描述：显示在所有节点上的线程池中工作线程及会话的状态信息。函数返回信息具体字段[GLOBAL\_THREADPOOL\_STATUS](global_threadpool_status.md)字段。

返回值类型：record

- remote\_bgwriter\_stat\(\)

描述：显示数据库所有实例的bgwriter线程刷页信息，候选buffer链中页面个数，buffer淘汰信息（本节点除外、DN上不可使用）。

返回值类型：record

- pv\_os\_run\_info

描述：显示当前操作系统运行的状态信息，具体字段信息参考[GS\_OS\_RUN\_INFO](../database_reference/gs_os_run_info.md)。

参数：nan

返回值类型：setof record

- pv\_session\_stat

描述：以会话线程或AutoVacuum线程为单位，统计会话状态信息，具体字段信息参考[GS\_SESSION\_STAT](../database_reference/gs_session_stat.md)。

参数：nan

返回值类型：setof record

- pv\_session\_time

描述：用于统计会话线程的运行时间信息，及各执行阶段所消耗时间，具体字段信息参考[GS\_SESSION\_TIME](../database_reference/gs_session_time.md)。

参数：nan

返回值类型：setof record

- pg\_stat\_get\_db\_temp\_bytes

描述：用于统计通过数据库查询写入临时文件的数据总量。计算所有临时文件，不论为什么创建临时文件，而且不管log\_temp\_files设置。

参数：oid

返回值类型：bigint

- pg\_stat\_get\_db\_temp\_files

描述：通过数据库查询创建的临时文件数量。计算所有临时文件，不论为什么创建临时文件（比如排序或者哈希），而且不管log\_temp\_files设置。

参数：oid

返回值类型：bigint

- remote\_candidate\_stat\(\)

描述：用于显示数据库所有实例的检查点信息和各类日志刷页情况（本节点除外），集中式不支持。

返回值类型：record

- dbe\_perf.gs\_stat\_activity\_timeout\(int\)

描述：获取当前节点上执行时间超过超时阈值的查询作业信息。需要GUC参数track\_activities设置为on才能正确返回结果。超时阈值的取值范围是0\~2147483。

返回值类型：setof record

database name 用户会话连接的数据库名称。
pid bigint 后台线程ID。
sessionid bigint 会话ID。
usesysid oid 登录该后台的用户OID。
application_name text 连接到该后台的应用名。
query text 该后台正在执行的查询。
xact_start timestamptz 启动当前事务的时间。
query_start timestamptz 开始当前查询的时间。
query_id bigint 查询语句ID。

- gs\_wlm\_user\_resource\_info\(name text\)

描述：目前该接口已废弃，暂不可用。

- create\_wlm\_instance\_statistics\_info

描述：目前该接口已废弃，暂不可用。

- gs\_session\_memory

描述：统计Session级别的内存使用情况，包含执行作业在数据节点上Postgres线程和Stream线程分配的所有内存。

>[!NOTE]说明
>若GUC参数enable\_memory\_limit=off，该函数不能使用。

返回值类型：record

**表 8**  返回值说明

sessid text 线程启动时间+线程标识。
init_mem integer 当前正在执行作业进入执行器前已分配的内存，单位MB。
used_mem integer 当前正在执行作业已分配的内存，单位MB。
peak_mem integer 当前正在执行作业已分配的内存峰值，单位MB。

- gs\_wlm\_persistent\_user\_resource\_info\(\)

描述：目前该接口已废弃，暂不可用。

- create\_wlm\_operator\_info\(int flag\)

描述：目前该接口已废弃，暂不可用。

- GS\_ALL\_NODEGROUP\_CONTROL\_GROUP\_INFO\(text\)

描述：目前该接口已废弃，暂不可用。

    ```
    SELECT * FROM GS_ALL_NODEGROUP_CONTROL_GROUP_INFO('InstallationGuide')
    ```

返回值类型：record

函数返回字段如下：

name text 控制组的名称。
type text 控制组的类型。
gid bigint 控制组ID。
classgid bigint Workload所属Class的控制组ID。
class text Class控制组。
workload text Workload控制组。
shares bigint 控制组分配的CPU资源配额。
limits bigint 控制组分配的CPU资源限额。
wdlevel bigint Workload控制组层级。
cpucores text 控制组使用的CPU核的信息。

- gs\_total\_nodegroup\_memory\_detail

描述：目前该接口已废弃，暂不可用。

- local\_redo\_time\_count\(\)

描述：返回本节点各个回放线程的各个流程的耗时统计（仅在备机上有有效数据）。

示例：

    ```sql
    openGauss=# select * from local_redo_time_count();
     thread_name | step1_total | step1_count | step2_total | step2_count | step3_total | step3_count | step4_total | step4_count | step5_total | step5_count | step6_total | step6_count | step7_total | step7_count | step8_total | step8_count | step9_total | step9_count
    -------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------
    ```

返回值如下：

local\_redo\_time\_count返回参数说明。

字段名 thread_name 线程名字 step1_total step1的总时间，每个线程对应的流程如下： 极致RTO： batch redo：从队列中获取一条日志redo manager：从队列中获取一条日志redo worker：从队列中获取一条日志trxn manager：从队列中读取一条日志trxn worker：从队列中读取一条日志read worker：从文件中读取一次xlog page（整体）read page worker：从队列中获取一个日志startup：从队列中获取一个日志 并行回放： page redo：从队列中获取一条日志startup：读取一条日志 step1_count step1的统计次数 step2_total step2的总时间，每个线程对应的流程如下： 极致RTO： batch redo：处理日志（整体）redo manager：处理日志（整体）redo worker：处理日志（整体）trxn manager：处理日志（整体）trxn worker：处理日志（整体）redo worker：读取xlog page耗时read page worker：生成和发送lsn forwarderstartup：check stop(是否回放到指定位置） 并行回放： page redo：处理日志（整体）startup：check stop(是否回放到指定位置） step2_count step2的统计次数 step3_total step3的总时间，每个线程对应的流程如下： 极致RTO： batch redo：更新standbystateredo manager：数据日志处理redo worker：回放page也日志（整体）trxn manager：更新flush lsntrxn worker：回放日志处理redo worker：推进xlog segmentread page worker：获取一个新的itemstartup：redo delay（延迟回放特性等待时间） 并行回放： page redo：更新standbystatestartup：redo delay（延迟回放特性等待时间） step3_count step3的统计次数 step4_total step4的总时间，每个线程对应的流程如下： 极致RTO： batch redo：解析xlogredo manager：DDL处理redo worker：读取数据page页trxn manager：同步等待时间trxn worker：更新本线程lsnread page worker：将日志放入分发线程startup：分发（整体） 并行回放： page redo：undo 日志回放startup：分发（整体） step4_count step4的统计次数 step5_total step5的总时间，每个线程对应的流程如下： 极致RTO： batch redo：分发给redo managerredo manager：分发给redo workerredo worker：回放数据page页的日志trxn manager：分发给trxn workertrxn worker：强同步wait时间read page worker：更新本线程lsnstartup：日志decode 并行回放： page redo：sharetrxn 日志回放startup：日志回放 step5_count step5的统计次数 step6_total step6的总时间，每个线程对应的流程如下： 极致RTO： redo worker：回放非数据页page日志trxn manager：全局lsn更新read page worker：日志crc校验 并行回放： page redo：synctrxn 日志回放startup：强同步等待 step6_count step6的统计次数 step7_total step7的总时间，每个线程对应的流程如下： 极致RTO： redo worker：fsm更新 并行回放： page redo：single 日志回放 step7_count step7的统计次数 step8_total step8的总时间，每个线程对应的流程如下： 极致RTO： redo worker：强同步等待 并行回放： page redo：all workers do 日志回放 step8_count step8的统计次数 step9_total step9的总时间，每个线程对应的流程如下： 极致RTO： 并行回放： page redo：muliti workers do 日志回放 step9_count step9的统计次数

- local\_xlog\_redo\_statics\(\)

描述：返回本节点已经回放的各个类型类型的日志统计信息（仅在备机上有有效数据）。

示例：

    ```sql
    openGauss=# select * from local_xlog_redo_statics();
     xlog_type | rmid | info | num | extra
    -----------+------+------+-----+-------
    ```

返回值如下：

**表 9**  local\_xlog\_redo\_statics返回参数说明

字段名 xlog_type 日志类型 rmid resource manager id info xlog operation num 日志个数 extra 针对page回放日志和xact日志有有效值。page页回放日志标识从磁盘读取page的个数。xact日志表示删除文件的个数。

- gs\_get\_shared\_memctx\_detail\(text\)

描述：返回指定内存上下文上的内存申请的详细信息，包含每一处内存申请所在的文件、行号和大小（同一文件同一行大小会做累加）。只支持查询通过pg\_shared\_memory\_detail视图查询出来的内存上下文，入参为内存上下文名称（即pg\_shared\_memory\_detail返回结果的contextname列）。查询该函数必须具有sysadmin权限或者monitor admin权限，且需要内存保护功能开启。

返回值类型：setof record

file text 申请内存所在文件的文件名。
line int8 申请内存所在文件的代码行号。
size int8 申请的内存大小，同一文件同一行多次申请会做累加。

>[!NOTE]说明
>该视图不支持release版本小型化场景。

- gs\_get\_history\_memory\_detail\(cstring\)

描述：查询历史内存快照信息，入参类型为cstring，取值为NULL或内存快照log文件名称：

  1. 若入参为NULL，则显示当前节点所有的内存快照log文件列表。
  2. 若入参为1查询到的列表中的内存快照log名称，则显示该log文件记录的内存快照详细信息。
  3. 若输入其他入参，则会提示入参错误或打开文件失败。

查询该函数必须具有sysadmin权限或者monitor admin权限。

返回值类型：text

memory_info text 内存信息，如果函数入参为NULL，该列显示内存快照文件列表信息；入参为内存快照文件名称，则显示该文件的具体内容。

- gs\_stack\(\)

描述：显示线程调用栈。查询该函数需要有sysadmin权限或者monadmin权限。

参数：tid，线程id。tid是可选参数，指定tid参数时，函数返回tid对应线程调用栈；当不指定tid参数时，函数返回所有线程的调用栈。

返回值：当指定tid时，返回值为text；当不指定tid时，返回值为setof record。

示例：

    ```
    openGauss=# SELECT gs_stack(139663481165568);
                                  gs_stack
    --------------------------------------------------------------------
     __poll + 0x2d                                                     +
     WaitLatchOrSocket(Latch volatile*, int, int, long) + 0x29f        +
     WaitLatch(Latch volatile*, int, long) + 0x2e                      +
     JobScheduleMain() + 0x90f                                         +
     int GaussDbThreadMain(knl_thread_arg*) + 0x456+
     InternalThreadFunc(void*) + 0x2d                                  +
     ThreadStarterFunc(void*) + 0xa4                                   +
     start_thread + 0xc5                                               +
     clone + 0x6d                                                      +
    (1 row)
    ```

- gs\_get\_session\_memctx\_detail\(text\)

描述：返回指定内存上下文上的内存申请的详细信息，包含每一处内存申请所在的文件、行号和大小（同一文件同一行大小会做累加）。仅在线程池模式下生效。只支持查询通过gs\_session\_memory\_context视图查询出来的内存上下文，入参为内存上下文名称（即gs\_session\_memory\_context返回结果的contextname列）。查询该函数必须具有sysadmin权限或者monitor admin权限，且需要内存保护功能开启。

返回值类型：setof record

file text 申请内存所在文件的文件名。
line int8 申请内存所在文件的代码行号。
size int8 申请的内存大小，同一文件同一行多次申请会做累加。

>[!NOTE]说明
>该视图仅在线程池模式下生效，且该视图不支持release版本小型化场景。

- gs\_get\_thread\_memctx\_detail\(tid,text\)

描述：返回指定内存上下文上的内存申请的详细信息，包含每一处内存申请所在的文件，行号和大小（同一文件同一行大小会做累加）。只支持查询通过gs\_thread\_memory\_context视图查询出来的内存上下文，第一个入参为线程id（即gs\_thread\_memory\_context返回数据的tid列），第二个参数为内存上下文名称（即gs\_thread\_memory\_context返回数据的contextname列）。查询该函数必须具有sysadmin权限或者monitor admin权限，且需要内存保护功能开启。

返回值类型：setof record

file text 申请内存所在文件的文件名。
line int8 申请内存所在文件的代码行号。
size int8 申请的内存大小，单位为byte，同一文件同一行多次申请会做累加。

  1. 若入参为[1]查询到的列表中的内存快照log名称，则显示该log文件记录的内存快照详细信息。

  2. 若输入其他入参，则会提示入参错误或打开文件失败。

查询该函数必须具有sysadmin权限或者monitor admin权限。

返回值类型：text

  >[!NOTE]说明
  >该视图不支持release版本小型化场景。

- DBE_PERF.standby_statement_history(bool \[, time1, time2\])

参数：
  - bool only_slow：是否仅查询慢SQL，true为是，false或NULL为查询全部SQL。
  - VARIADIC timestamptz finish_time: 可选输入，最多输入两个时间time1, time2，表示查询的SQL的finish_time所属时间段。

描述：备机中用来查询FULL SQL记录的函数，主机通过表statement_history进行查询，备机通过此函数进行查询。只有初始用户或者具有monadmin权限的用户可以执行该函数。

返回值类型：record，同表statement_history。

>[!NOTE]说明
>
> - 第一个bool参数的说明： true表示仅查询慢sql，相当于 select .. where is_slow_sql = true; false或NULL表示查询全部SQL，相当于不对is_slow_sql进行过滤。
>
> - 两个时间参数time1 time2的说明：表示查询的SQL的finish_time所属时间段, 分别表示起始与终止时间, 输入NULL或者不输入表示没有限制, 功能等同与 select .. where finish_time between time1 and time2。
>
> - 备机上数据并非存在表里，不存在start_time列的索引，推荐使用参数对finish_time进行条件查找，内部有对这进行一些性能的优化。但注意修改了系统时间可能会导致此功能不准确。
>
> - 查询结果基本会是按照finish_time自动进行降序（新到旧）排序的。
>
> - 除了FunctionScan算子计算过程本身之外，对于数据的扫描会额外占用16或32M内存来做一个临时buffer。
>
> - 此函数的稳定性等级为'v'。
>
> - 由于备机Full SQL采用异步下盘方式，所以用户SQL信息存储时刻可能有所滞后，建议客户查询此接口适当扩大时间查询范围。

- DBE_PERF.get_statement_history(start_time_point, finish_time_point)

参数：
  - timestamptz start_time_point: start_time时间节点，用于查询主机start_time大于start_time_point的慢SQL记录。
  - timestamptz finish_time_point: finish_time时间节点，用于查询备机finish_time大于finish_time_point的慢SQL记录。

描述：用来查询数据库某个时间节点之后执行的所有慢SQL记录，实现主备慢SQL一致性查询，在主机执行时需指定start_time_point，在备机执行时需指定finish_time_point。

返回值类型：record，同表statement_history。

主机查询示例：

    ```
    openGauss=# select db_name, schema_name, query, start_time, finish_time from dbe_perf.get_statement_history('2025-08-01', NULL);
     db_name  |  schema_name   |        query        |          start_time           |          finish_time
    ----------+----------------+---------------------+-------------------------------+-------------------------------
     postgres | "$user",public | select pg_sleep(?); | 2025-08-09 10:21:10.597625+08 | 2025-08-09 10:21:13.598819+08
     postgres | "$user",public | select pg_sleep(?); | 2025-08-09 10:38:34.229318+08 | 2025-08-09 10:38:38.230102+08
    (2 rows)

    ```

备机查询示例：

    ```
    openGauss=# select db_name, schema_name, query, start_time, finish_time from dbe_perf.get_statement_history(NULL, '2025-08-01');
     db_name  |  schema_name   |        query        |          start_time           |          finish_time
    ----------+----------------+---------------------+-------------------------------+-------------------------------
     postgres | "$user",public | select pg_sleep(?); | 2025-08-09 14:31:45.784688+08 | 2025-08-09 14:31:50.785979+08
    (1 row)

    ```

- gs\_hot\_standby\_space\_info\(\)

描述：查询standby\_read/base\_page，standby\_read/block\_info\_meta，standby\_read/lsn\_info\_meta文件夹中的文件总数和总大小。

返回值类型：setof record base_page_file_num xid bage_page_file的总数量。
base_page_total_size xid bage_page_file的总大小。
lsn_info_meta_file_num xid lsn_info_meta_file的总数量。
lsn_info_meta_total_size xid lsn_info_meta_file的总大小。
block_info_meta_file_num xid block_info_meta_file的总数量。
block_info_meta_total_size xid block_info_meta_file的总大小。
示例：

    ```
    openGauss=# select * from gs_hot_standby_space_info();
     base_page_file_num | base_page_total_size | lsn_info_meta_file_num | lsn_info_meta_total_size | block_info_meta_file_num | block_info_meta_total_size
    --------------------+----------------------+------------------------+--------------------------+--------------------------+----------------------------
                      6 |               163840 |                      6 |                     3136 |                       16 |                     147456
    (1 row)

    ```

- gs_lwlock_status()

描述：查看当前系统内轻量级锁的持锁、等锁情况。

返回值类型：setofrecord

示例：

    ```sql
    openGauss=# select * from gs_lwlock_status();
    node_name | lock_name | lock_unique_id | pid | sessionid | global_sessionid | mode | granted | start_time | tag
    -----------+-----------+----------------+-----+-----------+------------------+------+---------+------------+-----
    (0 rows)
    ```

返回字段说明如下：

**表 1**  返回字段说明

字段名称 字段类型 字段说明 node_name text 节点名称 lock_name text 轻量级锁的名字。
lock_unique_id bigint 轻量级锁的唯一ID。
pid bigint 持锁或等锁人的线程ID。
sessionid bigint 持锁或等锁人的会话ID。
global_sessionid text 资源池化全局会话ID。
mode text 持锁或等锁的模式。
granted boolean 是否持锁。true为持锁，false为等锁。
start_time timestamp with time zone 持锁或等锁的开始时间。
tag text 锁信息标签。
