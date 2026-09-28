# Introduction

> 来源: https://www.tencentcloud.com/document/product/409/51035

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL ​​API Reference Introduction Introduction Download Focus Mode Font Size Last updated: 2026-06-11 16:01:23

Overview

TencentDB for PostgreSQL enables you to easily set up, operate and scale out the most powerful open-source database PostgreSQL on the cloud. Tencent Cloud is responsible for most complex and time-consuming management tasks, such as PostgreSQL software installation, storage management, high-availability replication, and data backup for disaster recovery, allowing you to focus on business application development.
All TencentDB for PostgreSQL APIs introduced in this chapter comply with the latest OpenAPI 3.0 specification.
You can call APIs to operate TencentDB for PostgreSQL, such as creating an instance, querying the instance list, and modifying the maintenance time window.
For ALL supported API information of TencentDB for PostgreSQL, see API overview.

Glossary

Commonly used terminology for TencentDB for PostgreSQL API interface, see the table below:

Term	Full Name	Description Instance	Instance	Instance refers to a database environment that runs independently in the Tencent Cloud. A database instance may contain multiple user-created databases and can be accessed using the same tools and applications as a standalone database instance..
Region	Region	Indicates the resource region. Each region contains one or more availability zones. For details, please refer to Region and Availability Zone.
Zone	Zone	Refers to a physical data center with independent power and network within the same region in Tencent Cloud. The goal is to ensure fault isolation between availability zones, preventing fault propagation and making continuous online services for the user's business. For details, please refer to Region and Availability Zone.
None	None	A parameter template is a predefined set of database engine configuration values. You can create custom parameter templates to implement custom parameter settings based on your business scenario.
None	None	An RO Group is a collection of read-only instances. A RO Group shares a host address. Additionally, you can set the weight of read-only instances to perform load balancing and set delay removal.

Usage Limits

For API parameters, refer to parameter descriptions in the API documentation.

Previous Topic: History Next Topic: API Category Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Glossary Usage Limits Search AllCurrent Product Search titles only Enter keywords to search documentation
