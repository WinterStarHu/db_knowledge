# PostgreSQL: Documentation: 18: 35.22. domain_udt_usage

PostgreSQL: Documentation: 18: 35.22. domain_udt_usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.22. domain_udt_usage
Prev Up Chapter 35. The Information Schema Home Next
35.22. domain_udt_usage #
The view domain_udt_usage identifies all domains that are based on data types owned by a currently enabled role. Note that in PostgreSQL, built-in data types behave like user-defined types, so they are included here as well.
Table 35.20. domain_udt_usage Columns Column Type Description udt_catalog sql_identifier Name of the database that the domain data type is defined in (always the current database) udt_schema sql_identifier Name of the schema that the domain data type is defined in udt_name sql_identifier Name of the domain data type domain_catalog sql_identifier Name of the database that contains the domain (always the current database) domain_schema sql_identifier Name of the schema that contains the domain domain_name sql_identifier Name of the domain Prev Up Next
35.21. domain_constraints
Home
35.23. domains
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
