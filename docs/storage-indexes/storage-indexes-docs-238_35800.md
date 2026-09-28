# Managing TencentDB for SQL Server Instance

> 来源: https://www.tencentcloud.com/document/product/238/35800

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Getting Started Managing TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Download Focus Mode Font Size Last updated: 2026-03-20 15:50:27 AI-Translated Instance List Page Log in to the TencentDB for SQL Server console, and enter the instance list page to view the instance information and manage your instances.
﻿ Feature

Description

Restart

In the instance list, select an instance and click Restart at the top to restart it. You can also select multiple instances for batch restart.
The instance will be inaccessible during the restart, and existing connections to it will be closed.
If the number of business writes is high during the restart, the restart will fail. In this case, the instance will go back to the state before the restart and become accessible.
Restart the instance during off-peak hours to ensure success and minimize the impact on your business.

Renew

In the instance list, select one or more target instances, click Renew to renew them by month or year.

Set Auto-Renewal

In the instance list, select one or more target instances, and click More > Set Auto-Renewal to set monthly auto-renewal for them. After you click OK, the instances will be automatically renewed monthly upon expiration if your Tencent Cloud account balance is sufficient.

Disable Auto-Renewal

In the instance list, select one or more target instances marked with Renew before their name, click More > Disable Auto-Renewal, and click OK.

Edit Tag

You can click More > Edit Tag above the instance list or in the Operation column of an instance to manage its tags. If you haven't created a tag, you can click Tag Management to create one.

Adjust Configuration

In the instance list, you can adjust the configuration of your database instance. Both instance upgrade and disaster recovery mode adjustment are supported. For more information, see Overview.

Publish/Subscribe

In the instance list, you can select More > Publish/Subscribe in the Operation column of an instance to perform publish/subscribe to meet the data replication and sync requirements of your business.

Termination/Return

In the instance list, you can select More > Terminate/Return to terminate/return a database instance. For more information, see Terminating Instance.

Switch to Yearly/Monthly Subscription

You can switch the instances from pay-as-you-go to yearly/monthly subscription. In the instance list, click More > Switch to Yearly/Monthly Subscription in the Operation column, select renewal period, and click OK after reading the rules.

Read-Only Instance

In the instance list, you can click More > Read-Only Instance in the Operation column of an instance to view its read-only instances and configure the RO group. If there are no read-only instances, you can click Create after redirection to add one or more read-only instances.
Instance Management Page Log in to the TencentDB for SQL Server console. In the instance list, click the Instance ID or Manage in the Operation column to access the instance management page, where you can view its details, monitor it, and manage databases.
﻿ Feature

Description

Instance Details

On the Instance Detail tab, you can view and manage various information of your databases, including setting maintenance information and adding read-only instances in the instance architecture diagram.

System Monitoring

On the Instance Monitor tab, you can view the monitoring data of various core metrics of the current database. For more information, please see Monitoring Feature and Alarming Feature.

Backup and Restoration

On the Backup and Restoration tab, you can query the backup and restoration records and create a backup and restoration task. Supported backup upload methods include uploading file and downloading file from COS, and supported restoration modes include full backup file, full backups + logs, and full backups + differential backups.

Publish/Subscribe

On the Publish/Subscribe tab, you can create or delete one or more publish/subscribe linkage services. For details, see Publish-Subscribe.

Security Group

On the Security Group tab, you can configure security groups for your databases. For more information, see Configuring Security Group.

Account Management

On the Account Management tab, you can manage the administrator account, such as modifying permissions and resetting password. You can also create and delete accounts. For more information, see Creating Account.

Database Management

On the Database Management tab, you can create, delete, and set permissions of databases. For more information, see Database Management.

Read-Only Instances

On the Read-Only Instance tab, you can create one or more read-only (RO) instances, which can be applied to read/write separation and one-primary-multiple-replica application scenarios to boost the read load capacity of your databases. For more information, see Read-Only Instance Overview.

Backup Management

On the Backup and Restoration tab, you can manually create, download, and restore backups. You can also set scheduled backups, and perform rollbacks. For more information, see Backup Management.

Operation Log

On the Operation Log tab, you can download the slow logs, enable blocking and deadlock event collection, and query blocking and deadlock event records.

Parameter Configuration

On the Parameter Configuration tab, you can view and modify certain parameters and query the parameter modification logs. For more information, see Parameter Configuration.

Data Security

On the Data Security tab, you can enable transparent data encryption and set up encrypted databases, or enable SSL encryption. For details, see Transparent Data Encryption and Setting SSL Encryption.
Instance Details Page In the instance list, click the Instance ID or Manage in the Operation column to enter the instance management page, and then select the Instance Details page. On the Instance Details page, you can view and manage the instance information such as the instance architecture diagram, corresponding node addresses, storage and backup status, etc.
Single-Node Instance Two-node Instance Multi-node Instances The Instance Details page of a single-node instance is shown below:
﻿ Feature Area

Illustration

Feature

Description

Top information

﻿

Renaming instances

Instance names are primarily used to differentiate and manage SQL Server instances. For details, seeRenaming Instance.

﻿

Migrating across AZs

Migrate the instance to another AZ within the same region. For details, see Migrating Across AZs.

﻿

Switch to Yearly/Monthly Subscription

Switch the instance billing mode from pay-as-you-go to yearly/monthly subscription. For details, see From Pay-as-You-Go to Yearly/Monthly Subscription.

﻿

Renewal Management

Renew instances in the billing mode of yearly/monthly subscription. For details, see Renewal Instructions.

﻿

Tag

You can use the tags to perform classified management on the TencentDB for SQL Server resources. For details, see Setting Instance Tag.

﻿

Switch to Another Project

Assign instances to different projects for management. For details, see Setting Instance Project.

﻿

Instance Remarks

Set or modify instance remarks for easier distinction and management of instances. For details, see Setting Instance Remarks.

﻿

Maintenance cycle and time

Set the maintenance cycle and maintenance time for the instance. For details, see Setting Instance Maintenance Information.

Topology diagram (architecture diagram)

﻿

Primary Node Read-Write Address

You can hover the mouse over the primary node read-write address in the topology diagram to quickly view the private or public network address of the primary node. If the public network address is not enabled, you can click Enable. For details, see Enabling Public Network Address.

﻿

Primary Node

You can hover the mouse over the primary node in the topology diagram to quickly view the instance name and the private or public network address of the primary node. If the public network address is not enabled, you can click Enable. For details, seeEnabling Public Network Address.

﻿

Primary node storage

You can hover the mouse over the primary node storage in the topology diagram to view the storage space usage of the instance. Click Scale-out to enter the configuration adjustment page for setup.

﻿

Local Backup

You can hover the mouse over the local backup in the topology diagram to view the details of local backups, such as total backup, data backup, log backup, and actual occupied space/total free space quota. Click Manage Backup to enter the backup space page for management. For details, see Viewing Backup Space.

﻿

Cross-Region Backup

If cross-region backup is not enabled, you can click the + icon on the cross-region backup in the topology diagram to enable it.
If cross-region backup is enabled, you can hover the mouse over the cross-region backup in the topology diagram to view its detailed usage.

﻿

Topology diagram view scale

You can adjust the display scale of the topology diagram.

Instance information (on the right side)

﻿

Hiding/Showing instance information

You can hide or show the instance information section.

﻿

Primary node information

Under the primary node on the right side, you can view the primary node information such as private network address, public network address, network, configuration, instance status, edition, and architecture.
Operations that can be performed include changing network, enabling public network address, and adjusting configuration.
Related APIs API

Description

﻿DescribeDBInstances﻿

This API is used to query the list of instances.

﻿DescribeDBInstancesAttribute﻿

This API is used to query the attributes of an instance.

﻿DescribeCrossRegionZone﻿

This API is used to query the disaster recovery region and AZ of the secondary node based on the primary instance.

﻿DescribeCollationTimeZone﻿

This API is used to query the character set and time zone supported by the instance.

﻿DescribeFlowStatus﻿

This API is used to query flow status.

﻿DescribeInstanceTasks﻿

This API is used to query the list of asynchronous tasks related to an instance.

﻿ModifyDBInstanceName﻿

This API is used to rename an instance.

﻿ModifyDBInstanceNote﻿

This API is used to modify the instance remarks.

﻿ModifyDBInstanceProject﻿

This API is used to modify the project to which a database instance belongs.

﻿DescribeUpgradeInstanceCheck﻿

This API is used to pre-check the impact of the instance configuration adjustment before the adjustment.

﻿UpgradeDBInstance﻿

This API is used to upgrade an instance.

﻿CompleteExpansion﻿

This API is used to complete the instance upgrade and switch immediately without waiting for the maintenance window when the instance status is "upgrade pending switch" after scale-out is initiated. This API needs to be called during off-peak hours of the instance. Some databases cannot be accessed before the switch is completed.

﻿SwitchCloudInstanceHA﻿

This API is used to manually switch between primary and secondary.

﻿RestartDBInstance﻿

This API is used to restart a database instance.

﻿TerminateDBInstance﻿

This API is used to isolate an instance to move it into a recycle bin.

﻿RenewPostpaidDBInstance﻿

This API is used to recover the pay-as-you-go instance that is manually isolated through the API TerminateDBInstance from the recycle bin.

﻿DeleteDBInstance﻿

This API is used to release SQL server instances (eliminated immediately) in the recycle bin.

﻿ModifyDBInstanceNetwork﻿

This API is used to switch a running instance from a VPC to another.

﻿ModifyOpenWanIp﻿

This API is used to enable the public network for the instance.

﻿ModifyCloseWanIp﻿

This API is used to disable the public network for the instance.
Previous Topic: Connecting to TencentDB for SQL Server Instance from Local System Next Topic: Overview Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Instance List Page Instance Management Page Instance Details Page Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
