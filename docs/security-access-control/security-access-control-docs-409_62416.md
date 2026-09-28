# Test Results

> 来源: https://www.tencentcloud.com/document/product/409/62416

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Performance White Paper Test Results Test Results Download Focus Mode Font Size Last updated: 2024-08-09 15:24:42 This document will verify the performance data of TencentDB for PostgreSQL in write-only, read-only and read-write scenarios of Sysbench.
Scenario 1: Full Cache In the full cache scenario, all data can be stored in the cache, so there is no need to read or write the disk to update the cache during the query process.
Write-only Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

25000

64

21308.50

3551.41

4-core 16 GB memory

32

25000

64

139100.86

23183.37

8-core 32 GB memory

64

25000

64

219394.80

36565.50

48-core 480 GB memory

512

25000

256

357198.25

59531.89
Read-only Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

25000

64

26327.01

1645.44

4-core 16 GB memory

32

25000

64

111475.78

6967.24

8-core 32 GB memory

64

25000

64

179257.13

11203.57

48-core 480 GB memory

512

25000

256

346572.52

21660.78
Read-write Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

25000

64

17282.27

864.11

4-core 16 GB memory

32

25000

64

80646.27

4032.31

8-core 32 GB memory

64

25000

64

115549.05

5777.44

48-core 480 GB memory

256

25000

256

173502.17

8675.04
Scenario 2: Big Dataset In the big dataset scenario, all data cannot be stored in the cache (the data size is more than twice the memory size), so the disk needs to be read and written to update the cache during the query process.
Write-only Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

10000000

64

16973.36

2828.89

4-core 16 GB memory

32

10000000

64

64245.25

10707.54

8-core 32 GB memory

64

10000000

64

100686.77

16781.13

48-core 480 GB memory

256

10000000

640

125237.97

20873.00
Read-only Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

10000000

64

14407.49

900.47

4-core 16 GB memory

32

10000000

64

58952.38

3684.52

8-core 32 GB memory

64

10000000

64

87727.56

5482.97

48-core 480 GB memory

512

10000000

640

137603.21

8600.20
Read-write Instance specifications

Concurrency

Single-table data size (table_size)

Total number of tables (tables)

QPS

TPS

1-core 2 GB memory

32

10000000

64

13655.23

682.76

4-core 16 GB memory

32

10000000

64

58426.87

2921.34

8-core 32 GB memory

64

10000000

64

80741.40

4037.07

48-core 480 GB memory

256

10000000

640

114922.98

5746.15
Previous Topic: Test Methods Next Topic: History Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Scenario 1: Full Cache Write-only Read-only Read-write Scenario 2: Big Dataset Write-only Read-only Read-write Search AllCurrent Product Search titles only Enter keywords to search documentation
