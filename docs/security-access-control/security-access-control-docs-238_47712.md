# Read-Only Instance

> 来源: https://www.tencentcloud.com/document/product/238/47712

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Read-Only Instance Read-Only Instance Download Focus Mode Font Size Last updated: 2024-11-11 16:14:34 How do I view a read-only instance in TencentDB for SQL Server?
1.
Log in to the TencentDB for SQL Server console. In the instance list, instances with an R tag are read-only instances. Click the ID of a read-only instance or Manage in the Operation column to enter its details page.
2.
On the primary instance details page, you can enter the read-only instance details page from the topology diagram of the primary instance.
Note： Some features on the read-only instance details page cannot be modified, which actually displays the configurations of the corresponding primary instance. If necessary, you can modify them on the primary instance details page. For details, see Managing Read-Only Instance.
Does TencentDB for SQL Server support read/write separation?
Yes. TencentDB for SQL Server doesn't support unified read/write separation addresses, that is, read and write requests are separated automatically. Currently, the read-only instance needs to be accessed through a separate IP and port. After creating a read-only instance, you need to configure the connection addresses for both the primary instance and each read-only instance in your application. This configuration allows you to send write requests to the primary instance and read requests to the read-only instances. For more information, see Read-Only Instance Overview.
How do I create a read-only instance in TencentDB for SQL Server?
1.
Log in to the TencentDB for SQL Server console. In the instance list, click the ID of an instance or Manage in the Operation column to enter its details page.
2.
Click Add Read-Only Instance in the Instance Architecture Diagram on the instance details page or click Create on the Read-Only Instance page to enter the purchase page. For more information, see Managing Read-Only Instances.
How do I create an RO group in TencentDB for SQL Server?
TencentDB for SQL Server allows you to create one or multiple read-only instances to form an RO group, which is suitable for read/write separation and one-primary-multiple-replica scenarios and capable of greatly enhancing the read load capacity of your database. For more information, see Read-Only Group.
How long is the sync delay between the TencentDB for SQL Server primary and read-only instances?
SQL Server versions earlier than 2017 adopt replication sync, which has a delay of 3–5 seconds. If you use the Always On read-only replica feature of SQL Server 2017 and 2019, the sync delay will be 1–2 seconds.
Is there any difference between the read-only instances of various versions? How do I select the version of TencentDB for SQL Server if a read-only feature is required?
Read-only instances vary by version. If your business requires read-only instances, we recommend that you choose instances on v2017 or later for the following reasons:
On versions earlier than 2017, the publish/subscribe mode is used to create read-only instances, and data can be synced at the object level with a delay of 3–5 seconds. To use read-only instances, we recommend that you upgrade the primary instance to v2017 or later first in order to guarantee an efficient and stable data sync.
In the two-node architecture (formerly high availability/cluster edition) on 2017 Enterprise and later versions, the Always On mode is used to create read-only instances, and data sync is more efficient and stable with a delay of 1–2 seconds.
Can I use accounts created in the primary instance in read-only instances?
Accounts created in the primary instance will be synced to read-only instances but cannot be managed there. They support only read but not write operations in read-only instances.
How many read-only instances can I create for a TencentDB for SQL Server primary instance at most?
You can create up to five read-only instances for a primary instance. To create more, submit a ticket for assistance.
Does TencentDB for SQL Server support data migration to read-only instances?
No.
Do TencentDB for SQL Server read-only instances support database creation/deletion?
No. If needed, do so in the primary instance.
Do TencentDB for SQL Server read-only instances support account creation/deletion?
Read-only instances don't support account creation/deletion/authorization or account name/password change. If needed, do so in the primary instance.
Do TencentDB for SQL Server read-only instances support backup and rollback?
No. If needed, do so in the primary instance.
Do I need to enable load rebalancing after customizing weights in TencentDB for SQL Server?
Modifying weight will only affect new loads if rebalancing is disabled. The operation has no impact on read-only instances accessed by existing persistent connections and does not cause momentary database disconnection. If rebalancing is enabled, all connections to the database will be temporarily disconnected, and the loads of newly added connections will be balanced according to the set weights. You can choose whether to enable load balancing again as needed.
Previous Topic: Publish/Subscribe Next Topic: Version and Architecture Upgrade Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I view a read-only instance in TencentDB for SQL Server?
Does TencentDB for SQL Server support read/write separation?
How do I create a read-only instance in TencentDB for SQL Server?
How do I create an RO group in TencentDB for SQL Server?
How long is the sync delay between the TencentDB for SQL Server primary and read-only instances?
Is there any difference between the read-only instances of various versions? How do I select the version of TencentDB for SQL Server if a read-only feature is required?
Can I use accounts created in the primary instance in read-only instances?
How many read-only instances can I create for a TencentDB for SQL Server primary instance at most?
Does TencentDB for SQL Server support data migration to read-only instances?
Do TencentDB for SQL Server read-only instances support database creation/deletion?
Do TencentDB for SQL Server read-only instances support account creation/deletion?
Do TencentDB for SQL Server read-only instances support backup and rollback?
Do I need to enable load rebalancing after customizing weights in TencentDB for SQL Server?
Search AllCurrent Product Search titles only Enter keywords to search documentation
