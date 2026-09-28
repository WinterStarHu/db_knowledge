# FAQs

> 来源: https://www.tencentcloud.com/document/product/409/40006

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL FAQs FAQs Download Focus Mode Font Size Last updated: 2024-03-20 10:55:09 Why does the used storage space increase while no data is inserted?
This is because of PostgreSQL's Multi-Version Concurrency Control (MVCC) mechanism:
1.
DELETE will not physically delete rows.
2.
UPDATE is implemented by inserting new rows, and expired data will not be physically deleted. Therefore, the used storage capacity can increase even if there is no data inserted.
The autovacuum parameter is enabled by default for TencentDB, and expired data will be automatically repossessed by the kernel, so after the repossession, the used storage space will be released automatically. You can also run the VACUUM command to repossess expired data (in this case, the value of used storage capacity will not decrease immediately; instead, the expired data will be repossessed, and the used storage capacity will be marked reusable). To clear the data completely, you may use the VACUUM FULL command with parameters (this command will lock tables, so we strongly recommend you only use it during maintenance).
For more information on the VACUUM command, see VACUUM.
Why does my CPU utilization exceed 100%?
By default, PostgreSQL adopts the policy of overuse of idle resources that allows your business to preempt some idle CPU resources. Therefore, when the number of CPU cores of your instance exceeds the default value, your CPU utilization may appear to exceed 100% in the monitoring view, which is normal.
However, if your CPU load always exceeds 60%, we recommend you upgrade your instance as soon as possible.
Why is the used disk capacity larger than the actual data volume?
An update can lead to a sharp increase of xlog files, which cannot be archived and deleted in time and hence take up disk capacity. Or, query operations contain ORDER BY and JOIN operations involving massive amounts of data, and during the process, temp tables are generated and overflow to the disk, resulting in a surge in used capacity in a short period of time.
How do I enable or use extensions?
TencentDB for PostgreSQL supports most common extensions for direct use. However, some extensions may require superuser privileges. You can enable them in the Tencent Cloud console or contact us with the instance ID and extension name.
What should I pay attention to when restarting a PostgreSQL instance?
Exercise great caution when restarting a database, which plays a vital role in the business. Before the restart, we recommend you disconnect the database from the server and stop writing data.
Restarting an instance does not change its physical attributes, so the public IP, private IP, and any data stored on the instance will remain unchanged.
After the restart, reconnection to the database is needed. Make sure that your business has a reconnection mechanism.
Restart the instance during off-peak hours to ensure success and minimize the impact on your business.
Generally, it takes tens of seconds to a few minutes to restart an instance, during which the instance cannot be accessed and existing connections to it will be closed.
Restart will fail if there are a large number of writes and dirty pages during the restart. In this case, the instance will roll back to the status before the restart and can still be accessed.
There is a chance of failure in restarting a database. If it takes more than ten minutes to restart, you can contact us for help.
How do I terminate an instance?
You can log in to the TencentDB for PostgreSQL console and manually terminate an instance from the instance list.
How do I upgrade the PostgreSQL version?
TencentDB for PostgreSQL supports self-service major and minor version upgrades via the console. For kernel minor version upgrades, see Upgrading Kernel Minor Version of Database Proxy. For major version upgrades, please consult Upgrading Major Database Version.
﻿

Previous Topic: Standards and Certifications Next Topic: Service Level Agreement Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Why does the used storage space increase while no data is inserted?
Why does my CPU utilization exceed 100%?
Why is the used disk capacity larger than the actual data volume?
How do I enable or use extensions?
What should I pay attention to when restarting a PostgreSQL instance?
How do I terminate an instance?
How do I upgrade the PostgreSQL version?
Search AllCurrent Product Search titles only Enter keywords to search documentation
