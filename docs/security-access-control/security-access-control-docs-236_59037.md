# Commercial Billing and Activity Description for Database Proxy

> 来源: https://www.tencentcloud.com/document/product/236/59037

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Billing Commercial Billing and Activity Description for Database Proxy Commercial Billing and Activity Description for Database Proxy Download Focus Mode Font Size Last updated: 2024-02-23 10:14:46 The database proxy is a network proxy service between TencentDB and the application service, serving to delegate all requests made by the application service as it accesses the database. The database proxy offers advanced features such as automatic read/write separation, transaction split, and connection pool, featuring high availability, outstanding performance, maintainability, and user-friendly operation. This document will provide you with a guide to the commercial billing and activities of TencentDB for MySQL's database proxy.
I. Commercial Billing Overview Billing Time Billing for the TencentDB for MySQL database proxy will start on April 1, 2024, at 16:00:00 Beijing Time.
Billing Mode At present, only pay-as-you-go billing is supported.
Pricing for Database Proxy TencentDB for MySQL database proxy adopts pay-as-you-go billing, where the billing item is CU. The pricing of the database proxy varies by region, as displayed in the table below.
Note:
The term CU refers to the minimum billing specification of the database proxy (i.e. the price for a 2-core proxy specification with 4,000 MB memory). There are three specifications for the database proxy node: a 2-core one with 4,000 MB memory, a 4-core one with 8,000 MB memory, and an 8-core one with 16,000 MB memory. These correspond to 1 CU, 2 CU, and 4 CU respectively.
Region

Price (USD/CU/Hour)

Shanghai, Nanjing, Chongqing, Chengdu, Guangzhou, Beijing

0.06865672

Hong Kong (China)

0.11492537

Mumbai, Jakarta, Virginia, Bangkok, Tokyo, Singapore, Seoul, Toronto, Frankfurt, Silicon Valley, São Paulo

0.11791045

Shenzhen Finance, Beijing Finance, Shanghai Finance

0.11641791
Note:
The regions displayed above represent all the regions where the current instance supports deployment. Some regions do not yet support the database proxy feature. The regions that do support it include Beijing, Shanghai, Guangzhou, Shanghai Finance, Beijing Finance, Chengdu, Chongqing, Nanjing, Hong Kong (China), Tokyo, Bangkok, Virginia, Silicon Valley, Mumbai, Seoul, and Singapore.
Database Proxy Fees Formula Database proxy fees = (customer-selected proxy node specification/a 2-core one with 4,000 MB memory) x number of nodes x unit price x usage duration Example:
If a customer activates a database proxy in the Beijing region and sets four 8-core proxy specifications with 16,000 MB memory, thereby using a total of 28 hours, then at this moment the cost of the customer's database proxy corresponds to:
(an 8-core one with 16,000 MB memory/a 2-core one with 4,000 MB memory) x 4 x 0.06865672 USD x 28 = 30.7582106 USD II. Discount Overview TencentDB for MySQL Database proxy's business billing policy, including any applicable discounts for both new and existing customers, is detailed as follows.
Definition Noun

Description

Existing Customer

TencentDB for MySQL will record the proxy's initiation case at the time of official commercial billing time (on April 1, 2024, at 16:00:00 Beijing time). Customers possessing effective proxy nodes at this moment will be considered as existing customers.

New Customer

As of the official commercial billing time (on April 1, 2024, at 16:00:00 Beijing time), TencentDB for MySQL will record the activation status of the database proxy. Any customers who have no proxy node in operation as of this time will be considered as new customers.
Note:
Customers who previously activated a database proxy before the start of official commercial billing but deactivated it before the official billing times are also new customers.

Total Discounted Volume

For existing customers: Total Discounted Volume refers to the database proxy's total amount of discount, which is automatically calculated based on the customer's actual database proxy activation status as recorded at the official commercial billing time (on April 1, 2024, at 16:00:00 Beijing time).
For new customers: The discounted scope for each Tencent Cloud UIN account is limited to 3 instances, each of which is equipped with a total discounted volume of a 32-core one with 64,000 MB memory (16 CU).
Discount for Existing Customers After the billing starts, the total discounted volume for the existing customers' database proxy can continue to be used for a trial period of three months. Subsequently, three months later (on July 1, 2024, at 16:00:00), these database proxy specifications will be charged at the regular service price.
Promotions in Discounted Period Scenario

Description

Example (Take the instance with a total discounted volume of a 16-core one with 32,000 MB memory as an example.)

Adjusting the node specifications

After the adjustment of the total discounted volume in the instance, the corresponding database proxy node can be used for free for three months from the official billing time.

Adjusting the node specification to an 8-core one with 16,000 MB memory. The instances that do not exceed the total discounted volume still enjoy the free promotions.

After the adjustment, if the total discounted volume of the instance exceeds the discount limit, an additional fee will be charged for the surplus.

Adjusting the node specification to a 32-core one with 64,000 MB memory. The instances that exceed the total discounted volume with the exceeding portion (a 16-core one with 32,000 MB memory) require payment, while the remainder is free.

Adjusting the number of nodes

After the adjustment of the total discounted volume in the instance, the corresponding database proxy node can be used for free for three months from the official billing time.

Reducing the number of nodes from four to two, and adjusting the total proxy specifications from a 16-core one with 32,000 MB memory to an 8-core one with 16,000 MB memory. The instances that do not exceed the total discounted volume still enjoy the free promotions.

After the adjustment, if the total discounted volume of the instance exceeds the discount limit, an additional fee will be charged for the surplus.

Increasing the number of nodes from four to five, and adjusting the total instance proxy specification from a 16-core one with 32,000 MB memory to a 20-core one with 40,000 MB memory. The instances that exceed the total discounted volume with the exceeding portion (a 4-core one with 8,000 MB memory) require payment, while the remainder is free.

Adjusting the Availability Zone

Only the Availability Zone is adjusted, and the proxy specification does not change. The corresponding database proxy node is free for three months from the official billing time.

The switch from Beijing Zone 6 to Beijing Zone 7 does not affect the proxy specifications. The proxy specifications within the total discounted volume of the instance continue to enjoy the free promotions.

Adjusting the Kernel Minor Version of Database Proxy

Only the version is adjusted, and the proxy specification does not change. The corresponding database proxy node is free for an additional three months after official billing begins.

Database proxy minor version upgraded from 1.3.7 to 1.3.8, and the proxy specifications remain unchanged. Under the total instance discount amount, the proxy specification continues to enjoy free promotions.

Returning Instances

When returning the discounted instances, the discount qualification ceases to apply.

-

Refunds do not apply to instances that did not receive a discount; since the instance itself did not receive any discount, there is no consideration regarding any discounted changes.

- Discount for New Customers Starting from the official billing time, a Tencent Cloud UIN account is eligible to enjoy a 15-day free trial of database proxy features for three instances. Additionally, the total discounted volume for each instance's database proxy node is up to a 32-core one with 64,000 MB memory.
Promotion Details Table Scenario

Description

Example (Take the instance with a total discounted volume of a 32-core one with 64,000 MB memory as an example.)

Adjusting the number of nodes

After the adjustment of the total discounted volume in the instance, the corresponding database proxy node can experience a 15-day free trial when the database proxy is activated.

Reducing the number of nodes from four to two, and adjusting the total proxy specifications from a 32-core one with 64,000 MB memory to a 16-core one with 32,000 MB memory. The instances that do not exceed the total discounted volume still enjoy the free promotions.

After the adjustment, if the total discounted volume of the instance exceeds the discount limit, an additional fee will be charged for the surplus.

Increasing the number of nodes from four to five, and adjusting the total instance proxy specification from a 32-core one with 64,000 MB memory to a 40-core one with 80,000 MB memory. The instances that exceed the total discounted volume with the exceeding portion (an 8-core one with 16,000 MB memory) require payment, while the remainder is free.

Adjusting the node specifications

After the adjustment of the total discounted volume in the instance, the corresponding database proxy node is free for 15 days from the official billing time.

Adjusting the node specification to an 8-core one with 16,000 MB memory. The instances that do not exceed the total discounted volume still enjoy the free promotions.

After the adjustment, if the total discounted volume of the instance exceeds the discount limit, an additional fee will be charged for the surplus.

Adjusting the node specification to a 40-core one with 80,000 MB memory. The instances that exceed the total discounted volume with the exceeding portion (8-core one with 16,000 MB memory) require payment, while the remainder is free.

Adjusting the Availability Zone

Only the Availability Zone is adjusted, and the proxy specification does not change. The corresponding database proxy node is free for 15 days from the official billing time.

The switch from Beijing Zone 6 to Beijing Zone 7 does not affect the proxy specifications. The proxy specifications within the total discounted volume of the instance continue to enjoy the free promotions.

Adjusting the Kernel Minor Version of Database Proxy

Only the version is adjusted, and the proxy specification does not change. The corresponding database proxy node is free for an additional 15 days after official billing begins.

Database proxy minor version upgraded from 1.3.7 to 1.3.8, and the proxy specifications remain unchanged. Under the total instance discount amount, the proxy specification continues to enjoy free promotions.

Returning Instances

When returning the discounted instance, the discount qualification for that instance concurrently ceases to apply, reducing the count of discounted instance qualifications under the same UIN account by one.

For the instance under UIN account 1000*23412, after the activation of a new database proxy, the instance would lose its eligibility for offers upon refund. This leads to the decrement of the instance count, eligible for offers under this UIN account, by one leaving only two instances eligible for ongoing offers.

Refunds do not apply to instances that did not receive a discount; since the instance itself did not receive any discount, there is no consideration regarding any discounted changes.

- III. Bill Description You can inquire about the charges incurred by employing the TencentDB for MySQL Database proxy service via the Billing Center in Tencent Cloud Console, which aids your understanding of the billing situation for using this feature. For the specific query operation, see Viewing Bills.
﻿

Previous Topic: Database Audit Billing Overview Next Topic: Description of the Database Proxy Billing Cycle Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page I. Commercial Billing Overview Billing Time Billing Mode Pricing for Database Proxy Database Proxy Fees Formula II. Discount Overview Definition Discount for Existing Customers Discount for New Customers III. Bill Description Search AllCurrent Product Search titles only Enter keywords to search documentation
