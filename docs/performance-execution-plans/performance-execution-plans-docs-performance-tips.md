# PostgreSQL: Documentation: 18: Chapter 14. Performance Tips

PostgreSQL: Documentation: 18: Chapter 14. Performance Tips Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 14. Performance Tips Prev Up Part II. The SQL Language Home Next Chapter 14. Performance Tips Table of Contents
14.1. Using EXPLAIN
14.1.1. EXPLAIN Basics
14.1.2. EXPLAIN ANALYZE
14.1.3. Caveats
14.2. Statistics Used by the Planner
14.2.1. Single-Column Statistics
14.2.2. Extended Statistics
14.3. Controlling the Planner with Explicit JOIN Clauses
14.4. Populating a Database
14.4.1. Disable Autocommit
14.4.2. Use COPY
14.4.3. Remove Indexes
14.4.4. Remove Foreign Key Constraints
14.4.5. Increase maintenance_work_mem
14.4.6. Increase max_wal_size
14.4.7. Disable WAL Archival and Streaming Replication
14.4.8. Run ANALYZE Afterwards
14.4.9. Some Notes about pg_dump
14.5. Non-Durable Settings
Query performance can be affected by many things. Some of these can be controlled by the user, while others are fundamental to the underlying design of the system. This chapter provides some hints about understanding and tuning PostgreSQL performance.
Prev Up Next
13.7. Locking and Indexes
Home
14.1. Using EXPLAIN
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
