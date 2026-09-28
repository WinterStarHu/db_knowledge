# Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7

> 来源: https://www.tencentcloud.com/document/product/236/74099

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Practical Tutorial Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Download Focus Mode Font Size Last updated: 2025-10-27 18:01:40 AI-Translated TencentDB for MySQL provides two main methods for upgrading your database version: direct upgrade via the console and indirect upgrade via the Data Transfer Service (DTS). This document uses the upgrade from MySQL 5.6 to MySQL 5.7 as an example to introduce these two database version upgrade methods and their implementation.
Version Upgrade Prerequisites The syntax create table …  as select … is not supported.
Source-replica synchronization for TencentDB for MySQL 5.6 and 5.7 is implemented based on GTID and by default only supports the InnoDB engine.
If the number of tables in a single instance exceeds 300,000, it may cause the upgrade to fail and also affect database monitoring. It is recommended to reasonably standardize and control the number of tables per single instance to no more than 300,000.
Upgrade Method Description Direct upgrade via console: If conditions (the aforementioned Version Upgrade Prerequisites) are met, you can directly operate in the console to upgrade the database version of the existing instance to a higher version. This method is usually more convenient. It is recommended to perform a compatibility check before upgrading and to perform the upgrade during off-peak business hours.
﻿Indirect upgrade via DTS: If your instance does not meet the conditions for direct upgrade or it is not convenient to perform a direct upgrade, you can purchase a new MySQL instance with a higher version, and use DTS to migrate data of the original instance to the new one. After the data is verified, you can switch your business to the new instance and release the original instance. This method offers high flexibility but requires additional data migration and verification work.
Must-Knows The database version cannot be downgraded.
Instances with single-node (Cloud Disk) or cluster edition (Cloud Disk) architecture do not support upgrading the database version.
The primary instance, its associated read-only instances, and disaster recovery instances will be upgraded to the target database version simultaneously. You can upgrade the database version of the primary instance to associate the upgrade of read-only instances and disaster recovery instances under it.
Upgrading TencentDB for MySQL to a new version involves data migration and typically takes a considerable amount of time. During this period, your business will remain unaffected and accessible.
When the version upgrade is completed, an instance switchover will be involved (there will be a second-level database disconnection). It is recommended that user applications possess an automatic reconnection feature and that the switchover is performed during instance maintenance time. For details, see Setting Instance Maintenance Time.
Method One: Direct Upgrade via the Console Preparations Learn about the differences and advantages between old and new versions. For differences in supported features, see Appendix 1: Feature Differences Between MySQL 5.6 and 5.7. For upgrade advantages, see Appendix 2: Advantages of Upgrading from MySQL 5.6 to 5.7.
Understanding the Upgrade Process and Impact Database versions do not support cross-version upgrades, and by default, upgrades to the latest minor version within the target major version. For example, MySQL 5.6 cannot be directly upgraded to MySQL 8.0. You need to first upgrade it to MySQL 5.7, then to MySQL 8.0.
The minimum database version for instances with cluster edition (Cloud Disk) architecture is MySQL 5.7. Therefore, upgrading from MySQL 5.6 to MySQL 5.7 is not involved.
Checking Instance and Database Configuration Check custom functions and ensure no reserved keywords are used within the functions. For reserved keywords, see MySQL Official Keywords and Reserved Words.
Check whether there is a successful record of a full data backup in the past week, and perform a full data backup if necessary.
Before upgrading, ensure that sufficient storage space is reserved.
Increase the local log retention period. For specific operations, see Configuring Local Binlog Retention Policy.
To ensure the stability and performance of MySQL in the new database version, after completing the database version upgrade, TencentDB for MySQL no longer supports modifying certain parameters from the lower version that are deprecated in the higher version. Before upgrading the database version, it is recommended to back up modification records of related parameters for subsequent operations and auditing.
Pre-upgrade Testing and Simulation It is recommended to create an instance with a higher database version to perform syntax testing before upgrading, to avoid situations where syntax or features from the lower database version are not supported after upgrading to the higher version.
It is recommended to clone the instance before upgrading. First, use the cloned instance for upgrade testing, and after confirming all features are normal, upgrade the original instance.
Post-upgrade Must-Knows The database version cannot be downgraded. If you need to use the upgrade rollback capability, submit a ticket to apply.
Operation Steps See Upgrading the Database Version of MySQL 5.5 and MySQL 5.6.
Method Two: Indirect Upgrade via DTS For a MySQL 5.6 instance that does not meet the conditions for a direct upgrade, or if it is not convenient to perform a direct upgrade, you can create an instance with a database version of MySQL 5.7 and migrate the data from the original instance to the new instance via DTS. After performing compatibility testing on the new instance and monitoring it for a period of time to confirm its normal operation, you can choose to destroy the original instance and use the new instance, thereby achieving an indirect upgrade of the database version.
Operation Steps
1.
Create a MySQL 5.7 instance. For the method, see Creating MySQL Instance.
2.
Migrate data to the MySQL 5.7 instance created above via DTS. For details, see Migration from MySQL to TencentDB for MySQL.
3.
Log in to the Database Management Center (DMC) console, and check whether the data is normal. For the login method, see DMC Management.
4.
Destroy the original instance. For the method, see Terminating Instance.
Appendix 1: Feature Differences Between MySQL 5.6 and MySQL 5.7 The following table lists only partial feature differences between MySQL 5.7 and MySQL 5.6. For differences between other versions, see MySQL Official Release Notes.
Feature

MySQL 5.6

MySQL 5.7

Automatically killing idle transactions

Supported

Supported

Parallel replication

Supported

Supported

Dynamic thread pool

Not supported

Supported

NOWAIT syntax

Not supported

Supported

Returning

Not supported

Supported

Column compression

Not supported

Supported

Flashback query

Not supported

Supported

Large transaction replication

Supported

Supported

Support for using fdatasync

Not supported

Supported

Auto-increment column persistence

Not supported

Supported

InnoDB buffer pool parallel initialization

Supported

Supported

FAST DDL

Not supported

Supported

Invisible Index

Not supported

Supported

CATS transaction scheduling

Not supported

Supported

Computation pushdown

Not supported

Supported

Transparent data encryption

Not supported

Supported

Instant column addition

Not supported

Supported

Asynchronous large table deletion

Supported

Supported

Hotspot update

Not supported

Supported

SQL throttling

Supported

Supported

﻿LibraDB﻿

Not supported

Supported Appendix 2: Advantages of Upgrading from MySQL 5.6 to MySQL 5.7 Add the transparent data encryption feature to improve database security.
Support hotspot update merge optimization to enhance hotspot update performance.
Support DDL progress display. During DDL operation, execute the show detail processlist command to view the progress.
Add the default table encryption feature.
Support flashback query persistence.
Support the nonblocking DDL feature.
Support the validate password plugin.
Support storing historical deadlock information.
Support the InnoDB auto-increment column persistence feature.
Previous Topic: How to Configure Alarms for Storage Overuse Lock Events Next Topic: Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Version Upgrade Prerequisites Upgrade Method Description Must-Knows Method One: Direct Upgrade via the Console Preparations Operation Steps Method Two: Indirect Upgrade via DTS Operation Steps Appendix 1: Feature Differences Between MySQL 5.6 and MySQL 5.7 Appendix 2: Advantages of Upgrading from MySQL 5.6 to MySQL 5.7 Search AllCurrent Product Search titles only Enter keywords to search documentation
