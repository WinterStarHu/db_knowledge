# PostgreSQL: Documentation: 18: 35.39. role_usage_grants

PostgreSQL: Documentation: 18: 35.39. role_usage_grants Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.39. role_usage_grants
Prev Up Chapter 35. The Information Schema Home Next
35.39. role_usage_grants #
The view role_usage_grants identifies USAGE privileges granted on various kinds of objects where the grantor or grantee is a currently enabled role. Further information can be found under usage_privileges. The only effective difference between this view and usage_privileges is that this view omits objects that have been made accessible to the current user by way of a grant to PUBLIC.
Table 35.37. role_usage_grants Columns Column Type Description grantor sql_identifier The name of the role that granted the privilege grantee sql_identifier The name of the role that the privilege was granted to object_catalog sql_identifier Name of the database containing the object (always the current database) object_schema sql_identifier Name of the schema containing the object, if applicable, else an empty string object_name sql_identifier Name of the object object_type character_data COLLATION or DOMAIN or FOREIGN DATA WRAPPER or FOREIGN SERVER or SEQUENCE privilege_type character_data Always USAGE is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.38. role_udt_grants
Home
35.40. routine_column_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
