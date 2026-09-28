# Product Feature List

> 来源: https://www.tencentcloud.com/document/product/409/76907

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Product Introduction Product Feature List Product Feature List Download Focus Mode Font Size Last updated: 2026-07-03 12:17:32 AI-Translated This article introduces the supported features of TencentDB for PostgreSQL to help you better understand the product features.
Supported Features List Feature Attributes

Function Name

Architecture: Dual-Node High Availability Edition

Database configuration

Supported Versions

PostgreSQL 11 PostgreSQL 12 PostgreSQL 13 PostgreSQL 14 PostgreSQL 15 PostgreSQL 16 PostgreSQL 17 PostgreSQL 18

Number of Nodes

2 (one primary and one secondary)

Memory/Disk

Up to 960GB/16000GB

Creation and Lifecycle Management

Creating an Instance

Supported

CreateReadOnlyDBInstances

Supported

Terminating an Instance

Supported

Recovering an Instance

Supported

Decommissioning an Instance

Supported

Instance management

Setting the Instance Maintenance Window

Supported

Adjusting the Instance Configuration

Supported

Setting Instance AZ-level DR or Region-level DR

Supported

Restarting an Instance

Supported

Modifying the Data Replication Method

Supported

Switch the Instance Between Primary and Secondary

Supported

Task List

Supported

Version upgrade

Upgrading the Kernel Minor Version

Supported

Upgrading the Database Major Version

Supported

Elastic scaling

CPU Elastic Scale-Out

Supported (submit a ticket)

Account management

Creating an Account

Supported

Resetting the Password

Supported

Modifying Remarks

Supported

Modify Type

Supported

Modifying Permissions

Supported

Delete account

Supported

Lock/Unlock Account

Supported

Database management

CreateDB

Supported

Modify OWNER

Supported

database resource isolation

Supported (PostgreSQL 14, 15, 16 and kernel minor version ≥ v14.11_r1.21, v15.6_r1.10, v16.2_r1.3)

Parameter management

Configuring Instance Parameters

Supported

Parameter Template

Supported

Log management

Slow Query Analysis

Supported

Error Log

Supported

Operation Log Management

Supported

Log Delivery

Supported

Backup and restoration

Backup Data

Supported

Auto Backup Settings

Supported

Viewing Backup Space

Supported

Setting Backup Download Rules

Supported

Downloading Backup Files

Supported

Clone Instance

Supported

Restoring PostgreSQL Data on Cloud Servers

Supported

Using SCF to Archive PostgreSQL Historical Backups

Supported

Rolling back to the original instance

Supported

Deleting backups

Supported

Restoring Deleted Instances from Backups

Supported

Data Migration/Synchronization

DTS-based logical migration

Supported

DTS-based physical migration

Supported

DTS-based Data Synchronization

Supported

Plugin

Supported Plugin Versions Overview

Supported

Creating a Plugin

Supported

pg_roaringbitmap Plugin

Supported

Network management.

Modifying Network

Supported

Enabling Public Network Address

Supported

Enabling Public Network Service via CLB

Supported

Data security

Enabling Transparent Data Encryption

Supported

Configuring SSL Encryption

Supported

Security Group

Supported

Database Audit

Supported (kernel minor version ≥ v11.12_r1.14, v12.7_r1.15, v13.3_r1.12, v14.2_r1.15, v15.1_r1.7, v16, v17, v18)

Monitoring and alarms

Monitoring

Supported

Alarm

Supported

AI-related

AI Large Model Invocation

Supported

Vector and Graph Search

Supported

Multi-Agent Long-Term Memory

Supported

AI for DB Intelligent Ops

Supported

AI Vibe Coding

Supported

Supabase-Related

Supported

Database Cloning

Supported (PostgreSQL 18)

Self-developed kernel feature

Logical replication slot failover

Supported

Asynchronous invalid buffer

Supported

Process Monitoring

Supported

SQL Throttling

Supported (kernel minor version ≥ v14.11_r1.23, v15.6_r1.12, v16.2_r1.6)

Using starrocks_fdw to Achieve Read/Write Splitting

Supported (PostgreSQL 13 and kernel minor version ≥ v13.14_r1.17)

Automatic Cache Eviction

Supported (kernel minor version ≥ v13.20_r1.21, v14.17_r1.29, v15.12_r1.15, v16.8_r1.9, v17.4_r1.3)

Index Invalidation

Supported (kernel minor version ≥ v11.22_r1.34, v12.22_r1.36, v13.22_r1.31, v14.19_r1.40, v15.14_r1.25, v16.10_r1.20, v17.6_r1.14, v18.1_r1.4)

WAL Log Source Analysis (tencentdb_wal_stat)

Supported Previous Topic: Regions and AZs Next Topic: Major Version Lifecycle Description Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Supported Features List Search AllCurrent Product Search titles only Enter keywords to search documentation
