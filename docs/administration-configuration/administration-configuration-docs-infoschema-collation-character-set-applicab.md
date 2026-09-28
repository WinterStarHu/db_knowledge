# PostgreSQL: Documentation: 18: 35.11. collation_character_set_​applicability

PostgreSQL: Documentation: 18: 35.11. collation_character_set_​applicability Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.11. collation_character_set_​applicability
Prev Up Chapter 35. The Information Schema Home Next
35.11. collation_character_set_​applicability #
The view collation_character_set_applicability identifies which character set the available collations are applicable to. In PostgreSQL, there is only one character set per database (see explanation in Section 35.7), so this view does not provide much useful information.
Table 35.9. collation_character_set_applicability Columns Column Type Description collation_catalog sql_identifier Name of the database containing the collation (always the current database) collation_schema sql_identifier Name of the schema containing the collation collation_name sql_identifier Name of the default collation character_set_catalog sql_identifier Character sets are currently not implemented as schema objects, so this column is null character_set_schema sql_identifier Character sets are currently not implemented as schema objects, so this column is null character_set_name sql_identifier Name of the character set Prev Up Next
35.10. collations
Home
35.12. column_column_usage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
