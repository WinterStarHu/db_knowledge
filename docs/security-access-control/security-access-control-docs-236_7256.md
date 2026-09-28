# Use Cases

> 来源: https://www.tencentcloud.com/document/product/236/7256

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Use Cases Use Cases Download Focus Mode Font Size Last updated: 2026-04-22 11:10:43 AI-Translated Full-Scenario High Availability Architecture Business Pain Points

Provided Capabilities

Recommended Pairing Capabilities

Databases play a vital role in the core businesses of an enterprise. Data is the basic resource and lifeline of the enterprise. Therefore, to ensure stable production and operation of the enterprise, a highly available database architecture is indispensable. Issues such as database downtime, data loss, and unavailability have a significant impact on enterprises and can cause economic losses. Therefore, TencentDB for MySQL launches the All-Scenario High Availability Architecture (AS-HAA) to ensure stable business operations in all aspects and throughout the entire process.

High stability Automatic elastic scaling.
Nearby access.
Low network latency.
High availability Full-component cross-AZ/cross-region deployment.
High data processing performance and response speed.
High fault diagnosis and recovery efficiency.

﻿Cross-AZ Deployment﻿ ﻿Database Proxy﻿ ﻿CPU Elastic Scale-Out﻿ ﻿Cross-region Backup and Disaster Recovery﻿ ﻿TencentDB for DBbrain﻿

﻿ Gaming Scenarios Business Pain Points

Provided Capabilities

Recommended Pairing Capabilities

Gaming scenarios are characterized by long online duration, relatively long lifecycle of game business, prevalence of the regional server, large numbers of data records, and high requirements for low latency. At the same time, gaming businesses demand extremely high availability to avoid exceptions such as game server downtime and data loss. Rollback operations are very important in gaming businesses, requiring a balance between efficiency and integrity while minimizing the impact on users.

High performance Auto scaling of computing resources.
Minute-level deployment of partitioned databases.
Rollback to any time point.
High availability Fully automated imperceptible disaster recovery switch.

﻿Cross-AZ Deployment﻿ ﻿Database Proxy﻿ ﻿CPU Elastic Scale-Out﻿ ﻿Cross-region Backup and Disaster Recovery﻿

﻿ E-commerce Scenarios Business Pain Points

Provided Capabilities

Recommended Pairing Capabilities

In e-commerce scenarios, sudden traffic peaks can cause extreme pressure on server load, requiring high scalability and flexibility in database architecture. At the same time, high-concurrency access to hotspot data needs support from a high-performance, high-availability architecture. Moreover, e-commerce businesses often involve large data volumes, with performance requirements for multi-table join queries and relatively high real-time requirements.

High performance Addressing the performance bottleneck of hotspot data high concurrency.
Rapid elastic scaling for sudden business peaks.
High availability Strong data consistency.
Reducing the loss caused by single point of failure.
High security Effective prevention of malicious attacks, data leakage, or security risks caused by improper human operations.

﻿Cross-AZ Deployment﻿ ﻿Database Proxy﻿ ﻿CPU Elastic Scale-Out﻿ ﻿Cross-region Backup and Disaster Recovery﻿ ﻿Database Audit﻿ ﻿SSL Encrypted Transmission﻿ ﻿Transparent Data Encryption﻿

﻿ Financial Scenarios Business Pain Points

Provided Capabilities

Recommended Pairing Capabilities

The pain points of database architecture in financial businesses mainly include multiple challenges, such as high security, processing large volumes of data, high performance, high availability, and high scalability. In addition, it is necessary to manage complex queries, transaction isolation, and tuning to ensure database architecture design complies with strict laws and regulations, thereby ensuring data integrity, stability, and reliability.

High security Meeting the requirements of Cybersecurity Classified Protection Compliance Service.
Building a three-layer data security protection network before, during, and after events.
Multi-layer encryption for leakage prevention.
High availability Strong data consistency.
Cross-region disaster recovery to reduce the loss caused by single point of failure.

﻿Cross-AZ/Cross-region Deployment﻿ ﻿Cross-region Backup and Disaster Recovery﻿ ﻿Database Audit﻿ ﻿SSL Encrypted Transmission﻿ ﻿Transparent Data Encryption﻿ ﻿Secrets Manager﻿ ﻿Backup Encryption﻿ ﻿Binlog Encryption﻿

﻿ Website/SaaS Scenarios Business Pain Points

Provided Capabilities

Recommended Pairing Capabilities

The pain points of database architecture in personal websites and SaaS scenarios include persistent data storage and data security. In addition, it is necessary to process various needs of user queries and data analysis.

Cost-effective Single-node instances have a lower price, and Enhanced SSDs are used for underlying storage, with excellent performance.
Quick configuration change Rapid scale-out for computing and storage.

﻿Single-Node﻿

﻿ High-Performance Real-Time Data Analysis Business Pain Points

Provided Capabilities

﻿

Recommended Pairing Capabilities

With the continuous growth of data volume, the enterprise needs to process increasingly complex data. Different business departments and users require different types of data analysis, and the real-time requirements of data analysis are becoming more important. This has become a business pain point in today's commercial environment that determines whether an enterprise can quickly access and analyze data to make prompt decisions and strategic adjustments.

Real-time high-dimensional query Data visualization BI report Real-time monitoring and statistics

There is no need to perform Ops on complex and high-cost ETL components. The data of TencentDB for MySQL in the TXSQL engine can be directly synchronized to the LibraDB engine of the read-only instance.
LibraDB Engine enables high-performance real-time data analysis in large-scale data scenarios through the vectorized execution engine, massively parallel processing (MPP), and columnar storage acceleration capabilities.

﻿Enabling Read-Only Analysis Engines﻿ ﻿Loading Data into the Read-Only Analysis Engine﻿ ﻿Executing Queries﻿

﻿ Previous Topic: Strengths Next Topic: Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Full-Scenario High Availability Architecture Gaming Scenarios E-commerce Scenarios Financial Scenarios Website/SaaS Scenarios High-Performance Real-Time Data Analysis Search AllCurrent Product Search titles only Enter keywords to search documentation
