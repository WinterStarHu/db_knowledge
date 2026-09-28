# PostgreSQL: Documentation: 18: 35.8. check_constraint_routine_usage

PostgreSQL: Documentation: 18: 35.8. check_constraint_routine_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.8. check_constraint_routine_usage
Prev Up Chapter 35. The Information Schema Home Next
35.8. check_constraint_routine_usage #
The view check_constraint_routine_usage identifies routines (functions and procedures) that are used by a check constraint. Only those routines are shown that are owned by a currently enabled role.
Table 35.6. check_constraint_routine_usage Columns Column Type Description constraint_catalog sql_identifier Name of the database containing the constraint (always the current database) constraint_schema sql_identifier Name of the schema containing the constraint constraint_name sql_identifier Name of the constraint specific_catalog sql_identifier Name of the database containing the function (always the current database) specific_schema sql_identifier Name of the schema containing the function specific_name sql_identifier The “specific name” of the function. See Section 35.45 for more information.
Prev Up Next
35.7. character_sets
Home
35.9. check_constraints
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
