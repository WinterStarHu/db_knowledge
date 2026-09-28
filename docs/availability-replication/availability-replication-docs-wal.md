# PostgreSQL: Documentation: 18: Chapter 28. Reliability and the Write-Ahead Log

PostgreSQL: Documentation: 18: Chapter 28. Reliability and the Write-Ahead Log Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 28. Reliability and the Write-Ahead Log Prev Up Part III. Server Administration Home Next Chapter 28. Reliability and the Write-Ahead Log Table of Contents
28.1. Reliability
28.2. Data Checksums
28.2.1. Off-line Enabling of Checksums
28.3. Write-Ahead Logging (WAL)
28.4. Asynchronous Commit
28.5. WAL Configuration
28.6. WAL Internals
This chapter explains how to control the reliability of PostgreSQL, including details about the Write-Ahead Log.
Prev Up Next
27.6. Monitoring Disk Usage
Home
28.1. Reliability
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
