# Release Notes

> 来源: https://www.tencentcloud.com/document/product/236/35197

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Release Notes and Announcements Release Notes Release Notes Download Focus Mode Font Size Last updated: 2026-09-20 22:02:14 AI-Translated & Reviewed September 2026 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.4.10.

2026-09-17

Database Proxy Version Release Notes August 2026 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20260501 was released for TencentDB for MySQL 5.7.

2026-08-11

TXSQL Kernel Version Release Notes July 2026 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.4.8.

2026-07-16

Database Proxy Version Release Notes June 2026 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20260512 was released for TencentDB for MySQL 8.0.

2026-06-30

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.22.

2026-06-02

Database Proxy Version Release Notes May 2026 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20260430 was released for TencentDB for MySQL 8.0.

2026-05-29

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.4.7.

2026-05-21

Database Proxy Version Release Notes April 2026 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.21.

2026-04-30

Database Proxy Version Release Notes

Enhanced Hotspot Update Capability

The hotspot update feature of TencentDB for MySQL introduced the concept of transaction merging based on the queuing mechanism, launching an enhanced version of the hotspot update feature.

2026-04-09

Hotspot Update Enhancement: Merge Optimization

Release of TencentDB for MySQL 8.4

TencentDB for MySQL released the major database version MySQL 8.4.

2026-04-02

TXSQL Kernel Version Release Notes

TXSQL kernel feature update

The kernel version of TencentDB for MySQL 8.0 was updated to 20250430 and 20250501.

2026-04-02

TXSQL Kernel Version Release Notes March 2026 Update

Description

Release Date

Documentation

Supporting network forwarding

The TencentDB for MySQL database proxy supports the network forwarding feature, which forwards SQL using a pure network mode to reduce access latency.

2026-03-30

Network Forwarding Feature

Adding support for enabling public network in Jakarta and Riyadh

TencentDB for MySQL now supports enabling public network connections in Jakarta and Riyadh.

2026-03-23

Enabling Public Network Connection February 2026 Update

Description

Release Date

Documentation

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Added support for retaining the time filter when switching audit instances in the console's audit log query interface.
Added support for batch pasting client IP addresses in the console's audit log filter.
Introduced a new "Client Port" field to audit logs.
Extended the allowed characters for custom COS paths used for audit log shipping to include the underscore ("_").
Included the "Error Code" parameter in rule templates.

2026-02-02

Enabling the Audit Service December 2025 Update

Description

Release Date

Documentation

LibraDB kernel version update

A new kernel version (4.2509.1.0) was released for the TencentDB for MySQL analysis engine. This update introduced several new kernel features, along with system fixes and optimizations.

2025-12-24

LibraDB Engine Kernel Version Release Notes November 2025 Update

Description

Release Date

Documentation

LibraDB kernel version update

New kernel versions (4.2506.2.0 and 2.2410.14.0) were released for the TencentDB for MySQL analysis engine. These updates introduced several new kernel features, along with system fixes and optimizations.

2025-11-27

LibraDB Engine Kernel Version Release Notes

TXSQL kernel feature update

The new kernel versions 20221002 and 20241009 were released for TencentDB for MySQL 8.0.

2025-11-26

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.20.

2025-11-11

Database Proxy Version Release Notes

Free trial of audit logs and SQL analysis

A 30-day free trial was provided for the database audit feature of TencentDB for MySQL and the SQL analysis feature of TencentDB for DBbrain (DBbrain).

2025-11-03

Audit Logs and SQL Analysis October 2025 Update

Description

Release Date

Documentation

Support for enabling instance termination protection

The existing and newly purchased TencentDB for MySQL instances supported enabling instance termination protection. Once enabled, the instances could not be terminated directly through the console or API, effectively preventing accidental instance termination.

2025-10-30

Setting Instance Termination Protection

Network forwarding mode supported by the database proxy

The database proxy of instances with the TencentDB for MySQL Cluster Edition (cloud disk) architecture supported enabling network forwarding. Once enabled, SQL distribution would be performed through network forwarding.

2025-10-30

Viewing and Modifying Access Policies

Release of a new version of the Instance Details page

A new version of the Instance Details page of TencentDB for MySQL was released, showing the instance information, network information, specification configuration, resource usage, and instance architecture diagram more clearly to help enhance the instance operation management capabilities.

2025-10-28

Operation Overview

LibraDB kernel version update

New kernel versions 3.2503.7.0 and 2.2410.13.0 were released for the analysis engine of TencentDB for MySQL. They supported multiple new kernel features, fixed system issues, and optimized the system.

2025-10-24

LibraDB Engine Kernel Version Release Notes

New regions supported by the analysis engine

The regions Hong Kong (China) and Nanjing were supported for the analysis engine of TencentDB for MySQL.

2025-10-22

Regions and AZs

LibraDB kernel version update

The new kernel version 4.2506.1.0 was released for the analysis engine of TencentDB for MySQL. It supported multiple new kernel features and optimized the system.

2025-10-21

LibraDB Engine Kernel Version Release Notes

TXSQL kernel feature update

The new kernel version 20250803 was released for TencentDB for MySQL 5.7.

2025-10-16

TXSQL Kernel Version Release Notes

LibraDB kernel version update

The new kernel version 3.2503.6.0 was released for the analysis engine of TencentDB for MySQL. It supported multiple new kernel features, fixed system issues, and optimized the system.

2025-10-10

LibraDB Engine Kernel Version Release Notes

Automatic row-based storage and column-based storage node forwarding policy supported by the database proxy

The database proxy version 1.4.5 supported configuring request forwarding to read-only or read-write instances when the read-only analysis engine failed. It also supported forwarding SQL requests to the read-only analysis engine based on the read weight.

2025-10-10

Viewing and Modifying Access Policies

Viewing slow SQL details supported by the analysis engine

Slow SQL details and SQL analysis reports for read-only analysis engine instances could be viewed in the console.

2025-10-10

Viewing Slow SQL Details of the Analysis Engine September 2025 Update

Description

Release Date

Documentation

Flagship instances supported by Cluster Edition

TencentDB for MySQL flagship instances with the Cluster Edition architecture were launched in regions outside the Chinese mainland (Singapore, Frankfurt, and Jakarta), which provide higher performance.

2025-09-26

Cluster Edition

New regions supported by the analysis engine

The Frankfurt region was supported for the analysis engine of TencentDB for MySQL.

2025-09-22

Regions and AZs

LibraDB kernel version update

New kernel versions 3.2503.5.0 and 2.2410.12.0 were released for the analysis engine of TencentDB for MySQL. They supported multiple new kernel features, fixed system issues, and optimized the system.

2025-09-15

LibraDB Engine Kernel Version Release Notes

TXSQL kernel feature update

The new kernel version 20250802 was released for TencentDB for MySQL 5.7.

2025-09-10

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.4.5.

2025-09-08

Database Proxy Version Release Notes August 2025 Update

Description

Release Date

Documentation

LibraDB kernel version update

The new kernel version 2.2410.11.1 was released for the analysis engine of TencentDB for MySQL. It supported multiple new kernel features, fixed system issues, and optimized the system.

2025-08-28

LibraDB Engine Kernel Version Release Notes

TXSQL kernel feature update

The new kernel version 20241005 was released for TencentDB for MySQL 8.0.

2025-08-25

TXSQL Kernel Version Release Notes

TXSQL kernel feature update

The new kernel version 20250730 was released for TencentDB for MySQL 5.7.

2025-08-25

TXSQL Kernel Version Release Notes

Support for shipping database audit logs to COS

The database audit feature of TencentDB for MySQL supported shipping logs to Cloud Object Storage (COS). COS provided stable, durable, and low-cost storage services. Audit logs were stored in COS to meet the requirements for long-term data storage.

2025-08-12

Log Shipping

New regions supported by the analysis engine

The regions Virginia and São Paulo were supported for the analysis engine of TencentDB for MySQL.

2025-08-05

Regions and AZs

LibraDB kernel version update

New kernel versions 3.2503.4.0 and 2.2410.10.1 were released for the analysis engine of TencentDB for MySQL. They supported multiple new kernel features, fixed system issues, and optimized the system.

2025-08-05

LibraDB Engine Kernel Version Release Notes July 2025 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.19.

2025-07-18

Database Proxy Version Release Notes

LibraDB kernel version update

The new kernel version 3.2503.1.0 was released for the read-only analysis engine of TencentDB for MySQL. It supported multiple new kernel features.

2025-07-01

LibraDB Engine Kernel Version Release Notes June 2025 Update

Description

Release Date

Documentation

New regions supported by the read-only analysis engine

The Singapore and Chengdu regions were supported for the read-only analysis engine of TencentDB for MySQL.

2025-06-30

Regions and AZs

TXSQL kernel feature update

The new kernel version 20250510 was released for TencentDB for MySQL 5.7.

2025-06-27

TXSQL Kernel Version Release Notes

LibraDB kernel version update

TencentDB for MySQL released version 2.2410.8.0 with bugs fixed for the read-only analysis engine.

2025-06-25

LibraDB Engine Kernel Version Release Notes

LibraDB kernel version update

The new kernel version 2.2410.7.0 was released for the read-only analysis engine of TencentDB for MySQL. It supported multiple new kernel features.

2025-06-20

LibraDB Engine Kernel Version Release Notes

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Optimized the interface display after the configuration of log shipping to TDMQ for CKafka was successful.
Added PREPARE to the feature string of the parameter field "SQL Type" in the rule content when a rule template was created or modified.
Fixed the issue that no audit record could be matched by entering a table name.

2025-06-09

Enabling the Audit Service

Update of the CPU elastic scale-out feature

TencentDB for MySQL released a new version of the CPU elastic scale-out feature. It supported automatic and custom CPU scale-out to easily cope with burst load and ensure online business stability.
The scale-out methods after the update included automatic scale-out and custom scale-out.
Custom scale-out supported setting the scale-out time, which can be Now, By time period, or By cycle.
When the scale-out time was set to By time period or By cycle, automatic scale-out could be enabled.
The scale-out history could be queried.

2025-06-05

Overview May 2025 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.17.

2025-05-13

Database Proxy Version Release Notes

LibraDB kernel version update

New kernel versions 1.2404.24.0 and 2.2410.6.0 were released for the read-only analysis engine of TencentDB for MySQL.

2025-05-06

LibraDB Engine Kernel Version Release Notes April 2025 Update

Description

Release Date

Documentation

Support for backup retention settings

TencentDB for MySQL supported backup retention settings to prevent accidental instance deletion from causing immediate backup termination. This ensured data traceability and recoverability.

2025-04-29

Backup Retention Settings

Support for configuration adjustment on the read-only analysis engine

Read-only analysis engine instances of TencentDB for MySQL supported adjusting the instance configuration.

2025-04-27

Configuration Adjustment

Support for multi-node high availability on the read-only analysis engine

Read-only analysis engine instances of TencentDB for MySQL supported multi-node high availability capabilities.

2025-04-27

Multi-node High Availability

Support for alarm configuration on the read-only analysis engine

Read-only analysis engine instances of TencentDB for MySQL supported alarm configuration capabilities.

2025-04-27

Monitoring Alarms

LibraDB kernel version update

New kernel versions 1.2404.23.0 and 2.2410.5.0 were released for the read-only analysis engine of TencentDB for MySQL.

2025-04-22

LibraDB Engine Kernel Version Release Notes

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Added the display of the generation progress in the audit log file list.
Added the options of "All fields" and "Interaction with custom list fields (including field order and content)" when an audit log file was created.
Added PREPARE for the SQL type.
Optimized the display of source IP addresses for SaaS operations (Data Transfer Service (DTS), DBbrain, and Database Management Center (DMC)).
Optimized the display of error codes, transaction IDs, and table names.
Added version support descriptions for audit log fields.
Optimized the timeout logic for the fuzzy query and wildcard query scenarios.

2025-04-09

Enabling the Audit Service March 2025 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20250330 was released for TencentDB for MySQL 5.7.

2025-03-27

TXSQL Kernel Version Release Notes

Release of two-node economical instances

TencentDB for MySQL supported two-node economical instances. The new architecture provided stable services to meet the business requirements for computing and storage resources and reduce the use costs. Small and medium-sized enterprises and individual developers could use database services that better met their business requirements.

2025-03-26

Economical Instances

LibraDB kernel version update

TencentDB for MySQL released versions 1.2404.22.1 and 2.2410.4.1 with bugs fixed for the read-only analysis engine.

2025-03-25

LibraDB Engine Kernel Version Release Notes

LibraDB kernel version update

TencentDB for MySQL released versions 1.2404.22.0 and 2.2410.4.0 with bugs fixed for the read-only analysis engine.

2025-03-15

LibraDB Engine Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.4.4.

2025-03-14

Database Proxy Version Release Notes

Support for shipping database audit logs to TDMQ for CKafka

TencentDB for MySQL supported shipping database audit logs to TDMQ for CKafka. The database audit logs of instances could be collected and shipped to TDMQ for CKafka for real-time stream computing.

2025-03-12

Log Shipping

Support for shipping database audit logs to CLS

TencentDB for MySQL supported shipping database audit logs to Cloud Log Service (CLS). The database audit logs of instances could be collected and shipped to CLS for unified management and analysis.

2025-03-12

Log Shipping

Database audit feature supported by Cluster Edition

Instances of TencentDB for MySQL Cluster Edition supported the database audit feature. After the database audit feature was enabled, users could view audit logs, perform full audit and rule-based audit, search for audit logs, configure post-event alarms, and ship audit logs to TDMQ for CKafka and CLS.

2025-03-12

Database Audit Overview

TXRocks kernel feature update

The new kernel version 20240702 was released for TencentDB for MySQL 5.7.

2025-03-11

TXRocks Engine Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.16.

2025-03-06

Database Proxy Version Release Notes February 2025 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20241001 was released for TencentDB for MySQL 8.0.

2025-02-18

TXSQL Kernel Version Release Notes

LibraDB kernel version update

TencentDB for MySQL released version 1.2404.21.0 with bugs fixed for the read-only analysis engine.

2025-02-12

LibraDB Engine Kernel Version Release Notes

LibraDB kernel version update

The new kernel version 2.2410.1.0 was released for the read-only analysis engine of TencentDB for MySQL. It supported multiple new kernel features.

2025-02-05

LibraDB Engine Kernel Version Release Notes January 2025 Update

Description

Release Date

Documentation

Beta testing for the read-only analysis engine

The read-only analysis engine feature of TencentDB for MySQL was under beta testing. It significantly improved performance in multiple business scenarios such as complex SQL execution, big data processing, and multi-table joins. It could be widely used in typical scenarios such as slow queries, batch data processing, and reconciliation queries.

2025-01-21

Overview

TXSQL kernel feature update

The new kernel version 20240930 was released for TencentDB for MySQL 8.0.

2025-01-10

TXSQL Kernel Version Release Notes December 2024 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20230704 was released for TencentDB for MySQL 8.0.

2024-12-31

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.15.

2024-12-19

Database Proxy Version Release Notes

TXSQL kernel feature update

The new kernel version 20230703 was released for TencentDB for MySQL 8.0.

2024-12-18

TXSQL Kernel Version Release Notes

TXRocks kernel feature update

The new kernel version 20231030 was released for TencentDB for MySQL 8.0.
Added the virtual bulk load feature.
Added the LOCK TABLES FOR BACKUP syntax.

2024-12-03

TXRocks Engine Kernel Version Release Notes

TXRocks kernel feature update

The new kernel version 20231030 was released for TencentDB for MySQL 5.7.
Added the virtual bulk load feature.

2024-12-03

TXRocks Engine Kernel Version Release Notes November 2024 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20230702 was released for TencentDB for MySQL 8.0 to improve database performance and stability:
Reduced the overhead caused by frequent notifying of the exchange operator in parallel queries.
Fixed the instance crash issue that occurred when INSTANT DDL was executed to modify the column position.

2024-11-12

TXSQL Kernel Version Release Notes

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.14.

2024-11-08

Database Proxy Version Release Notes August 2024 Update

Description

Release Date

Documentation

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.13.

2024-08-26

Database Proxy Version Release Notes

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Released a new version of the rule-based audit feature.
Uniformly changed the unit of the audit log field Execution Time to microseconds in both the console and downloaded audit log files.
Added the display of the millisecond-level time for the unit of the Timestamp field in audit log files.
Note: The old version of the rule-based audit feature provided on the Audit Rules and Audit Policies pages will be unavailable soon. Adjust and configure the new version of the rule-based audit feature in a timely manner.

2024-08-09

Enabling the Audit Service Modifying Audit Rules

TXSQL kernel feature update

The new kernel version 20240331 was released for TencentDB for MySQL 5.7 to improve database performance and stability:
Incorporated changes from official versions 5.7.36, 5.7.37, 5.7.38, 5.7.39, 5.7.40, 5.7.41, 5.7.42, 5.7.43, and 5.7.44.
Added the update returning feature.
Added the display of the Data Definition Language (DDL) progress. During the DDL operation period, the show detail processlist command could be executed to view the progress.
Added the default table encryption feature.

2024-08-09

TXSQL Kernel Version Release Notes

Support for one-click upgrade to Cluster Edition

TencentDB for MySQL supported one-click upgrade of dual-node and three-node instances to Cluster Edition instances.

2024-08-01

One-Click Upgrade to Cluster Edition July 2024 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20230701 was released for TencentDB for MySQL 8.0 to improve database performance and stability:
Supported restoring TXSQL physical backups by using the community edition.
Replaced all keywords in the AWR feature with TXSQL_AWR.
Fixed the issue where the underlying tables failed to open when competition occurred between background threads and RENAME operations on the dict cache.

2024-07-30

TXSQL Kernel Version Release Notes June 2024 Update

Description

Release Date

Documentation

Support for Cluster Edition

The TencentDB for MySQL Cluster Edition architecture was fully released.

2024-06-28

MySQL Cluster Edition Overview

Update of the Product Pricing page

A new version of the Product Pricing page of TencentDB for MySQL was released, supporting the query and export of prices for different types/architectures and comprehensively covering price query and quotation scenarios.

2024-06-26

Product Pricing Page

Support for CAM authentication (password-free account login)

TencentDB for MySQL supported enabling the Cloud Access Management (CAM) authentication (password-free account login) feature, helping you simplify the complexity of account permission management, and enhancing database security and account management efficiency.

2024-06-24

Support for CAM Authentication (Password-Free Account Login)

Database proxy version update

TencentDB for MySQL released database proxy version 1.3.12.

2024-06-14

Database Proxy Version Release Notes May 2024 Update

Description

Release Date

Documentation

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Optimized the query time box on the Audit Log page and added quick query time options.
Added the Table Name and Transaction ID fields to audit logs.

2024-05-16

Viewing Audit Logs

Support for multiple disaster recovery instances

The primary instances with the TencentDB for MySQL two-node or three-node architecture support mounting multiple disaster recovery instances. This enhances business continuity and data reliability.

2024-05-15

Managing Disaster Recovery Instances April 2024 Update

Description

Release Date

Documentation

TXSQL kernel feature update

The new kernel version 20230630 was released for TencentDB for MySQL 8.0 to improve database performance and stability:
Supported the nonblocking DDL feature.
Supported recording the TP/AP load statistics of the largest GTS instance in the relay log for XA commit.
Supported selecting InnoDB temporary tables to be shared by parallel query worker threads.
Supported using partitioned tables as parallel tables in parallel queries.
Supported the flashback version query feature.
Supported flashback query persistence.
Supported virtual indexes.
Supported the range-based/list-based secondary partitioning feature.
Supported the feature of automatic relay log recovery.
Supported the default algorithm of DDL. INPLACE and INSTANT were optional.
Supported Fast Query Cache.
Supported the conversion of partitioned tables from MyISAM to InnoDB.

2024-04-23

TXSQL Kernel Version Release Notes March 2024 Update

Description

Release Date

Documentation

Support for Cluster Edition

During the grayscale release of the TencentDB for MySQL Cluster Edition architecture, multiple specific capabilities of Cluster Edition were provided, including automatic failover, switching of any secondary node (read-only node) to a primary node (read-write node), read-only secondary nodes, on-demand node addition and deletion, multi-availability zone (AZ) disaster recovery, node-level monitoring, and node topology management. These features help users handle diverse and complex business scenarios.

2024-03-26

MySQL Cluster Edition Overview

TXSQL kernel feature update

The new kernel version 20230601 was released for TencentDB for MySQL 5.7 to improve database performance and stability:
Supported flashback query persistence.
Supported DROP TABLE FORCE to implement dropping InnoDB metadata.
Supported Parallel Copy DDL.
Supported the LIMIT clause in subqueries.
Supported the conversion of partitioned tables from MyISAM to InnoDB.

2024-03-19

TXSQL Kernel Version Release Notes February 2024 Update

Description

Release Date

Documentation

Support for cross-region CLS

TencentDB for MySQL supported shipping slow logs and error logs to cross-region CLS.

2024-02-26

Log Shipping November 2023 Update

Description

Release Date

Documentation

Support for setting data verification sensitivity

In scenarios where migration and specification changes were triggered due to the configuration adjustment of primary instances of TencentDB for MySQL, data verification sensitivity settings were introduced to control the data verification duration and performance impact.

2023-11-27

Adjusting Instance Specifications October 2023 Update

Description

Release Date

Documentation

Support for log shipping

TencentDB for MySQL supported shipping slow logs and error logs. It collected the corresponding log data and shipped the data to CLS, achieving rapid monitoring and localization of business issues.

2023-10-18

Log Shipping

Support for upgrading MySQL 5.7 to MySQL 8.0

TencentDB for MySQL fully supported upgrading MySQL 5.7 to MySQL 8.0. MySQL 8.0 delivered better performance and enhanced features, demonstrating more outstanding performance in high-concurrency and big-data scenarios while providing enhanced system performance and stability.

2023-10-10

Upgrading MySQL 5.7 to MySQL 8.0

Support for the Frankfurt region for single-node instances

TencentDB for MySQL single-node instances supported the Frankfurt region, offering ultra-high cost-effectiveness and supporting a maximum of 30 TB of storage space.

2023-10-10

Single-Node Instances (Formerly Basic Edition and Cloud Disk Edition) September 2023 Update

Description

Release Date

Documentation

Database audit optimization

TencentDB for MySQL optimized the database audit feature as follows:
Supported binding multiple rule templates to instances.
Changed the relationship between rule templates and instances from initialization to strong binding. That is, the modification of the content in a rule template would cause a change to the audit rules used for instances bound to the template.
Supported viewing the rule templates bound to each instance, the audit rules hit by each audit log, and the instances associated with each rule template.
Integrated with EventBridge and Tencent Cloud Observability Platform (TCOP), supporting high, medium, and low-risk event alarms.

2023-09-25

Enabling the Audit Service Creating a Rule Template Configuring Post-Event Alarms August 2023 Update

Description

Release Date

Documentation

Transaction-level connection pools supported by the database proxy

The database proxy of TencentDB for MySQL supported transaction-level connection pools, helping enhance database concurrency performance and resource utilization. This avoided competition and conflicts among multiple transactions and improved the concurrency performance and reliability of transaction processing.

2023-08-25

Connection Pool Overview

Optimization of the Instance Details page

The Instance Details page of TencentDB for MySQL was optimized to support viewing the instance health status and abnormal alarms and provide an improved display of instance configurations in terms of availability, performance, and security.

2023-08-16

Viewing the Instance Health Status

Database audit optimization

The Database Audit Log page of TencentDB for MySQL was optimized. SQL command details supported multi-mode search, with matching options including Include/Exclude, OR/AND, and Segment/Wildcard.

2023-08-09

Viewing Audit Logs July 2023 Update

Description

Release Date

Documentation

Support for binlog encryption

TencentDB for MySQL supported binlog encryption to improve data security and reliability.

2023-07-17

Backup Encryption

Database audit optimization

The Database Audit Log page of TencentDB for MySQL was optimized. Various search patterns, such as fuzzy, precise, forward, reverse, simple, and complex search patterns, were supported. The units of the audit log fields Execution Time and CPU Time were uniformly changed to microseconds in both the console and downloaded audit log files.

2023-07-12

Viewing Audit Logs May 2023 Update

Description

Release Date

Documentation

Support for performance elastic management

The performance elastic management feature of TencentDB for MySQL was fully released, supporting manual CPU scaling and automatic performance scaling. This better alleviated performance pressure caused by sudden requests, adapted to peak business traffic, and ensured the stability of the online business.

2023-05-25

Performance Elastic Management

Release of the new database audit version

The new database audit version of TencentDB for MySQL was in grayscale release. The new version supported full audit and rule-based audit features. It provided features such as data collection integrity and reliability, data tamper-proofing, data transmission integrity, and data storage integrity.

2023-05-15

Enabling the Audit Service

Support for the creation of cross-AZ RO groups

TencentDB for MySQL supported creating cross-AZ read-only (RO) groups. That is, RO groups could reside in a different AZ from the primary instance, enhancing data disaster recovery capabilities.

2023-05-04

Managing RO Groups of Read-Only Instances March 2023 Update

Description

Release Date

Documentation

Launch of the new purchase page

The new purchase page of TencentDB for MySQL was released, supporting one-click configuration import and faster specification filtering. This facilitated quick adjustments and purchases based on existing configurations.

2023-03-16

Purchase Methods February 2023 Update

Description

Release Date

Documentation

Support for the monthly configuration of the backup cycle

The backup cycle of automatic backup of TencentDB for MySQL could be set on a monthly basis. That is, the backup cycle supported custom configuration on a weekly or monthly basis for backup time settings.

2023-02-28

Setting Automatic Backup

Support for transition-to-cold storage for backup

TencentDB for MySQL supported configuring transition-to-cold storage for backup. The storage type of generated backup files could be transitioned based on policies to reduce backup storage costs.

2023-02-14

Configuring Transition-to-Cold Storage December 2022 Update

Description

Release Date

Documentation

Support for parallel queries

TencentDB for MySQL supported the parallel query capabilities. By leveraging parallel query capabilities, it mobilized multi-core computing resources, significantly reducing the response time for large queries.

2022-12-22

Parallel Queries November 2022 Update

Description

Release Date

Documentation

Release of the new database proxy version

TencentDB for MySQL released a new version of database proxy. It provided robust features including automatic read-write separation, transaction splitting, connection pools, and momentary disconnection protection. It also supported mounting read-only instances across AZs and creating multiple database proxy access addresses to meet various business scenario requirements.

2022-11-02

﻿Database Proxy (New Version) October 2022 Update

Description

Release Date

Documentation

Support for backup encryption

TencentDB for MySQL supported the backup encryption feature to enhance data security. By leveraging Key Management Service (KMS) to encrypt backup files, security incidents caused by accidental leakage of backups were prevented.

2022-10-31

Backup Encryption

Support for single-node instances

TencentDB for MySQL supported single-node Cluster Edition instances, providing ultra-high cost-effectiveness to meet scenarios such as testing, development, and personal learning. A maximum of 30 TB of storage capacity was supported.

2022-10-08

Single-Node Instances (Formerly Basic Edition and Cloud Disk Edition) September 2022 Update

Description

Release Date

Documentation

Support for parameter modification for read-only instances

TencentDB for MySQL supported modifying parameters for read-only instances to meet parameter configuration requirements of various business scenarios.

2022-09-19

Configuring Instance Parameters

Support for cross-region backup

TencentDB for MySQL supported cross-region backup to achieve high availability for database recovery. This met feature requirements such as data availability and security, remote backup and recovery, cross-region disaster recovery, long-term data archiving, and regulation.

2022-09-09

Cross-Region Backup July 2022 Update

Description

Release Date

Documentation

Support for password complexity

TencentDB for MySQL supported the password complexity feature, helping enhance the strength of database access passwords and ensure database security.

2022-07-20

Setting the Password Complexity June 2022 Update

Description

Release Date

Documentation

Infrequent access storage supported by TencentDB for MySQL

Tencent Cloud provided infrequent access storage for TencentDB for MySQL. Users could select appropriate billing based on the actual storage frequency of their database audit, helping reduce the cost of using audit.

2022-06-30

Database Audit Billing Description

Support for SSL encryption

TencentDB for MySQL supported Secure Sockets Layer (SSL) encryption to establish a secure encrypted transmission channel. This enhances the security and integrity of communication data.

2022-06-27

SSL Encryption Settings April 2022 Update

Description

Release Date

Documentation

Support for intelligent parameter tuning

TencentDB for MySQL supported the intelligent parameter tuning feature, helping users improve database performance.

2022-04-25

Intelligent Parameter Tuning

Support for the TXRocks engine

TencentDB for MySQL supported the TXRocks transactional storage engine, which offers performance comparable to InnoDB while saving more storage space. The TXRocks engine is suitable for businesses that require high transactional read/write performance and large data storage capacity.

2022-04-18

TXRocks Overview

Support for scheduled backups

Scheduled backups supported backup planning with two scheduling cycles, which were more cost-effective compared to single-cycle backup policies.

2022-04-02

Backing Up Databases February 2022 Update

Description

Release Date

Documentation

Connection pools supported by the database proxy

The TencentDB for MySQL database proxy supported the connection pool feature. The supported session-level connection pool could effectively resolve the issue of excessive load on database instances caused by the frequent establishment of new connections for non-persistent connection businesses.

2022-02

Connection Pool Overview

Optimization and update of the database proxy feature

The TencentDB for MySQL database proxy feature was optimized and updated. It supported upgrading kernel minor versions of the database proxy, the network switching feature, and self-service configuration adjustments, delivering enhanced performance and more convenient operations.

2022-02

Upgrading the Kernel Minor Version of the Database Proxy Switching the Database Proxy Network Adjusting the Database Proxy Configuration December 2021 Update

Description

Release Date

Documentation

Optimization of RO group latency settings

The RO latency configuration of TencentDB for MySQL was changed from instance-level to RO group-level. This resolved conflicts between latency settings and removal policies in RO groups and simplified the latency management of RO instances. When an RO group is accessed through the unified IP address, data access inconsistencies caused by delayed RO instances are eliminated, ensuring data consistency with expectations.

2021-12

Managing Delayed Replication of Read-Only Instances

Support for migrating instances to other AZs

TencentDB for MySQL launched the feature of migrating instances to other AZs. This feature implemented nearby access for businesses and resource scale-out, achieving more efficient utilization of resources across different AZs in the same region.

2021-12

Migrating Instances to Other AZs

Parameter template and newly purchased instance optimization

TencentDB for MySQL optimized parameter-related capabilities and the instance provisioning process. This optimization included upgrades in capabilities such as parameter template creation, parameter comparison, parameter template application, parameter modification, addition of modifiable parameters, and instance purchase optimizations.

2021-12

Parameter Template and Newly Purchased Instance Optimization August 2021 Update

Description

Release Date

Documentation

Display of project group information in TencentDB for MySQL audit bills

Project group information corresponding to database instances was displayed in the exported bills. This facilitated classified statistics on bills by project group.

2021-08

Bills

Display of instance names in TencentDB for MySQL audit bills

The Instance ID column in the instance list was changed to the Instance ID/Name column, with instance names displayed to facilitate quick instance location.

2021-08

-

Seven-day retention period supported for TencentDB for MySQL audit logs

When you enabled the audit feature, you could set the log retention period to 7 days. This met requirements in scenarios requiring short-term observation of the operational status and issue analysis for database troubleshooting. You could also change the log retention period of instances for which the audit feature had been enabled to 7 days.

2021-08

Modifying the Retention Period of Audit Logs

TencentDB for MySQL audit search optimization

Fuzzy search was supported. Multiple SQL types were allowed to be set as filter conditions at the same time. The 24-hour limit was removed from search time ranges.

2021-08

Viewing Audit Logs July 2021 Update

Description

Release Date

Documentation

Support for instant specification changes

TencentDB for MySQL supported instant specification changes. When local resources were sufficient, the adjustment of database configurations would trigger instant specification changes. Instant specification changes did not involve data migration. Therefore, the preparation time was reduced, enabling faster instance specification adjustments.

2021-07

Adjusting Database Instance Specifications April 2021 Update

Description

Release Date

Documentation

Support for the database proxy

A database proxy was a network proxy service resided between cloud database services and application services. It was used to proxy all requests when an application service accessed a database. The access address of the database proxy was independent of the original database access address. All requests through the database proxy address were forwarded through the proxy cluster to access the primary and secondary nodes of the database, perform read-write separation, forward read requests to read-only instances, and reduce the load on the primary database.

2021-04

Database Proxy

Description of the inclusion of binlog usage space in the total disk usage space

The write speed of binlog affected database runtime performance. Therefore, TencentDB for MySQL would upgrade the binlog storage to improve the performance and stability of TencentDB for MySQL. This upgrade would migrate the storage medium of the instance binlog to high-performance SSD disks (the storage space of user instances).

2021-04

Description of the Inclusion of Binlog Usage Space in the Total Disk Usage Space

Support for setting the local binlog retention period

TencentDB for MySQL supported setting the local binlog retention period in the console.

2021-04

Setting the Local Binlog Retention Period March 2021 Update

Description

Release Date

Documentation

Product architecture (name) upgrade

The product architecture of TencentDB for MySQL was upgraded to support single-node (formerly Basic Edition), dual-node (formerly High Availability Edition), and three-node (formerly Financial Edition) architectures. The basic, general, and exclusive isolation policies were added. Features of each architecture remained unchanged.

2021-03

Architecture Overview Isolation Policies

Independent private network addresses supported by read-only instances

Read-only instances supported enabling independent private network addresses and allowed custom modifications of private IP addresses and port numbers.

2021-03

Creating a Read-Only Instance December 2020 Update

Description

Release Date

Documentation

Support for delayed replication for read-only instances

TencentDB for MySQL supported setting delayed replication for read-only instances and starting or stopping replication. By setting delayed replication (the latency between read-only instances and the primary instance) and choosing to initiate restoration to a specific time point or global transaction identifier (GTID) during the latency period, efficient data rollback and quick fault backtracking could be achieved.

2020-12

Managing Delayed Replication of Read-Only Instances November 2020 Update

Description

Release Date

Documentation

Support for instance cloning

TencentDB for MySQL supported restoring an instance to any time point within the log backup retention period through cloning. It also supported restoration to the backup set of a specified physical backup.

2020-11

Cloning an Instance October 2020 Update

Description

Release Date

Documentation

Purchase page optimization

The purchase page of TencentDB for MySQL supported specifying alarm policies, setting parameter templates, and binding security groups across projects.

2020-10

Creating a MySQL Instance

TDE supported by TencentDB for MySQL 8.0

TencentDB for MySQL 8.0 supported the Transparent Data Encryption (TDE) feature.

2020-10

Enabling TDE August 2020 Update

Description

Release Date

Documentation

Support for TencentDB for MySQL 8.0

TencentDB for MySQL 8.0 was supported. This version provided faster and more stable enterprise-level services based on comprehensive management services and the TXSQL kernel. It enriched industry scenarios and facilitated industrial upgrades for customers.

2020-08

Database Versions July 2020 Update

Description

Release Date

Documentation

Support for applying parameter templates to instances

TencentDB for MySQL supported modifying parameters of multiple instances at a time by using a parameter template. Parameter modification tasks could be scheduled to run within a custom time period, and these tasks could be canceled.

2020-07

Configuring Instance Parameters Applying Parameter Templates

Support for TDE

TencentDB for MySQL provided the TDE feature. Transparent encryption indicated that the data encryption and decryption operations are invisible to users. It supported real-time I/O encryption and decryption of data files, encrypting data before being written to disks and decrypting data when being read into the memory. This feature met compliance requirements for static data encryption.

2020-07

Enabling TDE

Support for the TencentDB for MySQL database audit feature

TencentDB for MySQL provided database audit capabilities to record database accesses and SQL statement execution. This helped enterprises control risks and improved the data security level.

2020-07

Enabling the Database Audit Feature June 2020 Update

Description

Release Date

Documentation

Support for manual upgrade of kernel minor versions

TencentDB for MySQL supported manual upgrade of kernel minor versions, enabling use of new features, performance improvements, bug fixes, and other functionalities.

2020-06

Upgrading the Kernel Minor Version April 2020 Update

Description

Release Date

Documentation

Renaming High Availability Edition (one primary node and two secondary nodes) Financial Edition

Financial Edition adopted a three-node architecture with one primary node and two secondary nodes. It supported strong synchronous replication. Through real-time hot standby, it ensured strong data consistency while providing finance-grade reliability and high availability.

2020-04

Database Architecture

Support for customizing the reclamation time for old IP addresses

When you switched networks, you could customize the reclamation time for old IP addresses within the range of 0 to 168 hours. If the reclamation time was set to 0 hours, old IP addresses would be reclaimed immediately after the network switch.

2020-04

Network Switch January 2020 Update

Description

Release Date

Documentation

Support for DBbrain

DBbrain was a product for intelligent database diagnosis and optimization. It also assisted users in proactive prevention, provided real-time database protection, efficiently identified the causes of failures, and offered corresponding solutions.

2020-01

TencentDB for DBbrain

Support for slow log details and error log details

TencentDB for MySQL instances (excluding Basic Edition) provided the operation log management feature. On the Operation Logs page in the console, you could view slow log details, error log details, and rollback logs of an instance, and download slow logs.

2020-01

Operation Logs December 2019 Update

Description

Release Date

Documentation

Commercial charging for TencentDB for MySQL backup

TencentDB for MySQL instance backup space exceeding the free tier would be charged. After backup commercialization, data compression, backup stability, and backup availability were significantly improved, ensuring higher reliability for backups. Users could reduce backup costs by using methods such as shortening the backup retention period and reducing the backup frequency.

2019-12

Backup Space Billing November 2019 Update

Description

Release Date

Documentation

Support for event alarms

By subscribing to events such as out of memory (OOM), primary/secondary switching, removal of read-only instances, and instance migration due to server failures, you could be informed about the operation status of your instance in real time.

2019-11

Alarm September 2019 Update

Description

Release Date

Documentation

Launch of the Database Backup page

The database backup page for TencentDB for MySQL has been officially launched. It consists of two main sections: Overview and Backup List. On the Overview page, you can conveniently view the details and usage trends of backup space. On the Backup List page, you can clearly see the data backup list and log backup list.

2019-09

Viewing Backup Space May 2019 Update

Description

Release Date

Documentation

Comprehensive upgrade of the backup type from automatic backup to physical backup

TencentDB for MySQL only supported physical backup for automatic backup. Existing instances with logical automatic backup would be automatically switched to physical backup over time. If logical backup was required, you could generate logical backup by using the manual backup feature in the TencentDB for MySQL console or by using API calls.

2019-05

Backup Methods

Support for Nanjing Zone 1

With the launch of Nanjing Zone 1, TencentDB for MySQL covered two major regions in East China: Shanghai and Nanjing.

2019-05

Regions and AZs March 2019 Update

Description

Release Date

Documentation

Support for switching between VPCs

Switching from VPC A to VPC B was supported. That is, a single cloud database could be switched from VPC A to VPC B.

2019-03

Network Switch February 2019 Update

Description

Release Date

Documentation

One-click connection check

The console provided a one-click connection check tool to assist users in quickly locating public and private network connection issues and provide corresponding solutions.

2019-02

One-Click Connection Check Tool June 2018 Update

Description

Release Date

Documentation

Support for the database audit feature

The database audit feature could record TencentDB operations in real time, perform fine-grained auditing on database operations, report alarms on risky behaviors encountered by databases, and record and report alarms on risky database behaviors such as SQL injection and abnormal operations.

2018-06

Database Audit

Support for purchasing Basic Edition instances

Basic Edition adopted a single-node deployment mode that separated compute from storage. If a compute node failed, the node could be replace to achieve rapid recovery. The underlying storage medium for MySQL Basic Edition was Premium Cloud Disk, which was suitable for 90% of I/O scenarios. It offered cost-effectiveness and outstanding performance stability.

2018-06

Database Architecture

Support for network switching

Switching from the basic network to a VPC and switching between subnets within a VPC were supported.

2018-06

Network Switch

Support for self-service connection detection

Self-service connection detection was supported to check whether the database connection was normal.

2018-06

One-Click Connection Check Tool

Support for downgrade and refund

Database configurations could be downgraded, and the remaining fees could be returned.

2018-06

Instance Adjustment Fee

Support for MySQL 5.7 data migration

DTS data migration supported MySQL 5.7.

2018-06

Online Import of MySQL Data

Product renaming

The product name was renamed from CDB for MySQL to TencentDB for MySQL.

2018-06

TencentDB for MySQL August 2017 Update

Description

Release Date

Documentation

Elastic specifications supported by read-only instances

The specifications of read-only instances no longer needed to be the same as those of the primary instance.

2017-08

Read-Only Instances

Support for 1-minute monitoring

The 1-minute database monitoring was supported.

2017-08

Monitoring

Support for physical backup

Data could be stored by using the physical backup.

2017-08

Backup Methods

Support for manual backup

The backup time and storage duration could be customized. The backup retention period could be up to 732 days.

2017-08

Backup Methods

Support for security groups

A security group was a stateful virtual firewall with filtering capabilities. It was used to set network access control for single or multiple cloud databases. It was an important network security isolation mechanism provided by Tencent Cloud.

2017-08

Cloud Database Security Group

Support for data subscription

DTS helped users obtain real-time incremental data updates of cloud databases, enabling users to consume incremental data based on their business requirements.

2017-08

Data Subscription

Support for data migration between cloud databases

DTS data migration was compatible with various network environments.

2017-08

Online Import of MySQL Data

DMC release

DMC supported real-time monitoring and instance session management.

2017-08

DMC June 2017 Update

Description

Release Date

Documentation

Support for MySQL 5.7

Based on the MySQL 5.6 kernel, TencentDB for MySQL now also offers MySQL 5.7 (Percona branch). This new version retains core capabilities such as horizontal scaling and read-write separation while fully supporting MySQL 5.7 features.

2017-06

Database Version March 2016 Update

Description

Release Date

Documentation

Launch of read-only instances

TencentDB for MySQL allowed users to create one or multiple read-only instances to support read-write separation and scenarios with one primary node and multiple secondary nodes. This significantly improved read workload capabilities of user databases.

2016-03

Read-Only Instances

Support for pay-as-you-go instances

Database services were charged on an hourly basis.

2016-03

Billing Overview Next Topic: Product Announcements Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page September 2026 August 2026 July 2026 June 2026 May 2026 April 2026 March 2026 February 2026 December 2025 November 2025 October 2025 September 2025 August 2025 July 2025 June 2025 May 2025 April 2025 March 2025 February 2025 January 2025 December 2024 November 2024 August 2024 July 2024 June 2024 May 2024 April 2024 March 2024 February 2024 November 2023 October 2023 September 2023 August 2023 July 2023 May 2023 March 2023 February 2023 December 2022 November 2022 October 2022 September 2022 July 2022 June 2022 April 2022 February 2022 December 2021 August 2021 July 2021 April 2021 March 2021 December 2020 November 2020 October 2020 August 2020 July 2020 June 2020 April 2020 January 2020 December 2019 November 2019 September 2019 May 2019 March 2019 February 2019 June 2018 August 2017 June 2017 March 2016 Search AllCurrent Product Search titles only Enter keywords to search documentation
