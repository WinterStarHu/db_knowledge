# Parameter Modifications

> 来源: https://www.tencentcloud.com/document/product/236/11269

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Parameter Modifications Parameter Modifications Download Focus Mode Font Size Last updated: 2024-11-27 10:52:26 How do I modify the configuration parameters of a TencentDB for MySQL instance?
In the TencentDB for MySQL console, click the instance ID in the instance list and enter the management page. Select Database Management > Parameter Settings. Common var\_name includes:
Variable

Description

character_set_server

Default character set of the server

connect_timeout

Connection timeout period

long_query_time

A query that takes longer than this time is a slow query.

max_allowed_packet

Maximum packet length

max_connections

Maximum number of connections

sql_mode

Current SQL mode of the server

table_open_cache

Number of tables opened by all threads. Increasing this value will increase the number of file descriptors that mysqld is requested to open.

wait_timeout

Non-interactive connection timeout period You can view more configuration parameters in Database Management > Parameter Settings in the console.
Does TencentDB for MySQL Support Queries by Using Chinese Commands?
Currently, TencentDB for MySQL does not support queries by using Chinese commands. For instance, querying the information of an instance with the ID cdb-nieng1e.
How do I enable the scheduler feature in TencentDB for MySQL?
In the TencentDB for MySQL console, click the instance ID in the instance list and enter the management page. Select Database Management > Parameter Settings and set the event_scheduler parameter to ON.
How do I increase the connection timeout period in TencentDB for MySQL?
In the TencentDB for MySQL console, click the instance ID in the instance list and enter the management page. Select Database Management > Parameter Settings and modify the wait_timeout parameter.
How do I modify the group_concat_max_len parameter in TencentDB for MySQL?
In the TencentDB for MySQL console, click the instance ID in the instance list and enter the management page. Select Database Management > Parameter Settings and modify the group_concat_max_len parameter.
How do I locate the SQL statements for full-table scan in TencentDB for MySQL?
Full-table scan statements are not recorded by default. To locate them, set the log_queries_not_using_indexes parameter to ON in Parameter Settings in the TencentDB for MySQL console. We recommend that you only enable this parameter for a short period of time.
How do I change the default character set in TencentDB?
TencentDB for MySQL supports LATIN1, GBK, UTF8 (default), and UTF8MB4 character sets.
Although TencentDB supports changing the default character set, we recommend that you explicitly specify the table encoding when creating a table and specify the connection encoding when establishing a connection for more portable application experience. For more information on MySQL default character set and how to modify it, see Use Limits. You can also modify the character set in the MySQL Console.
How do I view the character set collation in TencentDB?
TencentDB for MySQL allows you to set the character set collation when creating an instance. You can select a character set to provide a case-sensitive, accent-sensitive, or binary collation for your data, but doing so will affect the results of relevant database operations.
You can run the show collation command to view the collation.
Sample:
show collation where charset ='utf8mb4';
Collation description Collation Option

Description

_CS

Case-sensitive.

_CI

Case-insensitive.

_AS

Accent-sensitive. This option indicates that the sorting will be accent-sensitive; for example, "a" and "ấ" are different characters.

_AI

Accent-insensitive.

_BIN

Binary.
Character set suffix description Instance Character Set Suffix

Description

_CI_AI

Case-insensitive and accent-insensitive

_CI_AS

Case-insensitive and accent-sensitive

_CS_AI

Case-sensitive and accent-insensitive

_CS_AS

Case-sensitive and accent-sensitive What should I do if the lower_case_table_names parameter failed to be modified?
You can modify the lower_case_table_names parameter in the TencentDB for MySQL console. If it is set to 1, the case-insensitive mode is enabled. Pay attention to the following when modifying the parameter:
Modifying the parameter will restart the instance.
Before modifying the parameter, make sure that all database and table names in the instance are lowercase; otherwise, an error will be reported if any of them is uppercase.
The parameter cannot be modified in MySQL 8.0 as it supports the case-sensitive mode by default.
Check uppercase table names:
select table_schema,table_name from information_schema.tables where   table_schema not in("mysql","information_schema") and (md5(table_name)<>md5(lower(table_name)) or md5(table_schema)<>md5(lower(table_schema)));
Check uppercase database names:
select SCHEMA_NAME from information_schema.SCHEMATA where md5(SCHEMA_NAME)<>md5(lower(SCHEMA_NAME));
Previous Topic: Prohibition of Ping Command Next Topic: Instance Scaling Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I modify the configuration parameters of a TencentDB for MySQL instance?
Does TencentDB for MySQL Support Queries by Using Chinese Commands?
How do I enable the scheduler feature in TencentDB for MySQL?
How do I increase the connection timeout period in TencentDB for MySQL?
How do I modify the group_concat_max_len parameter in TencentDB for MySQL?
How do I locate the SQL statements for full-table scan in TencentDB for MySQL?
How do I change the default character set in TencentDB?
How do I view the character set collation in TencentDB?
What should I do if the lower_case_table_names parameter failed to be modified?
Search AllCurrent Product Search titles only Enter keywords to search documentation
