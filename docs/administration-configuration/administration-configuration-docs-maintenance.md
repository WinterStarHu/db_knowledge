# PostgreSQL: Documentation: 18: Chapter 24. Routine Database Maintenance Tasks

PostgreSQL: Documentation: 18: Chapter 24. Routine Database Maintenance Tasks Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 24. Routine Database Maintenance Tasks Prev Up Part III. Server Administration Home Next Chapter 24. Routine Database Maintenance Tasks Table of Contents
24.1. Routine Vacuuming
24.1.1. Vacuuming Basics
24.1.2. Recovering Disk Space
24.1.3. Updating Planner Statistics
24.1.4. Updating the Visibility Map
24.1.5. Preventing Transaction ID Wraparound Failures
24.1.6. The Autovacuum Daemon
24.2. Routine Reindexing
24.3. Log File Maintenance
PostgreSQL, like any database software, requires that certain tasks be performed regularly to achieve optimum performance. The tasks discussed here are required, but they are repetitive in nature and can easily be automated using standard tools such as cron scripts or Windows' Task Scheduler. It is the database administrator's responsibility to set up appropriate scripts, and to check that they execute successfully.
One obvious maintenance task is the creation of backup copies of the data on a regular schedule. Without a recent backup, you have no chance of recovery after a catastrophe (disk failure, fire, mistakenly dropping a critical table, etc.). The backup and recovery mechanisms available in PostgreSQL are discussed at length in Chapter 25.
The other main category of maintenance task is periodic “vacuuming” of the database. This activity is discussed in Section 24.1. Closely related to this is updating the statistics that will be used by the query planner, as discussed in Section 24.1.3.
Another task that might need periodic attention is log file management. This is discussed in Section 24.3.
check_postgres is available for monitoring database health and reporting unusual conditions. check_postgres integrates with Nagios and MRTG, but can be run standalone too.
PostgreSQL is low-maintenance compared to some other database management systems. Nonetheless, appropriate attention to these tasks will go far towards ensuring a pleasant and productive experience with the system.
Prev Up Next
23.3. Character Set Support
Home
24.1. Routine Vacuuming
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
