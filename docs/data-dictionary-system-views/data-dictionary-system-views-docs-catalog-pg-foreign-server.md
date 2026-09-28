# PostgreSQL: Documentation: 18: 52.24. pg_foreign_server

PostgreSQL: Documentation: 18: 52.24. pg_foreign_server Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.24. pg_foreign_server
Prev Up Chapter 52. System Catalogs Home Next
52.24. pg_foreign_server #
The catalog pg_foreign_server stores foreign server definitions. A foreign server describes a source of external data, such as a remote server. Foreign servers are accessed via foreign-data wrappers.
Table 52.24. pg_foreign_server Columns Column Type Description oid oid Row identifier srvname name Name of the foreign server srvowner oid (references pg_authid.oid) Owner of the foreign server srvfdw oid (references pg_foreign_data_wrapper.oid) OID of the foreign-data wrapper of this foreign server srvtype text Type of the server (optional) srvversion text Version of the server (optional) srvacl aclitem[] Access privileges; see Section 5.8 for details srvoptions text[] Foreign server specific options, as “keyword=value” strings Prev Up Next
52.23. pg_foreign_data_wrapper
Home
52.25. pg_foreign_table
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
