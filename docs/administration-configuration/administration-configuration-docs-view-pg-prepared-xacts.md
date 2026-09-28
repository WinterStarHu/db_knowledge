# PostgreSQL: Documentation: 18: 53.17. pg_prepared_xacts

PostgreSQL: Documentation: 18: 53.17. pg_prepared_xacts Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.17. pg_prepared_xacts
Prev Up Chapter 53. System Views Home Next
53.17. pg_prepared_xacts #
The view pg_prepared_xacts displays information about transactions that are currently prepared for two-phase commit (see PREPARE TRANSACTION for details).
pg_prepared_xacts contains one row per prepared transaction. An entry is removed when the transaction is committed or rolled back.
Table 53.17. pg_prepared_xacts Columns Column Type Description transaction xid Numeric transaction identifier of the prepared transaction gid text Global transaction identifier that was assigned to the transaction prepared timestamptz Time at which the transaction was prepared for commit owner name (references pg_authid.rolname) Name of the user that executed the transaction database name (references pg_database.datname) Name of the database in which the transaction was executed When the pg_prepared_xacts view is accessed, the internal transaction manager data structures are momentarily locked, and a copy is made for the view to display. This ensures that the view produces a consistent set of results, while not blocking normal operations longer than necessary. Nonetheless there could be some impact on database performance if this view is frequently accessed.
Prev Up Next
53.16. pg_prepared_statements
Home
53.18. pg_publication_tables
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
