# Intelligent Parameter Tuning

> 来源: https://www.tencentcloud.com/document/product/236/47701

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Setting Instance Parameters Managing Parameter Template Comparison of Different Template Parameters Performance Comparison of Parameter Templates Suggestions on Parameter Configuration Intelligent Parameter Tuning Modification Records of System Parameter Templates Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL User Guide Parameter Configuration Intelligent Parameter Tuning Intelligent Parameter Tuning Download Focus Mode Font Size Last updated: 2026-01-12 17:16:52 AI-Translated This document describes how to implement intelligent parameter tuning in the TencentDB for MySQL console.
Background The concept of "deep learning" has been gaining popularity among general users. As relevant technologies are getting more mature, the TencentDB team is thinking about how to use deep learning to improve the operating efficiency of databases. The first thing that comes to mind is database parameter tuning. Due to the huge differences in business systems, it is impossible to perform targeted tuning in a fine-grained manner like optimizing SQL, which is a challenge for DBAs. They often have to draw upon their experience to build a set of better performing parameter templates. The ability to tune database parameters is more like an exclusive skill of expert DBAs.
Between 2019 and 2021, the TencentDB team published two papers entitled "Automatic Database Tuning Using Deep Reinforcement Learning" and "An Online Cloud Database Hybrid Tuning System for Personalized Requirements" respectively, and applied for international patents for the theory. Now, the theory is developed into a usable system based on the papers, which improves the database performance by tuning parameters in real-world use cases.
Why database parameter tuning?
High numbers of parameters: For example, MySQL has hundreds of configuration items, so tuning is difficult.
High labor costs: A full-time DBA is required, and expert experience is needed, which incur high labor costs.
Poor tool universality: Existing tools have limited features and involve time-consuming operations, producing a poor effect.
New requirements in the cloud: Some users don't have a full-time Ops team, making it impossible to implement parameter tuning.
Prerequisites You have a running TencentDB for MySQL instance.
Use Limits Scenario-based intelligent tuning can be performed only three times per instance per month. This limit is reset on the first day of each month.
AI-based intelligent analysis (coming soon) can be performed only once per instance per month. This limit is reset on the first day of each month.
Intelligent parameter tuning can be performed only for instances with at least four CPU cores.
The intelligent parameter tuning task list keeps only the last 15 tuning results.
When an instance is terminated/returned or expires, any ongoing intelligent parameter tuning task in it will be automatically aborted and deleted.
Only one tuning task can be executed per instance at any time.
The intelligent parameter tuning feature currently is supported only in Beijing, Shanghai, and Guangzhou regions and will be available in more regions in the future.
Directions Previously purchased MySQL instance
1.
Log in to the TencentDB for MySQL console and select a region at the top. In the instance list, click an instance ID or Manage in the Operation column to enter the instance management page.
2.
On the instance management page, select Database Management > Parameter Settings > Intelligent Parameter Tuning.
﻿
3.
In the Intelligent Parameter Tuning pop-up window, select Scenario-Based Intelligent Tuning or AI-Based Intelligent Analysis as the tuning method and click Analyze.
﻿ If you select Scenario-Based Intelligent Tuning, follow the steps below:
Scenario-based intelligent tuning: An efficient and targeted intelligent analysis based on your selected scenario.
Select a business scenario in the Scenario drop-down list, which can be Order Transactions, OLTP Performance Test, or Pressure Test.
After selecting a scenario, you can customize the business ratio in the scenario for more accurate system analysis. Then, click Analyze.
Order Transactions (TPCC) Customizable items: Order processing (high), Payment (high), Order query (low), Logistics (low), Warehousing (low) Data Reading Mode: Cache (default), Disk + Cache Concurrency: Low, Middle, High (default) OLTP Performance Test (Sysbench) Customizable items: Reading data (high), Writing data (none by default) Data Reading Mode: Cache (default), Disk + Cache Concurrency: Low, Middle, High (default) Pressure Test (myslap) Concurrency: Low, Middle, High (default) ﻿ If you select AI-Based Intelligent Analysis (coming soon), follow the steps below:
AI-Based Intelligent Analysis: The database business type is determined through in-depth analysis of database operating metrics, the performance of different parameters in specific scenarios is analyzed with deep learning algorithms, and then parameter suggestions are presented.
After selecting AI-Based Intelligent Analysis, click Analyze.
Note： The AI-based intelligent analysis is under improvement and will be available soon.
This is a time-consuming intelligent analysis based on deep learning algorithm and big data analytics. We recommend you perform it during off-peak hours.
4.
The parameter tuning task starts when the analysis starts. You can select Intelligent Parameter Tuning > View Task on the Parameter Settings page to view the task details.
﻿
5.
After the parameter tuning task is completed, you can click View Results in the Operation column in Intelligent Parameter Tuning > View Task.
6.
After confirming the parameter tuning recommendations, click Apply to Instance.
﻿
7.
Confirm the parameter change in the pop-up window, select the Execution Mode, read and indicate your consent to the Restart Rules, and click OK.
Execution mode:
Immediate execution: The change will be applied to the instance immediately after the confirmation.
During maintenance time: The change will be applied to the instance during the maintenance time, which can be modified on the Instance Details page.
Newly purchased MySQL instance When purchasing a TencentDB for MySQL instance, you can enable Scenario-Specific Intelligent Tuning after selecting a parameter template. Once enabled, the system will further fine-tune configurations based on the chosen parameter template and corresponding business scenario. Three business scenarios are supported: transactional scenario, OLTP performance testing, and load testing.
You can view the corresponding modification results in Database Management > Parameter Settings > Intelligent Parameter Tuning > View Task.
﻿ Previous Topic: Suggestions on Parameter Configuration Next Topic: Modification Records of System Parameter Templates Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Background Prerequisites Use Limits Directions Previously purchased MySQL instance Newly purchased MySQL instance Search AllCurrent Product Search titles only Enter keywords to search documentation
