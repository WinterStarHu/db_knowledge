# Instance Type

> 来源: https://www.tencentcloud.com/document/product/238/46494

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Product Introduction Instance Type Instance Type Download Focus Mode Font Size Last updated: 2026-07-30 17:20:55 AI-Translated A database instance is the smallest management unit of TencentDB for SQL Server and an independently running database environment within Tencent Cloud. One instance represents an independently running TencentDB for SQL Server. You can create, modify, and delete cloud database instances through the console, and you can create and manage multiple databases within a single instance.
This document introduces the database instance types of TencentDB for SQL Server.
Instance Type Categories and Descriptions Instance Type

Introduction

Usage Instructions

Single-node instance

Single-node (formerly Basic Edition) instance

It employs a single-node database deployment architecture, contains only one node, and offers a lower usage cost.
It features a decoupled compute and storage architecture, with underlying data stored on cloud disks using a triple-replica mechanism.
The basic edition node is deployed on a CVM, delivering better database performance compared to self-built solutions.
The storage medium uses high-performance cloud disks, which are widely applicable to various I/O scenarios and deliver stable performance.

Suitable for personal learning, ISV software for small and medium-sized enterprises, Web applications, non-core small-scale enterprise systems, and testing environments. The single-node architecture consists of a single node and lacks primary/secondary automatic failover capability. Fault recovery typically relies on instance rebuild and data restoration, and the recovery time may be longer than that of high-availability architectures.

Primary/Replica instance

Two-node (formerly HA Edition/Cluster Edition) instance with a one-primary-one-replica architecture.

Supports SQL Server 2012/2014/2016 Enterprise and SQL Server 2012/2014/2016 Standard editions. It consists of a one-primary-one-mirror SQL Server database. The classic one-primary-one-secondary architecture is adopted, with the specifications of each node in the primary/replica instances being consistent. The primary and secondary nodes are deployed cross-rack or cross-AZ. Each database corresponds to a set of monitoring agents, which perform real-time monitoring of the database through heartbeat. Cross-AZ high availability is supported. The primary AZ and secondary AZ should be selected to be in different AZs. COS: Provides data disaster recovery services and cold backup data. Tencent Cloud management cluster: Consists of independently deployed decision scheduling clusters and configuration clusters, serving as the management and scheduling center for the cluster. It primarily manages the normal operation of database node groups, access gateway clusters, and COS.

The standby instance enhances the reliability of the instance. During the creation of a primary instance, a standby instance is created synchronously. Once the standby instance is successfully created, it is not visible to users.
When the primary node fails, a switch between primary and secondary occurs automatically. The database client experiences a brief interruption and must support reconnection.
Data replication between SQL Server primary/secondary nodes is asynchronous by default. Similarly, replication between the primary instance and read-only instances is also asynchronous by default.

SQL Server 2017/2019/2022/2025 Enterprise edition adopts the Always On architecture (including one-primary-one-secondary), supports adding up to five read-only instances, builds a cluster mode, and offers higher availability, reliability, and scalability. The primary and secondary nodes are deployed cross-rack or cross-AZ. Each database corresponds to a set of monitoring agents, which perform real-time monitoring of the database through heartbeat.

Suitable for industry applications such as gaming, healthcare, pharmaceuticals, internet, IoT, retail, e-commerce, logistics, insurance, securities, media, technical services, and automotive.

Multi-node instance with a one-primary-multiple-replica architecture (2 to 5 replica databases can be selected)

Supports SQL Server 2017/2019/2022/2025 Enterprise edition and adopts a one-primary-multiple-secondary architecture. Replica nodes provide disaster recovery. After enabling replica node read-only, they can also provide a replica node read-only address for read capability. Standby databases can be deployed across different AZs, which helps reduce the impact of data center-level failures on business.

Suitable for business systems with high availability requirements, such as the financial industry and the e-commerce industry; suitable for business scenarios involving large-scale data processing, such as big data analysis and log processing.

RO instance

Read-only instances

A single-node (without standby) instance that can support read requests. A read-only instance cannot exist independently. Each read-only instance belongs to an RO group and must be bound to a primary instance (two-node) for use. An RO group is a read-only instance group with CLB functionality.

A read-only instance is a single-node edition. After a physical server failure or database replication exception occurs, the instance requires a relatively long time to be rebuilt and recovered, depending on the data volume.
For business scenarios that heavily rely on read operations, it is recommended to create multiple read-only instances to distribute the database read load.
Note:
You can create and manage various types of instances through the TencentDB for SQL Server console.
Documentation Engines and Versions Feature Overview and Differences ﻿

Previous Topic: Features and Differences Next Topic: Specification Type Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance Type Categories and Descriptions Documentation Search AllCurrent Product Search titles only Enter keywords to search documentation
