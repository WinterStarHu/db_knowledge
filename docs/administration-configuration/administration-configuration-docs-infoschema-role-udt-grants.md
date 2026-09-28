# PostgreSQL: Documentation: 18: 35.38. role_udt_grants

PostgreSQL: Documentation: 18: 35.38. role_udt_grants Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.38. role_udt_grants
Prev Up Chapter 35. The Information Schema Home Next
35.38. role_udt_grants #
The view role_udt_grants is intended to identify USAGE privileges granted on user-defined types where the grantor or grantee is a currently enabled role. Further information can be found under udt_privileges. The only effective difference between this view and udt_privileges is that this view omits objects that have been made accessible to the current user by way of a grant to PUBLIC. Since data types do not have real privileges in PostgreSQL, but only an implicit grant to PUBLIC, this view is empty.
Table 35.36. role_udt_grants Columns Column Type Description grantor sql_identifier The name of the role that granted the privilege grantee sql_identifier The name of the role that the privilege was granted to udt_catalog sql_identifier Name of the database containing the type (always the current database) udt_schema sql_identifier Name of the schema containing the type udt_name sql_identifier Name of the type privilege_type character_data Always TYPE USAGE is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.37. role_table_grants
Home
35.39. role_usage_grants
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
