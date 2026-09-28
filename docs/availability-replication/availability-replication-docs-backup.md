# PostgreSQL: Documentation: 18: Chapter 25. Backup and Restore

PostgreSQL: Documentation: 18: Chapter 25. Backup and Restore Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
Chapter 25. Backup and Restore Prev Up Part III. Server Administration Home Next Chapter 25. Backup and Restore Table of Contents
25.1. SQL Dump
25.1.1. Restoring the Dump
25.1.2. Using pg_dumpall
25.1.3. Handling Large Databases
25.2. File System Level Backup
25.3. Continuous Archiving and Point-in-Time Recovery (PITR)
25.3.1. Setting Up WAL Archiving
25.3.2. Making a Base Backup
25.3.3. Making an Incremental Backup
25.3.4. Making a Base Backup Using the Low Level API
25.3.5. Recovering Using a Continuous Archive Backup
25.3.6. Timelines
25.3.7. Tips and Examples
25.3.8. Caveats
As with everything that contains valuable data, PostgreSQL databases should be backed up regularly. While the procedure is essentially simple, it is important to have a clear understanding of the underlying techniques and assumptions.
There are three fundamentally different approaches to backing up PostgreSQL data:
SQL dump File system level backup Continuous archiving Each has its own strengths and weaknesses; each is discussed in turn in the following sections.
Prev Up Next
24.3. Log File Maintenance
Home
25.1. SQL Dump
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
