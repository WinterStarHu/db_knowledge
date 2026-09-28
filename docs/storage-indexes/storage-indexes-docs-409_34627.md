# Managing TencentDB for PostgreSQL Instance

> 来源: https://www.tencentcloud.com/document/product/409/34627

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Getting Started Managing TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Download Focus Mode Font Size Last updated: 2025-09-10 22:08:08 AI-Translated Instance List Page You can log in to the TencentDB for PostgreSQL console and enter the instance list page to view instance information and manage your instances.
﻿ Instance restart Note:
Exercise great caution when restarting a database, which plays a vital role in the business. Before the restart, we recommend you disconnect the database from server and stop writing data.
Restarting an instance does not change its physical attributes, so the public IP, private IP, and any data stored on the instance will remain unchanged.
After the restart, reconnection to the database is needed. Make sure your business has a reconnection mechanism.
Be sure to restart the instance during off-hours so as to ensure success and reduce impact on your business.
In the Instance List, find the instance to be restarted and click More > Restart in the Operation column. You can also select multiple instances and restart them in batches.
Note:
Generally, it takes tens of seconds to a few minutes to restart an instance, during which the instance cannot be accessed and existing connections to it will be closed.
Restart will fail if there are a large number of writes and dirty pages during the restart. In this case, the instance will roll back to the status before the restart and can still be accessed.
There is a chance of failure in restarting a database. If it takes more than 10 minutes to restart, you can submit a ticket for help.
Instance Management Page After a TencentDB for PostgreSQL instance is created, click its ID in the instance list or click Manage in the Operation column to enter the instance management page, where you can view its details, monitor it, and manage its databases.
﻿ Instance details On the Instance Details page, you can view and manage the basic information of the instance. The public network address is disabled by default; to use it, enable it manually.
System monitoring On the System Monitoring page, you can view the monitoring data of various core metrics of the instance, including access, load, cache hit rate, SQL execution latency, XLOG sync delay, etc.
For more information on instance monitoring and alarming, see Monitoring Feature and Alarming Feature.
Parameter settings On the Parameter Settings page, you can modify parameters in batches or individually and query modification records. For more information, see Setting Instance Parameters .
Database management On the Database Management page, there are two modules: database list and account management. You can manage the databases and accounts in the instance separately.
Security group On the Security Group page, you can query security group objects, configure security groups, and preview rules for instances. For more information, see Managing Security Groups.
Note:
Security group outbound rules won't take effect for TencentDB for PostgreSQL, and inbound rules only apply to the private IP and port of TencentDB for PostgreSQL.
Backup management On the Backup Management page, you can view and download backups and xlogs. For more information, see Backing up Data.
Performance optimization On the Performance Optimization page, you can view and download slow logs and error logs.
Read-Only instance On the Read-Only Instance page, you can query and create read-only instances. You can also specify or create an RO group when creating a read-only instance.
Data Security On the Data Security page, you can perform transparent data encryption and SSL encryption, please refer to and for details.
Version Upgrade On the Version Upgrade page, you can perform kernel minor and major version upgrades, as well as view the upgrade history. Please refer to and for details.
Previous Topic: Connecting to TencentDB for PostgreSQL Instance Next Topic: Importing Data Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance List Page Instance restart Instance Management Page Instance details System monitoring Parameter settings Database management Security group Backup management Performance optimization Read-Only instance Data Security Version Upgrade Search AllCurrent Product Search titles only Enter keywords to search documentation
