# PostgreSQL: Documentation: 18: 35.14. column_options

PostgreSQL: Documentation: 18: 35.14. column_options Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.14. column_options
Prev Up Chapter 35. The Information Schema Home Next
35.14. column_options #
The view column_options contains all the options defined for foreign table columns in the current database. Only those foreign table columns are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.12. column_options Columns Column Type Description table_catalog sql_identifier Name of the database that contains the foreign table (always the current database) table_schema sql_identifier Name of the schema that contains the foreign table table_name sql_identifier Name of the foreign table column_name sql_identifier Name of the column option_name sql_identifier Name of an option option_value character_data Value of the option Prev Up Next
35.13. column_domain_usage
Home
35.15. column_privileges
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
