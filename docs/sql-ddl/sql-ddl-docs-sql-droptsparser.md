# PostgreSQL: Documentation: 18: DROP TEXT SEARCH PARSER

PostgreSQL: Documentation: 18: DROP TEXT SEARCH PARSER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP TEXT SEARCH PARSER Prev Up SQL Commands Home Next DROP TEXT SEARCH PARSER DROP TEXT SEARCH PARSER — remove a text search parser Synopsis DROP TEXT SEARCH PARSER [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP TEXT SEARCH PARSER drops an existing text search parser. You must be a superuser to use this command.
Parameters IF EXISTS Do not throw an error if the text search parser does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing text search parser.
CASCADE Automatically drop objects that depend on the text search parser, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the text search parser if any objects depend on it. This is the default.
Examples Remove the text search parser my_parser:
DROP TEXT SEARCH PARSER my_parser;
This command will not succeed if there are any existing text search configurations that use the parser. Add CASCADE to drop such configurations along with the parser.
Compatibility There is no DROP TEXT SEARCH PARSER statement in the SQL standard.
See AlsoALTER TEXT SEARCH PARSER, CREATE TEXT SEARCH PARSER Prev Up Next DROP TEXT SEARCH DICTIONARY Home DROP TEXT SEARCH TEMPLATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
