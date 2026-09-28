# Billing and Purchase

> 来源: https://www.tencentcloud.com/document/product/238/19128

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server FAQs Billing and Purchase Billing and Purchase Download Focus Mode Font Size Last updated: 2026-08-24 15:43:26 AI-Translated What Is the Price of TencentDB for SQL Server?
TencentDB for SQL Server includes a genuine Microsoft license and uses a pay-as-you-go (postpaid) billing mode.
Pricing is determined by two components: instance specifications (memory capacity) and storage space (hard disk capacity). For pricing details in different regions, see Product Pricing.
How to Purchase TencentDB for SQL Server Log in to the TencentDB for SQL Server console to create an instance, or directly log in to the purchase page to purchase an instance.
Do I Need to Purchase a SQL Server License?
Tencent Cloud provides you with a cloud database under the "License Included" model. The pricing for this model already includes the SQL Server software license, underlying hardware resources, and Tencent Cloud TencentDB management features. You do not need to purchase a Microsoft SQL Server license separately, even if you do not have one.
When using a database with the License Included model, you pay directly based on the instance specifications and usage duration, without needing to account for hardware costs or license fees. This converts high fixed costs into smaller variable costs, reducing your IT expenditure.
Attention:
Purchasing TencentDB for SQL Server does not mean you have procured a long-term contract for Microsoft SQL Server licenses. Therefore, you must not use the TencentDB license in unauthorized locations or during unauthorized periods. For the relevant regulations, see Microsoft Volume Licensing Service Provider Usage Rights.
Microsoft's original manufacturer services and Tencent Cloud's original manufacturer services are not included in the base pricing of TencentDB for SQL Server.
Does TencentDB for SQL Server Have Genuine Microsoft Authorization?
TencentDB for SQL Server is licensed by Microsoft.
What Is the Renewal Process for TencentDB for SQL Server?
Renewal refers to extending the usage duration of an instance. The following two renewal operations are supported:
On the TencentDB for SQL Server console Instance List page, select the target instance, and then click Renew or choose More Operations > Set Auto-renewal.
On the renewal management page in the Billing Center, select the TencentDB for SQL Server item to be renewed, choose the corresponding instance, and then click Renew or Batch Renew.
For details, see Renewal Instructions.
How to Process a Refund for a TencentDB for SQL Server Instance Purchased in the Wrong Region?
If you want a refund, process it according to your instance's status:
Pay-as-you-go instances: Resources for TencentDB for SQL Server can be terminated directly, but refunds cannot be requested.
Yearly/Monthly subscription instances:
Standard self-service refund: Each account can self-service refund up to 199 of your yearly/monthly subscription cloud database instances in the console at any time within a year.
In case of suspected abnormal or malicious returns, Tencent Cloud reserves the right to reject your return request.
Before requesting a refund, first read the refund instructions and notes. For details, see Refunds.
What Happens When TencentDB for SQL Server Expires or Has Overdue Payments?
Yearly/Monthly subscription instances:
The system sends renewal reminder notifications to users via email, Message Center, and SMS 7 days before the cloud database resource expires.
If your cloud service is not renewed before or on its expiration date, the system will start to suspend it at the expiration time (by powering off the device and retaining only the data).
Cloud database resources that have been expired for more than seven days will be reclaimed by the system, and the data will be cleared and unrecoverable.
Pay-as-you-go instances:
From the moment the account balance becomes negative: Within 24 hours, the cloud database remains usable and continues to incur charges. After 24 hours, the cloud database instance will be isolated. The isolated instance cannot be accessed, and charging is stopped.
After automatic shutdown: Within 3 days after shutdown, if your account balance is not topped up to be greater than 0, the instance cannot be started up. If the balance is topped up to be greater than 0, billing will continue, and the instance can be started up. If the account balance remains less than 0 for 3 days, the pay-as-you-go cloud database will be reclaimed, all data will be cleared, and cannot be recovered.
For details, see Overdue Payment.
What Is the Difference Between Yearly/Monthly Subscription and Pay-as-You-Go Billing?
Yearly/monthly subscription: Also known as prepaid, it requires payment when a new instance is created. This mode suits long-term needs, offers more cost-effective pricing than pay-as-you-go, and provides greater discounts for longer subscription periods. Yearly/monthly subscription instances do not support switching to pay-as-you-go instances.
Pay-as-you-go: Also known as postpaid, a billing order is generated hourly, and fees are deducted from your Tencent Cloud account based on the instance specifications at the time of order generation. This mode suits short-term needs, allowing you to release instances immediately after use to save costs. The pay-as-you-go mode can be switched to yearly/monthly subscription. For details, see Switching to Yearly/Monthly Subscription.
Can Yearly/Monthly Subscription and Pay-as-You-Go Billing Be Converted to Each Other?
Pay-as-you-go billing can be switched to yearly/monthly subscription. For details, see Switching to Yearly/Monthly Subscription.
Yearly/monthly subscription instances cannot be switched to pay-as-you-go instances.
What Are the Impacts and Billing Details of Switching a TencentDB for SQL Server Instance from Pay-as-You-Go to Yearly/Monthly Subscription?
During the switch from pay-as-you-go billing to yearly/monthly subscription, your business access will not be affected. Please proceed with confidence. For billing details, see Product Pricing.
Are There Differences in Features Supported by Yearly/Monthly Subscription and Pay-as-You-Go?
The supported features are basically the same. For specific details about each feature, you can view Feature Overview.
Are Pay-as-You-Go TencentDB for SQL Server Instances Charged When Not in Use?
Pay-as-you-go instances incur charges continuously. When an instance is no longer used, terminate it promptly to avoid further charges.
What to Do When TencentDB for SQL Server Instance Inventory Is Insufficient in an AZ?
When the TencentDB for SQL Server instance you intend to purchase is out of stock in the selected AZ, you have the following options:
Purchase an instance in another AZ within the same region. After the target AZ replenishes its inventory, migrate the instance to the target AZ. For detailed steps, see Cross-AZ Migration. Instances in different AZs within the same region can communicate via the private network, which will not affect your usage. Therefore, this method is recommended.
If your business requirement is not urgent, please wait for a period of time and make the purchase after the target AZ has instance inventory. However, the time required to replenish inventory cannot be determined due to varying conditions across supply chains.
If you have a large-scale procurement requirement for TencentDB for SQL Server, you can also submit a ticket in advance to contact us for resource reservation. We will coordinate resources for you ahead of time to ensure you can use them as scheduled.
How to View the Billing Details for TencentDB for SQL Server?
You can view your account's available balance, income and expense details, fees incurred by using SQL Server, and top up your account through the Billing Center in the Tencent Cloud console. For details, see Viewing Bill Details.
How to Terminate a TencentDB for SQL Server Instance?
Based on your business needs, you can self-service refund pay-as-you-go and yearly/monthly subscription instances in the console. For details, see Terminating an Instance.
Can a Terminated TencentDB for SQL Server Instance Be Restored?
Terminated instances are placed in the recycle bin. You can restore terminated instances from the recycle bin.
Yearly/monthly subscription instances go to the recycle bin: Instances in the recycle bin are retained for 7 natural days. If renewal is not performed after 7 natural days, the system will release the resources, and they cannot be recovered.
Pay-as-you-go instances go to the recycle bin: In the case of no arrears, instances proactively terminated by users are retained for 24 hours in the recycle bin. For instances whose renewal is not completed on time, the system will release the instance resources after the 24-hour retention period, and they cannot be recovered.
Can TencentDB for SQL Server Instances in Different AZs Within the Same Region Communicate via Private Networks?
Instances in different AZs within the same region can communicate via the private network using private network addresses.
Can a CVM and a TencentDB for SQL Server Instance in Different AZs Within the Same Region Connect? What Is the Latency?
When a CVM and a TencentDB for SQL Server instance are located in different AZs within the same region and within the same VPC, they can communicate via private network addresses. Typically, the latency is around 0.5 milliseconds.
Can the Region of a TencentDB for SQL Server Instance Be Modified?
The region of an instance cannot be modified after purchase. You can use DTS to migrate data to an instance in the target region, and then terminate the original instance.
Can the AZ of a TencentDB for SQL Server Instance Be Modified?
Under normal circumstances, AZs are identical and do not need to be modified. If you need to modify the AZ of an instance for special reasons, see Cross-AZ Migration.
Should a Two-Node (Formerly HA Edition/Cluster Edition) TencentDB for SQL Server Instance Be Deployed in a Single AZ or Multiple AZs?
Within the same region, AZs are interconnected via the private network, and fault isolation can be achieved between AZs. If your application requires high disaster recovery capability, we recommend that you deploy your instances in different AZs within the same region. For details, see Multi-AZ Disaster Recovery.
How to Purchase a Multi-AZ TencentDB for SQL Server Instance?
Log in to the SQL Server console. In the instance list, click Create Instance to go to the purchase page. On the SQL Server purchase page, select the supported region. Then, select the corresponding secondary AZ in the Multi-AZ option. Only some AZs support secondary AZs. For specific selectable secondary AZs, check the purchase page.
How to Upgrade a Single-AZ TencentDB for SQL Server Instance to Multi-AZ?
Log in to the SQL Server console. In the instance list, select the instance to be upgraded, and click Configuration Adjustment to go to the configuration adjustment page. On the configuration adjustment page, select the corresponding secondary AZ in the Multi-AZ Deployment option. For details, see Upgrading to Multi-AZ.
How to Restart TencentDB for SQL Server?
Restarting an instance is a common maintenance method for TencentDB for SQL Server. It is similar to restarting a local database. For details, see Restarting an Instance.
How to View and Manage TencentDB for SQL Server Instances?
Log in to the TencentDB for SQL Server console. On the instance list page, you can view instance-related information and manage instances. For details, see Managing TencentDB for SQL Server Instances.
What Tags Can Be Used to Facilitate the Categorization and Management of TencentDB for SQL Server Resources?
As business grows, the number of devices and instances that users need to manage gradually increases. With the growing number of operational and management items, the proper classification, management, and maintenance of resources have become one of the key means for resource management.
Users can enhance the descriptiveness of TencentDB for SQL Server instances from different dimensions, such as modifying the instance name, setting instance remarks, setting instance Tags, and setting the project to which the instance belongs, to facilitate better management and differentiation of instance resources.
What Is the Purpose of a TencentDB for SQL Server Instance Name and How to Modify It?
The instance name is primarily used to distinguish and manage SQL Server instances. You can modify the instance name through the console. For details, see Modifying the Instance Name.
What Is the Purpose of TencentDB for SQL Server Instance Remarks and How to Set Them?
TencentDB for SQL Server allows users to add remarks to instances to enhance their descriptiveness, facilitating better management and differentiation of instance resources. For details, see Setting Instance Remarks.
What Is the Purpose of TencentDB for SQL Server Instance Tags and How to Set Them?
A Tag is a key-value pair provided by Tencent Cloud for identifying cloud resources. You can use Tags to classify and manage TencentDB for SQL Server resources based on various dimensions, such as business, purpose, and owner. Tags allow you to easily filter and locate corresponding resources. For details, see Setting Instance Tags.
What Is the Purpose of a TencentDB for SQL Server Instance Project and How to Set the Project for an Instance?
The project feature is used to manage cloud resources by project, enabling project-based management of cloud resources. When creating a TencentDB for SQL Server instance, you must assign the instance to a project. Users can create multiple projects under one account, with different resources managed in each project, and assign multiple different instances to different projects. For details, see Setting the Project to Which an Instance Belongs.
﻿

Previous Topic: Purchase Consultation Next Topic: Connection and Network Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page What Is the Price of TencentDB for SQL Server?
How to Purchase TencentDB for SQL Server Do I Need to Purchase a SQL Server License?
Does TencentDB for SQL Server Have Genuine Microsoft Authorization?
What Is the Renewal Process for TencentDB for SQL Server?
How to Process a Refund for a TencentDB for SQL Server Instance Purchased in the Wrong Region?
What Happens When TencentDB for SQL Server Expires or Has Overdue Payments?
What Is the Difference Between Yearly/Monthly Subscription and Pay-as-You-Go Billing?
Can Yearly/Monthly Subscription and Pay-as-You-Go Billing Be Converted to Each Other?
What Are the Impacts and Billing Details of Switching a TencentDB for SQL Server Instance from Pay-as-You-Go to Yearly/Monthly Subscription?
Are There Differences in Features Supported by Yearly/Monthly Subscription and Pay-as-You-Go?
Are Pay-as-You-Go TencentDB for SQL Server Instances Charged When Not in Use?
What to Do When TencentDB for SQL Server Instance Inventory Is Insufficient in an AZ?
How to View the Billing Details for TencentDB for SQL Server?
How to Terminate a TencentDB for SQL Server Instance?
Can a Terminated TencentDB for SQL Server Instance Be Restored?
Can TencentDB for SQL Server Instances in Different AZs Within the Same Region Communicate via Private Networks?
Can a CVM and a TencentDB for SQL Server Instance in Different AZs Within the Same Region Connect? What Is the Latency?
Can the Region of a TencentDB for SQL Server Instance Be Modified?
Can the AZ of a TencentDB for SQL Server Instance Be Modified?
Should a Two-Node (Formerly HA Edition/Cluster Edition) TencentDB for SQL Server Instance Be Deployed in a Single AZ or Multiple AZs?
How to Purchase a Multi-AZ TencentDB for SQL Server Instance?
How to Upgrade a Single-AZ TencentDB for SQL Server Instance to Multi-AZ?
How to Restart TencentDB for SQL Server?
How to View and Manage TencentDB for SQL Server Instances?
What Tags Can Be Used to Facilitate the Categorization and Management of TencentDB for SQL Server Resources?
What Is the Purpose of a TencentDB for SQL Server Instance Name and How to Modify It?
What Is the Purpose of TencentDB for SQL Server Instance Remarks and How to Set Them?
What Is the Purpose of TencentDB for SQL Server Instance Tags and How to Set Them?
What Is the Purpose of a TencentDB for SQL Server Instance Project and How to Set the Project for an Instance?
Search AllCurrent Product Search titles only Enter keywords to search documentation
