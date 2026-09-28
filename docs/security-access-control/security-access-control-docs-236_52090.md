# Authorizing Sub-User to Use Database Audit

> 来源: https://www.tencentcloud.com/document/product/236/52090

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL SQL Insight (Database Audit) Authorizing Sub-User to Use Database Audit Authorizing Sub-User to Use Database Audit Download Focus Mode Font Size Last updated: 2026-05-28 10:37:20 AI-Translated By default, sub-users do not have permission to use MySQL SQL Insight (Database Audit). Therefore, you need to create a policy to allow sub-users to use this feature.
If you do not need to manage sub-user access to resources related to MySQL SQL Insight (Database Audit), you can skip this document.
CAM (Cloud Access Management, CAM) is a set of Web services provided by Tencent Cloud. It is primarily used to help users securely manage access permissions to resources under their Tencent Cloud accounts. Through CAM, you can create, manage, and delete users (or groups), and control which Tencent Cloud resources specified users can access via identity and policy management.
When using CAM, you can associate policies with a user or a group of users. Policies can grant or deny permissions for users to access specific resources and perform designated tasks. For more fundamental information on CAM policies, see Policy Syntax.
Grant Permissions to Sub-Users
1.
Log in to the CAM console as a root account, select the corresponding sub-user from the user list, and click Authorize.
﻿
2.
In the pop-up dialog box, select the QcloudCDBFullAccess or QcloudCDBInnerReadOnlyAccess preset policy, click OK, to complete the sub-user authorization.
Note:
MySQL SQL Insight (Database Audit) is a sub-module of MySQL databases. Therefore, the two preset policies for MySQL mentioned above cover the permission policies required by MySQL SQL Insight (Database Audit). If a sub-user only needs the permissions required for MySQL SQL Insight (Database Audit), refer to Custom MySQL SQL Insight (Database Audit) Policy.
﻿ Policy Syntax The CAM policy for MySQL SQL Insight (Database Audit) is described as follows:
{ "version":"2.0", "statement":
[ { "effect":"effect", "action":["action"], "resource":["resource"] } ] } version: Required. Currently, only the value 2.0 is allowed.
statement: Used to describe detailed information about one or more permissions. This element includes permissions or permission sets for multiple other elements such as effect, action, and resource. A policy contains exactly one statement element.
effect: A required field that describes whether the result of the statement is "allow" or "deny". The possible values are allow and deny.
action: A required field used to describe allowed or denied operations. Operations can be APIs (described with the name prefix) or feature sets (a specific set of APIs described with the permid prefix).
resource: A required field that describes the specific data for authorization.
API Operations In a CAM policy statement, you can specify any API operation from any service that supports CAM. For SQL Insight (Database Audit), use APIs prefixed with `name/cdb:`. To specify multiple operations within a single statement, separate them with commas, as shown below:
"action":["name/cdb:action1","name/cdb:action2"] You can also use a wildcard to specify multiple operations. For example, you can specify all operations whose names start with the word "Describe", as shown below:
"action":["name/cdb:Describe*"] Resource path The general format of resource paths is as follows:
qcs::service_type::account:resource service_type: Abbreviation for the product, which is cdb in this context.
account: The root account information of the resource owner, such as uin/326xxx46.
resource: the specific resource details of the product, each MySQL instance (instanceId) is a resource.
Example:
"resource": ["qcs::cdb::uin/326xxx46:instanceId/cdb-kf291vh3"] cdb-kf291vh3 is the ID of the MySQL instance resource, which is the resource in the CAM policy statement.
Examples The following examples are provided solely to demonstrate CAM usage. For the complete API of MySQL SQL Insight (Database Audit), see the API Documentation.
{ "version": "2.0", "statement": [ { "effect": "allow", "action": [ "name/cdb: DescribeAuditRules" ], "resource": [ "*" ] }, { "effect": "allow", "action": [ "name/cdb: CreateAuditPolicy" ], "resource": [ "*" ] }, ﻿

{ "effect": "allow", "action": [ "name/cdb: DescribeAuditLogFiles" ], "resource": [ "qcs::cdb::uin/326xxx46:instanceId/cdb-kf291vh3" ] } ] } Customizing a MySQL SQL Insight (Database Audit) Policy
1.
Log in as the primary account to the CAM console, in the policy list, click Create Custom Policy.
﻿
2.
In the pop-up dialog box, select Create by Policy Generator.
3.
On the Select Service and Operation page, select the required configurations, and click Next.
Effect: Select Allow or Deny. If Deny is selected, the user or user group cannot obtain authorization.
Service: Select TencentDB for MySQL (cdb).
Action: Select all APIs for MySQL SQL Insight (Database Audit). For details, see the API Documentation.
Resource: See Resource Description Method, select all resources, which means you can operate the audit logs of all MySQL instances.
Condition: Optional, which configures the effective conditions for the above authorization.
﻿
4.
On the Associate User/User Group/Role page, enter the "Policy Name" (e.g., SQLAuditFullAccess) and "Description" according to naming conventions, then click Complete.

﻿ ﻿
5.
After returning to the policy list, you can view the newly created custom policy.
Previous Topic: Viewing Audit Task Next Topic: Introduction to TencentDB for MySQL Cluster Edition Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Grant Permissions to Sub-Users Policy Syntax API Operations Resource path Examples Customizing a MySQL SQL Insight (Database Audit) Policy Search AllCurrent Product Search titles only Enter keywords to search documentation
