# Usage Instructions

> 来源: https://www.tencentcloud.com/document/product/238/74770

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Usage Instructions Synchronization Instructions Pre-check Failure Handling Creating a Data Consistency Check Task Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Data Synchronization (DTS) ﻿ Usage Instructions Usage Instructions Download Focus Mode Font Size Last updated: 2026-07-30 17:20:57 AI-Translated Feasibility of Data Synchronization Category

Description

Source/Target database type

Source database type:
Self-built databases (self-built in IDC, self-built on CVM) SQL Server 2008R2, 2012, 2014, 2016, 2017, 2019, 2022, 2025.
Note:
If you need to migrate self-built databases to the cloud, we recommend using the DTS migration feature for greater stability. For operations, see Migration Operation Guide.
Third-party vendor SQL Server 2008R2, 2012, 2014, 2016, 2017, 2019, 2022, 2025.
Cloud databases (within the same account or across different accounts) SQL Server 2008R2, 2012, 2014, 2016, 2017, 2019, 2022, 2025.
Target database type:
Cloud databases (within the same account or across different accounts) SQL Server 2008R2, 2012, 2014, 2016, 2017, 2019, 2022, 2025.

Synchronization type

Synchronization of structures and full and incremental data is supported.

Synchronization object

Synchronization of database-level data, table-level (user table) data, database and table structures, primary keys, and indexes is supported.
Synchronization of views, storage process, custom functions, custom data types, plan guides, and architectures is supported.
Synchronization of triggers is not supported.

Data type

Supported data types:
See the Supported Data Types List in this document.
Unsupported data types:
Special types: sql_variant, hierarchyid, geometry, geography.

Impact on the source database

When Data Transfer Service (DTS) is used to perform data synchronization, it occupies certain resources of the source instance, which may cause the source instance load to increase and add pressure to the database. If your database configuration is low, it is recommended to perform synchronization during off-peak hours.
Impacts related to enabling CDC:
A brief table lock is caused by enabling CDC since the creation of CDC-related tables and SQL Agent jobs results in certain resource consumption.
When CDC is enabled for a long time, note that the incremental data stored by the CDC component is retained for 3 days by default, which may consume a large amount of storage space. It is recommended to use the command exec console.sys.sp_cdc_change_job @job_type = 'cleanup', @retention= ; to set the retention time.
Enabling CDC for a long time can also impact transaction log truncation.
Due to CDC limitations, if the number of tables exceeds 1000 and the number of databases exceeds 10, it is recommended to use the data migration or backup and recovery capability.
The default maximum size for a single field that CDC jobs can handle is 64 KB. If any table with CDC enabled contains a single field larger than 64 KB, the command exec sp_configure 'max text repl size', -1; must be used in advance to adjust the source database configurations.

Impact on the target database

It is recommended not to perform data write operations on the target database when a data synchronization task is executed, as this may affect the progress of the synchronization task and impose the risk of data inconsistency.

Permission

Source: For specific cloud environment and permission requirements, see Multi-Cloud Environment Support.
Target: dbcreator.
If both the source and target are Tencent Cloud SQL Server instances, you can ignore this permission requirement.

Supported SQL statements

DML: INSERT, UPDATE, and DELETE.

Limitation

Scenarios involving a large volume of DML operations within a short period are not suitable for this data synchronization feature due to potential latency.
Foreign key migration is not supported. If tables contain foreign keys, they will not be migrated to the target instance. It is recommended to recreate foreign keys after migration.
DDL operations are not supported. Modifying table structures or deleting tables may cause the synchronization task to fail.
Structure migration cannot be performed independently, and structure and data are required to be migrated together.
Do not modify or delete user information (including usernames, passwords, and permissions) and port numbers in the source and target databases during synchronization, as this may cause the synchronization task to fail.
If the source table is large with long-running transactions during the full synchronization phase, it is recommended to enable READ_COMMITTED_SNAPSHOT.
Instances with SSL encryption enabled cannot be used as source or target instances for data synchronization.
When you perform operations such as cross-AZ migration / instance specification adjustment / instance edition upgrade that trigger a data migration scenario, system databases are not migrated. Do not create business-related data under system databases to avoid data loss after migration. Furthermore, under the aforementioned operation scenarios, non-standard system database operations and instance-level operations are not migrated together. You must handle them manually after the migration is completed.
Supported Data Types Integer Types Data type

Description

Full synchronization

Incremental synchronization

tinyint

1-byte integer (0 - 255)

✅

✅

smallint

2-byte integer (-32,768 to 32,767)

✅

✅

int

4-byte integer (-231 to 231-1)

✅

✅

bigint

8-byte integer (-263 to 263-1)

✅

✅ Exact Numeric Types Data type

Description

Full synchronization

Incremental synchronization

decimal(p,s)

Exact decimal

✅

✅

numeric(p,s)

Exact decimal (same as decimal)

✅

✅

money

Currency type (8 bytes)

✅

✅

smallmoney

Currency type (4 bytes)

✅

✅

bit

Boolean type (0/1/NULL)

✅

✅ Approximate Numeric Types Data type

Description

Full synchronization

Incremental synchronization

float(n)

floating-point number

✅

✅

real

single-precision floating-point number

✅

✅ String Type Data type

Description

Full synchronization

Incremental synchronization

char(n)

Fixed-length non-Unicode string

✅

✅

varchar(n)

Variable-length non-Unicode string

✅

✅

varchar(max)

Large text (up to 2 GB)

✅

✅ Note:
The default maximum size for a single field that CDC jobs can handle is 64 KB. If any table with CDC enabled contains a single field larger than 64 KB, the command exec sp_configure 'max text repl size', -1; must be used in advance to adjust the source database configurations.

text

Large text

✅

✅

nchar(n)

Fixed-length Unicode string

✅

✅

nvarchar(n)

Variable-length Unicode string

✅

✅

nvarchar(max)

Large Unicode text (up to 2 GB)

✅

✅ Note:
The default maximum size for a single field that CDC jobs can handle is 64 KB. If any table with CDC enabled contains a single field larger than 64 KB, the command exec sp_configure 'max text repl size', -1; must be used in advance to adjust the source database configurations.

ntext

Large Unicode text

✅

✅ Binary Type Data type

Description

Full synchronization

Incremental synchronization

binary(n)

Fixed-length binary

✅

✅

varbinary(n)

Variable-length binary

✅

✅

varbinary(max)

Large binary (up to 2 GB)

✅

✅ Note:
The default maximum size for a single field that CDC jobs can handle is 64 KB. If any table with CDC enabled contains a single field larger than 64 KB, the command exec sp_configure 'max text repl size', -1; must be used in advance to adjust the source database configurations.

image

Large binary

✅

✅ Note:
The default maximum size for a single field that CDC jobs can handle is 64 KB. If any table with CDC enabled contains a single field larger than 64 KB, the command exec sp_configure 'max text repl size', -1; must be used in advance to adjust the source database configurations.
Datetime Type Data type

Description

Full synchronization

Incremental synchronization

date

Date (0001-01-01 to 9999-12 -31)

✅

✅

time

Time

✅

✅

datetime

Datetime (1753-01-01 to 9999-12-31)

✅

✅

datetime2

High-precision datetime

✅

✅

smalldatetime

Small datetime (1900-01-01 to 2079-06-06)

✅

✅

datetimeoffset

Datetime with time zone

✅

✅

timestamp/ rowversion

Row version control

Skipped with warning

Skipped with warning Note:
About timestamp: The SQL Server timestamp (that is, rowversion) is an auto-generated row version column that does not allow explicit INSERT/UPDATE operations. During full export and incremental synchronization, DTS automatically skips this column, and the target generates new values for it. The timestamp column in the table structure is migrated normally (that is, the target creates the column).
Special Types Data type

Description

Full synchronization

Incremental synchronization

uniqueidentifier

GUID/UUID

✅

✅

xml

XML data

✅

✅ User-Defined Types Data type

Description

Full synchronization

Incremental synchronization

User-defined Data Type

Alias type based on system types

✅

✅ CDC Support for Multi-Cloud Environments Use Cases Migrate from third-party cloud vendors.
Feature Description Automatically identify the cloud environment.
Enable stored procedures using the corresponding cloud provider's CDC.
This feature reduces permission requirements. In some cloud environments, sysadmin permissions are not required.
Supported Cloud Environments Cloud Environment

CDC Enablement Method

Minimum Permission Requirement

Self-built SQL Server

EXEC sys.sp_cdc_enable_db

If CDC is not enabled, the minimum permission requirement is sysadmin.
If CDC is enabled, the minimum permission requirement is db_owner.

Third-party cloud vendor

EXEC msdb.dbo.rds_cdc_db

db_owner

EXEC sp_rds_cdc_enable_db

db_owner Supported Capabilities Feature Category

Sub-feature or Description

Supported Capability

Resumable transfer

-

Resumable transfer is partially supported during the full export (it is not supported for structure export or export of tables without primary keys).
Resumable transfer is supported for full and incremental imports.

Synchronization direction

One-to-one

Supported.

Many-to-one (multiple instances merged to one/multiple tables merged to one)

Not supported.

One-to-many

Not supported.

Bidirectional synchronization

Not supported.

Synchronization within the same instance (only one-to-one mode is supported)

Not supported.
HA Switch A switch of the source SQL Server will cause the DTS synchronization task to fail.
Business Impact When DTS is used to perform full data synchronization, it reads all data of the source database once, which increases the load on the source database. If your database specification is low, it is recommended to execute the synchronization task during off-peak hours or reduce the DTS rate before the task is started.
The impact varies depending on the source database specifications. For example, taking the specification of 8 cores and 16 GB as an example, DTS uses 8 concurrent threads (adjustable) by default. Assuming that there is no network bottleneck, the impact of DTS tasks on the performance of the source database is as follows.
During the full export phase: DTS consumes approximately 18% - 45% of the source database's CPU, adds approximately 40 - 60 MB/s of query pressure to the source database, and occupies about 8 active session connections.
During the incremental export phase: DTS exerts minimal pressure on the source database. By default, eight concurrent connections are used to query CDC data simultaneously.
Business Migration After Data Synchronization DTS provides a data consistency verification feature in the data synchronization feature. It adopts static data consistency verification to help users verify data consistency for safer service migration. For details, see Data Synchronization Cutover Instructions.
Previous Topic: Cross-version Migration Next Topic: Synchronization Instructions Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feasibility of Data Synchronization Supported Data Types Integer Types Exact Numeric Types Approximate Numeric Types String Type Binary Type Datetime Type Special Types User-Defined Types CDC Support for Multi-Cloud Environments Supported Capabilities HA Switch Business Impact Business Migration After Data Synchronization Search AllCurrent Product Search titles only Enter keywords to search documentation
