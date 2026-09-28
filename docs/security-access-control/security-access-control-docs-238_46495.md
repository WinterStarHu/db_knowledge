# Features and Differences

> 来源: https://www.tencentcloud.com/document/product/238/46495

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Product Introduction Features and Differences Features and Differences Download Focus Mode Font Size Last updated: 2026-07-30 17:20:55 AI-Translated This document introduces the feature overview and differences across editions of TencentDB for SQL Server.
Feature Overview and Differences by Edition Note:
In the following table, "-" means not involved.
Module

Feature

Single-Node (Formerly Basic Edition)

Dual-Node (Formerly HA Edition and Cluster Edition)

Multi-Node

Version

-

2012 Enterprise 2014 Enterprise 2016 Enterprise 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

2012 Enterprise 2014 Enterprise 2016 Enterprise 2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

2017 Enterprise 2019 Enterprise 2022 Enterprise 2025 Enterprise

Lifecycle

Instance creation

Supported

Supported

Supported

Instance restart

Supported

Supported

Supported

Automatic renewal

Supported

Supported

Supported

Billing mode change

Supported

Supported

Supported

Instance termination

Supported

Supported

Supported

Read-only instance creation

Not supported

Supported

Supported (enable the feature via the read-only capability of the secondary node.)

Specification adjustment

Supported

Supported

Supported

Disk scaling

Scale-out: Supported.
Scale-in: Not supported.

Local disk scaling: Supported.
Cloud disk scale-out: Supported.
Cloud disk scale-in: Not supported.

Scale-out: Supported.
Scale-in: Not supported.

Version upgrade

Supported

Supported

Supported

Architecture upgrade

Not supported

Supported

-

Instance attribute

View of instance list

Supported

Supported

Supported

View of instance details

Instance name modification

Instance remark modification

Instance tag settings

Maintenance time management

Project management

Service Availability

Highly available method

Compute node migration + disk snapshot

The SQL Server 2012/2014/2016 Enterprise edition uses the Mirror HA version.
SQL Server 2017/2019/2022/2025 Enterprise uses Always On HA.

Always On HA is used.

Cross-Availability Zone Disaster Recovery

Not supported

Supported

Supported

Intra-city disaster recovery

Not supported

Supported

Supported

Read-only instance removal

Not supported

Supported

-

Cross-AZ migration

Not supported

Supported

Supported

Backup and restoration

Full backup

Supported

Supported

Supported

Data Backup

Incremental backup

Log backup

Scheduled backup

Manual backup

Packaged backup

Single-database backup

Instance backup

Multi-database backup

Backup policy customization

Recover by backup set

Recover by time point

Recover by user backup set

Rollback to the current instance

Rollback to an existing instance (intra-region)

Rollback to an existing instance (cross-region)

Backup download

Perform backup tasks for a replica instance

Not supported

The SQL Server 2012/2014/2016 Enterprise edition is not supported.
The SQL Server 2017/2019/2022/2025 Enterprise edition is supported.

Not supported

Backup overview

Supported

Supported

Supported

COS object lock WORM mechanism

Supported

Supported

Supported

Database recovery mode modification

Supported

Not supported

Not supported

Monitoring and alarm

Resource monitoring

Supported

Supported

Supported

Engine monitoring

Real-time monitoring

Monitoring policy customization

Metric alarm

Event alarm

Account management

Account creation and deletion

Supported

Supported

Supported

Account CAM authentication

Password reset

Database permission setup

Table permission setup

Standard account

Privileged account

Designated account

Admin account

Supported

Not supported

Not supported

Database management

Table-level account authorization

Supported

Supported

Supported

DMC data management

Database creation

Database deletion

Database cloning

Database authorization

Change data capture (CDC)

Change tracking (CT)

Database shrink

Data security

Security group

Supported

Supported

Supported

Database auditing

Supported

Supported

Supported

Network encryption

Not supported

Not supported

Not supported

TDE encryption

Supported

Supported

Not supported

SSL encryption

Supported

Supported

Supported

Disk Encryption

Instances using cloud disks and with SQL Server 2019/2022/2025 Enterprise edition are supported.

Instances using cloud disks and with SQL Server 2019/2022/2025 Enterprise edition are supported.

Instances using cloud disks and with SQL Server 2019/2022/2025 Enterprise edition are supported.

Data channel

Data sync

Not supported

Not supported

Not supported

Homogeneous data migration

Supported

Supported

Supported

Heterogeneous data migration

Not supported

Not supported

Not supported

Publishing/subscription

Supported

Not supported

Log management

Error logs

Not supported

Not supported

Not supported

Slow logs

Supported

Supported

Supported

Run logs

Not supported

Not supported

Not supported

Blocking and deadlock events

SQL Server 2012/2014/2016/2017/2019/2022/2025 Enterprise editions are supported.

SQL Server 2012/2014/2016/2017/2019/2022/2025 Enterprise editions are supported.

Supported

Parameter management

Parameter update

Supported

Supported

Supported

Parameter history

Parameter template

Not supported

Not supported

Not supported

Performance optimization

Expert service

Supported

Supported

Supported

Resource analysis

Not supported

Not supported

Not supported

Engine analysis

Networking

VPC

Supported

Supported

Supported

Public network address

Supported

Supported

Supported Previous Topic: Major Version Lifecycle Description Next Topic: Instance Type Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Feature Overview and Differences by Edition Search AllCurrent Product Search titles only Enter keywords to search documentation
