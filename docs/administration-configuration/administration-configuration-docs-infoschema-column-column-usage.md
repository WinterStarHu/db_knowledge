# PostgreSQL: Documentation: 18: 35.12. column_column_usage

PostgreSQL: Documentation: 18: 35.12. column_column_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12
35.12. column_column_usage
Prev Up Chapter 35. The Information Schema Home Next
35.12. column_column_usage #
The view column_column_usage identifies all generated columns that depend on another base column in the same table. Only tables owned by a currently enabled role are included.
Table 35.10. column_column_usage Columns Column Type Description table_catalog sql_identifier Name of the database containing the table (always the current database) table_schema sql_identifier Name of the schema containing the table table_name sql_identifier Name of the table column_name sql_identifier Name of the base column that a generated column depends on dependent_column sql_identifier Name of the generated column Prev Up Next
35.11. collation_character_set_​applicability
Home
35.13. column_domain_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
