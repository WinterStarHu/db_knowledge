# Overview

> 来源: https://www.tencentcloud.com/document/product/236/38328

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Overview TencentDB for MySQL Cluster Edition Two-Node Instances (Formerly High-Availability Edition) Three-Node Instances (Formerly Finance Edition) Single-Node Instances (Formerly Basic Edition and Cloud Disk Edition) Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Database Architecture Overview Overview Download Focus Mode Font Size Last updated: 2025-11-20 10:15:32 AI-Translated TencentDB for MySQL supports four types of architectures: single-node (cloud disk edition), two-node (formerly high availability edition), and three-node (formerly finance edition),Cluster Edition (cloud disk edition).
Note:
The single-node (cloud disk edition) architecture is currently available in the regions of Shanghai, Beijing, Guangzhou, Chengdu, Hong Kong of China, Singapore, and Frankfurt. Other regions will be available gradually in the future.
The two-node (formerly high availability edition) employs a one-primary-one-replica mode. Only the primary database provides access services, and the replica database is dedicated for disaster recovery without providing access.
The three-node (formerly finance edition) employs a one-primary-two-replica mode. Only the primary database provides access services, and the two replica databases are dedicated for disaster recovery without providing access.
The Cluster Edition (cloud disk edition) employs a one-primary-multiple-replica mode. The primary node (read-write node) provides read-write services, and the replica nodes (read-only nodes) provide read-only access services.
Viewing the instance architecture For instances to be purchased, enter the TencentDB for MySQL purchase page, and select the architecture in the Architecture section.
For purchased instances, log in to the TencentDB for MySQL console, find the target instance from the instance list, and view its architecture in the Configuration Info section.
Architecture comparison Architecture

Single-Node

Two-Node

Three-Node

Cluster Edition

﻿Isolation policy﻿

Basic

Economical

General Exclusive

General Exclusive

Standard Enhanced Flagship

Supported version

MySQL 5.6 MySQL 5.7 MySQL 8.0

MySQL 5.7 MySQL 8.0

MySQL 5.6 MySQL 5.7 MySQL 8.0

MySQL 5.6 MySQL 5.7 MySQL 8.0

MySQL 5.7 MySQL 8.0

Node

A single node

One primary node and one secondary node

One primary node and one secondary node

One primary node and two secondary nodes

One primary node and multiple secondary nodes Up to 5 read-only nodes

Primary-secondary replication mode

-

Asynchronous Semi-synchronous (default)

Asynchronous Semi-synchronous (default)

Asynchronous Semi-synchronous (default) Strongly synchronous

Asynchronous Semi-synchronous (default)

Instance availability

-

99.95%

99.95%

99.99%

99.95%

Underlying storage

Enhanced SSD Premium Disk Cloud SSD

Local NVMe SSD

Local NVMe SSD

Local NVMe SSD

Tremendous SSD Enhanced SSD Premium Disk Cloud SSD

IOPS performance

Enhanced SSD Benchmark performance:
Random IOPS = min{1800 + Capacity (GiB) x 50, 50000} Cloud SSD Random IOPS = min{1800 + Capacity (GiB) x 30, 26000} Premium Disk Random IOPS = min{1800 + Capacity (GiB) x 8, 6000}

Up to 21000

Up to 240000

Up to 240000

Tremendous SSD Benchmark performance:
Random IOPS = min{4000 + Capacity (GiB) x 100, 50000} Enhanced SSD Benchmark performance:
Random IOPS = min{1800 + Capacity (GiB) x 50, 50000} Premium Disk Random IOPS = min{1800 + Capacity (GiB) x 8, 6000} Cloud SSD Random IOPS = min{1800 + Capacity (GiB) x 30, 26000}

Throughput performance (MB/s)

Enhanced SSD Benchmark performance:
Throughput = min{120 + Capacity (GiB) x 0.5, 350} Cloud SSD Throughput = min{120 + Capacity (GiB) x 0.2, 260} Premium Disk Throughput = min{100 + Capacity (GiB) x 0.15, 150}

-

-

-

Tremendous SSD Benchmark performance:
Throughput = min{120 + Capacity (GiB) x 0.5, 350} Enhanced SSD Benchmark performance:
Throughput = min{120 + Capacity (GiB) x 0.5, 350} Premium Disk Throughput = min{100 + Capacity (GiB) x 0.15, 150} Cloud SSD Throughput = min{120 + Capacity (GiB) x 0.2, 260}

Applicable scenario

Personal learning, micro-websites, enterprise non-core small systems, and large and medium-sized enterprise development and test environments

Small websites, Web applications, blogs, forums, and cloud development/test/learning environments

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications References TencentDB for MySQL supports MySQL 5.5, 5.6, 5.7, and 8.0. For more information, see Database Versions.
TencentDB for MySQL supports the following instance types: the source instance, the read-only instance, and the disaster recovery instance. For more information, see Database Instance Types.
TencentDB for MySQL supports different features in different architectures. For more information, see List of Feature Differences.
Previous Topic: Use Cases Next Topic: TencentDB for MySQL Cluster Edition Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Viewing the instance architecture Architecture comparison References Search AllCurrent Product Search titles only Enter keywords to search documentation
