# TencentDB for SQL Server Optimization of Slow SQL

> 来源: https://www.tencentcloud.com/document/product/238/75617

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial TencentDB for SQL Server Optimization of Slow SQL TencentDB for SQL Server Optimization of Slow SQL Download Focus Mode Font Size Last updated: 2025-12-23 10:46:30 AI-Translated TencentDB for SQL Server instances have extended event tracking for slow SQL enabled by default (that is, slow query log collection is enabled by default), recording SQL statements with execution time exceeding 1 second. You can download slow SQL files for the corresponding time period in the console for slow SQL analysis. This article introduces how to query slow SQL for instances via the console and optimization techniques for slow SQL.
Query and Download Slow SQL Files
1.
Log in to the SQL Server console.
2.
Select the region above, find the instance that needs to be queried or to download slow query logs, and click Instance ID or click Manage in the Operation column to go to the instance management page.
3.
On the instance management page, choose Operation Log > Slow Query Log to view the slow query log list.
﻿
4.
As needed, select the corresponding time range and click Download in the Operation column to download the slow SQL file.
5.
Open the downloaded slow SQL file on a server with SSMS tools, locate the corresponding slow SQL, and analyze it as shown in the figure below.
﻿ Optimization Techniques for Slow Queries A small number of slow SQL queries may be related to writing style and business logic, which require evaluation by the business side. However, most slow SQL queries are primarily caused by missing or improper indexes. For such cases, you can quickly locate missing indexes using the following methods.
1.
Connect to the TencentDB for SQL Server instance using SSMS.
2.
Select the corresponding database, open the query window, place the slow SQL in the query window, and then select the estimated execution plan.
﻿
3.
Here you can see that the impact of the missing index for the corresponding SQL is as high as 79%. Then right-click the row for the missing index, select to open index details, and the corresponding create index script will be generated.
﻿ ﻿ Note:
If you need to create missing indexes, it is recommended to do so during off-peak business hours. Create them online with the online=on parameter. For example:
﻿ Previous Topic: TencentDB for SQL Server Methods for Regular Maintenance Next Topic: How to Better Use Tempdb Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Query and Download Slow SQL Files Optimization Techniques for Slow Queries Search AllCurrent Product Search titles only Enter keywords to search documentation
