# Cross-Region Backup Billing Description

> 来源: https://www.tencentcloud.com/document/product/238/50229

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Cross-Region Backup Billing Description Cross-Region Backup Billing Description Download Focus Mode Font Size Last updated: 2026-07-28 11:35:09 AI-Translated Overview Cross-region backup is used to store backup files in another region. After you enable cross-region backup for an instance, the system automatically copies local automated backup files to the destination region's COS bucket. This document describes the billing details for cross-region backup.
Cross-Region Backup Description Cross-region backup does not affect local default backups. After you enable cross-region backup, both types of backup coexist.
After the local default automated backup is completed, cross-region backup is triggered. This process involves archiving the default automated backup to the cross-region backup storage device.
The backup files in the cross-region backup space consist of automated backups, which include data backups and log backups. This means that local automated backups are synchronized to remote storage.
Cross-region backup and local backup do not share backup space. This means that the backup space for cross-region backup is independent.
Cross-region backup does not include free storage space. If you enable cross-region backup for an instance, all backup files generated will be charged.
The billing space for cross-region backup (in the region of the primary instance) = data backup volume  (in the destination region) + log backup volume  (in the destination region).
Cross-region backup is stored in the destination region. The backup usage is calculated against the region where the primary instance resides. The storage fee for cross-region backup is calculated based on the storage price of the destination region. The traffic fee for cross-region backup is calculated based on the link between the source region and the destination region.
Cross-Region Backup Pricing The cross-region backup fee consists of two parts: storage and traffic.
Cross-region backup fee = Cross-region backup storage fee + Cross-region replication traffic fee For example, if an instance is located in Hong Kong (China) and cross-region backup is configured for Beijing, the cross-region backup is stored in a COS bucket in the Beijing region. The cross-region backup storage fee is calculated based on the storage price of the Beijing region. The cross-region backup traffic fee is calculated based on the link between Hong Kong (China) and Beijing.
Storage Pricing The cross-region backup storage fee is calculated based on the storage price of the destination region. The billing mode is pay-as-you-go and postpaid. The price is as follows:
Chinese Mainland, Financial Zone

Hong Kong (China)

0.000113 USD/GB/hour

0.000127 USD/GB/hour
Note:
No actual fee is charged for charged space less than 1 GB. Usage of less than one hour is billed as one hour.
Traffic Pricing The traffic for cross-region backup is billed based on the link between the source region and the destination region. The billing mode is pay-as-you-go and postpaid. The price is as follows:
Cross-Region Backup Source Region

Cross-Region Backup Destination Region

Traffic Price (USD/GB)

Chinese mainland (Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing)

Chinese mainland (Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing)

0.09230769

Finance zones (Beijing Finance, Shanghai Finance, Shenzhen Finance)

Finance zones (Beijing Finance, Shanghai Finance, Shenzhen Finance)

0.15384615

Hong Kong (China)

Chinese mainland (Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing)

0.35384615

Finance zones (Beijing Finance, Shanghai Finance, Shenzhen Finance)

Chinese mainland (Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing)

0.12307692

Chinese mainland (Beijing, Shanghai, Guangzhou, Chengdu, Chongqing, Nanjing)

Finance zones (Beijing Finance, Shanghai Finance, Shenzhen Finance)

0.12307692
Cross-Region Backup Lifecycle Cross-region backup is billed throughout its lifecycle until the instance is decommissioned. Specifically, it is billed when the instance is in the Running or Isolated state. Billing stops after the instance enters the Decommissioned state.
Yearly/Monthly subscription instances Within 7 days after instance expiration, if cross-region backup is enabled, the cross-region backup feature can function normally.
Seven days after instance expiration, starting from the 8th day, the instance is isolated and enters the recycle bin. At this point, rollback and manual backup are disabled, while automatic backup continues. If cross-region backup is enabled, it also proceeds normally. However, modifying the cross-region backup configuration is not supported. You can renew the instance in the console recycle bin. After renewal, the instance and backups are restored, and the ability to modify the cross-region backup configuration is re-enabled.
After being isolated in the recycle bin for 7 days, starting from the 15th day after instance expiration, the instance is officially decommissioned. At this point, the instance is terminated, and the associated local backups and cross-region backups are also terminated. Please promptly save any backups you require.
Pay-as-you-go instances Within 24 hours after instance expiration, if cross-region backup is enabled, cross-region backup can be performed normally.
Twenty-four hours after instance expiration, the instance is isolated and enters the recycle bin. At this point, rollback and manual backup are disabled, while automatic backup can still be performed. If cross-region backup is enabled, it also proceeds normally. However, modifying the cross-region backup configuration is not supported. You can renew the instance in the console recycle bin. After renewal, the instance and backups are restored, and the ability to modify the cross-region backup configuration is re-enabled.
After being isolated in the recycle bin for 3 days, starting from the 5th day after instance expiration, the instance is officially decommissioned. At this point, the instance is terminated, and the associated local backups and cross-region backups are also terminated. Please promptly save any backups you require.
Account Overdue Payment Description Yearly/Monthly subscription instances After the account incurs an overdue payment while the instance is still valid, backup-related services are downgraded. Rollback, manual backup, and backup download are disabled. During this period, automatic backup continues. If cross-region backup is enabled, it proceeds normally with backup synchronization and continues to be billed.
If you need to perform services such as rollback, manual backup, backup download, or modifying cross-region backup settings, please top up your account to a positive balance.
Pay-as-you-go instances After the account incurs an overdue payment, if cross-region backup is enabled, its backup lifecycle changes according to the lifecycle of the user's instance, which is the same as the pay-as-you-go backup lifecycle.
Previous Topic: Local Backup Space Billing Next Topic: Database Audit Billing Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Cross-Region Backup Description Cross-Region Backup Pricing Storage Pricing Traffic Pricing Cross-Region Backup Lifecycle Account Overdue Payment Description Search AllCurrent Product Search titles only Enter keywords to search documentation
