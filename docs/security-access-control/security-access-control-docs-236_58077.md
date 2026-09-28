# Selection Guide

> 来源: https://www.tencentcloud.com/document/product/236/58077

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Selection Guide Selection Guide Download Focus Mode Font Size Last updated: 2026-06-10 10:59:26 AI-Translated Before purchasing a TencentDB for MySQL instance, you need to understand the characteristics of different instances to select the appropriate one based on your business requirements.
Instance Selection Guide Before purchasing a TencentDB for MySQL instance, you need to consider factors such as price, performance, workload, and business use cases to ensure you can purchase a suitable instance with the best cost-effectiveness. The database storage engine, instance architecture, storage type, and isolation policy are closely related and mutually influential, which may cause confusion when you select. Therefore, this document briefly introduces these aspects to help you select the appropriate instance.
I. Database Storage Engines A storage engine refers to the type of a table. The database storage engine determines how tables are stored on a computer.
InnoDB: The most commonly used OLTP storage engine. It employs Multi-Version Concurrency Control (MVCC) and row-level locking technologies to deliver high-performance and reliable transaction processing capabilities. Compared to other MySQL storage engines, InnoDB offers superior data integrity, including features such as foreign keys and rollback, and provides more advanced query functionality. Tencent Cloud has also implemented numerous kernel optimizations for InnoDB, giving it a more significant performance advantage. Consequently, it is widely used in high-performance, high-concurrency use cases.
RocksDB: A highly popular high-performance persistent KV (key-value) store. TXRocks is a transactional storage engine developed by Tencent's TXSQL team based on this engine. By leveraging the LSM Tree storage structure of RocksDB, TXRocks minimizes wastage caused by partially filled InnoDB pages and fragmentation, while also supporting a compact data format. Consequently, TXRocks can achieve storage efficiency, using only half or even less space compared to InnoDB, without compromising on performance. It is particularly well-suited for applications that demand high transaction read/write performance and manage large volumes of data.
LibraDB: A self-developed OLAP storage engine. With capabilities such as columnar storage, large-scale concurrency execution, and the vectorized execution engine, LibraDB accelerates various complex and time-consuming SQL queries such as complex queries, slow SQL queries, and fuzzy matching in the business, effectively improving the overall SQL execution efficiency. LibraDB is suitable for use cases such as real-time reporting, online analysis, and HTAP. Currently, only read-only instances support the LibraDB engine.
II. Instance Architecture TencentDB for MySQL supports four instance architectures: single-node, two-node, three-node, and Cluster Edition.
﻿ Architecture

Description

Scenarios

Single-Node

Supported versions: MySQL 5.7 and 8.0 Node: a single node.

Personal learning, micro-websites, non-core small systems for enterprises, and development and testing environments for medium and large enterprises.

Two-Node

Supported versions: MySQL 5.6, 5.7, and 8.0.
Node: one primary node and one secondary node.
Primary-secondary replication mode: asynchronous and semi-synchronous (default)

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications.

Three-Node

Supported versions: MySQL 5.6, 5.7, and 8.0.
Node: one primary node and two secondary nodes.
Primary-secondary replication modes: asynchronous, strongly synchronous, or semi-synchronous (default).

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications.

Cluster Edition

Supported versions: MySQL 5.7 and 8.0 Node: one read-write node and up to 5 read-only nodes Primary-secondary replication mode: asynchronous and semi-synchronous (default)

Gaming, Internet, IoT, retail e-commerce, logistics, insurance, and security industry applications.
III. Storage Types TencentDB for MySQL supports local SSD disks, Cloud SSD, Premium Disk, Enhanced SSD, and Extreme SSD for its underlying storage.
Performance Metric

Tremendoust SSD Cloud Disk

Enhanced SSD Cloud Disk

Premium Disk

SSD

Local SSD

Maximum capacity of a single disk (GB)

32000

32000

32000

32000

12000GB

Maximum IOPS of a single disk

Up to 1,000,000 after adding additional performance

Up to 100,000 after additional performance is added

6000

26000

150000

Calculation formula for random IOPS performance.

Benchmark performance : Random IOPS = min{4000 + Capacity (GiB) x 100, 50000} Additional performance : Maximum IOPS = min{Additional performance value x 128, 950000}

Benchmark performance: Random IOPS = min{1800 + Capacity (GiB) x 50, 50000} Additional performance: Maximum IOPS = min{Additional performance value x 128, 50000}. For details, see Enhanced Cloud SSD Performance Specifications.

Random IOPS = min{1800 + Capacity (GiB) x 8, 6000}

Random IOPS = min{1800 + Capacity (GiB) x 30, 26000}

IOPS is related to the specification. For details, see Instance Specifications.

Maximum throughput of a single disk (MB/s)

Up to 4,000 MB/s after adding additional performance

Up to 1,000 MB/s after additional performance is added

150MB/s

260MB/s

-

Throughput performance calculation formula (MB/s)

Benchmark performance: Throughput = min{120 + Capacity (GiB) x 0.5, 350} Additional performance: Throughput = min{Additional performance value x 1, 3650}

Benchmark performance: Throughput = min{120 + Capacity (GiB) x 0.5, 350} Additional performance: Throughput = min{Additional performance value x 1, 650}. For details, see Enhanced Cloud SSD Performance Specifications.

Throughput = min{100 + Capacity (GiB) x 0.15, 150}

Throughput = min{120 + Capacity (GiB) x 0.2, 260}

-

Single-path random read/write latency (ms)

0.1ms - 0.5ms

0.2ms - 1ms

0.8ms - 5ms

0.5ms - 3ms

Microsecond-level IV. Isolation Policy The isolation policies of TencentDB for MySQL include basic, economical, general, exclusive, standard, enhanced, and flagship types.
Isolation Policy

Description

Basic

Only single-node supports the basic isolation policy (formerly Basic Edition), with storage-computing separation and cloud disk storage at the underlying layer.

Economical

Exclusive memory and disk allocation for instances. CPU resources are shared among general specification instances located on the same physical server.* Fixed instance specifications and disk capacity.
Suitable for lightweight and low-load use cases such as small websites, Web applications, blogs, forums, and cloud development/test/learning environments, offering excellent cost performance.

General

Exclusive memory and disk allocation for instances. CPU resources are shared among general specification instances located on the same physical server.* It offers excellent cost performance by leveraging economies of scale through resource sharing, with CPU resources being lightly shared.

Exclusive

The instance has exclusive access to CPU (with core binding), memory, and disk resources, ensuring long-term stable performance that is not affected by the behavior of other instances on the same physical machine.
The highest tier of the dedicated specification is a dedicated physical server, which exclusively utilizes all resources of a single physical machine.

Standard

Exclusive CPU and memory allocation for instances, with long-term stable performance.
Storage-computing separation architecture with flexible configurations.

Enhanced

Exclusive CPU and memory allocation for instances, with long-term stable performance.
Storage-computing separation architecture with flexible configurations.
Tremendous SSD is supported, providing stable and reliable performance.

Flagship

CPU core with a higher frequency, offering outstanding performance.
Exclusive CPU and memory allocation for instances, with long-term stable performance.
Storage-computing separation architecture with flexible configurations.
Tremendous SSD is supported, providing stable and reliable performance.
*In extreme cases, resource contention may occur (extremely low probability) for the general isolation policies.
Getting Started with Selection You can refer to the following steps for instance selection:
1.
Select a Database Storage Engine.
If you need full transaction support and strong read-write concurrency, InnoDB is recommended. To reduce storage costs, RocksDB is recommended, which can save up to half or more of the storage space compared to InnoDB while offering similar performance. For use cases such as real-time reporting, online analysis, and HTAP, it is recommended to add the LibraDB read-only analysis engine after you create two-node or three-node architecture instances, effectively improving the overall SQL execution efficiency.
2.
Select an Instance Architecture.
Typically, you can choose the two-node architecture, which adopts the classic high-availability setup of one primary and one standby node. This architecture is suitable for industries such as the internet, IoT, retail e-commerce, logistics, and gaming, as well as for medium and large enterprises.
If you require financial-grade reliability, high security, high availability, and high disaster recovery capabilities, and your business is similar to those in the finance, securities, or insurance industries, or involves core databases of large enterprises, the three-node architecture is recommended.
If your business is complex, involves frequent changes, handles large data volumes, requires high read performance, and needs frequent scaling or addition/deletion of read-only instances, while also requiring high reliability, security, availability, and disaster recovery capabilities, Cluster Edition is recommended.
If you use it for personal learning, micro-websites, non-core small systems for enterprises, or development and testing environments for medium and large enterprises, the single-node architecture is recommended.
3.
Select a Storage Type.
In terms of storage types, the instances with two-node or three-node architecture currently support local SSD; the single-node architecture instances support Cloud SSD, Premium Disk, and Enhanced SSD; the Cluster Edition architecture instances support Tremendous SSD, Enhanced SSD, Premium Disk, and Cloud SSD.
The single-node cloud disk architecture instance is implemented based on a cloud-native architecture. It is suitable for scenarios such as testing, development, and personal learning, supports up to 30 TB of storage space, and the storage capacity size affects IOPS.
For a comparison of performance metrics across different storage types, see Storage Types.
4.
Select an Isolation Policy and Instance Specifications The single-node architecture supports the basic isolation policy. The two-node architecture supports the economical, general, and dedicated isolation policies. The three-node architecture supports the general and dedicated isolation policies. The cloud disk edition architecture supports the standard, enhanced, and flagship isolation policies. Instance specifications include parameters such as vCPU, memory, maximum IOPS, and maximum storage capacity. You can select the appropriate ones based on your business needs.
Note:
To learn about all purchase selection options and descriptions, you can refer to Purchase Methods.
References Architecture Overview Isolation policy Database Instance Types Database Instance Replication Database Instance Specifications Previous Topic: Billing Overview Next Topic: Purchase Methods Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance Selection Guide I. Database Storage Engines II. Instance Architecture III. Storage Types IV. Isolation Policy Getting Started with Selection References Search AllCurrent Product Search titles only Enter keywords to search documentation
