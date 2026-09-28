# Cross-Account Backup Restoration

> 来源: https://www.tencentcloud.com/document/product/238/52608

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial Cross-Account Backup Restoration Cross-Account Backup Restoration Download Focus Mode Font Size Last updated: 2024-01-18 17:25:32 TencentDB for SQL Server supports intra-region cross-account backup restoration. This document describes how to get the backup file download URL of an instance under account A and then restore data under account B in the same region.
Note After getting the backup file download URL of an instance under account A, perform backup restoration under account B. The two accounts need to be in the same region.
This backup restoration mode currently supports backup files in BAK, TAR, and ZIP formats.
To use intra-region cross-account backup restoration, the form of the backup file obtained in the console must be unarchived file.
Currently, the backup file download URL needs to be decoded as detailed below.
Step 1. Obtain the backup file download URL under account A
1.
Log in to the TencentDB for SQL Server console with account A, and click an instance ID in the instance list to enter the instance management page.
2.
On the instance management page, select the Backup Management tab and click View Details in the Operation column of the target unarchived file in the data backup list.

﻿ ﻿
3.
Click Download in the pop-up window and copy the download URL.

﻿ ﻿ Step 2. Decode the URL Click here to decode the copied URL on the page redirected to.
Note:
Only the first part of the download URL needs to be decoded.
Example: Suppose a download URL is:
https://sqlserver-bucket-bj-1258415541.cos.ap-beijing.myqcloud.com/1312368346%2fsqlserver%2fmssql-8e5hjaiq%2fbackup%2fautoed_instance_58013012_AdventureWorksDW2012_2022_12_29023915.bak?********** You only need to select the URL part that ends with .bak? for decoding. Then, combine the output string with the other part of the URL to get the final URL for cross-account backup restoration.
For the above sample URL, take the following part for decoding:
https://sqlserver-bucket-bj-1258415541.cos.ap-beijing.myqcloud.com/1312368346%2fsqlserver%2fmssql-8e5hjaiq%2fbackup%2fautoed_instance_58013012_AdventureWorksDW2012_2022_12_29023915.bak?
It is decoded to:
https://sqlserver-bucket-bj-1258415541.cos.ap-beijing.myqcloud.com/1312368346/sqlserver/mssql-8e5hjaiq/backup/autoed_instance_58013012_AdventureWorksDW2012_2022_12_29023915.bak?
Then, the final URL for cross-account backup restoration is as follows:
https://sqlserver-bucket-bj-1258415541.cos.ap-beijing.myqcloud.com/1312368346/sqlserver/mssql-8e5hjaiq/backup/autoed_instance_58013012_AdventureWorksDW2012_2022_12_29023915.bak?********** Step 3. Restore data under account B Copy the final URL for backup restoration obtained in step 2.
1.
Log in to the TencentDB for SQL Server console with account B and click an instance ID in the instance list to enter the instance management page.
2.
On the instance management page, select Backup and Restoration > Create.

﻿ ﻿
3.
In the pop-up window, configure the following items and click Create Task.

﻿ ﻿ Parameter

Description

Task Name

Enter the task name, which can contain up to 60 letters, digits, or underscores.

Backup Upload Method

Select Download File from COS.

Restoration Mode

Select Full Backup File.
4.
In the Upload Backup File window, paste the URL and click Save.

﻿ ﻿
5.
Go to the Backup and Restoration tab, find the backup task you just created, and click Start in the Operation column.
6.
In the backup and restoration task list, check the migration task status. When it becomes Migration succeeded, the cross-account backup restoration is completed.
Previous Topic: How to Better Use Tempdb Next Topic: Creating VPC for TencentDB for SQL Server Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Note Step 1. Obtain the backup file download URL under account A Step 2. Decode the URL Step 3. Restore data under account B Search AllCurrent Product Search titles only Enter keywords to search documentation
