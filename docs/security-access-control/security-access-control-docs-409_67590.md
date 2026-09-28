# Regions and AZs

> 来源: https://www.tencentcloud.com/document/product/409/67590

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Product Introduction Regions and AZs Regions and AZs Download Focus Mode Font Size Last updated: 2026-09-17 21:09:33 AI-Translated & Reviewed The IDCs hosted by TencentDB are distributed in multiple positions around the world. These position nodes are called regions, and each region is composed of multiple availability zones (AZs). Each region is a separate geographical area. There are multiple isolated positions in each region, which are called AZs. Each AZ is independent, but the AZs in the same region are connected through the low-latency private network link. Tencent Cloud support users to allocate cloud resources in different positions. It is recommended that users consider placing resources in different availability zones when designing the system, to shield service unavailability status caused by single-point failures.
Names of regions and AZs directly reflect the coverage of IDCs. To facilitate customers' understanding, the naming rules are as follows:
The structure of Coverage + Located City of IDC is adopted for region naming. The first half represents the coverage capacity of the IDC, and the second half represents the city where the IDC is located or nearby.
AZ naming adopts the structure of City + Number.
Regions Tencent Cloud regions are completely isolated from each other to ensure their maximum stability and fault tolerance. It is recommended that you select the region closest to your users to reduce access latency and improve download speed. Users' operations such as launching or viewing instances are differentiated by regional attributes.
Precautions for private network communication of cloud products are as follows:
Cloud resources in the same region (within the same account and VPC) can be interconnected through the private network, which can be accessed directly using Private IP address.
The networks of different regions are completely isolated from each other, and cloud products in different regions cannot be interconnected over the private network by default.
Cloud products in different regions can communicate with each other by accessing the Internet through public IP addresses, while those in different private networks can communicate with each other through Cloud Connect Network, which is a relatively high-speed and stable communication method.
﻿Cloud Load Balancer (CLB) currently supports same-region traffic forwarding and the binding of cloud servers in the local region by default. If you enable the cross-region binding feature, CLB can support the cross-region binding of cloud servers.
Availability Zones An availability zone (AZ) is a physical IDC of Tencent Cloud with independent power supply and network in the same region. It can ensure continuous business stability, as faults (except for major disasters or power faults) in one AZ are isolated without affecting other AZs in the same region. By starting an instance in an independent AZ, users can protect their applications from being affected by a single-point fault. Users can choose any AZ within a specified region when launching an instance. To design a highly reliable application system (ensuring service availability when an instance fails), users can use cross-AZ deployment schemes (such as CLB and Elastic IP), so that instances in another AZ can handle related requests.
List of Regions and AZs Composition of regions and AZs:
Note:
Currently, only the following regions support public network connection: Beijing, Chengdu, Guangzhou, Hong Kong (China), Nanjing, Shanghai, Tokyo, and Silicon Valley.
China Region

AZ

South China (Guangzhou) ap-guangzhou

Guangzhou Zone 3 ap-guangzhou-3

Guangzhou Zone 4 ap-guangzhou-4

Guangzhou Zone 6 ap-guangzhou-6

Guangzhou Zone 7 ap-guangzhou-7

South China (Shenzhen Finance) ap-shenzhen-fsi

Shenzhen Finance Zone 3 (only financial institutions and enterprises can apply for activation through online consultation) ap-shenzhen-fsi-3

East China (Shanghai) ap-shanghai

Shanghai Zone 2 ap-shanghai-2

Shanghai Zone 3 ap-shanghai -3

Shanghai Zone 4 ap-shanghai-4

Shanghai Zone 5 ap-shanghai-5

Shanghai Zone 6 ap-shanghai-6

Shanghai Zone 7 ap-shanghai-7

Shanghai Zone 8 ap-shanghai-8

East China (Nanjing) ap-nanjing

Nanjing Zone 1 ap-nanjing-1

Nanjing Zone 2 ap-nanjing-2

Nanjing Zone 3 ap-nanjing-3

East China (Shanghai Finance) ap-shanghai-fsi

Shanghai Finance Zone 2 (only financial institutions and enterprises can apply for activation through online consultation) ap-shanghai-fsi-2

Shanghai Finance Zone 3 (only financial institutions and enterprises can apply for activation through online consultation) ap-shanghai-fsi-3

Shanghai Finance Zone 4 (only financial institutions and enterprises can apply for activation through online consultation) ap-shanghai-fsi-4

North China (Beijing) ap-beijing

Beijing Zone 3 ap-beijing-3

Beijing Zone 4 ap-beijing-4

Beijing Zone 5 ap-beijing-5

Beijing Zone 6 ap-beijing-6

Beijing Zone 7 ap-beijing-7

Beijing Zone 8 ap-beijing-8

North China (Beijing Finance) ap-beijing-fsi

Beijing Finance Zone 1 (only financial institutions and enterprises can apply for activation through online consultation) ap-beijing-fsi-1

Southwest China (Chengdu) ap-chengdu

Chengdu Zone 1 ap-chengdu-1

Chengdu Zone 2 ap-chengdu-2

Southwest China (Chongqing) ap-chongqing

Chongqing Zone 1 ap-chongqing-1

Hong Kong, Macao, and Taiwan, China (Hong Kong, China) ap-hongkong

Hong Kong Zone 2 (Hong Kong nodes cover services in Hong Kong, Macao, and Taiwan, China) ap-hongkong-2

Hong Kong Zone 3 (Hong Kong nodes cover services in Hong Kong, Macao, and Taiwan, China) ap-hongkong-3 Countries and Regions Outside China Region

AZ

Southeast Asia Pacific (Singapore) ap-singapore

Singapore Zone 2 (Singapore nodes cover services in Southeast Asia Pacific) ap-singapore-2

Singapore Zone 3 (Singapore nodes cover services in Southeast Asia Pacific) ap-singapore-3

Singapore Zone 4 (Singapore nodes cover services in Southeast Asia Pacific) ap-singapore-4

Southeast Asia Pacific (Jakarta) ap-jakarta

Jakarta Zone 1 ap-jakarta-1

Jakarta Zone 2 ap-jakarta-2

Jakarta Zone 3 ap-jakarta-3

Southeast Asia Pacific (Bangkok) ap-bangkok

Bangkok Zone 1 (Bangkok nodes cover services in Southeast Asia Pacific) ap-bangkok-1

Bangkok Zone 2 (Bangkok nodes cover services in Southeast Asia Pacific) ap-bangkok-2

Northeast Asia Pacific (Seoul) ap-seoul

Seoul Zone 1 (Seoul nodes cover services in Northeast Asia Pacific) ap-seoul-1

Seoul Zone 2 (Seoul nodes cover services in Northeast Asia Pacific) ap-seoul-2

Northeast Asia Pacific (Tokyo) ap-tokyo

Tokyo Zone 1 (Tokyo nodes cover services in Northeast Asia Pacific) ap-tokyo-1

Tokyo Zone 2 (Tokyo nodes cover services in Northeast Asia Pacific) ap-tokyo-2

Western US (Silicon Valley) na-siliconvalley

Silicon Valley Zone 1 (Silicon Valley nodes cover services in Western US) na-siliconvalley-1

Silicon Valley Zone 2 (Silicon Valley nodes cover services in West US) na-siliconvalley-2

Eastern US (Virginia) na-ashburn

Virginia Zone 1 (Virginia nodes cover services in East US) na-ashburn-1

Europe (Frankfurt) eu-frankfurt

Frankfurt Zone 1 (Frankfurt nodes cover services in Europe) eu-frankfurt-1

Frankfurt Zone 2 (Frankfurt nodes cover services in Europe) eu-frankfurt-2

South America (S?o Paulo) sa-saopaulo

Sao Paulo Zone 1 sa-saopaulo-1 How to Choose Regions and Azs When you purchase Tencent Cloud services, it is recommended that you select the region closest to your users to reduce access latency and improve download speed.
Previous Topic: Scenarios Next Topic: Product Feature List Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Regions Availability Zones List of Regions and AZs China Countries and Regions Outside China How to Choose Regions and Azs Search AllCurrent Product Search titles only Enter keywords to search documentation
