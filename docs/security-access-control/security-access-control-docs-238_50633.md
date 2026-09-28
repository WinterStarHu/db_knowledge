# User Guide

> 来源: https://www.tencentcloud.com/document/product/238/50633

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server User Guide User Guide Download Focus Mode Font Size Last updated: 2026-03-20 16:07:28 AI-Translated This document describes the common use cases and operations of TencentDB for SQL Server.
1. Basic Knowledge
If you purchase and use a TencentDB for SQL Server instance for the first time, we recommend you start with the overview and concepts of the product in the following order.
Product Overview Architecture Strengths Use Cases Common Concepts ﻿Regions and AZs﻿ ﻿Engines and Versions﻿ Features and Differences Instance Types Primary Instance Specifications Read-Only Instance Specifications Storage Types Network Environment License Statement Then, the use limits, specifications, and suggestions of TencentDB for SQL Server are provided to help you better use the product.
Constraints and Limits Usage Specifications and Suggestions
2. Billing Mode
TencentDB for SQL Server has two billing modes, pay-as-you-go billing mode and yearly/monthly subscription billing mode. For more information, see Billing Overview.
For more information on product billing, see the following documents:
﻿Primary Instance Pricing﻿ ﻿Read-Only Instance Pricing﻿ ﻿Renewal Instructions﻿ Payment Overdue ﻿Refund Instructions﻿ ﻿Converting Pay-as-You-Go to Yearly/Monthly Subscription﻿ Instance Adjustment Fees Description Backup Space Billing Cross-Region Backup Billing Viewing Bill Details
3. Getting Started
3.1 Purchasing a TencentDB for SQL Server instance
Before using TencentDB for SQL Server, you need to sign up for a Tencent Cloud account and purchase an instance. For more information, see Creating TencentDB for SQL Server Instance.
3.2 Connecting to a TencentDB for SQL Server instance
After purchasing a TencentDB for SQL Server instance, you can access the instance from a Windows or Linux CVM instance over the public network or private network. For more information, see Instance Connection Scenarios.
3.3 Managing a TencentDB for SQL Server instance
After creating a TencentDB for SQL Server instance, you can manage the instance in the console. For more information, see Managing TencentDB for SQL Server Instance.
4. Overview of Console Features
TencentDB for SQL Server provides an easy-to-use console to help you implement diversified features with ease, such as instance management, quick configuration adjustment, visual instance monitoring, and backup configuration and management. For more information, see the following documents.
Console Feature

Documentation

Instance management and maintenance

Renaming Instance Setting Instance Remarks Setting Instance Tag Setting Instance Project Modifying Instance-Level Character Set Collation Modifying System Time Zone Setting Instance Maintenance Information Restarting Instance Terminating Instance Migrating Across AZs Recycle Bin

Instance configuration adjustment

Overview Adjusting Instance Architecture Adjusting Instance Version Adjusting Instance Specification

Read-only instance

Read-Only Instance Overview Managing Read-Only Instance ﻿Read-Only Group Replica Node Read-only﻿

Network Management

Switching from Classic Network to VPC Changing Network (from VPC to VPC) Enabling/Disabling Public Network Address ﻿Enabling Public Network Access Through CLB﻿

Account management

﻿Creating Account﻿ ﻿Creating Admin Account Creating Special Permission Account﻿ Resetting Password Modifying Account Permissions Deleting Account

Database management

Creating Database Setting Database Permissions Cloning Database Deleting Database Setting Change Data Capture (CDC) Setting Change Tracking (CT) Shrinking Database

Data Security

﻿Transparent Data Encryption Seting up SSL Encryption﻿ ﻿Disk Encryption﻿ ﻿CAM Overview Authorization Policy Syntax Authorizable Resource Types Configuring Security Group﻿

Parameter configuration

Setting Instance Parameters Viewing Parameter Modification Log

Monitoring and alarms

Viewing Monitoring Charts Monitoring Metrics Setting Alarm Policies Setting Alarm Notification Viewing Alarm Records

Backup and rollback

Backup Overview ﻿Setting Up Regular Backup Retention Setting Up Periodic Backup Retention﻿ Creating Manual Backup Setting Backup Task ﻿Cross-Region Backup﻿ Viewing Backup List Downloading Backup Deleting Manual Backup Viewing Backup Space ﻿Rollback Plan Overview Rollback to Current Instance Rollback to Existing Instance (Same Region) Rollback to Existing Instance (Cross-region) View Rollback Task List﻿

Log management

﻿Querying and Downloading Slow Query Log﻿ ﻿Querying and Downloading Blocking and Deadlock Events Querying Primary/Replica Switchover Log Manually Creating Latest Blocking and Deadlock Events﻿

Publish/Subscribe

﻿Publish/Subscribe Overview﻿ ﻿Managing Publish/Subscribe﻿

SQL Server Integration Services (SSIS)

SSIS Overview Purchasing Business Intelligence Server Creating Windows Authentication Account Adding Flat File ﻿Interconnecting Source/Target Instances and Business Intelligence Server﻿ ﻿Deploying Project﻿

Data migration (New)

Cold Backup Migration ﻿Migrating Data with DTS﻿
5. FAQs
The FAQs about the use of TencentDB for SQL Server are summarized to make it easier for you to find answers to common questions. For more information, see Overview.
6. Troubleshooting
If you encounter problems such as high CPU utilization, blockage, slow SQL, and deadlocks during your use of TencentDB for SQL Server, you can refer to Performance/Space/Memory for troubleshooting.
7. Feedback and Suggestions
If you have any questions or suggestions about TencentDB for SQL Server, you can send your feedback through the following channels, and we will get back to you accordingly:
If you have any questions regarding the product documentation, such as links, content, or APIs, click Send Feedback on the right of the document page.
If you encounter any problems while using the product, submit a ticket for assistance.
Previous Topic: Product Announcements Next Topic: Product Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. Basic Knowledge
2. Billing Mode
3. Getting Started
3.1 Purchasing a TencentDB for SQL Server instance
3.2 Connecting to a TencentDB for SQL Server instance
3.3 Managing a TencentDB for SQL Server instance
4. Overview of Console Features
5. FAQs
6. Troubleshooting
7. Feedback and Suggestions
Search AllCurrent Product Search titles only Enter keywords to search documentation
