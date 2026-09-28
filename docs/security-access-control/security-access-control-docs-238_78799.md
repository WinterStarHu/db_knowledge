# Authorizing Sub-User to Use Database Audit

> 来源: https://www.tencentcloud.com/document/product/238/78799

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Database Audit Authorizing Sub-User to Use Database Audit Authorizing Sub-User to Use Database Audit Download Focus Mode Font Size Last updated: 2026-04-21 15:06:49 AI-Translated By default, sub-users do not have permission to use the Database Audit feature of TencentDB for SQL Server. Therefore, users need to create policies to allow sub-users to use Database Audit.
If you do not need to manage access to Database Audit-related resources for sub-users, you may ignore this document.
CAM (Cloud Access Management, CAM) is a suite of Web services provided by Tencent Cloud, primarily designed to help users securely manage access permissions to resources under their Tencent Cloud accounts. Through CAM, you can create, manage, and delete users (or groups), and control which Tencent Cloud resources specified users can access via identity management and policy management.
When using CAM, you can associate policies with a user or a group of users. Policies can grant or deny permissions for users to access specific resources and perform designated tasks. For more fundamental information on CAM policies, see Policy Syntax.
Grant permissions to the sub-user
1.
Log in to the CAM console as the primary account, select the corresponding sub-user in the user list, and click Authorize.
﻿
2.
In the pop-up dialog box, select the QcloudSQLServerFullAccess TencentDB for SQL Server Full Read/Write Access Permissions or QcloudSQLServerReadOnlyAccess TencentDB for SQL Server Read-Only Access Permissions preset policy, click OK to complete the sub-user authorization.
Note:
The Database Audit feature is a submodule of TencentDB for SQL Server. Therefore, the two preset permission policies for TencentDB for SQL Server mentioned above cover the permission policies required for Database Audit. If sub-users only need the permissions required for TencentDB for SQL Server Database Audit, they can refer to Custom TencentDB for SQL Server Database Audit Policy.
﻿ Policy Syntax The CAM policy for Database Audit is described as follows:
{ "version":"2.0", "statement":
[ { "effect":"effect", "action":["action"], "resource":["resource"] } ] } version: Required. Currently, only the value 2.0 is allowed.
statement: Describes the details of one or more permissions. This element includes permissions or permission sets for multiple other elements such as effect, action, and resource. A policy contains exactly one statement element.
effect: A required field that describes whether the result of the statement is "allow" or "deny". The possible values are allow and deny.
action: A required field that describes the allowed or denied operations. Actions can be APIs (prefixed with "name") or feature sets (specific API groups prefixed with "permid").
resource: Required. Describes the specific data for authorization.
API Operations In CAM policy statements, you can specify any API operation from any service that supports CAM. For Database Audit, use APIs prefixed with `name/sqlserver:`. To specify multiple operations in a single statement, separate them with commas, as follows:
"action":["name/sqlserver:action1","name/sqlserver:action2"] You can also use wildcards to specify multiple actions. For example, you can specify all actions whose names start with the word "Describe", as follows:
"action":["name/sqlserver:Describe*"] Resource path The general format of resource paths is as follows:
qcs::service_type::account:resource service_type: The product abbreviation, which is sqlserver here.
account: The root account information of the resource owner, such as uin/326xxx46.
resource Example:
"resource": ["qcs::sqlserver::uin/326xxx46:instanceId/mssql-ia**ym7b"] Where mssql-ia**ym7b is the ID of the TencentDB for SQL Server instance resource, which corresponds to the resource in the CAM policy statement.
Customize TencentDB for SQL Server Database Audit Policy.
1.
Log in to the CAM console as the primary account, navigate to the policy list, and click Create Custom Policy.
﻿
2.
In the pop-up dialog box, select Create by Policy builder.
3.
On the page for selecting services and operations, select the desired configurations and click Next.
Effect (Effect): Select Allow or Deny. If Deny is selected, users or user groups cannot obtain authorization.
Service (Service): Select TencentDB for SQL Server (sqlserver).
Action (Action): Select all APIs for TencentDB for SQL Server Database Audit. See API Documentation.
Resource (Resource): See Resource Descriptor, select all resources, indicating that audit logs for all TencentDB for SQL Server instances can be operated.
Condition (Condition): Optional. Set the effective conditions for the above authorization.
4.
On the Associate Users/User Groups/Role page, enter "policy name" (such as SQLAuditFullAccess) and "description" according to naming conventions, then click Complete.
﻿
5.
Return to the policy list to view the newly created custom policy.
Previous Topic: Disabling Audit Service Next Topic: Constraints and Limits Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Grant permissions to the sub-user Policy Syntax API Operations Resource path Customize TencentDB for SQL Server Database Audit Policy.
Search AllCurrent Product Search titles only Enter keywords to search documentation
