# PostgreSQL: Documentation: 18: 52.3. pg_am

PostgreSQL: Documentation: 18: 52.3. pg_am Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.3. pg_am
Prev Up Chapter 52. System Catalogs Home Next
52.3. pg_am #
The catalog pg_am stores information about relation access methods. There is one row for each access method supported by the system. Currently, only tables and indexes have access methods. The requirements for table and index access methods are discussed in detail in Chapter 62 and Chapter 63 respectively.
Table 52.3. pg_am Columns Column Type Description oid oid Row identifier amname name Name of the access method amhandler regproc (references pg_proc.oid) OID of a handler function that is responsible for supplying information about the access method amtype char t = table (including materialized views), i = index.
Note Before PostgreSQL 9.6, pg_am contained many additional columns representing properties of index access methods. That data is now only directly visible at the C code level. However, pg_index_column_has_property() and related functions have been added to allow SQL queries to inspect index access method properties; see Table 9.76.
Prev Up Next
52.2. pg_aggregate
Home
52.4. pg_amop
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
