# PostgreSQL: Documentation: 18: 53.14. pg_matviews

PostgreSQL: Documentation: 18: 53.14. pg_matviews Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.14. pg_matviews
Prev Up Chapter 53. System Views Home Next
53.14. pg_matviews #
The view pg_matviews provides access to useful information about each materialized view in the database.
Table 53.14. pg_matviews Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing materialized view matviewname name (references pg_class.relname) Name of materialized view matviewowner name (references pg_authid.rolname) Name of materialized view's owner tablespace name (references pg_tablespace.spcname) Name of tablespace containing materialized view (null if default for database) hasindexes bool True if materialized view has (or recently had) any indexes ispopulated bool True if materialized view is currently populated definition text Materialized view definition (a reconstructed SELECT query) Prev Up Next
53.13. pg_locks
Home
53.15. pg_policies
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
