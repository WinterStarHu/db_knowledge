# PostgreSQL: Documentation: 18: ALTER TEXT SEARCH TEMPLATE

PostgreSQL: Documentation: 18: ALTER TEXT SEARCH TEMPLATE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER TEXT SEARCH TEMPLATE Prev Up SQL Commands Home Next ALTER TEXT SEARCH TEMPLATE ALTER TEXT SEARCH TEMPLATE — change the definition of a text search template Synopsis ALTER TEXT SEARCH TEMPLATE name RENAME TO new_name ALTER TEXT SEARCH TEMPLATE name SET SCHEMA new_schema Description ALTER TEXT SEARCH TEMPLATE changes the definition of a text search template. Currently, the only supported functionality is to change the template's name.
You must be a superuser to use ALTER TEXT SEARCH TEMPLATE.
Parameters name The name (optionally schema-qualified) of an existing text search template.
new_name The new name of the text search template.
new_schema The new schema for the text search template.
Compatibility There is no ALTER TEXT SEARCH TEMPLATE statement in the SQL standard.
See AlsoCREATE TEXT SEARCH TEMPLATE, DROP TEXT SEARCH TEMPLATE Prev Up Next ALTER TEXT SEARCH PARSER Home ALTER TRIGGER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
