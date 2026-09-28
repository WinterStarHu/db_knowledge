# Backup Space Billing

> 来源: https://www.tencentcloud.com/document/product/409/55351

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Billing Backup Space Billing Backup Space Billing Download Focus Mode Font Size Last updated: 2026-03-31 17:17:19 AI-Translated Overview The backup space is used to store the backup files (automatic data backups, manual data backups, and log backups) of all TencentDB for PostgreSQL instances in a region. TencentDB for PostgreSQL offers a free tier of backup capacity based on the region. During the beta test of the backup billing, the free tier is equivalent to 700% of the total storage capacity of all the primary instances in your region, but the multiple will change to 100% after the backup billing official starts. For calculation examples, see Calculation Formula.
Note:
Free backup space is only available when you purchase a primary instance.
The backup space can be viewed on the database backup page in the [TencentDB for MySQL console].
Comparison of the free tier between during beta test and official start of the backup billing Billed Period

Free Tier

During the beta test of backup billing

700% of storage space

After the backup billing officially starts

100% of storage space Backup pricing Backup space in excess of the free tier is priced at 0.000118 USD/GB/hour in the Chinese mainland and 0.000133 USD/GB/hour outside the Chinese mainland.
If the excessive backup space is less than 1 GB, no fees will be charged. If the time period is less than one hour, it will be calculated as one hour. TencentDB for PostgreSQL adopts a flexible giveaway policy, so you generally don't need to pay for the backup space for most instances.
Billing schedule for backup space From 00:00 on July 1, 2023, the beta test of backup billing will officially carried out in all regions.
From 0:00 on August 1, 2023, the backup billing will be officially carried out in all regions.
Calculation formula During the beta test of backup billing:
Free backup capacity in one region = Sum of storage capacity of all TencentDB for PostgreSQL primary instances in that region * 700% Paid backup capacity in one region = Data backup volume + log backup volume - free backup capacity (all values are for that region) After the backup billing officially starts:
Free backup capacity in one region = Sum of storage capacity of all TencentDB for PostgreSQL primary instances in that region * 100% Paid backup capacity in one region = Data backup volume + log backup volume - free backup capacity (all values are for that region) Billing examples After the backup billing officially starts, the calculation method is as follows:
You have purchased three instances in Guangzhou region, named A, B, and C, and their configurations are as follows:
A (Running):
1-Primary-1-standby, 4-core 8 GB memory per node, 200 GB storage Backup space occupied: 5000 GB B (Running):
1-Primary-1-standby, 4-core 8 GB memory per node, 300GB storage Backup space occupied: 200GB C (Isolated):
1-Primary-1-standby, 4-core 8 GB memory per node, 200GB storage Backup space occupied: 100GB The calculation formulas for free backup space, occupied paid space, and occupied free space are as follows:
Free backup space = (backup space purchased by A + backup space purchased by B + backup space purchased by C)  100% = (200+300+200)  100% = 700 GB.
Occupied paid space = paid space occupied by A + paid space occupied by B + paid space occupied by C = (5000-200) + 0 + 0 = 4800 GB.
Occupied free space = free space occupied by A + free space occupied by B + free space occupied by C = 200 + 200 + 100 = 500 GB.
Note The free space occupied by an instance is the minimum value of purchased and occupied storage for the instance.
The paid space occupied by an instance is the excess beyond the purchased storage space. If the occupied space does not exceed the purchased space, the paid space of the instance is 0.
During the beta test of the backup billing, the calculation method is as follows:
You have purchased three instances in Guangzhou region, named A, B, and C, and their configurations are as follows:
A (Running):
1-Primary-1-standby, 4-core 8 GB memory per node, 200 GB storage Backup space occupied: 5000GB B (Running):
1-Primary-1-standby, 4-core 8 GB memory per node, 300GB storage Backup space occupied: 200GB C (Isolated):
1-Primary-1-standby, 4-core 8 GB memory per node, 200 GB storage Backup space occupied: 100GB The calculation formulas for free backup space, occupied paid space, and occupied free space are as follows:
Free backup space = (backup space purchased by A + backup space purchased by B + backup space purchased by C)  100% = (200+300+200)  700% = 4900 GB.
Occupied paid space = paid space occupied by A + paid space occupied by B + paid space occupied by C = (5000-200 * 7) + 0 + 0 = 3600 GB.
Occupied free space = free space occupied by A + free space occupied by B + free space occupied by C = (200 * 7) + 200 + 100 = 500 GB.
Backup lifecycle Backups are not subject to change over the instance lifecycle.
After an instance is moved into the recycle bin, the automatic backup continues. Rollback and manual backup are not allowed, but backups can be downloaded. The excess beyond the free tier is still billed.
After the instance is terminated, the backup data will not be deleted, and the system will continue to provide you with 7-day free quota. If you no longer need the backup data of this instance, you can delete it by yourself, and the data cannot be recovered after deletion.
Note When a pay-as-you-go instance is terminated, the system will provide you with an additional "final" full physical backup to avoid nonrecovery events due to misoperation. The "final" backup capacity is not included in the backup space statistics, hence no fees are charged. You can download it in the data backup list. The "final" physical backups are automatically deleted seven days after the instance is terminated.
Overdue payments Pay-as-you-go instance If your account has overdue payments, the backup service is downgraded, manual backup and backup download are not allowed, but automatic backup continues, where excessive backup space is still billed. Backups are not subject to change over the instance lifecycle. For more information, see Backup Lifecycle.
Suggestions for reducing backup costs Delete unnecessary manual backup Reduce the backup frequency for non-core businesses. You can adjust the backup cycle in the console, and the frequency should be at least twice a week.
Previous Topic: Refund Next Topic: Database Audit Billing Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Comparison of the free tier between during beta test and official start of the backup billing Backup pricing Billing schedule for backup space Calculation formula During the beta test of backup billing:
After the backup billing officially starts:
Billing examples Backup lifecycle Overdue payments Pay-as-you-go instance Suggestions for reducing backup costs Search AllCurrent Product Search titles only Enter keywords to search documentation
