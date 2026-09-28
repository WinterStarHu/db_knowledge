# Database Audit Billing Overview

> 来源: https://www.tencentcloud.com/document/product/238/78791

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Database Audit Billing Overview Database Audit Billing Overview Download Focus Mode Font Size Last updated: 2026-08-12 10:27:24 AI-Translated TencentDB for SQL Server offers the Database Audit feature, which records database access and SQL statement execution. This helps enterprises implement risk control and improve data security levels. This document describes the billing overview for TencentDB for SQL Server Database Audit.
Database Audit pricing Only after Database Audit is enabled do you need to pay for Database Audit. For how to enable Database Audit, see Enable Database Audit.
Database Audit is charged in pay-as-you-go mode based on the audit log storage size. The billing cycle is one hour. If the duration is less than one hour, the fee will be charged by one hour.
Note:
The audit log storage is reported on a "per-second" basis, and precision errors may occur when the audit log storage is calculated on an "hourly" basis. Please refer to the actual bill for details.
Region

Price (USD/GB/Hour)

Frequent Access Storage

Infrequent Access Storage

China (including financial regions)

0.00147059

0.00018382

Countries and Regions Outside China

0.00220588

0.00027573
Notes on Frequent/Infrequent Access Storage Frequent Access Storage represents ultra-high-performance storage media with excellent query performance. You can set the storage duration, within which audit data will be stored in STANDARD Storage. Data exceeding the STANDARD Storage duration will automatically transition to STANDARD_IA Storage. Both storage types support identical audit capabilities and differ only in performance.
You can set and modify the time period for frequent/infrequent access storage as needed, and the system will automatically move data between the frequent and infrequent access storage tiers based on the period, thus reducing your storage costs.
Frequent/Infrequent storage architecture ﻿ As shown in the picture, If the data of the last 7 days is set to be stored in frequent access storage, older data will be automatically transitioned to infrequent access storage. After the frequent access storage period is extended, the audit data that falls in the period will be automatically migrated from infrequent access storage to frequent access storage.
Performance differences between frequent and infrequent access storage Frequent access storage throughput

Infrequent access storage throughput

110,000 SQLs/per second

25,000 SQLs/per second Log Delivery Feature Pricing TencentDB for SQL Server Database Audit provides the Log Shipping feature. If you enable this feature, you will incur usage fees for the third-party independent billing product and traffic fees generated by log shipping, as detailed below.
The feature of shipping Database Audit logs from TencentDB for SQL Server to CLS involves CLS, a third-party cloud product billed independently. For its billing standards, see CLS > Billing Overview.
Billable Item: Audit Log Traffic

Chinese Mainland (USD/GB)

Hong Kong (China), other countries and regions (USD/GB)

0.05882353

0.08823529
Release Notes After Database Audit is enabled for TencentDB for SQL Server (in pay-as-you-go mode or yearly/monthly subscription mode), when the user releases the database instance or the database instance expires and is released, the corresponding Database Audit service will stop, logs will be automatically deleted, and cannot be recovered.
Overdue Payments
1.
From the moment your account balance falls below 0:
Within 2 hours, Database Audit can continue to be used and continues to incur charges.
After 2 hours, Database Audit will automatically stop and charging is stopped.
2.
After services automatically stop:
Within 24 hours of automatic suspension, if you top up your balance to be greater than or equal to 0, Database Audit will resume and billing will continue. If your account balance remains below 0, Database Audit cannot be restored.
After 24 hours of automatic suspension, if your account balance remains below 0, logs will be deleted and cannot be recovered.
Previous Topic: Cross-Region Backup Billing Description Next Topic: Disk Additional I/O Performance Billing Description Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Database Audit pricing Notes on Frequent/Infrequent Access Storage Frequent/Infrequent storage architecture Performance differences between frequent and infrequent access storage Log Delivery Feature Pricing Release Notes Overdue Payments Search AllCurrent Product Search titles only Enter keywords to search documentation
