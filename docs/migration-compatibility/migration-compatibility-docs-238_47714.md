# Data Migration

> 来源: https://www.tencentcloud.com/document/product/238/47714

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Data Migration Data Migration Download Focus Mode Font Size Last updated: 2024-07-30 15:54:13 How do I migrate data to TencentDB for SQL Server?
You can migrate data from self-built SQL Server databases in local IDCs, CVM instances, and cloud servers provided by other cloud vendors, cloud SQL Server databases provided by other cloud vendors, and TencentDB for SQL Server databases to TencentDB for SQL Server through either cold backup migration or DTS as appropriated based on your business scenarios.
If your business allows you to shut down the database for backup, you can use cold backup migration, i.e., restoring data from .bak backup files to migrate the source database to a TencentDB for SQL Server instance. You can download COS files or upload local files for migration. Three data restoration modes are supported: full backups, full backups + log backups, and full backups + differential backups.
If your business doesn't allow you to shut down the database and requires smooth migration, you can do so as instructed in Migration with DTS. DTS supports two migration modes: full migration and full + incremental migration. It supports multiple access types, such as public network, self-build on CVM, Direct Connect, VPN, CCN, and database.
How do I migrate a self-built SQL Server database in my local IDC to TencentDB for SQL Server?
If your business allows you to shut down the database for backup, you can use cold backup migration, i.e., restoring data from .bak backup files to migrate the source database to a TencentDB for SQL Server instance. You can download COS files or upload local files for migration. Three data restoration modes are supported: full backups, full backups + log backups, and full backups + differential backups.
If your business doesn't allow you to shut down the database and requires smooth migration, you can do so as instructed in Migration with DTS. DTS supports two migration modes: full migration and full + incremental migration. It supports multiple access types, such as public network, self-build on CVM, Direct Connect, VPN, and CCN.
How do I restore a backup of a self-built database to TencentDB for SQL Server?
In the TencentDB for SQL Server console, you can directly upload the backup file of a self-built database or download it from COS to restore it to TencentDB for SQL Server through the cold backup migration feature. For more information, see Cold Backup Migration.
I have purchased a TencentDB for SQL Server instance. How do I restore a local .bak file to it?
In the TencentDB for SQL Server console, you can directly upload the .bak backup file of a self-built database or download it from COS to restore it to TencentDB for SQL Server. For more information, see Cold Backup Migration.
How do I migrate a self-built SQL Server database in a CVM instance to TencentDB for SQL Server?
If your business doesn't allow you to shut down the database and requires smooth migration, you can do so as instructed in Migration with DTS. DTS supports two migration modes: full migration and full + incremental migration. It supports multiple access types, such as public network, self-build on CVM, Direct Connect, VPN, and CCN.
If your business allows you to shut down the database for backup, you can use cold backup migration, i.e., restoring data from .bak backup files to migrate the source database to a TencentDB for SQL Server instance. You can download COS files or upload local files for migration. Three data restoration modes are supported: full backups, full backups + log backups, and full backups + differential backups.
How do I migrate a self-built SQL Server database in another cloud vendor to TencentDB for SQL Server?
If your business doesn't allow you to shut down the database and requires smooth migration, you can do so as instructed in Migration with DTS. DTS supports two migration modes: full migration and full + incremental migration. It supports multiple access types, such as public network, self-build on CVM, Direct Connect, VPN, and CCN.
If your business allows you to shut down the database for backup, you can use cold backup migration, i.e., restoring data from .bak backup files to migrate the source database to a TencentDB for SQL Server instance. You can download COS files or upload local files for migration. Three data restoration modes are supported: full backups, full backups + log backups, and full backups + differential backups.
How do I migrate a cloud SQL Server instance in another cloud vendor to TencentDB for SQL Server?
If your business doesn't allow you to shut down the database and requires smooth migration, you can do so as instructed in Migration with DTS. DTS supports two migration modes: full migration and full + incremental migration. It supports multiple access types, such as public network, self-build on CVM, Direct Connect, VPN, and CCN.
If your business allows you to shut down the database for backup, you can use cold backup migration, i.e., restoring data from .bak backup files to migrate the source database to a TencentDB for SQL Server instance. You can download COS files or upload local files for migration. Three data restoration modes are supported: full backups, full backups + log backups, and full backups + differential backups.
How do I migrate a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) instance to a single-node (formerly basic edition) instance?
If the source instance is a two-node (formerly high-availability/cluster edition) instance, it cannot be migrated to a single-node (formerly basic edition) instance through DTS. You can use .bak files to restore the data through Cold Backup Migration.
How do I migrate a TencentDB for SQL Server single-node (formerly basic edition) instance to a two-node (formerly highavailability/cluster edition) instance?
If the source instance is a single-node (formerly basic edition) instance, you can do so as instructed in Migration with DTS.
How do I migrate a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) instance to another two-node (formerly high-availability/cluster edition) instance?
If the source instance is a two-node (formerly high-availability/cluster edition) instance, you can do so as instructed in Migration with DTS to migrate the data to an instance on a later version, which is not recommended though. Instead, you can upgrade the version without data migration by following instructions in Adjusting Instance Version.
Does TencentDB for SQL Server support cross-account migration?
TencentDB for SQL Server allows you to migrate data between instances with DTS across Tencent accounts. For detailed precautions and directions, see Cross-Account Migration with DTS.
Does TencentDB for SQL Server support heterogeneous migration?
No.
Does TencentDB for SQL Server support data sync with a self-built database?
No.
How do I connect Kingdee K/3 WISE to TencentDB for SQL Server?
You can connect Kingdee K/3 WISE to TencentDB for SQL Server in the following steps: migrate the data to TencentDB for SQL, execute distributed transactions between the TencentDB for SQL Server and Windows CVM instances, and initialize account set management. After you complete all the settings above, distributed transactions can be supported between the CVM and TencentDB for SQL Server instances, and you can log in to and use Kingdee K/3 WISE normally. For more information, see Connecting Kingdee K/3 WISE to TencentDB for SQL Server.
What should I check before using DTS for data migration to the cloud?
We recommend that you check the following items in the source and target databases before using DTS for data migration to the cloud:
Version numbers of source and target databases. The target database must be on a version later than or equal to the source database. For example, if the source database is on v2016, the target database can only be on v2016, v2017, or v2019.
Architecture versions of source and target databases. If the source instance is a self-built database in a local IDC, CVM instance, or cloud server in another cloud vendor, or is a cloud SQL Server instance in another cloud vendor, you can migrate it to a TencentDB for SQL Server single-node (formerly basic edition) instance or two-node (formerly high-availability/cluster edition) instance on any architecture version. If the source instance is a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) instance, it cannot be migrated to a single-node (formerly basic edition) instance through DTS. If the source instance is a TencentDB for SQL Server single-node (formerly basic edition) instance, it can be migrated to a two-node (formerly high-availability/cluster edition) instance through DTS.
Network connectivity between source and target databases. The source and target databases must be connected. The server where the source database resides must have enough outbound bandwidth; otherwise, the migration efficiency will be affected.
Names of source and target databases. The source and target instances cannot have databases with the same name.
Account permissions of the source database. You need to change to "local" for SQL service startup in the source database. The source database account is unrestricted but needs to have the sysadmin permissions.
Account permissions of the target database. The target database needs to have an account with admin permissions for migration.
Ports of the source database. The source database needs to open port 1433, and the service where the source database is located must open the file sharing port 445 for Windows server sharing.
Recovery model of the source database. The source database must be set to "full recovery model", and we recommend that you make a full backup before migration.
Local disk space of the source database. The local disk space of the source database must be large enough, so that the remaining free space can fit the size of the database to be migrated.
Disk space of the target database. The disk space of the target database must be at least 1.5 times the size of the source database.
Status of the target database. The target database cannot have access requests or active businesses; otherwise, the migration will fail.
What should I check when using DTS for data migration to the cloud?
You need to keep the following operation limits in mind when using DTS for migration:
Only one migration task can be initiated at any time for the same source instance.
Only database-level migration is supported (i.e., all objects in the database must be migrated together), while single-table migration is not supported.
Logins, jobs, triggers, and database links (link server) at the instance level cannot be migrated.
Do not modify or delete user information (including username, password, and permissions) in the source and target databases and port numbers during migration; otherwise, the migration task will fail.
Do not perform transaction log backup during incremental sync; otherwise, the transaction log will be truncated and become discontinuous.
If you only perform full data migration, do not write new data into the source database during migration; otherwise, the data in the source and target databases will be inconsistent. In scenarios with data writes, to ensure the data consistency in real time, we recommend that you select full + incremental data migration.
For full + incremental data migration, after you click Complete and the task status becomes Completed, do not write new data to the source database. We recommend that you stop writing for two minutes; otherwise, the data in the source and target databases may be inconsistent.
What should I check after using DTS for data migration to the cloud?
We recommend that you check the following items in the target database after using DTS for migration:
Permission completeness. Permissions will affect operations performed on the database. The migration only restores data. To restore other service-level permissions, such as database users and login usernames, you need to create them again and associate them with database accounts.
It is recommended to rebuild the indexes. Following the completion of migration, the physical environment of the data files undergoes a transformation, and the database index statistics may not be updated promptly. Rebuilding the indexes is advised; otherwise the database performance might deteriorate.
Instance-level objects such as logins, jobs, triggers, and database links (link server). You need to create them again after the migration is completed.
Previous Topic: Backup and Rollback Next Topic: Publish/Subscribe Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I migrate data to TencentDB for SQL Server?
How do I migrate a self-built SQL Server database in my local IDC to TencentDB for SQL Server?
How do I restore a backup of a self-built database to TencentDB for SQL Server?
I have purchased a TencentDB for SQL Server instance. How do I restore a local .bak file to it?
How do I migrate a self-built SQL Server database in a CVM instance to TencentDB for SQL Server?
How do I migrate a self-built SQL Server database in another cloud vendor to TencentDB for SQL Server?
How do I migrate a cloud SQL Server instance in another cloud vendor to TencentDB for SQL Server?
How do I migrate a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) instance to a single-node (formerly basic edition) instance?
How do I migrate a TencentDB for SQL Server single-node (formerly basic edition) instance to a two-node (formerly highavailability/cluster edition) instance?
How do I migrate a TencentDB for SQL Server two-node (formerly high-availability/cluster edition) instance to another two-node (formerly high-availability/cluster edition) instance?
Does TencentDB for SQL Server support cross-account migration?
Does TencentDB for SQL Server support heterogeneous migration?
Does TencentDB for SQL Server support data sync with a self-built database?
How do I connect Kingdee K/3 WISE to TencentDB for SQL Server?
What should I check before using DTS for data migration to the cloud?
What should I check when using DTS for data migration to the cloud?
What should I check after using DTS for data migration to the cloud?
Search AllCurrent Product Search titles only Enter keywords to search documentation
