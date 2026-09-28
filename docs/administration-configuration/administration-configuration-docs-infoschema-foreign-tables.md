# PostgreSQL: Documentation: 18: 35.31. foreign_tables

PostgreSQL: Documentation: 18: 35.31. foreign_tables Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.31. foreign_tables
Prev Up Chapter 35. The Information Schema Home Next
35.31. foreign_tables #
The view foreign_tables contains all foreign tables defined in the current database. Only those foreign tables are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.29. foreign_tables Columns Column Type Description foreign_table_catalog sql_identifier Name of the database that the foreign table is defined in (always the current database) foreign_table_schema sql_identifier Name of the schema that contains the foreign table foreign_table_name sql_identifier Name of the foreign table foreign_server_catalog sql_identifier Name of the database that the foreign server is defined in (always the current database) foreign_server_name sql_identifier Name of the foreign server Prev Up Next
35.30. foreign_table_options
Home
35.32. key_column_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
