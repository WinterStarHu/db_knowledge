# PostgreSQL: Documentation: 18: 35.44. routine_table_usage

PostgreSQL: Documentation: 18: 35.44. routine_table_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel
35.44. routine_table_usage
Prev Up Chapter 35. The Information Schema Home Next
35.44. routine_table_usage #
The view routine_table_usage is meant to identify all tables that are used by a function or procedure. This information is currently not tracked by PostgreSQL.
Table 35.42. routine_table_usage Columns Column Type Description specific_catalog sql_identifier Name of the database containing the function (always the current database) specific_schema sql_identifier Name of the schema containing the function specific_name sql_identifier The “specific name” of the function. See Section 35.45 for more information.
routine_catalog sql_identifier Name of the database containing the function (always the current database) routine_schema sql_identifier Name of the schema containing the function routine_name sql_identifier Name of the function (might be duplicated in case of overloading) table_catalog sql_identifier Name of the database that contains the table that is used by the function (always the current database) table_schema sql_identifier Name of the schema that contains the table that is used by the function table_name sql_identifier Name of the table that is used by the function Prev Up Next
35.43. routine_sequence_usage
Home
35.45. routines
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
