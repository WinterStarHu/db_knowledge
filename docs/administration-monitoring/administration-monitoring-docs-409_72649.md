# How to Use SCF for Scheduled Database Operations

> 来源: https://www.tencentcloud.com/document/product/409/72649

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases How to Use SCF for Scheduled Database Operations How to Use SCF for Scheduled Database Operations Download Focus Mode Font Size Last updated: 2025-08-14 17:00:44 AI-Translated This document introduces how to use SCF for scheduled database tasks.
Prerequisites A TencentDB for PostgreSQL instance has been created.
Operation Steps Creating and Configuring an Event Function Enter the SCF console and create an Event-Triggered function. For specific steps, please refer to Creating Event Function in Console.
Note:
Function name, region, namespace, and runtime environment cannot be modified after creation. Please ensure they are filled in correctly. The example usage in this document uses Node.js as the runtime environment.
The trigger is the core for implementing scheduled operations. SCF provides preset options to execute every 1 minute, every 5 minutes, every half hour, every 1 hour, or every 1 day. You can also select a custom trigger period and use a cron expression for scheduling. For details, please refer to cron expression usage.
Creation complete. On the console, click the function ID to enter the Function management > Function configuration page, then click Edit.
﻿ In network configuration, enable the Virtual Private Cloud (VPC), select the same VPC as the database instance requiring operation, and specify a subnet.
Note:
Note: SCF must be consistent with the database instance in the same VPC. Otherwise, connection failure may occur.
﻿ Editing SCF Function Code Method One: Online Editing Code Enter the Function management > Function code page and select the submission method as online editing.
﻿ Installing Dependency Packages To connect to TencentDB for PostgreSQL, you need to install the pg dependency package first. In the editor, click View > Terminal to open the terminal.
﻿ Enter the following commands sequentially in the terminal to install dependencies.
cd src npm install pg Running Environment

Operating System: Ubuntu 24.04.2 LTS / x86_64

Runtime Version: GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)

Editing Code Start editing the function in index.js under the src folder. The following example inserts a piece of data (user_id) into the target instance, with the execution method name as index.main_handler.
const { Client } = require('pg');
﻿

exports.main_handler = async (event, context) => { // Read database connection information from environment variables const dbConfig = { host: process.env.DB_HOST, port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432, database: process.env.DB_NAME, user: process.env.DB_USER, password: process.env.DB_PASSWORD, };
﻿

// Simple validation if (!dbConfig.host || !dbConfig.database || !dbConfig.user || !dbConfig.password) { return { error: 'Database connection information is incomplete, check environment variables' };
} ﻿

const client = new Client(dbConfig);
﻿

try { await client.connect();
﻿

// Generate a numeric string user_id, such as current timestamp string const userId = Date.now().toString();
﻿

// Insert data SQL const sql = `INSERT INTO student_info_b0 (user_id) VALUES ($1);`;
﻿

const res = await client.query(sql, [userId]);
﻿

await client.end();
﻿

return { message: 'data inserted successfully', insertedUserId: userId, rowCount: res.rowCount, };
} catch (error) { if (client) { await client.end();
} return { error: error.message, };
} };
Configuring Environment Variables Enter the Function management > Function configuration page, then click Edit.
Note:
DB_HOST: The private IP address of the target instance.
DB_NAME: The target database name.
DB_USER: The account name used for the connection.
DB_PASSWORD: The account password used for the connection.
DB_PORT: The port number used for the connection. TencentDB for PostgreSQL uses 5432 by default.
﻿ Modified. Click Save.
Return to the Function management > Function codes page and click Test. If the test is successful, the timing function is successfully created.
Method Two: Upload Code File SCF supports local upload of zip packages, local folder upload, and upload of zip packages via COS.
﻿ After uploading, ensure to install dependencies for the code to run properly.
For Node.js, the system can automatically install dependencies. Refer to online dependency installation.
For other runtime environments, manually install dependencies.
After uploading and installing dependencies, click Test. If the test is successful, the scheduled function is created successfully.
Managing Scheduled Configuration For triggers, you may create and delete them on the trigger management page. Triggers cannot be modified. You can delete the original trigger and reestablish it.
Click Create trigger, enter information, and submit.
﻿ For unnecessary triggers, click Delete in the upper right corner.
Test Database Connection If the SCF execution fails, use this method to check if successfully connected to the instance.
In Function management > Function configuration, click Edit, enable log shipping in the logging configuration, then click Save. For details about log billing, see CLS Billing Overview.
﻿ Paste the following content into index.js under the src folder.
const { Client } = require('pg');
﻿

exports.main_handler = async (event, context) => { console.log('Function execution started');
﻿

const client = new Client({ host: process.env.DB_HOST,       // database address port: Number(process.env.DB_PORT), // database port user: process.env.DB_USER,       // database username password: process.env.DB_PASSWORD, // database password database: process.env.DB_NAME,   // database name });
﻿

try { console.log('Connecting to the database');
await client.connect();
console.log('Database connected successfully');
﻿

console.log('Query execution started');
const res = await client.query('SELECT NOW()');
console.log('Query result:', res.rows[0]);
﻿

await client.end();
console.log('Database connection closed');
﻿

console.log('Function execution completed, preparing to return result');
return { statusCode: 200, body: JSON.stringify({ message: 'query succeeded', time: res.rows[0], }), };
} catch (err) { console.error('Function execution error:', err);
return { statusCode: 500, body: JSON.stringify({ message: 'failure of function execution', error: err.message, }), };
} };
Click Test, view running logs in log query, locate issue based on log information, thereby further addressing it.
﻿ Previous Topic: How to use failover slot for logical replication Next Topic: Fix Table Bloat Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Operation Steps Creating and Configuring an Event Function Editing SCF Function Code Method One: Online Editing Code Method Two: Upload Code File Managing Scheduled Configuration Test Database Connection Search AllCurrent Product Search titles only Enter keywords to search documentation
