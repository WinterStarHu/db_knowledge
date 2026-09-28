# Setting Instance Parameters

> 来源: https://www.tencentcloud.com/document/product/238/41609

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Setting Instance Parameters Viewing Parameter Modification Log Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Operation Guide Parameter Configuration Setting Instance Parameters Setting Instance Parameters Download Focus Mode Font Size Last updated: 2026-07-01 18:59:34 AI-Translated You can view and modify some parameters through the SQL Server console, and you can also query the parameter modification history on the console.
Note To ensure the stability of the instance, the console only allows modification of some parameters. The parameters displayed on the console's parameter configuration page are the parameters that users can modify.
If a modified parameter requires an instance restart to take effect, the system will prompt you whether to restart. It is recommended that you perform this operation during off-peak hours and ensure that your application has a reconnection mechanism.
Parameter List Parameter Name

Default Value

Value Range

Description

fill factor(%)

0

[0 - 100]

Used to fine-tune the storage and performance of index data

max worker threads

0

[672 - 32767]

Configures the number of worker threads available across the entire SQL Server for processing query requests, logins, logouts, and similar application requests.

cost threshold for parallelism

5

[0 - 32767]

Specifies the threshold at which SQL Server creates and runs parallel query plans.

max degree of parallelism

0

[0 - 1024]

The number of processors used to run a single statement each time a parallel plan is executed.

optimize for ad hoc workloads

0

[0 | 1]

Improves the plan cache efficiency for workloads containing a large number of single-use ad hoc batches.

min server memory(MB)

0

[0 - 4096]

Changes the amount of memory that the SQL Server memory manager can allocate to the SQL Server process.

blocked process threshold(s)

0

[0 - 86400]

Specifies the threshold (in seconds) for generating blocked process reports using the blocked process threshold option.

slow log threshold (ms)

1000

[1000 - 60000]

The execution time threshold (in milliseconds) for logging a statement as a slow query.

default language

0

[0 - 33]

Configures the default language and specifies the default language for all newly created login users.
default language Parameter Value Description Value

Description

0

English (US)

1

German

2

French

3

Japanese

4

Danish

5

Spanish

6

Italian

7

Dutch

8

Norwegian

9

Portuguese

10

Finnish

11

Swedish

12

Czech

13

Hungarian

14

Polish

15

Romanian

16

Croatian

17

Slovak

18

Slovene

19

Greek

20

Bulgarian

21

Russian

22

Turkish

23

English (British)

24

Estonian

25

Latvian

26

Lithuanian

27

Brazilian Portuguese

28

Traditional Chinese

29

Korean

30

Simplified Chinese

31

Arabic

32

Thai

33

Bokmål Modifying Parameters in Batches
1.
Log in to the TencentDB for SQL Server console and click Instance ID or Manage in the Operation column in the instance list to enter the instance management page.
2.
On the instance management page, choose the Parameter Configuration > Parameter Settings page and click Batch Modify Parameters.
﻿
3.
In the Current Value column, select and modify the parameters that need to be changed. After verifying that everything is correct, click OK.
﻿
4.
In the pop-up dialog box, select the Execution Mode for the parameter task and click OK.
Note:
If you select Immediately execution, the parameter modification task for the selected instance will be executed and take effect immediately.
If you select During maintenance time, the parameter modification task for the selected instance will be executed and take effect during the maintenance window of the instance.
﻿ Modifying a Single Parameter
1.
Log in to the TencentDB for SQL Server console and click the Instance ID in the instance list to go to the instance management page.
2.
On the instance management page, choose the Parameter Configuration > Parameter Settings page. Select the row where the target parameter is located. In the Current Value column, click ﻿ to modify the parameter value.
﻿
3.
Enter the target parameter value according to the prompt in the Parameter Value column. Click ﻿ to save or click ﻿ to cancel the operation.
﻿
4.
In the pop-up dialog box, select the Execution Mode for the parameter task and click OK.
Note:
If you select Immediately execution, the parameter modification task for the selected instance will be executed and take effect immediately.
If you select During maintenance time, the parameter modification task for the selected instance will be executed and take effect during the maintenance window of the instance.
﻿ Related APIs API

Description

Query the list of configurable parameters for an instance

The interface (DescribeInstanceParams) is used to query the parameter list of an instance.

Modify instance parameters

The interface (ModifyInstanceParam) is used to modify the parameters of a cloud database instance.

Query instance parameter modification history

The interface (DescribeInstanceParamRecords) is used to query the modification history of instance parameters.
Previous Topic: Configuring Security Groups Next Topic: Viewing Parameter Modification Log Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Note Parameter List default language Parameter Value Description Modifying Parameters in Batches Modifying a Single Parameter Related APIs Search AllCurrent Product Search titles only Enter keywords to search documentation
