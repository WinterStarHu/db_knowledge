# Strengths

> 来源: https://www.tencentcloud.com/document/product/236/5148

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Strengths Strengths Download Focus Mode Font Size Last updated: 2026-04-21 10:35:18 AI-Translated Strengths of TencentDB for MySQL TencentDB for MySQL provides users with services of setting, operating, and scaling databases on the cloud more easily, with strengths in flexibility, ease of use, high availability, and high data security and reliability. The product strengths are introduced below based on different instance architectures.
Single-Node Instances Strength

Description

Ultra-high cost performance

The deployment cost is very low. It can be as low as 3.67647059 USD/month.

Large-specification disk

Up to 30 TB of storage space is supported, with no specification limit.

High security

Anti-DDoS defends user data against various DDoS attack traffic, ensuring normal business operation.
Database attack protection efficiently defends against SQL injection, brute force cracking, and other attack behaviors.

High reliability

A three-replica distributed storage mechanism is adopted. The system only returns a response confirming successful writing after ensuring the data has been written to all three replicas. The backend data replication mechanism can quickly create a replica through data migration when any one of the replicas fails, ensuring that three replicas are available at all times to improve data reliability.
Two-Node and Three-Node Instances Strength

Description

Low cost and ease of use

Flexible billing methods. Two billing modes, namely yearly/monthly subscription and pay-as-you-go, are provided to avoid investing heavily in building basic equipment at one time.
Read-write separation is supported. TencentDB for MySQL supports mounting read-only instances. It supports a one-primary-multiple-secondary architecture to easily handle business load from massive requests. It also supports read-only (RO) groups with the load balancing feature for drastic optimization in scenarios where load distribution between read-only instances is uneven.
Powerful hardware ensures performance. The powerful I/O performance of NVMe SSDs ensures the database's read-write access capability. A single instance supports up to 240,000 QPS and 12 TB of storage space.

High security

Anti-DDoS defends user data against various DDoS attack traffic, ensuring normal business operation.
Database attack protection efficiently defends against SQL injection, brute force cracking, and other attack behaviors.
Data encryption provides the transparent data encryption (TDE) feature to ensure the security of stored and backup data.
Backup encryption, together with KMS, encrypts backup files to prevent security incidents caused by accidental leakage and enhance data security.
SQL Insight (Database Audit) provides the data auditing feature to meet the needs for core data theft prevention, traceable unauthorized operations, and traceable malicious pulls.

High reliability

The flashback query capability saves a large amount of data querying and recovery time, allowing quick data recovery from an operation error and ensuring quick business recovery.
Cross-region backup supports storing backups in centers in different regions to meet regulatory and cross-region recovery requirements.
Ultrafast rollback is based on data backups and log backups. The ultrafast rollback feature enables faster recovery of data corrupted due to personal reasons.

High availability

Real-time hot standby and real-time dual-server hot standby, based on data backups and log backups (binlog), support lossless recovery within 7 to 3650 days. Data backups and log backups can be retained for 7 to 3650 days.
Automatic disaster recovery provides automatic downtime detection and automatic failover. The primary-secondary switch and failover process are transparent to users.
The database proxy service handles all requests from application services for accessing the database, reducing the load on the primary database.
Cluster Edition Instances Strength

Description

Improved performance

Multiple kernel optimizations, such as atomic write, code segment optimization, and buffer pool warm-up, improve performance significantly.

Replica node read-only

The secondary database supports configuring read-only addresses without creating an inaccessible secondary server.

High elasticity

Specification adjustment and scale-out can be completed quickly based on business needs to achieve optimal costs for computing resources.

Complex business scenarios

Cluster Edition provides both read-write and read-only access addresses. The secondary databases in dual-node/triple-node instances only support high availability without external access. From performance and cost perspectives, Cluster Edition's architecture deployment model better suits complex business scenarios, such as systems with frequent business changes, large database volumes, high read performance requirements, and needs for frequent scaling or addition/deletion of read-only instances.

Flexibility and reliability

The product adopts a storage-computing separation and a one-primary-multiple-secondary architecture. It supports automatic failover, switching of any replica node (read-only node) to the primary node (read-write node), readable replica nodes, on-demand node addition and deletion, multi-availability zone disaster recovery, node-level monitoring, and cluster node topology management. It is more cost-effective, flexible, and reliable than self-built databases.

High security

Anti-DDoS defends user data against various DDoS attack traffic, ensuring normal business operation.
Database attack protection efficiently defends against SQL injection, brute force cracking, and other attack behaviors.
SQL Insight (Database Audit) provides the data auditing feature to meet the needs for core data theft prevention, traceable unauthorized operations, and traceable malicious pulls.

High reliability

The flashback query capability saves a large amount of data querying and recovery time, allowing quick data recovery from an operation error and ensuring quick business recovery.
Cross-region backup supports storing backups in centers in different regions to meet regulatory and cross-region recovery requirements.
Ultrafast rollback is based on data backups and log backups. The ultrafast rollback feature enables faster recovery of data corrupted due to personal reasons.

High availability

The product adopts the cloud-native high-availability deployment mode, with multiple readable replica database nodes. Based on data backups and log backups (binlog), it supports lossless recovery within 7 to 1830 days. Data backups can be retained for 7 to 1830 days, and log backups can be retained for 7 to 3650 days.
Automatic disaster recovery provides automatic downtime detection and automatic failover. The primary-secondary switch and failover process are transparent to users.
The database proxy service handles all requests from application services for accessing the database, reducing the load on the primary database.
Strengths of TencentDB for MySQL over Self-Built MySQL TencentDB for MySQL can be deployed, managed, and scaled more easily as it has been optimized to address common issues with traditional self-built MySQL, such as performance bottlenecks, maintenance difficulties, and data reliability and availability challenges.
Compared with self-built databases, TencentDB for MySQL offers two methods to manage cloud databases: command line and web. It supports batch operations for database management, permission setting, and SQL import, enabling easy management of massive databases. It provides multiple data import methods for initialization, automatically backs up data on a daily basis, and supports data recovery at any point in time within the backup retention period based on backup files. It provides multi-dimensional monitoring and custom resource threshold alarms, and supports downloading slow query analysis reports and complete SQL running reports. It supports public network access and VPC networks, allowing interconnection between cloud databases and IDC, private cloud, or other computing resources via these access methods and making it easy to be applied to hybrid cloud environments.
Below is a comparison between TencentDB for MySQL and self-built MySQL in terms of prices and peripheral system construction costs.
Price Comparison Comparison Item

TencentDB for MySQL

Self-Built Databases on CVM

Database on Self-Purchased Servers

Hardware cost and spare parts cost

Fee of a TencentDB for MySQL instance. For example, the fee of an instance with 4 CPUs, 8 GB of memory, and 100 GB of storage space (IOPS capacity reaches 8000) is 1,457 USD/year.

At least 2 Cloud Virtual Machine (CVM) instances are required as primary and secondary instances. The fee of 2 CVM instances with 4 CPUs, 8 GB of memory, and 100 GB of storage space (the IOPS capacity of a single instance is 4800) is: 661 USD/year x 2 = 1,322 USD/year.

At least 2 database servers are required. The fee of each server with 8000 IOPS capacity is around USD 1,094.
One of them is used to connect the private network switch of the front-end web server (an affordable 1U non-network management switch costs around USD 136).
Subsequent hardware damage and replacement will consume at least 30% of the fee.
Hardware expenditure: (1094 x 2 + 136) x 130% = USD 3,021. Annual fee: USD 3,021/3 = USD 1,007 (hardware depreciation over 3 years).

Server room management fee

No need to pay. The service provider is responsible for it.

No need to pay. The service provider is responsible for it.

The management fee for 1U cabinet space is 410 USD/year. With two 1U servers and one 1U private network switch billed, the server room management fee is: 410 x 3 = USD 1,230.

Bandwidth fee

No need to pay. The service provider is responsible for it.

If CVM and TencentDB for MySQL are in the same region, they can communicate with each other over the private network, with no fees charged.
If CVM and TencentDB for MySQL are in different regions, they can communicate with each other over the public network, with no external network traffic fees charged.

CVM instances in the same region can communicate with each other over the private network, with no fees charged.
CVM instances in different regions can communicate with each other over the public network, with external network traffic fees charged. For details, see Public Network Billing Mode.

Database Ops engineer fee

No personnel cost, as database maintenance is the responsibility of the service provider.

A junior database administrator (DBA) engineer earns at least 957 USD/month. Assuming the current project occupies 30% of the engineer's workload, the personnel cost is: 957 x 12 x 30% = USD 3,445.

A DBA engineer earns at least 957 USD/month. Assuming the current project occupies 30% of the engineer's workload, the personnel cost is: 957 x 12 x 30% = USD 3,445.

Total fee per year

1,457 USD/year.

4,764 USD/year.

5,682 USD/year.
Peripheral System Construction Cost Comparison System

TencentDB for MySQL

Self-Built Databases on CVM

Database on Self-Purchased Servers

Database monitoring system

Second-level monitoring data for more than 100 metrics is provided free of charge.

At least one CVM instance is required for monitoring, collection, storage, and display. The fee of a CVM instance with 4 CPUs, 8 GB of memory, and 300 GB of storage space (approximate storage capacity for one year of monitoring metrics) is 776 USD/year.

At least 1 database server is required. The server fee is around USD 1,094.
Subsequent hardware damage and replacement will consume at least 30% of the fee.
Hardware expenditure: (1094 x 1) x 130% = USD 1,422. Annual fee: USD 1,422/3 = USD 474 (hardware depreciation over 3 years).

Database Ops system

No need to pay. The service provider is responsible for it.

The fee of a professional MySQL Ops system is around 5,470 USD/year.

The fee of a professional MySQL Ops system is around 5,470 USD/year.

Database backup system

A capacity which is 100% of the purchased disk space is provided free of charge for backup. Usage beyond this free capacity will incur additional charges.

At least 1 CVM instance is required as backup system storage. The fee of a CVM instance with 4 CPUs, 8 GB of memory, and 200 GB of storage space (only able to retain 200 GB of backup) is 718 USD/year, and users need to build the capability to perform recovery based on backups on their own.

At least 1 database server is required. The server fee is around USD 1,094.
One server is used to connect the private network switch of the backup server (some 1U non-network management switches only cost around USD 136).
Subsequent hardware damage and replacement will consume at least 30% of the fee.
Hardware expenditure: (1094 x 1 + 136) x 130% = USD 1,599. Annual fee: USD 1,599/3 = USD 533 (hardware depreciation over 3 years).

Total fee per year

0 USD/year.

6,964 USD/year.

6,477 USD/year.
Comparison of Availability/Reliability/Ease of Use Comparison Item

TencentDB for MySQL

Self-Built Databases on CVM

Database on Self-Purchased Servers

Availability

The self-developed high-availability system based on two or three nodes enables recovery from a failure within 30 seconds.
Read-only instances automatically achieve load balancing.
Read-write separation is easy to use.
Analysis nodes will be launched in the future to meet requirements for analytical scenarios.

A high-availability system needs to be purchased separately.
The load balancing service needs to be implemented or purchased separately.
Analytical scenarios require combining with an analytical database, which is difficult and costly to set up.

For a single instance, delivery may take two hours to several weeks.
A high-availability system needs to be purchased separately.
The load balancing device needs to be implemented or purchased separately.
Analytical scenarios require combining with an analytical database, which is difficult and costly to set up.

Reliability.

Data reliability is high due to automated primary-secondary replication, data backup, and log backup.
Three-node MySQL 5.7 and three-node MySQL 8.0 achieve 0 Recovery Point Objective (RPO), with no data loss; Recovery Time Objective (RTO) is usually within 30 seconds.

High reliability is achieved only when the architecture is good.
Achieving 0 RPO is extremely costly and requires purchasing R&D services separately.

Data reliability is moderate, depending on the damage probability of a single disk.
Achieving 0 RPO is extremely costly and requires purchasing R&D services separately.

Ease of use

TencentDB for MySQL instances deployed on the local disk have excellent performance.
Performance is strong and loading is balanced after a read-only instance is added.
TencentDB for DBbrain (DBbrain) offers advanced optimization capability.
Performance analysis meets the requirements for most monitoring and database optimization scenarios.

After CVM instances are deployed on the local disk, data reliability decreases. Deploying them on the cloud disk requires planning a corresponding architecture and involves a high cost.
Self-built MySQL on SSD-based CVM has lower performance than TencentDB for MySQL on SSD.
Achieving Cluster Edition is difficult and involves a high consultation cost and extremely high maintenance costs.
Senior DBAs, high costs, and external assistance are required.

No automatic backup system is available. The streaming backup capability needs to be implemented separately, and achieving the point-in-time recovery feature is costly.
The monitoring system needs to be purchased or configured separately, the channel number is small, and the cost is high.
Setting up cross-region data centers is extremely costly and technically difficult, making it hard to achieve cross-region disaster recovery.
Version upgrade is costly.
Previous Topic: Overview Next Topic: Use Cases Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Strengths of TencentDB for MySQL Strengths of TencentDB for MySQL over Self-Built MySQL Price Comparison Peripheral System Construction Cost Comparison Comparison of Availability/Reliability/Ease of Use Search AllCurrent Product Search titles only Enter keywords to search documentation
