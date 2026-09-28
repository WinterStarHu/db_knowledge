# PostgreSQL: Documentation: 18: 35.52. table_constraints

PostgreSQL: Documentation: 18: 35.52. table_constraints Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.52. table_constraints
Prev Up Chapter 35. The Information Schema Home Next
35.52. table_constraints #
The view table_constraints contains all constraints belonging to tables that the current user owns or has some privilege other than SELECT on.
Table 35.50. table_constraints Columns Column Type Description constraint_catalog sql_identifier Name of the database that contains the constraint (always the current database) constraint_schema sql_identifier Name of the schema that contains the constraint constraint_name sql_identifier Name of the constraint table_catalog sql_identifier Name of the database that contains the table (always the current database) table_schema sql_identifier Name of the schema that contains the table table_name sql_identifier Name of the table constraint_type character_data Type of the constraint: CHECK (includes not-null constraints), FOREIGN KEY, PRIMARY KEY, or UNIQUE is_deferrable yes_or_no YES if the constraint is deferrable, NO if not initially_deferred yes_or_no YES if the constraint is deferrable and initially deferred, NO if not enforced yes_or_no YES if the constraint is enforced, NO if not nulls_distinct yes_or_no If the constraint is a unique constraint, then YES if the constraint treats nulls as distinct or NO if it treats nulls as not distinct, otherwise null for other types of constraints.
Prev Up Next
35.51. sql_sizing
Home
35.53. table_privileges
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
