# Disk Additional I/O Performance Billing Description

> 来源: https://www.tencentcloud.com/document/product/238/81632

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Disk Additional I/O Performance Billing Description Disk Additional I/O Performance Billing Description Download Focus Mode Font Size Last updated: 2026-08-18 14:46:53 AI-Translated If the baseline disk performance of TencentDB for SQL Server cannot meet your I/O demands during business peak periods, you can enable the additional disk I/O performance feature. Once enabled, this feature effectively enhances disk I/O throughput, adapts to high-load business scenarios, and provides you with more flexible and efficient database services. This document describes the billing details for the additional disk I/O performance.
Feature Overview TencentDB for SQL Server supports configuring additional I/O performance beyond the baseline disk performance to meet the demands of high-throughput, high-IOPS business scenarios.
What Is I/O Performance Configuration Additional I/O performance refers to the extra throughput capacity that can be configured by users based on their business requirements when the baseline performance of CBS reaches its limit or the current disk cannot meet the disk performance demands of their business.
Supported Editions and Types for I/O Performance Configuration The Cloud Disk Edition architecture supports single-node, two-node, multi-node, and read-only instances, with no regional or database version restrictions.
Currently, only Enhanced SSD and UlTra SSD support configuring additional I/O performance.
Disk Performance Composition The disk I/O performance of TencentDB for SQL Server consists of two parts:
Performance Type

Description

Adjustment Method

Baseline Performance

Performance automatically obtained with storage capacity

Cannot be adjusted independently. Can be adjusted by scaling out.

Additional Performance

Additional performance proactively configured by users

Can be purchased and adjusted independently.
Billing Instructions Baseline Performance: The performance automatically obtained based on the disk type and capacity settings when you purchase a TencentDB for SQL Server instance. It does not incur separate charges.
Additional Performance: It incurs separate charges. You can adjust the amount of additional performance both when purchasing a TencentDB for SQL Server instance and after purchase.
Billing Mode Additional disk I/O performance supports two billing modes:
Billing Mode

Description

Applicable Scenarios

Yearly/monthly subscription

Prepaid mode, where you pay the fee upon purchase or adjustment.

Stable business volume and long-term usage

Pay-as-you-go

Postpaid mode, where you are charged based on the actual usage duration.

Fluctuating business volume and short-term usage Billing Rules Minimum Configuration Unit: 0 MB/s.
Purchase Restriction: The disk capacity must be greater than or equal to 460 GB.
Pricing Note:
The price of additional I/O performance is related to the number of nodes in the instance. The price shown in the table below is for the additional I/O performance per node. The calculation for specific nodes and prices is as follows:
Single-node and read-only instances: The price for additional I/O performance per node is consistent with the table below.
Two-node instances: The price for additional I/O performance for two nodes is calculated as the unit price in the table below multiplied by 2.
Multi-node instances (3-6 nodes): The price for additional I/O performance is calculated as the unit price in the table below multiplied by the number of nodes. The number of nodes can be 3 to 6.
Pricing in Monthly Subscription Mode Region

Additional Performance (USD/MB/s/month)

South China (Guangzhou)

0.44117647

East China (Shanghai)

0.44117647

East China (Nanjing)

0.44117647

North China (Beijing)

0.44117647

Southwest China (Chengdu)

0.44117647

Southwest China (Chongqing)

0.44117647

East China (Shanghai Finance Zone)

0.66176471

South China (Shenzhen Finance Zone)

0.66176471

North China (Beijing Finance Zone)

0.66176471

Hong Kong (China)

0.44117647

Southeast Asia Pacific (Singapore)

0.44117647

Southeast Asia Pacific (Jakarta)

0.44117647

West US (Silicon Valley)

0.44117647

Europe (Frankfurt)

0.44117647

Northeast Asia Pacific (Seoul)

0.44117647

Eastern United States (Virginia)

0.44117647

Southeast Asia Pacific (Bangkok)

0.44117647

Northeast Asia Pacific (Tokyo)

0.44117647

South America (São Paulo)

0.44117647

Middle East (Riyadh, Saudi Arabia)

0.44117647
Pricing in Pay-As-You-Go Mode Region

Additional Performance (USD/MB/s/hour)

South China (Guangzhou)

0.00061765

East China (Shanghai)

0.00061765

East China (Nanjing)

0.00061765

North China (Beijing)

0.00061765

Southwest China (Chengdu)

0.00061765

Southwest China (Chongqing)

0.00061765

East China (Shanghai Finance Zone)

0.00092647

South China (Shenzhen Finance Zone)

0.00092647

North China (Beijing Finance Zone)

0.00092647

Hong Kong (China)

0.00061765

Southeast Asia Pacific (Singapore)

0.00061765

Southeast Asia Pacific (Jakarta)

0.00061765

West US (Silicon Valley)

0.00061765

Europe (Frankfurt)

0.00061765

Northeast Asia Pacific (Seoul)

0.00061765

Eastern United States (Virginia)

0.00061765

Southeast Asia Pacific (Bangkok)

0.00061765

Northeast Asia Pacific (Tokyo)

0.00061765

South America (São Paulo)

0.00061765

Middle East (Riyadh, Saudi Arabia)

0.00061765
Fee Description for Adjusting Additional I/O Performance You can adjust the additional I/O performance configuration based on your business requirements:
Operation Type

Billing Mode

Billing Instructions

Performance Upgrade

Yearly/monthly subscription

When performance is upgraded, you need to pay the price difference between the new and old configurations based on the remaining time in the instance lifecycle. The specific amount to be paid is subject to the console settlement and bill.

Pay-as-you-go

The change takes effect immediately, and billing starts based on the price of the new configuration. If the adjustment occurs with less than one hour remaining in the current billing hour, the system bills for a full hour. The final amount is subject to the bill in the Cost Center.

Performance Degrade

Yearly/monthly subscription

When performance is downgraded, a refund is issued based on the price difference between the value of the remaining time in the lifecycle and the value of a new purchase with the new configuration. If the difference is less than or equal to -0 (usually because the discount at your instance purchase differs from the discount after the configuration change), no refund is involved.

Pay-as-you-go

The change takes effect immediately, and billing starts based on the price of the new configuration. If the adjustment occurs with less than one hour remaining in the current billing hour, the system bills for a full hour. The final amount is subject to the bill in the Cost Center.
Documentation To learn about additional disk I/O performance and its calculation formula, see Storage Types.
To learn how to configure additional disk I/O performance, see Configuring Additional Disk I/O Performance.
Previous Topic: Database Audit Billing Overview Next Topic: Viewing Bill Details Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Overview What Is I/O Performance Configuration Supported Editions and Types for I/O Performance Configuration Disk Performance Composition Billing Instructions Billing Mode Billing Rules Pricing Fee Description for Adjusting Additional I/O Performance Documentation Search AllCurrent Product Search titles only Enter keywords to search documentation
