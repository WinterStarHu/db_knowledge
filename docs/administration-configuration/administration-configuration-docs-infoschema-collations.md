# PostgreSQL: Documentation: 18: 35.10. collations

PostgreSQL: Documentation: 18: 35.10. collations Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.10. collations
Prev Up Chapter 35. The Information Schema Home Next
35.10. collations #
The view collations contains the collations available in the current database.
Table 35.8. collations Columns Column Type Description collation_catalog sql_identifier Name of the database containing the collation (always the current database) collation_schema sql_identifier Name of the schema containing the collation collation_name sql_identifier Name of the default collation pad_attribute character_data Always NO PAD (The alternative PAD SPACE is not supported by PostgreSQL.) Prev Up Next
35.9. check_constraints
Home
35.11. collation_character_set_​applicability
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
