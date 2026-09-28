# COS Bulk Insert Stored Procedure User Manual

> 来源: https://www.tencentcloud.com/document/product/238/80774

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Practical Tutorial COS Bulk Insert Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual Download Focus Mode Font Size Last updated: 2026-06-16 10:03:28 AI-Translated This manual introduces a solution for bulk data import into TencentDB for SQL Server. It uses two core stored procedures to implement a complete workflow for efficiently importing data from Tencent Cloud COS into database tables in batches.
TencentSp_DownloadFromCOS — Downloading Files from COS Feature Overview Download the specified file from Tencent Cloud COS to the local disk of the SQL Server instance (D:\dow_file\\) for subsequent BULK INSERT operations.
Stored Procedure Location USE monitor;
EXEC dbo.TencentSp_DownloadFromCOS ...;
Parameter Description Parameter

Type

Default Value

Required

Description

@BucketName

VARCHAR(200)

NULL

Required (when not in CleanupOnly mode)

COS bucket name (including AppId), for example, mybucket-1258888888.

@FileName

VARCHAR(500)

NULL

Required (when not in CleanupOnly mode)

COS object path, for example, data/test.csv. After downloading, only the file name part is retained.

@Region

VARCHAR(100)

NULL

Required (when not in CleanupOnly mode)

COS region, for example, ap-guangzhou, ap-shanghai.

@OverwriteFile

INT

0

No

Whether to overwrite an existing local file with the same name.
A value of 0 indicates no overwriting (the file is skipped if it already exists).
A value of 1 indicates forced overwriting and re-download.

@ExpectedFileSizeMB

INT

NULL

No

Expected file size (MB). After it is set, it checks whether the remaining space on the D drive is sufficient. When it is NULL, it defaults to requiring at least 500 MB of free space.

@CleanupOnly

BIT

0

No

Only perform cleanup mode.
1 indicates that only expired local files are cleaned up, and no download is performed.

@CleanupDays

INT

1

No

Clean up local files older than the specified number of days.
0 indicates that all files are deleted.
Returned Result Field

Description

DownloadStatus

Download status.
Success: The operation succeeded.
AlreadyExists: The file already exists and was not overwritten.

LocalFilePath

Complete path to which the file is downloaded locally, for example, D:\dow_file\58001\test.csv.
Upon failure, it raises an error via RAISERROR and does not return a result set.
Example Example 1: Basic Download USE monitor;
EXEC dbo.TencentSp_DownloadFromCOS @BucketName = 'mybucket-1258888888', @FileName   = 'data/sales_2024.csv', @Region     = 'ap-guangzhou';
Example 2: Forced Overwrite Download + Disk Space Check EXEC dbo.TencentSp_DownloadFromCOS @BucketName       = 'mybucket-1258888888', @FileName         = 'data/large_file.csv', @Region           = 'ap-guangzhou', @OverwriteFile    = 1, @ExpectedFileSizeMB = 2048;  -- The expected file size is approximately 2 GB. Check the disk space.
Example 3: Cleaning Expired Files Only (No Download) -- Clean up local files older than 7 days EXEC dbo.TencentSp_DownloadFromCOS @CleanupOnly = 1, @CleanupDays = 7;
﻿

-- Clean up all local files EXEC dbo.TencentSp_DownloadFromCOS @CleanupOnly = 1, @CleanupDays = 0;
Security Mechanism Parameter Non-null Check: BucketName / FileName / Region cannot be null.
Length Limits: BucketName must be less than or equal to 100, FileName must be less than or equal to 500, and Region must be less than or equal to 50.
Character Allowlist: BucketName can only contain [a-zA-Z0-9.-]; FileName can only contain [a-zA-Z0-9._/ -]; Region can only contain [a-zA-Z0-9-].
Path Traversal Protection: The FileName must not contain ...
File Extension Check: The FileName must have a file extension.
Fixed Download Directory: Files can only be downloaded to D:\dow_file\\ and cannot be saved to a custom path.
Disk Space Check: Check the available space on drive D before downloading.
Audit Logs Each call is logged to the monitor.dbo.CosDownloadLog table, containing information such as the caller, bucket name, file, status, and error message. Logs older than 180 days are automatically cleaned up.
TencentSp_BulkInsertFromFile — Importing Data via BULK INSERT from a Local File Feature overview Bulk import the local file (typically downloaded by TencentSp_DownloadFromCOS) into the user-specified database table using BULK INSERT.
Stored Procedure Location USE monitor;
EXEC dbo.TencentSp_BulkInsertFromFile ...;
Parameter Description Required Parameters Parameter

Type

Description

@FileName

VARCHAR(500)

Source file name (excluding path), relative to the D:\dow_file\\ directory.

@TargetDB

SYSNAME

Target database name (system databases prohibited: master, model, msdb, tempdb, monitor).

@TargetSchema

SYSNAME

Target Schema name, typically dbo.

@TargetTable

SYSNAME

Target table name (the table must already exist).
Optional Parameters Parameter

Type

Default Value

Description

@FieldTerminator

VARCHAR(10)

,

The field delimiter. Use , for CSV files and \t for TSV files.

@RowTerminator

VARCHAR(10)

\n

The row terminator. Use \n for Linux-format files and \r\n for Windows-format files.

@FirstRow

INT

1

Specifies the row from which to start the import. Setting it to 2 allows skipping the CSV header row.

@LastRow

INT

NULL

Specifies the row at which to end the import. NULL indicates importing all rows.

@Format

VARCHAR(10)

NULL

The file format, such as CSV.

@CodePage

VARCHAR(20)

NULL

The code page, such as 65001 (UTF-8) or ACP (system default).

@DataFileType

VARCHAR(20)

NULL

The data file type: char, native, widechar, or widenative.

@FieldQuote

VARCHAR(5)

NULL

The field quote character, such as " (used with FORMAT='CSV').

@MaxErrors

INT

0

The maximum number of errors allowed. If this number is exceeded, the BULK INSERT operation fails and rolls back.

@BatchSize

INT

NULL

The number of rows to import per batch. NULL indicates importing all rows at once.

@KeepNulls

BIT

0

A value of 1 indicates that empty columns retain NULL (without using the table's default value).

@KeepIdentity

BIT

0

A value of 1 indicates that the IDENTITY column values from the file are retained.

@TabLock

BIT

0

A value of 1 indicates that a table lock is applied during the import (to improve performance for large batch imports).

@CheckConstraints

BIT

0

A value of 1 indicates that constraints are checked during the import.

@FireTriggers

BIT

0

A value of 1 indicates that INSERT triggers are fired during the import.

@FormatFile

VARCHAR(500)

NULL

Format file name (relative to D:\dow_file\\) . When the format file name is specified, FieldTerminator and RowTerminator are ignored.

@OrderHint

VARCHAR(500)

NULL

ORDER hint, such as col1 ASC, col2 DESC. Matching it with the clustered index can improve performance.

@ErrorFile

VARCHAR(500)

NULL

Error row output file name (relative to D:\dow_file\\).
Returned Result Field

Description

RowsImported

Number of rows successfully imported.
Upon failure, it raises an error via RAISERROR and does not return a result set.
Example Example 1: Basic CSV Import (Skipping Header) USE monitor;
EXEC dbo.TencentSp_BulkInsertFromFile @FileName        = 'sales_2024.csv', @TargetDB        = 'mydb', @TargetSchema    = 'dbo', @TargetTable     = 'SalesData', @FieldTerminator = ',', Example 2: High-Performance Import for Large Files EXEC dbo.TencentSp_BulkInsertFromFile @FileName        = 'big_data.csv', @TargetDB        = 'mydb', @TargetSchema    = 'dbo', @TargetTable     = 'BigTable', @FieldTerminator = ',', @FirstRow        = 2, @TabLock         = 1,       -- Table-level lock improves performance @BatchSize       = 50000,   -- 50,000 rows per batch @MaxErrors       = 10;      -- Tolerates up to 10 error rows Example 3: TSV File + Preserving NULL + IDENTITY EXEC dbo.TencentSp_BulkInsertFromFile @FileName        = 'export.tsv', @TargetDB        = 'mydb', @TargetSchema    = 'dbo', @TargetTable     = 'ImportTable', @FieldTerminator = '\t', @RowTerminator   = '\r\n', @FirstRow        = 1, @KeepNulls       = 1, @KeepIdentity    = 1;
Example 4: Using a Format File -- First, upload the formatted file to COS and download it.
EXEC dbo.TencentSp_DownloadFromCOS @BucketName = 'mybucket-1258888888', @FileName   = 'fmt/myformat.fmt', @Region     = 'ap-guangzhou';
﻿

-- Import using the formatted file.
EXEC dbo.TencentSp_BulkInsertFromFile @FileName    = 'data.dat', @TargetDB    = 'mydb', @TargetSchema = 'dbo', @TargetTable = 'MyTable', @FormatFile  = 'myformat.fmt';
Security Mechanism Parameter Non-null Check: FileName / TargetDB / TargetSchema / TargetTable cannot be null.
Length Limits: FileName must be less than or equal to 500, and TargetDB / TargetSchema / TargetTable must be less than or equal to 128.
Character Allowlist: FileName can only contain [a-zA-Z0-9._/ -]; TargetDB / TargetSchema / TargetTable can only contain [a-zA-Z0-9_].
Path Traversal Protection: FileName / FormatFile / ErrorFile must not contain ...
System Database Blocklist: Importing to master, model, msdb, tempdb, and monitor is prohibited.
Fixed Source File Directory: Files can only be read from D:\dow_file\\.
Existence Check: Before execution, check whether the source file and target table exist.
Audit Logs Each call is logged to the monitor.dbo.BulkInsertLog table, containing information such as the caller, file name, target database and table, number of imported rows, status, and error message. Logs older than 180 days are automatically cleaned up.
Complete Workflow Example (Download + Import) USE monitor;
﻿

-- Step 1: Download the CSV file from COS.
EXEC dbo.TencentSp_DownloadFromCOS @BucketName = 'mybucket-1258888888', @FileName   = 'data/sales_2024.csv', @Region     = 'ap-guangzhou';
﻿

-- Step 2: Import the file into the user database table.
EXEC dbo.TencentSp_BulkInsertFromFile @FileName        = 'sales_2024.csv',     -- Note: Only the file name is required, without the path.
@TargetDB        = 'mydb', @TargetSchema    = 'dbo', @TargetTable     = 'SalesData', @FieldTerminator = ',', @FirstRow        = 2;
﻿

-- Step 3 (Optional): Clean up local files.
EXEC dbo.TencentSp_DownloadFromCOS @CleanupOnly = 1, @CleanupDays = 0;
IV. Precautions COS Access Permissions: The COS bucket must have public read enabled or be configured for anonymous access because the download uses wget to make anonymous requests.
Target Table Must Be Pre-created: BULK INSERT does not automatically create tables. You must create the table structure in the target database in advance.
File Encoding: Files downloaded from COS are typically in Linux line-feed format (\n), and @RowTerminator is set to \n by default. For Windows format files, manually set @RowTerminator = '\r\n'.
Disk Space: Before large files are downloaded, it is recommended to set the @ExpectedFileSizeMB parameter to avoid insufficient disk space.
@FileName Parameter Difference: For TencentSp_DownloadFromCOS, @FileName is the complete COS object path (for example, data/test.csv). For TencentSp_BulkInsertFromFile, @FileName is only the file name (for example, test.csv) because the download operation retains only the final file name.
﻿

Previous Topic: tencentdb_ChangeLoginPassword Stored Procedure User Manual Next Topic: TencentDB for SQL Server Methods for Regular Maintenance Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page TencentSp_DownloadFromCOS — Downloading Files from COS Feature Overview Stored Procedure Location Parameter Description Returned Result Example Security Mechanism Audit Logs TencentSp_BulkInsertFromFile — Importing Data via BULK INSERT from a Local File Feature overview Stored Procedure Location Parameter Description Returned Result Example Security Mechanism Audit Logs Complete Workflow Example (Download + Import) IV. Precautions Search AllCurrent Product Search titles only Enter keywords to search documentation
