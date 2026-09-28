# Connecting to TencentDB for PostgreSQL Instance

> 来源: https://www.tencentcloud.com/document/product/409/34626

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Getting Started Connecting to TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Download Focus Mode Font Size Last updated: 2026-09-17 21:11:57 AI-Translated & Reviewed You can connect to TencentDB for PostgreSQL using a standard SQL client via a private network address or a public network address.
Private Network Connection: Use a CVM to access the private network address automatically assigned to the cloud database. This connection method uses a high-speed private network, resulting in low latency. We recommend that the CVM and the database belong to the same account and reside within the same VPC (ensuring the same region) or both reside within the basic network.
Note:
For CVMs and databases under different VPCs (including same/different accounts, same/different regions), see Peering Connection for private network connection methods.
Public Network Connection: Connect to TencentDB for PostgreSQL via a public network address.
Note:
A public network connection requires enabling the public network address of the database instance. This operation will expose your database service to the public network, potentially leading to intrusion or attacks on the database. We recommend that you use private network access to log in to the database.
Public network connections for cloud databases are suitable for development or auxiliary database management tasks. They are not recommended for use by formal business access because uncontrollable factors, such as DDoS attacks or sudden high-traffic access, may cause public network access to become unavailable.
Public network access addresses can be enabled only for primary instances in Beijing, Chengdu, Chongqing, Guangzhou, Hong Kong (China), Nanjing, Seoul, Shanghai, Singapore, Tokyo, Frankfurt, Virginia, and Silicon Valley. This feature is not supported for read-only instances.
This section describes how to connect to TencentDB for PostgreSQL from a CVM running Windows or Linux, using either a private or public network connection.
Connecting from a Windows CVM Instance
1.
Log in to a Windows CVM or work locally to download and install a standard SQL client.
Note:
This document uses pgAdmin as an example. You can download the installation program for a compatible version based on your system. For the download address, see pgAdmin.
2.
Select Object > Create > Server from the top of pgAdmin.

﻿ ﻿
3.
In the Create - Server dialog box, enter the name, host IP address, port number, username, password, and other details, and then click Save.
Host IP address and port number: You can view them on the TencentDB for PostgreSQL console under the Private IPv4/IPv6 Address or Public IPv4/IPv6 Address on the instance details page. If the public network address is not enabled, see Enable Public Network Address to enable it.
Note:
The private network address here is a VIP. Access to the database instance is uniformly handled through the access gateway cluster, rather than by connecting directly to the physical server of the database instance. Therefore, the private IP address remains unchanged during host failures or primary-standby switches.
Username and password: Use the database administrator username and password set during instance initialization. If you forget the password, you can reset it on the console account management page.
﻿
4.
After you log in to the database, choose Databases > postgres in the left sidebar to view the connected server (database instance).
﻿ Connecting from a Linux CVM Instance
1.
Log in to a Linux CVM or install a psql client from a yum repository on your local Linux server.
2.
To install the psql client, follow the instructions in Install PostgreSQL Database. The psql client will be installed automatically upon successful installation of PostgreSQL.
3.
Run the following command to log in to the PostgreSQL database.
psql -U username -h access_address -p port -d postgres Note:
If you are using a CVM within the same VPC as the database, you can directly use the database's private network address for access. If you are using a Linux server on the public internet, you must use the database's public network address for access.
Appendix: Enable Public Network Access Address
1.
Log in to the TencentDB for PostgreSQL console. On the instance list page, click the instance ID or Manage in the Operation column to go to the instance details page.
2.
On the instance details page, locate Public IPv4 Address under Basic Info, and click Enable.
﻿
3.
After you click OK in the pop-up dialog box, the public network activation enters the processing state.
4.
After the public network is successfully enabled, you can view the public network address in the Basic Info section.
Previous Topic: Creating TencentDB for PostgreSQL Instance Next Topic: Managing TencentDB for PostgreSQL Instance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Connecting from a Windows CVM Instance Connecting from a Linux CVM Instance Appendix: Enable Public Network Access Address Search AllCurrent Product Search titles only Enter keywords to search documentation
