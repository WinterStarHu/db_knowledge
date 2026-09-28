# PostgreSQL: Documentation: 18: 35.16. column_udt_usage

PostgreSQL: Documentation: 18: 35.16. column_udt_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.16. column_udt_usage
Prev Up Chapter 35. The Information Schema Home Next
35.16. column_udt_usage #
The view column_udt_usage identifies all columns that use data types owned by a currently enabled role. Note that in PostgreSQL, built-in data types behave like user-defined types, so they are included here as well. See also Section 35.17 for details.
Table 35.14. column_udt_usage Columns Column Type Description udt_catalog sql_identifier Name of the database that the column data type (the underlying type of the domain, if applicable) is defined in (always the current database) udt_schema sql_identifier Name of the schema that the column data type (the underlying type of the domain, if applicable) is defined in udt_name sql_identifier Name of the column data type (the underlying type of the domain, if applicable) table_catalog sql_identifier Name of the database containing the table (always the current database) table_schema sql_identifier Name of the schema containing the table table_name sql_identifier Name of the table column_name sql_identifier Name of the column Prev Up Next
35.15. column_privileges
Home
35.17. columns
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
