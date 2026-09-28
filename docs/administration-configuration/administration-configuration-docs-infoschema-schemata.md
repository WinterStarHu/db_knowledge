# PostgreSQL: Documentation: 18: 35.46. schemata

PostgreSQL: Documentation: 18: 35.46. schemata Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.46. schemata
Prev Up Chapter 35. The Information Schema Home Next
35.46. schemata #
The view schemata contains all schemas in the current database that the current user has access to (by way of being the owner or having some privilege).
Table 35.44. schemata Columns Column Type Description catalog_name sql_identifier Name of the database that the schema is contained in (always the current database) schema_name sql_identifier Name of the schema schema_owner sql_identifier Name of the owner of the schema default_character_set_catalog sql_identifier Applies to a feature not available in PostgreSQL default_character_set_schema sql_identifier Applies to a feature not available in PostgreSQL default_character_set_name sql_identifier Applies to a feature not available in PostgreSQL sql_path character_data Applies to a feature not available in PostgreSQL Prev Up Next
35.45. routines
Home
35.47. sequences
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
