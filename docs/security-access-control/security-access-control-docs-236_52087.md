# Viewing Audit Log

> 来源: https://www.tencentcloud.com/document/product/236/52087

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Viewing Audit Log Viewing Audit Log Download Focus Mode Font Size Last updated: 2026-04-29 15:05:09 AI-Translated ﻿This document provides information on how to view SQL Insight (Database Audit) logs and describes the fields in the audit log list.
Note:
If the audit mode is rule-based audit, log parsing errors may occur when an SQL statement contains non-ASCII binary characters or special characters. Log parsing is normal if the audit mode is full audit.
When an SQL statement exceeds 32 KB, it may be truncated in logs, which may cause log parsing errors.
SQL statements executed via functions or stored procedures will not be recorded in audit logs.
On July 12, 2023, a new version of the audit log page was released. The audit log search field "Scanned Rows" is a newly added field. For existing audit logs prior to this date, the data for this field will be displayed as "-", and in downloaded files and via API, it will be displayed as "-1".
Uniformly changed the unit of the audit log field Execution Time to microseconds in both the console and downloaded audit log files.
The unit of the audit log field "CPU Time" has been uniformly changed to microseconds in both the console and downloaded audit log files.
Added the display of the millisecond-level time for the unit of the Timestamp field in audit log files.
When audit logs are searched, the character used to separate multiple search terms has been changed from comma to newline.
After SQL Insight (Database Audit) is enabled, the storage regions for audit log files vary for instances in Tianjin, Taipei (China), and Shenzhen. The corresponding storage regions can be found in the table below.
Instance region

Audit Log Storage Region

Tianjin

Beijing

Taipei (China)

Hong Kong (China)

Shenzhen

Guangzhou Prerequisites Already enabling the audit service.
Viewing Audit Logs Note:
Audit logs are displayed with millisecond precision, allowing for more accurate SQL sorting and troubleshooting.
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top. On the Audit Instance page, click Audit Log Storage Status and select the Enabled option to filter for instances with the audit service enabled.
4.
In the Audit Instance list, locate the target instance (you can also use the search box to filter by resource attributes for quick search). Click View Audit Log in the Operation column to go to the Audit Log page and view the corresponding logs.
﻿ Tool List Tool

Description

Refreshing

Click ﻿ to refresh the audit log list.

Customize List Fields

Click ﻿ to select fields you want to display in the list.

Download

Click ﻿ to generate a log file. In the pop-up window, you can select the log fields to be included in the downloaded file. Available options are All fields and Interaction with custom list fields. If you select Interaction with custom list fields, the downloaded log file will only contain the fields displayed in the list, and the field order will be the same as that in the list.

File List

Click ﻿ to access the Audit Log List. You can query the information and download address of files that have been generated or are being generated. You can copy the download address to download a file and obtain the complete SQL audit logs.
Currently, only Tencent Cloud private network addresses are provided for downloading log files. You can download files via a Tencent Cloud CVM instance in the same region. (For example, to download the audit logs of a database instance in the Beijing region, use a CVM instance in the Beijing region.) Log files are valid for 24 hours. You should download them promptly.
The number of log files for each database instance should not exceed 30. You need to delete the log files after download.
If the displayed status is Failed, there may be too many logs. You can narrow the time range to download log files in batches.
Filtering and Search Conditions In the audit instance filter box, you can select and switch to other audit instances where the audit service is enabled.
In the time box, the default selection is Last 1 hour. You can quickly select other time ranges (Last 3 hours, Last 24 hours, Last 7 days) or customize a time period to view relevant audit logs within the selected timeframe.
Note:
The time period for search supports selecting any time period with available data. A maximum of the top 60,000 matching records will be displayed.
In the Search Box, select search items (such as SQL details, client IP, user account, database name, Table Name, SQL type, error code, execution time (μs), lock wait time (μs), IO wait time (ns), transaction duration (μs), CPU time (μs), risk level, thread ID, transaction ID, scanned rows, affected rows, returned rows, audit rules, etc.) to view relevant audit results. Separate multiple keywords with line breaks.
Search Item

Matching Items

Description

SQL Details

Include - Or - Tokenize

Rule Description Enter SQL command details. Separate multiple keywords with line breaks.
The matching items in the SQL Command Details search box are divided into three levels: the first level sets positive/negative matching modes (Contains, Does Not Contain); the second level defines logical relationships between keywords (OR, AND); the third level configures the matching mode for each keyword (Tokenized, Wildcard).
Note:
The search for SQL command details is case-insensitive.
Supports two types of positive/negative matching modes: "Contains" and "Does Not Contain".
Keywords support two types of logical matching: "OR" and "AND". "OR" represents a union relationship between different keywords, while "AND" represents an intersection relationship.
Each keyword supports two matching modes: "Tokenized" and "Wildcard". "Tokenized" indicates that each keyword in the SQL command details requires exact matching, while "Wildcard" indicates that each keyword can be matched with fuzzy logic.
Example Description Assume the SQL command details are: SELECT * FROM test_db1 join test_db2 LIMIT 1;
In the "Contains (Tokenized)" search mode, you can search using tokenized keywords such as "SELECT", "select * from", "*", "SELECT * FROM test_db1 join test_db2 LIMIT 1;", and "from Test_DB1". However, you cannot search using wildcard keywords like "SEL", "sel", or "test".
In the "Contains (Wildcard)" search mode, you can search using wildcard keywords such as "SEL", "sel", "test", and "DB".
In the "Contains (AND)" search mode, multiple keywords are combined with an "AND" relationship. For example, entering keywords such as "SELECT" and "test_db" will query all SQL commands containing both "SELECT" and "test_db".
In the "Contains (OR)" search mode, multiple keywords are combined with an "OR" relationship. For example, entering "test_db1" or "test_db2" will query all SQL commands containing either "test_db1" or "test_db2".

Include - AND - Segmentation

Exclude - AND - Segmentation

Include - OR - Wildcard

Include - AND - Wildcard

Exclude - AND - Wildcard

Client IP

IncludeExcludeEqual toNot equal to

Enter the client IP addresses, separating multiple keywords with line breaks. IP addresses support using * as a wildcard for filtering. For example, searching for Client IP address: 9.223.23.2* will match all IP addresses starting with 9.223.23.2.

User Account

IncludeExcludeEqual toNot equal to

Enter user account(s), separating multiple keywords with line breaks.

Database Name

IncludeExcludeEqual toNot equal to

Enter database name(s), separating multiple keywords with line breaks.
Note:
The search for database names is case-insensitive.

Table Name

Equal to Not equal to

Enter table name(s). The search for table names follows these rules:
Case-insensitive.
The search format is DbName.TableName.
For example: If the database test_db contains a table named test_table and you want to search for this table, you need to enter: Table name equals test_db.test_table.
Note:
A maximum of 64 table names can be stored.
The field "Table Name" is directly supported in MySQL 5.7 20240331 and later versions, as well as MySQL 8.0 20240930 and later versions. Other versions do not support this field. You can upgrade to supported versions if needed.

SQL Type

Equal to Not equal to

Select an SQL type from the drop-down list. Available types: ALTER, CHANGEUSER, CREATE, DELETE, DROP, EXECUTE, INSERT, LOGOUT, OTHER, REPLACE, SELECT, SET, UPDATE, and PREPARE. Multiple types can be selected at the same time.
Note:
The SQL type "PREPARE" is supported only in MySQL 5.7 20230115 and later versions, as well as MySQL 8.0 20221215 and later versions. You can upgrade to supported versions if needed.

Error Code

Equal to Not equal to

Enter error code(s), separating multiple keywords with line breaks.

Execution time (μs)

Interval Format

Enter the execution time in the format M-N, such as 10-100 or 20-200.

Lock wait time (μs)

Interval Format

Enter the lock wait time in the format M-N, such as 10-100 or 20-200.

IO wait time (ns)

Interval Format

Enter the I/O wait time in the format M-N, such as 10-100 or 20-200.

Transaction duration (μs)

Interval Format

Enter the transaction duration in the format M-N, such as 10-100 or 20-200.

CPU time (μs)

Interval Format

Enter the CPU time in the format M-N, such as 10-100 or 20-200.

Risk Level

Include Not included

Select Low, Medium, or High risk to filter audit logs that match the risk level settings of rule templates.
Leaving the input blank is also supported, which filters existing audit logs without a Risk Level Tag.

Thread ID

Equal to Not equal to

Enter Thread ID, with multiple keywords separated by line breaks.

Transaction ID

Equal to Not equal to

Enter Transaction ID, with multiple keywords separated by line breaks.
Note:
For the field "Transaction ID", support is available in MySQL 5.7 version 20240331 and above, and MySQL 8.0 version 20230630 and above. Other versions do not support this feature. To enable support, please upgrade to a supported version.
Transaction IDs are generated only after INSERT, UPDATE, or DELETE operations are performed within explicit transactions. Implicit transactions do not have Transaction IDs.

Number of scanned rows

Interval Format

Enter the number of rows scanned, in the format M-N, such as 10-100 or 20-200.

Number of affected rows

Interval Format

Enter the number of affected rows, in the format M-N, such as 10-100 or 20-200.

Number of returned rows

Interval Format

Enter the number of rows returned, in the format M-N, such as 10-100 or 20-200.

Audit Rule

Include Exclude

Displays the template ID and name for each rule template in the selected region. You can filter audit logs to show only those that match a specific rule template.
Supports leaving the input blank, which filters audit logs historically stored without audit rule tags and full audit logs that did not trigger any rules.
Supports searching audit rules by rule template ID and rule template name.
Supports simultaneously selecting multiple rule templates.
Audit Field The audit logs of TencentDB for MySQL support the following fields.
No.

Field Name

Supported Kernel Version

Field Description

1

Time

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

Records the start time of the operation (SQL execution).

2

Risk Level

-

Indicates the risk level of the operation, categorized as Low Risk, Medium Risk, or High Risk. For full audit logs that do not trigger any audit rules, the risk level will be displayed as "-".

3

Client IP

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The IP address of the client that initiates the database operation.

4

Database Name

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The name of the database involved in the operation.

5

Table Name

MySQL 5.6 not supported MySQL 5.7 ≥ 20240331 MySQL 8.0 ≥ 20230630

The specific names of the tables involved in the operation (if any). The system is limited to recording a maximum of 64 table names.
Note:
After the recycle bin feature is enabled, the table name field will record the database tables of __cdb_recycle_bin__ in the CloudAudit logs for truncate or drop operations.

6

User Account

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

User account performing the operation.

7

SQL Type

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

Type of SQL statement, such as SELECT, INSERT, UPDATE, DELETE.

8

SQL Details

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

Executed SQL Command Text.

9

Error Code

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

When an error occurs during SQL statement execution, an error code is generated. The error code is an integer value that identifies the specific error type, with 0 indicating success.

10

Thread ID

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

Each client connected to the database has a unique thread ID. This ID is used to identify which client performed a specific operation.

11

Transaction ID

MySQL 5.6 not supported MySQL 5.7 ≥ 20240331 MySQL 8.0 ≥ 20230630

In transactional storage engines (such as InnoDB), each transaction has a unique transaction ID. This ID is used to identify a specific transaction.

12

Scanned Rows

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The number of rows scanned by the database when a query is executed. This number helps you assess the efficiency of the query.

13

Returned Rows

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The number of rows returned by the query result. This number helps you understand the size of the result set.

14

Affected Rows

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The number of rows actually affected when modification operations are performed (such as INSERT, UPDATE, DELETE) on a data table. This number helps you understand the extent of the operation's impact.

15

Execution Time (μs)

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

The time taken for an SQL statement to execute from start to finish, measured in microseconds. This number helps you assess the performance of the query.

16

CPU Time (μs)

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190830 MySQL 8.0 ≥ 20210330

The time consumed by the execution of an SQL statement on the CPU, measured in microseconds. This number helps you understand the CPU usage of the query.

17

Lock Wait Time (μs)

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190830 MySQL 8.0 ≥ 20210330

Lock wait time (in microseconds). This number helps you understand the lock contention of the query.

18

IO Wait Time (ns)

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190830 MySQL 8.0 ≥ 20210330

I/O wait time (measured in nanoseconds). This metric helps you understand the I/O performance of the query.

19

Transaction Duration (μs)

MySQL 5.6 ≥ 20190930 MySQL 5.7 ≥ 20190830 MySQL 8.0 ≥ 20210330

The total time taken for a transaction from initiation to commit or rollback, measured in microseconds. This number helps you assess the performance of the transaction.

20

Policy Name

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

This field is no longer used for rule-based audit in new versions.

21

Audit Rule

MySQL 5.6 ≥ 20180122 MySQL 5.7 ≥ 20190430 MySQL 8.0 ≥ 20210330

Indicates which rule template this audit log entry is triggered by. Clicking on the corresponding rule template displays detailed rule information, including basic information, parameter settings, and modification history.
For historical audit logs, the audit rule value is displayed as "-".
For comprehensive audit logs that do not match any rules, the audit rule value is displayed as "-".

22

Client Port

MySQL 5.7 ≥ 20240331 MySQL 8.0 ≥ 20240930

The port number of the client that initiates database operations.
SQL Statement Types and Mapped Objects Relationship No.

SQL Statement Type

SQL Statement Mapping Object

0

OTHER

All SQL statement types except those listed below.

1

SELECT

SQLCOM_SELECT

2

INSERT

SQLCOM_INSERT,SQLCOM_INSERT_SELECT

3

UPDATE

SQLCOM_UPDATE,SQLCOM_UPDATE_MULTI

4

DELETE

SQLCOM_DELETE,SQLCOM_DELETE_MULTI,SQLCOM_TRUNCATE

5

CREATE

SQLCOM_CREATE_TABLE,SQLCOM_CREATE_INDEX,SQLCOM_CREATE_DB,SQLCOM_CREATE_FUNCTION,SQLCOM_CREATE_USER,SQLCOM_CREATE_PROCEDURE,SQLCOM_CREATE_SPFUNCTION,SQLCOM_CREATE_VIEW,SQLCOM_CREATE_TRIGGER,SQLCOM_CREATE_SERVER,SQLCOM_CREATE_EVENT,SQLCOM_CREATE_ROLE,SQLCOM_CREATE_RESOURCE_GROUP,SQLCOM_CREATE_SRS

6

DROP

SQLCOM_DROP_TABLE,SQLCOM_DROP_INDEX,SQLCOM_DROP_DB,SQLCOM_DROP_FUNCTION,SQLCOM_DROP_USER,SQLCOM_DROP_PROCEDURE,SQLCOM_DROP_VIEW,SQLCOM_DROP_TRIGGER,SQLCOM_DROP_SERVER,SQLCOM_DROP_EVENT,SQLCOM_DROP_ROLE,SQLCOM_DROP_RESOURCE_GROUP,SQLCOM_DROP_SRS

7

ALTER

SQLCOM_ALTER_TABLE,SQLCOM_ALTER_DB,SQLCOM_ALTER_PROCEDURE,SQLCOM_ALTER_FUNCTION,SQLCOM_ALTER_TABLESPACE,SQLCOM_ALTER_SERVER,SQLCOM_ALTER_EVENT,SQLCOM_ALTER_USER,SQLCOM_ALTER_INSTANCE,SQLCOM_ALTER_USER_DEFAULT_ROLE,SQLCOM_ALTER_RESOURCE_GROUP

8

REPLACE

SQLCOM_REPLACE,SQLCOM_REPLACE_SELECT

9

SET

SQLCOM_SET_OPTION,SQLCOM_RESET,SQLCOM_SET_PASSWORD,SQLCOM_SET_ROLE,SQLCOM_SET_RESOURCE_GROUP

10

EXECUTE

SQLCOM_EXECUTE

11

LOGIN

Database login. This behavior is not constrained by audit rules and is recorded by default.

12

LOGOUT

Database logout. This behavior is not constrained by audit rules and is recorded by default.

13

CHANGEUSER

User modification behavior. This behavior is not constrained by audit rules and is recorded by default.

14

PREPARE

- Previous Topic: Enabling Audit Service Next Topic: Log Shipping Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Viewing Audit Logs Tool List Filtering and Search Conditions Audit Field SQL Statement Types and Mapped Objects Relationship Search AllCurrent Product Search titles only Enter keywords to search documentation
