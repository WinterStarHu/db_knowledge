# PostgreSQL: Documentation: 18: 53.12. pg_indexes

PostgreSQL: Documentation: 18: 53.12. pg_indexes Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.12. pg_indexes
Prev Up Chapter 53. System Views Home Next
53.12. pg_indexes #
The view pg_indexes provides access to useful information about each index in the database.
Table 53.12. pg_indexes Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing table and index tablename name (references pg_class.relname) Name of table the index is for indexname name (references pg_class.relname) Name of index tablespace name (references pg_tablespace.spcname) Name of tablespace containing index (null if default for database) indexdef text Index definition (a reconstructed CREATE INDEX command) Prev Up Next
53.11. pg_ident_file_mappings
Home
53.13. pg_locks
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
