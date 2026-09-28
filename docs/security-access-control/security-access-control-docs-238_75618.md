# How to Better Use Tempdb

> 来源: https://www.tencentcloud.com/document/product/238/75618

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial How to Better Use Tempdb How to Better Use Tempdb Download Focus Mode Font Size Last updated: 2025-12-23 10:47:13 AI-Translated Tempdb is a system database used for storing temporary data, which is recreated every time the SQL Server process restarts. Due to its highly flexible nature, this system database is widely used in various business scenarios. This document describes the usage of the Tempdb system database in TencentDB for SQL Server and provides optimization recommendations.
Analysis of Issues of Tempdb Space Usage Since Tempdb temporarily materializes temporary data (when SQL Server performs certain operations, Tempdb is used to store intermediate results or temporary data), its space grows according to the data size when data is written to temporary tables. Normally, after a small amount of data is written to a temporary table and processed, Tempdb automatically releases this space after the transaction is committed, allowing subsequent transactions to reuse it. However, when encountering scenarios where Tempdb occupies significant space that cannot be shrunk, how should we handle it?
1. Proper Usage: Avoid Issues of Excessive Space Expansion from the Source
Avoid inserting large amounts of data into temporary tables within a single transaction, as this can lead to excessive expansion of Tempdb.
After temporary tables are used within a transaction, promptly commit the transaction to prevent continuous expansion of Tempdb.
2. File Shrinkage: Reclaim Expanded Space via Restart or Cache Cleanup
If the Tempdb file has expanded excessively and requires shrinking, it is difficult to shrink the data file while the instance is running. In such scenarios, the recommended solution is to restart the SQL Server process to reload and regenerate a new Tempdb.
If it is inconvenient to directly restart the SQL Server process due to business requirements, consider clearing the instance cache first and then performing the shrink operation. This approach allows shrinking the data file without requiring a restart.
Note:
After the instance cache is cleared, some SQL queries may experience performance degradation for a period of time.
Recommendations for Optimizing Tempdb Performance In systems with frequent Tempdb usage, the size and physical location of the database may have certain impacts. For instance, if the defined size for Tempdb is too small, each time the SQL Server instance restarts, the system will consume additional processing resources to complete the automatic expansion of Tempdb to the size required to support the current workload.
Optimization recommendations for Tempdb are as follows:
Set the size for automatic file growth to a reasonable value to avoid frequent triggering of file growth during data writes, which can impact performance. It is recommended to set the automatic file growth to 200MB - 500MB.
To maximize disk bandwidth utilization by creating multiple files as needed, which can effectively reduce Tempdb storage contention. It is recommended to increase the number of Tempdb data files based on the instance's number of CPUs. For instances with more than 8 CPUs, it is advised to create a total of 8 Tempdb data files.
It is recommended to set each Tempdb data file to the same size, and also set the automatic growth size for the files to the same size, which can optimize the performance of proportional fill.
Methods for Adding Tempdb Data Files Add Tempdb Data Files After the Instance Is Connected via SSMS
1.
Connect to SSMS.
2.
Click to open the Tempdb database properties.
3.
Click Files, then click ADD to add Tempdb files, and finally click OK.
﻿ Using SQL Commands to Add Tempdb Data Files You can also directly add Tempdb data files through SQL commands. The specific commands can be referenced as follows:
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'F:\gamedb\58047\tempdev2.ndf' , SIZE = 3382272KB , FILEGROWTH = 204800KB ) GO Description of SQL command parameters Parameter

Description

ALTER DATABASE [tempdb]

Specifies that the database for the operation is Tempdb.

ADD FILE (...)

Specifies that a new data file is to be added to the database.

SIZE = 3382272KB

The initial size of the file, here indicating approximately 3.22GB.

FILEGROWTH = 204800KB

The automatic growth size of the file, indicating that when file space is insufficient, it will be automatically extended by increments of approximately 199.9MB.
Previous Topic: TencentDB for SQL Server Optimization of Slow SQL Next Topic: Cross-Account Backup Restoration Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Analysis of Issues of Tempdb Space Usage Recommendations for Optimizing Tempdb Performance Methods for Adding Tempdb Data Files Add Tempdb Data Files After the Instance Is Connected via SSMS Using SQL Commands to Add Tempdb Data Files Search AllCurrent Product Search titles only Enter keywords to search documentation
