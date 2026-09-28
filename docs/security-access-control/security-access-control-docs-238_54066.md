# Account Types and Permissions

> 来源: https://www.tencentcloud.com/document/product/238/54066

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Account Types and Permissions Account List Creating Account Deleting Account Modifying Account Permissions Creating an Admin Account Creating an Admin Account Resetting Password Setting Account CAM Verification Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Account Management Account Types and Permissions Account Types and Permissions Download Focus Mode Font Size Last updated: 2025-10-11 10:28:08 AI-Translated After creating an SQL Server instance, you can create different database accounts under the instance and assign different accounts for database management according to business needs.
TencentDB for SQL Server supports the creation of various account types, with the corresponding permissions configured for each type. This document introduces the account types and the permissions supported by the TencentDB for SQL Server instances.
Note:
TencentDB for SQL Server launched the new database account and permission logic on February 9, 2023. For the mappings between old and new account types and permissions, see Account Type and Permission Changes.
The msdb database has security risks. Therefore, the system has temporarily revoked its permissions. If your business needs to use this database, submit a ticket for application.
Account Types and Permissions for Two-Node (Formerly HA/Cluster Edition) and Multi-node Instances Instance Architecture

Account Type

Database Permission

Table Permission Description

Role Description

Two-node (formerly HA/Cluster Edition) and multi-node

Privileged account

Instance admin account, which has the owner permissions of all databases by default.

Table-level authorization is supported. For grantable table permissions, see Modifying Account Permissions.

Server-level roles:
processadmin dbcreator Database-level roles:
rdb_owner

Standard account

Owner

Table-level authorization is supported. For grantable table permissions, see Modifying Account Permissions.

Server-level roles:
processadmin dbcreator Database-level roles:
db_owner

Read/Write

Server-level roles:
processadmin dbcreator Database-level roles:
db_reader db_writer

Read-only

Server-level roles:
processadmin dbcreator Database-level roles:
db_reader

Designated account

A designated account can only view and own the specified database.
A designated account can be authorized to multiple databases, but a database can be authorized to only one designated account.

Table-level authorization is not supported.

Server-level roles:
processadmin dbcreator Database-level roles:
db_owner Account types and permissions for single-node (formerly Basic Edition) instances Instance Architecture

Account Type

Database Permission

Table Permission Description

Role Description

Single-node (formerly Basic Edition)

Admin account

Instance admin account, which has the highest-level sysadmin permission and the owner permissions of all databases. After the admin account is enabled, the product SLA will no longer be guaranteed.

Table-level authorization is not supported.

Server-level roles:
sysadmin sysadmin Databaseoles:
db_owner

Privileged account

It has the owner permissions of all databases by default.

Table-level authorization is supported. For grantable table permissions, see Modifying Account Permissions.

Server-level roles:
processadmin dbcreator Database-level roles:
db_owner

Standard account

Owner

Table-level authorization is supported. For grantable table permissions, see Modifying Account Permissions.

Server-level roles:
processadmin dbcreator Database-level roles:
db_owner

Read/Write

Server-level roles:
processadmin dbcreator Database-level roles:
db_reader db_writer

Read-only

Server-level roles:
processadmin dbcreator Database-level roles:
db_reader

Designated account

A designated account can only view and own the specified database.
A designated account can be authorized to multiple databases, but a database can be authorized to only one designated account.

Table-level authorization is not supported.

Server-level roles:
processadmin dbcreator Database-level roles:
db_owner Previous Topic: Authorizable Resource Types Next Topic: Account List Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Account Types and Permissions for Two-Node (Formerly HA/Cluster Edition) and Multi-node Instances Account types and permissions for single-node (formerly Basic Edition) instances Search AllCurrent Product Search titles only Enter keywords to search documentation
