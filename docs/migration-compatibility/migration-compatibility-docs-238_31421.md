# Migrating Data from CVM-based SQL Server Instance

> 来源: https://www.tencentcloud.com/document/product/238/31421

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Migrating Data from CVM-based SQL Server Instance Migrating Data from SQL Server Instance Purchased at Other Cloud Service Provider or Built In-house Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Data Migration (Legacy) Migrating Data from CVM-based SQL Server Instance Migrating Data from CVM-based SQL Server Instance Download Focus Mode Font Size Last updated: 2026-06-10 12:00:22 AI-Translated Scenarios TencentDB for SQL Server supports data migration from SQL Server databases self-built on CVMs. This document guides you on configuring the migration task to help you migrate your self-built SQL Server database on a CVM to TencentDB for SQL Server.
Note:
Before migration, ensure that the SQL Server version of the target instance is not lower than that of the source instance.
It supports uploading a single .bak file or a .tar archive for recovery.
The database to be migrated must not have a duplicate name with a TencentDB for SQL Server database.
The data migration feature for older versions has been decommissioned. This document is for reference only by existing users. To use the new data migration feature, see Data Migration Solution Overview.
Operation Steps Step 1: Creating a Migration Task
1.
Log in to the TencentDB for SQL Server Console, and select the Data Migration (Legacy) page from the left sidebar.
2.
Click Create Task, fill in the task name, source database information, and target database information, and select CVM-based self-created SQL Server database for the source instance type.
﻿
3.
After clicking Next, you must first configure the source SQL Server instance before proceeding to configure the migration task.
Note:
If the error message "Source instance information verification failed!" appears, check the following items to troubleshoot.
Check whether the sa account exists on the source SQL Server instance.
Check whether the password for the sa account on the source SQL Server instance is correct.
Check whether the connectivity of the source SQL Server instance's IP address and PORT is normal.
Step 2: Configuring the Source SQL Server Instance
1.
The sa account is enabled on the source SQL Server instance.
2.
In Connections, select Allow remote connections to this server and set a reasonable remote query timeout value.
3.
In Security, select SQL Server and Windows Authentication mode.
4.
Enable the TCP/IP network protocol.
5.
Start the built-in account and select localsystem.
6.
The Windows Firewall allows communication on SQL Server ports, as well as on port 445 (for the basic network) or port 49001 (for the VPC).
7.
(Optional) When you select VPC for CVM Network, you must configure the freeSSHd tool.
8.
Download and install freeSSHd, use the default installation, and agree to start the freeSSHd service.
9.
Double-click the freeSSHd desktop icon, right-click the freeSSHd icon in the taskbar to open the Settings page, and then configure it.
10.
Select the SSH option and configure the port to 49001 (the default port here is 22 and needs to be changed to 49001).
﻿ ﻿
11.
Select the Server status option and start the SSH server.
12.
Select the Authentication option and then select Allowed to enable password authentication.
13.
Select the Users option, add a user named tencent_vpc_migrate (this username cannot be changed) with the password tencent_vpc_migrate (this password cannot be changed), and configure as shown in the following figure:

﻿ ﻿
14.
Use D:\\dbbackup\\ (this path cannot be changed) as the backup folder for SQL Server migration, select the SFTP option, and configure this path in "SFTP home path".
Step 3: Configuring the Migration Task Select the migration type and configure the database (select the databases and tables to be migrated), click Save and Verify, and if the verification fails, complete the fixes as instructed by the error messages.
Step 4: Starting the Migration Task After the task is created, return to the task list. At this point, the task status is Initializing. Select and click Start to initiate the synchronization task.
Step 5: Completing the Migration Task After data synchronization is complete (that is, the progress bar reaches 100%), you must manually click Complete to end the synchronization process. If you selected Incremental Sync when configuring the migration task, you need to manually click Complete when the progress bar is at 99%. Then, check the Status to see whether the migration succeeded.
When the task status changes to Task successful, it indicates that the data migration has succeeded.
When the task status changes to Task failed, it indicates that the data migration has failed. Please check the failure information, and then re-migrate after making corrections based on that information.
Related APIs API

Description

Create a migration task

This API (CreateMigration) is used to create a migration task.

Modify a migration task

This API (ModifyMigration) can modify existing migration task information.

Start migration check

This API (StartMigrationCheck) is used to start a pre-migration verification task, applicable to the migration method where the migration source type is TencentDB for SQL Server.

Run a migration task

This API (RunMigration) is used to start a migration task and initiate the migration.

Stop a migration task

This API (StopMigration) is used to stop a migration task.

Complete a migration task

This API (CompleteMigration) is used to complete a migration task.

Delete a migration task

This API (DeleteMigration) is used to delete a migration task.

Query migration task details

This API (DescribeMigrationDetail) is used to query the details of a migration task.

Query migration task list

This API (DescribeMigrations) queries a list of migration tasks that meet the specified conditions based on the input criteria.

Query migration database list

This API (DescribeMigrationDatabases) is used to query the list of databases to be migrated.

Query migration check task progress

This API (QueryMigrationCheckProcess) is used to query the progress of a migration check task, applicable to the migration method where the migration source type is TencentDB for SQL Server.
Previous Topic: Error Handling Next Topic: Same-Version Migration Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Scenarios Operation Steps Step 1: Creating a Migration Task Step 2: Configuring the Source SQL Server Instance Step 3: Configuring the Migration Task Step 4: Starting the Migration Task Step 5: Completing the Migration Task Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
