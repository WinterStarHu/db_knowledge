# PostgreSQL: Documentation: 18: ALTER TEXT SEARCH PARSER

PostgreSQL: Documentation: 18: ALTER TEXT SEARCH PARSER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER TEXT SEARCH PARSER Prev Up SQL Commands Home Next ALTER TEXT SEARCH PARSER ALTER TEXT SEARCH PARSER — change the definition of a text search parser Synopsis ALTER TEXT SEARCH PARSER name RENAME TO new_name ALTER TEXT SEARCH PARSER name SET SCHEMA new_schema Description ALTER TEXT SEARCH PARSER changes the definition of a text search parser. Currently, the only supported functionality is to change the parser's name.
You must be a superuser to use ALTER TEXT SEARCH PARSER.
Parameters name The name (optionally schema-qualified) of an existing text search parser.
new_name The new name of the text search parser.
new_schema The new schema for the text search parser.
Compatibility There is no ALTER TEXT SEARCH PARSER statement in the SQL standard.
See AlsoCREATE TEXT SEARCH PARSER, DROP TEXT SEARCH PARSER Prev Up Next ALTER TEXT SEARCH DICTIONARY Home ALTER TEXT SEARCH TEMPLATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
