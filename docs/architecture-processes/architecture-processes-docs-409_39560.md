# Billing Overview

> 来源: https://www.tencentcloud.com/document/product/409/39560

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Billing Billing Overview Billing Overview Download Focus Mode Font Size Last updated: 2026-05-08 15:13:44 AI-Translated Billing Mode TencentDB for PostgreSQL supports the postpaid mode:
Billing Mode

Payment Mode

Scenarios

Pay-as-you-go

Postpaid mode, where you first apply for resources on demand and are billed based on your actual resource usage during settlement.

It is suitable for business senarios with large instantaneous fluctuations in business volume. The instance can be released immediately after use to save costs.
Billing Formula Total cost = Specification cost + Storage space cost + Backup space cost (billed for usage exceeding the free quota) + Log space cost (currently free) + Traffic cost (currently free).
Billing Item Billable Item

Description

Instance specification fees

The fee for the instance specifications selected on the purchase page supports a tiered pay-as-you-go pricing model. For the price, see Product Pricing. The pay-as-you-go mode implements a three-tier pricing structure: the longer the usage, the greater the discount. Tier 1 (T1): 0 hours < T1 ≤ 96 hours; Tier 2 (T2): 96 hours < T2 ≤ 360 hours; Tier 3 (T3): T3 > 360 hours.

Storage space fees

The fee for the disk size selected on the purchase page supports pay-as-you-go pricing. For the price, see Product Pricing.

Backup space fees

For local disk instances, a free tier equivalent to 100% of the purchased instance capacity is provided. Usage exceeding the free tier will be billed. For the price, see Backup Space Billing. For cloud disk edition instances, a free tier equivalent to 200% of the purchased instance capacity is provided. Usage exceeding the free tier will be billed. For the price, see Cloud Disk Edition Backup Billing.

Log storage space fees

A free tier equivalent to 50% of the instance capacity is provided. Usage exceeding the free tier is currently free of charge.

Traffic fees

Public network traffic fees are currently free of charge.
You can directly use the Pricing Calculator to view the combined price of the products you need, in order to estimate resource costs. To ensure the accuracy of the obtained price, please log in to Tencent Cloud before viewing.
Pay-as-you-go Tiered Pricing Table Tier

Time Range

Tier 1

≤ 4 days

Tier 2

> 4 days, ≤ 15 days

Tier 3

> 15 days
Example: If a user's instance is in pay-as-you-go mode and has been used for 30 days, the fees for the first 4 days (96 hours) are charged at the first-tier price, for the period beyond 4 days up to 15 days (264 hours) at the second-tier price, and for the period beyond 15 days up to 30 days (360 hours) at the third-tier price.
Billing Examples [Pay-as-you-go Example]: For example, you purchase a pay-as-you-go TencentDB for PostgreSQL instance in the Jakarta region, with a primary instance specification of 16 cores and 32 GiB and a 500 GB hard disk, and use it for 400 hours.
The fees to be paid are calculated as follows:
Stage 1 cost: (USD 2.357/hour + 500 GB × USD 0.00024/GB/hour) × 96 hours = USD 237.792.
Stage 2 cost: (USD 1.767/hour + 500 GB × USD 0.00024/GB/hour) × 264 hours = USD 498.168.
Stage 3 cost: (USD 1.178/hour + 500 GB × USD 0.00024/GB/hour) × 40 hours = USD 51.92.
Instance cost = Stage 1 cost + Stage 2 cost + Stage 3 cost = USD 787.88.
﻿

Previous Topic: Function Description Next Topic: Instance Type and Specification Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Billing Mode Billing Formula Billing Item Pay-as-you-go Tiered Pricing Table Billing Examples Search AllCurrent Product Search titles only Enter keywords to search documentation
