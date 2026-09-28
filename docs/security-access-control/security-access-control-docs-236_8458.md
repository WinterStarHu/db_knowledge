# Regions and AZs

> 来源: https://www.tencentcloud.com/document/product/236/8458

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Product Introduction Regions and AZs Regions and AZs Download Focus Mode Font Size Last updated: 2026-09-20 21:10:36 AI-Translated & Reviewed TencentDB hosted IDCs are distributed in multiple locations around the world. These locations are called Regions (Region), and each Region consists of multiple AZs (Zone).
Each Region (Region) is an independent geographical area. Within each Region, there are multiple isolated locations called AZs (Zone). Each AZ is independent, but AZs within the same Region are connected via low-latency private network links. Tencent Cloud supports users in distributing cloud resources across different locations. It is recommended that users consider placing resources in different AZs when designing systems to avoid service unavailability caused by single points of failure.
Names of regions and AZs directly reflect the coverage of IDCs. To facilitate customers' understanding, the naming rules are as follows:
The structure of Coverage + Located City of IDC is adopted for region naming. The first half represents the coverage capacity of the IDC, and the second half represents the city where the IDC is located or nearby.
AZ naming adopts the structure of City + Number.
Regions Tencent Cloud regions are completely isolated from each other to ensure maximum stability and fault tolerance across regions. It is recommended that you select the region closest to your users to reduce access latency and improve download speeds. Operations such as launching instances and viewing instances are region-specific.
Considerations for private network communication within cloud products are as follows:
Cloud resources in the same region (within the same account and VPC) can be interconnected through the private network, which can be accessed directly using Private IP address.
The networks of different regions are completely isolated from each other, and cloud products in different regions cannot be interconnected over the private network by default.
Cloud products in different regions can communicate with each other by accessing the Internet through public IP addresses, while those in different private networks can communicate with each other through Cloud Connect Network, which is a relatively high-speed and stable communication method.
CLB currently supports traffic forwarding within the same region by default and can be bound to CVMs in the local region. If you enable the cross-region binding feature, CLB can support cross-region binding to CVMs.
AZ AZ (Zone) refers to Tencent Cloud's physically independent data centers within the same region, each with separate power and network systems. The goal is to ensure fault isolation between AZs (excluding large-scale disasters or major power failures), preventing fault propagation and maintaining continuous online services for user businesses. By launching instances in independent AZs, users can protect applications from single-location failures.
When launching instances, users can select any AZ within a specified region. To design high-availability application systems (maintaining service availability during instance failures), users can adopt cross-AZ deployment solutions (such as CLB, Elastic IP, and so on), enabling instances in another AZ to handle relevant requests.
List of Regions and AZs Composition of regions and AZs:
Note:
Currently, public network connections are supported only in the following regions:
Guangzhou, Shanghai, Beijing, Chengdu, Chongqing, Nanjing, Hong Kong (China), Singapore, Seoul, Tokyo, Silicon Valley, Virginia, Frankfurt, Jakarta, Riyadh.
China Region

AZ

South China (Guangzhou) ap-guangzhou

Guangzhou Zone 1 (Sold Out) ap-guangzhou-1

Guangzhou Zone 3 ap-guangzhou-3

Guangzhou Zone 4 ap-guangzhou-4

Guangzhou Zone 6 ap-guangzhou-6

Guangzhou Zone 7 ap-guangzhou-7

South China (Shenzhen Finance) ap-shenzhen-fsi

Shenzhen Finance Zone 1 (only available to financial institutions and enterprises. Submit a ticket to apply for activation) ap-shenzhen-fsi-1

Shenzhen Finance Zone 2 (only available to financial institutions and enterprises. Submit a ticket to apply for activation) ap-shenzhen-fsi-2

Shenzhen Finance Zone 3 (only available to financial institutions and enterprises. Submit a ticket to apply for activation) ap-shenzhen-fsi-3

East China (Shanghai) ap-shanghai

Shanghai Zone 2 ap-shanghai-2

Shanghai Zone 3 ap-shanghai-3

Shanghai Zone 4 ap-shanghai-4

Shanghai Zone 5 ap-shanghai-5

Shanghai Zone 8 ap-shanghai-8

East China (Nanjing) ap-nanjing

Nanjing Zone 1 ap-nanjing-1

Nanjing Zone 2 ap-nanjing-2

Nanjing Zone 3 ap-nanjing-3

East China (Shanghai Finance) ap-shanghai-fsi

Shanghai Finance Zone 2 (only for financial institutions and enterprises; submit a ticket to apply for activation) ap-shanghai-fsi-2

Shanghai Finance Zone 3 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-shanghai-fsi-3

North China (Beijing) ap-beijing

Beijing Zone 1 ap-beijing-1

Beijing Zone 3 ap-beijing-3

Beijing Zone 4 ap-beijing-4

Beijing Zone 5 ap-beijing-5

Beijing Zone 6 ap-beijing-6

Beijing Zone 7 ap-beijing-7

Beijing Zone 8 ap-beijing-8

North China (Beijing Finance) ap-beijing-fsi

Beijing Finance Zone 1 (only for financial institutions and enterprises; submit a ticket to apply for support.) ap-beijing-fsi-1

Southwest China (Chengdu) ap-chengdu

Chengdu Zone 1 ap-chengdu-1

Chengdu Zone 2 ap-chengdu-2

Southwest China (Chongqing) ap-chongqing

Chongqing Zone 1 ap-chongqing-1

Hong Kong (China), Macao (China), and Taiwan (China) ap-hongkong

Hong Kong Zone 1 (Hong Kong (China) nodes can be used to cover Hong Kong/Macao/Taiwan (China)) ap-hongkong-1

Hong Kong Zone 2 (Hong Kong (China) nodes can be used to cover Hong Kong/Macao/Taiwan (China)) ap-hongkong-2

Hong Kong Zone 3 (Hong Kong (China) nodes can be used to cover Hong Kong/Macao/Taiwan (China)) ap-hongkong-3 Countries and Regions Outside China Region

AZ

Southeast Asia Pacific (Singapore) ap-singapore

Singapore Zone 1 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-1

Singapore Zone 2 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-2

Singapore Zone 3 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-3

Singapore Zone 4 (Singapore nodes can be used to cover the Southeast Asia region) ap-singapore-4

Southeast Asia Pacific (Jakarta) ap-jakarta

Jakarta Zone 1 ap-jakarta-1

Jakarta Zone 2 ap-jakarta-2

Southeast Asia Pacific (Bangkok) ap-bangkok

Bangkok Zone 1 (Bangkok nodes can be used to cover the Southeast Asia region) ap-bangkok-1

Bangkok Zone 2 (Bangkok nodes can be used to cover the Southeast Asia region) ap-bangkok-2

Southeast Asia (Johor Bahru) ap-johorbahru

Johor Bahru Zone 1 ap-johorbahru-1

Johor Bahru Zone 2 ap-johorbahru-2

Northeast Asia Pacific (Seoul) ap-seoul

Seoul Zone 1 (Seoul nodes can be used to cover the Northeast Asia region) ap-seoul-1

Seoul Zone 2 (Seoul nodes can be used to cover the Northeast Asia region) ap-seoul-2

Northeast Asia Pacific (Tokyo) ap-tokyo

Tokyo Zone 1 (Tokyo nodes can be used to cover the Northeast Asia region).
ap-tokyo-1

Tokyo Zone 2 (Tokyo nodes can be used to cover the Northeast Asia region).
ap-tokyo-2

Northeast Asia Pacific (Osaka) ap-osaka

Osaka zone1 (Osaka nodes can be used to cover the Northeast Asia region) ap-osaka-1

West US (Silicon Valley) na-siliconvalley

Silicon Valley Zone 1 (Sold Out) na-siliconvalley-1

Silicon Valley Zone 2 (Silicon Valley nodes can be used to cover the West US region).
na-siliconvalley-2

Eastern United States (Virginia) na-ashburn

Virginia Zone 1 (Virginia nodes can be used to cover the East US region).
na-ashburn-1

Virginia Zone 2 (Virginia nodes can be used to cover the East US region).
na-ashburn-2

South America (São Paulo) sa-saopaulo

Sao Paulo Zone 1 (Sao Paulo nodes can be used to cover the South America region).
sa-saopaulo-1

Europe (Frankfurt) eu-frankfurt

Frankfurt Zone 1 (Frankfurt nodes can be used to cover the Europe region).
eu-frankfurt-1

Frankfurt Zone 2 (Frankfurt nodes can be used to cover the Europe region).
eu-frankfurt-2

Middle East (Riyadh) me-saudi-arabia

Riyadh Zone 1 me-saudi-arabia-1

Riyadh Zone 2 me-saudi-arabia-2 Corresponding regions support disk types For instances with two-node, three-node, or four-node architectures, the disk type is set to local SSD by default. For instances with single-node or cluster edition architectures, the disk type is set to cloud disk, which includes Cloud SSD, Enhanced SSD, Premium Disk, and Extreme SSD. Note that the regions supported by different types of cloud disks vary slightly. For details, refer to the table below.
Note:
CLOUD_HSSD: Enhanced SSD CBS.
CLOUD_SSD: Cloud SSD.
CLOUD_PREMIUM: Premium Disk.
CLOUD_TSSD: Extreme SSD CBS.
Single-Node Cluster Edition Region

AZ

Supported Disk Type

Guangzhou

ap-guangzhou-6 ap-guangzhou-7

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Shanghai

ap-shanghai-2

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

ap-shanghai-5 ap-shanghai-8

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM,CLOUD_TSSD

Nanjing

ap-nanjing-1 ap-nanjing-3

CLOUD_HSSD,CLOUD_SSD

Beijing

ap-beijing-6 ap-beijing-7 ap-beijing-8

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Chengdu

ap-chengdu-1 ap-chengdu-2

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Hong Kong (China)

ap-hongkong-2 ap-hongkong-3

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Singapore

ap-singapore-2 ap-singapore-3 ap-singapore-4

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Jakarta

ap-jakarta-1 ap-jakarta-2

CLOUD_HSSD,CLOUD_SSD

Seoul

ap-seoul-1 ap-seoul-2

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Silicon Valley

na-siliconvalley-1 na-siliconvalley-2

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM

Frankfurt

eu-frankfurt-1 eu-frankfurt-2

CLOUD_HSSD,CLOUD_SSD,CLOUD_PREMIUM,CLOUD_TSSD How to Choose Regions and Azs When you purchase Tencent Cloud services, it is recommended that you select the region closest to your users to reduce access latency and improve download speed.
Regions and AZs Supported by Read-Only Analysis Engine The regions and availability zones (AZs) currently supported by the read-only analysis engine feature of TencentDB for MySQL are shown in the table below. The enabling and usage of the engine can be in a different AZ from that of the primary instance.
Region

AZ

North China (Beijing) ap-beijing

Beijing Zone 5 ap-beijing-5

Beijing Zone 6 ap-beijing-6

Beijing Zone 7 ap-beijing-7

East China (Shanghai) ap-shanghai

Shanghai Zone 6 ap-shanghai-6

South China (Guangzhou) ap-guangzhou

Guangzhou Zone 4 ap-guangzhou-4

Guangzhou Zone 7 ap-guangzhou-7

Southwest China (Chengdu) ap-chengdu

Chengdu Zone 1 ap-chengdu-1

Hong Kong (China), Macao (China), and Taiwan (China) ap-hongkong

Hong Kong (China) Zone 2 ap-hongkong-2

East China (Nanjing) ap-nanjing

Nanjing Zone 3 ap-nanjing-3

Southeast Asia Pacific (Singapore) ap-singapore

Singapore Zone 4 ap-singapore-4

Eastern United States (Virginia) na-ashburn

Virginia Zone 1 na-ashburn-1

Virginia Zone 2 na-ashburn-2

South America (São Paulo) sa-saopaulo

São Paulo Zone 1 sa-saopaulo-1

Europe (Frankfurt) eu-frankfurt

Frankfurt Zone 1 eu-frankfurt-1 Previous Topic: High Availability (Multi-AZ) Next Topic: Service Regions and Service Providers Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Regions AZ List of Regions and AZs China Countries and Regions Outside China Corresponding regions support disk types How to Choose Regions and Azs Regions and AZs Supported by Read-Only Analysis Engine Search AllCurrent Product Search titles only Enter keywords to search documentation
