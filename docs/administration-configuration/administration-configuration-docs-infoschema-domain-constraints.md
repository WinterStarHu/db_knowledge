# PostgreSQL: Documentation: 18: 35.21. domain_constraints

PostgreSQL: Documentation: 18: 35.21. domain_constraints Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.21. domain_constraints
Prev Up Chapter 35. The Information Schema Home Next
35.21. domain_constraints #
The view domain_constraints contains all constraints belonging to domains defined in the current database. Only those domains are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.19. domain_constraints Columns Column Type Description constraint_catalog sql_identifier Name of the database that contains the constraint (always the current database) constraint_schema sql_identifier Name of the schema that contains the constraint constraint_name sql_identifier Name of the constraint domain_catalog sql_identifier Name of the database that contains the domain (always the current database) domain_schema sql_identifier Name of the schema that contains the domain domain_name sql_identifier Name of the domain is_deferrable yes_or_no YES if the constraint is deferrable, NO if not initially_deferred yes_or_no YES if the constraint is deferrable and initially deferred, NO if not Prev Up Next
35.20. data_type_privileges
Home
35.22. domain_udt_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
