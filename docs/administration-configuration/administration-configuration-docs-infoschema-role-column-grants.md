# PostgreSQL: Documentation: 18: 35.35. role_column_grants

PostgreSQL: Documentation: 18: 35.35. role_column_grants Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.35. role_column_grants
Prev Up Chapter 35. The Information Schema Home Next
35.35. role_column_grants #
The view role_column_grants identifies all privileges granted on columns where the grantor or grantee is a currently enabled role. Further information can be found under column_privileges. The only effective difference between this view and column_privileges is that this view omits columns that have been made accessible to the current user by way of a grant to PUBLIC.
Table 35.33. role_column_grants Columns Column Type Description grantor sql_identifier Name of the role that granted the privilege grantee sql_identifier Name of the role that the privilege was granted to table_catalog sql_identifier Name of the database that contains the table that contains the column (always the current database) table_schema sql_identifier Name of the schema that contains the table that contains the column table_name sql_identifier Name of the table that contains the column column_name sql_identifier Name of the column privilege_type character_data Type of the privilege: SELECT, INSERT, UPDATE, or REFERENCES is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.34. referential_constraints
Home
35.36. role_routine_grants
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
