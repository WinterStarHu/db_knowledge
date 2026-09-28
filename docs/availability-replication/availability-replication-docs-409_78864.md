# How to use failover slot for logical replication

> 来源: https://www.tencentcloud.com/document/product/409/78864

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases How to use failover slot for logical replication How to use failover slot for logical replication Download Focus Mode Font Size Last updated: 2026-04-15 15:47:04 AI-Translated Background Logical replication slot (logical replication slot) is a mechanism in PostgreSQL for logical replication, ensuring that logical subscribers can receive change data starting from a specified LSN (Log Sequence Number) to prevent data loss. TencentDB for PostgreSQL implements failover slot through self-developed kernel capability, enabling cross-region failover in high-availability scenarios. This guarantees replication slot continuity and data consistency during primary-standby switch. For detailed feature description, see Logical Replication Slot Failover (Failover Slot).
This article will explain the creation and usage steps of failover slot.
Prerequisites Two TencentDB for PostgreSQL instances located in the same VPC serve as the primary node and standby node respectively.
The major versions of the two instances must be the same, and both should be within the 11-16 range.
Operation Steps
1. primary node creates publication
Log in to the primary instance and run the following command to create a publication. In this example, the publication is named pub_1, and the table to be published is table_1.
CREATE PUBLICATION pub_1 FOR TABLE table_1;
Note:
When a slot is created, the system defaults to creating a failover slot, and automatically creates a failover slot with the same name as the subscription during subscription creation. For specific details, see Creating Failover Slots.
2. Create a subscription on the standby node
Log in to the standby node and sequentially run the following commands to create a subscription. In this example, the subscription is named sub_1.
Note:
Before a subscription is created, ensure that the standby node has created a table with the same schema as table_1 that the publication connects to.
-- Create a subscription create subscription sub_1 connection 'instanceid=postgres-***** host=*.*.*.* port=5432 dbname=database_name user=user_name password=****** access_type=1' publication pub_1;
The description of parameters in the command is as follows:
instanceid: The instance ID of the primary instance, which can be obtained from the instance list in the Console.
host: The private IP address of the primary node instance.
port: The connection port number, default 5432.
dbname: The name of the database where the publication of the primary instance is located.
user: The username that can be used on the primary instance.
password: The account password that can be used on the primary instance.
access_type: Set to 1, indicating that the target instance is a TencentDB instance.
After the standby database creates a subscription, the failover slot will be automatically transferred to the standby node following a primary-standby switch, requiring no additional configuration for slot migration.
3. Verify the result
Checking the replication slot status Execute the following on the primary instance:
SELECT slot_name, slot_type, active FROM pg_replication_slots WHERE slot_name = 'sub_1';
If the active value is true, it indicates that the failover slot is in use.
Check data synchronization After data is inserted into the primary database, if querying table_1 in the standby database shows the newly inserted data, then the failover_slot is functioning properly.
Primary-standby switch verification After the Primary-Standby Switch is clicked on the Instance Details page, if repeating the query on the new primary database yields consistent results with the previous query, then the standby database subscription remains functional and the failover_slot is operating normally.
﻿ Previous Topic: Read-Only Instance and Read-Only Group Practical Tutorial Next Topic: How to Use SCF for Scheduled Database Operations Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Background Prerequisites Operation Steps
1. primary node creates publication
2. Create a subscription on the standby node
3. Verify the result
Checking the replication slot status Check data synchronization Primary-standby switch verification Search AllCurrent Product Search titles only Enter keywords to search documentation
