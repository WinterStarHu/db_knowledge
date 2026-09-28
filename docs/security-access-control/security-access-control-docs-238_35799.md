# Instance Adjustment Fees Description

> 来源: https://www.tencentcloud.com/document/product/238/35799

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Purchase Guide Instance Adjustment Fees Description Instance Adjustment Fees Description Download Focus Mode Font Size Last updated: 2026-03-20 15:37:37 AI-Translated This document describes the instance adjustment fees of TencentDB for SQL Server.
Billing Mode for Upgraded Instances For yearly/monthly subscription instances, when a user self-upgrades a database instance, the system calculates the price difference between specifications and deducts it from the user's account. If the account balance is insufficient, you need to recharge first. The upgrade will be billed according to the new specifications.
When a pay-as-you-go instance is upgraded, it will be billed according to the new specifications in the next billing cycle.
Billing Mode for Downgraded Instances Explanation of Downgrade Fees For yearly/monthly subscription instances, when a user self-downgrades a database instance, the system calculates the price difference according to the following formula:
Refund amount = Remaining value of the original configuration - Purchase value of the new configuration The explanation of the monetary value is as follows:
Remaining value of the original configuration: The effective order amount of the original configuration minus the used value of the original configuration.
The effective order amount of the original configuration: The amount paid for orders that are in effect, excluding discounts and vouchers.
The consumed amount for the original configuration: Calculated based on the following rules:
For the used part, if the usage has lasted for a full month or longer as of the day when downgrading is initiated, charges will be deducted by the month. If not, charges will be deducted on a pay-as-you-go basis.
The usage is precise down to the second.
Purchase value of the new configuration: The current official price of the new configuration multiplied by the remaining usage duration.
Note:
Deductions or vouchers will not be refunded.
The refund will be returned to your Tencent Cloud account proportionally based on the ratio of cash and bonus funds used for the purchase.
If the refund amount is ≤ 0, it will be calculated as 0, meaning the refund amount is 0.
Pay-as-You-Go For pay-as-you-go instances, when a user downgrades a database instance, the system recalculates the billing based on the new configuration.
Downgrade Fees Calculation Example Note:
The prices used in the examples below are only for demonstration purposes and do not correspond to the actual prices on the official website. The actual unit prices shall prevail, which may vary by region, campaign, or policy.
Background The dual-server high-availability edition instance with the specs of 1 core, 4 GB memory, 10 GB storage space in Beijing Zone 5 will be billed at the rate of 0.26256 USD/Hour.
The instance has been used for 24 hours, and you want to downgrade it to the specs of 1 core, 2 GB memory, and 10 GB storage space.
Billing Pay-as-you-go fee per hour = memory specification fee + storage fee.
The first 24 hours will be billed at the rate of original specification. Fee per hour = 4*0.0651 USD/GB/Hour + 10*0.000216 USD/GB/Hour = 0.26256 USD/Hour.
For the instance downgraded to the specs of 1 core, 2 GB memory, and 10 GB storage after 24 hours, it will be billed according to the new specifications in the next billing cycle.
New specs fee per hour = 20.0651 USD/GB/Hour + 10*0.000216 USD/GB/Hour =0.13236 USD/Hour.
References TencentDB for SQL Server supports quick adjustment of instance specifications and provides flexible scaling operations. For related operations, see Adjusting Instance Configuration.
Related APIs API

Description

﻿InquiryPriceUpgradeDBInstance﻿

This API is used to query the upgrade prices of a yearly/monthly subscribed instance.
Previous Topic: From Pay-as-You-Go to Monthly Subscription Next Topic: Local Backup Space Billing Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Billing Mode for Upgraded Instances Billing Mode for Downgraded Instances Explanation of Downgrade Fees Downgrade Fees Calculation Example References Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
