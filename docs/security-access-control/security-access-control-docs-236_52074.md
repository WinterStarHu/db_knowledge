# Feature List

> 来源: https://www.tencentcloud.com/document/product/236/52074

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Feature List Feature List Download Focus Mode Font Size Last updated: 2026-07-09 16:37:22 AI-Translated Product Feature List This document introduces the functional differences supported by various architecture types of TencentDB for MySQL, along with the latest pre-release features. This helps you better understand the characteristics of each architecture, experience the newest features faster, and select instances based on your specific needs.
Note:
The "-" symbol in the table below indicates not supported.
You can click the corresponding table title to switch between the feature differences list and the pre-release features list.
Feature attribute

Feature Name

Cluster Edition

Four-Node

Three-Node

Two-Node

Single-Node

Lifecycle

Isolation policy

Standard Enhanced Flagship

General Exclusive

General Exclusive

Economical

General Exclusive

General (read-only instances)

basic (cloud disk edition)

Supported Version

MySQL 5.7 MySQL 8.0 MySQL 8.4

MySQL 5.6 MySQL 5.7 MySQL 8.0 MySQL 8.4

MySQL 5.6 MySQL 5.7 MySQL 8.0 MySQL 8.4

MySQL 5.7 MySQL 8.0

MySQL 5.5 MySQL 5.6 MySQL 5.7 MySQL 8.0 MySQL 8.4

MySQL 5.6 MySQL 5.7 MySQL 8.0 MySQL 8.4

MySQL 5.7,8.0 MySQL 8.4

Number of Nodes

1 read-write node 1 - 5 read-only nodes 1 - 15 independent read-only instances

4

3

2

2

1

1

Memory/Disk

standard: up to 216GB/30TB enhanced: up to 1536GB/30TB

Up to 720GB/12TB

Up to 720GB/12TB

Up to 16GB/200GB

Up to 720GB/12TB

Up to 720GB/12TB

Up to 16GB/30TB

Creating an Instance

Supported

Supported

Supported

Supported

Supported

Supported

Supported

CreateReadOnlyDBInstances

Supported (adding read-only nodes or creating new standalone read-only instances)

Supported

Supported

Supported

Supported (MySQL 5.6, 5.7, 8.0 only)

Supported

-

Create DR Instance.

Supported

Supported

Supported

-

Supported (MySQL 5.6, 5.7, 8.0 only)

-

-

Terminating an Instance

Supported

Supported

Supported

Supported

Supported

Supported

Supported

switching from pay-as-you-go to yearly/monthly subscription

Supported

Supported

Supported

-

Supported

Supported

Supported

auto-renewal

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Instance management

Set the instance maintenance window.

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Assigning a Project to the Instance

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Configuration Adjustment

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Migrating instances to other AZs

Supported

Supported

Supported

-

Supported

-

-

Modify the port number.

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Primary-secondary switch

Supported

Supported

Supported

Supported

Supported

-

-

Modify data replication modes.

Supported

Supported

Supported

Supported

Supported

-

-

Version upgrade

Upgrade the database engine version.

-

Supported

Supported

Supported

Supported (only MySQL 5.5 and 5.6).

Supported

-

Upgrading the Kernel Minor Version

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Architecture upgrade

Adjusting the Number of Nodes.

Supports (can quickly add or remove 1 - 5 nodes, making it more flexible)

Supported

Supported

-

Supported

-

-

Upgrade to Cloud Disk Edition from Dual-Node

-

-

-

-

Supported

-

-

Upgrade to Cloud Disk Edition from Tri-Node

-

-

Supported

-

-

-

-

Supporting engine

InnoDB

Supported

Supported

Supported

Supported

Supported

Supported

Supported

RocksDB

Supported

-

Supported

Supported

Supported

-

-

LibraDB

-

-

Supported

Supported

Supported

-

-

Backup and Restore

Automatic Backup

Supported

Supported

Supported

Supported

Supported

-

Supported

Manual Backup

Supported

Supported

Supported

Supported

Supported

-

Supported

Cross-Region Backup

Supported

Supported

Supported

Supported

Supported

-

-

Downloading Backup Files

-

Supported

Supported

Supported

Supported

-

-

Deleting backups

Support (manual snapshot backups can be deleted)

Supported

Supported

Supported

Supported

-

-

Cloning an Instance

Supported

Supported

Supported

Supported

Supported

-

Supported

Performing a Rollback.

Supported

Supported

Supported

Supported

Supported

-

-

Regular Backup Retention

-

Supported

Supported

Supported

Supported

-

-

Backup Encryption

-

Supported

Supported

Supported

Supported

-

-

Backup Archiving to Cold Storage

-

Supported

Supported

Supported

Supported

-

-

Monitoring and alarm

Resource Monitor

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Engine monitoring

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Deploy monitoring.

Supported

Supported

Supported

Supported

Supported

-

-

Alarms

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Account management

Creating an Account

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Setting Password Complexity

Supported

Supported

Supported

Supported

Supported

-

-

Resetting Password

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Modifying Account Permissions

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Modify authorized access host addresses.

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Delete account.

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Database management

DMC Console

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Data security

Security Group

Supported

Supported

Supported

Supported

Supported

Supported

Supported

SQL Insight (formerly Database Audit)

-

Supported

Supported

-

Supported (MySQL 5.6 and 5.7 only)

-

-

Enable Transparent Data Encryption.

-

-

Supported (MySQL 5.7, 8.0 only)

-

Supported (MySQL 5.7, 8.0 only)

-

-

Configure SSL Encryption

-

-

Supported (MySQL 5.6, 5.7, 8.0 only)

Supported

Supported (MySQL 5.6, 5.7, 8.0 only)

-

-

Data channel

Use DTS service to migrate

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Offline migration

-

Supported

Supported

Supported

Supported

-

-

Importing SQL Files

Supported

Supported

Supported

Supported

Supported

-

-

Parameter management

Configuring Instance Parameters

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Intelligent Parameter Tuning

-

-

Supported

Supported

Supported

-

-

Network

Switch Network.

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Enable public network connection address.

Supported

Supported

Supported

Supported

Supported

-

Supported

Performance

Database Proxy

Supported

Supported

Supported

-

Supported

-

-

Network Forwarding

Supported

Supported

Supported

Supported

Supported

-

-

Parallel Query

Supported

-

Supports (MySQL 8.0 kernel version 20220831 and above)

Supports (MySQL 8.0 kernel version 20220831 and above)

Supports (MySQL 8.0 kernel version 20220831 and above)

Supports (MySQL 8.0 kernel version 20220831 and above)

Supports (MySQL 8.0 kernel version 20220831 and above)

CPU Elastic Scale-Out

-

General Supported

General Supported

-

General Supported

Supported

-

Operation logs

Slow logs

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Slow log download

-

Supported

Supported

Supported

Supported

Supported

-

Error logs

Supported

Supported

Supported

Supported

Supported

Supported

Supported

Rollback logs

Supported

Supported

Supported

Supported

Supported

-

-

Log Shipping

Supported

Supported

Supported

Supported

Supported

Supported

- Previous Topic: Economical Instance Next Topic: Database Versions Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Product Feature List Search AllCurrent Product Search titles only Enter keywords to search documentation
