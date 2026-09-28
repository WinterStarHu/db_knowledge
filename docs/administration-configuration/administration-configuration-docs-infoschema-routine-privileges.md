# PostgreSQL: Documentation: 18: 35.41. routine_privileges

PostgreSQL: Documentation: 18: 35.41. routine_privileges Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.41. routine_privileges
Prev Up Chapter 35. The Information Schema Home Next
35.41. routine_privileges #
The view routine_privileges identifies all privileges granted on functions to a currently enabled role or by a currently enabled role. There is one row for each combination of function, grantor, and grantee.
Table 35.39. routine_privileges Columns Column Type Description grantor sql_identifier Name of the role that granted the privilege grantee sql_identifier Name of the role that the privilege was granted to specific_catalog sql_identifier Name of the database containing the function (always the current database) specific_schema sql_identifier Name of the schema containing the function specific_name sql_identifier The “specific name” of the function. See Section 35.45 for more information.
routine_catalog sql_identifier Name of the database containing the function (always the current database) routine_schema sql_identifier Name of the schema containing the function routine_name sql_identifier Name of the function (might be duplicated in case of overloading) privilege_type character_data Always EXECUTE (the only privilege type for functions) is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.40. routine_column_usage
Home
35.42. routine_routine_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
