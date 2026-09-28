# PostgreSQL: Documentation: 18: DROP INDEX

PostgreSQL: Documentation: 18: DROP INDEX Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP INDEX Prev Up SQL Commands Home Next DROP INDEX DROP INDEX — remove an index Synopsis DROP INDEX [ CONCURRENTLY ] [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP INDEX drops an existing index from the database system. To execute this command you must be the owner of the index.
Parameters CONCURRENTLY Drop the index without locking out concurrent selects, inserts, updates, and deletes on the index's table. A normal DROP INDEX acquires an ACCESS EXCLUSIVE lock on the table, blocking other accesses until the index drop can be completed. With this option, the command instead waits until conflicting transactions have completed.
There are several caveats to be aware of when using this option. Only one index name can be specified, and the CASCADE option is not supported. (Thus, an index that supports a UNIQUE or PRIMARY KEY constraint cannot be dropped this way.) Also, regular DROP INDEX commands can be performed within a transaction block, but DROP INDEX CONCURRENTLY cannot. Lastly, indexes on partitioned tables cannot be dropped using this option.
For temporary tables, DROP INDEX is always non-concurrent, as no other session can access them, and non-concurrent index drop is cheaper.
IF EXISTS Do not throw an error if the index does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an index to remove.
CASCADE Automatically drop objects that depend on the index, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the index if any objects depend on it. This is the default.
Examples This command will remove the index title_idx:
DROP INDEX title_idx;
Compatibility DROP INDEX is a PostgreSQL language extension. There are no provisions for indexes in the SQL standard.
See AlsoCREATE INDEX Prev Up Next DROP GROUP Home DROP LANGUAGE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
