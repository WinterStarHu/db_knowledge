# PostgreSQL: Documentation: 18: 35.18. constraint_column_usage

PostgreSQL: Documentation: 18: 35.18. constraint_column_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.18. constraint_column_usage
Prev Up Chapter 35. The Information Schema Home Next
35.18. constraint_column_usage #
The view constraint_column_usage identifies all columns in the current database that are used by some constraint. Only those columns are shown that are contained in a table owned by a currently enabled role. For a check constraint, this view identifies the columns that are used in the check expression. For a not-null constraint, this view identifies the column that the constraint is defined on. For a foreign key constraint, this view identifies the columns that the foreign key references. For a unique or primary key constraint, this view identifies the constrained columns.
Table 35.16. constraint_column_usage Columns Column Type Description table_catalog sql_identifier Name of the database that contains the table that contains the column that is used by some constraint (always the current database) table_schema sql_identifier Name of the schema that contains the table that contains the column that is used by some constraint table_name sql_identifier Name of the table that contains the column that is used by some constraint column_name sql_identifier Name of the column that is used by some constraint constraint_catalog sql_identifier Name of the database that contains the constraint (always the current database) constraint_schema sql_identifier Name of the schema that contains the constraint constraint_name sql_identifier Name of the constraint Prev Up Next
35.17. columns
Home
35.19. constraint_table_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
