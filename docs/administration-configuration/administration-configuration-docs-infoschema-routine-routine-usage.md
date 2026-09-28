# PostgreSQL: Documentation: 18: 35.42. routine_routine_usage

PostgreSQL: Documentation: 18: 35.42. routine_routine_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel
35.42. routine_routine_usage
Prev Up Chapter 35. The Information Schema Home Next
35.42. routine_routine_usage #
The view routine_routine_usage identifies all functions or procedures that are used by another (or the same) function or procedure, either in the SQL body or in parameter default expressions. (This only works for unquoted SQL bodies, not quoted bodies or functions in other languages.) An entry is included here only if the used function is owned by a currently enabled role. (There is no such restriction on the using function.) Note that the entries for both functions in the view refer to the “specific” name of the routine, even though the column names are used in a way that is inconsistent with other information schema views about routines. This is per SQL standard, although it is arguably a misdesign. See Section 35.45 for more information about specific names.
Table 35.40. routine_routine_usage Columns Column Type Description specific_catalog sql_identifier Name of the database containing the using function (always the current database) specific_schema sql_identifier Name of the schema containing the using function specific_name sql_identifier The “specific name” of the using function.
routine_catalog sql_identifier Name of the database that contains the function that is used by the first function (always the current database) routine_schema sql_identifier Name of the schema that contains the function that is used by the first function routine_name sql_identifier The “specific name” of the function that is used by the first function.
Prev Up Next
35.41. routine_privileges
Home
35.43. routine_sequence_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
