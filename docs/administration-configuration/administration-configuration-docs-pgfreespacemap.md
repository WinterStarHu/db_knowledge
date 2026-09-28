# PostgreSQL: Documentation: 18: F.27. pg_freespacemap — examine the free space map

PostgreSQL: Documentation: 18: F.27. pg_freespacemap — examine the free space map Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.27. pg_freespacemap — examine the free space map Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.27. pg_freespacemap — examine the free space map # F.27.1. Functions F.27.2. Sample Output F.27.3. Author The pg_freespacemap module provides a means for examining the free space map (FSM). It provides a function called pg_freespace, or two overloaded functions, to be precise. The functions show the value recorded in the free space map for a given page, or for all pages in the relation.
By default use is restricted to superusers and roles with privileges of the pg_stat_scan_tables role. Access may be granted to others using GRANT.
F.27.1. Functions # pg_freespace(rel regclass IN, blkno bigint IN) returns int2 Returns the amount of free space on the page of the relation, specified by blkno, according to the FSM.
pg_freespace(rel regclass IN, blkno OUT bigint, avail OUT int2) Displays the amount of free space on each page of the relation, according to the FSM. A set of (blkno bigint, avail int2) tuples is returned, one tuple for each page in the relation.
The values stored in the free space map are not exact. They're rounded to precision of 1/256th of BLCKSZ (32 bytes with default BLCKSZ), and they're not kept fully up-to-date as tuples are inserted and updated.
For indexes, what is tracked is entirely-unused pages, rather than free space within pages. Therefore, the values are not meaningful, just whether a page is in-use or empty.
F.27.2. Sample Output # postgres=# SELECT * FROM pg_freespace('foo');
blkno | avail
-------+-------
0 |     0 1 |     0 2 |     0 3 |    32 4 |   704 5 |   704 6 |   704 7 |  1216 8 |   704 9 |   704 10 |   704 11 |   704 12 |   704 13 |   704 14 |   704 15 |   704 16 |   704 17 |   704 18 |   704 19 |  3648 (20 rows) postgres=# SELECT * FROM pg_freespace('foo', 7);
pg_freespace
--------------
1216 (1 row) F.27.3. Author # Original version by Mark Kirkwood . Rewritten in version 8.4 to suit new FSM implementation by Heikki Linnakangas Prev Up Next F.26. pgcrypto — cryptographic functions Home F.28. pg_logicalinspect — logical decoding components inspection Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
