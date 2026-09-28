# Request Structure

> 来源: https://www.tencentcloud.com/document/product/238/32087

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Request Structure Common Params Signature v3 Signature Responses Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server API Documentation Making API Requests Request Structure Request Structure Download Focus Mode Font Size Last updated: 2026-06-30 11:29:19

1. Service Address

The API supports access from either a nearby region (at sqlserver.intl.tencentcloudapi.com) or a specified region (at sqlserver.ap-guangzhou.tencentcloudapi.com for Guangzhou, for example).

We recommend using the domain name to access the nearest server. When you call an API, the request is automatically resolved to a server in the region nearest to the location where the API is initiated. For example, when you initiate an API request in Guangzhou, this domain name is automatically resolved to a Guangzhou server, the result is the same as that of specifying the region in the domain like "sqlserver.ap-guangzhou.tencentcloudapi.com".

Note: For latency-sensitive businesses, we recommend that you specify the region in the domain name.

Tencent Cloud currently supports the following regions:

Hosted region	Domain name Local access region (recommended, only for non-financial availability zones)	sqlserver.intl.tencentcloudapi.com South China (Guangzhou)	sqlserver.ap-guangzhou.tencentcloudapi.com East China (Shanghai)	sqlserver.ap-shanghai.tencentcloudapi.com East China (Nanjing)	sqlserver.ap-nanjing.tencentcloudapi.com North China (Beijing)	sqlserver.ap-beijing.tencentcloudapi.com Southwest China (Chengdu)	sqlserver.ap-chengdu.tencentcloudapi.com Southwest China (Chongqing)	sqlserver.ap-chongqing.tencentcloudapi.com Hong Kong, Macao, Taiwan (Hong Kong, China)	sqlserver.ap-hongkong.tencentcloudapi.com Southeast Asia (Singapore)	sqlserver.ap-singapore.tencentcloudapi.com Southeast Asia (Jakarta)	sqlserver.ap-jakarta.tencentcloudapi.com Southeast Asia (Bangkok)	sqlserver.ap-bangkok.tencentcloudapi.com Northeast Asia (Seoul)	sqlserver.ap-seoul.tencentcloudapi.com Northeast Asia (Tokyo)	sqlserver.ap-tokyo.tencentcloudapi.com U.S. East Coast (Virginia)	sqlserver.na-ashburn.tencentcloudapi.com U.S. West Coast (Silicon Valley)	sqlserver.na-siliconvalley.tencentcloudapi.com South America (São Paulo)	sqlserver.sa-saopaulo.tencentcloudapi.com Europe (Frankfurt)	sqlserver.eu-frankfurt.tencentcloudapi.com

Note: As financial availability zones and non-financial availability zones are isolated, when accessing the services in a financial availability zone (with the common parameter Region specifying a financial availability zone), it is necessary to specify a domain name of the financial availability zone, preferably in the same region as specified in Region.

Access region for financial availability zone	Domain name for financial availability zone East China (Shanghai Finance)	sqlserver.ap-shanghai-fsi.tencentcloudapi.com South China (Shenzhen Finance)	sqlserver.ap-shenzhen-fsi.tencentcloudapi.com

2. Communications Protocol

All the Tencent Cloud APIs communicate via HTTPS, providing highly secure communication tunnels.

3. Request Methods

Supported HTTP request methods:

POST (recommended) GET

The Content-Type types supported by POST requests:

application/json (recommended). The TC3-HMAC-SHA256 signature algorithm must be used.
application/x-www-form-urlencoded. The HmacSHA1 or HmacSHA256 signature algorithm must be used.
multipart/form-data (only supported by certain APIs). You must use TC3-HMAC-SHA256 to calculate the signature.

The size of a GET request packet is up to 32 KB. The size of a POST request is up to 1 MB when the HmacSHA1 or HmacSHA256 signature algorithm is used, and up to 10 MB when TC3-HMAC-SHA256 is used.

4. Character Encoding

Only UTF-8 encoding is used.

Previous Topic: API Category Next Topic: Common Params Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page
1. Service Address
2. Communications Protocol
3. Request Methods
4. Character Encoding
Search AllCurrent Product Search titles only Enter keywords to search documentation
