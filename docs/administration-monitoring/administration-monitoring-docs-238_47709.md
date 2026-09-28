# Monitoring and Alarms

> 来源: https://www.tencentcloud.com/document/product/238/47709

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Monitoring and Alarms Monitoring and Alarms Download Focus Mode Font Size Last updated: 2024-01-18 17:25:32 How do I view the monitoring data of a TencentDB for SQL Server instance?
TencentDB for SQL Server supports 38 common metrics of SQL Server. For more information, see Monitoring Metrics. You can also collect statistics of other metrics by configuring the counters of SSMS.
You can view and stay up to date with instance conditions on monitoring charts as instructed in Viewing Monitoring Charts. You can also set alarm policies, configure alarm notifications, and view alarm records in Tencent Cloud Observability Platform (TCOP) for 38 monitoring metrics about CPU, memory, storage, network, connection, access, and lock. For example, you can configure alarms in Alarm Management > Policy Management > Create Policy in the TCOP console.
Where can I view monitoring charts in TencentDB for SQL Server?
We provide a wide variety of performance monitoring metrics and convenient monitoring features (such as custom view, time comparison, and merged monitoring metrics). You can view and stay up to date with instance conditions by going to the System Monitoring page in the TencentDB for SQL Server console, as instructed in Viewing Monitoring Charts.
What monitoring metrics are supported by TencentDB for SQL Server?
TencentDB for SQL Server supports 38 common metrics of SQL Server. For more information, see Monitoring Metrics. You can also collect statistics of other metrics by configuring the counters of SSMS.
How do I set an alarm policy for TencentDB for SQL Server?
You can create an alarm policy in the TCOP console. An alarm will be triggered and notifications will be sent if the status of a monitoring metric of TencentDB for SQL Server becomes abnormal. For more information, see Setting Alarm Policies.
How do I associate an alarm policy with an alarm object in TencentDB for SQL Server?
You can create an alarm policy in the TCOP console and associate it with an alarm object. If the object meets the alarm trigger condition, an alarm will be triggered. For more information, see Setting Alarm Policies.
How do I set alarm notifications for TencentDB for SQL Server?
After creating an alarm policy, you can configure an alarm notification template and alarm notifications in the TCOP console. After the configuration is completed, if an alarm is triggered by an exception, the system will send notifications to the recipients via the specified channels (email, SMS, and phone call). For more information, see Setting Alarm Notification.
How do I view alarm records in TencentDB for SQL Server?
You can view detailed alarm records in the console and quickly locate specific problems through alarm messages for further troubleshooting. For more information, see Viewing Alarm Records.
What is the minimum monitoring granularity in TencentDB for SQL Server?
The minimum monitoring granularity in TencentDB for SQL Server is 10 seconds, and the time range automatically changes with the granularity.
Which monitoring metrics of a TencentDB for SQL Server instance should I stay up to date with?
You need to pay attention to the following monitoring metrics: CPU utilization, memory utilization, and percentage of remaining disk space. You can configure alarm notifications based on your actual business scenario, so that alarms will be triggered and notifications will be sent if the status of a monitoring metric of TencentDB for SQL Server becomes abnormal. When receiving an alarm, you can take applicable measures to resolve it. For more information, see Setting Alarm Policies.
Sample configuration: If the CPU utilization reaches a certain value (such as 80%) for multiple times (such as five times) within a certain period of time (such as five minutes), an alarm will be triggered (once an hour, for example).
Previous Topic: Disk Space and Specification Adjustment Next Topic: Log-Related Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page How do I view the monitoring data of a TencentDB for SQL Server instance?
Where can I view monitoring charts in TencentDB for SQL Server?
What monitoring metrics are supported by TencentDB for SQL Server?
How do I set an alarm policy for TencentDB for SQL Server?
How do I associate an alarm policy with an alarm object in TencentDB for SQL Server?
How do I set alarm notifications for TencentDB for SQL Server?
How do I view alarm records in TencentDB for SQL Server?
What is the minimum monitoring granularity in TencentDB for SQL Server?
Which monitoring metrics of a TencentDB for SQL Server instance should I stay up to date with?
Search AllCurrent Product Search titles only Enter keywords to search documentation
