# tencentdb_ChangeLoginPassword Stored Procedure User Manual

> 来源: https://www.tencentcloud.com/document/product/238/82368

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual tencentdb_ChangeLoginPassword Stored Procedure User Manual Download Focus Mode Font Size Last updated: 2026-08-18 17:38:30 AI-Translated Feature Overview tencentdb_ChangeLoginPassword is a stored procedure deployed in the master database of a SQL Server instance, enabling users to self-service modify passwords for their SQL Logins. Users can complete password modification without requiring the sysadmin role.
Calling Methods USE master GO EXEC dbo.tencentdb_ChangeLoginPassword @login = N'', @new_password = N'' Parameter Description Parameter

Type

Description

@login

SYSNAME

SQL Login name for which the password is to be changed

@new_password

NVARCHAR(128)

New Password Returned values Return Code

Description

0

Successful

51001

The login name is in the system blocklist.

51002

The login name does not exist or is not an SQL Login.

51004

Modification of sa (system built-in privileged account) is not allowed.

51006

The password contains special characters prohibited by the server security policy.

51007

The target login name is a member of a privileged server role (sysadmin/securityadmin/serveradmin).

51008

The password does not meet the complexity requirements.

51009

Password length exceeds the limit (> 32 characters).
Password Complexity Requirements Rule

Requirement

Length

8 to 32 characters

Complexity

Contain at least 2 types from letters, numbers, and symbols

Excluding account name

The password must not contain the login name (case-insensitive).

Special character restriction

Must not contain special character combinations such as ];, [;, ;[, '], [', and so on Call Example -- Password successfully changed.
EXEC dbo.tencentdb_ChangeLoginPassword @login = N'myapp_user', @new_password = N'NewP@ss2026!' -- Returns 0 ﻿

-- Attempt to modify a system account (denied) EXEC dbo.tencentdb_ChangeLoginPassword @login = N'tencent_admin', @new_password = N'Test1234!' -- Msg 51001: Login is in the system blacklist and cannot be modified.
﻿

-- Password does not meet complexity requirements (denied) EXEC dbo.tencentdb_ChangeLoginPassword @login = N'myapp_user', @new_password = N'123' -- Msg 51008: Password does not meet complexity requirements.
Note Applicable only to SQL Logins: Windows Authentication accounts are not supported for password modification through this stored procedure.
Privileged account modification not supported: Members of the sysadmin/securityadmin/serveradmin roles are not permitted to modify passwords.
EXECUTE permission required: Your account must have EXECUTE permission on this stored procedure to invoke it.
Execute in the master database: Before invoking, first run USE master.
Previous Topic: Creating a Data Consistency Check Task Next Topic: COS Bulk Insert Stored Procedure User Manual Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Overview Calling Methods Parameter Description Returned values Password Complexity Requirements Call Example Note Search AllCurrent Product Search titles only Enter keywords to search documentation
