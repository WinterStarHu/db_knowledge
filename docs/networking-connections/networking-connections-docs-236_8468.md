# Creating VPCs for TencentDB for MySQL

> 来源: https://www.tencentcloud.com/document/product/236/8468

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Practical Tutorial Creating VPCs for TencentDB for MySQL Creating VPCs for TencentDB for MySQL Download Focus Mode Font Size Last updated: 2024-07-23 12:58:47 Tencent Cloud provides Virtual Private Cloud (VPC), a platform for hosting TencentDB instances. You can launch Tencent Cloud resources in a VPC, such as TencentDB instances.
A common scheme is to share data between a TencentDB instance and a web server running in the same VPC. This document uses this scheme to create a VPC and add a TencentDB instance to it.
Below describes how to add CVM and TencentDB for MySQL instances in the same VPC to interconnect cloud resources over the private network.
Step 1. Create a VPC A VPC has at least one subnet, and Tencent Cloud service resources can only be added in a subnet.
1.
Log in to the VPC console.
2.
Select the region of the VPC at the top of the list and click Create.
3.
Enter the VPC information and the initial subnet information, and click OK. The CIDRs of the VPC and subnet cannot be modified after creation.
The VPC CIDR can be any of the following IP ranges. If you want two VPCs to communicate with each other over the private network, their CIDRs should not overlap.
10.0.0.0 - 10.255.255.255 (mask range between 11 and 28)
172.16.0.0 - 172.31.255.255 (mask range between 11 and 28)
192.168.0.0 - 192.168.255.255 (mask range between 16 and 28)
The subnet CIDR must be within or the same as the VPC CIDR.
For example, if the IP range of a VPC is 192.168.0.0/16, then that of its subnets can be 192.168.0.0/16, 192.168.0.0/17, etc.
﻿ Step 2. Create a subnet You can create one or more subnets at a time.
1.
Log in to the VPC console.
2.
Click Subnet on the left sidebar to enter the management page.
3.
Select the region and VPC in which the subnet is to be created and click Create.
4.
Enter the subnet name, CIDR, AZ, and associated route table.
﻿
5.
(Optional) Click +New line to create multiple subnets at a time.
6.
Click Create.
Step 3. Create a route table and associate it with a subnet You can create a custom route table, edit its routing policy, and associate it with a specified subnet. The route table associated with a subnet is used to specify the outbound routes for the subnet.
1.
Log in to the VPC console and select Route Tables on the left sidebar.
2.
Select the region and VPC at the top of the list and click Create.
3.
In the pop-up dialog box, enter the name, network, routing rules and click Create. Return to the route table list to view the newly created route table.
﻿
4.
Click Subnet on the left sidebar, select the subnet to be associated with the route table, and click More > Change route table in the Operation column to associate it.
Step 4. Add a CVM instance
1.
Log in to the VPC console.
2.
Click Subnet on the left sidebar to enter the management page.
3.
Select the target subnet, click the icon in the CVM column to add a CVM.
﻿
4.
Complete the purchase of the CVM instance as instructed on the page. For more information, see Purchasing Channels.
Step 5. Add a TencentDB instance New database
1.
Log in to the TencentDB for MySQL console and click Create in the instance list to enter the purchase page.
2.
In the Network section on the purchase page, select the previously created VPC and the corresponding subnet, and add the new TencentDB instance to the VPC.
﻿ Existing database
1.
In the instance list, click an instance ID or Manage in the Operation column to enter the instance management page.
2.
In the Network section on the details page, switch to the corresponding VPC.
Previous Topic: Limits on Automatic Conversion from MyISAM to InnoDB Next Topic: Enhancing Business Load Capacity with TencentDB for MySQL Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Step 1. Create a VPC Step 2. Create a subnet Step 3. Create a route table and associate it with a subnet Step 4. Add a CVM instance Step 5. Add a TencentDB instance Search AllCurrent Product Search titles only Enter keywords to search documentation
