# Shrinking a Database

> 来源: https://www.tencentcloud.com/document/product/238/72323

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Shrinking a Database Shrinking a Database Download Focus Mode Font Size Last updated: 2025-08-06 16:16:24 AI-Translated After data is cleared in a SQL Server database, although the corresponding data pages are removed from the data file, the disk space occupied by the data file is not released automatically. To reclaim the unused space, the database shrink feature should be used to manually release the disk space occupied by the data file.
Data Clearing and Disk Space Available for Releasing ﻿ As shown in the figure above, the data file still occupies 133 MB of disk space after data clearing, and the available free space is 93 MB. This indicates that the database shrink feature can be used to release up to 93 MB of disk space.
﻿ As shown in the figure above, the data file occupies 50 MB of disk space after the database shrink feature is used to reclaim part of the available free space.
Database Shrink Solution of TencentDB for SQL Server Solution 1: Shrinking the Database Through the Console
1.
Log in to the TencentDB for SQL Server console and click Instance ID or Manage in the Operation column in the instance list to enter the instance management page.
2.
On the instance management page, select the Database Management tab, locate the row where the target database is located, and select Others > Shrink Database in the Operation column.
﻿
3.
Once enabled, the process will automatically shrink in cycles of 2 GB at a time until all available free space is released.
Solution 2: Using SSMS to Connect to Instances and Executing Scripts for Shrinking Note:
Shrinking a database may generate large logs and cause blocking. Therefore, when a script is used to perform the shrink operation, it is not recommended to shrink a large amount at once (for example, more than 50 GB in a single operation). It is recommended to shrink a smaller amount multiple times during off-peak hours.
Step 1: Connecting to SQL Server Instances Through SSMS For detailed operations, see the connection methods in Connecting to TencentDB for SQL Server Instance from Windows CVM Instance or Connecting to TencentDB for SQL Server Instance from Local System.
Step 2: Executing Scripts for Shrinking Note:
When the following command is used, replace the variables with actual information:
[database]: Replace it with your target database name, for example, [MyDB].
N'Database_logic_file_name': Replace it with the file of the database you want to shrink, for example, N'MyDBData'.
Target shrinking size: Replace it with the actual target size for shrinking, for example, if the value is 40, it means shrinking to 40 MB.
USE [database] GO DBCC SHRINKFILE (N'database_logic_file_name', target shrinking size) GO Example: Shrink the data file MyDBData of MyDB to 40 MB.
USE [MyDB] GO DBCC SHRINKFILE (N'MyDBData' , 40) GO Previous Topic: Enabling and Disabling the CDC Feature Next Topic: History Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Data Clearing and Disk Space Available for Releasing Database Shrink Solution of TencentDB for SQL Server Solution 1: Shrinking the Database Through the Console Solution 2: Using SSMS to Connect to Instances and Executing Scripts for Shrinking Search AllCurrent Product Search titles only Enter keywords to search documentation
