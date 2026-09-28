# Building Drupal Website

> 来源: https://www.tencentcloud.com/document/product/236/10961

TencentDB for MySQL Release Notes and Announcements Release Notes Product Announcements User Tutorial Product Introduction Overview Strengths Use Cases Database Architecture Resource Isolation Policy Economical Instance Feature List Database Instance High Availability (Multi-AZ) Regions and AZs Service Regions and Service Providers Kernel Features Overview Kernel Version Release Notes Functionality Features Performance Features Security Features Stability Features TXRocks Engine LibraDB Engine Checking and Fixing Kernel Issues Billing Billing Overview Selection Guide Purchase Methods Renewal Payment Overdue Refund Instructions Pay-as-You-Go to Monthly Subscription Instance Adjustment Fee Billing for Storage Space Overusage Backup Space Billing Database Audit Billing Overview Commercial Billing and Activity Description for Database Proxy Description of the Database Proxy Billing Cycle Viewing Bills Getting Started Overview Creating MySQL Instance Connecting to MySQL Instance SQL Insight (Database Audit) SQL Insight (Database Audit) Introduction Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Configuring Post-Event Alarms Modifying Audit Rule Modifying Audit Services Disabling Audit Service Audit Rule Template SQL Audit Rule (Legacy) Viewing Audit Task Authorizing Sub-User to Use Database Audit MySQL Cluster Edition Introduction to TencentDB for MySQL Cluster Edition Creating TencentDB for MySQL Cluster Edition Instance Maintenance Management Instance Viewing Instance Monitoring Adjusting Instance Configuration Operations for Other Features Migrate or upgrade to TencentDB for MySQL Cluster Edition User Guide Use Limits Operation Overview Instance Management and Maintenance Instance Upgrade CPU Elastic Expansion Read-Only/Disaster Recovery Instances Database Proxy Database Management Center (DMC) Account Management Parameter Configuration Backup and Rollback Data Migration Network and Security Monitoring and Alarms Log Center Read-Only Analysis Engine Tag Practical Tutorial Practice of Executing FLUSH TABLE on RO Without Writing to binlog Using TencentDB for MySQL to Upgrade MySQL 5.7 to MySQL 8.0 How to Configure Alarms for Storage Overuse Lock Events Methods and Instructions for Upgrading from MySQL 5.6 to MySQL 5.7 Cybersecurity Classified Protection Practice for Database Audit of TencentDB for MySQL Building All-Scenario High-Availability Architecture Usage Specifications of TencentDB for MySQL Configuring Automatic Application Reconnection Impact of Modifying MySQL Source Instance Parameters Limits on Automatic Conversion from MyISAM to InnoDB Creating VPCs for TencentDB for MySQL Enhancing Business Load Capacity with TencentDB for MySQL Setting up 2-Region-3-DC Disaster Recovery Architecture Improving TencentDB for MySQL Performance with Read/Write Separation Migrating Data from InnoDB to RocksDB with DTS Building LAMP Stack for Web Application Building Drupal Website Calling MySQL APIs in Python The primary and secondary instances have inconsistent query data White Paper Performance White Paper Security White Paper Troubleshooting Connections Performance Backup and Restoration Instance Data Sync Delay Failure to Enable Case Insensitivity Failure to Obtain slow_query_log_file via a Command Handling Primary Key-Related Error Hiding ​​API Reference History Introduction API Category Making API Requests Instance APIs Data Import APIs Database Proxy APIs Database Audit APIs Security APIs Task APIs Data Security Encryption APIs Account APIs Backup APIs Rollback APIs Parameter APIs Database APIs Log-related API Monitoring APIs Data Types Error Codes FAQs Selection Related Billing Backup Rollback Connection and Login Parameter Modifications Instance Upgrade Account Permissions Performance Space Memory Ops Data Migration Features Console Operations Logs Event Database audit Instance Switch Impact Agreements Service Level Agreement Terms of Service Reference Standards and Certifications Contact Us Glossary Documentation TencentDB for MySQL Practical Tutorial Building Drupal Website Building Drupal Website Download Focus Mode Font Size Last updated: 2024-07-23 13:02:01 Drupal is an open-source content management framework written in PHP, which consists of a content management system and a PHP development framework. It can be used to build rich-featured dynamic websites ranging from personal blogs to large communities.
This tutorial describes how to build a Drupal ecommerce website on a CVM instance.
Software environments used here include CentOS 7.2, Drupal 7.56, and PHP 5.4.16.
Logging in to the CVM instance For more information on how to purchase and access a CVM instance, see Customizing Linux CVM Configurations.
Installing the MariaDB service
1.
MariaDB is supported by CentOS 7 and later by default, so it is used here. Install the MariaDB service in the CVM instance with yum.
yum install mariadb-server mariadb -y
2.
Start the MariaDB service.
systemctl start mariadb
3.
Create a database for Drupal (the database used in this project is named drupal).
mysqladmin -u root -p create drupal Here, drupal is the name of the database used by the Drupal service.
4.
Create a user for the database.
mysql -u root -p Authorize the user and exit the database after successful authorization.
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON drupal.* TO 'username'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
exit Here, username and password are the database username and password used by the Drupal service, respectively.
Installing the Apache service
1.
Install Apache in the CVM instance with yum.
yum install httpd -y
2.
Launch the Apache service.
service httpd start
3.
Test Apache.
Note:
In this step, you should configure an inbound rule with the source being all and the port protocol being TCP:80 in the security group of your CVM instance. For more information on how to configure the security group, see Security Group.
Enter http://115.xxx.xxx.xxx/ in your local browser (where 115.xxx.xxx.xxx is the public IP of your CVM instance). If the following page appears, Apache has started successfully.

﻿ Installing PHP
1.
Install PHP and its extensions in the CVM instance with yum.
yum install php php-dom php-gd php-mysql php-pdo -y
2.
Create an info.php file in the /var/www/html directory of the CVM instance to check whether PHP is successfully installed. Below is the sample code:
<?php phpinfo(); ?>
3.
Restart the Apache service.
service httpd restart
4.
Enter http://115.xxx.xxx.xxx/info.php in your local browser (where 115.xxx.xxx.xxx is the public IP of your CVM instance). If the following page appears, PHP has been installed successfully.

﻿ Installing the Drupal service
1.
Download the Drupal installation package.
wget http://ftp.drupal.org/files/projects/drupal-7.56.zip
2.
Decompress it to the root directory of the website.
unzip drupal-7.56.zip mv drupal-7.56/* /var/www/html/
3.
Download the Chinese translation package.
cd /var/www/html/ wget -P profiles/standard/translations http://ftp.drupal.org/files/translations/7.x/drupal/drupal-7.56.zh-hans.po
4.
Modify the owner and group to which the sites directory belongs.
chown -R apache:apache /var/www/html/sites
5.
Restart the Apache service.
service httpd restart
6.
Enter http://115.xxx.xxx.xxx/ in your local browser (where 115.xxx.xxx.xxx is the public IP of your CVM instance) to go to the installation page of Drupal, select the version to be installed, and click Save and continue.

﻿
7.
Select the language for installation and click Save and continue.
8.
Set up the database and enter the database information you configured when installing the MariaDB service.
9.
Enter the site information.
10.
Complete the Drupal installation.
11.
Then, you can visit http://115.xxx.xxx.xxx/ (where 115.xxx.xxx.xxx is the IP address of your CVM instance) to customize the website.
Previous Topic: Building LAMP Stack for Web Application Next Topic: Instance Purchase Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Logging in to the CVM instance Installing the MariaDB service Installing the Apache service Installing PHP Installing the Drupal service Search AllCurrent Product Search titles only Enter keywords to search documentation
