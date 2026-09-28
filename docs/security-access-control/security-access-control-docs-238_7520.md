# Regions and AZs

> 来源: https://www.tencentcloud.com/document/product/238/7520

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Product Introduction Regions and AZs Regions and AZs Download Focus Mode Font Size Last updated: 2026-09-20 21:16:39 AI-Translated Region Introduction A Region refers to the geographical area of a physical data center. Different regions are completely isolated from each other to maximize stability and fault tolerance. For lower access latency and higher download speed, it is recommended to choose the region closest to your customers.
Related Features The networks of different regions are fully isolated from each other, and Tencent Cloud services in different regions cannot communicate using private networks by default.
Cloud services in different VPCs can communicate through Cloud Connect Network, which is faster and more stable.
CLB currently supports traffic forwarding and binding to cloud databases within the same region by default. If you enable the Cross-Region Binding feature, CLB can bind to cloud databases across regions.
AZ Introduction An AZ (Availability Zone) refers to a physical data center within the same region that has independent power and network. Its goal is to ensure that failures are isolated between AZs (except for major disasters or large-scale power failures), preventing fault propagation and keeping user services online. By launching instances in independent AZs, users can protect their applications from the impact of a single point of failure.
Related Features Tencent Cloud services that are in the same region but different AZs, yet within the same VPC, can communicate with each other via the private network. They can be accessed directly using a private IP address.
Note:
Interconnection via the private network refers to the interconnection of resources under the same account, and the resources of different accounts are completely isolated from each other on the private network.
China Region

AZ

South China (Guangzhou) ap-guangzhou

Guangzhou Zone 3 ap-guangzhou-3

Guangzhou Zone 4 (sold out) ap-guangzhou-4

Guangzhou Zone 6 ap-guangzhou-6

Guangzhou Zone 7 ap-guangzhou-7

South China (Shenzhen Finance) ap-shenzhen-fsi

Shenzhen Finance Zone 1 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-shenzhen-fsi-1

East China (Shanghai) ap-shanghai

Shanghai Zone 2 ap-shanghai-2

Shanghai Zone 3 ap-shanghai-3

Shanghai Zone 4 ap-shanghai-4

Shanghai Zone 5 ap-shanghai-5

East China (Nanjing) ap-nanjing

Nanjing Zone 1 ap-nanjing-1

Nanjing Zone 2 ap-nanjing-2

East China (Shanghai Finance) ap-shanghai-fsi

Shanghai Finance Zone 3 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-shanghai-fsi-3

Shanghai Finance Zone 4 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-shanghai-fsi-4

North China (Beijing) ap-beijing

Beijing Zone 1 ap-beijing-1

Beijing Zone 3 ap-beijing-3

Beijing Zone 4 ap-beijing-4

Beijing Zone 5 ap-beijing-5

Beijing Zone 6 ap-beijing-6

Beijing Zone 7 ap-beijing-7

North China (Beijing Finance) ap-beijing-fsi

Beijing Finance Zone 1 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-beijing-fsi-1

Beijing Finance Zone 2 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-beijing-fsi-2

Southwest China (Chengdu) ap-chengdu

Chengdu Zone 1 ap-chengdu-1

Chengdu Zone 2 ap-chengdu-2

Southwest China (Chongqing) ap-chongqing

Chongqing Zone 1 ap-chongqing-1

Hong Kong (China), Macao (China), and Taiwan (China) ap-hongkong

Hong Kong Zone 1 (Hong Kong nodes cover services in the China regions of Hong Kong, Macao, and Taiwan) ap-hongkong-1

Hong Kong Zone 2 (Hong Kong nodes cover services in the China regions of Hong Kong, Macao, and Taiwan) ap-hongkong-2

Hong Kong Zone 3 (Hong Kong nodes cover services in the China regions of Hong Kong, Macao, and Taiwan) ap-hongkong-3 Other Countries and Regions Region

AZ

Southeast Asia Pacific (Singapore) ap-singapore

Singapore Zone 1 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-1

Singapore Zone 2 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-2

Singapore Zone 3 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-3

Singapore Zone 4 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-4

Southeast Asia Pacific (Jakarta) ap-jakarta

Jakarta Zone 1 (Jakarta nodes can be used to cover the Southeast Asia region) ap-jakarta-1

Jakarta Zone 2 (Jakarta nodes can be used to cover the Southeast Asia region) ap-jakarta-2

Southeast Asia Pacific (Bangkok) ap-bangkok

Bangkok Zone 1 (Bangkok nodes can be used to cover the Southeast Asia region) ap-bangkok-1

Bangkok Zone 2 (Bangkok nodes can be used to cover the Southeast Asia region) ap-bangkok-2

Southeast Asia (Johor Bahru) ap-johorbahru

Johorbahru Zone 1 ap-johorbahru-1

Johorbahru Zone 2 ap-johorbahru-2

Northeast Asia (Seoul) ap-seoul

Seoul Zone 1 (Seoul nodes can be used to cover the Northeast Asia region) ap-seoul-1

Seoul Zone 2 (Seoul nodes can be used to cover the Northeast Asia region) ap-seoul-2

Northeast Asia (Tokyo) ap-tokyo

Tokyo Zone 1 (Tokyo nodes can be used to cover the Northeast Asia region) ap-tokyo-1

Tokyo Zone 2 (Tokyo nodes can be used to cover the Northeast Asia region) ap-tokyo-2

West US (Silicon Valley) na-siliconvalley

Silicon Valley Zone 1 (Silicon Valley nodes can be used to cover the West US region) na-siliconvalley-1

Silicon Valley Zone 2 (Silicon Valley nodes can be used to cover the West US region) na-siliconvalley-2

Eastern United States (Virginia) na-ashburn

Virginia Zone 1 (Virginia nodes can be used to cover the East US region).
na-ashburn-1

Virginia Zone 2 (Virginia nodes can be used to cover the East US region).
na-ashburn-2

Europe (Frankfurt) eu-frankfurt

Frankfurt Zone 1 (Frankfurt nodes can be used to cover the Europe region).
eu-frankfurt-1

Frankfurt Zone 2 (Frankfurt nodes can be used to cover the Europe region).
eu-frankfurt-2

South America (São Paulo) sa-saopaulo

Sao Paulo Zone 1 (Sao Paulo nodes can be used to cover the South America region).
sa-saopaulo-1

Middle East (Riyadh) me-riyadh

Riyadh Zone 1 me-saudi-arabia-1

Riyadh Zone 2 me-saudi-arabia-2 AZs Supported by Each Edition Architecture China Asia Pacific Europe and Americas Middle East Region

AZ

Multi-Node Cloud Disk Edition

Single-Node Cluster Edition

Two-Node Cluster Edition

Read-only Cluster Edition

Two-Node (Local Disk)

Read-only (Local Disk)

Guangzhou ap-guangzhou

Guangzhou Zone 3 ap-guangzhou-3

✓

✓

×

×

✓

✓

Guangzhou Zone 6 ap-guangzhou-6

✓

✓

✓

✓

✓

×

Guangzhou Zone 7 ap-guangzhou-7

✓

✓

✓

✓

✓

×

Shanghai ap-shanghai

Shanghai Zone 2 ap-shanghai-2

✓

✓

✓

✓

✓

✓

Shanghai Zone 3 ap-shanghai-3

✓

✓

×

×

✓

✓

Shanghai Zone 4 ap-shanghai-4

✓

✓

✓

✓

✓

✓

Shanghai Zone 5 ap-shanghai-5

✓

✓

✓

✓

✓

×

Shanghai Finance ap-shanghai-fsi

Shanghai Finance Zone 3 ap-shanghai-fsi-3

×

✓

✓

✓

×

×

Shanghai Finance Zone 4 ap-shanghai-fsi-4

×

✓

✓

✓

×

×

Nanjing ap-nanjing

Nanjing Zone 1 ap-nanjing-1

×

✓

✓

✓

✓

✓

Nanjing Zone 2 ap-nanjing-2

×

✓

✓

✓

✓

✓

Beijing ap-beijing

Beijing Zone 1 ap-beijing-1

×

×

×

×

✓

✓

Beijing Zone 3 ap-beijing-3

✓

✓

✓

✓

✓

✓

Beijing Zone 4 ap-beijing-4

×

✓

×

×

×

×

Beijing Zone 5 ap-beijing-5

✓

✓

×

×

✓

✓

Beijing Zone 6 ap-beijing-6

✓

✓

✓

✓

✓

×

Beijing Zone 7 ap-beijing-7

✓

✓

✓

✓

✓

×

Beijing Finance ap-beijing-fsi

Beijing Finance Zone 1 ap-beijing-fsi-1

×

✓

✓

✓

×

×

Beijing Finance Zone 2 ap-beijing-fsi-2

×

✓

✓

✓

×

×

Chengdu ap-chengdu

Chengdu Zone 1 ap-chengdu-1

×

✓

✓

✓

✓

×

Chengdu Zone 2 ap-chengdu-2

×

✓

✓

✓

✓

×

Chongqing ap-chongqing

Chongqing Zone 1 ap-chongqing-1

×

✓

✓

✓

✓

×

Hong Kong (China) ap-hongkong

Hong Kong (China) Zone 1 ap-hongkong-1

×

×

×

×

✓

✓

Hong Kong (China) Zone 2 ap-hongkong-2

×

✓

✓

✓

✓

✓

Hong Kong (China) Zone 3 ap-hongkong-3

×

×

✓

✓

✓

× How to Choose Regions and Azs The region where the cloud database is located, your location, and the geographical location of your target users.
When you purchase a cloud database, it is recommended that you select the region closest to your customers to reduce access latency and increase access speed.
The relationship between servers and other Tencent Cloud services.
It is recommended that you choose other cloud services within the same AZ in the same region if possible so that they can communicate with each other over the private network, reducing access latency and increasing access speed.
High availability and disaster recovery.
Even when you have only one VPC, it is recommended that you deploy your business across different AZs at a minimum. This ensures fault isolation between AZs and achieves cross-AZ disaster recovery.
There may be network latency among different AZs. We recommend you assess your business requirements and find the optimal balance between high availability and low latency.
If you need to access hosts in other countries or regions, it is recommended that you select a cloud database in those countries or regions for access. If you create a cloud database in China, accessing hosts in other countries or regions will result in high latency, and its use is not recommended.
Resource Position Description This section describes which Tencent Cloud resources are global, which are region-specific but not AZ-specific, and which are AZ-based.
Resource

Resource ID format -8-digit alphanumeric string

Type

Description

User Account

No limit

Globally unique

Users can use the same account to access Tencent Cloud resources around the world.

SSH Key

skey-xxxxxxxx

Available in all regions

Users can use an SSH key to bind a CVM in any region under the account.

CVM instance

ins-xxxxxxxx

Available in a single AZ of a region

Users can only create a CVM instance in a specific AZ.

Custom Image

img-xxxxxxxx

Available in multiple AZs of a region

Custom images created for the instance are available to all AZs of the same region. Use Copy Image to copy a custom image if you want to use it in other regions.

Elastic IP

eip-xxxxxxxx

Available in multiple AZs of a region

EIP addresses are created in a certain region, and can only be associated with instances in the same region.

Security group

sg-xxxxxxxx

Available in multiple AZs of a region

Security groups are created in a certain region, and can only be associated with instances in the same region. Tencent Cloud automatically creates three default security groups for users.

CBS

disk-xxxxxxxx

Available in a single AZ of a region

Users can only create a CBS in a specific AZ, and mount it to an instance in the same AZ.

Snapshot

snap-xxxxxxxx

Available in multiple AZs of a region

After creating a snapshot for a CBS, users can use the snapshot in the same region to perform other operations (such as creating a CBS).

Cloud Load Balancer

clb-xxxxxxxx

Available in multiple AZs of a region

CLB can be bound with CVMs in different AZs of a single region for traffic forwarding.

VPC

vpc-xxxxxxxx

Available in multiple AZs of a region

A VPC is created in a certain region. Resources belonging to the same VPC can be created in different AZs.

Subnet

subnet-xxxxxxxx

Available in a single AZ of a region

Users cannot create a subnet across AZs.

Route table

rtb-xxxxxxxx

Available in multiple AZs of a region

When creating a route table, users need to specify a VPC. Therefore, route tables are regional as well.
Related Operations TencentDB for SQL Server supports cross-AZ migration of instances. For details, see Cross-AZ Migration.
Previous Topic: Use Cases Next Topic: Major Version Lifecycle Description Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Region Introduction Related Features AZ Introduction Related Features China Other Countries and Regions AZs Supported by Each Edition Architecture How to Choose Regions and Azs Resource Position Description Related Operations Search AllCurrent Product Search titles only Enter keywords to search documentation
