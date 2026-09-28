# Resource Isolation Policy

> 来源: https://www.tencentcloud.com/document/product/236/39794

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Resource Isolation Policy Resource Isolation Policy Download Focus Mode Font Size Last updated: 2024-11-06 19:15:37 This document describes the isolation policies of TencentDB for MySQL, including basic , general, dedicated, standard, and enhanced types.
Note:
The former "Basic Edition" has been renamed "basic single-node", and the former "Single-Node High IO Edition" has been renamed "general single-node".
Two-node and three-node architectures support general and dedicated isolation policies.
The Cluster Edition architecture supports both standard and enhanced isolation policies.
Architecture

Resource Isolation Policy

Description

Single-node (cloud disk)

Basic

Single-node instances are the only ones that support this policy. A basic single-node instance (formerly Basic Edition) supports computation-storage separation and stores data on cloud disks.

Two-node (local disk) Three-node (local disk)

General

A general instance exclusively uses the allocated memory and disk resources and shares the CPU resources with other general instances on the same physical machine. * A general instance benefits from higher specifications at a lower cost by sharing CPU resources.

Two-node (local disk) Three-node (local disk)

Dedicated

A dedicated instance has exclusive access to the CPU, memory, and disk resources (if CPU pinning is enabled). It has long-term stability and is unaffected by the activities of other instances on the physical machine.
A dedicated instance with the highest configurations can monopolize a physical machine and all of its resources.

Cluster Edition (cloud disk)

Standard Type

Exclusive allocation of CPU and memory ensures long-term stable performance.
A decoupled architecture of computing and storage offers flexible configuration options.

Cluster Edition (cloud disk)

Enhanced Type

Enhanced frequency CPU cores deliver optimal performance.
Exclusive allocation of CPU and memory ensures long-term stable performance.
A decoupled architecture of computing and storage offers flexible configuration options.
Supports Tremendous SSD cloud disk, providing stable and reliable performance.
*There may be resource contention for the general type in extreme cases (very low probability).
Isolation policies for different architectures For TencentDB for MySQL, both the single node (cloud disk edition) and the Cluster Edition (cloud disk edition), are deployed on the cloud-native TKE, with each instance enjoying dedicated CPU, memory, and disk resources, ensuring complete isolation between different instances.
TencentDB for MySQL two-node (local disk) and three-node (local disk) instances are deployed based on local physical machines. Each physical machine sustains multiple instances and adopts isolation policies to ensure the complete isolation between different instances with dedicated CPU, memory, and disk resources.
In addition, TencentDB for MySQL also implements corresponding data isolation policies in multiple dimensions such as account, region, AZ, and network.
Previous Topic: Single-Node Instances (Formerly Basic Edition and Cloud Disk Edition) Next Topic: Economical Instance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Isolation policies for different architectures Search AllCurrent Product Search titles only Enter keywords to search documentation
