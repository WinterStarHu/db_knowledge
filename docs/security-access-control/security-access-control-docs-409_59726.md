# Enabling the Audit Service

> 来源: https://www.tencentcloud.com/document/product/409/59726

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Database Audit Enabling the Audit Service Enabling the Audit Service Download Focus Mode Font Size Last updated: 2026-09-04 14:38:03 AI-Translated TencentDB for PostgreSQL supports Database Audit, which records database access and SQL statement execution, helping enterprises control risks and improve data security.
Use Cases Address audit risks Incomplete audit logs make it difficult to trace and locate security incidents.
It fails to meet the explicit requirements of Multi-Level Protection Scheme (Level 3).
It cannot meet the requirements of industry information security compliance documents.
Address management risks Accidental operations, unauthorized operations, and privilege escalation by technical personnel compromise the secure running of business systems.
Accidental operations, malicious operations, and tampering by third-party development and maintenance personnel.
Super administrator permissions are overly broad and cannot be audited or monitored.
Address technical pain points SQL injection into the database system can maliciously pull database and table information.
A sudden surge in database requests that is not caused by slow logs makes rapid troubleshooting difficult.
Fee Instructions For TencentDB for PostgreSQL audit fees, see Database Audit Billing.
Supported Versions Database Audit for TencentDB for PostgreSQL supports primary instances and read-only instances in dual-server high availability (one primary and one standby) deployments running PostgreSQL v11.12_r1.14, v12.7_r1.15, v13.3_r1.12, v14.2_r1.15, v15.1_r1.7, v16, or v17 and later. To enable full Database Audit for historical TencentDB for PostgreSQL instances, upgrade the minor kernel version first.
Prerequisites Note:
Enabling or disabling the audit service requires a database restart. Please note this.
Operation Steps
1.
Log in to the TencentDB for PostgreSQL console.
2.
In the left sidebar, select Database Audit.
3.
After selecting a region at the top, go to the Audit Instance page and click Audit Status to view the list of instances with audit enabled or disabled.
﻿
4.
Locate the target instance in the audit instance list. You can also use the search box to filter by resource attributes for quick access. In the Operation column, click Enable Database Audit.
Note:
You can enable the audit service in batches. On the Audit Instance page, select multiple target instances and click Enable Database Audit at the top to go to the settings page.
﻿
5.
On the Enable Database Audit page, complete Select Audit Instance, Audit Rule Settings, and Audit Service Settings in sequence. Read and select Tencent Cloud Service Agreement, and click OK.
5.1
Select Audit Instance Under Audit Instance Selection, the system selects the instances chosen in Step 4 by default. You can modify the instance selection in this window (select other instances or multiple instances) or use the search box to quickly find target instances by instance ID or name. After completing the instance selection, go to Audit Rule Settings.
﻿
5.2
Audit Rule Settings Under Audit Rule Settings, only Full Audit is currently supported. In full audit mode, the system records all database accesses and SQL statement executions. Audit logs support Express Audit and Detailed Audit. For more information, see Audit Service Description. After completing the audit rule settings, go to the audit service settings.
5.3
Audit Service Settings Under Audit Service Settings, set Log Retention Period and Ultra-High-Performance Storage/Infrequent Access Storage Duration, read and select Tencent Cloud Service Agreement, and then click OK to enable the audit service.
Parameter

Description

Log Retention Period

Set the retention period for audit logs. Unit: days. Supported values: 7, 30, 90, 180, 365, 1090, and 1825 days.

Ultra-High-Performance Storage Duration

Ultra-high-performance storage represents an ultra high performance storage medium with the best query performance. Unit: day. After setting the Storage Duration, audit data within the specified duration will be stored in ultra-high-performance storage. When data exceeds its specified period in ultra-high-performance storage, it will automatically transition to infrequent access storage. Different storages support the same audit capabilities, only differing in performance. For example: If the Log Retention Period is set to 30 days, and the Ultra-High-Performance Storage Duration is set to 7 days, then the Infrequent Access Storage Duration defaults to 23 days.
Previous Topic: Audit Service Description Next Topic: View Audit Logs Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Use Cases Fee Instructions Supported Versions Prerequisites Operation Steps Search AllCurrent Product Search titles only Enter keywords to search documentation
