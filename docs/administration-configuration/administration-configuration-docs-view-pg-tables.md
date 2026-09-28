# PostgreSQL: Documentation: 18: 53.32. pg_tables

PostgreSQL: Documentation: 18: 53.32. pg_tables Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.32. pg_tables
Prev Up Chapter 53. System Views Home Next
53.32. pg_tables #
The view pg_tables provides access to useful information about each table in the database.
Table 53.32. pg_tables Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing table tablename name (references pg_class.relname) Name of table tableowner name (references pg_authid.rolname) Name of table's owner tablespace name (references pg_tablespace.spcname) Name of tablespace containing table (null if default for database) hasindexes bool (references pg_class.relhasindex) True if table has (or recently had) any indexes hasrules bool (references pg_class.relhasrules) True if table has (or once had) rules hastriggers bool (references pg_class.relhastriggers) True if table has (or once had) triggers rowsecurity bool (references pg_class.relrowsecurity) True if row security is enabled on the table Prev Up Next
53.31. pg_stats_ext_exprs
Home
53.33. pg_timezone_abbrevs
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
