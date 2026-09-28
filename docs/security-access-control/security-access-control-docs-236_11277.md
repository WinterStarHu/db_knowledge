# Ops

> 来源: https://www.tencentcloud.com/document/product/236/11277

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL FAQs Ops Ops Download Focus Mode Font Size Last updated: 2026-02-05 10:16:20 AI-Translated What should I do when a problem with pt-online-schema-change occurs in TencentDB for MySQL?
TencentDB for MySQL v5.6 and higher supports Online DDL. To protect your business from being affected by table locking, you are recommended to change the table structure in v5.5 by using open-source tools such as pt-online-schema-change. However, you may encounter problems when using pt-online-schema-change to change the TencentDB for MySQL table structure through CVM.
Common error message:
Use of uninitialized value $host in string eq at /usr/local/percona-toolkit-3.0.3/bin/pt-online-schema-change line 4284.
View the corresponding source code:
sub _find_slaves_by_processlist { my ( $self, $dsn_parser, $dbh, $dsn ) = @_;
﻿

my @slaves = map  { my $slave        = $dsn_parser->parse("h=$_", $dsn);
$slave->{source} = 'processlist';
$slave;
} grep { $_ } map  { my ( $host ) = $_->{host} =~ m/^([^:]+):/;
if ( $host eq 'localhost' ) { $host = '127.0.0.1'; # Replication never uses sockets.
} $host;
} $self->get_connected_slaves($dbh);
﻿

return @slaves;
} As the code suggests, processlist cannot get the standby node information it is looking for, because TencentDB has processed the information related to account replication.
Solution:
Add the following parameter so that pt-osc can be used without checking the status of the standby node.
--recursion-method=none What should I do if "Specified key was too long" is displayed during data import to TencentDB?
Cause:
TencentDB for MySQL returns the error message "Specified key was too long" when you import XXXX.sql file to the TencentDB for MySQL instance on the CVM command line.
The error message "ERROR 1071 (42000): The error information that Specified key was too long and max key length is 767 bytes" indicates that the index field exceeds 767 bytes and is too long.
For the InnoDB storage engine, the maximum length of multi-column index is as follows:
The maximum length of a single index column is 767 bytes and the total length of all columns should not be greater than 3,072 bytes.
For the MyISAM storage engine, the maximum length of multi-column index is as follows:
The maximum length of a single index column is 1000 bytes and the total length of all columns should not be greater than 1000 bytes.
Note:
In fields such as 768/2=384 double-bytes or 767/3=255 three-bytes, GBK is double-byte, UTF8 is three-byte, and UTF8MB4 is four-byte.
In MySQL v5.6 and higher, all MyISAM tables are automatically converted to InnoDB table. Therefore, with the MyISAM storage engine, a self-built database may contain combined index column of more than 767 bytes in length; however, due to the use of the MyISAM storage engine, the same table creation statement that can run in the self-built database won't work in MySQL v5.6 or higher.
Solution:
1.
Modify the length of index columns in the erroneous rows in the backup file.
Common  erroneous row:
create table test(test varchar(255) primary key)charset=utf8;
-- Success create table test(test varchar(256) primary key)charset=utf8;
-- Failure ERROR 1071（42000）:Specified key was too long; max key length is 767 bytes
2.
You can use TencentDB v5.5 where MyISAM won't be automatically converted into InnoDB.
What should I do if an error occurs with "select * from XX into outfile xxxx"?
For the sake of platform security, file permission is unavailable, and data cannot be exported through "select into outfile". You are recommended to export the data in another way.
What should I do if emojis inserted into a TencentDB for MySQL become garbled?
Check whether the TencentDB for MySQL instance, client, and connection to the instance all use or support the utf8mb4 character set.
To store an emoji in an instance, you need to follow the steps below.
1.
Set the character set of the instance to utf8mb4. You can log in to the TencentDB for MySQL console and modify the character_set_server parameter.
Note:
Modifying this parameter will restart the database; therefore, you are recommended to back up your data in advance to prevent any loss.
2.
The client of your application should use the utf8mb4 character set for the outputted string.
3.
When creating a connection to your application, you should specify the executed character set. Take the common JDBC connection for example:
MySQL Connector/J v5.1.13 or higher should be used. Below is the sample code:
String query = “set names utf8mb4”;
stat.execute(query);
﻿

Previous Topic: Freeing Up Table Space in a MySQL Instance Using OPTIMIZE TABLE Next Topic: Data Migration Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page What should I do when a problem with pt-online-schema-change occurs in TencentDB for MySQL?
What should I do if "Specified key was too long" is displayed during data import to TencentDB?
What should I do if an error occurs with "select * from XX into outfile xxxx"?
What should I do if emojis inserted into a TencentDB for MySQL become garbled?
Search AllCurrent Product Search titles only Enter keywords to search documentation
