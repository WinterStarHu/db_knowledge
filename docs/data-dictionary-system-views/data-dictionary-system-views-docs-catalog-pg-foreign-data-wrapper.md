# PostgreSQL: Documentation: 18: 52.23. pg_foreign_data_wrapper

PostgreSQL: Documentation: 18: 52.23. pg_foreign_data_wrapper Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.23. pg_foreign_data_wrapper
Prev Up Chapter 52. System Catalogs Home Next
52.23. pg_foreign_data_wrapper #
The catalog pg_foreign_data_wrapper stores foreign-data wrapper definitions. A foreign-data wrapper is the mechanism by which external data, residing on foreign servers, is accessed.
Table 52.23. pg_foreign_data_wrapper Columns Column Type Description oid oid Row identifier fdwname name Name of the foreign-data wrapper fdwowner oid (references pg_authid.oid) Owner of the foreign-data wrapper fdwhandler oid (references pg_proc.oid) References a handler function that is responsible for supplying execution routines for the foreign-data wrapper. Zero if no handler is provided fdwvalidator oid (references pg_proc.oid) References a validator function that is responsible for checking the validity of the options given to the foreign-data wrapper, as well as options for foreign servers and user mappings using the foreign-data wrapper. Zero if no validator is provided fdwacl aclitem[] Access privileges; see Section 5.8 for details fdwoptions text[] Foreign-data wrapper specific options, as “keyword=value” strings Prev Up Next
52.22. pg_extension
Home
52.24. pg_foreign_server
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
