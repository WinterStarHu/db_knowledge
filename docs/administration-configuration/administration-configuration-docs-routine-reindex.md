# PostgreSQL: Documentation: 18: 24.2. Routine Reindexing

PostgreSQL: Documentation: 18: 24.2. Routine Reindexing Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
24.2. Routine Reindexing
Prev Up Chapter 24. Routine Database Maintenance Tasks Home Next
24.2. Routine Reindexing #
In some situations it is worthwhile to rebuild indexes periodically with the REINDEX command or a series of individual rebuilding steps.
B-tree index pages that have become completely empty are reclaimed for re-use. However, there is still a possibility of inefficient use of space: if all but a few index keys on a page have been deleted, the page remains allocated. Therefore, a usage pattern in which most, but not all, keys in each range are eventually deleted will see poor use of space. For such usage patterns, periodic reindexing is recommended.
The potential for bloat in non-B-tree indexes has not been well researched. It is a good idea to periodically monitor the index's physical size when using any non-B-tree index type.
Also, for B-tree indexes, a freshly-constructed index is slightly faster to access than one that has been updated many times because logically adjacent pages are usually also physically adjacent in a newly built index. (This consideration does not apply to non-B-tree indexes.) It might be worthwhile to reindex periodically just to improve access speed.
REINDEX can be used safely and easily in all cases. This command requires an ACCESS EXCLUSIVE lock by default, hence it is often preferable to execute it with its CONCURRENTLY option, which requires only a SHARE UPDATE EXCLUSIVE lock.
Prev Up Next
24.1. Routine Vacuuming
Home
24.3. Log File Maintenance
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
