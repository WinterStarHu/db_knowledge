# Improving TencentDB for MySQL Performance with Read/Write Separation

> 来源: https://www.tencentcloud.com/document/product/236/47009

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Practical Tutorial Improving TencentDB for MySQL Performance with Read/Write Separation Improving TencentDB for MySQL Performance with Read/Write Separation Download Focus Mode Font Size Last updated: 2024-07-23 13:01:32 This document describes how to enable the read/write separation feature through the database proxy service to achieve horizontal scaling and improve the performance of TencentDB for MySQL.
Implementing Read/Write Separation Architecture via Database Proxy ﻿ Database Proxy Database proxy is a network proxy service between the TencentDB service and the application service. It is used to proxy all requests when the application service accesses the database.
The database proxy access address is independent of the original database access address. Requests arriving at the proxy address are all relayed through the proxy cluster to access the source and replica nodes of the database. Read/Write requests are separated, so that read requests are forwarded to read-only instances, which lowers the load of the source database.
Automatic Read/Write Separation Currently, your business may face scenarios such as more reads and less writes as well as unpredictable business loads. In application scenarios with a large number of read requests, a single instance may not be able to withstand the load, potentially affecting the business.
To implement the auto scaling of read capabilities and mitigate the pressure on the database, you can create one or multiple read-only instances and use them to sustain high numbers of database reads. However, this solution requires that businesses can be transformed to support read/write separation, and the code robustness determines the quality of business read/write separation, which imposes high technical requirements and has low flexibility and scalability.
After creating a read-only instance, you can purchase the database proxy service to enable the read/write separation feature. Then, you can configure the database proxy address in your application so as to automatically forward write requests to the source instance and read requests to the read-only instance.
Enabling Read/Write Separation via Database Proxy Step 1. Enable the database proxy
1.
Log in to the TencentDB for MySQL console. In the instance list, select the source instance for which to enable database proxy and click its ID or Manage in the Operation column to enter the instance management page.
2.
On the instance management page, select the Database Proxy tab and click Enable Now.

﻿ ﻿
3.
In the pop-up window, select the specification and node quantity, click OK, and refresh.
Network: Only VPC is supported currently. The VPC of the source instance is selected by default.
Proxy Specification: 2-core 4000 MB memory, 4-core 8000 MB memory, or 8-core 16000 MB memory.
Node Quantity: Number of proxy nodes. We recommend you set the quantity to 1/8 (rounded up) of the total number of CPU cores on the source and read-only instances; for example, if the source instance has 4 CPU cores, and the read-only instance has 8 CPU cores, then the recommended node quantity will be (4 + 8) / 8 ≈ 2.
Connection Pool Status: The connection pool can mitigate excessively high database instance loads caused by frequent new connections in non-persistent connection businesses.
Security Group: It is an important means of network security isolation. You can choose an existing security group or create a new one as needed.
﻿
4.
After successfully enabling the service, you can manage proxy nodes, view their basic information, modify the database proxy address, and adjust configurations on the database proxy page.
Note:
You can view Connections in the proxy node list or view the performance monitoring data of each proxy node to check whether the numbers of connections on the nodes are unbalanced, and if so, you can distribute the connections by clicking Rebalance.
Rebalance will cause proxy nodes to restart, and the service will become unavailable momentarily during the restart. We recommend you restart the service during off-peak hours. Make sure that your business has a reconnection mechanism.
﻿ Step 2. Enable database proxy read/write separation
1.
Log in to the TencentDB for MySQL console.
2.
Select the region at the top of the page and click the ID or Manage in the Operation column of the target instance to enter the instance management page.
3.
On the Database Proxy tab on the instance management page, select the Read/Write Separation tab and click Enable Now.
﻿
4.
In the pop-up window, set the relevant configuration items and click OK.
Note:
Only source and read-only instances that are in Running status can be added to the database proxy.
Currently, remote or delayed read-only instances cannot be mounted to the database proxy.
Remove Delayed RO Instances: Specify whether to enable the removal policy. If a replication exception (such as replication delay or interruption) occurs on a read-only instance, the database proxy will remove the instance out of read/write separation temporarily. The delay threshold is ten seconds by default, and at least one read-only instance should be retained.
Note:
The set Delay Threshold and Least RO Instances take effect only for new connections.
Delay Threshold: Specify the maximum delay allowed when a read-only instance syncs data from the source instance. If the delay of a read-only instance exceeds this threshold, read requests will not be forwarded to it, regardless of its weight. The value must be an integer greater than or equal to 1.
If the delay of a read-only instance exceeds the threshold, the instance will be removed, its weight will be automatically set to 0 after the removal, and the system will send an alarm to you (you should subscribe to the "removal of node mounted to database proxy" alarm first. For the configuration, see Alarm Policies (Cloud Monitor)).
The instance will be put back into the database proxy when its delay falls below the threshold. No matter whether delayed read-only instance removal is enabled, a read-only instance that is removed due to instance failure will rejoin the database proxy when it is repaired.
After Least RO Instances is set, if the database proxy finds that the number of read-only instances being routed is smaller than the set value, it will add abnormal read-only instances to read/write separation until the number of instances in read/write separation is greater than or equal to the set value.
Note:
If a fatal failure (such as downtime) occurs on a read-only instance, it cannot be retained and counted into Least RO Instances.
Least RO Instances: This is the minimum number of instances that should be retained in the RO group. When there are fewer instances in the RO group, even if an instance exceeds the delay threshold, it will not be removed.
Assign Read Weight: Assign read weights to instances. You can select Assigned by system or Custom. Each weight must be an integer between 0 and 100. The configured read weight assignment takes effect immediately for all connections.
The database proxy will assign read request traffic according to the set weights; for example, if weights of two read-only instances are 10 and 20 respectively, their read request traffic will be assigned at a ratio of 1:2.
The weight here refers to the read request weight only, as write requests are directly routed to the source database without participating in weight calculation; for example, if a client sends ten write statements and ten read statements, and the ratio of the source and read-only instance weights is 1:1, the source instance will receive ten write statements and five read statements, and the read-only instance will receive five read statements only.
If you select Assigned by system, the system will automatically assign weights based on the instance's CPU and memory specification, and you can only set the weight of the source instance in this case.
If the weight of a read-only instance is 0, the database proxy will not connect to the instance. If its weight is changed from 0 to another value, the weight takes effect only for new connections.
Failover: Enable or disable this parameter. We recommend you enable this parameter, so the database proxy can send read requests to the source instance if all read-only instances are abnormal.
Note:
The configured failover capability takes effect only for new connections.
Apply to Newly Added RO Instances: Enable or disable this parameter. After it is enabled, if you purchase new read-only instances, they will be automatically added to the database proxy.
If Assign Read Weight is set to Assigned by system, newly purchased read-only instances will be assigned with the default weight based on their specification.
If Assign Read Weight is set to Custom, when newly purchased read-only instances are added to the RO group, their weights will be 0 by default, which can be modified in the configuration of the database proxy's read/write separation.
﻿ Database Proxy Read/Write Separation Enabled After the database proxy read/write separation feature is successfully enabled, the database proxy page is as follows:

﻿ ﻿ References Setting Database Proxy Access Address Switching Database Proxy Network Setting Session-Level Connection Pool Previous Topic: Setting up 2-Region-3-DC Disaster Recovery Architecture Next Topic: Migrating Data from InnoDB to RocksDB with DTS Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Implementing Read/Write Separation Architecture via Database Proxy Database Proxy Automatic Read/Write Separation Enabling Read/Write Separation via Database Proxy Step 1. Enable the database proxy Step 2. Enable database proxy read/write separation Database Proxy Read/Write Separation Enabled References Search AllCurrent Product Search titles only Enter keywords to search documentation
