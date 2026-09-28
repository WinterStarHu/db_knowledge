# PostgreSQL: Documentation: 18: 35.65. view_table_usage

PostgreSQL: Documentation: 18: 35.65. view_table_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.65. view_table_usage
Prev Up Chapter 35. The Information Schema Home Next
35.65. view_table_usage #
The view view_table_usage identifies all tables that are used in the query expression of a view (the SELECT statement that defines the view). A table is only included if that table is owned by a currently enabled role.
Note System tables are not included. This should be fixed sometime.
Table 35.63. view_table_usage Columns Column Type Description view_catalog sql_identifier Name of the database that contains the view (always the current database) view_schema sql_identifier Name of the schema that contains the view view_name sql_identifier Name of the view table_catalog sql_identifier Name of the database that contains the table that is used by the view (always the current database) table_schema sql_identifier Name of the schema that contains the table that is used by the view table_name sql_identifier Name of the table that is used by the view Prev Up Next
35.64. view_routine_usage
Home
35.66. views
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
