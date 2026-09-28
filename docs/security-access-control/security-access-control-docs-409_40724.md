# Creating TencentDB for PostgreSQL Instance

> 来源: https://www.tencentcloud.com/document/product/409/40724

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Getting Started Creating TencentDB for PostgreSQL Instance Creating TencentDB for PostgreSQL Instance Download Focus Mode Font Size Last updated: 2026-05-08 15:13:44 AI-Translated Prerequisites Have registered a Tencent Cloud account and completed identity verification.
Purchase in the Console
1.
Log in to TencentDB for PostgreSQL purchase page, configure Basic Info, Database Configuration, and Advanced Configuration according to actual requirements. After confirming that everything is correct, click Buy Now.
Basic Info Parameter

Description

Billing Mode

Pay as you go is supported. Pay as you go is suitable for scenarios where demand fluctuates significantly.

Region

Select the region where your business needs to deploy PostgreSQL; it cannot be changed after purchase. It is recommended to keep it consistent with the region of the CVM that needs to be connected to minimize latency.

Primary AZ

AZ refers to physically independent data centers within the same region that have separate power and network resources. Select the primary AZ for the instance. It is recommended to keep it consistent with the CVM to be connected to minimize latency.
Note:
Cloud products in different AZs within the same VPC can interconnect via the private network. For example: a CVM in Guangzhou Zone 3 can access PostgreSQL in Guangzhou Zone 4 via the private network.

Standby AZ

Select the Standby AZ for the instance. It is recommended to keep it consistent with the CVM to be connected to minimize latency.
Note:
Cross-AZ deployment provides higher availability assurance.

Network

Select the network for the instance. It is recommended to keep it consistent with the CVM to be connected to minimize latency.
Note:
The network type selected on the purchase page is VPC, which is a logically isolated network space set up by users on Tencent Cloud. Within a VPC, users can freely define subnet division, IP addresses, and routing policies.
Database Configuration Parameter

Description

Database Engine

The default is PostgreSQL.

Disk Type

Local SSD is used by default. Cloud disk types are also supported. For cloud disk types, see CBS Types.

Architecture

By default, a dual-node high availability architecture (one primary and one standby) is supported.

Database major version

Select the major version of the database. Supported options include: 11, 12, 13, 14, 15, 16, 17, 18. There are feature differences between major versions of PostgreSQL. For details, see the official documentation for each version.

Database Kernel Version

Select the corresponding database kernel version under the database major version. For detailed information about the database kernel version, see Kernel Version Overview.

Instance Specification

Instance Specifications represent different performance levels and price bases.

Disk

Select the disk size for the instance, with a minimum of 10GB and a step size of 10GB. The maximum value of the optional disk depends on the selected instance specifications; please refer to the value on the actual purchase page for accuracy.

Backup Space

A free tier equivalent to 100% of the purchased instance capacity is provided. Usage exceeding the free tier will be billed. For details, see Backup Space Billing.

Instance Name

You can choose to Name It Lafer or Name It Now. Only Chinese characters, English letters, digits, _, and - are supported, with a length limit of less than 60 characters.

Data Replication Mode

You can choose Async or Semi-syn. For an introduction to data replication methods, see Modifying Data Replication Mode.

Character Set

Supported character sets are UTF8 and LATIN1.

Username

Composed of letters (a-z, A-Z), digits (0-9), and underscores (_), beginning with a letter or underscore (_), with a maximum length of 63 characters. Must not use system-reserved keywords, must not be "postgres", and must not begin with "pg_" or "tencentdb_".

Password

Password length must be 8 - 32 characters. It is recommended to use passwords with 12 or more characters. The password cannot start with / and must contain all of the following items:
Lowercase letters a - z.
Uppercase letters A - Z.
Digits 0 - 9.
Special characters ()~!@#$%^&*-+=_|{}[]:<>,.?/

Confirm Password

Re-enter the password.
Advanced configuration Parameter

Description

Security Group

Select an existing security group for the instance, or create a new security group and then select the newly created security group. For an introduction to security groups, see Security Group Overview. To create a new security group, go to Create.

Tag

Facilitates categorizing and managing instance resources.

Project

If you expect different teams to manage different databases, please specify to the projects of different teams.

Enable Encryption

Choose whether to enable Transparent Data Encryption (TDE). This option is disabled by default. For details, see TDE Overview.

Instance Termination Protection

It is disabled by default. After instance termination protection is enabled, you will not be able to terminate instances via the console or API. For details, see Enable Instance Termination Protection.

Quantity

Refers to the number of instances that can be purchased in a single transaction. To prevent accidental operations, we have set a one-time purchase limit of 10. If you wish to purchase more, please complete multiple transactions.

Terms of Service

Read and select the Terms of Service and Refund Policy. For details, see Terms of Service and Refund.
2.
After the purchase is completed, return to the Instance List. Once the instance status changes to Running, you can connect to it.
Purchasing API After purchasing a cloud database via API, refer to CreateInstances. Once it is created, you can connect to it.
Subsequent Operations You can use a standard SQL client to connect to TencentDB for PostgreSQL via a private network address or public network address. For details, see Connecting to TencentDB for PostgreSQL Instance.
Previous Topic: Database Audit Billing Overview Next Topic: Connecting to TencentDB for PostgreSQL Instance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Purchase in the Console Purchasing API Subsequent Operations Search AllCurrent Product Search titles only Enter keywords to search documentation
