# Storage Types

> 来源: https://www.tencentcloud.com/document/product/238/46490

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Product Introduction Storage Types Storage Types Download Focus Mode Font Size Last updated: 2026-08-18 14:46:52 AI-Translated TencentDB for SQL Server offers multiple storage types: Premium local SSD, Balanced SSD CBS, Enhanced SSD CBS, SSD CBS, Premium Disk, and Extreme SSD CBS. This document details the storage types and their applicable scenarios for TencentDB for SQL Server to help you better select a database disk type.
Description Storage Type

Description

Applicable Instance Architectures

Scenarios

Premium local SSD

The High I/O local disk storage type delivers excellent I/O throughput performance. A SQL Server instance with a 90-core, 720 GB specification can achieve up to 4.5 million TPM.

Two-Node (Formerly HA/Cluster Edition)

This storage type is suitable for business scenarios that demand extremely high storage I/O performance and also have a high-availability architecture at the application layer, such as online gaming, e-commerce, ERP software service providers, video streaming, and media.

Balanced SSD cloud disk

Tencent Cloud's entry-level all-flash block storage product offers the advantage of high cost-effectiveness.

Multi-Node Two-Node (Formerly HA/Cluster Edition) Single-Node (Formerly Basic Edition)

This storage type is suitable for medium-scale application scenarios that require high data reliability and moderate performance, such as Web/App servers and business logic processing.

Enhanced SSD cloud disk

Tencent Cloud's General Purpose SSD CBS is designed with a new-generation storage engine. This product type, built on all-NVMe SSD storage media and the latest network infrastructure, employs a three-replica distributed mechanism to deliver storage services with low latency, high random IOPS, high throughput I/O capabilities, and data durability of up to 99.9999999%.

Multi-Node Two-Node (Formerly HA/Cluster Edition) Single-Node (Formerly Basic Edition)

This storage type is suitable for business scenarios that demand extremely high storage I/O performance and also have a high-availability architecture at the application layer, such as online gaming, e-commerce, ERP software service providers, and video streaming.

SSD cloud disk

This all-flash storage type is provided by Tencent Cloud and is based on NVMe SSD storage media. It employs a three-replica distributed mechanism to deliver storage services with low latency, relatively high random IOPS and throughput I/O capabilities, and data durability of up to 99.9999999%.

Single-Node (Formerly Basic Edition)

This storage type is suitable for application scenarios such as I/O-intensive applications and small-to-medium relational databases.

Premium cloud disk

This hybrid storage type is offered by Tencent Cloud. It delivers high-performance storage capabilities close to those of solid-state storage through a Cache mechanism, while ensuring data reliability by employing a three-replica distributed mechanism.

Single-Node (Formerly Basic Edition)

This storage type is suitable for small-to-medium application scenarios that require high data reliability and moderate performance, such as Web/App servers, business logic processing, and small-to-medium website development.

UlTra SSD

UlTra SSD CBS is built by Tencent Cloud on a self-developed high-performance distributed storage engine, coupled with high-speed network infrastructure and next-generation storage hardware, to deliver reliable performance with ultra-low latency in a long-term and stable manner.

Multi-Node Two-Node (Formerly HA/Cluster Edition) Single-Node (Formerly Basic Edition)

Suitable for low-latency, IO-intensive, and throughput-intensive workload scenarios, such as critical transaction services, core database services, large-scale OLTP services, video processing services, and so on.
Selecting a Storage Class You can select the storage type after choosing an instance architecture on the SQL Server Purchase Page.
﻿ Comparison of Storage Class Features Storage Type

I/O Performance

Maximum Selectable Hard Disk Capacity (GB)

Premium local SSD

Local disks offer low I/O latency and provide better I/O throughput performance compared to CBS.

6000

Balanced SSD cloud disk

It delivers moderate I/O throughput performance.

32000

Enhanced SSD cloud disk

It delivers extremely high I/O throughput performance.

32000

SSD cloud disk

It delivers relatively high I/O throughput performance.

32000

Premium cloud disk

It delivers stable I/O performance.

32000

UlTra SSD

Low latency and ultra-high I/O throughput performance

32000 Disk Additional I/O Performance If the baseline disk performance of TencentDB for SQL Server cannot meet your I/O demands during business peak periods, you can enable the additional disk I/O performance feature. This feature can be configured either during or after instance creation. It effectively enhances disk I/O throughput, adapts to high-load business scenarios, and provides you with more flexible and efficient database services.
Supported Versions Supported Architectures: Single-node, dual-node, and multi-node Cloud Disk Edition architectures, as well as read-only instances.
Supported Database Versions: All database versions currently displayed on the purchase page.
Supported Regions: The regions currently displayed on the purchase page.
Disk Baseline Performance Storage Type

Baseline Performance Category

Calculation Formula for Baseline Performance

Balanced SSD cloud disk

Random IOPS

min{1,800 + Capacity (GiB) x 15, 10,000}

Maximum throughput (MB/s)

min{100 + Capacity (GiB) x 0.2, 190}

Enhanced SSD cloud disk

Random IOPS

Min{1,800 + Capacity (GiB) x 50, 50,000}

Maximum throughput (MB/s)

Min{120 + Capacity (GiB) x 0.5, 350}

SSD cloud disk

Random IOPS

min{1,800 + Capacity (GiB) x 30, 26,000}

Maximum throughput (MB/s)

min{120 + Capacity (GiB) x 0.2, 260}

Premium cloud disk

Random IOPS

min{1,800 + Capacity (GiB) x 8, 6,000}

Maximum throughput (MB/s)

min{100 + Capacity (GiB) x 0.15, 150}

UlTra SSD

Random IOPS

min{4,000 + Capacity (GiB) x 100, 50,000}

Maximum throughput (MB/s)

min{120 + Capacity (GiB) x 0.5, 350} Feature Usage Conditions Currently, the additional disk I/O performance feature is supported only for Enhanced SSD CBS and Extreme SSD CBS when their storage capacity is greater than or equal to 460 GB.
Disk Additional Performance Storage Type

Additional Performance Category

Calculation Formula for Additional Performance

Enhanced SSD cloud disk

Random IOPS

Min{Configuration value x 128, 50,000}

Maximum throughput (MB/s)

Min{Configuration value x 1, 650}

UlTra SSD

Random IOPS

min{Configuration value x 128, 950,000}

Maximum throughput (MB/s)

min{Configuration value x 1, III,650} Configuration Value: Custom additional performance is supported. The configuration value range for Enhanced SSD CBS is 0 - 650, and for Extreme SSD CBS is 0 - 3650. For the actual configuration value range, refer to the console or purchase page.
Billing for Disk Additional I/O Performance Using additional disk I/O performance incurs charges. For billing details, see Additional Disk I/O Performance Billing.
Setting Disk Additional I/O Performance Additional disk I/O performance can be configured either during or after instance creation. For the operation method, see Configure Additional Disk I/O Performance.
Previous Topic: Read-Only Instance Specifications Next Topic: Common Concepts Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Description Selecting a Storage Class Comparison of Storage Class Features Disk Additional I/O Performance Supported Versions Disk Baseline Performance Feature Usage Conditions Disk Additional Performance Billing for Disk Additional I/O Performance Setting Disk Additional I/O Performance Search AllCurrent Product Search titles only Enter keywords to search documentation
