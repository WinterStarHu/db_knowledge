# PostgreSQL: Documentation: 18: 35.32. key_column_usage

PostgreSQL: Documentation: 18: 35.32. key_column_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.32. key_column_usage
Prev Up Chapter 35. The Information Schema Home Next
35.32. key_column_usage #
The view key_column_usage identifies all columns in the current database that are restricted by some unique, primary key, or foreign key constraint. Check constraints are not included in this view. Only those columns are shown that the current user has access to, by way of being the owner or having some privilege.
Table 35.30. key_column_usage Columns Column Type Description constraint_catalog sql_identifier Name of the database that contains the constraint (always the current database) constraint_schema sql_identifier Name of the schema that contains the constraint constraint_name sql_identifier Name of the constraint table_catalog sql_identifier Name of the database that contains the table that contains the column that is restricted by this constraint (always the current database) table_schema sql_identifier Name of the schema that contains the table that contains the column that is restricted by this constraint table_name sql_identifier Name of the table that contains the column that is restricted by this constraint column_name sql_identifier Name of the column that is restricted by this constraint ordinal_position cardinal_number Ordinal position of the column within the constraint key (count starts at 1) position_in_unique_constraint cardinal_number For a foreign-key constraint, ordinal position of the referenced column within its unique constraint (count starts at 1); otherwise null Prev Up Next
35.31. foreign_tables
Home
35.33. parameters
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
