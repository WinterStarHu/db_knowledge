# Account Permissions and Permission Control

> 来源: https://www.tencentcloud.com/document/product/238/72321

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Account Permissions and Permission Control Account Permissions and Permission Control Download Focus Mode Font Size Last updated: 2025-10-15 19:47:48 AI-Translated The permissions for TencentDB for SQL Server are mainly divided into 3 types: standard permission accounts, privileged permission accounts, and designated accounts. Each type of permission serves different functional purposes. This document will introduce the practices for account permissions and permission control.
Permission Category and Description Standard permission account: It can grant read or write-related permissions for a single business database based on business needs.
Privileged permission account: It can grant the dbowner permission for ALL business databases, and an instance can only create one privileged permission account.
Designated account: It can grant permissions for special operations, such as viewing errorlog and specifying which databases it is allowed to access.
Creating Accounts with Different Permissions
1.
Log in to the TencentDB for SQL Server console and find the target instance.
2.
On the instance management page, select Account Management > Create Account, enter relevant information in the pop-up dialog box, and then click OK after confirmation.
Note:
For detailed operation steps and descriptions, see Create Account.
Permission Control Currently, the TencentDB for SQL Server console provides permission control at the table level. If there is a need for more fine-grained permission control, you can connect to the instance using a privileged permission account through SSMS to perform the operations.
Step 1: Creating a Privileged Permission Account For detailed steps, see Create Account.
Step 2: Connecting to the SQL Server Instance Through SSMS After connecting to the SQL Server instance through SSMS, you can perform fine-grained permission control. For detailed steps on connecting to the instance, see Connecting to TencentDB for SQL Server Instance from Local System. Note that you need to use the created privileged permission account and password to log in to SSMS.
﻿ Step 3: Authorizing Through Commands Note:
When the following command is used, replace the variables with actual field information:
: Replace  with the actual name.
: Replace  with the actual name.
: Replace  with the actual SQL.
Example: Granting Permission to a Single Table GRANT SELECT ON  TO ;
-- GRANT UPDATE ON  TO ;
-- GRANT INSERT ON  TO ;
-- GRANT DELETE ON  TO ;
It indicates granting  the permission to perform query, update, insertion, or deletion operations in .
Example: Granting Permissions to Specific Fields of a Table GRANT SELECT(col1,col2,col3) ON  TO ;
It indicates granting  the permission to perform query operations on some columns (col1, col2, and col3) of .
Example: Granting Permissions to Execute Stored Procedures or Create a View GRANT EXEC TO ;
-- GRANT CREATE VIEW TO ;
The first line of command indicates granting  the permission to execute stored procedures.
The second line of command indicates granting  the permission to create a view in the current database.
Example: Revoking Granted Fine-Grained Permissions REVOKE  TO ;
-- For example, REVOKE CREATE VIEW TO ;
Previous Topic: Connecting Kingdee K/3 WISE to TencentDB for SQL Server Next Topic: Enabling and Disabling the CDC Feature Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Permission Category and Description Creating Accounts with Different Permissions Permission Control Step 1: Creating a Privileged Permission Account Step 2: Connecting to the SQL Server Instance Through SSMS Step 3: Authorizing Through Commands Search AllCurrent Product Search titles only Enter keywords to search documentation
