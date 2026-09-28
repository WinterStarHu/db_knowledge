# Database List

> 来源: https://www.tencentcloud.com/document/product/238/52607

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Database List Creating Database Setting Database Permissions Cloning Database Deleting Database Setting Change Data Capture (CDC) Setting Change Tracking (CT) Shrinking Database Modifying the Recovery Mode Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Database Management Database List Database List Download Focus Mode Font Size Last updated: 2025-12-03 11:31:12 AI-Translated This document introduces the related fields and information of the database management list.
Prerequisites A SQL Server instance is created.
Viewing the Database Management List
1.
Log in to the TencentDB for SQL Server Console.
2.
Find the target instance in the instance list, click Manage in the Operation column to enter the instance details page.
3.
Click Database Management to enter the Database Management page.
﻿ Tool Item ﻿ Tool

Description

Search box

Click ﻿ for filtering. Fuzzy search of database names is supported to quickly find corresponding databases.

Refreshing

Click ﻿ to refresh the list.

Sorting by database name

Click ﻿ after the Database Name field to sort the database list by the first letter of database names (in ascending or descending order).

Sorting by creation time

Click ﻿ after the Creation Time field to sort the database list by creation time (in ascending or descending order).
Database List Field Information Field

Description

Database Name

Displays the names of all databases created under the instance.

Status

Displays the running status of the corresponding database.

Character set

Displays the character set information of the corresponding database.

Creation time

Displays the creation time of the database, in ascending or descending order.

Bind account

Displays the accounts authorized to access the database.

Description

Displays the description information of the database.

Primary-Secondary Synchronization Status

Displays the primary-secondary synchronization status at the database level. The values include synchronized and not synchronized. This field is only applicable to dual-node and multi-node architecture instances.
Synchronized: indicates that the data is consistent after primary-secondary synchronization.
Not synchronized: indicates that the data is inconsistent after primary-secondary synchronization, which may occur in the following scenarios:
During database creation (for example, a database is created during rollback).
After the database is created, data synchronization is not yet completed.
During abnormal database synchronization statuses, such as synchronization interruption.
When data is being written, backup data synchronization is not yet completed.

TDE status

Displays the TDE status of the database.

Operation

Set permissions: Set read-write, read-only, and owner permissions on databases for accounts.
Delete: Delete the corresponding database.
Clone: Clone existing databases to the instance with one click.
Others: Enable/Disable change data capture (CDC) for databases, enable/disable change tracking, and shrink databases.
Note:
Each operation of the database list supports selecting multiple databases, allowing you to perform corresponding batch operations by clicking Batch Management above the database list.
﻿ Related Operations ﻿Creating a Database﻿ ﻿Setting Database Permissions﻿ ﻿Cloning a Database﻿ ﻿Deleting a Database﻿ ﻿Setting Change Data Capture (CDC)﻿ ﻿Setting Change Tracking (CT)﻿ ﻿Shrinking a Database﻿ Related APIs API

Description

﻿CreateDB﻿

This API is used to create a database.

﻿ModifyDBName﻿

This API is used to update the database name.

﻿ModifyDBRemark﻿

This API is used to modify database remarks.

﻿DescribeDBCharsets﻿

This API is used to query the character sets supported by instances.

﻿DescribeDatabases﻿

This API is used to query the database list.

﻿DescribeAccountPrivilegeByDB﻿

This API is used to query information on the account and permissions associated with the database.

﻿DeleteDB﻿

This API is used to delete a database.

﻿CloneDB﻿

This API is used to clone a database. Only cloning to this instance is supported, and a new database name should be specified during cloning process.

﻿ModifyDatabaseCDC﻿

This API is used to enable or disable CDC for databases.

﻿ModifyDatabaseCT﻿

This API is used to enable or disable CT for databases.

﻿ModifyDatabaseShrinkMDF﻿

This API is used to shrink the database mdf (Shrink mdf).

﻿DescribeDBsNormal﻿

This API is used to query database configuration information. This API does not contain accounts associated with databases.
Previous Topic: Setting Account CAM Verification Next Topic: Creating Database Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Viewing the Database Management List Tool Item Database List Field Information Related Operations Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
