# Log Shipping

> 来源: https://www.tencentcloud.com/document/product/236/69312

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Log Shipping Log Shipping Download Focus Mode Font Size Last updated: 2026-09-02 15:40:43 AI-Translated TencentDB for MySQL's SQL Insight (Database Audit) provides the log shipping feature. Through log shipping, it can collect audit logs from TencentDB for MySQL instances and ship them to CLS (Cloud Log Service) for centralized management and analysis. It also supports shipping to Ckafka message queues. After shipping, you can perform real-time stream computing on logs in the Ckafka message queue console. It also supports shipping to COS object storage for archive storage of log data. This document describes how to configure the log shipping feature for SQL Insight (Database Audit) via the console.
Prerequisites If you need to ship to CLS, the prerequisites are as follows.:
Before using this feature, make sure you have activated CLS.
Already enabling the audit service.
The instance status is Running.
If you need to ship logs to TDMQ for CKafka, the prerequisites are as follows:
The CKafka instance has been purchased.
Under the Ckafka instance, add a routing policy.
Already enabling the audit service.
The instance status is Running.
Prerequisites for shipping logs to COS:
Before using this feature, make sure you have activated COS.
Already enabling the audit service.
The instance status is Running.
Supported Versions and Architecture MySQL 5.6 20180101 and later versions.
MySQL 5.7 20190429 and later versions.
MySQL 8.0 20210330 and later versions.
Instance architectures include two-node, three-node, and cloud disk versions.
Billing Overview for Log Shipping The feature of shipping SQL Insight (Database Audit) logs to CLS for TencentDB for MySQL involves the third-party independently billed cloud product CLS. For billing standards, see CLS > Billing Overview.
The feature of shipping SQL Insight (Database Audit) logs to Ckafka message queue for TencentDB for MySQL involves the third-party independently billed cloud product Ckafka message queue. For billing standards, see Ckafka Billing Overview.
The feature of shipping SQL Insight (Database Audit) logs to COS object storage for TencentDB for MySQL involves the third-party independently billed cloud product COS object storage. For billing standards, see Billing Overview.
After the SQL Insight (Database Audit) log shipping feature is enabled for TencentDB for MySQL, traffic fees will be incurred based on the volume of shipped logs. For details, see the table below.
Note:
After the log shipping feature is enabled, traffic fees are incurred. However, regardless of whether you enable one or more log shipping paths (CLS, CKafka, or COS), the system only charges traffic fees incurred by this feature as a whole.
Billable Item: Audit Log Traffic

Chinese Mainland (USD/GB)

Hong Kong (China), other countries and regions (USD/GB)

0.05882353

0.08823529
Description of Log Shipping Traffic Monitoring After enabling the log shipping, you can learn about the real-time shipping traffic generated by log shipping through the monitoring feature.
Monitoring Metric Name

Callable Metric Name

Unit

Metric Description

Shipping traffic

AuditDeliverRate

MB

Shipping traffic generated by the log shipping You can find instances with the log shipping feature enabled in Audit Instance List. Under the Log Shipping field, you can click the monitoring icon to view the monitoring status of the shipping traffic.
Description of Log Shipping Status ﻿ As shown above, on the Database Audit page of the TencentDB for MySQL, the shipping status of the corresponding instance regarding audit logs will be displayed under the Log Shipping field. The specific descriptions for each shipping status are as follows.
Ckafka: Indicates that the SQL Insight (Database Audit) feature of the current instance has enabled log shipping to the Ckafka message queue.
CLS: Indicates that the SQL Insight (Database Audit) feature of the current instance has enabled log shipping to CLS.
Disabled: Indicates that the SQL Insight (Database Audit) feature of the current instance has not been configured for log shipping.
COS: Indicates that the SQL Insight (Database Audit) feature of the current instance has enabled log shipping to COS.
Related Documentation For shipping database audit logs to CLS, to Ckafka message queues, and to COS, see the steps in the following tabs.
Operations Related to Shipping to CLS Shipping to TDMQ for CKafka Operations About Shipping to COS Enabling Log Shipping to CLS
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top. On the Audit Instance page, click Audit Log Storage Status, and select the Enabled option to filter instances with audit enabled.
4.
Find the target instance in the audit instance list (or search for the instance by resource attributes in the search box), and choose More > Configure Log Shipping in the Operation column.
﻿
5.
(Skip this step if CLS has already been activated.) Click go to activate in the pop-up sidebar to activate CLS.
6.
(Skip this step if CLS has already been activated.) Return to the console after activation and click Activation Completed in the pop-up window for activation confirmation.
Note:
During the activation process, the system will verify whether activation is successful. If the system prompts that activation has failed, wait for a while and try again.
7.
(Skip this step if COS has already been authorized.) In the sidebar, click Go to Authorization. Then, in the Service Authorization pop-up window, click Grant.
Note:
During the authorization process, the system will verify whether the service role authorization is successful. If the system prompts that authorization has failed, wait for a while and try again.
8.
Click Enable Now in the Ship to CLS area in the sidebar.
﻿
9.
Complete the following configurations in the pop-up window and click Enable Now.
﻿ Parameter

Description

Destination region

Select the region for log shipping. If CLS supports the region where the database instance resides, this item will default to the instance region (you may select other available regions). If CLS does not support the database instance region, you can select other regions supported by CLS.

Log topic operations

It supports selecting an existing topic or creating one.

Select existing log topic

If the log topic is set to select an existing topic, you need to further select the existing logsets and log topics.
Logset: Logsets classify log topics to facilitate log topic management. You can filter existing logsets in the search box.
Log topic: A log topic is the basic unit for collecting, storing, retrieving, and analyzing log data. You can filter log topics of the selected logset in the search box.
Note:
Log topics that can be selected in this step should be those created with the Create Log Topic option selected for log topic operations when enabling log shipping in the console. Log topics created in the CLS console cannot be selected.

Create Log Topic

If the log topic is set to create a log topic, you need to further customize the log topic and then assign it to an existing logset or a created logset.
Log topic: A log topic is the basic unit for collecting, storing, retrieving, and analyzing log data. You need to create a log topic.
Select the existing logset: The log topic to be created will be added to an existing logset. If you select this option, you can filter existing logsets in the search box.
Create logset: The log topic to be created will be added to a newly created logset. If you select this option, you need to create a logset.
Viewing Log Shipping to CLS After the SQL Insight (Database Audit) feature of shipping logs to CLS is enabled for an instance, you can view the current log shipping status to CLS (view the logset and log topic for log shipping).
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top. On the Audit Instance page, find the target instance (or search for the instance by resource attributes in the search box), and choose More > Configure Log Shipping in the Operation column.
4.
In the pop-up sidebar, view the current log shipping information.
5.
Click the logset name, log topic name, or Search & Analysis to jump to the CLS console to view the details of log shipping.
Disabling Log Shipping to CLS Note:
After disabling log shipping, the shipping of the current instance's Database Audit logs will be stopped. Note that after disabling, only the shipping of newly generated database audit logs will be stopped, and logs shipped to CLS will continue to be stored in the log topic until expiration. During this period, storage fees will be generated continuously. If you want to delete one or more log topics, please go to Log Topic Management.
1.
Log in to the TencentDB for MySQL console.
2.
Select SQL Insight (Database Audit) in the left sidebar.
3.
Select a region at the top. On the Audit Instance page, find the target instance (or search for the instance by resource attributes in the search box), and choose More > Configure Log Shipping in the Operation column.
4.
Click Disable Shipping in the upper right corner of the Shipping to CLS Log area in the pop-up sidebar.
5.
Read the precautions in the pop-up window, select Disable, and click OK.
Appendix 1: Adding a Routing Policy To ship database audit logs to TDMQ for CKafka (CKafka), you need to add a routing policy for the CKafka instance first. Otherwise, an error may occur during log shipping configuration, indicating that CKafka has no routing policy with the route type of Supporting Environment and the access mode of PLAINTEXT. Follow the steps below to add a routing policy.
1.
Log in to the CKafka console.
2.
Click Instance List in the left sidebar and click the ID/name of the target instance to go to the basic information page.
3.
On the Basic Information page, click Add a routing policy in the Access Method section.
4.
In the pop-up window, select Supporting Environment as the route type, select PLAINTEXT as the access method, and click Submit.
Appendix 2: Creating a Bucket When enabling log shipping to COS, you need to select a COS bucket. If no COS bucket exists, you can follow the steps below to create a bucket and then select it.
1.
Click Create Bucket in the dropdown list.
2.
In the pop-up window, complete the following configurations, and click Create.
﻿ Parameter

Description

Region

Select a region of the bucket. You should select a COS region corresponding to the physical region where your business is mainly located for communication with other Tencent Cloud services in the same region via the private network. The region cannot be modified after creation.

Name

Enter a custom bucket name. Only lowercase letters, digits, and hyphens (-) are supported. The total number of characters in the domain name cannot exceed 60. The bucket name cannot be modified once set.

Access Permission

Select the access permission. By default, a bucket is provided with three access permissions: private read/write, public read/private write, and public read/write. The permission can be modified after setting. For details, see ACL.

Bucket tag

Bucket tags are used as identifiers for bucket management. You can set tags for buckets to facilitate group-based bucket management. For details, see Setting Bucket Tags.

Request domain name

This field displays the request domain name after the settings are completed. You can use this domain name to access the bucket.
References Related CLS documents are as follows.:
Logset Managing Log Topics Dashboard Data Processing Search and Analysis Related documents of TDMQ for CKafka are as follows:
Querying Messages Relevant COS documents:
Querying Buckets Clearing Buckets Deleting Buckets ACL Previous Topic: Viewing Audit Log Next Topic: Configuring Post-Event Alarms Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Supported Versions and Architecture Billing Overview for Log Shipping Description of Log Shipping Traffic Monitoring Description of Log Shipping Status Related Documentation Appendix 1: Adding a Routing Policy Appendix 2: Creating a Bucket References Search AllCurrent Product Search titles only Enter keywords to search documentation
