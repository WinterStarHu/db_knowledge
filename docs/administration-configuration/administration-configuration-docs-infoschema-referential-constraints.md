# PostgreSQL: Documentation: 18: 35.34. referential_constraints

PostgreSQL: Documentation: 18: 35.34. referential_constraints Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.34. referential_constraints
Prev Up Chapter 35. The Information Schema Home Next
35.34. referential_constraints #
The view referential_constraints contains all referential (foreign key) constraints in the current database. Only those constraints are shown for which the current user has write access to the referencing table (by way of being the owner or having some privilege other than SELECT).
Table 35.32. referential_constraints Columns Column Type Description constraint_catalog sql_identifier Name of the database containing the constraint (always the current database) constraint_schema sql_identifier Name of the schema containing the constraint constraint_name sql_identifier Name of the constraint unique_constraint_catalog sql_identifier Name of the database that contains the unique or primary key constraint that the foreign key constraint references (always the current database) unique_constraint_schema sql_identifier Name of the schema that contains the unique or primary key constraint that the foreign key constraint references unique_constraint_name sql_identifier Name of the unique or primary key constraint that the foreign key constraint references match_option character_data Match option of the foreign key constraint: FULL, PARTIAL, or NONE.
update_rule character_data Update rule of the foreign key constraint: CASCADE, SET NULL, SET DEFAULT, RESTRICT, or NO ACTION.
delete_rule character_data Delete rule of the foreign key constraint: CASCADE, SET NULL, SET DEFAULT, RESTRICT, or NO ACTION.
Prev Up Next
35.33. parameters
Home
35.35. role_column_grants
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
