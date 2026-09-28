# Overdue Payments

> 来源: https://www.tencentcloud.com/document/product/409/34624

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Billing Overdue Payments Overdue Payments Download Focus Mode Font Size Last updated: 2026-02-09 11:45:09 AI-Translated Note:
If you are a customer of a Tencent Cloud partner, the rules regarding resources when there are overdue payments are subject to the agreement between you and the partner.
Balance Reminder We will estimate the number of days it takes your account balance to become negative based on the usage in the past 24 hours and current balance. If it is less than five days, we will send a reminder to your Tencent Cloud account creator and all the collaborators via email and SMS.
Overdue Payment Reminder For pay-as-you-go resources, fees are deducted on the hour. When your account balance is in negative, we will notify the Tencent Cloud account creator and all the collaborators via email and SMS.
Overdue Payment Processing Starting from the moment your account becomes negative:
You can continue to use your database for 2 hours from the moment your account becomes negative. We will also continue to bill you for this period.
After your account has been overdue for 2 hours, your database instance will automatically shut down. We will also stop billing you for service.
After automatic shutdown:
Within 24 hours after automatic shutdown, if your account is not topped up to a positive balance, you will not be able to start your database; If your balance is positive, the billing continues, and you can start your database.
If your account remains negative for 24 hours after shutdown, the database will be repossessed, and all data will be deleted and cannot be recovered.
We will notify the Tencent Cloud account creator and all the collaborators via email and SMS when the database is repossessed.
When you do not use pay-as-you-go resources any longer, terminate them as soon as possible to avoid further fee deduction.
After the database is terminated or repossessed, the data will be deleted and cannot be recovered.
Since your actual resource consumption changes from time to time, some deviation may exist for the stated balance.
Previous Topic: Purchase Methods Next Topic: Refund Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Balance Reminder Overdue Payment Reminder Overdue Payment Processing Search AllCurrent Product Search titles only Enter keywords to search documentation
