# Release Notes

> 来源: https://www.tencentcloud.com/document/product/238/41605

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Release Notes and Announcements Release Notes Release Notes Download Focus Mode Font Size Last updated: 2026-09-10 16:30:45 AI-Translated & Reviewed September 2026 Update

Description

Release Date

Documentation

System Supports Time Zone Update

TencentDB for SQL Server has completed a system-level time zone update. After the update, it fully supports 138 time zones, covering major regions worldwide and daylight saving time rules.

2026-09-10

Modify System Time Zone August 2026 Update

Description

Release Date

Documentation

New regions supported for disk encryption

TencentDB for SQL Server disk encryption feature now supports new regions: Beijing, Guangzhou, Hong Kong (China), Singapore, Seoul, Tokyo, Jakarta, Frankfurt.

2026-08-20

Disk Encryption

New regions and AZs supported for instances with the cloud disk architecture

Single-node, two-node, and RO instances with the cloud disk architecture of TencentDB for SQL Server now support: Johor Bahru Zone 1 and Johor Bahru Zone 2.

2026-08-20

Regions and AZs

Support for self-service password modification via tool direct connection

TencentDB for SQL Server provides the system stored procedure tencentdb_ChangeLoginPassword in the master database of an instance. It supports users in modifying the passwords of their SQL Logins on their own after directly connecting to the instance using client tools such as SSMS.

2026-08-17

User Manual for the tencentdb_ChangeLoginPassword Stored Procedure

Support for UlTra SSD

TencentDB for SQL Server now supports the UlTra SSD as a storage type, with disk I/O bandwidth performance reaching up to 4 GB/s. This storage type offers advantages such as low latency and high throughput, making it suitable for I/O-intensive and throughput-intensive workloads that require low latency.

2026-08-10

Storage type

Support for shipping database audit logs to CLS

TencentDB for SQL Server Database Audit supports shipping logs to CLS (Cloud Log Service). It can collect database audit logs from instances and ship them to CLS for centralized management and analysis.

2026-08-03

Shipping Logs July 2026 Update

Description

Release Date

Documentation

DTS data migration capability upgrade

DTS now supports migrating instances whose database names contain hyphens and importing non-compressed files in the Web version.

2026-07-31

Migration Instructions

TencentDB for SQL Server 2025 Enterprise Edition officially released

TencentDB for SQL Server released the SQL Server 2025 Enterprise database version, supporting single-node, two-node, multi-node, and read-only instances of the Cloud Disk Edition architecture, providing database services with better and more stable performance, enriching industry scenarios, and helping customers upgrade their industries.

2026-07-28

Major Version Lifecycle Description June 2026 Update

Description

Release Date

Documentation

Support for configuring extra disk I/O performance

TencentDB for SQL Server supports enabling the disk extra I/O performance feature. Once enabled, it can effectively enhance disk I/O throughput, adapt to high-load business scenarios, and provide you with a more flexible and efficient database service.

2026-06-29

Billing Description for Extra Disk I/O Performance

Support for configuring primary/secondary transmission mode

TencentDB for SQL Server supports selecting the primary/secondary transmission mode when an instance is created and also supports modifying the primary/secondary transmission mode after creation. The supported transmission modes are as follows:
Asynchronous replication: high-performance mode, availability first.
Synchronous replication: high-reliability mode, reliability first.

2026-06-29

Setting Transmission Mode

Added support for the default language parameter in parameter management.

TencentDB for SQL Server parameter management now supports the default language parameter, which is used to set the default login language.

2026-06-22

Configuring Instance Parameters

Support for modifying the recovery mode

TencentDB for SQL Server supports displaying and modifying the database recovery mode. You can change the default recovery mode from Simple to Full. In Full mode, all transactions are completely recorded, transaction log backup is supported, point-in-time recovery is supported, and data loss is prevented.

2026-06-11

Modifying the Recovery Mode

Optimization of the Data Synchronization Feature

TencentDB for SQL Server has optimized and upgraded the Data Transmission Service (DTS) feature as follows.
Full migration performance improvement: Through optimization of write batch parameters and memory management, full migration throughput is increased by 2 - 3 times.
Data consistency enhancement: The issue of data loss in varchar columns containing special characters (EUDC) has been fixed; the issue of column order misalignment after table structure changes has been fixed; the issue of primary key conflicts in overlapping full/incremental regions has been fixed.
Column order migration is supported.

2026-06-10

Use Instructions

Console and resource updates

The console and resources of TencentDB for SQL Server have been updated as follows to further improve and enhance the user experience.
New regions that support enabling public network access: Jakarta, Virginia, Riyadh.
SQL Server 2019 Enterprise is supported on single-node instances in Jakarta Zone 1.
When a dual-node/multi-node instance is created, if the region supports multi-AZ deployment, multi-AZ deployment is used by default.
A 4-core, 32GB specification has been added for single-node SSD cloud disk instances.

2026-06-04

Enable or Disable Public Network Address Primary instance specifications list May 2026 Update

Description

Release Date

Documentation

Data Synchronization Feature Upgrade

TencentDB for SQL Server has optimized and upgraded the Data Transmission Service (DTS) feature as follows, comprehensively improving the range of supported data types, performance, and ease of use.
New pre-check items: snapshot isolation level check, encrypted object check, and CDC task check.
Supports multi-cloud environment CDC synchronization.
The synchronization task now includes a schema-init step, which applies to scenarios where the schema-init tool is used to initialize table-level CDC.
Adds the full export sharding feature and the full import adaptive speed control feature.
It supports querying CDC data using eight concurrent connections simultaneously.
Reduces the permission requirements on the source side (synchronization tasks can now be created without sysadmin privileges).
It now supports synchronization for a wide range of data types.

2026-05-21

Use Instructions

Optimizing the monitoring system

Tencent Cloud will comprehensively optimize and upgrade the monitoring metric collection framework for TencentDB for SQL Server. After the optimization, the performance metric collection efficiency in the new monitoring architecture is significantly improved.
For information regarding the release date and impact, see the Service Announcement.
To query monitoring metrics, see the Supported Monitoring Metrics.

2026-05-11

-

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on the console and product features for further improvement of the user experience.
When deleting a database, you can choose whether to back it up.
The default TDE encryption algorithm has been updated from AES_128 to AES_256.
A DMC login entry has been added to the instance list and instance details page.
New character sets and time zones have been added.
DTS data synchronization links support data synchronization and consistency verification for data containing timestamp fields.

2025-05-09

Deleting a Database Transparent Data Encryption Modify Instance-Level Character Set Rules.
Modify System Time Zone.
Use Instructions April 2026 Update

Description

Release Date

Documentation

Update to the account CAM authentication feature

The account CAM authentication feature of TencentDB for SQL Server has added examples for connecting to the database using PHP and .NET.

2026-04-24

Setting up account CAM authentication.
March 2026 Update

Description

Release Date

Documentation

Support for the database audit feature

TencentDB for SQL Server supports Database Audit. This feature enables comprehensive auditing of data activities, provides all-round monitoring and recording of data access and activities by Ops, management, and R&D personnel, facilitates post-event auditing and tracing, enables timely detection of abnormal data situations and risks, generates alerts for analysis, meets compliance requirements, and helps users quickly pass Cybersecurity Classified Protection Compliance assessments and trace security events.

2026-03-30

Overview January 2026 Update

Description

Release Date

Documentation

Release of the new backup feature

TencentDB for SQL Server releases a new backup feature, providing users with a more convenient and intuitive console view of backup trends, enhancing ease of use and user experience, and improving users' controllability and management capabilities over backup usage. The updates are as follows:
The backup architecture has been refactored to support streaming backup and streaming rollback, significantly improving the efficiency of backup and rollback.
Log backup supports packing and single-database backup configuration capability.
Optimize backup download and download restriction settings.
Added support for viewing instance-level backup statistics overview.
We have optimized the data backup, log backup, and rollback record pages in the backup management page.
Data/Log Backup retention period supports up to 7300 days.
Regular backup supports conversion to scheduled backup.
The scheduled backup retention policy supports configuring the number of retained backups on a weekly basis.
The fields in the data backup and log backup lists have been updated.

2026-01-26

View Backup Overview (Instance Level) View Backup Overview (Region Level) December 2025 Update

Description

Release Date

Documentation

New regions and AZs supported for instances with the cloud disk architecture

TencentDB for SQL Server single-node, two-node, and read-only (RO) instances with the cloud disk architecture were supported in Beijing Finance Zone 1, Beijing Finance Zone 2, Riyadh Zone 1, and Riyadh Zone 2.

2025-12-04

Regions and AZs October 2025 Update

Description

Release Date

Documentation

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on the console and product features for further improvement of the user experience.
A new display field, Primary-Secondary Synchronization Status, was added to the database list of dual-node and multi-node architecture instances.
When the database version of an instance is upgraded, it is supported to choose whether to automatically upgrade the database compatibility level.
A new monitoring metric, Total XTP Memory Usage, was added.

2025-10-29

Database Management List Upgrading the Instance Version Supported Monitoring Metrics

Support for data synchronization through Data Transfer Service (DTS)

TencentDB for SQL Server supports data synchronization from SQL Server to TencentDB for SQL Server through DTS, enabling the hot migration of homogeneous data and providing users with a stable data synchronization solution.

2025-10-20

Synchronization Instructions September 2025 Update

Description

Release Date

Documentation

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on the console and product features for further improvement of the user experience.
Transparent data encryption was supported for the instance with a multi-node architecture.
The backup and recovery feature supported the migration scenario where incremental logs from multiple databases are backed up into a single .bak file.
The advanced permission account and ordinary account supported the create login feature.
database_name information was added to the slow query/blocking/deadlock log files.
The settings of the threshold for slow query log collection were supported.
The console supported display of the synchronization method for the instance architecture, including Single, Mirror, and Always On.

2025-09-25

Transparent Data Encryption Cold Backup Migration Creating an Account Querying and Downloading Slow Query Logs Single-Node (Formerly Basic Edition) August 2025 Update

Description

Release Date

Documentation

Support for new regions and AZs of single-node and dual-node Cloud Disk Edition architecture instances

Shanghai Finance Zone 3 and Shanghai Finance Zone 4 were supported by TencentDB for SQL Server single-node and dual-node Cloud Disk Edition architecture instances.

2025-08-28

Regions and AZs July 2025 Update

Description

Release Date

Documentation

Support for event alarms

TencentDB for SQL Server supports setting event alarms, which facilitates users to be informed of the dynamics of Ops events and other events in a timely manner. If the system detects a corresponding abnormal event, it will send alarm notifications to recipients through multiple optional methods.

2025-07-15

Setting Event Alarms May 2025 Update

Description

Release Date

Documentation

Support for table-level account authorization

TencentDB for SQL Server supports table-level account authorization. It allows granting, delegating, or denying permissions on tables for specific accounts. By controlling access permissions of different accounts to different tables, fine-grained authorization management for tables in the database can be achieved.

2025-05-09

Modifying Account Permissions April 2025 Update

Description

Release Date

Documentation

Integration with Database Management Center (DMC)

DMC supports TencentDB for SQL Server. By logging in to DMC, users can have database management and data visualization analysis capabilities, such as visualized database management, SQL execution window, instance session management, data management, and real-time monitoring.

2025-04-17

DMC Management

Support for restart during maintenance period

TencentDB for SQL Server optimizes the restart feature, supporting selection of the effective time for restart: within the maintenance period or immediate adjustment. Restarting within the maintenance period is suitable for scenarios requiring scheduled maintenance of instances. You can flexibly choose the effective time for restart based on your business needs.

2025-04-10

Restarting an Instance

Monitoring feature update

Monitoring feature updates of TencentDB for SQL Server:
Added the monitoring metrics: "AvgLatchWaitMs" and "LockTimeoutSec".
Optimized the collection method of metrics, including: Disk Queue Length, Avg. Disk sec/Transfer, Disk Reads/sec, Disk Writes/sec, Disk Transfers/sec, Disk throughput, Write IO average response time, and Read IO average response time.
Optimized the collection logic of metrics of instances using cloud disks, including CPU, memory, and disk utilization.
Supported the 10-second granularity for all monitoring metrics.
Supported using the predefined dashboards of TCOP.
Added the portal for viewing alerting rules of instances on TCOP.
Maintained the consistency of monitoring metric names in the TencentDB for SQL Server console and on TCOP.
Supported matching the corresponding instance ID when users navigate from the TencentDB for SQL Server console to TCOP to configure alarms.

2025-04-01

Monitoring Metrics March 2025 Update

Description

Release Date

Documentation

Support for disk encryption

TencentDB for SQL Server supports the disk encryption feature to meet security or compliance requirements. Users can enable disk encryption to effectively guarantee data security and prevent unauthorized access and data leakage.

2025-03-27

Disk Encryption February 2025 Update

Description

Release Date

Documentation

Release a multi-node architecture instance

TencentDB for SQL Server has upgraded its product architecture with a brand new multi-node architecture instance. It provides a high-availability disaster recovery deployment method with one primary and multiple secondary nodes. Users can flexibly select the number of replica nodes based on business needs, while enabling replica node read-only to save read-only instance overhead. The multi-node architecture offers higher assurance for business production environments and adapts to more business scenarios.

2025-02-26

Multi-node January 2025 Update

Description

Release Date

Documentation

TDE encryption feature update

TencentDB for SQL Server introduces a brand-new TDE transparent data encryption feature, with added support for user-customized (KMS) key source method to meet encryption demands in different scenarios. It also optimizes the interface operations to enhance user experience.

2025-01-15

Transparent Data Encryption

SSL encryption feature update

TencentDB for SQL Server introduces a brand-new SSL encryption feature, with added support for user-customized (KMS) certificate source method to meet encryption demands in different scenarios. It also optimizes the UI to enhance user experience.

2025-01-15

Setting SSL encryption August 2024 Update

Description

Release Date

Documentation

Release a new version Instance details page

TencentDB for SQL Server released a new version of the instance details page and new architecture diagram.

2024-08-01

Manage SQL Server Instances July 2024 Update

Description

Release Date

Documentation

Enable MFA for sensitive operations

TencentDB for SQL Server sensitive operations (destroy instance, modify network, change IP address, reset password, delete account, restart instance, active/standby switch) integrate MFA, adding protection for account resources and identity authentication for sensitive operations, enhancing database security.

2024-07-12

- June 2024 Update

Description

Release Date

Documentation

Supports CAM authentication (account passwordless login)

TencentDB for SQL Server supports enabling the CAM authentication (password-free login for accounts) feature for accounts, helping you simplify the complexity of account permission management and enhance database security and account management efficiency.

2024-06-21

Support CAM Authentication (Account Passwordless Login) May 2024 Update

Description

Release Date

Documentation

Support manual creation of the latest blocking and deadlock events

TencentDB for SQL Server supports manual creation of the latest blocking and deadlock events when collection is enabled. You can create and download blocking and deadlock event files when needed.

2024-05-09

Manually create the latest blocking and deadlock events April 2024 Update

Description

Release Date

Documentation

Tencent Cloud International - Monthly Subscription

TencentDB for SQL Server on the international site supports the annual and monthly billing mode, suitable for long-term needs with relatively stable traffic volume. The purchase period is longer, the more discounts you get.

2024-04-22

Primary instance price Read-only Instance Price

Support modifying private network address and releasing reserved address

TencentDB for SQL Server supports modifying the private IP address of an instance without changing the VPC or subnet. For cases where the old IP address is still reserved after modification, you can manually release the reserved address to quickly free up the old IP address.

2024-04-11

Changing the Network March 2024 Update

Description

Release Date

Documentation

Support Replica Node Read-Only

TencentDB for SQL Server supports the replica node read-only feature. You can access the secondary node via the read-only address of the replica node, effectively saving the cost of a read-only instance.

2024-03-08

Replica Node Read-Only

Read-only instance support for enabling public network access

TencentDB for SQL Server read-only instances support enabling public network addresses within the read-only group. The application system can access them via the public network address of the read-only group.

2024-03-08

Enable or Disable Public Network Address

New monitoring metric

TencentDB for SQL Server has added monitoring metrics related to the Real Server where the two-node cloud disk edition instance is deployed, including disk throughput, disk read traffic, disk write traffic, average read IO response time, and average write IO response time.

2024-03-07

Monitoring Metrics December 2023 Update

Description

Release Date

Documentation

Support SSL encryption

TencentDB for SQL Server supports SSL encryption, establishing a secure encrypted transfer channel between the client and the cloud database server to implement encrypted data transmission. This prevents data from being intercepted or tampered with during transmission, ensuring the security of information transmission between both parties.

2023-12-07

Setting SSL encryption November 2023 Update

Description

Release Date

Documentation

Optimized configuration adjustment method for dual-node cloud disk architecture

TencentDB for SQL Server dual-node cloud disk architecture instance change and Disk expansion methods have been optimized from migration upgrade to in-place upgrade.

2023-11-30

Adjusting Instance Specifications

Added support for regions and AZs of single-node cloud disk edition architecture

TencentDB for SQL Server single-node cloud disk edition architecture now supports Tokyo (Zone 1, zone 2).

2023-11-02

Regions and AZs October 2023 Update

Description

Release Date

Documentation

Add instance specification for single-node

TencentDB for SQL Server adds instance specifications with 1:8 ratio and high specifications for single-node general-purpose SSD, enhanced SSD, and high-performance cloud block storage.

2023-10-09

Primary Instance Specification List September 2023 Update

Description

Release Date

Documentation

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on the console and product features for further improvement of the user experience.
Integration of TencentDB for SQL Server into the Instance Monitoring page of Tencent Cloud Observability Platform.
Modifying instance project belonging does not unbind the security group.
Manually back up with retention duration policy selection, supporting selection of policies that follow the automated backup retention time or the instance lifecycle.

2023-09-14

Set the project to which the instance belongs Create manual backup

Support manual primary-replica switchover

TencentDB for SQL Server supports manual switching of the primary and secondary databases of instances to ensure system availability and data integrity. The instance connection address remains unchanged after the switch, and applications can automatically connect to the new primary instance.

2023-09-05

Manual primary-replica switchover August 2023 Update

Description

Release Date

Documentation

Added support for regions and AZs of dual-node cloud disk architecture

Cloud Database SQL Server dual-node cloud disk architecture now supports new regions: Tokyo (Zone 1, Zone 2), Bangkok (Zone 1, Zone 2), and Jakarta (Zone 1, Zone 2).

2023-08-04

-

Mobile management for instances

TencentDB for SQL Server integrates with mobile terminals (Tencent Cloud Assistant), providing features such as real-time monitoring, remote management, restart, and renewal. It better adapts to mobile work scenarios and requirements, enabling enterprise users to monitor database operational status and handle urgent issues anytime, anywhere, even outside working hours, improving efficiency and convenience.

2023-08-03

- June 2023 Update

Description

Release Date

Documentation

support transparent data encryption (TDE)

TencentDB for SQL Server supports the Transparent Data Encryption (TDE) feature. TDE makes Data Encryption and decryption operations Transparent to users. It performs real-time I/O Encryption and decryption on Data files, encrypting Data before writing to disk and decrypting when reading from disk into memory, meeting compliance requirements for static Data Encryption.

2023-06-26

Transparent Data Encryption May 2023 Update

Description

Release Date

Documentation

Added support for regions and AZs of dual-node cloud disk architecture

TencentDB for SQL Server dual-node cloud disk architecture supports the Frankfurt (Zone 1, Zone 2), Seoul (Zone 1, Zone 2), Silicon Valley (Zone 1, Zone 2), Mumbai (Zone 1, Zone 2), Virginia (Zone 1, Zone 2), and São Paulo (Zone 1) regions.

2023-05-25

Regions and AZs

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on product features and console display for further improvement of the user experience.
For the DTS check before data migration task, error verification is enhanced with failure details and solution tips.
For the DTS migration steps process, error handling is enhanced with failed task details and solution tips during migration.

2023-05-05

Check before DTS data migration failure details and solution DTS data migration failure details and solution during migration April 2023 Update

Description

Release Date

Documentation

Optimize the rollback feature

TencentDB for SQL Server has optimized the rollback feature. It now supports restoring databases to the current instance, existing intra-region instances, and cross-region instances by time point or backup set, enabling remote disaster recovery and improving data recovery ease of use and security.

2023-04-21

Rollback Plan Overview March 2023 Update

Description

Release Date

Documentation

Support query and download blocking and deadlock events

TencentDB for SQL Server supports enabling the collection of blocking events and Deadlock Events, and supports downloading corresponding record files to help you locate and optimize the detailed information of SQL execution that causes issues.

2023-03-23

Query and download blocking events and deadlock events

Newly-added cloud disk type for single-node

TencentDB for SQL Server single-node (formerly Basic Edition) cloud disk edition instances support mounting universal type and enhanced SSD cloud disks in all regions, with maximum storage space upgraded to 32TB to respond flexibly to more business loads.

2023-03-02

Storage type

Full release of dual-node cloud disk architecture

TencentDB for SQL Server has fully released the brand-new dual-node cloud disk architecture, now supporting Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing, Hong Kong (China), and Singapore regions. It is fully compatible with all functions of the two-node local disk architecture, adding more flexible CPU/memory specifications ratios, supporting mounting universal type and enhanced SSD cloud disks, with maximum storage space upgraded to 32TB.

2023-03-02

Instance Architecture February 2023 Update

Description

Release Date

Documentation

Optimize the backup and recovery feature

TencentDB for SQL Server has optimized the backup and recovery feature, supporting task re-editing, database rename, and multiple COS file formats.

2023-02-14

Cold Backup Migration

Account Type and Permission Change

TencentDB for SQL Server released a new version of database account types and permission logic, offering more comprehensive and convenient account management service.

2023-02-09

Account Types and Permissions

New monitoring metric

TencentDB for SQL Server adds a new monitoring metric, RO sync delay time, to monitor the data sync delay time between the primary instance and read-only instance.

2023-02-09

Monitoring Metrics

Early access to dual-node cloud disk architecture

TencentDB for SQL Server released a dual-node Cloud Disk Edition instance, which is fully compatible with all features of the dual-node local disk edition, adds more flexible CPU/memory specification ratios, supports mounting general-purpose and enhanced SSD CBS, increases the maximum storage space to 32TB, and delivers performance comparable to local SSDs, easily handling various business scenarios such as high performance, high concurrency, and high availability. In addition, the original high availability/cluster edition is renamed to dual-node, the original basic edition is renamed to single-node. To get early access, submit a ticket to apply.

2023-02-09

Instance Architecture January 2023 Update

Description

Release Date

Documentation

Support cross-account data migration

TencentDB for SQL Server supports the use of DTS data migration capability to perform data migration across different accounts between instances.

2023-01-13

Use DTS for cross-account data migration December 2022 Update

Description

Release Date

Documentation

The basic version supports version upgrades.

TencentDB for SQL Server basic version supports self-service version upgrades.

2022-12-12

Adjusting Instance Version

The basic version supports cross-AZ migration.

TencentDB for SQL Server basic version supports cross-AZ migration. After migration, all attributes of the instance, configurations, private network address, and subnet do not change.

2022-12-12

Cross-AZ Migration

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on product features and console display for further improvement of the user experience.
The console instance list adds a secondary AZ field, showing the primary and secondary AZ of instances and whether they span AZs.
The instance database management list and account management list support fuzzy search of database names/account names for filtering queries.

2022-12-12

- November 2022 Update

Description

Release Date

Documentation

Support scheduled backup

TencentDB for SQL Server supports setting up regular backup retention and scheduled backup retention. Using scheduled backup allows for two cycle planning to perform backup, which saves more costs compared to a single periodic backup policy.

2022-11-22

Set up scheduled backup retention October 2022 Update

Description

Release Date

Documentation

New monitoring metric

TencentDB for SQL Server 2014 and above versions add new monitoring metrics, including internal system locked memory and internal system memory consumption.

2022-10-09

Supported Monitoring Metrics September 2022 Update

Description

Release Date

Documentation

Optimize bind to security group related operation

TencentDB for SQL Server security group supports unbinding from projects, multiple selections and blurry search capability.

2022-09-16

Configuring a security group August 2022 Update

Description

Release Date

Documentation

Supports modifying the instance character set and time zone

TencentDB for SQL Server supports setting the system character set collation rule and system time zone when purchasing instances.

2022-08-25

Modify Instance-Level Character Set Rules Modify System Time Zone

Hong Kong Zone 3 is now live

TencentDB for SQL Server is now available in Hong Kong Zone 3, supporting both dual-server high-availability edition and cluster version.

2022-08-10

Regions and AZs July 2022 Update

Description

Release Date

Documentation

Enable public network access

TencentDB for SQL Server supports enabling public network access. Once enabled, you can access the instance via the public network address.

2022-07-25

Enable or Disable Public Network Address June 2022 Update

Description

Release Date

Documentation

Console and feature optimization

The TencentDB for SQL Server technical team performed the following optimizations on product features and console display for further improvement of the user experience.
Delete manual backups in batch based on time range.
Backup name supports up to 128 characters in length.
Log backup frequency is adjusted to every 10 minutes.
Optimize console backup space trend chart visual display.
Time-based support for range search of slow log files.
Purchase page supports search and fuzzy search for VPC, subnet, and project list.
Adjust the display sequence of system monitoring metrics in the console.
Optimize the maintenance period setting logic for instances. Select at least one maintenance period to underwrite database operations security.
The VPC console adds a quick redirect link to query the SQL Server instance bound to the VPC.

2022-06-22

- May 2022 Update

Description

Release Date

Documentation

Support CCN migration

TencentDB for SQL Server supports data migration through DTS by connecting the source database to Tencent Cloud private network via CCN.

2022-05-30

Use DTS for data migration

Support Korean character set

TencentDB for SQL Server supports setting the Korean character set when creating a database.

2022-05-30

Create a Database

Brand new document release

TencentDB for SQL Server has added new documents on common issues, constraints and limitations, and usage guidelines and suggestions to help users better use SQL Server.

2022-05-27

FAQs Constraints and Limitations Usage Specifications and Suggestions March 2022 Update

Description

Release Date

Documentation

Supports database dimension parallel multitasking

TencentDB for SQL Server supports concurrent execution of multiple tasks under the same account and within the same instance, including backup, restore, account authorization, database deletion, and rename, with support for up to 5 concurrent tasks.

2022-03-14

- February 2022 Update

Description

Release Date

Documentation

Backup commercial version release

TencentDB for SQL Server commercial version backup release supports customization of automatic backup settings. Data backup allows custom retention time and period, while log backup supports viewing and downloading. The newly-added instance dimension backup statistics overview displays backup space and free quota aggregation for all instances under the user account in each region, including total backup space for all instances and single instance backup space across two statistical dimensions. This provides users with convenient access to backup space statistics, backup trends for all instances in each region, and real-time statistics of backup space for individual instances under their account.

2022-02-15

View backup list Viewing backup space Backup Space Billing

Optimization system monitoring function

TencentDB for SQL Server optimized console system monitoring interface supports full screen display, time comparison, monitoring granularity setting and data export.

2022-02-11

View Monitoring Chart January 2022 Update

Description

Release Date

Documentation

Support basic version Cloud SSD Disk

TencentDB for SQL Server basic version supports Cloud SSD. The basic edition instance specification supports up to 24 cores and 96GB.

2022-01-20

Performance testing report

Support setting instance remarks

TencentDB for SQL Server supports editing instance remarks through the console to improve descriptiveness, making it user-friendly for better management and case-sensitive identification of instance resources.

2022-01-17

Set instance remark

Support migrating from basic network to VPC

TencentDB for SQL Server supports converting basic network to VPC through the console, convenient for users to perform network management based on business requirements.

2022-01-14

Migrate from basic network to VPC

VPC supports designated IP

TencentDB for SQL Server supports changing the network of an instance through the console. You can change from VPC network A to VPC network B with no limit on AZ, as long as it is in the same region as the instance. It also supports specifying subnet IP.

2022-01-14

Change Network (VPC to VPC) December 2021 Update

Description

Release Date

Documentation

Supporting Self-Service Configuration Changes

TencentDB for SQL Server supports self-service configuration adjustments for instances through the console, including architecture and version upgrades, self-service scaling, and multiple configuration adjustment scenarios such as simultaneous or selective scaling of CPU/memory/disk. A reminder for adjustment impact is displayed for different reconfiguration scenarios.

2021-12

Overview of Instance Configuration Adjustment November 2021 Update

Description

Release Date

Documentation

Data Migration (new version) feature update goes live.

Data Migration (new version) feature update goes live. Data Migration (legacy version) is no longer updated and will be officially decommissioned on March 1, 2022. The new version offers more features.

2021-11

SQL Server to SQL Server migration

Regional server deployment in Chongqing

TencentDB for SQL Server is now available in Chongqing Zone 1.

2021-11

Regions and AZs October 2021 Update

Description

Release Date

Documentation

Support for cross-AZ migration

Cross-AZ migration enables the migration of an instance to another availability zone within the same region. After migrating availability zones, all attributes, configurations, private network addresses, and subnets of the instance will not change.

2021-10

Cross-AZ Migration September 2021 Update

Description

Release Date

Documentation

Performance test report update

TencentDB for SQL Server has undergone a comprehensive upgrade, newly launching an ultra-high specification configuration with 90 cores and 720GB memory, reaching 4.5 million TPM. Performance and cost-effectiveness have improved by over 30%, breaking Tencent Cloud's own industry performance record again. The new release includes performance test reports for both the high-availability edition and basic edition.

2021-09

Performance testing report

Backup file support single-database backup upload to COS

By default, the instance backup is packaged and uploaded to COS. When selecting a single database backup file, the .bak file of each database in the instance will be directly uploaded to COS without packaging, supporting direct download of each separate database backup file within the database instance backup.

2021-09

Creating and Viewing Backup Tasks

Execute backup task from instance

Cluster edition instances (2017/2019) support executing backup tasks from instances.

2021-09

Creating and Viewing Backup Tasks

Bangkok regional server deployment

TencentDB for SQL Server is now available in Bangkok Zone 1 and Bangkok Zone 2.

2021-09

Regions and AZs

Singapore region server deployment

TencentDB for SQL Server is now available in Singapore Zone 2.

2021-09

Regions and AZs

Jakarta Region server deployment

TencentDB for SQL Server is now available in Jakarta Zone 2.

2021-09

Regions and AZs August 2021 Update

Description

Release Date

Documentation

Beijing Zone 6 launch

TencentDB for SQL Server is now available in Beijing Zone 6.

2021-08

Regions and AZs

Guangzhou Zone 7 server launch

TencentDB for SQL Server is now available in Guangzhou Zone 7.

2021-08

Regions and AZs July 2021 Update

Description

Release Date

Documentation

Supports configuration of change data capture (CDC)

Users can configure change data capture (CDC) in the console. CDC records all changes made to the table and the intermediate value of data, helping track table changes.

2021-07

Change data capture (CDC)

Supports configuration of change tracking (CT)

Users can configure change tracking (CT) in the console, start up change tracking to record the fact of row modification, and directly obtain latest data from the tracking table.

2021-07

Change tracking (CT)

Supports database shrinking

Users can shrink the database configuration directly in the console to avoid space waste.

2021-07

Shrink Database

Supports parameter configuration in the console

Users can view and directly modify parameters in the console and view parameter modification history, improving the ease of use for parameter modifications.

2021-07

Set instance parameters

Release system-level monitoring metrics and add new instance dimension monitoring metrics, totaling 11.

Add monitoring for 4 newly-added memory and lock-related performance counters, and 7 system-level monitoring metrics for physical machines, enabling enterprise users to comprehensively monitor database performance.

2021-07

Monitoring June 2021 Update

Description

Release Date

Documentation

Adding a large specification sales pool

The dual-server high-availability edition, cluster version, and read-only instance support large specifications of 64C512GB and 90C720GB to meet enterprise user needs.

2021-06

-

Tokyo Zone 2 is now live

TencentDB for SQL Server is now available in Tokyo Zone 2.

2021-06

Regions and AZs May 2021 Update

Description

Release Date

Documentation

TencentDB for SQL Server 2019 officially released

TencentDB for SQL Server 2019 is officially released, supporting basic version, high-availability edition, and cluster edition instance, with distinct enhancements in performance, ease of use, high availability, and security.

2021-05

Supported Versions

Beijing Zone 7 is now online

TencentDB for SQL Server is now available in Beijing Zone 7.

2021-05

Regions and AZs December 2020 Update

Description

Release Date

Documentation

Self-service version upgrades and architecture upgrades are supported.

Support self-service version upgrades, architecture upgrades, and scaling in the console, making it easy to adjust instances based on business needs.

2020-12

Adjust Instance Specification November 2020 Update

Description

Release Date

Documentation

Support tag integration

TencentDB for SQL Server supports tag integration. Tags can be used to classify resource usage methods, user groups, and business scenarios under the account.

2020-11

-

Regional server deployment in Chengdu

TencentDB for SQL Server is now available in the Chengdu region.

2020-11

Regions and AZs October 2020 Update

Description

Release Date

Documentation

Integration of DTS migration and optimization of Cold Backup Migration

DTS supports SQL Server data migration from IDC self-built, self-built on Cloud, other cloud vendors, and Cloud Instances to TencentDB for SQL Server. Cold Backup Migration performs data recovery using .bak backup files, suitable for migrating data from other cloud vendors or self-built SQL Server databases to TencentDB for SQL Server. Multiple migration methods provide SQL Server cloud users with a more convenient and comfortable cloud migration experience.

2020-10

Cold Backup Migration July 2020 Update

Description

Release Date

Documentation

TencentDB for SQL Server Basic Version (Standalone Edition) officially goes live.

TencentDB for SQL Server Basic Version is now live, supporting sysadmin privilege on the cloud. The basic version provides genuine authorization, high availability, high security, high performance, and a complete database solution with lightweight operations.

2020-07

Product Architecture March 2020 Update

Description

Release Date

Documentation

Support admin account

Newly-added support for admin permissions, granting read and write permissions as well as thread management permission for ALL DBs in the instance. It also enables auto discovery of new additions to the instance and automatically obtains read and write permissions for the DB.

2020-03

- January 2020 Update

Description

Release Date

Documentation

Support Always On clusters

TencentDB for SQL Server 2017 Enterprise Edition supports adding read-only instances. The underlying Always On architecture implements cluster capability control, such as automated data replication, traffic load balancing for read-only instances, and instance primary/backup switch.

2020-01

Product Architecture December 2019 Update

Description

Release Date

Documentation

support multi-availability zone deployment

Multi-AZ deployment meets customers' cross-region disaster recovery requirements and provides better availability assurance.

2019-12

Multi-AZ Disaster Recovery

Support setting maintenance time

Support setting maintenance time. To ensure the stability of cloud database instances, the backend system performs maintenance on instances during maintenance time.

2019-12

Set instance maintenance information October 2019 Update

Description

Release Date

Documentation

Support security group configuration.

Security Group is a stateful virtual firewall with filtering function, used to set network access control for single or multiple cloud databases (CDBs). It is an important means of network security isolation.

2019-10

Configuring a security group

Support Recycle Bin Feature

Pay-as-you-go instances are automatically moved to the recycle bin upon expiration or manual termination.

2019-10

- September 2019 Update

Description

Release Date

Documentation

Support console database creation with selectable character sets

Enable multiple Microsoft SQL Server character sets on the console for users to select when creating a database.

2019-09

Create a Database July 2019 Update

Description

Release Date

Documentation

TencentDB for SQL Server supports the Seoul region

TencentDB for SQL Server is now available in the Seoul region.

2019-07

Regions and AZs June 2019 Update

Description

Release Date

Documentation

Support pay-as-you-go mode.

TencentDB for SQL Server supports pay-as-you-go sales model. Users can select the required mode according to business needs.

2019-06

Billing Overview May 2019 Update

Description

Release Date

Documentation

Instance upgrade support

Support upgrading and expanding the specifications of database instances.

2019-05

Adjusting Instance Specifications September 2017 Update

Description

Release Date

Documentation

Support the 2016 version for sale

TencentDB for SQL Server released the 2016 version.

2017-09

- December 2016 Update

Description

Release Date

Documentation

Support Standby Read-Only

TencentDB for SQL Server launches standby read-only with memory and disks as needed, creating tailored database specifications for your business. The snapshot method enables standby read-only to assist online data analysis, adding no cost, unaffected primary performance, and maintaining high availability.

2016-12

- May 2016 Update

Description

Release Date

Documentation

Support 2012 Enterprise Edition

TencentDB for SQL Server released the 2012 Enterprise Edition, fully compatible with all functions supported by the 2008 version.

2016-05

- December 2015 Update

Description

Release Date

Documentation

TencentDB for SQL Server officially released

TencentDB for SQL Server is now live, including instance management, instance details, system monitoring, database management, account management, backup, and other features.

2015-12

Overview Next Topic: Product Announcements Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page September 2026 August 2026 July 2026 June 2026 May 2026 April 2026 March 2026 January 2026 December 2025 October 2025 September 2025 August 2025 July 2025 May 2025 April 2025 March 2025 February 2025 January 2025 August 2024 July 2024 June 2024 May 2024 April 2024 March 2024 December 2023 November 2023 October 2023 September 2023 August 2023 June 2023 May 2023 April 2023 March 2023 February 2023 January 2023 December 2022 November 2022 October 2022 September 2022 August 2022 July 2022 June 2022 May 2022 March 2022 February 2022 January 2022 December 2021 November 2021 October 2021 September 2021 August 2021 July 2021 June 2021 May 2021 December 2020 November 2020 October 2020 July 2020 March 2020 January 2020 December 2019 October 2019 September 2019 July 2019 June 2019 May 2019 September 2017 December 2016 May 2016 December 2015 Search AllCurrent Product Search titles only Enter keywords to search documentation
