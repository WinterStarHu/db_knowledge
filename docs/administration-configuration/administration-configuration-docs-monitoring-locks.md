# PostgreSQL: Documentation: 18: 27.3. Viewing Locks

PostgreSQL: Documentation: 18: 27.3. Viewing Locks Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
27.3. Viewing Locks
Prev Up Chapter 27. Monitoring Database Activity Home Next
27.3. Viewing Locks #
Another useful tool for monitoring database activity is the pg_locks system table. It allows the database administrator to view information about the outstanding locks in the lock manager. For example, this capability can be used to:
View all the locks currently outstanding, all the locks on relations in a particular database, all the locks on a particular relation, or all the locks held by a particular PostgreSQL session.
Determine the relation in the current database with the most ungranted locks (which might be a source of contention among database clients).
Determine the effect of lock contention on overall database performance, as well as the extent to which contention varies with overall database traffic.
Details of the pg_locks view appear in Section 53.13. For more information on locking and managing concurrency with PostgreSQL, refer to Chapter 13.
Prev Up Next
27.2. The Cumulative Statistics System
Home
27.4. Progress Reporting
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
