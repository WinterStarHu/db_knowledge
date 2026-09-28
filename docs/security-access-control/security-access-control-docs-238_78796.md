# Viewing Audit Log

> 来源: https://www.tencentcloud.com/document/product/238/78796

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Viewing Audit Log Viewing Audit Log Download Focus Mode Font Size Last updated: 2026-04-21 15:06:49 AI-Translated This article introduces how to view Database Audit logs and the relevant fields on the audit log page.
Note:
Audit logs for TencentDB for SQL Server are collected based on extended events. Since different types of extended events contain different fields, you may see that some fields in the audit logs are empty.
Prerequisites Audit Service Enabled.
Viewing Audit Logs
1.
Log in to the TencentDB for SQL Server console.
2.
In the left sidebar, select Database Audit.
3.
Select a region at the top. On the Audit Instance page, click Audit Log Storage Status and select the Enabled option to filter for instances with the audit service enabled.
4.
In the Audit Instance list, locate the target instance (you can also quickly find it by filtering resource attributes in the search box). In its Operation column, click View Audit Log to navigate to the Audit Log page and view the corresponding instance's audit logs.
﻿ Search Criteria Configuration Instructions On the audit log page, you can enter keywords in the search filters to search audit logs. After the Database Audit feature is enabled, the audit log page displays some search filters by default. You can also customize (add or remove) search filters via Retrieve condition configuration.
﻿ The default search filters displayed are as follows:
Username, Client Hostname, Database Name, Execution Time (us), CPU Time (us).
The complete search filters are as follows:
Category

Search filter options

Security AND operation trace

Username, server login name, session login name, Client hostname, Database Name, Command, access object, Object Type, Database ID, Process database ID, object ID, Transaction ID, Thread ID.

Performance and Resource Consumption

Affected Rows, Lastly, the statement affects the number of rows, execution time (us), CPU time (us), logical read, Physical read, I/O write.

Error and exception monitoring

error code, Error Status, severity, Error Message, Error Category, Error subject.
Tool List Tool

Description

Refreshing

Click ﻿ to refresh the audit log list.

Customize List Fields

Click ﻿ to select fields you want to display in the list.

Download

Click ﻿ to create a log file. Then click Generate File in the pop-up window.
﻿

File List

Click ﻿ to access the Audit Log List. You can query the information and download address of files that have been generated or are being generated. You can copy the download address to download a file and obtain the complete SQL audit logs.
﻿ Currently, only Tencent Cloud private network addresses are provided for downloading log files. You can download files via a Tencent Cloud CVM instance in the same region. (For example, to download the audit logs of a database instance in the Beijing region, use a CVM instance in the Beijing region.) Log files are valid for 24 hours. You should download them promptly.
The number of log files for each database instance should not exceed 30. You need to delete the log files after download.
If the displayed status is Failed, there may be too many logs. You can narrow the time range to download log files in batches.
Filtering and Search Conditions In the audit instance filter box, you can switch to other audit instances that have the audit service enabled.
In the Time Frame, the default selection is Last 3 Hours. You can quickly select other time ranges (Last 1 Hour, Last 3 Hours, Last 12 Hours, Last 24 Hours, Last 7 Days) or specify a custom time range to view relevant audit logs within the selected period.
Note:
The search time range supports selecting any time range with data available. Only the first 60,000 matching records are displayed.
In the search box, select search items (SQL text, username, server login name, session login name, client host name, database name, execution statement, accessed object, object type, database ID, procedure database ID, object ID, transaction ID, thread ID, affected rows, last statement affected rows, execution time (us), CPU time (us), logical reads, physical reads, I/O writes, error number, error state, severity, error message, error category, error subject, and so on) to search and view relevant audit results. Multiple keywords are separated by line breaks, indicating an "OR" relationship.
search items

Matching items

Description

SQL text

Precision including Blurry included Precision excluding Blurry excluded

Enter SQL text. Multiple entries should be separated by line breaks. The default matching option is: Exact match - OR.
Matching Rule Description Case-insensitive.
"Precision including" means each keyword in the SQL command details must be matched precisely. For example: when the SQL text is "SELECT * FROM test_db1 join test_db2 LIMIT 1;", in exact match mode you can use keywords like: "SELECT", "select * from", "SELECT * FROM test_db1 join test_db2 LIMIT 1;", or "from Test_DB1" for matching. However, keywords like "SEL", "sel", or "test" cannot be used for matching.
"Blurry included" means each keyword in the SQL command details can be matched approximately. For example: when the SQL text is "SELECT * FROM test_db1 join test_db2 LIMIT 1;", in fuzzy match mode you can use keywords like: "SEL", "sel", "test", or "DB" for matching.
"Precision excluding" means each keyword in the SQL command details must be precisely excluded. For example: when the SQL text is "SELECT * FROM test_db1 join test_db2 LIMIT 1;", in exact exclusion mode you can input "SELECT" to filter out logs that do not contain SELECT.
"Blurry excluded" means each keyword in the SQL command details can be approximately excluded. For example: when the SQL text is "SELECT * FROM test_db1 join test_db2 LIMIT 1;", in fuzzy exclusion mode you can input "SEL", "sel", or "select" to filter out logs that do not contain SELECT.
"OR" indicates a "union" relationship between different keywords. For example: entering "test_db1" and "test_db2" will retrieve all logs containing either "test_db1" or "test_db2".
"AND" indicates an "intersection" relationship between different keywords. For example: entering keywords like "SELECT" and "test_db" will retrieve all logs containing both "SELECT" and "test_db".

Execution statement.
Username.
Server Login Name Session Login Name Client Host Name Database Name Access Object Object Type Error Message Error Category Error Subject.

Precision including Blurry included Precision excluding Blurry excluded

Enter keywords, separating multiple keywords with line breaks. The default matching option is: Exact Match.

Database ID Process Database ID Object ID Error Code Error Status Severity Transaction ID.
Thread ID

Equal to Not equal to

Please enter keywords, separated by line breaks. The default matching item is: Equals.
Matching Rule Description "Equals" means each keyword in the search term requires an exact match. For example: when the database ID is 10, you can match it using the keyword "10" in Equals mode, but it will not match using the keywords "1" or "0".
"Not equal to" means each keyword in the search term requires precise exclusion. For example: when the database ID is 10, using the keyword "10" in Not equal to mode will exclude logs where the database ID is 10.

Number of Affected Rows Last Statement Affected Rows Execution Time (us) CPU Time (us) Logical Reads Physical Reads I/O Write

Range Format

The format is M-N, for example: 10-100.
Audit Field TencentDB for SQL Server audit logs support the following fields.
No.

Field Name

Field Description

1

Time

Timestamp. The time when the log is generated, accurate to the millisecond, in the format: 2025-08-28 19:52:36.104.

2

Username

Username of the executing user.

3

server login name

Server Principal.

4

session login name

Server Principal Name of the session that initiated the triggered event.

5

Client hostname

Client host name.

6

Client Application Name

Client application name.

7

Database Name

Current database name or connected database name.

8

SQL text

-

9

Command

The statement text that triggered the event, or the statement text run by an application through calling remote services (RPC).

10

access object

The name of the object (for example: table, view, stored procedure, etc.) that owns the execution statement, or the name of the object referenced by RPC.

11

Object Type

Type of program unit (for example: stored procedure, function, etc.) that has executed.

12

Returned values

Return value of RPC.

13

Affected

The number of rows returned by RPC or affected by the execution statement.

14

Lastly, the state

Last Affected Rows Count.

15

execution time (us)

Time elapsed since user login (μs).
Execution Time (μs).
RPC Completion Time (μs).

16

CPU time (us)

CPU time consumed by the user during this session (μs).
CPU Time Consumed by Statement Execution (μs).

17

logical read

Logical Page Read Count during Session.
Logical Page Reads Issued by RPC.
Logical Page Reads Issued by Executed Statement.

18

Physical read

Physical Page Reads Issued by the User during Session.
Physical Page Reads Issued by RPC.
Physical Page Read Count by Executed Statement.

19

I/O write

Page Writes Issued by the User during Session.
Number of Page Writes by Executed Statement Page Writes Issued by RPC.

20

error code

-

21

Error Status

﻿

- ﻿

22

severity

-

23

Error Message

-

24

Error Category

-

25

Error Category

-

26

whether user-defined

This field indicates whether the error is a user-defined error (true) or a system error (false).

27

whether captured

This field indicates whether the error is caught by the Transact-SQL TRY/CATCH block.

28

Execution Plan Parameters

Plan handle for the plan cache entry of a parameterized query.

29

Database ID

Database ID or the ID of the current database.

30

Process database ID

This field contains the database ID of the module (for example: stored procedures, functions, etc.) to which the statement that has been executed belongs.

31

object ID

This field contains the ID of the module (for example: stored procedures, functions, etc.) to which the statement that has been executed belongs.

32

Transaction ID

In storage engines that support transactions, each transaction has a unique transaction ID, which is used to identify the specific transaction.

33

Thread ID

Current system thread ID.

34

Output Parameter (xml)

Output parameters returned by RPC.
Previous Topic: Enabling Audit Service Next Topic: Log Shipping Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Viewing Audit Logs Search Criteria Configuration Instructions Tool List Filtering and Search Conditions Audit Field Search AllCurrent Product Search titles only Enter keywords to search documentation
