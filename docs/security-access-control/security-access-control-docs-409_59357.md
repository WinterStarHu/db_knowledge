# Implement Read/Write Separation via pgpool

> 来源: https://www.tencentcloud.com/document/product/409/59357

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases Implement Read/Write Separation via pgpool Implement Read/Write Separation via pgpool Download Focus Mode Font Size Last updated: 2025-06-09 10:27:08 AI-Translated Background When all requests are handled by the primary database, it may cause excessive load on the primary database, resulting in slow response and affecting system stability and scaling capability. If write requests can be sent to the primary database and read requests to the replica database, it can achieve cost allocation of the primary database's load and improve query performance. This approach is called read-write separation. The pgpool tool can act as a proxy layer between the client and the PostgreSQL cluster to intelligently distribute SQL requests.
This article introduces how to configure read-write separation through pgpool.
Prerequisites Two database nodes, one as the primary node and the other as a read-only node.
A CVM with PostgreSQL installed is used to deploy pgpool. The PostgreSQL versions of the CVM and the two database nodes must be consistent.
Step 1: Installing Pgpool Click to download pgpool download link. After downloading the pgpool installation package to your local system, upload the package to the server. For specific upload methods, please refer to Copying Local Files to CVMs.
After upload completion, execute the following commands in sequence to complete the pgpool installation. Among them, the pgpool version number can be modified as needed.
[root@VM-10-6-tencentos ~]# tar -zxvf pgpool-II-4.4.5.tar.gz [root@VM-10-6-tencentos ~]# cd pgpool-II-4.4.5 [root@VM-10-6-tencentos pgpool-II-4.4.5]# ./configure [root@VM-10-6-tencentos pgpool-II-4.4.5]# make [root@VM-10-6-tencentos pgpool-II-4.4.5]# make install After completion, execute the following commands to check whether the installation was successful. If the version information of pgpool is returned, the installation is successful.
[root@VM-10-6-tencentos pgpool-II-4.4.5]# pgpool --version pgpool-II version 4.4.5 (nurikoboshi) Step 2: Modify the Configuration File Note:
Use pgpool to implement CLB access. All authentication occurs between the client and pgpool. Meanwhile, the client still needs to continue the authentication process of PostgreSQL.
1.
Configure the pgpool.conf file Install pgpool-II to automatically generate the pgpool.conf.sample file. Execute the following commands to copy and rename it to pgpool.conf, thereby modifying the configuration file.
[root@VM-0-15-tencentos pgpool-II-4.4.5]# cp /usr/local/etc/pgpool.conf.sample /usr/local/etc/pgpool.conf [root@VM-10-6-tencentos pgpool-II-4.4.5]# vi /usr/local/etc/pgpool.conf Press the i key to enter edit mode and make modifications to the following items.
#listen_addresses = '0.0.0.0'
﻿

#backend_hostname0 = 'database instance IP address'
#backend_port0 = 5432
﻿

#enable_pool_hba = on
You can refer to the important parameters in the following pgpool.conf file.
Note:
The following configuration is an example of key parameters. Please adjust it according to your own business characteristics and conduct strict tests before launch.
Note: The primary instance of TencentDB for PostgreSQL already possesses HA switching ability and does not require pgpool for switching. Therefore, for the backend_flag0 parameter, the primary node needs to be configured as ALWAYS_PRIMARY, and the secondary node needs to be configured as DISALLOW_TO_FAILOVER.
#------------------------------------------------------------------------------
# CONNECTIONS
#------------------------------------------------------------------------------
﻿

# - pgpool Connection Settings -
﻿

#listen_addresses = '0.0.0.0'
# what host name(s) or IP address(es) to listen on;
# comma-separated list of addresses;
# defaults to 'localhost'; use '*' for all
# (change requires restart)
#port = 9989
# Port number
# (change requires restart)
#unix_socket_directories = '/tmp'
# Unix domain socket path(s)
# The Debian package defaults to
# /var/run/postgresql
# (change requires restart)
#unix_socket_group = ''
# The Owner group of Unix domain socket(s)
# (change requires restart)
#reserved_connections = 0
# Number of reserved connections.
# Pgpool-II does not accept connections if over
# num_init_chidlren - reserved_connections.
# - pgpool Communication Manager Connection Settings -
﻿

#pcp_listen_addresses = 'localhost'
# what host name(s) or IP address(es) for pcp process to listen on;
# comma-separated list of addresses;
# defaults to 'localhost'; use '*' for all
# (change requires restart)
#pcp_port = 9898
# Port number for pcp
# (change requires restart)
#pcp_socket_dir = '/tmp'
# Unix domain socket path for pcp
# The Debian package defaults to
# /var/run/postgresql
# (change requires restart)
#listen_backlog_multiplier = 2
# Set the backlog parameter of listen(2) to
# num_init_children * listen_backlog_multiplier.
# (change requires restart)
#serialize_accept = off
# whether to serialize accept() call to avoid thundering herd problem
# (change requires restart)
# - Backend Connection Settings -
﻿

#backend_hostname0 = 'primary node database ip address'
# Host name or IP address to connect to for backend 0
#backend_port0 = 5432
# Port number for backend 0
#backend_weight0 = 1
# Weight for backend 0 (only in load balancing mode)
#backend_data_directory0 = '/data'
# Data directory for backend 0
#backend_flag0 = 'ALWAYS_PRIMARY'
# Controls various backend behavior
# ALLOW_TO_FAILOVER, DISALLOW_TO_FAILOVER
# or ALWAYS_PRIMARY
#backend_application_name0 = 'server0'
# walsender's application_name, used for "show pool_nodes" command
#backend_hostname1 = 'secondary node database ip address'
#backend_port1 = 5433
#backend_weight1 = 1
#backend_data_directory1 = '/data1'
#backend_flag1 = 'DISALLOW_TO_FAILOVER'
#backend_application_name1 = 'server1'
﻿

# - Authentication -
﻿

#enable_pool_hba = on
# Use pool_hba.conf for client authentication
#pool_passwd = 'pool_passwd'
# File name of pool_passwd for md5 authentication.
# "" disables pool_passwd.
# (change requires restart)
#allow_clear_text_frontend_auth = off
# Allow Pgpool-II to use clear text password authentication
# with clients, when pool_passwd does not
# contain the user password
﻿

# - SSL Connections -
﻿

#ssl = off
# Enable SSL support
# (change requires restart)
#------------------------------------------------------------------------------
# POOLS
#------------------------------------------------------------------------------
# - Concurrent session and pool size -
﻿

#num_init_children = 32
# Maximum Number of concurrent sessions allowed
# (change requires restart)
#max_pool = 4
# Number of connection pool caches per connection
# (change requires restart)
﻿

# - Life time -
﻿

#child_life_time = 5min
# Pool exits after being idle for this many seconds
#child_max_connections = 0
# Pool exits after receiving that many connections
# 0 means no exit
#connection_life_time = 0
# Connection to backend closes after being idle for this many seconds
# 0 means no close
#client_idle_limit = 0
# Client is disconnected after being idle for that many seconds
# (even inside an explicit transactions!)
# 0 means no disconnection
﻿

#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------
﻿

#pid_file_name = '/var/run/pgpool/pgpool.pid'
# PID file name
# Can be specified as relative to the"
# location of pgpool.conf file or
# as an absolute path
# (change requires restart)
#logdir = '/tmp'
# Directory of pgPool status file
# (change requires restart)
#------------------------------------------------------------------------------
# CONNECTION POOLING
#------------------------------------------------------------------------------
﻿

#connection_cache = on
# Activate connection pools
# (change requires restart)
﻿

# Semicolon separated list of queries
# to be issued at the end of a session
# The default is for 8.3 and later
#reset_query_list = 'ABORT; DISCARD ALL'
# The following one is for 8.2 and before
﻿

#------------------------------------------------------------------------------
# LOAD BALANCING MODE
#------------------------------------------------------------------------------
﻿

#load_balance_mode = on
# Activate load balancing mode
# (change requires restart)
#ignore_leading_white_space = on
# Ignore leading white spaces of each query
#write_function_list = ''
# Comma separated list of function names
# that write to database
# Regexp are accepted
# If both read_only_function_list and write_function_list
# is empty, function's volatile property is checked.
# If it's volatile, the function is regarded as a
# writing function.
#disable_load_balance_on_write = 'transaction'
# Load balance behavior when write query is issued
# in an explicit transaction.
#
# Valid values:
#
# 'transaction' (default):
#     if a write query is issued, subsequent
#     read queries will not be load balanced
#     until the transaction ends.
#
# 'trans_transaction':
#     if a write query is issued, subsequent
#     read queries in an explicit transaction
#     will not be load balanced until the session ends.
#
#
# 'dml_adaptive':
#     Queries on the tables that have already been
#     modified within the current explicit transaction will
#     not be load balanced until the end of the transaction.
#
# 'always':
#     if a write query is issued, read queries will
#     not be load balanced until the session ends.
#
# Note that any query not in an explicit transaction
# is not affected by the parameter except 'always'.
#statement_level_load_balance = off
# Enables statement level load balancing
#------------------------------------------------------------------------------
# HEALTH CHECK GLOBAL PARAMETERS
#------------------------------------------------------------------------------
﻿

#health_check_period = 0
# Health check period
# Disabled (0) by default
#health_check_timeout = 20
# Health check timeout
# 0 means no timeout
#health_check_user = 'nobody'
# Health check user
#health_check_password = ''
# Password for health check user
# Leaving it empty will make Pgpool-II to first look for the
# Password in pool_passwd file before using the empty password
﻿

#health_check_database = ''
# Database name for health check. If '', tries 'postgres' frist,
#health_check_max_retries = 0
# Maximum number of times to retry a failed health check before giving up.
#health_check_retry_delay = 1
# Amount of time to wait (in seconds) between retries.
#connect_timeout = 10000
# Timeout value in milliseconds before giving up to connect to backend.
# Default is 10000 ms (10 second). Flaky network user may want to increase
# the value. 0 means no timeout.
# Note that this value is not only used for health check,
# but also for ordinary conection to backend.

2.
Configure the pool_passwd password file.
The pool_passwd password file is required when connecting to the database using pgpool. Run the following command to generate the password file. The --username parameter uses the account name for connecting to the cloud database. For example, the account name is dbadmin and the sample password is password. Modify the command as needed. The returned message will be auto-written to the pool_passwd file of Pgpool-II.
[root@VM-10-6-tencentos pgpool-II-4.4.5]# cd /usr/local/bin [root@VM-10-6-tencentos bin]# pg_md5 --md5auth --username=dbadmin password [root@VM-10-6-tencentos bin]# more /usr/local/etc/pool_passwd dbadmin:md50b0cdb5c1d1f30fe83e5a******* Step 3: Configure the PCP Command (Optional) The PCP command is the API of pgpool-II for management features. It is a necessary tool for completing operations such as starting/stopping backend database nodes, viewing node status, and reloading configurations. If you only use pgpool for operations such as load balancing, you can skip this step.
To use the PCP command, user authentication must be performed. This authentication requires defining an additional username and password in the pcp.conf file. First, execute the following commands to copy the pcp.conf.sample file and rename it to pcp.conf, thereby modifying the configuration file.
[root@VM-10-6-tencentos bin]# cd /usr/local/etc [root@VM-10-6-tencentos etc]# cp /usr/local/etc/pcp.conf.sample /usr/local/etc/pcp.conf Execute the following commands to obtain the pcp username and password.
[root@VM-10-6-tencentos etc]# pg_md5 --md5auth --username=pcpuser password2 [root@VM-10-6-tencentos etc]# more /usr/local/etc/pool_passwd dbadmin:md50b0cdb5c1d1f30fe83e5a******* pcpuser:md5907cf835939adc1c736e2******* Copy the returned pcpuser:********, then execute the following commands to edit the pcp.conf file.
[root@VM-10-6-tencentos etc]# vi /usr/local/etc/pcp.conf Press i to enter edit mode, paste the replicated content at the end of the file, then press the esc key to exit edit mode, directly enter :wq to save changes and exit the file.
Step 4: Configure Database Nodes Pgpool - II can implement functions such as load balancing, fault migration, and high availability by configuring multiple backend nodes. To implement read - write separation, use two backend database nodes, one as the primary node and the other as a read - only node. The requirements for the two nodes are as follows:
Node

Function

Master node

Responsible for write operations and read operations (if read - write separation is enabled)

Secondary node

Handle read operations only Execute the following commands. Edit the pgpool.conf configuration file.
[root@VM-10-6-tencentos etc]# vi /usr/local/etc/pgpool.confg Press i to enter edit mode. Find Backend Connection Settings and make the following modifications.
# - Backend Connection Settings -
﻿

#backend_hostname0 = 'primary node ip address'
# Host name or IP address to connect to for backend 0
#backend_port0 = 5432
# Port number for backend 0
#backend_weight0 = 1
# Weight for backend 0 (only in load balancing mode)
#backend_data_directory0 = '/data'
# Data directory for backend 0
#backend_flag0 = 'ALWAYS_PRIMARY'
# Controls various backend behavior
# ALLOW_TO_FAILOVER, DISALLOW_TO_FAILOVER
# or ALWAYS_PRIMARY
#backend_application_name0 = 'server0'
# walsender's application_name, used for "show pool_nodes" command
#backend_hostname1 = 'secondary node ip address'
#backend_port1 = 5433
#backend_weight1 = 1
#backend_data_directory1 = '/data1'
#backend_flag1 = 'DISALLOW_TO_FAILOVER'
#backend_application_name1 = 'server1'
Find LOAD BALANCING MODE. When load_balance_mode is set to true, SELECT queries performed by customers will be distributed to the set multiple database nodes for execution, achieving read-write separation and load balancing.
Press the esc key to exit edit mode, directly enter :wq to save changes and exit the file.
Step 5: Start Up Pgpool-II and Verify Read-Write Separation Since this document uses the source code compilation method to install pgpool-II, the systemd service file will not be automatically generated, and it needs to be created manually. Execute the following commands to create a pgpool user, then create and enter the pgpool.service file:
[root@VM-10-6-tencentos etc]# sudo useradd -r -s /sbin/nologin pgpool [root@VM-10-6-tencentos etc]# vi /etc/systemd/system/pgpool.service Press i to enter edit mode and paste the following content into the file:
[Unit] Description=Pgpool-II connection pool server After=network.target ﻿

[Service] Type=simple User=pgpool Group=pgpool ExecStart=/usr/local/bin/pgpool -n -f /usr/local/etc/pgpool.conf #Here needs to be filled in the file path of pgpool.conf, which can be adjusted according to the actual situation Restart=on-failure ﻿

[Install] WantedBy=multi-user.target Execute the following commands in sequence to load the systemd configuration and start the service:
[root@VM-10-6-tencentos etc]# sudo mkdir -p /var/run/pgpool [root@VM-10-6-tencentos etc]# sudo systemctl daemon-reload [root@VM-10-6-tencentos etc]# sudo systemctl enable pgpool [root@VM-10-6-tencentos etc]# sudo systemctl start pgpool Returned information with "process started" represents that the service has been started successfully.
Note:
Connect to the primary node via CVM and execute the statement "SELECT pg_is_in_recovery();", then disconnect and reconnect and re-query pg_is_in_recovery(). If it alternately returns false and true, it indicates that requests are being alternately sent to the primary database and the replica database, meaning that read-write separation was successful.
[root@VM-0-15-tencentos ~]# /usr/local/pgsql/bin/psql -h127.0.0.1 -p9989 -U dbadmin -d postgres Password for user dbadmin:
psql (15.1) Type "help" for help.
﻿

postgres=> show pool_nodes;
node_id |  hostname   | port | status | pg_status | lb_weight |  role   | pg_role | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_state | last_st atus_change
---------+-------------+------+--------+-----------+-----------+---------+---------+------------+-------------------+-------------------+-------------------+------------------------+--------
-------------
0       | *.*.*.*  | 5432 | up     | unknown   | 0.500000  | primary | unknown | 4          | false             | 0                 |                   |                        | 2024-02 -27 20:04:13 1       | *.*.*.* | 5432 | up     | unknown   | 0.500000  | standby | unknown | 13         | true              | 0                 |                   |                        | 2024-02 -27 20:04:13 (2 rows) ﻿

postgres=> Read-write separation setting is successful.
Previous Topic: Supporting Tiered Storage Based on cos_fdw Extension Next Topic: Implementing Slow SQL Analysis Using the Auto_explain Plugin Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Background Prerequisites Step 1: Installing Pgpool Step 2: Modify the Configuration File Step 3: Configure the PCP Command (Optional) Step 4: Configure Database Nodes Step 5: Start Up Pgpool-II and Verify Read-Write Separation Search AllCurrent Product Search titles only Enter keywords to search documentation
