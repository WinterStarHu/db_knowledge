# Log-Related

> 来源: https://www.tencentcloud.com/document/product/238/47708

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Log-Related Log-Related Download Focus Mode Font Size Last updated: 2026-02-02 12:11:48 AI-Translated What is the slow query collection threshold in TencentDB for SQL Server?
The default slow query collection threshold in TencentDB for SQL Server is one second. SQL statements whose execution duration exceeds one second will be recorded into slow logs.
Is the Slow Query Collection Threshold for TencentDB for SQL Server Modifiable?
The default threshold for slow query collection in TencentDB for SQL Server is 1,000 milliseconds. It can be modified via the console. For detailed operations, see Querying and Downloading Slow Query Log.
Do Slow Query Logs in TencentDB for SQL Server Occupy User Space?
Slow queries in TencentDB for SQL Server do not occupy user storage space.
Can TencentDB for SQL Server View the Slow SQL Table?
You can log in to the SQL Server console, go to the instance list, click the instance ID, and enter the slow query log page to Querying and Downloading Slow Query Log. The slow SQL table in TencentDB for SQL Server is not open to the public by default. You can use SSMS to connect to the instance and view it yourself. If you have insufficient permissions, please submit a ticket to apply for elevated database account permissions.
How to Analyze Slow SQL in TencentDB for SQL Server?
You can log in to the SQL Server console, go to the instance list, click the instance ID, and enter the slow query log page. For details, see Querying and Downloading Slow Query Log. Download slow logs in the console. The downloaded slow log files are in xel format. Use SSMS to open xel files to view specific slow SQL. If you need to optimize slow SQL, copy the slow SQL, enable the execution plan to see the specific execution plan, and optimize the slow SQL based on this execution plan. For details, see Display an Actual Execution Plan.
Is the Transaction Log of TencentDB for SQL Server Automatically Cleaned?
The transaction logs of TencentDB for SQL Server are automatically cleaned up every 10 minutes.
Does TencentDB for SQL Server Support Viewing the Audit Log?
TencentDB for SQL Server does not currently support viewing audit logs.
Does TencentDB for SQL Server Support Viewing Error Logs?
TencentDB for SQL Server currently does not support viewing error logs in the console. You can directly check the instance's logs via SSMS.
How to Obtain Error Logs for TencentDB for SQL Server via Command?
Log in to the SQL Server client and execute the following query in the query window to view the error logs.
Exec master.sys.sp_readerrorlog FileID,LogType,FilterText FileID: The log file number of the Error Log, where 0 indicates the most recent log.
LogType: Log type. A value of 1 indicates that the queried log type is error logs, and a value of 2 indicates that the queried log type is Agent logs.
FilterText: Query keyword, which can be NULL.
Example:
exec master.sys.sp_readerrorlog 0,1,'error' What Types of Operation Logs Can Be Viewed in the Console for TencentDB for SQL Server?
TencentDB for SQL Server allows you to view slow query logs, blocking events, deadlock events, and primary/replica switch logs via the console.
﻿

Previous Topic: Monitoring and Alarms Next Topic: Parameter Modification Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page What is the slow query collection threshold in TencentDB for SQL Server?
Is the Slow Query Collection Threshold for TencentDB for SQL Server Modifiable?
Do Slow Query Logs in TencentDB for SQL Server Occupy User Space?
Can TencentDB for SQL Server View the Slow SQL Table?
How to Analyze Slow SQL in TencentDB for SQL Server?
Is the Transaction Log of TencentDB for SQL Server Automatically Cleaned?
Does TencentDB for SQL Server Support Viewing the Audit Log?
Does TencentDB for SQL Server Support Viewing Error Logs?
How to Obtain Error Logs for TencentDB for SQL Server via Command?
What Types of Operation Logs Can Be Viewed in the Console for TencentDB for SQL Server?
Search AllCurrent Product Search titles only Enter keywords to search documentation
