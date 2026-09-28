# Querying and Downloading Blocking and Deadlock Events

> 来源: https://www.tencentcloud.com/document/product/238/56212

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Querying and Downloading Blocking and Deadlock Events Querying and Downloading Slow Query Logs Querying primary and standby switch logs Manually Create Latest Blocking and Deadlock Events Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Log Management Querying and Downloading Blocking and Deadlock Events Querying and Downloading Blocking and Deadlock Events Download Focus Mode Font Size Last updated: 2026-07-30 17:20:57 AI-Translated TencentDB for SQL Server supports recording blocking events and deadlock events. Through these records, you can identify the detailed information of the SQL statements causing blocking and deadlock for optimization purposes.
This article describes how to query and download blocking events and deadlock events.
Note:
Blocking events and deadlock events are supported only in the Enterprise editions of 2012, 2014, 2016, 2017, 2019, 2022, and 2025. They are not supported in the 2008 R2 Enterprise edition.
The log time defaults to Beijing time. If the default time zone is modified, the storage time of log data will be displayed in the time zone of the instance server, while the console will show Beijing (UTC+8) time.
Prerequisites Querying and Downloading blocking and deadlock events requires enabling the collection of blocking and deadlock events first.
Background In databases, to maintain data consistency, when a session modifies a specific resource without completing the modification, the system will not release this specific resource. This prevents other concurrent sessions from accessing or modifying the same resource. When slow SQL or other exceptions occur, resources may be occupied for extended periods, severely impacting other sessions and causing blocking events.
On the other hand, if multiple transactions compete for resources—for example, the first transaction holds resource A and attempts to acquire resource B held by the second transaction, while the second transaction holds resource B and attempts to acquire resource A held by the first transaction—a deadlock event occurs.
To address these issues, TencentDB for SQL Server provides a feature in the console to record blocking and deadlock events. Once enabled, this feature helps quickly locate blocking and deadlock events in the database, allowing you to identify and optimize the detailed information of the executed SQL statements causing these issues.
Related Information on Blocking and Deadlock Events The collection of blocking and deadlock events is disabled by default. You can enable it manually. Once enabled, blocking and deadlock events will be collected, and the file will record detailed SQL information causing the blocking and deadlock.
After the collection of blocking and deadlock events is enabled, the default collection threshold is 1000 ms (1000 ms = 1 second). SQL executions exceeding 1000 ms will be recorded as blocking SQL and deadlock SQL. The collection threshold can be customized in the range of 1000 ms - 86400000 ms.
Blocking and deadlock event files are collected every 5 minutes by default. That is, within every 5-minute interval, SQL executions exceeding 1 second will be recorded.
The retention period for blocking and deadlock events defaults to 7 days, after which they are automatically deleted.
Blocking and Deadlock Events File Generation and Download Policy You can download blocking event or deadlock event files to view the corresponding log data for troubleshooting. Before downloading files, you can understand the file generation and download policy through the following description to query and download files more efficiently.
When the instance reaches the collection frequency for blocking or deadlock events and blocking or deadlock event log data is generated, the console will generate blocking or deadlock event log files and support downloading them.
When the instance reaches the collection frequency for blocking or deadlock events but no blocking or deadlock event log data is generated, the console will not generate blocking or deadlock event log files and does not support downloading them.
When the instance has not reached the collection frequency for blocking or deadlock events but blocking or deadlock event log data is generated, you can click the Download button to generate blocking or deadlock event log files and download them.
When the instance has not reached the collection frequency for blocking or deadlock events and no blocking or deadlock event log data is generated, you cannot generate blocking or deadlock event log files by clicking the Download button, nor is downloading supported.
Enable Collection of Blocking and Deadlock Events Note:
The collection of blocking and deadlock events can only be enabled or disabled together; currently, separate collection settings are not supported.
Method 1: Enable by Setting Operation Logs
1.
Log in to the SQL Server console.
2.
Select a region at the top, find the target instance, click Instance ID or click Manage in its Operation column to go to the instance management page.
﻿
3.
On the instance management page, select the Operation Log tab.
4.
Click Operation Log Settings.
﻿
5.
Complete the following configuration in the pop-up window and click Save.
﻿ Parameter

Description

Collection

Enable this feature button.

Collection Threshold

Set the collection threshold. Reference range: 1000 - 86400000 milliseconds.

Collection Frequency

By default, it is set to every 5 minutes and cannot be modified.

Retention Period

Retained for 7 days by default and automatically deleted upon expiration.
Method 2: Enable by setting the blocked process threshold parameter value
1.
Log in to the SQL Server console, click the Instance ID in the instance list to go to the instance management page.
2.
On the instance management page, choose Parameter Configuration > Parameter Settings, locate the row for parameter blocked process threshold. In the Current Running Parameter Value column, click ﻿ to set the value to a non-zero number.
Note:
The blocked process threshold parameter defaults to 0, indicating that blocking and deadlock events are not collected.
The blocked process threshold parameter value range: 0 - 86400, unit: seconds.
When the current running value of the blocked process threshold parameter is not 0, it indicates that blocking and deadlock events are collected, and the corresponding collection switch in Operation Log Settings will be enabled.
Querying and Downloading Blocking and Deadlock Events
1.
On the instance management page, choose Operation Log > Blocking Event or Operation Log > Deadlock Event to view the corresponding event lists.
The supported fields include: File Name, Start Time, Last Updated Time, File Size, Operation (Download).
Logs can be searched based on time ranges: Last 5 minutes, Last 15 minutes, Last 30 minutes, Last 1 hour, Last 3 hours, Last 24 hours, Today, Yesterday, Last 3 days, Last 7 days, Last 30 days, and Custom time range.
﻿
2.
In the Operation column, click Download to download the blocking event or deadlock event file.
Note:
When Download is clicked, the following scenarios may occur.
If the file status is "Completed", after If the file status is "Writing", when the file is not ready, clicking Download will display a message "Log file is being prepared" and downloading is unavailable. When the file is ready, you can copy the private network address and run the command to download it. The command format is: wget -c 'File download address' -O 'Custom filename', or download it locally.
Related APIs API

Description

Query Extended Events List

The interface (DescribeXEvents) is used to query the extended events list.

Enable or disable extended events

The interface (StartInstanceXEvent) is used to enable or disable extended events.
Previous Topic: Viewing Rollback Task List Next Topic: Querying and Downloading Slow Query Logs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Background Related Information on Blocking and Deadlock Events Blocking and Deadlock Events File Generation and Download Policy Enable Collection of Blocking and Deadlock Events Querying and Downloading Blocking and Deadlock Events Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
