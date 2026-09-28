# Instance Type and Specification

> 来源: https://www.tencentcloud.com/document/product/409/43453

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Billing Instance Type and Specification Instance Type and Specification Download Focus Mode Font Size Last updated: 2026-09-20 14:30:15 AI-Translated & Reviewed A database instance is a database environment that runs independently in Tencent Cloud. A database instance can contain multiple databases created by users and can be accessed using the same tools and applications as a standalone database instance.
Instance Types TencentDB for PostgreSQL provides the following two types of database instances:
Instance Type

Definition

Architecture

Disk Type

Visible in Instance List or Not

Function

Primary Instance

Instance that can read and write

High-Availability Edition

Local SSD disk Cloud disk

Yes

Has the full features of TencentDB for PostgreSQL. Primary instances with local SSD storage can attach read-only instances, while primary instances with cloud disks do not currently support attaching read-only instances.

Read-only instances

Instance that provides read-only functionality

Single-node read-only

Local SSD

Yes

Read-only instances cannot exist independently and must belong to a primary instance (with local SSD storage). Their only data source is data synchronized from the primary instance. They can only be in the same region as the primary instance. By default, a single primary instance can create up to 6 read-only instances.
Related Information For the creation operations and considerations of read-only instances, see Create Read-Only Instance.
For creating and configuring a read-only instance RO group, see Manage Read-Only Instance RO Group.
Note:
When the actual used capacity of an instance exceeds its purchased capacity, the instance is automatically locked. After being locked, the instance supports only read operations and cannot accept write operations. Please configure capacity alarms.
Supported Specifications for Instances with Local SSD Disks Edition

Version

Specification Type

CPU and Memory

Disk Capacity

Maximum Number of Connections

Maximum IOPS

Dual-machine high availability (one primary and one secondary) instance, read-only instance

11,12,13,14,15,16,17,18

General - local high-performance SSD

1core 2GiB

10GB - 3000GB

2048

1200

2core 4GiB

10GB - 3000GB

2048

4000

2core 6GiB

10GB - 3000GB

2048

6000

4core 8GiB

10GB - 3000GB

2048

8000

4core 16GiB

10GB - 4000GB

2048

14000

6core 24GiB

10GB - 4000GB

2048

16000

8core 16GiB

10GB - 4000GB

2048

20000

8core 32GiB

10GB - 4000GB

4000

28000

8core 48GiB

10GB - 4000GB

4500

30000

8core 64GiB

10GB - 4500GB

5500

36000

12core 24GiB

10GB - 8000GB

2048

36000

12core 64GiB

10GB - 8000GB

5500

38000

16core 32GiB

10GB - 8000GB

4000

32000

16core 96GiB

10GB - 8000GB

8000

40000

20core 128GiB

10GB - 8000GB

10000

40000

24core 48GiB

10GB - 8000GB

4500

32000

24core 192GiB

10GB - 8000GB

12000

60000

28core 240GiB

10GB - 8000GB

13000

60000

32core 64GiB

10GB - 8000GB

5500

60000

32core 128GiB

10GB - 8000GB

10000

72000

48core 480GiB

10GB - 8000GB

22000

120000

64core 256GiB

10GB - 8000GB

13000

120000

64core 384GiB

10GB - 8000GB

20000

150000

64core 512GiB

10GB - 8000GB

22000

150000

90core 720GiB

10GB - 8000GB

36000

150000

128core 720GiB

10GB - 8000GB

36000

150000

156core 960GiB

10GB - 8000GB

40000

150000 Note:
Shanghai Zone 2, Shanghai Zone 3, Shanghai Zone 4, Shanghai Zone 5, Shanghai Zone 6, Shanghai Zone 7, Shanghai Zone 8, Guangzhou Zone 4, Guangzhou Zone 6, and Guangzhou Zone 7 support larger storage specifications: the 48-core 480GiB configuration supports a maximum disk capacity of 16,000 GB.
Supported Specifications for Instances with Cloud Disks Note:
The CBS resources supported in different regions (Premium Disk, Cloud SSD, and Enhanced SSD) may vary. For the specific supported resources, refer to the configuration on the actual purchase page.
Edition

Database Major Version

Specification Type

CPU and Memory

Disk Capacity

Maximum Number of Connections

Dual-server high availability (one primary and one standby) instance

13,14,15,16,17,18

General-purpose - Premium Disk General-purpose - Cloud SSD General-purpose - Enhanced SSD

1core 2GiB

20GB - 32000GB

2048

2core 4GiB

20GB - 32000GB

2048

2core 6GiB

20GB - 32000GB

2048

4core 8GiB

20GB - 32000GB

2048

4core 16GiB

20GB - 32000GB

2048

6core 24GiB

20GB - 32000GB

2048

8core 16GiB

20GB - 32000GB

2048

8core 32GiB

20GB - 32000GB

4000

8core 48GiB

20GB - 32000GB

4500

8core 64GiB

20GB - 32000GB

5500

12core 24GiB

20GB - 32000GB

2048

12core 64GiB

20GB - 32000GB

5500

16core 32GiB

20GB - 32000GB

4000

16core 96GiB

20GB - 32000GB

8000

20core 128GiB

20GB - 32000GB

10000

24core 48GiB

20GB - 32000GB

4500

24core 192GiB

20GB - 32000GB

12000

28core 240GiB

20GB - 32000GB

13000

32core 64GiB

20GB - 32000GB

5500 Previous Topic: Billing Overview Next Topic: Purchase Methods Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance Types Related Information Supported Specifications for Instances with Local SSD Disks Supported Specifications for Instances with Cloud Disks Search AllCurrent Product Search titles only Enter keywords to search documentation
