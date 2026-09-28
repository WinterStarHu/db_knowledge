# PostgreSQL: Documentation: 18: 52.25. pg_foreign_table

PostgreSQL: Documentation: 18: 52.25. pg_foreign_table Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.25. pg_foreign_table
Prev Up Chapter 52. System Catalogs Home Next
52.25. pg_foreign_table #
The catalog pg_foreign_table contains auxiliary information about foreign tables. A foreign table is primarily represented by a pg_class entry, just like a regular table. Its pg_foreign_table entry contains the information that is pertinent only to foreign tables and not any other kind of relation.
Table 52.25. pg_foreign_table Columns Column Type Description ftrelid oid (references pg_class.oid) The OID of the pg_class entry for this foreign table ftserver oid (references pg_foreign_server.oid) OID of the foreign server for this foreign table ftoptions text[] Foreign table options, as “keyword=value” strings Prev Up Next
52.24. pg_foreign_server
Home
52.26. pg_index
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
