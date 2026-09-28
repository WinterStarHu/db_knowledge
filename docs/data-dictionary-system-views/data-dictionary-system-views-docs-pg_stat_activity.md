# PG\_STAT\_ACTIVITY

PG\_STAT\_ACTIVITY视图显示和当前用户查询相关的信息，字段保存的是上一次执行的信息。

**表 1**  PG\_STAT\_ACTIVITY字段

datid oid 用户会话在后台连接到的数据库OID。
datname name 用户会话在后台连接到的数据库名称。
pid bigint 后台线程ID。
sessionid bigint 会话ID。
usesysid oid 登录该后台的用户OID。
usename name 登录该后台的用户名。
application_name text 连接到该后台的应用名。
client_addr inet 连接到该后台的客户端的IP地址。 如果此字段是null，它表明通过服务器机器上UNIX套接字连接客户端或者这是内部进程，如autovacuum。
client_hostname text 客户端的主机名，这个字段是通过client_addr的反向DNS查找得到。这个字段只有在启动log_hostname且使用IP连接时才非空。
client_port integer 客户端用于与后台通讯的TCP端口号，如果使用Unix套接字，则为-1。
backend_start timestamp with time zone 该过程开始的时间，即当客户端连接服务器时。
xact_start timestamp with time zone 启动当前事务的时间，如果没有事务是活跃的，则为null。如果当前查询是首个事务，则这列等同于query_start列。
query_start timestamp with time zone 开始当前活跃查询的时间， 如果state的值不是active，则这个值是上一个查询的开始时间。
state_change timestamp with time zone 上次状态改变的时间。
waiting boolean 如果后台当前正等待锁则为true。
enqueue text 该字段不支持。
state text resource_pool name 用户使用的资源池。
query_id bigint 查询语句的ID。
query text 该后台的最新查询。如果state状态是active（活跃的），此字段显示当前正在执行的查询。所有其他情况表示上一个查询。
connection_info text json格式字符串，记录当前连接数据库的驱动类型、驱动版本号、当前驱动的部署路径、进程属主用户等信息（参见connection_info）。
unique_sql_id bigint 语句的unique sql id。
trace_id text 驱动传入的trace id，与应用的一次请求相关联。
注：目前支持记录存储过程中的PL/SQL信息，对于PL/SQL, query字段的显示稍有变化，会将目前执行的顶层语句，当前执行语句的上一层语句以及当前执行的语句一同放进query字段进行显示。
结构如下：query string: 顶层调用的存储过程或函数 current level: 当前语句的父语句 ; execute stmt: 当前正在执行的语句
