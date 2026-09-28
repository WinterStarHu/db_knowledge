# PostgreSQL: Documentation: 18: 35.9. check_constraints

PostgreSQL: Documentation: 18: 35.9. check_constraints Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.9. check_constraints
Prev Up Chapter 35. The Information Schema Home Next
35.9. check_constraints #
The view check_constraints contains all check constraints, either defined on a table or on a domain, that are owned by a currently enabled role. (The owner of the table or domain is the owner of the constraint.) The SQL standard considers not-null constraints to be check constraints with a CHECK (column_name IS NOT NULL) expression. So not-null constraints are also included here and don't have a separate view.
Table 35.7. check_constraints Columns Column Type Description constraint_catalog sql_identifier Name of the database containing the constraint (always the current database) constraint_schema sql_identifier Name of the schema containing the constraint constraint_name sql_identifier Name of the constraint check_clause character_data The check expression of the check constraint Prev Up Next
35.8. check_constraint_routine_usage
Home
35.10. collations
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
