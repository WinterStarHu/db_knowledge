# Billing Overview

> 来源: https://www.tencentcloud.com/document/product/238/35798

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Billing Overview Billing Overview Download Focus Mode Font Size Last updated: 2026-08-03 14:57:41 AI-Translated Billing Mode TencentDB for SQL Server offers the following billing mode:
Billing Mode

Payment Mode

Applicable Scenarios

Yearly/monthly subscription

Prepaid mode, which means that you pay the fee when you create an instance.

Suitable for long-term needs with relatively stable traffic volume. The fee is lower compared to pay-as-you-go mode, and the longer the purchase period, the more discounts you get.

Pay-as-you-go

Postpaid mode, which means that you apply for resources on demand first, and you are charged based on your actual resource usage during settlement.
Note:
Fees are settled hourly. If the resources are used for less than 1 hour, fees are charged based on 1 hour.

It is suitable for business scenarios with large instantaneous fluctuations in business volume. The instance can be released immediately after use to save costs.
Instance Price Billing Formula Total cost = Instance specification cost + Storage space cost + Backup space cost Billable Items Billable Item

Description

Instance specification fees

Fees for the instance specification selected on the purchase page. Monthly subscription and pay-as-you-go are supported.
For single-node instance specification pricing, see Single-Node Instance Pricing.
For two-node instance specification pricing, see Two-Node Instance Pricing.
For multi-node instance specification pricing, see Multi-node Instance Pricing.
For read-only instance specification pricing, see Read-Only Instance Pricing.

Storage space fees

Fees for the disk size selected on the purchase page. Monthly subscription and pay-as-you-go are supported.
For single-node instance storage pricing, see Single-Node Instance Pricing.
For two-node instance storage pricing, see Two-Node Instance Pricing.
For multi-node instance storage pricing, see Multi-node Instance Pricing.
For read-only instance storage pricing, see Read-Only Instance Pricing.

Backup space fees

Used to store the backup files of all TencentDB for SQL Server instances in a certain region. Backup files include automatic data backups, manual data backups, and log backups.
For local backup space billing, see Local Backup Space Billing.
Cross-region backup involves storage and traffic fees. For details, see Cross-Region Backup Billing.
Note:
TencentDB for SQL Server provides you with a free tier of backup space for each region. Cross-region backup has no free space. All generated backup files are charged if cross-region backup is enabled for an instance. The free backup space size equals the sum of the storage space of all your primary single-node (formerly Basic Edition), two-node (formerly HA/Cluster Edition), and multi-node instances in the region. Billing for excess backup space beyond the free tier started at 00:00 on July 10, 2022.
Disk Additional I/O Performance Price TencentDB for SQL Server supports configuring additional I/O performance beyond the baseline disk performance to meet the demands of high-throughput, high-IOPS business scenarios. You can choose whether to enable additional disk I/O performance based on your business needs, either during instance purchase or afterwards. If you enable additional disk I/O performance, it involves additional charges. For detailed feature introduction and billing information, see Additional Disk I/O Performance Billing.
Previous Topic: License Statement Next Topic: Single-Node Instance Pricing Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Billing Mode Instance Price Billing Formula Billable Items Disk Additional I/O Performance Price Search AllCurrent Product Search titles only Enter keywords to search documentation
